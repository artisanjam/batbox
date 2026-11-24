target_sources(batbox_interactive PRIVATE
  src/ui/message_list_view/SearchFields.cpp
  src/ui/message_list_view/SearchMessages.cpp
  src/ui/message_list_view/SurfaceState.cpp
  src/ui/message_list_view/SurfacePlan.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/viewport/Measurements.cpp
  src/ui/viewport/Range.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/message_actions/MessageActionsText.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/transcript_navigation/NavigationSearch.cpp
  src/ui/transcript_navigation/NavigationSeek.cpp
  src/ui/transcript_navigation/NavigationSticky.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/message_list_view/Projection.cpp
  src/ui/viewport/Controller.cpp
  src/ui/terminal_ftxui/ElementSearch.cpp)
