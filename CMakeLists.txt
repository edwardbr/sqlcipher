cmake_minimum_required(VERSION 3.2)
project(sqlite3 VERSION 3.21.0)

option(SQLITE_ENABLE_COLUMN_METADATA "FIXME Description" ON)
option(SQLITE_ENABLE_FTS4  "FIXME Description" ON)
option(SQLITE_ENABLE_FTS5 "FIXME Description" ON)
option(SQLITE_ENABLE_JSON1 "FIXME Description" ON)
option(SQLITE_ENABLE_RTREE "FIXME Description" ON)
option(SQLITE_ENABLE_STAT4 "FIXME Description" ON)
option(SQLITE_SOUNDEX "FIXME Description" ON)
option(SQLITE_USE_URI "FIXME Description" ON)

set(headers sqlite3ext.h sqlite3.h)
add_library(sqlite3 sqlite3.c ${headers})

foreach(
    x
    SQLITE_ENABLE_COLUMN_METADATA
    SQLITE_ENABLE_FTS4
    SQLITE_ENABLE_FTS5
    SQLITE_ENABLE_JSON1
    SQLITE_ENABLE_RTREE
    SQLITE_ENABLE_STAT4
    SQLITE_SOUNDEX
    SQLITE_USE_URI
)
  if(${x})
    target_compile_definitions(sqlite3 PRIVATE ${x})
  endif()
endforeach()

find_package(Threads REQUIRED)
target_link_libraries(sqlite3 PUBLIC Threads::Threads ${CMAKE_DL_LIBS})

set(pc_config "${CMAKE_CURRENT_BINARY_DIR}/sqlite3.pc")
configure_file(sqlite3.pc.in ${pc_config} @ONLY)

set(la_config "${CMAKE_CURRENT_BINARY_DIR}/libsqlite3.la")
configure_file(libsqlite3.la.in ${la_config} @ONLY)

# Installation (https://github.com/forexample/package-example) {

set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)

# Use:
#   * PROJECT_VERSION
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Use variables:
#   * TARGETS_EXPORT_NAME
#   * PROJECT_NAME
configure_package_config_file(
    "cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)

install(
    TARGETS sqlite3
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    RUNTIME DESTINATION "bin"
    INCLUDES DESTINATION "${include_install_dir}"
)

install(
    FILES ${headers}
    DESTINATION "${include_install_dir}"
)

install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${namespace}"
    DESTINATION "${config_install_dir}"
)

install(FILES ${pc_config} DESTINATION lib/pkgconfig)
install(FILES ${la_config} DESTINATION lib)

# }
