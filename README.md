# Odin Thirdparty Bindings + Generator

A collection of Odin bindings for third-party C libraries.

The repository is arranged as an Odin collection:

- `odin/<library>` contains the Odin package, handwritten helpers, and checked-in binary artifacts.
- `recipes/<library>` contains the fetch/build/bindgen recipe for regenerating that package.
- `examples/<library>/<example>` contains standalone example packages.

Use the collection from this repository root with:

```powershell
odin check odin\capstone -no-entry-point
odin check odin\ffmpeg -no-entry-point
odin run examples\capstone\disasm_basic -collection:thirdparty=odin -define:CAPSTONE_STATIC=true
```

Examples import packages through the collection:

```odin
import cs "thirdparty:capstone"
import ff "thirdparty:ffmpeg"
```

On Windows, FFmpeg runtime DLLs live in `odin\ffmpeg\libs\windows\amd64`. Add that directory to `PATH` before running FFmpeg examples:

```powershell
$env:PATH = "$(Resolve-Path .\odin\ffmpeg\libs\windows\amd64);$env:PATH"
odin run examples\ffmpeg\raylib_video -collection:thirdparty=odin -- -video:"path\to\video.mp4"
```

The `justfile` wraps the common workflows:

```powershell
just check
just capstone
just ffmpeg
```
