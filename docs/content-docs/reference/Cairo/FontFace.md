Gnome::Cairo::FontFace
======================

Base class for font faces

Description
===========

**cairo_font_face_t** represents a particular font at a particular weight, slant, and other characteristic but no size, transformation, or size.

Font faces are created using *font-backend*-specific constructors, typically of the form `cairo_B<backend>_font_face_create( )`, or implicitly using the *toy* text API by way of `cairo_select_font_face()`. The resulting face can be accessed using `cairo_get_font_face()`.

See Also
--------

**cairo_scaled_font_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::FontFace;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

[cairo_font_face_] get_type
---------------------------

This function returns the type of the backend used to create a font face. See **cairo_font_type_t** for available types. Return value: The type of *font_face*.

    method cairo_font_face_get_type ( --> Int )

[cairo_font_face_] get_reference_count
--------------------------------------

Returns the current reference count of *font_face*. Return value: the current reference count of *font_face*. If the object is a nil object, 0 will be returned.

    method cairo_font_face_get_reference_count ( --> UInt )

cairo_font_face_status
----------------------

Checks whether an error has previously occurred for this font face Return value: `CAIRO_STATUS_SUCCESS` or another error such as `CAIRO_STATUS_NO_MEMORY`.

    method cairo_font_face_status ( --> Int )

