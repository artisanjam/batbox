#include "application/poetry/Provider.hpp"
#include "cwd/Override.hpp"
#include "runtime/IndigenousPath.hpp"
#include "glob/DiscoveryMatcherBinding.hpp"
#include "git/GitBindings.hpp"
#include "instructions/project/async/ContextBinding.hpp"
#include "runtime/Unicode.hpp"
#include <cstdlib>
#include <filesystem>
#include <stdexcept>

namespace batbox::application::poetry {
namespace {
std::vector<std::string> stringArray(const Json& value){
  std::vector<std::string> result;
  if(value.is_array())for(const auto& item:value)
    if(item.is_string())result.push_back(item.get<std::string>());
  return result;
}
bool inPath(const std::string& child,const std::string& base){
  const auto relative=std::filesystem::path(child).lexically_normal().
    lexically_relative(std::filesystem::path(base).lexically_normal());
  if(relative.empty())return false;
  for(const auto& component:relative)
    if(component=="..")return false;
  return true;
}
}
void Provider::bindDiscovery(){
  const auto home=std::getenv("HOME");
  memoryPaths_.homeDirectory=home?home:"";
  memoryPaths_.configHomeDir=inputs_.config.stateDirectory.string();
  memoryPaths_.projectRoot=cwd();
  memoryPaths_.environment=inputs_.environment;
  memoryPaths_.initialSettings=settings();
  memoryPaths_.settingsBySource["userSettings"]=memoryPaths_.initialSettings;
  // The canonical root is a shared tree owned here; callbacks capture the
  // handle, not `this`, so they stay valid after Provider teardown.
  const auto boundCanonicalRoot=canonicalRoot_;
  memoryPaths_.findCanonicalGitRoot=[boundCanonicalRoot](const std::string& path){
    return boundCanonicalRoot->find(path);
  };
  // Snapshots for the discovery bindings below: async MemoryRun continuations
  // may run on a non-owner loop thread under load, and after a retired
  // workspace shutdown the Provider itself can be destroyed while queued
  // continuation callbacks still hold copies of these functions -- calling
  // memoryPathServices()/settings()/cwd() through `this` there either trips
  // the owner guard, races owner-thread writes, or reads freed memory. Every
  // field read here is fixed for a provider's lifetime, so the snapshot
  // equals any later live read, and no callback borrows Provider state.
  const auto boundMemoryPaths=memoryPaths_;
  const auto boundConfig=inputs_.config;
  // cwd() keeps the cwd-override stack live; only the base path is copied,
  // so override behavior is preserved without borrowing the Provider.
  const auto boundCwd=[boundConfig] {
    return cwd::pwd([&]{return runtime::pathToUtf8(boundConfig.cwd);});
  };
  const auto boundHomeDirectory=memoryPaths_.homeDirectory;
  const auto boundLogDiagnostic=inputs_.logDiagnostic;
  discovery_.parse.paths.getCwd=boundCwd;
  discovery_.parse.paths.homeDirectory=[boundHomeDirectory]{
    return boundHomeDirectory;};
  discovery_.parse.paths.platform=[] {
#if defined(_WIN32)
    return std::string("windows");
#elif defined(__APPLE__)
    return std::string("darwin");
#else
    return std::string("linux");
#endif
  };
  discovery_.parse.paths.normalizeNFC=value::normalizeNFC;
  discovery_.parse.logDebug=[boundLogDiagnostic](const std::string& message){
    if(boundLogDiagnostic)
      boundLogDiagnostic("debug",message,std::nullopt);
  };
  const auto boundExcludePatterns=
    stringArray(value::property(settings(),"memoryExcludePatterns"));
  discovery_.excludePatterns=[boundExcludePatterns]{
    return boundExcludePatterns;
  };
  glob::bindDiscoveryMatchers(discovery_);
  discovery_.pathInWorkingPath=inPath;
  discovery_.originalCwd=boundCwd;
  discovery_.memoryPath=[boundConfig](const std::string& type){
    if(type=="Managed")return (boundConfig.stateDirectory/
      "instructions/managed/BATBOX.md").string();
    if(type=="User")return (application::configurationDirectory(boundConfig)/
      "BATBOX.md").string();
    throw std::invalid_argument("Unknown instruction source: "+type);
  };
  discovery_.managedRulesDir=[boundConfig]{return (boundConfig.stateDirectory/
    "instructions/managed/rules").string();};
  discovery_.userRulesDir=[boundConfig]{return (application::configurationDirectory(
    boundConfig)/"rules").string();};
  const auto boundSettingSources=value::property(settings(),"settingSources");
  discovery_.settingSourceEnabled=[boundSettingSources](const std::string& source){
    const auto& configured=value::property(boundSettingSources,source);
    return configured.is_null()||value::truthy(configured);
  };
  const auto boundExternalIncludesApproved=value::truthy(
    value::property(settings(),"allowExternalInstructions"));
  discovery_.externalIncludesApproved=[boundExternalIncludesApproved]{
    return boundExternalIncludesApproved;
  };
  const auto boundAdditionalDirectories=inputs_.additionalDirectories;
  discovery_.additionalDirectoriesEnabled=[boundAdditionalDirectories]{
    return !boundAdditionalDirectories.empty();
  };
  discovery_.additionalDirectories=[boundAdditionalDirectories]{
    return boundAdditionalDirectories;
  };
  discovery_.findGitRoot=[boundCanonicalRoot](const std::string& path){
    return boundCanonicalRoot->nearest(path);
  };
  discovery_.findCanonicalGitRoot=[boundCanonicalRoot](const std::string& path){
    return boundCanonicalRoot->find(path);
  };
  discovery_.autoMemoryEnabled=[boundMemoryPaths]{
    return instructions::isAutoMemoryEnabled(boundMemoryPaths);
  };
  // The stash is shared, not borrowed from Provider: the entrypoint callback
  // can outlive the Provider after a retired workspace shutdown.
  const auto boundMemoryPathStash=memoryPathStash_;
  discovery_.autoMemoryEntrypoint=[boundMemoryPaths,boundMemoryPathStash]()mutable{
    return instructions::getAutoMemEntrypoint(boundMemoryPaths,
      *boundMemoryPathStash);
  };
  const auto boundInstructionsLoadedHook=inputs_.instructionsLoadedHook;
  discovery_.hasInstructionsLoadedHook=[boundInstructionsLoadedHook]{
    return bool(boundInstructionsLoadedHook);
  };
  discovery_.instructionsLoadedHook=[boundInstructionsLoadedHook](const auto& file,
      const auto& reason){
    if(boundInstructionsLoadedHook)
      boundInstructionsLoadedHook(file,reason);
  };
  const auto boundSkipAutoMemoryIndex=value::truthy(
    value::property(settings(),"skipAutoMemoryIndex"));
  discovery_.skipAutoMemoryIndex=[boundSkipAutoMemoryIndex]{
    return boundSkipAutoMemoryIndex;
  };
  const auto boundSkipProjectInstructions=value::truthy(
    value::property(settings(),"skipProjectInstructions"));
  discovery_.skipProjectInstructions=[boundSkipProjectInstructions]{
    return boundSkipProjectInstructions;
  };
  discoveryAsync_=instructions::project::async::indigenousAsyncFs(owner_,discovery_);
}
void Provider::bindContext(){
  contextServices_.environment=inputs_.environment;
  contextServices_.testEnvironment=inputs_.testEnvironment;
  contextServices_.logError=[this](std::exception_ptr error){
    if(inputs_.logError)inputs_.logError(error);
  };
  contextServices_.includeGitInstructions=[this]{
    return context::shouldIncludeGitInstructions(inputs_.environment,settings());
  };
  contextServices_.stashBreakerFeature=[] {return false;};
  contextServices_.bareMode=[this]{
    return value::truthy(value::property(settings(),"bareMode"));
  };
  contextServices_.additionalInstructionDirectories=[this]{
    return inputs_.additionalDirectories;
  };
  contextServices_.projectServices=&discovery_;
  contextServices_.setStashedBatboxMdContent=[this](const auto& content){
    stashedBatboxMdContent_=content;
  };
  contextServices_.localISODate=[] {return context::getLocalISODate();};
  git::bindGitContextServices(contextServices_,*gitBasics_);
  contextServices_.gitStdoutNoThrow=[this](const std::vector<std::string>& args){
    event_loop::Deferred<std::string> output(owner_);
    process::ExecOptions options;
    options.preserveOutputOnError=false;
    options.cwd=cwd();
    process::execFileNoThrow(owner_,gitBasics_->gitExe(),args,
      options,execImports_).then([output](const process::ExecResult* value,
        const std::exception_ptr& error){
      if(error)output.reject(error);else output.resolve(value->stdoutText);
    });
    return output;
  };
  instructions::project::async::bindMemoryContextServices(
    contextServices_,discoveryStash_,discoveryAsync_);
}
} // namespace batbox::application::poetry
