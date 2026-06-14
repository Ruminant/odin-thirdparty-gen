package main

import "core:fmt"
import "core:flags"
import "core:os"
import "core:strings"
import "core:mem"
import ff "thirdparty:ffmpeg"

Options :: struct {
	video: string `usage:"input video file"`,
	seconds: f64 `usage:"time in seconds to capture frame"`,
	output: string `usage:"output PNG file"`,
}

write_png :: proc(filename: string, rgb: ^ff.AVFrame) -> bool {

	// FFmpeg treats image formats as codecs too. A single RGB frame can be sent
	// through the PNG encoder and received back as one encoded AVPacket.
	codec := ff.avcodec_find_encoder(ff.AVCodecID.PNG)
	if codec == nil {
		fmt.printf("avcodec_find_encoder for PNG failed\n")
		return false
	}

	// Codec contexts hold the mutable state and options for an encoder/decoder.
	// The codec itself is static description data and must not be freed by us.
	enc := ff.avcodec_alloc_context3(codec)
	if (enc == nil) {
		fmt.printf("avcodec_alloc_context3 failed\n")
		return false
	}
	defer ff.avcodec_free_context(&enc)
	
	pkt := ff.av_packet_alloc()
	if (pkt == nil) {
		fmt.printf("av_packet_alloc failed\n")
		return false
	}
	defer ff.av_packet_free(&pkt)
	

	// The PNG encoder needs to know what kind of frame we are going to send it.
	// The source frame is already RGB24 because grab_png_at_time converts it
	// before calling this helper.
	enc.width = rgb.width
	enc.height = rgb.height
	enc.pix_fmt = (ff.AVPixelFormat)(rgb.format)
	enc.time_base = {num = 1, den = 25}
	
	if ret := ff.avcodec_open2(enc, codec, nil); ret < 0 {
		fmt.printf("avcodec_open2 failed: %d (%s)\n", ret, ff.error_string_temp(ret))
		return false
	}

	rgb.pts = 0

	// The modern codec API is a send/receive state machine. For a still image,
	// one frame in produces one packet out.
	if ret := ff.avcodec_send_frame(enc, rgb); ret < 0 {
		fmt.printf("avcodec_send_frame failed: %d (%s)\n", ret, ff.error_string_temp(ret))
		return false
	}

	if ret := ff.avcodec_receive_packet(enc, pkt); ret < 0 {
		fmt.printf("avcodec_receive_packet failed: %d (%s)\n", ret, ff.error_string_temp(ret))
		return false
	}

	// AVPacket owns a block of encoded bytes. Copy those bytes to disk before
	// av_packet_free releases the packet at the end of this procedure.
	bytes := mem.slice_ptr(pkt.data, int(pkt.size))
	if ok := os.write_entire_file_from_bytes(filename, bytes); ok != nil {
		fmt.printf("Failed to write PNG file: %s\n", filename)
		return false
	}

	return true
}

grab_png_at_time :: proc(video: string, seconds: f64, output: string) {

	avfmt : ^ff.AVFormatContext

	// Convert the Odin string to a null-terminated string for the C API. The
	// clone allocates, so it is paired with delete once avformat_open_input has
	// consumed the path.
	video_path := strings.clone_to_cstring(video)
	defer delete(video_path)

	// Open the container file. This creates an AVFormatContext, which represents
	// the demuxer and top-level media container state.
	if result := ff.avformat_open_input(&avfmt, video_path, nil, nil); result < 0 {
		fmt.printf("avformat_open_input failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}
	defer ff.avformat_close_input(&avfmt)

	// Ask FFmpeg to read enough of the file to discover stream metadata such as
	// codecs, time bases, dimensions, and duration.
	if result := ff.avformat_find_stream_info(avfmt, nil); result < 0 {
		fmt.printf("avformat_find_stream_info failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}

	// A container can hold many streams: video, audio, subtitles, attachments,
	// and so on. Let FFmpeg pick the most suitable video stream.
	video_stream_index := ff.av_find_best_stream(avfmt, ff.AVMediaType.VIDEO, -1, -1, nil, 0)
	if video_stream_index < 0 {
		fmt.printf("av_find_best_stream failed: %d (%s)\n", video_stream_index, ff.error_string_temp(video_stream_index))
		return;
	}
	
	// The format stream owns codec parameters, not a ready-to-use decoder. First
	// look up the decoder implementation for the stream's codec id.
	streams := ([^]^ff.AVStream)(avfmt.streams)
	video_stream := streams[video_stream_index]
	codec := ff.avcodec_find_decoder(video_stream.codecpar.codec_id)
	if codec == nil {
		fmt.printf("avcodec_find_decoder failed: %d (%s)\n", video_stream_index, ff.error_string_temp(video_stream_index))
		return;
	}


	// Allocate decoder state. This is where FFmpeg will keep reference frames,
	// codec private data, pending packets, and other mutable decode state.
	dec := ff.avcodec_alloc_context3(codec)
	if dec == nil {
		fmt.printf("avcodec_alloc_context3 failed: %d (%s)\n", video_stream_index, ff.error_string_temp(video_stream_index))
		return;
	}
	defer ff.avcodec_free_context(&dec)

	// Copy stream parameters into the decoder context before opening it. This is
	// the bridge from container metadata to codec setup.
	if result := ff.avcodec_parameters_to_context(dec, video_stream.codecpar); result < 0 {
		fmt.printf("avcodec_parameters_to_context failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}

	// Open the decoder. After this, packets from the stream can be sent into
	// avcodec_send_packet and decoded frames can be received back.
	if result := ff.avcodec_open2(dec, codec, nil); result < 0 {
		fmt.printf("avcodec_open2 failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}

	// A packet holds compressed data from the container. A frame holds decoded
	// pixels. The RGB frame is our conversion target before PNG encoding.
	pkt := ff.av_packet_alloc()
	defer ff.av_packet_free(&pkt)

	frame := ff.av_frame_alloc()
	defer ff.av_frame_free(&frame)

	rgb := ff.av_frame_alloc()
	defer ff.av_frame_free(&rgb)

	if (pkt == nil || frame == nil || rgb == nil) {
		fmt.printf("av_packet_alloc or av_frame_alloc failed\n")
		return
	}

	// Seek using the container/global time base. Passing stream_index = -1 means
	// seek_target is expressed in AV_TIME_BASE units, i.e. microseconds.
	seek_target := i64(seconds * ff.AV_TIME_BASE)
	if result := ff.av_seek_frame(avfmt, -1, seek_target, ff.AVSEEK_FLAG_BACKWARD); result < 0 {
		fmt.printf("av_seek_frame failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}

	// Seeking invalidates decoder history. Flush so packets read after the seek
	// are decoded without stale frames from before the seek.
	ff.avcodec_flush_buffers(dec)

	// Prepare the output frame for swscale. Most video decoders produce YUV or
	// another codec-native pixel format; PNG wants RGB24, so this frame receives
	// converted pixels with the same dimensions as the decoded video.
	rgb.format = (i32)(ff.AVPixelFormat.RGB24)
	rgb.width = dec.width
	rgb.height = dec.height

	// Allocate writable image buffers for the RGB frame. The alignment argument
	// is a performance/detail choice; 32 is a common FFmpeg example value.
	if result := ff.av_frame_get_buffer(rgb, 32); result < 0 {
		fmt.printf("av_frame_get_buffer failed: %d (%s)\n", result, ff.error_string_temp(result))
		return
	}

	// Prepare the scaling/conversion context. The context chooses the source and
	// destination formats, dimensions, and filtering mode. We will call
	// sws_scale_frame below, so FFmpeg can read/write the AVFrame buffers
	// directly instead of us passing data and linesize arrays by hand.
	sws := ff.sws_getContext(dec.width, dec.height, dec.pix_fmt, rgb.width, rgb.height, (ff.AVPixelFormat)(rgb.format),
		(i32)(ff.SwsFlags.BILINEAR), nil, nil, nil)
	if sws == nil {
		fmt.printf("sws_getContext failed\n")
		return
	}
	defer ff.sws_freeContext(sws)

	got_frame := false

	// Read compressed packets until a decoded video frame reaches or passes the
	// requested timestamp. av_read_frame returns packets from all streams, so
	// non-video packets are ignored.
	outer: for {
		if result := ff.av_read_frame(avfmt, pkt); result < 0 {
			fmt.printf("av_read_frame failed: %d (%s)\n", result, ff.error_string_temp(result))
			break
		}

		if pkt.stream_index != video_stream_index {
			ff.av_packet_unref(pkt)
			continue
		}

		// The decoder API is deliberately split into sending compressed packets
		// and receiving decoded frames. One packet can produce zero, one, or many
		// frames. EAGAIN means "do the other side of the state machine first."
		packet_sent := false
		for !packet_sent {
			ret := ff.avcodec_send_packet(dec, pkt)
			if ret == ff.AVERROR_EAGAIN {
				// The decoder has queued output; receive frames and retry this packet.
			} else if ret < 0 {
				fmt.printf("avcodec_send_packet failed: %d (%s)\n", ret, ff.error_string_temp(ret))
				ff.av_packet_unref(pkt)
				break outer
			} else {
				packet_sent = true
				ff.av_packet_unref(pkt)
			}

			received_frame := false
			for {
				ret = ff.avcodec_receive_frame(dec, frame)

				if ret == ff.AVERROR_EOF {
					if !packet_sent {
						ff.av_packet_unref(pkt)
					}
					break outer
				}
				if ret == ff.AVERROR_EAGAIN {
					break
				}

				if ret < 0 {
					fmt.printf("avcodec_receive_frame failed: %d (%s)\n", ret, ff.error_string_temp(ret))
					if !packet_sent {
						ff.av_packet_unref(pkt)
					}
					return
				}
				received_frame = true

				// Frame timestamps are in the stream's own time base, not seconds.
				// AV_NOPTS_VALUE means the timestamp is unknown; otherwise convert
				// by multiplying by the stream time base as a floating point ratio.
				best_ts := frame.best_effort_timestamp
				if best_ts != ff.AV_NOPTS_VALUE {
					frame_time := (f64)(best_ts) * ff.av_q2d(video_stream.time_base)

					if frame_time + 0.00001 < seconds {
						ff.av_frame_unref(frame)
						continue
					}
				}

				if result := ff.av_frame_make_writable(rgb); result < 0 {
					fmt.printf("av_frame_make_writable failed: %d (%s)\n", result, ff.error_string_temp(result))
					if !packet_sent {
						ff.av_packet_unref(pkt)
					}
					return
				}

				// Convert the decoded frame into our RGB output frame. sws_scale_frame
				// uses the AVFrame metadata and buffers directly, which keeps the
				// Odin call site much cleaner than the older sws_scale pointer API.
				if result := ff.sws_scale_frame(sws, rgb, frame); result < 0 {
					fmt.printf("sws_scale_frame failed: %d (%s)\n", result, ff.error_string_temp(result))
					if !packet_sent {
						ff.av_packet_unref(pkt)
					}
					return
				}

				// The target frame has been found and converted; encode it as PNG.
				if !write_png(output, rgb) {
					ff.av_frame_unref(frame)
					if !packet_sent {
						ff.av_packet_unref(pkt)
					}
					return
				}

				got_frame = true
				ff.av_frame_unref(frame)
				if !packet_sent {
					ff.av_packet_unref(pkt)
				}
				break outer
			}

			if !packet_sent && !received_frame {
				fmt.println("Decoder returned EAGAIN from both send and receive.")
				ff.av_packet_unref(pkt)
				break outer
			}
		}

	}
	
	if !got_frame {
		fmt.printf("No frame found at %f seconds\n", seconds)
	}
}

main :: proc() {
//	open_file_example()
	opt: Options = {seconds=10.0, output="output.png"}
	flags.parse_or_exit(&opt, os.args)
	fmt.printf("input_video: %s\n", opt.video)
	fmt.printf("seconds: %f\n", opt.seconds)
	fmt.printf("output_png: %s\n", opt.output)
	grab_png_at_time(opt.video, opt.seconds, opt.output)
}
