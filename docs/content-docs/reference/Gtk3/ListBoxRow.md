Gnome::Gtk3::ListBoxRow
=======================

Description
===========

A row in a Gnome::Gtk3::ListBox.

Implemented Interfaces
----------------------

Gnome::Gtk3::ListBoxRow implements

  * Gnome::Gtk3::Actionable

See Also
--------

`Gnome::Gtk3::ListBox`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ListBoxRow;
    also is Gnome::Gtk3::Bin;

Example
-------

    # Get the listbox from a Glade generated gui. Id is choosen
    # to be 'listboxFromGui'.
    my Gnome::Gtk3::ListBox $lb .= new(:build-id<listboxFromGui>);


    my Gnome::Glib::List $gl .= new(:native-object($lb.get-children));
    for ^$gl.g-list-length -> $entry-index {
      my Gnome::Gtk3::ListBoxRow $lb-row .=
        new(:widget($lb.get-row-at-index($entry-index)));

      next unless $lb-row.is-selected;

      # This row is selected and has a Grid (for example, can be anything
      # you've created!!)
      my Gnome::Gtk3::Grid $lb-grid .= new(:widget($lb-row.get_child()));
      ...
    }

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

[gtk_] list_box_row_new
-----------------------

Creates a new **Gnome::Gtk3::ListBoxRow**, to be used as a child of a **Gnome::Gtk3::ListBox**.

Returns: a new **Gnome::Gtk3::ListBoxRow**

Since: 3.10

    method gtk_list_box_row_new ( --> N-GObject  )

[[gtk_] list_box_row_] get_header
---------------------------------

Returns the current header of the *row*. This can be used in a **Gnome::Gtk3::ListBoxUpdateHeaderFunc** to see if there is a header set already, and if so to update the state of it.

Returns: (transfer none) (nullable): the current header, or `Any` if none

Since: 3.10

    method gtk_list_box_row_get_header ( --> N-GObject  )

[[gtk_] list_box_row_] set_header
---------------------------------

Sets the current header of the *row*. This is only allowed to be called from a **Gnome::Gtk3::ListBoxUpdateHeaderFunc**. It will replace any existing header in the row, and be shown in front of the row in the listbox.

Since: 3.10

    method gtk_list_box_row_set_header ( N-GObject $header )

  * N-GObject $header; (allow-none): the header, or `Any`

[[gtk_] list_box_row_] get_index
--------------------------------

Gets the current index of the *row* in its **Gnome::Gtk3::ListBox** container.

Returns: the index of the *row*, or -1 if the *row* is not in a listbox

Since: 3.10

    method gtk_list_box_row_get_index ( --> Int )

[[gtk_] list_box_row_] changed
------------------------------

Marks *row* as changed, causing any state that depends on this to be updated. This affects sorting, filtering and headers.

Note that calls to this method must be in sync with the data used for the row functions. For instance, if the list is mirroring some external data set, and *two* rows changed in the external data set then when you call `gtk_list_box_row_changed()` on the first row the sort function must only read the new data for the first of the two changed rows, otherwise the resorting of the rows will be wrong.

This generally means that if you don’t fully control the data model you have to duplicate the data that affects the listbox row functions into the row widgets themselves. Another alternative is to call `gtk_list_box_invalidate_sort()` on any model change, but that is more expensive.

Since: 3.10

    method gtk_list_box_row_changed ( )

[[gtk_] list_box_row_] is_selected
----------------------------------

Returns whether the child is currently selected in its **Gnome::Gtk3::ListBox** container.

Returns: `1` if *row* is selected

Since: 3.14

    method gtk_list_box_row_is_selected ( --> Int  )

[[gtk_] list_box_row_] set_selectable
-------------------------------------

Set the *selectable* property for this row.

Since: 3.14

    method gtk_list_box_row_set_selectable ( Int $selectable )

  * Int $selectable; `1` to mark the row as selectable

[[gtk_] list_box_row_] get_selectable
-------------------------------------

Gets the value of the *selectable* property for this row.

Returns: `1` if the row is selectable

Since: 3.14

    method gtk_list_box_row_get_selectable ( --> Int  )

[[gtk_] list_box_row_] set_activatable
--------------------------------------

Set the *activatable* property for this row.

Since: 3.14

    method gtk_list_box_row_set_activatable ( Int $activatable )

  * Int $activatable; `1` to mark the row as activatable

[[gtk_] list_box_row_] get_activatable
--------------------------------------

Gets the value of the *activatable* property for this row.

Returns: `1` if the row is activatable

Since: 3.14

    method gtk_list_box_row_get_activatable ( --> Int  )

