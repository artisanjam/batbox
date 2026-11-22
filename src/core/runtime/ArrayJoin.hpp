#pragma once
#include "core/runtime/JsonValue.hpp"
namespace batbox::value {
std::string arrayJoin(const Json& values,const std::string& separator=",");
}
