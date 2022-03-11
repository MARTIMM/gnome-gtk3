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

    my Gnome::Gdk3::RGBA $color .= new(
      :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
    );

Types
=====

N-GdkRGBA
---------

N-GdkRGBA is a convenient way to pass rgba colors around. It’s based on cairo’s way to deal with colors and mirrors its behavior. All values are in the range from 0.0 to 1.0 inclusive. So the color (0.0, 0.0, 0.0, 0.0) represents transparent black and (1.0, 1.0, 1.0, 1.0) is opaque white. Other values will be clamped to this range when drawing.

The colors originally where **Num** type but they can now also be **Int**, **Rat**, **Str** or **Num** as long as they represent a number between 0 and 1.

  * $.red; The intensity of the red channel from 0.0 to 1.0 inclusive

  * $.green; The intensity of the green channel from 0.0 to 1.0 inclusive

  * $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive

  * $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

    my N-GdkRGBA $c .= new( :red(1), :green(1), :blue(0.5), :alpha(0.99));

Methods
=======

new
---

### :red, :green, :blue, :alpha

Create a new object using colors and transparency values. Their ranges are from 0 to 1. All values are optional and are set to 1e0 by default.

    multi method new (
      Num() :$red, Num() :$green, Num() :$blue, Num() :$alpha
    )

  * $.red; The intensity of the red channel from 0.0 to 1.0 inclusive

  * $.green; The intensity of the green channel from 0.0 to 1.0 inclusive

  * $.blue; The intensity of the blue channel from 0.0 to 1.0 inclusive

  * $.alpha; The opacity of the color from 0.0 for completely translucent to 1.0 for opaque

### :rgba

Create an object using a string which is parsed with `parse()`. If parsing fails, the color is set to opaque white.

    multi method new ( Str :$rgba! )

### :native-object

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelSupportClass**.

    multi method new ( N-GObject :$native-object! )

alpha
-----

Set the alpha transparency to a new value if provided. Returns original or newly set value.

    method alpha ( Num $c? --> Num )

blue
----

Set the blue color to a new value if provided. Returns original or newly set color value.

    method blue ( Num $c? --> Num )

copy
----

Makes a copy of a **Gnome::Gdk3::RGBA**.

Returns: A newly allocated **Gnome::Gdk3::RGBA**, with the same contents as this *rgba* object

    method copy ( --> N-GObject )

  * N-GdkRGBA $rgba; a **Gnome::Gdk3::RGBA**

equal
-----

Compare native RGBA color with a given one.

Returns: `True` if the two colors compare equal

    method equal ( N-GObject() $compare-with --> Bool )

  * $compare-with; another **Gnome::Gdk3::RGBA** object

green
-----

Set the green color to a new value if provided. Returns original or newly set color value.

    method green ( Num $c? --> Num )

hash
----

A method that stores **Gnome::Gdk3::RGBA** objects in a hash or to return a value. Note that the original GTK function only returns a `UInt` value and does not provide a hash table storage facility.

    multi method hash ( N-GObject() $p --> UInt )

    multi method hash ( UInt $key --> N-GObject )

  * $p; a **Gnome::Gdk3::RGBA** value to store

  * $key; a key to return a previously stored **N-GdkRGBA** value

parse
-----

Parses a textual representation of a color and set / overwrite the values in the *red*, *green*, *blue* and *alpha* fields in this **Gnome::Gdk3::RGBA** object.

The string can be either one of:

  * A standard name (Taken from the X11 rgb.txt file).

  * A hexadecimal value in the form **#rgb**, **#rrggbb**, **#rrrgggbbb** or **#rrrrggggbbbb**.

  * A RGB color in the form **rgb(r,g,b)** (In this case the color will have full opacity).

  * A RGBA color in the form **rgba(r,g,b,a)**.

Where “r”, “g”, “b” and “a” are respectively the red, green, blue and alpha color values. In the last two cases, r g and b are either integers in the range 0 to 255 or precentage values in the range 0% to 100%, and a is a floating point value in the range 0 to 1.

Returns: `True` if the parsing succeeded

    method parse ( Str $spec --> Bool )

  * Str $spec; the string specifying the color

red
---

Set the red color to a new value if provided. Returns original or newly set color value.

    method red ( Num() $c? --> Num )

to-string
---------

Returns a textual specification of this rgba object in the form **rgb(r,g,b)** or **rgba(r,g,b,a)**, where `r`, `g`, `b` and `a` represent the red, green, blue and alpha values respectively. r, g, and b are represented as integers in the range 0 to 255, and a is represented as floating point value in the range 0 to 1.

These string forms are string forms those supported by the CSS3 colors module, and can be parsed by `parse()`.

Note that this string representation may lose some precision, since r, g and b are represented as 8-bit integers. If this is a concern, you should use a different representation.

Returns: A newly allocated text string

    method to-string ( --> Str )

  * N-GObject $rgba; a native **Gnome::Gdk3::RGBA**

