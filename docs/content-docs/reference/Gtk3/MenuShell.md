Gnome::Gtk3::MenuShell
======================

A base class for menu objects

Description
===========

A **Gnome::Gtk3::MenuShell** is the abstract base class used to derive the **Gnome::Gtk3::Menu** and **Gnome::Gtk3::MenuBar** subclasses.

A **Gnome::Gtk3::MenuShell** is a container of **Gnome::Gtk3::MenuItem** objects arranged in a list which can be navigated, selected, and activated by the user to perform application functions. A **Gnome::Gtk3::MenuItem** can have a submenu associated with it, allowing for nested hierarchical menus.

Terminology
-----------

A menu item can be “selected”, this means that it is displayed in the prelight state, and if it has a submenu, that submenu will be popped up.

A menu is “active” when it is visible onscreen and the user is selecting from it. A menubar is not active until the user clicks on one of its menuitems. When a menu is active, passing the mouse over a submenu will pop it up.

There is also is a concept of the current menu and a current menu item. The current menu item is the selected menu item that is furthest down in the hierarchy. (Every active menu shell does not necessarily contain a selected menu item, but if it does, then the parent menu shell must also contain a selected menu item.) The current menu is the menu that contains the current menu item. It will always have a GTK grab and receive all key presses.

Implemented Interfaces
----------------------

Gnome::Gtk3::MenuShell implements

  * Gnome::Atk::ImplementorIface

  * Gnome::Gtk3::Buildable

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::MenuShell;
    also is Gnome::Gtk3::Container;

Methods
=======

new
---

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_menu_shell_append
---------------------

Adds a new **Gnome::Gtk3::MenuItem** to the end of the menu shell's item list.

    method gtk_menu_shell_append ( N-GObject $child )

  * N-GObject $child; (type **Gnome::Gtk3::.MenuItem**): The **Gnome::Gtk3::MenuItem** to add

gtk_menu_shell_prepend
----------------------

Adds a new **Gnome::Gtk3::MenuItem** to the beginning of the menu shell's item list.

    method gtk_menu_shell_prepend ( N-GObject $child )

  * N-GObject $child; The **Gnome::Gtk3::MenuItem** to add

gtk_menu_shell_insert
---------------------

Adds a new **Gnome::Gtk3::MenuItem** to the menu shell’s item list at the position indicated by *position*.

    method gtk_menu_shell_insert ( N-GObject $child, Int $position )

  * N-GObject $child; The **Gnome::Gtk3::MenuItem** to add

  * Int $position; The position in the item list where *child* is added. Positions are numbered from 0 to n-1

gtk_menu_shell_deactivate
-------------------------

Deactivates the menu shell.

Typically this results in the menu shell being erased from the screen.

    method gtk_menu_shell_deactivate ( )

[gtk_menu_shell_] select_item
-----------------------------

Selects the menu item from the menu shell.

    method gtk_menu_shell_select_item ( N-GObject $menu_item )

  * N-GObject $menu_item; The **Gnome::Gtk3::MenuItem** to select

gtk_menu_shell_deselect
-----------------------

Deselects the currently selected item from the menu shell, if any.

    method gtk_menu_shell_deselect ( )

[gtk_menu_shell_] activate_item
-------------------------------

Activates the menu item within the menu shell.

    method gtk_menu_shell_activate_item ( N-GObject $menu_item, Int $force_deactivate )

  * N-GObject $menu_item; the **Gnome::Gtk3::MenuItem** to activate

  * Int $force_deactivate; if `1`, force the deactivation of the menu shell after the menu item is activated

[gtk_menu_shell_] select_first
------------------------------

Select the first visible or selectable child of the menu shell; don’t select tearoff items unless the only item is a tearoff item.

Since: 2.2

    method gtk_menu_shell_select_first ( Int $search_sensitive )

  * Int $search_sensitive; if `1`, search for the first selectable menu item, otherwise select nothing if the first item isn’t sensitive. This should be `0` if the menu is being popped up initially.

gtk_menu_shell_cancel
---------------------

Cancels the selection within the menu shell.

Since: 2.4

    method gtk_menu_shell_cancel ( )

[gtk_menu_shell_] get_take_focus
--------------------------------

Returns `1` if the menu shell will take the keyboard focus on popup.

Returns: `1` if the menu shell will take the keyboard focus on popup.

Since: 2.8

    method gtk_menu_shell_get_take_focus ( --> Int  )

[gtk_menu_shell_] set_take_focus
--------------------------------

If *take_focus* is `1` (the default) the menu shell will take the keyboard focus so that it will receive all keyboard events which is needed to enable keyboard navigation in menus.

Setting *take_focus* to `0` is useful only for special applications like virtual keyboard implementations which should not take keyboard focus.

The *take_focus* state of a menu or menu bar is automatically propagated to submenus whenever a submenu is popped up, so you don’t have to worry about recursively setting it for your entire menu hierarchy. Only when programmatically picking a submenu and popping it up manually, the *take_focus* property of the submenu needs to be set explicitly.

Note that setting it to `0` has side-effects:

If the focus is in some other app, it keeps the focus and keynav in the menu doesn’t work. Consequently, keynav on the menu will only work if the focus is on some toplevel owned by the onscreen keyboard.

To avoid confusing the user, menus with *take_focus* set to `0` should not display mnemonics or accelerators, since it cannot be guaranteed that they will work.

See also `gdk_keyboard_grab()`

Since: 2.8

    method gtk_menu_shell_set_take_focus ( Int $take_focus )

  * Int $take_focus; `1` if the menu shell should take the keyboard focus on popup

[gtk_menu_shell_] get_selected_item
-----------------------------------

Gets the currently selected item.

Returns: (transfer none): the currently selected item

Since: 3.0

    method gtk_menu_shell_get_selected_item ( --> N-GObject  )

[gtk_menu_shell_] get_parent_shell
----------------------------------

Gets the parent menu shell.

The parent menu shell of a submenu is the **Gnome::Gtk3::Menu** or **Gnome::Gtk3::MenuBar** from which it was opened up.

Returns: (transfer none): the parent **Gnome::Gtk3::MenuShell**

Since: 3.0

    method gtk_menu_shell_get_parent_shell ( --> N-GObject  )

[gtk_menu_shell_] bind_model
----------------------------

Establishes a binding between a **Gnome::Gtk3::MenuShell** and a **GMenuModel**.

The contents of *shell* are removed and then refilled with menu items according to *model*. When *model* changes, *shell* is updated. Calling this function twice on *shell* with different *model* will cause the first binding to be replaced with a binding to the new model. If *model* is `Any` then any previous binding is undone and all children are removed.

*with_separators* determines if toplevel items (eg: sections) have separators inserted between them. This is typically desired for menus but doesn’t make sense for menubars.

If *action_namespace* is non-`Any` then the effect is as if all actions mentioned in the *model* have their names prefixed with the namespace, plus a dot. For example, if the action “quit” is mentioned and *action_namespace* is “app” then the effective action name is “app.quit”.

This function uses **Gnome::Gtk3::Actionable** to define the action name and target values on the created menu items. If you want to use an action group other than “app” and “win”, or if you want to use a **Gnome::Gtk3::MenuShell** outside of a **Gnome::Gtk3::ApplicationWindow**, then you will need to attach your own action group to the widget hierarchy using `gtk_widget_insert_action_group()`. As an example, if you created a group with a “quit” action and inserted it with the name “mygroup” then you would use the action name “mygroup.quit” in your **GMenuModel**.

For most cases you are probably better off using `gtk_menu_new_from_model()` or `gtk_menu_bar_new_from_model()` or just directly passing the **GMenuModel** to `gtk_application_set_app_menu()` or `gtk_application_set_menubar()`.

Since: 3.6

    method gtk_menu_shell_bind_model ( N-GObject $model, Str $action_namespace, Int $with_separators )

  * N-GObject $model; (allow-none): the **GMenuModel** to bind to or `Any` to remove binding

  * Str $action_namespace; (allow-none): the namespace for actions in *model*

  * Int $with_separators; `1` if toplevel items in *shell* should have separators between them

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

### deactivate

This signal is emitted when a menu shell is deactivated.

    method handler (
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

### selection-done

This signal is emitted when a selection has been completed within a menu shell.

    method handler (
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

### move-current

An keybinding signal which moves the current menu item in the direction specified by *direction*.

    method handler (
      Unknown type GTK_TYPE_MENU_DIRECTION_TYPE $direction,
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

  * $direction; the direction to move

### activate-current

An action signal that activates the current menu item within the menu shell.

    method handler (
      Int $force_hide,
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

  * $force_hide; if `1`, hide the menu after activating the menu item

### cancel

An action signal which cancels the selection within the menu shell. Causes the *selection-done* signal to be emitted.

    method handler (
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

### cycle-focus

A keybinding signal which moves the focus in the given *direction*.

    method handler (
      Unknown type GTK_TYPE_DIRECTION_TYPE $direction,
      Gnome::GObject::Object :widget($menushell),
      *%user-options
    );

  * $menushell; the object which received the signal

  * $direction; the direction to cycle in

### move-selected

The *move-selected* signal is emitted to move the selection to another item.

Returns: `1` to stop the signal emission, `0` to continue

Since: 2.12

    method handler (
      Int $distance,
      Gnome::GObject::Object :widget($menu_shell),
      *%user-options
      --> Int
    );

  * $menu_shell; the object on which the signal is emitted

  * $distance; +1 to move to the next item, -1 to move to the previous

### insert

The *insert* signal is emitted when a new **Gnome::Gtk3::MenuItem** is added to a **Gnome::Gtk3::MenuShell**. A separate signal is used instead of **Gnome::Gtk3::Container**::add because of the need for an additional position parameter.

The inverse of this signal is the **Gnome::Gtk3::Container**::removed signal.

Since: 3.2

    method handler (
      N-GObject $child,
      Int $position,
      Gnome::GObject::Object :widget($menu_shell),
      *%user-options
    );

  * $menu_shell; the object on which the signal is emitted

  * $child; the **Gnome::Gtk3::MenuItem** that is being inserted

  * $position; the position at which the insert occurs

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Take Focus

A boolean that determines whether the menu and its submenus grab the keyboard focus. See `gtk_menu_shell_set_take_focus()` and `gtk_menu_shell_get_take_focus()`. Since: 2.8

The **Gnome::GObject::Value** type of property *take-focus* is `G_TYPE_BOOLEAN`.

