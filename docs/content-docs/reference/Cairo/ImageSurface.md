Gnome::Cairo::ImageSurface
==========================

Rendering to memory buffers

Description
===========

    Image surfaces provide the ability to render to memory buffers either allocated by cairo or by the calling code.  The supported image formats are those defined in B<cairo_format_t>.

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

### :format :width :height

Creates an image surface of the specified format and dimensions. Initially the surface contents are set to 0. (Specifically, within each pixel, each color or alpha channel belonging to format will be 0. The contents of bits within a pixel, but not belonging to the given format are undefined).

The caller owns the surface and should call `.clear-object()` when done with it.

This function always returns a valid pointer, but it will return a pointer to a "nil" surface if an error such as out of memory occurs. You can use `.cairo_surface_status()` to check for this.

    multi method new ( cairo_format_t :$format, Int :$width, Int :$height )

[cairo_image_surface_] create_for_data
--------------------------------------

Creates an image surface for the provided pixel data. The output buffer must be kept around until the **cairo_surface_t** is destroyed or `cairo_surface_finish()` is called on the surface.

The initial contents of *$data* will be used as the initial image contents; you must explicitly clear the buffer, using, for example, `cairo_rectangle()` and `cairo_fill()` if you want it cleared.

Note that the stride may be larger than width*bytes_per_pixel to provide proper alignment for each pixel and row. This alignment is required to allow high-performance rendering within cairo. The correct way to obtain a legal stride value is to call `cairo_format_stride_for_width()` with the desired format and maximum image width value, and then use the resulting stride value to allocate the data and to create the image surface. See `cairo_format_stride_for_width()` for example code.

Return value: a pointer to the newly created surface. The caller owns the surface and should call `cairo_surface_destroy()` when done with it.

This function always returns a valid pointer, but it will return a pointer to a "nil" surface in the case of an error such as out of memory or an invalid stride value. In case of invalid stride value the error status of the returned surface will be `CAIRO_STATUS_INVALID_STRIDE`. You can use `cairo_surface_status()` to check for this.

See `cairo_surface_set_user_data()` for a means of attaching a destroy-notification fallback to the surface if necessary.

    method cairo_image_surface_create_for_data (
      CArray[int8] $data, Int $format, Int $width, Int $height, Int $stride
      --> cairo_surface_t
    )

  * CArray[int8] $data; cairo_image_surface_create_for_data:

  * Int $format; a pointer to a buffer supplied by the application in which to write contents. This pointer must be suitably aligned for any kind of variable, (for example, a pointer returned by malloc).

  * Int $width; the format of pixels in the buffer

  * Int $height; the width of the image to be stored in the buffer

  * Int $stride; the height of the image to be stored in the buffer

[cairo_image_surface_] get_data
-------------------------------

Get a pointer to the data of the image surface, for direct inspection or modification. A call to `cairo_surface_flush()` is required before accessing the pixel data to ensure that all pending drawing operations are finished. A call to `cairo_surface_mark_dirty()` is required after the data is modified. Return value: a pointer to the image data of this surface or `Any` if *surface* is not an image surface, or if `cairo_surface_finish()` has been called.

    method cairo_image_surface_get_data ( cairo_surface_t $surface --> CArray[int8] )

  * cairo_surface_t $surface; returned data:

[cairo_image_surface_] get_format
---------------------------------

Get the format of the surface. Return value: the format of the surface

    method cairo_image_surface_get_format ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_format:

[cairo_image_surface_] get_width
--------------------------------

Get the width of the image surface in pixels. Return value: the width of the surface in pixels.

    method cairo_image_surface_get_width ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_width:

[cairo_image_surface_] get_height
---------------------------------

Get the height of the image surface in pixels. Return value: the height of the surface in pixels.

    method cairo_image_surface_get_height ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_height:

[cairo_image_surface_] get_stride
---------------------------------

Get the stride of the image surface in bytes Return value: the stride of the image surface in bytes (or 0 if *surface* is not an image surface). The stride is the distance in bytes from the beginning of one row of the image data to the beginning of the next row.

    method cairo_image_surface_get_stride ( cairo_surface_t $surface --> Int )

  * cairo_surface_t $surface; cairo_image_surface_get_stride:

cairo_image_surface_create_from_png
-----------------------------------

Creates a new image surface and initializes the contents to the given PNG file. Return value: a new **cairo_surface_t** initialized with the contents of the PNG file, or a "nil" surface if any error occurred. A nil surface can be checked for with cairo_surface_status(surface) which may return one of the following values: `CAIRO_STATUS_NO_MEMORY` `CAIRO_STATUS_FILE_NOT_FOUND` `CAIRO_STATUS_READ_ERROR` `CAIRO_STATUS_PNG_ERROR`.

Alternatively, you can allow errors to propagate through the drawing operations and check the status on the context upon completion using `cairo_status()`.

    method cairo_image_surface_create_from_png ( Str $filename --> cairo_surface_t )

  * Str $filename; cairo_image_surface_create_from_png:

