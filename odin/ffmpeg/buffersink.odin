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


@(default_calling_convention="c")
foreign lib {
	/**
	* Get a frame with filtered data from sink and put it in frame.
	*
	* @param ctx    pointer to a buffersink or abuffersink filter context.
	* @param frame  pointer to an allocated frame that will be filled with data.
	*               The data must be freed using av_frame_unref() / av_frame_free()
	* @param flags  a combination of AV_BUFFERSINK_FLAG_* flags
	*
	* @return  >= 0 in for success, a negative AVERROR code for failure.
	*/
	av_buffersink_get_frame_flags :: proc(ctx: ^AVFilterContext, frame: ^AVFrame, flags: i32) -> i32 ---
}

/**
* Tell av_buffersink_get_buffer_ref() to read video/samples buffer
* reference, but not remove it from the buffer. This is useful if you
* need only to read a video/samples buffer, without to fetch it.
*/
AV_BUFFERSINK_FLAG_PEEK :: 1

/**
* Tell av_buffersink_get_buffer_ref() not to request a frame from its input.
* If a frame is already buffered, it is read (and removed from the buffer),
* but if no frame is present, return AVERROR(EAGAIN).
*/
AV_BUFFERSINK_FLAG_NO_REQUEST :: 2

@(default_calling_convention="c")
foreign lib {
	/**
	* Set the frame size for an audio buffer sink.
	*
	* All calls to av_buffersink_get_buffer_ref will return a buffer with
	* exactly the specified number of samples, or AVERROR(EAGAIN) if there is
	* not enough. The last buffer at EOF will be padded with 0.
	*/
	av_buffersink_set_frame_size :: proc(ctx: ^AVFilterContext, frame_size: u32) ---

	/**
	* @defgroup lavfi_buffersink_accessors Buffer sink accessors
	* Get the properties of the stream
	* @{
	*/
	av_buffersink_get_type                :: proc(ctx: ^AVFilterContext) -> AVMediaType ---
	av_buffersink_get_time_base           :: proc(ctx: ^AVFilterContext) -> AVRational ---
	av_buffersink_get_format              :: proc(ctx: ^AVFilterContext) -> i32 ---
	av_buffersink_get_frame_rate          :: proc(ctx: ^AVFilterContext) -> AVRational ---
	av_buffersink_get_w                   :: proc(ctx: ^AVFilterContext) -> i32 ---
	av_buffersink_get_h                   :: proc(ctx: ^AVFilterContext) -> i32 ---
	av_buffersink_get_sample_aspect_ratio :: proc(ctx: ^AVFilterContext) -> AVRational ---
	av_buffersink_get_colorspace          :: proc(ctx: ^AVFilterContext) -> AVColorSpace ---
	av_buffersink_get_color_range         :: proc(ctx: ^AVFilterContext) -> AVColorRange ---
	av_buffersink_get_alpha_mode          :: proc(ctx: ^AVFilterContext) -> AVAlphaMode ---
	av_buffersink_get_channels            :: proc(ctx: ^AVFilterContext) -> i32 ---
	av_buffersink_get_ch_layout           :: proc(ctx: ^AVFilterContext, ch_layout: ^AVChannelLayout) -> i32 ---
	av_buffersink_get_sample_rate         :: proc(ctx: ^AVFilterContext) -> i32 ---
	av_buffersink_get_hw_frames_ctx       :: proc(ctx: ^AVFilterContext) -> ^AVBufferRef ---
	av_buffersink_get_side_data           :: proc(ctx: ^AVFilterContext, nb_side_data: ^i32) -> ^^AVFrameSideData ---

	/**
	* Get a frame with filtered data from sink and put it in frame.
	*
	* @param ctx pointer to a context of a buffersink or abuffersink AVFilter.
	* @param frame pointer to an allocated frame that will be filled with data.
	*              The data must be freed using av_frame_unref() / av_frame_free()
	*
	* @return
	*         - >= 0 if a frame was successfully returned.
	*         - AVERROR(EAGAIN) if no frames are available at this point; more
	*           input frames must be added to the filtergraph to get more output.
	*         - AVERROR_EOF if there will be no more output frames on this sink.
	*         - A different negative AVERROR code in other failure cases.
	*/
	av_buffersink_get_frame :: proc(ctx: ^AVFilterContext, frame: ^AVFrame) -> i32 ---

	/**
	* Same as av_buffersink_get_frame(), but with the ability to specify the number
	* of samples read. This function is less efficient than
	* av_buffersink_get_frame(), because it copies the data around.
	*
	* @param ctx pointer to a context of the abuffersink AVFilter.
	* @param frame pointer to an allocated frame that will be filled with data.
	*              The data must be freed using av_frame_unref() / av_frame_free()
	*              frame will contain exactly nb_samples audio samples, except at
	*              the end of stream, when it can contain less than nb_samples.
	*
	* @return The return codes have the same meaning as for
	*         av_buffersink_get_frame().
	*
	* @warning do not mix this function with av_buffersink_get_frame(). Use only one or
	* the other with a single sink, not both.
	*/
	av_buffersink_get_samples :: proc(ctx: ^AVFilterContext, frame: ^AVFrame, nb_samples: i32) -> i32 ---
}

