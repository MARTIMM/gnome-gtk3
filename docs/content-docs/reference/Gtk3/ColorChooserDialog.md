Gnome::Gtk3::ColorChooserDialog
===============================

A dialog for choosing colors

![](images/colorchooser.png)

Description
===========

The **Gnome::Gtk3::ColorChooserDialog** widget is a dialog for choosing a color. It implements the **Gnome::Gtk3::ColorChooser** interface.

Since: 3.4

Implemented Interfaces
----------------------

Gnome::Gtk3::ColorChooserDialog implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * [Gnome::Gtk3::ColorChooser](ColorChooser.html)

See Also
--------

**Gnome::Gtk3::ColorChooser**, **Gnome::Gtk3::Dialog**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ColorChooserDialog;
    also is Gnome::Gtk3::Dialog;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::ColorChooser;

Example
-------

    my Gnome::Gtk3::ColorChooserDialog $dialog .= new(
      :title('my color dialog')
    );

Methods
=======

new
---

Create a new object with a title. The transient $parent-window which may be `Any`.

    multi method new ( Str :$title!, Gnome::GObject::Object :$parent-window )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( Gnome::GObject::Object :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] color_chooser_dialog_new
-------------------------------

Creates a new native `Gtk3ColorChooserDialog`.

Returns: a new **Gnome::Gtk3::ColorChooserDialog**

Since: 3.4

    method gtk_color_chooser_dialog_new (
      Str $title, N-GObject $parent
      --> N-GObject
    )

  * Str $title; (allow-none): Title of the dialog, or %NULL

  * N-GObject $parent; (allow-none): Transient parent of the dialog, or %NULL

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Show editor

Show editor Default value: False

The **Gnome::GObject::Value** type of property *show-editor* is `G_TYPE_BOOLEAN`.

