#pragma once
#include "lib/runtime/Loop.hpp"
#include "services/providers/model/Watchdog.hpp"

namespace batbox::query {
model::StreamWatchdog::TimerScheduler makeOwnerWatchdogTimer(
  event_loop::Loop& loop);
}
