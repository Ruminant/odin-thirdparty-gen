#ifndef VSCRUB_NANOSVG_WRAPPER_H
#define VSCRUB_NANOSVG_WRAPPER_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum vs_nanosvg_result {
    VS_NANOSVG_OK = 0,
    VS_NANOSVG_INVALID_ARGUMENT = 1,
    VS_NANOSVG_ALLOCATION_FAILED = 2,
    VS_NANOSVG_PARSE_FAILED = 3,
    VS_NANOSVG_RASTERIZER_FAILED = 4,
} vs_nanosvg_result;

vs_nanosvg_result vs_nanosvg_rasterize_rgba(
    const unsigned char* svg_data,
    size_t svg_length,
    int output_width,
    int output_height,
    unsigned char* rgba,
    int stride);

#ifdef __cplusplus
}
#endif

#endif

