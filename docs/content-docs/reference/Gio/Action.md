Gnome::Gio::Action
==================

An action interface

Description
===========

**Gnome::Gio::Action** represents a single named action.

The main interface to an action is that it can be activated with `activate()`. This results in the 'activate' signal being emitted.

An action may optionally have a state, in which case the state may be set with `change-state()`. This call takes a **N-GVariant**. The correct type for the state is determined by a static state type (which is given at construction time).

The state may have a hint associated with it, specifying its valid range.

**Gnome::Gio::Action** is merely the interface to the concept of an action, as described above. Various implementations of actions exist, including **GSimpleAction**.

In all cases, the implementing class is responsible for storing the name of the action, the parameter type, the enabled state, the optional state type and the state and emitting the appropriate signals when these change. The implementor is responsible for filtering calls to `activate()` and `change-state()` for type safety and for the state being enabled.

Probably the only useful thing to do with a **Gnome::Gio::Action** is to put it inside of a **GSimpleActionGroup**.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gio::Action;

Methods
=======

activate
--------

Activates the action. *$parameter* must be the correct type of parameter for the action (ie: the parameter type given at construction time). If the parameter type was undefined then *$parameter* must also be undefined. If the *$parameter* GVariant is floating, it is consumed.

    method activate ( N-GVariant $parameter )

  * N-GVariant $parameter; the parameter to the activation

change-state
------------

Request for the state of this action to be changed to *$value*. The action must be stateful and *value* must be of the correct type. See `get-state-type()`. This call merely requests a change. The action may refuse to change its state or may change its state to something other than *value*. See `get-state-hint()`.

    method change-state ( N-GVariant $value )

  * N-GVariant $value; the new state

get-enabled
-----------

Checks if this action is currently enabled. An action must be enabled in order to be activated or in order to have its state changed from outside callers.

Returns: whether the action is enabled

    method get-enabled ( --> Bool )

get-name
--------

Queries the name of this action.

Returns: the name of the action.

    method get-name ( -->  Str  )

get-parameter-type
------------------

Queries the type of the parameter that must be given when activating this action. When activating the action using `activate()`, the **N-GVariant** given to that function must be of the type returned by this function. In the case that this function returns undefined, you must not give any **N-GVariant**, but undefined instead.

Returns: the parameter type.

    method get-parameter-type ( --> Gnome::Glib::VariantType )

get-state
---------

Queries the current state of this action. If the action is not stateful then undefined will be returned. If the action is stateful then the type of the return value is the type given by `get-state-type()`. The return value (if not undefined) should be freed with `clear-object()` when it is no longer required.

Returns: the current state of the action.

    method get-state ( --> Gnome::Glib::Variant )

get-state-hint
--------------

Requests a hint about the valid range of values for the state of this action. If an undefined value is returned, it either means that the action is not stateful or that there is no hint about the valid range of values for the state of the action.

Returns: the state range hint, an undefined, array or tuple Variant.

    method get-state-hint ( --> Gnome::Glib::Variant )

get-state-type
--------------

Queries the type of the state of this action. If the action is stateful, then this function returns the **Gnome::Glib::VariantType** of the state. This is the type of the initial value given as the state. All calls to `change-state()` must give a **N-GVariant** of this type and `get-state()` will return a **N-GVariant** of the same type. If the action is not stateful, then this function will return an undefined type. In that case, `get-state()` will return undefined and you must not call `change-state()`.

Returns: the state type, if the action is stateful

    method get-state-type ( --> Gnome::Glib::VariantType )

name-is-valid
-------------

Checks if *$action_name* is valid. *$action_name* is valid if it consists only of alphanumeric characters, plus '-' and '.'. The empty string is not a valid action name. It is an error to call this function with a non-utf8 *action_name*.

Returns: `True` if *action_name* is valid

    method name-is-valid (  Str  $action_name --> Bool )

  * Str $action_name; an potential action name

parse-detailed-name
-------------------

Parses a detailed action name into its separate name and target components. Detailed action names can have three formats.

The first format is used to represent an action name with no target value and consists of just an action name containing no whitespace or the characters ':', '(' or ')'. For example: *app.action*.

The second format is used to represent an action with a target value that is a non-empty string consisting only of alphanumerics, plus '-' and '.'. In that case, the action name and target value are separated by a double colon ("::"). For example: *app.action::target*.

The third format is used to represent an action with any type of target value, including strings. The target value follows the action name, surrounded in parens. For example: *app.action(42)*.

The target value is parsed using `parse()` from **Gnome::Glib::Variant**. If a tuple-typed value is desired, it must be specified in the same way, resulting in two sets of parens, for example: *app.action((1,2,3))*. A string target can be specified this way as well: *app.action('target')*. For strings, this third format must be used if the target value is empty or contains characters other than alphanumerics, '-' and '.'.

Returns: A List

    method parse-detailed-name ( Str $detailed_name --> List )

  * Str $detailed_name; a detailed action name

The returned List contains;

  * Str $action_name; the action name

  * Gnome::Glib::Variant $target_value; the target value, or an undefined type for no target

  * Gnome::Glib::Error which is invalid if call returns successfull or is valid with an error message and code explaining the cause.

print-detailed-name
-------------------

Formats a detailed action name from *$action_name* and *$target_value*. It is an error to call this function with an invalid action name. This function is the opposite of `parse-detailed-name()`. It will produce a string that can be parsed back to the *$action_name* and *$target_value* by that function. See that function for the types of strings that will be printed by this function.

Returns: a detailed format string

    method print-detailed-name (
      Str $action_name, N-GVariant $target_value
      --> Str
    )

  * Str $action_name; a valid action name

  * N-GVariant $target_value; a **N-GVariant** target value, or undefined

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

If this action is currently enabled.

If the action is disabled then calls to `g_action_activate()` and `g_action_change_state()` have no effect.

The **Gnome::GObject::Value** type of property *enabled* is `G_TYPE_BOOLEAN`.

### State Type

The **N-GVariantType** of the state that the action has, or `Any` if the action is stateless. This is immutable.

The **Gnome::GObject::Value** type of property *state-type* is `G_TYPE_BOXED`.

### State

The state of the action, or `Any` if the action is stateless.

The **Gnome::GObject::Value** type of property *state* is `G_TYPE_VARIANT`.

