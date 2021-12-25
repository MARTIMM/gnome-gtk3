Gnome::Cairo
============

The cairo drawing context

Description
===========

    B<cairo_t> is the main object used when drawing with cairo. To draw with cairo, you create a B<cairo_t>, set the target surface, and drawing options for the B<cairo_t>, create shapes with functions like C<cairo_move_to()> and C<cairo_line_to()>, and then draw shapes with C<cairo_stroke()> or C<cairo_fill()>.
    B<cairo_t> 's can be pushed to a stack via C<cairo_save()>. They may then safely be changed, without losing the current state. Use C<cairo_restore()> to restore to the saved state.

See Also
--------

**cairo_surface_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### new(:surface)

Creates a new **cairo_t** with all graphics state parameters set to default values and with *target* as a target surface. The target surface should be constructed with a backend-specific function such as `cairo_image_surface_create()` (or any other `cairo_B<backend>_surface_create( )` variant).

This function references *target*, so you can immediately call `cairo_surface_destroy()` on it if you don't need to maintain a separate reference to it.

The object is cleared with `clear-object()` when you are done using the **cairo_t**. This function never returns `Any`. If memory cannot be allocated, a special **cairo_t** object will be returned on which `cairo_status()` returns `CAIRO_STATUS_NO_MEMORY`. If you attempt to target a surface which does not support writing (such as **cairo_mime_surface_t**) then a `CAIRO_STATUS_WRITE_ERROR` will be raised.

You can use this object normally, but no drawing will be done.

    multi method new ( cairo_surface_t :$surface )

  * cairo_surface_t $surface;

### :native-object

Create a **Gnome::Cairo** object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

append-path
-----------

Append the *path* onto the current path. The *path* may be either the return value from one of `cairo_copy_path()` or `cairo_copy_path_flat()` or it may be constructed manually. See **cairo_path_t** for details on how the path data structure should be initialized, and note that <literal>path->status</literal> must be initialized to `CAIRO_STATUS_SUCCESS`.

    method append-path ( cairo_path_t $path )

  * cairo_path_t $path; a cairo context

arc
---

Adds a circular arc of the given *radius* to the current path. The arc is centered at (*xc*, *yc*), begins at *angle1* and proceeds in the direction of increasing angles to end at *angle2*. If *angle2* is less than *angle1* it will be progressively increased by <literal>2*M_P*/literal* until it is greater than *angle1*. If there is a current point, an initial line segment will be added to the path to connect the current point to the beginning of the arc. If this initial line is undesired, it can be avoided by calling `cairo_new_sub_path()` before calling `cairo_arc()`. Angles are measured in radians. An angle of 0.0 is in the direction of the positive X axis (in user space). An angle of <literal>M_PI/2.0</literal> radians (90 degrees) is in the direction of the positive Y axis (in user space). Angles increase in the direction from the positive X axis toward the positive Y axis. So with the default transformation matrix, angles increase in a clockwise direction. (To convert from degrees to radians, use <literal>degrees * (M_PI / 180.)</literal>.) This function gives the arc in the direction of increasing angles; see `cairo_arc_negative()` to get the arc in the direction of decreasing angles. The arc is circular in user space. To achieve an elliptical arc, you can scale the current transformation matrix by different amounts in the X and Y directions. For example, to draw an ellipse in the box given by *x*, *y*, *width*, *height*:

    cairo_save (cr); cairo_translate (cr, x + width / 2., y + height / 2.); cairo_scale (cr, width / 2., height / 2.); cairo_arc (cr, 0., 0., 1., 0., 2 * M_PI); cairo_restore (cr);



     method arc (
       Num $xc, Num $yc, Num $radius, Num $angle1, Num $angle2
     )

  * Num $xc; a cairo context

  * Num $yc; X position of the center of the arc

  * Num $radius; Y position of the center of the arc

  * Num $angle1; the radius of the arc

  * Num $angle2; the start angle, in radians

arc-negative
------------

Adds a circular arc of the given *radius* to the current path. The arc is centered at (*xc*, *yc*), begins at *angle1* and proceeds in the direction of decreasing angles to end at *angle2*. If *angle2* is greater than *angle1* it will be progressively decreased by <literal>2*M_P*/literal* until it is less than *angle1*. See `cairo_arc()` for more details. This function differs only in the direction of the arc between the two angles.

    method arc-negative (
      Num $xc, Num $yc, Num $radius, Num $angle1, Num $angle2
    )

  * Num $xc; a cairo context

  * Num $yc; X position of the center of the arc

  * Num $radius; Y position of the center of the arc

  * Num $angle1; the radius of the arc

  * Num $angle2; the start angle, in radians

clip
----

Establishes a new clip region by intersecting the current clip region with the current path as it would be filled by `cairo_fill()` and according to the current fill rule (see `cairo_set_fill_rule()`). After `cairo_clip()`, the current path will be cleared from the cairo context. The current clip region affects all drawing operations by effectively masking out any changes to the surface that are outside the current clip region. Calling `cairo_clip()` can only make the clip region smaller, never larger. But the current clip is part of the graphics state, so a temporary restriction of the clip region can be achieved by calling `cairo_clip()` within a `cairo_save()`/`cairo_restore()` pair. The only other means of increasing the size of the clip region is `cairo_reset_clip()`.

    method clip ( )

clip-extents
------------

Computes a bounding box in user coordinates covering the area inside the current clip.

    method clip-extents ( Num $x1, Num $y1, Num $x2, Num $y2 )

  * Num $x1; a cairo context

  * Num $y1; left of the resulting extents

  * Num $x2; top of the resulting extents

  * Num $y2; right of the resulting extents

clip-preserve
-------------

Establishes a new clip region by intersecting the current clip region with the current path as it would be filled by `cairo_fill()` and according to the current fill rule (see `cairo_set_fill_rule()`). Unlike `cairo_clip()`, `cairo_clip_preserve()` preserves the path within the cairo context. The current clip region affects all drawing operations by effectively masking out any changes to the surface that are outside the current clip region. Calling `cairo_clip_preserve()` can only make the clip region smaller, never larger. But the current clip is part of the graphics state, so a temporary restriction of the clip region can be achieved by calling `cairo_clip_preserve()` within a `cairo_save()`/`cairo_restore()` pair. The only other means of increasing the size of the clip region is `cairo_reset_clip()`.

    method clip-preserve ( )

close-path
----------

Adds a line segment to the path from the current point to the beginning of the current sub-path, (the most recent point passed to `cairo_move_to()`), and closes this sub-path. After this call the current point will be at the joined endpoint of the sub-path. The behavior of `cairo_close_path()` is distinct from simply calling `cairo_line_to()` with the equivalent coordinate in the case of stroking. When a closed sub-path is stroked, there are no caps on the ends of the sub-path. Instead, there is a line join connecting the final and initial segments of the sub-path. If there is no current point before the call to `cairo_close_path()`, this function will have no effect. Note: As of cairo version 1.2.4 any call to `cairo_close_path()` will place an explicit MOVE_TO element into the path immediately after the CLOSE_PATH element, (which can be seen in `cairo_copy_path()` for example). This can simplify path processing in some cases as it may not be necessary to save the "last move_to point" during processing as the MOVE_TO immediately after the CLOSE_PATH will provide that point.

    method close-path ( )

copy-clip-rectangle-list
------------------------

Gets the current clip region as a list of rectangles in user coordinates. Never returns `Any`. The status in the list may be `CAIRO_STATUS_CLIP_NOT_REPRESENTABLE` to indicate that the clip region cannot be represented as a list of user-space rectangles. The status may have other values to indicate other errors. Returns: the current clip region as a list of rectangles in user coordinates, which should be destroyed using `cairo_rectangle_list_destroy()`.

    method copy-clip-rectangle-list ( --> cairo_rectangle_list_t )

copy-page
---------

Emits the current page for backends that support multiple pages, but doesn't clear it, so, the contents of the current page will be retained for the next page too. Use `cairo_show_page()` if you want to get an empty page after the emission. This is a convenience function that simply calls `cairo_surface_copy_page()` on *cr*'s target.

    method copy-page ( )

copy-path
---------

Creates a copy of the current path and returns it to the user as a **cairo_path_t**. See **cairo_path_data_t** for hints on how to iterate over the returned data structure. This function will always return a valid pointer, but the result will have no data (<literal>data==`Any`</literal> and <literal>num_data==0</literal>), if either of the following conditions hold: <orderedlist> <listitem>If there is insufficient memory to copy the path. In this case <literal>path->status</literal> will be set to `CAIRO_STATUS_NO_MEMORY`.</listitem> <listitem>If *cr* is already in an error state. In this case <literal>path->status</literal> will contain the same status that would be returned by `cairo_status()`.</listitem> </orderedlist> Return value: the copy of the current path. The caller owns the returned object and should call `cairo_path_destroy()` when finished with it.

    method copy-path ( --> cairo_path_t )

copy-path-flat
--------------

Gets a flattened copy of the current path and returns it to the user as a **cairo_path_t**. See **cairo_path_data_t** for hints on how to iterate over the returned data structure. This function is like `cairo_copy_path()` except that any curves in the path will be approximated with piecewise-linear approximations, (accurate to within the current tolerance value). That is, the result is guaranteed to not have any elements of type `CAIRO_PATH_CURVE_TO` which will instead be replaced by a series of `CAIRO_PATH_LINE_TO` elements. This function will always return a valid pointer, but the result will have no data (<literal>data==`Any`</literal> and <literal>num_data==0</literal>), if either of the following conditions hold: <orderedlist> <listitem>If there is insufficient memory to copy the path. In this case <literal>path->status</literal> will be set to `CAIRO_STATUS_NO_MEMORY`.</listitem> <listitem>If *cr* is already in an error state. In this case <literal>path->status</literal> will contain the same status that would be returned by `cairo_status()`.</listitem> </orderedlist> Return value: the copy of the current path. The caller owns the returned object and should call `cairo_path_destroy()` when finished with it.

    method copy-path-flat ( --> cairo_path_t )

curve-to
--------

Adds a cubic Bézier spline to the path from the current point to position (*x3*, *y3*) in user-space coordinates, using (*x1*, *y1*) and (*x2*, *y2*) as the control points. After this call the current point will be (*x3*, *y3*). If there is no current point before the call to `cairo_curve_to()` this function will behave as if preceded by a call to cairo_move_to(*cr*, *x1*, *y1*).

    method curve-to ( Num $x1, Num $y1, Num $x2, Num $y2, Num $x3, Num $y3 )

  * Num $x1; a cairo context

  * Num $y1; the X coordinate of the first control point

  * Num $x2; the Y coordinate of the first control point

  * Num $y2; the X coordinate of the second control point

  * Num $x3; the Y coordinate of the second control point

  * Num $y3; the X coordinate of the end of the curve

device-to-user
--------------

Transform a coordinate from device space to user space by multiplying the given point by the inverse of the current transformation matrix (CTM).

    method device-to-user ( Num $x, Num $y )

  * Num $x; a cairo

  * Num $y; X value of coordinate (in/out parameter)

device-to-user-distance
-----------------------

Transform a distance vector from device space to user space. This function is similar to `cairo_device_to_user()` except that the translation components of the inverse CTM will be ignored when transforming (*dx*,*dy*).

    method device-to-user-distance ( Num $dx, Num $dy )

  * Num $dx; a cairo context

  * Num $dy; X component of a distance vector (in/out parameter)

fill
----

A drawing operator that fills the current path according to the current fill rule, (each sub-path is implicitly closed before being filled). After `cairo_fill()`, the current path will be cleared from the cairo context. See `cairo_set_fill_rule()` and `cairo_fill_preserve()`.

    method fill ( )

fill-extents
------------

Computes a bounding box in user coordinates covering the area that would be affected, (the "inked" area), by a `cairo_fill()` operation given the current path and fill parameters. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Surface dimensions and clipping are not taken into account. Contrast with `cairo_path_extents()`, which is similar, but returns non-zero extents for some paths with no inked area, (such as a simple line segment). Note that `cairo_fill_extents()` must necessarily do more work to compute the precise inked areas in light of the fill rule, so `cairo_path_extents()` may be more desirable for sake of performance if the non-inked path extents are desired. See `cairo_fill()`, `cairo_set_fill_rule()` and `cairo_fill_preserve()`.

    method fill-extents ( Num $x1, Num $y1, Num $x2, Num $y2 )

  * Num $x1; a cairo context

  * Num $y1; left of the resulting extents

  * Num $x2; top of the resulting extents

  * Num $y2; right of the resulting extents

fill-preserve
-------------

A drawing operator that fills the current path according to the current fill rule, (each sub-path is implicitly closed before being filled). Unlike `cairo_fill()`, `cairo_fill_preserve()` preserves the path within the cairo context. See `cairo_set_fill_rule()` and `cairo_fill()`.

    method fill-preserve ( )

font-extents
------------

Gets the font extents for the currently selected font.

    method font-extents ( cairo_font_extents_t $extents )

  * cairo_font_extents_t $extents; a **cairo_t**

get-antialias
-------------

Gets the current shape antialiasing mode, as set by `cairo_set_antialias()`. Return value: the current shape antialiasing mode.

    method get-antialias ( --> cairo_antialias_t )

get-current-point
-----------------

Gets the current point of the current path, which is conceptually the final point reached by the path so far. The current point is returned in the user-space coordinate system. If there is no defined current point or if this object is not valid, *$x* and *$y* will both be set to 0.0. It is possible to check this in advance with `has_current_point()`. Most path construction functions alter the current point.

See the following for details on how they affect the current point: `new_path()`, `new_sub_path()`, `append_path()`, `close_path()`, `move_to()`, `line_to()`, `curve_to()`, `rel_move_to()`, `rel_line_to()`, `rel_curve_to()`, `arc()`, `arc_negative()`, `rectangle()`, `text_path()`, `glyph_path()`, `stroke_to_path()`.

Some functions use and alter the current point but do not otherwise change current path: `show_text()`. Some functions unset the current path and as a result, current point: `fill()`, `stroke()`.

    method get-current-point ( --> List )

The returned list has;

  * Num $x; a cairo context

  * Num $y; return value for X coordinate of the current point

get-dash
--------

Gets the current dash array. If not `Any`, *dashes* should be big enough to hold at least the number of values returned by `cairo_get_dash_count()`.

    method get-dash ( Num $dashes, Num $offset )

  * Num $dashes; a **cairo_t**

  * Num $offset; return value for the dash array, or `Any`

get-dash-count
--------------

This function returns the length of the dash array in *cr* (0 if dashing is not currently in effect). See also `cairo_set_dash()` and `cairo_get_dash()`. Return value: the length of the dash array, or 0 if no dash array set.

    method get-dash-count ( --> Int )

get-fill-rule
-------------

Gets the current fill rule, as set by `cairo_set_fill_rule()`. Return value: the current fill rule.

    method get-fill-rule ( --> Int )

get-font-face
-------------

Gets the current font face for a **cairo_t**. Return value: the current font face. This object is owned by cairo. To keep a reference to it, you must call `cairo_font_face_reference()`. This function never returns `Any`. If memory cannot be allocated, a special "nil" **cairo_font_face_t** object will be returned on which `cairo_font_face_status()` returns `CAIRO_STATUS_NO_MEMORY`. Using this nil object will cause its error state to propagate to other objects it is passed to, (for example, calling `cairo_set_font_face()` with a nil font will trigger an error that will shutdown the **cairo_t** object).

    method get-font-face ( --> cairo_font_face_t )

get-font-matrix
---------------

Stores the current font matrix into *matrix*. See `cairo_set_font_matrix()`.

    method get-font-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a **cairo_t**

get-font-options
----------------

Retrieves font rendering options set via **cairo_set_font_options**. Note that the returned options do not include any options derived from the underlying surface; they are literally the options passed to `cairo_set_font_options()`.

    method get-font-options ( cairo_font_options_t $options )

  * cairo_font_options_t $options; a **cairo_t**

get-group-target
----------------

Gets the current destination surface for the context. This is either the original target surface as passed to `cairo_create()` or the target surface for the current group as started by the most recent call to `cairo_push_group()` or `cairo_push_group_with_content()`. This function will always return a valid pointer, but the result can be a "nil" surface if *cr* is already in an error state, (ie. `cairo_status()` <literal>!=</literal> `CAIRO_STATUS_SUCCESS`). A nil surface is indicated by `cairo_surface_status()` <literal>!=</literal> `CAIRO_STATUS_SUCCESS`. Return value: the target surface. This object is owned by cairo. To keep a reference to it, you must call `cairo_surface_reference()`.

    method get-group-target ( --> cairo_surface_t )

get-line-cap
------------

Gets the current line cap style, as set by `cairo_set_line_cap()`. Return value: the current line cap style.

    method get-line-cap ( --> Int )

get-line-join
-------------

Gets the current line join style, as set by `cairo_set_line_join()`. Return value: the current line join style.

    method get-line-join ( --> Int )

get-line-width
--------------

This function returns the current line width value exactly as set by `cairo_set_line_width()`. Note that the value is unchanged even if the CTM has changed between the calls to `cairo_set_line_width()` and `cairo_get_line_width()`. Return value: the current line width.

    method get-line-width ( --> Num )

get-matrix
----------

Stores the current transformation matrix (CTM) into *matrix*.

    method get-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a cairo context

get-miter-limit
---------------

Gets the current miter limit, as set by `cairo_set_miter_limit()`. Return value: the current miter limit.

    method get-miter-limit ( --> Num )

get-opacity
-----------

Gets the current compositing opacity for a cairo context. Return value: the current compositing opacity. Since: TBD

    method get-opacity ( --> Num )

get-operator
------------

Gets the current compositing operator for a cairo context. Return value: the current compositing operator.

    method get-operator ( --> Int )

get-reference-count
-------------------

Returns the current reference count of *cr*. Return value: the current reference count of *cr*. If the object is a nil object, 0 will be returned.

    method get-reference-count ( --> Int )

get-scaled-font
---------------

Gets the current scaled font for a **cairo_t**. Return value: the current scaled font. This object is owned by cairo. To keep a reference to it, you must call `cairo_scaled_font_reference()`. This function never returns `Any`. If memory cannot be allocated, a special "nil" **cairo_scaled_font_t** object will be returned on which `cairo_scaled_font_status()` returns `CAIRO_STATUS_NO_MEMORY`. Using this nil object will cause its error state to propagate to other objects it is passed to, (for example, calling `cairo_set_scaled_font()` with a nil font will trigger an error that will shutdown the **cairo_t** object).

    method get-scaled-font ( --> cairo_scaled_font_t )

get-source
----------

Gets the current source pattern for *cr*. Return value: the current source pattern. This object is owned by cairo. To keep a reference to it, you must call `cairo_pattern_reference()`.

    method get-source ( --> cairo_pattern_t )

get-target
----------

Gets the target surface for the cairo context as passed to `cairo_create()`. This function will always return a valid pointer, but the result can be a "nil" surface if *cr* is already in an error state, (ie. `cairo_status()` <literal>!=</literal> `CAIRO_STATUS_SUCCESS`). A nil surface is indicated by `cairo_surface_status()` <literal>!=</literal> `CAIRO_STATUS_SUCCESS`. Return value: the target surface. This object is owned by cairo. To keep a reference to it, you must call `cairo_surface_reference()`.

    method get-target ( --> cairo_surface_t )

get-tolerance
-------------

Gets the current tolerance value, as set by `cairo_set_tolerance()`. Return value: the current tolerance value.

    method get-tolerance ( --> Num )

glyph-extents
-------------

Gets the extents for an array of glyphs. The extents describe a user-space rectangle that encloses the "inked" portion of the glyphs, (as they would be drawn by `cairo_show_glyphs()`). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `cairo_show_glyphs()`. Note that whitespace glyphs do not contribute to the size of the rectangle (extents.width and extents.height).

    method glyph-extents ( cairo_glyph_t $glyphs, Int $num_glyphs, cairo_text_extents_t $extents )

  * cairo_glyph_t $glyphs; a **cairo_t**

  * Int $num_glyphs; an array of **cairo_glyph_t** objects

  * cairo_text_extents_t $extents; the number of elements in *glyphs*

glyph-path
----------

Adds closed paths for the glyphs to the current path. The generated path if filled, achieves an effect similar to that of `cairo_show_glyphs()`.

    method glyph-path ( cairo_glyph_t $glyphs, Int $num_glyphs )

  * cairo_glyph_t $glyphs; a cairo context

  * Int $num_glyphs; array of glyphs to show

has-current-point
-----------------

Returns whether a current point is defined on the current path. See `cairo_get_current_point()` for details on the current point. Return value: whether a current point is defined.

    method has-current-point ( --> Int )

identity-matrix
---------------

Resets the current transformation matrix (CTM) by setting it equal to the identity matrix. That is, the user-space and device-space axes will be aligned and one user-space unit will transform to one device-space unit.

    method identity-matrix ( )

in-clip
-------

Tests whether the given point is inside the area that would be visible through the current clip, i.e. the area that would be filled by a `cairo_paint()` operation. See `cairo_clip()`, and `cairo_clip_preserve()`. Return value: A non-zero value if the point is inside, or zero if outside.

    method in-clip ( Num $x, Num $y --> Int )

  * Num $x; a cairo context

  * Num $y; X coordinate of the point to test

in-fill
-------

Tests whether the given point is inside the area that would be affected by a `cairo_fill()` operation given the current path and filling parameters. Surface dimensions and clipping are not taken into account. See `cairo_fill()`, `cairo_set_fill_rule()` and `cairo_fill_preserve()`. Return value: A non-zero value if the point is inside, or zero if outside.

    method in-fill ( Num $x, Num $y --> Int )

  * Num $x; a cairo context

  * Num $y; X coordinate of the point to test

in-stroke
---------

Tests whether the given point is inside the area that would be affected by a `cairo_stroke()` operation given the current path and stroking parameters. Surface dimensions and clipping are not taken into account. See `cairo_stroke()`, `cairo_set_line_width()`, `cairo_set_line_join()`, `cairo_set_line_cap()`, `cairo_set_dash()`, and `cairo_stroke_preserve()`. Return value: A non-zero value if the point is inside, or zero if outside.

    method in-stroke ( Num $x, Num $y --> Int )

  * Num $x; a cairo context

  * Num $y; X coordinate of the point to test

line-to
-------

Adds a line to the path from the current point to position (*x*, *y*) in user-space coordinates. After this call the current point will be (*x*, *y*). If there is no current point before the call to `cairo_line_to()` this function will behave as cairo_move_to(*cr*, *x*, *y*).

    method line-to ( Num $x, Num $y )

  * Num $x; a cairo context

  * Num $y; the X coordinate of the end of the new line

mask
----

A drawing operator that paints the current source using the alpha channel of *pattern* as a mask. (Opaque areas of *pattern* are painted with the source, transparent areas are not painted.)

    method mask ( cairo_pattern_t $pattern )

  * cairo_pattern_t $pattern; a cairo context

mask-surface
------------

A drawing operator that paints the current source using the alpha channel of *surface* as a mask. (Opaque areas of *surface* are painted with the source, transparent areas are not painted.)

    method mask-surface ( cairo_surface_t $surface, Num $surface_x, Num $surface_y )

  * cairo_surface_t $surface; a cairo context

  * Num $surface_x; a **cairo_surface_t**

  * Num $surface_y; X coordinate at which to place the origin of *surface*

move-to
-------

Begin a new sub-path. After this call the current point will be (*x*, *y*).

    method move-to ( Num $x, Num $y )

  * Num $x; a cairo context

  * Num $y; the X coordinate of the new position

new-path
--------

Clears the current path. After this call there will be no path and no current point.

    method new-path ( )

new-sub-path
------------

Begin a new sub-path. Note that the existing path is not affected. After this call there will be no current point. In many cases, this call is not needed since new sub-paths are frequently started with `cairo_move_to()`. A call to `cairo_new_sub_path()` is particularly useful when beginning a new sub-path with one of the `cairo_arc()` calls. This makes things easier as it is no longer necessary to manually compute the arc's initial coordinates for a call to `cairo_move_to()`.

    method new-sub-path ( )

paint
-----

A drawing operator that paints the current source everywhere within the current clip region.

    method paint ( )

paint-with-alpha
----------------

A drawing operator that paints the current source everywhere within the current clip region using a mask of constant alpha value *alpha*. The effect is similar to `cairo_paint()`, but the drawing is faded out using the alpha value.

    method paint-with-alpha ( Num $alpha )

  * Num $alpha; a cairo context

path-extents
------------

Computes a bounding box in user-space coordinates covering the points on the current path. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Stroke parameters, fill rule, surface dimensions and clipping are not taken into account. Contrast with `cairo_fill_extents()` and `cairo_stroke_extents()` which return the extents of only the area that would be "inked" by the corresponding drawing operations. The result of `cairo_path_extents()` is defined as equivalent to the limit of `cairo_stroke_extents()` with `CAIRO_LINE_CAP_ROUND` as the line width approaches 0.0, (but never reaching the empty-rectangle returned by `cairo_stroke_extents()` for a line width of 0.0). Specifically, this means that zero-area sub-paths such as `cairo_move_to()`;`cairo_line_to()` segments, (even degenerate cases where the coordinates to both calls are identical), will be considered as contributing to the extents. However, a lone `cairo_move_to()` will not contribute to the results of `cairo_path_extents()`.

    method path-extents ( Num $x1, Num $y1, Num $x2, Num $y2 )

  * Num $x1; a cairo context

  * Num $y1; left of the resulting extents

  * Num $x2; top of the resulting extents

  * Num $y2; right of the resulting extents

pop-group
---------

Terminates the redirection begun by a call to `cairo_push_group()` or `cairo_push_group_with_content()` and returns a new pattern containing the results of all drawing operations performed to the group. The `cairo_pop_group()` function calls `cairo_restore()`, (balancing a call to `cairo_save()` by the push_group function), so that any changes to the graphics state will not be visible outside the group. Return value: a newly created (surface) pattern containing the results of all drawing operations performed to the group. The caller owns the returned object and should call `cairo_pattern_destroy()` when finished with it.

    method pop-group ( --> cairo_pattern_t )

pop-group-to-source
-------------------

Terminates the redirection begun by a call to `cairo_push_group()` or `cairo_push_group_with_content()` and installs the resulting pattern as the source pattern in the given cairo context. The behavior of this function is equivalent to the sequence of operations:

    cairo_pattern_t *group = cairo_pop_group (cr); cairo_set_source (cr, group); cairo_pattern_destroy (group);

      but is more convenient as their is no need for a variable to store the short-lived pointer to the pattern.  The C<cairo_pop_group()> function calls C<cairo_restore()>, (balancing a call to C<cairo_save()> by the push_group function), so that any changes to the graphics state will not be visible outside the group.

     method pop-group-to-source ( )

push-group
----------

Temporarily redirects drawing to an intermediate surface known as a group. The redirection lasts until the group is completed by a call to `cairo_pop_group()` or `cairo_pop_group_to_source()`. These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern). This group functionality can be convenient for performing intermediate compositing. One common use of a group is to render objects as opaque within the group, (so that they occlude each other), and then blend the result with translucence onto the destination. Groups can be nested arbitrarily deep by making balanced calls to `cairo_push_group()`/`cairo_pop_group()`. Each call pushes/pops the new target group onto/from a stack. The `cairo_push_group()` function calls `cairo_save()` so that any changes to the graphics state will not be visible outside the group, (the pop_group functions call `cairo_restore()`). By default the intermediate group will have a content type of `CAIRO_CONTENT_COLOR_ALPHA`. Other content types can be chosen for the group by using `cairo_push_group_with_content()` instead. As an example, here is how one might fill and stroke a path with translucence, but without any portion of the fill being visible under the stroke:

    cairo_push_group (cr); cairo_set_source (cr, fill_pattern); cairo_fill_preserve (cr); cairo_set_source (cr, stroke_pattern); cairo_stroke (cr); cairo_pop_group_to_source (cr); cairo_paint_with_alpha (cr, alpha);



     method push-group ( )

push-group-with-content
-----------------------

Temporarily redirects drawing to an intermediate surface known as a group. The redirection lasts until the group is completed by a call to `cairo_pop_group()` or `cairo_pop_group_to_source()`. These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern). The group will have a content type of *content*. The ability to control this content type is the only distinction between this function and `cairo_push_group()` which you should see for a more detailed description of group rendering.

    method push-group-with-content ( Int $content )

  * Int $content; a cairo context

rectangle
---------

Adds a closed sub-path rectangle of the given size to the current path at position (*x*, *y*) in user-space coordinates. This function is logically equivalent to:

    cairo_move_to (cr, x, y); cairo_rel_line_to (cr, width, 0); cairo_rel_line_to (cr, 0, height); cairo_rel_line_to (cr, -width, 0); cairo_close_path (cr);



     method rectangle ( Num $x, Num $y, Num $width, Num $height )

  * Num $x; a cairo context

  * Num $y; the X coordinate of the top left corner of the rectangle

  * Num $width; the Y coordinate to the top left corner of the rectangle

  * Num $height; the width of the rectangle

rel-curve-to
------------

Relative-coordinate version of `cairo_curve_to()`. All offsets are relative to the current point. Adds a cubic Bézier spline to the path from the current point to a point offset from the current point by (*dx3*, *dy3*), using points offset by (*dx1*, *dy1*) and (*dx2*, *dy2*) as the control points. After this call the current point will be offset by (*dx3*, *dy3*). Given a current point of (x, y), cairo_rel_curve_to(*cr*, *dx1*, *dy1*, *dx2*, *dy2*, *dx3*, *dy3*) is logically equivalent to cairo_curve_to(*cr*, x+*dx1*, y+*dy1*, x+*dx2*, y+*dy2*, x+*dx3*, y+*dy3*). It is an error to call this function with no current point. Doing so will cause *cr* to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-curve-to ( Num $dx1, Num $dy1, Num $dx2, Num $dy2, Num $dx3, Num $dy3 )

  * Num $dx1; a cairo context

  * Num $dy1; the X offset to the first control point

  * Num $dx2; the Y offset to the first control point

  * Num $dy2; the X offset to the second control point

  * Num $dx3; the Y offset to the second control point

  * Num $dy3; the X offset to the end of the curve

rel-line-to
-----------

Relative-coordinate version of `cairo_line_to()`. Adds a line to the path from the current point to a point that is offset from the current point by (*dx*, *dy*) in user space. After this call the current point will be offset by (*dx*, *dy*). Given a current point of (x, y), cairo_rel_line_to(*cr*, *dx*, *dy*) is logically equivalent to cairo_line_to(*cr*, x + *dx*, y + *dy*). It is an error to call this function with no current point. Doing so will cause *cr* to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-line-to ( Num $dx, Num $dy )

  * Num $dx; a cairo context

  * Num $dy; the X offset to the end of the new line

rel-move-to
-----------

Begin a new sub-path. After this call the current point will offset by (*x*, *y*). Given a current point of (x, y), cairo_rel_move_to(*cr*, *dx*, *dy*) is logically equivalent to cairo_move_to(*cr*, x + *dx*, y + *dy*). It is an error to call this function with no current point. Doing so will cause *cr* to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-move-to ( Num $dx, Num $dy )

  * Num $dx; a cairo context

  * Num $dy; the X offset

reset-clip
----------

Reset the current clip region to its original, unrestricted state. That is, set the clip region to an infinitely large shape containing the target surface. Equivalently, if infinity is too hard to grasp, one can imagine the clip region being reset to the exact bounds of the target surface. Note that code meant to be reusable should not call `cairo_reset_clip()` as it will cause results unexpected by higher-level code which calls `cairo_clip()`. Consider using `cairo_save()` and `cairo_restore()` around `cairo_clip()` as a more robust means of temporarily restricting the clip region.

    method reset-clip ( )

restore
-------

Restores *cr* to the state saved by a preceding call to `cairo_save()` and removes that state from the stack of saved states.

    method restore ( )

rotate
------

Modifies the current transformation matrix (CTM) by rotating the user-space axes by *angle* radians. The rotation of the axes takes places after any existing transformation of user space. The rotation direction for positive angles is from the positive X axis toward the positive Y axis.

    method rotate ( Num $angle )

  * Num $angle; a cairo context

save
----

Makes a copy of the current state of *cr* and saves it on an internal stack of saved states for *cr*. When `cairo_restore()` is called, *cr* will be restored to the saved state. Multiple calls to `cairo_save()` and `cairo_restore()` can be nested; each call to `cairo_restore()` restores the state from the matching paired `cairo_save()`. It isn't necessary to clear all saved states before a **cairo_t** is freed. If the reference count of a **cairo_t** drops to zero in response to a call to `cairo_destroy()`, any saved states will be freed along with the **cairo_t**.

    method save ( )

scale
-----

Modifies the current transformation matrix (CTM) by scaling the X and Y user-space axes by *sx* and *sy* respectively. The scaling of the axes takes place after any existing transformation of user space.

    method scale ( Num $sx, Num $sy )

  * Num $sx; a cairo context

  * Num $sy; scale factor for the X dimension

select-font-face
----------------

Note: The `cairo_select_font_face()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications. Selects a family and style of font from a simplified description as a family name, slant and weight. Cairo provides no operation to list available family names on the system (this is a "toy", remember), but the standard CSS2 generic family names, ("serif", "sans-serif", "cursive", "fantasy", "monospace"), are likely to work as expected. If *family* starts with the string "*cairo*:", or if no native font backends are compiled in, cairo will use an internal font family. The internal font family recognizes many modifiers in the *family* string, most notably, it recognizes the string "monospace". That is, the family name "*cairo*:monospace" will use the monospace version of the internal font family. For "real" font selection, see the font-backend-specific font_face_create functions for the font backend you are using. (For example, if you are using the freetype-based cairo-ft font backend, see `cairo_ft_font_face_create_for_ft_face()` or `cairo_ft_font_face_create_for_pattern()`.) The resulting font face could then be used with `cairo_scaled_font_create()` and `cairo_set_scaled_font()`. Similarly, when using the "real" font support, you can call directly into the underlying font system, (such as fontconfig or freetype), for operations such as listing available fonts, etc. It is expected that most applications will need to use a more comprehensive font handling and text layout library, (for example, pango), in conjunction with cairo. If text is drawn without a call to `cairo_select_font_face()`, (nor `cairo_set_font_face()` nor `cairo_set_scaled_font()`), the default family is platform-specific, but is essentially "sans-serif". Default slant is `CAIRO_FONT_SLANT_NORMAL`, and default weight is `CAIRO_FONT_WEIGHT_NORMAL`. This function is equivalent to a call to `cairo_toy_font_face_create()` followed by `cairo_set_font_face()`.

    method select-font-face ( Int $slant, Int $weight )

  * Int $family; a **cairo_t**

  * Int $slant; a font family name, encoded in UTF-8

  * Int $weight; the slant for the font

set-antialias
-------------

Set the antialiasing mode of the rasterizer used for drawing shapes. This value is a hint, and a particular backend may or may not support a particular value. At the current time, no backend supports `CAIRO_ANTIALIAS_SUBPIXEL` when drawing shapes. Note that this option does not affect text rendering, instead see `cairo_font_options_set_antialias()`.

    method set-antialias ( Int $antialias )

  * Int $antialias; a **cairo_t**

set-dash
--------

Sets the dash pattern to be used by `cairo_stroke()`. A dash pattern is specified by *dashes*, an array of positive values. Each value provides the length of alternate "on" and "off" portions of the stroke. The *offset* specifies an offset into the pattern at which the stroke begins. Each "on" segment will have caps applied as if the segment were a separate sub-path. In particular, it is valid to use an "on" length of 0.0 with `CAIRO_LINE_CAP_ROUND` or `CAIRO_LINE_CAP_SQUARE` in order to distributed dots or squares along a path. Note: The length values are in user-space units as evaluated at the time of stroking. This is not necessarily the same as the user space at the time of `cairo_set_dash()`. If *num_dashes* is 0 dashing is disabled. If *num_dashes* is 1 a symmetric pattern is assumed with alternating on and off portions of the size specified by the single value in *dashes*. If any value in *dashes* is negative, or if all values are 0, then *cr* will be put into an error state with a status of `CAIRO_STATUS_INVALID_DASH`.

    method set-dash ( Num $dashes, Int $num_dashes, Num $offset )

  * Num $dashes; a cairo context

  * Int $num_dashes; an array specifying alternate lengths of on and off stroke portions

  * Num $offset; the length of the dashes array

set-fill-rule
-------------

Set the current fill rule within the cairo context. The fill rule is used to determine which regions are inside or outside a complex (potentially self-intersecting) path. The current fill rule affects both `cairo_fill()` and `cairo_clip()`. See **cairo_fill_rule_t** for details on the semantics of each available fill rule. The default fill rule is `CAIRO_FILL_RULE_WINDING`.

    method set-fill-rule ( Int $fill_rule )

  * Int $fill_rule; a **cairo_t**

set-font-face
-------------

Replaces the current **cairo_font_face_t** object in the **cairo_t** with *font_face*. The replaced font face in the **cairo_t** will be destroyed if there are no other references to it.

    method set-font-face ( cairo_font_face_t $font_face )

  * cairo_font_face_t $font_face; a **cairo_t**

set-font-matrix
---------------

Sets the current font matrix to *matrix*. The font matrix gives a transformation from the design space of the font (in this space, the em-square is 1 unit by 1 unit) to user space. Normally, a simple scale is used (see `cairo_set_font_size()`), but a more complex font matrix can be used to shear the font or stretch it unequally along the two axes

    method set-font-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a **cairo_t**

set-font-options
----------------

Sets a set of custom font rendering options for the **cairo_t**. Rendering options are derived by merging these options with the options derived from underlying surface; if the value in *options* has a default value (like `CAIRO_ANTIALIAS_DEFAULT`), then the value from the surface is used.

    method set-font-options ( cairo_font_options_t $options )

  * cairo_font_options_t $options; a **cairo_t**

set-font-size
-------------

Sets the current font matrix to a scale by a factor of *size*, replacing any font matrix previously set with `cairo_set_font_size()` or `cairo_set_font_matrix()`. This results in a font size of *size* user space units. (More precisely, this matrix will result in the font's em-square being a *size* by *size* square in user space.) If text is drawn without a call to `cairo_set_font_size()`, (nor `cairo_set_font_matrix()` nor `cairo_set_scaled_font()`), the default font size is 10.0.

    method set-font-size ( Num $size )

  * Num $size; a **cairo_t**

set-line-cap
------------

Sets the current line cap style within the cairo context. See **cairo_line_cap_t** for details about how the available line cap styles are drawn. As with the other stroke parameters, the current line cap style is examined by `cairo_stroke()`, `cairo_stroke_extents()`, and `cairo_stroke_to_path()`, but does not have any effect during path construction. The default line cap style is `CAIRO_LINE_CAP_BUTT`.

    method set-line-cap ( Int $line_cap )

  * Int $line_cap; a cairo context

set-line-join
-------------

Sets the current line join style within the cairo context. See **cairo_line_join_t** for details about how the available line join styles are drawn. As with the other stroke parameters, the current line join style is examined by `cairo_stroke()`, `cairo_stroke_extents()`, and `cairo_stroke_to_path()`, but does not have any effect during path construction. The default line join style is `CAIRO_LINE_JOIN_MITER`.

    method set-line-join ( Int $line_join )

  * Int $line_join; a cairo context

set-line-width
--------------

Sets the current line width within the cairo context. The line width value specifies the diameter of a pen that is circular in user space, (though device-space pen may be an ellipse in general due to scaling/shear/rotation of the CTM). Note: When the description above refers to user space and CTM it refers to the user space and CTM in effect at the time of the stroking operation, not the user space and CTM in effect at the time of the call to `cairo_set_line_width()`. The simplest usage makes both of these spaces identical. That is, if there is no change to the CTM between a call to `cairo_set_line_width()` and the stroking operation, then one can just pass user-space values to `cairo_set_line_width()` and ignore this note. As with the other stroke parameters, the current line width is examined by `cairo_stroke()`, `cairo_stroke_extents()`, and `cairo_stroke_to_path()`, but does not have any effect during path construction. The default line width value is 2.0.

    method set-line-width ( Num $width )

  * Num $width; a **cairo_t**

set-matrix
----------

Modifies the current transformation matrix (CTM) by setting it equal to *matrix*.

    method set-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a cairo context

set-miter-limit
---------------

Sets the current miter limit within the cairo context. If the current line join style is set to `CAIRO_LINE_JOIN_MITER` (see `cairo_set_line_join()`), the miter limit is used to determine whether the lines should be joined with a bevel instead of a miter. Cairo divides the length of the miter by the line width. If the result is greater than the miter limit, the style is converted to a bevel. As with the other stroke parameters, the current line miter limit is examined by `cairo_stroke()`, `cairo_stroke_extents()`, and `cairo_stroke_to_path()`, but does not have any effect during path construction. The default miter limit value is 10.0, which will convert joins with interior angles less than 11 degrees to bevels instead of miters. For reference, a miter limit of 2.0 makes the miter cutoff at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90 degrees. A miter limit for a desired angle can be computed as: miter limit = 1/sin(angle/2)

    method set-miter-limit ( Num $limit )

  * Num $limit; a cairo context

set-operator
------------

Sets the compositing operator to be used for all drawing operations. See **cairo_operator_t** for details on the semantics of each available compositing operator. The default operator is `CAIRO_OPERATOR_OVER`.

    method set-operator ( Int $op )

  * Int $op; a **cairo_t**

set-scaled-font
---------------

Replaces the current font face, font matrix, and font options in the **cairo_t** with those of the **cairo_scaled_font_t**. Except for some translation, the current CTM of the **cairo_t** should be the same as that of the **cairo_scaled_font_t**, which can be accessed using `cairo_scaled_font_get_ctm()`.

    method set-scaled-font ( cairo_scaled_font_t $scaled_font )

  * cairo_scaled_font_t $scaled_font; a **cairo_t**

set-source
----------

Sets the source pattern within *cr* to *source*. This pattern will then be used for any subsequent drawing operation until a new source pattern is set. Note: The pattern's transformation matrix will be locked to the user space in effect at the time of `cairo_set_source()`. This means that further modifications of the current transformation matrix will not affect the source pattern. See `cairo_pattern_set_matrix()`. The default source pattern is a solid pattern that is opaque black, (that is, it is equivalent to cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)).

    method set-source ( cairo_pattern_t $source )

  * cairo_pattern_t $source; a cairo context

set-source-rgb
--------------

Sets the source pattern within *cr* to an opaque color. This opaque color will then be used for any subsequent drawing operation until a new source pattern is set. The color components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped. The default source pattern is opaque black, (that is, it is equivalent to cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)).

    method set-source-rgb ( Num $red, Num $green, Num $blue )

  * Num $red; a cairo context

  * Num $green; red component of color

  * Num $blue; green component of color

set-source-rgba
---------------

Sets the source pattern within *cr* to a translucent color. This color will then be used for any subsequent drawing operation until a new source pattern is set. The color and alpha components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped. The default source pattern is opaque black, (that is, it is equivalent to cairo_set_source_rgba(cr, 0.0, 0.0, 0.0, 1.0)).

    method set-source-rgba ( Num $red, Num $green, Num $blue, Num $alpha )

  * Num $red; a cairo context

  * Num $green; red component of color

  * Num $blue; green component of color

  * Num $alpha; blue component of color

set-source-surface
------------------

This is a convenience function for creating a pattern from *surface* and setting it as the source in *cr* with `cairo_set_source()`. The *x* and *y* parameters give the user-space coordinate at which the surface origin should appear. (The surface origin is its upper-left corner before any transformation has been applied.) The *x* and *y* parameters are negated and then set as translation values in the pattern matrix. Other than the initial translation pattern matrix, as described above, all other pattern attributes, (such as its extend mode), are set to the default values as in `cairo_pattern_create_for_surface()`. The resulting pattern can be queried with `cairo_get_source()` so that these attributes can be modified if desired, (eg. to create a repeating pattern with `cairo_pattern_set_extend()`).

    method set-source-surface ( cairo_surface_t $surface, Num $x, Num $y )

  * cairo_surface_t $surface; a cairo context

  * Num $x; a surface to be used to set the source pattern

  * Num $y; User-space X coordinate for surface origin

set-tolerance
-------------

Sets the tolerance used when converting paths into trapezoids. Curved segments of the path will be subdivided until the maximum deviation between the original path and the polygonal approximation is less than *tolerance*. The default value is 0.1. A larger value will give better performance, a smaller value, better appearance. (Reducing the value from the default value of 0.1 is unlikely to improve appearance significantly.) The accuracy of paths within Cairo is limited by the precision of its internal arithmetic, and the prescribed *tolerance* is restricted to the smallest representable internal value.

    method set-tolerance ( Num $tolerance )

  * Num $tolerance; a **cairo_t**

show-glyphs
-----------

A drawing operator that generates the shape from an array of glyphs, rendered according to the current font face, font size (font matrix), and font options.

    method show-glyphs ( cairo_glyph_t $glyphs, Int $num_glyphs )

  * cairo_glyph_t $glyphs; a cairo context

  * Int $num_glyphs; array of glyphs to show

show-page
---------

Emits and clears the current page for backends that support multiple pages. Use `cairo_copy_page()` if you don't want to clear the page. This is a convenience function that simply calls `cairo_surface_show_page()` on *cr*'s target.

    method show-page ( )

show-text
---------

A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options. This function first computes a set of glyphs for the string of text. The first glyph is placed so that its origin is at the current point. The origin of each subsequent glyph is offset from that of the previous glyph by the advance values of the previous glyph. After this call the current point is moved to the origin of where the next glyph would be placed in this same progression. That is, the current point will be at the origin of the final glyph offset by its advance values. This allows for easy display of a single logical string with multiple calls to `cairo_show_text()`. Note: The `cairo_show_text()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications. See `cairo_show_glyphs()` for the "real" text display API in cairo.

    method show-text ( )

  * Int $utf8; a cairo context

show-text-glyphs
----------------

This operation has rendering effects similar to `cairo_show_glyphs()` but, if the target surface supports it, uses the provided text and cluster mapping to embed the text for the glyphs shown in the output. If the target does not support the extended attributes, this function acts like the basic `cairo_show_glyphs()` as if it had been passed *glyphs* and *num_glyphs*. The mapping between *utf8* and *glyphs* is provided by an array of *clusters*. Each cluster covers a number of text bytes and glyphs, and neighboring clusters cover neighboring areas of *utf8* and *glyphs*. The clusters should collectively cover *utf8* and *glyphs* in entirety. The first cluster always covers bytes from the beginning of *utf8*. If *cluster_flags* do not have the `CAIRO_TEXT_CLUSTER_FLAG_BACKWARD` set, the first cluster also covers the beginning of *glyphs*, otherwise it covers the end of the *glyphs* array and following clusters move backward. See **cairo_text_cluster_t** for constraints on valid clusters.

    method show-text-glyphs ( Int $utf8_len, cairo_glyph_t $glyphs, Int $num_glyphs, cairo_text_cluster_t $clusters, Int $num_clusters, Int $cluster_flags )

  * Int $utf8; a cairo context

  * Int $utf8_len; a string of text encoded in UTF-8

  * cairo_glyph_t $glyphs; length of *utf8* in bytes, or -1 if it is NUL-terminated

  * Int $num_glyphs; array of glyphs to show

  * cairo_text_cluster_t $clusters; number of glyphs to show

  * Int $num_clusters; array of cluster mapping information

  * Int $cluster_flags; number of clusters in the mapping

status
------

Checks whether an error has previously occurred for this context. Returns: the current status of this context, see **cairo_status_t**

    method status ( --> Int )

stroke
------

A drawing operator that strokes the current path according to the current line width, line join, line cap, and dash settings. After `cairo_stroke()`, the current path will be cleared from the cairo context. See `cairo_set_line_width()`, `cairo_set_line_join()`, `cairo_set_line_cap()`, `cairo_set_dash()`, and `cairo_stroke_preserve()`. Note: Degenerate segments and sub-paths are treated specially and provide a useful result. These can result in two different situations: 1. Zero-length "on" segments set in `cairo_set_dash()`. If the cap style is `CAIRO_LINE_CAP_ROUND` or `CAIRO_LINE_CAP_SQUARE` then these segments will be drawn as circular dots or squares respectively. In the case of `CAIRO_LINE_CAP_SQUARE`, the orientation of the squares is determined by the direction of the underlying path. 2. A sub-path created by `cairo_move_to()` followed by either a `cairo_close_path()` or one or more calls to `cairo_line_to()` to the same coordinate as the `cairo_move_to()`. If the cap style is `CAIRO_LINE_CAP_ROUND` then these sub-paths will be drawn as circular dots. Note that in the case of `CAIRO_LINE_CAP_SQUARE` a degenerate sub-path will not be drawn at all, (since the correct orientation is indeterminate). In no case will a cap style of `CAIRO_LINE_CAP_BUTT` cause anything to be drawn in the case of either degenerate segments or sub-paths.

    method stroke ( )

stroke-extents
--------------

Computes a bounding box in user coordinates covering the area that would be affected, (the "inked" area), by a `cairo_stroke()` operation given the current path and stroke parameters. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Surface dimensions and clipping are not taken into account. Note that if the line width is set to exactly zero, then `cairo_stroke_extents()` will return an empty rectangle. Contrast with `cairo_path_extents()` which can be used to compute the non-empty bounds as the line width approaches zero. Note that `cairo_stroke_extents()` must necessarily do more work to compute the precise inked areas in light of the stroke parameters, so `cairo_path_extents()` may be more desirable for sake of performance if non-inked path extents are desired. See `cairo_stroke()`, `cairo_set_line_width()`, `cairo_set_line_join()`, `cairo_set_line_cap()`, `cairo_set_dash()`, and `cairo_stroke_preserve()`.

    method stroke-extents ( Num $x1, Num $y1, Num $x2, Num $y2 )

  * Num $x1; a cairo context

  * Num $y1; left of the resulting extents

  * Num $x2; top of the resulting extents

  * Num $y2; right of the resulting extents

stroke-preserve
---------------

A drawing operator that strokes the current path according to the current line width, line join, line cap, and dash settings. Unlike `cairo_stroke()`, `cairo_stroke_preserve()` preserves the path within the cairo context. See `cairo_set_line_width()`, `cairo_set_line_join()`, `cairo_set_line_cap()`, `cairo_set_dash()`, and `cairo_stroke_preserve()`.

    method stroke-preserve ( )

tag-begin
---------

Create a destination for a hyperlink. Destination tag attributes are detailed at [Destinations][dests]. CAIRO_TAG_LINK: Create hyperlink. Link tag attributes are detailed at [Links][links]. Since: 1.16 cairo_tag_begin: Marks the beginning of the *tag_name* structure. Call `cairo_tag_end()` with the same *tag_name* to mark the end of the structure. The attributes string is of the form "key1=value2 key2=value2 ...". Values may be boolean (true/false or 1/0), integer, float, string, or an array. String values are enclosed in single quotes ('). Single quotes and backslashes inside the string should be escaped with a backslash. Boolean values may be set to true by only specifying the key. eg the attribute string "key" is the equivalent to "key=true". Arrays are enclosed in '[]'. eg "rect=[1.2 4.3 2.0 3.0]". If no attributes are required, *attributes* can be an empty string or NULL. See [Tags and Links Description][cairo-Tags-and-Links.description] for the list of tags and attributes. Invalid nesting of tags or invalid attributes will cause *cr* to shutdown with a status of `CAIRO_STATUS_TAG_ERROR`. See `cairo_tag_end()`. Since: 1.16

    method tag-begin ( )

  * Int $tag_name;

  * Int $attributes;

tag-end
-------

Marks the end of the *tag_name* structure. Invalid nesting of tags will cause *cr* to shutdown with a status of `CAIRO_STATUS_TAG_ERROR`. See `cairo_tag_begin()`.

    method tag-end ( )

  * Int $tag_name; a cairo context

text-extents
------------

Gets the extents for a string of text. The extents describe a user-space rectangle that encloses the "inked" portion of the text, (as it would be drawn by `cairo_show_text()`). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `cairo_show_text()`. Note that whitespace characters do not directly contribute to the size of the rectangle (extents.width and extents.height). They do contribute indirectly by changing the position of non-whitespace characters. In particular, trailing whitespace characters are likely to not affect the size of the rectangle, though they will affect the x_advance and y_advance values.

    method text-extents ( cairo_text_extents_t $extents )

  * Int $utf8; a **cairo_t**

  * cairo_text_extents_t $extents; a NUL-terminated string of text encoded in UTF-8, or `Any`

text-path
---------

Adds closed paths for text to the current path. The generated path if filled, achieves an effect similar to that of `cairo_show_text()`. Text conversion and positioning is done similar to `cairo_show_text()`. Like `cairo_show_text()`, After this call the current point is moved to the origin of where the next glyph would be placed in this same progression. That is, the current point will be at the origin of the final glyph offset by its advance values. This allows for chaining multiple calls to to `cairo_text_path()` without having to set current point in between. Note: The `cairo_text_path()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications. See `cairo_glyph_path()` for the "real" text path API in cairo.

    method text-path ( )

  * Int $utf8; a cairo context

transform
---------

Modifies the current transformation matrix (CTM) by applying *matrix* as an additional transformation. The new transformation of user space takes place after any existing transformation.

    method transform ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a cairo context

translate
---------

Modifies the current transformation matrix (CTM) by translating the user-space origin by (*tx*, *ty*). This offset is interpreted as a user-space coordinate according to the CTM in place before the new call to `cairo_translate()`. In other words, the translation of the user-space origin takes place after any existing transformation.

    method translate ( Num $tx, Num $ty )

  * Num $tx; a cairo context

  * Num $ty; amount to translate in the X direction

user-to-device
--------------

Transform a coordinate from user space to device space by multiplying the given point by the current transformation matrix (CTM).

    method user-to-device ( Num $x, Num $y )

  * Num $x; a cairo context

  * Num $y; X value of coordinate (in/out parameter)

user-to-device-distance
-----------------------

Transform a distance vector from user space to device space. This function is similar to `cairo_user_to_device()` except that the translation components of the CTM will be ignored when transforming (*dx*,*dy*).

    method user-to-device-distance ( Num $dx, Num $dy )

  * Num $dx; a cairo context

  * Num $dy; X component of a distance vector (in/out parameter)

