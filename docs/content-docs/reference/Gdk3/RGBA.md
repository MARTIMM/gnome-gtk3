Gnome::Gdk3::Rgba
=================

RGBA colors

Description
===========

**Gnome::Gdk3::RGBA** is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::RGBA;
    also is Gnome::GObject::Boxed;

Example
-------

    my GdkRGBA $color .= new(
      :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
    );

GdkRGBA
-------

GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

  * $.red; The intensity of the red channel from 0.0 to 1.0 inclusive

  * $.green; The intensity of the green channel from 0.0 to 1.0 inclusive

  * $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive

  * $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

Methods
=======

new
---

Create a new object using colors and transparency values. Their ranges are from 0 to 1

    multi method new ( Num :$red!, Num :$green!, Num :$blue!, Num :$alpha! )

Create an object using a string which is parsed with `gdk_rgba_parse()`. If parsing fails, the color is set to opaque white.

    multi method new ( Str :$rgba! )

Create an object using a native object from elsewhere.

    multi method new ( Gnome::GObject::Object :$rgba! )

gdk_rgba_copy
-------------

Makes a copy of a **Gnome::Gdk3::RGBA**.

Returns: A newly allocated **Gnome::Gdk3::RGBA**, with the same contents as *rgba*

Since: 3.0

    method gdk_rgba_copy ( N-GObject $rgba --> N-GObject  )

  * N-GdkRGBA $rgba; a **Gnome::Gdk3::RGBA**

gdk_rgba_hash
-------------

A method that stores **Gnome::Gdk3::RGBAs** values in a hash or to return a value. Note that the original GTK function only returns a uint32 value and does not provide a hash table storage facility

    multi method gdk_rgba_hash ( N-GdkRGBA $p --> UInt )

    multi method gdk_rgba_hash ( UInt $hash-int --> N-GdkRGBA )

  * N-GdkRGBA $p; a **Gnome::Gdk3::RGBA** value to store

  * UInt $hash-int; a key to return a previously stored **N-GdkRGBA** value

gdk_rgba_equal
--------------

Compare native RGBA color with a given one.

Returns: `1` if the two colors compare equal

Since: 3.0

    method gdk_rgba_equal ( N-GdkRGBA $compare-with --> Int )

  * N-GdkRGBA $compare-with; another **Gnome::Gdk3::RGBA** pointer

gdk_rgba_parse
--------------

Parses a textual representation of a color and set / overwrite the values in the *red*, *green*, *blue* and *alpha* fields in this **Gnome::Gdk3::RGBA**.

The string can be either one of: - A standard name (Taken from the X11 rgb.txt file). - A hexadecimal value in the form “\**rgb**”, “\**rrggbb**”, “\**rrrgggbbb**” or ”\**rrrrggggbbbb**” - A RGB color in the form “rgb(r,g,b)” (In this case the color will have full opacity) - A RGBA color in the form “rgba(r,g,b,a)”

Where “r”, “g”, “b” and “a” are respectively the red, green, blue and alpha color values. In the last two cases, r g and b are either integers in the range 0 to 255 or precentage values in the range 0% to 100%, and a is a floating point value in the range 0 to 1.

Returns: `1` if the parsing succeeded

Since: 3.0

    method gdk_rgba_parse ( Str $spec --> Int )

  * N-GObject $rgba; the **Gnome::Gdk3::RGBA** to fill in

  * Str $spec; the string specifying the color

[gdk_rgba_] to_string
---------------------

Returns a textual specification of *rgba* in the form `rgb (r, g, b)` or `rgba (r, g, b, a)`, where “r”, “g”, “b” and “a” represent the red, green, blue and alpha values respectively. r, g, and b are represented as integers in the range 0 to 255, and a is represented as floating point value in the range 0 to 1.

These string forms are string forms those supported by the CSS3 colors module, and can be parsed by `gdk_rgba_parse()`.

Note that this string representation may lose some precision, since r, g and b are represented as 8-bit integers. If this is a concern, you should use a different representation.

Returns: A newly allocated text string

Since: 3.0

    method gdk_rgba_to_string ( N-GdkRGBA $rgba --> Str  )

  * N-GObject $rgba; a native **Gnome::Gdk3::RGBA**

