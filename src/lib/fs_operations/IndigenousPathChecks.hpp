#pragma once
#include "lib/fs_operations/PathChecks.hpp"

namespace batbox::fs_operations {
FileView indigenousFileView();
PathImports indigenousPathImports(std::function<std::string()> cwd,
  std::function<std::string()> homedir);
}
