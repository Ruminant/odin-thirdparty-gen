// Odin exports `_start` instead of the conventional C `main` entry point.
// Firefox currently rejects TextDecoder views backed by growable WASM memory.
// Force Emscripten's built-in UTF-8 fallback while retaining live growable views.
UTF8Decoder = null;

Module['onRuntimeInitialized'] = () => {
  try {
    Module['__start']();
  } catch (error) {
    // Sokol hands control to Emscripten's requestAnimationFrame loop this way.
    if (error !== 'unwind') throw error;
  }
};
