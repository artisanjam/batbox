#pragma once
#include "lib/fs_operations/NodeFsAsyncIndigenous.hpp"
#include "lib/fs_operations/NodeFsBytes.hpp"

namespace batbox::fs_operations {
NodeFsBytesImports indigenousNodeFsBytesImports(event_loop::Loop& loop,
  std::shared_ptr<IndigenousAsyncFsHost> host);
}
