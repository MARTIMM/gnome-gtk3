Gnome::Gdk3::DragContext
========================

Functions for controlling lower level drag and drop handling

Description
===========

These functions provide a low level interface for drag and drop. The X backend of GDK supports both the Xdnd and Motif drag and drop protocols transparently, the Win32 backend supports the WM-DROPFILES protocol.

GTK+ provides a higher level abstraction based on top of these functions, and so they are not normally needed in GTK+ applications.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::DragContext;
    also is Gnome::GObject::Object;

See Also
========

  * Gnome::Gdk3::Atom

  * Gnome::Gtk3::DragDest

  * Gnome::Gtk3::DragSource

  * Gnome::Gtk3::SelectionData

  * Gnome::Gtk3::TargetEntry

  * Gnome::Gtk3::TargetList

Types
=====

enum GdkDragAction
------------------

Used in **Gnome::Gdk3::DragContext** to indicate what the destination should do with the dropped data.

  * GDK_ACTION_NONE: (=0) in some methods used to terminate or refuse action. Can only be used on its own. Combined (ored) with other values for an action mask is obviously not very helpful.

  * GDK-ACTION-COPY: Copy the data.

  * GDK-ACTION-MOVE: Move the data, i.e. first copy it, then delete it from the source using the DELETE target of the X selection protocol.

  * GDK-ACTION-LINK: Add a link to the data. Note that this is only useful if source and destination agree on what it means.

  * GDK-ACTION-PRIVATE: Special action which tells the source that the destination will do something that the source doesn’t understand.

  * GDK-ACTION-ASK: Ask the user what to do with the data.

enum GdkDragCancelReason
------------------------

Used in **Gnome::Gdk3::DragContext** to the reason of a cancelled DND operation.

  * GDK-DRAG-CANCEL-NO-TARGET: There is no suitable drop target.

  * GDK-DRAG-CANCEL-USER-CANCELLED: Drag cancelled by the user

  * GDK-DRAG-CANCEL-ERROR: Unspecified error.

enum GdkDragProtocol
--------------------

Used here to indicate the protocol according to which DND is done.

  * GDK-DRAG-PROTO-NONE: no protocol.

  * GDK-DRAG-PROTO-MOTIF: The Motif DND protocol. No longer supported

  * GDK-DRAG-PROTO-XDND: The Xdnd protocol.

  * GDK-DRAG-PROTO-ROOTWIN: An extension to the Xdnd protocol for unclaimed root window drops.

  * GDK-DRAG-PROTO-WIN32-DROPFILES: The simple WM-DROPFILES protocol.

  * GDK-DRAG-PROTO-OLE2: The complex OLE2 DND protocol (not implemented).

  * GDK-DRAG-PROTO-LOCAL: Intra-application DND.

  * GDK-DRAG-PROTO-WAYLAND: Wayland DND protocol.

Methods
=======

new
---

### :window, :targets

Starts a drag and creates a new drag context for it. This function assumes that the drag is controlled by the client pointer device, use `new(:$window, :$targets, :$device)` to begin a drag with a different device.

This function is called by the drag source.

    multi method new ( :$window!, :$targets! )

  * N-GObject $window; the source window for this drag

  * N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.

### :window, :targets, :device

Starts a drag with a different device and creates a new drag context for it.

This function is called by the drag source.

    multi method new ( :$window!, :$targets!, :$device! )

  * N-GObject $window; the source window for this drag

  * N-GObject $device; the device that controls this drag

  * N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.

### :window, :targets, :device, :x, :y

Starts a drag with a different device and creates a new drag context for it.

This function is called by the drag source.

    multi method new (
      :$window!, :$targets!, :$device!, Int() $x, Int() $y
    )

  * N-GObject $window; the source window for this drag

  * N-GObject $device; the device that controls this drag

  * N-GList $targets; the offered targets, as list of native Gnome::Gdk3::Atom.

  * Int() $x; the x coordinate where the drag nominally started

  * Int() $y; the y coordinate where the drag nominally started

### :native-object

Create a Drag object using a native object from elsewhere. This is the most used way to initialize this object because you will get the context when a signal arrives and calls a handler for it.

    multi method new ( N-GObject :$native-object! )

#### Example

An example of a handler to process the `drag-motion` event.

    method motion (
      N-GObject $context, Int $x, Int $y, UInt $time
      --> Bool
    ) {
      …
      my Gnome::Gdk3::DragContext $drag-context .= new(
        :native-object($context)
      );
      $drag-context.status( GDK_ACTION_COPY, $time);
      …
    }

abort
-----

Aborts a drag without dropping.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.

    method abort ( UInt $time )

  * $time; the timestamp for this operation

get-actions
-----------

Determines the bitmask of actions proposed by the source if `get-suggested-action()` returns `GDK-ACTION-ASK`.

Returns: the `GdkDragAction` flags

    method get-actions ( --> Int )

get-dest-window
---------------

Returns the destination window for the DND operation, a **Gnome::Gdk3::Window**

    method get-dest-window ( --> Gnome::Gdk3::Window )

get-device
----------

Returns the **Gnome::Gdk3::Device** associated to the drag context.

    method get-device ( --> Gnome::Gdk3::Device )

get-drag-window
---------------

Returns the window on which the drag icon should be rendered during the drag operation. Note that the window may not be available until the drag operation has begun. GDK will move the window in accordance with the ongoing drag operation. The window is owned by *context* and will be destroyed when the drag operation is over.

Returns: the drag window, or `undefined`

    method get-drag-window ( --> Gnome::Gdk3::Window )

get-protocol
------------

Returns the drag protocol that is used by this context.

Returns: the drag protocol

    method get-protocol ( --> GdkDragProtocol )

get-selected-action
-------------------

Determines the action chosen by the drag destination.

Returns: a `GdkDragAction` enum value.

    method get-selected-action ( --> GdkDragAction )

get-source-window
-----------------

Returns the **Gnome::Gdk3::Window** where the DND operation started.

    method get-source-window ( --> Gnome::Gdk3::Window )

get-suggested-action
--------------------

Determines the suggested drag action of the context.

Returns: a `GdkDragAction` value

    method get-suggested-action ( --> GdkDragAction )

list-targets
------------

Retrieves the list of targets of the context.

Returns: (element-type Gnome::Gdk3::Atom): a **Gnome::Glib::List** of targets

    method list-targets ( --> Gnome::Glib::List )

set-device
----------

Associates a **Gnome::Gdk3::Device** to *context*, so all Drag and Drop events for *context* are emitted as if they came from this device.

    method set-device ( N-GObject() $device )

  * $device; a **Gnome::Gdk3::Device**

set-hotspot
-----------

Sets the position of the drag window that will be kept under the cursor hotspot. Initially, the hotspot is at the top left corner of the drag window.

    method set-hotspot ( Int() $hot_x, Int() $hot_y )

  * $hot_x; x coordinate of the drag window hotspot

  * $hot_y; y coordinate of the drag window hotspot

drop
----

Drops on the current destination.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.

    method drop ( UInt $time )

  * $time; the timestamp for this operation

drop-done
---------

Inform GDK if the drop ended successfully. Passing `False` for *$success* may trigger a drag cancellation animation.

This function is called by the drag source, and should be the last call before dropping the reference to the *context*.

The **Gnome::Gdk3::DragContext** will only take the first `drop-done()` call as effective, if this function is called multiple times, all subsequent calls will be ignored.

    method drop-done ( Bool $success )

  * $success; whether the drag was ultimatively successful

drop-succeeded
--------------

Returns whether the dropped data has been successfully transferred. This function is intended to be used while handling a `GDK-DROP-FINISHED` event, its return value is meaningless at other times.

Returns: `True` if the drop was successful.

    method drop-succeeded ( --> Bool )

find-window-for-screen
----------------------

Finds the destination window and DND protocol to use at the given pointer position.

This function is called by the drag source to obtain the *dest-window* and *protocol* parameters for `motion()`.

    method find-window-for-screen (
      N-GObject() $drag_window, N-GObject() $screen,
      Int() $x_root, Int() $y_root, N-GObject() $dest_window,
      GdkDragProtocol $protocol
    )

  * $drag_window; a window which may be at the pointer position, but should be ignored, since it is put up by the drag source as an icon

  * $screen; the screen where the destination window is sought

  * $x_root; the x position of the pointer in root coordinates

  * $y_root; the y position of the pointer in root coordinates

  * $dest_window; location to store the destination window in

  * $protocol; location to store the DND protocol in

gdk-drop-finish
---------------

Ends the drag operation after a drop.

This function is called by the drag destination.

    method gdk-drop-finish ( Bool $success, UInt $time )

  * $success; `True` if the data was successfully received

  * $time; the timestamp for this operation

gdk-drop-reply
--------------

Accepts or rejects a drop.

This function is called by the drag destination in response to a drop initiated by the drag source.

    method gdk-drop-reply ( Bool $accepted, UInt $time )

  * $accepted; `True` if the drop is accepted

  * $time; the timestamp for this operation

get-selection
-------------

Returns the selection atom for the current source window.

Returns: the selection atom, or `GDK-NONE`

    method get-selection ( --> Gnome::Gdk3::Atom )

motion
------

Updates the drag context when the pointer moves or the set of actions changes.

This function is called by the drag source.

This function does not need to be called in managed drag and drop operations.

Returns:

    method motion (
      N-GObject() $dest_window, GdkDragProtocol $protocol,
      Int() $x_root, Int() $y_root, GdkDragAction $suggested_action,
      GdkDragAction $possible_actions, UInt $time
      --> Bool
    )

  * $dest_window; the new destination window, obtained by `find-window()`

  * $protocol; the DND protocol in use, obtained by `find-window()`

  * $x_root; the x position of the pointer in root coordinates

  * $y_root; the y position of the pointer in root coordinates

  * $suggested_action; the suggested action

  * $possible_actions; the possible actions

  * $time; the timestamp for this operation

status
------

Selects one of the actions offered by the drag source.

This function is called by the drag destination in response to `motion()` called by the drag source.

    method status ( GdkDragAction $action, UInt $time )

  * $action; the selected action which will be taken when a drop happens, or GDK_ACTION_NONE to indicate that a drop will not be accepted

  * $time; the timestamp for this operation

