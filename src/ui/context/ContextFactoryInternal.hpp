#pragma once

#include "ui/context/ContextFactory.hpp"

namespace batbox::interactive::context {
void bindContextCallbacks(GadgetUseContext& context,
  std::shared_ptr<const ContextBindings> bindings);
} // namespace batbox::interactive::context
