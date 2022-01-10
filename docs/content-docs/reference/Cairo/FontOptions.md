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

### :native-object

Create a FontOptions object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

equal
-----

Compares two font options objects for equality.

Return value: `True` if all fields of the two font options objects match. Note that this function will return `False` if either object is in error.

    method equal ( cairo_font_options_t $other --> Bool )

  * $other; another **Gnome::Cairo::FontOptions**

get-antialias
-------------

Gets the antialiasing mode for the font options object. Return value: the antialiasing mode

    method get-antialias ( --> cairo_antialias_t )

get-hint-metrics
----------------

Gets the metrics hinting mode for the font options object. See the documentation for **cairo-hint-metrics-t** for full details. Return value: the metrics hinting mode for the font options object

    method get-hint-metrics ( --> cairo_hint_metrics_t )

get-hint-style
--------------

Gets the hint style for font outlines for the font options object. See the documentation for **cairo-hint-style-t** for full details.

Return value: the hint style for the font options object

    method get-hint-style ( --> cairo_hint_style_t )

get-subpixel-order
------------------

Gets the subpixel order for the font options object. See the documentation for **cairo-subpixel-order-t** for full details.

Return value: the subpixel order for the font options object

    method get-subpixel-order ( --> cairo_subpixel_order_t )

get-variations
--------------

Gets the OpenType font variations for the font options object. See `set-variations()` for details about the string format.

Return value: the font variations for the font options object. The returned string belongs to the *options* and must not be modified. It is valid until either the font options object is destroyed or the font variations in this object is modified with `set-variations()`.

    method get-variations ( --> Str )

merge
-----

Merges non-default options from *$other* into *options*, replacing existing values. This operation can be thought of as somewhat similar to compositing *$other* onto *options* with the operation of `CAIRO-OPERATOR-OVER`.

    method merge ( cairo_font_options_t $other )

  * $other; another **Gnome::Cairo::FontOptions**

set-antialias
-------------

Sets the antialiasing mode for the font options object. This specifies the type of antialiasing to do when rendering text.

    method set-antialias ( cairo_antialias_t $antialias )

  * $antialias; the new antialiasing mode

set-hint-metrics
----------------

Sets the metrics hinting mode for the font options object. This controls whether metrics are quantized to integer values in device units. See the documentation for **cairo-hint-metrics-t** for full details.

    method set-hint-metrics ( cairo_hint_metrics_t $hint_metrics )

  * $hint_metrics; the new metrics hinting mode

set-hint-style
--------------

Sets the hint style for font outlines for the font options object. This controls whether to fit font outlines to the pixel grid, and if so, whether to optimize for fidelity or contrast. See the documentation for **cairo-hint-style-t** for full details.

    method set-hint-style ( cairo_hint_style_t $hint_style )

  * $hint_style; the new hint style

set-subpixel-order
------------------

Sets the subpixel order for the font options object. The subpixel order specifies the order of color elements within each pixel on the display device when rendering with an antialiasing mode of `CAIRO-ANTIALIAS-SUBPIXEL`. See the documentation for **cairo-subpixel-order-t** for full details.

    method set-subpixel-order ( cairo_subpixel_order_t $subpixel_order )

  * $subpixel_order; the new subpixel order

set-variations
--------------

Sets the OpenType font variations for the font options object. Font variations are specified as a string with a format that is similar to the CSS font-variation-settings. The string contains a comma-separated list of axis assignments, which each assignment consists of a 4-character axis name and a value, separated by whitespace and optional equals sign.

Examples: `wght=200,wdth=140.5` or `wght 200 , wdth 140.5` or mixed.

    method set-variations ( )

  * $variations; the new font variations, or `Any`

status
------

Checks whether an error has previously occurred for this font options object

Return value: `CAIRO_STATUS_SUCCESS` or `CAIRO_STATUS_NO-MEMORY`

    method status ( --> cairo_status_t )

