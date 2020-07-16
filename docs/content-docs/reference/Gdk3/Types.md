Gnome::Gdk3::Types
==================

Description
===========

Types for the Gdk modules

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Types;

Types
=====

enum GdkByteOrder
-----------------

A set of values describing the possible byte-orders for storing pixel values in memory.

  * GDK_LSB_FIRST: The values are stored with the least-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0xcc, 0xee, 0xff, 0x00.

  * GDK_MSB_FIRST: The values are stored with the most-significant byte first. For instance, the 32-bit value 0xffeecc would be stored in memory as 0x00, 0xff, 0xee, 0xcc.

enum GdkModifierType
--------------------

A set of bit-flags to indicate the state of modifier keys and mouse buttons in various event types. Typical modifier keys are Shift, Control, Meta, Super, Hyper, Alt, Compose, Apple, CapsLock or ShiftLock.

Like the X Window System, GDK supports 8 modifier keys and 5 mouse buttons.

Since 2.10, GDK recognizes which of the Meta, Super or Hyper keys are mapped to Mod2 - Mod5, and indicates this by setting `GDK_SUPER_MASK`, `GDK_HYPER_MASK` or `GDK_META_MASK` in the state field of key events.

Note that GDK may add internal values to events which include reserved values such as `GDK_MODIFIER_RESERVED_13_MASK`. Your code should preserve and ignore them. You can use `GDK_MODIFIER_MASK` to remove all reserved values.

Also note that the GDK X backend interprets button press events for button 4-7 as scroll events, so `GDK_BUTTON4_MASK` and `GDK_BUTTON5_MASK` will never be set.

  * GDK_SHIFT_MASK: the Shift key.

  * GDK_LOCK_MASK: a Lock key (depending on the modifier mapping of the X server this may either be CapsLock or ShiftLock).

  * GDK_CONTROL_MASK: the Control key.

  * GDK_MOD1_MASK: the fourth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier, but normally it is the Alt key).

  * GDK_MOD2_MASK: the fifth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).

  * GDK_MOD3_MASK: the sixth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).

  * GDK_MOD4_MASK: the seventh modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).

  * GDK_MOD5_MASK: the eighth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).

  * GDK_BUTTON1_MASK: the first mouse button.

  * GDK_BUTTON2_MASK: the second mouse button.

  * GDK_BUTTON3_MASK: the third mouse button.

  * GDK_BUTTON4_MASK: the fourth mouse button.

  * GDK_BUTTON5_MASK: the fifth mouse button.

  * GDK_MODIFIER_RESERVED_13_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_14_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_15_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_16_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_17_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_18_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_19_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_20_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_21_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_22_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_23_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_24_MASK: A reserved bit flag; do not use in your own code

  * GDK_MODIFIER_RESERVED_25_MASK: A reserved bit flag; do not use in your own code

  * GDK_SUPER_MASK: the Super modifier. Since 2.10

  * GDK_HYPER_MASK: the Hyper modifier. Since 2.10

  * GDK_META_MASK: the Meta modifier. Since 2.10

  * GDK_MODIFIER_RESERVED_29_MASK: A reserved bit flag; do not use in your own code

  * GDK_RELEASE_MASK: not used in GDK itself. GTK+ uses it to differentiate between (keyval, modifiers) pairs from key press and release events.

  * GDK_MODIFIER_MASK: a mask covering all modifier types.

enum GdkModifierIntent
----------------------

This enum is used with `gdk_keymap_get_modifier_mask()` in order to determine what modifiers the currently used windowing system backend uses for particular purposes. For example, on X11/Windows, the Control key is used for invoking menu shortcuts (accelerators), whereas on Apple computers it’s the Command key (which correspond to `GDK_CONTROL_MASK` and `GDK_MOD2_MASK`, respectively).

Since: 3.4

  * GDK_MODIFIER_INTENT_PRIMARY_ACCELERATOR: the primary modifier used to invoke menu accelerators.

  * GDK_MODIFIER_INTENT_CONTEXT_MENU: the modifier used to invoke context menus. Note that mouse button 3 always triggers context menus. When this modifier is not 0, it additionally triggers context menus when used with mouse button 1.

  * GDK_MODIFIER_INTENT_EXTEND_SELECTION: the modifier used to extend selections using `modifier`-click or `modifier`-cursor-key

  * GDK_MODIFIER_INTENT_MODIFY_SELECTION: the modifier used to modify selections, which in most cases means toggling the clicked item into or out of the selection.

  * GDK_MODIFIER_INTENT_NO_TEXT_INPUT: when any of these modifiers is pressed, the key event cannot produce a symbol directly. This is meant to be used for input methods, and for use cases like typeahead search.

  * GDK_MODIFIER_INTENT_SHIFT_GROUP: the modifier that switches between keyboard groups (AltGr on X11/Windows and Option/Alt on OS X).

  * GDK_MODIFIER_INTENT_DEFAULT_MOD_MASK: The set of modifier masks accepted as modifiers in accelerators. Needed because Command is mapped to MOD2 on OSX, which is widely used, but on X11 MOD2 is NumLock and using that for a mod key is problematic at best. Ref: https://bugzilla.gnome.org/show_bug.cgi?id=736125.

enum GdkStatus
--------------

enum GdkGrabStatus
------------------

Returned by `gdk_device_grab()`, `gdk_pointer_grab()` and `gdk_keyboard_grab()` to indicate success or the reason for the failure of the grab attempt.

  * GDK_GRAB_SUCCESS: the resource was successfully grabbed.

  * GDK_GRAB_ALREADY_GRABBED: the resource is actively grabbed by another client.

  * GDK_GRAB_INVALID_TIME: the resource was grabbed more recently than the specified time.

  * GDK_GRAB_NOT_VIEWABLE: the grab window or the *confine_to* window are not viewable.

  * GDK_GRAB_FROZEN: the resource is frozen by an active grab of another client.

  * GDK_GRAB_FAILED: the grab failed for some other reason. Since 3.16

enum GdkGrabOwnership
---------------------

Defines how device grabs interact with other devices.

  * GDK_OWNERSHIP_NONE: All other devices’ events are allowed.

  * GDK_OWNERSHIP_WINDOW: Other devices’ events are blocked for the grab window.

  * GDK_OWNERSHIP_APPLICATION: Other devices’ events are blocked for the whole application.

enum N-GdkEventMask
-------------------

A set of bit-flags to indicate which events a window is to receive. Most of these masks map onto one or more of the **Gnome::Gdk3::EventType** event types above.

See the [input handling overview][chap-input-handling] for details of [event masks][event-masks] and [event propagation][event-propagation].

`GDK_POINTER_MOTION_HINT_MASK` is deprecated. It is a special mask to reduce the number of `GDK_MOTION_NOTIFY` events received. When using `GDK_POINTER_MOTION_HINT_MASK`, fewer `GDK_MOTION_NOTIFY` events will be sent, some of which are marked as a hint (the is_hint member is `1`). To receive more motion events after a motion hint event, the application needs to asks for more, by calling `gdk_event_request_motions()`.

Since GTK 3.8, motion events are already compressed by default, independent of this mechanism. This compression can be disabled with `gdk_window_set_event_compression()`. See the documentation of that function for details.

If `GDK_TOUCH_MASK` is enabled, the window will receive touch events from touch-enabled devices. Those will come as sequences of **Gnome::Gdk3::EventTouch** with type `GDK_TOUCH_UPDATE`, enclosed by two events with type `GDK_TOUCH_BEGIN` and `GDK_TOUCH_END` (or `GDK_TOUCH_CANCEL`). `gdk_event_get_event_sequence()` returns the event sequence for these events, so different sequences may be distinguished.

  * GDK_EXPOSURE_MASK: receive expose events

  * GDK_POINTER_MOTION_MASK: receive all pointer motion events

  * GDK_POINTER_MOTION_HINT_MASK: deprecated. see the explanation above

  * GDK_BUTTON_MOTION_MASK: receive pointer motion events while any button is pressed

  * GDK_BUTTON1_MOTION_MASK: receive pointer motion events while 1 button is pressed

  * GDK_BUTTON2_MOTION_MASK: receive pointer motion events while 2 button is pressed

  * GDK_BUTTON3_MOTION_MASK: receive pointer motion events while 3 button is pressed

  * GDK_BUTTON_PRESS_MASK: receive button press events

  * GDK_BUTTON_RELEASE_MASK: receive button release events

  * GDK_KEY_PRESS_MASK: receive key press events

  * GDK_KEY_RELEASE_MASK: receive key release events

  * GDK_ENTER_NOTIFY_MASK: receive window enter events

  * GDK_LEAVE_NOTIFY_MASK: receive window leave events

  * GDK_FOCUS_CHANGE_MASK: receive focus change events

  * GDK_STRUCTURE_MASK: receive events about window configuration change

  * GDK_PROPERTY_CHANGE_MASK: receive property change events

  * GDK_VISIBILITY_NOTIFY_MASK: receive visibility change events

  * GDK_PROXIMITY_IN_MASK: receive proximity in events

  * GDK_PROXIMITY_OUT_MASK: receive proximity out events

  * GDK_SUBSTRUCTURE_MASK: receive events about window configuration changes of child windows

  * GDK_SCROLL_MASK: receive scroll events

  * GDK_TOUCH_MASK: receive touch events. Since 3.4

  * GDK_SMOOTH_SCROLL_MASK: receive smooth scrolling events. Since 3.4

  * GDK_TABLET_PAD_MASK: receive tablet pad events. Since 3.22

  * GDK_ALL_EVENTS_MASK: the combination of all the above event masks.

enum GdkGLError
---------------

Error enumeration for **Gnome::Gdk3::GLContext**.

Since: 3.16

  * GDK_GL_ERROR_NOT_AVAILABLE: OpenGL support is not available

  * GDK_GL_ERROR_UNSUPPORTED_FORMAT: The requested visual format is not supported

  * GDK_GL_ERROR_UNSUPPORTED_PROFILE: The requested profile is not supported

enum GdkWindowTypeHint
----------------------

These are hints for the window manager that indicate what type of function the window has. The window manager can use this when determining decoration and behaviour of the window. The hint must be set before mapping the window.

See the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec) specification for more details about window types.

  * GDK_WINDOW_TYPE_HINT_NORMAL: Normal toplevel window.

  * GDK_WINDOW_TYPE_HINT_DIALOG: Dialog window.

  * GDK_WINDOW_TYPE_HINT_MENU: Window used to implement a menu; GTK+ uses this hint only for torn-off menus, see **Gnome::Gtk3::TearoffMenuItem**.

  * GDK_WINDOW_TYPE_HINT_TOOLBAR: Window used to implement toolbars.

  * GDK_WINDOW_TYPE_HINT_SPLASHSCREEN: Window used to display a splash screen during application startup.

  * GDK_WINDOW_TYPE_HINT_UTILITY: Utility windows which are not detached toolbars or dialogs.

  * GDK_WINDOW_TYPE_HINT_DOCK: Used for creating dock or panel windows.

  * GDK_WINDOW_TYPE_HINT_DESKTOP: Used for creating the desktop background window.

  * GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU: A menu that belongs to a menubar.

  * GDK_WINDOW_TYPE_HINT_POPUP_MENU: A menu that does not belong to a menubar, e.g. a context menu.

  * GDK_WINDOW_TYPE_HINT_TOOLTIP: A tooltip.

  * GDK_WINDOW_TYPE_HINT_NOTIFICATION: A notification - typically a “bubble” that belongs to a status icon.

  * GDK_WINDOW_TYPE_HINT_COMBO: A popup from a combo box.

  * GDK_WINDOW_TYPE_HINT_DND: A window that is used to implement a DND cursor.

enum GdkAxisUse
---------------

An enumeration describing the way in which a device axis (valuator) maps onto the predefined valuator types that GTK+ understands.

Note that the X and Y axes are not really needed; pointer devices report their location via the x/y members of events regardless. Whether X and Y are present as axes depends on the GDK backend.

  * GDK_AXIS_IGNORE: the axis is ignored.

  * GDK_AXIS_X: the axis is used as the x axis.

  * GDK_AXIS_Y: the axis is used as the y axis.

  * GDK_AXIS_PRESSURE: the axis is used for pressure information.

  * GDK_AXIS_XTILT: the axis is used for x tilt information.

  * GDK_AXIS_YTILT: the axis is used for y tilt information.

  * GDK_AXIS_WHEEL: the axis is used for wheel information.

  * GDK_AXIS_DISTANCE: the axis is used for pen/tablet distance information. (Since: 3.22)

  * GDK_AXIS_ROTATION: the axis is used for pen rotation information. (Since: 3.22)

  * GDK_AXIS_SLIDER: the axis is used for pen slider information. (Since: 3.22)

  * GDK_AXIS_LAST: a constant equal to the numerically highest axis value.

enum GdkAxisFlags
-----------------

Flags describing the current capabilities of a device/tool.

Since: 3.22

  * GDK_AXIS_FLAG_X: X axis is present

  * GDK_AXIS_FLAG_Y: Y axis is present

  * GDK_AXIS_FLAG_PRESSURE: Pressure axis is present

  * GDK_AXIS_FLAG_XTILT: X tilt axis is present

  * GDK_AXIS_FLAG_YTILT: Y tilt axis is present

  * GDK_AXIS_FLAG_WHEEL: Wheel axis is present

  * GDK_AXIS_FLAG_DISTANCE: Distance axis is present

  * GDK_AXIS_FLAG_ROTATION: Z-axis rotation is present

  * GDK_AXIS_FLAG_SLIDER: Slider axis is present

class N-GdkRectangle
--------------------

Defines the position and size of a rectangle. It is identical to **cairo_rectangle_int_t**.

  * Int $.x;

  * Int $.y;

  * Int $.width;

  * Int $.height;

class N-GdkPoint
----------------

Defines the x and y coordinates of a point.

  * Int $.x: the x coordinate of the point.

  * Int $.y: the y coordinate of the point.

