#pragma once
#include "lib/runtime/Loop.hpp"
#include "lib/shell/BashProvider.hpp"
#include "lib/shell/ManagedShell.hpp"
#include "lib/shell/MissionOutputPoller.hpp"
#include "core/missions/roster/Roster.hpp"
#include "ui/gadget_results/Storage.hpp"
#include "core/gadgets/bash/BashGadget.hpp"
#include "core/gadgets/bash/AsyncBashCall.hpp"

namespace batbox::application::shell {
struct Inputs {
  event_loop::Loop* owner=nullptr;
  std::string shellPath,originalCwd,outputDir;
  std::shared_ptr<shell_provider::BashProvider> provider;
  std::function<std::string()> generateMissionId,generateExecId;
  std::function<long long()> nowMs;
  std::function<void(const std::string&,const std::optional<std::string>&)>
    enqueueNotification;
  std::function<void(const missions::roster::MissionRecord&)> onMissionTerminated;
  std::function<void(std::exception_ptr)> onBackgroundError;
  std::shared_ptr<batbox::shell::CwdCompletionServices> cwdCompletion;
  std::size_t maxInlineOutputBytes=30000;
  bool backgroundMissionsDisabled=false,assistantAutoBackgroundEnabled=false;
  double defaultTimeoutMs=120000,maxTimeoutMs=600000,
    assistantBlockingBudgetMs=15000;
};
struct Host {
  std::shared_ptr<batbox::shell::ManagedShell> shell;
  std::shared_ptr<batbox::shell::MissionOutputPoller> poller;
  std::shared_ptr<missions::roster::Roster> missions;
};
Host makeHost(Inputs inputs);
// Seal this generation against new commands, stop its local Bash missions, and
// await indigenous child reaping plus MissionOutput poller shutdown off the owner.
event_loop::Deferred<event_loop::Unit> stopAndWait(event_loop::Loop& owner,
  const Host& host);

// Completes the Bash gadget's real mission lifecycle and persistence callbacks.
// Permission, command classification, image and FTXUI imports remain
// on Services and must be supplied by their owning application modules.
void bindBashMissionServices(bash_gadget::Services& services,const Host& host,
  const gadget_results::StorageImports& storage,
  std::function<void(const Json&)> showBackgroundHint={});
void bindConservativeBashClassification(bash_gadget::Services& services);

struct AsyncHostInputs {
  event_loop::Loop& owner;
  const Host& shell;
  gadget_results::StorageImports storage;
  std::function<Json()> getGadgetPermissionContext;
  std::function<event_loop::Deferred<batbox::gadgets::GadgetResult>(
    const Json&,const batbox::gadgets::GadgetCallContext&,const Json&)> applySedEdit;
  std::function<event_loop::Deferred<std::optional<std::string>>(
    const std::string&,const std::optional<std::string>&,
    const std::optional<std::uintmax_t>&)> resizeShellImageOutput;
  std::function<void(std::exception_ptr)> onUnobservedError;
  double defaultTimeoutMs=120000,progressThresholdMs=2000;
};
// Binds the Bash async-generator mission path to the same ManagedShell and
// mission roster as MissionOutput/MissionStop. It runs command waits off the owner.
bash_gadget::AsyncMissionHost makeAsyncBashMissionHost(AsyncHostInputs inputs);
} // namespace batbox::application::shell
