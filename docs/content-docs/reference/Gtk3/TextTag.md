TITLE
=====

Gnome::Gtk3::TextTag

SUBTITLE
========

A tag that can be applied to text in a `Gnome::Gtk3::TextBuffer`

Description
===========

You may wish to begin by reading the [text widget conceptual overview][TextWidget] which gives an overview of all the objects and data types related to the text widget and how they work together.

Tags should be in the `Gnome::Gtk3::TextTagTable` for a given `Gnome::Gtk3::TextBuffer` before using them with that buffer.

`gtk_text_buffer_create_tag()` is the best way to create tags. See “gtk3-demo” for numerous examples.

For each property of `Gnome::Gtk3::TextTag`, there is a “set” property, e.g. “font-set” corresponds to “font”. These “set” properties reflect whether a property has been set or not. They are maintained by GTK+ and you should not set them independently.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextTag;
    also is Gnome::GObject::Object;

Example
-------

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( Str :$tag-name! )

Create a new tag object. Tag will have the given name.

### multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_text_tag_new
----------------

Creates a `Gnome::Gtk3::TextTag`. Configure the tag using object arguments, i.e. using `g_object_set()`.

Returns: a new `Gnome::Gtk3::TextTag`

    method gtk_text_tag_new ( Str $name --> N-GObject  )

  * Str $name; tag name, or `Any`

[gtk_text_tag_] get_priority
----------------------------

Get the tag priority.

Returns: The tag’s priority.

    method gtk_text_tag_get_priority ( --> Int  )

[gtk_text_tag_] set_priority
----------------------------

Sets the priority of a `Gnome::Gtk3::TextTag`. Valid priorities start at 0 and go to one less than `gtk_text_tag_table_get_size()`. Each tag in a table has a unique priority; setting the priority of one tag shifts the priorities of all the other tags in the table to maintain a unique priority for each tag. Higher priority tags “win” if two tags both set the same text attribute. When adding a tag to a tag table, it will be assigned the highest priority in the table by default; so normally the precedence of a set of tags is the order in which they were added to the table, or created with `gtk_text_buffer_create_tag()`, which adds the tag to the buffer’s table automatically.

    method gtk_text_tag_set_priority ( Int $priority )

  * Int $priority; the new priority

gtk_text_tag_event
------------------

Emits the “event” signal on the `Gnome::Gtk3::TextTag`.

Returns: result of signal emission (whether the event was handled)

    method gtk_text_tag_event ( N-GObject $event_object, GdkEvent $event, N-GObject $iter --> Int  )

  * N-GObject $event_object; object that received the event, such as a widget

  * GdkEvent $event; the event

  * N-GObject $iter; location where the event was received

gtk_text_tag_changed
--------------------

Emits the sig `tag-changed` signal on the `Gnome::Gtk3::TextTagTable` where the tag is included.

The signal is already emitted when setting a `Gnome::Gtk3::TextTag` property. This function is useful for a `Gnome::Gtk3::TextTag` subclass.

Since: 3.20

    method gtk_text_tag_changed ( Int $size_changed )

  * Int $size_changed; whether the change affects the `Gnome::Gtk3::TextView` layout.

Signals
=======

Register any signal as follows. See also `Gnome::GObject::Object`.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Not yet supported signals
-------------------------

### event

The sig *event* signal is emitted when an event occurs on a region of the buffer marked with this tag.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      Gnome::GObject::Object :widget($tag),
      :handler-arg0($object),
      :handler-arg1($event),
      :handler-arg2($iter),
      :$user-option1, ..., :$user-optionN
    );

  * $tag; the `Gnome::Gtk3::TextTag` on which the signal is emitted

  * $object; the object the event was fired from (typically a `Gnome::Gtk3::TextView`)

  * $event; the event which triggered the signal

  * $iter; a `Gnome::Gtk3::TextIter` pointing at the location the event occurred

Properties
==========

An example of using a string type property of a `Gnome::Gtk3::Label` object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Not yet supported properties
----------------------------

### background-rgba

The `Gnome::GObject::Value` type of property *background-rgba* is `G_TYPE_BOXED`.

Background color as a `Gnome::Gdk3::RGBA`.

Since: 3.2

### foreground-rgba

The `Gnome::GObject::Value` type of property *foreground-rgba* is `G_TYPE_BOXED`.

Foreground color as a `Gnome::Gdk3::RGBA`.

Since: 3.2

### font

The `Gnome::GObject::Value` type of property *font* is `G_TYPE_STRING`.

Font description as string, e.g. \"Sans Italic 12\".

Note that the initial value of this property depends on the internals of `PangoFontDescription`.

### language

The `Gnome::GObject::Value` type of property *language* is `G_TYPE_STRING`.

The language this text is in, as an ISO code. Pango can use this as a hint when rendering the text. If not set, an appropriate default will be used.

Note that the initial value of this property depends on the current locale, see also `gtk_get_default_language()`.

### underline-rgba

The `Gnome::GObject::Value` type of property *underline-rgba* is `G_TYPE_BOXED`.

This property modifies the color of underlines. If not set, underlines will use the forground color.

If prop `underline` is set to `PANGO_UNDERLINE_ERROR`, an alternate color may be applied instead of the foreground. Setting this property will always override those defaults.

Since: 3.16

### strikethrough-rgba

The `Gnome::GObject::Value` type of property *strikethrough-rgba* is `G_TYPE_BOXED`.

This property modifies the color of strikeouts. If not set, strikeouts will use the forground color.

Since: 3.16

### invisible

The `Gnome::GObject::Value` type of property *invisible* is `G_TYPE_BOOLEAN`.

Whether this text is hidden.

Note that there may still be problems with the support for invisible text, in particular when navigating programmatically inside a buffer containing invisible segments.

Since: 2.8

### paragraph-background

The `Gnome::GObject::Value` type of property *paragraph-background* is `G_TYPE_STRING`.

The paragraph background color as a string.

Since: 2.8

### paragraph-background-rgba

The `Gnome::GObject::Value` type of property *paragraph-background-rgba* is `G_TYPE_BOXED`.

The paragraph background color as a `Gnome::Gdk3::RGBA`.

Since: 3.2

### fallback

The `Gnome::GObject::Value` type of property *fallback* is `G_TYPE_BOOLEAN`.

Whether font fallback is enabled.

When set to `1`, other fonts will be substituted where the current font is missing glyphs.

Since: 3.16

### letter-spacing

The `Gnome::GObject::Value` type of property *letter-spacing* is `G_TYPE_INT`.

Extra spacing between graphemes, in Pango units.

Since: 3.16

### font-features

The `Gnome::GObject::Value` type of property *font-features* is `G_TYPE_STRING`.

OpenType font features, as a string.

Since: 3.18

### accumulative-margin

The `Gnome::GObject::Value` type of property *accumulative-margin* is `G_TYPE_BOOLEAN`.

Whether the margins accumulate or override each other.

When set to `1` the margins of this tag are added to the margins of any other non-accumulative margins present. When set to `0` the margins override one another (the default).

Since: 2.12

