package sokol_imgui

import "core:c"

import sapp "../app"
import sg "../gfx"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_IMGUI_DEBUG, SOKOL_DEBUG)
SOKOL_IMGUI_USE_GL :: #config(SOKOL_USE_GL, false)
SOKOL_IMGUI_LINK_DCIMGUI :: #config(SOKOL_IMGUI_LINK_DCIMGUI, true)

when ODIN_OS == .Windows {
    when SOKOL_IMGUI_USE_GL {
        when DEBUG { foreign import sokol_imgui_clib { "../libs/windows/amd64/sokol_imgui_windows_x64_gl_debug.lib" } }
        else       { foreign import sokol_imgui_clib { "../libs/windows/amd64/sokol_imgui_windows_x64_gl_release.lib" } }
    } else {
        when DEBUG { foreign import sokol_imgui_clib { "../libs/windows/amd64/sokol_imgui_windows_x64_d3d11_debug.lib" } }
        else       { foreign import sokol_imgui_clib { "../libs/windows/amd64/sokol_imgui_windows_x64_d3d11_release.lib" } }
    }

    when SOKOL_IMGUI_LINK_DCIMGUI {
        IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "dear/lib/windows_amd64/dcimgui_core.lib")
        foreign import dcimgui_core { IMGUI_ODIN_LIB_DCIMGUI_CORE }
    }
} else when ODIN_OS == .Darwin {
    when SOKOL_IMGUI_USE_GL {
        when ODIN_ARCH == .arm64 {
            when DEBUG { foreign import sokol_imgui_clib { "../libs/darwin/arm64/sokol_imgui_macos_arm64_gl_debug.a" } }
            else       { foreign import sokol_imgui_clib { "../libs/darwin/arm64/sokol_imgui_macos_arm64_gl_release.a" } }
        } else {
            when DEBUG { foreign import sokol_imgui_clib { "../libs/darwin/amd64/sokol_imgui_macos_x64_gl_debug.a" } }
            else       { foreign import sokol_imgui_clib { "../libs/darwin/amd64/sokol_imgui_macos_x64_gl_release.a" } }
        }
    } else {
        when ODIN_ARCH == .arm64 {
            when DEBUG { foreign import sokol_imgui_clib { "../libs/darwin/arm64/sokol_imgui_macos_arm64_metal_debug.a" } }
            else       { foreign import sokol_imgui_clib { "../libs/darwin/arm64/sokol_imgui_macos_arm64_metal_release.a" } }
        } else {
            when DEBUG { foreign import sokol_imgui_clib { "../libs/darwin/amd64/sokol_imgui_macos_x64_metal_debug.a" } }
            else       { foreign import sokol_imgui_clib { "../libs/darwin/amd64/sokol_imgui_macos_x64_metal_release.a" } }
        }
    }

    when SOKOL_IMGUI_LINK_DCIMGUI {
        when ODIN_ARCH == .arm64 {
            IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "dear/lib/darwin_arm64/libdcimgui_core.a")
        } else {
            IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "dear/lib/darwin_amd64/libdcimgui_core.a")
        }
        foreign import dcimgui_core { IMGUI_ODIN_LIB_DCIMGUI_CORE, "system:c++" }
    }
} else {
    #panic("sokol_imgui currently has only Windows and Darwin library defaults")
}

@(default_calling_convention="c", link_prefix="simgui_")
foreign sokol_imgui_clib {
    setup :: proc(#by_ptr desc: Desc) ---
    new_frame :: proc(#by_ptr desc: Frame_Desc) ---
    render :: proc() ---
    shutdown :: proc() ---

    imtextureid :: proc(tex_view: sg.View) -> u64 ---
    imtextureid_with_sampler :: proc(tex_view: sg.View, smp: sg.Sampler) -> u64 ---
    texture_view_from_imtextureid :: proc(imtex_id: u64) -> sg.View ---
    sampler_from_imtextureid :: proc(imtex_id: u64) -> sg.Sampler ---

    add_focus_event :: proc(focus: bool) ---
    add_mouse_pos_event :: proc(x: f32, y: f32) ---
    add_touch_pos_event :: proc(x: f32, y: f32) ---
    add_mouse_button_event :: proc(mouse_button: c.int, down: bool) ---
    add_mouse_wheel_event :: proc(wheel_x: f32, wheel_y: f32) ---
    add_key_event :: proc(imgui_key: c.int, down: bool) ---
    add_input_character :: proc(ch: u32) ---
    add_input_characters_utf8 :: proc(chars: cstring) ---
    add_touch_button_event :: proc(mouse_button: c.int, down: bool) ---

    handle_event :: proc(#by_ptr ev: sapp.Event) -> bool ---
    map_keycode :: proc(keycode: sapp.Keycode) -> c.int ---
}

Allocator :: struct {
    alloc_fn: proc "c" (size: c.size_t, user_data: rawptr) -> rawptr,
    free_fn: proc "c" (ptr: rawptr, user_data: rawptr),
    user_data: rawptr,
}

Logger :: struct {
    func: proc "c" (tag: cstring, log_level: u32, log_item_id: u32, message_or_null: cstring, line_nr: u32, filename_or_null: cstring, user_data: rawptr),
    user_data: rawptr,
}

Desc :: struct {
    max_vertices: c.int,
    color_format: sg.Pixel_Format,
    depth_format: sg.Pixel_Format,
    sample_count: c.int,
    ini_filename: cstring,
    no_default_font: bool,
    disable_paste_override: bool,
    disable_set_mouse_cursor: bool,
    disable_windows_resize_from_edges: bool,
    write_alpha_channel: bool,
    allocator: Allocator,
    logger: Logger,
}

Frame_Desc :: struct {
    width: c.int,
    height: c.int,
    delta_time: f64,
    dpi_scale: f32,
}

Font_Tex_Desc :: struct {
    min_filter: sg.Filter,
    mag_filter: sg.Filter,
}

Texture_ID :: u64
