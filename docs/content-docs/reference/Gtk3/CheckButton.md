TITLE
=====

Gnome::Gtk3::CheckButton

SUBTITLE
========



    unit class Gnome::Gtk3::CheckButton;
    also is Gnome::Gtk3::ToggleButton;

CheckButton — Create widgets with a discrete toggle button
----------------------------------------------------------

Synopsis
========

    my Gnome::Gtk3::CheckButton $bold-option .= new(:label<Bold>);

    # later ...
    if $bold-option.get-active {
      # Insert text in bold
    }

Methods
=======

gtk_check_button_new
--------------------

    method gtk_check_button_new ( --> N-GObject )

Creates a new native checkbutton object

[gtk_check_button_] new_with_label
----------------------------------

    method gtk_check_button_new_with_label ( Str $label --> N-GObject )

Creates a new native checkbutton object with a label

[gtk_check_button_] new_with_mnemonic
-------------------------------------

    method gtk_check_button_new_with_mnemonic ( Str $label --> N-GObject )

Creates a new check button containing a label. The label will be created using gtk_label_new_with_mnemonic(), so underscores in label indicate the mnemonic for the check button.

new
---

    multi method new ( Str :$label )

Create GtkCheckButton object with a label.

    multi method new ( Bool :$empty )

Create an empty GtkCheckButton.

    multi method new ( :$widget! )

Create a check button using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a check button using a native object from a builder. See also Gnome::GObject::Object.

