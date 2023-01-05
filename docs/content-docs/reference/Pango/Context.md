Gnome::Pango::Context
=====================

Functions to run the rendering pipeline

Description
===========

A `PangoContext` stores global information used to control the itemization process.

The information stored by `PangoContext` includes the fontmap used to look up fonts, and default values such as the default language, default gravity, or default font.

To obtain a `PangoContext`, use `Gnome::Pango::Fontmap.create_context()`. This is equivalent to call `.new()` followed by `.set-font-map()`. For existing widgets, it is easier to use the `Gnome::Gtk3::Widget.get-pango-context` call, see the example below.

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::Context;
    also is Gnome::GObject::Object;

Example
-------

    my Gnome::Gtk3::Button $button .= new(:label<Stop>);
    my Gnome::Pango::Context() $context = $button.get-pango-context;

Methods
=======

new
---

### default, no options

Create a new Context object.

    multi method new ( )

### :native-object

Create a Context object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

changed
-------

Forces a change in the context, which will cause any `PangoLayout` using this context to re-layout.

This function is only useful when implementing a new backend for Pango, something applications won't do. Backends should call this function if they have attached extra data to the context and such data is changed.

    method changed ( )

get-base-dir
------------

Retrieves the base direction for the context.

See [method*Pango*.Context.set_base_dir].

Return value: the base direction for the context.

    method get-base-dir ( --> PangoDirection )

get-base-gravity
----------------

Retrieves the base gravity for the context.

See [method*Pango*.Context.set_base_gravity].

Return value: the base gravity for the context.

    method get-base-gravity ( --> N-GObject )

get-font-description
--------------------

Retrieve the default font description for the context.

Return value: : a pointer to the context's default font description. This value must not be modified or freed.

    method get-font-description ( --> N-GObject )

get-font-map
------------

Gets the `PangoFontMap` used to look up fonts for this context.

Return value: : the font map for the `PangoContext`. This value is owned by Pango and should not be unreferenced.

    method get-font-map ( --> N-GObject )

get-gravity
-----------

Retrieves the gravity for the context.

This is similar to [method*Pango*.Context.get_base_gravity], except for when the base gravity is `PANGO_GRAVITY_AUTO` for which [func*Pango*.Gravity.get_for_matrix] is used to return the gravity from the current context matrix.

Return value: the resolved gravity for the context.

    method get-gravity ( --> N-GObject )

get-gravity-hint
----------------

Retrieves the gravity hint for the context.

See [method*Pango*.Context.set_gravity_hint] for details.

Return value: the gravity hint for the context.

    method get-gravity-hint ( --> PangoGravityHint )

get-language
------------

Retrieves the global language tag for the context.

Return value: the global language tag.

    method get-language ( --> N-GObject )

get-matrix
----------

Gets the transformation matrix that will be applied when rendering with this context.

See [method*Pango*.Context.set_matrix].

Return value: : the matrix, or `undefined` if no matrix has been set (which is the same as the identity matrix). The returned matrix is owned by Pango and must not be modified or freed.

    method get-matrix ( --> N-GObject )

get-round-glyph-positions
-------------------------

Returns whether font rendering with this context should round glyph positions and widths.

    method get-round-glyph-positions ( --> Bool )

get-serial
----------

Returns the current serial number of *context*.

The serial number is initialized to an small number larger than zero when a new context is created and is increased whenever the context is changed using any of the setter functions, or the `PangoFontMap` it uses to find fonts has changed. The serial may wrap, but will never have the value 0. Since it can wrap, never compare it with "less than", always use "not equals".

This can be used to automatically detect changes to a `PangoContext`, and is only useful when implementing objects that need update when their `PangoContext` changes, like `PangoLayout`.

Return value: The current serial number of *context*.

.4

    method get-serial ( --> UInt )

load-font
---------

Loads the font in one of the fontmaps in the context that is the closest match for *desc*.

Returns: the newly allocated `PangoFont` that was loaded, or `undefined` if no font matched.

    method load-font ( N-GObject() $desc --> N-GObject )

  * $desc; a `PangoFontDescription` describing the font to load

load-fontset
------------

Load a set of fonts in the context that can be used to render a font matching *desc*.

Returns: the newly allocated `PangoFontset` loaded, or `undefined` if no font matched.

    method load-fontset ( N-GObject() $desc, N-GObject() $language --> N-GObject )

  * $desc; a `PangoFontDescription` describing the fonts to load

  * $language; a `PangoLanguage` the fonts will be used for

set-base-dir
------------

Sets the base direction for the context.

The base direction is used in applying the Unicode bidirectional algorithm; if the *direction* is `PANGO_DIRECTION_LTR` or `PANGO_DIRECTION_RTL`, then the value will be used as the paragraph direction in the Unicode bidirectional algorithm. A value of `PANGO_DIRECTION_WEAK_LTR` or `PANGO_DIRECTION_WEAK_RTL` is used only for paragraphs that do not contain any strong characters themselves.

    method set-base-dir ( PangoDirection $direction )

  * $direction; the new base direction

set-base-gravity
----------------

Sets the base gravity for the context.

The base gravity is used in laying vertical text out.

    method set-base-gravity ( N-GObject() $gravity )

  * $gravity; the new base gravity

set-font-description
--------------------

Set the default font description for the context

    method set-font-description ( N-GObject() $desc )

  * $desc; the new pango font description

set-font-map
------------

Sets the font map to be searched when fonts are looked-up in this context.

This is only for internal use by Pango backends, a `PangoContext` obtained via one of the recommended methods should already have a suitable font map.

    method set-font-map ( N-GObject() $font_map )

  * $font_map; the `PangoFontMap` to set.

set-gravity-hint
----------------

Sets the gravity hint for the context.

The gravity hint is used in laying vertical text out, and is only relevant if gravity of the context as returned by [method*Pango*.Context.get_gravity] is set to `PANGO_GRAVITY_EAST` or `PANGO_GRAVITY_WEST`.

    method set-gravity-hint ( PangoGravityHint $hint )

  * $hint; the new gravity hint

set-language
------------

Sets the global language tag for the context.

The default language for the locale of the running process can be found using [func*Pango*.Language.get_default].

    method set-language ( N-GObject() $language )

  * $language; the new language tag.

set-matrix
----------

Sets the transformation matrix that will be applied when rendering with this context.

Note that reported metrics are in the user space coordinates before the application of the matrix, not device-space coordinates after the application of the matrix. So, they don't scale with the matrix, though they may change slightly for different matrices, depending on how the text is fit to the pixel grid.

    method set-matrix ( N-GObject() $matrix )

  * $matrix; a `PangoMatrix`, or `undefined` to unset any existing matrix. (No matrix set is the same as setting the identity matrix.)

set-round-glyph-positions
-------------------------

Sets whether font rendering with this context should round glyph positions and widths to integral positions, in device units.

This is useful when the renderer can't handle subpixel positioning of glyphs.

The default value is to round glyph positions, to remain compatible with previous Pango behavior.

    method set-round-glyph-positions ( Bool $round_positions )

  * $round_positions; whether to round glyph positions

