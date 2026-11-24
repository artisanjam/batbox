add_library(batbox_attachments
  src/core/attachments/Aggregate.cpp
  src/core/attachments/Messages.cpp
  src/core/attachments/Leaves.cpp)
target_link_libraries(batbox_attachments PUBLIC batbox_attachment_triggers
  batbox_interactive batbox_bootstrap_state batbox_query batbox_event_loop)
target_compile_options(batbox_attachments PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_attachments PRIVATE
  src/core/attachments/files/Mentions.cpp
  src/core/attachments/files/PDFReference.cpp
  src/core/attachments/files/Generate.cpp
  src/core/attachments/files/AtMentions.cpp
  src/core/attachments/files/Ide.cpp
  src/core/attachments/files/IndigenousBinding.cpp
  src/core/attachments/files/IndigenousIdeMemory.cpp)
target_link_libraries(batbox_attachments PUBLIC batbox_core batbox_glob batbox_media)
target_sources(batbox_attachments PRIVATE
  src/core/attachments/context/BatListing.cpp
  src/core/attachments/context/ContextBinding.cpp
  src/core/attachments/context/DeferredGadgets.cpp
  src/core/attachments/context/McpInstructions.cpp)
target_link_libraries(batbox_attachments PUBLIC batbox_bats batbox_settings ICU::i18n)
target_sources(batbox_attachments PRIVATE
  src/core/attachments/local/ChangedFiles.cpp
  src/core/attachments/local/DiagnosticsMissions.cpp
  src/core/attachments/local/LocalBinding.cpp
  src/core/attachments/local/IndigenousBinding.cpp
  src/core/attachments/local/PlanReminders.cpp
  src/core/attachments/local/Snippet.cpp
  src/core/attachments/local/MissionReminders.cpp)
