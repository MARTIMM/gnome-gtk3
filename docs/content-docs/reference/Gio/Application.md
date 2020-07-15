Gnome::Gio::Application
=======================

Core application class

Description
===========

A **Gnome::Gio::Application** is the foundation of an application. It wraps some low-level platform-specific services and is intended to act as the foundation for higher-level application classes such as **Gnome::Gtk3::Application** or **MxApplication**. In general, you should not use this class outside of a higher level framework.

Gnome::Gio::Application provides convenient life cycle management by maintaining a "use count" for the primary application instance. The use count can be changed using `g_application_hold()` and `g_application_release()`. If it drops to zero, the application exits. Higher-level classes such as **Gnome::Gtk3::Application** employ the use count to ensure that the application stays alive as long as it has any opened windows.

Another feature that Gnome::Gio::Application (optionally) provides is process uniqueness. Applications can make use of this functionality by providing a unique application ID. If given, only one application with this ID can be running at a time per session. The session concept is platform-dependent, but corresponds roughly to a graphical desktop login. When your application is launched again, its arguments are passed through platform communication to the already running program. The already running instance of the program is called the "primary instance"; for non-unique applications this is the always the current instance. On Linux, the D-Bus session bus is used for communication.

The use of **Gnome::Gio::Application** differs from some other commonly-used uniqueness libraries (such as libunique) in important ways. The application is not expected to manually register itself and check if it is the primary instance. Instead, the `main()` function of a **Gnome::Gio::Application** should do very little more than instantiating the application instance, possibly connecting signal handlers, then calling `g_application_run()`. All checks for uniqueness are done internally. If the application is the primary instance then the startup signal is emitted and the mainloop runs. If the application is not the primary instance then a signal is sent to the primary instance and `g_application_run()` promptly returns. See the code examples below.

If used, the expected form of an application identifier is the same as that of of a [D-Bus well-known bus name](https://dbus.freedesktop.org/doc/dbus-specification.html#message-protocol-names-bus). Examples include: `com.example.MyApp`, `org.example.internal_apps.Calculator`, `org._7_zip.Archiver`. For details on valid application identifiers, see `g_application_id_is_valid()`.

On Linux, the application identifier is claimed as a well-known bus name on the user's session bus. This means that the uniqueness of your application is scoped to the current session. It also means that your application may provide additional services (through registration of other object paths) at that bus name. The registration of these object paths should be done with the shared GDBus session bus. Note that due to the internal architecture of GDBus, method calls can be dispatched at any time (even if a main loop is not running). For this reason, you must ensure that any object paths that you wish to register are registered before **Gnome::Gio::Application** attempts to acquire the bus name of your application (which happens in `g_application_register()`). Unfortunately, this means that you cannot use `g_application_get_is_remote()` to decide if you want to register object paths.

Gnome::Gio::Application also implements the **GActionGroup** and **GActionMap** interfaces and lets you easily export actions by adding them with `g_action_map_add_action()`. When invoking an action by calling `g_action_group_activate_action()` on the application, it is always invoked in the primary instance. The actions are also exported on the session bus, and GIO provides the **GDBusActionGroup** wrapper to conveniently access them remotely. GIO provides a **GDBusMenuModel** wrapper for remote access to exported **GMenuModels**.

There is a number of different entry points into a Gnome::Gio::Application:

- via 'Activate' (i.e. just starting the application)

- via 'Open' (i.e. opening some files)

- by handling a command-line

- via activating an action

The *startup* signal lets you handle the application initialization for all of these in a single place.

Regardless of which of these entry points is used to start the application, Gnome::Gio::Application passes some "platform data from the launching instance to the primary instance, in the form of a **GVariant** dictionary mapping strings to variants. To use platform data, override the *before_emit* or *after_emit* virtual functions in your **Gnome::Gio::Application** subclass. When dealing with **Gnome::Gio::ApplicationCommandLine** objects, the platform data is directly available via `g_application_command_line_get_cwd()`, `g_application_command_line_get_environ()` and `g_application_command_line_get_platform_data()`.

As the name indicates, the platform data may vary depending on the operating system, but it always includes the current directory (key "cwd"), and optionally the environment (ie the set of environment variables and their values) of the calling process (key "environ"). The environment is only added to the platform data if the `G_APPLICATION_SEND_ENVIRONMENT` flag is set. **Gnome::Gio::Application** subclasses can add their own platform data by overriding the *add_platform_data* virtual function. For instance, **Gnome::Gtk3::Application** adds startup notification data in this way.

To parse commandline arguments you may handle the *command-line* signal or override the `local_command_line()` vfunc, to parse them in either the primary instance or the local instance, respectively.

For an example of opening files with a Gnome::Gio::Application, see [Gnome::Gio::Application-example-open.c](https://git.gnome.org/browse/glib/tree/gio/tests/Gnome::Gio::Application-example-open.c).

For an example of using actions with Gnome::Gio::Application, see [Gnome::Gio::Application-example-actions.c](https://git.gnome.org/browse/glib/tree/gio/tests/Gnome::Gio::Application-example-actions.c).

For an example of using extra D-Bus hooks with Gnome::Gio::Application, see [Gnome::Gio::Application-example-dbushooks.c](https://git.gnome.org/browse/glib/tree/gio/tests/Gnome::Gio::Application-example-dbushooks.c).

Implemented Interfaces
----------------------

Gnome::Gio::Application implements

  * [Gnome::Gio::ActionMap](ActionMap.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::Application;
    also is Gnome::GObject::Object;
    also does Gnome::Gio::ActionMap;

Methods
=======

new
---

Create a new object with a valid application id and a mask of GApplicationFlags values.

    multi method new (
      Bool :$app-id!, Int :$flags = G_APPLICATION_FLAGS_NONE
    )

Create an object using a native object from elsewhere.

    multi method new ( N-GObject :$native-object! )

[g_application_] id_is_valid
----------------------------

Checks if *application_id* is a valid application identifier.

A valid ID is required for calls to `g_application_new()` and `g_application_set_application_id()`.

Application identifiers follow the same format as [D-Bus well-known bus names](https://dbus.freedesktop.org/doc/dbus-specification.html**message**-protocol-names-bus).

For convenience, the restrictions on application identifiers are reproduced here:

  * Application identifiers are composed of 1 or more elements separated by a period (`.`) character. All elements must contain at least one character.

  * Each element must only contain the ASCII characters `[A-Z][a-z][0-9]_-`, with `-` discouraged in new application identifiers. Each element must not begin with a digit.

  * Application identifiers must contain at least one `.` (period) character (and thus at least two elements).

  * Application identifiers must not begin with a `.` (period) character.

  * Application identifiers must not exceed 255 characters.

Note that the hyphen (`-`) character is allowed in application identifiers, but is problematic or not allowed in various specifications and APIs that refer to D-Bus, such as [Flatpak application IDs](http://docs.flatpak.org/en/latest/introduction.html#identifiers), the [DBusActivatable interface in the Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html**dbus**), and the convention that an application's "main" interface and object path resemble its application identifier and bus name. To avoid situations that require special-case handling, it is recommended that new application identifiers consistently replace hyphens with underscores.

Like D-Bus interface names, application identifiers should start with the reversed DNS domain name of the author of the interface (in lower-case), and it is conventional for the rest of the application identifier to consist of words run together, with initial capital letters.

As with D-Bus interface names, if the author's DNS domain name contains hyphen/minus characters they should be replaced by underscores, and if it contains leading digits they should be escaped by prepending an underscore. For example, if the owner of 7-zip.org used an application identifier for an archiving application, it might be named `org._7_zip.Archiver`.

Returns: `1` if *application_id* is valid

    method g_application_id_is_valid ( Str $application_id --> Int  )

  * Str $application_id; a potential application identifier

g_application_new
-----------------

Creates a new **Gnome::Gio::Application** instance.

If defined, the application id must be valid. See `g_application_id_is_valid()`.

If no application ID is given then some features of **Gnome::Gio::Application** (most notably application uniqueness) will be disabled.

Returns: a new **Gnome::Gio::Application** instance

    method g_application_new (
      Str $application_id, GApplicationFlags $flags --> N-GObject
    )

  * Str $application_id; (nullable): the application id

  * GApplicationFlags $flags; the application flags

[g_application_] get_application_id
-----------------------------------

Gets the unique identifier for *application*.

    method g_application_get_application_id ( --> Str  )

[g_application_] set_application_id
-----------------------------------

Sets the unique identifier for *application*. The application id can only be modified if *application* has not yet been registered. The application id must be valid, see `g_application_id_is_valid()`.

    method g_application_set_application_id ( Str $application_id )

  * Str $application_id; (nullable): the identifier for *application*

[g_application_] get_inactivity_timeout
---------------------------------------

Gets the current inactivity timeout for the application.

This is the amount of time (in milliseconds) after the last call to `g_application_release()` before the application stops running.

Returns: the timeout, in milliseconds

    method g_application_get_inactivity_timeout ( --> UInt  )

[g_application_] set_inactivity_timeout
---------------------------------------

Sets the current inactivity timeout for the application.

This is the amount of time (in milliseconds) after the last call to `g_application_release()` before the application stops running.

This call has no side effects of its own. The value set here is only used for next time `g_application_release()` drops the use count to zero. Any timeouts currently in progress are not impacted.

    method g_application_set_inactivity_timeout ( UInt $inactivity_timeout )

  * UInt $inactivity_timeout; the timeout, in milliseconds

[g_application_] get_flags
--------------------------

Gets the flags for *application*.

See **GApplicationFlags**.

    method g_application_get_flags ( --> Int )

[g_application_] set_flags
--------------------------

Sets the flags for *application*. The flags can only be modified if *application* has not yet been registered.

See **GApplicationFlags**.

    method g_application_set_flags ( Int $flags )

  * Int $flags; a mask of GApplicationFlags values

[g_application_] get_resource_base_path
---------------------------------------

Gets the resource base path of *application*.

See `g_application_set_resource_base_path()` for more information.

Returns: (nullable): the base resource path, if one is set

    method g_application_get_resource_base_path ( --> Str  )

[g_application_] set_resource_base_path
---------------------------------------

Sets (or unsets) the base resource path of *application*.

The path is used to automatically load various application resources such as menu layouts and action descriptions. The various types of resources will be found at fixed names relative to the given base path.

By default, the resource base path is determined from the application ID by prefixing '/' and replacing each '.' with '/'. This is done at the time that the **Gnome::Gio::Application** object is constructed. Changes to the application ID after that point will not have an impact on the resource base path.

As an example, if the application has an ID of "org.example.app" then the default resource base path will be "/org/example/app". If this is a **Gnome::Gtk3::Application** (and you have not manually changed the path) then the object will then search for the menus of the application at "/org/example/app/gtk/menus.ui".

See **Gnome::Gio::Resource** for more information about adding resources to your application.

You can disable automatic resource loading functionality by setting the path to `Any`.

Changing the resource base path once the application is running is not recommended. The point at which the resource path is consulted for forming paths for various purposes is unspecified. When writing a sub-class of **Gnome::Gio::Application** you should either set the *resource-base-path* property at construction time, or call this function during the instance initialization. Alternatively, you can call this function in the **Gnome::Gio::ApplicationClass**.startup virtual function, before chaining up to the parent implementation.

    method g_application_set_resource_base_path ( Str $resource_path )

  * Str $resource_path; (nullable): the resource path to use

[g_application_] add_main_option_entries
----------------------------------------

Adds main option entries to be handled by *application*.

This function is comparable to `g_option_context_add_main_entries()`.

After the commandline arguments are parsed, the *handle-local-options* signal will be emitted. At this point, the application can inspect the values pointed to by *arg_data* in the given **N-GOptionEntrys**.

Unlike **GOptionContext**, **Gnome::Gio::Application** supports giving a `Any` *arg_data* for a non-callback **N-GOptionEntry**. This results in the argument in question being packed into a **GVariantDict** which is also passed to *handle-local-options*, where it can be inspected and modified. If `G_APPLICATION_HANDLES_COMMAND_LINE` is set, then the resulting dictionary is sent to the primary instance, where `g_application_command_line_get_options_dict()` will return it. This "packing" is done according to the type of the argument -- booleans for normal flags, strings for strings, bytestrings for filenames, etc. The packing only occurs if the flag is given (ie: we do not pack a "false" **GVariant** in the case that a flag is missing).

In general, it is recommended that all commandline arguments are parsed locally. The options dictionary should then be used to transmit the result of the parsing to the primary instance, where `g_variant_dict_lookup()` can be used. For local options, it is possible to either use *arg_data* in the usual way, or to consult (and potentially remove) the option from the options dictionary.

This function is new in GLib 2.40. Before then, the only real choice was to send all of the commandline arguments (options and all) to the primary instance for handling. **Gnome::Gio::Application** ignored them completely on the local side. Calling this function "opts in" to the new behaviour, and in particular, means that unrecognised options will be treated as errors. Unrecognised options have never been ignored when `G_APPLICATION_HANDLES_COMMAND_LINE` is unset.

If *handle-local-options* needs to see the list of filenames, then the use of `G_OPTION_REMAINING` is recommended. If *arg_data* is `Any` then `G_OPTION_REMAINING` can be used as a key into the options dictionary. If you do use `G_OPTION_REMAINING` then you need to handle these arguments for yourself because once they are consumed, they will no longer be visible to the default handling (which treats them as filenames to be opened).

It is important to use the proper GVariant format when retrieving the options with `g_variant_dict_lookup()`: - for `G_OPTION_ARG_NONE`, use b - for `G_OPTION_ARG_STRING`, use &s - for `G_OPTION_ARG_INT`, use i - for `G_OPTION_ARG_INT64`, use x - for `G_OPTION_ARG_DOUBLE`, use d - for `G_OPTION_ARG_FILENAME`, use ^ay - for `G_OPTION_ARG_STRING_ARRAY`, use &as - for `G_OPTION_ARG_FILENAME_ARRAY`, use ^aay

    method g_application_add_main_option_entries ( N-GOptionEntry $entries )

  * N-GOptionEntry $entries; (array zero-terminated=1) (element-type N-GOptionEntry) a `Any`-terminated list of **N-GOptionEntrys**

[g_application_] add_main_option
--------------------------------

Add an option to be handled by *application*.

Calling this function is the equivalent of calling `g_application_add_main_option_entries()` with a single **N-GOptionEntry** that has its arg_data member set to `Any`.

The parsed arguments will be packed into a **GVariantDict** which is passed to *handle-local-options*. If `G_APPLICATION_HANDLES_COMMAND_LINE` is set, then it will also be sent to the primary instance. See `g_application_add_main_option_entries()` for more details.

See **N-GOptionEntry** for more documentation of the arguments.

    method g_application_add_main_option (
      Str $long_name, char $short_name, GOptionFlags $flags,
      GOptionArg $arg, Str $description, Str $arg_description
    )

  * Str $long_name; the long name of an option used to specify it in a commandline

  * char $short_name; the short name of an option

  * GOptionFlags $flags; flags from **GOptionFlags**

  * GOptionArg $arg; the type of the option, as a **GOptionArg**

  * Str $description; the description for the option in `--help` output

  * Str $arg_description; (nullable): the placeholder to use for the extra argument parsed by the option in `--help` output

[g_application_] add_option_group
---------------------------------

Adds a **N-GOptionGroup** to the commandline handling of *application*.

This function is comparable to `g_option_context_add_group()`.

Unlike `g_application_add_main_option_entries()`, this function does not deal with undefined *arg_data* and never transmits options to the primary instance.

The reason for that is because, by the time the options arrive at the primary instance, it is typically too late to do anything with them. Taking the GTK option group as an example: GTK will already have been initialised by the time the *command-line* handler runs. In the case that this is not the first-running instance of the application, the existing instance may already have been running for a very long time.

This means that the options from **N-GOptionGroup** are only really usable in the case that the instance of the application being run is the first instance. Passing options like `--display=` or `--gdk-debug=` on future runs will have no effect on the existing primary instance.

Calling this function will cause the options in the supplied option group to be parsed, but it does not cause you to be "opted in" to the new functionality whereby unrecognised options are rejected even if `G_APPLICATION_HANDLES_COMMAND_LINE` was given.

    method g_application_add_option_group ( N-GOptionGroup $group )

  * N-GOptionGroup $group; (transfer full): a **N-GOptionGroup**

[g_application_] set_option_context_parameter_string
----------------------------------------------------

Sets the parameter string to be used by the commandline handling of *application*. This function registers the argument to be passed to `g_option_context_new()` when the internal **GOptionContext** of *application* is created. See `g_option_context_new()` for more information about *parameter_string*.

    method g_application_set_option_context_parameter_string (
      Str $parameter_string
    )

  * Str $parameter_string; a string which is displayed in the first line of `--help` output, after the usage summary `programname [OPTION...]`.

[g_application_] set_option_context_summary
-------------------------------------------

Adds a summary to the *application* option context.

See `g_option_context_set_summary()` for more information.

    method g_application_set_option_context_summary ( Str $summary )

  * Str $summary; (nullable): a string to be shown in `--help` output before the list of options, or `Any`

[g_application_] set_option_context_description
-----------------------------------------------

Adds a description to the *application* option context.

See `g_option_context_set_description()` for more information.

    method g_application_set_option_context_description ( Str $description )

  * Str $description; (nullable): a string to be shown in `--help` output after the list of options, or `Any`

[g_application_] get_is_registered
----------------------------------

Checks if *application* is registered. An application is registered if `g_application_register()` has been successfully called. Returns: `1` if *application* is registered.

    method g_application_get_is_registered ( --> Int  )

[g_application_] get_is_remote
------------------------------

Checks if *application* is remote.

If *application* is remote then it means that another instance of application already exists (the 'primary' instance). Calls to perform actions on *application* will result in the actions being performed by the primary instance.

The value of this property cannot be accessed before `g_application_register()` has been called. See `g_application_get_is_registered()`.

Returns: `1` if *application* is remote

    method g_application_get_is_remote ( --> Int  )

g_application_register
----------------------

Attempts registration of the application.

This is the point at which the application discovers if it is the primary instance or merely acting as a remote for an already-existing primary instance. This is implemented by attempting to acquire the application identifier as a unique bus name on the session bus using GDBus.

If there is no application ID or if `G_APPLICATION_NON_UNIQUE` was given, then this process will always become the primary instance.

Due to the internal architecture of GDBus, method calls can be dispatched at any time (even if a main loop is not running). For this reason, you must ensure that any object paths that you wish to register are registered before calling this function.

If the application has already been registered then `1` is returned with no work performed.

The *startup* signal is emitted if registration succeeds and *application* is the primary instance (including the non-unique case).

In the event of an error (such as *cancellable* being cancelled, or a failure to connect to the session bus), `0` is returned and *error* is set appropriately.

Note: the return value of this function is not an indicator that this instance is or is not the primary instance of the application. See `g_application_get_is_remote()` for that.

Returns a valid error object if registration didn't succeed.

    method g_application_register (
      N-GObject :$cancellable
      --> Gnome::Glib::Error
    )

  * N-GObject $cancellable; (nullable): a **GCancellable**, or `Any`

g_application_hold
------------------

Increases the use count of *application*.

Use this function to indicate that the application has a reason to continue to run. For example, `g_application_hold()` is called by GTK+ when a toplevel window is on the screen.

To cancel the hold, call `g_application_release()`.

    method g_application_hold ( )

g_application_release
---------------------

Decrease the use count of *application*.

When the use count reaches zero, the application will stop running.

Never call this function except to cancel the effect of a previous call to `g_application_hold()`.

    method g_application_release ( )

g_application_activate
----------------------

Activates the application.

In essence, this results in the *activate* signal being emitted in the primary instance. The application must be registered before calling this function.

    method g_application_activate ( )

g_application_open
------------------

Opens the given files.

In essence, this results in the *open* signal being emitted in the primary instance.

*n_files* must be greater than zero.

*hint* is simply passed through to the *open* signal. It is intended to be used by applications that have multiple modes for opening files (eg: "view" vs "edit", etc). Unless you have a need for this functionality, you should use "".

The application must be registered before calling this function and it must have the `G_APPLICATION_HANDLES_OPEN` flag set.

    method g_application_open ( N-GObject $files, Int $n_files, Str $hint )

  * N-GObject $files; (array length=n_files): an array of **GFiles** to open

  * Int $n_files; the length of the *files* array

  * Str $hint; a hint (or ""), but never `Any`

g_application_run
-----------------

Runs the application.

This function is intended to be run from `main()` and its return value is intended to be returned by `main()`. Although you are expected to pass the *argc*, *argv* parameters from `main()` to this function, it is possible to pass `Any` if *argv* is not available or commandline handling is not required. Note that on Windows, *argc* and *argv* are ignored, and `g_win32_get_command_line()` is called internally (for proper support of Unicode commandline arguments).

**Gnome::Gio::Application** will attempt to parse the commandline arguments. You can add commandline flags to the list of recognised options by way of `g_application_add_main_option_entries()`. After this, the *handle-local-options* signal is emitted, from which the application can inspect the values of its **N-GOptionEntrys**.

    I<handle-local-options> is a good place to handle options such as `--version`, where an immediate reply from the local process is desired (instead of communicating with an already-running instance). A  I<handle-local-options> handler can stop further processing by returning a non-negative value, which then becomes the exit status of the process.

What happens next depends on the flags: if `G_APPLICATION_HANDLES_COMMAND_LINE` was specified then the remaining commandline arguments are sent to the primary instance, where a *command-line* signal is emitted. Otherwise, the remaining commandline arguments are assumed to be a list of files. If there are no files listed, the application is activated via the *activate* signal. If there are one or more files, and `G_APPLICATION_HANDLES_OPEN` was specified then the files are opened via the *open* signal.

If, after the above is done, the use count of the application is zero then the exit status is returned immediately. If the use count is non-zero then the default main context is iterated until the use count falls to zero, at which point 0 is returned.

If the `G_APPLICATION_IS_SERVICE` flag is set, then the service will run for as much as 10 seconds with a use count of zero while waiting for the message that caused the activation to arrive. After that, if the use count falls to zero the application will exit immediately, except in the case that `g_application_set_inactivity_timeout()` is in use.

This function sets the prgname (`g_set_prgname()`), if not already set, to the basename of argv[0].

Much like `g_main_loop_run()`, this function will acquire the main context for the duration that the application is running.

Since 2.40, applications that are not explicitly flagged as services or launchers (ie: neither `G_APPLICATION_IS_SERVICE` or `G_APPLICATION_IS_LAUNCHER` are given as flags) will check (from the default handler for local_command_line) if "--gapplication-service" was given in the command line. If this flag is present then normal commandline processing is interrupted and the `G_APPLICATION_IS_SERVICE` flag is set. This provides a "compromise" solution whereby running an application directly from the commandline will invoke it in the normal way (which can be useful for debugging) while still allowing applications to be D-Bus activated in service mode. The D-Bus service file should invoke the executable with "--gapplication-service" as the sole commandline argument. This approach is suitable for use by most graphical applications but should not be used from applications like editors that need precise control over when processes invoked via the commandline will exit and what their exit status will be.

Returns: the exit status

    method g_application_run ( --> int32  )

g_application_quit
------------------

Immediately quits the application.

Upon return to the mainloop, `g_application_run()` will return, calling only the 'shutdown' function before doing so.

The hold count is ignored. Take care if your code has called `g_application_hold()` on the application and is therefore still expecting it to exist. (Note that you may have called `g_application_hold()` indirectly, for example through `gtk_application_add_window()`.)

The result of calling `g_application_run()` again after it returns is unspecified.

    method g_application_quit ( )

[g_application_] get_default
----------------------------

Returns the default **Gnome::Gio::Application** instance for this process.

Normally there is only one **Gnome::Gio::Application** per process and it becomes the default when it is created. You can exercise more control over this by using `g_application_set_default()`.

If there is no default application then `Any` is returned.

Returns: (transfer none): the default application for this process, or `Any`

    method g_application_get_default ( --> N-GObject  )

[g_application_] set_default
----------------------------

Sets or unsets the default application for the process, as returned by `g_application_get_default()`.

This function does not take its own reference on *application*. If *application* is destroyed then the default application will revert back to `Any`.

    method g_application_set_default ( )

[g_application_] mark_busy
--------------------------

Increases the busy count of *application*.

Use this function to indicate that the application is busy, for instance while a long running operation is pending.

The busy state will be exposed to other processes, so a session shell will use that information to indicate the state to the user (e.g. with a spinner).

To cancel the busy indication, use `g_application_unmark_busy()`.

    method g_application_mark_busy ( )

[g_application_] unmark_busy
----------------------------

Decreases the busy count of *application*.

When the busy count reaches zero, the new state will be propagated to other processes.

This function must only be called to cancel the effect of a previous call to `g_application_mark_busy()`.

    method g_application_unmark_busy ( )

[g_application_] get_is_busy
----------------------------

Gets the application's current busy state, as set through `g_application_mark_busy()` or `g_application_bind_busy_property()`.

Returns: `1` if *application* is currenty marked as busy

    method g_application_get_is_busy ( --> Int  )

[g_application_] send_notification
----------------------------------

Sends a notification on behalf of *application* to the desktop shell. There is no guarantee that the notification is displayed immediately, or even at all.

Notifications may persist after the application exits. It will be D-Bus-activated when the notification or one of its actions is activated.

Modifying *notification* after this call has no effect. However, the object can be reused for a later call to this function.

*id* may be any string that uniquely identifies the event for the application. It does not need to be in any special format. For example, "new-message" might be appropriate for a notification about new messages.

If a previous notification was sent with the same *id*, it will be replaced with *notification* and shown again as if it was a new notification. This works even for notifications sent from a previous execution of the application, as long as *id* is the same string.

*id* may be `Any`, but it is impossible to replace or withdraw notifications without an id.

If *notification* is no longer relevant, it can be withdrawn with `g_application_withdraw_notification()`.

    method g_application_send_notification ( Str $id, N-GObject $notification )

  * Str $id; (nullable): id of the notification, or `Any`

  * N-GObject $notification; the **GNotification** to send

[g_application_] withdraw_notification
--------------------------------------

Withdraws a notification that was sent with `g_application_send_notification()`.

This call does nothing if a notification with *id* doesn't exist or the notification was never sent.

This function works even for notifications sent in previous executions of this application, as long *id* is the same as it was for the sent notification.

Note that notifications are dismissed when the user clicks on one of the buttons in a notification or triggers its default action, so there is no need to explicitly withdraw the notification in that case.

    method g_application_withdraw_notification ( Str $id )

  * Str $id; id of a previously sent notification

[g_application_] bind_busy_property
-----------------------------------

Marks *application* as busy (see `g_application_mark_busy()`) while *property* on *object* is `1`.

The binding holds a reference to *application* while it is active, but not to *object*. Instead, the binding is destroyed when *object* is finalized.

    method g_application_bind_busy_property ( Pointer $object, Str $property )

  * Pointer $object; (type GObject.Object): a **GObject**

  * Str $property; the name of a boolean property of *object*

[g_application_] unbind_busy_property
-------------------------------------

Destroys a binding between *property* and the busy state of *application* that was previously created with `g_application_bind_busy_property()`.

    method g_application_unbind_busy_property ( Pointer $object, Str $property )

  * Pointer $object; (type GObject.Object): a **GObject**

  * Str $property; the name of a boolean property of *object*

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

### startup

The *startup* signal is emitted on the primary instance immediately after registration. See `g_application_register()`.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the application

### shutdown

The *shutdown* signal is emitted only on the registered primary instance immediately after the main loop terminates.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the application

### activate

The *activate* signal is emitted on the primary instance when an activation occurs. See `g_application_activate()`.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the application

### open

The *open* signal is emitted on the primary instance when there are files to open. See `g_application_open()` for more information.

    method handler (
      Unknown type G_TYPE_POINTER $files,
      Int $n_files,
      Str $hint,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the application

  * $files; (array length=n_files) (element-type GFile): an array of **GFiles**

  * $n_files; the length of *files*

  * $hint; a hint provided by the calling instance

### command-line

The *command-line* signal is emitted on the primary instance when a commandline is not handled locally. See `g_application_run()` and the **Gnome::Gio::ApplicationCommandLine** documentation for more information.

Returns: An integer that is set as the exit status for the calling process. See `g_application_command_line_set_exit_status()`.

    method handler (
      Unknown type G_TYPE_APPLICATION_COMMAND_LINE $command_line,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
      --> Int
    );

  * $application; the application

  * $command_line; a **Gnome::Gio::ApplicationCommandLine** representing the passed commandline

### handle-local-options

The *handle-local-options* signal is emitted on the local instance after the parsing of the commandline options has occurred.

You can add options to be recognised during commandline option parsing using `g_application_add_main_option_entries()` and `g_application_add_option_group()`.

Signal handlers can inspect *options* (along with values pointed to from the *arg_data* of an installed **N-GOptionEntrys**) in order to decide to perform certain actions, including direct local handling (which may be useful for options like --version).

In the event that the application is marked `G_APPLICATION_HANDLES_COMMAND_LINE` the "normal processing" will send the *options* dictionary to the primary instance where it can be read with `g_application_command_line_get_options_dict()`. The signal handler can modify the dictionary before returning, and the modified dictionary will be sent.

In the event that `G_APPLICATION_HANDLES_COMMAND_LINE` is not set, "normal processing" will treat the remaining uncollected command line arguments as filenames or URIs. If there are no arguments, the application is activated by `g_application_activate()`. One or more arguments results in a call to `g_application_open()`.

If you want to handle the local commandline arguments for yourself by converting them to calls to `g_application_open()` or `g_action_group_activate_action()` then you must be sure to register the application first. You should probably not call `g_application_activate()` for yourself, however: just return -1 and allow the default handler to do it for you. This will ensure that the `--Gnome::Gio::Application-service` switch works properly (i.e. no activation in that case).

Note that this signal is emitted from the default implementation of `local_command_line()`. If you override that function and don't chain up then this signal will never be emitted.

You can override `local_command_line()` if you need more powerful capabilities than what is provided here, but this should not normally be required.

Returns: an exit code. If you have handled your options and want to exit the process, return a non-negative option, 0 for success, and a positive value for failure. To continue, return -1 to let the default option processing continue.

    method handler (
      Unknown type G_TYPE_VARIANT_DICT $options,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
      --> Int
    );

  * $application; the application

  * $options; the options dictionary

### name-lost

The *name-lost* signal is emitted only on the registered primary instance when a new instance has taken over. This can only happen if the application is using the `G_APPLICATION_ALLOW_REPLACEMENT` flag.

The default handler for this signal calls `g_application_quit()`.

Returns: `1` if the signal has been handled

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
      --> Int
    );

  * $application; the application

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Application identifier

The unique identifier for the application Default value: Any

The **Gnome::GObject::Value** type of property *application-id* is `G_TYPE_STRING`.

### Application flags

The **Gnome::GObject::Value** type of property *flags* is `G_TYPE_FLAGS`.

### Resource base path

The base resource path for the application Default value: Any

The **Gnome::GObject::Value** type of property *resource-base-path* is `G_TYPE_STRING`.

### Is registered

If g_application_register( has been called) Default value: False

The **Gnome::GObject::Value** type of property *is-registered* is `G_TYPE_BOOLEAN`.

### Is remote

If this application instance is remote Default value: False

The **Gnome::GObject::Value** type of property *is-remote* is `G_TYPE_BOOLEAN`.

### Inactivity timeout

The **Gnome::GObject::Value** type of property *inactivity-timeout* is `G_TYPE_UINT`.

### Action group

The group of actions that the application exports Widget type: G_TYPE_ACTION_GROUP

The **Gnome::GObject::Value** type of property *action-group* is `G_TYPE_OBJECT`.

### Is busy

Whether the application is currently marked as busy through `g_application_mark_busy()` or `g_application_bind_busy_property()`. The **Gnome::GObject::Value** type of property *is-busy* is `G_TYPE_BOOLEAN`.

