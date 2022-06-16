Gnome::Gtk3::Drag
=================

Functions for controlling drag and drop handling

Description
===========

GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

As well as the functions listed here, applications may need to use some facilities provided for [Selections][gtk3-Selections]. Also, the Drag and Drop API makes use of signals in the **Gnome::Gtk3::Widget** class.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Drag;

Types
=====

Methods
=======

new
---

### default, no options

Create a new Drag object.

    multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like `:native-object` is needed.

cancel
------

Cancels an ongoing drag operation on the source side.

If you want to be able to cancel a drag operation in this way, you need to keep a pointer to the drag context, either from an explicit call to `begin_with_coordinates()`, or by connecting to *drag-begin from Gnome::Gtk3::Widget*.

If *context* does not refer to an ongoing drag operation, this function does nothing.

If a drag is cancelled in this way, the *result* argument of *drag-failed from Gnome::Gtk3::Widget* is set to *GTK_DRAG_RESULT_ERROR*.

    method cancel ( N-GObject() $context )

  * $context; a native **Gnome::Gdk3::DragContext**.

finish
------

Informs the drag source that the drop is finished, and that the data of the drag will no longer be required.

    method finish ( N-GObject() $context, Bool $success, Bool $del, UInt $time )

  * $context; the drag context

  * $success; a flag indicating whether the drop was successful

  * $del; a flag indicating whether the source should delete the original data. (This should be `True` for a move)

  * $time; the timestamp from the *drag-drop from Gnome::Gtk3::Widget* signal

get-data
--------

Gets the data associated with a drag. When the data is received or the retrieval fails, GTK+ will emit a *drag-data-received from Gnome::Gtk3::Widget* signal. Failure of the retrieval is indicated by the length field of the *selection_data* signal parameter being negative. However, when `get_data()` is called implicitely because the `GTK_DEST_DEFAULT_DROP` was set, then the widget will not receive notification of failed drops.

    method get-data (
      N-GObject() $widget, N-GObject() $context,
      N-GObject() $target, UInt $time
    )

  * $widget; the widget that will receive the *drag-data-received from Gnome::Gtk3::Widget* signal

  * $context; the drag context, a **Gnome::Gdk3::DragContext**.

  * $target; the target (form of the data) to retrieve, A native **Gnome::Gdk3::Atom**.

  * $time; a timestamp for retrieving the data. This will generally be the time received in a *drag-motion from Gnome::Gtk3::Widget* or *drag-drop from Gnome::Gtk3::Widget* signal

get-source-widget
-----------------

Determines the source widget for a drag.

Returns: if the drag is occurring within a single application, a pointer to the source widget. Otherwise, `undefined`.

    method get-source-widget ( N-GObject() $context --> N-GObject )

  * $context; a (destination side) drag context

highlight
---------

Highlights a widget as a currently hovered drop target. To end the highlight, call `unhighlight()`. GTK+ calls this automatically if `GTK_DEST_DEFAULT_HIGHLIGHT` is set.

    method highlight ( N-GObject() $widget )

  * $widget; a widget to highlight

set-icon-name
-------------

Sets the icon for a given drag from a named themed icon. See the docs for **Gnome::Gtk3::IconTheme** for more details. Note that the size of the icon depends on the icon theme (the icon is loaded at the symbolic size **Gnome::Gio::TK_ICON_SIZE_DND**), thus *hot_x* and *hot_y* have to be used with care.

    method set-icon-name (
      N-GObject() $context, Str $icon_name, Int() $hot_x, Int() $hot_y
    )

  * $context; the context for a drag (This must be called with a context for the source side of a drag)

  * $icon_name; name of icon to use

  * $hot_x; the X offset of the hotspot within the icon

  * $hot_y; the Y offset of the hotspot within the icon

set-icon-pixbuf
---------------

Sets *pixbuf* as the icon for a given drag.

    method set-icon-pixbuf (
      N-GObject() $context, N-GObject() $pixbuf,
      Int() $hot_x, Int() $hot_y
    )

  * $context; the context for a drag (This must be called with a context for the source side of a drag)

  * $pixbuf; the **Gnome::Gdk3::Pixbuf** to use as the drag icon

  * $hot_x; the X offset within *widget* of the hotspot

  * $hot_y; the Y offset within *widget* of the hotspot

unhighlight
-----------

Removes a highlight set by `highlight()` from a widget.

    method unhighlight ( N-GObject() $widget )

  * $widget; a widget to remove the highlight from

