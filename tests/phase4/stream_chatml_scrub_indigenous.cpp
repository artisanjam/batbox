/* ChatML marker scrubbing in the streaming reducer: markers written as
 * literal words inside text/thinking must not reach stored content (they
 * re-read as turn boundaries when history is re-rendered), and a marker
 * split across deltas must not reassemble downstream as halves. */
#include "ui/streaming/Reducer.hpp"
#include <cassert>
#include <iostream>
#include <string>

using batbox::Json;
using namespace batbox::streaming;

namespace {
ReducerConfig config() {
  ReducerConfig c;
  c.model = "batbox-model";
  c.resolvedModel = "batbox-model";
  c.randomUUID = [] { return std::string("uuid"); };
  c.timestamp = [] { return std::string("now"); };
  c.calculateUSDCost = [](const std::string&, const Json&) { return 1.0; };
  c.addToTotalFlightCost = [](double, const Json&, const std::string&) { return 1.0; };
  c.getErrorMessageIfRefusal =
      [](const Json&, const std::string&) -> std::optional<Json> { return std::nullopt; };
  c.createAssistantAPIErrorMessage =
      [](const std::string&, const std::string&, const std::string&) {
        return Json{{"type", "assistant"}, {"kind", "api_error"}};
      };
  return c;
}

std::string run(std::vector<Json> events) {
  Reducer reducer(config());
  reducer.consume(Json{{"type", "message_start"},
                       {"message", Json{{"id", "m"}, {"role", "assistant"},
                                        {"content", Json::array()}}}});
  for (const auto& event : events) reducer.consume(event);
  assert(!reducer.messages().empty());
  // messages() yields the stored result envelope: {message: {...}, type, ...}
  const Json& message = (*reducer.messages().back())["message"];
  assert(message.contains("content") && message["content"].is_array() &&
         !message["content"].empty());
  const Json& block = message["content"].front();
  if (block.value("type", "") == "thinking") return block.value("thinking", "");
  return block.value("text", "");
}

Json start(int index, const std::string& type) {
  Json block{{"type", type}};
  block[type == "thinking" ? "thinking" : "text"] = "";
  if (type == "thinking") block["signature"] = "";
  return Json{{"type", "content_block_start"}, {"index", index},
              {"content_block", std::move(block)}};
}
Json delta(int index, const std::string& type, const std::string& field,
           const std::string& text) {
  return Json{{"type", "content_block_delta"}, {"index", index},
              {"delta", {{"type", type}, {field, text}}}};
}
Json stop(int index) {
  return Json{{"type", "content_block_stop"}, {"index", index}};
}

const std::string kStart = "<|im_start|>";
const std::string kEnd = "<|im_end|>";
const std::string kBar = "\xef\xbd\x9c";  // U+FF5C replacement glyph
}  // namespace

int main() {
  // A whole marker inside one delta is replaced, prose survives.
  {
    std::string text = run({start(0, "text"),
                            delta(0, "text_delta", "text", "see " + kStart + " here"),
                            stop(0)});
    assert(text.find("<|") == std::string::npos);
    assert(text.find(kBar) != std::string::npos);
    assert(text.find("see ") != std::string::npos &&
           text.find(" here") != std::string::npos);
  }
  // A marker split across deltas is rejoined, never left as halves.
  {
    std::string thinking = run({start(0, "thinking"),
                                delta(0, "thinking_delta", "thinking", "the <|im_"),
                                delta(0, "thinking_delta", "thinking", "end|> again"),
                                stop(0)});
    assert(thinking.find("<|") == std::string::npos);
    assert(thinking.find("|>") == std::string::npos);
    assert(thinking == "the <" + kBar + "im_end" + kBar + "> again");
  }
  // An unfinished prefix is flushed verbatim -- not a boundary, no text lost.
  {
    std::string text = run({start(0, "text"),
                            delta(0, "text_delta", "text", "note <|im_"),
                            stop(0)});
    assert(text == "note <|im_");
  }
  // Marker-shaped strings that are not markers survive untouched.
  {
    std::string text = run({start(0, "text"),
                            delta(0, "text_delta", "text", "a <|not a marker|> b"),
                            stop(0)});
    assert(text == "a <|not a marker|> b");
  }
  // Two markers, one after the other.
  {
    std::string text = run({start(0, "text"),
                            delta(0, "text_delta", "text", kStart + "x" + kEnd),
                            stop(0)});
    assert(text.find("<|") == std::string::npos);
    std::size_t bars = 0, at = text.find(kBar);
    while (at != std::string::npos) { ++bars; at = text.find(kBar, at + kBar.size()); }
    assert(bars == 4);  // two markers, four replaced pipes
    assert(text.find("x") != std::string::npos);
  }
  // Prefix held but never completed across several deltas flushes whole.
  {
    std::string text = run({start(0, "text"),
                            delta(0, "text_delta", "text", "tail <|im"),
                            delta(0, "text_delta", "text", "por"),
                            stop(0)});
    assert(text == "tail <|impor");
  }
  std::cout << "stream-chatml-scrub: ok\n";
  return 0;
}
