add_library(batbox_intl src/lib/intl/Stash.cpp src/lib/intl/IndigenousSegments.cpp)
target_link_libraries(batbox_intl PUBLIC batbox_core ICU::i18n)
target_compile_options(batbox_intl PRIVATE -Wall -Wextra -Wpedantic)
