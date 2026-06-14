package main

import c "core:c"
import "core:fmt"
import ff "thirdparty:ffmpeg"


open_file_example :: proc() {
	path := cstring("ffmpeg-empty-output.mkv")

	ctx: ^ff.AVFormatContext
	result := ff.avformat_alloc_output_context2(&ctx, nil, nil, path)
	if result < 0 || ctx == nil {
		fmt.printf("avformat_alloc_output_context2 failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}
	defer ff.avformat_free_context(ctx)

	if ctx.oformat != nil && (ctx.oformat.flags & ff.AVFMT_NOFILE) == 0 {
		result = ff.avio_open(&ctx.pb, path, ff.AVIO_FLAG_WRITE)
		if result < 0 {
			fmt.printf("avio_open failed: %d (%s)\n", result, ff.error_string_temp(result))
			return
		}
		defer ff.avio_closep(&ctx.pb)
	}

	fmt.println("Opened and closed an FFmpeg output context.")
}

main :: proc() {
	open_file_example()
}
