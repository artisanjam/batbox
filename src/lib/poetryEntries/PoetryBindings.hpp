#pragma once
#include "lib/poetryEntries/Guidance.hpp"
#include "lib/poetryEntries/SystemPoetry.hpp"

namespace batbox::poetryEntries {
// Binds the guidance sections and the built-in static head; callers may
// replace systemHead afterwards.
void bindGuidance(SystemPoetryInputs& poetry,const GuidanceServices& guidance);
}
