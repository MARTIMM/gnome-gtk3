Gnome::Gtk3::Main
=================

Library initialization, main event loop, and events

Description
===========

Before using GTK+, you need to initialize it; initialization connects to the window system display, and parses some standard command line arguments. The `gtk_init()` macro initializes GTK+. `gtk_init()` exits the application if errors occur; to avoid this, use `gtk_init_check()`. `gtk_init_check()` allows you to recover from a failed GTK+ initialization - you might start up your application in text mode instead.

However, in these Gnome packages the initialization takes place automatically as soon as possible. It happens when an object is created which has **Gnome::GObject::Object** as its parent. It calls `gtk_init_check()` to initialize GTK+. If other actions are needed before using GTK, it is necessary to inititialize by hand. This will be as easy as instatiating this class;

    my Gnome::Gtk3::Main .= new;

Like all GUI toolkits, GTK+ uses an event-driven programming model. When the user is doing nothing, GTK+ sits in the “main loop” and waits for input. If the user performs some action - say, a mouse click - then the main loop “wakes up” and delivers an event to GTK+. GTK+ forwards the event to one or more widgets.

When widgets receive an event, they frequently emit one or more “signals”. Signals notify your program that "something interesting happened" by invoking functions you’ve connected to the signal with `g_signal_connect()`. Functions connected to a signal are often termed “callbacks”.

When your callbacks are invoked, you would typically take some action - for example, when an Open button is clicked you might display a **Gnome::Gtk3::FileChooserDialog**. After a callback finishes, GTK+ will return to the main loop and await more user input.

Typical MAIN function for a GTK+ application
--------------------------------------------

    # Set up signal handlers
    class SigHandlers {
      ...
    }

    sub MAIN ( ... ) {
      my Gnome::Gtk3::Window $top-window .= new(:title('My Application Window'));

      # Set up our GUI elements
      ...

      # Register signal handlers
      ...

      $top-window.show-all;

      # Start event loop
      Gnome::Gtk3::Main.new.gtk-main;

      # Event loop finished, exit program
    }

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Main;

Example
-------

    my Gnome::Gtk3::Main $main .= new;

    # Setup user interface
    ...
    # Start main loop
    $main.gtk-main;

    # Elsewhere in some exit handler
    method exit ( ) {
      Gnome::Gtk3::Main.new.gtk-main-quit;
    }

Methods
=======

new
---

Create a GtkMain object. Initialization of GTK is automatically executed if not already done. Arguments from the command line are provided to this process.

    submethod BUILD ( Bool :$check = False )

  * $check; Use checked initialization. Program will not fail when commandline arguments do not parse properly.

[gtk_] check_version
--------------------

Checks that the GTK+ library in use is compatible with the given version. Generally you would pass in the constants **GTK_MAJOR_VERSION**, **GTK_MINOR_VERSION**, **GTK_MICRO_VERSION** as the three arguments to this function; that produces a check that the library in use is compatible with the version of GTK+ the application or module was compiled against.

Compatibility is defined by two things: first the version of the running library is newer than the version *required_major*.required_minor.*required_micro*. Second the running library must be binary compatible with the version *required_major*.required_minor.*required_micro* (same major version.)

This function is primarily for GTK+ modules; the module can call this function to check that it wasn’t loaded into an incompatible version of GTK+. However, such a check isn’t completely reliable, since the module may be linked against an old version of GTK+ and calling the old version of `gtk_check_version()`, but still get loaded into an application using a newer version of GTK+.

Returns: (nullable): `Any` if the GTK+ library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GTK+ and should not be modified or freed.

    method gtk_check_version (
      UInt $required_major, UInt $required_minor,
      UInt $required_micro
      --> Str
    )

  * UInt $required_major; the required major version

  * UInt $required_minor; the required minor version

  * UInt $required_micro; the required micro version

[gtk_] parse_args
-----------------

Parses command line arguments, and initializes global attributes of GTK+, but does not actually open a connection to a display. (See `gdk_display_open()`, `gdk_get_display_arg_name()`)

Any arguments used by GTK+ or GDK are removed from the array and *argc* and *argv* are updated accordingly.

There is no need to call this function explicitly if you are using `gtk_init()`, or `gtk_init_check()`.

Note that many aspects of GTK+ require a display connection to function, so this way of initializing GTK+ is really only useful for specialized use cases.

Returns: `1` if initialization succeeded, otherwise `0`

    method gtk_parse_args ( int32 $argc, CArray[Str] $argv --> Int  )

  * int32 $argc; (inout): a pointer to the number of command line arguments

  * CArray[Str] $argv; (array length=argc) (inout): a pointer to the array of command line arguments

[gtk_] init
-----------

Call this function before using any other GTK+ functions in your GUI applications. It will initialize everything needed to operate the toolkit and parses some standard command line options.

Although you are expected to pass the *argc*, *argv* parameters from `main()` to this function, it is possible to pass `Any` if *argv* is not available or commandline handling is not required.

*argc* and *argv* are adjusted accordingly so your own code will never see those standard arguments.

Note that there are some alternative ways to initialize GTK+: if you are calling `gtk_parse_args()`, `gtk_init_check()`, `gtk_init_with_args()` or `g_option_context_parse()` with the option group returned by `gtk_get_option_group()`, you don’t have to call `gtk_init()`.

And if you are using **Gnome::Gtk3::Application**, you don't have to call any of the initialization functions either; the *startup* handler does it for you.

This function will terminate your program if it was unable to initialize the windowing system for some reason. If you want your program to fall back to a textual interface you want to call `gtk_init_check()` instead.

Since 2.18, GTK+ calls `signal (SIGPIPE, SIG_IGN)` during initialization, to ignore SIGPIPE signals, since these are almost never wanted in graphical applications. If you do need to handle SIGPIPE for some reason, reset the handler after `gtk_init()`, but notice that other libraries (e.g. libdbus or gvfs) might do similar things.

    method gtk_init ( int32 $argc, CArray[CArray[Str]] $argv )

  * CArray[int32] $argc; (inout): Address of the `argc` parameter of your `main()` function (or 0 if *argv* is `Any`). This will be changed if any arguments were handled.

  * CArray[CArray[Str]] $argv; (array length=argc) (inout) (allow-none): Address of the `argv` parameter of `main()`, or `Any`. Any options understood by GTK+ are stripped before return.

[gtk_] init_check
-----------------

This function does the same work as `gtk_init()` with only a single change: It does not terminate the program if the windowing system can’t be initialized. Instead it returns `0` on failure.

This way the application can fall back to some other means of communication with the user - for example a curses or command line interface.

Returns: `1` if the windowing system has been successfully initialized, `0` otherwise

    method gtk_init_check ( CArray[int32] $argc, CArray[CArray[Str]] $argv --> Int  )

  * CArray[int32] $argc; (inout): Address of the `argc` parameter of your `main()` function (or 0 if *argv* is `Any`). This will be changed if any arguments were handled.

  * CArray[CArray[Str]] $argv; (array length=argc) (inout) (allow-none): Address of the `argv` parameter of `main()`, or `Any`. Any options understood by GTK+ are stripped before return.

[gtk_] get_option_group
-----------------------

Returns a **N-GOptionGroup** for the commandline arguments recognized by GTK+ and GDK.

You should add this group to your **N-GOptionContext** with `g_option_context_add_group()`, if you are using `g_option_context_parse()` to parse your commandline arguments.

Returns: a **N-GOptionGroup** for the commandline arguments recognized by GTK+

Since: 2.6

    method gtk_get_option_group ( Int $open_default_display --> N-GOptionGroup  )

  * Int $open_default_display; whether to open the default display when parsing the commandline arguments

[gtk_] disable_setlocale
------------------------

Prevents `gtk_init()`, `gtk_init_check()`, `gtk_init_with_args()` and `gtk_parse_args()` from automatically calling `setlocale (LC_ALL, "")`. You would want to use this function if you wanted to set the locale for your program to something other than the user’s locale, or if you wanted to set different values for different locale categories.

Most programs should not need to call this function.

    method gtk_disable_setlocale ( )

[gtk_] get_locale_direction
---------------------------

Get the direction of the current locale. This is the expected reading direction for text and UI.

This function depends on the current locale being set with `setlocale()` and will default to setting the `GTK_TEXT_DIR_LTR` direction otherwise. `GTK_TEXT_DIR_NONE` will never be returned.

GTK+ sets the default text direction according to the locale during `gtk_init()`, and you should normally use `gtk_widget_get_direction()` or `gtk_widget_get_default_direction()` to obtain the current direcion.

This function is only needed rare cases when the locale is changed after GTK+ has already been initialized. In this case, you can use it to update the default text direction as follows:

|[<!-- language="C" --> setlocale (LC_ALL, new_locale); direction = `gtk_get_locale_direction()`; gtk_widget_set_default_direction (direction); ]|

Returns: the **Gnome::Gtk3::TextDirection** of the current locale

Since: 3.12

    method gtk_get_locale_direction ( --> GtkTextDirection  )

[gtk_] events_pending
---------------------

Checks if any events are pending.

This can be used to update the UI and invoke timeouts etc. while doing some time intensive computation.

## Updating the UI during a long computation

|[<!-- language="C" --> // computation going on...

while (`gtk_events_pending()`) `gtk_main_iteration()`;

// ...computation continued ]|

Returns: `1` if any events are pending, `0` otherwise

    method gtk_events_pending ( --> Int  )

[[gtk_] main_] do_event
-----------------------

Processes a single GDK event.

This is public only to allow filtering of events between GDK and GTK+. You will not usually need to call this function directly.

While you should not call this function directly, you might want to know how exactly events are handled. So here is what this function does with the event:

1. Compress enter/leave notify events. If the event passed build an enter/leave pair together with the next event (peeked from GDK), both events are thrown away. This is to avoid a backlog of (de-)highlighting widgets crossed by the pointer.

2. Find the widget which got the event. If the widget can’t be determined the event is thrown away unless it belongs to a INCR transaction.

3. Then the event is pushed onto a stack so you can query the currently handled event with `gtk_get_current_event()`.

4. The event is sent to a widget. If a grab is active all events for widgets that are not in the contained in the grab widget are sent to the latter with a few exceptions: - Deletion and destruction events are still sent to the event widget for obvious reasons. - Events which directly relate to the visual representation of the event widget. - Leave events are delivered to the event widget if there was an enter event delivered to it before without the paired leave event. - Drag events are not redirected because it is unclear what the semantics of that would be. Another point of interest might be that all key events are first passed through the key snooper functions if there are any. Read the description of `gtk_key_snooper_install()` if you need this feature.

5. After finishing the delivery the event is popped from the event stack.

    method gtk_main_do_event ( GdkEvent $event )

  * GdkEvent $event; An event to process (normally passed by GDK)

[[gtk_] main_] gtk_main
-----------------------

Runs the main loop until `gtk_main_quit()` is called.

You can nest calls to `gtk_main()`. In that case `gtk_main_quit()` will make the innermost invocation of the main loop return.

    method gtk_main ( )

[gtk_] main_level
-----------------

Asks for the current nesting level of the main loop.

Returns: the nesting level of the current invocation of the main loop

    method gtk_main_level ( --> UInt  )

[gtk_] main_quit
----------------

Makes the innermost invocation of the main loop return when it regains control.

    method gtk_main_quit ( )

[gtk_] main_iteration
---------------------

Runs a single iteration of the mainloop.

If no events are waiting to be processed GTK+ will block until the next event is noticed. If you don’t want to block look at `gtk_main_iteration_do()` or check if any events are pending with `gtk_events_pending()` first.

Returns: `1` if `gtk_main_quit()` has been called for the innermost mainloop

    method gtk_main_iteration ( --> Int  )

[[gtk_] main_] iteration_do
---------------------------

Runs a single iteration of the mainloop. If no events are available either return or block depending on the value of *blocking*.

Returns: `1` if `gtk_main_quit()` has been called for the innermost mainloop

    method gtk_main_iteration_do ( Int $blocking --> Int  )

  * Int $blocking; `1` if you want GTK+ to block if no events are pending

[gtk_] grab_add
---------------

Makes *widget* the current grabbed widget.

This means that interaction with other widgets in the same application is blocked and mouse as well as keyboard events are delivered to this widget.

If *widget* is not sensitive, it is not set as the current grabbed widget and this function does nothing.

    method gtk_grab_add ( N-GObject $widget )

  * N-GObject $widget; The widget that grabs keyboard and pointer events

[gtk_] grab_get_current
-----------------------

Queries the current grab of the default window group.

Returns: (transfer none) (nullable): The widget which currently has the grab or `Any` if no grab is active

    method gtk_grab_get_current ( --> N-GObject  )

[gtk_] grab_remove
------------------

Removes the grab from the given widget.

You have to pair calls to `gtk_grab_add()` and `gtk_grab_remove()`.

If *widget* does not have the grab, this function does nothing.

    method gtk_grab_remove ( N-GObject $widget )

  * N-GObject $widget; The widget which gives up the grab

[gtk_] device_grab_add
----------------------

Adds a GTK+ grab on *device*, so all the events on *device* and its associated pointer or keyboard (if any) are delivered to *widget*. If the *block_others* parameter is `1`, any other devices will be unable to interact with *widget* during the grab.

Since: 3.0

    method gtk_device_grab_add ( N-GObject $widget, N-GObject $device, Int $block_others )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * N-GObject $device; a **Gnome::Gdk3::Device** to grab on.

  * Int $block_others; `1` to prevent other devices to interact with *widget*.

[gtk_] device_grab_remove
-------------------------

Removes a device grab from the given widget.

You have to pair calls to `gtk_device_grab_add()` and `gtk_device_grab_remove()`.

Since: 3.0

    method gtk_device_grab_remove ( N-GObject $widget, N-GObject $device )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * N-GObject $device; a **Gnome::Gdk3::Device**

[gtk_] get_current_event
------------------------

Obtains a copy of the event currently being processed by GTK+.

For example, if you are handling a *clicked* signal, the current event will be the **Gnome::Gdk3::EventButton** that triggered the *clicked* signal.

Returns: (transfer full) (nullable): a copy of the current event, or `Any` if there is no current event. The returned event must be freed with `gdk_event_free()`.

    method gtk_get_current_event ( --> GdkEvent  )

[gtk_] get_current_event_time
-----------------------------

If there is a current event and it has a timestamp, return that timestamp, otherwise return `GDK_CURRENT_TIME`.

Returns: the timestamp from the current event, or `GDK_CURRENT_TIME`.

    method gtk_get_current_event_time ( --> UInt  )

[gtk_] get_current_event_state
------------------------------

If there is a current event and it has a state field, place that state field in *state* and return `1`, otherwise return `0`.

Returns: `1` if there was a current event and it had a state field

    method gtk_get_current_event_state ( GdkModifierType $state --> Int  )

  * GdkModifierType $state; (out): a location to store the state of the current event

[gtk_] get_current_event_device
-------------------------------

If there is a current event and it has a device, return that device, otherwise return `Any`.

Returns: (transfer none) (nullable): a **Gnome::Gdk3::Device**, or `Any`

    method gtk_get_current_event_device ( --> N-GObject  )

[gtk_] get_event_widget
-----------------------

If *event* is `Any` or the event was not associated with any widget, returns `Any`, otherwise returns the widget that received the event originally.

Returns: (transfer none) (nullable): the widget that originally received *event*, or `Any`

    method gtk_get_event_widget ( GdkEvent $event --> N-GObject  )

  * GdkEvent $event; a **Gnome::Gdk3::Event**

[gtk_] propagate_event
----------------------

Sends an event to a widget, propagating the event to parent widgets if the event remains unhandled.

Events received by GTK+ from GDK normally begin in `gtk_main_do_event()`. Depending on the type of event, existence of modal dialogs, grabs, etc., the event may be propagated; if so, this function is used.

`gtk_propagate_event()` calls `gtk_widget_event()` on each widget it decides to send the event to. So `gtk_widget_event()` is the lowest-level function; it simply emits the *event* and possibly an event-specific signal on a widget. `gtk_propagate_event()` is a bit higher-level, and `gtk_main_do_event()` is the highest level.

All that said, you most likely don’t want to use any of these functions; synthesizing events is rarely needed. There are almost certainly better ways to achieve your goals. For example, use `gdk_window_invalidate_rect()` or `gtk_widget_queue_draw()` instead of making up expose events.

    method gtk_propagate_event ( N-GObject $widget, GdkEvent $event )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * GdkEvent $event; an event

