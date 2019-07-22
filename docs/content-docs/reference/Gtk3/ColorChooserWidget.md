TITLE
=====

Gnome::Gtk3::ColorChooserWidget

SUBTITLE
========

A widget for choosing colors

Description
===========

The `Gnome::Gtk3::ColorChooserWidget` widget lets the user select a color. By default, the chooser presents a predefined palette of colors, plus a small number of settable custom colors. It is also possible to select a different color with the single-color editor. To enter the single-color editing mode, use the context menu of any color of the palette, or use the '+' button to add a new custom color.

The chooser automatically remembers the last selection, as well as custom colors.

To change the initially selected color, use `gtk_color_chooser_set_rgba()`. To get the selected color use `gtk_color_chooser_get_rgba()`.

The `Gnome::Gtk3::ColorChooserWidget` is used in the `Gnome::Gtk3::ColorChooserDialog` to provide a dialog for selecting colors.

# CSS names

`Gnome::Gtk3::ColorChooserWidget` has a single CSS node with name colorchooser.

See Also
--------

`Gnome::Gtk3::ColorChooserDialog`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ColorChooserWidget;
    also is Gnome::Gtk3::Box;

Example
-------

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create a new object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_color_chooser_widget_new
----------------------------

Creates a new native `GtkColorChooserWidget`.

Returns: a new `Gnome::Gtk3::ColorChooserWidget`

Since: 3.4

    method gtk_color_chooser_widget_new ( --> N-GObject )

Properties
==========

An example of using a string type property of a `Gnome::Gtk3::Label` object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### show-editor

The `Gnome::GObject::Value` type of property *show-editor* is `G_TYPE_BOOLEAN`.

The ::show-editor property is `1` when the color chooser is showing the single-color editor. It can be set to switch the color chooser into single-color editing mode.

Since: 3.4

