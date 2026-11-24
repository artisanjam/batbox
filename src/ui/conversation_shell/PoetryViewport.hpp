#pragma once
#include "ui/PresentationState.hpp"
#include "ui/conversation_shell/Shell.hpp"
#include "ui/text_input/MeasuredText.hpp"
#include <ftxui/dom/node.hpp>

namespace batbox::interactive::conversation_shell {
double poetryEditorColumns(const InputState& input,int columns,
  const text_input::MetricsServices& metrics);
ftxui::Element poetryViewport(const InputState& input,int columns,int maxRows,
  const text_input::MetricsServices& metrics,bool cursorVisible,
  const PoetryDecor* decor=nullptr);
}
