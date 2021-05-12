Gnome::Gtk3::TargetEntry
========================

Functions for handling inter-process communication

Description
===========

    via selections
    signals for B<Gnome::Gtk3::Widget>. In particular, if you are using the functions
    in this section, you may need to pay attention to
     I<selection-get>,  I<selection-received> and
     I<selection-clear-event> signals

The selection mechanism provides the basis for different types of communication between processes. In particular, drag and drop and **Gnome::Gtk3::Clipboard** work via selections. You will very seldom or never need to use most of the functions in this section directly; **Gnome::Gtk3::Clipboard** provides a nicer interface to the same functionality.

If an application is expected to exchange image data and work on Windows, it is highly advised to support at least "image/bmp" target for the widest possible compatibility with third-party applications. **Gnome::Gtk3::Clipboard** already does that by using `gtk-target-list-add-image-targets()` and `gtk-selection-data-set-pixbuf()` or `gtk-selection-data-get-pixbuf()`, which is one of the reasons why it is advised to use **Gnome::Gtk3::Clipboard**.

Some of the datatypes defined this section are used in the **Gnome::Gtk3::Clipboard** and drag-and-drop API’s as well. The **Gnome::Gtk3::TargetEntry** and **Gnome::Gtk3::TargetList** objects represent lists of data types that are supported when sending or receiving data. The **Gnome::Gtk3::SelectionData** object is used to store a chunk of data along with the data type and other * associated information.

See Also
--------

**Gnome::Gtk3::Widget** - Much of the operation of selections happens via

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TargetEntry;
    also is Gnome::GObject::Boxed;

Types
=====

enum GtkTargetFlags
-------------------

The GtkTargetFlag> enumeration is used to specify constraints on a N-GtkTargetEntry.

  * GTK_TARGET_SAME_APP: If this is set, the target will only be selected for drags within a single application.

  * GTK_TARGET_SAME_WIDGET: If this is set, the target will only be selected for drags within a single widget.

  * GTK_TARGET_OTHER_APP: If this is set, the target will not be selected for drags within a single application.

  * GTK_TARGET_OTHER_WIDGET: If this is set, the target will not be selected for drags withing a single widget.

class N-GtkTargetEntry
----------------------

A N-GtkTargetEntry represents a single type of data than can be supplied for by a widget for a selection or for supplied or received during drag-and-drop.

  * Str $.target: a string representation of the target type

  * UInt $.flags: GtkTargetFlags for DND

  * UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the *selection-get* signal. It allows the application to identify the target type without extensive string compares.

Methods
=======

new
---

### :target, :flags, :info

Makes a new **Gnome::Gtk3::TargetEntry**.

    multi method new ( Str :$target!, UInt :$flags!, UInt :$info! )

  * Str $target; String identifier for target

  * UInt $flags; Set of flags of enum GtkTargetFlags

  * UInt $info; an ID that will be passed back to the application

### :native-object

Create a TargetEntry object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

copy
----

Makes a copy of a **Gnome::Gtk3::TargetEntry** and its data.

Returns: a pointer to a copy of *data*. Free with `free()`

    method copy ( --> N-GtkTargetEntry )

