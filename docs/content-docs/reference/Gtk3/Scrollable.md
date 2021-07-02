Gnome::Gtk3::Scrollable
=======================

An interface for scrollable widgets

Description
===========

**Gnome::Gtk3::Scrollable** is an interface that is implemented by widgets with native scrolling ability.

To implement this interface you should override the *hadjustment* and *vadjustment* properties.

Creating a scrollable widget
----------------------------

All scrollable widgets should do the following.

  * When a parent widget sets the scrollable child widget’s adjustments, the widget should populate the adjustments’ *lower*, *upper*, *step-increment*, *page-increment* and *page-size* properties and connect to the *value-changed* signal.

  * Because its preferred size is the size for a fully expanded widget, the scrollable widget must be able to cope with underallocations. This means that it must accept any value passed to its **Gnome::Gtk3::WidgetClass**.`size-allocate()` function.

  * When the parent allocates space to the scrollable child widget, the widget should update the adjustments’ properties with new values.

  * When any of the adjustments emits the *value-changed* signal, the scrollable widget should scroll its contents.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Scrollable;

Methods
=======

get-border
----------

Returns the size of a non-scrolling border around the outside of the scrollable. An example for this would be treeview headers. GTK+ can use this information to display overlayed graphics, like the overshoot indication, at the right position.

Returns: Undefined or invalid if *border* has not been set.

    method get-border ( --> N-GtkBorder )
    method get-border-rk ( --> Gnome::Gtk3::Border )

  * N-GObject $border;

get-hadjustment
---------------

Retrieves the **Gnome::Gtk3::Adjustment** used for horizontal scrolling.

    method get-hadjustment ( --> N-GObject )
    method get-hadjustment-rk ( --> Gnome::Gtk3::Adjustment )

get-hscroll-policy
------------------

Gets the horizontal **GtkScrollablePolicy** enum value.

    method get-hscroll-policy ( --> GtkScrollablePolicy )

get-vadjustment, get-vadjustment-rk
-----------------------------------

Retrieves the **Gnome::Gtk3::Adjustment** used for vertical scrolling.

    method get-vadjustment ( --> N-GObject )
    method get-vadjustment-rk ( --> Gnome::Gtk3::Adjustment )

get-vscroll-policy
------------------

Gets the vertical **GtkScrollablePolicy**.

    method get-vscroll-policy ( --> GtkScrollablePolicy )

set-hadjustment
---------------

Sets the horizontal adjustment of the **Gnome::Gtk3::Scrollable**.

    method set-hadjustment ( N-GObject $hadjustment )

  * N-GObject $hadjustment; a **Gnome::Gtk3::Adjustment**

set-hscroll-policy
------------------

Sets the **GtkScrollablePolicy** to determine whether horizontal scrolling should start below the minimum width or below the natural width.

    method set-hscroll-policy ( GtkScrollablePolicy $policy )

  * GtkScrollablePolicy $policy; the horizontal **GtkScrollablePolicy**.

set-vadjustment
---------------

Sets the vertical adjustment of the **Gnome::Gtk3::Scrollable**.

    method set-vadjustment ( N-GObject $vadjustment )

  * N-GObject $vadjustment; a **Gnome::Gtk3::Adjustment**

set-vscroll-policy
------------------

Sets the **Gnome::Gtk3::ScrollablePolicy** to determine whether vertical scrolling should start below the minimum height or below the natural height.

    method set-vscroll-policy ( GtkScrollablePolicy $policy )

  * GtkScrollablePolicy $policy; the vertical **Gnome::Gtk3::ScrollablePolicy**

