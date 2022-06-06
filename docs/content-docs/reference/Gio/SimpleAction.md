Gnome::Gio::SimpleAction
========================

A simple **Gnome::Gio::Action** implementation

Description
===========

A **Gnome::Gio::SimpleAction** is the obvious simple implementation of the **Gnome::Gio::Action** interface. This is the easiest way to create an action for purposes of adding it to a **Gnome::Gio::SimpleActionGroup**.

See also **Gnome::Gio::Action**.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::SimpleAction;
    also is Gnome::GObject::Object;
    also does Gnome::Gio::Action;

Uml Diagram
-----------

![](plantuml/SimpleAction.svg)

Methods
=======

new
---

### :name, :parameter-type

Create a new stateless SimpleAction object.

    multi method new ( Str :$name!, N-GObject() :$parameter-type? )

  * $name; the name of the action

  * $parameter_type; the type of parameter that will be passed to handlers for the *activate* signal. The $parameter_type is a native **Gnome::Glib::Variant** object.

### :name, :state, :parameter-type

Create a new stateful SimpleAction object. All future state values must have the same type as the initial *$state* variant object.

    multi method new (
      Str :$name!, N-GObject() :$state!, N-GObject() :$parameter_type?
    )

  * $name; the name of the action

  * $parameter_type; the type of the parameter that will be passed to handlers for the *activate* signal. The $parameter_type is a native **Gnome::Glib::VariantType** object.

  * $state; the initial state value of the action. The state is a native **Gnome::Glib::Variant** object.

### :native-object

Create a SimpleAction object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject() :$native-object! )

set-enabled
-----------

Sets the action as enabled or not.

An action must be enabled in order to be activated or in order to have its state changed from outside callers.

This should only be called by the implementor of the action. Users of the action should not attempt to modify its enabled flag.

    method set-enabled ( Bool $enabled )

  * $enabled; whether the action is enabled

set-state
---------

Sets the state of the action.

This directly updates the 'state' property to the given value.

This should only be called by the implementor of the action. Users of the action should not attempt to directly modify the 'state' property. Instead, they should call `Gnome::Gio::Action.change-state()` to request the change.

    method set-state ( N-GObject() $value )

  * $value; the new value for the state. The state is a native **Gnome::Glib::Variant** object.

set-state-hint
--------------

Sets the state hint for the action.

See `Gnome::Gio::Action.get_state_hint()` for more information about action state hints.

    method set-state-hint ( N-GObject() $state_hint )

  * $state_hint; a native **Gnome::Gio::Variant** representing the state hint, may be an undefined value.

Signals
=======

activate
--------

Indicates that the action was just activated.

*$parameter* will always be of the expected type, i.e. the parameter type specified when the action was created. If an incorrect type is given when activating the action, this signal is not emitted.

If no handler is connected to this signal then the default behaviour for boolean-stated actions with an undefined parameter type is to toggle them via the *change-state* signal.

For stateful actions where the state type is equal to the parameter type, the default is to forward them directly to *change-state*. This should allow almost all users of **Gnome::Gio::SimpleAction** to connect only one handler or the other.

    method handler (
      N-GObject $parameter,
      Gnome::Gio::SimpleAction :_widget($simple),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $parameter; a native **Gnome::Gio::Variant**, the parameter to the activation, or `undefined` if it has no parameter

  * $simple; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

change-state
------------

Indicates that the action just received a request to change its state.

*value* will always be of the correct state type, i.e. the type of the initial state passed to a `new(:state, …)`. If an incorrect type is given when requesting to change the state, this signal is not emitted.

If no handler is connected to this signal then the default behaviour is to call `set-state()` to set the state to the requested value. If you connect a signal handler then no default action is taken. If the state should change then you must call `set-state()` from the handler.

    method handler (
      N-GObject $parameter,
      Gnome::Gio::SimpleAction :_widget($simple),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $value; a native **Gnome::Gio::Variant**, the requested value for the state, or `undefined` if it has no parameter

  * $simple; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

enabled
-------

If the action can be activated

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

name
----

The name used to invoke the action

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is undefined.

parameter-type
--------------

The type of GVariant passed to `activate()`

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * The type of this G_TYPE_BOXED object is G_TYPE_VARIANT_TYPE

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

state
-----

The state the action is in

  * **Gnome::GObject::Value** type of this property is G_TYPE_VARIANT

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is undefined.

state-type
----------

The type of the state kept by the action

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOXED

  * The type of this G_TYPE_BOXED object is G_TYPE_VARIANT_TYPE

  * Parameter is readable.

