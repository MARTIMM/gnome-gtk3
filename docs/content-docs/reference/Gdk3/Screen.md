Gnome::Gdk3::Screen
===================

Object representing a physical screen

Description
===========

**Gnome::Gdk3::Screen** objects are the GDK representation of the screen on which windows can be displayed and on which the pointer moves. X originally identified screens with physical screens, but nowadays it is more common to have a single **Gnome::Gdk3::Screen** which combines several physical monitors (see `gdk_screen_get_n_monitors()`).

**Gnome::Gdk3::Screen** is used throughout GDK and GTK+ to specify which screen the top level windows are to be displayed on. it is also used to query the screen specification and default settings such as the default visual (`gdk_screen_get_system_visual()`), the dimensions of the physical monitors (`gdk_screen_get_monitor_geometry()`), etc.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Screen;
    also is Gnome::GObject::Object;

Methods
=======

new
---

### default, no options

Create a new plain object with the default screen.

    multi method new ( )

### :native-object

Create an object using a native screen object from elsewhere.

    multi method new ( N-GObject :$native-object! )

get-display
-----------

Gets the display to which the *screen* belongs.

Returns: the display to which *screen* belongs

    method get-display ( --> N-GObject )

get-font-options
----------------

Gets any options previously set with `set-font-options()`.

Returns: the current font options, or `undefined` if no default font options have been set.

    method get-font-options ( --> cairo_font_options_t )

get-resolution
--------------

Gets the resolution for font handling on the screen; see `set-resolution()` for full details.

Returns: the current resolution, or -1 if no resolution has been set.

    method get-resolution ( --> Num )

get-rgba-visual
---------------

Gets a visual to use for creating windows with an alpha channel. The windowing system on which GTK+ is running may not support this capability, in which case `undefined` will be returned. Even if a non-`undefined` value is returned, its possible that the window’s alpha channel won’t be honored when displaying the window on the screen: in particular, for X an appropriate windowing manager and compositing manager must be running to provide appropriate display.

This functionality is not implemented in the Windows backend.

For setting an overall opacity for a top-level window, see `gdk-window-set-opacity()`.

Returns: a visual to use for windows with an alpha channel or `undefined` if the capability is not available.

    method get-rgba-visual ( --> N-GObject )

get-root-window
---------------

Gets the root window of *screen*.

Returns: the root window

    method get-root-window ( --> N-GObject )

get-system-visual
-----------------

Get the system’s default visual for *screen*. This is the visual for the root window of the display. The return value should not be freed.

Returns: the system visual

    method get-system-visual ( --> N-GObject )

get-toplevel-windows, get-toplevel-windows-rk
---------------------------------------------

    method get-toplevel-windows-rk ( --> Gnome::Glib::List )
    method get-toplevel-windows ( --> N-GList )

get-window-stack, get-window-stack-rk
-------------------------------------

Returns a **Gnome::Gdk3::List** of **Gnome::Gdk3::Windows** representing the current window stack.

On X11, this is done by inspecting the -NET-CLIENT-LIST-STACKING property on the root window, as described in the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec). If the window manager does not support the -NET-CLIENT-LIST-STACKING hint, this function returns `undefined`.

On other platforms, this function may return `undefined`, depending on whether it is implementable on that platform.

The returned list is newly allocated and owns references to the windows it contains, so it should be freed using `g-list-free()` and its windows unrefed using `g-object-unref()` when no longer needed.

Returns: (element-type GdkWindow): a list of **Gnome::Gdk3::Windows** for the current window stack, or `undefined`.

    method get-window-stack-rk ( --> Gnome::Glib::List )
    method get-window-stack ( --> N-GList )

is-composited
-------------

Returns whether windows with an RGBA visual can reasonably be expected to have their alpha channel drawn correctly on the screen.

On X11 this function returns whether a compositing manager is compositing *screen*.

Returns: Whether windows with RGBA visuals can reasonably be expected to have their alpha channels drawn correctly on the screen.

    method is-composited ( --> Bool )

list-visuals, list-visuals-rk
-----------------------------

Lists the available visuals for the specified *screen*. A visual describes a hardware image data format. For example, a visual might support 24-bit color, or 8-bit color, and might expect pixels to be in a certain format.

Call `g-list-free()` on the return value when you’re finished with it.

Returns: (transfer container) (element-type GdkVisual): a list of visuals; the list must be freed, but not its contents

    method list-visuals-rk ( --> Gnome::Glib::List )
    method list-visuals ( --> N-GList )

set-resolution
--------------

    method set-resolution ( Num() $dpi )

  * Num $dpi; the resolution in “dots per inch”. (Physical inches aren’t actually involved; the terminology is conventional.)

Sets the resolution for font handling on the screen. This is a scale factor between points specified in a **PangoFontDescription** and cairo units. The default value is 96, meaning that a 10 point font will be 13 units high. (10 * 96. / 72. = 13.3).

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### composited-changed

The *composited-changed* signal is emitted when the composited status of the screen changes

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

### monitors-changed

The *monitors-changed* signal is emitted when the number, size or position of the monitors attached to the screen change.

Only for X11 and OS X for now. A future implementation for Win32 may be a possibility.

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

### size-changed

The *size-changed* signal is emitted when the pixel width or height of a screen changes.

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Font options: font-options

The **Gnome::GObject::Value** type of property *font-options* is `G_TYPE_POINTER`.

### Font resolution: resolution

The **Gnome::GObject::Value** type of property *resolution* is `G_TYPE_DOUBLE`.

