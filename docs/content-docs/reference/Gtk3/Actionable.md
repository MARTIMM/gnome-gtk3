Gnome::Gtk3::Actionable
=======================

An interface for widgets that can be associated with actions

Description
===========

This interface provides a convenient way of associating widgets with actions on a **Gnome::Gtk3::ApplicationWindow** or **Gnome::Gtk3::Application**.

It primarily consists of two properties: *action-name* and *action-target*. There are also some convenience APIs for setting these properties.

The action will be looked up in action groups that are found among the widgets ancestors. Most commonly, these will be the actions with the “win.” or “app.” prefix that are associated with the **Gnome::Gtk3::ApplicationWindow** or **Gnome::Gtk3::Application**, but other action groups that are added with `gtk-widget-insert-action-group()` will be consulted as well.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Actionable;

Methods
=======

get-action-name
---------------

Gets the action name for *actionable*.

See `set-action-name()` for more information.

Returns: the action name, or `undefined` if none is set

    method get-action-name ( --> Str )

get-action-target-value
-----------------------

Gets the current target value of *actionable*.

See `set-action-target-value()` for more information.

Returns: the current target value

    method get-action-target-value ( --> N-GObject )

set-action-name
---------------

Specifies the name of the action with which this widget should be associated. If *action-name* is `undefined` then the widget will be unassociated from any previous action.

Usually this function is used when the widget is located (or will be located) within the hierarchy of a **Gnome::Gtk3::ApplicationWindow**.

Names are of the form “win.save” or “app.quit” for actions on the containing **Gnome::Gtk3::ApplicationWindow** or its associated **Gnome::Gtk3::Application**, respectively.

This is the same form used for actions in the **GMenu** associated with the window.

    method set-action-name ( Str $action_name )

  * $action_name; an action name, or `undefined`

set-action-target-value
-----------------------

Sets the target value of an actionable widget.

If *$target-value* is `undefined` then the target value is unset.

The target value has two purposes. First, it is used as the parameter to activation of the action associated with the **Gnome::Gtk3::Actionable** widget. Second, it is used to determine if the widget should be rendered as “active” — the widget is active if the state is equal to the given target.

Consider the example of associating a set of buttons with a **N-GAction** with string state in a typical “radio button” situation. Each button will be associated with the same action, but with a different target value for that action. Clicking on a particular button will activate the action with the target of that button, which will typically cause the action’s state to change to that value. Since the action’s state is now equal to the target value of the button, the button will now be rendered as active (and the other buttons, with different targets, rendered inactive).

    method set-action-target-value ( N-GObject() $target_value )

  * $target_value; a native **Gnome::Glib::Variant** to set as the target value, or `undefined`

set-detailed-action-name
------------------------

Sets the action-name and associated string target value of an actionable widget.

*$detailed-action-name* is a string in the format accepted by `g-action-parse-detailed-name()`.

    method set-detailed-action-name ( Str $detailed_action_name )

  * $detailed_action_name; the detailed action name

Properties
==========

action-name
-----------

The name of the associated action, like 'app.quit' Default value: Any

The **Gnome::GObject::Value** type of property *action-name* is `G_TYPE_STRING`.

  * Parameter is readable and writable.

  * Default value is undefined.

action-target
-------------

The parameter for action invocations.

The **Gnome::GObject::Value** type of property *action-target* is `G_TYPE_VARIANT`.

  * Parameter is readable and writable.

  * Default value is undefined.

