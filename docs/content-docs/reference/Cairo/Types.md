cairo_t
-------

cairo_surface_t
---------------

cairo_pattern_t
---------------

cairo_matrix_t
--------------

cairo_path_data_t
-----------------

cairo_path_t
------------

cairo_font_face_t
-----------------

cairo_font_options_t
--------------------




cairo_font_extents_t
--------------------

cairo_text_extents_t
--------------------

The cairo_text_extents_t structure stores the extents of a single glyph or a string of glyphs in user-space coordinates. Because text extents are in user-space coordinates, they are mostly, but not entirely, independent of the current transformation matrix. If you call cairo_scale(cr, 2.0, 2.0), text will be drawn twice as big, but the reported text extents will not be doubled. They will change slightly due to hinting (so you can't assume that metrics are independent of the transformation matrix), but otherwise will remain unchanged.

  * double x_bearing; the horizontal distance from the origin to the leftmost part of the glyphs as drawn. Positive if the glyphs lie entirely to the right of the origin.

  * double y_bearing; the vertical distance from the origin to the topmost part of the glyphs as drawn. Positive only if the glyphs lie completely below the origin; will usually be negative.

  * double width; width of the glyphs as drawn

  * double height; height of the glyphs as drawn

  * double x_advance; distance to advance in the X direction after drawing these glyphs

  * double y_advance; distance to advance in the Y direction after drawing these glyphs. Will typically be zero except for vertical text layout as found in East-Asian languages.

cairo_device_t
--------------

cairo_rectangle_int_t
---------------------

A data structure for holding a rectangle with integer coordinates.

  * Int $.x; X coordinate of the left side of the rectangle

  * Int $.y; Y coordinate of the the top side of the rectangle

  * Int $.width; width of the rectangle

  * Int $.height; height of the rectangle

cairo_rectangle_t
-----------------

A data structure for holding a rectangle using doubles this time.

  * Num $.x; X coordinate of the left side of the rectangle

  * Num $.y; Y coordinate of the the top side of the rectangle

  * Num $.width; width of the rectangle

  * Num $.height; height of the rectangle

cairo_rectangle_list_t
----------------------

A data structure for holding a dynamically allocated array of rectangles.

  * cairo_status_t $.status; Error status of the rectangle list

  * CArray cairo_rectangle_t $.rectangles; Array containing cairo_rectangle_t rectangles

  * int $.num_rectangles; Number of rectangles in this list

cairo_glyph_t
-------------

The cairo_glyph_t structure holds information about a single glyph when drawing or measuring text. A font is (in simple terms) a collection of shapes used to draw text. A glyph is one of these shapes. There can be multiple glyphs for a single character (alternates to be used in different contexts, for example), or a glyph can be a ligature of multiple characters. Cairo doesn't expose any way of converting input text into glyphs, so in order to use the Cairo interfaces that take arrays of glyphs, you must directly access the appropriate underlying font system.

Note that the offsets given by x and y are not cumulative. When drawing or measuring text, each glyph is individually positioned with respect to the overall origin

  * int64 $.index; glyph index in the font. The exact interpretation of the glyph index depends on the font technology being used.

  * num64 $.x; the offset in the X direction between the origin used for drawing or measuring the string and the origin of this glyph.

  * num64 $.y; the offset in the Y direction between the origin used for drawing or measuring the string and the origin of this glyph.

cairo_text_cluster_t
--------------------

The cairo_text_cluster_t structure holds information about a single text cluster. A text cluster is a minimal mapping of some glyphs corresponding to some UTF-8 text.

For a cluster to be valid, both num_bytes and num_glyphs should be non-negative, and at least one should be non-zero. Note that clusters with zero glyphs are not as well supported as normal clusters. For example, PDF rendering applications typically ignore those clusters when PDF text is being selected.

See `cairo_show_text_glyphs()` for how clusters are used in advanced text operations.

  * int32 $.num_bytes; the number of bytes of UTF-8 text covered by cluster

  * int32 $.num_glyphs; the number of glyphs covered by cluster

