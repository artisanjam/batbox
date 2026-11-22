#pragma once
#include "core/runtime/JsonValue.hpp"
namespace batbox::skills {
Json skillGadgetInputSchema();
Json skillGadgetOutputSchema();
Json parseSkillGadgetInput(const Json& input);
}
