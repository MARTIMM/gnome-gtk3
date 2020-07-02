Gnome::Cairo::ScaledFont
========================

Font face at particular size and options

Description
===========

    B<cairo_scaled_font_t> represents a realization of a font face at a particular size and transformation and a certain set of font options.

See Also
--------

**cairo_font_face_t**, **cairo_matrix_t**, **cairo_font_options_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::ScaledFont;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### new()

Create a new ScaledFont object.

    multi method new ( )

[cairo_scaled_font_] get_type
-----------------------------

This function returns the type of the backend used to create a scaled font. See **cairo_font_type_t** for available types. However, this function never returns `CAIRO_FONT_TYPE_TOY`. Return value: The type of *scaled_font*.

    method cairo_scaled_font_get_type ( --> Int )

cairo_scaled_font_status
------------------------

Checks whether an error has previously occurred for this scaled_font. Return value: `CAIRO_STATUS_SUCCESS` or another error such as `CAIRO_STATUS_NO_MEMORY`.

    method cairo_scaled_font_status ( --> Int )

cairo_scaled_font_create
------------------------

Creates a **cairo_scaled_font_t** object from a font face and matrices that describe the size of the font and the environment in which it will be used. Return value: a newly created **cairo_scaled_font_t**. Destroy with `cairo_scaled_font_destroy()`

    method cairo_scaled_font_create ( cairo_font_face_t $font_face, cairo_matrix_t $font_matrix, cairo_matrix_t $ctm, cairo_font_options_t $options --> cairo_scaled_font_t )

  * cairo_font_face_t $font_face; cairo_scaled_font_create:

  * cairo_matrix_t $font_matrix; a **cairo_font_face_t**

  * cairo_matrix_t $ctm; font space to user space transformation matrix for the font. In the simplest case of a N point font, this matrix is just a scale by N, but it can also be used to shear the font or stretch it unequally along the two axes. See `cairo_set_font_matrix()`.

  * cairo_font_options_t $options; user to device transformation matrix with which the font will be used.

cairo_scaled_font_reference
---------------------------

Increases the reference count on *scaled_font* by one. This prevents *scaled_font* from being destroyed until a matching call to `cairo_scaled_font_destroy()` is made. Use `cairo_scaled_font_get_reference_count()` to get the number of references to a **cairo_scaled_font_t**. Returns: the referenced **cairo_scaled_font_t**

    method cairo_scaled_font_reference ( --> cairo_scaled_font_t )

cairo_scaled_font_destroy
-------------------------

Decreases the reference count on *font* by one. If the result is zero, then *font* and all associated resources are freed. See `cairo_scaled_font_reference()`.

    method cairo_scaled_font_destroy ( --> void )

[cairo_scaled_font_] get_reference_count
----------------------------------------

Returns the current reference count of *scaled_font*. Return value: the current reference count of *scaled_font*. If the object is a nil object, 0 will be returned.

    method cairo_scaled_font_get_reference_count ( --> UInt )

cairo_scaled_font_extents
-------------------------

Gets the metrics for a **cairo_scaled_font_t**.

    method cairo_scaled_font_extents ( cairo_font_extents_t $extents --> void )

  * cairo_font_extents_t $extents; a **cairo_scaled_font_t**

[cairo_scaled_font_] text_extents
---------------------------------

Gets the extents for a string of text. The extents describe a user-space rectangle that encloses the "inked" portion of the text drawn at the origin (0,0) (as it would be drawn by `cairo_show_text()` if the cairo graphics state were set to the same font_face, font_matrix, ctm, and font_options as *scaled_font*). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `cairo_show_text()`. Note that whitespace characters do not directly contribute to the size of the rectangle (extents.width and extents.height). They do contribute indirectly by changing the position of non-whitespace characters. In particular, trailing whitespace characters are likely to not affect the size of the rectangle, though they will affect the x_advance and y_advance values.

    method cairo_scaled_font_text_extents ( Str $utf8, cairo_text_extents_t $extents --> void )

  * Str $utf8; a **cairo_scaled_font_t**

  * cairo_text_extents_t $extents; a NUL-terminated string of text, encoded in UTF-8

[cairo_scaled_font_] glyph_extents
----------------------------------

Gets the extents for an array of glyphs. The extents describe a user-space rectangle that encloses the "inked" portion of the glyphs, (as they would be drawn by `cairo_show_glyphs()` if the cairo graphics state were set to the same font_face, font_matrix, ctm, and font_options as *scaled_font*). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `cairo_show_glyphs()`. Note that whitespace glyphs do not contribute to the size of the rectangle (extents.width and extents.height).

    method cairo_scaled_font_glyph_extents ( cairo_glyph_t $glyphs, Int $num_glyphs, cairo_text_extents_t $extents --> void )

  * cairo_glyph_t $glyphs; a **cairo_scaled_font_t**

  * Int $num_glyphs; an array of glyph IDs with X and Y offsets.

  * cairo_text_extents_t $extents; the number of glyphs in the *glyphs* array

[cairo_scaled_font_] get_font_face
----------------------------------

Gets the font face that this scaled font uses. This might be the font face passed to `cairo_scaled_font_create()`, but this does not hold true for all possible cases. Return value: The **cairo_font_face_t** with which *scaled_font* was created. This object is owned by cairo. To keep a reference to it, you must call `cairo_scaled_font_reference()`.

    method cairo_scaled_font_get_font_face ( --> cairo_font_face_t )

[cairo_scaled_font_] get_font_matrix
------------------------------------

Stores the font matrix with which *scaled_font* was created into *matrix*.

    method cairo_scaled_font_get_font_matrix ( cairo_matrix_t $font_matrix --> void )

  * cairo_matrix_t $font_matrix; a **cairo_scaled_font_t**

[cairo_scaled_font_] get_ctm
----------------------------

Stores the CTM with which *scaled_font* was created into *ctm*. Note that the translation offsets (x0, y0) of the CTM are ignored by `cairo_scaled_font_create()`. So, the matrix this function returns always has 0,0 as x0,y0.

    method cairo_scaled_font_get_ctm ( cairo_matrix_t $ctm --> void )

  * cairo_matrix_t $ctm; a **cairo_scaled_font_t**

[cairo_scaled_font_] get_scale_matrix
-------------------------------------

Stores the scale matrix of *scaled_font* into *matrix*. The scale matrix is product of the font matrix and the ctm associated with the scaled font, and hence is the matrix mapping from font space to device space.

    method cairo_scaled_font_get_scale_matrix ( cairo_matrix_t $scale_matrix --> void )

  * cairo_matrix_t $scale_matrix; a **cairo_scaled_font_t**

[cairo_scaled_font_] get_font_options
-------------------------------------

Stores the font options with which *scaled_font* was created into *options*.

    method cairo_scaled_font_get_font_options ( cairo_font_options_t $options --> void )

  * cairo_font_options_t $options; a **cairo_scaled_font_t**

