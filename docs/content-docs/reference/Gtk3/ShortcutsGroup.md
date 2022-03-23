Gnome::Gtk3::ShortcutsGroup
===========================

Represents a group of shortcuts in a GtkShortcutsWindow

Description
===========

A GtkShortcutsGroup represents a group of related keyboard shortcuts or gestures. The group has a title. It may optionally be associated with a view of the application, which can be used to show only relevant shortcuts depending on the application context.

This widget is only meant to be used with **Gnome::Gtk3::ShortcutsWindow**.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ShortcutsGroup;
    also is Gnome::Gtk3::Box;

Types
=====

Methods
=======

new
---

### :native-object

Create a ShortcutsGroup object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a ShortcutsGroup object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use `new(:label('my text label'))` or `.set-text('my text label')`.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Accelerator Size Group: accel-size-group

The size group for the accelerator portion of shortcuts in this group. This is used internally by GTK+, and must not be modified by applications.Widget type: GTK_TYPE_SIZE_GROUP

The **Gnome::GObject::Value** type of property *accel-size-group* is `G_TYPE_OBJECT`.

### Height: height

A rough measure for the number of lines in this group. This is used internally by GTK+, and is not useful for applications.

The **Gnome::GObject::Value** type of property *height* is `G_TYPE_UINT`.

### Title: title

The title for this group of shortcuts.

The **Gnome::GObject::Value** type of property *title* is `G_TYPE_STRING`.

### Title Size Group: title-size-group

The size group for the textual portion of shortcuts in this group. This is used internally by GTK+, and must not be modified by applications. Widget type: GTK_TYPE_SIZE_GROUP

The **Gnome::GObject::Value** type of property *title-size-group* is `G_TYPE_OBJECT`.

### View: view

An optional view that the shortcuts in this group are relevant for. The group will be hidden if the *view-name* property does not match the view of this group. Set this to `undefined` to make the group always visible.

The **Gnome::GObject::Value** type of property *view* is `G_TYPE_STRING`.

