Gnome::Gio::AppLaunchContext
============================

Application information and launch contexts

Description
===========

    B<Gnome::Gio::AppInfo> and B<Gnome::Gio::AppLaunchContext> are used for describing and launching applications installed on the system.

See Also
--------

**Gnome::Gio::AppInfo** and **Gnome::Gio::AppInfoMonitor**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::AppLaunchContext;
    also is Gnome::GObject::Object;

Methods
=======

new
---

### default, no options

Create a new AppLaunchContext object.

    multi method new ( )

### :native-object

Create a AppLaunchContext object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a AppLaunchContext object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-display
-----------

Gets the display string for the *context*. This is used to ensure new applications are started on the same display as the launching application, by setting the `DISPLAY` environment variable.

Returns: a display string for the display.

    method get-display ( N-GObject $info, N-GList $files --> Str )

  * N-GObject $info; a **Gnome::Gio::AppInfo**

  * N-GList $files; (element-type GFile): a **Gnome::Gio::List** of **Gnome::Gio::File** objects

get-environment
---------------

Gets the complete environment variable list to be passed to the child process when *context* is used to launch an application. This is a `undefined`-terminated array of strings, where each string has the form `KEY=VALUE`.

Returns: (element-type filename) : the child's environment

    method get-environment ( --> CArray[Str] )

get-startup-notify-id
---------------------

Initiates startup notification for the application and returns the `DESKTOP-STARTUP-ID` for the launched operation, if supported.

Startup notification IDs are defined in the [FreeDesktop.Org Startup Notifications standard](http://standards.freedesktop.org/startup-notification-spec/startup-notification-latest.txt").

Returns: a startup notification ID for the application, or `undefined` if not supported.

    method get-startup-notify-id ( N-GObject $info, N-GList $files --> Str )

  * N-GObject $info; a **Gnome::Gio::AppInfo**

  * N-GList $files; (element-type GFile): a **Gnome::Gio::List** of of **Gnome::Gio::File** objects

launch-failed
-------------

Called when an application has failed to launch, so that it can cancel the application startup notification started in `get-startup-notify-id()`.

    method launch-failed ( Str $startup_notify_id )

  * Str $startup_notify_id; the startup notification id that was returned by `get-startup-notify-id()`.

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

### launch-failed

The *launch-failed* signal is emitted when a **Gnome::Gio::AppInfo** launch fails. The startup notification id is provided, so that the launcher can cancel the startup notification.

    method handler (
      Str $startup_notify_id,
      Int :$_handle_id,
      Gnome::Gio::AppLaunchContext :_widget($context),
      *%user-options
    );

  * Gnome::Gio::AppLaunchContext $context; the object emitting the signal

  * $startup_notify_id; the startup notification id for the failed launch

  * $_handle_id; the registered event handler id

### launched

The *launched* signal is emitted when a **Gnome::Gio::AppInfo** is successfully launched. The *platform-data* is an GVariant dictionary mapping strings to variants (ie a{sv}), which contains additional, platform-specific data about this launch. On UNIX, at least the "pid" and "startup-notification-id" keys will be present.

    method handler (
      N-GObject $info,
      N-GObject $platform_data,
      Int :$_handle_id,
      Gnome::Gio::AppLaunchContext :_widget($context),
      *%user-options
    );

  * Gnome::Gio::AppLaunchContext $context; the object emitting the signal

  * N-GObject $info; the **Gnome::Gio::AppInfo** that was just launched

  * N-GObject $platform_data; additional platform-specific data for this launch. This is a native **Gnome::Glib::Variant**.

  * $_handle_id; the registered event handler id

