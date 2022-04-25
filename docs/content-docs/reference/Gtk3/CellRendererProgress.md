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

Uml Diagram
-----------

![](plantuml/CellRenderer-ea.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererProgress object.

    multi method new ( )

### :native-object

Create a CellRendererProgress object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererProgress object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Properties
==========

inverted
--------

Invert the direction in which the progress bar grows

The **Gnome::GObject::Value** type of property *inverted* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

pulse
-----

Set this to positive values to indicate that some progress is made, but you don't know how much.

The **Gnome::GObject::Value** type of property *pulse* is `G_TYPE_INT`.

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

text
----

Text on the progress bar

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

  * Parameter is readable and writable.

  * Default value is undefined.

text-xalign
-----------

The horizontal text alignment, from 0 (left to 1 (right). Reversed for RTL layouts.)

The **Gnome::GObject::Value** type of property *text-xalign* is `G_TYPE_FLOAT`.

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.5.

text-yalign
-----------

The vertical text alignment, from 0 (top to 1 (bottom).)

The **Gnome::GObject::Value** type of property *text-yalign* is `G_TYPE_FLOAT`.

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.5.

value
-----

Value of the progress bar

The **Gnome::GObject::Value** type of property *value* is `G_TYPE_INT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is 100.

  * Default value is 0.

