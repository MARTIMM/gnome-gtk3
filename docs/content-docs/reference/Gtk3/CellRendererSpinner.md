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

Uml Diagram
-----------

![](plantuml/CellRenderer-ea.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererSpinner object.

    multi method new ( )

### :native-object

Create a CellRendererSpinner object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererSpinner object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Properties
==========

active
------

Whether the spinner is active (ie. shown in the cell)

The **Gnome::GObject::Value** type of property *active* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

pulse
-----

Pulse of the spinner

The **Gnome::GObject::Value** type of property *pulse* is `G_TYPE_UINT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXUINT.

  * Default value is 0.

size
----

The GtkIconSize value that specifies the size of the rendered spinner

The **Gnome::GObject::Value** type of property *size* is `G_TYPE_ENUM`.

  * Parameter is readable and writable.

  * Default value is GTK_ICON_SIZE_MENU.

