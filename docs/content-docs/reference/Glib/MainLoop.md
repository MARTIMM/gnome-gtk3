Gnome::Glib::MainLoop
=====================

The Main Event Loop — manages all available sources of events

Description
===========

Note that this is a low level module, please take a look at **Gnome::Gtk3::Main** first.

The main event loop manages all the available sources of events for GLib and GTK+ applications. These events can come from any number of different types of sources such as file descriptors (plain files, pipes or sockets) and timeouts.

To allow multiple independent sets of sources to be handled in different threads, each source is associated with a *MainContext*. A *MainContext* can only be running in a single thread, but sources can be added to it and removed from it from other threads. All functions which operate on a *MainContext* or a built-in N-GSource are thread-safe. Contexts are described by **Gnome::Gio::MainContext**

Each event source is assigned a priority. The default priority, G_PRIORITY_DEFAULT, is 0. Values less than 0 denote higher priorities. Values greater than 0 denote lower priorities. Events from high priority sources are always processed before events from lower priority sources.

The *MainLoop* data type represents a main event loop. A *MainLoop* is created with `new()` or `new(:context)`. After adding the initial event sources, `run()` is called. This continuously checks for new events from each of the event sources and dispatches them. Finally, the processing of an event from one of the sources leading to a call to `quit()` will exit the main loop, and `run()` returns.

It is possible to create new instances of *MainLoop* recursively. This is often used in GTK+ applications when showing modal dialog boxes. Note that event sources are associated with a particular *MainContext*, and will be checked and dispatched for all main loops associated with that *MainContext*.

GTK+ contains wrappers of some of these functions, e.g. gtk_main(), gtk_main_quit() and gtk_events_pending().

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::MainLoop;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

Constants
---------

  * G_PRIORITY_HIGH; Use this for high priority event sources. It is not used within GLib or GTK+.

  * G_PRIORITY_DEFAULT; Use this for default priority event sources. In GLib this priority is used when adding timeout functions with g_timeout_add(). In GDK this priority is used for events from the X server.

  * G_PRIORITY_HIGH_IDLE; Use this for high priority idle functions. GTK+ uses G_PRIORITY_HIGH_IDLE + 10 for resizing operations, and G_PRIORITY_HIGH_IDLE + 20 for redrawing operations. (This is done to ensure that any pending resizes are processed before any pending redraws, so that widgets are not redrawn twice unnecessarily.)

  * G_PRIORITY_DEFAULT_IDLE; Use this for default priority idle functions. In GLib this priority is used when adding idle functions with g_idle_add().

  * G_PRIORITY_LOW; Use this for very low priority background tasks. It is not used within GLib or GTK+.

  * G_SOURCE_REMOVE; Use this macro as the return value of a callback handler to leave the GSource in the main loop.

  * G_SOURCE_CONTINUE; Use this macro as the return value of a callback handler to remove the GSource from the main loop.

Methods
=======

new
---

### default, no options

Create a new Main object depending on the default context.

    multi method new ( )

### :context

Create a new Main object depending on provided context.

    multi method new ( :context! )

get-context
-----------

Returns the **Gnome::Glib::MainContext** of *loop*.

    method get-context ( --> Gnome::Glib::MainContext )

is-running
----------

Checks to see if the main loop is currently being run via `run()`.

Returns: `True` if the mainloop is currently being run.

    method is-running ( --> Bool )

quit
----

Stops a **Gnome::Glib::MainLoop** from running. Any calls to `run()` for the loop will return.

Note that sources that have already been dispatched when `quit()` is called will still be executed.

    method quit ( )

run
---

Runs a main loop until `quit()` is called on the loop. If this is called for the thread of the loop's **Gnome::Glib::MainContext**, it will process events from the loop, otherwise it will simply wait.

    method run ( )

