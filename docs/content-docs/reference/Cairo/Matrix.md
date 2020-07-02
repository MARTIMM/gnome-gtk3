Gnome::Cairo::Matrix
====================

Generic matrix operations

Description
===========

    B<cairo_matrix_t> is used throughout cairo to convert between different coordinate spaces. A B<cairo_matrix_t> holds an affine transformation, such as a scale, rotation, shear, or a combination of these. The transformation of a point (<literal>x</literal>,<literal>y</literal>) is given by: <programlisting> x_new = xx * x + xy * y + x0; y_new = yx * x + yy * y + y0; </programlisting> The current transformation matrix of a B<cairo_t>, represented as a B<cairo_matrix_t>, defines the transformation from user-space coordinates to device-space coordinates. See C<cairo_get_matrix()> and C<cairo_set_matrix()>.

See Also
--------

**cairo_t**

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

### new()

Create a new Matrix object.

    multi method new ( )

[cairo_matrix_] init_identity
-----------------------------

Modifies *matrix* to be an identity transformation.

    method cairo_matrix_init_identity ( )

cairo_matrix_init
-----------------

Sets *matrix* to be the affine transformation given by *xx*, *yx*, *xy*, *yy*, *x0*, *y0*. The transformation is given by: <programlisting> x_new = xx * x + xy * y + x0; y_new = yx * x + yy * y + y0; </programlisting>

    method cairo_matrix_init ( Num $xx, Num $yx, Num $xy, Num $yy, Num $x0, Num $y0 )

  * Num $xx; a **cairo_matrix_t**

  * Num $yx; xx component of the affine transformation

  * Num $xy; yx component of the affine transformation

  * Num $yy; xy component of the affine transformation

  * Num $x0; yy component of the affine transformation

  * Num $y0; X translation component of the affine transformation

[cairo_matrix_] init_translate
------------------------------

Initializes *matrix* to a transformation that translates by *tx* and *ty* in the X and Y dimensions, respectively.

    method cairo_matrix_init_translate ( Num $tx, Num $ty )

  * Num $tx; a **cairo_matrix_t**

  * Num $ty; amount to translate in the X direction

cairo_matrix_translate
----------------------

Applies a translation by *tx*, *ty* to the transformation in *matrix*. The effect of the new transformation is to first translate the coordinates by *tx* and *ty*, then apply the original transformation to the coordinates.

    method cairo_matrix_translate ( Num $tx, Num $ty )

  * Num $tx; a **cairo_matrix_t**

  * Num $ty; amount to translate in the X direction

[cairo_matrix_] init_scale
--------------------------

Initializes *matrix* to a transformation that scales by *sx* and *sy* in the X and Y dimensions, respectively.

    method cairo_matrix_init_scale ( Num $sx, Num $sy )

  * Num $sx; a **cairo_matrix_t**

  * Num $sy; scale factor in the X direction

cairo_matrix_scale
------------------

Applies scaling by *sx*, *sy* to the transformation in *matrix*. The effect of the new transformation is to first scale the coordinates by *sx* and *sy*, then apply the original transformation to the coordinates.

    method cairo_matrix_scale ( Num $sx, Num $sy )

  * Num $sx; a **cairo_matrix_t**

  * Num $sy; scale factor in the X direction

[cairo_matrix_] init_rotate
---------------------------

Initialized *matrix* to a transformation that rotates by *radians*.

    method cairo_matrix_init_rotate ( Num $radians )

  * Num $radians; a **cairo_matrix_t**

cairo_matrix_rotate
-------------------

Applies rotation by *radians* to the transformation in *matrix*. The effect of the new transformation is to first rotate the coordinates by *radians*, then apply the original transformation to the coordinates.

    method cairo_matrix_rotate ( Num $radians )

  * Num $radians; a **cairo_matrix_t**

cairo_matrix_multiply
---------------------

Multiplies the affine transformations in *a* and *b* together and stores the result in *result*. The effect of the resulting transformation is to first apply the transformation in *a* to the coordinates and then apply the transformation in *b* to the coordinates. It is allowable for *result* to be identical to either *a* or *b*.

    method cairo_matrix_multiply ( cairo_matrix_t $a, cairo_matrix_t $b )

  * cairo_matrix_t $a; a **cairo_matrix_t** in which to store the result

  * cairo_matrix_t $b; a **cairo_matrix_t**

[cairo_matrix_] transform_distance
----------------------------------

Transforms the distance vector (*dx*,*dy*) by *matrix*. This is similar to `cairo_matrix_transform_point()` except that the translation components of the transformation are ignored. The calculation of the returned vector is as follows: <programlisting> dx2 = dx1 * a + dy1 * c; dy2 = dx1 * b + dy1 * d; </programlisting> Affine transformations are position invariant, so the same vector always transforms to the same vector. If (*x1*,*y1*) transforms to (*x2*,*y2*) then (*x1*+*dx1*,*y1*+*dy1*) will transform to (*x1*+*dx2*,*y1*+*dy2*) for all values of *x1* and *x2*.

    method cairo_matrix_transform_distance ( Num $dx, Num $dy )

  * Num $dx; a **cairo_matrix_t**

  * Num $dy; X component of a distance vector. An in/out parameter

[cairo_matrix_] transform_point
-------------------------------

Transforms the point (*x*, *y*) by *matrix*.

    method cairo_matrix_transform_point ( Num $x, Num $y )

  * Num $x; a **cairo_matrix_t**

  * Num $y; X position. An in/out parameter

cairo_matrix_invert
-------------------

Changes *matrix* to be the inverse of its original value. Not all transformation matrices have inverses; if the matrix collapses points together (it is *degenerate*), then it has no inverse and this function will fail. Returns: If *matrix* has an inverse, modifies *matrix* to be the inverse matrix and returns `CAIRO_STATUS_SUCCESS`. Otherwise, returns `CAIRO_STATUS_INVALID_MATRIX`.

    method cairo_matrix_invert ( --> Int )

