Gnome::Gtk3::MenuItem
=====================

The widget used for item in menus

Description
===========

The **Gnome::Gtk3::MenuItem** widget and the derived widgets are the only valid children for menus. Their function is to correctly handle highlighting, alignment, events and submenus.

As a **Gnome::Gtk3::MenuItem** derives from **Gnome::Gtk3::Bin** it can hold any valid child widget, although only a few are really useful.

By default, a **Gnome::Gtk3::MenuItem** sets a **Gnome::Gtk3::AccelLabel** as its child. **Gnome::Gtk3::MenuItem** has direct functions to set the label and its mnemonic. For more advanced label settings, you can fetch the child widget from the **Gnome::Gtk3::Bin**.

Gnome::Gtk3::MenuItem as Gnome::Gtk3::Buildable
-----------------------------------------------

The **Gnome::Gtk3::MenuItem** implementation of the **Gnome::Gtk3::Buildable** interface supports adding a submenu by specifying “submenu” as the “type” attribute of a <child> element.

An example of UI definition fragment with submenus:

    <object class="B<Gnome::Gtk3::MenuItem>">
      <child type="submenu">
        <object class="B<Gnome::Gtk3::Menu>"/>
      </child>
    </object>

Css Nodes
---------

    menuitem
    ├── <child>
    ╰── [arrow.right]

**Gnome::Gtk3::MenuItem** has a single CSS node with name menuitem. If the menuitem has a submenu, it gets another CSS node with name arrow, which has the .left or .right style class.

Implemented Interfaces
----------------------

Gnome::Gtk3::MenuItem implements

  * Gnome::Atk::ImplementorIface

  * Gnome::Gtk3::Buildable

  * Gnome::Gtk3::Activatable

  * Gnome::Gtk3::Actionable

See Also
--------

**Gnome::Gtk3::Bin**, **Gnome::Gtk3::MenuShell**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::MenuItem;
    also is Gnome::Gtk3::Bin;

Example
-------

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create a new object with a label.

    multi method new ( Str :$label! )

Create a new object with a mnemonic.

    multi method new ( Str :$mnemonic! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_menu_item_new
-----------------

Creates a new **Gnome::Gtk3::MenuItem**.

Returns: the newly created **Gnome::Gtk3::MenuItem**

    method gtk_menu_item_new ( --> N-GObject  )

[gtk_menu_item_] new_with_label
-------------------------------

Creates a new **Gnome::Gtk3::MenuItem** whose child is a **Gnome::Gtk3::Label**.

Returns: the newly created **Gnome::Gtk3::MenuItem**

    method gtk_menu_item_new_with_label ( Str $label --> N-GObject  )

  * Str $label; the text for the label

[gtk_menu_item_] new_with_mnemonic
----------------------------------

Creates a new **Gnome::Gtk3::MenuItem** containing a label.

The label will be created using `gtk_label_new_with_mnemonic()`, so underscores in *label* indicate the mnemonic for the menu item.

Returns: a new **Gnome::Gtk3::MenuItem**

    method gtk_menu_item_new_with_mnemonic ( Str $label --> N-GObject  )

  * Str $label; The text of the button, with an underscore in front of the mnemonic character

[gtk_menu_item_] set_submenu
----------------------------

Sets or replaces the menu item’s submenu, or removes it when a `Any` submenu is passed.

    method gtk_menu_item_set_submenu ( N-GObject $submenu )

  * N-GObject $submenu; (allow-none) (type **Gnome::Gtk3::.Menu**): the submenu, or `Any`

[gtk_menu_item_] get_submenu
----------------------------

Gets the submenu underneath this menu item, if any. See `gtk_menu_item_set_submenu()`.

Returns: (nullable) (transfer none): submenu for this menu item, or `Any` if none

    method gtk_menu_item_get_submenu ( --> N-GObject  )

gtk_menu_item_select
--------------------

Emits the *select* signal on the given item.

    method gtk_menu_item_select ( )

gtk_menu_item_deselect
----------------------

Emits the *deselect* signal on the given item.

    method gtk_menu_item_deselect ( )

gtk_menu_item_activate
----------------------

Emits the *activate* signal on the given item

    method gtk_menu_item_activate ( )

[gtk_menu_item_] toggle_size_request
------------------------------------

Emits the *toggle-size-request* signal on the given item.

    method gtk_menu_item_toggle_size_request ( Int $requisition )

  * Int $requisition; (inout): the requisition to use as signal data.

[gtk_menu_item_] toggle_size_allocate
-------------------------------------

Emits the *toggle-size-allocate* signal on the given item.

    method gtk_menu_item_toggle_size_allocate ( Int $allocation )

  * Int $allocation; the allocation to use as signal data.

[gtk_menu_item_] set_accel_path
-------------------------------

Set the accelerator path on *menu_item*, through which runtime changes of the menu item’s accelerator caused by the user can be identified and saved to persistent storage (see `gtk_accel_map_save()` on this). To set up a default accelerator for this menu item, call `gtk_accel_map_add_entry()` with the same *accel_path*. See also `gtk_accel_map_add_entry()` on the specifics of accelerator paths, and `gtk_menu_set_accel_path()` for a more convenient variant of this function.

This function is basically a convenience wrapper that handles calling `gtk_widget_set_accel_path()` with the appropriate accelerator group for the menu item.

Note that you do need to set an accelerator on the parent menu with `gtk_menu_set_accel_group()` for this to work.

Note that *accel_path* string will be stored in a **GQuark**. Therefore, if you pass a static string, you can save some memory by interning it first with `g_intern_static_string()`.

    method gtk_menu_item_set_accel_path ( Str $accel_path )

  * Str $accel_path; (allow-none): accelerator path, corresponding to this menu item’s functionality, or `Any` to unset the current path.

[gtk_menu_item_] get_accel_path
-------------------------------

Retrieve the accelerator path that was previously set on *menu_item*.

See `gtk_menu_item_set_accel_path()` for details.

Returns: (nullable) (transfer none): the accelerator path corresponding to this menu item’s functionality, or `Any` if not set

Since: 2.14

    method gtk_menu_item_get_accel_path ( --> Str  )

[gtk_menu_item_] set_label
--------------------------

Sets *text* on the *menu_item* label

Since: 2.16

    method gtk_menu_item_set_label ( Str $label )

  * Str $label; the text you want to set

[gtk_menu_item_] get_label
--------------------------

Sets *text* on the *menu_item* label

Returns: The text in the *menu_item* label. This is the internal string used by the label, and must not be modified.

Since: 2.16

    method gtk_menu_item_get_label ( --> Str  )

[gtk_menu_item_] set_use_underline
----------------------------------

If true, an underline in the text indicates the next character should be used for the mnemonic accelerator key.

Since: 2.16

    method gtk_menu_item_set_use_underline ( Int $setting )

  * Int $setting; `1` if underlines in the text indicate mnemonics

[gtk_menu_item_] get_use_underline
----------------------------------

Checks if an underline in the text indicates the next character should be used for the mnemonic accelerator key.

Returns: `1` if an embedded underline in the label indicates the mnemonic accelerator key.

Since: 2.16

    method gtk_menu_item_get_use_underline ( --> Int  )

[gtk_menu_item_] set_reserve_indicator
--------------------------------------

Sets whether the *menu_item* should reserve space for the submenu indicator, regardless if it actually has a submenu or not.

There should be little need for applications to call this functions.

Since: 3.0

    method gtk_menu_item_set_reserve_indicator ( Int $reserve )

  * Int $reserve; the new value

[gtk_menu_item_] get_reserve_indicator
--------------------------------------

Returns whether the *menu_item* reserves space for the submenu indicator, regardless if it has a submenu or not.

Returns: `1` if *menu_item* always reserves space for the submenu indicator

Since: 3.0

    method gtk_menu_item_get_reserve_indicator ( --> Int  )

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

### activate

Emitted when the item is activated.

    method handler (
      Gnome::GObject::Object :widget($menuitem),
      *%user-options
    );

  * $menuitem; the object which received the signal.

### activate-item

Emitted when the item is activated, but also if the menu item has a submenu. For normal applications, the relevant signal is *activate*.

    method handler (
      Gnome::GObject::Object :widget($menuitem),
      *%user-options
    );

  * $menuitem; the object which received the signal.

### toggle-size-allocate

    method handler (
      Int $int,
      Gnome::GObject::Object :widget($menuitem),
      *%user-options
    );

  * $menuitem;

  * $int; ?

### select

    method handler (
      Gnome::GObject::Object :widget($menuitem),
      *%user-options
    );

  * $menuitem;

### deselect

    method handler (
      Gnome::GObject::Object :widget($menuitem),
      *%user-options
    );

  * $menuitem;

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Right Justified

Sets whether the menu item appears justified at the right side of a menu bar. Since: 2.14

The **Gnome::GObject::Value** type of property *right-justified* is `G_TYPE_BOOLEAN`.

### Accel Path

Sets the accelerator path of the menu item, through which runtime changes of the menu item's accelerator caused by the user can be identified and saved to persistant storage. Since: 2.14

The **Gnome::GObject::Value** type of property *accel-path* is `G_TYPE_STRING`.

### Label

The text for the child label. Since: 2.16

The **Gnome::GObject::Value** type of property *label* is `G_TYPE_STRING`.

### Use underline

`1` if underlines in the text indicate mnemonics. Since: 2.16

The **Gnome::GObject::Value** type of property *use-underline* is `G_TYPE_BOOLEAN`.

