Gnome::Pango::Gravity
=====================

Description
===========

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::Gravity;

Types
=====

enum PangoGravity
-----------------

`PangoGravity` represents the orientation of glyphs in a segment of text.

This is useful when rendering vertical text layouts. In those situations, the layout is rotated using a non-identity [struct*Pango*.Matrix], and then glyph orientation is controlled using `PangoGravity`.

Not every value in this enumeration makes sense for every usage of `PangoGravity`; for example, `PANGO_GRAVITY_AUTO` only can be passed to [method*Pango*.Context.set_base_gravity] and can only be returned by [method*Pango*.Context.get_base_gravity].

See also: PangoGravityHint below

  * PANGO_GRAVITY_SOUTH: Glyphs stand upright (default) <img align="right" valign="center" src="m-south.png">

  * PANGO_GRAVITY_EAST: Glyphs are rotated 90 degrees counter-clockwise. <img align="right" valign="center" src="m-east.png">

  * PANGO_GRAVITY_NORTH: Glyphs are upside-down. <img align="right" valign="cener" src="m-north.png">

  * PANGO_GRAVITY_WEST: Glyphs are rotated 90 degrees clockwise. <img align="right" valign="center" src="m-west.png">

  * PANGO_GRAVITY_AUTO: Gravity is resolved from the context matrix

enum PangoGravityHint
---------------------

`PangoGravityHint` defines how horizontal scripts should behave in a vertical context.

That is, English excerpts in a vertical paragraph for example.

See also [enum*Pango*.Gravity]

  * PANGO_GRAVITY_HINT_NATURAL: scripts will take their natural gravity based on the base gravity and the script. This is the default.

  * PANGO_GRAVITY_HINT_STRONG: always use the base gravity set, regardless of the script.

  * PANGO_GRAVITY_HINT_LINE: for scripts not in their natural direction (eg. Latin in East gravity), choose per-script gravity such that every script respects the line progression. This means, Latin and Arabic will take opposite gravities and both flow top-to-bottom for example.

