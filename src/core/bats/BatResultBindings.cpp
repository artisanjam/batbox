#include "core/bats/BatResultBindings.hpp"
#include "core/messages/Context.hpp"
#include "core/messages/TextContent.hpp"
#include "core/runtime/Platform.hpp"
#include "util/tokens.hpp"

namespace batbox::bats {
BatResultImports indigenousBatResultImports(){
  BatResultImports imports;
  imports.getLastAssistantMessage=messages::getLastAssistantMessage;
  imports.extractTextContent=messages::extractTextContent;
  imports.getTokenCountFromUsage=batbox::getTokenCountFromUsage;
  imports.nowMillis=platform::nowMillis;
  return imports;
}
}
