Gnome::Gio::ActionGroup
=======================

A group of actions

Description
===========

**Gnome::Gio::ActionGroup** represents a group of actions. Actions can be used to expose functionality in a structured way, either from one part of a program to another, or to the outside world. Action groups are often used together with a **GMenuModel** that provides additional representation data for displaying the actions to the user, e.g. in a menu.

The main way to interact with the actions in a GActionGroup is to activate them with `activate-action()`. Activating an action may require a **GVariant** parameter. The required type of the parameter can be inquired with `get-action-parameter-type()`. Actions may be disabled, see `get-action-enabled()`. Activating a disabled action has no effect.

Actions may optionally have a state in the form of a **GVariant**. The current state of an action can be inquired with `get-action-state(). Activating a stateful action may change its state, but it is also possible to set the state by calling `change-action-state()`.

As typical example, consider a text editing application which has an option to change the current font to 'bold'. A good way to represent this would be a stateful action, with a boolean state. Activating the action would toggle the state.

Each action in the group has a unique name (which is a string). All method calls, except `list-actions()` take the name of an action as an argument.

The **Gnome::Gio::ActionGroup** API is meant to be the 'public' API to the action group. The calls here are exactly the interaction that 'external forces' (eg: UI, incoming D-Bus messages, etc.) are supposed to have with actions. 'Internal' APIs (ie: ones meant only to be accessed by the action group implementation) are found on subclasses. This is why you will find - for example - `get-action-enabled()` but not an equivalent `set()` call.

Signals are emitted on the action group in response to state changes on individual actions.

See Also
--------

**GAction**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::ActionGroup;

Methods
=======

action-added
------------

Emits the *action-added* signal on *action-group*. This function should only be called by **GActionGroup** implementations.

    method action-added ( Str $action_name )

  * Str $action_name; the name of an action in the group

action-enabled-changed
----------------------

Emits the *action-enabled-changed* signal on *action-group*. This function should only be called by **GActionGroup** implementations.

    method action-enabled-changed ( Str $action_name, Int $enabled )

  * Str $action_name; the name of an action in the group

  * Int $enabled; whether or not the action is now enabled

action-removed
--------------

Emits the *action-removed* signal on *action-group*. This function should only be called by **GActionGroup** implementations.

    method action-removed ( Str $action_name )

  * Str $action_name; the name of an action in the group

action-state-changed
--------------------

Emits the *action-state-changed* signal on *action-group*. This function should only be called by **GActionGroup** implementations.

    method action-state-changed ( Str $action_name, N-GVariant $state )

  * Str $action_name; the name of an action in the group

  * N-GVariant $state; the new state of the named action

activate-action
---------------

Activate the named action within *action-group*. If the action is expecting a parameter, then the correct type of parameter must be given as *$parameter*. If the action is expecting no parameters then *parameter* must be `undefined`. See `get-action-parameter-type()`.

    method activate-action ( Str $action_name, N-GVariant $parameter )

  * Str $action_name; the name of the action to activate

  * N-GVariant $parameter; (nullable): parameters to the activation

change-action-state
-------------------

Request for the state of the named action within *action-group* to be changed to *value*. The action must be stateful and *value* must be of the correct type. See `get-action-state-type()`. This call merely requests a change. The action may refuse to change its state or may change its state to something other than *value*. See `get-action-state-hint()`. If the *value* GVariant is floating, it is consumed.

    method change-action-state ( Str $action_name, N-GVariant $value )

  * Str $action_name; the name of the action to request the change on

  * N-GVariant $value; the new state

get-action-enabled
------------------

Checks if the named action within *action-group* is currently enabled. An action must be enabled in order to be activated or in order to have its state changed from outside callers.

Returns: whether or not the action is currently enabled

    method get-action-enabled ( Str $action_name --> Bool )

  * Str $action_name; the name of the action to query

get-action-parameter-type
-------------------------

Queries the type of the parameter that must be given when activating the named action within *action-group*. When activating the action using [[activate-action]], the **GVariant** given to that function must be of the type returned by this function. In the case that this function returns `undefined`, you must not give any **GVariant**, but `undefined` instead. The parameter type of a particular action will never change but it is possible for an action to be removed and for a new action to be added with the same name but a different parameter type.

Returns: (nullable): the parameter type

    method get-action-parameter-type (
      Str $action_name --> Gnome::Glib::VariantType
    )

  * Str $action_name; the name of the action to query

get-action-state
----------------

Queries the current state of the named action within *action-group*. If the action is not stateful then `undefined` will be returned. If the action is stateful then the type of the return value is the type given by [[get-action-state-type]]. The return value (if non-`undefined`) should be freed with [[g-variant-unref]] when it is no longer required.

Returns: the current state of the action

    method get-action-state (
      Str $action_name --> Gnome::Glib::Variant
    )

  * Str $action_name; the name of the action to query

get-action-state-hint
---------------------

Requests a hint about the valid range of values for the state of the named action within *action-group*. If `undefined` is returned it either means that the action is not stateful or that there is no hint about the valid range of values for the state of the action. If a **GVariant** array is returned then each item in the array is a possible value for the state. If a **GVariant** pair (ie: two-tuple) is returned then the tuple specifies the inclusive lower and upper bound of valid values for the state. In any case, the information is merely a hint. It may be possible to have a state value outside of the hinted range and setting a value within the range may fail. The return value (if non-`undefined`) should be freed with [[g-variant-unref]] when it is no longer required.

Returns: the state range hint

    method get-action-state-hint ( Str $action_name --> Gnome::Glib::Variant )

  * Str $action_name; the name of the action to query

get-action-state-type
---------------------

Queries the type of the state of the named action within *action-group*. If the action is stateful then this function returns the **GVariantType** of the state. All calls to `change-action-state()` must give a **GVariant** of this type and `g-action-group-get-action-state()` will return a **GVariant** of the same type. If the action is not stateful then this function will return `undefined`. In that case, [[g-action-group-get-action-state]] will return `undefined` and you must not call [[g-action-group-change-action-state]]. The state type of a particular action will never change but it is possible for an action to be removed and for a new action to be added with the same name but a different state type.

Returns: (nullable): the state type, if the action is stateful

    method get-action-state-type ( Str $action_name --> Gnome::Glib::VariantType )

  * Str $action_name; the name of the action to query

has-action
----------

Checks if the named action exists within *action-group*.

Returns: whether the named action exists

    method has-action ( Str $action_name --> Bool )

  * Str $action_name; the name of the action to check for

list-actions
------------

Lists the actions contained within *action-group*.

Returns: an array of the names of the actions in the group

    method list-actions ( --> Array  )

query-action
------------

Queries all aspects of the named action within an *action-group*. This function acquires the information available from `has-action()`, `get-action-enabled()`, `get-action-parameter-type()`, `get-action-state-type()`, `get-action-state-hint()` and `get-action-state()` with a single function call.

This provides two main benefits. The first is the improvement in efficiency that comes with not having to perform repeated lookups of the action in order to discover different things about it. The second is that implementing **GActionGroup** can now be done by only overriding this one virtual function.

Returns: A List if the action exists, else an empty List

    method query-action ( Str $action_name --> List )

  * Str $action_name; the name of an action in the group

The returned list holds;

  * Bool $enabled; if the action is presently enabled

  * Gnome::Glib::VariantType $parameter_type; the parameter type, or `undefined` if none needed

  * Gnome::Glib::VariantType $state_type; the state type, or `undefined` if stateless

  * Gnome::Glib::Variant $state_hint; the state hint, or `undefined` if none

  * Gnome::Glib::Variant $state; the current state, or `undefined` if stateless

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### action-added

Signals that a new action was just added to the group. This signal is emitted after the action has been added and is now visible.

    method handler (
      Str $action_name,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($action_group),
      *%user-options
    );

  * $action_group; the **GActionGroup** that changed

  * $action_name; the name of the action in *action-group*

### action-enabled-changed

Signals that the enabled status of the named action has changed.

    method handler (
      Str $action_name,
      Int $enabled,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($action_group),
      *%user-options
    );

  * $action_group; the **GActionGroup** that changed

  * $action_name; the name of the action in *action-group*

  * $enabled; whether the action is enabled or not

### action-removed

Signals that an action is just about to be removed from the group. This signal is emitted before the action is removed, so the action is still visible and can be queried from the signal handler.

    method handler (
      Str $action_name,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($action_group),
      *%user-options
    );

  * $action_group; the **GActionGroup** that changed

  * $action_name; the name of the action in *action-group*

### action-state-changed

Signals that the state of the named action has changed.

    method handler (
      Str $action_name,
      Unknown type G_TYPE_VARIANT $value,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($action_group),
      *%user-options
    );

  * $action_group; the **GActionGroup** that changed

  * $action_name; the name of the action in *action-group*

  * $value; the new value of the state

