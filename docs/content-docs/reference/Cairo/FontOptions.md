Gnome::Cairo::FontOptions
=========================

How a font should be rendered

Description
===========

    The font options specify how fonts should be rendered.  Most of the  time the font options implied by a surface are just right and do not  need any changes, but for pixel-based targets tweaking font options  may result in superior output on a particular display.

See Also
--------

**cairo_scaled_font_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::FontOptions;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### new()

Create a new FontOptions object.

    multi method new ( )

cairo_font_options_create
-------------------------

Allocates a new font options object with all options initialized to default values. Return value: a newly allocated **cairo_font_options_t**. Free with `cairo_font_options_destroy()`. This function always returns a valid pointer; if memory cannot be allocated, then a special error object is returned where all operations on the object do nothing. You can check for this with `cairo_font_options_status()`.

    method cairo_font_options_create ( --> cairo_font_options_t )

cairo_font_options_copy
-----------------------

Allocates a new font options object copying the option values from *original*. Return value: a newly allocated **cairo_font_options_t**. Free with `cairo_font_options_destroy()`. This function always returns a valid pointer; if memory cannot be allocated, then a special error object is returned where all operations on the object do nothing. You can check for this with `cairo_font_options_status()`.

    method cairo_font_options_copy ( --> cairo_font_options_t )

cairo_font_options_status
-------------------------

Checks whether an error has previously occurred for this font options object Return value: `CAIRO_STATUS_SUCCESS` or `CAIRO_STATUS_NO_MEMORY`

    method cairo_font_options_status ( --> Int )

cairo_font_options_merge
------------------------

Merges non-default options from *other* into *options*, replacing existing values. This operation can be thought of as somewhat similar to compositing *other* onto *options* with the operation of `CAIRO_OPERATOR_OVER`.

    method cairo_font_options_merge ( cairo_font_options_t $other --> void )

  * cairo_font_options_t $other; a **cairo_font_options_t**

cairo_font_options_equal
------------------------

Compares two font options objects for equality. Return value: `1` if all fields of the two font options objects match. Note that this function will return `0` if either object is in error.

    method cairo_font_options_equal ( cairo_font_options_t $other --> Int )

  * cairo_font_options_t $other; a **cairo_font_options_t**

cairo_font_options_hash
-----------------------

Compute a hash for the font options object; this value will be useful when storing an object containing a **cairo_font_options_t** in a hash table. Return value: the hash value for the font options object. The return value can be cast to a 32-bit type if a 32-bit hash value is needed.

    method cairo_font_options_hash ( --> UInt )

[cairo_font_options_] set_antialias
-----------------------------------

Sets the antialiasing mode for the font options object. This specifies the type of antialiasing to do when rendering text.

    method cairo_font_options_set_antialias ( Int $antialias --> void )

  * Int $antialias; a **cairo_font_options_t**

[cairo_font_options_] get_antialias
-----------------------------------

Gets the antialiasing mode for the font options object. Return value: the antialiasing mode

    method cairo_font_options_get_antialias ( --> Int )

[cairo_font_options_] set_subpixel_order
----------------------------------------

Sets the subpixel order for the font options object. The subpixel order specifies the order of color elements within each pixel on the display device when rendering with an antialiasing mode of `CAIRO_ANTIALIAS_SUBPIXEL`. See the documentation for **cairo_subpixel_order_t** for full details.

    method cairo_font_options_set_subpixel_order ( Int $subpixel_order --> void )

  * Int $subpixel_order; a **cairo_font_options_t**

[cairo_font_options_] get_subpixel_order
----------------------------------------

Gets the subpixel order for the font options object. See the documentation for **cairo_subpixel_order_t** for full details. Return value: the subpixel order for the font options object

    method cairo_font_options_get_subpixel_order ( --> Int )

[cairo_font_options_] set_hint_style
------------------------------------

Sets the hint style for font outlines for the font options object. This controls whether to fit font outlines to the pixel grid, and if so, whether to optimize for fidelity or contrast. See the documentation for **cairo_hint_style_t** for full details.

    method cairo_font_options_set_hint_style ( Int $hint_style --> void )

  * Int $hint_style; a **cairo_font_options_t**

[cairo_font_options_] get_hint_style
------------------------------------

Gets the hint style for font outlines for the font options object. See the documentation for **cairo_hint_style_t** for full details. Return value: the hint style for the font options object

    method cairo_font_options_get_hint_style ( --> Int )

[cairo_font_options_] set_hint_metrics
--------------------------------------

Sets the metrics hinting mode for the font options object. This controls whether metrics are quantized to integer values in device units. See the documentation for **cairo_hint_metrics_t** for full details.

    method cairo_font_options_set_hint_metrics ( Int $hint_metrics --> void )

  * Int $hint_metrics; a **cairo_font_options_t**

[cairo_font_options_] get_hint_metrics
--------------------------------------

Gets the metrics hinting mode for the font options object. See the documentation for **cairo_hint_metrics_t** for full details. Return value: the metrics hinting mode for the font options object

    method cairo_font_options_get_hint_metrics ( --> Int )

[cairo_font_options_] set_variations
------------------------------------

Sets the OpenType font variations for the font options object. Font variations are specified as a string with a format that is similar to the CSS font-variation-settings. The string contains a comma-separated list of axis assignments, which each assignment consists of a 4-character axis name and a value, separated by whitespace and optional equals sign. Examples: wght=200,wdth=140.5 wght 200 , wdth 140.5

    method cairo_font_options_set_variations ( Str $variations --> void )

  * Str $variations; a **cairo_font_options_t**

[cairo_font_options_] get_variations
------------------------------------

Gets the OpenType font variations for the font options object. See `cairo_font_options_set_variations()` for details about the string format. Return value: the font variations for the font options object. The returned string belongs to the *options* and must not be modified. It is valid until either the font options object is destroyed or the font variations in this object is modified with `cairo_font_options_set_variations()`.

    method cairo_font_options_get_variations ( --> Str )

