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

/**
 * @file
 * error code definitions
 */
package ffmpeg

import "core:c"

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


AVERROR_EXPERIMENTAL       :: (-0x2bb2afa8) ///< Requested feature is flagged experimental. Set strict_std_compliance if you really want to use it.
AVERROR_INPUT_CHANGED      :: (-0x636e6701) ///< Input changed between calls. Reconfiguration is required. (can be OR-ed with AVERROR_OUTPUT_CHANGED)
AVERROR_OUTPUT_CHANGED     :: (-0x636e6702) ///< Output changed between calls. Reconfiguration is required. (can be OR-ed with AVERROR_INPUT_CHANGED)
AV_ERROR_MAX_STRING_SIZE :: 64

@(default_calling_convention="c")
foreign lib {
	/**
	* Put a description of the AVERROR code errnum in errbuf.
	* In case of failure the global variable errno is set to indicate the
	* error. Even in case of failure av_strerror() will print a generic
	* error message indicating the errnum provided to errbuf.
	*
	* @param errnum      error code to describe
	* @param errbuf      buffer to which description is written
	* @param errbuf_size the size in bytes of errbuf
	* @return 0 on success, a negative value if a description for errnum
	* cannot be found
	*/
	av_strerror :: proc(errnum: i32, errbuf: cstring, errbuf_size: c.size_t) -> i32 ---
}

