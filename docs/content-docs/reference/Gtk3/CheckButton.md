Gnome::Gtk3::CheckButton
========================

widgets with a discrete toggle button

![](images/check-button.png)

Description
===========

A **Gnome::Gtk3::CheckButton** places a discrete **Gnome::Gtk3::ToggleButton** next to a widget, (usually a **Gnome::Gtk3::Label**). See the section on **Gnome::Gtk3::ToggleButton** widgets for more information about toggle/check buttons.

The important signal ( sig `toggled` ) is also inherited from **Gnome::Gtk3::ToggleButton**.

Css Nodes
---------

    checkbutton
    ├── check
    ╰── <child>

A **Gnome::Gtk3::CheckButton** with indicator (see `gtk_toggle_button_set_mode()`) has a main CSS node with name checkbutton and a subnode with name check.

    button.check
    ├── check
    ╰── <child>

A **Gnome::Gtk3::CheckButton** without indicator changes the name of its main node to button and adds a .check style class to it. The subnode is invisible in this case.

Implemented Interfaces
----------------------

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * Gnome::Gtk3::Actionable

  * Gnome::Gtk3::Activatable

See Also
--------

**Gnome::Gtk3::CheckMenuItem**, **Gnome::Gtk3::Button**, **Gnome::Gtk3::ToggleButton**, **Gnome::Gtk3::RadioButton**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CheckButton;
    also is Gnome::Gtk3::ToggleButton;
    also does Gnome::Gtk3::Buildable;

Example
-------

    my Gnome::Gtk3::CheckButton $bold-option .= new(:label<Bold>);

    # later ... check state
    if $bold-option.get-active {
      # Insert text in bold
    }

Methods
=======

new
---

Create GtkCheckButton object with a label.

    multi method new ( Str :$label! )

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] check_button_new
-----------------------

Creates a new **Gnome::Gtk3::CheckButton**.

Returns: a **Gnome::Gtk3::Widget**.

    method gtk_check_button_new ( --> N-GObject  )

[[gtk_] check_button_] new_with_label
-------------------------------------

Creates a new **Gnome::Gtk3::CheckButton** with a **Gnome::Gtk3::Label** to the right of it.

Returns: a **Gnome::Gtk3::Widget**.

    method gtk_check_button_new_with_label ( Str $label --> N-GObject  )

  * Str $label; the text for the check button.

[[gtk_] check_button_] new_with_mnemonic
----------------------------------------

Creates a new **Gnome::Gtk3::CheckButton** containing a label. The label will be created using `gtk_label_new_with_mnemonic()`, so underscores in *label* indicate the mnemonic for the check button.

Returns: a new **Gnome::Gtk3::CheckButton**

    method gtk_check_button_new_with_mnemonic ( Str $label --> N-GObject  )

  * Str $label; The text of the button, with an underscore in front of the mnemonic character

