cmake_minimum_required(VERSION 3.25)

project(sokol_dcimgui LANGUAGES CXX)

include(FetchContent)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

set(SOKOL_DCIMGUI_IMGUI_VERSION "1.92.8-docking" CACHE STRING "Dear ImGui version used by Sokol's generated dcimgui bridge")
set(SOKOL_DCIMGUI_IMGUI_URL "https://github.com/ocornut/imgui/archive/refs/tags/v${SOKOL_DCIMGUI_IMGUI_VERSION}.tar.gz" CACHE STRING "Dear ImGui archive URL")
set(SOKOL_DCIMGUI_OUTPUT_DIR "" CACHE PATH "Directory where the built dcimgui_core archive is copied")
set(SOKOL_DCIMGUI_USER_CONFIG "" CACHE FILEPATH "Optional IMGUI_USER_CONFIG header path")

FetchContent_Declare(
    imgui
    URL "${SOKOL_DCIMGUI_IMGUI_URL}"
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(imgui)

set(SOKOL_DCIMGUI_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated_bindings")

add_library(dcimgui_core STATIC
    "${imgui_SOURCE_DIR}/imgui.cpp"
    "${imgui_SOURCE_DIR}/imgui_demo.cpp"
    "${imgui_SOURCE_DIR}/imgui_draw.cpp"
    "${imgui_SOURCE_DIR}/imgui_tables.cpp"
    "${imgui_SOURCE_DIR}/imgui_widgets.cpp"
    "${SOKOL_DCIMGUI_GENERATED_DIR}/dcimgui.cpp"
)

target_compile_features(dcimgui_core PUBLIC cxx_std_11)
target_include_directories(dcimgui_core
    PUBLIC
        "${SOKOL_DCIMGUI_GENERATED_DIR}"
        "${imgui_SOURCE_DIR}"
)

if(SOKOL_DCIMGUI_USER_CONFIG)
    target_compile_definitions(dcimgui_core PUBLIC "IMGUI_USER_CONFIG=\"${SOKOL_DCIMGUI_USER_CONFIG}\"")
endif()

if(SOKOL_DCIMGUI_OUTPUT_DIR)
    add_custom_command(TARGET dcimgui_core POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${SOKOL_DCIMGUI_OUTPUT_DIR}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:dcimgui_core>" "${SOKOL_DCIMGUI_OUTPUT_DIR}/$<TARGET_FILE_NAME:dcimgui_core>"
        VERBATIM
    )
endif()
