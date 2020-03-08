Gnome::Gio::Action
==================

An action interface

Description
===========

**Gnome::Gio::Action** represents a single named action.

The main interface to an action is that it can be activated with `g_action_activate()`. This results in the 'activate' signal being emitted. An activation has a **GVariant** parameter (which may be `Any`). The correct type for the parameter is determined by a static parameter type (which is given at construction time).

An action may optionally have a state, in which case the state may be set with `g_action_change_state()`. This call takes a **GVariant**. The correct type for the state is determined by a static state type (which is given at construction time).

The state may have a hint associated with it, specifying its valid range.

**Gnome::Gio::Action** is merely the interface to the concept of an action, as described above. Various implementations of actions exist, including **GSimpleAction**.

In all cases, the implementing class is responsible for storing the name of the action, the parameter type, the enabled state, the optional state type and the state and emitting the appropriate signals when these change. The implementor is responsible for filtering calls to `g_action_activate()` and `g_action_change_state()` for type safety and for the state being enabled.

Probably the only useful thing to do with a **Gnome::Gio::Action** is to put it inside of a **GSimpleActionGroup**.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gio::Action;

Methods
=======

[g_action_] get_name
--------------------

Queries the name of *action*.

Returns: the name of the action **Gnome::Gio::Action**

    method g_action_get_name ( --> Str )

[g_action_] get_parameter_type
------------------------------

Queries the type of the parameter that must be given when activating *action*.

When activating the action using `g_action_activate()`, the **GVariant** given to that function must be of the type returned by this function.

In the case that this function returns `Any`, you must not give any **GVariant**, but `Any` instead.

Returns: (nullable): the parameter type **Gnome::Gio::Action** method g_action_get_parameter_type ( --> N-GObject )

[g_action_] get_state_type
--------------------------

Queries the type of the state of *action*.

If the action is stateful (e.g. created with `g_simple_action_new_stateful()`) then this function returns the **GVariantType** of the state. This is the type of the initial value given as the state. All calls to `g_action_change_state()` must give a **GVariant** of this type and `g_action_get_state()` will return a **GVariant** of the same type.

If the action is not stateful (e.g. created with `g_simple_action_new()`) then this function will return `Any`. In that case, `g_action_get_state()` will return `Any` and you must not call `g_action_change_state()`.

Returns: (nullable): the state type, if the action is stateful **Gnome::Gio::Action** method g_action_get_state_type ( --> N-GObject )

[g_action_] get_state_hint
--------------------------

Requests a hint about the valid range of values for the state of *action*.

If `Any` is returned it either means that the action is not stateful or that there is no hint about the valid range of values for the state of the action.

If a **GVariant** array is returned then each item in the array is a possible value for the state. If a **GVariant** pair (ie: two-tuple) is returned then the tuple specifies the inclusive lower and upper bound of valid values for the state.

In any case, the information is merely a hint. It may be possible to have a state value outside of the hinted range and setting a value within the range may fail.

The return value (if non-`Any`) should be freed with `g_variant_unref()` when it is no longer required.

Returns: (nullable) (transfer full): the state range hint **Gnome::Gio::Action** method g_action_get_state_hint ( --> N-GObject )

[g_action_] get_enabled
-----------------------

Checks if *action* is currently enabled.

An action must be enabled in order to be activated or in order to have its state changed from outside callers.

Returns: whether the action is enabled **Gnome::Gio::Action** method g_action_get_enabled ( --> Int )

[g_action_] get_state
---------------------

Queries the current state of *action*.

If the action is not stateful then `Any` will be returned. If the action is stateful then the type of the return value is the type given by `g_action_get_state_type()`.

The return value (if non-`Any`) should be freed with `g_variant_unref()` when it is no longer required.

Returns: (transfer full): the current state of the action **Gnome::Gio::Action** method g_action_get_state ( --> N-GObject )

[g_action_] change_state
------------------------

Request for the state of *action* to be changed to *value*.

The action must be stateful and *value* must be of the correct type. See `g_action_get_state_type()`.

This call merely requests a change. The action may refuse to change its state or may change its state to something other than *value*. See `g_action_get_state_hint()`.

If the *value* GVariant is floating, it is consumed. **Gnome::Gio::Action** method g_action_change_state ( N-GObject $value )

  * N-GObject $value; the new state

g_action_activate
-----------------

Activates the action.

*parameter* must be the correct type of parameter for the action (ie: the parameter type given at construction time). If the parameter type was `Any` then *parameter* must also be `Any`.

If the *parameter* GVariant is floating, it is consumed. **Gnome::Gio::Action** method g_action_activate ( N-GObject $parameter )

  * N-GObject $parameter; (nullable): the parameter to the activation

[g_action_] name_is_valid
-------------------------

Checks if *action_name* is valid.

*action_name* is valid if it consists only of alphanumeric characters, plus '-' and '.'. The empty string is not a valid action name.

It is an error to call this function with a non-utf8 *action_name*. *action_name* must not be `Any`.

Returns: `1` if *action_name* is valid **Gnome::Gio::Action** method g_action_name_is_valid ( Str $action_name --> Int )

  * Str $action_name; an potential action name

[g_action_] parse_detailed_name
-------------------------------

Parses a detailed action name into its separate name and target components.

Detailed action names can have three formats.

The first format is used to represent an action name with no target value and consists of just an action name containing no whitespace nor the characters ':', '(' or ')'. For example: "app.action".

The second format is used to represent an action with a target value that is a non-empty string consisting only of alphanumerics, plus '-' and '.'. In that case, the action name and target value are separated by a double colon ("::"). For example: "app.action::target".

The third format is used to represent an action with any type of target value, including strings. The target value follows the action name, surrounded in parens. For example: "app.action(42)". The target value is parsed using `g_variant_parse()`. If a tuple-typed value is desired, it must be specified in the same way, resulting in two sets of parens, for example: "app.action((1,2,3))". A string target can be specified this way as well: "app.action('target')". For strings, this third format must be used if * target value is empty or contains characters other than alphanumerics, '-' and '.'.

Returns: `1` if successful, else `0` with *error* set **Gnome::Gio::Action** method g_action_parse_detailed_name ( Str $detailed_name, CArray[Str] $action_name, N-GObject $target_value, N-GError $error --> Int )

  * Str $detailed_name; a detailed action name

  * CArray[Str] $action_name; (out): the action name

  * N-GObject $target_value; (out): the target value, or `Any` for no target

  * N-GError $error; a pointer to a `Any` **GError**, or `Any`

[g_action_] print_detailed_name
-------------------------------

Formats a detailed action name from *action_name* and *target_value*.

It is an error to call this function with an invalid action name.

This function is the opposite of `g_action_parse_detailed_name()`. It will produce a string that can be parsed back to the *action_name* and *target_value* by that function.

See that function for the types of strings that will be printed by this function.

Returns: a detailed format string **Gnome::Gio::Action** method g_action_print_detailed_name ( Str $action_name, N-GObject $target_value --> Str )

  * Str $action_name; a valid action name

  * N-GObject $target_value; (nullable): a **GVariant** target value, or `Any`

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Action Name

The name of the action. This is mostly meaningful for identifying the action once it has been added to a **GActionGroup**. It is immutable.

The **Gnome::GObject::Value** type of property *name* is `G_TYPE_STRING`.

### Parameter Type

The type of the parameter that must be given when activating the action. This is immutable, and may be `Any` if no parameter is needed when activating the action.

The **Gnome::GObject::Value** type of property *parameter-type* is `G_TYPE_BOXED`.

### Enabled

If *action* is currently enabled. If the action is disabled then calls to `g_action_activate()` and `g_action_change_state()` have no effect.

The **Gnome::GObject::Value** type of property *enabled* is `G_TYPE_BOOLEAN`.

### State Type

The **GVariantType** of the state that the action has, or `Any` if the action is stateless. This is immutable.

The **Gnome::GObject::Value** type of property *state-type* is `G_TYPE_BOXED`.

### State

The state of the action, or `Any` if the action is stateless.

The **Gnome::GObject::Value** type of property *state* is `G_TYPE_VARIANT`.

