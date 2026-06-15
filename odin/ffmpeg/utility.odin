package ffmpeg

import "core:c"
import "core:strings"

AVERROR_EAGAIN :: i32(-11)
AVERROR_EOF    :: i32(-541478725)
AV_NOPTS_VALUE :: i64(-9223372036854775807 - 1)

av_q2d :: proc(a: AVRational) -> f64 {
    return f64(a.num) / f64(a.den)
}

error_to_buffer :: proc(errnum: i32, buffer: []u8) -> string {
    assert(len(buffer) > 0)

    av_strerror(
        errnum,
        cstring(raw_data(buffer)),
        c.size_t(len(buffer)),
    )

    return string(cstring(raw_data(buffer)))
}

error_string :: proc(errnum: i32, allocator := context.allocator) -> string {
    buffer: [AV_ERROR_MAX_STRING_SIZE]u8
    msg := error_to_buffer(errnum, buffer[:])
    return strings.clone(msg, allocator)
}

error_string_temp :: proc(errnum: i32) -> string {
    return error_string(errnum, context.temp_allocator)
}