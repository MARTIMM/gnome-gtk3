TITLE
=====

Gnome::Gtk3::TextTagTable

SUBTITLE
========

Collection of tags that can be used together

Description
===========

You may wish to begin by reading the [text widget conceptual overview][TextWidget] which gives an overview of all the objects and data types related to the text widget and how they work together.

Gnome::Gtk3::TextTagTables as Gnome::Gtk3::Buildable
----------------------------------------------------

The `Gnome::Gtk3::TextTagTable` implementation of the `Gnome::Gtk3::Buildable` interface supports adding tags by specifying “tag” as the “type” attribute of a <child> element.

An example of a UI definition fragment specifying tags: <object class="GtkTextTagTable"> <child type="tag"> <object class="GtkTextTag"/> </child> </object>

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextTagTable;
    also is Gnome::GObject::Object;

Example
-------

gtk_text_tag_table_new
----------------------

Creates a new `Gnome::Gtk3::TextTagTable`. The table contains no tags by default.

Returns: a new `Gnome::Gtk3::TextTagTable`

    method gtk_text_tag_table_new ( --> N-GObject  )

gtk_text_tag_table_add
----------------------

Add a tag to the table. The tag is assigned the highest priority in the table.

*tag* must not be in a tag table already, and may not have the same name as an already-added tag.

Returns: `1` on success.

    method gtk_text_tag_table_add ( N-GObject $tag --> Int  )

  * N-GObject $tag; a `Gnome::Gtk3::TextTag`

gtk_text_tag_table_remove
-------------------------

Remove a tag from the table. If a `Gnome::Gtk3::TextBuffer` has *table* as its tag table, the tag is removed from the buffer. The table’s reference to the tag is removed, so the tag will end up destroyed if you don’t have a reference to it.

    method gtk_text_tag_table_remove ( N-GObject $tag )

  * N-GObject $tag; a `Gnome::Gtk3::TextTag`

gtk_text_tag_table_lookup
-------------------------

Look up a named tag.

Returns: (nullable) (transfer none): The tag, or `Any` if none by that name is in the table.

    method gtk_text_tag_table_lookup ( Str $name --> N-GObject  )

  * Str $name; name of a tag

[gtk_text_tag_table_] get_size
------------------------------

Returns the size of the table (number of tags)

Returns: number of tags in *table*

    method gtk_text_tag_table_get_size ( --> Int  )

Not yet implemented methods
===========================

method gtk_text_tag_table_foreach ( ... )
-----------------------------------------

Signals
=======

Register any signal as follows. See also `Gnome::GObject::Object`.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Supported signals
-----------------

### tag-added

    method handler (
      Gnome::GObject::Object :widget($texttagtable),
      :handler-arg0($tag),
      :$user-option1, ..., :$user-optionN
    );

  * $texttagtable; the object which received the signal.

  * $tag; the added tag.

### tag-removed

    method handler (
      Gnome::GObject::Object :widget($texttagtable),
      :handler-arg0($tag),
      :$user-option1, ..., :$user-optionN
    );

  * $texttagtable; the object which received the signal.

  * $tag; the removed tag.

Not yet supported signals
-------------------------

### tag-changed

    method handler (
      Gnome::GObject::Object :widget($texttagtable),
      :handler-arg0($tag),
      :handler-arg1($size_changed),
      :$user-option1, ..., :$user-optionN
    );

  * $texttagtable; the object which received the signal.

  * $tag; the changed tag.

  * $size_changed; whether the change affects the `Gnome::Gtk3::TextView` layout.

