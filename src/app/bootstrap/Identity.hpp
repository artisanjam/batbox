#pragma once
#include "core/async_context/State.hpp"
#include <string>

namespace batbox::bootstrap {
struct IdentityState {
  cwd::State directories;
  std::string flightId;
};
}
