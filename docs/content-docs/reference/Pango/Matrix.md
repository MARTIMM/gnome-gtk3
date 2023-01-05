Gnome::Pango::Matrix
====================

Description
===========

A Gnome::Pango::Matrix specifies a transformation between user-space and device coordinates.

Given the transformation matrix.

    class N-PangoMatrix is export is repr('CStruct') {
      has gdouble $.xx;
      has gdouble $.xy;
      has gdouble $.yx;
      has gdouble $.yy;
      has gdouble $.x0;
      has gdouble $.y0;
    }

Then the transformation is given by

    | $xd $yd | = | $xu $yu 1 | * | $xx $yx |
                                  | $xy $yy |
                                  | $x0 $y0 |

or

    $xd = $xu * $matrix.xx + $yu * $matrix.xy + $matrix.x0;
    $yd = $xu * $matrix.yx + $yu * $matrix.yy + $matrix.y0;

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::Matrix;
    also is Gnome::GObject::Boxed;

Types
=====

class N-PangoMatrix
-------------------

A `PangoMatrix` specifies a transformation between user-space and device coordinates.

  * double $.xx: 1st component of the transformation matrix

  * double $.xy: 2nd component of the transformation matrix

  * double $.yx: 3rd component of the transformation matrix

  * double $.yy: 4th component of the transformation matrix

  * double $.x0: x translation

  * double $.y0: y translation

Methods
=======

new
---

### default, no options

Create a new Matrix object.

    multi method new ( )

### :native-object

Create a Matrix object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

concat
------

Changes the transformation represented by *matrix* to be the transformation given by first applying transformation given by *new_matrix* then applying the original transformation.

    method concat ( N-GObject() $new_matrix )

  * $new_matrix; a `PangoMatrix`

copy
----

Copies a PangoMatrix.

    method copy ( --> N-GObject )

Example

    my Gnome::Pango::Matrix() $my-copy = $matrix.copy;

get-font-scale-factor
---------------------

Returns the scale factor of a matrix on the height of the font.

That is, the scale factor in the direction perpendicular to the vector that the X coordinate is mapped to. If the scale in the X coordinate is needed as well, use method `.get-font-scale-factors()`.

Return value: the scale factor of *matrix* on the height of the font, or 1.0 if *matrix* is `undefined`.

    method get-font-scale-factor ( --> Num )

get-font-scale-factors
----------------------

Calculates the scale factor of a matrix on the width and height of the font.

That is, *xscale* is the scale factor in the direction of the X coordinate, and *yscale* is the scale factor in the direction perpendicular to the vector that the X coordinate is mapped to.

Note that output numbers will always be non-negative.

    method get-font-scale-factors ( --> List )

The list returned consists of

  * scale factor in the x direction

  * scale factor perpendicular to the x direction

get-slant-ratio
---------------

Gets the slant ratio of a matrix.

For a simple shear matrix in the form:

1 λ 0 1

this is simply λ.

Returns: the slant ratio of *matrix*

    method get-slant-ratio ( --> Num )

rotate
------

Changes the transformation represented by *matrix* to be the transformation given by first rotating by *degrees* degrees counter-clockwise then applying the original transformation.

    method rotate ( Num() $degrees )

  * $degrees; degrees to rotate counter-clockwise

scale
-----

Changes the transformation represented by *matrix* to be the transformation given by first scaling by *sx* in the X direction and *sy* in the Y direction then applying the original transformation.

    method scale ( Num() $scale_x, Num() $scale_y )

  * $scale_x; amount to scale by in X direction

  * $scale_y; amount to scale by in Y direction

transform-distance
------------------

Transforms the distance vector (*dx*,*dy*) by *matrix*.

This is similar to method `.transform_point()`, except that the translation components of the transformation are ignored. The calculation of the returned vector is as follows:

    dx2 = dx1 * xx + dy1 * xy;
    dy2 = dx1 * yx + dy1 * yy;

Affine transformations are position invariant, so the same vector always transforms to the same vector. If (*x1*,*y1*) transforms to (*x2*,*y2*) then (*x1*+*dx1*,*y1*+*dy1*) will transform to (*x1*+*dx2*,*y1*+*dy2*) for all values of *x1* and *x2*.

    method transform-distance ( Num() $dx is rw, Num() $dy is rw )

  * $dx; X component of a distance vector

  * $dy; Y component of a distance vector

transform-point
---------------

Transforms the point (*x*, *y*) by *matrix*.

    method transform-point ( Num() $x is rw, Num() $y is rw )

  * $x; in/out X position

  * $y; in/out Y position

translate
---------

Changes the transformation represented by *matrix* to be the transformation given by first translating by (*tx*, *ty*) then applying the original transformation.

    method translate ( Num() $tx, Num() $ty )

  * $tx; amount to translate in the X direction

  * $ty; amount to translate in the Y direction

