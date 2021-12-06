Gnome::Gtk3::ColorButton
========================

A button to launch a color selection dialog

![](images/color-button.png)

Description
===========

The **Gnome::Gtk3::ColorButton** is a button which displays the currently selected color and allows to open a color selection dialog to change the color. It is a suitable widget for selecting a color in a preference dialog.

Css Nodes
---------

**Gnome::Gtk3::ColorButton** has a single CSS node with name button. To differentiate it from a plain **Gnome::Gtk3::Button**, it gets the .color style class.

See Also
--------

**Gnome::Gtk3::ColorSelectionDialog**, **Gnome::Gtk3::FontButton**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ColorButton;
    also is Gnome::Gtk3::Button;
    also does Gnome::Gtk3::ColorChooser;

Uml Diagram
-----------

![](plantuml/ColorButton.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::ColorButton;

    unit class MyGuiClass;
    also is Gnome::Gtk3::ColorButton;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::ColorButton class process the options
      self.bless( :GtkColorButton, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

    my GdkRGBA $color .= new(
      :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
    );
    my Gnome::Gtk3::ColorButton $color-button .= new(:$color));

Methods
=======

new
---

### default, no options

Creates a new color button. This creates a widget in the form of a small button containing a swatch representing the current selected color. When the button is clicked, a color-selection dialog will open, allowing the user to select a color. The swatch will be updated to reflect the new color when the user finishes.

    multi method new ( )

### :color

Create a color button with a new color

    multi method_new ( GdkRGBA :$color! )

### :native-object

Create a ColorButton object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a ColorButton object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-title
---------

Gets the title of the color selection dialog.

Returns: An internal string, do not free the return value

    method get-title ( --> Str )

set-title
---------

Sets the title for the color selection dialog.

    method set-title ( Str $title )

  * Str $title; String containing new window title

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

### color-set

The *color-set* signal is emitted when the user selects a color. When handling this signal, use `get-rgba()` to find out which color was just selected.

Note that this signal is only emitted when the user changes the color. If you need to react to programmatic color changes as well, use the notify::color signal.

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

  * $_handle_id; the registered event handler id

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Current RGBA Color: rgba

The RGBA color.

The **Gnome::GObject::Value** type of property *rgba* is `G_TYPE_BOXED`.

### Show Editor: show-editor

Set this property to `True` to skip the palette in the dialog and go directly to the color editor.

This property should be used in cases where the palette in the editor would be redundant, such as when the color button is already part of a palette.

The **Gnome::GObject::Value** type of property *show-editor* is `G_TYPE_BOOLEAN`.

### Title: title

The title of the color selection dialog

The **Gnome::GObject::Value** type of property *title* is `G_TYPE_STRING`.

### Use alpha: use-alpha

If this property is set to `True`, the color swatch on the button is rendered against a checkerboard background to show its opacity and the opacity slider is displayed in the color selection dialog.

The **Gnome::GObject::Value** type of property *use-alpha* is `G_TYPE_BOOLEAN`.

