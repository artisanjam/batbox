#pragma once
#include "lib/runtime/Loop.hpp"
#include "services/providers/model/StreamingAttempt.hpp"
#include "services/providers/model/Watchdog.hpp"
#include "ui/streaming/Reducer.hpp"
#include <stop_token>

namespace batbox::model { class StreamObservation; }
namespace batbox::query {
// Indigenous stream driver: transport next() remains on the worker, while each
// reducer continuation runs on the owner between generator yields.
void consumeOwnerStream(const event_loop::Loop::Dispatcher& owner,
  std::stop_token cursorClose,model::OpenedStream& opened,
  streaming::Reducer& reducer,
  const std::function<void(const streaming::MessageRef&)>& yield,
  model::StreamWatchdog* watchdog,
  const std::function<void()>& onFirstChunk={},
  model::StreamObservation* observation=nullptr);
} // namespace batbox::query
