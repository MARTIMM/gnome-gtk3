Gnome::Gdk3::Events
===================

Functions for handling events from the window system

Description
===========

This section describes functions dealing with events from the window system.

In GTK+ applications the events are handled automatically in `gtk_main_do_event()` and passed on to the appropriate widgets, so these functions are rarely needed. Though some of the fields in the gdk event structures are useful.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Events;
    also is Gnome::N::TopLevelClassSupport;

Example
-------

    my Gnome::Gtk3::Window $top-window .= new;
    $top-window.set-title('Hello GTK!');
    # ... etcetera ...

    # Define a handler method
    method handle-keypress ( N-GdkEvent $event, :$widget ) {
      if $event.event-any.type ~~ GDK_KEY_PRESS {
        my N-GdkEventKey $event-key = $event;
        if Buf.new($event.event-key.keyval).decode eq 's' {
          # key 's' pressed, stop process ...
        }
      }
    }

    # And register the signal handler for a window event
    $top-window.register-signal( self, 'handle-keypress', 'key-press-event');

If the handler handles only one event type, the method can also be defined as

    method handle-keypress ( N-GdkEventKey $event-key, :$widget ) {
      if $event-key.type ~~ GDK_KEY_PRESS and
        Buf.new($event-key.keyval).decode eq 's' {
        # key 's' pressed, stop process ...
      }
    }

Types
=====

enum GdkCrossingMode
--------------------

Specifies the crossing mode for **Gnome::Gdk3::EventCrossing**.

  * GDK_CROSSING_NORMAL: crossing because of pointer motion.

  * GDK_CROSSING_GRAB: crossing because a grab is activated.

  * GDK_CROSSING_UNGRAB: crossing because a grab is deactivated.

  * GDK_CROSSING_GTK_GRAB: crossing because a GTK+ grab is activated.

  * GDK_CROSSING_GTK_UNGRAB: crossing because a GTK+ grab is deactivated.

  * GDK_CROSSING_STATE_CHANGED: crossing because a GTK+ widget changed state (e.g. sensitivity).

  * GDK_CROSSING_TOUCH_BEGIN: crossing because a touch sequence has begun, this event is synthetic as the pointer might have not left the window.

  * GDK_CROSSING_TOUCH_END: crossing because a touch sequence has ended, this event is synthetic as the pointer might have not left the window.

  * GDK_CROSSING_DEVICE_SWITCH: crossing because of a device switch (i.e. a mouse taking control of the pointer after a touch device), this event is synthetic as the pointer didn’t leave the window.

enum GdkEventType
-----------------

Specifies the type of the event.

Do not confuse these events with the signals that GTK+ widgets emit. Although many of these events result in corresponding signals being emitted, the events are often transformed or filtered along the way.

In some language bindings, the values `GDK-2BUTTON-PRESS` and `GDK-3BUTTON-PRESS` would translate into something syntactically invalid (eg `Gdk.EventType.2ButtonPress`, where a symbol is not allowed to start with a number). In that case, the aliases `GDK-DOUBLE-BUTTON-PRESS` and `GDK-TRIPLE-BUTTON-PRESS` can be used instead.

  * GDK_NOTHING: a special code to indicate a null event.

  * GDK_DELETE: the window manager has requested that the toplevel window be hidden or destroyed, usually when the user clicks on a special icon in the title bar.

  * GDK_DESTROY: the window has been destroyed.

  * GDK_EXPOSE: all or part of the window has become visible and needs to be redrawn.

  * GDK_MOTION_NOTIFY: the pointer (usually a mouse) has moved.

  * GDK_BUTTON_PRESS: a mouse button has been pressed.

  * GDK_2BUTTON_PRESS: a mouse button has been double-clicked (clicked twice within a short period of time). Note that each click also generates a `GDK_BUTTON_PRESS` event.

  * GDK_DOUBLE_BUTTON_PRESS: alias for `GDK_2BUTTON_PRESS`, added in 3.6.

  * GDK_3BUTTON_PRESS: a mouse button has been clicked 3 times in a short period of time. Note that each click also generates a `GDK_BUTTON_PRESS` event.

  * GDK_TRIPLE_BUTTON_PRESS: alias for `GDK_3BUTTON_PRESS`, added in 3.6.

  * GDK_BUTTON_RELEASE: a mouse button has been released.

  * GDK_KEY_PRESS: a key has been pressed.

  * GDK_KEY_RELEASE: a key has been released.

  * GDK_ENTER_NOTIFY: the pointer has entered the window.

  * GDK_LEAVE_NOTIFY: the pointer has left the window.

  * GDK_FOCUS_CHANGE: the keyboard focus has entered or left the window.

  * GDK_CONFIGURE: the size, position or stacking order of the window has changed. Note that GTK+ discards these events for `GDK_WINDOW_CHILD` windows.

  * GDK_MAP: the window has been mapped.

  * GDK_UNMAP: the window has been unmapped.

  * GDK_PROPERTY_NOTIFY: a property on the window has been changed or deleted.

  * GDK_SELECTION_CLEAR: the application has lost ownership of a selection.

  * GDK_SELECTION_REQUEST: another application has requested a selection.

  * GDK_SELECTION_NOTIFY: a selection has been received.

  * GDK_PROXIMITY_IN: an input device has moved into contact with a sensing surface (e.g. a touchscreen or graphics tablet).

  * GDK_PROXIMITY_OUT: an input device has moved out of contact with a sensing surface.

  * GDK_DRAG_ENTER: the mouse has entered the window while a drag is in progress.

  * GDK_DRAG_LEAVE: the mouse has left the window while a drag is in progress.

  * GDK_DRAG_MOTION: the mouse has moved in the window while a drag is in progress.

  * GDK_DRAG_STATUS: the status of the drag operation initiated by the window has changed.

  * GDK_DROP_START: a drop operation onto the window has started.

  * GDK_DROP_FINISHED: the drop operation initiated by the window has completed.

  * GDK_CLIENT_EVENT: a message has been received from another application.

  * GDK_VISIBILITY_NOTIFY: the window visibility status has changed.

  * GDK_SCROLL: the scroll wheel was turned

  * GDK_WINDOW_STATE: the state of a window has changed. See **Gnome::Gdk3::WindowState** for the possible window states

  * GDK_SETTING: a setting has been modified.

  * GDK_OWNER_CHANGE: the owner of a selection has changed. This event type was added in 2.6

  * GDK_GRAB_BROKEN: a pointer or keyboard grab was broken. This event type was added in 2.8.

  * GDK_DAMAGE: the content of the window has been changed. This event type was added in 2.14.

  * GDK_TOUCH_BEGIN: A new touch event sequence has just started. This event type was added in 3.4.

  * GDK_TOUCH_UPDATE: A touch event sequence has been updated. This event type was added in 3.4.

  * GDK_TOUCH_END: A touch event sequence has finished. This event type was added in 3.4.

  * GDK_TOUCH_CANCEL: A touch event sequence has been canceled. This event type was added in 3.4.

  * GDK_TOUCHPAD_SWIPE: A touchpad swipe gesture event, the current state is determined by its phase field. This event type was added in 3.18.

  * GDK_TOUCHPAD_PINCH: A touchpad pinch gesture event, the current state is determined by its phase field. This event type was added in 3.18.

  * GDK_PAD_BUTTON_PRESS: A tablet pad button press event. This event type was added in 3.22.

  * GDK_PAD_BUTTON_RELEASE: A tablet pad button release event. This event type was added in 3.22.

  * GDK_PAD_RING: A tablet pad axis event from a "ring". This event type was added in 3.22.

  * GDK_PAD_STRIP: A tablet pad axis event from a "strip". This event type was added in 3.22.

  * GDK_PAD_GROUP_MODE: A tablet pad group mode change. This event type was added in 3.22.

  * GDK_EVENT_LAST: marks the end of the GdkEventType enumeration. Added in 2.18

enum GdkNotifyType
------------------

Specifies the kind of crossing for **Gnome::Gdk3::EventCrossing**.

See the X11 protocol specification of LeaveNotify for full details of crossing event generation.

  * GDK_NOTIFY_ANCESTOR: the window is entered from an ancestor or left towards an ancestor.

  * GDK_NOTIFY_VIRTUAL: the pointer moves between an ancestor and an inferior of the window.

  * GDK_NOTIFY_INFERIOR: the window is entered from an inferior or left towards an inferior.

  * GDK_NOTIFY_NONLINEAR: the window is entered from or left towards a window which is neither an ancestor nor an inferior.

  * GDK_NOTIFY_NONLINEAR_VIRTUAL: the pointer moves between two windows which are not ancestors of each other and the window is part of the ancestor chain between one of these windows and their least common ancestor.

  * GDK_NOTIFY_UNKNOWN: an unknown type of enter/leave event occurred.

enum GdkOwnerChange
-------------------

Specifies why a selection ownership was changed.

  * GDK_OWNER_CHANGE_NEW_OWNER: some other app claimed the ownership

  * GDK_OWNER_CHANGE_DESTROY: the window was destroyed

  * GDK_OWNER_CHANGE_CLOSE: the client was closed

enum GdkPropertyState
---------------------

Specifies the type of a property change for a **Gnome::Gdk3::EventProperty**.

  * GDK_PROPERTY_NEW_VALUE: the property value was changed.

  * GDK_PROPERTY_DELETE: the property was deleted.

enum GdkScrollDirection
-----------------------

Specifies the direction for **Gnome::Gdk3::EventScroll**.

  * GDK_SCROLL_UP: the window is scrolled up.

  * GDK_SCROLL_DOWN: the window is scrolled down.

  * GDK_SCROLL_LEFT: the window is scrolled to the left.

  * GDK_SCROLL_RIGHT: the window is scrolled to the right.

  * GDK_SCROLL_SMOOTH: the scrolling is determined by the delta values in **Gnome::Gdk3::EventScroll**. See `gdk_event_get_scroll_deltas()`. Since: 3.4

enum GdkSettingAction
---------------------

Specifies the kind of modification applied to a setting in a **Gnome::Gdk3::EventSetting**.

  * GDK_SETTING_ACTION_NEW: a setting was added.

  * GDK_SETTING_ACTION_CHANGED: a setting was changed.

  * GDK_SETTING_ACTION_DELETED: a setting was deleted.

enum GdkTouchpadGesturePhase
----------------------------

Specifies the current state of a touchpad gesture. All gestures are guaranteed to begin with an event with phase `GDK_TOUCHPAD_GESTURE_PHASE_BEGIN`, followed by 0 or several events with phase `GDK_TOUCHPAD_GESTURE_PHASE_UPDATE`.

A finished gesture may have 2 possible outcomes, an event with phase `GDK_TOUCHPAD_GESTURE_PHASE_END` will be emitted when the gesture is considered successful, this should be used as the hint to perform any permanent changes. Cancelled gestures may be so for a variety of reasons, due to hardware or the compositor, or due to the gesture recognition layers hinting the gesture did not finish resolutely (eg. a 3rd finger being added during a pinch gesture). In these cases, the last event will report the phase `GDK_TOUCHPAD_GESTURE_PHASE_CANCEL`, this should be used as a hint to undo any visible/permanent changes that were done throughout the progress of the gesture.

See also **Gnome::Gdk3::EventTouchpadSwipe** and **Gnome::Gdk3::EventTouchpadPinch**.

  * GDK_TOUCHPAD_GESTURE_PHASE_BEGIN: The gesture has begun.

  * GDK_TOUCHPAD_GESTURE_PHASE_UPDATE: The gesture has been updated.

  * GDK_TOUCHPAD_GESTURE_PHASE_END: The gesture was finished, changes should be permanently applied.

  * GDK_TOUCHPAD_GESTURE_PHASE_CANCEL: The gesture was cancelled, all changes should be undone.

enum GdkVisibilityState
-----------------------

Specifies the visiblity status of a window for a **Gnome::Gdk3::EventVisibility**.

  * GDK_VISIBILITY_UNOBSCURED: the window is completely visible.

  * GDK_VISIBILITY_PARTIAL: the window is partially visible.

  * GDK_VISIBILITY_FULLY_OBSCURED: the window is not visible at all.

enum GdkWindowState
-------------------

Specifies the state of a toplevel window.

  * GDK_WINDOW_STATE_WITHDRAWN: the window is not shown.

  * GDK_WINDOW_STATE_ICONIFIED: the window is minimized.

  * GDK_WINDOW_STATE_MAXIMIZED: the window is maximized.

  * GDK_WINDOW_STATE_STICKY: the window is sticky.

  * GDK_WINDOW_STATE_FULLSCREEN: the window is maximized without decorations.

  * GDK_WINDOW_STATE_ABOVE: the window is kept above other windows.

  * GDK_WINDOW_STATE_BELOW: the window is kept below other windows.

  * GDK_WINDOW_STATE_FOCUSED: the window is presented as focused (with active decorations).

  * GDK_WINDOW_STATE_TILED: the window is in a tiled state, Since 3.10. Since 3.22.23, this is deprecated in favor of per-edge information.

  * GDK_WINDOW_STATE_TOP_TILED: whether the top edge is tiled, Since 3.22.23

  * GDK_WINDOW_STATE_TOP_RESIZABLE: whether the top edge is resizable, Since 3.22.23

  * GDK_WINDOW_STATE_RIGHT_TILED: whether the right edge is tiled, Since 3.22.23

  * GDK_WINDOW_STATE_RIGHT_RESIZABLE: whether the right edge is resizable, Since 3.22.23

  * GDK_WINDOW_STATE_BOTTOM_TILED: whether the bottom edge is tiled, Since 3.22.23

  * GDK_WINDOW_STATE_BOTTOM_RESIZABLE: whether the bottom edge is resizable, Since 3.22.23

  * GDK_WINDOW_STATE_LEFT_TILED: whether the left edge is tiled, Since 3.22.23

  * GDK_WINDOW_STATE_LEFT_RESIZABLE: whether the left edge is resizable, Since 3.22.23

class N-GdkEventAny
-------------------

Contains the fields which are common to all event structs. Any event pointer can safely be cast to a pointer to a **Gnome::Gdk3::EventAny** to access these fields.

  * GdkEventType $.type: the type of the event.

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

class N-GdkEventVisibility
--------------------------

Generated when the window visibility status has changed.

Deprecated: 3.12: Modern composited windowing systems with pervasive transparency make it impossible to track the visibility of a window reliably, so this event can not be guaranteed to provide useful information.

  * GdkEventType $.type: the type of the event (`GDK_VISIBILITY_NOTIFY`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * GdkVisibilityState $.state: the new visibility state (`GDK_VISIBILITY_FULLY_OBSCURED`, `GDK_VISIBILITY_PARTIAL` or `GDK_VISIBILITY_UNOBSCURED`).

class N-GdkEventMotion
----------------------

Generated when the pointer moves.

  * GdkEventType $.type: the type of the event.

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * `Num()` $.x: the x coordinate of the pointer relative to the window.

  * `Num()` $.y: the y coordinate of the pointer relative to the window.

  * `Num()` $.axes: *x*, *y* translated to the axes of *device*, or `undefined` if *device* is the mouse.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

  * `Int()` $.is_hint: set to 1 if this event is just a hint, see the `GDK_POINTER_MOTION_HINT_MASK` value of **Gnome::Gdk3::EventMask**.

  * N-GObject $.device: the master device that the event originated from. Use `gdk_event_get_source_device()` to get the slave device.

  * `Num()` $.x_root: the x coordinate of the pointer relative to the root of the screen.

  * `Num()` $.y_root: the y coordinate of the pointer relative to the root of the screen.

class N-GdkEventButton
----------------------

Used for button press and button release events. The *type* field will be one of `GDK_BUTTON_PRESS`, `GDK_2BUTTON_PRESS`, `GDK_3BUTTON_PRESS` or `GDK_BUTTON_RELEASE`,

Double and triple-clicks result in a sequence of events being received. For double-clicks the order of events will be:

- `GDK_BUTTON_PRESS` - `GDK_BUTTON_RELEASE` - `GDK_BUTTON_PRESS` - `GDK_2BUTTON_PRESS` - `GDK_BUTTON_RELEASE`

Note that the first click is received just like a normal button press, while the second click results in a `GDK_2BUTTON_PRESS` being received just after the `GDK_BUTTON_PRESS`.

Triple-clicks are very similar to double-clicks, except that `GDK_3BUTTON_PRESS` is inserted after the third click. The order of the events is:

- `GDK_BUTTON_PRESS` - `GDK_BUTTON_RELEASE` - `GDK_BUTTON_PRESS` - `GDK_2BUTTON_PRESS` - `GDK_BUTTON_RELEASE` - `GDK_BUTTON_PRESS` - `GDK_3BUTTON_PRESS` - `GDK_BUTTON_RELEASE`

For a double click to occur, the second button press must occur within 1/4 of a second of the first. For a triple click to occur, the third button press must also occur within 1/2 second of the first button press.

  * GdkEventType $.type: the type of the event (`GDK_BUTTON_PRESS`, `GDK_2BUTTON_PRESS`, `GDK_3BUTTON_PRESS` or `GDK_BUTTON_RELEASE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * `Num()` $.x: the x coordinate of the pointer relative to the window.

  * `Num()` $.y: the y coordinate of the pointer relative to the window.

  * `Num()` $.axes: *x*, *y* translated to the axes of *device*, or `undefined` if *device* is the mouse.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

  * UInt $.button: the button which was pressed or released, numbered from 1 to 5. Normally button 1 is the left mouse button, 2 is the middle button, and 3 is the right button. On 2-button mice, the middle button can often be simulated by pressing both mouse buttons together.

  * N-GObject $.device: the master device that the event originated from. Use `gdk_event_get_source_device()` to get the slave device.

  * `Num()` $.x_root: the x coordinate of the pointer relative to the root of the screen.

  * `Num()` $.y_root: the y coordinate of the pointer relative to the root of the screen.

class N-GdkEventScroll
----------------------

Generated from button presses for the buttons 4 to 7. Wheel mice are usually configured to generate button press events for buttons 4 and 5 when the wheel is turned.

Some GDK backends can also generate “smooth” scroll events, which can be recognized by the `GDK_SCROLL_SMOOTH` scroll direction. For these, the scroll deltas can be obtained with `gdk_event_get_scroll_deltas()`.

  * GdkEventType $.type: the type of the event (`GDK_SCROLL`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * `Num()` $.x: the x coordinate of the pointer relative to the window.

  * `Num()` $.y: the y coordinate of the pointer relative to the window.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

  * GdkScrollDirection $.direction: the direction to scroll to (one of `GDK_SCROLL_UP`, `GDK_SCROLL_DOWN`, `GDK_SCROLL_LEFT`, `GDK_SCROLL_RIGHT` or `GDK_SCROLL_SMOOTH`).

  * N-GObject $.device: the master device that the event originated from. Use `gdk_event_get_source_device()` to get the slave device.

  * `Num()` $.x_root: the x coordinate of the pointer relative to the root of the screen.

  * `Num()` $.y_root: the y coordinate of the pointer relative to the root of the screen.

  * `Num()` $.delta_x: the x coordinate of the scroll delta

  * `Num()` $.delta_y: the y coordinate of the scroll delta

class N-GdkEventKey
-------------------

Describes a key press or key release event.

  * GdkEventType $.type: the type of the event (`GDK_KEY_PRESS` or `GDK_KEY_RELEASE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

  * UInt $.keyval: the key that was pressed or released. See the `gdk/gdkkeysyms.h` header file for a complete list of GDK key codes.

  * `Int()` $.length: the length of *string*.

  * Str $.string: a string containing an approximation of the text that would result from this keypress. The only correct way to handle text input of text is using input methods (see **Gnome::Gdk3::IMContext**), so this field is deprecated and should never be used. (`gdk_unicode_to_keyval()` provides a non-deprecated way of getting an approximate translation for a key.) The string is encoded in the encoding of the current locale (Note: this for backwards compatibility: strings in GTK+ and GDK are typically in UTF-8.) and NUL-terminated. In some cases, the translation of the key code will be a single NUL byte, in which case looking at *length* is necessary to distinguish it from the an empty translation.

  * UInt $.hardware_keycode: the raw code of the key that was pressed or released.

  * UInt $.group: the keyboard group.

  * ___is_modifier: a flag that indicates if *hardware_keycode* is mapped to a modifier. Since 2.10

class N-GdkEventCrossing
------------------------

Generated when the pointer enters or leaves a window.

  * GdkEventType $.type: the type of the event (`GDK_ENTER_NOTIFY` or `GDK_LEAVE_NOTIFY`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * N-GObject $.subwindow: the window that was entered or left.

  * UInt $.time: the time of the event in milliseconds.

  * `Num()` $.x: the x coordinate of the pointer relative to the window.

  * `Num()` $.y: the y coordinate of the pointer relative to the window.

  * `Num()` $.x_root: the x coordinate of the pointer relative to the root of the screen.

  * `Num()` $.y_root: the y coordinate of the pointer relative to the root of the screen.

  * GdkCrossingMode $.mode: the crossing mode (`GDK_CROSSING_NORMAL`, `GDK_CROSSING_GRAB`, `GDK_CROSSING_UNGRAB`, `GDK_CROSSING_GTK_GRAB`, `GDK_CROSSING_GTK_UNGRAB` or `GDK_CROSSING_STATE_CHANGED`). `GDK_CROSSING_GTK_GRAB`, `GDK_CROSSING_GTK_UNGRAB`, and `GDK_CROSSING_STATE_CHANGED` were added in 2.14 and are always synthesized, never native.

  * GdkNotifyType $.detail: the kind of crossing that happened (`GDK_NOTIFY_INFERIOR`, `GDK_NOTIFY_ANCESTOR`, `GDK_NOTIFY_VIRTUAL`, `GDK_NOTIFY_NONLINEAR` or `GDK_NOTIFY_NONLINEAR_VIRTUAL`).

  * Bool $.focus: `True` if *window* is the focus window or an inferior.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

class N-GdkEventFocus
---------------------

Describes a change of keyboard focus.

  * GdkEventType $.type: the type of the event (`GDK_FOCUS_CHANGE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * `Int()` $.in: `True` if the window has gained the keyboard focus, `False` if it has lost the focus.

class N-GdkEventConfigure
-------------------------

Generated when a window size or position has changed.

  * GdkEventType $.type: the type of the event (`GDK_CONFIGURE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * `Int()` $.x: the new x coordinate of the window, relative to its parent.

  * `Int()` $.y: the new y coordinate of the window, relative to its parent.

  * `Int()` $.width: the new width of the window.

  * `Int()` $.height: the new height of the window.

class N-GdkEventProximity
-------------------------

Proximity events are generated when using GDK’s wrapper for the XInput extension. The XInput extension is an add-on for standard X that allows you to use nonstandard devices such as graphics tablets. A proximity event indicates that the stylus has moved in or out of contact with the tablet, or perhaps that the user’s finger has moved in or out of contact with a touch screen.

This event type will be used pretty rarely. It only is important for XInput aware programs that are drawing their own cursor.

  * GdkEventType $.type: the type of the event (`GDK_PROXIMITY_IN` or `GDK_PROXIMITY_OUT`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * N-GObject $.device: the master device that the event originated from. Use `gdk_event_get_source_device()` to get the slave device.

class N-GdkEventSetting
-----------------------

Generated when a setting is modified.

  * GdkEventType $.type: the type of the event (`GDK_SETTING`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * GdkSettingAction $.action: what happened to the setting (`GDK_SETTING_ACTION_NEW`, `GDK_SETTING_ACTION_CHANGED` or `GDK_SETTING_ACTION_DELETED`).

  * Str $.name: the name of the setting.

class N-GdkEventWindowState
---------------------------

Generated when the state of a toplevel window changes.

  * GdkEventType $.type: the type of the event (`GDK_WINDOW_STATE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * GdkWindowState $.changed_mask: mask specifying what flags have changed.

  * GdkWindowState $.new_window_state: the new window state, a combination of **Gnome::Gdk3::WindowState** bits.

class N-GdkEventGrabBroken
--------------------------

Generated when a pointer or keyboard grab is broken. On X11, this happens when the grab window becomes unviewable (i.e. it or one of its ancestors is unmapped), or if the same application grabs the pointer or keyboard again. Note that implicit grabs (which are initiated by button presses) can also cause **Gnome::Gdk3::EventGrabBroken** events.

  * GdkEventType $.type: the type of the event (`GDK_GRAB_BROKEN`)

  * N-GObject $.window: the window which received the event, i.e. the window that previously owned the grab

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * Bool $.keyboard: `True` if a keyboard grab was broken, `False` if a pointer grab was broken

  * Bool $.implicit: `True` if the broken grab was implicit

  * N-GObject $.grab_window: If this event is caused by another grab in the same application, *grab_window* contains the new grab window. Otherwise *grab_window* is `undefined`.

class N-GdkEventTouchpadSwipe
-----------------------------

Generated during touchpad swipe gestures.

  * GdkEventType $.type: the type of the event (`GDK_TOUCHPAD_SWIPE`)

  * N-GObject $.window: the window which received the event

  * `Int()` $.send_event: `True` if the event was sent explicitly

  * `Int()` $.phase: the current phase of the gesture

  * `Int()` $.n_fingers: The number of fingers triggering the swipe

  * UInt $.time: the time of the event in milliseconds

  * `Num()` $.x: The X coordinate of the pointer

  * `Num()` $.y: The Y coordinate of the pointer

  * `Num()` $.dx: Movement delta in the X axis of the swipe focal point

  * `Num()` $.dy: Movement delta in the Y axis of the swipe focal point

  * `Num()` $.x_root: The X coordinate of the pointer, relative to the root of the screen.

  * `Num()` $.y_root: The Y coordinate of the pointer, relative to the root of the screen.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

class N-GdkEventTouchpadPinch
-----------------------------

Generated during touchpad swipe gestures.

  * GdkEventType $.type: the type of the event (`GDK_TOUCHPAD_PINCH`)

  * N-GObject $.window: the window which received the event

  * `Int()` $.send_event: `True` if the event was sent explicitly

  * `Int()` $.phase: the current phase of the gesture

  * `Int()` $.n_fingers: The number of fingers triggering the pinch

  * UInt $.time: the time of the event in milliseconds

  * `Num()` $.x: The X coordinate of the pointer

  * `Num()` $.y: The Y coordinate of the pointer

  * `Num()` $.dx: Movement delta in the X axis of the swipe focal point

  * `Num()` $.dy: Movement delta in the Y axis of the swipe focal point

  * `Num()` $.angle_delta: The angle change in radians, negative angles denote counter-clockwise movements

  * `Num()` $.scale: The current scale, relative to that at the time of the corresponding `GDK_TOUCHPAD_GESTURE_PHASE_BEGIN` event

  * `Num()` $.x_root: The X coordinate of the pointer, relative to the root of the screen.

  * `Num()` $.y_root: The Y coordinate of the pointer, relative to the root of the screen.

  * UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See **Gnome::Gdk3::ModifierType**.

class N-GdkEventPadButton
-------------------------

Generated during `GDK_SOURCE_TABLET_PAD` button presses and releases.

  * GdkEventType $.type: the type of the event (`GDK_PAD_BUTTON_PRESS` or `GDK_PAD_BUTTON_RELEASE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * UInt $.group: the pad group the button belongs to. A `GDK_SOURCE_TABLET_PAD` device may have one or more groups containing a set of buttons/rings/strips each.

  * UInt $.button: The pad button that was pressed.

  * UInt $.mode: The current mode of *group*. Different groups in a `GDK_SOURCE_TABLET_PAD` device may have different current modes.

class N-GdkEventPadAxis
-----------------------

Generated during `GDK_SOURCE_TABLET_PAD` interaction with tactile sensors.

  * GdkEventType $.type: the type of the event (`GDK_PAD_RING` or `GDK_PAD_STRIP`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * UInt $.group: the pad group the ring/strip belongs to. A `GDK_SOURCE_TABLET_PAD` device may have one or more groups containing a set of buttons/rings/strips each.

  * UInt $.index: number of strip/ring that was interacted. This number is 0-indexed.

  * UInt $.mode: The current mode of *group*. Different groups in a `GDK_SOURCE_TABLET_PAD` device may have different current modes.

  * `Num()` $.value: The current value for the given axis.

class N-GdkEventPadGroupMode
----------------------------

Generated during `GDK_SOURCE_TABLET_PAD` mode switches in a group.

  * GdkEventType $.type: the type of the event (`GDK_PAD_GROUP_MODE`).

  * N-GObject $.window: the window which received the event.

  * `Int()` $.send_event: `True` if the event was sent explicitly.

  * UInt $.time: the time of the event in milliseconds.

  * UInt $.group: the pad group that is switching mode. A `GDK_SOURCE_TABLET_PAD` device may have one or more groups containing a set of buttons/rings/strips each.

  * UInt $.mode: The new mode of *group*. Different groups in a `GDK_SOURCE_TABLET_PAD` device may have different current modes.

class N-GdkEvent
----------------

A `N-GdkEvent` contains a union of all of the event types, and allows access to the data fields in a number of ways.

The event type is always the first field in all of the event types, and can always be accessed with the following code, no matter what type of event it is:

    method my-handler ( N-GdkEvent $event ) {
      if $event.type ~~ GDK_BUTTON_PRESS {
        my N-GdkEventButton $event-button := $event-button;
        ...
      }

      elsif $event.type ~~ GDK_KEY_RELEASE {
        my N-GdkEventKey $event-key := $event-key;
        ...
      }
    }

The event structures contain data specific to each type of event in GDK. The type is a union of all structures explained above.

### struct N-GdkEventExpose ***this event structure is not yet implemented***

### struct N-GdkEventTouch ***this event structure is not yet implemented***

### struct N-GdkEventSelection ***this event structure is not yet implemented***

### struct N-GdkEventProperty ***this event structure is not yet implemented***

### struct N-GdkEventOwnerChange ***this event structure is not yet implemented***

### struct N-GdkEventDND ***this event structure is not yet implemented***

Fields `$.event-any`, `$.event-motion`, `$.event-button`, `$.event-scroll`, `$.event-key`, `$.event-crossing`, `$.event-focus` and `$.event-configure` are deprecated (version 0.19.2) and replaced by `$.any`, `m$.motion`, `$.button`, `$.scroll`, `$.key`, `$.crossing`, `$.focus` and `$.configure` resp. (Fields are removed in version 0.22.0 and higher)

Methods
=======

new
---

### :type

Creates a new event of the given type. All fields are set to 0.

Returns: a newly-allocated **Gnome::Gdk3::Event**. This object should be freed with `clear-object()`.

    multi method new ( GdkEventType :$type! )

  * $type; a **Gnome::Gdk3::EventType**

### :get

When `:get` is given (no value needed) it checks all open displays for a an event to process, to be processed on, fetching events from the windowing system if necessary. See `Gnome::Gdk3::Display.get-event()`.

Gets the next **Gnome::Gdk3::Event** to be processed, or, if no events are pending, the object becomes invalid. As always, this object should be freed with `clear-object()`.

    multi method get ( :get! )

### :native-object

    multi method new ( Gnome::GObject::Object :$native-object! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

get-angle
---------

If this and the provided event contain X/Y information, this function will return a defined angle, the relative angle from this event to *$event*. The rotation direction for positive angles is from the positive X axis towards the positive Y axis.

    method get-angle ( N-GdkEvent $event --> Num )

  * $event; the second **Gnome::Gdk3::Event**

get-center
----------

If this and the provided event contain X/Y information, the center of both coordinates will be returned in a List. An empty list is returned otherwise.

    method get-center ( N-GdkEvent $event2 --> List )

  * $event; the second **Gnome::Gdk3::Event**

List returns

  * Num; the X coordinate of the center

  * Num; the Y coordinate of the center

get-axis
--------

Extract the axis value for a particular axis use from an event structure.

Returns: the axis value if the specified axis was found, otherwise an undefined `Num`.

    method get-axis ( GdkAxisUse $axis_use --> Num )

  * $axis_use; the axis use to look for

get-button
----------

Extract the button number from an event.

Returns: a defined `Int` if the event delivered a button number.

    method get-button ( --> Int )

get-click-count
---------------

Extracts the click count from an event.

Returns: a defined `Int` if the event delivered a click count

    method get-click-count ( --> Int )

get-coords
----------

Extract the event window relative x/y coordinates from an event.

Returns: `True` if the event delivered event window coordinates

    method get-coords ( --> List )

List returns;

  * Num; event window x coordinate

  * Num; event window y coordinate

get-device
----------

If the event contains a “device” field, this function will return it, else it will return `undefined` or an invalid object in the case of `get-device-rk()`.

Returns: a **Gnome::Gdk3::Device**, or `undefined`.

    method get-device ( --> N-GObject )

get-distance
------------

If this and the provided event have X/Y information, the distance between both coordinates (as in a straight line going from this event to *$event*) will be returned. Otherwise returned value is undefined.

    method get-distance ( N-GdkEvent $event --> Num )

  * $event; second **Gnome::Gdk3::Event**

get-event-type
--------------

Retrieves the type of the event.

Returns: a **Gnome::Gdk3::EventType**

    method get-event-type ( --> GdkEventType )

get-keycode
-----------

Extracts the hardware keycode from an event.

Also see `get-scancode()`.

Returns: a defined keycode if the event delivered a hardware keycode, undefined otherwise.

    method get-keycode ( --> UInt )

get-keyval
----------

Extracts the keyval from an event.

Returns: a defined key symbol if the event delivered a key symbol, undefined otherwise.

    method get-keyval ( --> UInt )

get-pointer-emulated
--------------------

Returns whether this event is an 'emulated' pointer event (typically from a touch event), as opposed to a real one.

Returns: `True` if this event is emulated

    method get-pointer-emulated ( --> Bool )

get-root-coords
---------------

Extract the root window relative x/y coordinates from an event.

Returns: a list if the event delivered root window coordinates. The list is empty if not.

    method get-root-coords ( --> List )

The List returns

  * Num; root window x coordinate

  * Num; root window y coordinate

get-scancode
------------

Gets the keyboard low-level scancode of a key event.

This is usually hardware_keycode. On Windows this is the high word of WM_KEY{DOWN,UP} lParam which contains the scancode and some extended flags.

Returns: The associated keyboard scancode or 0

    method get-scancode ( --> Int )

get-screen
----------

Returns the screen for the event. The screen is typically the screen in any `$event.any.window``, but for events such as mouse events, it is the screen where the pointer was when the event occurs - that is, the screen which has the root window to which `$event.motion.x_root` and `$event.motion.y_root` are relative.

Returns: the screen for the event

    method get-screen ( --> N-GObject )

  * $event; a **Gnome::Gdk3::Event**

get-scroll-deltas
-----------------

Retrieves the scroll deltas from this event

See also: `gdk_event_get_scroll_direction()`

Returns: A List holding the values if the event contains smooth scroll information and an empty List otherwise.

    method get-scroll-deltas ( --> List )

The List returns;

  * Num; X delta

  * Num; Y delta

get-scroll-direction
--------------------

Extracts the scroll direction from an event.

If *event* is not of type `GDK_SCROLL`, the contents of *direction* are undefined.

If you wish to handle both discrete and smooth scrolling, you should check the return value of this function, or of `get-scroll-deltas()`; for instance:

    # Handle discrete scrolling with a known constant delta;
    constant Num $delta = 12e0;

    my GdkScrollDirection $direction;
    my Num $vscroll_factor = 0e0;
    my Num ( $x_scroll, $y_scroll);

    if ?( $direction = $event.get-scroll-direction ) {
      with $direction {
        when GDK_SCROLL_UP {
          $vscroll_factor = -$delta;
        }

        when GDK_SCROLL_DOWN {
          $vscroll_factor = $delta;
        }

        default {
          # no scrolling
        }
      }
    }

    elsif my List $deltas = $event.get-scroll-deltas {
      # Handle smooth scrolling directly
      $vscroll_factor = $deltas[1];
    }

Returns: a defined GdkScrollDirection value if the event delivered a scroll direction and undefined otherwise

    method get-scroll-direction ( --> GdkScrollDirection )

get-show-events
---------------

Gets whether event debugging output is enabled.

Returns: `True` if event debugging output is enabled.

    method get-show-events ( --> Bool )

get-source-device
-----------------

This function returns the hardware secondary **Gnome::Gdk3::Device** that has triggered the event, falling back to the virtual primary device (as in `get-device()`) if the event wasn’t caused by interaction with a hardware device.

This may happen for example in synthesized crossing events after a **Gnome::Gdk3::Window** updates its geometry or a grab is acquired/released.

If the event does not contain a device field, this function will return `undefined` or an invalid object in the case of `get-source-device-rk()`.

Returns: a **Gnome::Gdk3::Device**, or `undefined`.

    method get-source-device ( --> N-GObject )

  * $event; a **Gnome::Gdk3::Event**

get-state
---------

If the event contains a “state” field, returns that field.

Returns a defined state value if there was a state field in the event. Undefined otherwise.

    method get-state ( --> GdkModifierType )

get-time
--------

Returns the time stamp from *event*, if there is one; otherwise returns the current time.

Returns: time stamp field from this event

    method get-time ( --> UInt )

get-window
----------

Extracts the **Gnome::Gdk3::Window** associated with an event.

    method get-window ( --> N-GObject )

is-scroll-stop-event
--------------------

Check whether a scroll event is a stop scroll event. Scroll sequences with smooth scroll information may provide a stop scroll event once the interaction with the device finishes, e.g. by lifting a finger. This stop scroll event is the signal that a widget may trigger kinetic scrolling based on the current velocity.

Stop scroll events always have a delta of 0/0.

    method is-scroll-stop-event ( --> Bool )

pending
-------

Checks if any events are ready to be processed for any display.

Returns: `True` if any events are pending.

    method pending ( --> Bool )

put
---

Appends a copy of this event onto the front of the event queue for `$event.any.window`’s display, or the default event queue if `$event.any.window` is `undefined`. See `Gnome::Gdk3::Display.put-event()`.

    method put ( )

request-motions
---------------

Request more motion notifies if this event is a motion notify hint event.

This function should be used instead of `Gnome::Gdk3::Window.get-pointer()` to request further motion notifies, because it also works for extension events where motion notifies are provided for devices other than the core pointer. Coordinate extraction, processing and requesting more motion events from a `GDK_MOTION_NOTIFY` event usually works like this:

    method request-motions ( )

set-device
----------

Sets the device for *event* to *device*. The event must have been allocated by GTK+, for instance, by `copy()`.

    method set-device ( N-GObject $device )

  * $device; a **Gnome::Gdk3::Device**

set-screen
----------

Sets the screen for *event* to *screen*. The event must have been allocated by GTK+, for instance, by `gdk_event_copy()`.

    method set-screen ( N-GObject $screen )

  * $screen; a **Gnome::Gdk3::Screen**

set-show-events
---------------

Sets whether a trace of received events is output. Note that GTK+ must be compiled with debugging (that is, configured using the `--enable-debug` option) to use this option.

    method set-show-events ( Bool $show_events )

  * $show_events; `True` to output event debugging information.

set-source-device
-----------------

Sets the slave device for *event* to *device*.

The event must have been allocated by GTK+, for instance by `gdk_event_copy()`.

    method set-source-device ( N-GObject $device )

  * $device; a **Gnome::Gdk3::Device**

triggers-context-menu
---------------------

This function returns whether this event (a GdkEventButton type) should trigger a context menu, according to platform conventions. The right mouse button always triggers context menus. Additionally, if `gdk_keymap_get_modifier_mask()` returns a non-0 mask for `GDK_MODIFIER_INTENT_CONTEXT_MENU`, then the left mouse button will also trigger a context menu if this modifier is pressed.

This function should always be used instead of simply checking for event->button == `GDK_BUTTON_SECONDARY`.

Returns: `True` if the event should trigger a context menu.

    method triggers-context-menu ( --> Bool )

