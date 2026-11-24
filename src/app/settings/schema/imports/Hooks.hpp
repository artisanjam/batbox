#pragma once
#include "app/settings/schema/Main.hpp"

namespace batbox::settings::schema::imports {
SchemaResult hooks(const Json& input,
  const UrlCanonicalizer& canonicalUrl);
}
