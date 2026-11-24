# The missions system as one module: src/missions holds the four roles in
# directories that match their namespaces -- roster (background-mission
# state), output and stop (the mission gadgets), store (the mission
# registry and its gadget bindings). It includes shell headers
# (ManagedShell, the output poller); the shell declares the cycle back.
add_library(batbox_missions
  src/core/missions/roster/Roster.cpp
  src/core/missions/output/MissionOutput.cpp
  src/core/missions/output/Formatting.cpp
  src/core/missions/output/Data.cpp
  src/core/missions/stop/MissionStop.cpp
  src/core/missions/stop/Result.cpp
  src/core/missions/store/Store.cpp
  src/core/missions/store/PoetryEntries.cpp
  src/core/missions/store/CreateGet.cpp
  src/core/missions/store/Update.cpp
  src/core/missions/store/List.cpp)
target_link_libraries(batbox_missions PUBLIC batbox_core batbox_event_loop)
target_compile_options(batbox_missions PRIVATE -Wall -Wextra -Wpedantic)

if(BUILD_TESTING)
  add_executable(batbox-mission-management-indigenous
    tests/phase5/mission_management_indigenous.cpp)
  target_link_libraries(batbox-mission-management-indigenous PRIVATE batbox_missions)
  if(MSVC)
    target_compile_options(batbox-mission-management-indigenous PRIVATE /UNDEBUG)
  else()
    target_compile_options(batbox-mission-management-indigenous PRIVATE -UNDEBUG)
  endif()
  add_test(NAME batbox-mission-management-indigenous COMMAND batbox-mission-management-indigenous)
endif()
