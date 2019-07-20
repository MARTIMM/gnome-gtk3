TITLE
=====

Gnome::Gtk3::ComboBoxText

SUBTITLE
========



    unit class Gnome::Gtk3::ComboBoxText;
    also is Gnome::Gtk3::ComboBox;

ComboBoxText — A simple, text-only combo box
--------------------------------------------

Synopsis
========

    # Get a fully designed text combobox
    my Gnome::Gtk3::ComboBoxText $server-cb .= new(:build-id<serverComboBox>);
    my Str $server = $server-cb.get-active-id;

Methods
=======

gtk_combo_box_text_append
-------------------------

    method gtk_combo_box_text_append ( Str $id, Str $text )

Appends text. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-append).

gtk_combo_box_text_prepend
--------------------------

    method gtk_combo_box_text_prepend ( Str $id, Str $text )

Prepends text. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-prepend).

This is the same as calling gtk_combo_box_text_insert() with a position of 0.

gtk_combo_box_text_insert
-------------------------

    method gtk_combo_box_text_insert ( Int $position, Str $id, Str $text )

Insert text at position. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-insert).

[gtk_combo_box_text_] append_text
---------------------------------

    method gtk_combo_box_text_append_text ( Str $text )

Append text. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-append-text).

[gtk_combo_box_text_] prepend_text
----------------------------------

    method gtk_combo_box_text_prepend_text ( Str $text )

Prepend text. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-prepend-text).

[gtk_combo_box_text_] insert_text
---------------------------------

    method gtk_combo_box_text_insert_text ( int32 $position, Str $text )

Insert text at position. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-insert-text).

gtk_combo_box_text_remove
-------------------------

    method gtk_combo_box_text_remove ( Int $position )

Remove text at position. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-remove).

[gtk_combo_box_text_] remove_all
--------------------------------

    method gtk_combo_box_text_remove_all ( )

Remove all text entries. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-remove-all).

gtk_combo_box_text_get_active_text
----------------------------------

    method gtk_combo_box_text_get_active_text ( )

Get selected entry. See also [gnome developer docs](https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-get-active-text).

new
---

    multi method new ( :$widget! )

Create a simple text combobox using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a simple text combobox using a native object from a builder. See also Gnome::GObject::Object.

