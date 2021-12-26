Gnome::Cairo::ImageSurface
==========================

Rendering to memory buffers

Description
===========

Image surfaces provide the ability to render to memory buffers either allocated by cairo or by the calling code. The supported image formats are those defined in **cairo_format_t**.

See Also
--------

**cairo_surface_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::ImageSurface;
    also is Gnome::Cairo::Surface;

Methods
=======

new
---

### :format, :width, :height

Creates an image surface of the specified format and dimensions. Initially the surface contents are set to 0. (Specifically, within each pixel, each color or alpha channel belonging to format will be 0. The contents of bits within a pixel, but not belonging to the given format are undefined).

The caller owns the surface and should call `.clear-object()` when done with it.

    multi method new (
      cairo_format_t:D :$format!, Int() :$width = 128, Int() :$height = 128
    )

  * Int $format; cairo_image_surface_create:

  * Int $width; format of pixels in the surface to create

  * Int $height; width of the surface, in pixels

### :png

Creates a new image surface and initializes the contents to the given PNG file.

The native object is a **cairo_surface_t** initialized with the contents of the PNG file, or a "nil" surface if any error occurred. A nil surface can be checked for with `.status()`. which may return one of the following values: `CAIRO_STATUS_NO_MEMORY` `CAIRO_STATUS_FILE_NOT_FOUND` `CAIRO_STATUS_READ_ERROR` `CAIRO_STATUS_PNG_ERROR`.

Alternatively, you can allow errors to propagate through the drawing operations and check the status on the context upon completion using `cairo_status()`.

    multi method new ( Str:D :$png! )

  * Str $png; The PNG image filename

get-format
----------

Get the format of the surface. Return value: the format of the surface

    method get-format ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_format:

get-height
----------

Get the height of the image surface in pixels. Return value: the height of the surface in pixels.

    method get-height ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_height:

get-stride
----------

Get the stride of the image surface in bytes Return value: the stride of the image surface in bytes (or 0 if *surface* is not an image surface). The stride is the distance in bytes from the beginning of one row of the image data to the beginning of the next row.

    method get-stride ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_stride:

get-width
---------

Get the width of the image surface in pixels. Return value: the width of the surface in pixels.

    method get-width ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_width:

