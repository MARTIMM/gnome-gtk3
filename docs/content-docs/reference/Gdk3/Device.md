Gnome::Gdk3::Device
===================

Object representing an input device

Description
===========

The **Gnome::Gdk3::Device** object represents a single input device, such as a keyboard, a mouse, a touchpad, etc.

See the **Gnome::Gdk3::DeviceManager** documentation for more information about the various kinds of master and slave devices, and their relationships.

See Also
--------

**Gnome::Gdk3::DeviceManager**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Device;
    also is Gnome::GObject::Object;

Types
=====

enum GdkInputSource
-------------------

An enumeration describing the type of an input device in general terms.

  * GDK_SOURCE_MOUSE: the device is a mouse. (This will be reported for the core pointer, even if it is something else, such as a trackball.)

  * GDK_SOURCE_PEN: the device is a stylus of a graphics tablet or similar device.

  * GDK_SOURCE_ERASER: the device is an eraser. Typically, this would be the other end of a stylus on a graphics tablet.

  * GDK_SOURCE_CURSOR: the device is a graphics tablet “puck” or similar device.

  * GDK_SOURCE_KEYBOARD: the device is a keyboard.

  * GDK_SOURCE_TOUCHSCREEN: the device is a direct-input touch device, such as a touchscreen or tablet. This device type has been added in 3.4.

  * GDK_SOURCE_TOUCHPAD: the device is an indirect touch device, such as a touchpad. This device type has been added in 3.4.

  * GDK_SOURCE_TRACKPOINT: the device is a trackpoint. This device type has been added in 3.22

  * GDK_SOURCE_TABLET_PAD: the device is a "pad", a collection of buttons, rings and strips found in drawing tablets. This device type has been added in 3.22.

enum GdkInputMode
-----------------

An enumeration that describes the mode of an input device.

  * GDK_MODE_DISABLED: the device is disabled and will not report any events.

  * GDK_MODE_SCREEN: the device is enabled. The device’s coordinate space maps to the entire screen.

  * GDK_MODE_WINDOW: the device is enabled. The device’s coordinate space is mapped to a single window. The manner in which this window is chosen is undefined, but it will typically be the same way in which the focus window for key events is determined.

enum GdkDeviceType
------------------

Indicates the device type. See [above][**Gnome::Gdk3::DeviceManager**.description] for more information about the meaning of these device types.

  * GDK_DEVICE_TYPE_MASTER: Device is a master (or virtual) device. There will be an associated focus indicator on the screen.

  * GDK_DEVICE_TYPE_SLAVE: Device is a slave (or physical) device.

  * GDK_DEVICE_TYPE_FLOATING: Device is a physical device, currently not attached to any virtual device.

Methods
=======

new
---

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

[[gdk_] device_] get_name
-------------------------

Determines the name of the device.

Returns: a name

Since: 2.20

    method gdk_device_get_name ( --> Str  )

[[gdk_] device_] get_has_cursor
-------------------------------

Determines whether the pointer follows device motion. This is not meaningful for keyboard devices, which don't have a pointer.

Returns: `1` if the pointer follows device motion

Since: 2.20

    method gdk_device_get_has_cursor ( --> Int  )

[[gdk_] device_] get_source
---------------------------

Determines the type of the device.

Returns: a **Gnome::Gdk3::InputSource**

Since: 2.20

    method gdk_device_get_source ( --> GdkInputSource  )

[[gdk_] device_] get_mode
-------------------------

Determines the mode of the device.

Returns: a **Gnome::Gdk3::InputSource**

Since: 2.20

    method gdk_device_get_mode ( --> GdkInputMode  )

[[gdk_] device_] set_mode
-------------------------

Sets a the mode of an input device. The mode controls if the device is active and whether the device’s range is mapped to the entire screen or to a single window.

Note: This is only meaningful for floating devices, master devices (and slaves connected to these) drive the pointer cursor, which is not limited by the input mode.

Returns: `1` if the mode was successfully changed.

    method gdk_device_set_mode ( GdkInputMode $mode --> Int  )

  * GdkInputMode $mode; the input mode.

[[gdk_] device_] get_n_keys
---------------------------

Returns the number of keys the device currently has.

Returns: the number of keys.

Since: 2.24

    method gdk_device_get_n_keys ( --> Int  )

[[gdk_] device_] get_key
------------------------

If *index_* has a valid keyval, this function will return `1` and fill in *keyval* and *modifiers* with the keyval settings.

Returns: `1` if keyval is set for *index*.

Since: 2.20

    method gdk_device_get_key ( UInt $index_, UInt $keyval, GdkModifierType $modifiers --> Int  )

  * UInt $index_; the index of the macro button to get.

  * UInt $keyval; (out): return value for the keyval.

  * GdkModifierType $modifiers; (out): return value for modifiers.

[[gdk_] device_] set_key
------------------------

Specifies the X key event to generate when a macro button of a device is pressed.

    method gdk_device_set_key ( UInt $index_, UInt $keyval, GdkModifierType $modifiers )

  * UInt $index_; the index of the macro button to set

  * UInt $keyval; the keyval to generate

  * GdkModifierType $modifiers; the modifiers to set

[[gdk_] device_] get_state
--------------------------

Gets the current state of a pointer device relative to *window*. As a slave device’s coordinates are those of its master pointer, this function may not be called on devices of type `GDK_DEVICE_TYPE_SLAVE`, unless there is an ongoing grab on them. See `gdk_device_grab()`.

    method gdk_device_get_state ( N-GObject $window, Num $axes, GdkModifierType $mask )

  * N-GObject $window; a **Gnome::Gdk3::Window**.

  * Num $axes; (nullable) (array): an array of doubles to store the values of the axes of *device* in, or `Any`.

  * GdkModifierType $mask; (optional) (out): location to store the modifiers, or `Any`.

[[gdk_] device_] get_position
-----------------------------

Gets the current location of *device*. As a slave device coordinates are those of its master pointer, This function may not be called on devices of type `GDK_DEVICE_TYPE_SLAVE`, unless there is an ongoing grab on them, see `gdk_device_grab()`.

Since: 3.0

    method gdk_device_get_position ( N-GObject $screen, Int $x, Int $y )

  * N-GObject $screen; (out) (transfer none) (allow-none): location to store the **Gnome::Gdk3::Screen** the *device* is on, or `Any`.

  * Int $x; (out) (allow-none): location to store root window X coordinate of *device*, or `Any`.

  * Int $y; (out) (allow-none): location to store root window Y coordinate of *device*, or `Any`.

[[gdk_] device_] get_window_at_position
---------------------------------------

Obtains the window underneath *device*, returning the location of the device in *win_x* and *win_y*. Returns `Any` if the window tree under *device* is not known to GDK (for example, belongs to another application).

As a slave device coordinates are those of its master pointer, This function may not be called on devices of type `GDK_DEVICE_TYPE_SLAVE`, unless there is an ongoing grab on them, see `gdk_device_grab()`.

Returns: (nullable) (transfer none): the **Gnome::Gdk3::Window** under the device position, or `Any`.

Since: 3.0

    method gdk_device_get_window_at_position ( Int $win_x, Int $win_y --> N-GObject  )

  * Int $win_x; (out) (allow-none): return location for the X coordinate of the device location, relative to the window origin, or `Any`.

  * Int $win_y; (out) (allow-none): return location for the Y coordinate of the device location, relative to the window origin, or `Any`.

[[gdk_] device_] get_position_double
------------------------------------

Gets the current location of *device* in double precision. As a slave device's coordinates are those of its master pointer, this function may not be called on devices of type `GDK_DEVICE_TYPE_SLAVE`, unless there is an ongoing grab on them. See `gdk_device_grab()`.

Since: 3.10

    method gdk_device_get_position_double ( N-GObject $screen, Num $x, Num $y )

  * N-GObject $screen; (out) (transfer none) (allow-none): location to store the **Gnome::Gdk3::Screen** the *device* is on, or `Any`.

  * Num $x; (out) (allow-none): location to store root window X coordinate of *device*, or `Any`.

  * Num $y; (out) (allow-none): location to store root window Y coordinate of *device*, or `Any`.

[[gdk_] device_] get_window_at_position_double
----------------------------------------------

Obtains the window underneath *device*, returning the location of the device in *win_x* and *win_y* in double precision. Returns `Any` if the window tree under *device* is not known to GDK (for example, belongs to another application).

As a slave device coordinates are those of its master pointer, This function may not be called on devices of type `GDK_DEVICE_TYPE_SLAVE`, unless there is an ongoing grab on them, see `gdk_device_grab()`.

Returns: (nullable) (transfer none): the **Gnome::Gdk3::Window** under the device position, or `Any`.

Since: 3.0

    method gdk_device_get_window_at_position_double ( Num $win_x, Num $win_y --> N-GObject  )

  * Num $win_x; (out) (allow-none): return location for the X coordinate of the device location, relative to the window origin, or `Any`.

  * Num $win_y; (out) (allow-none): return location for the Y coordinate of the device location, relative to the window origin, or `Any`.

[[gdk_] device_] get_n_axes
---------------------------

Returns the number of axes the device currently has.

Returns: the number of axes.

Since: 3.0

    method gdk_device_get_n_axes ( --> Int  )

[[gdk_] device_] list_axes
--------------------------

Returns a **GList** of **Gnome::Gdk3::Atoms**, containing the labels for the axes that *device* currently has.

Returns: (transfer container) (element-type **Gnome::Gdk3::Atom**): A **GList** of **Gnome::Gdk3::Atoms**, free with `g_list_free()`.

Since: 3.0

    method gdk_device_list_axes ( --> N-GList  )

[[gdk_] device_] get_display
----------------------------

Returns the **Gnome::Gdk3::Display** to which *device* pertains.

Returns: (transfer none): a **Gnome::Gdk3::Display**. This memory is owned by GTK+, and must not be freed or unreffed.

Since: 3.0

    method gdk_device_get_display ( --> N-GObject  )

[[gdk_] device_] get_associated_device
--------------------------------------

Returns the associated device to *device*, if *device* is of type `GDK_DEVICE_TYPE_MASTER`, it will return the paired pointer or keyboard.

If *device* is of type `GDK_DEVICE_TYPE_SLAVE`, it will return the master device to which *device* is attached to.

If *device* is of type `GDK_DEVICE_TYPE_FLOATING`, `Any` will be returned, as there is no associated device.

Returns: (nullable) (transfer none): The associated device, or `Any`

Since: 3.0

    method gdk_device_get_associated_device ( --> N-GObject  )

[[gdk_] device_] list_slave_devices
-----------------------------------

If the device if of type `GDK_DEVICE_TYPE_MASTER`, it will return the list of slave devices attached to it, otherwise it will return `Any`

Returns: (nullable) (transfer container) (element-type **Gnome::Gdk3::Device**): the list of slave devices, or `Any`. The list must be freed with `g_list_free()`, the contents of the list are owned by GTK+ and should not be freed.

    method gdk_device_list_slave_devices ( --> N-GList  )

[[gdk_] device_] get_device_type
--------------------------------

Returns the device type for *device*.

Returns: the **Gnome::Gdk3::DeviceType** for *device*.

Since: 3.0

    method gdk_device_get_device_type ( --> GdkDeviceType  )

gdk_device_warp
---------------

Warps *device* in *display* to the point *x*,*y* on the screen *screen*, unless the device is confined to a window by a grab, in which case it will be moved as far as allowed by the grab. Warping the pointer creates events as if the user had moved the mouse instantaneously to the destination.

Note that the pointer should normally be under the control of the user. This function was added to cover some rare use cases like keyboard navigation support for the color picker in the **Gnome::Gtk3::ColorSelectionDialog**.

Since: 3.0

    method gdk_device_warp ( N-GObject $screen, Int $x, Int $y )

  * N-GObject $screen; the screen to warp *device* to.

  * Int $x; the X coordinate of the destination.

  * Int $y; the Y coordinate of the destination.

[[gdk_] device_] get_last_event_window
--------------------------------------

Gets information about which window the given pointer device is in, based on events that have been received so far from the display server. If another application has a pointer grab, or this application has a grab with owner_events = `0`, `Any` may be returned even if the pointer is physically over one of this application's windows.

Returns: (transfer none) (allow-none): the last window the device

Since: 3.12

    method gdk_device_get_last_event_window ( --> N-GObject  )

[[gdk_] device_] get_vendor_id
------------------------------

Returns the vendor ID of this device, or `Any` if this information couldn't be obtained. This ID is retrieved from the device, and is thus constant for it.

This function, together with `gdk_device_get_product_id()`, can be used to eg. compose **GSettings** paths to store settings for this device.

|[<!-- language="C" --> static GSettings * get_device_settings (**Gnome::Gdk3::Device** *device) { const gchar *vendor, *product; GSettings *settings; **Gnome::Gdk3::Device** *device; gchar *path;

vendor = gdk_device_get_vendor_id (device); product = gdk_device_get_product_id (device);

path = g_strdup_printf ("/org/example/app/devices/`s`:`s`/", vendor, product); settings = g_settings_new_with_path (DEVICE_SCHEMA, path); g_free (path);

return settings; } ]|

Returns: (nullable): the vendor ID, or `Any`

Since: 3.16

    method gdk_device_get_vendor_id ( --> Str  )

[[gdk_] device_] get_product_id
-------------------------------

Returns the product ID of this device, or `Any` if this information couldn't be obtained. This ID is retrieved from the device, and is thus constant for it. See `gdk_device_get_vendor_id()` for more information.

Returns: (nullable): the product ID, or `Any`

Since: 3.16

    method gdk_device_get_product_id ( --> Str  )

[[gdk_] device_] get_seat
-------------------------

Returns the **Gnome::Gdk3::Seat** the device belongs to.

Returns: (transfer none): A **Gnome::Gdk3::Seat**. This memory is owned by GTK+ and must not be freed.

Since: 3.20

    method gdk_device_get_seat ( --> N-GObject  )

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

### changed

The *changed* signal is emitted either when the **Gnome::Gdk3::Device** has changed the number of either axes or keys. For example In X this will normally happen when the slave device routing events through the master device changes (for example, user switches from the USB mouse to a tablet), in that case the master device will change to reflect the new slave device axes and keys.

    method handler (
      Gnome::GObject::Object :widget($device),
      *%user-options
    );

  * $device; the **Gnome::Gdk3::Device** that changed.

### tool-changed

The *tool-changed* signal is emitted on pen/eraser **Gnome::Gdk3::Devices** whenever tools enter or leave proximity.

Since: 3.22

    method handler (
      N-GObject #`{{ native Gnome::Gdk3::DeviceTool }} $tool,
      Gnome::GObject::Object :widget($device),
      *%user-options
    );

  * $device; the **Gnome::Gdk3::Device** that changed.

  * $tool; The new current tool

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Device manager

The **Gnome::Gdk3::DeviceManager** the **Gnome::Gdk3::Device** pertains to. Since: 3.0 Widget type: GDK_TYPE_DEVICE_MANAGER

The **Gnome::GObject::Value** type of property *device-manager* is `G_TYPE_OBJECT`.

### Device name

The device name. Since: 3.0

The **Gnome::GObject::Value** type of property *name* is `G_TYPE_STRING`.

### Device type

Device role in the device manager. Since: 3.0 Widget type: GDK_TYPE_DEVICE_TYPE

The **Gnome::GObject::Value** type of property *type* is `G_TYPE_ENUM`.

### Input source

Source type for the device. Since: 3.0 Widget type: GDK_TYPE_INPUT_SOURCE

The **Gnome::GObject::Value** type of property *input-source* is `G_TYPE_ENUM`.

### Input mode for the device

Input mode for the device Default value: False

The **Gnome::GObject::Value** type of property *input-mode* is `G_TYPE_ENUM`.

### Whether the device has a cursor

Whether the device is represented by a cursor on the screen. Devices of type `GDK_DEVICE_TYPE_MASTER` will have `1` here. Since: 3.0

The **Gnome::GObject::Value** type of property *has-cursor* is `G_TYPE_BOOLEAN`.

### Number of axes in the device

Number of axes in the device. Since: 3.0

The **Gnome::GObject::Value** type of property *n-axes* is `G_TYPE_UINT`.

### Vendor ID

Vendor ID of this device, see `gdk_device_get_vendor_id()`. Since: 3.16

The **Gnome::GObject::Value** type of property *vendor-id* is `G_TYPE_STRING`.

### Product ID

Product ID of this device, see `gdk_device_get_product_id()`. Since: 3.16

The **Gnome::GObject::Value** type of property *product-id* is `G_TYPE_STRING`.

### Number of concurrent touches

The maximal number of concurrent touches on a touch device. Will be 0 if the device is not a touch device or if the number of touches is unknown. Since: 3.20

The **Gnome::GObject::Value** type of property *num-touches* is `G_TYPE_UINT`.

### Axes

The axes currently available for this device. Since: 3.22

The **Gnome::GObject::Value** type of property *axes* is `G_TYPE_FLAGS`.

### Tool

The tool that is currently used with this device Widget type: GDK_TYPE_DEVICE_TOOL

The **Gnome::GObject::Value** type of property *tool* is `G_TYPE_OBJECT`.

