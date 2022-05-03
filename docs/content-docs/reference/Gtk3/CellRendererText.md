Gnome::Gtk3::CellRendererText
=============================

Renders text in a cell

Description
===========

A **Gnome::Gtk3::CellRendererText** renders a given text in its cell, using the font, color and style information provided by its properties. The text will be ellipsized if it is too long and the *ellipsize* property allows it.

If the *mode* is `GTK_CELL_RENDERER_MODE_EDITABLE`, the **Gnome::Gtk3::CellRendererText** allows to edit its text using an entry.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererText;
    also is Gnome::Gtk3::CellRenderer;

Uml Diagram
-----------

![](plantuml/CellRenderer-ea.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererText object.

    multi method new ( )

### :native-object

Create a CellRendererText object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererText object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

set-fixed-height-from-font
--------------------------

Sets the height of a renderer to explicitly be determined by the “font” and “y_pad” property set on it. Further changes in these properties do not affect the height, so they must be accompanied by a subsequent call to this function. Using this function is unflexible, and should really only be used if calculating the size of a cell is too slow (ie, a massive number of cells displayed). If *number_of_rows* is -1, then the fixed height is unset, and the height is determined by the properties again.

    method set-fixed-height-from-font ( Int() $number_of_rows )

  * $number_of_rows; Number of rows of text each cell renderer is allocated, or -1

Signals
=======

edited
------

This signal is emitted after *renderer* has been edited.

It is the responsibility of the application to update the model and store *new_text* at the position indicated by *path*.

    method handler (
      Str $path,
      Str $new_text,
      Gnome::Gtk3::CellRendererText :_widget($renderer),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path; the path identifying the edited cell

  * $new_text; the new text

  * $renderer; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

alignment
---------

How to align the lines

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_ALIGNMENT

  * Parameter is readable and writable.

  * Default value is PANGO_ALIGN_LEFT.

attributes
----------

A list of style attributes to apply to the text of the renderer

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * the type of this G_TYPE_BOXED object is PANGO_TYPE_ATTR_LIST

  * Parameter is readable and writable.

background
----------

Background color as a string

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is writable.

  * Default value is undefined.

background-rgba
---------------

Background color as a GdkRGBA

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * the type of this G_TYPE_BOXED object is GDK_TYPE_RGBA

  * Parameter is readable and writable.

editable
--------

Whether the text can be modified by the user

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

ellipsize
---------

The preferred place to ellipsize the string, if the cell renderer does not have enough room to display the entire string

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_ELLIPSIZE_MODE

  * Parameter is readable and writable.

  * Default value is PANGO_ELLIPSIZE_NONE.

family
------

Name of the font family, e.g. Sans_COMMA_ Helvetica_COMMA_ Times_COMMA_ Monospace

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

font
----

Font description as a string, e.g. \Sans Italic 12\

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

font-desc
---------

Font description as a PangoFontDescription struct

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * the type of this G_TYPE_BOXED object is PANGO_TYPE_FONT_DESCRIPTION

  * Parameter is readable and writable.

foreground
----------

Foreground color as a string

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is writable.

  * Default value is undefined.

foreground-rgba
---------------

Foreground color as a GdkRGBA

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * the type of this G_TYPE_BOXED object is GDK_TYPE_RGBA

  * Parameter is readable and writable.

language
--------

The language this text is in, as an ISO code. Pango can use this as a hint when rendering the text. If you don't understand this parameter_COMMA_ you probably don't need it

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

markup
------

Marked up text to render

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is writable.

  * Default value is undefined.

max-width-chars
---------------

The maximum width of the cell, in characters

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

placeholder-text
----------------

Text rendered when an editable cell is empty

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

rise
----

Offset of text above the baseline (below the baseline if rise is negative)

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -G_MAXINT.

  * Maximum value is G_MAXINT.

  * Default value is 0.

scale
-----

Font scaling factor

  * **Gnome::GObject::Value** type of this property is G_TYPE_DOUBLE

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is G_MAXDOUBLE.

  * Default value is 1.0.

single-paragraph-mode
---------------------

Whether to keep all text in a single paragraph

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

size
----

Font size

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXINT.

  * Default value is 0.

size-points
-----------

Font size in points

  * **Gnome::GObject::Value** type of this property is G_TYPE_DOUBLE

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is G_MAXDOUBLE.

  * Default value is 0.0.

stretch
-------

Font stretch

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_STRETCH

  * Parameter is readable and writable.

  * Default value is PANGO_STRETCH_NORMAL.

strikethrough
-------------

Whether to strike through the text

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

style
-----

Font style

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_STYLE

  * Parameter is readable and writable.

  * Default value is PANGO_STYLE_NORMAL.

text
----

Text to render

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

underline
---------

Style of underline for this text

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_UNDERLINE

  * Parameter is readable and writable.

  * Default value is PANGO_UNDERLINE_NONE.

variant
-------

Font variant

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_VARIANT

  * Parameter is readable and writable.

  * Default value is PANGO_VARIANT_NORMAL.

weight
------

Font weight

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXINT.

  * Default value is PANGO_WEIGHT_NORMAL.

width-chars
-----------

The desired width of the label, in characters

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

wrap-mode
---------

How to break the string into multiple lines, if the cell renderer does not have enough room to display the entire string

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * the type of this G_TYPE_ENUM object is PANGO_TYPE_WRAP_MODE

  * Parameter is readable and writable.

  * Default value is PANGO_WRAP_CHAR.

wrap-width
----------

The width at which the text is wrapped

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

