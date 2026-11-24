#pragma once
#include "lib/intl/Intl.hpp"
namespace batbox::intl {
std::shared_ptr<Segmenter> indigenousSegmenter(const std::string& granularity);
}
