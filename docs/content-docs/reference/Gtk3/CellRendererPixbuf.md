Gnome::Gtk3::CellRendererPixbuf
===============================

Renders a pixbuf in a cell

Description
===========

A **Gnome::Gtk3::CellRendererPixbuf** can be used to render an image in a cell. It allows to render either a given **Gnome::Gdk3::Pixbuf** (set via the *pixbuf* property) or a named icon (set via the *icon-name* property).

To support the tree view, **Gnome::Gtk3::CellRendererPixbuf** also supports rendering two alternative pixbufs, when the *is-expander* property is `1`. If the *is-expanded* property is `1` and the *pixbuf-expander-open* property is set to a pixbuf, it renders that pixbuf, if the *is-expanded* property is `0` and the *pixbuf-expander-closed* property is set to a pixbuf, it renders that one.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererPixbuf;
    also is Gnome::Gtk3::CellRenderer;

Uml Diagram
-----------

![](plantuml/CellRenderer-ea.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererPixbuf object.

    multi method new ( )

### :native-object

Create a CellRendererPixbuf object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererPixbuf object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Properties
==========

gicon
-----

The GIcon being displayed

The **Gnome::GObject::Value** type of property *gicon* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

icon-name
---------

The name of the icon from the icon theme

The **Gnome::GObject::Value** type of property *icon-name* is `G_TYPE_STRING`.

  * Parameter is readable and writable.

  * Default value is undefined.

pixbuf
------

The pixbuf to render

The **Gnome::GObject::Value** type of property *pixbuf* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

pixbuf-expander-closed
----------------------

Pixbuf for closed expander

The **Gnome::GObject::Value** type of property *pixbuf-expander-closed* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

pixbuf-expander-open
--------------------

Pixbuf for open expander

The **Gnome::GObject::Value** type of property *pixbuf-expander-open* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

stock-detail
------------

Render detail to pass to the theme engine

The **Gnome::GObject::Value** type of property *stock-detail* is `G_TYPE_STRING`.

  * Parameter is readable and writable.

  * Default value is undefined.

stock-size
----------

The GtkIconSize value that specifies the size of the rendered icon

The **Gnome::GObject::Value** type of property *stock-size* is `G_TYPE_UINT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXUINT.

  * Default value is GTK_ICON_SIZE_MENU.

surface
-------

The surface to render

The **Gnome::GObject::Value** type of property *surface* is `G_TYPE_BOXED`.

