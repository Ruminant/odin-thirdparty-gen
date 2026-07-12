// Emscripten imports required by Odin's js_wasm32 runtime.
mergeInto(LibraryManager.library, {
  rand_bytes: function (ptr, len) {
    globalThis.crypto.getRandomValues(HEAPU8.subarray(ptr, ptr + len));
  },
  write__deps: ["$UTF8ToString"],
  write: function (fd, ptr, len) {
    const text = UTF8ToString(ptr, len);
    if (fd === 2) console.error(text);
    else console.log(text);
    return len;
  },
});
