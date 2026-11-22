include_guard(GLOBAL)
# One ICU discovery point for the whole project. Every component the sources
# use must be configured here: uc (ustring/uchar/unorm2/usymbol) and i18n
# (ucol_, uregex_, BreakIterator beyond ubrk, date format/dtptngen).
# Homebrew's icu4c is keg-only: its headers and libraries live under
# <brew-prefix>/opt/icu4c, which FindICU does not search unless directed.
# The prefix is not always the default /opt/homebrew -- a custom install
# (e.g. $HOME/usr/homebrew) relocates it -- so derive it from the brew
# environment when available and fall back to the known stock prefixes.
# Detect with unicode/utext.h (always shipped) rather than unicode/unicode.h,
# which the newer icu4c formulae no longer install.
if(APPLE)
  set(_icu_roots "")
  if(DEFINED ENV{HOMEBREW_PREFIX})
    list(APPEND _icu_roots "$ENV{HOMEBREW_PREFIX}/opt/icu4c")
  endif()
  foreach(prefix /opt/homebrew/opt/icu4c /usr/local/opt/icu4c)
    list(APPEND _icu_roots "${prefix}")
  endforeach()
  foreach(prefix ${_icu_roots})
    if(EXISTS "${prefix}/include/unicode/utext.h"
        AND EXISTS "${prefix}/lib/libicui18n.dylib")
      list(APPEND CMAKE_PREFIX_PATH "${prefix}")
    endif()
  endforeach()
endif()
find_package(ICU REQUIRED COMPONENTS uc i18n)
