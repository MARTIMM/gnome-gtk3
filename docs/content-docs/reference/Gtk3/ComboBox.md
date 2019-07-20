TITLE
=====

Gnome::Gtk3::ComboBox

SUBTITLE
========



    unit class Gnome::Gtk3::ComboBox;
    also is Gnome::Gtk3::Bin;

ComboBox — A widget used to choose from a list of items
-------------------------------------------------------

Synopsis
========

    # Get a fully designed combobox
    my Gnome::Gtk3::ComboBox $server-cb .= new(:build-id<serverComboBox>);
    my Str $server = $server-cb.get-active-id;

Methods
=======

[gtk_combo_box_] get_active
---------------------------

    method gtk_combo_box_get_active ( --> int32 )

Returns the index of the currently active item, or -1 if there’s no active item. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-get-active).

[gtk_combo_box_] set_active
---------------------------

    method gtk_combo_box_set_active ( int32 $index )

Sets the active item of combo_box to be the item at index. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-set-active).

[gtk_combo_box_] get_active_id
------------------------------

    method gtk_combo_box_get_active_id ( --> Str )

Returns the ID of the active row of combo_box. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-get-active-id).

[gtk_combo_box_] set_active_id
------------------------------

    method gtk_combo_box_set_active_id ( Str $active_id )

Changes the active row of combo_box. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-set-active-id).

new
---

    multi method new ( :$widget! )

Create a combobox using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a combobox using a native object from a builder. See also Gnome::GObject::Object.

