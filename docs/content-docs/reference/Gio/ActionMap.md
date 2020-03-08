Gnome::Gio::ActionMap
=====================

Interface for action containers

Description
===========

*include*: gio/gio.h

The Gnome::Gio::ActionMap interface is implemented by **Gnome::Gio::ActionGroup** implementations that operate by containing a number of named **Gnome::Gio::Action** instances, such as **Gnome::Gio::SimpleActionGroup**.

One useful application of this interface is to map the names of actions from various action groups to unique, prefixed names (e.g. by prepending "app." or "win."). This is the motivation for the 'Map' part of the interface name.

Known implementations
---------------------

Gnome::Gio::ActionMap is implemented by

  * [Gnome::Gio::Application](Application.html)

Synopsis
========

Declaration
-----------

    unit role Gnome::Gio::ActionMap;

Methods
=======

[g_action_map_] lookup_action
-----------------------------

Looks up the action with the name *action_name* in *action_map*.

If no such action exists, returns `Any`.

Returns: (transfer none): a **N-GAction**, or `Any`

Since: 2.32

    method g_action_map_lookup_action ( Str $action_name --> GAction )

  * Str $action_name; the name of an action

[g_action_map_] add_action
--------------------------

Adds an action to the *action_map*.

If the action map already contains an action with the same name as *action* then the old action is dropped from the action map.

The action map takes its own reference on *action*.

Since: 2.32

    method g_action_map_add_action ( GAction $action )

  * GAction $action; a **GAction**

[g_action_map_] remove_action
-----------------------------

Removes the named action from the action map.

If no action of this name is in the map then nothing happens.

Since: 2.32

    method g_action_map_remove_action ( Str $action_name )

  * Str $action_name; the name of the action

