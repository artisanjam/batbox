#pragma once
#include "services/providers/model/QueryModel.hpp"
#include "core/messages/Messages.hpp"
#include "core/gadgets/web/Web.hpp"

namespace batbox::gadgets::web {
using QueryServicesFactory=std::function<model::QueryServices()>;
// Bind the small-model query used to process fetched web content.
std::function<Json(const Json&,std::stop_token)> bindSmallModel(
  QueryServicesFactory makeQueryServices,messages::Services messageServices,
  std::function<std::string()> getSmallFastModel);
} // namespace batbox::gadgets::web
