/*
 * AVOptions
 * copyright (c) 2005 Michael Niedermayer <michaelni@gmx.at>
 *
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


/**
* An option type determines:
* - for native access, the underlying C type of the field that an AVOption
*   refers to;
* - for foreign access, the semantics of accessing the option through this API,
*   e.g. which av_opt_get_*() and av_opt_set_*() functions can be called, or
*   what format will av_opt_get()/av_opt_set() expect/produce.
*/
AVOptionType :: enum i32 {
	/**
	* Underlying C type is unsigned int.
	*/
	FLAGS      = 1,

	/**
	* Underlying C type is int.
	*/
	INT        = 2,

	/**
	* Underlying C type is int64_t.
	*/
	INT64      = 3,

	/**
	* Underlying C type is double.
	*/
	DOUBLE     = 4,

	/**
	* Underlying C type is float.
	*/
	FLOAT      = 5,

	/**
	* Underlying C type is a uint8_t* that is either NULL or points to a C
	* string allocated with the av_malloc() family of functions.
	*/
	STRING     = 6,

	/**
	* Underlying C type is AVRational.
	*/
	RATIONAL   = 7,

	/**
	* Underlying C type is a uint8_t* that is either NULL or points to an array
	* allocated with the av_malloc() family of functions. The pointer is
	* immediately followed by an int containing the array length in bytes.
	*/
	BINARY     = 8,

	/**
	* Underlying C type is AVDictionary*.
	*/
	DICT       = 9,

	/**
	* Underlying C type is uint64_t.
	*/
	UINT64     = 10,

	/**
	* Special option type for declaring named constants. Does not correspond to
	* an actual field in the object, offset must be 0.
	*/
	CONST      = 11,

	/**
	* Underlying C type is two consecutive integers.
	*/
	IMAGE_SIZE = 12,

	/**
	* Underlying C type is enum AVPixelFormat.
	*/
	PIXEL_FMT  = 13,

	/**
	* Underlying C type is enum AVSampleFormat.
	*/
	SAMPLE_FMT = 14,

	/**
	* Underlying C type is AVRational.
	*/
	VIDEO_RATE = 15,

	/**
	* Underlying C type is int64_t.
	*/
	DURATION   = 16,

	/**
	* Underlying C type is uint8_t[4].
	*/
	COLOR      = 17,

	/**
	* Underlying C type is int.
	*/
	BOOL       = 18,

	/**
	* Underlying C type is AVChannelLayout.
	*/
	CHLAYOUT   = 19,

	/**
	* Underlying C type is unsigned int.
	*/
	UINT       = 20,

	/**
	* May be combined with another regular option type to declare an array
	* option.
	*
	* For array options, @ref AVOption.offset should refer to a pointer
	* corresponding to the option type. The pointer should be immediately
	* followed by an unsigned int that will store the number of elements in the
	* array.
	*/
	FLAG_ARRAY = 65536,
}

/**
* A generic parameter which can be set by the user for muxing or encoding.
*/
AV_OPT_FLAG_ENCODING_PARAM  :: (1<<0)

/**
* A generic parameter which can be set by the user for demuxing or decoding.
*/
AV_OPT_FLAG_DECODING_PARAM  :: (1<<1)
AV_OPT_FLAG_AUDIO_PARAM     :: (1<<3)
AV_OPT_FLAG_VIDEO_PARAM     :: (1<<4)
AV_OPT_FLAG_SUBTITLE_PARAM  :: (1<<5)

/**
* The option is intended for exporting values to the caller.
*/
AV_OPT_FLAG_EXPORT          :: (1<<6)

/**
* The option may not be set through the AVOptions API, only read.
* This flag only makes sense when AV_OPT_FLAG_EXPORT is also set.
*/
AV_OPT_FLAG_READONLY        :: (1<<7)

/**
* A generic parameter which can be set by the user for bit stream filtering.
*/
AV_OPT_FLAG_BSF_PARAM       :: (1<<8)

/**
* A generic parameter which can be set by the user at runtime.
*/
AV_OPT_FLAG_RUNTIME_PARAM   :: (1<<15)

/**
* A generic parameter which can be set by the user for filtering.
*/
AV_OPT_FLAG_FILTERING_PARAM :: (1<<16)

/**
* Set if option is deprecated, users should refer to AVOption.help text for
* more information.
*/
AV_OPT_FLAG_DEPRECATED      :: (1<<17)

/**
* Set if option constants can also reside in child objects.
*/
AV_OPT_FLAG_CHILD_CONSTS    :: (1<<18)

/**
* May be set as default_val for AV_OPT_TYPE_FLAG_ARRAY options.
*/
AVOptionArrayDef :: struct {
	/**
	* Native access only.
	*
	* Default value of the option, as would be serialized by av_opt_get() (i.e.
	* using the value of sep as the separator).
	*/
	def: cstring,

	/**
	* Minimum number of elements in the array. When this field is non-zero, def
	* must be non-NULL and contain at least this number of elements.
	*/
	size_min: u32,

	/**
	* Maximum number of elements in the array, 0 when unlimited.
	*/
	size_max: u32,

	/**
	* Separator between array elements in string representations of this
	* option, used by av_opt_set() and av_opt_get(). It must be a printable
	* ASCII character, excluding alphanumeric and the backslash. A comma is
	* used when sep=0.
	*
	* The separator and the backslash must be backslash-escaped in order to
	* appear in string representations of the option value.
	*/
	sep: i8,
}

/**
* AVOption
*/
AVOption :: struct {
	name: cstring,

	/**
	* short English help text
	* @todo What about other languages?
	*/
	help: cstring,

	/**
	* Native access only.
	*
	* The offset relative to the context structure where the option
	* value is stored. It should be 0 for named constants.
	*/
	offset: i32,
	type:   AVOptionType,

	default_val: struct #raw_union {
		_i64: i64,
		dbl:  f64,
		str:  cstring,

		/* TODO those are unused now */
		q: AVRational,

		/**
		* Used for AV_OPT_TYPE_FLAG_ARRAY options. May be NULL.
		*
		* Foreign access to some members allowed, as noted in AVOptionArrayDef
		* documentation.
		*/
		arr: ^AVOptionArrayDef,
	},

	min: f64, ///< minimum valid value for the option
	max: f64, ///< maximum valid value for the option

	/**
	* A combination of AV_OPT_FLAG_*.
	*/
	flags: i32,

	/**
	* The logical unit to which the option belongs. Non-constant
	* options and corresponding named constants share the same
	* unit. May be NULL.
	*/
	unit: cstring,
}

/**
* A single allowed range of values, or a single allowed value.
*/
AVOptionRange :: struct {
	str: cstring,

	/**
	* Value range.
	* For string ranges this represents the min/max length.
	* For dimensions this represents the min/max pixel count or width/height in multi-component case.
	*/
	value_min, value_max: f64,

	/**
	* Value's component range.
	* For string this represents the unicode range for chars, 0-127 limits to ASCII.
	*/
	component_min, component_max: f64,

	/**
	* Range flag.
	* If set to 1 the struct encodes a range, if set to 0 a single value.
	*/
	is_range: i32,
}

/**
* List of AVOptionRange structs.
*/
AVOptionRanges :: struct {
	/**
	* Array of option ranges.
	*
	* Most of option types use just one component.
	* Following describes multi-component option types:
	*
	* AV_OPT_TYPE_IMAGE_SIZE:
	* component index 0: range of pixel count (width * height).
	* component index 1: range of width.
	* component index 2: range of height.
	*
	* @note To obtain multi-component version of this structure, user must
	*       provide AV_OPT_MULTI_COMPONENT_RANGE to av_opt_query_ranges or
	*       av_opt_query_ranges_default function.
	*
	* Multi-component range can be read as in following example:
	*
	* @code
	* int range_index, component_index;
	* AVOptionRanges *ranges;
	* AVOptionRange *range[3]; //may require more than 3 in the future.
	* av_opt_query_ranges(&ranges, obj, key, AV_OPT_MULTI_COMPONENT_RANGE);
	* for (range_index = 0; range_index < ranges->nb_ranges; range_index++) {
	*     for (component_index = 0; component_index < ranges->nb_components; component_index++)
	*         range[component_index] = ranges->range[ranges->nb_ranges * component_index + range_index];
	*     //do something with range here.
	* }
	* av_opt_freep_ranges(&ranges);
	* @endcode
	*/
	range: ^^AVOptionRange,

	/**
	* Number of ranges per component.
	*/
	nb_ranges: i32,

	/**
	* Number of components.
	*/
	nb_components: i32,
}

@(default_calling_convention="c")
foreign lib {
	/**
	* Set the values of all AVOption fields to their default values.
	*
	* @param s an AVOption-enabled struct (its first member must be a pointer to AVClass)
	*/
	av_opt_set_defaults :: proc(s: rawptr) ---

	/**
	* Set the values of all AVOption fields to their default values. Only these
	* AVOption fields for which (opt->flags & mask) == flags will have their
	* default applied to s.
	*
	* @param s an AVOption-enabled struct (its first member must be a pointer to AVClass)
	* @param mask combination of AV_OPT_FLAG_*
	* @param flags combination of AV_OPT_FLAG_*
	*/
	av_opt_set_defaults2 :: proc(s: rawptr, mask: i32, flags: i32) ---

	/**
	* Free all allocated objects in obj.
	*/
	av_opt_free :: proc(obj: rawptr) ---

	/**
	* Iterate over all AVOptions belonging to obj.
	*
	* @param obj an AVOptions-enabled struct or a double pointer to an
	*            AVClass describing it.
	* @param prev result of the previous call to av_opt_next() on this object
	*             or NULL
	* @return next AVOption or NULL
	*/
	av_opt_next :: proc(obj: rawptr, prev: ^AVOption) -> ^AVOption ---

	/**
	* Iterate over AVOptions-enabled children of obj.
	*
	* @param prev result of a previous call to this function or NULL
	* @return next AVOptions-enabled child or NULL
	*/
	av_opt_child_next :: proc(obj: rawptr, prev: rawptr) -> rawptr ---

	/**
	* Iterate over potential AVOptions-enabled children of parent.
	*
	* @param iter a pointer where iteration state is stored.
	* @return AVClass corresponding to next potential child or NULL
	*/
	av_opt_child_class_iterate :: proc(parent: ^AVClass, iter: ^rawptr) -> ^AVClass ---
}

AV_OPT_SEARCH_CHILDREN   :: (1<<0) /**< Search in possible children of the
                                               given object first. */

/**
*  The obj passed to av_opt_find() is fake -- only a double pointer to AVClass
*  instead of a required pointer to a struct containing AVClass. This is
*  useful for searching for options without needing to allocate the corresponding
*  object.
*/
AV_OPT_SEARCH_FAKE_OBJ   :: (1<<1)

/**
*  In av_opt_get, return NULL if the option has a pointer type and is set to NULL,
*  rather than returning an empty string.
*/
AV_OPT_ALLOW_NULL :: (1<<2)

/**
* May be used with av_opt_set_array() to signal that new elements should
* replace the existing ones in the indicated range.
*/
AV_OPT_ARRAY_REPLACE :: (1<<3)

/**
*  Allows av_opt_query_ranges and av_opt_query_ranges_default to return more than
*  one component for certain option types.
*  @see AVOptionRanges for details.
*/
AV_OPT_MULTI_COMPONENT_RANGE :: (1<<12)

@(default_calling_convention="c")
foreign lib {
	/**
	* Look for an option in an object. Consider only options which
	* have all the specified flags set.
	*
	* @param[in] obj A pointer to a struct whose first element is a
	*                pointer to an AVClass.
	*                Alternatively a double pointer to an AVClass, if
	*                AV_OPT_SEARCH_FAKE_OBJ search flag is set.
	* @param[in] name The name of the option to look for.
	* @param[in] unit When searching for named constants, name of the unit
	*                 it belongs to.
	* @param opt_flags Find only options with all the specified flags set (AV_OPT_FLAG).
	* @param search_flags A combination of AV_OPT_SEARCH_*.
	*
	* @return A pointer to the option found, or NULL if no option
	*         was found.
	*
	* @note Options found with AV_OPT_SEARCH_CHILDREN flag may not be settable
	* directly with av_opt_set(). Use special calls which take an options
	* AVDictionary (e.g. avformat_open_input()) to set options found with this
	* flag.
	*/
	av_opt_find :: proc(obj: rawptr, name: cstring, unit: cstring, opt_flags: i32, search_flags: i32) -> ^AVOption ---

	/**
	* Look for an option in an object. Consider only options which
	* have all the specified flags set.
	*
	* @param[in] obj A pointer to a struct whose first element is a
	*                pointer to an AVClass.
	*                Alternatively a double pointer to an AVClass, if
	*                AV_OPT_SEARCH_FAKE_OBJ search flag is set.
	* @param[in] name The name of the option to look for.
	* @param[in] unit When searching for named constants, name of the unit
	*                 it belongs to.
	* @param opt_flags Find only options with all the specified flags set (AV_OPT_FLAG).
	* @param search_flags A combination of AV_OPT_SEARCH_*.
	* @param[out] target_obj if non-NULL, an object to which the option belongs will be
	* written here. It may be different from obj if AV_OPT_SEARCH_CHILDREN is present
	* in search_flags. This parameter is ignored if search_flags contain
	* AV_OPT_SEARCH_FAKE_OBJ.
	*
	* @return A pointer to the option found, or NULL if no option
	*         was found.
	*/
	av_opt_find2 :: proc(obj: rawptr, name: cstring, unit: cstring, opt_flags: i32, search_flags: i32, target_obj: ^rawptr) -> ^AVOption ---

	/**
	* Show the obj options.
	*
	* @param req_flags requested flags for the options to show. Show only the
	* options for which it is opt->flags & req_flags.
	* @param rej_flags rejected flags for the options to show. Show only the
	* options for which it is !(opt->flags & req_flags).
	* @param av_log_obj log context to use for showing the options
	*/
	av_opt_show2 :: proc(obj: rawptr, av_log_obj: rawptr, req_flags: i32, rej_flags: i32) -> i32 ---

	/**
	* Extract a key-value pair from the beginning of a string.
	*
	* @param ropts        pointer to the options string, will be updated to
	*                     point to the rest of the string (one of the pairs_sep
	*                     or the final NUL)
	* @param key_val_sep  a 0-terminated list of characters used to separate
	*                     key from value, for example '='
	* @param pairs_sep    a 0-terminated list of characters used to separate
	*                     two pairs from each other, for example ':' or ','
	* @param flags        flags; see the AV_OPT_FLAG_* values below
	* @param rkey         parsed key; must be freed using av_free()
	* @param rval         parsed value; must be freed using av_free()
	*
	* @return  >=0 for success, or a negative value corresponding to an
	*          AVERROR code in case of error; in particular:
	*          AVERROR(EINVAL) if no key is present
	*
	*/
	av_opt_get_key_value :: proc(ropts: ^cstring, key_val_sep: cstring, pairs_sep: cstring, flags: u32, rkey: ^cstring, rval: ^cstring) -> i32 ---
}

AV_OPT_FLAG_IMPLICIT_KEY :: 1

@(default_calling_convention="c")
foreign lib {
	/**
	* Parse the key/value pairs list in opts. For each key/value pair
	* found, stores the value in the field in ctx that is named like the
	* key. ctx must be an AVClass context, storing is done using
	* AVOptions.
	*
	* @param opts options string to parse, may be NULL
	* @param key_val_sep a 0-terminated list of characters used to
	* separate key from value
	* @param pairs_sep a 0-terminated list of characters used to separate
	* two pairs from each other
	* @return the number of successfully set key/value pairs, or a negative
	* value corresponding to an AVERROR code in case of error:
	* AVERROR(EINVAL) if opts cannot be parsed,
	* the error code issued by av_opt_set() if a key/value pair
	* cannot be set
	*/
	av_set_options_string :: proc(ctx: rawptr, opts: cstring, key_val_sep: cstring, pairs_sep: cstring) -> i32 ---

	/**
	* Parse the key-value pairs list in opts. For each key=value pair found,
	* set the value of the corresponding option in ctx.
	*
	* @param ctx          the AVClass object to set options on
	* @param opts         the options string, key-value pairs separated by a
	*                     delimiter
	* @param shorthand    a NULL-terminated array of options names for shorthand
	*                     notation: if the first field in opts has no key part,
	*                     the key is taken from the first element of shorthand;
	*                     then again for the second, etc., until either opts is
	*                     finished, shorthand is finished or a named option is
	*                     found; after that, all options must be named
	* @param key_val_sep  a 0-terminated list of characters used to separate
	*                     key from value, for example '='
	* @param pairs_sep    a 0-terminated list of characters used to separate
	*                     two pairs from each other, for example ':' or ','
	* @return  the number of successfully set key=value pairs, or a negative
	*          value corresponding to an AVERROR code in case of error:
	*          AVERROR(EINVAL) if opts cannot be parsed,
	*          the error code issued by av_set_string3() if a key/value pair
	*          cannot be set
	*
	* Options names must use only the following characters: a-z A-Z 0-9 - . / _
	* Separators must use characters distinct from option names and from each
	* other.
	*/
	av_opt_set_from_string :: proc(ctx: rawptr, opts: cstring, shorthand: ^cstring, key_val_sep: cstring, pairs_sep: cstring) -> i32 ---

	/**
	* Set all the options from a given dictionary on an object.
	*
	* @param obj a struct whose first element is a pointer to AVClass
	* @param options options to process. This dictionary will be freed and replaced
	*                by a new one containing all options not found in obj.
	*                Of course this new dictionary needs to be freed by caller
	*                with av_dict_free().
	*
	* @return 0 on success, a negative AVERROR if some option was found in obj,
	*         but could not be set.
	*
	* @see av_dict_copy()
	*/
	av_opt_set_dict :: proc(obj: rawptr, options: ^^AVDictionary) -> i32 ---

	/**
	* Set all the options from a given dictionary on an object.
	*
	* @param obj a struct whose first element is a pointer to AVClass
	* @param options options to process. This dictionary will be freed and replaced
	*                by a new one containing all options not found in obj.
	*                Of course this new dictionary needs to be freed by caller
	*                with av_dict_free().
	* @param search_flags A combination of AV_OPT_SEARCH_*.
	*
	* @return 0 on success, a negative AVERROR if some option was found in obj,
	*         but could not be set.
	*
	* @see av_dict_copy()
	*/
	av_opt_set_dict2 :: proc(obj: rawptr, options: ^^AVDictionary, search_flags: i32) -> i32 ---

	/**
	* Copy options from src object into dest object.
	*
	* The underlying AVClass of both src and dest must coincide. The guarantee
	* below does not apply if this is not fulfilled.
	*
	* Options that require memory allocation (e.g. string or binary) are malloc'ed in dest object.
	* Original memory allocated for such options is freed unless both src and dest options points to the same memory.
	*
	* Even on error it is guaranteed that allocated options from src and dest
	* no longer alias each other afterwards; in particular calling av_opt_free()
	* on both src and dest is safe afterwards if dest has been memdup'ed from src.
	*
	* @param dest Object to copy from
	* @param src  Object to copy into
	* @return 0 on success, negative on error
	*/
	av_opt_copy :: proc(dest: rawptr, src: rawptr) -> i32 ---

	/**
	* @defgroup opt_set_funcs Option setting functions
	* @{
	* Those functions set the field of obj with the given name to value.
	*
	* @param[in] obj A struct whose first element is a pointer to an AVClass.
	* @param[in] name the name of the field to set
	* @param[in] val The value to set. In case of av_opt_set() if the field is not
	* of a string type, then the given string is parsed.
	* SI postfixes and some named scalars are supported.
	* If the field is of a numeric type, it has to be a numeric or named
	* scalar. Behavior with more than one scalar and +- infix operators
	* is undefined.
	* If the field is of a flags type, it has to be a sequence of numeric
	* scalars or named flags separated by '+' or '-'. Prefixing a flag
	* with '+' causes it to be set without affecting the other flags;
	* similarly, '-' unsets a flag.
	* If the field is of a dictionary type, it has to be a ':' separated list of
	* key=value parameters. Values containing ':' special characters must be
	* escaped.
	* @param search_flags flags passed to av_opt_find2. I.e. if AV_OPT_SEARCH_CHILDREN
	* is passed here, then the option may be set on a child of obj.
	*
	* @return 0 if the value has been set, or an AVERROR code in case of
	* error:
	* AVERROR_OPTION_NOT_FOUND if no matching option exists
	* AVERROR(ERANGE) if the value is out of range
	* AVERROR(EINVAL) if the value is not valid
	*/
	av_opt_set            :: proc(obj: rawptr, name: cstring, val: cstring, search_flags: i32) -> i32 ---
	av_opt_set_int        :: proc(obj: rawptr, name: cstring, val: i64, search_flags: i32) -> i32 ---
	av_opt_set_double     :: proc(obj: rawptr, name: cstring, val: f64, search_flags: i32) -> i32 ---
	av_opt_set_q          :: proc(obj: rawptr, name: cstring, val: AVRational, search_flags: i32) -> i32 ---
	av_opt_set_bin        :: proc(obj: rawptr, name: cstring, val: ^u8, size: i32, search_flags: i32) -> i32 ---
	av_opt_set_image_size :: proc(obj: rawptr, name: cstring, w: i32, h: i32, search_flags: i32) -> i32 ---
	av_opt_set_pixel_fmt  :: proc(obj: rawptr, name: cstring, fmt: AVPixelFormat, search_flags: i32) -> i32 ---
	av_opt_set_sample_fmt :: proc(obj: rawptr, name: cstring, fmt: AVSampleFormat, search_flags: i32) -> i32 ---
	av_opt_set_video_rate :: proc(obj: rawptr, name: cstring, val: AVRational, search_flags: i32) -> i32 ---

	/**
	* @note Any old chlayout present is discarded and replaced with a copy of the new one. The
	* caller still owns layout and is responsible for uninitializing it.
	*/
	av_opt_set_chlayout :: proc(obj: rawptr, name: cstring, layout: ^AVChannelLayout, search_flags: i32) -> i32 ---

	/**
	* @note Any old dictionary present is discarded and replaced with a copy of the new one. The
	* caller still owns val is and responsible for freeing it.
	*/
	av_opt_set_dict_val :: proc(obj: rawptr, name: cstring, val: ^AVDictionary, search_flags: i32) -> i32 ---

	/**
	* Add, replace, or remove elements for an array option. Which of these
	* operations is performed depends on the values of val and search_flags.
	*
	* @param start_elem Index of the first array element to modify; must not be
	*                   larger than array size as returned by
	*                   av_opt_get_array_size().
	* @param nb_elems number of array elements to modify; when val is NULL,
	*                 start_elem+nb_elems must not be larger than array size as
	*                 returned by av_opt_get_array_size()
	*
	* @param val_type Option type corresponding to the type of val, ignored when val is
	*                 NULL.
	*
	*                 The effect of this function will will be as if av_opt_setX()
	*                 was called for each element, where X is specified by type.
	*                 E.g. AV_OPT_TYPE_STRING corresponds to av_opt_set().
	*
	*                 Typically this should be the same as the scalarized type of
	*                 the AVOption being set, but certain conversions are also
	*                 possible - the same as those done by the corresponding
	*                 av_opt_set*() function. E.g. any option type can be set from
	*                 a string, numeric types can be set from int64, double, or
	*                 rational, etc.
	*
	* @param val Array with nb_elems elements or NULL.
	*
	*            When NULL, nb_elems array elements starting at start_elem are
	*            removed from the array. Any array elements remaining at the end
	*            are shifted by nb_elems towards the first element in order to keep
	*            the array contiguous.
	*
	*            Otherwise (val is non-NULL), the type of val must match the
	*            underlying C type as documented for val_type.
	*
	*            When AV_OPT_ARRAY_REPLACE is not set in search_flags, the array is
	*            enlarged by nb_elems, and the contents of val are inserted at
	*            start_elem. Previously existing array elements from start_elem
	*            onwards (if present) are shifted by nb_elems away from the first
	*            element in order to make space for the new elements.
	*
	*            When AV_OPT_ARRAY_REPLACE is set in search_flags, the contents
	*            of val replace existing array elements from start_elem to
	*            start_elem+nb_elems (if present). New array size is
	*            max(start_elem + nb_elems, old array size).
	*/
	av_opt_set_array :: proc(obj: rawptr, name: cstring, search_flags: i32, start_elem: u32, nb_elems: u32, val_type: AVOptionType, val: rawptr) -> i32 ---

	/**
	* @defgroup opt_get_funcs Option getting functions
	* @{
	* Those functions get a value of the option with the given name from an object.
	*
	* @param[in] obj a struct whose first element is a pointer to an AVClass.
	* @param[in] name name of the option to get.
	* @param[in] search_flags flags passed to av_opt_find2. I.e. if AV_OPT_SEARCH_CHILDREN
	* is passed here, then the option may be found in a child of obj.
	* @param[out] out_val value of the option will be written here
	* @return >=0 on success, a negative error code otherwise
	*/
	/**
	* @note the returned string will be av_malloc()ed and must be av_free()ed by the caller
	*
	* @note if AV_OPT_ALLOW_NULL is set in search_flags in av_opt_get, and the
	* option is of type AV_OPT_TYPE_STRING, AV_OPT_TYPE_BINARY or AV_OPT_TYPE_DICT
	* and is set to NULL, *out_val will be set to NULL instead of an allocated
	* empty string.
	*/
	av_opt_get            :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^^u8) -> i32 ---
	av_opt_get_int        :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^i64) -> i32 ---
	av_opt_get_double     :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^f64) -> i32 ---
	av_opt_get_q          :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^AVRational) -> i32 ---
	av_opt_get_image_size :: proc(obj: rawptr, name: cstring, search_flags: i32, w_out: ^i32, h_out: ^i32) -> i32 ---
	av_opt_get_pixel_fmt  :: proc(obj: rawptr, name: cstring, search_flags: i32, out_fmt: ^AVPixelFormat) -> i32 ---
	av_opt_get_sample_fmt :: proc(obj: rawptr, name: cstring, search_flags: i32, out_fmt: ^AVSampleFormat) -> i32 ---
	av_opt_get_video_rate :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^AVRational) -> i32 ---

	/**
	* @param[out] layout The returned layout is a copy of the actual value and must
	* be freed with av_channel_layout_uninit() by the caller
	*/
	av_opt_get_chlayout :: proc(obj: rawptr, name: cstring, search_flags: i32, layout: ^AVChannelLayout) -> i32 ---

	/**
	* @param[out] out_val The returned dictionary is a copy of the actual value and must
	* be freed with av_dict_free() by the caller
	*/
	av_opt_get_dict_val :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^^AVDictionary) -> i32 ---

	/**
	* For an array-type option, get the number of elements in the array.
	*/
	av_opt_get_array_size :: proc(obj: rawptr, name: cstring, search_flags: i32, out_val: ^u32) -> i32 ---

	/**
	* For an array-type option, retrieve the values of one or more array elements.
	*
	* @param start_elem index of the first array element to retrieve
	* @param nb_elems number of array elements to retrieve; start_elem+nb_elems
	*                 must not be larger than array size as returned by
	*                 av_opt_get_array_size()
	*
	* @param out_type Option type corresponding to the desired output.
	*
	*                 The array elements produced by this function will
	*                 will be as if av_opt_getX() was called for each element,
	*                 where X is specified by out_type. E.g. AV_OPT_TYPE_STRING
	*                 corresponds to av_opt_get().
	*
	*                 Typically this should be the same as the scalarized type of
	*                 the AVOption being retrieved, but certain conversions are
	*                 also possible - the same as those done by the corresponding
	*                 av_opt_get*() function. E.g. any option type can be retrieved
	*                 as a string, numeric types can be retrieved as int64, double,
	*                 or rational, etc.
	*
	* @param out_val  Array with nb_elems members into which the output will be
	*                 written. The array type must match the underlying C type as
	*                 documented for out_type, and be zeroed on entry to this
	*                 function.
	*
	*                 For dynamically allocated types (strings, binary, dicts,
	*                 etc.), the result is owned and freed by the caller.
	*/
	av_opt_get_array :: proc(obj: rawptr, name: cstring, search_flags: i32, start_elem: u32, nb_elems: u32, out_type: AVOptionType, out_val: rawptr) -> i32 ---

	/**
	* @defgroup opt_eval_funcs Evaluating option strings
	* @{
	* This group of functions can be used to evaluate option strings
	* and get numbers out of them. They do the same thing as av_opt_set(),
	* except the result is written into the caller-supplied pointer.
	*
	* @param obj a struct whose first element is a pointer to AVClass.
	* @param o an option for which the string is to be evaluated.
	* @param val string to be evaluated.
	* @param *_out value of the string will be written here.
	*
	* @return 0 on success, a negative number on failure.
	*/
	av_opt_eval_flags  :: proc(obj: rawptr, o: ^AVOption, val: cstring, flags_out: ^i32) -> i32 ---
	av_opt_eval_int    :: proc(obj: rawptr, o: ^AVOption, val: cstring, int_out: ^i32) -> i32 ---
	av_opt_eval_uint   :: proc(obj: rawptr, o: ^AVOption, val: cstring, uint_out: ^u32) -> i32 ---
	av_opt_eval_int64  :: proc(obj: rawptr, o: ^AVOption, val: cstring, int64_out: ^i64) -> i32 ---
	av_opt_eval_float  :: proc(obj: rawptr, o: ^AVOption, val: cstring, float_out: ^f32) -> i32 ---
	av_opt_eval_double :: proc(obj: rawptr, o: ^AVOption, val: cstring, double_out: ^f64) -> i32 ---
	av_opt_eval_q      :: proc(obj: rawptr, o: ^AVOption, val: cstring, q_out: ^AVRational) -> i32 ---

	/**
	* Gets a pointer to the requested field in a struct.
	* This function allows accessing a struct even when its fields are moved or
	* renamed since the application making the access has been compiled,
	*
	* @returns a pointer to the field, it can be cast to the correct type and read
	*          or written to.
	*
	* @deprecated direct access to AVOption-exported fields is not supported
	*/
	av_opt_ptr :: proc(avclass: ^AVClass, obj: rawptr, name: cstring) -> rawptr ---

	/**
	* Check if given option is set to its default value.
	*
	* Options o must belong to the obj. This function must not be called to check child's options state.
	* @see av_opt_is_set_to_default_by_name().
	*
	* @param obj  AVClass object to check option on
	* @param o    option to be checked
	* @return     >0 when option is set to its default,
	*              0 when option is not set its default,
	*             <0 on error
	*/
	av_opt_is_set_to_default :: proc(obj: rawptr, o: ^AVOption) -> i32 ---

	/**
	* Check if given option is set to its default value.
	*
	* @param obj          AVClass object to check option on
	* @param name         option name
	* @param search_flags combination of AV_OPT_SEARCH_*
	* @return             >0 when option is set to its default,
	*                     0 when option is not set its default,
	*                     <0 on error
	*/
	av_opt_is_set_to_default_by_name :: proc(obj: rawptr, name: cstring, search_flags: i32) -> i32 ---

	/**
	* Check whether a particular flag is set in a flags field.
	*
	* @param field_name the name of the flag field option
	* @param flag_name the name of the flag to check
	* @return non-zero if the flag is set, zero if the flag isn't set,
	*         isn't of the right type, or the flags field doesn't exist.
	*/
	av_opt_flag_is_set :: proc(obj: rawptr, field_name: cstring, flag_name: cstring) -> i32 ---
}

AV_OPT_SERIALIZE_SKIP_DEFAULTS              :: 0x00000001  ///< Serialize options that are not set to default values only.
AV_OPT_SERIALIZE_OPT_FLAGS_EXACT            :: 0x00000002  ///< Serialize options that exactly match opt_flags only.
AV_OPT_SERIALIZE_SEARCH_CHILDREN            :: 0x00000004  ///< Serialize options in possible children of the given object.

@(default_calling_convention="c")
foreign lib {
	/**
	* Serialize object's options.
	*
	* Create a string containing object's serialized options.
	* Such string may be passed back to av_opt_set_from_string() in order to restore option values.
	* A key/value or pairs separator occurring in the serialized value or
	* name string are escaped through the av_escape() function.
	*
	* @param[in]  obj           AVClass object to serialize
	* @param[in]  opt_flags     serialize options with all the specified flags set (AV_OPT_FLAG)
	* @param[in]  flags         combination of AV_OPT_SERIALIZE_* flags
	* @param[out] buffer        Pointer to buffer that will be allocated with string containing serialized options.
	*                           Buffer must be freed by the caller when is no longer needed.
	* @param[in]  key_val_sep   character used to separate key from value
	* @param[in]  pairs_sep     character used to separate two pairs from each other
	* @return                   >= 0 on success, negative on error
	* @warning Separators cannot be neither '\\' nor '\0'. They also cannot be the same.
	*/
	av_opt_serialize :: proc(obj: rawptr, opt_flags: i32, flags: i32, buffer: ^cstring, key_val_sep: i8, pairs_sep: i8) -> i32 ---

	/**
	* Free an AVOptionRanges struct and set it to NULL.
	*/
	av_opt_freep_ranges :: proc(ranges: ^^AVOptionRanges) ---

	/**
	* Get a list of allowed ranges for the given option.
	*
	* The returned list may depend on other fields in obj like for example profile.
	*
	* @param flags is a bitmask of flags, undefined flags should not be set and should be ignored
	*              AV_OPT_SEARCH_FAKE_OBJ indicates that the obj is a double pointer to a AVClass instead of a full instance
	*              AV_OPT_MULTI_COMPONENT_RANGE indicates that function may return more than one component, @see AVOptionRanges
	*
	* The result must be freed with av_opt_freep_ranges.
	*
	* @return number of components returned on success, a negative error code otherwise
	*/
	av_opt_query_ranges :: proc(_: ^^AVOptionRanges, obj: rawptr, key: cstring, flags: i32) -> i32 ---

	/**
	* Get a default list of allowed ranges for the given option.
	*
	* This list is constructed without using the AVClass.query_ranges() callback
	* and can be used as fallback from within the callback.
	*
	* @param flags is a bitmask of flags, undefined flags should not be set and should be ignored
	*              AV_OPT_SEARCH_FAKE_OBJ indicates that the obj is a double pointer to a AVClass instead of a full instance
	*              AV_OPT_MULTI_COMPONENT_RANGE indicates that function may return more than one component, @see AVOptionRanges
	*
	* The result must be freed with av_opt_free_ranges.
	*
	* @return number of components returned on success, a negative error code otherwise
	*/
	av_opt_query_ranges_default :: proc(_: ^^AVOptionRanges, obj: rawptr, key: cstring, flags: i32) -> i32 ---
}

