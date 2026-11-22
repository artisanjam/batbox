#pragma once
#include "core/runtime/ArrayJoin.hpp"
#include "core/runtime/JsonValue.hpp"
namespace batbox::termio {
inline std::string osc(const Json& parts,const std::string& terminal){
  const auto terminator=terminal=="kitty"?"\x1b\\":"\x07";
  return std::string("\x1b]")+value::arrayJoin(parts,";")+terminator;
}
}
