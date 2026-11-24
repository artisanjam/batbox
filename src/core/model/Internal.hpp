#pragma once
#include "core/model/LocalModelService.hpp"
#include "core/normalization/Normalization.hpp"
#include "services/providers/model/ModelConfig.hpp"
#include "lib/http/PoetryStash.hpp"
#include "core/runtime/Platform.hpp"

namespace batbox::application::model {
struct LocalServiceBuilder {
  LocalModelService& host;
  ConfigurationSnapshot runtime;
  batbox::gadgets::Gadgets gadgets;
  batbox::gadgets::PoetryContext poetry;
  Json options;
  messages::Services messages;
  normalization::Dependencies normalization;
  api_errors::Providers errors;
  explicit LocalServiceBuilder(LocalModelService&,batbox::gadgets::Gadgets,Json,
    batbox::gadgets::PoetryContext={});
  Json gadgetMetadata()const;
  messages::Services makeMessages();
  normalization::Dependencies makeNormalization();
  api_errors::Providers makeErrors();
  batbox::model::PreflightServices makePreflight();
  requests::Dependencies makeAssembly();
  requests::BuilderDependencies makeBuilder();
  retry::Dependencies makeRetry();
  streaming::ReducerConfig makeReducer();
  batbox::model::QueryServices makeServices();
  query::OwnerPreflightAwaits makeOwnerPreflight();
};
} // namespace batbox::application::model
