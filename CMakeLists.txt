cmake_minimum_required(VERSION 3.10.2)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

include(HunterGate)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.165.tar.gz"
    SHA1 "5a73f91df5f6109c0bb1104d0c0ee423f7bece79"
    LOCAL
)


project(sqlcipher VERSION 3.27.2)

option(SQLITE_ENABLE_COLUMN_METADATA "FIXME Description" ON)
option(SQLITE_ENABLE_FTS4  "FIXME Description" ON)
option(SQLITE_ENABLE_FTS5 "FIXME Description" ON)
option(SQLITE_ENABLE_JSON1 "FIXME Description" ON)
option(SQLITE_ENABLE_RTREE "FIXME Description" ON)
option(SQLITE_ENABLE_STAT4 "FIXME Description" ON)
option(SQLITE_SOUNDEX "FIXME Description" ON)
option(SQLITE_USE_URI "FIXME Description" ON)

add_definitions(-DSQLITE_HAS_CODEC -DSQLITE_THREADSAFE=1)

set(headers include/sqlcipher/sqlite3ext.h include/sqlcipher/sqlite3.h)
add_library(sqlcipher sqlite3.c ${headers})
add_library(sqlcipher::sqlcipher ALIAS sqlcipher)

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
    target_compile_definitions(sqlcipher PRIVATE ${x})
  endif()
endforeach()

find_package(Threads REQUIRED)
target_link_libraries(sqlcipher PUBLIC Threads::Threads ${CMAKE_DL_LIBS})

hunter_add_package(OpenSSL)
find_package(OpenSSL REQUIRED)
target_link_libraries(sqlcipher PUBLIC ssl crypto)

if(ANDROID)
  set(pthread_to_config "")
else()
  set(pthread_to_config "-lpthread")
endif()

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
    TARGETS sqlcipher
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
