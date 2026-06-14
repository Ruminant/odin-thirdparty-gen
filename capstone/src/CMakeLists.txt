cmake_minimum_required(VERSION 3.20)

project(odin_thirdparty_capstone LANGUAGES C)

include(FetchContent)

set(BUILD_SHARED_LIBS ON CACHE BOOL "Build Capstone shared library" FORCE)
set(BUILD_STATIC_LIBS ON CACHE BOOL "Build Capstone static library" FORCE)
set(CAPSTONE_BUILD_CSTEST OFF CACHE BOOL "Build Capstone test binary" FORCE)
set(CAPSTONE_BUILD_CSTOOL OFF CACHE BOOL "Build Capstone cstool" FORCE)

FetchContent_Declare(
    capstone
    URL https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.9.tar.gz
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)

FetchContent_MakeAvailable(capstone)

if(TARGET capstone_static)
    set_target_properties(capstone_static PROPERTIES OUTPUT_NAME "capstone_static")
endif()
