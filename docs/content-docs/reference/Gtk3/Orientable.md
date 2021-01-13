Gnome::Gtk3::Orientable
=======================

An interface for flippable widgets

Description
===========

The **Gnome::Gtk3::Orientable** interface is implemented by all widgets that can be oriented horizontally or vertically. Historically, such widgets have been realized as subclasses of a common base class (e.g **HBox**/**VBox** or **HScale**/**VScale**). **Gnome::Gtk3::Orientable** is more flexible in that it allows the orientation to be changed at runtime, allowing the widgets to “flip”.

Note that **HBox**/**VBox** or **HScale**/**VScale** are not implemented in this Raku package because these classes are deprecated.

**Gnome::Gtk3::Orientable** was introduced in GTK+ 2.16.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Orientable;

Example
-------

    my Gnome::Gtk3::LevelBar $level-bar .= new;
    $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

Methods
=======

set-orientation
---------------

    method set-orientation ( GtkOrientation $orientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

get-orientation
---------------

    method get-orientation ( --> GtkOrientation )

Retrieves the orientation of the *orientable*.

