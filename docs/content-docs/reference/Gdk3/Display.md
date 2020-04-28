Gnome::Gdk3::Display
====================

Controls a set of **Gnome::Gdk3::Screens** and their associated input devices

Description
===========

**Gnome::Gdk3::Display** objects purpose are two fold:

  * To manage and provide information about input devices (pointers and keyboards)

  * To manage and provide information about the available **Gnome::Gdk3::Screens**

**Gnome::Gdk3::Display** objects are the GDK representation of an X Display, which can be described as a workstation consisting of a keyboard, a pointing device (such as a mouse) and one or more screens. It is used to open and keep track of various **Gnome::Gdk3::Screen** objects currently instantiated by the application. It is also used to access the keyboard(s) and mouse pointer(s) of the display.

Most of the input device handling has been factored out into the separate **Gnome::Gdk3::DeviceManager** object. Every display has a device manager, which you can obtain using `gdk_display_get_device_manager()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Display;
    also is Gnome::GObject::Object;

Methods
=======

new
---

Create a new object with the default display.

    multi method new ( )

Create a new plain object selecting a display by name.

    multi method new ( Bool :open!, Str :$display-name )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

gdk_display_open
----------------

Opens a display.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::Display**, or `Any` if the display could not be opened

Since: 2.2

    method gdk_display_open ( Str $display_name --> N-GObject  )

  * Str $display_name; the name of the display to open

[[gdk_] display_] get_name
--------------------------

Gets the name of the display.

Returns: a string representing the display name. This string is owned by GDK and should not be modified or freed.

Since: 2.2

    method gdk_display_get_name ( --> Str  )

[[gdk_] display_] get_default_screen
------------------------------------

Get the default **Gnome::Gdk3::Screen** for this display.

Since: 2.2

    method gdk_display_get_default_screen ( --> N-GObject  )

[[gdk_] display_] device_is_grabbed
-----------------------------------

Returns `1` if there is an ongoing grab on *device* for *display*.

Returns: `1` if there is a grab in effect for *device*.

    method gdk_display_device_is_grabbed ( N-GObject $device --> Int  )

  * N-GObject $device; a **Gnome::Gdk3::Device**

gdk_display_beep
----------------

Emits a short beep on *display*

Since: 2.2

    method gdk_display_beep ( )

gdk_display_sync
----------------

Flushes any requests queued for the windowing system and waits until all requests have been handled. This is often used for making sure that the display is synchronized with the current state of the program. Calling `gdk_display_sync()` before `gdk_error_trap_pop()` makes sure that any errors generated from earlier requests are handled before the error trap is removed.

This is most useful for X11. On windowing systems where requests are handled synchronously, this function will do nothing.

Since: 2.2

    method gdk_display_sync ( )

gdk_display_flush
-----------------

Flushes any requests queued for the windowing system; this happens automatically when the main loop blocks waiting for new events, but if your application is drawing without returning control to the main loop, you may need to call this function explicitly. A common case where this function needs to be called is when an application is executing drawing commands from a thread other than the thread where the main loop is running.

This is most useful for X11. On windowing systems where requests are handled synchronously, this function will do nothing.

Since: 2.4

    method gdk_display_flush ( )

gdk_display_close
-----------------

Closes the connection to the windowing system for the given display, and cleans up associated resources.

Since: 2.2

    method gdk_display_close ( )

[[gdk_] display_] is_closed
---------------------------

Finds out if the display has been closed.

Returns: `1` if the display is closed.

Since: 2.22

    method gdk_display_is_closed ( --> Int  )

[[gdk_] display_] get_event
---------------------------

Gets the next **Gnome::Gdk3::Event** to be processed for the display, fetching events from the windowing system if necessary.

Returns: (nullable): the next **Gnome::Gdk3::Event** to be processed, or `Any` if no events are pending. The returned **Gnome::Gdk3::Event** should be freed with `gdk_event_free()`.

Since: 2.2

    method gdk_display_get_event ( --> GdkEvent  )

[[gdk_] display_] peek_event
----------------------------

Gets a copy of the first **Gnome::Gdk3::Event** in the *display*’s event queue, without removing the event from the queue. (Note that this function will not get more events from the windowing system. It only checks the events that have already been moved to the GDK event queue.)

Returns: (nullable): a copy of the first **Gnome::Gdk3::Event** on the event queue, or `Any` if no events are in the queue. The returned **Gnome::Gdk3::Event** should be freed with `gdk_event_free()`.

Since: 2.2

    method gdk_display_peek_event ( --> GdkEvent  )

[[gdk_] display_] put_event
---------------------------

Appends a copy of the given event onto the front of the event queue for *display*.

Since: 2.2

    method gdk_display_put_event ( GdkEvent $event )

  * GdkEvent $event; a **Gnome::Gdk3::Event**.

[[gdk_] display_] has_pending
-----------------------------

Returns whether the display has events that are waiting to be processed.

Returns: `1` if there are events ready to be processed.

Since: 3.0

    method gdk_display_has_pending ( --> Int  )

[[gdk_] display_] set_double_click_time
---------------------------------------

    method gdk_display_set_double_click_time ( UInt $msec )

  * UInt $msec;

[[gdk_] display_] set_double_click_distance
-------------------------------------------

    method gdk_display_set_double_click_distance ( UInt $distance )

  * UInt $distance;

[[gdk_] display_] get_default
-----------------------------

Gets the default GdkDisplay. This is a convenience function for `gdk_display_manager_get_default_display(gdk_display_manager_get())`.

Returns a GdkDisplay, or NULL if there is no default display.

    method gdk_display_get_default ( --> N-GObject  )

[[gdk_] display_] supports_cursor_alpha
---------------------------------------

Returns `1` if cursors can use an 8bit alpha channel on *display*. Otherwise, cursors are restricted to bilevel alpha (i.e. a mask).

Returns: whether cursors can have alpha channels.

Since: 2.4

    method gdk_display_supports_cursor_alpha ( --> Int  )

[[gdk_] display_] supports_cursor_color
---------------------------------------

Returns `1` if multicolored cursors are supported on *display*. Otherwise, cursors have only a forground and a background color.

Returns: whether cursors can have multiple colors.

Since: 2.4

    method gdk_display_supports_cursor_color ( --> Int  )

[[gdk_] display_] get_default_cursor_size
-----------------------------------------

Returns the default size to use for cursors on *display*.

Returns: the default cursor size.

Since: 2.4

    method gdk_display_get_default_cursor_size ( --> UInt  )

[[gdk_] display_] get_maximal_cursor_size
-----------------------------------------

Gets the maximal size to use for cursors on *display*.

Since: 2.4

    method gdk_display_get_maximal_cursor_size ( UInt $width, UInt $height )

  * UInt $width; (out): the return location for the maximal cursor width

  * UInt $height; (out): the return location for the maximal cursor height

[[gdk_] display_] get_default_group
-----------------------------------

Returns the default group leader window for all toplevel windows on *display*. This window is implicitly created by GDK. See `gdk_window_set_group()`.

Returns: (transfer none): The default group leader window for *display*

Since: 2.4

    method gdk_display_get_default_group ( --> N-GObject  )

[[gdk_] display_] supports_selection_notification
-------------------------------------------------

Returns whether **Gnome::Gdk3::EventOwnerChange** events will be sent when the owner of a selection changes.

Returns: whether **Gnome::Gdk3::EventOwnerChange** events will be sent.

Since: 2.6

    method gdk_display_supports_selection_notification ( --> Int  )

[[gdk_] display_] supports_clipboard_persistence
------------------------------------------------

Returns whether the speicifed display supports clipboard persistance; i.e. if it’s possible to store the clipboard data after an application has quit. On X11 this checks if a clipboard daemon is running.

Returns: `1` if the display supports clipboard persistance.

Since: 2.6

    method gdk_display_supports_clipboard_persistence ( --> Int  )

[[gdk_] display_] supports_shapes
---------------------------------

Returns `1` if `gdk_window_shape_combine_mask()` can be used to create shaped windows on *display*.

Returns: `1` if shaped windows are supported

Since: 2.10

    method gdk_display_supports_shapes ( --> Int  )

[[gdk_] display_] supports_input_shapes
---------------------------------------

Returns `1` if `gdk_window_input_shape_combine_mask()` can be used to modify the input shape of windows on *display*.

Returns: `1` if windows with modified input shape are supported

Since: 2.10

    method gdk_display_supports_input_shapes ( --> Int  )

[[gdk_] display_] notify_startup_complete
-----------------------------------------

Indicates to the GUI environment that the application has finished loading, using a given identifier.

GTK+ will call this function automatically for **Gnome::Gtk3::Window** with custom startup-notification identifier unless `gtk_window_set_auto_startup_notification()` is called to disable that feature.

Since: 3.0

    method gdk_display_notify_startup_complete ( Str $startup_id )

  * Str $startup_id; a startup-notification identifier, for which notification process should be completed

[[gdk_] display_] get_app_launch_context
----------------------------------------

Returns a **Gnome::Gdk3::AppLaunchContext** suitable for launching applications on the given display.

Returns: (transfer full): a new **Gnome::Gdk3::AppLaunchContext** for *display*. Free with `g_object_unref()` when done

Since: 3.0

    method gdk_display_get_app_launch_context ( --> N-GObject  )

[[gdk_] display_] get_default_seat
----------------------------------

Returns the default **Gnome::Gdk3::Seat** for this display.

Returns: (transfer none): the default seat.

Since: 3.20

    method gdk_display_get_default_seat ( --> N-GObject  )

[[gdk_] display_] list_seats
----------------------------

Returns the list of seats known to *display*.

Returns: (transfer container) (element-type **Gnome::Gdk3::Seat**): the list of seats known to the **Gnome::Gdk3::Display**

Since: 3.20

    method gdk_display_list_seats ( --> N-GList  )

[[gdk_] display_] get_n_monitors
--------------------------------

Gets the number of monitors that belong to *display*.

The returned number is valid until the next emission of the *monitor-added* or *monitor-removed* signal.

Returns: the number of monitors Since: 3.22

    method gdk_display_get_n_monitors ( --> int32  )

[[gdk_] display_] get_monitor
-----------------------------

Gets a monitor associated with this display.

Returns: (transfer none): the **Gnome::Gdk3::Monitor**, or `Any` if *monitor_num* is not a valid monitor number Since: 3.22

    method gdk_display_get_monitor ( int32 $monitor_num --> N-GObject  )

  * int32 $monitor_num; number of the monitor

[[gdk_] display_] get_primary_monitor
-------------------------------------

Gets the primary monitor for the display.

The primary monitor is considered the monitor where the “main desktop” lives. While normal application windows typically allow the window manager to place the windows, specialized desktop applications such as panels should place themselves on the primary monitor.

Returns: (transfer none): the primary monitor, or `Any` if no primary monitor is configured by the user Since: 3.22

    method gdk_display_get_primary_monitor ( --> N-GObject  )

[[gdk_] display_] get_monitor_at_point
--------------------------------------

Gets the monitor in which the point (*x*, *y*) is located, or a nearby monitor if the point is not in any monitor.

Returns: (transfer none): the monitor containing the point Since: 3.22

    method gdk_display_get_monitor_at_point ( int32 $x, int32 $y --> N-GObject  )

  * int32 $x; the x coordinate of the point

  * int32 $y; the y coordinate of the point

[[gdk_] display_] get_monitor_at_window
---------------------------------------

Gets the monitor in which the largest area of *window* resides, or a monitor close to *window* if it is outside of all monitors.

Returns: (transfer none): the monitor with the largest overlap with *window* Since: 3.22

    method gdk_display_get_monitor_at_window ( N-GObject $window --> N-GObject  )

  * N-GObject $window; a **Gnome::Gdk3::Window**

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### opened

The *opened* signal is emitted when the connection to the windowing system for *display* is opened.

    method handler (
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the object on which the signal is emitted

### closed

The *closed* signal is emitted when the connection to the windowing system for *display* is closed.

Since: 2.2

    method handler (
      Int $is_error,
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the object on which the signal is emitted

  * $is_error; `1` if the display was closed due to an error

### seat-added

The *seat-added* signal is emitted whenever a new seat is made known to the windowing system.

Since: 3.20

    method handler (
      N-GObject $seat,
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the object on which the signal is emitted

  * $seat; the native seat for Gnome::Gdk3::Seat that was just added

### seat-removed

The *seat-removed* signal is emitted whenever a seat is removed by the windowing system.

Since: 3.20

    method handler (
      N-GObject $seat,
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the object on which the signal is emitted

  * $seat; the native seat for Gnome::Gdk3::Seatthat was just removed

### monitor-added

The *monitor-added* signal is emitted whenever a monitor is added.

Since: 3.22

    method handler (
      N-GObject $monitor,
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the objedct on which the signal is emitted

  * $monitor; the native monitor Gnome::Gdk3::Monitor that was just added

### monitor-removed

The *monitor-removed* signal is emitted whenever a monitor is removed.

Since: 3.22

    method handler (
      N-GObject $monitor,
      Gnome::GObject::Object :widget($display),
      *%user-options
    );

  * $display; the object on which the signal is emitted

  * $monitor; the native monitor Gnome::Gdk3::Monitor that was just removed

