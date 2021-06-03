---
title: Tutorial - Drag and Drop - Signals
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Signals Involved in Drag-and-Drop

Various signals come into play during a DND operation. Some are essential to handle and others are not. All signals are emitted on GTK+ widgets and their descriptions can be found in the API documentation of the **Gnome::Gtk3::Widget** class. The following table lists all of these signals, indicating whether it is emitted on the course or the destination, and what its purpose is.

| Signal | Widget | Purpose |
|--------|--------|---------|
drag-begin-event | source | notifies source that drag started
drag-motion | destination &nbsp; | notifies destination about drag pointer motion
drag-drop | destination | notifies destination that data has been dropped
drag-data-get | source | request for drag data from source
drag-data-received | destination | source has sent target the requested data
drag-data-delete | source | source should/can delete data
drag-end-event | source | notifies source that drag is done
drag-failed | source | notifies source that drag failed
drag-leave | destination | notifies destination that cursor has left widget

## The Typical Sequence of Events

The sequence of events that take place in a drag-and-drop is well-defined. The typical sequence is described below. Under certain conditions there will be slight deviations from it.

* Everything begins when the user presses the mouse button over a source widget and starts a drag. At that moment, the "drag-begin-event" signal is emitted on the source.

* When the mouse is on top of a destination widget, the "drag-motion" signal is emitted on that widget. This signal can be connected to the destination for various reasons. For one, you can use it to highlight the widget when the cursor is over it and the drag format and action are acceptable to the widget. For another, if only certain parts of the widget are drop zones, the handler is needed in order to determine whether the cursor is in a drop zone or not.  If it is not in a drop zone, the handler should return FALSE and take no other action. Otherwise, it should display visual feedback to the user by calling gdk_drag_status() and return TRUE. Sometimes a drag-motion handler cannot decide whether the offered data is acceptable from the cursor position and data type, and must actually examine the data to know. In this case it will do the work typically done in a drag-drop handler. The details about this and other issues to be handled in a "drag-motion" handler are explained below. <br/>
  If when you set up the destination widget using `Gnome::Gtk3::DragDest.set()`, you set any of the flags `GTK_DEST_DEFAULT_DROP`, `GTK_DEST_DEFAULT_MOTION` or `GTK_DEST_DEFAULT_ALL` on the widget, you will not be able to use the "drag-motion" signal this way, because GTK+ will handle it with its internal functions instead. <br/>
  The "drag-motion" signal will be delivered to the widget each time that the cursor moves over the widget. If you want to detect when it enters and leaves the widget, you have to make use of the "drag-leave" signal, which is emitted on a destination widget whenever the cursor leaves it. An entry event takes place when it is the first "drag-motion" signal to be received after a "drag-leave" or the first one to be received. The handlers for the two signals can be coded to detect these conditions.

* When the user releases the mouse button over the destination, the "drag-drop" signal is emitted on the destination widget. This signal should be connected to a signal handler whose primary objective is to determine whether the cursor position is in a drop zone or not, and if it is, to issue a request for the data from the source by calling `Gnome::Gtk3::DragDest.get_data()` and return TRUE. If the cursor is not in a drop zone, it should return FALSE and take no other action.

* When the destination issues a request for the source's data, whether in the "drag-drop" handler or the "drag-motion" handler, the "drag-data-get" signal will be emitted on the source. A handler for this signal should be connected to the signal. This handler is responsible for packing up the data and setting it into a selection object that will be available to the destination.

* Once the source widget's "drag-data-get" handler has returned, the "drag-data-received" signal will be emitted on the destination. This signal should be connected to a signal handler on the destination widget. If the data was received in order to determine whether the drop will be accepted (as when the "drag-motion" handler requested the data), the handler has to call `Gnome::Gdk3::DragContext.status()` and not finish the drag. In most cases, if the data was received in response to a "drag-drop" signal, the handler has to retrieve the data from the selection object and then call `Gnome::gtk3::DragDest.finish()`. If the drag was a move (the `GdkDragAction` was set to `GDK_ACTION_MOVE` in the source or destination), then in the call to `Gnome::gtk3::DragDest.finish()` it needs to pass a flag indicating that the data should be deleted in the source.

* The call to `Gnome::gtk3::DragDest.finish()` causes a "drag-end" signal to be emitted on the source widget. It can connect a handler to this signal to do any post-processing needed after the drag. It will also cause a "drag-data-delete" signal to be emitted on the source if the destination passed the flag when it called `Gnome::gtk3::DragDest.finish()`. The source has to delete the data in its handler for this signal. This normal sequence might not be followed if there was a failure at some point. In this case, the "drag-failed" signal will be emitted on the source. A handler can be attached to the source to deal with the failure, such as by logging a message.
