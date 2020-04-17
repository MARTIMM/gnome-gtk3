Gnome::Gtk3::Separator
======================

A separator widget

![](images/separator.png)

Description
===========

**Gnome::Gtk3::Separator** is a horizontal or vertical separator widget, depending on the value of the *orientation* property, used to group the widgets within a window. It displays a line with a shadow to make it appear sunken into the interface.

Css Nodes
---------

**Gnome::Gtk3::Separator** has a single CSS node with name separator. The node gets one of the .horizontal or .vertical style classes.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Separator;
    also is Gnome::Gtk3::Widget;

Methods
=======

new
---

Create a new Separator object.

    multi method new ( GtkOrientation :$orientation! )

Create a Separator object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a Separator object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

