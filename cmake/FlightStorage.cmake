add_library(batbox_flights
  src/core/flights/AsyncStash.cpp
  src/core/flights/ProjectDirectories.cpp
  src/core/flights/LoadParsing.cpp src/core/flights/AsyncLoad.cpp src/core/flights/AsyncLoadIndigenous.cpp
  src/core/flights/BatTranscript.cpp
  src/core/flights/Cleaning.cpp src/core/flights/CleaningRefs.cpp src/core/flights/PoetryEntries.cpp
  src/core/flights/Graph.cpp src/core/flights/Relink.cpp src/core/flights/Paths.cpp
  src/core/flights/Load.cpp src/core/flights/WriteQueue.cpp src/core/flights/QueueIO.cpp
  src/core/flights/Metadata.cpp src/core/flights/ProjectMetadata.cpp src/core/flights/Views.cpp
  src/core/flights/MetadataStash.cpp
  src/core/flights/FlightListing.cpp)
target_sources(batbox_flights PRIVATE
  src/core/flights/scanning/BoundaryCore.cpp src/core/flights/scanning/BoundaryReader.cpp
  src/core/flights/scanning/ChainFilter.cpp src/core/flights/scanning/MetadataScan.cpp)
target_sources(batbox_flights PRIVATE src/core/flights/async_queue/Queue.cpp src/core/flights/async_queue/AsyncFileSystem.cpp)
target_sources(batbox_flights PRIVATE src/core/flights/SavedBats.cpp)
target_sources(batbox_flights PRIVATE
  src/core/flights/async_project/AsyncProject.cpp src/core/flights/async_project/MessageChain.cpp
  src/core/flights/async_project/Records.cpp src/core/flights/async_project/IndigenousStat.cpp)
target_link_libraries(batbox_flights PUBLIC batbox_core batbox_event_loop)
target_compile_options(batbox_flights PRIVATE -Wall -Wextra -Wpedantic)
