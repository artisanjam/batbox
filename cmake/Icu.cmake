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
  # explicit CMAKE_PREFIX_PATH the caller passed for a custom brew prefix.
  foreach(prefix ${CMAKE_PREFIX_PATH})
    list(APPEND _icu_candidates "${prefix}/opt/icu4c")
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
# Sources include <unicode/...> directly in targets that do not link ICU::
# imported targets (batbox_intl, batbox_text_sdk), so propagate the discovered
# include dir project-wide from this single discovery point.
if(ICU_INCLUDE_DIRS)
  include_directories(BEFORE SYSTEM ${ICU_INCLUDE_DIRS})
endif()
