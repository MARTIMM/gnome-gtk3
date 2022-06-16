Gnome::Gtk3::DragDest
=====================

Description
===========

GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

This module defines the drag destination manipulations

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::DragDest;

Types
=====

enum GtkDestDefaults
--------------------

The **Gnome::Gtk3::DestDefaults** enumeration specifies the various types of action that will be taken on behalf of the user for a drag destination site.

  * GTK_DEST_DEFAULT_NONE: (=0) to select no default.

  * GTK-DEST-DEFAULT-MOTION: If set for a widget, GTK+, during a drag over this widget will check if the drag matches this widget’s list of possible targets and actions. GTK+ will then call `gdk-drag-status()` as appropriate.

  * GTK-DEST-DEFAULT-HIGHLIGHT: If set for a widget, GTK+ will draw a highlight on this widget as long as a drag is over this widget and the widget drag format and action are acceptable.

  * GTK-DEST-DEFAULT-DROP: If set for a widget, when a drop occurs, GTK+ will will check if the drag matches this widget’s list of possible targets and actions. If so, GTK+ will call `gtk-drag-get-data()` on behalf of the widget. Whether or not the drop is successful, GTK+ will call `gtk-drag-finish()`. If the action was a move, then if the drag was successful, then `True` will be passed for the *delete* parameter to `gtk-drag-finish()`.

  * GTK-DEST-DEFAULT-ALL: If set, specifies that all default actions should be taken.

Methods
=======

new
---

### default, no options

Create a new DragDest object.

    multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like `:native-object` is needed.

add-image-targets
-----------------

Add the image targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag destination. The targets are added with *info* = 0. If you need another value, use `gtk-target-list-add-image-targets()` and `set-target-list()`.

    method add-image-targets ( N-GObject() $widget )

  * $widget; a native **Gnome::Gtk3::Widget** that’s a drag destination

add-text-targets
----------------

Add the text targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag destination. The targets are added with *info* = 0. If you need another value, use `gtk-target-list-add-text-targets()` and `set-target-list()`.

    method add-text-targets ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag destination

add-uri-targets
---------------

Add the URI targets supported by **Gnome::Gtk3::SelectionData** to the target list of the drag destination. The targets are added with *info* = 0. If you need another value, use `gtk-target-list-add-uri-targets()` and `set-target-list()`.

    method add-uri-targets ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag destination

find-target
-----------

Looks for a match between the supported targets of *context* and the *dest-target-list*, returning the first matching target, otherwise returning `GDK-NONE`. *dest-target-list* should usually be the return value from `get-target-list()`, but some widgets may have different valid targets for different parts of the widget; in that case, they will have to implement a drag-motion handler that passes the correct target list to this function.

Returns: first target that the source offers and the dest can accept, or `GDK-NONE`

    method find-target (
      N-GObject() $widget, N-GObject() $context,
      N-GObject() $target-list?
      --> N-GObject
    )

  * $widget; drag destination widget

  * $context; drag context

  * $target-list; list of droppable targets, or `undefined` to use `get-target-list($widget)`.

Previously, it returned a **Gnome::Gdk3::Atom**. To confirm with latest ideas about coercing, the routine now returns a native object. To cope with the change, write the following instead, for example;

    my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(…);

Note the `()` tacked on the **Gnome::Gdk3::Atom** type! Sorry that I cannot give a deprecation warning because of multis not looking for return types.

get-target-list
---------------

Returns the list of targets this widget can accept from drag-and-drop.

Returns: the **Gnome::Gtk3::TargetList**, or `undefined` if none

    method get-target-list ( N-GObject() $widget --> N-GObject )

  * $widget; a **Gnome::Gtk3::Widget**

get-track-motion
----------------

Returns whether the widget has been configured to always emit *drag-motion* signals.

Returns: `True` if the widget always emits *drag-motion* events

    method get-track-motion ( N-GObject $widget --> Bool )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag destination

set
---

Sets a widget as a potential drop destination, and adds default behaviors.

The default behaviors listed in *flags* have an effect similar to installing default handlers for the widget’s drag-and-drop signals ( *drag-motion*, *drag-drop*, ...). They all exist for convenience. When passing `GTK-DEST-DEFAULT-ALL` for instance it is sufficient to connect to the widget’s *drag-data-received* signal to get primitive, but consistent drag-and-drop support.

Things become more complicated when you try to preview the dragged data, as described in the documentation for *drag-motion*. The default behaviors described by *flags* make some assumptions, that can conflict with your own signal handlers. For instance `GTK-DEST-DEFAULT-DROP` causes invokations of `gdk-drag-status()` in the context of *drag-motion*, and invokations of `gtk-drag-finish()` in *drag-data-received*. Especially the later is dramatic, when your own *drag-motion* handler calls `gtk-drag-get-data()` to inspect the dragged data.

There’s no way to set a default action here, you can use the *drag-motion* callback for that.

The method API is

    multi method set (
      N-GObject() $widget, Int() $flags,
      Array[N-GtkTargetEntry] $targets, Int() $actions
    )

  * $widget; a **Gnome::Gtk3::Widget**

  * $flags; which types of default drag behavior to use. Bits are from enum GtkDestDefaults.

  * $targets; an array of native **Gnome::Gtk3::TargetEntry** targets indicating the drop types that this *widget* will accept. Later you can access the list with `get-target-list()` and `find-target()`, or an empty array.

  * $actions; a bitmask of possible actions for a drop onto this *widget*. Bits are from enum GdkDragAction defined in **Gnome::Gdk3::DragContext**.

set-target-list
---------------

Sets the target types that this widget can accept from drag-and-drop. The widget must first be made into a drag destination with `set()`.

    method set-target-list ( N-GObject() $widget, N-GtkTargetList $target-list )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag destination

  * $target-list; list of droppable targets, or `undefined` for none

set-track-motion
----------------

Tells the widget to emit *drag-motion* and *drag-leave* events regardless of the targets and the `GTK-DEST-DEFAULT-MOTION` flag.

This may be used when a widget wants to do generic actions regardless of the targets that the source offers.

    method set-track-motion ( N-GObject() $widget, Bool $track_motion )

  * $widget; a **Gnome::Gtk3::Widget** that’s a drag destination

  * $track_motion; whether to accept all targets

unset
-----

Clears information about a drop destination set with `set()`. The widget will no longer receive notification of drags.

    method unset ( N-GObject() $widget )

  * $widget; a **Gnome::Gtk3::Widget**

