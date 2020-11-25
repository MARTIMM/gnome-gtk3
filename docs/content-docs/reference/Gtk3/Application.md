Gnome::Gtk3::Application
========================

Application class

Description
===========

**Gnome::Gtk3::Application** is a class that handles many important aspects of a GTK+ application in a convenient fashion, without enforcing a one-size-fits-all application model.

Currently, **Gnome::Gtk3::Application** handles GTK+ initialization, application uniqueness, session management, provides some basic scriptability and desktop shell integration by exporting actions and menus and manages a list of toplevel windows whose life-cycle is automatically tied to the life-cycle of your application.

While **Gnome::Gtk3::Application** works fine with plain **Gnome::Gtk3::Windows**, it is recommended to use it together with **Gnome::Gtk3::ApplicationWindow**.

When GDK threads are enabled, **Gnome::Gtk3::Application** will acquire the GDK lock when invoking actions that arrive from other processes. The GDK lock is not touched for local action invocations. In order to have actions invoked in a predictable context it is therefore recommended that the GDK lock be held while invoking actions locally with `g_action_group_activate_action()`. The same applies to actions associated with **Gnome::Gtk3::ApplicationWindow** and to the “activate” and “open” **GApplication** methods.

Automatic resources
-------------------

**Gnome::Gtk3::Application** will automatically load menus from the **Gnome::Gtk3::Builder** resource located at "gtk/menus.ui", relative to the application's resource base path (see `g_application_set_resource_base_path()`). The menu with the ID "app-menu" is taken as the application's app menu and the menu with the ID "menubar" is taken as the application's menubar. Additional menus (most interesting submenus) can be named and accessed via `gtk_application_get_menu_by_id()` which allows for dynamic population of a part of the menu structure.

If the resources "gtk/menus-appmenu.ui" or "gtk/menus-traditional.ui" are present then these files will be used in preference, depending on the value of `gtk_application_prefers_app_menu()`. If the resource "gtk/menus-common.ui" is present it will be loaded as well. This is useful for storing items that are referenced from both "gtk/menus-appmenu.ui" and "gtk/menus-traditional.ui".

It is also possible to provide the menus manually using `gtk_application_set_app_menu()` and `gtk_application_set_menubar()`.

**Gnome::Gtk3::Application** will also automatically setup an icon search path for the default icon theme by appending "icons" to the resource base path. This allows your application to easily store its icons as resources. See `gtk_icon_theme_add_resource_path()` for more information.

If there is a resource located at "gtk/help-overlay.ui" which defines a **Gnome::Gtk3::ShortcutsWindow** with ID "help_overlay" then **Gnome::Gtk3::Application** associates an instance of this shortcuts window with each **Gnome::Gtk3::ApplicationWindow** and sets up keyboard accelerators (Control-F1 and Control-?) to open it. To create a menu item that displays the shortcuts window, associate the item with the action win.show-help-overlay.

A simple application
--------------------

[A simple example](https://git.gnome.org/browse/gtk+/tree/examples/bp/bloatpad.c)

**Gnome::Gtk3::Application** optionally registers with a session manager of the users session (if you set the *register-session* property) and offers various functionality related to the session life-cycle.

An application can block various ways to end the session with the `gtk_application_inhibit()` function. Typical use cases for this kind of inhibiting are long-running, uninterruptible operations, such as burning a CD or performing a disk backup. The session manager may not honor the inhibitor, but it can be expected to inform the user about the negative consequences of ending the session while inhibitors are present.

See Also
--------

[HowDoI: Using **Gnome::Gtk3::Application**](https://wiki.gnome.org/HowDoI/**Gnome::Gtk3::Application**), [Getting Started with GTK+: Basics](https://developer.gnome.org/gtk3/stable/gtk-getting-started.html**id**-1.2.3.3)

Implemented Interfaces
----------------------

Gnome::Gtk3::Application implements

  * Gnome::Gio::ActionGroup

  * Gnome::Gio::ActionMap

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Application;
    also is Gnome::Gio::Application;
    also does Gnome::Gio::ActionMap;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Application;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Application;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Application class process the options
      self.bless( :GtkApplication, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### :app-id, :flags

Create a new Application object.

    multi method new (
      Str :$app-id!,
      GApplicationFlags :$flags = G_APPLICATION_FLAGS_NONE
    )

### :native-object

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelSupportClass**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_application_new
-------------------

Creates a new **Gnome::Gtk3::Application** instance.

When using **Gnome::Gtk3::Application**, it is not necessary to call `gtk_init()` manually. It is called as soon as the application gets registered as the primary instance.

Concretely, `gtk_init()` is called in the default handler for the *startup* signal. Therefore, **Gnome::Gtk3::Application** subclasses should chain up in their *startup* handler before using any GTK+ API.

Note that commandline arguments are not passed to `gtk_init()`. All GTK+ functionality that is available via commandline arguments can also be achieved by setting suitable environment variables such as `G_DEBUG`, so this should not be a big problem. If you absolutely must support GTK+ commandline arguments, you can explicitly call `gtk_init()` before creating the application instance.

If non-`Any`, the application ID must be valid. See `g_application_id_is_valid()`.

If no application ID is given then some features (most notably application uniqueness) will be disabled. A null application ID is only allowed with GTK+ 3.6 or later.

Returns: a new **Gnome::Gtk3::Application** instance

    method gtk_application_new ( Str $application_id, GApplicationFlags $flags --> N-GObject )

  * Str $application_id; (allow-none): The application ID.

  * GApplicationFlags $flags; the application flags

[gtk_application_] add_window
-----------------------------

Adds a window to *application*.

This call can only happen after the *application* has started; typically, you should add new application windows in response to the emission of the *activate* signal.

This call is equivalent to setting the *application* property of *$window* to *application*.

Normally, the connection between the application and the window will remain until the window is destroyed, but you can explicitly remove it with `gtk_application_remove_window()`.

GTK+ will keep the *application* running as long as it has any windows.

    method gtk_application_add_window ( N-GObject $window )

  * N-GObject $window; a **Gnome::Gtk3::Window**

[gtk_application_] remove_window
--------------------------------

Remove a window from *application*.

If *window* belongs to *application* then this call is equivalent to setting the *application* property of *window* to `Any`.

The application may stop running as a result of a call to this function.

    method gtk_application_remove_window ( N-GObject $window )

  * N-GObject $window; a **Gnome::Gtk3::Window**

[gtk_application_] get_windows
------------------------------

Gets a list of the **Gnome::Gtk3::Windows** associated with *application*.

The list is sorted by most recently focused window, such that the first element is the currently focused window. (Useful for choosing a parent for a transient window.)

The list that is returned should not be modified in any way. It will only remain valid until the next focus change or window creation or deletion.

Returns: (element-type **Gnome::Gtk3::Window**) (transfer none): a **GList** of **Gnome::Gtk3::Window**

    method gtk_application_get_windows ( --> N-GList )

[gtk_application_] get_app_menu
-------------------------------

Returns the menu model that has been set with `gtk_application_set_app_menu()`.

Returns: (transfer none) (nullable): the application menu of *application* or `Any` if no application menu has been set.

    method gtk_application_get_app_menu ( --> N-GObject )

[gtk_application_] set_app_menu
-------------------------------

Sets or unsets the application menu for *application*.

This can only be done in the primary instance of the application, after it has been registered. *startup* is a good place to call this.

The application menu is a single menu containing items that typically impact the application as a whole, rather than acting on a specific window or document. For example, you would expect to see “Preferences” or “Quit” in an application menu, but not “Save” or “Print”.

If supported, the application menu will be rendered by the desktop environment.

Use the base **GActionMap** interface to add actions, to respond to the user selecting these menu items.

    method gtk_application_set_app_menu ( N-GObject $app_menu )

  * N-GObject $app_menu; (allow-none): a **GMenuModel**, or `Any`

[gtk_application_] get_menubar
------------------------------

Returns the menu model that has been set with `gtk_application_set_menubar()`.

Returns: (transfer none): the menubar for windows of *application*

    method gtk_application_get_menubar ( --> N-GObject )

[gtk_application_] set_menubar
------------------------------

Sets or unsets the menubar for windows of *application*.

This is a menubar in the traditional sense.

This can only be done in the primary instance of the application, after it has been registered. *startup* is a good place to call this.

Depending on the desktop environment, this may appear at the top of each window, or at the top of the screen. In some environments, if both the application menu and the menubar are set, the application menu will be presented as if it were the first item of the menubar. Other environments treat the two as completely separate — for example, the application menu may be rendered by the desktop shell while the menubar (if set) remains in each individual window.

Use the base **GActionMap** interface to add actions, to respond to the user selecting these menu items.

    method gtk_application_set_menubar ( N-GObject $menubar )

  * N-GObject $menubar; (allow-none): a **GMenuModel**, or `Any`

[gtk_application_] get_window_by_id
-----------------------------------

Returns the **Gnome::Gtk3::ApplicationWindow** with the given ID.

The ID of a **Gnome::Gtk3::ApplicationWindow** can be retrieved with `gtk_application_window_get_id()`.

Returns: (nullable) (transfer none): the window with ID *id*, or `Any` if there is no window with this ID

    method gtk_application_get_window_by_id ( UInt $id --> N-GObject )

  * UInt $id; an identifier number

[gtk_application_] get_active_window
------------------------------------

Gets the “active” window for the application.

The active window is the one that was most recently focused (within the application). This window may not have the focus at the moment if another application has it — this is just the most recently-focused window within this application.

Returns: (transfer none) (nullable): the active window, or `Any` if there isn't one.

    method gtk_application_get_active_window ( --> N-GObject )

[gtk_application_] list_action_descriptions
-------------------------------------------

Lists the detailed action names which have associated accelerators. See `gtk_application_set_accels_for_action()`.

Returns: (transfer full): a `Any`-terminated array of strings, free with `g_strfreev()` when done

    method gtk_application_list_action_descriptions ( --> CArray[Str] )

[gtk_application_] get_accels_for_action
----------------------------------------

Gets the accelerators that are currently associated with the given action.

Returns: (transfer full): accelerators for *detailed_action_name*, as a `Any`-terminated array. Free with `g_strfreev()` when no longer needed

    method gtk_application_get_accels_for_action ( Str $detailed_action_name --> CArray[Str] )

  * Str $detailed_action_name; a detailed action name, specifying an action and target to obtain accelerators for

[gtk_application_] get_actions_for_accel
----------------------------------------

Returns the list of actions (possibly empty) that *accel* maps to. Each item in the list is a detailed action name in the usual form.

This might be useful to discover if an accel already exists in order to prevent installation of a conflicting accelerator (from an accelerator editor or a plugin system, for example). Note that having more than one action per accelerator may not be a bad thing and might make sense in cases where the actions never appear in the same context.

In case there are no actions for a given accelerator, an empty array is returned. `Any` is never returned.

It is a programmer error to pass an invalid accelerator string. If you are unsure, check it with `gtk_accelerator_parse()` first.

Returns: (transfer full): a `Any`-terminated array of actions for *accel*

    method gtk_application_get_actions_for_accel ( Str $accel --> CArray[Str] )

  * Str $accel; an accelerator that can be parsed by `gtk_accelerator_parse()`

[gtk_application_] set_accels_for_action
----------------------------------------

Sets zero or more keyboard accelerators that will trigger the given action. The first item in *accels* will be the primary accelerator, which may be displayed in the UI.

To remove all accelerators for an action, use an empty, zero-terminated array for *accels*.

For the *detailed_action_name*, see `g_action_parse_detailed_name()` and `g_action_print_detailed_name()`.

    method gtk_application_set_accels_for_action ( Str $detailed_action_name, CArray[Str] $accels )

  * Str $detailed_action_name; a detailed action name, specifying an action and target to associate accelerators with

  * CArray[Str] $accels; (array zero-terminated=1): a list of accelerators in the format understood by `gtk_accelerator_parse()`

[gtk_application_] prefers_app_menu
-----------------------------------

Determines if the desktop environment in which the application is running would prefer an application menu be shown.

If this function returns `1` then the application should call `gtk_application_set_app_menu()` with the contents of an application menu, which will be shown by the desktop environment. If it returns `0` then you should consider using an alternate approach, such as a menubar.

The value returned by this function is purely advisory and you are free to ignore it. If you call `gtk_application_set_app_menu()` even if the desktop environment doesn't support app menus, then a fallback will be provided.

Applications are similarly free not to set an app menu even if the desktop environment wants to show one. In that case, a fallback will also be created by the desktop environment (GNOME, for example, uses a menu with only a "Quit" item in it).

The value returned by this function never changes. Once it returns a particular value, it is guaranteed to always return the same value.

You may only call this function after the application has been registered and after the base startup handler has run. You're most likely to want to use this from your own startup handler. It may also make sense to consult this function while constructing UI (in activate, open or an action activation handler) in order to determine if you should show a gear menu or not.

This function will return `0` on Mac OS and a default app menu will be created automatically with the "usual" contents of that menu typical to most Mac OS applications. If you call `gtk_application_set_app_menu()` anyway, then this menu will be replaced with your own.

Returns: `1` if you should set an app menu

    method gtk_application_prefers_app_menu ( --> Int )

[gtk_application_] get_menu_by_id
---------------------------------

Gets a menu from automatically loaded resources. See [Automatic resources][automatic-resources] for more information.

Returns: (transfer none): Gets the menu with the given id from the automatically loaded resources

    method gtk_application_get_menu_by_id ( Str $id --> N-GObject )

  * Str $id; the id of the menu to look up

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

### window-added

Emitted when a **Gnome::Gtk3::Window** is added to *application* through `gtk_application_add_window()`.

    method handler (
      Unknown type GTK_TYPE_WINDOW $window,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the **Gnome::Gtk3::Application** which emitted the signal

  * $window; the newly-added **Gnome::Gtk3::Window**

### window-removed

Emitted when a **Gnome::Gtk3::Window** is removed from *application*, either as a side-effect of being destroyed or explicitly through `gtk_application_remove_window()`.

    method handler (
      Unknown type GTK_TYPE_WINDOW $window,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the **Gnome::Gtk3::Application** which emitted the signal

  * $window; the **Gnome::Gtk3::Window** that is being removed

### query-end

Emitted when the session manager is about to end the session, only if *register-session* is `1`. Applications can connect to this signal and call `gtk_application_inhibit()` with `GTK_APPLICATION_INHIBIT_LOGOUT` to delay the end of the session until state has been saved.

Since: 3.24.8

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($application),
      *%user-options
    );

  * $application; the **Gnome::Gtk3::Application** which emitted the signal

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Register session

Set this property to `1` to register with the session manager. The **Gnome::GObject::Value** type of property *register-session* is `G_TYPE_BOOLEAN`.

### Screensaver Active

This property is `1` if GTK+ believes that the screensaver is currently active. GTK+ only tracks session state (including this) when *register-session* is set to `1`. Tracking the screensaver state is supported on Linux. The **Gnome::GObject::Value** type of property *screensaver-active* is `G_TYPE_BOOLEAN`.

### Application menu

The GMenuModel for the application menu Widget type: G_TYPE_MENU_MODEL

The **Gnome::GObject::Value** type of property *app-menu* is `G_TYPE_OBJECT`.

### Menubar

The GMenuModel for the menubar Widget type: G_TYPE_MENU_MODEL

The **Gnome::GObject::Value** type of property *menubar* is `G_TYPE_OBJECT`.

### Active window

The window which most recently had focus Widget type: GTK_TYPE_WINDOW

The **Gnome::GObject::Value** type of property *active-window* is `G_TYPE_OBJECT`.

