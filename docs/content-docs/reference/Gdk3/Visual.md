Gnome::Gdk3::Visual
===================

Low-level display hardware information

Description
===========

A **Gnome::Gdk3::Visual** describes a particular video hardware display format. It includes information about the number of bits used for each color, the way the bits are translated into an RGB value for display, and the way the bits are stored in memory. For example, a piece of display hardware might support 24-bit color, 16-bit color, or 8-bit color; meaning 24/16/8-bit pixel sizes. For a given pixel size, pixels can be in different formats; for example the “red” element of an RGB pixel may be in the top 8 bits of the pixel, or may be in the lower 4 bits.

There are several standard visuals. The visual returned by `gdk-screen-get-system-visual()` is the system’s default visual, and the visual returned by `gdk-screen-get-rgba-visual()` should be used for creating windows with an alpha channel.

A number of functions are provided for determining the “best” available visual. For the purposes of making this determination, higher bit depths are considered better, and for visuals of the same bit depth, `GDK-VISUAL-PSEUDO-COLOR` is preferred at 8bpp, otherwise, the visual types are ranked in the order of(highest to lowest) `GDK-VISUAL-DIRECT-COLOR`, `GDK-VISUAL-TRUE-COLOR`, `GDK-VISUAL-PSEUDO-COLOR`, `GDK-VISUAL-STATIC-COLOR`, `GDK-VISUAL-GRAYSCALE`, then `GDK-VISUAL-STATIC-GRAY`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Visual;
    also is Gnome::GObject::Object;

Types
=====

enum GdkVisualType
------------------

A set of values that describe the manner in which the pixel values for a visual are converted into RGB values for display.

  * GDK-VISUAL-STATIC-GRAY: Each pixel value indexes a grayscale value directly.

  * GDK-VISUAL-GRAYSCALE: Each pixel is an index into a color map that maps pixel values into grayscale values. The color map can be changed by an application.

  * GDK-VISUAL-STATIC-COLOR: Each pixel value is an index into a predefined, unmodifiable color map that maps pixel values into RGB values.

  * GDK-VISUAL-PSEUDO-COLOR: Each pixel is an index into a color map that maps pixel values into rgb values. The color map can be changed by an application.

  * GDK-VISUAL-TRUE-COLOR: Each pixel value directly contains red, green, and blue components. Use `get-red-pixel-details()`, etc, to obtain information about how the components are assembled into a pixel value.

  * GDK-VISUAL-DIRECT-COLOR: Each pixel value contains red, green, and blue components as for `GDK-VISUAL-TRUE-COLOR`, but the components are mapped via a color table into the final output table instead of being converted directly.

Methods
=======

new
---

### :native-object

Create a Visual object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-blue-pixel-details
----------------------

Obtains values that are needed to calculate blue pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

    method get-blue-pixel-details ( --> List )

List returns the following;

  * UInt mask;

  * Int shift;

  * Int precision;

get-depth
---------

Returns the bit depth of this visual.

    method get-depth ( --> Int )

get-green-pixel-details
-----------------------

Obtains values that are needed to calculate green pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

    method get-green-pixel-details ( --> List )

List returns the following;

  * UInt mask;

  * Int shift;

  * Int precision;

get-red-pixel-details
---------------------

Obtains values that are needed to calculate red pixel values in TrueColor and DirectColor. The “mask” is the significant bits within the pixel. The “shift” is the number of bits left we must shift a primary for it to be in position (according to the "mask"). Finally, "precision" refers to how much precision the pixel value contains for a particular primary.

    method get-red-pixel-details ( --> List )

List returns the following;

  * UInt mask;

  * Int shift;

  * Int precision;

get-screen
----------

Gets the screen to which this visual belongs

Returns: the screen to which this visual belongs. Although, at this point, the return type is known, it is not possible to return a **Gnome::Gdk3::Screen** raku object because of code fails to require a raku object. The caller must do the following `Gnome::Gdk3::Screen.new(:native-object($v.get-screen))` locally to get the raku object.

get-visual-type
---------------

Returns the type of visual this is (PseudoColor, TrueColor, etc).

Returns: A **Gnome::Gdk3::VisualType** stating the type of *visual*.

    method get-visual-type ( --> GdkVisualType )

