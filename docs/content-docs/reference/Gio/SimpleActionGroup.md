Gnome::Gio::SimpleActionGroup
=============================

A simple GActionGroup implementation

Description
===========

**Gnome::Gio::SimpleActionGroup** is a hash table filled with native **Gnome::Gio::Action** objects, implementing the **Gnome::Gio::ActionGroup** and **Gnome::Gio::ActionMap** interfaces.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::SimpleActionGroup;
    also is Gnome::GObject::Object;
    also does Gnome::Gio::ActionGroup;
    also does Gnome::Gio::ActionMap;

Methods
=======

new
---

### default, no options

Create a new SimpleActionGroup object.

    multi method new ( )

### :native-object

Create a SimpleActionGroup object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a SimpleActionGroup object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

