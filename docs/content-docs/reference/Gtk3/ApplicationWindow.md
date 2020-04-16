Gnome::Gtk3::ApplicationWindow
==============================

**Gnome::Gtk3::Window** subclass with **Gnome::Gtk3::Application** support

Description
===========

**Gnome::Gtk3::ApplicationWindow** is a **Gnome::Gtk3::Window** subclass that offers some extra functionality for better integration with **Gnome::Gtk3::Application** features. Notably, it can handle both the application menu as well as the menubar. See `gtk_application_set_app_menu()` and `gtk_application_set_menubar()`.

This class implements the **GActionGroup** and **GActionMap** interfaces, to let you add window-specific actions that will be exported by the associated **Gnome::Gtk3::Application**, together with its application-wide actions. Window-specific actions are prefixed with the “win.” prefix and application-wide actions are prefixed with the “app.” prefix. Actions must be addressed with the prefixed name when referring to them from a **GMenuModel**.

Note that widgets that are placed inside a **Gnome::Gtk3::ApplicationWindow** can also activate these actions, if they implement the **Gnome::Gtk3::Actionable** interface.

As with **Gnome::Gtk3::Application**, the GDK lock will be acquired when processing actions arriving from other processes and should therefore be held when activating actions locally (if GDK threads are enabled).

The settings *gtk-shell-shows-app-menu* and *gtk-shell-shows-menubar* tell GTK+ whether the desktop environment is showing the application menu and menubar models outside the application as part of the desktop shell. For instance, on OS X, both menus will be displayed remotely; on Windows neither will be. gnome-shell (starting with version 3.4) will display the application menu, but not the menubar.

If the desktop environment does not display the menubar, then **Gnome::Gtk3::ApplicationWindow** will automatically show a **Gnome::Gtk3::MenuBar** for it. This behaviour can be overridden with the *show-menubar* property. If the desktop environment does not display the application menu, then it will automatically be included in the menubar or in the windows client-side decorations.

A **Gnome::Gtk3::ApplicationWindow** with a menubar
---------------------------------------------------

    my Gnome::Gtk3::Application $app .= new(:app-id("org.gtk.test"));
    my Str $gui-interface = Q:to/EOMENU/;
      <interface>
        <menu id='menubar'>
          <submenu label='_Edit'>
            <item label='_Copy' action='win.copy'/>
            <item label='_Paste' action='win.paste'/>
          </submenu>
        </menu>
      </interface>
      EOMENU

    my Gnome::Gtk3::Builder $builder .= new(:string($gui-interface));

    my Gnome::Gio::MenuModel $menubar .= new(:build-id<menubar>);
    $app.set-menubar($menubar);

    ...

    my Gnome::Gtk3::ApplicationWindow $app-window .= new(:application($app));

Handling fallback yourself
--------------------------

The XML format understood by **Gnome::Gtk3::Builder** for **GMenuModel** consists of a toplevel `<menu>` element, which contains one or more `<item>` elements. Each `<item>` element contains `<attribute>` and `<link>` elements with a mandatory name attribute. `<link>` elements have the same content model as `<menu>`. Instead of `<link name="submenu>` or `<link name="section">`, you can use `<submenu>` or `<section>` elements.

Attribute values can be translated using gettext, like other **Gnome::Gtk3::Builder** content. `<attribute>` elements can be marked for translation with a `translatable="yes"` attribute. It is also possible to specify message context and translator comments, using the context and comments attributes. To make use of this, the **Gnome::Gtk3::Builder** must have been given the gettext domain to use.

The following attributes are used when constructing menu items:

  * "label": a user-visible string to display

  * "action": the prefixed name of the action to trigger

  * "target": the parameter to use when activating the action

  * "icon" and "verb-icon": names of icons that may be displayed

  * "submenu-action": name of an action that may be used to determine if a submenu can be opened

  * "hidden-when": a string used to determine when the item will be hidden. Possible values include "action-disabled", "action-missing", "macos-menubar".

The following attributes are used when constructing sections:

  * "label": a user-visible string to use as section heading

  * "display-hint": a string used to determine special formatting for the section. Possible values include "horizontal-buttons".

  * "text-direction": a string used to determine the **Gnome::Gtk3::TextDirection** to use when "display-hint" is set to "horizontal-buttons". Possible values include "rtl", "ltr", and "none".

The following attributes are used when constructing submenus:

  * "label": a user-visible string to display

  * "icon": icon name to display

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ApplicationWindow;
    also is Gnome::Gtk3::Window;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::ApplicationWindow;

    unit class MyGuiClass;
    also is Gnome::Gtk3::ApplicationWindow;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::ApplicationWindow class process the options
      self.bless( :GtkApplicationWindow, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

Create a new **Gnome::Gtk3::ApplicationWindow** based on a **Gnome::Gtk3::Application** object.

    multi method new (N-GObject :$application!)

Create a ApplicationWindow object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a ApplicationWindow object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_application_window_] set_show_menubar
------------------------------------------

Sets whether the window will display a menubar for the app menu and menubar as needed.

    method gtk_application_window_set_show_menubar ( Int $show_menubar )

  * Int $show_menubar; whether to show a menubar when needed

[gtk_application_window_] get_show_menubar
------------------------------------------

Returns whether the window will display a menubar for the app menu and menubar as needed.

Returns: `1` if *window* will display a menubar when needed

    method gtk_application_window_get_show_menubar ( --> Int )

[gtk_application_window_] get_id
--------------------------------

Returns the unique ID of the window. If the window has not yet been added to a **Gnome::Gtk3::Application**, returns `0`.

Returns: the unique ID for *window*, or `0` if the window has not yet been added to a **Gnome::Gtk3::Application**

    method gtk_application_window_get_id ( --> UInt )

[gtk_application_window_] set_help_overlay
------------------------------------------

Associates a shortcuts window with the application window, and sets up an action with the name win.show-help-overlay to present it.

*window* takes resposibility for destroying *help_overlay*.

    method gtk_application_window_set_help_overlay ( N-GObject $help_overlay )

  * N-GObject $help_overlay; (nullable): a **Gnome::Gtk3::ShortcutsWindow**

[gtk_application_window_] get_help_overlay
------------------------------------------

Gets the **Gnome::Gtk3::ShortcutsWindow** that has been set up with a prior call to `gtk_application_window_set_help_overlay()`.

Returns: (transfer none) (nullable): the help overlay associated with *window*, or `Any`

    method gtk_application_window_get_help_overlay ( --> N-GObject )

