#pragma once

#include "ui/cards/BashResultProjection.hpp"
#include "ui/cards/ThinkingHighlight.hpp"
#include "ui/cards/UserPoetryLeaf.hpp"
#include "ui/cards/UserTextCard.hpp"
#include "ui/cards/UserTextProjection.hpp"
#include "ftxui/dom/elements.hpp"
#include <functional>
#include <optional>

namespace batbox::interactive::cards {

struct UserTextRenderServices {
  UserTextProtocol protocol;
  UserCardPalette userPalette;
  PoetryPalette poetryPalette;
  BashResultProjectionImports bashResult;
  PoetryEnvironment poetry;
  HighlightOptions highlight;
  std::function<ftxui::Element(UserTextKind, const Json&,
                                const UserTextCard&)> renderOtherCard;
};

// The caller supplies the original user message and one text content block.
// A missing result means the selected card is intentionally hidden.
std::optional<ftxui::Element> projectUserTextBlock(
    const Json& userMessage, const Json& textBlock, bool addMargin, bool verbose,
    int columns, const UserTextRenderServices& services);

} // namespace batbox::interactive::cards
