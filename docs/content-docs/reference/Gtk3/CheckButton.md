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

See Also
--------

**Gnome::Gtk3::CheckMenuItem**, **Gnome::Gtk3::Button**, **Gnome::Gtk3::ToggleButton**, **Gnome::Gtk3::RadioButton**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CheckButton;
    also is Gnome::Gtk3::ToggleButton;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::CheckButton;

    unit class MyGuiClass;
    also is Gnome::Gtk3::CheckButton;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::CheckButton class process the options
      self.bless( :GtkCheckButton, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

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

    multi method new ( Str :$label!, Bool :$mnemonic = False )

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

