Gnome::Gtk3::ComboBoxText
=========================

A simple, text-only combo box

![](images/combo-box-text.png)

Description
===========

A `Gnome::Gtk3::ComboBoxText` is a simple variant of `Gnome::Gtk3::ComboBox` that hides the model-view complexity for simple text-only use cases.

To create a `Gnome::Gtk3::ComboBoxText`, use `gtk_combo_box_text_new()` or `gtk_combo_box_text_new_with_entry()`.

You can add items to a `Gnome::Gtk3::ComboBoxText` with `gtk_combo_box_text_append_text()`, `gtk_combo_box_text_insert_text()` or `gtk_combo_box_text_prepend_text()` and remove options with `gtk_combo_box_text_remove()`.

If the `Gnome::Gtk3::ComboBoxText` contains an entry (via the “has-entry” property), its contents can be retrieved using `gtk_combo_box_text_get_active_text()`. The entry itself can be accessed by calling `gtk_bin_get_child()` on the combo box.

You should not call `gtk_combo_box_set_model()` or attempt to pack more cells into this combo box via its `Gnome::Gtk3::CellLayout` interface.

Gnome::Gtk3::ComboBoxText as Gnome::Gtk3::Buildable
---------------------------------------------------

The `Gnome::Gtk3::ComboBoxText` implementation of the `Gnome::Gtk3::Buildable` interface supports adding items directly using the <items> element and specifying <item> elements for each item. Each <item> element can specify the “id” corresponding to the appended text and also supports the regular translation attributes “translatable”, “context” and “comments”.

Here is a UI definition fragment specifying `GtkComboBoxText` items:

    <object class="GtkComboBoxText">
      <items>
        <item translatable="yes" id="factory">Factory</item>
        <item translatable="yes" id="home">Home</item>
        <item translatable="yes" id="subway">Subway</item>
      </items>
    </object>

Css Nodes
---------

    combobox
    ╰── box.linked
        ├── entry.combo
        ├── button.combo
        ╰── window.popup

`Gnome::Gtk3::ComboBoxText` has a single CSS node with name combobox. It adds the style class .combo to the main CSS nodes of its entry and button children, and the .linked class to the node of its internal box.

Implemented Interfaces
----------------------

Gnome::Gtk3::ComboBoxText implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * Gnome::Gtk3::CellLayout

  * Gnome::Gtk3::CellEditable

See Also
--------

`Gnome::Gtk3::ComboBox`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ComboBoxText;
    also is Gnome::Gtk3::ComboBox;
    also does Gnome::Gtk3::Buildable;

Example
-------

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

gtk_combo_box_text_new
----------------------

Creates a new **Gnome::Gtk3::ComboBoxText**, which is a **Gnome::Gtk3::ComboBox** just displaying strings.

Returns: A new **Gnome::Gtk3::ComboBoxText**

Since: 2.24

    method gtk_combo_box_text_new ( --> N-GObject  )

[gtk_combo_box_text_] new_with_entry
------------------------------------

Creates a new **Gnome::Gtk3::ComboBoxText**, which is a **Gnome::Gtk3::ComboBox** just displaying strings. The combo box created by this function has an entry.

Returns: a new **Gnome::Gtk3::ComboBoxText**

Since: 2.24

    method gtk_combo_box_text_new_with_entry ( --> N-GObject  )

[gtk_combo_box_text_] append_text
---------------------------------

Appends *text* to the list of strings stored in *combo_box*.

This is the same as calling `gtk_combo_box_text_insert_text()` with a position of -1.

Since: 2.24

    method gtk_combo_box_text_append_text ( Str $text )

  * Str $text; A string

[gtk_combo_box_text_] insert_text
---------------------------------

Inserts *text* at *position* in the list of strings stored in *combo_box*.

If *position* is negative then *text* is appended.

This is the same as calling `gtk_combo_box_text_insert()` with a `Any` ID string.

Since: 2.24

    method gtk_combo_box_text_insert_text ( Int $position, Str $text )

  * Int $position; An index to insert *text*

  * Str $text; A string

[gtk_combo_box_text_] prepend_text
----------------------------------

Prepends *text* to the list of strings stored in *combo_box*.

This is the same as calling `gtk_combo_box_text_insert_text()` with a position of 0.

Since: 2.24

    method gtk_combo_box_text_prepend_text ( Str $text )

  * Str $text; A string

gtk_combo_box_text_remove
-------------------------

Removes the string at *position* from *combo_box*.

Since: 2.24

    method gtk_combo_box_text_remove ( Int $position )

  * Int $position; Index of the item to remove

[gtk_combo_box_text_] remove_all
--------------------------------

Removes all the text entries from the combo box.

Since: 3.0

    method gtk_combo_box_text_remove_all ( )

[gtk_combo_box_text_] get_active_text
-------------------------------------

Returns the currently active string in *combo_box*, or `Any` if none is selected. If *combo_box* contains an entry, this function will return its contents (which will not necessarily be an item from the list).

Returns: (transfer full): a newly allocated string containing the currently active text. Must be freed with `g_free()`.

Since: 2.24

    method gtk_combo_box_text_get_active_text ( --> Str  )

gtk_combo_box_text_insert
-------------------------

Inserts *text* at *position* in the list of strings stored in *combo_box*. If *id* is non-`Any` then it is used as the ID of the row. See *id-column*.

If *position* is negative then *text* is appended.

Since: 3.0

    method gtk_combo_box_text_insert ( Int $position, Str $id, Str $text )

  * Int $position; An index to insert *text*

  * Str $id; (allow-none): a string ID for this value, or `Any`

  * Str $text; A string to display

gtk_combo_box_text_append
-------------------------

Appends *text* to the list of strings stored in *combo_box*. If *id* is non-`Any` then it is used as the ID of the row.

This is the same as calling `gtk_combo_box_text_insert()` with a position of -1.

Since: 2.24

    method gtk_combo_box_text_append ( Str $id, Str $text )

  * Str $id; (allow-none): a string ID for this value, or `Any`

  * Str $text; A string

gtk_combo_box_text_prepend
--------------------------

Prepends *text* to the list of strings stored in *combo_box*. If *id* is non-`Any` then it is used as the ID of the row.

This is the same as calling `gtk_combo_box_text_insert()` with a position of 0.

Since: 2.24

    method gtk_combo_box_text_prepend ( Str $id, Str $text )

  * Str $id; (allow-none): a string ID for this value, or `Any`

  * Str $text; a string

