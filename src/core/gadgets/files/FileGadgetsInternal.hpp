#pragma once
#include "core/gadgets/files/FileGadgets.hpp"
#include "core/gadgets/files/FileSchemas.hpp"
#include "core/gadgets/files/FilePoetryEntries.hpp"
#include <memory>

namespace batbox::gadgets::files {
Gadget makeFileGadgetBase(const std::string& name,const std::string& searchHint,
                      double maxResultSize,bool strict,FileGadgetBindings bindings);
std::string stringValue(const Json& input,const char* key);
void bindFilePathBackfill(Gadget& gadget,const filesystem::PathServices& paths);
} // namespace batbox::gadgets::files
