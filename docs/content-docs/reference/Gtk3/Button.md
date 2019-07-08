TITLE
=====

Gnome::Gtk3::Button

SUBTITLE
========



    unit class Gnome::Gtk3::Button;
    also is Gnome::Gtk3::Bin;

Button — A widget that emits a signal when clicked on
-----------------------------------------------------

Synopsis
========

    my Gnome::Gtk3::Button $start-button .= new(:label<Start>);

Methods
=======

new
---

    multi method new ( Bool :$empty! )

Create an empty button

    multi method new ( Str :$label! )

Creates a new button object with a label

    multi method new ( :$widget! )

Create a button using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a button using a native object from a builder. See also Gnome::GObject::Object.

gtk_button_new
--------------

Creates a new native GtkButton

    method gtk_button_new ( --> N-GObject )

Returns a native widget. Can be used to initialize another object using :widget. This is very cumbersome when you know that a oneliner does the job for you: `my Gnome::Gtk3::Buton $m .= new(:empty);

    my Gnome::Gtk3::Buton $m;
    $m .= :new(:widget($m.gtk_button_new());

[gtk_button_] new_with_label
----------------------------

    method gtk_button_new_with_label ( Str $label --> N-GObject )

Creates a new native button object with a label

[gtk_button_] get_label
-----------------------

    method gtk_button_get_label ( --> Str )

Get text label of button

[gtk_button_] set_label
-----------------------

    method gtk_button_set_label ( Str $label )

Set a label ob the button

Signals
=======

Registering example

    class MyHandlers {
      method my-click-handler ( :$widget, :$my-data ) { ... }
    }

    # elsewhere
    my MyHandlers $mh .= new;
    $button.register-signal( $mh, 'click-handler', 'clicked', :$my-data);

See also method `register-signal` in Gnome::GObject::Object.

Supported signals
-----------------

### clicked

Emitted when the button has been activated (pressed and released).

Handler signature;

    handler ( instance: :$widget, :$user-option1, ..., :$user-optionN )

Unsupported signals
-------------------

### activated

Signal `activated` is not supported because GTK advises against the use of it.

Deprecated signals
------------------

### enter

Signal `enter` has been deprecated since version 2.8 and should not be used in newly-written code. Use the “enter-notify-event” signal.

### leave

Signal `leave` has been deprecated since version 2.8 and should not be used in newly-written code. Use the `leave-notify-event` signal.

### pressed

Signal `pressed` has been deprecated since version 2.8 and should not be used in newly-written code. Use the `button-press-event` signal.

### released

Signal `released` has been deprecated since version 2.8 and should not be used in newly-written code. Use the `button-release-event` signal.

