Gnome::Cairo::Surface
=====================

Base class for surfaces

Description
===========

**cairo_surface_t** is the abstract type representing all different drawing targets that cairo can render to. The actual drawings are performed using a cairo *context*.

A cairo surface is created by using *backend*-specific constructors, typically of the form `cairo_B<backend>_surface_create( )`.

Most surface types allow accessing the surface without using Cairo functions. If you do this, keep in mind that it is mandatory that you call `flush()` before reading from or writing to the surface and that you must use `mark_dirty()` after modifying it.

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

### :similar

Create a new surface that is as compatible as possible with an existing surface. For example the new surface will have the same device scale, fallback resolution and font options as *other*. Generally, the new surface will also use the same backend as *other*, unless that is not possible for some reason. The type of the returned surface may be examined with `get_type()`.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.) Use `create_similar_image()` if you need an image surface which can be painted quickly to the target surface. Return value: a pointer to the newly allocated surface. The caller owns the surface and should call `clear-object()` when done with it.

commentThis
===========

function always returns a valid pointer, but it will return a pointer to a "nil" surface if *other* is already in an error state or any other error occurs.

    multi method new (
      cairo_surface_t :$similar!,
      cairo_content_t :$content = CAIRO_CONTENT_COLOR,
      Int :$width = 32, Int :$height = 32
    )

### :image

Create a new image surface that is as compatible as possible for uploading to and the use in conjunction with an existing surface. However, this surface can still be used like any normal image surface. Unlike `new(:$similar)` the new image surface won't inherit the device scale from the `$image` surface.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.) Use `new(:similar)` if you don't need an image surface.

    multi method new (
      cairo_surface_t :image!, cairo_format_t :$format = CAIRO_FORMAT_RGB24,
      Int :$width = 32, Int :$height = 32
    )

### :target

Create a new surface that is a rectangle within the target surface. All operations drawn to this surface are then clipped and translated onto the target surface. Nothing drawn via this sub-surface outside of its bounds is drawn onto the target surface, making this a useful method for passing constrained child surfaces to library routines that draw directly onto the parent surface, i.e. with no further backend allocations, double buffering or copies.

The semantics of subsurfaces have not been finalized yet unless the rectangle is in full device units, is contained within the extents of the target surface, and the target or subsurface's device transforms are not changed.

    multi method new (
      cairo_surface_t :$target,
      Num() :$x = 0e0, Num() :$y = 0e0,
      Num() :$width = 128e0, Num() :$height = 128e0
      --> cairo_surface_t
    }

### :native-object

Create a **Gnome::Cairo::Surface** object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

copy-page
---------

Emits the current page for backends that support multiple pages, but doesn't clear it, so that the contents of the current page will be retained for the next page. Use `cairo_surface_show_page()` if you want to get an empty page after the emission. There is a convenience function for this that takes a **cairo_t**, namely `cairo_copy_page()`.

    method copy-page ( )

finish
------

This function finishes the surface and drops all references to external resources. For example, for the Xlib backend it means that cairo will no longer access the drawable, which can be freed. After calling `cairo_surface_finish()` the only valid operations on a surface are getting and setting user, referencing and destroying, and flushing and finishing it. Further drawing to the surface will not affect the surface but will instead trigger a `CAIRO_STATUS_SURFACE_FINISHED` error. When the last call to `cairo_surface_destroy()` decreases the reference count to zero, cairo will call `cairo_surface_finish()` if it hasn't been called already, before freeing the resources associated with the surface.

    method finish ( )

flush
-----

Do any pending drawing for the surface and also restore any temporary modifications cairo has made to the surface's state. This function must be called before switching from drawing on the surface with cairo to drawing on it directly with native APIs, or accessing its memory outside of Cairo. If the surface doesn't support direct access, then this function does nothing.

    method flush ( )

get-content
-----------

This function returns the content type of *surface* which indicates whether the surface contains color and/or alpha information. See **cairo_content_t**. Return value: The content type of *surface*.

    method get-content ( --> Int )

get-device
----------

This function returns the device for a *surface*. See **cairo_device_t**. Return value: The device for *surface* or `Any` if the surface does not have an associated device.

    method get-device ( --> cairo_device_t )

get-device-offset
-----------------

This function returns the previous device offset set by `cairo_surface_set_device_offset()`.

    method get-device-offset ( Num $x_offset, Num $y_offset )

  * Num $x_offset; a **cairo_surface_t**

  * Num $y_offset; the offset in the X direction, in device units

get-device-scale
----------------

This function returns the previous device offset set by `cairo_surface_set_device_scale()`.

    method get-device-scale ( Num $x_scale, Num $y_scale )

  * Num $x_scale; a **cairo_surface_t**

  * Num $y_scale; the scale in the X direction, in device units

get-fallback-resolution
-----------------------

This function returns the previous fallback resolution set by `cairo_surface_set_fallback_resolution()`, or default fallback resolution if never set.

    method get-fallback-resolution ( Num $x_pixels_per_inch, Num $y_pixels_per_inch )

  * Num $x_pixels_per_inch; a **cairo_surface_t**

  * Num $y_pixels_per_inch; horizontal pixels per inch

get-font-options
----------------

Retrieves the default font rendering options for the surface. This allows display surfaces to report the correct subpixel order for rendering on them, print surfaces to disable hinting of metrics and so forth. The result can then be used with `cairo_scaled_font_create()`.

    method get-font-options ( cairo_font_options_t $options )

  * cairo_font_options_t $options; a **cairo_surface_t**

get-reference-count
-------------------

Returns the current reference count of *surface*. Return value: the current reference count of *surface*. If the object is a nil object, 0 will be returned.

    method get-reference-count ( --> Int )

get-type
--------

This function returns the type of the backend used to create a surface. See **cairo_surface_type_t** for available types. Return value: The type of *surface*.

    method get-type ( --> Int )

has-show-text-glyphs
--------------------

Returns whether the surface supports sophisticated `cairo_show_text_glyphs()` operations. That is, whether it actually uses the provided text and cluster data to a `cairo_show_text_glyphs()` call. Note: Even if this function returns `0`, a `cairo_show_text_glyphs()` operation targeted at *surface* will still succeed. It just will act like a `cairo_show_glyphs()` operation. Users can use this function to avoid computing UTF-8 text and cluster mapping if the target surface does not use it. Return value: `1` if *surface* supports `cairo_show_text_glyphs()`, `0` otherwise

    method has-show-text-glyphs ( --> Int )

mark-dirty
----------

Tells cairo that drawing has been done to surface using means other than cairo, and that cairo should reread any cached areas. Note that you must call `cairo_surface_flush()` before doing such drawing.

    method mark-dirty ( )

mark-dirty-rectangle
--------------------

Like `cairo_surface_mark_dirty()`, but drawing has been done only to the specified rectangle, so that cairo can retain cached contents for other parts of the surface. Any cached clip set on the surface will be reset by this function, to make sure that future cairo calls have the clip set that they expect.

    method mark-dirty-rectangle ( Int $x, Int $y, Int $width, Int $height )

  * Int $x; a **cairo_surface_t**

  * Int $y; X coordinate of dirty rectangle

  * Int $width; Y coordinate of dirty rectangle

  * Int $height; width of dirty rectangle

set-device-offset
-----------------

Sets an offset that is added to the device coordinates determined by the CTM when drawing to *surface*. One use case for this function is when we want to create a **cairo_surface_t** that redirects drawing for a portion of an onscreen surface to an offscreen surface in a way that is completely invisible to the user of the cairo API. Setting a transformation via `cairo_translate()` isn't sufficient to do this, since functions like `cairo_device_to_user()` will expose the hidden offset. Note that the offset affects drawing to the surface as well as using the surface in a source pattern.

    method set-device-offset ( Num $x_offset, Num $y_offset )

  * Num $x_offset; a **cairo_surface_t**

  * Num $y_offset; the offset in the X direction, in device units

set-device-scale
----------------

Sets a scale that is multiplied to the device coordinates determined by the CTM when drawing to *surface*. One common use for this is to render to very high resolution display devices at a scale factor, so that code that assumes 1 pixel will be a certain size will still work. Setting a transformation via `cairo_translate()` isn't sufficient to do this, since functions like `cairo_device_to_user()` will expose the hidden scale. Note that the scale affects drawing to the surface as well as using the surface in a source pattern.

    method set-device-scale ( Num $x_scale, Num $y_scale )

  * Num $x_scale; a **cairo_surface_t**

  * Num $y_scale; a scale factor in the X direction

set-fallback-resolution
-----------------------

Set the horizontal and vertical resolution for image fallbacks. When certain operations aren't supported natively by a backend, cairo will fallback by rendering operations to an image and then overlaying that image onto the output. For backends that are natively vector-oriented, this function can be used to set the resolution used for these image fallbacks, (larger values will result in more detailed images, but also larger file sizes). Some examples of natively vector-oriented backends are the ps, pdf, and svg backends. For backends that are natively raster-oriented, image fallbacks are still possible, but they are always performed at the native device resolution. So this function has no effect on those backends. Note: The fallback resolution only takes effect at the time of completing a page (with `cairo_show_page()` or `cairo_copy_page()`) so there is currently no way to have more than one fallback resolution in effect on a single page. The default fallback resoultion is 300 pixels per inch in both dimensions.

    method set-fallback-resolution ( Num $x_pixels_per_inch, Num $y_pixels_per_inch )

  * Num $x_pixels_per_inch; a **cairo_surface_t**

  * Num $y_pixels_per_inch; horizontal setting for pixels per inch

show-page
---------

Emits and clears the current page for backends that support multiple pages. Use `cairo_surface_copy_page()` if you don't want to clear the page. There is a convenience function for this that takes a **cairo_t**, namely `cairo_show_page()`.

    method show-page ( )

status
------

Checks whether an error has previously occurred for this surface. Return value: `CAIRO_STATUS_SUCCESS`, `CAIRO_STATUS_NULL_POINTER`, `CAIRO_STATUS_NO_MEMORY`, `CAIRO_STATUS_READ_ERROR`, `CAIRO_STATUS_INVALID_CONTENT`, `CAIRO_STATUS_INVALID_FORMAT`, or `CAIRO_STATUS_INVALID_VISUAL`.

    method status ( --> cairo_status_t )

unmap-image
-----------

Unmaps the image surface as returned from **cairo_surface_map_to_image**(). The content of the image will be uploaded to the target surface. Afterwards, the image is destroyed. Using an image surface which wasn't returned by `cairo_surface_map_to_image()` results in undefined behavior.

    method unmap-image ( cairo_surface_t $image )

  * cairo_surface_t $image; the surface passed to `cairo_surface_map_to_image()`.

