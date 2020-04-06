Gnome::Gtk3::TextTagTable
=========================

Collection
==========

of tags that can be used together

Description
===========

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Gnome::Gtk3::TextTagTables as Gnome::Gtk3::Buildable
----------------------------------------------------

The **Gnome::Gtk3::TextTagTable** implementation of the **Gnome::Gtk3::Buildable** interface supports adding tags by specifying “tag” as the “type” attribute of a <child> element.

An example of a UI definition fragment specifying tags:

    <object class="GtkTextTagTable">
      <child type="tag">
        <object class="GtkTextTag"/>
      </child>
    </object>

Implemented Interfaces
----------------------

Gnome::Gtk3::TextTagTable implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextTagTable;
    also is Gnome::GObject::Object;
    also does Gnome::Gtk3::Buildable;

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] text_tag_table_new
-------------------------

Creates a new **Gnome::Gtk3::TextTagTable**. The table contains no tags by default.

Returns: a new **Gnome::Gtk3::TextTagTable**

    method gtk_text_tag_table_new ( --> N-GObject  )

[gtk_] text_tag_table_add
-------------------------

Add a tag to the table. The tag is assigned the highest priority in the table.

*tag* must not be in a tag table already, and may not have the same name as an already-added tag.

Returns: `1` on success.

    method gtk_text_tag_table_add ( N-GObject $tag --> Int  )

  * N-GObject $tag; a **Gnome::Gtk3::TextTag**

[gtk_] text_tag_table_remove
----------------------------

Remove a tag from the table. If a **Gnome::Gtk3::TextBuffer** has *table* as its tag table, the tag is removed from the buffer. The table’s reference to the tag is removed, so the tag will end up destroyed if you don’t have a reference to it.

    method gtk_text_tag_table_remove ( N-GObject $tag )

  * N-GObject $tag; a **Gnome::Gtk3::TextTag**

[gtk_] text_tag_table_lookup
----------------------------

Look up a named tag.

Returns: (nullable) (transfer none): The tag, or `Any` if none by that name is in the table.

    method gtk_text_tag_table_lookup ( Str $name --> N-GObject  )

  * Str $name; name of a tag

[gtk_] text_tag_table_foreach
-----------------------------

Calls a function on each tag in this table, with named arguments in %user-data. Note that the table may not be modified while iterating over it (you can’t add/remove tags).

    method gtk_text_tag_table_foreach (
      $callback-object, Str $callback_name, *%user-options
    )

  * $callback-object; Object wherein the callback method is declared

  * Str $callback-name; Name of the callback method

  * %user-options; named arguments which will be provided to the callback

The callback method signature is

    method f ( Gnome::Gtk3::TextTag $tag, *%user-options )

[[gtk_] text_tag_table_] get_size
---------------------------------

Returns the size of the table (number of tags)

Returns: number of tags in *table*

    method gtk_text_tag_table_get_size ( --> Int  )

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

### tag-changed

    method handler (
      N-GObject $tag,
      Int $size_changed,
      Gnome::GObject::Object :widget($texttagtable),
      *%user-options
    );

  * $texttagtable; the object which received the signal.

  * $tag; the changed tag, a native **Gnome::Gtk3::TextTag**.

  * $size_changed; whether the change affects the **Gnome::Gtk3::TextView** layout.

### tag-added

    method handler (
      N-GObject $tag,
      Gnome::GObject::Object :widget($texttagtable),
      *%user-options
    );

  * $texttagtable; the object which received the signal.

  * $tag; the added tag, a native **Gnome::Gtk3::TextTag**.

### tag-removed

    method handler (
      N-GObject $tag,
      Gnome::GObject::Object :widget($texttagtable),
      *%user-options
    );

  * $texttagtable; the object which received the signal.

  * $tag; the removed tag, a native **Gnome::Gtk3::TextTag**.

