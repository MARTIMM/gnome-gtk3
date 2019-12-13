Gnome::Gtk3::CellRendererSpinner
================================

Renders a spinning animation in a cell

Description
===========

**Gnome::Gtk3::CellRendererSpinner** renders a spinning animation in a cell, very similar to **Gnome::Gtk3::Spinner**. It can often be used as an alternative to a **Gnome::Gtk3::CellRendererProgress** for displaying indefinite activity, instead of actual progress.

To start the animation in a cell, set the *active* property to `1` and increment the *pulse* property at regular intervals. The usual way to set the cell renderer properties for each cell is to bind them to columns in your tree model using e.g. `gtk_tree_view_column_add_attribute()`.

See Also
--------

**Gnome::Gtk3::Spinner**, **Gnome::Gtk3::CellRendererProgress**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererSpinner;
    also is Gnome::Gtk3::CellRenderer;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_cell_renderer_spinner_new
-----------------------------

Returns a new cell renderer which will show a spinner to indicate activity.

Since: 2.20

    method gtk_cell_renderer_spinner_new ( --> N-GObject  )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Active

Whether the spinner is active (ie. shown in the cell) Default value: False

The **Gnome::GObject::Value** type of property *active* is `G_TYPE_BOOLEAN`.

### Pulse

Pulse of the spinner. Increment this value to draw the next frame of the spinner animation. Usually, you would update this value in a timeout. By default, the **Gnome::Gtk3::Spinner** widget draws one full cycle of the animation, consisting of 12 frames, in 750 milliseconds. Since: 2.20

The **Gnome::GObject::Value** type of property *pulse* is `G_TYPE_UINT`.

### Size

The **Gnome::Gtk3::IconSize** value that specifies the size of the rendered spinner. Since: 2.20 Widget type: GTK_TYPE_ICON_SIZE

The **Gnome::GObject::Value** type of property *size* is `G_TYPE_ENUM`.

