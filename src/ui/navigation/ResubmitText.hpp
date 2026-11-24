#pragma once
#include "core/turn/QueryTurn.hpp"

namespace batbox::interactive::navigation {
struct ResubmitText {std::string text,mode;};
std::optional<ResubmitText> textForResubmit(const TurnMessageRef& message);
} // namespace batbox::interactive::navigation
