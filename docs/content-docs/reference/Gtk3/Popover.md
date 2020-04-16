Gnome::Gtk3::Popover
====================

Context dependent bubbles

Description
===========

**Gnome::Gtk3::Popover** is a bubble-like context window, primarily meant to provide context-dependent information or options. Popovers are attached to a widget, passed at construction time on `gtk_popover_new()`, or updated afterwards through `gtk_popover_set_relative_to()`, by default they will point to the whole widget area, although this behavior can be changed through `gtk_popover_set_pointing_to()`.

The position of a popover relative to the widget it is attached to can also be changed through `gtk_popover_set_position()`.

By default, **Gnome::Gtk3::Popover** performs a GTK+ grab, in order to ensure input events get redirected to it while it is shown, and also so the popover is dismissed in the expected situations (clicks outside the popover, or the Esc key being pressed). If no such modal behavior is desired on a popover, `gtk_popover_set_modal()` may be called on it to tweak its behavior.

Css Nodes
---------

**Gnome::Gtk3::Popover** has a single css node called popover. It always gets the .background style class and it gets the .menu style class if it is menu-like (e.g. **Gnome::Gtk3::PopoverMenu** or created using `gtk_popover_new_from_model()`.

Particular uses of **Gnome::Gtk3::Popover**, such as touch selection popups or magnifiers in **Gnome::Gtk3::Entry** or **Gnome::Gtk3::TextView** get style classes like .touch-selection or .magnifier to differentiate from plain popovers.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Popover;
    also is Gnome::Gtk3::Bin;

Methods
=======

new
---

Create a new Popover object to point to *relative_to*.

    multi method new ( N-GObject :$relative-to! )

Create a Popover object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a Popover object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_popover_] set_relative_to
------------------------------

Sets a new widget to be attached to *popover*. If *popover* is visible, the position will be updated.

Note: the ownership of popovers is always given to their *relative_to* widget, so if *relative_to* is set to `Any` on an attached *popover*, it will be detached from its previous widget, and consequently destroyed unless extra references are kept.

    method gtk_popover_set_relative_to ( N-GObject $relative_to )

  * N-GObject $relative_to; (allow-none): a **Gnome::Gtk3::Widget**

[gtk_popover_] get_relative_to
------------------------------

Returns the widget *popover* is currently attached to

Returns: (transfer none): a **Gnome::Gtk3::Widget**

    method gtk_popover_get_relative_to ( --> N-GObject )

[gtk_popover_] set_pointing_to
------------------------------

Sets the rectangle that *popover* will point to, in the coordinate space of the widget *popover* is attached to, see `gtk_popover_set_relative_to()`.

    method gtk_popover_set_pointing_to ( N-GdkRectangle $rect )

  * N-GdkRectangle $rect; rectangle to point to

[gtk_popover_] get_pointing_to
------------------------------

If a rectangle to point to has been set, this function will return `1` and fill in *rect* with such rectangle, otherwise it will return `0` and fill in *rect* with the attached widget coordinates.

Returns: `1` if a rectangle to point to was set.

    method gtk_popover_get_pointing_to ( N-GObject $rect --> Int )

  * N-GObject $rect; (out): location to store the rectangle

[gtk_popover_] set_position
---------------------------

Sets the preferred position for *popover* to appear. If the *popover* is currently visible, it will be immediately updated.

This preference will be respected where possible, although on lack of space (eg. if close to the window edges), the **Gnome::Gtk3::Popover** may choose to appear on the opposite side

    method gtk_popover_set_position ( GtkPositionType $position )

  * GtkPositionType $position; preferred popover position

[gtk_popover_] get_position
---------------------------

Returns the preferred position of *popover*.

Returns: The preferred position.

    method gtk_popover_get_position ( --> GtkPositionType )

[gtk_popover_] set_modal
------------------------

Sets whether *popover* is modal, a modal popover will grab all input within the toplevel and grab the keyboard focus on it when being displayed. Clicking outside the popover area or pressing Esc will dismiss the popover and ungrab input.

    method gtk_popover_set_modal ( Int $modal )

  * Int $modal; **TRUE** to make popover claim all input within the toplevel

[gtk_popover_] get_modal
------------------------

Returns whether the popover is modal, see gtk_popover_set_modal to see the implications of this.

Returns: **TRUE** if *popover* is modal

    method gtk_popover_get_modal ( --> Int )

[gtk_popover_] bind_model
-------------------------

Establishes a binding between a **Gnome::Gtk3::Popover** and a **GMenuModel**.

The contents of *popover* are removed and then refilled with menu items according to *model*. When *model* changes, *popover* is updated. Calling this function twice on *popover* with different *model* will cause the first binding to be replaced with a binding to the new model. If *model* is `Any` then any previous binding is undone and all children are removed.

If *action_namespace* is non-`Any` then the effect is as if all actions mentioned in the *model* have their names prefixed with the namespace, plus a dot. For example, if the action “quit” is mentioned and *action_namespace* is “app” then the effective action name is “app.quit”.

This function uses **Gnome::Gtk3::Actionable** to define the action name and target values on the created menu items. If you want to use an action group other than “app” and “win”, or if you want to use a **Gnome::Gtk3::MenuShell** outside of a **Gnome::Gtk3::ApplicationWindow**, then you will need to attach your own action group to the widget hierarchy using `gtk_widget_insert_action_group()`. As an example, if you created a group with a “quit” action and inserted it with the name “mygroup” then you would use the action name “mygroup.quit” in your **GMenuModel**.

    method gtk_popover_bind_model ( N-GObject $model, Str $action_namespace )

  * N-GObject $model; the **GMenuModel** to bind to or undefined to remove binding

  * Str $action_namespace; the namespace for actions in *model*. May be undefined

[gtk_popover_] set_default_widget
---------------------------------

Sets the widget that should be set as default widget while the popover is shown (see `gtk_window_set_default()`). **Gnome::Gtk3::Popover** remembers the previous default widget and reestablishes it when the popover is dismissed.

    method gtk_popover_set_default_widget ( N-GObject $widget )

  * N-GObject $widget; (allow-none): the new default widget, or `Any`

[gtk_popover_] get_default_widget
---------------------------------

Gets the widget that should be set as the default while the popover is shown.

Returns: (nullable) (transfer none): the default widget, or `Any` if there is none

    method gtk_popover_get_default_widget ( --> N-GObject )

[gtk_popover_] set_constrain_to
-------------------------------

Sets a constraint for positioning this popover.

Note that not all platforms support placing popovers freely, and may already impose constraints.

    method gtk_popover_set_constrain_to ( GtkPopoverConstraInt $constraint )

  * GtkPopoverConstraInt $constraint; the new constraint

[gtk_popover_] get_constrain_to
-------------------------------

Returns the constraint for placing this popover. See `gtk_popover_set_constrain_to()`.

Returns: the constraint for placing this popover.

    method gtk_popover_get_constrain_to ( --> GtkPopoverConstraInt )

gtk_popover_popup
-----------------

Pops *popover* up. This is different than a `gtk_widget_show()` call in that it shows the popover with a transition. If you want to show the popover without a transition, use `gtk_widget_show()`.

    method gtk_popover_popup ( )

gtk_popover_popdown
-------------------

Pops *popover* down.This is different than a `gtk_widget_hide()` call in that it shows the popover with a transition. If you want to hide the popover without a transition, use `gtk_widget_hide()`.

    method gtk_popover_popdown ( )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### closed

This signal is emitted when the popover is dismissed either through API or user interaction.

    method handler (
      ,
      *%user-options
    );

