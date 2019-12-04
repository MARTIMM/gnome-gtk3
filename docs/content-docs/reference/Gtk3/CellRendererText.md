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

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] cell_renderer_text_new
-----------------------------

Creates a new **Gnome::Gtk3::CellRendererText**. Adjust how text is drawn using object properties. Object properties can be set globally (with `g_object_set()`). Also, with **Gnome::Gtk3::TreeViewColumn**, you can bind a property to a value in a **Gnome::Gtk3::TreeModel**. For example, you can bind the “text” property on the cell renderer to a string value in the model, thus rendering a different string in each row of the **Gnome::Gtk3::TreeView**

Returns: the new cell renderer

    method gtk_cell_renderer_text_new ( --> N-GObject  )

[[gtk_] cell_renderer_text_] set_fixed_height_from_font
-------------------------------------------------------

Sets the height of a renderer to explicitly be determined by the “font” and “y_pad” property set on it. Further changes in these properties do not affect the height, so they must be accompanied by a subsequent call to this function. Using this function is unflexible, and should really only be used if calculating the size of a cell is too slow (ie, a massive number of cells displayed). If *number_of_rows* is -1, then the fixed height is unset, and the height is determined by the properties again.

    method gtk_cell_renderer_text_set_fixed_height_from_font ( Int $number_of_rows )

  * Int $number_of_rows; Number of rows of text each cell renderer is allocated, or -1

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### edited

This signal is emitted after *renderer* has been edited.

It is the responsibility of the application to update the model and store *new_text* at the position indicated by *path*.

    method handler (
      Str $path,
      Str $new_text,
      Gnome::GObject::Object :widget($renderer),
      *%user-options
    );

  * $renderer; the object which received the signal

  * $path; the path identifying the edited cell

  * $new_text; the new text

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Text

Text to render Default value: Any

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### Markup

Marked up text to render Default value: Any

The **Gnome::GObject::Value** type of property *markup* is `G_TYPE_STRING`.

### Attributes

The **Gnome::GObject::Value** type of property *attributes* is `G_TYPE_BOXED`.

### Single Paragraph Mode

Whether to keep all text in a single paragraph Default value: False

The **Gnome::GObject::Value** type of property *single-paragraph-mode* is `G_TYPE_BOOLEAN`.

### Background color name

Background color as a string Default value: Any

The **Gnome::GObject::Value** type of property *background* is `G_TYPE_STRING` and is write only.

### Foreground color name

Foreground color as a string Default value: Any

The **Gnome::GObject::Value** type of property *foreground* is `G_TYPE_STRING`.

### Editable

Whether the text can be modified by the user Default value: False

The **Gnome::GObject::Value** type of property *editable* is `G_TYPE_BOOLEAN`.

### Font

Font description as a string, e.g. \Sans Italic 12\ Default value: Any

The **Gnome::GObject::Value** type of property *font* is `G_TYPE_STRING`.

### Font

The **Gnome::GObject::Value** type of property *font-desc* is `G_TYPE_BOXED`.

### Font family

Name of the font family, e.g. Sans_COMMA_ Helvetica_COMMA_ Times_COMMA_ Monospace Default value: Any

The **Gnome::GObject::Value** type of property *family* is `G_TYPE_STRING`.

### Font style

Font style Default value: False

The **Gnome::GObject::Value** type of property *style* is `G_TYPE_ENUM`.

### Font variant

Font variant Default value: False

The **Gnome::GObject::Value** type of property *variant* is `G_TYPE_ENUM`.

### Font weight

The **Gnome::GObject::Value** type of property *weight* is `G_TYPE_INT`.

### Font stretch

Font stretch Default value: False

The **Gnome::GObject::Value** type of property *stretch* is `G_TYPE_ENUM`.

### Font size

The **Gnome::GObject::Value** type of property *size* is `G_TYPE_INT`.

### Font points

The **Gnome::GObject::Value** type of property *size-points* is `G_TYPE_DOUBLE`.

### Font scale

The **Gnome::GObject::Value** type of property *scale* is `G_TYPE_DOUBLE`.

### Rise

The **Gnome::GObject::Value** type of property *rise* is `G_TYPE_INT`.

### Strikethrough

Whether to strike through the text Default value: False

The **Gnome::GObject::Value** type of property *strikethrough* is `G_TYPE_BOOLEAN`.

### Underline

Style of underline for this text Default value: False

The **Gnome::GObject::Value** type of property *underline* is `G_TYPE_ENUM`.

### Language

The language this text is in, as an ISO code. Pango can use this as a hint when rendering the text. If you don't understand this parameter_COMMA_ you probably don't need it Default value: Any

The **Gnome::GObject::Value** type of property *language* is `G_TYPE_STRING`.

### Ellipsize

Specifies the preferred place to ellipsize the string, if the cell renderer does not have enough room to display the entire string. Setting it to `PANGO_ELLIPSIZE_NONE` turns off ellipsizing. See the wrap-width property for another way of making the text fit into a given width. Since: 2.6 Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The **Gnome::GObject::Value** type of property *ellipsize* is `G_TYPE_ENUM`.

### Width In Characters

The desired width of the cell, in characters. If this property is set to -1, the width will be calculated automatically, otherwise the cell will request either 3 characters or the property value, whichever is greater. Since: 2.6

The **Gnome::GObject::Value** type of property *width-chars* is `G_TYPE_INT`.

### Maximum Width In Characters

The desired maximum width of the cell, in characters. If this property is set to -1, the width will be calculated automatically. For cell renderers that ellipsize or wrap text; this property controls the maximum reported width of the cell. The cell should not receive any greater allocation unless it is set to expand in its **Gnome::Gtk3::CellLayout** and all of the cell's siblings have received their natural width. Since: 3.0

The **Gnome::GObject::Value** type of property *max-width-chars* is `G_TYPE_INT`.

### Wrap mode

Specifies how to break the string into multiple lines, if the cell renderer does not have enough room to display the entire string. This property has no effect unless the wrap-width property is set. Since: 2.8 Widget type: PANGO_TYPE_WRAP_MODE

The **Gnome::GObject::Value** type of property *wrap-mode* is `G_TYPE_ENUM`.

### Wrap width

Specifies the minimum width at which the text is wrapped. The wrap-mode property can be used to influence at what character positions the line breaks can be placed. Setting wrap-width to -1 turns wrapping off. Since: 2.8

The **Gnome::GObject::Value** type of property *wrap-width* is `G_TYPE_INT`.

### Alignment

Specifies how to align the lines of text with respect to each other. Note that this property describes how to align the lines of text in case there are several of them. The "xalign" property of **Gnome::Gtk3::CellRenderer**, on the other hand, sets the horizontal alignment of the whole text. Since: 2.10 Widget type: PANGO_TYPE_ALIGNMENT

The **Gnome::GObject::Value** type of property *alignment* is `G_TYPE_ENUM`.

### Placeholder text

The text that will be displayed in the **Gnome::Gtk3::CellRenderer** if *editable* is `1` and the cell is empty. Since 3.6

The **Gnome::GObject::Value** type of property *placeholder-text* is `G_TYPE_STRING`.

### nick

The **Gnome::GObject::Value** type of property *text_cell_renderer_props[propval] = g_param_spec_boolean (propname* is `G_TYPE_`.

