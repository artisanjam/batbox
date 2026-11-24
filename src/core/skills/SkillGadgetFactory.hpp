#pragma once
#include "core/skills/SkillGadgetExecution.hpp"
#include "core/skills/SkillGadgetPoetry.hpp"
#include "core/skills/SkillGadgetSchema.hpp"

namespace batbox::skills {
struct SkillGadgetFactoryServices {
  SkillExecutionServices execution;
  SkillPoetryServices poetry;
  std::function<std::string()> getProjectRoot;
  std::function<std::vector<Json>(const Json&)> getAllCommandsForValidation;
  std::function<RuleEntries(const Json&,const std::string&)> getRules;
  std::function<Json(const Json&,const Json&)> renderGadgetUseMessage;
  std::function<Json(const Json&,const Json&,const Json&)> renderGadgetResultMessage;
  std::function<Json(const Json&,const Json&)> renderGadgetUseProgressMessage;
  std::function<Json(const Json&,const Json&)> renderGadgetUseRejectedMessage;
  std::function<Json(const Json&,const Json&)> renderGadgetUseErrorMessage;
};
gadgets::Gadget makeSkillGadget(SkillGadgetFactoryServices services);
}
