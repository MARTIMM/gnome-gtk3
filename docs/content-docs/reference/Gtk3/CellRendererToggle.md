Gnome::Gtk3::CellRendererToggle
===============================

Renders a toggle button in a cell

Description
===========

**Gnome::Gtk3::CellRendererToggle** renders a toggle button in a cell. The button is drawn as a radio or a checkbutton, depending on the *radio* property. When activated, it emits the *toggled* signal.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererToggle;
    also is Gnome::Gtk3::CellRenderer;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] cell_renderer_toggle_new
-------------------------------

Creates a new **Gnome::Gtk3::CellRendererToggle**. Adjust rendering parameters using object properties. Object properties can be set globally (with `g_object_set()`). Also, with **Gnome::Gtk3::TreeViewColumn**, you can bind a property to a value in a **Gnome::Gtk3::TreeModel**. For example, you can bind the “active” property on the cell renderer to a boolean value in the model, thus causing the check button to reflect the state of the model.

Returns: the new cell renderer

    method gtk_cell_renderer_toggle_new ( --> N-GObject  )

[[gtk_] cell_renderer_toggle_] get_radio
----------------------------------------

Returns `1` whether we’re rendering radio toggles rather than checkboxes.

    method gtk_cell_renderer_toggle_get_radio ( --> Int  )

[[gtk_] cell_renderer_toggle_] set_radio
----------------------------------------

If *$radio* is `True`, the cell renderer renders a radio toggle (i.e. a toggle in a group of mutually-exclusive toggles). If `False`, it renders a check toggle (a standalone boolean option). This can be set globally for the cell renderer, or changed just before rendering each cell in the model (for **Gnome::Gtk3::TreeView**, you set up a per-row setting using **Gnome::Gtk3::TreeViewColumn** to associate model columns with cell renderer properties).

    method gtk_cell_renderer_toggle_set_radio ( Bool $radio )

  * Bool $radio; `True` to make the toggle look like a radio button

[[gtk_] cell_renderer_toggle_] get_active
-----------------------------------------

Returns `1` if the cell renderer is active. See `gtk_cell_renderer_toggle_set_active()`.

    method gtk_cell_renderer_toggle_get_active ( --> Int  )

[[gtk_] cell_renderer_toggle_] set_active
-----------------------------------------

Activates or deactivates a cell renderer.

    method gtk_cell_renderer_toggle_set_active ( Bool $setting )

  * Bool $setting; the value to set.

[[gtk_] cell_renderer_toggle_] get_activatable
----------------------------------------------

Returns `1` if the cell renderer is activatable. See `gtk_cell_renderer_toggle_set_activatable()`.

Since: 2.18

    method gtk_cell_renderer_toggle_get_activatable ( --> Int  )

[[gtk_] cell_renderer_toggle_] set_activatable
----------------------------------------------

Makes the cell renderer activatable.

Since: 2.18

    method gtk_cell_renderer_toggle_set_activatable ( Bool $setting )

  * Bool $setting; the value to set.

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

The *toggled* signal is emitted when the cell is toggled.

It is the responsibility of the application to update the model with the correct value to store at *path*. Often this is simply the opposite of the value currently stored at *path*.

    method handler (
      Str $path,
      Gnome::GObject::Object :widget($cell_renderer),
      *%user-options
    );

  * $cell_renderer; the object which received the signal

  * $path; string representation of **Gnome::Gtk3::TreePath** describing the event location

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Toggle state

The toggle state of the button Default value: False

The **Gnome::GObject::Value** type of property *active* is `G_TYPE_BOOLEAN`.

### Inconsistent state

The inconsistent state of the button Default value: False

The **Gnome::GObject::Value** type of property *inconsistent* is `G_TYPE_BOOLEAN`.

### Activatable

The toggle button can be activated Default value: True

The **Gnome::GObject::Value** type of property *activatable* is `G_TYPE_BOOLEAN`.

### Radio state

Draw the toggle button as a radio button Default value: False

The **Gnome::GObject::Value** type of property *radio* is `G_TYPE_BOOLEAN`.

### Indicator size

The **Gnome::GObject::Value** type of property *indicator-size* is `G_TYPE_INT`.

