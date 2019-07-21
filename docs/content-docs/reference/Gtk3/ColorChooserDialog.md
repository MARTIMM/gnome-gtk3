TITLE
=====

Gnome::Gtk3::ColorChooserDialog

![](images/colorchooser.png)

SUBTITLE
========

A dialog for choosing colors

Description
===========

The `Gnome::Gtk3::ColorChooserDialog` widget is a dialog for choosing a color. It implements the `Gnome::Gtk3::ColorChooser` interface.

Since: 3.4

See Also
--------

`Gnome::Gtk3::ColorChooser`, `Gnome::Gtk3::Dialog`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ColorChooserDialog;
    also is Gnome::Gtk3::Dialog;

Example
-------

    my Gnome::Gtk3::ColorChooserDialog $dialog .= new(
      :title('my color dialog')
    );

Methods
=======

new
---

### multi method new ( Str :$title!, Gnome::GObject::Object :$parent-window )

Create a new object with a title. The transient $parent-window which may be `Any`.

### multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_color_chooser_dialog_new
----------------------------

Creates a new native `Gtk3ColorChooserDialog`.

Returns: a new `Gnome::Gtk3::ColorChooserDialog`

Since: 3.4

    method gtk_color_chooser_dialog_new (
      Str $title, N-GObject $parent
      --> N-GObject
    )

  * Str $title; (allow-none): Title of the dialog, or %NULL

  * N-GObject $parent; (allow-none): Transient parent of the dialog, or %NULL

