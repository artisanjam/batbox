find_package(PkgConfig REQUIRED)
pkg_check_modules(VIPS REQUIRED IMPORTED_TARGET vips)
add_library(batbox_media
  src/lib/media/Base64.cpp src/lib/media/Binding.cpp src/lib/media/ImageBasics.cpp
  src/lib/media/ImageCompress.cpp src/lib/media/ImageIndigenous.cpp src/lib/media/ImagePipeline.cpp
  src/lib/media/ImageResize.cpp src/lib/media/PDFExtract.cpp src/lib/media/PDFFile.cpp
  src/lib/media/PDFRead.cpp src/lib/media/Process.cpp)
target_link_libraries(batbox_media PUBLIC batbox_core PkgConfig::VIPS)
target_compile_options(batbox_media PRIVATE -Wall -Wextra -Wpedantic)
