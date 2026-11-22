include_guard(GLOBAL)
# One pkg-config search-path setup for the whole project. Homebrew keeps
# keg-only formulae (libarchive, icu4c, jpeg-turbo, ...) out of the shared
# <prefix>/lib/pkgconfig, so pkg-config cannot resolve their Requires chains:
# vips fails a bare lookup with "Package libarchive was not found" even though
# the keg ships libarchive.pc. Add every keg's pkgconfig dir under the
# candidate brew prefixes to the search path before any pkg_check_modules.
# Prefix candidates follow the same derivation as Icu.cmake: HOMEBREW_PREFIX,
# CMAKE_PREFIX_PATH (environment as well as the variable -- CMake consumes
# the env value only inside find commands and leaves the variable unset),
# then the stock prefixes.
set(_keg_roots "")
if(DEFINED ENV{HOMEBREW_PREFIX})
  list(APPEND _keg_roots "$ENV{HOMEBREW_PREFIX}")
endif()
set(_cpp "${CMAKE_PREFIX_PATH}")
if(NOT _cpp AND DEFINED ENV{CMAKE_PREFIX_PATH})
  string(REPLACE ":" ";" _cpp "$ENV{CMAKE_PREFIX_PATH}")
endif()
foreach(prefix ${_cpp})
  list(APPEND _keg_roots "${prefix}")
endforeach()
foreach(prefix /opt/homebrew /usr/local)
  list(APPEND _keg_roots "${prefix}")
endforeach()
set(_pc_dirs "")
foreach(root ${_keg_roots})
  file(GLOB _here "${root}/opt/*/lib/pkgconfig")
  list(APPEND _pc_dirs ${_here})
endforeach()
if(_pc_dirs)
  list(REMOVE_DUPLICATES _pc_dirs)
  if(DEFINED ENV{PKG_CONFIG_PATH})
    set(ENV{PKG_CONFIG_PATH} "${_pc_dirs}:$ENV{PKG_CONFIG_PATH}")
  else()
    set(ENV{PKG_CONFIG_PATH} "${_pc_dirs}")
  endif()
endif()
