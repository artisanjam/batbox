find_package(yaml-cpp REQUIRED)
add_library(batbox_instructions
  src/lib/instructions/MemoryLines.cpp src/lib/instructions/MemoryLoad.cpp
  src/lib/instructions/MemoryPath.cpp src/lib/instructions/MemoryScan.cpp
  src/lib/instructions/MemoryTruncation.cpp src/lib/instructions/MemoryTypes.cpp
  src/lib/instructions/MemoryTypesIndividual.cpp
  src/lib/instructions/FrontmatterYaml.cpp src/lib/instructions/FrontmatterFields.cpp
  src/lib/instructions/FrontmatterPaths.cpp)
target_link_libraries(batbox_instructions PUBLIC batbox_core yaml-cpp ICU::uc)
target_compile_options(batbox_instructions PRIVATE -Wall -Wextra -Wpedantic)
add_library(batbox_skills
  src/core/skills/Arguments.cpp src/core/skills/SkillCommand.cpp src/core/skills/SkillDirectory.cpp
  src/core/skills/SkillFields.cpp src/core/skills/SkillRosterCore.cpp src/core/skills/SkillRosterDynamic.cpp
  src/core/skills/SkillGadgetCall.cpp src/core/skills/SkillGadgetContext.cpp src/core/skills/SkillGadgetFactory.cpp
  src/core/skills/SkillGadgetMessages.cpp src/core/skills/SkillGadgetPoetry.cpp src/core/skills/SkillGadgetPoetryText.cpp
  src/core/skills/SkillGadgetSchema.cpp src/core/skills/SkillGadgetValidation.cpp)
target_link_libraries(batbox_skills PUBLIC batbox_instructions batbox_bats)
target_compile_options(batbox_skills PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_skills PRIVATE src/core/skills/process/PoetryPolicy.cpp
  src/core/skills/process/PoetryMetadata.cpp src/core/skills/process/PoetryCommand.cpp)
target_sources(batbox_skills PRIVATE src/core/skills/remote/RemoteSkill.cpp
  src/core/skills/remote/RemoteSkillText.cpp)
