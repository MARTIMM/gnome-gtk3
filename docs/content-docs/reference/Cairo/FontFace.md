Gnome::Cairo::FontFace
======================

Base class for font faces

Description
===========

**Gnome::Cairo::FontFace** represents a particular font at a particular weight, slant, and other characteristic but no size, transformation, or size.

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::FontFace;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

There are no creation methods to get a new **Gnome::Cairo::FontFace**. You can import it from elsewhere when a native object is returned or sometimes the Raku object can be produced like the `Gnome::Cairo.get-font-face()` call;

    my Gnome::Cairo::FontFace $ff = $context.get-font-face;

### :native-object

Create a FontFace object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-type
--------

This function returns the type of the backend used to create a font face. See **cairo-font-type-t** for available types. Return value: The type of *font-face*.

    method get-type ( --> cairo_font_type_t )

status
------

Checks whether an error has previously occurred for this font face Return value: `CAIRO_STATUS_SUCCESS` or another error such as `CAIRO_STATUS_NO-MEMORY`.

    method status ( --> cairo_status_t )

