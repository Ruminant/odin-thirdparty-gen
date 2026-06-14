package main

import "core:flags"
import "core:fmt"
import "core:os"
import "core:strings"

import ff "thirdparty:ffmpeg"
import rl "vendor:raylib"

Options :: struct {
	video: string `usage:"input video file"`,
}

Video :: struct {
	format:        ^ff.AVFormatContext,
	decoder:       ^ff.AVCodecContext,
	packet:        ^ff.AVPacket,
	frame:         ^ff.AVFrame,
	rgb:           ^ff.AVFrame,
	scaler:        ^ff.SwsContext,
	stream_index:  i32,
	pending_packet: bool,
	sent_flush:    bool,
	eof:           bool,
}

video_close :: proc(video: ^Video) {
	if video.pending_packet && video.packet != nil {
		ff.av_packet_unref(video.packet)
		video.pending_packet = false
	}

	if video.scaler != nil {
		ff.sws_freeContext(video.scaler)
		video.scaler = nil
	}
	if video.rgb != nil {
		ff.av_frame_free(&video.rgb)
	}
	if video.frame != nil {
		ff.av_frame_free(&video.frame)
	}
	if video.packet != nil {
		ff.av_packet_free(&video.packet)
	}
	if video.decoder != nil {
		ff.avcodec_free_context(&video.decoder)
	}
	if video.format != nil {
		ff.avformat_close_input(&video.format)
	}
}

video_open :: proc(path: string, video: ^Video) -> bool {
	// FFmpeg is a C API, so file paths are passed as null-terminated strings.
	// clone_to_cstring allocates, and avformat_open_input only needs it during
	// the call, so the path can be deleted before this function returns.
	cpath := strings.clone_to_cstring(path)
	defer delete(cpath)

	if result := ff.avformat_open_input(&video.format, cpath, nil, nil); result < 0 {
		fmt.printf("avformat_open_input failed: %d (%s)\n", result, ff.error_string_temp(result))
		video_close(video)
		return false
	}

	// Probe the container so stream codec parameters, dimensions, and time bases
	// are available before we choose a stream and open a decoder.
	if result := ff.avformat_find_stream_info(video.format, nil); result < 0 {
		fmt.printf("avformat_find_stream_info failed: %d (%s)\n", result, ff.error_string_temp(result))
		video_close(video)
		return false
	}

	stream_index := ff.av_find_best_stream(video.format, ff.AVMediaType.VIDEO, -1, -1, nil, 0)
	if stream_index < 0 {
		fmt.printf("av_find_best_stream failed: %d (%s)\n", stream_index, ff.error_string_temp(stream_index))
		video_close(video)
		return false
	}
	video.stream_index = stream_index

	streams := ([^]^ff.AVStream)(video.format.streams)
	stream := streams[stream_index]

	codec := ff.avcodec_find_decoder(stream.codecpar.codec_id)
	if codec == nil {
		fmt.println("avcodec_find_decoder failed")
		video_close(video)
		return false
	}

	// The decoder context owns mutable decode state. Codec parameters copied from
	// the stream tell the decoder what kind of compressed data it will receive.
	video.decoder = ff.avcodec_alloc_context3(codec)
	if video.decoder == nil {
		fmt.println("avcodec_alloc_context3 failed")
		video_close(video)
		return false
	}

	if result := ff.avcodec_parameters_to_context(video.decoder, stream.codecpar); result < 0 {
		fmt.printf("avcodec_parameters_to_context failed: %d (%s)\n", result, ff.error_string_temp(result))
		video_close(video)
		return false
	}

	if result := ff.avcodec_open2(video.decoder, codec, nil); result < 0 {
		fmt.printf("avcodec_open2 failed: %d (%s)\n", result, ff.error_string_temp(result))
		video_close(video)
		return false
	}

	video.packet = ff.av_packet_alloc()
	video.frame = ff.av_frame_alloc()
	video.rgb = ff.av_frame_alloc()
	if video.packet == nil || video.frame == nil || video.rgb == nil {
		fmt.println("av_packet_alloc or av_frame_alloc failed")
		video_close(video)
		return false
	}

	// Raylib can upload RGB24 pixel data directly to an R8G8B8 texture. Ask
	// swscale to convert every decoded frame to that format.
	video.rgb.format = i32(ff.AVPixelFormat.RGB24)
	video.rgb.width = video.decoder.width
	video.rgb.height = video.decoder.height

	// Alignment 1 keeps RGB rows tightly packed as width * 3 bytes. Raylib's
	// UpdateTexture expects tightly packed rows, not FFmpeg padding.
	if result := ff.av_frame_get_buffer(video.rgb, 1); result < 0 {
		fmt.printf("av_frame_get_buffer failed: %d (%s)\n", result, ff.error_string_temp(result))
		video_close(video)
		return false
	}

	video.scaler = ff.sws_getContext(
		video.decoder.width,
		video.decoder.height,
		video.decoder.pix_fmt,
		video.rgb.width,
		video.rgb.height,
		ff.AVPixelFormat(video.rgb.format),
		i32(ff.SwsFlags.BILINEAR),
		nil,
		nil,
		nil,
	)
	if video.scaler == nil {
		fmt.println("sws_getContext failed")
		video_close(video)
		return false
	}

	return true
}

video_send_next_packet :: proc(video: ^Video) -> bool {
	if video.sent_flush {
		return false
	}

	if !video.pending_packet {
		for {
			result := ff.av_read_frame(video.format, video.packet)
			if result == ff.AVERROR_EOF {
				// A nil packet enters decoder draining mode. After this, receive
				// frames until avcodec_receive_frame returns AVERROR_EOF.
				if send_result := ff.avcodec_send_packet(video.decoder, nil); send_result < 0 {
					fmt.printf("avcodec_send_packet(nil) failed: %d (%s)\n", send_result, ff.error_string_temp(send_result))
					video.eof = true
					return false
				}
				video.sent_flush = true
				return true
			}
			if result < 0 {
				fmt.printf("av_read_frame failed: %d (%s)\n", result, ff.error_string_temp(result))
				video.eof = true
				return false
			}

			if video.packet.stream_index != video.stream_index {
				ff.av_packet_unref(video.packet)
				continue
			}

			video.pending_packet = true
			break
		}
	}

	result := ff.avcodec_send_packet(video.decoder, video.packet)
	if result == ff.AVERROR_EAGAIN {
		// The decoder has queued output. Keep this packet alive and let the
		// caller receive frames before trying to send it again.
		return true
	}
	if result < 0 {
		fmt.printf("avcodec_send_packet failed: %d (%s)\n", result, ff.error_string_temp(result))
		ff.av_packet_unref(video.packet)
		video.pending_packet = false
		video.eof = true
		return false
	}

	ff.av_packet_unref(video.packet)
	video.pending_packet = false
	return true
}

video_decode_next_rgb :: proc(video: ^Video) -> bool {
	if video.eof {
		return false
	}

	for {
		result := ff.avcodec_receive_frame(video.decoder, video.frame)
		if result == 0 {
			// The decoded frame is in the codec's native pixel format. Convert it
			// into the persistent RGB24 frame that backs the Raylib texture upload.
			if writable := ff.av_frame_make_writable(video.rgb); writable < 0 {
				fmt.printf("av_frame_make_writable failed: %d (%s)\n", writable, ff.error_string_temp(writable))
				ff.av_frame_unref(video.frame)
				video.eof = true
				return false
			}

			if scaled := ff.sws_scale_frame(video.scaler, video.rgb, video.frame); scaled < 0 {
				fmt.printf("sws_scale_frame failed: %d (%s)\n", scaled, ff.error_string_temp(scaled))
				ff.av_frame_unref(video.frame)
				video.eof = true
				return false
			}

			ff.av_frame_unref(video.frame)
			return true
		}

		if result == ff.AVERROR_EOF {
			video.eof = true
			return false
		}
		if result != ff.AVERROR_EAGAIN {
			fmt.printf("avcodec_receive_frame failed: %d (%s)\n", result, ff.error_string_temp(result))
			video.eof = true
			return false
		}

		// EAGAIN means the decoder needs more compressed input before it can
		// produce another frame.
		if !video_send_next_packet(video) {
			return false
		}
	}
}

fit_rect :: proc(texture_width, texture_height: i32) -> rl.Rectangle {
	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	video_width := f32(texture_width)
	video_height := f32(texture_height)

	scale := screen_width / video_width
	if by_height := screen_height / video_height; by_height < scale {
		scale = by_height
	}

	width := video_width * scale
	height := video_height * scale
	return {
		x = (screen_width - width) * 0.5,
		y = (screen_height - height) * 0.5,
		width = width,
		height = height,
	}
}

main :: proc() {
	options: Options
	flags.parse_or_exit(&options, os.args)
	if options.video == "" {
		fmt.println("Provide an input video file with -video:<path>.")
		return
	}

	video: Video
	if !video_open(options.video, &video) {
		return
	}
	defer video_close(&video)

	rl.InitWindow(video.rgb.width, video.rgb.height, cstring("FFmpeg + Raylib RGB24 video"))
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	// The Raylib Image points at FFmpeg's RGB frame buffer. LoadTextureFromImage
	// copies that first frame-sized block into GPU memory; each decoded frame is
	// then pushed with UpdateTexture.
	image := rl.Image {
		data = video.rgb.data[0],
		width = video.rgb.width,
		height = video.rgb.height,
		mipmaps = 1,
		format = .UNCOMPRESSED_R8G8B8,
	}
	texture := rl.LoadTextureFromImage(image)
	defer rl.UnloadTexture(texture)

	source := rl.Rectangle {
		x = 0,
		y = 0,
		width = f32(texture.width),
		height = f32(texture.height),
	}

	frame_count := 0
	ended := false

	for !rl.WindowShouldClose() {
		// No timing yet: one Raylib frame attempts to decode and display one
		// video frame. This makes playback depend on machine speed and target FPS.
		if !ended {
			if video_decode_next_rgb(&video) {
				rl.UpdateTexture(texture, video.rgb.data[0])
				frame_count += 1
			} else {
				ended = true
			}
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		dest := fit_rect(texture.width, texture.height)
		rl.DrawTexturePro(texture, source, dest, {}, 0, rl.WHITE)

		rl.DrawFPS(10, 10)
		if ended {
			rl.DrawText(cstring("End of video"), 10, 34, 20, rl.RAYWHITE)
		} else {
			rl.DrawText(cstring("Decoding one video frame per draw frame"), 10, 34, 20, rl.RAYWHITE)
		}

		frame_text := fmt.tprintf("frames displayed: %d", frame_count)
		rl.DrawText(strings.clone_to_cstring(frame_text, context.temp_allocator), 10, 58, 20, rl.RAYWHITE)

		rl.EndDrawing()
	}
}
