#pragma once
#include "core/event_loop/Loop.hpp"
#include "model/Watchdog.hpp"

namespace batbox::query {
model::StreamWatchdog::TimerScheduler makeOwnerWatchdogTimer(
  event_loop::Loop& loop);
}
