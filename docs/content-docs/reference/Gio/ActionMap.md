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

add-action-entries
------------------

A convenience function for creating multiple SimpleAction instances and adding them to this action map. The method will never call the native subroutine but will perform the necessary steps to add the action and register `activate` and `change-state` signals. Each entry in the Array is a Hash with the following keys;

  * Str :name; the name of the action. This must be defined.

  * Any :activate-handler-object; handler class object. If undefined, :activate will be ignored.

  * Str :activate; the callback method defined in `activate-handler-object` to connect to the "activate" signal of the action. this can be undefined for stateful actions, in which case the default handler is used. For boolean-stated actions with no parameter, this behaves like a toggle. For other state types (and parameter type equal to the state type) this will be a function that just calls change_state (which you should provide).

  * Hash :activate-data; additional data to the `.register-signal()`. May be undefined

  * Str :parameter-type; the type of the parameter that must be passed to the activate function for this action, given as a single GVariant type string (or undefined for no parameter)

  * Str :state; the initial state for this action, given in Variant text format. The state is parsed with no extra type information, so type tags must be added to the string if they are necessary. Stateless actions should not define this key. For more information look for [GVariant Text Format](https://developer.gnome.org/glib/stable/gvariant-text.html).

  * Any :change-state-handler-object; handler class object. If undefined, :change_state will be ignored.

  * Str :change-state the callback method defined in `change-state-handler-object` to connect to the "change-state" signal of the action. All stateful actions should provide a handler here; stateless actions should not.

  * Hash :change-state-data; additional data to the `.register-signal()`. May be undefined

This Hash will mimic the original structure GActionEntry close enough while being more flexible for Raku users.

    method add-action-entries ( Array $entries )

  * Array $entries; an array of hashes

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

