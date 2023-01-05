Gnome::Cairo
============

The cairo drawing context

Description
===========

**cairo_t** is the main object used when drawing with cairo. To draw with cairo, you create a **cairo_t**, set the target surface, and drawing options for the **cairo_t**, create shapes with functions like `move_to()` and `line_to()`, and then draw shapes with `stroke()` or `fill()`. **cairo_t** 's can be pushed to a stack via `save()`. They may then safely be changed, without losing the current state. Use `restore()` to restore to the saved state.

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

### :surface

Creates a new **cairo_t** with all graphics state parameters set to default values and with *target* as a target surface. The target surface should be constructed with a backend-specific function such as `Gnome::Cairo::ImageSurface.new(…)`.

This function references *$surface*, so you can immediately call `clear-object()` on it if you don't need to maintain a separate reference to it.

The object is cleared with `clear-object()` when you are done using the **cairo_t**. This function never returns `Any`. If memory cannot be allocated, a special **cairo_t** object will be returned on which `status()` returns `CAIRO_STATUS_NO_MEMORY`. If you attempt to target a surface which does not support writing (such as **cairo_mime_surface_t**) then a `CAIRO_STATUS_WRITE_ERROR` will be raised.

You can use this object normally, but no drawing will be done.

    multi method new ( cairo_surface_t :$surface! )

  * cairo_surface_t $surface;

### :native-object

Create a **Gnome::Cairo** object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

append-path
-----------

Append the *$path* onto the current path. Note that `Gnome::Cairo::Path.status()` must be `CAIRO_STATUS_SUCCESS`.

    method append-path ( cairo_path_t $path )

  * $path; path to be appended

arc
---

Adds a circular arc of the given *$radius* to the current path. The arc is centered at (*$xc*, *$yc*), begins at *$angle1* and proceeds in the direction of increasing angles to end at *$angle2*. If *$angle2* is less than *$angle1* it will be progressively increased by `2*π` until it is greater than *$angle1*.

If there is a current point, an initial line segment will be added to the path to connect the current point to the beginning of the arc. If this initial line is undesired, it can be avoided by calling `new-sub-path()` before calling `arc()`.

Angles are measured in radians. An angle of 0.0 is in the direction of the positive X axis (in user space). An angle of `π/2.0` radians (90 degrees) is in the direction of the positive Y axis (in user space). Angles increase in the direction from the positive X axis toward the positive Y axis. So with the default transformation matrix, angles increase in a clockwise direction. (To convert from degrees to radians, use `degrees * (π / 180)`.) This function gives the arc in the direction of increasing angles; see `arc-negative()` to get the arc in the direction of decreasing angles. The arc is circular in user space. To achieve an elliptical arc, you can scale the current transformation matrix by different amounts in the X and Y directions. For example, to draw an ellipse in the box given by *$x*, *$y*, *$width*, *$height*:

      with $cairo {
        .save;
        .translate( $x + $width / 2, $y + $height / 2);
        .scale( $width / 2, $height / 2);
        .arc( 0, 0, 1, 0, 2 * π);
        .restore;
      }

      method arc (
        Num() $xc, Num() $yc, Num() $radius, Num() $angle1, Num() $angle2
      )

  * $xc; X position of the center of the arc

  * $yc; Y position of the center of the arc

  * $radius; the radius of the arc

  * $angle1; the start angle, in radians

  * $angle2; the end angle, in radians

arc-negative
------------

Adds a circular arc of the given *$radius* to the current path. The arc is centered at (*$xc*, *$yc*), begins at *$angle1* and proceeds in the direction of decreasing angles to end at *$angle2*. If *$angle2* is greater than *$angle1* it will be progressively decreased by `2 * π` until it is less than *$angle1*. See `arc()` for more details. This function differs only in the direction of the arc between the two angles.

    method arc-negative (
      Num() $xc, Num() $yc, Num() $radius, Num() $angle1, Num() $angle2
    )

  * $xc; X position of the center of the arc

  * $yc; Y position of the center of the arc

  * $radius; the radius of the arc

  * $angle1; the start angle, in radians

  * $angle2; the end angle, in radians

clip
----

Establishes a new clip region by intersecting the current clip region with the current path as it would be filled by `fill()` and according to the current fill rule (see `set-fill-rule()`).

After `clip()`, the current path will be cleared from the cairo context. The current clip region affects all drawing operations by effectively masking out any changes to the surface that are outside the current clip region.

Calling `clip()` can only make the clip region smaller, never larger. But the current clip is part of the graphics state, so a temporary restriction of the clip region can be achieved by calling `clip()` within a `save()`/`restore()` pair. The only other means of increasing the size of the clip region is `reset-clip()`.

    method clip ( )

clip-extents
------------

Computes a bounding box in user coordinates covering the area inside the current clip.

    method clip-extents ( --> List )

List holds the following values

  * Num $x1; left of the resulting extents

  * Num $y1; top of the resulting extents

  * Num $x2; right of the resulting extents

  * Num $y2; bottom of the resulting extents

clip-preserve
-------------

Establishes a new clip region by intersecting the current clip region with the current path as it would be filled by `fill()` and according to the current fill rule (see `set-fill-rule()`).

Unlike `clip()`, `clip-preserve()` preserves the path within the cairo context. The current clip region affects all drawing operations by effectively masking out any changes to the surface that are outside the current clip region. Calling `clip-preserve()` can only make the clip region smaller, never larger. But the current clip is part of the graphics state, so a temporary restriction of the clip region can be achieved by calling `preserve()` within a `save()`/`restore()` pair. The only other means of increasing the size of the clip region is `reset-clip()`.

    method clip-preserve ( )

close-path
----------

Adds a line segment to the path from the current point to the beginning of the current sub-path, (the most recent point passed to `move-to()`), and closes this sub-path. After this call the current point will be at the joined endpoint of the sub-path.

The behavior of `close-path()` is distinct from simply calling `line-to()` with the equivalent coordinate in the case of stroking. When a closed sub-path is stroked, there are no caps on the ends of the sub-path. Instead, there is a line join connecting the final and initial segments of the sub-path.

If there is no current point before the call to `close-path()`, this function will have no effect.

Note: As of cairo version 1.2.4 any call to `close-path()` will place an explicit MOVE_TO element into the path immediately after the CLOSE_PATH element, (which can be seen in `copy-path()` for example). This can simplify path processing in some cases as it may not be necessary to save the "last move_to point" during processing as the MOVE_TO immediately after the CLOSE_PATH will provide that point.

    method close-path ( )

copy-clip-rectangle-list
------------------------

Gets the current clip region as a list of rectangles in user coordinates. Never returns an undefined list.

The status in the list may be `CAIRO_STATUS_CLIP_NOT_REPRESENTABLE` to indicate that the clip region cannot be represented as a list of user-space rectangles. The status may have other values to indicate other errors.

Returns: the current clip region as a list of rectangles in user coordinates

    method copy-clip-rectangle-list ( --> cairo_rectangle_list_t )

copy-page
---------

Emits the current page for backends that support multiple pages, but doesn't clear it, so, the contents of the current page will be retained for the next page too.

Use `show-page()` if you want to get an empty page after the emission. This is a convenience function that simply calls `Gnome::Cairo::Surface.copy-page()` on this context's target.

    method copy-page ( )

copy-path
---------

Creates a copy of the current path and returns it to the user as a **cairo_path_t**. See **cairo_path_data_t** for hints on how to iterate over the returned data structure.

This function will always return a valid pointer, but the result will have no data, if either of the following conditions hold:

  * If there is insufficient memory to copy the path. In this case `$path.status` will be set to `CAIRO_STATUS_NO_MEMORY`.

  * If the context is already in an error state. In this case `$path.status` will contain the same status that would be returned by `.status()`.

Return value: the copy of the current path. The caller owns the returned object and should call `clear-object()` when finished with it.

    method copy-path ( --> cairo_path_t )

copy-path-flat
--------------

Gets a flattened copy of the current path and returns it to the user as a **cairo_path_t**. See **cairo_path_data_t** for hints on how to iterate over the returned data structure. This function is like `copy-path()` except that any curves in the path will be approximated with piecewise-linear approximations, (accurate to within the current tolerance value). That is, the result is guaranteed to not have any elements of type `CAIRO_PATH_CURVE_TO` which will instead be replaced by a series of `CAIRO_PATH_LINE_TO` elements.

This function will always return a valid pointer, but the result will have no data, if either of the following conditions hold:

  * If there is insufficient memory to copy the path. In this case `$path.status` will be set to `CAIRO_STATUS_NO_MEMORY`.

  * If the context is already in an error state. In this case `$path.status` will contain the same status that would be returned by `.status()`.

Return value: the copy of the current path. The caller owns the returned object and should call `clear-object()` when finished with it.

    method copy-path-flat ( --> cairo_path_t )

curve-to
--------

Adds a cubic Bézier spline to the path from the current point to position (*x3*, *y3*) in user-space coordinates, using (*x1*, *y1*) and (*x2*, *y2*) as the control points. After this call the current point will be (*x3*, *y3*). If there is no current point before the call to `curve-to()` this function will behave as if preceded by a call to cairo_move_to(this context, *x1*, *y1*).

    method curve-to ( Num() $x1, Num() $y1, Num() $x2, Num() $y2, Num() $x3, Num() $y3 )

  * $x1; the X coordinate of the first control point

  * $y1; the Y coordinate of the first control point

  * $x2; the X coordinate of the second control point

  * $y2; the Y coordinate of the second control point

  * $x3; the X coordinate of the end of the curve

  * $y3; the Y coordinate of the end of the curve

device-to-user
--------------

Transform a coordinate from device space to user space by multiplying the given point by the inverse of the current transformation matrix (CTM).

    method device-to-user ( Num() $x is rw, Num() $y is rw )

  * $x; X value of coordinate

  * $y; Y value of coordinate

device-to-user-distance
-----------------------

Transform a distance vector from device space to user space. This function is similar to `device-to-user()` except that the translation components of the inverse CTM will be ignored when transforming (*dx*,*dy*).

    method device-to-user-distance ( Num() $dx is rw, Num() $dy is rw )

  * $dx; y component of a distance vector

  * $dy; X component of a distance vector

fill
----

A drawing operator that fills the current path according to the current fill rule, (each sub-path is implicitly closed before being filled). After `fill()`, the current path will be cleared from the cairo context. See `set-fill-rule()` and `fill-preserve()`.

    method fill ( )

fill-extents
------------

Computes a bounding box in user coordinates covering the area that would be affected, (the "inked" area), by a `fill()` operation given the current path and fill parameters. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Surface dimensions and clipping are not taken into account. Contrast with `path-extents()`, which is similar, but returns non-zero extents for some paths with no inked area, (such as a simple line segment). Note that `fill-extents()` must necessarily do more work to compute the precise inked areas in light of the fill rule, so `path-extents()` may be more desirable for sake of performance if the non-inked path extents are desired.

See `fill()`, `set-fill-rule()` and `fill-preserve()`.

    method fill-extents ( --> List )

List returns

  * Num; left of the resulting extents

  * Num; top of the resulting extents

  * Num; right of the resulting extents

  * Num; bottom of the resulting extents

fill-preserve
-------------

A drawing operator that fills the current path according to the current fill rule, (each sub-path is implicitly closed before being filled). Unlike `fill()`, `fill-preserve()` preserves the path within the cairo context. See `set-fill-rule()` and `fill()`.

    method fill-preserve ( )

get-antialias
-------------

Gets the current shape antialiasing mode, as set by `set-antialias()`. Return value: the current shape antialiasing mode.

    method get-antialias ( --> cairo_antialias_t )

get-current-point
-----------------

Gets the current point of the current path, which is conceptually the final point reached by the path so far. The current point is returned in the user-space coordinate system. If there is no defined current point or if this object is not valid, *$x* and *$y* will both be set to 0.0. It is possible to check this in advance with `has-current-point()`. Most path construction functions alter the current point.

See the following for details on how they affect the current point: `new-path()`, `new-sub-path()`, `append-path()`, `close-path()`, `move-to()`, `line-to()`, `curve-to()`, `rel-move-to()`, `rel-line-to()`, `rel-curve-to()`, `arc()`, `arc-negative()`, `rectangle()`, `text-path()`, `glyph-path()`, `stroke-to-path()`.

Some functions use and alter the current point but do not otherwise change current path: `show-text()`. Some functions unset the current path and as a result, current point: `fill()`, `stroke()`.

    method get-current-point ( --> List )

The returned list has;

  * $x; X coordinate of the current point

  * $y; Y coordinate of the current point

get-dash
--------

Gets the current dash array.

    method get-dash ( --> List )

List returns;

  * Array; the dash array

  * Num; the current dash offset, or `Undefined`

get-dash-count
--------------

This function returns the length of the dash array in this context (0 if dashing is not currently in effect). See also `set-dash()` and `get-dash()`. Return value: the length of the dash array, or 0 if no dash array set.

    method get-dash-count ( --> Int )

get-fill-rule
-------------

Gets the current fill rule, as set by `set-fill-rule()`.

Return value: the current fill rule.

    method get-fill-rule ( --> cairo_fill_rule_t )

get-font-face
-------------

Gets the current font face for a **cairo_t**.

Return value: the current font face.

This function never returns an undefined font face. If memory cannot be allocated, a special "nil" **cairo_font_face_t** object will be returned on which `Gnome::Cairo::FontFace.status()` returns `CAIRO_STATUS_NO_MEMORY`. Using this nil object will cause its error state to propagate to other objects it is passed to, (for example, calling `set-font-face()` with a nil font will trigger an error that will shutdown the **cairo_t** object).

    method get-font-face ( --> Gnome::Cairo::FontFace )

get-font-matrix
---------------

Returns the current font matrix. See `set-font-matrix()`.

    method get-font-matrix ( --> Gnome::Cairo::Matrix )

get-font-options
----------------

Retrieves font rendering options set via `set-font-options()`. Note that the returned options do not include any options derived from the underlying surface; they are literally the options passed to `set-font-options()`.

    method get-font-options ( cairo_font_options_t $options --> N-GObject )

  * cairo_font_options_t $options; a **cairo_t**

get-group-target
----------------

Gets the current destination surface for the context. This is either the original target surface as passed to `new(:surface)` or the target surface for the current group as started by the most recent call to `push-group()` or `push-group-with-content()`.

This function will always return a valid pointer, but the result can be a "nil" surface if this context is already in an error state, (ie. `$context.status() ≠ CAIRO_STATUS_SUCCESS`). A nil surface is indicated by `Gnome::Cairo::Surface.status() ≠ CAIRO_STATUS_SUCCESS`.

Return value: the target surface. This object is owned by cairo. To keep a reference to it, you must call `surface-reference()`.

    method get-group-target ( --> Gnome::Cairo::Surface )

get-line-cap
------------

Gets the current line cap style, as set by `set-line-cap()`.

Return value: the current line cap style.

    method get-line-cap ( --> cairo_line_cap_t )

get-line-join
-------------

Gets the current line join style, as set by `set-line-join()`. Return value: the current line join style.

    method get-line-join ( --> cairo_line_join_t )

get-line-width
--------------

This function returns the current line width value exactly as set by `set-line-width()`. Note that the value is unchanged even if the CTM has changed between the calls to `set-line-width()` and `get-line-width()`.

Return value: the current line width.

    method get-line-width ( --> Num )

get-matrix
----------

Stores the current transformation matrix (CTM) into *matrix*.

    method get-matrix ( --> Gnome::Cairo::Matrix )

get-miter-limit
---------------

Gets the current miter limit, as set by `set-miter-limit()`.

Return value: the current miter limit.

    method get-miter-limit ( --> Num )

get-operator
------------

Gets the current compositing operator for a cairo context. Return value: the current compositing operator.

    method get-operator ( --> cairo_operator_t )

get-scaled-font
---------------

Gets the current scaled font for a **cairo_t**.

Return value: the current scaled font. This object is owned by cairo.

This function never returns `Any`. If memory cannot be allocated, a special "nil" **cairo_scaled_font_t** object will be returned on which `scaled-font-status()` returns `CAIRO_STATUS_NO_MEMORY`. Using this nil object will cause its error state to propagate to other objects it is passed to, (for example, calling `set-scaled-font()` with a nil font will trigger an error that will shutdown the **cairo_t** object).

    method get-scaled-font ( --> Gnome::Cairo::ScaledFont )

get-source
----------

Gets the current source pattern for this context.

Return value: the current source pattern. This object is owned by cairo.

    method get-source ( --> Gnome::Cairo::Pattern )

get-target
----------

Gets the target surface for the cairo context as passed to `create()`. This function will always return a valid pointer, but the result can be a "nil" surface if this context is already in an error state, (ie. `status()` `!=` `CAIRO_STATUS_SUCCESS`). A nil surface is indicated by `surface-status()` `!=` `CAIRO_STATUS_SUCCESS`. Return value: the target surface. This object is owned by cairo. To keep a reference to it, you must call `surface-reference()`.

    method get-target ( --> Gnome::Cairo::Surface )

get-tolerance
-------------

Gets the current tolerance value, as set by `set-tolerance()`.

Return value: the current tolerance value.

    method get-tolerance ( --> Num )

glyph-extents
-------------

Gets the extents for an array of glyphs. The extents describe a user-space rectangle that encloses the "inked" portion of the glyphs, (as they would be drawn by `show-glyphs()`). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `show-glyphs()`.

Note that whitespace glyphs do not contribute to the size of the rectangle (extents.width and extents.height).

    method glyph-extents (
      cairo_glyph_t $glyphs, Int $num_glyphs,
      cairo_text_extents_t $extents
    )

  * $glyphs; an array of **glyph-t** objects

  * $num_glyphs; the number of elements in *glyphs*

  * $extents; a **text-extents-t** object into which the results will be stored

glyph-path
----------

Adds closed paths for the glyphs to the current path. The generated path if filled, achieves an effect similar to that of `show-glyphs()`.

    method glyph-path ( cairo_glyph_t $glyphs, Int $num_glyphs )

  * $glyphs; array of glyphs to show

  * $num_glyphs; number of glyphs to show

has-current-point
-----------------

Returns whether a current point is defined on the current path. See `get-current-point()` for details on the current point.

Return value: whether a current point is defined.

    method has-current-point ( --> Bool )

identity-matrix
---------------

Resets the current transformation matrix (CTM) by setting it equal to the identity matrix. That is, the user-space and device-space axes will be aligned and one user-space unit will transform to one device-space unit.

    method identity-matrix ( )

in-clip
-------

Tests whether the given point is inside the area that would be visible through the current clip, i.e. the area that would be filled by a `paint()` operation.

See `clip()`, and `clip-preserve()`.

Return value: A non-zero value if the point is inside, or zero if outside.

    method in-clip ( Num() $x, Num() $y --> Bool )

  * $x; X coordinate of the point to test

  * $y; Y coordinate of the point to test

in-fill
-------

Tests whether the given point is inside the area that would be affected by a `fill()` operation given the current path and filling parameters. Surface dimensions and clipping are not taken into account.

See `fill()`, `set-fill-rule()` and `fill-preserve()`.

Return value: A non-zero value if the point is inside, or zero if outside.

    method in-fill ( Num() $x, Num() $y --> Bool )

  * $x; X coordinate of the point to test

  * $y; Y coordinate of the point to test

in-stroke
---------

Tests whether the given point is inside the area that would be affected by a `stroke()` operation given the current path and stroking parameters. Surface dimensions and clipping are not taken into account. See `stroke()`, `set-line-width()`, `set-line-join()`, `set-line-cap()`, `set-dash()`, and `stroke-preserve()`. Return value: A non-zero value if the point is inside, or zero if outside.

    method in-stroke ( Num() $x, Num() $y --> Bool )

  * $x; X coordinate of the point to test

  * $y; Y coordinate of the point to test

line-to
-------

Adds a line to the path from the current point to position (*x*, *y*) in user-space coordinates. After this call the current point will be (*x*, *y*). If there is no current point before the call to `line-to()` this function will behave as cairo_move_to(this context, *x*, *y*).

    method line-to ( Num() $x, Num() $y )

  * $x; the X coordinate of the end of the new line

  * $y; the Y coordinate of the end of the new line

mask
----

A drawing operator that paints the current source using the alpha channel of *pattern* as a mask. (Opaque areas of *pattern* are painted with the source, transparent areas are not painted.)

    method mask ( cairo_pattern_t $pattern )

  * $pattern; a pattern

mask-surface
------------

A drawing operator that paints the current source using the alpha channel of *surface* as a mask. (Opaque areas of *surface* are painted with the source, transparent areas are not painted.)

    method mask-surface (
      cairo_surface_t $surface, Num() $surface_x, Num() $surface_y
    )

  * $surface; a surface

  * $surface_x; X coordinate at which to place the origin of *surface*

  * $surface_y; Y coordinate at which to place the origin of *surface*

move-to
-------

Begin a new sub-path. After this call the current point will be (*x*, *y*).

    method move-to ( Num() $x, Num() $y )

  * $x; the X coordinate of the new position

  * $y; the Y coordinate of the new position

new-path
--------

Clears the current path. After this call there will be no path and no current point.

    method new-path ( )

new-sub-path
------------

Begin a new sub-path.

Note that the existing path is not affected. After this call there will be no current point.

In many cases, this call is not needed since new sub-paths are frequently started with `move-to()`.

A call to `new-sub-path()` is particularly useful when beginning a new sub-path with one of the `arc()` calls. This makes things easier as it is no longer necessary to manually compute the arc's initial coordinates for a call to `move-to()`.

    method new-sub-path ( )

paint
-----

A drawing operator that paints the current source everywhere within the current clip region.

    method paint ( )

paint-with-alpha
----------------

A drawing operator that paints the current source everywhere within the current clip region using a mask of constant alpha value *$alpha*. The effect is similar to `paint()`, but the drawing is faded out using the alpha value.

    method paint-with-alpha ( Num() $alpha )

  * $alpha; alpha value, between 0 (transparent) and 1 (opaque)

path-extents
------------

Computes a bounding box in user-space coordinates covering the points on the current path. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Stroke parameters, fill rule, surface dimensions and clipping are not taken into account.

Contrast with `fill-extents()` and `stroke-extents()` which return the extents of only the area that would be "inked" by the corresponding drawing operations.

The result of `path-extents()` is defined as equivalent to the limit of `stroke-extents()` with `CAIRO_LINE_CAP_ROUND` as the line width approaches 0.0, (but never reaching the empty-rectangle returned by `stroke-extents()` for a line width of 0.0).

Specifically, this means that zero-area sub-paths such as `move-to(); line-to()` segments, (even degenerate cases where the coordinates to both calls are identical), will be considered as contributing to the extents. However, a lone `move-to()` will not contribute to the results of `path-extents()`.

    method path-extents ( --> List )

List returns;

  * Num; left of the resulting extents

  * Num; top of the resulting extents

  * Num; right of the resulting extents

  * Num; bottom of the resulting extents

pop-group
---------

Terminates the redirection begun by a call to `push-group()` or `push-group-with-content()` and returns a new pattern containing the results of all drawing operations performed to the group.

The `pop-group()` function calls `restore()`, (balancing a call to `save()` by the push_group function), so that any changes to the graphics state will not be visible outside the group.

Return value: a newly created (surface) pattern containing the results of all drawing operations performed to the group. The caller owns the returned object and should call `clear-object()` when finished with it.

    method pop-group ( --> Gnome::Cairo::Pattern )

pop-group-to-source
-------------------

Terminates the redirection begun by a call to `push-group()` or `push-group-with-content()` and installs the resulting pattern as the source pattern in the given cairo context.

The behavior of this function is equivalent to the sequence of operations:

    my Gnome::Cairo::Pattern $group = $cairo.pop-group;
    $cairo.set-source($group);
    $group.clear-object;

but is more convenient as there is no need for a variable to store the short-lived pointer to the pattern.

The `pop-group()` function calls `restore()`, (balancing a call to `save()` by the push_group function), so that any changes to the graphics state will not be visible outside the group.

    method pop-group-to-source ( )

push-group
----------

Temporarily redirects drawing to an intermediate surface known as a group. The redirection lasts until the group is completed by a call to `pop-group()` or `pop-group-to-source()`. These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern).

This group functionality can be convenient for performing intermediate compositing. One common use of a group is to render objects as opaque within the group, (so that they occlude each other), and then blend the result with translucence onto the destination.

Groups can be nested arbitrarily deep by making balanced calls to `push-group()`/`pop-group()`. Each call pushes/pops the new target group onto/from a stack.

The `push-group()` function calls `save()` so that any changes to the graphics state will not be visible outside the group, (the pop_group functions call `restore()`).

By default the intermediate group will have a content type of `CAIRO_CONTENT_COLOR_ALPHA`. Other content types can be chosen for the group by using `push-group-with-content()` instead.

As an example, here is how one might fill and stroke a path with translucence, but without any portion of the fill being visible under the stroke:

      my Gnome::Cairo::Pattern $fill-pattern = …
      my Gnome::Cairo::Pattern $stroke-pattern = …
      my Num() $alpha = 0.8;

      with $cairo {
        .push-group;
        .set-source($fill-pattern);
        .fill-preserve;
        .set-source($stroke-pattern);
        .stroke;
        .pop-group-to-source;
        .paint-with-alpha($alpha);
      }

      method push-group ( )

push-group-with-content
-----------------------

Temporarily redirects drawing to an intermediate surface known as a group. The redirection lasts until the group is completed by a call to `pop-group()` or `pop-group-to-source()`. These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern).

The group will have a content type of *$content*. The ability to control this content type is the only distinction between this function and `push-group()` which you should see for a more detailed description of group rendering.

    method push-group-with-content ( cairo_content_t $content )

  * $content; a **content-t** indicating the type of group that will be created

rectangle
---------

Adds a closed sub-path rectangle of the given size to the current path at position (*$x*, *$y*) in user-space coordinates. This method is logically equivalent to:

      with $cairo {
        .move-to( $x, $y);
        .rel-line-to( $width, 0);
        .rel-line-to( 0, $height);
        .rel-line-to( -$width, 0);
        .close.path;
      }

      method rectangle ( Num() $x, Num() $y, Num() $width, Num() $height )

  * $x; the X coordinate of the top left corner of the rectangle

  * $y; the Y coordinate to the top left corner of the rectangle

  * $width; the width of the rectangle

  * $height; the height of the rectangle

rel-curve-to
------------

Relative-coordinate version of `curve-to()`. All offsets are relative to the current point. Adds a cubic Bézier spline to the path from the current point to a point offset from the current point by (*$dx3, $dy3*), using points offset by (*$dx1, $dy1*) and (*$dx2, $dy2*) as the control points. After this call the current point will be offset by (*$dx3, $dy3*).

Given a current point of `($x, $y)`, then `rel-curve-to( $dx1, $dy1, $dx2, $dy2, $dx3, $dy3)` is logically equivalent to `curve-to( $x + $dx1, $y + $dy1, $x + $dx2, $y + $dy2, $x + dx3, $y + $dy3)`.

It is an error to call this function with no current point. Doing so will cause this context to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-curve-to (
      Num() $dx1, Num() $dy1, Num() $dx2, Num() $dy2,
      Num() $dx3, Num() $dy3
    )

  * $dx1; the X offset to the first control point

  * $dy1; the Y offset to the first control point

  * $dx2; the X offset to the second control point

  * $dy2; the Y offset to the second control point

  * $dx3; the X offset to the end of the curve

  * $dy3; the Y offset to the end of the curve

rel-line-to
-----------

Relative-coordinate version of `line-to()`. Adds a line to the path from the current point to a point that is offset from the current point by (*$dx*, *$dy*) in user space. After this call the current point will be offset by (*$dx*, *$dy*).

Given a current point of `($x, $y)`, `rel-line-to( $dx, $dy)` is logically equivalent to `line_to( $x + $dx, $y + $dy)`.

It is an error to call this function with no current point. Doing so will cause this context to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-line-to ( Num() $dx, Num() $dy )

  * $dx; the X offset to the end of the new line

  * $dy; the Y offset to the end of the new line

rel-move-to
-----------

Begin a new sub-path. After this call the current point will offset by `( $x, $y)`. Given a current point of `($x, $y)`, `rel-move-to( $dx, $dy)` is logically equivalent to `move-to( $x + $dx, $y + $dy)`.

It is an error to call this function with no current point. Doing so will cause this context to shutdown with a status of `CAIRO_STATUS_NO_CURRENT_POINT`.

    method rel-move-to ( Num() $dx, Num() $dy )

  * $dx; the X offset

  * $dy; the Y offset

reset-clip
----------

Reset the current clip region to its original, unrestricted state. That is, set the clip region to an infinitely large shape containing the target surface. Equivalently, if infinity is too hard to grasp, one can imagine the clip region being reset to the exact bounds of the target surface.

Note that code meant to be reusable should not call `reset-clip()` as it will cause results unexpected by higher-level code which calls `clip()`. Consider using `save()` and `restore()` around `clip()` as a more robust means of temporarily restricting the clip region.

    method reset-clip ( )

restore
-------

Restores this context to the state saved by a preceding call to `save()` and removes that state from the stack of saved states.

    method restore ( )

rotate
------

Modifies the current transformation matrix (CTM) by rotating the user-space axes by *$angle* radians. The rotation of the axes takes place after any existing transformation of user space. The rotation direction for positive angles is from the positive X axis toward the positive Y axis.

    method rotate ( Num() $angle )

  * $angle; Angle to rotate in radians

save
----

Makes a copy of the current state of this context and saves it on an internal stack of saved states for this context. When `restore()` is called, this context will be restored to the saved state.

Multiple calls to `save()` and `restore()` can be nested; each call to `restore()` restores the state from the matching paired `save()`.

    method save ( )

scale
-----

Modifies the current transformation matrix (CTM) by scaling the X and Y user-space axes by *sx* and *sy* respectively. The scaling of the axes takes place after any existing transformation of user space.

    method scale ( Num() $sx, Num() $sy )

  * $sx; scale factor for the X dimension

  * $sy; scale factor for the Y dimension

select-font-face
----------------

Note: The `select-font-face()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications.

Selects a family and style of font from a simplified description as a family name, slant and weight. Cairo provides no operation to list available family names on the system (this is a "toy", remember), but the standard CSS2 generic family names, ("serif", "sans-serif", "cursive", "fantasy", "monospace"), are likely to work as expected.

If *$family* starts with the string "`cairo:`", or if no native font backends are compiled in, cairo will use an internal font family. The internal font family recognizes many modifiers in the *$family* string, most notably, it recognizes the string "monospace". That is, the family name "*cairo*:monospace" will use the monospace version of the internal font family.

It is expected that most applications will need to use a more comprehensive font handling and text layout library, (for example, pango), in conjunction with cairo.

If text is drawn without a call to `select-font-face()`, (nor `set-font-face()` nor `set-scaled-font()`), the default family is platform-specific, but is essentially "sans-serif". Default slant is `CAIRO_FONT_SLANT_NORMAL`, and default weight is `CAIRO_FONT_WEIGHT_NORMAL`.

    method select-font-face (
      Str $family, cairo_font_slant_t $slant,
      cairo_font_weight_t $weight
    )

  * $family; a font family name, encoded in UTF-8

  * $slant; the slant for the font

  * $weight; the weight for the font

set-antialias
-------------

Set the antialiasing mode of the rasterizer used for drawing shapes. This value is a hint, and a particular backend may or may not support a particular value.

At the current time, no backend supports `CAIRO_ANTIALIAS_SUBPIXEL` when drawing shapes.

Note that this option does not affect text rendering, instead see `font-options-set-antialias()`.

    method set-antialias ( cairo_antialias_t $antialias )

  * $antialias; the new antialiasing mode

set-dash
--------

Sets the dash pattern to be used by `stroke()`. A dash pattern is specified by *$dashes*, an array of positive values. Each value provides the length of alternate "on" and "off" portions of the stroke. The *$offset* specifies an offset into the pattern at which the stroke begins.

Each "on" segment will have caps applied as if the segment were a separate sub-path. In particular, it is valid to use an "on" length of 0.0 with `CAIRO_LINE_CAP_ROUND` or `CAIRO_LINE_CAP_SQUARE` in order to distributed dots or squares along a path.

Note: The length values are in user-space units as evaluated at the time of stroking. This is not necessarily the same as the user space at the time of `set-dash()`. If *$num_dashes* is 0 dashing is disabled. If *num_dashes* is 1 a symmetric pattern is assumed with alternating on and off portions of the size specified by the single value in *$dashes*.

If any value in *$dashes* is negative, or if all values are 0, then this context will be put into an error state with a status of `CAIRO_STATUS_INVALID_DASH`.

    method set-dash ( Array $dashes, Num() $offset )

  * $dashes; an array specifying alternate lengths of on and off stroke portions

  * $offset; an offset into the dash pattern at which the stroke should start

set-fill-rule
-------------

Set the current fill rule within the cairo context. The fill rule is used to determine which regions are inside or outside a complex (potentially self-intersecting) path. The current fill rule affects both `fill()` and `clip()`. See **cairo_fill_rule_t** for details on the semantics of each available fill rule.

The default fill rule is `CAIRO_FILL_RULE_WINDING`.

    method set-fill-rule ( cairo_fill_rule_t $fill_rule )

  * $fill_rule; a fill rule type

set-font-face
-------------

Replaces the current **cairo_font_face_t** object in the **cairo_t** with *font_face*. The replaced font face in the **cairo_t** will be destroyed if there are no other references to it.

    method set-font-face ( cairo_font_face_t $font_face )

  * $font_face; a **font-face-t**, or `Any` to restore to the default font

set-font-matrix
---------------

Sets the current font matrix to *matrix*. The font matrix gives a transformation from the design space of the font (in this space, the em-square is 1 unit by 1 unit) to user space. Normally, a simple scale is used (see `set-font-size()`), but a more complex font matrix can be used to shear the font or stretch it unequally along the two axes

    method set-font-matrix ( cairo_matrix_t $matrix )

  * $matrix; a **matrix-t** describing a transform to be applied to the current font.

set-font-options
----------------

Sets a set of custom font rendering options for the **cairo_t**. Rendering options are derived by merging these options with the options derived from underlying surface; if the value in *options* has a default value (like `CAIRO_ANTIALIAS_DEFAULT`), then the value from the surface is used.

    method set-font-options ( cairo_font_options_t $options )

  * $options; font options to use

set-font-size
-------------

Sets the current font matrix to a scale by a factor of *size*, replacing any font matrix previously set with `set-font-size()` or `set-font-matrix()`. This results in a font size of *size* user space units. (More precisely, this matrix will result in the font's em-square being a *$size* by *$size* square in user space.)

If text is drawn without a call to `set-font-size()`, (nor `set-font-matrix()` nor `cset-scaled-font()`), the default font size is 10.0.

    method set-font-size ( Num() $size )

  * $size; The size of the current font

set-line-cap
------------

Sets the current line cap style within the cairo context. See **cairo_line_cap_t** for details about how the available line cap styles are drawn. As with the other stroke parameters, the current line cap style is examined by `stroke()`, `stroke-extents()`, and `stroke-to-path()`, but does not have any effect during path construction. The default line cap style is `CAIRO_LINE_CAP_BUTT`.

    method set-line-cap ( Int $line_cap )

  * $line_cap; a line cap style

set-line-join
-------------

Sets the current line join style within the cairo context. See **cairo_line_join_t** for details about how the available line join styles are drawn. As with the other stroke parameters, the current line join style is examined by `stroke()`, `stroke-extents()`, and `stroke-to-path()`, but does not have any effect during path construction. The default line join style is `CAIRO_LINE_JOIN_MITER`.

    method set-line-join ( Int $line_join )

  * $line_join; a line join style

set-line-width
--------------

Sets the current line width within the cairo context. The line width value specifies the diameter of a pen that is circular in user space, (though device-space pen may be an ellipse in general due to scaling/shear/rotation of the CTM).

Note: When the description above refers to user space and CTM it refers to the user space and CTM in effect at the time of the stroking operation, not the user space and CTM in effect at the time of the call to `set-line-width()`. The simplest usage makes both of these spaces identical. That is, if there is no change to the CTM between a call to `set-line-width()` and the stroking operation, then one can just pass user-space values to `set-line-width()` and ignore this note.

As with the other stroke parameters, the current line width is examined by `stroke()`, `stroke-extents()`, and `stroke-to-path()`, but does not have any effect during path construction.

The default line width value is 2.0.

    method set-line-width ( Num() $width )

  * $width; a line width

set-matrix
----------

Modifies the current transformation matrix (CTM) by setting it equal to *matrix*.

    method set-matrix ( cairo_matrix_t $matrix )

  * $matrix; a transformation matrix from user space to device space

set-miter-limit
---------------

Sets the current miter limit within the cairo context.

If the current line join style is set to `CAIRO_LINE_JOIN_MITER` (see `set-line-join()`), the miter limit is used to determine whether the lines should be joined with a bevel instead of a miter. Cairo divides the length of the miter by the line width. If the result is greater than the miter limit, the style is converted to a bevel.

As with the other stroke parameters, the current line miter limit is examined by `stroke()`, `stroke-extents()`, and `stroke-to-path()`, but does not have any effect during path construction.

The default miter limit value is 10.0, which will convert joins with interior angles less than 11 degrees to bevels instead of miters. For reference, a miter limit of 2.0 makes the miter cutoff at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90 degrees.

A miter limit for a desired angle can be computed as: `miter limit = 1/sin(angle/2)`.

    method set-miter-limit ( Num() $limit )

  * $limit; a cairo context

set-operator
------------

Sets the compositing operator to be used for all drawing operations. See **cairo_operator_t** for details on the semantics of each available compositing operator.

The default operator is `CAIRO_OPERATOR_OVER`.

    method set-operator ( cairo_operator_t $op )

  * $op; a compositing operator

set-scaled-font
---------------

Replaces the current font face, font matrix, and font options in the **cairo_t** with those of the **cairo_scaled_font_t**. Except for some translation, the current CTM of the **cairo_t** should be the same as that of the **cairo_scaled_font_t**, which can be accessed using `scaled-font-get-ctm()`.

    method set-scaled-font ( cairo_scaled_font_t $scaled_font )

  * $scaled_font; a scaled font

set-source
----------

Sets the source pattern within this context to *source*. This pattern will then be used for any subsequent drawing operation until a new source pattern is set.

Note: The pattern's transformation matrix will be locked to the user space in effect at the time of `set-source()`. This means that further modifications of the current transformation matrix will not affect the source pattern. See `pattern-set-matrix()`.

The default source pattern is a solid pattern that is opaque black, (that is, it is equivalent to `set-source-rgb( 0.0, 0.0, 0.0))`.

    method set-source ( cairo_pattern_t $source )

  * $source; a pattern type to be used as the source for subsequent drawing operations.

set-source-pixbuf
-----------------

Sets the given pixbuf as the source pattern for this context.

The image is aligned so that the origin of the *$pixbuf* is `($x, $y)`.

    method set-source-pixbuf( $pixbuf is copy, Num() $x, Num() $y ) {

  * $pixbuf; The pixel buffer

  * $x; x origin

  * $y; y origin

set-source-rgb
--------------

Sets the source pattern within this context to an opaque color. This opaque color will then be used for any subsequent drawing operation until a new source pattern is set.

The color components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped.

The default source pattern is opaque black, (that is, it is equivalent to `set-source-rgb( 0.0, 0.0, 0.0)`).

    method set-source-rgb ( Num() $red, Num() $green, Num() $blue )

  * $red; red component of color

  * $green; green component of color

  * $blue; blue component of color

set-source-rgba
---------------

Sets the source pattern within this context to a translucent color. This color will then be used for any subsequent drawing operation until a new source pattern is set.

The color and alpha components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped.

The default source pattern is opaque black, (that is, it is equivalent to `set-source-rgba( 0.0, 0.0, 0.0, 1.0))`.

    method set-source-rgba (
      Num() $red, Num() $green, Num() $blue, Num() $alpha
    )

  * $red; red component of color

  * $green; green component of color

  * $blue; blue component of color

  * $alpha; alpha component of color

set-source-surface
------------------

This is a convenience function for creating a pattern from *$surface* and setting it as the source in this context with `set-source()`.

The *$x* and *$y* parameters give the user-space coordinate at which the surface origin should appear. (The surface origin is its upper-left corner before any transformation has been applied). The *$x* and *$y* parameters are negated and then set as translation values in the pattern matrix.

Other than the initial translation pattern matrix, as described above, all other pattern attributes, (such as its extend mode), are set to the default values as in `Gnome::Cairo::Pattern.new(:surface)`. The resulting pattern can be queried with `get-source()` so that these attributes can be modified if desired, (eg. to create a repeating pattern with `Gnome::Cairo::Pattern.set-extend()`).

    method set-source-surface ( cairo_surface_t $surface, Num() $x, Num() $y )

  * $surface; a surface to be used to set the source pattern

  * $x; User-space X coordinate for surface origin

  * $y; User-space Y coordinate for surface origin

set-tolerance
-------------

Sets the tolerance used when converting paths into trapezoids. Curved segments of the path will be subdivided until the maximum deviation between the original path and the polygonal approximation is less than *$tolerance*. The default value is 0.1. A larger value will give better performance, a smaller value, better appearance. (Reducing the value from the default value of 0.1 is unlikely to improve appearance significantly.)

The accuracy of paths within Cairo is limited by the precision of its internal arithmetic, and the prescribed *$tolerance* is restricted to the smallest representable internal value.

    method set-tolerance ( Num() $tolerance )

  * $tolerance; the tolerance, in device units

show-glyphs
-----------

A drawing operator that generates the shape from an array of glyphs, rendered according to the current font face, font size (font matrix), and font options.

    method show-glyphs ( Array $glyphs )

  * $glyphs; array of glyphs to show

  * $num_glyphs; number of glyphs to show

show-page
---------

Emits and clears the current page for backends that support multiple pages. Use `copy-page()` if you don't want to clear the page.

This is a convenience function that simply calls `Gnome::Cairo::Surface.show-page()` on this context's target surface.

    method show-page ( )

show-text
---------

A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options.

This function first computes a set of glyphs for the string of text. The first glyph is placed so that its origin is at the current point. The origin of each subsequent glyph is offset from that of the previous glyph by the advance values of the previous glyph.

After this call the current point is moved to the origin of where the next glyph would be placed in this same progression. That is, the current point will be at the origin of the final glyph offset by its advance values. This allows for easy display of a single logical string with multiple calls to `show-text()`.

Note: The `show-text()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications. See `show-glyphs()` for the "real" text display API in cairo.

    method show-text ( Str $utf8-string )

  * $utf8-string; a string to show

show-text-glyphs
----------------

This operation has rendering effects similar to `show-glyphs()` but, if the target surface supports it, uses the provided text and cluster mapping to embed the text for the glyphs shown in the output. If the target does not support the extended attributes, this function acts like the basic `show-glyphs()` as if it had been passed *glyphs* and *num_glyphs*.

The mapping between *utf8* and *glyphs* is provided by an array of *clusters*. Each cluster covers a number of text bytes and glyphs, and neighboring clusters cover neighboring areas of *utf8* and *glyphs*.

The clusters should collectively cover *utf8* and *glyphs* in entirety.

The first cluster always covers bytes from the beginning of *utf8*. If *cluster_flags* do not have the `CAIRO_TEXT_CLUSTER_FLAG_BACKWARD` set, the first cluster also covers the beginning of *glyphs*, otherwise it covers the end of the *glyphs* array and following clusters move backward.

See **cairo_text_cluster_t** for constraints on valid clusters.

    method show-text-glyphs (
      Str $utf8, Array $glyphs, Array $clusters,
      cairo_text_cluster_flags_t $cluster_flags
    )

  * $utf8; a string of text encoded in UTF-8.

  * $glyphs; array of glyphs to show. Element type cairo_glyph_t.

  * $clusters; array of cluster mapping information. Element type cairo_text_cluster_t.

  * $cluster_flags; cluster mapping flags.

status
------

Checks whether an error has previously occurred for this context.

Returns: the current status of this context, see **cairo_status_t**

    method status ( --> cairo_status_t )

status-to-string
----------------

Provides a human-readable description of a cairo_status_t.

    method status-to-string ( cairo_status_t $status --> Str )

stroke
------

A drawing operator that strokes the current path according to the current line width, line join, line cap, and dash settings. After `stroke()`, the current path will be cleared from the cairo context. See `set-line-width()`, `set-line-join()`, `cset-line-cap()`, `set-dash()`, and `stroke-preserve()`.

Note: Degenerate segments and sub-paths are treated specially and provide a useful result. These can result in two different situations:

  * Zero-length "on" segments set in `set-dash()`. If the cap style is `CAIRO_LINE_CAP_ROUND` or `CAIRO_LINE_CAP_SQUARE` then these segments will be drawn as circular dots or squares respectively. In the case of `CAIRO_LINE_CAP_SQUARE`, the orientation of the squares is determined by the direction of the underlying path.

  * A sub-path created by `move-to()` followed by either a `close-path()` or one or more calls to `line-to()` to the same coordinate as the `move-to()`. If the cap style is `CAIRO_LINE_CAP_ROUND` then these sub-paths will be drawn as circular dots.

Note that in the case of `CAIRO_LINE_CAP_SQUARE` a degenerate sub-path will not be drawn at all, (since the correct orientation is indeterminate). In no case will a cap style of `CAIRO_LINE_CAP_BUTT` cause anything to be drawn in the case of either degenerate segments or sub-paths.

    method stroke ( )

stroke-extents
--------------

Computes a bounding box in user coordinates covering the area that would be affected, (the "inked" area), by a `stroke()` operation given the current path and stroke parameters. If the current path is empty, returns an empty rectangle ((0,0), (0,0)). Surface dimensions and clipping are not taken into account.

Note that if the line width is set to exactly zero, then `stroke-extents()` will return an empty rectangle. Contrast with `path-extents()` which can be used to compute the non-empty bounds as the line width approaches zero.

Note that `stroke-extents()` must necessarily do more work to compute the precise inked areas in light of the stroke parameters, so `path-extents()` may be more desirable for sake of performance if non-inked path extents are desired. See `stroke()`, `set-line-width()`, `set-line-join()`, `set-line-cap()`, `set-dash()`, and `stroke-preserve()`.

    method stroke-extents ( --> List )

List returns;

  * Num; left of the resulting extents

  * Num; top of the resulting extents

  * Num; right of the resulting extents

  * Num; bottom of the resulting extents

stroke-preserve
---------------

A drawing operator that strokes the current path according to the current line width, line join, line cap, and dash settings. Unlike `stroke()`, `stroke-preserve()` preserves the path within the cairo context.

See `set-line-width()`, `set-line-join()`, `set-line-cap()`, `set-dash()`, and `stroke-preserve()`.

    method stroke-preserve ( )

tag-begin
---------

Marks the beginning of the *t$ag-name* structure. Call `tag-end()` with the same *$tag-name* to mark the end of the structure.

The `$attributes` string is of the form "key1=value2 key2=value2 ...". Values may be boolean (true/false or 1/0), integer, float, string, or an array. String values are enclosed in single quotes ('). Single quotes and backslashes inside the string should be escaped with a backslash. Boolean values may be set to true by only specifying the key. E.g. the attribute string "key" is the equivalent to "key=true". Arrays are enclosed in '[]'. E.g. "rect=[1.2 4.3 2.0 3.0]".

If no attributes are required, *attributes* can be an empty string or NULL. Invalid nesting of tags or invalid attributes will cause this context to shutdown with a status of `CAIRO_STATUS_TAG_ERROR`.

For example;

    with $cairo {
      .tag-begin( CAIRO_TAG_LINK, "uri='https://cairographics.org'");
      .move-to( 50, 50);
      .show-text('This is a link to the cairo website.');
      .tag-end(CAIRO_TAG_LINK);
    }

See `tag-end()`.

    method tag-begin ( Str $tag_name, Str $attributes )

  * $tag-name; The tag name. This can only be one of `CAIRO_TAG_LINK` or `CAIRO_TAG_DEST`.

  * $attributes; tag attributes.

tag-end
-------

Marks the end of the *tag_name* structure. Invalid nesting of tags will cause this context to shutdown with a status of `CAIRO_STATUS_TAG_ERROR`. See `tag-begin()`.

    method tag-end ( Str $tag_name )

  * $tag_name; tag name. This can only be one of `CAIRO_TAG_LINK` or `CAIRO_TAG_DEST`.

text-extents
------------

Gets the extents for a string of text. The extents describe a user-space rectangle that encloses the "inked" portion of the text, (as it would be drawn by `show-text()`). Additionally, the x_advance and y_advance values indicate the amount by which the current point would be advanced by `show-text()`.

Note that whitespace characters do not directly contribute to the size of the rectangle (extents.width and extents.height). They do contribute indirectly by changing the position of non-whitespace characters. In particular, trailing whitespace characters are likely to not affect the size of the rectangle, though they will affect the x_advance and y_advance values.

    method text-extents ( Str $utf-string --> cairo_text_extents_t )

  * $utf8;

  * cairo_text_extents_t $extents; a NUL-terminated string of text encoded in UTF-8, or `Any`

text-path
---------

Adds closed paths for text to the current path.

The generated path if filled, achieves an effect similar to that of `show-text()`.

Text conversion and positioning is done similar to `show-text()`.

Like `show-text()`, After this call the current point is moved to the origin of where the next glyph would be placed in this same progression.

That is, the current point will be at the origin of the final glyph offset by its advance values. This allows for chaining multiple calls to to `text-path()` without having to set current point in between.

Note: The `text-path()` function call is part of what the cairo designers call the "toy" text API. It is convenient for short demos and simple programs, but it is not expected to be adequate for serious text-using applications. See `glyph-path()` for the "real" text path API in cairo.

    method text-path ( Str $utf8 )

  * $utf8; a string of text encoded in UTF-8.

transform
---------

Modifies the current transformation matrix (CTM) by applying *matrix* as an additional transformation. The new transformation of user space takes place after any existing transformation.

    method transform ( cairo_matrix_t $matrix )

  * $matrix; a transformation to be applied to the user-space axes

translate
---------

Modifies the current transformation matrix (CTM) by translating the user-space origin by (*tx*, *ty*). This offset is interpreted as a user-space coordinate according to the CTM in place before the new call to `translate()`. In other words, the translation of the user-space origin takes place after any existing transformation.

    method translate ( Num() $tx, Num() $ty )

  * $tx; amount to translate in the X direction

  * $ty; amount to translate in the Y direction

user-to-device
--------------

Transform a coordinate from user space to device space by multiplying the given point by the current transformation matrix (CTM).

    method user-to-device ( Num() $x is rw, Num() $y is rw )

  * $x; X value of coordinate

  * $y; Y value of coordinate

user-to-device-distance
-----------------------

Transform a distance vector from user space to device space. This function is similar to `user-to-device()` except that the translation components of the CTM will be ignored when transforming (*dx*,*dy*).

    method user-to-device-distance ( Num() $dx is rw, Num() $dy is rw )

  * $dx; X component of a distance vector

  * $dy; Y component of a distance vector

