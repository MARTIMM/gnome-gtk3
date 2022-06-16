Gnome::Gtk3::DragSource
=======================

Description
===========

GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

This module defines the drag source manipulations

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::DragSource;

Methods
=======

new
---

### default, no options

Create a new DragSource object.

    multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like `:native-object` is needed.

add-image-targets
-----------------

Add the writable image targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag source. The targets are added with *info* = 0. If you need another value, use `Gnome::Gtk3::TargetList.add-image-targets()` and `set-target-list()`.

    method add-image-targets ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget** that’s is a drag source

add-text-targets
----------------

Add the text targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag source. The targets are added with *info* = 0. If you need another value, use `Gnome::Gtk3::TargetList.add-text-targets()` and `set-target-list()`.

    method add-text-targets ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget** that’s is a drag source

add-uri-targets
---------------

Add the URI targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag source. The targets are added with *info* = 0. If you need another value, use `Gnome::Gtk3::TargetList.add-uri-targets()` and `set-target-list()`.

    method add-uri-targets ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget** that’s is a drag source

set
---

Sets up a widget so that GTK+ will start a drag operation when the user clicks and drags on the widget. The widget must have a window.

    method set (
      N-GObject() $widget, Int() $start-button-mask,
      Array[N-GtkTargetEntry] $targets, Int() $actions
    )

  * $widget; a **Gnome::Gtk3::Widget**

  * $start-button-mask; the bitmask of buttons that can start the drag. Bits are from enum GdkModifierType

  * $targets; an array of **Gnome::Gtk3::TargetEntry** targets that the drag will support, may be `undefined`

  * $actions; the bitmask of possible actions for a drag from this widget. Bits are from enum GdkDragAction defined in **Gnome::Gdk3::Dnd**.

set-icon-name
-------------

Sets the icon that will be used for drags from a particular source to a themed icon. See the docs for **Gnome::Gtk3::IconTheme** for more details.

    method set-icon-name ( N-GObject() $widget, Str $icon-name )

  * $widget; a **Gnome::Gtk3::Widget**

  * $icon-name; name of icon to use

set-icon-pixbuf
---------------

Sets the icon that will be used for drags from a particular widget from a **Gnome::Gtk3::Pixbuf**. GTK+ retains a reference for *pixbuf* and will release it when it is no longer needed.

    method set-icon-pixbuf ( N-GObject() $widget, N-GObject() $pixbuf )

  * $widget; a **Gnome::Gtk3::Widget**

  * $pixbuf; the **Gnome::Gtk3::Pixbuf** for the drag icon

set-target-list
---------------

Changes the target types that this widget offers for drag-and-drop. The widget must first be made into a drag source with `set()`.

    method set-target-list ( N-GObject() $widget, N-GtkTargetList $target-list )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag source

  * $target-list; list of draggable targets, or `undefined` for none

unset
-----

Undoes the effects of `set()`.

    method unset ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget**

