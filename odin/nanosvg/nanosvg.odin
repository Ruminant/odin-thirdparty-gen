package nanosvg

import "core:c"

Result :: enum c.int {
	Ok                = 0,
	Invalid_Argument  = 1,
	Allocation_Failed = 2,
	Parse_Failed      = 3,
	Rasterizer_Failed = 4,
}

when ODIN_OS == .Windows {
	NANOSVG_LIB :: #config(NANOSVG_LIB, "libs/windows/amd64/nanosvg.lib")
	foreign import nanosvg_lib {NANOSVG_LIB}
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	// Odin emits an object for the Emscripten link step. Add
	// libs/web/wasm32/libnanosvg.a to that final link command.
	foreign import nanosvg_lib {"env.o"}
} else {
	#panic("NanoSVG is currently supported on Windows and WebAssembly")
}

@(default_calling_convention="c")
foreign nanosvg_lib {
	@(link_name="vs_nanosvg_rasterize_rgba")
	rasterize_rgba :: proc(
		svg_data: rawptr,
		svg_length: c.size_t,
		output_width: c.int,
		output_height: c.int,
		rgba: rawptr,
		stride: c.int,
	) -> Result ---
}
