#pragma once
#include "core/bats/BatGadgetPreflight.hpp"
#include "core/bats/BatGadgetLaunch.hpp"
#include "core/bats/BatGadgetAsync.hpp"
#include "core/bats/BatGadgetForeground.hpp"

namespace batbox::bats {
struct BatGadgetCallServices {
  BatGadgetPreflightServices preflight;
  BatGadgetLaunchServices launch;
  BatGadgetAsyncServices async;
  BatGadgetForegroundServices foreground;
};

// BatGadget.call orchestration: preflight, launch setup, then the requested
// asynchronous or foreground execution. External services remain explicit.
Json callBatGadget(const Json& input,const BatContext& context,
  const std::function<std::future<Json>(const Json&)>& canUseGadget,
  const Json& assistantMessage,BatGadgetCallServices& services);
} // namespace batbox::bats
