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
  src/skills/Arguments.cpp src/skills/SkillCommand.cpp src/skills/SkillDirectory.cpp
  src/skills/SkillFields.cpp src/skills/SkillRosterCore.cpp src/skills/SkillRosterDynamic.cpp
  src/skills/SkillGadgetCall.cpp src/skills/SkillGadgetContext.cpp src/skills/SkillGadgetFactory.cpp
  src/skills/SkillGadgetMessages.cpp src/skills/SkillGadgetPoetry.cpp src/skills/SkillGadgetPoetryText.cpp
  src/skills/SkillGadgetSchema.cpp src/skills/SkillGadgetValidation.cpp)
target_link_libraries(batbox_skills PUBLIC batbox_instructions batbox_bats)
target_compile_options(batbox_skills PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_skills PRIVATE src/skills/process/PoetryPolicy.cpp
  src/skills/process/PoetryMetadata.cpp src/skills/process/PoetryCommand.cpp)
target_sources(batbox_skills PRIVATE src/skills/remote/RemoteSkill.cpp
  src/skills/remote/RemoteSkillText.cpp)
