Gnome::Gio::AppInfoMonitor
==========================

Monitor application information for changes

Description
===========

**Gnome::Gio::AppInfoMonito**r is a very simple object used for monitoring the app info database for changes (ie: newly installed or removed applications). Call `Gnome::Gio::AppInfo.monitor_get()` to get a **Gnome::Gio::AppInfoMonitor** and connect to the "changed" signal.

In the usual case, applications should try to make note of the change (doing things like invalidating caches) but not act on it. In particular, applications should avoid making calls to **Gnome::Gio::AppInfo** APIs in response to the change signal, deferring these until the time that the data is actually required. The exception to this case is when application information is actually being displayed on the screen (eg: during a search or when the list of all applications is shown). The reason for this is that changes to the list of installed applications often come in groups (like during system updates) and rescanning the list on every change is pointless and expensive.

See Also
--------

**Gnome::Gio::AppInfo**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::AppInfoMonitor;
    also is Gnome::GObject::Object

Uml Diagram
-----------

![](plantuml/AppInfo.svg)

Methods
=======

new
---

### default, no options

Creates the **Gnome::Gio::AppInfoMonitor** for the current thread-default main context.

The **Gnome::Gio::AppInfoMonitor** will emit a "changed" signal in the thread-default main context whenever the list of installed applications (as reported by `Gnome::Gio::AppInfo.get-all()`) may have changed.

You must only call `.clear-object()` on the return value from under the same main context as you created it.

    multi method new ( )

### :native-object

Create a AppInfoMonitor object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

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

### changed

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($appinfomonitor),
      *%user-options
    );

  * $appinfomonitor; the registered info moditor object

  * $_handle_id; the registered event handler id

