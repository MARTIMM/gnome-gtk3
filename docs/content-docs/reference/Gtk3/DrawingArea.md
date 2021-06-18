Gnome::Gtk3::DrawingArea
========================

A widget for custom user interface elements

Description
===========

The **Gnome::Gtk3::DrawingArea** widget is used for creating custom user interface elements. It’s essentially a blank widget; you can draw on it. After creating a drawing area, the application may want to connect to:

  * Mouse and button press signals to respond to input from the user.

  * The *realize* signal to take any necessary actions when the widget is instantiated on a particular display. (Create GDK resources in response to this signal.)

  * The *size-allocate* signal to take any necessary actions when the widget changes size.

  * The *draw* signal to handle redrawing the contents of the widget.

The following code portion demonstrates using a drawing area to display a circle in the normal widget foreground color.

Note that GDK automatically clears the exposed area before sending the expose event, and that drawing is implicitly clipped to the exposed area. If you want to have a theme-provided background, you need to call `gtk_render_background()` in your *draw* method.

Simple **Gnome::Gtk3::DrawingArea** usage
-----------------------------------------

Draw signals are normally delivered when a drawing area first comes onscreen, or when it’s covered by another window and then uncovered. You can also force an expose event by adding to the “damage region” of the drawing area’s window; `gtk_widget_queue_draw_area()` and `gdk_window_invalidate_rect()` are equally good ways to do this. You’ll then get a draw signal for the invalid region.

The available routines for drawing are documented on the [GDK Drawing Primitives][gdk3-Cairo-Interaction] page and the cairo documentation.

To receive mouse events on a drawing area, you will need to enable them with `gtk_widget_add_events()`. To receive keyboard events, you will need to set the “can-focus” property on the drawing area, and you should probably draw some user-visible indication that the drawing area is focused. Use `gtk_widget_has_focus()` in your expose event handler to decide whether to draw the focus indicator. See `gtk_render_focus()` for one way to draw focus.

See Also
--------

**Gnome::Gtk3::Image**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::DrawingArea;
    also is Gnome::Gtk3::Widget;

Uml Diagram
-----------

![](plantuml/DrawingArea.png)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::DrawingArea;

    unit class MyGuiClass;
    also is Gnome::Gtk3::DrawingArea;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::DrawingArea class process the options
      self.bless( :GtkDrawingArea, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new DrawingArea object.

    multi method new ( )

