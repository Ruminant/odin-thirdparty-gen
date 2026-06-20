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

The first packaged artifact target is `windows-amd64`. Runtime/link artifacts are published under the `snapshot-libs` pre-release, while bindgen tool artifacts are published under the `snapshot` pre-release. macOS artifacts should use the same bootstrap flow once `darwin-amd64` and `darwin-arm64` assets are published.

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

Sokol is arranged as upstream subpackages, for example `thirdparty:sokol/app`, `thirdparty:sokol/gfx`, and `thirdparty:sokol/imgui`. The recipe stages the libraries built by upstream's `build_clibs_windows.cmd`. The `dcimgui*.lib` files in `odin\sokol\libs\windows\amd64` are temporarily vendored by hand because upstream references `dcimgui_core` but does not build or ship it in that archive.

The `justfile` wraps the common workflows:

```powershell
just bootstrap
just bootstrap-tools
just check
just capstone
just ffmpeg
just sokol
just package-release windows-amd64
just package-tools path\to\bindgen.exe path\to\libclang.dll
```

`just package-release <platform>` creates `dist/odin-thirdparty-artifacts-<platform>.zip` from locally staged runtime/link binaries and updates `thirdparty.lock.json` with the archive hash and size. `just package-tools <bindgen> [libclang]` creates the matching bindgen tool artifact. Upload those zips to the release tags configured in `thirdparty.lock.json` before expecting the bootstrap commands to work from a fresh checkout.
