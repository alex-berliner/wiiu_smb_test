cmake_minimum_required(VERSION 3.2)
project(wiiu_smb_test CXX)


list(APPEND CMAKE_MODULE_PATH "${DEVKITPRO}/portlibs/wiiu/lib/cmake/libsmb2")

find_package(SMB2 REQUIRED)

if (NOT TARGET SMB2::SMB2)
    add_library(SMB2::SMB2 STATIC IMPORTED)
    set_target_properties(SMB2::SMB2 PROPERTIES
        IMPORTED_LOCATION "${SMB2_LIBRARY}"
    )
    target_include_directories(SMB2::SMB2 INTERFACE
        "${SMB2_INCLUDE_DIR}"
    )
endif()

add_executable(wiiu_smb_test
main.cpp)

set(CMAKE_FIND_DEBUG_MODE 1)
target_link_libraries(wiiu_smb_test PRIVATE SMB2::SMB2)
set(CMAKE_FIND_DEBUG_MODE 0)

wut_create_rpx(wiiu_smb_test)


install(FILES "${CMAKE_CURRENT_BINARY_DIR}/wiiu_smb_test.rpx"
        DESTINATION "${CMAKE_INSTALL_PREFIX}")
