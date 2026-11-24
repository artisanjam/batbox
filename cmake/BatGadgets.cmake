target_sources(batbox_bats PRIVATE
  src/core/bats/BatResultBindings.cpp
  src/core/bats/BatGadgetCall.cpp src/core/bats/BatGadgetLaunch.cpp
  src/core/bats/BatGadgetPoetry.cpp src/core/bats/BatGadgetAsync.cpp
  src/core/bats/BatGadgetForeground.cpp src/core/bats/BatGadgetForegroundProgress.cpp
  src/core/bats/BatGadgetForegroundFinalize.cpp src/core/bats/BatGadgetBackgroundContinuation.cpp
  src/core/bats/BatGadgetStream.cpp src/core/bats/BatGadgetRace.cpp
  src/core/bats/BatGadgetBinding.cpp src/core/bats/BatGadgetDescriptor.cpp
  src/core/bats/BatGadgetPoetryDescriptor.cpp src/core/bats/BatGadgetSchema.cpp)
target_link_libraries(batbox_bats PUBLIC batbox_event_loop)
