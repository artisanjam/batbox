#pragma once
#include "app/bootstrap/CoreFlags.hpp"
#include "app/bootstrap/FlightCron.hpp"
#include "app/bootstrap/Identity.hpp"

namespace batbox::bootstrap {
struct BootstrapState {
  IdentityState identity;
  CoreFlags flags;
  FlightCronState cron;
};
}
