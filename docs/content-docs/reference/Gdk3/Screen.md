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

Create a new plain object with the default screen.

    multi method new ( )

Create an object using a native screen object from elsewhere.

    multi method new ( N-GObject :$screen! )

[[gdk_] screen_] get_system_visual
----------------------------------

Get the system’s default visual for this screen. This is the visual for the root window of the display. The return value should not be freed.

Returns: the system visual. A native **Gnome::Gdk3::Visual**

Since: 2.2

    method gdk_screen_get_system_visual ( --> N-GObject  )

[[gdk_] screen_] get_rgba_visual
--------------------------------

Gets a visual to use for creating windows with an alpha channel. The windowing system on which GTK+ is running may not support this capability, in which case `Any` will be returned. Even if a non-`Any` value is returned, its possible that the window’s alpha channel won’t be honored when displaying the window on the screen: in particular, for X an appropriate windowing manager and compositing manager must be running to provide appropriate display.

This functionality is not implemented in the Windows backend.

For setting an overall opacity for a top-level window, see `gdk_window_set_opacity()`.

Returns: a visual to use for windows with an alpha channel or `Any` if the capability is not available.

Since: 2.8

    method gdk_screen_get_rgba_visual ( --> N-GObject  )

[[gdk_] screen_] is_composited
------------------------------

Returns whether windows with an RGBA visual can reasonably be expected to have their alpha channel drawn correctly on the screen.

On X11 this function returns whether a compositing manager is compositing this screen.

Returns: Whether windows with RGBA visuals can reasonably be expected to have their alpha channels drawn correctly on the screen.

Since: 2.10

    method gdk_screen_is_composited ( --> Int  )

[[gdk_] screen_] get_root_window
--------------------------------

Gets the root window of this screen.

Returns: the root window, a native **Gnome::Gdk3::Window**.

Since: 2.2

    method gdk_screen_get_root_window ( --> N-GObject  )

[[gdk_] screen_] get_display
----------------------------

Gets the display to which the *screen* belongs.

Returns: the display to which screen belongs, a native **Gnome::Gdk3::Display**.

Since: 2.2

    method gdk_screen_get_display ( --> N-GObject  )

[[gdk_] screen_] list_visuals
-----------------------------

Lists the available visuals for this screen. A visual describes a hardware image data format. For example, a visual might support 24-bit color, or 8-bit color, and might expect pixels to be in a certain format.

Call `g_list_free()` on the return value when you’re finished with it.

Returns: a list of native **Gnome::Gdk3::Visual**, the list must be freed, but not its contents.

Since: 2.2

    method gdk_screen_list_visuals ( --> N-GList )

[[gdk_] screen_] get_toplevel_windows
-------------------------------------

Obtains a list of all toplevel windows known to GDK on the screen screen . A toplevel window is a child of the root window (see gdk_get_default_root_window()).

The returned list should be freed with g_list_free(), but its elements need not be freed. It's a list of native **Gnome::Gdk3::Window** elements.

    method gdk_screen_get_toplevel_windows ( --> N-GList  )

[[gdk_] screen_] get_default
----------------------------

Gets the default screen for the default display. (See gdk_display_get_default()).

    method gdk_screen_get_default ( --> N-GObject  )

Returns a native **Gnome::Gdk3::Screen**.

[[gdk_] screen_] get_setting
----------------------------

Retrieves a desktop-wide setting such as double-click time for this screen.

FIXME needs a list of valid settings here, or a link to more information.

Returns: `1` if the setting existed and a value was stored in *value*, `0` otherwise.

Since: 2.2

    method gdk_screen_get_setting ( Str $name, N-GObject $value --> Int  )

  * Str $name; the name of the setting

  * N-GObject $value; location to store the value of the setting

[[gdk_] screen_] get_resolution
-------------------------------

Gets the resolution for font handling on the screen; see `gdk_screen_set_resolution()` for full details.

Returns: the current resolution, or -1 if no resolution has been set.

Since: 2.10

    method gdk_screen_get_resolution ( --> Num  )

[[gdk_] screen_] get_window_stack
---------------------------------

Returns a **GList** of **Gnome::Gdk3::Windows** representing the current window stack.

On X11, this is done by inspecting the _NET_CLIENT_LIST_STACKING property on the root window, as described in the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec). If the window manager does not support the _NET_CLIENT_LIST_STACKING hint, this function returns `Any`.

On other platforms, this function may return `Any`, depending on whether it is implementable on that platform.

The returned list is newly allocated and owns references to the windows it contains, so it should be freed using `g_list_free()` and its windows unrefed using `g_object_unref()` when no longer needed.

Returns: (nullable) (transfer full) (element-type **Gnome::Gdk3::Window**): a list of **Gnome::Gdk3::Windows** for the current window stack, or `Any`.

Since: 2.10

    method gdk_screen_get_window_stack ( --> N-GList  )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, N-GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### size-changed

The *size-changed* signal is emitted when the pixel width or height of a screen changes.

Since: 2.2

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

### composited-changed

The *composited-changed* signal is emitted when the composited status of the screen changes

Since: 2.10

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

### monitors-changed

The *monitors-changed* signal is emitted when the number, size or position of the monitors attached to the screen change.

Only for X11 and OS X for now. A future implementation for Win32 may be a possibility.

Since: 2.14

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($screen),
      *%user-options
    );

  * $screen; the object on which the signal is emitted

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Font resolution

The **Gnome::GObject::Value** type of property *resolution* is `G_TYPE_DOUBLE`.

