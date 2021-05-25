Gnome::Gtk3::TargetEntry
========================

Functions for handling target entries

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TargetEntry;
    also is Gnome::GObject::Boxed;

Types
=====

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

#### Example

An example initialization and insertion into a target list.

    my Gnome::Gtk3::TargetEntry $te1 .= new(
      :target<text/plain>, :flags(GTK_TARGET_SAME_APP), :info(1234)
    );
    …
    my Gnome::Gtk3::TargetList $tl .= new(:targets([ $te1, …]))
    …

### :native-object

Create a TargetEntry object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

copy
----

Makes a copy of a **Gnome::Gtk3::TargetEntry** and its data.

Returns: a pointer to a copy of *data*. Free with `free()`

    method copy ( --> N-GObject )

