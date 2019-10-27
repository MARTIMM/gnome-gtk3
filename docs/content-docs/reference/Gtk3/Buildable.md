Gnome::Gtk3::Buildable
======================

Interface for objects that can be built by **Gnome::Gtk3::Builder**

Description
===========

**Gnome::Gtk3::Buildable** allows objects to extend and customize their deserialization from **Gnome::Gtk3::Builder** UI descriptions. The interface includes methods for setting names and properties of objects, parsing custom tags and constructing child objects.

The **Gnome::Gtk3::Buildable** interface is implemented by all widgets and many of the non-widget objects that are provided by GTK+. The main user of this interface is **Gnome::Gtk3::Builder**. There should be very little need for applications to call any of these functions directly. An object only needs to implement this interface if it needs to extend the **Gnome::Gtk3::Builder** format or run any extra routines at deserialization time.

Known implementations
---------------------

As stated above Gnome::Gtk3::Buildable is implemented by all widgets and many of the non-widget objects that are provided by GTK+.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Buildable;

Methods
=======

[gtk_buildable_] set_name
-------------------------

Sets the name of the *buildable* object.

Since: 2.12

    method gtk_buildable_set_name ( Str $name )

  * Str $name; name to set

[gtk_buildable_] get_name
-------------------------

Gets the name of the *buildable* object.

**Gnome::Gtk3::Builder** sets the name based on the [**Gnome::Gtk3::Builder** UI definition][BUILDER-UI] used to construct the *buildable*.

Returns: the name set with `gtk_buildable_set_name()`

Since: 2.12

    method gtk_buildable_get_name ( --> Str  )

[gtk_buildable_] add_child
--------------------------

Adds a child to *buildable*. *type* is an optional string describing how the child should be added.

Since: 2.12

    method gtk_buildable_add_child ( N-GObject $builder, N-GObject $child, Str $type )

  * N-GObject $builder; a **Gnome::Gtk3::Builder**

  * N-GObject $child; child to add

  * Str $type; (allow-none): kind of child or `Any`

[gtk_buildable_] set_buildable_property
---------------------------------------

Sets the property name *name* to *value* on the *buildable* object.

Since: 2.12

    method gtk_buildable_set_buildable_property ( N-GObject $builder, Str $name, N-GObject $value )

  * N-GObject $builder; a **Gnome::Gtk3::Builder**

  * Str $name; name of property

  * N-GObject $value; value of property

[gtk_buildable_] construct_child
--------------------------------

Constructs a child of *buildable* with the name *name*.

**Gnome::Gtk3::Builder** calls this function if a “constructor” has been specified in the UI definition.

Returns: (transfer full): the constructed child

Since: 2.12

    method gtk_buildable_construct_child ( N-GObject $builder, Str $name --> N-GObject  )

  * N-GObject $builder; **Gnome::Gtk3::Builder** used to construct this object

  * Str $name; name of child to construct

[gtk_buildable_] custom_tag_end
-------------------------------

This is called at the end of each custom element handled by the buildable.

Since: 2.12

    method gtk_buildable_custom_tag_end ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

  * N-GObject $builder; **Gnome::Gtk3::Builder** used to construct this object

  * N-GObject $child; (allow-none): child object or `Any` for non-child tags

  * Str $tagname; name of tag

  * Pointer $data; (type gpointer): user data that will be passed in to parser functions

[gtk_buildable_] custom_finished
--------------------------------

This is similar to `gtk_buildable_parser_finished()` but is called once for each custom tag handled by the *buildable*.

Since: 2.12

    method gtk_buildable_custom_finished ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

  * N-GObject $builder; a **Gnome::Gtk3::Builder**

  * N-GObject $child; (allow-none): child object or `Any` for non-child tags

  * Str $tagname; the name of the tag

  * Pointer $data; user data created in custom_tag_start

[gtk_buildable_] parser_finished
--------------------------------

Called when the builder finishes the parsing of a [**Gnome::Gtk3::Builder** UI definition][BUILDER-UI]. Note that this will be called once for each time `gtk_builder_add_from_file()` or `gtk_builder_add_from_string()` is called on a builder.

Since: 2.12

    method gtk_buildable_parser_finished ( N-GObject $builder )

  * N-GObject $builder; a **Gnome::Gtk3::Builder**

[gtk_buildable_] get_internal_child
-----------------------------------

Get the internal child called *childname* of the *buildable* object.

Returns: (transfer none): the internal child of the buildable object

Since: 2.12

    method gtk_buildable_get_internal_child ( N-GObject $builder, Str $childname --> N-GObject  )

  * N-GObject $builder; a **Gnome::Gtk3::Builder**

  * Str $childname; name of child

