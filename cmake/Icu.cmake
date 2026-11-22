include_guard(GLOBAL)
# One ICU discovery point for the whole project. Every component the sources
# use must be configured here: uc (ustring/uchar/unorm2/usymbol) and i18n
# (ucol_, uregex_, BreakIterator beyond ubrk, date format/dtptngen).
# Homebrew's icu4c is keg-only: its headers and libraries live under
# <brew-prefix>/opt/icu4c, which FindICU does not search unless directed via
# ICU_ROOT. The prefix is not always the default /opt/homebrew -- a custom
# install (e.g. $HOME/usr/homebrew) relocates it -- so derive it from the brew
# environment when available and fall back to the known stock prefixes, then
# point FindICU at the keg root so its headers win over the macOS SDK's
# stubbed system ICU. Detect with unicode/utext.h (always shipped) rather than
# unicode/unicode.h, which the newer icu4c formulae no longer install.
if(APPLE AND NOT ICU_ROOT)
  set(_icu_candidates "")
  if(DEFINED ENV{HOMEBREW_PREFIX})
    list(APPEND _icu_candidates "$ENV{HOMEBREW_PREFIX}/opt/icu4c")
  endif()
  # Non-login shells (ssh commands, CI) export no HOMEBREW_PREFIX; honor any
  # explicit CMAKE_PREFIX_PATH for a custom brew prefix -- both as the brew
  # root (prefix/opt/icu4c) and as a keg root itself (a versioned keg like
  # icu4c@79 named directly in the path). CMake consumes the env value only
  # inside find commands -- the variable itself stays unset unless passed
  # with -D -- so read the environment directly and split it.
  set(_cpp "${CMAKE_PREFIX_PATH}")
  if(NOT _cpp AND DEFINED ENV{CMAKE_PREFIX_PATH})
    string(REPLACE ":" ";" _cpp "$ENV{CMAKE_PREFIX_PATH}")
  endif()
  foreach(prefix ${_cpp})
    list(APPEND _icu_candidates "${prefix}/opt/icu4c" "${prefix}")
  endforeach()
  foreach(prefix /opt/homebrew/opt/icu4c /usr/local/opt/icu4c)
    list(APPEND _icu_candidates "${prefix}")
  endforeach()
  foreach(prefix ${_icu_candidates})
    if(EXISTS "${prefix}/include/unicode/utext.h"
        AND EXISTS "${prefix}/lib/libicui18n.dylib")
      set(ICU_ROOT "${prefix}")
      break()
    endif()
  endforeach()
endif()
find_package(ICU REQUIRED COMPONENTS uc i18n)
# A stale cache or an unpinned search can resolve the headers to the macOS
# SDK's stub set: it ships utext.h/uchar.h (so detection succeeds and the
# version reads plausible) but not the component headers our sources include
# (brkiter.h/dtptngen.h for i18n, unorm2.h for uc). When the discovered dir
# lacks them, drop the cached path and re-discover -- the ICU_ROOT hint set
# above then makes the keg win over the SDK. Warn loudly if even the re-search
# lands on a stub: the build would fail downstream with confusing errors.
if(APPLE AND NOT EXISTS "${ICU_INCLUDE_DIR}/unicode/brkiter.h"
    AND NOT EXISTS "${ICU_INCLUDE_DIR}/unicode/unorm2.h")
  unset(ICU_INCLUDE_DIR CACHE)
  find_package(ICU REQUIRED COMPONENTS uc i18n)
  if(NOT EXISTS "${ICU_INCLUDE_DIR}/unicode/brkiter.h")
    message(WARNING
      "ICU headers discovered at ${ICU_INCLUDE_DIR} lack unicode/brkiter.h -- "
      "this looks like the macOS SDK stub set. Set ICU_ROOT (or "
      "CMAKE_PREFIX_PATH) to a full icu4c keg.")
  endif()
endif()
# Sources include <unicode/...> directly in targets that do not link ICU::
# imported targets (batbox_intl, batbox_text_sdk), so propagate the discovered
# include dir project-wide from this single discovery point. This FindICU
# publishes the include dir on the imported targets (and only the singular
# ICU_INCLUDE_DIR), not in ICU_INCLUDE_DIRS -- read the target property.
get_target_property(_icu_include ICU::uc INTERFACE_INCLUDE_DIRECTORIES)
if(_icu_include)
  include_directories(BEFORE SYSTEM ${_icu_include})
endif()
