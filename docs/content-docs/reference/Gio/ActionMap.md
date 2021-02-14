Gnome::Gio::ActionMap
=====================

Interface for action containers

Description
===========

The Gnome::Gio::ActionMap interface is implemented by **Gnome::Gio::ActionGroup** implementations that operate by containing a number of named **Gnome::Gio::Action** instances, such as **Gnome::Gio::SimpleActionGroup**.

One useful application of this interface is to map the names of actions from various action groups to unique, prefixed names (e.g. by prepending "app." or "win."). This is the motivation for the 'Map' part of the interface name.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gio::ActionMap;

Methods
=======

add-action
----------

Adds an action to the action map. If the action map already contains an action with the same name as *$action* then the old action is dropped from the action map. The action map takes its own reference on *$action*.

    method add-action ( N-GObject $action )

  * N-GObject $action; an action object

lookup-action
-------------

Looks up the action with the name *$action_name* in action map. If no such action exists, returns an invalid object.

Returns: a Gnome::Gio::SimpleAction object

    method lookup-action (
      Str $action_name --> Gnome::Gio::SimpleAction
    )

  * Str $action_name; the name of an action

remove-action
-------------

Removes the named action from the action map. If no action of this name is found in the map then nothing happens.

    method remove-action ( Str $action_name )

  * Str $action_name; the name of the action

