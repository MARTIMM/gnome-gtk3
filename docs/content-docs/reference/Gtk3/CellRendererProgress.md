Gnome::Gtk3::CellRendererProgress
=================================

Renders numbers as progress bars

Description
===========

**Gnome::Gtk3::CellRendererProgress** renders a numeric value as a progress par in a cell. Additionally, it can display a text on top of the progress bar.

The **Gnome::Gtk3::CellRendererProgress** cell renderer was added in GTK+ 2.6.

Implemented Interfaces
----------------------

Gnome::Gtk3::CellRendererProgress implements

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererProgress;
    also is Gnome::Gtk3::CellRenderer;
    also does Gnome::Gtk3::Orientable;

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

[gtk_] cell_renderer_progress_new
---------------------------------

Creates a new **Gnome::Gtk3::CellRendererProgress**.

Returns: the new cell renderer

Since: 2.6

    method gtk_cell_renderer_progress_new ( --> N-GObject  )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Value

The "value" property determines the percentage to which the progress bar will be "filled in". Since: 2.6

The **Gnome::GObject::Value** type of property *value* is `G_TYPE_INT`.

### Text

The "text" property determines the label which will be drawn over the progress bar. Setting this property to `Any` causes the default label to be displayed. Setting this property to an empty string causes no label to be displayed. Since: 2.6

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### Pulse

Setting this to a non-negative value causes the cell renderer to enter "activity mode", where a block bounces back and forth to indicate that some progress is made, without specifying exactly how much. Each increment of the property causes the block to move by a little bit. To indicate that the activity has not started yet, set the property to zero. To indicate completion, set the property to `G_MAXINT`. Since: 2.12

The **Gnome::GObject::Value** type of property *pulse* is `G_TYPE_INT`.

### Text x alignment

The "text-xalign" property controls the horizontal alignment of the text in the progress bar. Valid values range from 0 (left) to 1 (right). Reserved for RTL layouts. Since: 2.12

The **Gnome::GObject::Value** type of property *text-xalign* is `G_TYPE_FLOAT`.

### Text y alignment

The "text-yalign" property controls the vertical alignment of the text in the progress bar. Valid values range from 0 (top) to 1 (bottom). Since: 2.12

The **Gnome::GObject::Value** type of property *text-yalign* is `G_TYPE_FLOAT`.

### Inverted

Invert the direction in which the progress bar grows Default value: False

The **Gnome::GObject::Value** type of property *inverted* is `G_TYPE_BOOLEAN`.

