#pragma once
#include "app/config/Config.hpp"
#include "core/model/LocalModelService.hpp"
#include "core/messages/Messages.hpp"

namespace batbox::gadgets::live_roster { class Roster; }

namespace batbox::application {
std::function<Json(const Json&)> makeAttachmentNormalizer(
  const std::shared_ptr<messages::Services>& messages,
  std::shared_ptr<batbox::gadgets::live_roster::Roster> roster={});
std::shared_ptr<application::model::LocalModelService> makeLocalModel(
  event_loop::Loop& owner,const Config& config,
  const std::shared_ptr<messages::Services>& messages,
  std::function<void(const std::string&)> diagnostic,
  std::shared_ptr<batbox::gadgets::live_roster::Roster> roster={});
}
