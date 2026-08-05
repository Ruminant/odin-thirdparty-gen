const std = @import("std");
const builtin = @import("builtin");

const Build = std.Build;
const OptimizeMode = std.builtin.OptimizeMode;

const Platform = struct {
    key: []const u8,
    os: std.Target.Os.Tag,
    arch: std.Target.Cpu.Arch,
    abi: std.Target.Abi,
    odin_os: []const u8,
    odin_arch: []const u8,
    library_arch: []const u8,

    fn nativeTarget(self: Platform, b: *Build) Build.ResolvedTarget {
        return b.resolveTargetQuery(.{
            .cpu_arch = self.arch,
            .os_tag = self.os,
            .abi = self.abi,
        });
    }

    fn isWasm(self: Platform) bool {
        return self.os == .emscripten;
    }
};

const SokolBackend = struct {
    name: []const u8,
    define: []const u8,
};

const sokol_modules = [_][]const u8{
    "log",       "app",   "gfx", "glue",  "time",  "audio",
    "debugtext", "shape", "gl",  "fetch", "imgui",
};

const imgui_sources = [_][]const u8{
    "imgui.cpp",
    "imgui_demo.cpp",
    "imgui_draw.cpp",
    "imgui_tables.cpp",
    "imgui_widgets.cpp",
};

const capstone_sources = [_][]const u8{
    "cs.c",
    "Mapping.c",
    "MCInst.c",
    "MCInstrDesc.c",
    "MCRegisterInfo.c",
    "SStream.c",
    "utils.c",
    "arch/ARM/ARMDisassembler.c",
    "arch/ARM/ARMInstPrinter.c",
    "arch/ARM/ARMMapping.c",
    "arch/ARM/ARMModule.c",
    "arch/AArch64/AArch64BaseInfo.c",
    "arch/AArch64/AArch64Disassembler.c",
    "arch/AArch64/AArch64InstPrinter.c",
    "arch/AArch64/AArch64Mapping.c",
    "arch/AArch64/AArch64Module.c",
    "arch/Mips/MipsDisassembler.c",
    "arch/Mips/MipsInstPrinter.c",
    "arch/Mips/MipsMapping.c",
    "arch/Mips/MipsModule.c",
    "arch/PowerPC/PPCDisassembler.c",
    "arch/PowerPC/PPCInstPrinter.c",
    "arch/PowerPC/PPCMapping.c",
    "arch/PowerPC/PPCModule.c",
    "arch/X86/X86Disassembler.c",
    "arch/X86/X86DisassemblerDecoder.c",
    "arch/X86/X86IntelInstPrinter.c",
    "arch/X86/X86InstPrinterCommon.c",
    "arch/X86/X86Mapping.c",
    "arch/X86/X86Module.c",
    "arch/X86/X86ATTInstPrinter.c",
    "arch/Sparc/SparcDisassembler.c",
    "arch/Sparc/SparcInstPrinter.c",
    "arch/Sparc/SparcMapping.c",
    "arch/Sparc/SparcModule.c",
    "arch/SystemZ/SystemZDisassembler.c",
    "arch/SystemZ/SystemZInstPrinter.c",
    "arch/SystemZ/SystemZMapping.c",
    "arch/SystemZ/SystemZModule.c",
    "arch/SystemZ/SystemZMCTargetDesc.c",
    "arch/XCore/XCoreDisassembler.c",
    "arch/XCore/XCoreInstPrinter.c",
    "arch/XCore/XCoreMapping.c",
    "arch/XCore/XCoreModule.c",
    "arch/M68K/M68KDisassembler.c",
    "arch/M68K/M68KInstPrinter.c",
    "arch/M68K/M68KModule.c",
    "arch/TMS320C64x/TMS320C64xDisassembler.c",
    "arch/TMS320C64x/TMS320C64xInstPrinter.c",
    "arch/TMS320C64x/TMS320C64xMapping.c",
    "arch/TMS320C64x/TMS320C64xModule.c",
    "arch/M680X/M680XDisassembler.c",
    "arch/M680X/M680XInstPrinter.c",
    "arch/M680X/M680XModule.c",
    "arch/EVM/EVMDisassembler.c",
    "arch/EVM/EVMInstPrinter.c",
    "arch/EVM/EVMMapping.c",
    "arch/EVM/EVMModule.c",
    "arch/WASM/WASMDisassembler.c",
    "arch/WASM/WASMInstPrinter.c",
    "arch/WASM/WASMMapping.c",
    "arch/WASM/WASMModule.c",
    "arch/MOS65XX/MOS65XXModule.c",
    "arch/MOS65XX/MOS65XXDisassembler.c",
    "arch/BPF/BPFDisassembler.c",
    "arch/BPF/BPFInstPrinter.c",
    "arch/BPF/BPFMapping.c",
    "arch/BPF/BPFModule.c",
    "arch/RISCV/RISCVDisassembler.c",
    "arch/RISCV/RISCVInstPrinter.c",
    "arch/RISCV/RISCVMapping.c",
    "arch/RISCV/RISCVModule.c",
    "arch/SH/SHDisassembler.c",
    "arch/SH/SHInstPrinter.c",
    "arch/SH/SHModule.c",
    "arch/TriCore/TriCoreDisassembler.c",
    "arch/TriCore/TriCoreInstPrinter.c",
    "arch/TriCore/TriCoreMapping.c",
    "arch/TriCore/TriCoreModule.c",
};

const capstone_defines = [_][]const u8{
    "CAPSTONE_USE_SYS_DYN_MEM",
    "CAPSTONE_ARM_SUPPORT",
    "CAPSTONE_HAS_ARM",
    "CAPSTONE_ARM64_SUPPORT",
    "CAPSTONE_HAS_ARM64",
    "CAPSTONE_M68K_SUPPORT",
    "CAPSTONE_HAS_M68K",
    "CAPSTONE_MIPS_SUPPORT",
    "CAPSTONE_HAS_MIPS",
    "CAPSTONE_PPC_SUPPORT",
    "CAPSTONE_HAS_POWERPC",
    "CAPSTONE_SPARC_SUPPORT",
    "CAPSTONE_HAS_SPARC",
    "CAPSTONE_SYSZ_SUPPORT",
    "CAPSTONE_HAS_SYSZ",
    "CAPSTONE_XCORE_SUPPORT",
    "CAPSTONE_HAS_XCORE",
    "CAPSTONE_X86_SUPPORT",
    "CAPSTONE_HAS_X86",
    "CAPSTONE_TMS320C64X_SUPPORT",
    "CAPSTONE_HAS_TMS320C64X",
    "CAPSTONE_M680X_SUPPORT",
    "CAPSTONE_HAS_M680X",
    "CAPSTONE_EVM_SUPPORT",
    "CAPSTONE_HAS_EVM",
    "CAPSTONE_MOS65XX_SUPPORT",
    "CAPSTONE_HAS_MOS65XX",
    "CAPSTONE_WASM_SUPPORT",
    "CAPSTONE_HAS_WASM",
    "CAPSTONE_BPF_SUPPORT",
    "CAPSTONE_HAS_BPF",
    "CAPSTONE_RISCV_SUPPORT",
    "CAPSTONE_HAS_RISCV",
    "CAPSTONE_SH_SUPPORT",
    "CAPSTONE_HAS_SH",
    "CAPSTONE_TRICORE_SUPPORT",
    "CAPSTONE_HAS_TRICORE",
};

const capstone_public_headers = [_][]const u8{
    "arm.h",        "arm64.h",   "bpf.h",  "capstone.h", "evm.h",
    "m680x.h",      "m68k.h",    "mips.h", "mos65xx.h",  "platform.h",
    "ppc.h",        "riscv.h",   "sh.h",   "sparc.h",    "systemz.h",
    "tms320c64x.h", "tricore.h", "wasm.h", "x86.h",      "xcore.h",
};

pub fn build(b: *Build) !void {
    const platform = resolvePlatform(b);
    const python = b.option([]const u8, "python", "Python executable used by code-generation helpers") orelse
        if (builtin.os.tag == .windows) "py" else "python3";
    const odin = b.option([]const u8, "odin", "Path to the Odin compiler") orelse "odin";
    const emsdk = b.option([]const u8, "emsdk", "Path to an activated Emscripten SDK");

    const all = b.step("all", "Build all libraries available for the selected platform");
    const checks = addOdinChecks(b, odin);
    const bindings = b.step("bindings", "Regenerate Capstone and FFmpeg Odin bindings");

    if (platform.isWasm()) {
        const sokol_wasm = try addSokolWasm(b, emsdk);
        all.dependOn(sokol_wasm);
        b.step("sokol", "Build Sokol for the selected platform").dependOn(sokol_wasm);
        b.step("sokol-wasm", "Build Sokol and Dear ImGui WebAssembly archives").dependOn(sokol_wasm);

        const examples = try addSokolWasmExamples(b, odin, python, emsdk, sokol_wasm);
        b.step("sokol-wasm-examples", "Build the Sokol browser smoke tests").dependOn(examples);
    } else {
        const capstone = addCapstone(b, platform);
        const sokol = addSokolNative(b, platform);
        all.dependOn(capstone);
        all.dependOn(sokol);
        b.step("capstone", "Build Capstone for the selected native platform").dependOn(capstone);
        b.step("sokol", "Build Sokol and Dear ImGui for the selected native platform").dependOn(sokol);

        const capstone_bindings = addPythonRecipe(
            b,
            python,
            "recipes/capstone/build_bindings.py",
            &.{ "--skip-build", "--skip-checks" },
        );
        capstone_bindings.step.dependOn(capstone);
        bindings.dependOn(&capstone_bindings.step);

        if (platform.os == .windows) {
            const ffmpeg = addFfmpeg(b, python, true);
            all.dependOn(ffmpeg);
            b.step("ffmpeg", "Fetch and stage the Windows FFmpeg SDK").dependOn(ffmpeg);
            const ffmpeg_bindings = addFfmpeg(b, python, false);
            bindings.dependOn(ffmpeg_bindings);
        } else {
            _ = b.step("ffmpeg", "FFmpeg prebuilt recipe is currently Windows-only");
        }
    }

    b.getInstallStep().dependOn(all);
    b.step("check", "Check all Odin packages and examples").dependOn(checks);
}

fn resolvePlatform(b: *Build) Platform {
    const requested = b.option([]const u8, "platform", "Artifact platform key (windows-amd64, darwin-amd64, darwin-arm64, linux-amd64, web-wasm32)");
    const key = requested orelse switch (builtin.os.tag) {
        .windows => "windows-amd64",
        .macos => if (builtin.cpu.arch == .aarch64) "darwin-arm64" else "darwin-amd64",
        .linux => "linux-amd64",
        else => @panic("unsupported host platform; pass -Dplatform explicitly"),
    };
    if (std.mem.eql(u8, key, "windows-amd64")) return .{
        .key = key,
        .os = .windows,
        .arch = .x86_64,
        .abi = .msvc,
        .odin_os = "windows",
        .odin_arch = "amd64",
        .library_arch = "x64",
    };
    if (std.mem.eql(u8, key, "darwin-amd64")) return .{
        .key = key,
        .os = .macos,
        .arch = .x86_64,
        .abi = .none,
        .odin_os = "darwin",
        .odin_arch = "amd64",
        .library_arch = "x64",
    };
    if (std.mem.eql(u8, key, "darwin-arm64")) return .{
        .key = key,
        .os = .macos,
        .arch = .aarch64,
        .abi = .none,
        .odin_os = "darwin",
        .odin_arch = "arm64",
        .library_arch = "arm64",
    };
    if (std.mem.eql(u8, key, "linux-amd64")) return .{
        .key = key,
        .os = .linux,
        .arch = .x86_64,
        .abi = .gnu,
        .odin_os = "linux",
        .odin_arch = "amd64",
        .library_arch = "x64",
    };
    if (std.mem.eql(u8, key, "web-wasm32")) return .{
        .key = key,
        .os = .emscripten,
        .arch = .wasm32,
        .abi = .none,
        .odin_os = "web",
        .odin_arch = "wasm32",
        .library_arch = "wasm",
    };
    std.debug.panic("unknown -Dplatform value: {s}", .{key});
}

fn addCapstone(b: *Build, platform: Platform) *Build.Step {
    const target = platform.nativeTarget(b);
    const source = b.dependency("capstone", .{}).path("");
    const stage = b.addUpdateSourceFiles();

    for (capstone_public_headers) |name| {
        stage.addCopyFileToSource(
            source.path(b, b.fmt("include/capstone/{s}", .{name})),
            b.fmt("recipes/capstone/bindgen/input/{s}", .{name}),
        );
    }
    for ([_][]const u8{ "intrin.h", "stdint.h" }) |name| {
        stage.addCopyFileToSource(
            source.path(b, b.fmt("include/windowsce/{s}", .{name})),
            b.fmt("recipes/capstone/bindgen/input/windowsce/{s}", .{name}),
        );
    }

    const static_module = capstoneModule(b, source, target, .ReleaseFast, true);
    const static_lib = b.addLibrary(.{
        .name = "capstone_static",
        .linkage = .static,
        .root_module = static_module,
    });
    stage.addCopyFileToSource(
        static_lib.getEmittedBin(),
        b.fmt("odin/capstone/libs/{s}/{s}/{s}", .{
            platform.odin_os,
            platform.odin_arch,
            if (platform.os == .windows) "capstone_static.lib" else "libcapstone_static.a",
        }),
    );

    const shared_module = capstoneModule(b, source, target, .ReleaseFast, false);
    const shared_lib = b.addLibrary(.{
        .name = "capstone",
        .linkage = .dynamic,
        .version = .{ .major = 5, .minor = 0, .patch = 9 },
        .root_module = shared_module,
    });
    const shared_name = switch (platform.os) {
        .windows => "capstone.dll",
        .macos => "libcapstone.dylib",
        .linux => "libcapstone.so",
        else => unreachable,
    };
    stage.addCopyFileToSource(
        shared_lib.getEmittedBin(),
        b.fmt("odin/capstone/libs/{s}/{s}/{s}", .{ platform.odin_os, platform.odin_arch, shared_name }),
    );
    if (platform.os == .windows) {
        stage.addCopyFileToSource(
            shared_lib.getEmittedImplib(),
            "odin/capstone/libs/windows/amd64/capstone.lib",
        );
    }
    return &stage.step;
}

fn capstoneModule(
    b: *Build,
    source: Build.LazyPath,
    target: Build.ResolvedTarget,
    optimize: OptimizeMode,
    static: bool,
) *Build.Module {
    const module = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    module.addIncludePath(source.path(b, "include"));
    for (capstone_defines) |define| module.addCMacro(define, "1");
    module.addCMacro(if (static) "CAPSTONE_STATIC" else "CAPSTONE_SHARED", "1");
    module.addCSourceFiles(.{
        .root = source,
        .files = &capstone_sources,
        .flags = &.{ "-std=c99", "-Wno-unused-function", "-Wno-unused-variable" },
    });
    return module;
}

fn addSokolNative(b: *Build, platform: Platform) *Build.Step {
    const target = platform.nativeTarget(b);
    const imgui = b.dependency("imgui", .{}).path("");
    const source = b.path("recipes/sokol/source/c");
    const dear = b.path("recipes/sokol/dcimgui/generated_bindings");
    const stage = b.addUpdateSourceFiles();
    const output_root = b.fmt("odin/sokol/libs/{s}/{s}", .{ platform.odin_os, platform.odin_arch });

    const dcimgui_module = b.createModule(.{
        .target = target,
        .optimize = .ReleaseFast,
        .link_libc = true,
    });
    dcimgui_module.addIncludePath(imgui);
    dcimgui_module.addIncludePath(dear);
    dcimgui_module.addCSourceFiles(.{
        .root = imgui,
        .files = &imgui_sources,
        .flags = &.{ "-std=c++11", "-DNDEBUG" },
    });
    dcimgui_module.addCSourceFile(.{
        .file = dear.path(b, "dcimgui.cpp"),
        .flags = &.{ "-std=c++11", "-DNDEBUG" },
    });
    const dcimgui = b.addLibrary(.{
        .name = "dcimgui_core",
        .linkage = .static,
        .root_module = dcimgui_module,
    });
    stage.addCopyFileToSource(
        dcimgui.getEmittedBin(),
        b.fmt("odin/sokol/imgui/dear/lib/{s}_{s}/{s}", .{
            platform.odin_os,
            platform.odin_arch,
            if (platform.os == .windows) "dcimgui_core.lib" else "libdcimgui_core.a",
        }),
    );

    const backends: []const SokolBackend = switch (platform.os) {
        .windows => &.{
            .{ .name = "d3d11", .define = "SOKOL_D3D11" },
            .{ .name = "gl", .define = "SOKOL_GLCORE" },
        },
        .macos => &.{
            .{ .name = "metal", .define = "SOKOL_METAL" },
            .{ .name = "gl", .define = "SOKOL_GLCORE" },
        },
        .linux => &.{.{ .name = "gl", .define = "SOKOL_GLCORE" }},
        else => unreachable,
    };

    for (backends) |backend| {
        inline for (.{ OptimizeMode.Debug, OptimizeMode.ReleaseFast }) |optimize| {
            const mode = if (optimize == .debug) "debug" else "release";
            for (sokol_modules) |name| {
                const module = sokolModule(b, target, optimize, source, dear, imgui, backend, false, platform);
                module.addCSourceFile(.{
                    .file = source.path(b, b.fmt("sokol_{s}.c", .{name})),
                    .flags = sokolLanguageFlags(platform),
                });
                const lib = b.addLibrary(.{
                    .name = b.fmt("sokol_{s}_{s}_{s}", .{ name, backend.name, mode }),
                    .linkage = .static,
                    .root_module = module,
                });
                const filename = if (platform.os == .windows)
                    b.fmt("sokol_{s}_windows_x64_{s}_{s}.lib", .{ name, backend.name, mode })
                else if (platform.os == .macos)
                    b.fmt("sokol_{s}_macos_{s}_{s}_{s}.a", .{ name, platform.library_arch, backend.name, mode })
                else
                    b.fmt("sokol_{s}_linux_x64_gl_{s}.a", .{ name, mode });
                stage.addCopyFileToSource(lib.getEmittedBin(), b.fmt("{s}/{s}", .{ output_root, filename }));
            }

            const combined_module = sokolModule(b, target, optimize, source, dear, imgui, backend, true, platform);
            combined_module.addCSourceFile(.{
                .file = source.path(b, "sokol.c"),
                .flags = sokolLanguageFlags(platform),
            });
            const combined = b.addLibrary(.{
                .name = b.fmt("sokol_{s}_{s}", .{ backend.name, mode }),
                .linkage = .dynamic,
                .root_module = combined_module,
            });
            if (platform.os == .windows) {
                stage.addCopyFileToSource(
                    combined.getEmittedBin(),
                    b.fmt("{s}/sokol_dll_windows_x64_{s}_{s}.dll", .{ output_root, backend.name, mode }),
                );
                stage.addCopyFileToSource(
                    combined.getEmittedImplib(),
                    b.fmt("{s}/sokol_dll_windows_x64_{s}_{s}.lib", .{ output_root, backend.name, mode }),
                );
            } else if (platform.os == .macos) {
                stage.addCopyFileToSource(
                    combined.getEmittedBin(),
                    b.fmt("{s}/sokol_dylib_macos_{s}_{s}_{s}.dylib", .{
                        output_root, platform.library_arch, backend.name, mode,
                    }),
                );
            } else {
                // Linux bindings select a module-named shared object. The combined
                // Sokol DLL exports every module, so stage it under each expected name.
                for (sokol_modules) |name| {
                    stage.addCopyFileToSource(
                        combined.getEmittedBin(),
                        b.fmt("{s}/sokol_{s}_linux_x64_gl_{s}.so", .{ output_root, name, mode }),
                    );
                }
            }
        }
    }
    return &stage.step;
}

fn sokolModule(
    b: *Build,
    target: Build.ResolvedTarget,
    optimize: OptimizeMode,
    source: Build.LazyPath,
    dear: Build.LazyPath,
    imgui: Build.LazyPath,
    backend: SokolBackend,
    dynamic: bool,
    platform: Platform,
) *Build.Module {
    const module = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        // Debug artifacts must remain linkable without Zig's UBSan runtime.
        // _DEBUG and debug info are still enabled below.
        .sanitize_c = .off,
    });
    module.addIncludePath(source);
    module.addIncludePath(dear);
    module.addIncludePath(imgui);
    module.addCMacro("IMPL", "1");
    module.addCMacro(backend.define, "1");
    if (dynamic) module.addCMacro("SOKOL_DLL", "1");
    if (optimize == .debug) module.addCMacro("_DEBUG", "1") else module.addCMacro("NDEBUG", "1");
    if (platform.os == .windows and dynamic) {
        for ([_][]const u8{ "d3d11", "dxgi", "ole32", "user32", "gdi32", "shell32" }) |lib|
            module.linkSystemLibrary(lib, .{});
    } else if (platform.os == .macos and dynamic) {
        for ([_][]const u8{ "Foundation", "CoreGraphics", "Cocoa", "QuartzCore", "CoreAudio", "AudioToolbox" }) |framework|
            module.linkFramework(framework, .{});
        if (std.mem.eql(u8, backend.name, "metal")) {
            module.linkFramework("Metal", .{});
            module.linkFramework("MetalKit", .{});
        } else {
            module.linkFramework("OpenGL", .{});
        }
    } else if (platform.os == .linux and dynamic) {
        for ([_][]const u8{ "GL", "X11", "Xi", "Xcursor", "pthread", "dl", "m" }) |lib|
            module.linkSystemLibrary(lib, .{});
    }
    return module;
}

fn sokolLanguageFlags(platform: Platform) []const []const u8 {
    return if (platform.os == .macos)
        &.{ "-x", "objective-c" }
    else
        &.{};
}

fn addSokolWasm(b: *Build, emsdk_option: ?[]const u8) !*Build.Step {
    const emsdk = emsdk_option orelse
        @panic("web-wasm32 requires -Demsdk=/path/to/emsdk (for example -Demsdk=E:/dev/tools/emsdk)");
    const emcc = emTool(b, emsdk, "emcc");
    const emxx = emTool(b, emsdk, "em++");
    const emar = emTool(b, emsdk, "emar");
    const imgui = b.dependency("imgui", .{}).path("");
    const source = b.path("recipes/sokol/source/c");
    const dear = b.path("recipes/sokol/dcimgui/generated_bindings");
    const stage = b.addUpdateSourceFiles();

    var dcimgui_objects: std.ArrayList(Build.LazyPath) = .empty;
    for (imgui_sources) |name| {
        const compile = b.addSystemCommand(&.{emxx});
        compile.setName(b.fmt("em++ {s}", .{name}));
        compile.addArgs(&.{ "-c", "-O2", "-DNDEBUG", "-std=c++11" });
        compile.addPrefixedDirectoryArg("-I", imgui);
        compile.addPrefixedDirectoryArg("-I", dear);
        compile.addFileArg(imgui.path(b, name));
        compile.addArg("-o");
        try dcimgui_objects.append(b.allocator, compile.addOutputFileArg(b.fmt("{s}.o", .{std.fs.path.stem(name)})));
    }
    const dc_compile = b.addSystemCommand(&.{emxx});
    dc_compile.setName("em++ dcimgui.cpp");
    dc_compile.addArgs(&.{ "-c", "-O2", "-DNDEBUG", "-std=c++11" });
    dc_compile.addPrefixedDirectoryArg("-I", imgui);
    dc_compile.addPrefixedDirectoryArg("-I", dear);
    dc_compile.addFileArg(dear.path(b, "dcimgui.cpp"));
    dc_compile.addArg("-o");
    try dcimgui_objects.append(b.allocator, dc_compile.addOutputFileArg("dcimgui.o"));

    const dc_archive = b.addSystemCommand(&.{ emar, "rcs" });
    dc_archive.setName("emar libdcimgui_core.a");
    const dc_archive_output = dc_archive.addOutputFileArg("libdcimgui_core.a");
    for (dcimgui_objects.items) |object| dc_archive.addFileArg(object);
    stage.addCopyFileToSource(dc_archive_output, "odin/sokol/imgui/dear/lib/web_wasm32/libdcimgui_core.a");

    inline for (.{ OptimizeMode.Debug, OptimizeMode.ReleaseFast }) |optimize| {
        const mode = if (optimize == .debug) "debug" else "release";
        for (sokol_modules) |name| {
            const compile = b.addSystemCommand(&.{emcc});
            compile.setName(b.fmt("emcc sokol_{s} ({s})", .{ name, mode }));
            compile.addArgs(&.{ "-c", "-DIMPL", "-DSOKOL_GLES3" });
            if (optimize == .debug) compile.addArg("-g") else compile.addArgs(&.{ "-O2", "-DNDEBUG" });
            compile.addPrefixedDirectoryArg("-I", source);
            compile.addPrefixedDirectoryArg("-I", dear);
            compile.addPrefixedDirectoryArg("-I", imgui);
            compile.addFileArg(source.path(b, b.fmt("sokol_{s}.c", .{name})));
            compile.addArg("-o");
            const object = compile.addOutputFileArg(b.fmt("sokol_{s}_{s}.o", .{ name, mode }));

            const archive = b.addSystemCommand(&.{ emar, "rcs" });
            archive.setName(b.fmt("emar sokol_{s} ({s})", .{ name, mode }));
            const output = archive.addOutputFileArg(b.fmt("sokol_{s}_wasm_gl_{s}.a", .{ name, mode }));
            archive.addFileArg(object);
            stage.addCopyFileToSource(
                output,
                b.fmt("odin/sokol/libs/web/wasm32/sokol_{s}_wasm_gl_{s}.a", .{ name, mode }),
            );
        }
    }
    return &stage.step;
}

fn addSokolWasmExamples(
    b: *Build,
    odin: []const u8,
    python: []const u8,
    emsdk_option: ?[]const u8,
    libraries: *Build.Step,
) !*Build.Step {
    const emsdk = emsdk_option orelse @panic("sokol-wasm-examples requires -Demsdk");
    const postprocess = b.path("recipes/sokol/postprocess_wasm.py");
    const all = b.step("generated wasm examples", "Internal WebAssembly example aggregation step");
    for ([_][]const u8{ "clear", "imgui" }) |name| {
        const compile = b.addSystemCommand(&.{ odin, "build" });
        compile.setName(b.fmt("odin build {s} (wasm)", .{name}));
        compile.addDirectoryArg(b.path(b.fmt("examples/sokol/{s}", .{name})));
        compile.addArgs(&.{ "-target:js_wasm32", "-build-mode:obj", "-collection:thirdparty=odin" });
        const object = compile.addPrefixedOutputFileArg("-out:", b.fmt("{s}.obj", .{name}));
        compile.step.dependOn(libraries);

        const linker = emTool(b, emsdk, if (std.mem.eql(u8, name, "imgui")) "em++" else "emcc");
        const link = b.addSystemCommand(&.{linker});
        link.setName(b.fmt("link {s}.html", .{name}));
        link.addFileArg(object);
        for ([_][]const u8{ "app", "gfx", "glue", "log" }) |module|
            link.addFileArg(b.path(b.fmt("odin/sokol/libs/web/wasm32/sokol_{s}_wasm_gl_release.a", .{module})));
        if (std.mem.eql(u8, name, "imgui")) {
            link.addFileArg(b.path("odin/sokol/libs/web/wasm32/sokol_imgui_wasm_gl_release.a"));
            link.addFileArg(b.path("odin/sokol/imgui/dear/lib/web_wasm32/libdcimgui_core.a"));
        }
        link.addArgs(&.{"--js-library"});
        link.addFileArg(b.path("recipes/sokol/wasm/odin_runtime.js"));
        link.addArgs(&.{"--post-js"});
        link.addFileArg(b.path("recipes/sokol/wasm/odin_start.js"));
        link.addArgs(&.{
            "-sUSE_WEBGL2=1",            "-sFULL_ES3=1",              "-sALLOW_MEMORY_GROWTH=1",
            "-sGROWABLE_ARRAYBUFFERS=0", "-sINITIAL_MEMORY=67108864", "-o",
        });
        const html = link.addOutputFileArg(b.fmt("{s}.html", .{name}));

        const patch = b.addSystemCommand(if (builtin.os.tag == .windows)
            &.{ python, "-3" }
        else
            &.{python});
        patch.setName(b.fmt("postprocess {s}.html", .{name}));
        patch.addFileArg(postprocess);
        patch.addFileArg(html);
        patch.addDirectoryArg(b.path("recipes/sokol/build/example-wasm"));
        patch.addArg(name);
        all.dependOn(&patch.step);
    }
    return all;
}

fn addFfmpeg(b: *Build, python: []const u8, skip_bindgen: bool) *Build.Step {
    if (builtin.os.tag != .windows) return b.step("ffmpeg unavailable", "FFmpeg SDK recipe is Windows-only");
    const command = b.addSystemCommand(&.{ python, "-3" });
    command.addFileArg(b.path("recipes/ffmpeg/build_bindings.py"));
    if (skip_bindgen) command.addArgs(&.{ "--skip-bindgen", "--skip-checks", "--skip-upx" });
    command.setName("stage FFmpeg SDK");
    command.stdio = .inherit;
    return &command.step;
}

fn addPythonRecipe(b: *Build, python: []const u8, script: []const u8, args: []const []const u8) *Build.Step.Run {
    const command = b.addSystemCommand(if (builtin.os.tag == .windows)
        &.{ python, "-3" }
    else
        &.{python});
    command.addFileArg(b.path(script));
    command.addArgs(args);
    command.stdio = .inherit;
    return command;
}

fn addOdinChecks(b: *Build, odin: []const u8) *Build.Step {
    const all = b.step("odin checks", "Internal Odin check aggregation step");
    const packages = [_][]const u8{
        "odin/capstone",
        "odin/ffmpeg",
        "odin/sokol/log",
        "odin/sokol/app",
        "odin/sokol/gfx",
        "odin/sokol/glue",
        "odin/sokol/fetch",
        "odin/sokol/time",
        "odin/sokol/audio",
        "odin/sokol/debugtext",
        "odin/sokol/shape",
        "odin/sokol/gl",
        "odin/sokol/helpers",
        "odin/sokol/imgui",
        "odin/sokol/imgui/dear",
    };
    for (packages) |package| {
        const check = b.addSystemCommand(&.{ odin, "check" });
        check.addDirectoryArg(b.path(package));
        check.addArg("-no-entry-point");
        all.dependOn(&check.step);
    }
    for ([_][]const u8{
        "examples/capstone/disasm_basic",
        "examples/ffmpeg/create_empty_output",
        "examples/ffmpeg/grab_png_at_time",
        "examples/ffmpeg/raylib_video",
        "examples/sokol/clear",
        "examples/sokol/fetch",
    }) |package| {
        const check = b.addSystemCommand(&.{ odin, "check" });
        check.addDirectoryArg(b.path(package));
        check.addArg("-collection:thirdparty=odin");
        all.dependOn(&check.step);
    }
    return all;
}

fn emTool(b: *Build, emsdk: []const u8, name: []const u8) []const u8 {
    return b.pathJoin(&.{
        emsdk,
        "upstream",
        "emscripten",
        b.fmt("{s}{s}", .{ name, if (builtin.os.tag == .windows) ".exe" else "" }),
    });
}
