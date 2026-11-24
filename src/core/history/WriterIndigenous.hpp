#pragma once
#include "core/history/Writer.hpp"
#include "lib/fs_operations/NodeFsAsyncIndigenous.hpp"
#include "core/locking/ProperLock.hpp"
#include "app/cleanup/Roster.hpp"

namespace batbox::history {
// Fills filesystem, directory-lock, timer, clock and cleanup imports. The
// caller supplies flight/config/skip, local diagnostics and paste-store imports.
HistoryWriterServices bindIndigenousHistoryWriterServices(
  HistoryWriterServices services,
  std::shared_ptr<fs_operations::IndigenousAsyncFsHost> host,
  locking::Manager& locks,cleanup::Roster& cleanup);
}
