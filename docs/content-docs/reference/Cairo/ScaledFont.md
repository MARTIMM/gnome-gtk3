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

create
------

Creates a **t** object from a font face and matrices that describe the size of the font and the environment in which it will be used. Return value: a newly created **t**. Destroy with `destroy()`

    method create ( cairo_font_face_t $font_face, cairo_matrix_t $font_matrix, cairo_matrix_t $ctm, cairo_font_options_t $options --> cairo_scaled_font_t )

  * $font_face; a **cairo-font-face-t**

  * $font_matrix; font space to user space transformation matrix for the font. In the simplest case of a N point font, this matrix is just a scale by N, but it can also be used to shear the font or stretch it unequally along the two axes. See `cairo-set-font-matrix()`.

  * $ctm; user to device transformation matrix with which the font will be used.

  * $options; options to use when getting metrics for the font and rendering with it.

destroy
-------

Decreases the reference count on *font* by one. If the result is zero, then *font* and all associated resources are freed. See `reference()`.

    method destroy ( )

extents
-------

Gets the metrics for a **t**.

    method extents ( cairo_font_extents_t $extents )

  * $extents; a **cairo-font-extents-t** which to store the retrieved extents.

get-ctm
-------

Stores the CTM with which *scaled-font* was created into *ctm*. Note that the translation offsets (x0, y0) of the CTM are ignored by `create()`. So, the matrix this function returns always has 0,0 as x0,y0.

    method get-ctm ( cairo_matrix_t $ctm )

  * $ctm; return value for the CTM

get-font-face
-------------

Gets the font face that this scaled font uses. This might be the font face passed to `create()`, but this does not hold true for all possible cases. Return value: The **cairo-font-face-t** with which *scaled-font* was created. This object is owned by cairo. To keep a reference to it, you must call `reference()`.

    method get-font-face ( --> cairo_font_face_t )

get-font-matrix
---------------

Stores the font matrix with which *scaled-font* was created into *matrix*.

    method get-font-matrix ( cairo_matrix_t $font_matrix )

  * $font_matrix; return value for the matrix

get-font-options
----------------

Stores the font options with which *scaled-font* was created into *options*.

    method get-font-options ( cairo_font_options_t $options )

  * $options; return value for the font options

get-reference-count
-------------------

Returns the current reference count of *scaled-font*. Return value: the current reference count of *scaled-font*. If the object is a nil object, 0 will be returned.

    method get-reference-count ( --> Int )

get-scale-matrix
----------------

Stores the scale matrix of *scaled-font* into *matrix*. The scale matrix is product of the font matrix and the ctm associated with the scaled font, and hence is the matrix mapping from font space to device space.

    method get-scale-matrix ( cairo_matrix_t $scale_matrix )

  * $scale_matrix; return value for the matrix

get-type
--------

This function returns the type of the backend used to create a scaled font. See **cairo-font-type-t** for available types. However, this function never returns `CAIRO-FONT-TYPE-TOY`. Return value: The type of *scaled-font*.

    method get-type ( --> cairo_font_type_t )

glyph-extents
-------------

Gets the extents for an array of glyphs. The extents describe a user-space rectangle that encloses the "inked" portion of the glyphs, (as they would be drawn by `cairo-show-glyphs()` if the cairo graphics state were set to the same font-face, font-matrix, ctm, and font-options as *scaled-font*). Additionally, the x-advance and y-advance values indicate the amount by which the current point would be advanced by `cairo-show-glyphs()`. Note that whitespace glyphs do not contribute to the size of the rectangle (extents.width and extents.height).

    method glyph-extents ( cairo_glyph_t $glyphs, Int $num_glyphs, cairo_text_extents_t $extents )

  * $glyphs; an array of glyph IDs with X and Y offsets.

  * $num_glyphs; the number of glyphs in the *glyphs* array

  * $extents; a **cairo-text-extents-t** which to store the retrieved extents.

reference
---------

Increases the reference count on *scaled-font* by one. This prevents *scaled-font* from being destroyed until a matching call to `destroy()` is made. Use `get-reference-count()` to get the number of references to a **t**. Returns: the referenced **t**

    method reference ( --> cairo_scaled_font_t )

status
------

Checks whether an error has previously occurred for this scaled-font. Return value: `CAIRO-STATUS-SUCCESS` or another error such as `CAIRO-STATUS-NO-MEMORY`.

    method status ( --> cairo_status_t )

text-extents
------------

Gets the extents for a string of text. The extents describe a user-space rectangle that encloses the "inked" portion of the text drawn at the origin (0,0) (as it would be drawn by `cairo-show-text()` if the cairo graphics state were set to the same font-face, font-matrix, ctm, and font-options as *scaled-font*). Additionally, the x-advance and y-advance values indicate the amount by which the current point would be advanced by `cairo-show-text()`. Note that whitespace characters do not directly contribute to the size of the rectangle (extents.width and extents.height). They do contribute indirectly by changing the position of non-whitespace characters. In particular, trailing whitespace characters are likely to not affect the size of the rectangle, though they will affect the x-advance and y-advance values.

    method text-extents ( cairo_text_extents_t $extents )

  * $utf8; a NUL-terminated string of text, encoded in UTF-8

  * $extents; a **cairo-text-extents-t** which to store the retrieved extents.

