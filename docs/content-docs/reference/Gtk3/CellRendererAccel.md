Gnome::Gtk3::CellRendererAccel
==============================

Renders a keyboard accelerator in a cell

Description
===========

**Gnome::Gtk3::CellRendererAccel** displays a keyboard accelerator (i.e. a key combination like `Control + a`). If the cell renderer is editable, the accelerator can be changed by simply typing the new combination.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererAccel;
    also is Gnome::Gtk3::CellRendererText;

Uml Diagram
-----------

![](plantuml/CellRenderer-ea.svg)

Types
=====

enum GtkCellRendererAccelMode
-----------------------------

Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus.

  * GTK_CELL_RENDERER_ACCEL_MODE_GTK: GTK+ accelerators mode

  * GTK_CELL_RENDERER_ACCEL_MODE_OTHER: Other accelerator mode

Methods
=======

new
---

### default, no options

Create a new plain object.

    multi method new ( )

### :native-object

Create a CellRendererAccel object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Signals
=======

accel-cleared
-------------

Gets emitted when the user has removed the accelerator.

    method handler (
      Str $path_string,
      Gnome::Gtk3::CellRendererAccel :_widget($accel),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path_string; the path identifying the row of the edited cell

  * $accel; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

accel-edited
------------

Gets emitted when the user has selected a new accelerator.

    method handler (
      Str $path_string,
      Int $accel_key,
      GdkModifierType #`{ from Gnome::Gdk3::Window } $accel_mods,
      Int $hardware_keycode,
      Gnome::Gtk3::CellRendererAccel :_widget($accel),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path_string; the path identifying the row of the edited cell

  * $accel_key; the new accelerator keyval

  * $accel_mods; the new acclerator modifier mask

  * $hardware_keycode; the keycode of the new accelerator

  * $accel; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

Accelerator key: accel-key
--------------------------

The keyval of the accelerator.

The **Gnome::GObject::Value** type of property *accel-key* is `G_TYPE_UINT`.

accel-mode
----------

Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus.

Default value: False

The **Gnome::GObject::Value** type of property *accel-mode* is `G_TYPE_ENUM`.

Accelerator modifiers: accel-mods
---------------------------------

The modifier mask of the accelerator.

The **Gnome::GObject::Value** type of property *accel-mods* is `G_TYPE_FLAGS`.

Accelerator keycode: keycode
----------------------------

The hardware keycode of the accelerator. Note that the hardware keycode is only relevant if the key does not have a keyval. Normally, the keyboard configuration should assign keyvals to all keys.

The **Gnome::GObject::Value** type of property *keycode* is `G_TYPE_UINT`.

