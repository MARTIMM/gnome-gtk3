Gnome::Cairo::Surface
=====================

Base class for surfaces

Description
===========

    B<cairo_surface_t> is the abstract type representing all different drawing targets that cairo can render to.  The actual drawings are performed using a cairo I<context>.
    A cairo surface is created by using I<backend>-specific constructors, typically of the form C<cairo_B<backend>_surface_create( )>.
    Most surface types allow accessing the surface without using Cairo functions. If you do this, keep in mind that it is mandatory that you call C<cairo_surface_flush()> before reading from or writing to the surface and that you must use C<cairo_surface_mark_dirty()> after modifying it. <example> <title>Directly modifying an image surface</title>

    void modify_image_surface (cairo_surface_t *surface) {   unsigned char *data;   int width, height, stride;
      // flush to ensure all writing to the image was done   cairo_surface_flush (surface);
      // modify the image   data = cairo_image_surface_get_data (surface);   width = cairo_image_surface_get_width (surface);   height = cairo_image_surface_get_height (surface);   stride = cairo_image_surface_get_stride (surface);   modify_image_data (data, width, height, stride);
      // mark the image dirty so Cairo clears its caches.   cairo_surface_mark_dirty (surface); }

    </example> Note that for other surface types it might be necessary to acquire the surface's device first. See C<cairo_device_acquire()> for a discussion of devices.

See Also
--------

**cairo_t**, **cairo_pattern_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::Surface;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### new()

Create a new Surface object.

    multi method new ( )

[cairo_surface_] get_type
-------------------------

This function returns the type of the backend used to create a surface. See **cairo_surface_type_t** for available types. Return value: The type of *surface*.

    method cairo_surface_get_type ( --> cairo_surface_type_t )

[cairo_surface_] get_content
----------------------------

This function returns the content type of *surface* which indicates whether the surface contains color and/or alpha information. See **cairo_content_t**. Return value: The content type of this *surface*.

    method cairo_surface_get_content ( --> Int )

cairo_surface_status
--------------------

Checks whether an error has previously occurred for this surface. Return value: `CAIRO_STATUS_SUCCESS`, `CAIRO_STATUS_NULL_POINTER`, `CAIRO_STATUS_NO_MEMORY`, `CAIRO_STATUS_READ_ERROR`, `CAIRO_STATUS_INVALID_CONTENT`, `CAIRO_STATUS_INVALID_FORMAT`, or `CAIRO_STATUS_INVALID_VISUAL`.

    method cairo_surface_status ( --> cairo_status_t )

[cairo_surface_] get_device
---------------------------

This function returns the device for a *surface*. See **cairo_device_t**. Return value: The device for *surface* or `Any` if the surface does not have an associated device.

    method cairo_surface_get_device ( --> cairo_device_t )

[cairo_surface_] create_similar
-------------------------------

Create a new surface that is as compatible as possible with an existing surface. For example the new surface will have the same device scale, fallback resolution and font options as this surface. Generally, the new surface will also use the same backend as this surface, unless that is not possible for some reason. The type of the returned surface may be examined with `cairo_surface_get_type()`.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.) Use `cairo_surface_create_similar_image()` if you need an image surface which can be painted quickly to the target surface.

Return value: a pointer to the newly allocated surface. The caller owns the surface and should call `cairo_surface_destroy()` when done with it.

This function always returns a valid pointer, but it will return a pointer to a "nil" surface if *other* is already in an error state or any other error occurs.

    method cairo_surface_create_similar ( Int $content, Int $width, Int $height --> cairo_surface_t )

  * Int $content; an existing surface used to select the backend of the new surface

  * Int $width; the content for the new surface

  * Int $height; width of the new surface, (in device-space units)

[cairo_surface_] create_similar_image
-------------------------------------

Create a new image surface that is as compatible as possible for uploading to and the use in conjunction with an existing surface. However, this surface can still be used like any normal image surface. Unlike `cairo_surface_create_similar()` the new image surface won't inherit the device scale from *other*. Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.) Use `cairo_surface_create_similar()` if you don't need an image surface. Return value: a pointer to the newly allocated image surface. The caller owns the surface and should call `cairo_surface_destroy()` when done with it. This function always returns a valid pointer, but it will return a pointer to a "nil" surface if *other* is already in an error state or any other error occurs.

    method cairo_surface_create_similar_image ( Int $format, Int $width, Int $height --> cairo_surface_t )

  * Int $format; an existing surface used to select the preference of the new surface

  * Int $width; the format for the new surface

  * Int $height; width of the new surface, (in pixels)

[cairo_surface_] map_to_image
-----------------------------

Returns an image surface that is the most efficient mechanism for modifying the backing store of the target surface. The region retrieved may be limited to the *extents* or `Any` for the whole surface Note, the use of the original surface as a target or source whilst it is mapped is undefined. The result of mapping the surface multiple times is undefined. Calling `cairo_surface_destroy()` or `cairo_surface_finish()` on the resulting image surface results in undefined behavior. Changing the device transform of the image surface or of *surface* before the image surface is unmapped results in undefined behavior. Return value: a pointer to the newly allocated image surface. The caller must use `cairo_surface_unmap_image()` to destroy this image surface. This function always returns a valid pointer, but it will return a pointer to a "nil" surface if *other* is already in an error state or any other error occurs. If the returned pointer does not have an error status, it is guaranteed to be an image surface whose format is not `CAIRO_FORMAT_INVALID`.

    method cairo_surface_map_to_image ( cairo_rectangle_int_t $extents --> cairo_surface_t )

  * cairo_rectangle_int_t $extents; an existing surface used to extract the image from

[cairo_surface_] unmap_image
----------------------------

Unmaps the image surface as returned from **cairo_surface_map_to_image**(). The content of the image will be uploaded to the target surface. Afterwards, the image is destroyed. Using an image surface which wasn't returned by `cairo_surface_map_to_image()` results in undefined behavior.

    method cairo_surface_unmap_image ( cairo_surface_t $image )

  * cairo_surface_t $image; the surface passed to `cairo_surface_map_to_image()`.

[cairo_surface_] get_reference_count
------------------------------------

Returns the current reference count of *surface*. Return value: the current reference count of *surface*. If the object is a nil object, 0 will be returned.

    method cairo_surface_get_reference_count ( --> UInt )

cairo_surface_finish
--------------------

This function finishes the surface and drops all references to external resources. For example, for the Xlib backend it means that cairo will no longer access the drawable, which can be freed. After calling `cairo_surface_finish()` the only valid operations on a surface are getting and setting user, referencing and destroying, and flushing and finishing it. Further drawing to the surface will not affect the surface but will instead trigger a `CAIRO_STATUS_SURFACE_FINISHED` error. When the last call to `cairo_surface_destroy()` decreases the reference count to zero, cairo will call `cairo_surface_finish()` if it hasn't been called already, before freeing the resources associated with the surface.

    method cairo_surface_finish ( )

[cairo_surface_] supports_mime_type
-----------------------------------

Return whether *surface* supports *mime_type*. Return value: `1` if *surface* supports *mime_type*, `0` otherwise

    method cairo_surface_supports_mime_type ( Str $mime_type --> Int )

  * Str $mime_type; a **cairo_surface_t**

[cairo_surface_] get_font_options
---------------------------------

Retrieves the default font rendering options for the surface. This allows display surfaces to report the correct subpixel order for rendering on them, print surfaces to disable hinting of metrics and so forth. The result can then be used with `cairo_scaled_font_create()`.

    method cairo_surface_get_font_options ( cairo_font_options_t $options )

  * cairo_font_options_t $options; a **cairo_surface_t**

cairo_surface_flush
-------------------

Do any pending drawing for the surface and also restore any temporary modifications cairo has made to the surface's state. This function must be called before switching from drawing on the surface with cairo to drawing on it directly with native APIs, or accessing its memory outside of Cairo. If the surface doesn't support direct access, then this function does nothing.

    method cairo_surface_flush ( )

[cairo_surface_] mark_dirty
---------------------------

Tells cairo that drawing has been done to surface using means other than cairo, and that cairo should reread any cached areas. Note that you must call `cairo_surface_flush()` before doing such drawing.

    method cairo_surface_mark_dirty ( )

[cairo_surface_] mark_dirty_rectangle
-------------------------------------

Like `cairo_surface_mark_dirty()`, but drawing has been done only to the specified rectangle, so that cairo can retain cached contents for other parts of the surface. Any cached clip set on the surface will be reset by this function, to make sure that future cairo calls have the clip set that they expect.

    method cairo_surface_mark_dirty_rectangle ( Int $x, Int $y, Int $width, Int $height )

  * Int $x; a **cairo_surface_t**

  * Int $y; X coordinate of dirty rectangle

  * Int $width; Y coordinate of dirty rectangle

  * Int $height; width of dirty rectangle

[cairo_surface_] set_device_scale
---------------------------------

Sets a scale that is multiplied to the device coordinates determined by the CTM when drawing to *surface*. One common use for this is to render to very high resolution display devices at a scale factor, so that code that assumes 1 pixel will be a certain size will still work. Setting a transformation via `cairo_translate()` isn't sufficient to do this, since functions like `cairo_device_to_user()` will expose the hidden scale. Note that the scale affects drawing to the surface as well as using the surface in a source pattern.

    method cairo_surface_set_device_scale ( Num $x_scale, Num $y_scale )

  * Num $x_scale; a **cairo_surface_t**

  * Num $y_scale; a scale factor in the X direction

[cairo_surface_] get_device_scale
---------------------------------

This function returns the previous device offset set by `cairo_surface_set_device_scale()`.

    method cairo_surface_get_device_scale ( Num $x_scale, Num $y_scale )

  * Num $x_scale; a **cairo_surface_t**

  * Num $y_scale; the scale in the X direction, in device units

[cairo_surface_] set_device_offset
----------------------------------

Sets an offset that is added to the device coordinates determined by the CTM when drawing to *surface*. One use case for this function is when we want to create a **cairo_surface_t** that redirects drawing for a portion of an onscreen surface to an offscreen surface in a way that is completely invisible to the user of the cairo API. Setting a transformation via `cairo_translate()` isn't sufficient to do this, since functions like `cairo_device_to_user()` will expose the hidden offset. Note that the offset affects drawing to the surface as well as using the surface in a source pattern.

    method cairo_surface_set_device_offset ( Num $x_offset, Num $y_offset )

  * Num $x_offset; a **cairo_surface_t**

  * Num $y_offset; the offset in the X direction, in device units

[cairo_surface_] get_device_offset
----------------------------------

This function returns the previous device offset set by `cairo_surface_set_device_offset()`.

    method cairo_surface_get_device_offset ( Num $x_offset, Num $y_offset )

  * Num $x_offset; a **cairo_surface_t**

  * Num $y_offset; the offset in the X direction, in device units

[cairo_surface_] set_fallback_resolution
----------------------------------------

Set the horizontal and vertical resolution for image fallbacks. When certain operations aren't supported natively by a backend, cairo will fallback by rendering operations to an image and then overlaying that image onto the output. For backends that are natively vector-oriented, this function can be used to set the resolution used for these image fallbacks, (larger values will result in more detailed images, but also larger file sizes). Some examples of natively vector-oriented backends are the ps, pdf, and svg backends. For backends that are natively raster-oriented, image fallbacks are still possible, but they are always performed at the native device resolution. So this function has no effect on those backends. Note: The fallback resolution only takes effect at the time of completing a page (with `cairo_show_page()` or `cairo_copy_page()`) so there is currently no way to have more than one fallback resolution in effect on a single page. The default fallback resoultion is 300 pixels per inch in both dimensions.

    method cairo_surface_set_fallback_resolution ( Num $x_pixels_per_inch, Num $y_pixels_per_inch )

  * Num $x_pixels_per_inch; a **cairo_surface_t**

  * Num $y_pixels_per_inch; horizontal setting for pixels per inch

[cairo_surface_] get_fallback_resolution
----------------------------------------

This function returns the previous fallback resolution set by `cairo_surface_set_fallback_resolution()`, or default fallback resolution if never set.

    method cairo_surface_get_fallback_resolution ( Num $x_pixels_per_inch, Num $y_pixels_per_inch )

  * Num $x_pixels_per_inch; a **cairo_surface_t**

  * Num $y_pixels_per_inch; horizontal pixels per inch

[cairo_surface_] copy_page
--------------------------

Emits the current page for backends that support multiple pages, but doesn't clear it, so that the contents of the current page will be retained for the next page. Use `cairo_surface_show_page()` if you want to get an empty page after the emission. There is a convenience function for this that takes a **cairo_t**, namely `cairo_copy_page()`.

    method cairo_surface_copy_page ( )

[cairo_surface_] show_page
--------------------------

Emits and clears the current page for backends that support multiple pages. Use `cairo_surface_copy_page()` if you don't want to clear the page. There is a convenience function for this that takes a **cairo_t**, namely `cairo_show_page()`.

    method cairo_surface_show_page ( )

[cairo_surface_] has_show_text_glyphs
-------------------------------------

Returns whether the surface supports sophisticated `cairo_show_text_glyphs()` operations. That is, whether it actually uses the provided text and cluster data to a `cairo_show_text_glyphs()` call. Note: Even if this function returns `0`, a `cairo_show_text_glyphs()` operation targeted at *surface* will still succeed. It just will act like a `cairo_show_glyphs()` operation. Users can use this function to avoid computing UTF-8 text and cluster mapping if the target surface does not use it. Return value: `1` if *surface* supports `cairo_show_text_glyphs()`, `0` otherwise

    method cairo_surface_has_show_text_glyphs ( --> Int )

cairo_surface_write_to_png
--------------------------

The PNG functions allow reading PNG images into image surfaces, and writing any surface to a PNG file. It is a toy API. It only offers very simple support for reading and writing PNG files, which is sufficient for testing and demonstration purposes. Applications which need more control over the generated PNG file should access the pixel data directly, using `cairo_image_surface_get_data()` or a backend-specific access function, and process it with another library, e.g. gdk-pixbuf or libpng. CAIRO_HAS_PNG_FUNCTIONS: Defined if the PNG functions are available. This macro can be used to conditionally compile code using the cairo PNG functions. stderr and rely on the user to check for errors via the **cairo_status_t** return. loading the image after a warning. So we also want to return the (incorrect?) surface. We use our own warning callback to squelch any attempts by libpng to write to stderr as we may not be in control of that output. Otherwise, we will segfault if we are writing to a stream.

    method cairo_surface_write_to_png ( cairo_surface_t $surface, Str $filename --> Int )

  * cairo_surface_t $surface; SECTION:cairo-png

  * Str $filename; PNG Support

