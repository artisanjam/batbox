#pragma once
#include "ui/message_view/RowPlan.hpp"
#include "ui/message_view/Metadata.hpp"
#include "ui/cards/UserTextBinding.hpp"
#include "ui/cards_assistant/AssistantBinding.hpp"
#include "ui/cards_system/SystemTextProjection.hpp"
#include "ui/cards_gadget_result/GadgetResultProjection.hpp"
#include "ui/cards_gadget_use/GadgetUseProjection.hpp"
#include "ui/cards_gadget_use/GroupedGadgetUse.hpp"
#include "ui/cards_remaining/AttachmentProjection.hpp"
#include "ui/cards_remaining/MessageLeavesProjection.hpp"

namespace batbox::interactive::message_view {
struct RemainingServices {
  cards_remaining::AttachmentServices attachments;
  cards_remaining::AttachmentProjectionImports attachmentProjection;
  cards_remaining::ImageServices images;
  cards_remaining::CompactServices compact;
  cards_remaining::AdvisorServices advisor;
  cards_remaining::LeafPalette palette;
  std::function<std::string()> historyShortcut;
};
struct ProjectionServices {
  cards::UserTextRenderServices user;
  cards_assistant::AssistantRenderServices assistant;
  cards_system::SystemProjectionImports system;
  RemainingServices remaining;
  gadgets::Gadgets gadgets;
  Json commands=Json::array();
  std::shared_ptr<const MessageLookups> lookups;
  bool selected=false;
  std::function<cards_gadget_result::GadgetResultProjectionImports(
    const MessagePlan&,const BlockPlan&,const MessageLookups&,const gadgets::Gadgets&)> gadgetResult;
  std::function<std::optional<ftxui::Element>(const MessagePlan&,
    const MessageLookups&,const gadgets::Gadgets&)> collapsed;
  cards_gadget_use::UseServices gadgetUse;
  cards_gadget_use::UseProjectionImports gadgetUseProjection;
  cards_gadget_use::GroupedRenderer groupedGadgetUse;
  std::function<std::optional<ftxui::Element>(const MessagePlan&,const BlockPlan&)>
    otherBlock;
  std::function<std::optional<ftxui::Element>(const MessagePlan&)> otherMessage;
  MetadataImports metadata;
  ftxui::Color metadataColor;
};
std::optional<ftxui::Element> projectMessage(const MessagePlan& plan,
  const ProjectionServices& services);
std::optional<ftxui::Element> projectRow(const RowPlan& plan,
  const ProjectionServices& services);
} // namespace batbox::interactive::message_view
