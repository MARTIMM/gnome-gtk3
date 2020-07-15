Gnome::Gtk3::TextTag
====================

A tag that can be applied to text in a Gnome::Gtk3::TextBuffer

Description
===========

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Tags should be in the **Gnome::Gtk3::TextTagTable** for a given **Gnome::Gtk3::TextBuffer** before using them with that buffer.

`gtk_text_buffer_create_tag()` is the best way to create tags. See “gtk3-demo” for numerous examples.

For each property of **Gnome::Gtk3::TextTag**, there is a “set” property, e.g. “font-set” corresponds to “font”. These “set” properties reflect whether a property has been set or not. They are maintained by GTK+ and you should not set them independently.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextTag;
    also is Gnome::GObject::Object;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :$empty! )

Create a new tag object. Tag will have the given name.

    multi method new ( Str :$tag-name! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] text_tag_new
-------------------

Creates a **Gnome::Gtk3::TextTag**. Configure the tag using object arguments, i.e. using `g_object_set()`.

Returns: a new **Gnome::Gtk3::TextTag**

    method gtk_text_tag_new ( Str $name --> N-GObject  )

  * Str $name; tag name, or `Any`

[[gtk_] text_tag_] get_priority
-------------------------------

Get the tag priority.

Returns: The tag’s priority.

    method gtk_text_tag_get_priority ( --> Int  )

[[gtk_] text_tag_] set_priority
-------------------------------

Sets the priority of a **Gnome::Gtk3::TextTag**. Valid priorities start at 0 and go to one less than `gtk_text_tag_table_get_size()`. Each tag in a table has a unique priority; setting the priority of one tag shifts the priorities of all the other tags in the table to maintain a unique priority for each tag. Higher priority tags “win” if two tags both set the same text attribute. When adding a tag to a tag table, it will be assigned the highest priority in the table by default; so normally the precedence of a set of tags is the order in which they were added to the table, or created with `gtk_text_buffer_create_tag()`, which adds the tag to the buffer’s table automatically.

    method gtk_text_tag_set_priority ( Int $priority )

  * Int $priority; the new priority

[gtk_] text_tag_event
---------------------

Emits the “event” signal on the **Gnome::Gtk3::TextTag**.

Returns: result of signal emission (whether the event was handled)

    method gtk_text_tag_event (
      N-GObject $event_object, GdkEvent $event, N-GObject $iter
      --> Int
    )

  * N-GObject $event_object; object that received the event, such as a widget

  * GdkEvent $event; the event

  * N-GObject $iter; location where the event was received

[gtk_] text_tag_changed
-----------------------

Emits the *tag-changed* signal on the **Gnome::Gtk3::TextTagTable** where the tag is included.

The signal is already emitted when setting a **Gnome::Gtk3::TextTag** property. This function is useful for a **Gnome::Gtk3::TextTag** subclass.

Since: 3.20

    method gtk_text_tag_changed ( Int $size_changed )

  * Int $size_changed; whether the change affects the **Gnome::Gtk3::TextView** layout.

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

### event

The *event* signal is emitted when an event occurs on a region of the buffer marked with this tag.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      N-GObject $object,
      GdkEvent $event,
      N-GObject $iter,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($tag),
      *%user-options
      --> Int
    );

  * $tag; the **Gnome::Gtk3::TextTag** on which the signal is emitted

  * $object; the object the event was fired from (typically a native Gnome::Gtk3::TextView)

  * $event; the event which triggered the signal

  * $iter; a native Gnome::Gtk3::TextIter pointing at the location the event occurred

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Tag name

Name used to refer to the text tag. NULL for anonymous tags Default value: Any

The **Gnome::GObject::Value** type of property *name* is `G_TYPE_STRING`.

### Background color name

Background color as a string Default value: Any

The **Gnome::GObject::Value** type of property *background* is `G_TYPE_STRING`.

### Background RGBA

Background color as a **Gnome::Gdk3::RGBA**. Since: 3.2

The **Gnome::GObject::Value** type of property *background-rgba* is `G_TYPE_BOXED`.

### Background full height

Whether the background color fills the entire line height or only the height of the tagged characters Default value: False

The **Gnome::GObject::Value** type of property *background-full-height* is `G_TYPE_BOOLEAN`.

### Foreground color name

Foreground color as a string Default value: Any

The **Gnome::GObject::Value** type of property *foreground* is `G_TYPE_STRING`.

### Foreground RGBA

Foreground color as a **Gnome::Gdk3::RGBA**. Since: 3.2

The **Gnome::GObject::Value** type of property *foreground-rgba* is `G_TYPE_BOXED`.

### Text direction

Text direction, e.g. right-to-left or left-to-right Default value: False

The **Gnome::GObject::Value** type of property *direction* is `G_TYPE_ENUM`.

### Editable

Whether the text can be modified by the user Default value: True

The **Gnome::GObject::Value** type of property *editable* is `G_TYPE_BOOLEAN`.

### Font

Font description as string, e.g. \"Sans Italic 12\". Note that the initial value of this property depends on the internals of **PangoFontDescription**.

The **Gnome::GObject::Value** type of property *font* is `G_TYPE_STRING`.

### Font family

Name of the font family, e.g. Sans_COMMA_ Helvetica_COMMA_ Times_COMMA_ Monospace Default value: Any

The **Gnome::GObject::Value** type of property *family* is `G_TYPE_STRING`.

### Font style

Font style as a PangoStyle, e.g. PANGO_STYLE_ITALIC Default value: False

The **Gnome::GObject::Value** type of property *style* is `G_TYPE_ENUM`.

### Font variant

Font variant as a PangoVariant, e.g. PANGO_VARIANT_SMALL_CAPS Default value: False

The **Gnome::GObject::Value** type of property *variant* is `G_TYPE_ENUM`.

### Font weight

The **Gnome::GObject::Value** type of property *weight* is `G_TYPE_INT`.

### Font stretch

Font stretch as a PangoStretch, e.g. PANGO_STRETCH_CONDENSED Default value: False

The **Gnome::GObject::Value** type of property *stretch* is `G_TYPE_ENUM`.

### Font size

The **Gnome::GObject::Value** type of property *size* is `G_TYPE_INT`.

### Font scale

The **Gnome::GObject::Value** type of property *scale* is `G_TYPE_DOUBLE`.

### Font points

The **Gnome::GObject::Value** type of property *size-points* is `G_TYPE_DOUBLE`.

### Justification

Left, right_COMMA_ or center justification Default value: False

The **Gnome::GObject::Value** type of property *justification* is `G_TYPE_ENUM`.

### Language

The language this text is in, as an ISO code. Pango can use this as a hint when rendering the text. If not set, an appropriate default will be used. Note that the initial value of this property depends on the current locale, see also `gtk_get_default_language()`.

The **Gnome::GObject::Value** type of property *language* is `G_TYPE_STRING`.

### Left margin

The **Gnome::GObject::Value** type of property *left-margin* is `G_TYPE_INT`.

### Right margin

The **Gnome::GObject::Value** type of property *right-margin* is `G_TYPE_INT`.

### Indent

The **Gnome::GObject::Value** type of property *indent* is `G_TYPE_INT`.

### Rise

The **Gnome::GObject::Value** type of property *rise* is `G_TYPE_INT`.

### Pixels above lines

The **Gnome::GObject::Value** type of property *pixels-above-lines* is `G_TYPE_INT`.

### Pixels below lines

The **Gnome::GObject::Value** type of property *pixels-below-lines* is `G_TYPE_INT`.

### Pixels inside wrap

The **Gnome::GObject::Value** type of property *pixels-inside-wrap* is `G_TYPE_INT`.

### Strikethrough

Whether to strike through the text Default value: False

The **Gnome::GObject::Value** type of property *strikethrough* is `G_TYPE_BOOLEAN`.

### Underline

Style of underline for this text Default value: False

The **Gnome::GObject::Value** type of property *underline* is `G_TYPE_ENUM`.

### Wrap mode

Whether to wrap lines never, at word boundaries_COMMA_ or at character boundaries. Default value: False

The **Gnome::GObject::Value** type of property *wrap-mode* is `G_TYPE_ENUM`.

### Invisible

Whether this text is hidden. Note that there may still be problems with the support for invisible text, in particular when navigating programmatically inside a buffer containing invisible segments.

Since: 2.8

The **Gnome::GObject::Value** type of property *invisible* is `G_TYPE_BOOLEAN`.

### Paragraph background color name

The paragraph background color as a string. Since: 2.8

The **Gnome::GObject::Value** type of property *paragraph-background* is `G_TYPE_STRING`.

### Fallback

Whether font fallback is enabled. When set to `1`, other fonts will be substituted where the current font is missing glyphs.

Since: 3.16

The **Gnome::GObject::Value** type of property *fallback* is `G_TYPE_BOOLEAN`.

### Letter Spacing

Extra spacing between graphemes, in Pango units. Since: 3.16

The **Gnome::GObject::Value** type of property *letter-spacing* is `G_TYPE_INT`.

### Font Features

OpenType font features, as a string. Since: 3.18

The **Gnome::GObject::Value** type of property *font-features* is `G_TYPE_STRING`.

### Margin Accumulates

Whether the margins accumulate or override each other. When set to `1` the margins of this tag are added to the margins of any other non-accumulative margins present. When set to `0` the margins override one another (the default). Since: 2.12

The **Gnome::GObject::Value** type of property *accumulative-margin* is `G_TYPE_BOOLEAN`.

### propval

The **Gnome::GObject::Value** type of property *g_object_class_install_property (object_class* is `G_TYPE_`.

