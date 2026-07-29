# Odin Thirdparty Bindings + Generator

A collection of Odin bindings for third-party C libraries.

The repository is arranged as an Odin collection:

- `odin/<library>` contains the Odin package and handwritten helpers.
- `recipes/<library>` contains the fetch/build/bindgen recipe for regenerating that package.
- `examples/<library>/<example>` contains standalone example packages.
- `thirdparty.lock.json` describes release artifacts used by `just bootstrap`.

Runtime and link artifacts are not source-of-truth files in git. They are prepared by the recipes, packaged as release assets, and installed into the checkout with:

```powershell
just bootstrap
```

Bindgen tooling is packaged separately because it is only needed when regenerating bindings:

```powershell
just bootstrap-tools
```

On macOS and Linux, install the system libclang package separately when regenerating bindings. The tool artifact should only need the bindgen executable there. On Windows, the tool artifact may also include `libclang.dll`.

Windows recipes look for `BINDGEN_EXE` first, then `.thirdparty-tools\bindgen\windows-amd64\bindgen.exe`.

Runtime/link artifacts are published under the `snapshot-libs` pre-release, while bindgen tool artifacts are published under the `snapshot-tools` pre-release. The configured artifact rows are `windows-amd64`, `darwin-arm64`, and `web-wasm32`.

Use the collection from this repository root with:

```powershell
just bootstrap
odin check odin\capstone -no-entry-point
odin check odin\ffmpeg -no-entry-point
odin check odin\sokol\app -no-entry-point
odin run examples\capstone\disasm_basic -collection:thirdparty=odin -define:CAPSTONE_STATIC=true
```

Examples import packages through the collection:

```odin
import cs "thirdparty:capstone"
import ff "thirdparty:ffmpeg"
import sapp "thirdparty:sokol/app"
import sg "thirdparty:sokol/gfx"
```

On Windows, FFmpeg runtime DLLs live in `odin\ffmpeg\libs\windows\amd64`. Add that directory to `PATH` before running FFmpeg examples:

```powershell
$env:PATH = "$(Resolve-Path .\odin\ffmpeg\libs\windows\amd64);$env:PATH"
odin run examples\ffmpeg\raylib_video -collection:thirdparty=odin -- -video:"path\to\video.mp4"
```

Sokol is arranged as subpackages such as `thirdparty:sokol/app`, `thirdparty:sokol/gfx`, and `thirdparty:sokol/imgui`. Its C sources and generated Odin bindings are owned by this repository. The recipe fetches the pinned Dear ImGui `v1.92.8-docking` sources and builds them with the matching generated Dear Bindings bridge.

The `justfile` wraps the common workflows:

```powershell
just bootstrap
just bootstrap-tools
just check
just build-capstone
just build-ffmpeg
just build-sokol
just build-sokol-wasm
just package-release windows-amd64
just package-tools path\to\bindgen.exe path\to\libclang.dll
```

`just package-release <platform>` creates `dist/odin-thirdparty-artifacts-<platform>.zip` from locally staged runtime/link binaries and updates `thirdparty.lock.json` with the archive hash and size. `just package-tools <bindgen> [libclang]` creates the matching bindgen tool artifact. Upload those zips to the release tags configured in `thirdparty.lock.json` before expecting the bootstrap commands to work from a fresh checkout.

The compilation graph is implemented in `build.zig`, with `just` providing short aliases. It pins and fetches Capstone 5.0.9 and Dear ImGui 1.92.8-docking through `build.zig.zon`, compiles native libraries with Zig, and stages them under the exact paths expected by the Odin bindings.

Use Zig `0.17.0-dev.1413+addc3c3b8` or newer. The supported build platform keys are:

- `windows-amd64`
- `darwin-amd64`
- `darwin-arm64`
- `linux-amd64`
- `web-wasm32`

The platform defaults to the native host. It can be selected explicitly:

```powershell
just build-sokol windows-amd64
zig build all -Dplatform=darwin-arm64
```

Sokol also supports a `web-wasm32` artifact built with Emscripten 6.0.2. Set `EMSDK` or pass its path to the `just` recipe:

```powershell
just build-capstone
just build-sokol
just build-sokol-wasm E:\dev\tools\emsdk
just example-sokol-wasm E:\dev\tools\emsdk
just package-release web-wasm32
just bootstrap web-wasm32
```

`just example-sokol-wasm` writes complete `clear` and `imgui` HTML/JavaScript/WASM smoke tests under `recipes/sokol/build/example-wasm`.

Binding regeneration is intentionally separate from normal compilation because it rewrites checked-in Odin source:

```powershell
just bindings
```

FFmpeg remains a Windows-only prebuilt SDK recipe rather than a source compilation. Zig owns its top-level build step and delegates only SDK acquisition/staging and binding cleanup to a portable Python helper. The old batch recipes and superseded Sokol Python/CMake orchestration have been removed.
