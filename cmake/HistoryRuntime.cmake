add_library(batbox_history src/core/history/References.cpp src/core/history/PastedContent.cpp
  src/core/history/Reader.cpp src/core/history/ReaderIndigenous.cpp)
target_link_libraries(batbox_history PUBLIC batbox_core batbox_event_loop batbox_fs_operations)
target_compile_options(batbox_history PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_flights PUBLIC batbox_fs_operations batbox_cleanup)
target_sources(batbox_history PRIVATE src/core/history/ViewBasic.cpp
  src/core/history/ViewsIndigenous.cpp)
target_sources(batbox_history PRIVATE src/core/history/WriterFlush.cpp src/core/history/WriterPrepare.cpp
  src/core/history/WriterPublic.cpp src/core/history/WriterIndigenous.cpp)
target_link_libraries(batbox_history PUBLIC batbox_locking batbox_cleanup OpenSSL::Crypto)
# The paste store (formerly batbox_paste_store, sole consumer batbox_history)
# is part of the history mechanism: pasted-content blobs beside the history
# trail.
target_sources(batbox_history PRIVATE
  src/lib/paste_store/PathsHash.cpp src/lib/paste_store/StoreRetrieve.cpp
  src/lib/paste_store/Cleanup.cpp src/lib/paste_store/Indigenous.cpp)
