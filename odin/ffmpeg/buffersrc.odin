/*
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */
package ffmpeg

when ODIN_OS == .Windows {
	foreign import lib {
		"libs/windows/amd64/avcodec.lib",
		"libs/windows/amd64/avdevice.lib",
		"libs/windows/amd64/avfilter.lib",
		"libs/windows/amd64/avformat.lib",
		"libs/windows/amd64/avutil.lib",
		"libs/windows/amd64/swresample.lib",
		"libs/windows/amd64/swscale.lib",
	}
} else {
	foreign import lib {
		"system:avcodec",
		"system:avdevice",
		"system:avfilter",
		"system:avformat",
		"system:avutil",
		"system:swresample",
		"system:swscale",
	}
}

_ :: lib


AV_BUFFERSRC_FLAG_NO_CHECK_FORMAT :: 1
AV_BUFFERSRC_FLAG_PUSH            :: 4
AV_BUFFERSRC_FLAG_KEEP_REF        :: 8

@(default_calling_convention="c")
foreign lib {
	/**
	* Get the number of failed requests.
	*
	* A failed request is when the request_frame method is called while no
	* frame is present in the buffer.
	* The number is reset when a frame is added.
	*/
	av_buffersrc_get_nb_failed_requests :: proc(buffer_src: ^AVFilterContext) -> u32 ---
}

/**
* This structure contains the parameters describing the frames that will be
* passed to this filter.
*
* It should be allocated with av_buffersrc_parameters_alloc() and freed with
* av_free(). All the allocated fields in it remain owned by the caller.
*/
AVBufferSrcParameters :: struct {
	/**
	* video: the pixel format, value corresponds to enum AVPixelFormat
	* audio: the sample format, value corresponds to enum AVSampleFormat
	*/
	format: i32,

	/**
	* The timebase to be used for the timestamps on the input frames.
	*/
	time_base: AVRational,

	/**
	* Video only, the display dimensions of the input frames.
	*/
	width, height: i32,

	/**
	* Video only, the sample (pixel) aspect ratio.
	*/
	sample_aspect_ratio: AVRational,

	/**
	* Video only, the frame rate of the input video. This field must only be
	* set to a non-zero value if input stream has a known constant framerate
	* and should be left at its initial value if the framerate is variable or
	* unknown.
	*/
	frame_rate: AVRational,

	/**
	* Video with a hwaccel pixel format only. This should be a reference to an
	* AVHWFramesContext instance describing the input frames.
	*/
	hw_frames_ctx: ^AVBufferRef,

	/**
	* Audio only, the audio sampling rate in samples per second.
	*/
	sample_rate: i32,

	/**
	* Audio only, the audio channel layout
	*/
	ch_layout: AVChannelLayout,

	/**
	* Video only, the YUV colorspace and range.
	*/
	color_space:  AVColorSpace,
	color_range:  AVColorRange,
	side_data:    ^^AVFrameSideData,
	nb_side_data: i32,

	/**
	* Video only, the alpha mode.
	*/
	alpha_mode: AVAlphaMode,
}

@(default_calling_convention="c")
foreign lib {
	/**
	* Allocate a new AVBufferSrcParameters instance. It should be freed by the
	* caller with av_free().
	*/
	av_buffersrc_parameters_alloc :: proc() -> ^AVBufferSrcParameters ---

	/**
	* Initialize the buffersrc or abuffersrc filter with the provided parameters.
	* This function may be called multiple times, the later calls override the
	* previous ones. Some of the parameters may also be set through AVOptions, then
	* whatever method is used last takes precedence.
	*
	* @param ctx an instance of the buffersrc or abuffersrc filter
	* @param param the stream parameters. The frames later passed to this filter
	*              must conform to those parameters. All the allocated fields in
	*              param remain owned by the caller, libavfilter will make internal
	*              copies or references when necessary.
	* @return 0 on success, a negative AVERROR code on failure.
	*/
	av_buffersrc_parameters_set :: proc(ctx: ^AVFilterContext, param: ^AVBufferSrcParameters) -> i32 ---

	/**
	* Add a frame to the buffer source.
	*
	* @param ctx   an instance of the buffersrc filter
	* @param frame frame to be added. If the frame is reference counted, this
	* function will make a new reference to it. Otherwise the frame data will be
	* copied.
	*
	* @return 0 on success, a negative AVERROR on error
	*
	* This function is equivalent to av_buffersrc_add_frame_flags() with the
	* AV_BUFFERSRC_FLAG_KEEP_REF flag.
	*/
	av_buffersrc_write_frame :: proc(ctx: ^AVFilterContext, frame: ^AVFrame) -> i32 ---

	/**
	* Add a frame to the buffer source.
	*
	* @param ctx   an instance of the buffersrc filter
	* @param frame frame to be added. If the frame is reference counted, this
	* function will take ownership of the reference(s) and reset the frame.
	* Otherwise the frame data will be copied. If this function returns an error,
	* the input frame is not touched.
	*
	* @return 0 on success, a negative AVERROR on error.
	*
	* @note the difference between this function and av_buffersrc_write_frame() is
	* that av_buffersrc_write_frame() creates a new reference to the input frame,
	* while this function takes ownership of the reference passed to it.
	*
	* This function is equivalent to av_buffersrc_add_frame_flags() without the
	* AV_BUFFERSRC_FLAG_KEEP_REF flag.
	*/
	av_buffersrc_add_frame :: proc(ctx: ^AVFilterContext, frame: ^AVFrame) -> i32 ---

	/**
	* Add a frame to the buffer source.
	*
	* By default, if the frame is reference-counted, this function will take
	* ownership of the reference(s) and reset the frame. This can be controlled
	* using the flags.
	*
	* If this function returns an error, the input frame is not touched.
	*
	* @param buffer_src  pointer to a buffer source context
	* @param frame       a frame, or NULL to mark EOF
	* @param flags       a combination of AV_BUFFERSRC_FLAG_*
	* @return            >= 0 in case of success, a negative AVERROR code
	*                    in case of failure
	*/
	av_buffersrc_add_frame_flags :: proc(buffer_src: ^AVFilterContext, frame: ^AVFrame, flags: i32) -> i32 ---

	/**
	* Close the buffer source after EOF.
	*
	* This is similar to passing NULL to av_buffersrc_add_frame_flags()
	* except it takes the timestamp of the EOF, i.e. the timestamp of the end
	* of the last frame.
	*/
	av_buffersrc_close :: proc(ctx: ^AVFilterContext, pts: i64, flags: u32) -> i32 ---

	/**
	* Returns 0 or a negative AVERROR code. Currently, this will only ever
	* return AVERROR(EOF), to indicate that the buffer source has been closed,
	* either as a result of av_buffersrc_close(), or because the downstream
	* filter is no longer accepting new data.
	*/
	av_buffersrc_get_status :: proc(ctx: ^AVFilterContext) -> i32 ---
}

