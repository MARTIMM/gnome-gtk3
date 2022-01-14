Gnome::Cairo::Matrix
====================

Generic matrix operations

Description
===========

**Gnome::Cairo::Matrix** is used throughout cairo to convert between different coordinate spaces.

The native type `cairo_matrix_t`, defined in **Gnome::Cairo::Types** has the following members;

  * Num $.xx; xx component of the affine transformation

  * Num $.yx; yx component of the affine transformation

  * Num $.xy; xy component of the affine transformation

  * Num $.yy; yy component of the affine transformation

  * Num $.x0; X translation component of the affine transformation

  * Num $.y0; Y translation component of the affine transformation

A **Gnome::Cairo::Matrix** holds an affine transformation, such as a scale, rotation, shear, or a combination of these. The transformation of a point `( $x, $y)` is given by:

    $x-new = $xx * $x + $xy * $y + $x0;
    $y-new = $yx * $x + $yy * $y + $y0;

The current transformation matrix of a cairo context, defines the transformation from user-space coordinates to device-space coordinates. See `cairo-get-matrix()` and `cairo-set-matrix()`.

See Also
--------

**Gnome::Cairo**

Synopsis
========

Declaration
-----------

    unit class Gnome::Cairo::Matrix;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### default, no options

Create a new Matrix object. All values are set to 0e0.

    multi method new ( )

### :init

Sets *matrix* to be the affine transformation given by *$xx*, *$yx*, *$xy*, *$yy*, *$x0*, *$y0*.

    multi method new (
      :init( Num() $xx, Num() $yx,
             Num() $xy, Num() $yy,
             Num() $x0, Num() $y0
           )!
    )

  * $xx; xx component of the affine transformation

  * $yx; yx component of the affine transformation

  * $xy; xy component of the affine transformation

  * $yy; yy component of the affine transformation

  * $x0; X translation component of the affine transformation

  * $y0; Y translation component of the affine transformation

### :init-identity

Modifies *matrix* to be an identity transformation.

    multi method new ( :init-identity! )

### :init-rotate

Initialized *matrix* to a transformation that rotates by *radians*.

    multi method new ( :init-rotate($radians)! )

  * $radians; angle of rotation, in radians.

### :init-scale

Initializes *matrix* to a transformation that scales by *sx* and *sy* in the X and Y dimensions, respectively.

    multi method new ( :init-scale( Num() $sx, Num() $sy)! )

  * $sx; scale factor in the X direction

  * $sy; scale factor in the Y direction

### :init-translate

Initializes *matrix* to a transformation that translates by *tx* and *ty* in the X and Y dimensions, respectively.

    multi method new ( :init-translate( Num() $tx, Num() $ty )! )

  * $tx; amount to translate in the X direction

  * $ty; amount to translate in the Y direction

### :$native-object

Create a Matrix object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( cairo_matrix_t :$native-object! )

invert
------

Changes *matrix* to be the inverse of its original value. Not all transformation matrices have inverses; if the matrix collapses points together (it is *degenerate*), then it has no inverse and this function will fail.

    Returns: If I<matrix> has an inverse, modifies I<matrix> to be the inverse matrix and returns C<CAIRO_STATUS_SUCCESS>. Otherwise, returns C<CAIRO_STATUS_INVALID-MATRIX>.

     method invert ( --> cairo_status_t )

multiply
--------

Multiplies the affine transformations in *$a* and *$b* together and stores the result in the current matrix. The effect of the resulting transformation is to first apply the transformation in *$a* to the coordinates and then apply the transformation in *$b* to the coordinates. It is allowable for the current matrix to be identical to either *$a* or *$b*.

    method multiply ( cairo_matrix_t $a, cairo_matrix_t $b )

  * $a; a matrix

  * $b; a matrix

rotate
------

Applies rotation by *$radians* to the transformation in *matrix*. The effect of the new transformation is to first rotate the coordinates by *$radians*, then apply the original transformation to the coordinates.

The direction of rotation is defined such that positive angles rotate in the direction from the positive X axis toward the positive Y axis. With the default axis orientation of cairo, positive angles rotate in a clockwise direction.

    method rotate ( Num() $radians )

  * $radians; angle of rotation, in radians.

scale
-----

Applies scaling by *$sx*, *$sy* to the transformation in *matrix*. The effect of the new transformation is to first scale the coordinates by *$sx* and *$sy*, then apply the original transformation to the coordinates.

    method scale ( Num() $sx, Num() $sy )

  * $sx; scale factor in the X direction

  * $sy; scale factor in the Y direction

transform-distance
------------------

Transforms the distance vector (*$dx*, *$dy*) by *matrix*. This is similar to `transform-point()` except that the translation components of the transformation are ignored. The calculation of the returned vector is as follows:

    dx2 = dx1 * a + dy1 * c;
    dy2 = dx1 * b + dy1 * d;

    Affine transformations are position invariant, so the same vector always transforms to the same vector. If C<( x1, y1)> transforms to C<( x2, y2)> then C<( x1 + dx1, y1 + dy1)> will transform to C<( x1 + dx2, y1 + dy2)> for all values of C<x1> and C<x2>.

     method transform-distance ( Num() $dx is rw, Num() $dy is rw )

  * $dx; X component of a distance vector. An in/out parameter

  * $dy; Y component of a distance vector. An in/out parameter

transform-point
---------------

Transforms the point (*x*, *y*) by *matrix*.

    method transform-point ( Num() $x is rw, Num() $y is rw )

  * $x; X position. An in/out parameter

  * $y; Y position. An in/out parameter

translate
---------

Applies a translation by *tx*, *ty* to the transformation in *matrix*. The effect of the new transformation is to first translate the coordinates by *tx* and *ty*, then apply the original transformation to the coordinates.

    method translate ( Num() $tx, Num() $ty )

  * $tx; amount to translate in the X direction

  * $ty; amount to translate in the Y direction

