Gnome::Gdk3::Pixbuf
===================

Creating a pixbuf from image data that is already in memory.

Description
===========

The most basic way to create a pixbuf is to wrap an existing pixel buffer with a **Gnome::Gdk3::Pixbuf** structure. You can use the `gdk_pixbuf_new_from_data()` function to do this You need to specify the destroy notification function that will be called when the data buffer needs to be freed; this will happen when a **Gnome::Gdk3::Pixbuf** is finalized by the reference counting functions If you have a chunk of static data compiled into your application, you can pass in `Any` as the destroy notification function so that the data will not be freed.

The `gdk_pixbuf_new()` function can be used as a convenience to create a pixbuf with an empty buffer. This is equivalent to allocating a data buffer using `malloc()` and then wrapping it with `gdk_pixbuf_new_from_data()`. The `gdk_pixbuf_new()` function will compute an optimal rowstride so that rendering can be performed with an efficient algorithm.

As a special case, you can use the `gdk_pixbuf_new_from_xpm_data()` function to create a pixbuf from inline XPM image data.

You can also copy an existing pixbuf with the `gdk_pixbuf_copy()` function. This is not the same as just doing a `g_object_ref()` on the old pixbuf; the copy function will actually duplicate the pixel data in memory and create a new **Gnome::Gdk3::Pixbuf** structure for it.

See Also
--------

`gdk_pixbuf_finalize()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Pixbuf;
    also is Gnome::GObject::Object;

Types
=====

enum GdkPixbufAlphaMode
-----------------------

These values can be passed to `gdk_pixbuf_xlib_render_to_drawable_alpha()` to control how the alpha channel of an image should be handled. This function can create a bilevel clipping mask (black and white) and use it while painting the image. In the future, when the X Window System gets an alpha channel extension, it will be possible to do full alpha compositing onto arbitrary drawables. For now both cases fall back to a bilevel clipping mask.

  * GDK_PIXBUF_ALPHA_BILEVEL: A bilevel clipping mask (black and white) will be created and used to draw the image. Pixels below 0.5 opacity will be considered fully transparent, and all others will be considered fully opaque.

  * GDK_PIXBUF_ALPHA_FULL: For now falls back to **GDK_PIXBUF_ALPHA_BILEVEL**. In the future it will do full alpha compositing.

enum GdkColorspace
------------------

This enumeration defines the color spaces that are supported by the gdk-pixbuf library. Currently only RGB is supported.

  * GDK_COLORSPACE_RGB: Indicates a red/green/blue additive color space.

enum GdkPixbufError
-------------------

An error code in the **GDK_PIXBUF_ERROR** domain. Many gdk-pixbuf operations can cause errors in this domain, or in the **G_FILE_ERROR** domain.

  * GDK_PIXBUF_ERROR_CORRUPT_IMAGE: An image file was broken somehow.

  * GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY: Not enough memory.

  * GDK_PIXBUF_ERROR_BAD_OPTION: A bad option was passed to a pixbuf save module.

  * GDK_PIXBUF_ERROR_UNKNOWN_TYPE: Unknown image type.

  * GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION: Don't know how to perform the given operation on the type of image at hand.

  * GDK_PIXBUF_ERROR_FAILED: Generic failure code, something went wrong.

  * GDK_PIXBUF_ERROR_INCOMPLETE_ANIMATION: Only part of the animation was loaded.

Methods
=======

new
---

### :$file

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If image is not found, a broken image icon is loaded instead.

    multi method new ( Str :$file! )

### :$file, :$width, :$height

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If image is not found, a broken image icon is loaded instead.

The image will be scaled to fit in the requested size, preserving the image's aspect ratio. Note that the returned pixbuf may be smaller than width x height , if the aspect ratio requires it. To load and image at the requested size, regardless of aspect ratio, add :preserve_aspect_ratio, see below.

    method new ( Str :$file, Int :$width, Int :$height )

### :$file, :$width, :$height, :$preserve_aspect_ratio

Creates a new pixbuf by loading an image from a file. The file format is detected automatically. If image is not found, a broken image icon is loaded instead.

When preserving the aspect ratio, a width of -1 will cause the image to be scaled to the exact given height, and a height of -1 will cause the image to be scaled to the exact given width. When not preserving aspect ratio, a width or height of -1 means to not scale the image at all in that dimension.

    method new (
      Str :$file!, Int :$width!, Int :$height!,
      Bool :$preserve_aspect_ratio!
    )

### :$resource

Creates a new pixbuf by loading an image from a Gio resource file. The file format is detected automatically. If image is not found, a broken image icon is loaded instead.

    multi method new ( Str :$resource! )

[gdk_pixbuf_] error_quark
-------------------------

    method gdk_pixbuf_error_quark ( --> Int  )

[gdk_pixbuf_] gdk_pixbuf_get_type
---------------------------------

    method gdk_pixbuf_get_type ( --> Int )

[gdk_pixbuf_] get_colorspace
----------------------------

Queries the color space of a pixbuf.

Return value: Color space enum value.

    method gdk_pixbuf_get_colorspace ( --> GdkColorspace  )

[gdk_pixbuf_] get_n_channels
----------------------------

Queries the number of channels of a pixbuf.

    method gdk_pixbuf_get_n_channels ( --> Int  )

[gdk_pixbuf_] get_has_alpha
---------------------------

Queries whether a pixbuf has an alpha channel (opacity information). `1` if it has an alpha channel, `0` otherwise.

    method gdk_pixbuf_get_has_alpha ( --> Int  )

[gdk_pixbuf_] get_bits_per_sample
---------------------------------

Queries the number of bits per color sample in a pixbuf.

    method gdk_pixbuf_get_bits_per_sample ( --> Int  )

[gdk_pixbuf_] get_width
-----------------------

Queries the width of a pixbuf.

    method gdk_pixbuf_get_width ( --> Int  )

[gdk_pixbuf_] get_height
------------------------

Queries the height of a pixbuf.

    method gdk_pixbuf_get_height ( --> Int  )

[gdk_pixbuf_] get_rowstride
---------------------------

Queries the rowstride of a pixbuf, which is the number of bytes between the start of a row and the start of the next row.

Return value: Distance between row starts.

    method gdk_pixbuf_get_rowstride ( --> Int  )

[gdk_pixbuf_] get_byte_length
-----------------------------

Returns the length of the pixel data, in bytes.

Since: 2.26

    method gdk_pixbuf_get_byte_length ( --> UInt  )

gdk_pixbuf_new
--------------

Creates a new **Gnome::Gdk3::Pixbuf** structure and allocates a buffer for it. The buffer has an optimal rowstride. Note that the buffer is not cleared; you will have to fill it completely yourself.

Return value: (nullable): A newly-created **Gnome::Gdk3::Pixbuf** with a reference count of 1, or `Any` if not enough memory could be allocated for the image buffer.

    method gdk_pixbuf_new (
      GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample,
      Int $width, Int $height
      --> N-GObject
    )

  * GdkColorspace $colorspace; Color space for image

  * Int $has_alpha; Whether the image should have transparency information

  * Int $bits_per_sample; Number of bits per color sample

  * Int $width; Width of image in pixels, must be > 0

  * Int $height; Height of image in pixels, must be > 0

[gdk_pixbuf_] calculate_rowstride
---------------------------------

Calculates the rowstride that an image created with those values would have. This is useful for front-ends and backends that want to sanity check image values without needing to create them.

Return value: the rowstride for the given values, or -1 in case of error.

Since: 2.36.8

    method gdk_pixbuf_calculate_rowstride (
      GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample,
      Int $width, Int $height
      --> Int
    )

  * GdkColorspace $colorspace; Color space for image

  * Int $has_alpha; Whether the image should have transparency information

  * Int $bits_per_sample; Number of bits per color sample

  * Int $width; Width of image in pixels, must be > 0

  * Int $height; Height of image in pixels, must be > 0

gdk_pixbuf_copy
---------------

Creates a new **Gnome::Gdk3::Pixbuf** with a copy of the information in the specified *pixbuf*. Note that this does not copy the options set on the original **Gnome::Gdk3::Pixbuf**, use `gdk_pixbuf_copy_options()` for this.

Return value: (nullable) (transfer full): A newly-created pixbuf with a reference count of 1, or `Any` if not enough memory could be allocated.

    method gdk_pixbuf_copy ( --> N-GObject  )

[gdk_pixbuf_] new_subpixbuf
---------------------------

Creates a new pixbuf which represents a sub-region this pixel buffer. The new pixbuf shares its pixels with the original pixbuf, so writing to one affects both. The new pixbuf holds a reference to this buffer, so this buffer will not be finalized until the new pixbuf is finalized.

Note that if this buffer is read-only, this function will force it to be mutable.

Return value: a new pixbuf

    method gdk_pixbuf_new_subpixbuf (
      Int $src_x, Int $src_y, Int $width, Int $height
      --> N-GObject
    )

  * Int $src_x; X coord in this pixel buffer

  * Int $src_y; Y coord in this pixel buffer

  * Int $width; width of region in this pixel buffer

  * Int $height; height of region in this pixel buffer

[gdk_pixbuf_] new_from_bytes
----------------------------

    method gdk_pixbuf_new_from_bytes ( N-GObject $data, GdkColorspace $colorspace, Int $has_alpha, Int $bits_per_sample, Int $width, Int $height, Int $rowstride --> N-GObject  )

  * N-GObject $data;

  * GdkColorspace $colorspace;

  * Int $has_alpha;

  * Int $bits_per_sample;

  * Int $width;

  * Int $height;

  * Int $rowstride;

[gdk_pixbuf_] new_from_xpm_data
-------------------------------

    method gdk_pixbuf_new_from_xpm_data ( CArray[Str] $data --> N-GObject  )

  * CArray[Str] $data;

gdk_pixbuf_fill
---------------

Clears a pixbuf to the given RGBA value, converting the RGBA value into the pixbuf's pixel format. The alpha will be ignored if the pixbuf doesn't have an alpha channel.

    method gdk_pixbuf_fill ( UInt $pixel )

  * UInt $pixel; RGBA pixel to clear to (0xffffffff is opaque white, 0x00000000 transparent black)

gdk_pixbuf_savev
----------------

    method gdk_pixbuf_savev ( Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

  * Str $filename;

  * Str $type;

  * CArray[Str] $option_keys;

  * CArray[Str] $option_values;

  * N-GError $error;

[gdk_pixbuf_] savev_utf8
------------------------

    method gdk_pixbuf_savev_utf8 ( Str $filename, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

  * Str $filename;

  * Str $type;

  * CArray[Str] $option_keys;

  * CArray[Str] $option_values;

  * N-GError $error;

[gdk_pixbuf_] save_to_bufferv
-----------------------------

    method gdk_pixbuf_save_to_bufferv ( CArray[Str] $buffer, UInt $buffer_size, Str $type, CArray[Str] $option_keys, CArray[Str] $option_values, N-GError $error --> Int  )

  * CArray[Str] $buffer;

  * UInt $buffer_size;

  * Str $type;

  * CArray[Str] $option_keys;

  * CArray[Str] $option_values;

  * N-GError $error;

[gdk_pixbuf_] add_alpha
-----------------------

    method gdk_pixbuf_add_alpha ( Int $substitute_color, UInt $r, UInt $g, UInt $b --> N-GObject  )

  * Int $substitute_color;

  * UInt $r;

  * UInt $g;

  * UInt $b;

[gdk_pixbuf_] copy_area
-----------------------

    method gdk_pixbuf_copy_area ( Int $src_x, Int $src_y, Int $width, Int $height, N-GObject $dest_pixbuf, Int $dest_x, Int $dest_y )

  * Int $src_x;

  * Int $src_y;

  * Int $width;

  * Int $height;

  * N-GObject $dest_pixbuf;

  * Int $dest_x;

  * Int $dest_y;

[gdk_pixbuf_] saturate_and_pixelate
-----------------------------------

    method gdk_pixbuf_saturate_and_pixelate ( N-GObject $dest, Num $saturation, Int $pixelate )

  * N-GObject $dest;

  * Num $saturation;

  * Int $pixelate;

[gdk_pixbuf_] apply_embedded_orientation
----------------------------------------

    method gdk_pixbuf_apply_embedded_orientation ( --> N-GObject  )

[gdk_pixbuf_] set_option
------------------------

Attaches a key/value pair as an option to a **Gnome::Gdk3::Pixbuf**. If *key* already exists in the list of options attached to *pixbuf*, the new value is ignored and `0` is returned.

Return value: `1` on success.

Since: 2.2

    method gdk_pixbuf_set_option ( Str $key, Str $value --> Int  )

  * Str $key; a nul-terminated string.

  * Str $value; a nul-terminated string.

[gdk_pixbuf_] get_option
------------------------

Looks up *key* in the list of options that may have been attached to the *pixbuf* when it was loaded, or that may have been attached by another function using `gdk_pixbuf_set_option()`.

For instance, the ANI loader provides "Title" and "Artist" options. The ICO, XBM, and XPM loaders provide "x_hot" and "y_hot" hot-spot options for cursor definitions. The PNG loader provides the tEXt ancillary chunk key/value pairs as options. Since 2.12, the TIFF and JPEG loaders return an "orientation" option string that corresponds to the embedded TIFF/Exif orientation tag (if present). Since 2.32, the TIFF loader sets the "multipage" option string to "yes" when a multi-page TIFF is loaded. Since 2.32 the JPEG and PNG loaders set "x-dpi" and "y-dpi" if the file contains image density information in dots per inch. Since 2.36.6, the JPEG loader sets the "comment" option with the comment EXIF tag.

Return value: the value associated with *key*. This is a nul-terminated string that should not be freed or `Any` if *key* was not found.

    method gdk_pixbuf_get_option ( Str $key --> Str  )

  * Str $key; a nul-terminated string.

[gdk_pixbuf_] remove_option
---------------------------

Remove the key/value pair option attached to a **Gnome::Gdk3::Pixbuf**.

Return value: `1` if an option was removed, `0` if not.

Since: 2.36

    method gdk_pixbuf_remove_option ( Str $key --> Int  )

  * Str $key; a nul-terminated string representing the key to remove.

[gdk_pixbuf_] copy_options
--------------------------

Copy the key/value pair options attached to a **Gnome::Gdk3::Pixbuf** to another. This is useful to keep original metadata after having manipulated a file. However be careful to remove metadata which you've already applied, such as the "orientation" option after rotating the image.

Return value: `1` on success.

Since: 2.36

    method gdk_pixbuf_copy_options ( N-GObject $dest_pixbuf --> Int  )

  * N-GObject $dest_pixbuf; the **Gnome::Gdk3::Pixbuf** to copy options to

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### _(Number of Channels

The number of samples per pixel. Currently, only 3 or 4 samples per pixel are supported.

The **Gnome::GObject::Value** type of property *n-channels* is `G_TYPE_INT`.

### _(Colorspace

_(The colorspace in which the samples are interpreted Default value: False

The **Gnome::GObject::Value** type of property *colorspace* is `G_TYPE_ENUM`.

### _(Has Alpha

_(Whether the pixbuf has an alpha channel Default value: False

The **Gnome::GObject::Value** type of property *has-alpha* is `G_TYPE_BOOLEAN`.

### _(Bits per Sample

The number of bits per sample. Currently only 8 bit per sample are supported.

The **Gnome::GObject::Value** type of property *bits-per-sample* is `G_TYPE_INT`.

### _(Width

The **Gnome::GObject::Value** type of property *width* is `G_TYPE_INT`.

### _(Height

The **Gnome::GObject::Value** type of property *height* is `G_TYPE_INT`.

### _(Rowstride

The number of bytes between the start of a row and the start of the next row. This number must (obviously) be at least as large as the width of the pixbuf.

The **Gnome::GObject::Value** type of property *rowstride* is `G_TYPE_INT`.

### _(Pixels

The **Gnome::GObject::Value** type of property *pixels* is `G_TYPE_POINTER`.

### _(Pixel Bytes

The **Gnome::GObject::Value** type of property *pixel-bytes* is `G_TYPE_BOXED`.

