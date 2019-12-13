Gnome::Gtk3::CellRendererAccel
==============================

Renders a keyboard accelerator in a cell

Description
===========

**Gnome::Gtk3::CellRendererAccel** displays a keyboard accelerator (i.e. a key combination like `Control + a`). If the cell renderer is editable, the accelerator can be changed by simply typing the new combination.

The **Gnome::Gtk3::CellRendererAccel** cell renderer was added in GTK+ 2.10.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererAccel;
    also is Gnome::Gtk3::CellRendererText;

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

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_cell_renderer_accel_new
---------------------------

Creates a new **Gnome::Gtk3::CellRendererAccel**.

Returns: the new cell renderer

Since: 2.10

    method gtk_cell_renderer_accel_new ( --> N-GObject  )

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

### accel-edited

Gets emitted when the user has selected a new accelerator.

Since: 2.10

    method handler (
      Str $path_string,
      uint32 $accel_key,
      uint32 $accel_mods,
      uint32 $hardware_keycode,
      Gnome::GObject::Object :widget($accel),
      *%user-options
      --> Int
    );

  * $accel; the object reveiving the signal

  * $path_string; the path identifying the row of the edited cell

  * $accel_key; the new accelerator keyval

  * $accel_mods; the new acclerator modifier mask defined in Gnome::Gdk3::Window as enum GdkModifierType

  * $hardware_keycode; the keycode of the new accelerator

### accel-cleared

Gets emitted when the user has removed the accelerator.

Since: 2.10

    method handler (
      Str $path_string,
      Gnome::GObject::Object :widget($accel),
      *%user-options
    );

  * $accel; the object reveiving the signal

  * $path_string; the path identifying the row of the edited cell

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Accelerator key

The keyval of the accelerator. Since: 2.10

The **Gnome::GObject::Value** type of property *accel-key* is `G_TYPE_UINT`.

### Accelerator modifiers

The modifier mask of the accelerator. Since: 2.10

The **Gnome::GObject::Value** type of property *accel-mods* is `G_TYPE_FLAGS`.

### Accelerator keycode

The hardware keycode of the accelerator. Note that the hardware keycode is only relevant if the key does not have a keyval. Normally, the keyboard configuration should assign keyvals to all keys. Since: 2.10

The **Gnome::GObject::Value** type of property *keycode* is `G_TYPE_UINT`.

### Accelerator Mode

Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus. Since: 2.10 Widget type: GTK_TYPE_CELL_RENDERER_ACCEL_MODE

The **Gnome::GObject::Value** type of property *accel-mode* is `G_TYPE_ENUM`.

### NULL

NULL Default value: False

The **Gnome::GObject::Value** type of property *accel-mode* is `G_TYPE_ENUM`.

### NULL

NULL Default value: Any

The **Gnome::GObject::Value** type of property *path* is `G_TYPE_STRING`.

