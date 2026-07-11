//------------------------------------------------------------------------------
//  fetch/main.odin
//
//  Minimal sokol_fetch sample which loads a PNG, preferring HTTP on web builds
//  and falling back to disk on native builds.
//------------------------------------------------------------------------------
package main

import "base:runtime"
import "core:c"
import "core:fmt"
import sapp "thirdparty:sokol/app"
import sfetch "thirdparty:sokol/fetch"
import sg "thirdparty:sokol/gfx"
import sglue "thirdparty:sokol/glue"
import slog "thirdparty:sokol/log"

REMOTE_PNG_URL :: "https://godotengine.org/assets/press/icon_color.png"
LOCAL_PNG_PATH :: "examples/sokol/fetch/icon.png"

Fetch_Source :: enum {
    Remote,
    Local,
}

state: struct {
    pass_action: sg.Pass_Action,
    sent: bool,
    done: bool,
    ok: bool,
    failed: bool,
    fallback_pending: bool,
    source: Fetch_Source,
    bytes_read: int,
}

fetch_buffer: [16 * 1024]u8

is_png :: proc(data: sfetch.Range) -> bool {
    signature := [?]u8{0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A}
    if data.ptr == nil || data.size < c.size_t(len(signature)) {
        return false
    }

    bytes := ([^]u8)(data.ptr)
    for i in 0..<len(signature) {
        if bytes[i] != signature[i] {
            return false
        }
    }
    return true
}

source_path :: proc(source: Fetch_Source) -> cstring {
    switch source {
    case .Remote:
        return REMOTE_PNG_URL
    case .Local:
        return LOCAL_PNG_PATH
    }
    return ""
}

send_fetch :: proc(source: Fetch_Source) {
    state.source = source
    state.sent = false
    state.done = false
    state.ok = false
    state.failed = false
    state.fallback_pending = false
    state.bytes_read = 0

    path := source_path(source)
    request := sfetch.Request {
        path = path,
        callback = fetch_callback,
        buffer = {
            ptr = rawptr(raw_data(fetch_buffer[:])),
            size = c.size_t(len(fetch_buffer)),
        },
    }

    handle := sfetch.send(request)
    state.sent = sfetch.handle_valid(handle)
    if state.sent {
        fmt.printf(">> fetching %s\n", path)
    } else if source == .Remote {
        state.fallback_pending = true
        fmt.printf(">> failed to start fetch request for %s, falling back to %s\n", path, LOCAL_PNG_PATH)
    } else {
        state.done = true
        state.failed = true
        fmt.printf(">> failed to start fetch request for %s\n", path)
    }
}

fetch_callback :: proc "c" (response: ^sfetch.Response) {
    context = runtime.default_context()

    if response.fetched {
        state.bytes_read = int(response.data.size)
        state.ok = is_png(response.data)
    }

    if response.finished {
        state.failed = response.failed || !state.ok

        if state.ok {
            state.done = true
            fmt.printf(">> fetched %s (%d bytes, PNG signature ok)\n", source_path(state.source), state.bytes_read)
        } else if state.source == .Remote {
            state.fallback_pending = true
            fmt.printf(">> failed to fetch %s (error: %v), falling back to %s\n", source_path(state.source), response.error_code, LOCAL_PNG_PATH)
        } else {
            state.done = true
            fmt.printf(">> failed to fetch %s (error: %v)\n", source_path(state.source), response.error_code)
        }
    }
}

init :: proc "c" () {
    context = runtime.default_context()

    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    sfetch.setup({
        max_requests = 1,
        num_channels = 1,
        num_lanes = 1,
        logger = { func = slog.func },
    })

    state.pass_action.colors[0] = {
        load_action = .CLEAR,
        clear_value = { r = 0.1, g = 0.1, b = 0.1, a = 1.0 },
    }

    send_fetch(.Remote)
}

frame :: proc "c" () {
    context = runtime.default_context()

    sfetch.dowork()
    if state.fallback_pending {
        send_fetch(.Local)
    }

    if state.done {
        state.pass_action.colors[0].clear_value = state.ok ? { r = 0.0, g = 0.6, b = 0.2, a = 1.0 } : { r = 0.8, g = 0.0, b = 0.0, a = 1.0 }
    }

    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sfetch.shutdown()
    sg.shutdown()
}

main :: proc() {
    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 400,
        height = 300,
        window_title = "sokol_fetch",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })
}
