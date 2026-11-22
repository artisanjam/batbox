#pragma once
#include "lib/instructions/hooks/runtime/IndigenousCommandFull.hpp"
#include "lib/instructions/hooks/runtime/IndigenousCommandProcess.hpp"

namespace batbox::instructions::hooks::runtime {
event_loop::Deferred<IndigenousProcessRequest> prepareIndigenousHookCommand(
  event_loop::Loop& loop,const IndigenousCommandConfig& config,
  const FullCommandRequest& request);
} // namespace batbox::instructions::hooks::runtime
