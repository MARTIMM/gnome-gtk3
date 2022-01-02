Gnome::Cairo::Pattern
=====================

Sources for drawing

Description
===========

**cairo_pattern_t** is the paint with which cairo draws. The primary use of patterns is as the source for all cairo drawing operations, although they can also be used as masks, that is, as the brush too.

A cairo pattern is created by using one of the many constructors in the form of `new(:rgb())` for example.

See Also
--------

**cairo_t**, **cairo_surface_t**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::Pattern;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### new ( :rgb( red, green, blue) )

Creates a new **cairo_pattern_t** corresponding to an opaque color. The color components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped. Return value: the newly created **cairo_pattern_t** if successful, or an error pattern in case of no memory.

The caller owns the returned object and should call `clear-object()` when finished with it. This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error. To inspect the status of a pattern use `status()`.

A translucent colored pattern is created when also an alpha value is defined.

    multi method new ( :rgb( Num() $red, Num() $green, Num() $blue) )

  * $red; red color from 0 to 1

  * $green; green color from 0 to 1

  * $blue; blue color from 0 to 1

### new ( )

Creates a new **cairo_pattern_t** as if :rgb( 1, 1, 1) is used. This is a white colored pattern.

    multi method new ( )

### new ( :rgba( red, green, blue, alpha) )

Creates a new **cairo_pattern_t** corresponding to a color with added transparency.

The caller owns the returned object and should call `clear-object()` when finished with it. This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error. To inspect the status of a pattern use `status()`.

    multi method new (
      :rgba( Num() $red, Num() $green, Num() $blue, Num() $alpha)
    )

  * $red; red color from 0 to 1

  * $green; green color from 0 to 1

  * $blue; blue color from 0 to 1

  * $alpha; transparency from 0 to 1 (opaque)

### new ( :surface )

Create a new **cairo_pattern_t** for the given surface. The caller owns the returned object and should call `clear-object()` when finished with it. This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error. To inspect the status of a pattern use `status()`.

    multi method new ( cairo_surface_t :$surface! )

### new ( :linear( x0, y0, x1, y1) )

Create a new linear gradient **cairo_pattern_t** along the line defined by (x0, y0) and (x1, y1). Before using the gradient pattern, a number of color stops should be defined using `add-color-stop-rgb()` or `add-color-stop-rgba()`. Note: The coordinates here are in pattern space. For a new pattern, pattern space is identical to user space, but the relationship between the spaces can be changed with `set-matrix()`.

The caller owns the returned object and should call `clear-object()` when finished with it. This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error. To inspect the status of a pattern use `status()`.

    method new ( :linear( Num() $x0, Num() $y0, Num() $x1, Num() $y1) )

  * $x0; x coordinate of the start point

  * $y0; y coordinate of the start point

  * $x1; x coordinate of the end point

  * $y1; y coordinate of the end point

### new ( :radial( cx0, cy0, radius0, cx1, cy1, radius1) )

Creates a new radial gradient **cairo_pattern_t** between the two circles defined by (cx0, cy0, radius0) and (cx1, cy1, radius1). Before using the gradient pattern, a number of color stops should be defined using `add-color-stop-rgb()` or `add-color-stop-rgba()`. Note: The coordinates here are in pattern space. For a new pattern, pattern space is identical to user space, but the relationship between the spaces can be changed with `set-matrix()`.

The caller owns the returned object and should call `clear-object()` when finished with it. To inspect the status of a pattern use `status()`.

    multi method new (
      :radial(
        Num() $cx0, Num() $cy0, Num() $radius0,
        Num() $cx1, Num() $cy1, Num() $radius1
      )
    )

  * $cx0; x coordinate for the center of the start circle

  * $cy0; y coordinate for the center of the start circle

  * $radius0; radius of the start circle

  * $cx1; x coordinate for the center of the end circle

  * $cy1; y coordinate for the center of the end circle

  * $radius1; radius of the end circle

### new( :mesh )

Create a new mesh pattern.

Mesh patterns are tensor-product patch meshes (type 7 shadings in PDF). Mesh patterns may also be used to create other types of shadings that are special cases of tensor-product patch meshes such as Coons patch meshes (type 6 shading in PDF) and Gouraud-shaded triangle meshes (type 4 and 5 shadings in PDF).

Mesh patterns consist of one or more tensor-product patches, which should be defined before using the mesh pattern. Using a mesh pattern with a partially defined patch as source or mask will put the context in an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

A tensor-product patch is defined by 4 Bézier curves (side 0, 1, 2, 3) and by 4 additional control points (P0, P1, P2, P3) that provide further control over the patch and complete the definition of the tensor-product patch. The corner C0 is the first point of the patch.

Degenerate sides are permitted so straight lines may be used. A zero length line on one side may be used to create 3 sided patches.

            C1     Side 1      C2
              +---------------+
              |               |
              |  P1       P2  |
              |               |
      Side 0  |               | Side 2
              |               |
              |               |
              |  P0       P3  |
              |               |
              +---------------+
            C0     Side 3      C3

Each patch is constructed by first calling `mesh-pattern-begin-patch()`, then `mesh-pattern-move-to()` to specify the first point in the patch (C0). Then the sides are specified with calls to `mesh-pattern-curve-to()` and `mesh-pattern-line-to()`.

The four additional control points (P0, P1, P2, P3) in a patch can be specified with `mesh-pattern-set-control-point()`. At each corner of the patch (C0, C1, C2, C3) a color may be specified with `mesh-pattern-set-corner-color-rgb()` or `mesh-pattern-set-corner-color-rgba()`. Any corner whose color is not explicitly specified defaults to transparent black. A Coons patch is a special case of the tensor-product patch where the control points are implicitly defined by the sides of the patch. The default value for any control point not specified is the implicit value for a Coons patch, i.e. if no control points are specified the patch is a Coons patch. A triangle is a special case of the tensor-product patch where the control points are implicitly defined by the sides of the patch, all the sides are lines and one of them has length 0, i.e. if the patch is specified using just 3 lines, it is a triangle. If the corners connected by the 0-length side have the same color, the patch is a Gouraud-shaded triangle. Patches may be oriented differently to the above diagram. For example the first point could be at the top left. The diagram only shows the relationship between the sides, corners and control points. Regardless of where the first point is located, when specifying colors, corner 0 will always be the first point, corner 1 the point between side 0 and side 1 etc.

Calling `mesh-pattern-end-patch()` completes the current patch. If less than 4 sides have been defined, the first missing side is defined as a line from the current point to the first point of the patch (C0) and the other sides are degenerate lines from C0 to C0. The corners between the added sides will all be coincident with C0 of the patch and their color will be set to be the same as the color of C0.

Additional patches may be added with additional calls to `mesh-pattern-begin-patch()`/`mesh-pattern-end-patch()`.

    my Gnome::Cairo $pattern .= new(:mesh);

    # Add a Coons patch
    $pattern.mesh-pattern-begin-patch( $pattern);
    $pattern.mesh-pattern-move-to( 0, 0);
    $pattern.mesh-pattern-curve-to( 30, -30,  60,  30, 100, 0);
    $pattern.mesh-pattern-curve-to( 60,  30, 130,  60, 100, 100);
    $pattern.mesh-pattern-curve-to( 60,  70,  30, 130,   0, 100);
    $pattern.mesh-pattern-curve-to( 30,  70, -30,  30,   0, 0);
    $pattern.mesh-pattern-set-corner-color-rgb( $pattern, 0, 1, 0, 0);
    $pattern.mesh-pattern-set-corner-color-rgb( 1, 0, 1, 0);
    $pattern.mesh-pattern-set-corner-color-rgb( 2, 0, 0, 1);
    $pattern.mesh-pattern-set-corner-color-rgb( 3, 1, 1, 0);
    $pattern.mesh-pattern-end-patch;

    # Add a Gouraud-shaded triangle
    $pattern.mesh-pattern-begin-patch;
    $pattern.mesh-pattern-move-to( 100, 100);
    $pattern.mesh-pattern-line-to( 130, 130);
    $pattern.mesh-pattern-line-to( 130,  70);
    $pattern.mesh-pattern-set-corner-color-rgb( 0, 1, 0, 0);
    $pattern.mesh-pattern-set-corner-color-rgb( 1, 0, 1, 0);
    $pattern.mesh-pattern-set-corner-color-rgb( 2, 0, 0, 1);
    $pattern.mesh-pattern-end-patch;

When two patches overlap, the last one that has been added is drawn over the first one.

When a patch folds over itself, points are sorted depending on their parameter coordinates inside the patch. The v coordinate ranges from 0 to 1 when moving from side 3 to side 1; the u coordinate ranges from 0 to 1 when going from side 0 to side 2. Points with higher v coordinate hide points with lower v coordinate. When two points have the same v coordinate, the one with higher u coordinate is above. This means that points nearer to side 1 are above points nearer to side 3; when this is not sufficient to decide which point is above (for example when both points belong to side 1 or side 3) points nearer to side 2 are above points nearer to side 0. For a complete definition of tensor-product patches, see the PDF specification (ISO32000), which describes the parametrization in detail.

Note: The coordinates are always in pattern space. For a new pattern, pattern space is identical to user space, but the relationship between the spaces can be changed with `pattern-set-matrix()`. Return value: the newly created **cairo_pattern_t** if successful, or an error pattern in case of no memory. The caller owns the returned object and should call `pattern-destroy()` when finished with it. This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error. To inspect the status of a pattern use `pattern-status()`.

    multi method new ( :mesh! )

add-color-stop-rgb
------------------

Adds an opaque color stop to a gradient pattern. The offset specifies the location along the gradient's control vector. For example, a linear gradient's control vector is from (x0,y0) to (x1,y1) while a radial gradient's control vector is from any point on the start circle to the corresponding point on the end circle. The color is specified in the same way as in `set-source-rgb()`. If two (or more) stops are specified with identical offset values, they will be sorted according to the order in which the stops are added, (stops added earlier will compare less than stops added later). This can be useful for reliably making sharp color transitions instead of the typical blend. Note: If the pattern is not a gradient pattern, (eg. a linear or radial pattern), then the pattern will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`.

    method add-color-stop-rgb ( Num $offset, Num $red, Num $green, Num $blue )

  * Num $offset; a **cairo_pattern_t**

  * Num $red; an offset in the range [0.0 .. 1.0]

  * Num $green; red component of color

  * Num $blue; green component of color

add-color-stop-rgba
-------------------

Adds a translucent color stop to a gradient pattern. The offset specifies the location along the gradient's control vector. For example, a linear gradient's control vector is from (x0,y0) to (x1,y1) while a radial gradient's control vector is from any point on the start circle to the corresponding point on the end circle. The color is specified in the same way as in `set-source-rgba()`. If two (or more) stops are specified with identical offset values, they will be sorted according to the order in which the stops are added, (stops added earlier will compare less than stops added later). This can be useful for reliably making sharp color transitions instead of the typical blend. Note: If the pattern is not a gradient pattern, (eg. a linear or radial pattern), then the pattern will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`.

    method add-color-stop-rgba ( Num $offset, Num $red, Num $green, Num $blue, Num $alpha )

  * Num $offset; a **cairo_pattern_t**

  * Num $red; an offset in the range [0.0 .. 1.0]

  * Num $green; red component of color

  * Num $blue; green component of color

  * Num $alpha; blue component of color

mesh-pattern-begin-patch
------------------------

Begin a patch in a mesh pattern. After calling this function, the patch shape should be defined with `mesh-pattern-move-to()`, `mesh-pattern-line-to()` and `mesh-pattern-curve-to()`. After defining the patch, `mesh-pattern-end-patch()` must be called before using *pattern* as a source or mask. Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *pattern* already has a current patch, it will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-begin-patch ( )

mesh-pattern-curve-to
---------------------

Adds a cubic Bézier spline to the current patch from the current point to position (*x3*, *y3*) in pattern-space coordinates, using (*x1*, *y1*) and (*x2*, *y2*) as the control points. If the current patch has no current point before the call to `mesh-pattern-curve-to()`, this function will behave as if preceded by a call to cairo_mesh_pattern_move_to(*pattern*, *x1*, *y1*). After this call the current point will be (*x3*, *y3*). Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *pattern* has no current patch or the current patch already has 4 sides, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-curve-to ( Num $x1, Num $y1, Num $x2, Num $y2, Num $x3, Num $y3 )

  * Num $x1; a **cairo_pattern_t**

  * Num $y1; the X coordinate of the first control point

  * Num $x2; the Y coordinate of the first control point

  * Num $y2; the X coordinate of the second control point

  * Num $x3; the Y coordinate of the second control point

  * Num $y3; the X coordinate of the end of the curve

mesh-pattern-end-patch
----------------------

Indicates the end of the current patch in a mesh pattern. If the current patch has less than 4 sides, it is closed with a straight line from the current point to the first point of the patch as if `mesh-pattern-line-to()` was used. Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *pattern* has no current patch or the current patch has no current point, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-end-patch ( )

mesh-pattern-get-control-point
------------------------------

Gets the control point *point_num* of patch *patch_num* for a mesh pattern. *patch_num* can range from 0 to n-1 where n is the number returned by `mesh_pattern-get-patch-count()`. Valid values for *point_num* are from 0 to 3 and identify the control points as explained in `create-mesh()`. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_INVALID_INDEX` if *patch_num* or *point_num* is not valid for *pattern*. If *pattern* is not a mesh pattern, `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` is returned.

    method mesh-pattern-get-control-point ( Int $patch_num, Int $point_num, Num $x, Num $y --> cairo_status_t )

  * Int $patch_num; a **cairo_pattern_t**

  * Int $point_num; the patch number to return data for

  * Num $x; the control point number to return data for

  * Num $y; return value for the x coordinate of the control point, or `Any`

mesh-pattern-get-corner-color-rgba
----------------------------------

Gets the color information in corner *corner_num* of patch *patch_num* for a mesh pattern. *patch_num* can range from 0 to n-1 where n is the number returned by `mesh-pattern-get-patch-count()`. Valid values for *corner_num* are from 0 to 3 and identify the corners as explained in `create-mesh()`. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_INVALID_INDEX` if *patch_num* or *corner_num* is not valid for *pattern*. If *pattern* is not a mesh pattern, `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` is returned.

    method mesh-pattern-get-corner-color-rgba ( Int $patch_num, Int $corner_num, Num $red, Num $green, Num $blue, Num $alpha --> cairo_status_t )

  * Int $patch_num; a **cairo_pattern_t**

  * Int $corner_num; the patch number to return data for

  * Num $red; the corner number to return data for

  * Num $green; return value for red component of color, or `Any`

  * Num $blue; return value for green component of color, or `Any`

  * Num $alpha; return value for blue component of color, or `Any`

mesh-pattern-get-patch-count
----------------------------

Gets the number of patches specified in the given mesh pattern. The number only includes patches which have been finished by calling `mesh-pattern-end-patch()`. For example it will be 0 during the definition of the first patch.

    method mesh-pattern-get-patch-count ( --> List )

Returned List holds;

  * Int; The count of patches

  * cairo_status_t; The status, `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if *pattern* is not a mesh pattern.

mesh-pattern-get-path
---------------------

Gets path defining the patch *patch_num* for a mesh pattern. *patch_num* can range from 0 to n-1 where n is the number returned by `mesh-pattern-get-patch-count()`. Return value: the path defining the patch, or a path with status `CAIRO_STATUS_INVALID_INDEX` if *patch_num* or *point_num* is not valid for *pattern*. If *pattern* is not a mesh pattern, a path with status `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` is returned.

    method mesh-pattern-get-path ( Int $patch_num --> cairo_path_t )

  * Int $patch_num; a **cairo_pattern_t**

mesh-pattern-line-to
--------------------

Adds a line to the current patch from the current point to position (*x*, *y*) in pattern-space coordinates. If there is no current point before the call to `mesh-pattern-line-to()` this function will behave as cairo_mesh_pattern_move_to(*pattern*, *x*, *y*). After this call the current point will be (*x*, *y*). Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *pattern* has no current patch or the current patch already has 4 sides, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-line-to ( Num $x, Num $y )

  * Num $x; a **cairo_pattern_t**

  * Num $y; the X coordinate of the end of the new line

mesh-pattern-move-to
--------------------

Define the first point of the current patch in a mesh pattern. After this call the current point will be (*x*, *y*). Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *pattern* has no current patch or the current patch already has at least one side, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-move-to ( Num $x, Num $y )

  * Num $x; a **cairo_pattern_t**

  * Num $y; the X coordinate of the new position

mesh-pattern-set-control-point
------------------------------

Set an internal control point of the current patch. Valid values for *point_num* are from 0 to 3 and identify the control points as explained in `create-mesh()`. Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *point_num* is not valid, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_INDEX`. If *pattern* has no current patch, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-set-control-point ( Int $point_num, Num $x, Num $y )

  * Int $point_num; a **cairo_pattern_t**

  * Num $x; the control point to set the position for

  * Num $y; the X coordinate of the control point

mesh-pattern-set-corner-color-rgb
---------------------------------

Sets the color of a corner of the current patch in a mesh pattern. The color is specified in the same way as in `set-source-rgb()`. Valid values for *corner_num* are from 0 to 3 and identify the corners as explained in `create-mesh()`. Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *corner_num* is not valid, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_INDEX`. If *pattern* has no current patch, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-set-corner-color-rgb ( Int $corner_num, Num $red, Num $green, Num $blue )

  * Int $corner_num; a **cairo_pattern_t**

  * Num $red; the corner to set the color for

  * Num $green; red component of color

  * Num $blue; green component of color

mesh-pattern-set-corner-color-rgba
----------------------------------

Sets the color of a corner of the current patch in a mesh pattern. The color is specified in the same way as in `set-source-rgba()`. Valid values for *corner_num* are from 0 to 3 and identify the corners as explained in `create-mesh()`. Note: If *pattern* is not a mesh pattern then *pattern* will be put into an error status with a status of `CAIRO_STATUS_PATTERN_TYPE_MISMATCH`. If *corner_num* is not valid, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_INDEX`. If *pattern* has no current patch, *pattern* will be put into an error status with a status of `CAIRO_STATUS_INVALID_MESH_CONSTRUCTION`.

    method mesh-pattern-set-corner-color-rgba ( Int $corner_num, Num $red, Num $green, Num $blue, Num $alpha )

  * Int $corner_num; a **cairo_pattern_t**

  * Num $red; the corner to set the color for

  * Num $green; red component of color

  * Num $blue; green component of color

  * Num $alpha; blue component of color

get-color-stop-count
--------------------

Gets the number of color stops specified in the given gradient pattern. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if *pattern* is not a gradient pattern.

    method get-color-stop-count ( Int $count --> cairo_status_t )

  * Int $count; a **cairo_pattern_t**

get-color-stop-rgba
-------------------

Gets the color and offset information at the given *index* for a gradient pattern. Values of *index* range from 0 to n-1 where n is the number returned by `get-color-stop-count()`. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_INVALID_INDEX` if *index* is not valid for the given pattern. If the pattern is not a gradient pattern, `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` is returned.

    method get-color-stop-rgba ( Int $index, Num $offset, Num $red, Num $green, Num $blue, Num $alpha --> cairo_status_t )

  * Int $index; a **cairo_pattern_t**

  * Num $offset; index of the stop to return data for

  * Num $red; return value for the offset of the stop, or `Any`

  * Num $green; return value for red component of color, or `Any`

  * Num $blue; return value for green component of color, or `Any`

  * Num $alpha; return value for blue component of color, or `Any`

get-extend
----------

Gets the current extend mode for a pattern. See **cairo_extend_t** for details on the semantics of each extend strategy. Return value: the current extend strategy used for drawing the pattern.

    method get-extend ( --> cairo_extend_t )

get-filter
----------

Gets the current filter for a pattern. See **cairo_filter_t** for details on each filter. Return value: the current filter used for resizing the pattern.

    method get-filter ( --> cairo_filter_t )

get-linear-points
-----------------

Gets the gradient endpoints for a linear gradient. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if *pattern* is not a linear gradient pattern.

    method get-linear-points ( Num $x0, Num $y0, Num $x1, Num $y1 --> cairo_status_t )

  * Num $x0; a **cairo_pattern_t**

  * Num $y0; return value for the x coordinate of the first point, or `Any`

  * Num $x1; return value for the y coordinate of the first point, or `Any`

  * Num $y1; return value for the x coordinate of the second point, or `Any`

get-matrix
----------

Stores the pattern's transformation matrix into *matrix*.

    method get-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a **cairo_pattern_t**

get-radial-circles
------------------

Gets the gradient endpoint circles for a radial gradient, each specified as a center coordinate and a radius. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if *pattern* is not a radial gradient pattern.

    method get-radial-circles ( Num $x0, Num $y0, Num $r0, Num $x1, Num $y1, Num $r1 --> cairo_status_t )

  * Num $x0; a **cairo_pattern_t**

  * Num $y0; return value for the x coordinate of the center of the first circle, or `Any`

  * Num $r0; return value for the y coordinate of the center of the first circle, or `Any`

  * Num $x1; return value for the radius of the first circle, or `Any`

  * Num $y1; return value for the x coordinate of the center of the second circle, or `Any`

  * Num $r1; return value for the y coordinate of the center of the second circle, or `Any`

get-reference-count
-------------------

Returns the current reference count of *pattern*. Return value: the current reference count of *pattern*. If the object is a nil object, 0 will be returned.

    method get-reference-count ( --> Int )

get-rgba
--------

Gets the solid color for a solid color pattern. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if the pattern is not a solid color pattern.

    method get-rgba ( Num $red, Num $green, Num $blue, Num $alpha --> cairo_status_t )

  * Num $red; a **cairo_pattern_t**

  * Num $green; return value for red component of color, or `Any`

  * Num $blue; return value for green component of color, or `Any`

  * Num $alpha; return value for blue component of color, or `Any`

get-surface
-----------

Gets the surface of a surface pattern. The reference returned in *surface* is owned by the pattern; the caller should call `surface-reference()` if the surface is to be retained. Return value: `CAIRO_STATUS_SUCCESS`, or `CAIRO_STATUS_PATTERN_TYPE_MISMATCH` if the pattern is not a surface pattern.

    method get-surface ( cairo_surface_t $surface --> cairo_status_t )

  * cairo_surface_t $surface; a **cairo_pattern_t**

get-type
--------

Get the pattern's type. See **cairo_pattern_type_t** for available types. Return value: The type of *pattern*.

    method get-type ( --> cairo_pattern_type_t )

set-extend
----------

Sets the mode to be used for drawing outside the area of a pattern. See **cairo_extend_t** for details on the semantics of each extend strategy. The default extend mode is `CAIRO_EXTEND_NONE` for surface patterns and `CAIRO_EXTEND_PAD` for gradient patterns.

    method set-extend ( cairo_extend_t $extend )

  * cairo_extend_t $extend; a **cairo_pattern_t**

set-filter
----------

Sets the filter to be used for resizing when using this pattern. See **cairo_filter_t** for details on each filter. * Note that you might want to control filtering even when you do not have an explicit **cairo_pattern_t** object, (for example when using `set-source-surface()`). In these cases, it is convenient to use `get-source()` to get access to the pattern that cairo creates implicitly. For example:

    cairo_set_source_surface (cr, image, x, y); cairo_pattern_set_filter (cairo_get_source (cr), CAIRO_FILTER_NEAREST);



     method set-filter ( cairo_filter_t $filter )

  * cairo_filter_t $filter; a **cairo_pattern_t**

set-matrix
----------

Sets the pattern's transformation matrix to *matrix*. This matrix is a transformation from user space to pattern space. When a pattern is first created it always has the identity matrix for its transformation matrix, which means that pattern space is initially identical to user space. Important: Please note that the direction of this transformation matrix is from user space to pattern space. This means that if you imagine the flow from a pattern to user space (and on to device space), then coordinates in that flow will be transformed by the inverse of the pattern matrix. For example, if you want to make a pattern appear twice as large as it does by default the correct code to use is:

    cairo_matrix_init_scale (&amp;matrix, 0.5, 0.5); cairo_pattern_set_matrix (pattern, &amp;matrix);

      Meanwhile, using values of 2.0 rather than 0.5 in the code above would cause the pattern to appear at half of its default size.  Also, please note the discussion of the user-space locking semantics of C<set-source()>.

     method set-matrix ( cairo_matrix_t $matrix )

  * cairo_matrix_t $matrix; a **cairo_pattern_t**

status
------

Checks whether an error has previously occurred for this pattern.

    method status ( --> cairo_status_t )

