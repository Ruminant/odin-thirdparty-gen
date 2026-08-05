#include "nanosvg_wrapper.h"

#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define NANOSVG_IMPLEMENTATION
#include "nanosvg.h"

#define NANOSVGRAST_IMPLEMENTATION
#include "nanosvgrast.h"

vs_nanosvg_result vs_nanosvg_rasterize_rgba(
    const unsigned char* svg_data,
    size_t svg_length,
    int output_width,
    int output_height,
    unsigned char* rgba,
    int stride) {
    char* mutable_svg;
    NSVGimage* image;
    NSVGrasterizer* rasterizer;
    float scale;
    float tx;
    float ty;

    if (svg_data == NULL || svg_length == 0 || output_width <= 0 || output_height <= 0 ||
        rgba == NULL || output_width > INT_MAX / 4 || stride < output_width * 4 ||
        svg_length == SIZE_MAX) {
        return VS_NANOSVG_INVALID_ARGUMENT;
    }

    mutable_svg = (char*)malloc(svg_length + 1);
    if (mutable_svg == NULL) {
        return VS_NANOSVG_ALLOCATION_FAILED;
    }
    memcpy(mutable_svg, svg_data, svg_length);
    mutable_svg[svg_length] = '\0';

    image = nsvgParse(mutable_svg, "px", 96.0f);
    free(mutable_svg);
    if (image == NULL || image->width <= 0.0f || image->height <= 0.0f || image->shapes == NULL) {
        if (image != NULL) {
            nsvgDelete(image);
        }
        return VS_NANOSVG_PARSE_FAILED;
    }

    rasterizer = nsvgCreateRasterizer();
    if (rasterizer == NULL) {
        nsvgDelete(image);
        return VS_NANOSVG_RASTERIZER_FAILED;
    }

    scale = fminf((float)output_width / image->width, (float)output_height / image->height);
    tx = ((float)output_width - image->width * scale) * 0.5f;
    ty = ((float)output_height - image->height * scale) * 0.5f;
    nsvgRasterize(rasterizer, image, tx, ty, scale, rgba, output_width, output_height, stride);

    nsvgDeleteRasterizer(rasterizer);
    nsvgDelete(image);
    return VS_NANOSVG_OK;
}

