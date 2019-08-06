TITLE
=====

Gnome::Gtk3::StyleProvider

SUBTITLE
========

Interface to provide style information to `Gnome::Gtk3::StyleContext`

Description
===========

`Gnome::Gtk3::StyleProvider` is an interface used to provide style information to a `Gnome::Gtk3::StyleContext`. See `gtk_style_context_add_provider()` and `gtk_style_context_add_provider_for_screen()`.

See Also
--------

`Gnome::Gtk3::StyleContext`, `Gnome::Gtk3::CssProvider`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::StyleProvider;
    also is Gnome::GObject::Interface;

Example
-------

Methods
=======

new
---

### multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

List of deprecated (not implemented!) methods
=============================================

Since 3.8
---------

### method gtk_style_provider_get_style ( ... )

### method gtk_style_provider_get_icon_factory ( ... )

