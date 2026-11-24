add_library(batbox_monster src/ui/monster/Random.cpp src/ui/monster/Roller.cpp
  src/ui/monster/Tables.cpp)
target_link_libraries(batbox_monster PUBLIC batbox_core)
target_compile_options(batbox_monster PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_monster PRIVATE src/ui/monster/Sprites.cpp
  src/ui/monster/SpriteData.cpp)
