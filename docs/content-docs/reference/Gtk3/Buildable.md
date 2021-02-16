Gnome::Gtk3::Buildable
======================

Interface for objects that can be built by **Gnome::Gtk3::Builder**

Description
===========

**Gnome::Gtk3::Buildable** allows objects to extend and customize their deserialization from **Gnome::Gtk3::Builder** UI descriptions. The interface includes methods for setting names and properties of objects, parsing custom tags and constructing child objects.

The **Gnome::Gtk3::Buildable** interface is implemented by all widgets and many of the non-widget objects that are provided by GTK+. The main user of this interface is **Gnome::Gtk3::Builder**. There should be very little need for applications to call any of these functions directly.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Buildable;

Methods
=======

buildable-get-name
------------------

Gets the name of the *buildable* object.

**Gnome::Gtk3::Builder** sets the name based on the **Gnome::Gtk3::Builder** UI definition used to construct the *buildable*.

Returns: the name set with `buildable-set-name()`

    method buildable-get-name ( --> Str )

buildable-set-name
------------------

Sets the name of the *buildable* object.

    method buildable-set-name ( Str $name )

  * Str $name; name to set

