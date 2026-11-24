# Include after batbox_application_frontend and before IndigenousHost.
add_library(batbox_application_media
  src/app/media/Bindings.cpp
  src/app/media/ClipboardImage.cpp
  src/app/media/AttachmentAggregate.cpp
  src/app/media/AttachmentCollectors.cpp)
target_link_libraries(batbox_application_media PUBLIC batbox_media
  batbox_clipboard batbox_attachments batbox_interactive
  batbox_process batbox_memory_prefetch batbox_skills batbox_bootstrap_state)
target_compile_options(batbox_application_media PRIVATE -Wall -Wextra -Wpedantic)
if(APPLE)
  find_library(BATBOX_APPKIT_FRAMEWORK AppKit REQUIRED)
  target_sources(batbox_application_media PRIVATE
    src/app/media/ClipboardImageMac.mm)
  target_link_libraries(batbox_application_media PRIVATE
    ${BATBOX_APPKIT_FRAMEWORK})
endif()
target_sources(batbox_application_frontend PRIVATE src/app/frontend/Editing.cpp)
target_link_libraries(batbox_application_frontend PUBLIC batbox_application_media)
# batbox_history is linked on batbox_terminal_ftxui directly (UI library pair).
