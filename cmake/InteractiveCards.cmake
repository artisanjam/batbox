target_sources(batbox_interactive PRIVATE
  src/ui/cards/BashResultCard.cpp
  src/ui/cards/BashResultText.cpp
  src/ui/cards/OutputLineCard.cpp
  src/ui/cards/OutputLineText.cpp
  src/ui/cards/OutputLineTruncation.cpp
  src/ui/cards/ThinkingHighlight.cpp
  src/ui/cards/UserPoetryLeaf.cpp
  src/ui/cards/UserTextCard.cpp
  src/ui/cards/UserTextLeaves.cpp)
target_link_libraries(batbox_interactive PUBLIC batbox_text_sdk batbox_intl)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards/BashResultProjection.cpp
  src/ui/cards/OutputLineProjection.cpp
  src/ui/cards/UserBashOutputProjection.cpp
  src/ui/cards/UserPoetryProjection.cpp
  src/ui/cards/UserTextBinding.cpp
  src/ui/cards/UserTextProjection.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/cards_assistant/AssistantTextCard.cpp
  src/ui/cards_assistant/ThinkingCard.cpp
  src/ui/cards_system/SystemAPIErrorCard.cpp
  src/ui/cards_system/SystemAPIErrorTicker.cpp
  src/ui/cards_system/SystemTextRouter.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards_assistant/AssistantProjection.cpp
  src/ui/cards_assistant/AssistantBinding.cpp
  src/ui/cards_system/SystemAPIErrorProjection.cpp
  src/ui/cards_system/SystemTextProjection.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/cards_gadget_result/FallbackErrorCard.cpp
  src/ui/cards_gadget_result/HookProgressCard.cpp
  src/ui/cards_gadget_result/GadgetErrorCard.cpp
  src/ui/cards_gadget_result/GadgetResultRouter.cpp
  src/ui/cards_gadget_children/GadgetSuccessCard.cpp
  src/ui/cards_gadget_children/GadgetRejectCard.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards_gadget_result/HookProgressProjection.cpp
  src/ui/cards_gadget_result/GadgetErrorProjection.cpp
  src/ui/cards_gadget_result/GadgetResultProjection.cpp
  src/ui/cards_gadget_children/GadgetSuccessProjection.cpp
  src/ui/cards_gadget_children/GadgetRejectProjection.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/cards_gadget_use/GadgetUseDecision.cpp
  src/ui/cards_gadget_use/GroupedGadgetUse.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards_gadget_use/GadgetUseProjection.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/cards_collapsed/CollapsedPlan.cpp
  src/ui/cards_collapsed/CollapsedSummary.cpp
  src/ui/cards_collapsed/VerboseGadgetUse.cpp
  src/ui/cards_collapsed/MinHintDisplay.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards_collapsed/CollapsedProjection.cpp
  src/ui/cards_collapsed/VerboseGadgetUseProjection.cpp
  src/ui/cards_collapsed/CollapsedBinding.cpp
  src/ui/cards_gadget_binding/GadgetChildBinding.cpp
  src/ui/message_view/RetainedViews.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/cards_remaining/AttachmentCard.cpp
  src/ui/cards_remaining/AttachmentMissionStatus.cpp
  src/ui/cards_remaining/MessageLeaves.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/cards_remaining/AttachmentProjection.cpp
  src/ui/cards_remaining/MessageLeavesProjection.cpp)
target_sources(batbox_interactive PRIVATE
  src/ui/gadget_views/GadgetViewModel.cpp)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/terminal_ftxui/TextFit.cpp
  src/ui/gadget_views/GadgetViewProjection.cpp)
