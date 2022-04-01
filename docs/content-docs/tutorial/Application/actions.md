---
title: Tutorial - Actions
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# GIO Actions
<!--
See also for some text on this subject here [HowDoI `Action`](https://wiki.gnome.org/HowDoI/GAction). Also [Inkshape](https://wiki.inkscape.org/wiki/index.php/GtkAction_migration) has a migration doc with some explanation about the different techniques of signals versus `Action` way of working.
-->

##### Note
This document is taken from [a gnome 'How do I'](https://wiki.gnome.org/HowDoI/GAction) site, for which I am greateful to be able to use it here. However, where it comes to code, class names, etc, it is changed to reflect the Raku implementation of it.

## Introduction
<!--
The purpose of this document is to get an overview of the Action module interactions. Action modules make use of a Variant object to be able to sent all sorts of data to a signal handler. A Variant object can hold simple types to complex types such as arrays, tuples, hashes, etc.

A signal is sent after a call to `.activate()` or `.change-state()`. The activation takes also place, at a button click on e.g. RadioButton or a menu entry click, in short, all widgets inheriting the Actionable interface.
-->

A **Gnome::Gio::Action** is a representation of a single user-interesting action in an application. To use `Action` you should also be using **Gnome::Gtk3::Application** <!--. See HowDoI/GtkApplication.-->

It's possible however, to use `Action` without `Application` but this is not discussed here. This page is about using `Action` within your `Application`.

An `Action` is essentially a way to tell the toolkit about a piece of functionality in your program, and to give it a name. Also Actions are purely functional. They do not contain any presentational information.


## Information and rules

An action has four pieces of information associated with it:

* A name as an identifier (usually all-lowercase)
* An enabled flag indicating if the action can be activated or not (like "sensitive")
* An optional state value, for stateful actions (like a boolean for toggles)
* An optional parameter type, used when activating the action


An action supports two operations:

* Activation, invoked with an optional parameter (of the correct type, see above)
* State change request, invoked with a new requested state value (of the correct type). Only supported for stateful actions.


Here are some rules about an action:

* The name is immutable (in the sense that it will never change) and it must always be a defined non-empty string.
* The enabled flag can change.
* The parameter type is immutable.
* The parameter type is optional: it can be undefined.
* If the parameter type is undefined, then action activation must be done without a parameter. <!-- (ie: an undefined native pointer)-->
* If the parameter type is defined then the parameter given to the action, must have this type.
* The state can change, but it cannot change type.
* If the action was stateful when it was created, it will always have a state and it will always have exactly the same type (such as boolean or string)
* If the action was stateless when it was created, it can never have a state
* You can only request state changes on stateful actions and it is only possible to request that the state change to a value of the same type as the existing state


An action does not have any of the following:

* A label
* An icon
* A way of creating a widget corresponding to it
* Any other sort of presentational information


## Action state and parameters

Most actions in your application will be stateless actions with no parameters. These typically appear as menu items with no special decoration. An example is a "quit" menu entry.

Stateful actions are used to represent an action which has a closely-associated state of some kind. A good example is a "fullscreen" action. For this case, you'd expect to see a checkmark next to the menu item when the fullscreen option is active. This is usually called a toggle action, and it has a boolean state. By convention, toggle actions have no parameter type for activation: activating the action always toggles the state.

Another common case is to have an action representing a enumeration of possible values of a given type (typically string). This is often called a radio action and is usually represented in the user interface with radio buttons or radio menu items, or sometimes a combobox. A good example is "text-justify" with possible values "left", "center", and "right". By convention, these types of actions have a parameter type equal to their state type, and activating them with a particular parameter value is equivalent to changing their state to that value.

This approach to handling radio buttons is different than many other action systems such as GtkAction. With `Action`, there is only one action for "text-justify" and "left", "center" and "right" are possible states on that action. There are not three separate "justify-left", "justify-center" and "justify-right" actions.

The final common type of action is a stateless action with a parameter. This is typically used for actions like "open-bookmark" where the parameter to the action would be the identifier of the bookmark to open.


## Action target and detailed names

Because some types of actions cannot be invoked without a parameter, it is often important to specify a parameter when referring to the action from a place where it will be invoked (such as from a radio button that sets the state to a particular value or from a menu item that opens a specific bookmark). From these contexts, the value used for the action parameter is typically called the target of the action.

Even though toggle actions have a state, they do not have a parameter. Therefore, a target value is not needed when referring to them -- they will always be toggled on activation.

Most APIs that allow using a `Action` (such as GMenuModel and GtkActionable) allow use of detailed action names. This is a convenient way of specifying an action name and an action target with a single string.

In the case that the action target is a string with no unusual characters (ie: only alpha-numeric, plus '-' and '.') then you can use a detailed action name of the form "justify::left" to specify the justify action with a target of left.

In the case that the action target is not a string, or contains unusual characters, you can use the more general format "action-name(5)", where the "5" here is any valid text-format GVariant (ie: a string that can be parsed by g_variant_parse()). Another example is "open-bookmark('http://gnome.org/')".

You can convert between detailed action names and split-out action names and target values using g_action_parse_detailed_action_name() and g_action_print_detailed_action_name() but usually you will not need to. Most APIs will provide both ways of specifying actions with targets.


## Action scopes

Actions are always scoped to a particular object on which they operate.

The two things that it's possible to scope an action to with GTK+ are applications and windows.

Actions scoped to windows should be the actions that specifically impact that window. These are actions like "fullscreen" and "close", or in the case that a window contains a document, "save" and "print".

Actions that impact the application as a whole rather than one specific window are scoped to the application. These are actions like "about" and "preferences".

If a particular action is scoped to a window then it is scoped to a specific window. Another way of saying this: if your application has a "fullscreen" action that applies to windows and it has three windows, then it will have three fullscreen actions: one for each window.

Having a separate action per-window allows for each window to have a separate state for each instance of the action as well as being able to control the enabled state of the action on a per-window basis.

Actions are added to their relevant scope (application or window) using the `Action`Map interface.



## `Action`Map

`Action`Map is an interface exposing a mapping of action names to actions. It is implemented by `Application` and `Application`Window. Actions can be added, removed, or looked up.

void                g_action_map_add_action             (`Action`Map  *action_map,
                                                         `Action`     *action);
void                g_action_map_remove_action          (`Action`Map  *action_map,
                                                         const gchar *action_name);
`Action` *           g_action_map_lookup_action          (`Action`Map  *action_map,
                                                         const gchar *action_name);

If you want to insert several actions at the same time, it is typically faster and easier to use `Action`Entry.

When referring to actions on a `Action`Map only the name of the action itself is used (ie: "quit", not "app.quit"). The "app.quit" form is only used when referring to actions from places like a GMenu or GtkActionable widget where the scope of the action is not already known. Because you're using the `Application` or `Application`Window as the `Action`Map it is clear which object your action is scoped to, so the prefix is not needed.



## GSimpleAction vs. `Action`

`Action` is an interface with several implementations. The one that you are most likely to use directly is GSimpleAction.

A good way to think about the split between `Action` and GSimpleAction is that `Action` is the "consumer interface" and GSimpleAction is the provider interface. The `Action` interface provides the functions that are consumed by users/callers/displayers of the action (such as menus and widgets). The GSimpleAction interface is only accessed by the code that provides the implementation for the action itself.

Note that `Action`Map takes a `Action`. Your action will only be "consumed" as a result of you putting it in a `Action`Map.

Compare:

    `Action` has a function for checking if an action is enabled (g_action_get_enabled()) but only the GSimpleAction API can enable or disable an action (g_simple_action_set_enabled()).

    `Action` has a function to query the state of the action (g_action_get_state()) and request changes to it (g_action_change_state()) but only GSimpleAction has the API to directly set the state value (g_simple_action_set_state()).

If you want to provide a custom `Action` implementation then you can have your own mechanism to control access to state setting and enabled. The GSettings `Action` implementation, for example, gets its state directly from the value in GSettings and is enabled according to lockdown in effect on the key. It is not possible to directly modify these values in any way (although it is possible to indirectly affect the state by changing the value of the setting, if you have permission to do so).



## Using GSimpleAction

If you are implementing actions, probably you will do it with GSimpleAction.

GSimpleAction has two interesting signals: activate and change-state. These correspond directly to g_action_activate() and g_action_change_state(). You will almost certainly need to connect a handler to the activate signal in order to handle the action being activated. The signal handler takes a GVariant parameter which is the parameter that was passed to g_action_activate().

If your action is stateful, you may also want to connect a change-state handler to deal with state change requests. If your action is stateful and you do not connect a handler for the change-state signal then the default is that all state change requests will always change the state to the requested value. Even if you always want the state to be set to the requested value, you will probably want to connect a handler so that you can take some action in response to the state being changed.

The default behaviour of setting the state in response to g_action_change_state() is disabled when connecting a handler to change-state. You therefore need to be sure to call g_simple_action_set_state() from your handler if you actually want the state to change.

A convenient way to bulk-create all the GSimpleActions you need to add to a `Action`Map is to use a `Action`Entry array and `g_action_map_add_action_entries()'.

static `Action`Entry app_entries[] =
{
  { "preferences", preferences_activated, NULL, NULL, NULL },
  { "quit", quit_activated, NULL, NULL, NULL }
};

static void
example_app_startup (GApplication *app)
{
  ...
  g_action_map_add_action_entries (G_ACTION_MAP (app),
                                   app_entries, G_N_ELEMENTS (app_entries),
                                   app);
  ...
}



## Other kinds of actions

Besides GSimpleAction, GIO provides some other implementations of `Action`. One is GSettingsAction, which wraps a GSettings key with an action that represents the value of the setting and lets you set the key to a new value when activated. Another is GPropertyAction, which similarly wraps a GObject property.

Both GSettingsAction and GPropertyAction implement toggle-on-activate behaviour for boolean states - note that GSimpleAction does not, you have to implement an activate handler yourself for that.



## Adding actions to your `Application`

You can add a `Action` to anything implementing the `Action`Map interface, including `Application`. This is done with g_action_map_add_action(). For GSimpleActions, you can also use g_action_map_add_action_entries().

Typically, you will want to do this during the startup phase of your application. See HowDoI/`Application` for more information on that.

It's possible to add or remove actions at any time, but doing it before startup is wasteful in case the application is a remote instance (and will just exit anyway). It is also possible to dynamically add and remove actions any time after startup, when the application is running.



Adding actions to your `Application`Window

`Application`Window also implements `Action`Map. You will typically want to add most actions to your window when it is constructed. It is possible to add and remove actions at any time while the window exists.

For example:
Toggle line numbers

   1 from gi.repository import Gio, Gtk
   2
   3 def saveCb(action, param):
   4     print "You are welcome"
   5
   6 def activateCb(app):
   7     window = Gtk.ApplicationWindow()
   8     app.add_window(window)
   9     window.show()
  10
  11     action = Gio.SimpleAction.new("save", None)
  12     action.connect("activate", saveCb)
  13     window.add_action(action)
  14
  15     button = Gtk.Button.new()
  16     button.set_label("Save")
  17     button.show()
  18     window.add(button)
  19     button.set_action_name("win.save")
  20
  21 app = Gtk.Application()
  22 app.connect("activate", activateCb)
  23 app.run([])




## Accelerators (keybindings) for actions

Use gtk_application_add_accelerator inside your application's startup implementation. For example:

   const char *accels[] = {"<Contol><Shift>T", NULL};
   gtk_application_set_accels_for_action (app, "win.new_tab", accels);



## What can be done with actions

`Action`s that you add to your application or window can be used in several different ways.

    used with GMenu

    used with GtkActionable widgets
    remotely activated from a remote GApplication instance (only for application actions)
    listed as "Additional application actions" in desktop files (only for application actions)
    remotely activated from other D-Bus callers (such as Ubuntu's HUD)
    used with GNotification notifications (only for application actions, available since GLib 2.39)



















# Actions Model

## UML diagram

In the diagram below, the Button class inherit indirectly from Widget and Application has a Button somewhere as a child object on its UI. The UML diagram is like shown below. It's a one to one mapping from the C-libraries setup.

![actions diagram](images/actions.svg)


## User Programming Steps

There are some steps involved to make use of Actions.

* Create a SimpleAction object with or without a state.
* Register a signal handler for an `activate` signal.
* Add the SimpleAction to the ActionMap in a Application or ApplicationWindow.
* Add an Actionable widget such as a Button to the GUI.
* Set the action name of this widget to `app.something` or `win.something` depending if an Application or ApplicationWindow is used to store the SimpleAction.


## Advantages

* Used with **Gnome::Gio::Menu**. This might not be very interesting to Raku because of the menu widgets provided in GTK. However, Gtk version 4 does not have any support for menu items anymore because the menu items already did depend on **Gnome::Gio::Menu** and therefore are not really necessary. So, to be ready for the 4th version, you better use the Gio menu versions.

* Used with **Gnome::Gtk3::Actionable** widgets. There are menu and button widgets using this interface.
  The complete list of classes using Actionable is;
  * Button
  * CheckButton
  * CheckMenuItem
  * ColorButton
  * FontButton
  * ImageMenuItem
  * LinkButton
  * ListBoxRow
  * LockButton
  * MenuButton
  * MenuItem
  * MenuToolButton
  * ModelButton
  * RadioButton
  * RadioMenuItem
  * RadioToolButton
  * ScaleButton
  * SeparatorMenuItem
  * Switch
  * TearoffMenuItem
  * ToggleButton
  * ToggleToolButton
  * ToolButton
  * VolumeButton
* They can be remotely activated from a remote **Gnome::Gio::Application** instance. This works only for application actions, those with a 'app.' prefix. A **Gnome::Gio::SimpleAction** is stored in an Application.
* Can be listed as "additional application actions" in desktop files. This also works only for application actions.
* Can be remotely activated from other D-Bus callers.
* Can be used with **Gnome::Gio::Notification** notifications but works only for application actions.

Other remarks from the Inkscape migration web page;
* Less code to write: we only need one signal handler for the "activate" signal for a particular action; not multiple handlers for each GUI event. So, no need to register a handler on a button, menu entry, d-bus or whatever, if they need to do the same action.
* Easier look-up: Each action is identified by a unique text ID, and so we can access it by name.
* It is trivial to allow actions (with or without arguments) to be called from the command line.
* There is a built in DBus interface.

Action signals can also be fired by calling `.activate()`. A value, if needed, can be set by `.set-action-target-value()` before calling. State changes can be done by calling `.change-state()` which in turn trigger a `change-state` signal. Without a handler, it always sets the new state. If there is a handler, the handler is called with the new state and the handler must set it explicitly using a call to `.set-state()` and return a success code.
As I understand it, `action` signals can come from other sources then your current running program (it might come from a second instance of the same program) and also from a call to `.action()`. `change-state` signals, however, always are initiated by a call from `.change-state()`.

### Raku model

Seeing the advantages, most importantly the triggers caused by outside processes such as DBus and multiple started applications, it is necessary to implement the modules involved. However, there might be a possible way to minimize the use of Variants.
