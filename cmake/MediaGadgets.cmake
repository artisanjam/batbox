find_package(PkgConfig REQUIRED)
include(cmake/PkgKeg.cmake)
pkg_check_modules(VIPS REQUIRED IMPORTED_TARGET vips)
# A search on a broken Requires chain caches VIPS_FOUND=1 with empty flag
# lists (keg metadata resolves but cflags fail), and FindPkgConfig skips
# re-searches of cached-found modules. Re-discover when the cached result is
# vacuous so a corrected search path takes effect on reconfigure.
if(VIPS_FOUND AND NOT VIPS_INCLUDE_DIRS)
  foreach(_v VIPS VIPS_STATIC)
    foreach(_k FOUND CFLAGS CFLAGS_I CFLAGS_OTHER INCLUDEDIR INCLUDE_DIRS
        LDFLAGS LDFLAGS_OTHER LIBDIR LIBRARIES LIBRARY_DIRS LIBS LIBS_L
        LIBS_OTHER LIBS_PATHS MODULE_NAME PREFIX VERSION)
      unset(${_v}_${_k} CACHE)
    endforeach()
  endforeach()
  pkg_check_modules(VIPS REQUIRED IMPORTED_TARGET vips)
endif()
add_library(batbox_media
  src/lib/media/Base64.cpp src/lib/media/Binding.cpp src/lib/media/ImageBasics.cpp
  src/lib/media/ImageCompress.cpp src/lib/media/ImageIndigenous.cpp src/lib/media/ImagePipeline.cpp
  src/lib/media/ImageResize.cpp src/lib/media/PDFExtract.cpp src/lib/media/PDFFile.cpp
  src/lib/media/PDFRead.cpp src/lib/media/Process.cpp)
target_link_libraries(batbox_media PUBLIC batbox_core PkgConfig::VIPS)
target_compile_options(batbox_media PRIVATE -Wall -Wextra -Wpedantic)
