Gnome::Gtk3::TargetList
=======================

Handling of target lists

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TargetList;
    also is Gnome::GObject::Boxed;

Example
-------

An example of a drag destination specification (an image) which can only accept plain text.

    # Use an image to show where to drop
    my Gnome::Gtk3::Image $image .= new;
    $image.set-from-file('bullseye.jpg');

    # Define a drag destination and ise that image for it
    my Gnome::Gtk3::DragDest $destination .= new;
    $destination.set( $image, 0, GDK_ACTION_COPY);

    # Specify what the drag destination can handle. Also
    # the source must be in the same application
    my Gnome::Gtk3::TargetList $target-list .= new;
    $target-list.add(
      Gnome::Gdk3::Atom.new(:intern<text/plain>),
      GTK_TARGET_SAME_APP, $str-info
    );
    $destination.set-target-list( $widget, $target-list);

Types
=====

enum GtkTargetFlags
-------------------

The GtkTargetFlag> enumeration is used to specify constraints on a target entry.

  * GTK_TARGET_ANY; (=0) Using this on its own means that there are no constraints.

  * GTK_TARGET_SAME_APP: If this is set, the target will only be selected for drags within a single application.

  * GTK_TARGET_SAME_WIDGET: If this is set, the target will only be selected for drags within a single widget.

  * GTK_TARGET_OTHER_APP: If this is set, the target will not be selected for drags within a single application.

  * GTK_TARGET_OTHER_WIDGET: If this is set, the target will not be selected for drags withing a single widget.

class N-GtkTargetPair
---------------------

A **N-GtkTargetPair** is used to represent the same information as a table of **N-GtkTargetEntry**, but in an efficient form.

  * N-GObject $.target: **Gnome::Gtk3::Atom** representation of the target type

  * UInt $.flags: **GtkTargetFlags** for DND

  * UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the *selection-get* signal. It allows the application to identify the target type without extensive string compares.

Methods
=======

new
---

### default, no options

Create a new empty TargetList object.

    multi method new ( )

### :targets

Creates a new TargetList from an array of target entries.

    multi method new ( Array :$targets! )

### :native-object

Create a TargetList object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GtkTargetList :$native-object! )

add
---

Appends another target to a **Gnome::Gtk3::TargetList**.

    method add ( N-GtkTargetEntry $target, UInt $flags, UInt $info )

  * Gnome::Gdk3::Atom $target; the interned atom representing the target

  * UInt $flags; the flags for this target

  * UInt $info; an ID that will be passed back to the application

add-image-targets
-----------------

Appends the image targets supported by **Gnome::Gtk3::SelectionData** to the target list. All targets are added with the same *$info*. Example targets added are; image/png, image/x-win-bitmap, image/vnd.microsoft.icon, application/ico, image/ico to name a few

    method add-image-targets ( UInt $info, Bool $writable )

  * UInt $info; an ID that will be passed back to the application

  * Bool $writable; whether to add only targets for which GTK+ knows how to convert a pixbuf into the format

add-rich-text-targets
---------------------

Appends the rich text targets registered with `gtk-text-buffer-register-serialize-format()` or `gtk-text-buffer-register-deserialize-format()` to the target list. All targets are added with the same *info*.

    method add-rich-text-targets (
      UInt $info, Bool $deserializable, N-GObject $buffer
    )

  * UInt $info; an ID that will be passed back to the application

  * Bool $deserializable; if `True`, then deserializable rich text formats will be added, serializable formats otherwise.

  * N-GObject $buffer; a **Gnome::Gtk3::TextBuffer**.

add-table
---------

Prepends a table of **Gnome::Gtk3::TargetEntry** to a target list.

    method add-table ( Array $targets )

  * Array $targets; the table of **Gnome::Gtk3::TargetEntry** target entries

add-text-targets
----------------

Appends the text targets supported by **Gnome::Gtk3::SelectionData** to the target list. All targets are added with the same *info*.

    method add-text-targets ( UInt $info )

  * UInt $info; an ID that will be passed back to the application

add-uri-targets
---------------

Appends the URI targets supported by **Gnome::Gtk3::SelectionData** to the target list. All targets are added with the same *info*.

    method add-uri-targets ( UInt $info )

  * UInt $info; an ID that will be passed back to the application

find
----

Looks up a given target in a **Gnome::Gtk3::TargetList**.

    method find ( Gnome::Gdk3::Atom $target --> List )

  * Gnome::Gdk3::Atom $target; an interned atom representing the target to search for

Returns a List where;

  * Bool $result; The result of `find()`, `True` if the target was found, otherwise `False`

  * Int $info; application info for target, or `undefined`

remove
------

Removes a target from a target list.

    method remove ( N-GObject $target )

  * Gnome::Gdk3::Atom $target; the interned atom representing the target

table-from-list
---------------

This function creates an **Gnome::Gtk3::TargetEntry** array that contains the same targets as the passed `list`.

Returns: the new table as an Array of target entries.

    method table-from-list ( --> Array )

