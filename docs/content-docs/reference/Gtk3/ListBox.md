Gnome::Gtk3::ListBox
====================

A list container

![](images/list-box.png)

Description
===========

A **Gnome::Gtk3::ListBox** is a vertical container that contains **Gnome::Gtk3::ListBoxRow** children. These rows can be dynamically sorted and filtered, and headers can be added dynamically depending on the row content. It also allows keyboard and mouse navigation and selection like a typical list.

Using **Gnome::Gtk3::ListBox** is often an alternative to **Gnome::Gtk3::TreeView**, especially when the list contents has a more complicated layout than what is allowed by a **Gnome::Gtk3::CellRenderer**, or when the contents is interactive (i.e. has a button in it).

Although a **Gnome::Gtk3::ListBox** must have only **Gnome::Gtk3::ListBoxRow** children you can add any kind of widget to it via `gtk_container_add()`, and a **Gnome::Gtk3::ListBoxRow** widget will automatically be inserted between the list and the widget.

**Gnome::Gtk3::ListBoxRows** can be marked as activatable or selectable. If a row is activatable, sig `row-activated` will be emitted for it when the user tries to activate it. If it is selectable, the row will be marked as selected when the user tries to select it.

The **Gnome::Gtk3::ListBox** widget was added in GTK+ 3.10.

Css Nodes
---------

**Gnome::Gtk3::ListBox** uses a single CSS node with name list. **Gnome::Gtk3::ListBoxRow** uses a single CSS node with name row. The row nodes get the .activatable style class added when appropriate.

See Also
--------

**Gnome::Gtk3::ScrolledWindow**

Implemented Interfaces
----------------------

Gnome::Gtk3::ListBox implements

  * Gnome::Atk::ImplementorIface

  * [Gnome::Gtk3::Buildable](Buildable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ListBox;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Buildable;

Example
-------

Create a ListBox with one row. This row is a grid holding a CheckBox and Label.

    my Gnome::Gtk3::ListBox $lb .= new;

    # The widgets
    my Gnome::Gtk3::CheckButton $check .= new(:label('bold'));
    my Gnome::Gtk3::Label $label .= new(:text('Turn on bold font'));

    # Add the widgets to the Grid
    my Gnome::Gtk3::Grid $grid .= new;
    $grid.gtk-grid-attach( $check, 0, 0, 1, 1);
    $grid.gtk-grid-attach( $label, 1, 0, 1, 1);

    # Add the Grid to the ListBox
    $lb.gtk-container-add($grid);

To check its values one can register signals on each important widget (e.g. $check in this case) or read the listbox entries.

    my Int $index = 0;
    while my $nw = $lb.get-row-at-index($index) {
      my Gnome::Gtk3::ListBoxRow $row .= new(:widget($nw));
      my Gnome::Gtk3::Grid $grid .= new(:widget($row.get-child));
      my Gnome::Gtk3::CheckButton $check .=
         new(:widget($grid.get-child-at( 0, 0)));
      if $check.get-active {
        ...
      }
    }

Every check in this list looks the same, so it is useful to set a name on each of the check widgets. This name can then be retrieved within the handler or the code example above. If it is simple, like above, on can use the label text instead.

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] list_box_prepend
-----------------------

Prepend a widget to the list. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of `gtk_container_add()`.

Since: 3.10

    method gtk_list_box_prepend ( N-GObject $child )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to add

[gtk_] list_box_insert
----------------------

Insert the *child* into the *box* at *position*. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of `gtk_container_add()`.

If *position* is -1, or larger than the total number of items in the *box*, then the *child* will be appended to the end.

Since: 3.10

    method gtk_list_box_insert ( N-GObject $child, Int $position )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to add

  * Int $position; the position to insert *child* in

[[gtk_] list_box_] get_selected_row
-----------------------------------

Gets the selected row.

Note that the box may allow multiple selection, in which case you should use `gtk_list_box_selected_foreach()` to find all selected rows.

Returns: (transfer none): the selected row as a native ListBoxRow

Since: 3.10

    method gtk_list_box_get_selected_row ( --> N-GObject  )

[[gtk_] list_box_] get_row_at_index
-----------------------------------

Gets the n-th child in the list (not counting headers). If *_index* is negative or larger than the number of items in the list, `Any` is returned.

Returns: a native ListBoxRow

Since: 3.10

    method gtk_list_box_get_row_at_index ( Int $index --> N-GObject  )

  * Int $index; the index of the row

[[gtk_] list_box_] get_row_at_y
-------------------------------

Gets the row at the *y* position.

Returns: the row or `Any` in case no row exists for the given y coordinate.

Since: 3.10

    method gtk_list_box_get_row_at_y ( Int $y --> N-GObject  )

  * Int $y; position

[[gtk_] list_box_] select_row
-----------------------------

Make *row* the currently selected row.

Since: 3.10

    method gtk_list_box_select_row ( GtkListBoxRow $row )

  * GtkListBoxRow $row; (allow-none): The row to select or `Any`

[[gtk_] list_box_] set_placeholder
----------------------------------

Sets the placeholder widget that is shown in the list when it doesn't display any visible children.

Since: 3.10

    method gtk_list_box_set_placeholder ( N-GObject $placeholder )

  * N-GObject $placeholder; (allow-none): a **Gnome::Gtk3::Widget** or `Any`

[[gtk_] list_box_] set_adjustment
---------------------------------

Sets the adjustment (if any) that the widget uses to for vertical scrolling. For instance, this is used to get the page size for PageUp/Down key handling.

In the normal case when the *box* is packed inside a **Gnome::Gtk3::ScrolledWindow** the adjustment from that will be picked up automatically, so there is no need to manually do that.

Since: 3.10

    method gtk_list_box_set_adjustment ( N-GObject $adjustment )

  * N-GObject $adjustment; (allow-none): the adjustment, or `Any`

[[gtk_] list_box_] get_adjustment
---------------------------------

Gets the adjustment (if any) that the widget uses to for vertical scrolling.

Returns: (transfer none): the adjustment

Since: 3.10

    method gtk_list_box_get_adjustment ( --> N-GObject  )

[[gtk_] list_box_] selected_foreach
-----------------------------------

Calls a function for each selected child. Note that the selection cannot be modified from within this function.

Since: 3.14

    method gtk_list_box_selected_foreach (
      $callback-object, Str $callback_name, *%user-options
    )

  * $callback-object; Object wherein the callback method is declared

  * Str $callback-name; Name of the callback method

  * %user-options; named arguments which will be provided to the callback

The callback method signature is

    method f (
      Gnome::Gtk3::ListBox $listbox, Gnome::Gtk3::GtkListRow $row,
      *%user-options
    )

[[gtk_] list_box_] get_selected_rows
------------------------------------

Creates a list of all selected children.

Returns: (element-type **Gnome::Gtk3::ListBoxRow**) (transfer container): A **GList** containing the **Gnome::Gtk3::Widget** for each selected child. Free with `g_list_free()` when done.

Since: 3.14

    method gtk_list_box_get_selected_rows ( --> N-GList  )

[[gtk_] list_box_] unselect_row
-------------------------------

Unselects a single row of *box*, if the selection mode allows it.

Since: 3.14

    method gtk_list_box_unselect_row ( GtkListBoxRow $row )

  * GtkListBoxRow $row; the row to unselected

[[gtk_] list_box_] select_all
-----------------------------

Select all children of *box*, if the selection mode allows it.

Since: 3.14

    method gtk_list_box_select_all ( )

[[gtk_] list_box_] unselect_all
-------------------------------

Unselect all children of *box*, if the selection mode allows it.

Since: 3.14

    method gtk_list_box_unselect_all ( )

[[gtk_] list_box_] set_selection_mode
-------------------------------------

Sets how selection works in the listbox. See **Gnome::Gtk3::SelectionMode** for details.

Since: 3.10

    method gtk_list_box_set_selection_mode ( GtkSelectionMode $mode )

  * GtkSelectionMode $mode; The **Gnome::Gtk3::SelectionMode**

[[gtk_] list_box_] get_selection_mode
-------------------------------------

Gets the selection mode of the listbox.

Returns: a **Gnome::Gtk3::SelectionMode**

Since: 3.10

    method gtk_list_box_get_selection_mode ( --> GtkSelectionMode  )

[[gtk_] list_box_] invalidate_filter
------------------------------------

Update the filtering for all rows. Call this when result of the filter function on the *box* is changed due to an external factor. For instance, this would be used if the filter function just looked for a specific search string and the entry with the search string has changed.

Since: 3.10

    method gtk_list_box_invalidate_filter ( )

[[gtk_] list_box_] invalidate_sort
----------------------------------

Update the sorting for all rows. Call this when result of the sort function on the *box* is changed due to an external factor.

Since: 3.10

    method gtk_list_box_invalidate_sort ( )

[[gtk_] list_box_] invalidate_headers
-------------------------------------

Update the separators for all rows. Call this when result of the header function on the *box* is changed due to an external factor.

Since: 3.10

    method gtk_list_box_invalidate_headers ( )

[[gtk_] list_box_] set_activate_on_single_click
-----------------------------------------------

If *single* is `1`, rows will be activated when you click on them, otherwise you need to double-click.

Since: 3.10

    method gtk_list_box_set_activate_on_single_click ( Int $single )

  * Int $single; a boolean

[[gtk_] list_box_] get_activate_on_single_click
-----------------------------------------------

Returns whether rows activate on single clicks.

Returns: `1` if rows are activated on single click, `0` otherwise

Since: 3.10

    method gtk_list_box_get_activate_on_single_click ( --> Int  )

[[gtk_] list_box_] drag_unhighlight_row
---------------------------------------

If a row has previously been highlighted via `gtk_list_box_drag_highlight_row()` it will have the highlight removed.

Since: 3.10

    method gtk_list_box_drag_unhighlight_row ( )

[[gtk_] list_box_] drag_highlight_row
-------------------------------------

This is a helper function for implementing DnD onto a **Gnome::Gtk3::ListBox**. The passed in *row* will be highlighted via `gtk_drag_highlight()`, and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets a drag leave event.

Since: 3.10

    method gtk_list_box_drag_highlight_row ( GtkListBoxRow $row )

  * GtkListBoxRow $row; a **Gnome::Gtk3::ListBoxRow**

[gtk_] list_box_new
-------------------

Creates a new **Gnome::Gtk3::ListBox** container.

Returns: a new **Gnome::Gtk3::ListBox**

Since: 3.10

    method gtk_list_box_new ( --> N-GObject  )

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

### row-selected

The *row-selected* signal is emitted when a new row is selected, or (with a `Any` *row*) when the selection is cleared.

When the *box* is using **GTK_SELECTION_MULTIPLE**, this signal will not give you the full picture of selection changes, and you should use the *selected-rows-changed* signal instead.

Since: 3.10

    method handler (
      N-GObject $row,
      Gnome::GObject::Object :widget($box),
      *%user-options
    );

  * $box; the **Gnome::Gtk3::ListBox** on which the signal is emitted

  * $row; the selected row, a native ListBoxRow

### selected-rows-changed

The *selected-rows-changed* signal is emitted when the set of selected rows changes.

Since: 3.14

    method handler (
      Gnome::GObject::Object :widget($box),
      *%user-options
    );

  * $box; the **Gnome::Gtk3::ListBox** on wich the signal is emitted

### select-all

The *select-all* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to select all children of the box, if the selection mode permits it.

The default bindings for this signal is Ctrl-a.

Since: 3.14

    method handler (
      Gnome::GObject::Object :widget($box),
      *%user-options
    );

  * $box; the **Gnome::Gtk3::ListBox** on which the signal is emitted

### unselect-all

The *unselect-all* signal is a keybinding signal which gets emitted to unselect all children of the box, if the selection mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

Since: 3.14

    method handler (
      Gnome::GObject::Object :widget($box),
      *%user-options
    );

  * $box; the **Gnome::Gtk3::ListBox** on which the signal is emitted

### row-activated

The *row-activated* signal is emitted when a row has been activated by the user.

Since: 3.10

    method handler (
      N-GObject $row,
      Gnome::GObject::Object :widget($box),
      *%user-options
    );

  * $box; the **Gnome::Gtk3::ListBox** on which the signal is emitted

  * $row; the activated row, a native ListBoxRow

### activate-cursor-row

    method handler (
      Gnome::GObject::Object :widget($listbox),
      *%user-options
    );

  * $listbox; the **Gnome::Gtk3::ListBox** on which the signal is emitted

### toggle-cursor-row

    method handler (
      Gnome::GObject::Object :widget($listbox),
      *%user-options
    );

  * $listbox; object receiving the signal

### move-cursor

    method handler (
      GtkMovementStep $arg1,
      Int $arg2,
      Gnome::GObject::Object :widget($listbox),
      *%user-options
    );

  * $listbox; the **Gnome::Gtk3::ListBox** on which the signal is emitted

  * $arg1; a GtkMovementStep

  * $arg2; ?

### activate

    method handler (
      Gnome::GObject::Object :widget($listbox),
      *%user-options
    );

  * $listbox;

