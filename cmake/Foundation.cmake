include(cmake/Icu.cmake)
include(cmake/CmarkDependency.cmake)
target_sources(batbox_instructions PRIVATE
  src/lib/instructions/project/MarkdownLexer.cpp src/lib/instructions/project/ProjectComments.cpp
  src/lib/instructions/project/ProjectContent.cpp src/lib/instructions/project/ProjectFrontmatter.cpp
  src/lib/instructions/project/ProjectIncludes.cpp src/lib/instructions/project/ProjectPaths.cpp
  src/lib/instructions/project/ProjectContext.cpp)
target_link_libraries(batbox_instructions PUBLIC PkgConfig::CMARK_GFM ICU::i18n)
add_library(batbox_context src/core/context/AsyncContextStash.cpp src/core/context/AsyncGitStatus.cpp
  src/core/context/AsyncSystemContext.cpp src/core/context/AsyncUserContext.cpp)
target_link_libraries(batbox_context PUBLIC batbox_instructions batbox_event_loop)
target_compile_options(batbox_context PRIVATE -Wall -Wextra -Wpedantic)
# The default system prompt is poetry/system.md, embedded as bytes so the
# binary never reads it at run time.
set(BATBOX_SYSTEM_POETRY_SOURCE ${CMAKE_SOURCE_DIR}/poetry/system.md)
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${BATBOX_SYSTEM_POETRY_SOURCE})
file(READ ${BATBOX_SYSTEM_POETRY_SOURCE} BATBOX_SYSTEM_POETRY_HEX HEX)
string(REGEX REPLACE "([0-9a-f][0-9a-f])" "0x\\1," BATBOX_SYSTEM_POETRY_BYTES "${BATBOX_SYSTEM_POETRY_HEX}")
string(REGEX REPLACE "((0x..,){24})" "\\1\n" BATBOX_SYSTEM_POETRY_BYTES "${BATBOX_SYSTEM_POETRY_BYTES}")
configure_file(src/lib/poetryEntries/SystemPoetryDefault.cpp.in
  ${CMAKE_BINARY_DIR}/generated/poetryEntries/SystemPoetryDefault.cpp @ONLY)
add_library(batbox_poetryEntries
  src/lib/poetryEntries/BatPoetry.cpp src/lib/poetryEntries/EnvironmentBasics.cpp src/lib/poetryEntries/EnvironmentRender.cpp
  src/lib/poetryEntries/GuidanceCore.cpp src/lib/poetryEntries/GuidanceFlight.cpp
  src/lib/poetryEntries/GuidanceGadgets.cpp src/lib/poetryEntries/PoetryBindings.cpp src/lib/poetryEntries/PoetryBlocks.cpp
  src/lib/poetryEntries/SystemHead.cpp src/lib/poetryEntries/SystemPoetryFile.cpp
  ${CMAKE_BINARY_DIR}/generated/poetryEntries/SystemPoetryDefault.cpp
  src/lib/poetryEntries/AsyncSections.cpp
  src/lib/poetryEntries/AsyncPoetryStart.cpp
  src/lib/poetryEntries/AsyncPoetryDynamic.cpp src/lib/poetryEntries/AsyncPoetryFinish.cpp
  src/lib/poetryEntries/EffectiveSystemPoetry.cpp)
target_link_libraries(batbox_poetryEntries PUBLIC batbox_context batbox_core)
target_compile_options(batbox_poetryEntries PRIVATE -Wall -Wextra -Wpedantic)
if(WIN32)
  set(BATBOX_INDIGENOUS_EXEC_SOURCE src/lib/runtime/IndigenousExecUv.cpp)
else()
  set(BATBOX_INDIGENOUS_EXEC_SOURCE src/lib/runtime/IndigenousExec.cpp)
endif()
add_library(batbox_process src/lib/runtime/ExecFileNoThrow.cpp ${BATBOX_INDIGENOUS_EXEC_SOURCE})
target_link_libraries(batbox_process PUBLIC batbox_event_loop batbox_core)
target_compile_options(batbox_process PRIVATE -Wall -Wextra -Wpedantic)
# One git system, one target. src/lib/git/ holds the subprocess/binding half,
# src/lib/git/filesystem/ the filesystem/state half; GitBindings.hpp bridges
# the two halves, so one target is the honest shape.
add_library(batbox_git src/lib/git/filesystem/Paths.cpp src/lib/git/filesystem/Refs.cpp
  src/lib/git/filesystem/Computations.cpp src/lib/git/filesystem/Watcher.cpp
  src/lib/git/filesystem/IndigenousFs.cpp
  src/lib/git/GitBasics.cpp src/lib/git/IndigenousBasics.cpp
  src/lib/git/GitBindings.cpp src/lib/git/CanonicalRoot.cpp src/lib/git/IndigenousCanonicalRoot.cpp)
target_link_libraries(batbox_git PUBLIC batbox_event_loop batbox_core ICU::i18n
  batbox_context batbox_process OpenSSL::Crypto ICU::uc)
target_compile_options(batbox_git PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_shell PRIVATE src/core/gadgets/bash/AsyncBashPersistence.cpp
  src/core/gadgets/bash/AsyncBashImage.cpp)
add_library(batbox_shell_media src/core/gadgets/bash/IndigenousBashImage.cpp)
target_link_libraries(batbox_shell_media PUBLIC batbox_shell batbox_media)
target_compile_options(batbox_shell_media PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_query PRIVATE
  src/core/query/AsyncCompletionStart.cpp
  src/core/query/AsyncCompletionStop.cpp src/core/query/AsyncGadgetTurnStart.cpp
  src/core/query/AsyncGadgetTurnAbort.cpp src/core/query/AsyncGadgetTurnAttachments.cpp
  src/core/query/AsyncGadgetTurnFinish.cpp src/core/query/IndigenousModelCursor.cpp
  src/core/query/IndigenousGadgetCursor.cpp src/core/query/AsyncOperationQueue.cpp
  src/core/query/AsyncEntry.cpp
  src/core/query/AsyncEngineClose.cpp src/core/query/AsyncModelClose.cpp
  src/core/query/AsyncDecisionClose.cpp src/core/query/OwnerPreflight.cpp
  src/core/query/OwnerModelCursor.cpp src/core/query/OwnerStreamConsume.cpp src/core/query/OwnerRetry.cpp)
