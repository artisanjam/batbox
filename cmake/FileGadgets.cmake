if(WIN32)
  set(BATBOX_RIPGREP_PROCESS_SOURCE src/lib/filesystem/RipgrepProcessWin.cpp)
else()
  set(BATBOX_RIPGREP_PROCESS_SOURCE src/lib/filesystem/RipgrepProcess.cpp)
endif()
# The file gadgets (Read/Edit/Grep/Glob/Notebook implementations), their
# filesystem support, and the read-file staleness stash form one cohesive
# mechanism layer. They were compiled into batbox_core, which put L2 gadget
# code into the foundation target. batbox_core links this target PUBLIC so
# existing consumers keep resolving.
add_library(batbox_file_gadgets
  src/core/file_state_stash/FileStateStash.cpp
  src/core/file_state_stash/Path.cpp
  src/core/file_state_stash/Helpers.cpp
  src/lib/filesystem/FileOps.cpp
  src/lib/filesystem/Paths.cpp
  src/lib/filesystem/Range.cpp
  src/lib/filesystem/RangeFast.cpp
  src/lib/filesystem/RangeStream.cpp
  ${BATBOX_RIPGREP_PROCESS_SOURCE}
  src/lib/filesystem/RipgrepOutcome.cpp
  src/core/gadgets/files/BinaryExtensions.cpp
  src/core/gadgets/files/EditMatch.cpp
  src/core/gadgets/files/EditPatch.cpp
  src/core/gadgets/files/EditUnicode.cpp
  src/core/gadgets/files/FileEditCall.cpp
  src/core/gadgets/files/FileEditResult.cpp
  src/core/gadgets/files/FileEditSearchGadgets.cpp
  src/core/gadgets/files/FileEditValidation.cpp
  src/core/gadgets/files/FileInputParse.cpp
  src/core/gadgets/files/FileInputSchema.cpp
  src/core/gadgets/files/FileOutputSchema.cpp
  src/core/gadgets/files/FilePoetryEntries.cpp
  src/core/gadgets/files/FileReadCall.cpp
  src/core/gadgets/files/FileReadImage.cpp
  src/core/gadgets/files/FileReadInner.cpp
  src/core/gadgets/files/FileReadPDF.cpp
  src/core/gadgets/files/FileReadResult.cpp
  src/core/gadgets/files/FileReadUtils.cpp
  src/core/gadgets/files/FileReadValidation.cpp
  src/core/gadgets/files/FileReadWriteGadgets.cpp
  src/core/gadgets/files/FileGadgetsBase.cpp
  src/core/gadgets/files/FileWriteCall.cpp
  src/core/gadgets/files/FileWriteResult.cpp
  src/core/gadgets/files/FileWriteValidation.cpp
  src/core/gadgets/files/GlobCore.cpp
  src/core/gadgets/files/GlobGadget.cpp
  src/core/gadgets/files/GrepCall.cpp
  src/core/gadgets/files/GrepFiles.cpp
  src/core/gadgets/files/GrepHelpers.cpp
  src/core/gadgets/files/GrepModes.cpp
  src/core/gadgets/files/GrepResult.cpp
  src/core/gadgets/files/GrepValidation.cpp
  src/core/gadgets/files/NotebookRead.cpp
  src/core/gadgets/files/NotebookResult.cpp
)
target_include_directories(batbox_file_gadgets PUBLIC src)
target_link_libraries(batbox_file_gadgets PUBLIC batbox_core
  batbox_glob batbox_text_sdk)
target_compile_options(batbox_file_gadgets PRIVATE -Wall -Wextra -Wpedantic)
# batbox_core keeps its consumers working unchanged by re-exposing this
# mechanism layer (no source back-edge: no core TU references file-gadget
# symbols, so the archive order core -> file_gadgets is acyclic).
target_link_libraries(batbox_core PUBLIC batbox_file_gadgets)
