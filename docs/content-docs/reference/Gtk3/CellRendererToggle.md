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

Uml Diagram
-----------

Methods
=======

new
---

### default, no options

Create a new CellRendererToggle object.

    multi method new ( )

### :native-object

Create a CellRendererToggle object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererToggle object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-activatable
---------------

Returns whether the cell renderer is activatable. See `set_activatable()`.

Returns: `True` if the cell renderer is activatable.

    method get-activatable ( --> Bool )

get-active
----------

Returns whether the cell renderer is active. See `set_active()`.

Returns: `True` if the cell renderer is active.

    method get-active ( --> Bool )

get-radio
---------

Returns whether we’re rendering radio toggles rather than checkboxes.

Returns: `True` if we’re rendering radio toggles.

    method get-radio ( --> Bool )

set-activatable
---------------

Makes the cell renderer activatable.

    method set-activatable ( Bool $setting )

  * $setting; the value to set.

set-active
----------

Activates or deactivates a cell renderer.

    method set-active ( Bool $setting )

  * $setting; the value to set.

set-radio
---------

If *radio* is `True`, the cell renderer renders a radio toggle (i.e. a toggle in a group of mutually-exclusive toggles). If `False`, it renders a check toggle (a standalone boolean option). This can be set globally for the cell renderer, or changed just before rendering each cell in the model (for **Gnome::Gtk3::TreeView**, you set up a per-row setting using **Gnome::Gtk3::TreeViewColumn** to associate model columns with cell renderer properties).

    method set-radio ( Bool $radio )

  * $radio; `True` to make the toggle look like a radio button

Signals
=======

toggled
-------

The *toggled* signal is emitted when the cell is toggled.

It is the responsibility of the application to update the model with the correct value to store at *path*. Often this is simply the opposite of the value currently stored at *path*.

    method handler (
      Str $path,
      Gnome::Gtk3::CellRendererToggle :_widget($cell_renderer),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path; string representation of **Gnome::Gtk3::TreePath** describing the event location

  * $cell_renderer; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

activatable
-----------

The toggle button can be activated

The **Gnome::GObject::Value** type of property *activatable* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is TRUE.

active
------

The toggle state of the button

The **Gnome::GObject::Value** type of property *active* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

inconsistent
------------

The inconsistent state of the button

The **Gnome::GObject::Value** type of property *inconsistent* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

radio
-----

Draw the toggle button as a radio button

The **Gnome::GObject::Value** type of property *radio* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

