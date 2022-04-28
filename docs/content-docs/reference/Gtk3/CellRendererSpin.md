Gnome::Gtk3::CellRendererSpin
=============================

Renders a spin button in a cell

Description
===========

**Gnome::Gtk3::CellRendererSpin** renders text in a cell like **Gnome::Gtk3::CellRendererText** from which it is derived. But while **Gnome::Gtk3::CellRendererText** offers a simple entry to edit the text, **Gnome::Gtk3::CellRendererSpin** offers a **Gnome::Gtk3::SpinButton** widget. Of course, that means that the text has to be parseable as a floating point number.

The range of the spinbutton is taken from the *adjustment* property of the cell renderer, which can be set explicitly or mapped to a column in the tree model, like all properties of cell renders. **Gnome::Gtk3::CellRendererSpin** also has properties for the *climb-rate* and the number of *digits* to display. Other **Gnome::Gtk3::SpinButton** properties can be set in a handler for the *editing-started* signal.

The **Gnome::Gtk3::CellRendererSpin** cell renderer was added in GTK+ 2.10.

See Also
--------

**Gnome::Gtk3::CellRendererText**, **Gnome::Gtk3::SpinButton**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererSpin;
    also is Gnome::Gtk3::CellRendererText;

Uml Diagram
-----------

![](plantuml/CellRendererea.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererSpin object.

    multi method new ( )

### :native-object

Create a CellRendererSpin object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererSpin object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Properties
==========

adjustment
----------

The adjustment that holds the value of the spin button

The **Gnome::GObject::Value** type of property *adjustment* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

climb-rate
----------

The acceleration rate when you hold down a button

The **Gnome::GObject::Value** type of property *climb-rate* is `G_TYPE_DOUBLE`.

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is G_MAXDOUBLE.

  * Default value is 0.0.

digits
------

The number of decimal places to display

The **Gnome::GObject::Value** type of property *digits* is `G_TYPE_UINT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is 20.

  * Default value is 0.

