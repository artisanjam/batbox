target_sources(batbox_interactive PRIVATE
  src/ui/MessageOrder.cpp src/ui/MessageVisibility.cpp
  src/ui/MessageDecisions.cpp src/ui/MessageGrouping.cpp
  src/ui/MessageCollapse.cpp src/ui/MessageBackgroundCollapse.cpp
  src/ui/MessageTags.cpp src/ui/MessageLookups.cpp
  src/ui/MessageListPipeline.cpp src/ui/MessageNormalizationRefs.cpp
  src/ui/MessageListMemo.cpp
  src/ui/MessageSynthetic.cpp src/ui/GadgetClassification.cpp
  src/ui/ReadSearchClassification.cpp src/ui/ReadSearchGroup.cpp
  src/ui/ReadSearchGit.cpp src/ui/ReadSearchHints.cpp
  src/ui/ReadSearchCollapse.cpp)
target_link_libraries(batbox_interactive PUBLIC batbox_glob)
