#pragma once

#include "ui/cards/BashResultCard.hpp"
#include "ui/cards/OutputLineCard.hpp"
#include "ui/cards/OutputLineProjection.hpp"
#include "ftxui/dom/elements.hpp"
#include <functional>

namespace batbox::interactive::cards {

struct BashResultProjectionImports {
  int columns = 80;
  bool expandShellOutput = false;
  bool inVirtualList = false;
  OutputLineImports outputLine;
  OutputLinePalette outputPalette;
  ftxui::Color dimColor;
  std::function<std::string()> backgroundShortcutHint;
};

ftxui::Element projectBashResult(const BashResultCard& card,
                                  const BashResultProjectionImports& imports);

} // namespace batbox::interactive::cards
