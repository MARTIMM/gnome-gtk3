Gnome::Gtk3::ToggleButton
=========================

Create buttons which retain their state

![](images/toggle-button.png)

Description
===========

A **Gnome::Gtk3::ToggleButton** is a **Gnome::Gtk3::Button** which will remain “pressed-in” when clicked. Clicking again will cause the toggle button to return to its normal state.

A toggle button is created by calling either `gtk_toggle_button_new()` or `gtk_toggle_button_new_with_label()`. If using the former, it is advisable to pack a widget, (such as a **Gnome::Gtk3::Label** and/or a **Gnome::Gtk3::Image**), into the toggle button’s container. (See **Gnome::Gtk3::Button** for more information).

The state of a **Gnome::Gtk3::ToggleButton** can be set specifically using `gtk_toggle_button_set_active()`, and retrieved using `gtk_toggle_button_get_active()`.

To simply switch the state of a toggle button, use `gtk_toggle_button_toggled()`.

Css Nodes
---------

**Gnome::Gtk3::ToggleButton** has a single CSS node with name button. To differentiate it from a plain **Gnome::Gtk3::Button**, it gets the .toggle style class.

Implemented Interfaces
----------------------

  * Gnome::Gtk3::Buildable

  * Gnome::Gtk3::Actionable

  * Gnome::Gtk3::Activatable

See Also
--------

**Gnome::Gtk3::Button**, **Gnome::Gtk3::CheckButton**, **Gnome::Gtk3::CheckMenuItem**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ToggleButton;
    also is Gnome::Gtk3::Button;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create a GtkToggleButton with a label.

    multi method new ( Str :$label )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_toggle_button_new
---------------------

Creates a new toggle button. A widget should be packed into the button, as in `gtk_button_new()`.

Returns: a new toggle button.

    method gtk_toggle_button_new ( --> N-GObject  )

[gtk_toggle_button_] new_with_label
-----------------------------------

Creates a new toggle button with a text label.

Returns: a new toggle button.

    method gtk_toggle_button_new_with_label ( Str $label --> N-GObject  )

  * Str $label; a string containing the message to be placed in the toggle button.

[gtk_toggle_button_] new_with_mnemonic
--------------------------------------

Creates a new **Gnome::Gtk3::ToggleButton** containing a label. The label will be created using `gtk_label_new_with_mnemonic()`, so underscores in *label* indicate the mnemonic for the button.

Returns: a new **Gnome::Gtk3::ToggleButton**

    method gtk_toggle_button_new_with_mnemonic ( Str $label --> N-GObject  )

  * Str $label; the text of the button, with an underscore in front of the mnemonic character

[gtk_toggle_button_] set_mode
-----------------------------

Sets whether the button is displayed as a separate indicator and label. You can call this function on a checkbutton or a radiobutton with `$draw_indicator` = `0` to make the button look like a normal button.

This can be used to create linked strip of buttons that work like a **Gnome::Gtk3::StackSwitcher**.

This function only affects instances of classes like **Gnome::Gtk3::CheckButton** and **Gnome::Gtk3::RadioButton** that derive from **Gnome::Gtk3::ToggleButton**, not instances of **Gnome::Gtk3::ToggleButton** itself.

    method gtk_toggle_button_set_mode ( Int $draw_indicator )

  * Int $draw_indicator; if `1`, draw the button as a separate indicator and label; if `0`, draw the button like a normal button

[gtk_toggle_button_] get_mode
-----------------------------

Retrieves whether the button is displayed as a separate indicator and label. See `gtk_toggle_button_set_mode()`.

Returns: `1` if the togglebutton is drawn as a separate indicator and label.

    method gtk_toggle_button_get_mode ( --> Int  )

[gtk_toggle_button_] set_active
-------------------------------

Sets the status of the toggle button. Set to `1` if you want the **Gnome::Gtk3::ToggleButton** to be “pressed in”, and `0` to raise it. This action causes the *toggled* signal and the *clicked* signal to be emitted.

    method gtk_toggle_button_set_active ( Int $is_active )

  * Int $is_active; `1` or `0`.

[gtk_toggle_button_] get_active
-------------------------------

Queries a **Gnome::Gtk3::ToggleButton** and returns its current state. Returns `1` if the toggle button is pressed in and `0` if it is raised.

Returns: a **Int** value.

    method gtk_toggle_button_get_active ( --> Int  )

gtk_toggle_button_toggled
-------------------------

Emits the *toggled* signal on the **Gnome::Gtk3::ToggleButton**. There is no good reason for an application ever to call this function.

    method gtk_toggle_button_toggled ( )

[gtk_toggle_button_] set_inconsistent
-------------------------------------

If the user has selected a range of elements (such as some text or spreadsheet cells) that are affected by a toggle button, and the current values in that range are inconsistent, you may want to display the toggle in an “in between” state. This function turns on “in between” display. Normally you would turn off the inconsistent state again if the user toggles the toggle button. This has to be done manually, `gtk_toggle_button_set_inconsistent()` only affects visual appearance, it doesn’t affect the semantics of the button.

    method gtk_toggle_button_set_inconsistent ( Int $setting )

  * Int $setting; `1` if state is inconsistent

[gtk_toggle_button_] get_inconsistent
-------------------------------------

Gets the value set by `gtk_toggle_button_set_inconsistent()`.

Returns: `1` if the button is displayed as inconsistent, `0` otherwise

    method gtk_toggle_button_get_inconsistent ( --> Int  )

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

### toggled

Should be connected if you wish to perform an action whenever the **Gnome::Gtk3::ToggleButton**'s state is changed.

    method handler (
      Gnome::GObject::Object :widget($togglebutton),
      *%user-options
    );

  * $togglebutton; the object which received the signal.

