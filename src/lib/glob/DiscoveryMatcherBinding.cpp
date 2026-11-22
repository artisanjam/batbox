#include "lib/glob/DiscoveryMatcherBinding.hpp"
#include "lib/glob/Ignore.hpp"
#include "lib/glob/Picomatch.hpp"
#include "lib/instructions/project/ProjectDiscovery.hpp"

namespace batbox::glob {
void bindDiscoveryMatchers(instructions::project::DiscoveryServices& services){
  services.matchExclude=[](const std::string& path,
    const std::vector<std::string>& patterns){
    return isMatch(path,patterns);
  };
  services.matchRuleIgnore=[](const std::string& relativePath,
    const std::vector<std::string>& patterns){
    return ignores(relativePath,patterns);
  };
}
} // namespace batbox::glob
