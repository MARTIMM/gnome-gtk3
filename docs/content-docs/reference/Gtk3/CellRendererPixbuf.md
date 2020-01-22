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

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_cell_renderer_pixbuf_new
----------------------------

Creates a new **Gnome::Gtk3::CellRendererPixbuf**. Adjust rendering parameters using object properties. Object properties can be set globally (with `g_object_set()`). Also, with **Gnome::Gtk3::TreeViewColumn**, you can bind a property to a value in a **Gnome::Gtk3::TreeModel**. For example, you can bind the “pixbuf” property on the cell renderer to a pixbuf value in the model, thus rendering a different image in each row of the **Gnome::Gtk3::TreeView**.

Returns: the new cell renderer

    method gtk_cell_renderer_pixbuf_new ( --> N-GObject  )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Pixbuf Object

The pixbuf to render

Widget type: GDK_TYPE_PIXBUF

The **Gnome::GObject::Value** type of property *pixbuf* is `G_TYPE_OBJECT`.

### Pixbuf Expander Open

Pixbuf for open expander. Used when a Pixbuf is shown in a Gnome::Gtk3::TreeStore

Widget type: GDK_TYPE_PIXBUF

The **Gnome::GObject::Value** type of property *pixbuf-expander-open* is `G_TYPE_OBJECT`.

### Pixbuf Expander Closed

Pixbuf for closed expander. Used when a Pixbuf is shown in a Gnome::Gtk3::TreeStore

Widget type: GDK_TYPE_PIXBUF

The **Gnome::GObject::Value** type of property *pixbuf-expander-closed* is `G_TYPE_OBJECT`.

### surface

The surface to render

Since: 3.10

The **Gnome::GObject::Value** type of property *surface* is `G_TYPE_BOXED`.

### Size

The GtkIconSize value that specifies the size of the rendered icon.

The **Gnome::GObject::Value** type of property *stock-size* is `G_TYPE_UINT`.

### Detail

Render detail to pass to the theme engine

Default value: Any

The **Gnome::GObject::Value** type of property *stock-detail* is `G_TYPE_STRING`.

### Icon Name

The name of the themed icon to display. This property only has an effect if not overridden by "stock_id" or "pixbuf" properties.

Since: 2.8

The **Gnome::GObject::Value** type of property *icon-name* is `G_TYPE_STRING`.

### Icon

The GIcon representing the icon to display. If the icon theme is changed, the image will be updated automatically.

Since: 2.14 Widget type: G_TYPE_ICON

The **Gnome::GObject::Value** type of property *gicon* is `G_TYPE_OBJECT`.

