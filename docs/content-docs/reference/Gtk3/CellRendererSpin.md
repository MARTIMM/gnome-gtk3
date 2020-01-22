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

gtk_cell_renderer_spin_new
--------------------------

Creates a new **Gnome::Gtk3::CellRendererSpin**.

Since: 2.10

    method gtk_cell_renderer_spin_new ( --> N-GObject  )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Adjustment

The adjustment that holds the value of the spinbutton. This must be non-`Any` for the cell renderer to be editable. Since: 2.10 Widget type: GTK_TYPE_ADJUSTMENT

The **Gnome::GObject::Value** type of property *adjustment* is `G_TYPE_OBJECT`.

### Climb rate

The acceleration rate when you hold down a button. Since: 2.10

The **Gnome::GObject::Value** type of property *climb-rate* is `G_TYPE_DOUBLE`.

### Digits

The number of decimal places to display. Since: 2.10

The **Gnome::GObject::Value** type of property *digits* is `G_TYPE_UINT`.

