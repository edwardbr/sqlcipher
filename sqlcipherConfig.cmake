FIND_PATH(SQLCIPHER_ROOT_DIR
  NAMES include/sqlcipher/sqlite3.h
)
MARK_AS_ADVANCED(SQLCIPHER_ROOT_DIR)

# Re-use the previous path:
FIND_PATH(SQLCIPHER_INCLUDE_DIR sqlcipher/sqlite3.h
  PATHS ${SQLCIPHER_ROOT_DIR}/include
)

FIND_LIBRARY(LIB_SQLCIPHER NAMES libsqlite.a
      PATHS ${SQLCIPHER_ROOT_DIR}/lib
      )

SET(SQLCIPHER_LIBRARIES ${LIB_SQLCIPHER})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(sqlcipher DEFAULT_MSG
  SQLCIPHER_LIBRARIES 
  SQLCIPHER_INCLUDE_DIR
)