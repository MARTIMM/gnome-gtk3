Gnome::Gdk3::Drag
=================

Functions for controlling drag and drop handling

Description
===========

These functions provide a low level interface for drag and drop. The X backend of GDK supports both the Xdnd and Motif drag and drop protocols transparently, the Win32 backend supports the WM-DROPFILES protocol.

GTK+ provides a higher level abstraction based on top of these functions, and so they are not normally needed in GTK+ applications. See the [Drag and Drop][gtk3-Drag-and-Drop] section of * the GTK+ documentation for more information.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Drag;
    also is Gnome::GObject::Object;

Types
=====

enum GdkDragAction
------------------

Used in **Gnome::Gdk3::DragContext** to indicate what the destination should do with the dropped data.

  * GDK-ACTION-DEFAULT: Means nothing, and should not be used.

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

Used in **Gnome::Gdk3::DragContext** to indicate the protocol according to which DND is done.

  * GDK-DRAG-PROTO-NONE: no protocol.

  * GDK-DRAG-PROTO-MOTIF: The Motif DND protocol. No longer supported

  * GDK-DRAG-PROTO-XDND: The Xdnd protocol.

  * GDK-DRAG-PROTO-ROOTWIN: An extension to the Xdnd protocol for unclaimed root window drops.

  * GDK-DRAG-PROTO-WIN32-DROPFILES: The simple WM-DROPFILES protocol.

  * GDK-DRAG-PROTO-OLE2: The complex OLE2 DND protocol (not implemented).

  * GDK-DRAG-PROTO-LOCAL: Intra-application DND.

  * GDK-DRAG-PROTO-WAYLAND: Wayland DND protocol.

