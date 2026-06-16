//------------------------------------------------------------------------------
//  simgui/main.odin
//
//  Minimal sokol_imgui + Dear ImGui sample.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import imgui "thirdparty:sokol/imgui/dear"
import sapp "thirdparty:sokol/app"
import sg "thirdparty:sokol/gfx"
import sglue "thirdparty:sokol/glue"
import simgui "thirdparty:sokol/imgui"
import slog "thirdparty:sokol/log"

state: struct {
    pass_action: sg.Pass_Action,
    show_first_window: bool,
    show_second_window: bool,
    some_value: f32,
    my_color: sg.Color
}

backend_name :: proc() -> string {
    switch sg.query_backend() {
        case .D3D11:            return "Direct3D11"
        case .GLCORE:           return "OpenGL"
        case .GLES3:            return "OpenGLES3"
        case .METAL_IOS:        return "Metal iOS"
        case .METAL_MACOS:      return "Metal macOS"
        case .METAL_SIMULATOR:  return "Metal Simulator"
        case .WGPU:             return "WebGPU"
        case .VULKAN:           return "Vulkan"
        case .DUMMY:            return "Dummy"
    }
    return "Unknown"
}

init :: proc "c" () {
    context = runtime.default_context()

    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    simgui.setup({
        logger = { func = slog.func },
    })

    io := imgui.get_io()
    io.ConfigFlags |= imgui.ImGuiConfigFlags_DockingEnable

    state.show_first_window = true
    state.show_second_window = true
    state.pass_action.colors[0] = {
        load_action = .CLEAR,
        clear_value = { r = 0.0, g = 0.5, b = 1.0, a = 1.0 },
    }
    state.my_color = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }
}

frame :: proc "c" () {
    context = runtime.default_context()

    simgui.new_frame({
        width = sapp.width(),
        height = sapp.height(),
        delta_time = sapp.frame_duration(),
        dpi_scale = sapp.dpi_scale(),
    })

    imgui.set_next_window_pos({ x = 10, y = 30 }, imgui.ImGuiCond_Once)
    imgui.set_next_window_size({ x = 400, y = 110 }, imgui.ImGuiCond_Once)
    if imgui.begin("Hello Dear ImGui!", &state.show_first_window) {
        bg := [?]f32 {
            state.pass_action.colors[0].clear_value.r,
            state.pass_action.colors[0].clear_value.g,
            state.pass_action.colors[0].clear_value.b,
        }
        if imgui.color_edit3("Background", &bg) {
            state.pass_action.colors[0].clear_value.r = bg[0]
            state.pass_action.colors[0].clear_value.g = bg[1]
            state.pass_action.colors[0].clear_value.b = bg[2]
        }
        imgui.text("Dear ImGui Version: %s", imgui.get_version())

        imgui.color_edit3("My Color", (^[3]f32)(&state.my_color.r))

        imgui.slider_float("Some Value", &state.some_value, 0.0, 1.0, "%.3f", 1.0)

        if imgui.button("Quit") {
            sapp.quit()
        }

        drawlist := imgui.get_window_draw_list()
        color := imgui.ImGui_GetColorU32ImVec4(imgui.ImVec4{state.my_color.r, state.my_color.g, state.my_color.b, state.my_color.a})
        imgui.add_circle(drawlist, { x = 200, y = 80 }, 30, color, 32, 5.0)

    }
    imgui.end()

    imgui.set_next_window_pos({ x = 50, y = 160 }, imgui.ImGuiCond_Once)
    imgui.set_next_window_size({ x = 400, y = 100 }, imgui.ImGuiCond_Once)
    if imgui.begin("Another Window", &state.show_second_window) {
        imgui.text("Sokol Backend: %s", backend_name())
    }
    imgui.end()

    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    simgui.render()
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    simgui.shutdown()
    sg.shutdown()
}

event :: proc "c" (ev: ^sapp.Event) {
    context = runtime.default_context()
    _ = simgui.handle_event(ev^)
}

main :: proc() {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        event_cb = event,
        width = 800,
        height = 600,
        window_title = "sokol-odin + Dear ImGui",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
