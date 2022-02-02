Gnome::Gtk3::Main
=================

Library initialization, main event loop, and events

Description
===========

Before using GTK+, you need to initialize it; initialization connects to the window system display, and parses some standard command line arguments. The `gtk_init()` macro initializes GTK+. `gtk_init()` exits the application if errors occur; to avoid this, use `gtk_init_check()`. `gtk_init_check()` allows you to recover from a failed GTK+ initialization - you might start up your application in text mode instead.

However, in these Raku Gnome packages, the initialization takes place automatically as soon as possible. It happens when an object is created which has **Gnome::GObject::Object** as its parent. It calls `init_check()` to initialize GTK+.

Like all GUI toolkits, GTK+ uses an event-driven programming model. When the user is doing nothing, GTK+ sits in the “main loop” and waits for input. If the user performs some action - say, a mouse click - then the main loop “wakes up” and delivers an event to GTK+. GTK+ forwards the event to one or more widgets.

When widgets receive an event, they frequently emit one or more “signals”. Signals notify your program that "something interesting happened" by invoking functions you’ve connected to the signal with `register-signal()` defined in **Gnome::GObject::Object**. Functions connected to a signal are often termed “callbacks” or "signal handlers".

When your callbacks are invoked, you would typically take some action - for example, when an Open button is clicked you might display a **Gnome::Gtk3::FileChooserDialog**. After a callback finishes, GTK+ will return to the main loop and await more user input.

Typical MAIN function for simple GTK+ applications
--------------------------------------------------

    # Set up signal handlers
    class SigHandlers {
      …
    }

    sub MAIN ( … ) {
      my Gnome::Gtk3::Window $top-window .= new;
      $top-window.set-title('My Application Window');

      # Expand $top-window with other GUI elements
      …

      # Register signal handlers
      …

      # Show all of the GUI and start event loop
      $top-window.show-all;
      Gnome::Gtk3::Main.new.main;

      # Event loop finished, exit program
    }

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Main;

Example
-------

    # Setup user interface
    …
    # Start main loop
    Gnome::Gtk3::Main.new.main;

    # Elsewhere in some exit handler
    method exit ( ) {
      Gnome::Gtk3::Main.new.quit;
    }

Methods
=======

new
---

Create a GtkMain object.

    submethod BUILD ( )

do-event
--------

Processes a single GDK event.

This is public only to allow filtering of events between GDK and GTK+. You will not usually need to call this function directly.

While you should not call this function directly, you might want to know how exactly events are handled. So here is what this function does with the event:

1. Compress enter/leave notify events. If the event passed build an enter/leave pair together with the next event (peeked from GDK), both events are thrown away. This is to avoid a backlog of (de-)highlighting widgets crossed by the pointer.

2. Find the widget which got the event. If the widget can’t be determined the event is thrown away unless it belongs to a INCR transaction.

3. Then the event is pushed onto a stack so you can query the currently handled event with `current-event()`.

4. The event is sent to a widget. If a grab is active all events for widgets that are not in the contained in the grab widget are sent to the latter with a few exceptions:

  * Deletion and destruction events are still sent to the event widget for obvious reasons.

  * Events which directly relate to the visual representation of the event widget.

  * Leave events are delivered to the event widget if there was an enter event delivered to it before without the paired leave event.

  * Drag events are not redirected because it is unclear what the semantics of that would be.

5. After finishing the delivery the event is popped from the event stack.

    method do-event ( N-GdkEvent $event )

  * N-GdkEvent $event; An event to process (normally passed by GDK)

check-version
-------------

Checks that the GTK+ library in use is compatible with the given version. Generally you would pass in the constants **GTK-MAJOR-VERSION**, **GTK-MINOR-VERSION**, **GTK-MICRO-VERSION** as the three arguments to this function; that produces a check that the library in use is compatible with the version of GTK+ the application or module was compiled against.

Compatibility is defined by two things: first the version of the running library is newer than the version *$required-major*.required-minor.*$required-micro*. Second the running library must be binary compatible with the version *$required-major*.required-minor.*$required-micro* (same major version.)

This function is primarily for GTK+ modules; the module can call this function to check that it wasn’t loaded into an incompatible version of GTK+. However, such a check isn’t completely reliable, since the module may be linked against an old version of GTK+ and calling the old version of `gtk-check-version()`, but still get loaded into an application using a newer version of GTK+.

Returns: `undefined` if the GTK+ library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GTK+ and should not be modified or freed.

    method check-version (
      UInt $required_major, UInt $required_minor,
      UInt $required_micro
      --> Str
    )

  * UInt $required_major; the required major version

  * UInt $required_minor; the required minor version

  * UInt $required_micro; the required micro version

device-grab-add
---------------

Adds a GTK+ grab on *device*, so all the events on *device* and its associated pointer or keyboard (if any) are delivered to *widget*. If the *block-others* parameter is `True`, any other devices will be unable to interact with *widget* during the grab.

    method device-grab-add (
      N-GObject $widget, N-GObject $device, Bool $block_others
    )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * N-GObject $device; a **Gnome::Gdk3::Device** to grab on.

  * Int $block_others; `True` to prevent other devices to interact with *widget*.

device-grab-remove
------------------

Removes a device grab from the given widget.

You have to pair calls to `device-grab-add()` and `device-grab-remove()`.

    method device-grab-remove ( N-GObject $widget, N-GObject $device )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * N-GObject $device; a **Gnome::Gdk3::Device**

disable-setlocale
-----------------

Prevents `init()`, `init-check()`, `init-with-args()` and `parse-args()` from automatically calling `setlocale (LC-ALL, "")`. You would want to use this function if you wanted to set the locale for your program to something other than the user’s locale, or if you wanted to set different values for different locale categories.

Most programs should not need to call this function.

    method disable-setlocale ( )

events-pending
--------------

Checks if any events are pending.

This can be used to update the UI and invoke timeouts etc. while doing some time intensive computation.

### Example updating the UI during a long computation

    # computation going on …

    while ( $main.events-pending ) {
      $main.iteration;
    }

    # … computation continued

Returns: `True` if any events are pending, `False` otherwise

    method events-pending ( --> Bool )

get-current-event
-----------------

Obtains a copy of the event currently being processed by GTK+.

For example, if you are handling a *clicked* signal, the current event will be the **Gnome::Gdk3::EventButton** that triggered the *clicked* signal.

Returns: a copy of the current event, or `undefined` if there is no current event.

    method get-current-event ( --> N-GdkEvent )

get-current-event-device
------------------------

If there is a current event and it has a device, return that device, otherwise return an invalid object.

    method get-current-event-device ( --> Gnome::Gdk3::Device )

get-current-event-state
-----------------------

If there is a current event and it has a state field, place that state field in *state* and return `True`, otherwise return `False`.

Returns: `True` if there was a current event and it had a state field

    method get-current-event-state ( GdkModifierType $state --> Bool )

  * GdkModifierType $state; (out): a location to store the state of the current event

get-current-event-time
----------------------

If there is a current event and it has a timestamp, return that timestamp, otherwise return `GDK-CURRENT-TIME`.

    method get-current-event-time ( --> UInt )

get-event-widget
----------------

If *$event* is `undefined` or the event was not associated with any widget, returns an invalid object, otherwise returns the widget that received the event originally.

Returns: the widget that originally received *$event*

    method get-event-widget ( N-GdkEvent $event --> Gnome::Gdk3::Events )

  * N-GdkEvent $event; a **Gnome::Gdk3::Events**

get-locale-direction
--------------------

Get the direction of the current locale. This is the expected reading direction for text and UI.

This function depends on the current locale being set with `setlocale()` and will default to setting the `GTK-TEXT-DIR-LTR` direction otherwise. `GTK-TEXT-DIR-NONE` will never be returned.

GTK+ sets the default text direction according to the locale during `init()`, and you should normally use `Gnome::Gtk3::Widget.get-direction()` or `Gnome::Gtk3::Widget.get-default-direction()` to obtain the current direcion.

This function is only needed in rare cases when the locale is changed after GTK+ has already been initialized. In this case, you can use it to update the default text direction as follows:

Returns: the **Gnome::Gtk3::TextDirection** of the current locale

    method get-locale-direction ( --> GtkTextDirection )

grab-add
--------

Makes *$widget* the current grabbed widget.

This means that interaction with other widgets in the same application is blocked and mouse as well as keyboard events are delivered to this widget.

If *$widget* is not sensitive, it is not set as the current grabbed widget and this function does nothing.

    method grab-add ( N-GObject $widget )

  * N-GObject $widget; The widget that grabs keyboard and pointer events

grab-get-current
----------------

Queries the current grab of the default window group.

Returns: The widget which currently has the grab or `undefined` if no grab is active

    method grab-get-current ( --> N-GObject )

grab-remove
-----------

Removes the grab from the given widget.

You have to pair calls to `grab-add()` and `grab-remove()`.

If *$widget* does not have the grab, this function does nothing.

    method grab-remove ( N-GObject $widget )

  * N-GObject $widget; The widget which gives up the grab

init
----

Call this function before using any other GTK+ functions in your GUI applications. It will initialize everything needed to operate the toolkit and parses some standard command line options.

There are no arguments to this function because Raku has its commandline arguments in @*ARGS. That array will be adjusted after this call if needed.

Note that initialization, using `init-check()`, takes place automatically when **Gnome::GObject::Object** is initialized. That class is inherited by almost all classes.

This function will terminate your program if it was unable to initialize the windowing system for some reason. If you want your program to fall back to a textual interface you want to call `init-check()` instead.

    method init ( )

init-check
----------

This function does the same work as `init()` with only a single change: It does not terminate the program if the commandline arguments couldn’t be parsed or the windowing system can’t be initialized. Instead it returns `False` on failure.

This way the application can fall back to some other means of communication with the user - for example a curses or command line interface.

Returns: `True` if the commandline arguments (if any) were valid and the windowing system has been successfully initialized, `False` otherwise.

    method init-check ( --> Bool )

main
----

Runs the main loop until `quit()` is called.

You can nest calls to `main()`. In that case `quit()` will make the innermost invocation of the main loop return.

    method main ( )

propagate-event
---------------

Sends an event to a widget, propagating the event to parent widgets if the event remains unhandled.

Events received by GTK+ from GDK normally begin in `do-event()`. Depending on the type of event, existence of modal dialogs, grabs, etc., the event may be propagated; if so, this function is used.

`propagate-event()` calls `Gnome::Gtk3::Widget.event()` on each widget it decides to send the event to. So `widget-event()` is the lowest-level function; it simply emits the *event* and possibly an event-specific signal on a widget. `propagate-event()` is a bit higher-level, and `main-do-event()` is the highest level.

All that said, you most likely don’t want to use any of these functions; synthesizing events is rarely needed. There are almost certainly better ways to achieve your goals. For example, use `Gnome::Gdk3::Window.invalidate-rect()` or `Gnome::Gtk3::Widget.queue-draw()` instead of making up expose events.

    method propagate-event ( N-GObject $widget, N-GdkEvent $event )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * N-GdkEvent $event; an event

iteration
---------

Runs a single iteration of the mainloop.

If no events are waiting to be processed GTK+ will block until the next event is noticed. If you don’t want to block look at `iteration-do()` or check if any events are pending with `events-pending()` first.

Returns: `True` if `quit()` has been called for the innermost mainloop

    method iteration ( --> Bool )

iteration-do
------------

Runs a single iteration of the mainloop. If no events are available either return or block depending on the value of *blocking*.

Returns: `True` if `quit()` has been called for the innermost mainloop

    method iteration-do ( Int $blocking --> Bool )

  * Int $blocking; `True` if you want GTK+ to block if no events are pending

level
-----

Asks for the current nesting level of the main loop.

Returns: the nesting level of the current invocation of the main loop

    method level ( --> UInt )

quit
----

Makes the innermost invocation of the main loop return when it regains control.

    method quit ( )

