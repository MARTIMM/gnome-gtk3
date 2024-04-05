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

**Gnome::Gtk3::ListBox** as **Gnome::Gtk3::Buildable**
------------------------------------------------------

The **Gnome::Gtk3::ListBox** implementation of the **Gnome::Gtk3::Buildable** interface supports setting a child as the placeholder by specifying “placeholder” as the “type” attribute of a <child> element. See `set-placeholder()` for info.

Css Nodes
---------

**Gnome::Gtk3::ListBox** uses a single CSS node with name list. **Gnome::Gtk3::ListBoxRow** uses a single CSS node with name row. The row nodes get the .activatable style class added when appropriate.

See Also
--------

**Gnome::Gtk3::ScrolledWindow**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ListBox;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Buildable;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::ListBox:api<1>;

    unit class MyGuiClass;
    also is Gnome::Gtk3::ListBox;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::ListBox class process the options
      self.bless( :GtkListBox, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

Create a ListBox with one row. This row is a grid holding a CheckBox and Label.

    my Gnome::Gtk3::ListBox $lb .= new;

    # The widgets
    my Gnome::Gtk3::CheckButton $check .= new(:label('bold'));
    my Gnome::Gtk3::Label $label .= new(:text('Turn on bold font'));

    # Add the widgets to the Grid
    my Gnome::Gtk3::Grid $grid .= new;
    $grid.attach( $check, 0, 0, 1, 1);
    $grid.attach( $label, 1, 0, 1, 1);

    # Add the Grid to the ListBox
    $lb.add($grid);

To check its values one can register signals on each important widget (e.g. `$check` in this case) or read the listbox entries.

    my Int $index = 0;
    while my $nw = $lb.get-row-at-index($index) {
      my Gnome::Gtk3::ListBoxRow() $row = $nw;
      my Gnome::Gtk3::Grid $grid() = $row.get-child;
      my Gnome::Gtk3::CheckButton() $check = $grid.get-child-at( 0, 0);
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

drag-highlight-row
------------------

This is a helper function for implementing DnD onto a **Gnome::Gtk3::ListBox**. The passed in *row* will be highlighted via `gtk_drag_highlight()`, and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets a drag leave event.

    method drag-highlight-row ( N-GObject() $row )

  * $row; a **Gnome::Gtk3::ListBoxRow**

drag-unhighlight-row
--------------------

If a row has previously been highlighted via `drag_highlight_row()` it will have the highlight removed.

    method drag-unhighlight-row ( )

get-activate-on-single-click
----------------------------

Returns whether rows activate on single clicks.

Returns: `True` if rows are activated on single click, `False` otherwise

    method get-activate-on-single-click ( --> Bool )

get-adjustment
--------------

Gets the adjustment (if any) that the widget uses to for vertical scrolling.

Returns: the adjustment

    method get-adjustment ( --> N-GObject )

get-row-at-index
----------------

Gets the n-th child in the list (not counting headers). If *_index* is negative or larger than the number of items in the list, `undefined` is returned.

Returns: the child **Gnome::Gtk3::Widget** or `undefined`

    method get-row-at-index ( Int() $index --> N-GObject )

  * $index; the index of the row

get-row-at-y
------------

Gets the row at the *y* position.

Returns: the row or `undefined` in case no row exists for the given y coordinate.

    method get-row-at-y ( Int() $y --> N-GObject )

  * $y; position

get-selected-row
----------------

Gets the selected row.

Note that the box may allow multiple selection, in which case you should use `selected_foreach()` to find all selected rows.

Returns: the selected row

    method get-selected-row ( --> N-GObject )

get-selected-rows
-----------------

Creates a list of all selected children.

Returns: A **Gnome::Gio::List** containing the **Gnome::Gtk3::Widget** for each selected child. Free with `clear-object()` when done.

    method get-selected-rows ( --> N-GList )

get-selection-mode
------------------

Gets the selection mode of the listbox.

Returns: a **Gnome::Gtk3::SelectionMode**

    method get-selection-mode ( --> GtkSelectionMode )

insert
------

Insert the *child* into the *box* at *position*. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of `gtk_container_add()`.

If *position* is -1, or larger than the total number of items in the *box*, then the *child* will be appended to the end.

    method insert ( N-GObject() $child, Int() $position )

  * $child; the **Gnome::Gtk3::Widget** to add

  * $position; the position to insert *child* in

invalidate-filter
-----------------

Update the filtering for all rows. Call this when result of the filter function on the *box* is changed due to an external factor. For instance, this would be used if the filter function just looked for a specific search string and the entry with the search string has changed.

    method invalidate-filter ( )

invalidate-headers
------------------

Update the separators for all rows. Call this when result of the header function on the *box* is changed due to an external factor.

    method invalidate-headers ( )

invalidate-sort
---------------

Update the sorting for all rows. Call this when result of the sort function on the *box* is changed due to an external factor.

    method invalidate-sort ( )

prepend
-------

Prepend a widget to the list. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of `gtk_container_add()`.

    method prepend ( N-GObject() $child )

  * $child; the **Gnome::Gtk3::Widget** to add

row-changed
-----------

Marks *row* as changed, causing any state that depends on this to be updated. This affects sorting, filtering and headers.

Note that calls to this method must be in sync with the data used for the row functions. For instance, if the list is mirroring some external data set, and *two* rows changed in the external data set then when you call `row_changed()` on the first row the sort function must only read the new data for the first of the two changed rows, otherwise the resorting of the rows will be wrong.

This generally means that if you don’t fully control the data model you have to duplicate the data that affects the listbox row functions into the row widgets themselves. Another alternative is to call `invalidate_sort()` on any model change, but that is more expensive.

    method row-changed ( N-GObject() $row )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-get-activatable
-------------------

Gets the value of the *activatable from Gnome::Gtk3::ListBoxRow* property for this row.

Returns: `True` if the row is activatable

    method row-get-activatable ( N-GObject() $row --> Bool )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-get-header
--------------

Returns the current header of the *row*. This can be used in a **Gnome::Gtk3::ListBoxUpdateHeaderFunc** to see if there is a header set already, and if so to update the state of it.

Returns: the current header, or `undefined` if none

    method row-get-header ( N-GObject() $row --> N-GObject )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-get-index
-------------

Gets the current index of the *row* in its **Gnome::Gtk3::ListBox** container.

Returns: the index of the *row*, or -1 if the *row* is not in a listbox

    method row-get-index ( N-GObject() $row --> Int )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-get-selectable
------------------

Gets the value of the *selectable from Gnome::Gtk3::ListBoxRow* property for this row.

Returns: `True` if the row is selectable

    method row-get-selectable ( N-GObject() $row --> Bool )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-is-selected
---------------

Returns whether the child is currently selected in its **Gnome::Gtk3::ListBox** container.

Returns: `True` if *row* is selected

    method row-is-selected ( N-GObject() $row --> Bool )

  * $row; a **Gnome::Gtk3::ListBoxRow**

row-new
-------

Creates a new **Gnome::Gtk3::ListBoxRow**, to be used as a child of a **Gnome::Gtk3::ListBox**.

Returns: a new **Gnome::Gtk3::ListBoxRow**

    method row-new ( --> N-GObject )

row-set-activatable
-------------------

Set the *activatable from Gnome::Gtk3::ListBoxRow* property for this row.

    method row-set-activatable ( N-GObject() $row, Bool $activatable )

  * $row; a **Gnome::Gtk3::ListBoxRow**

  * $activatable; `True` to mark the row as activatable

row-set-header
--------------

Sets the current header of the *row*. This is only allowed to be called from a **Gnome::Gtk3::ListBoxUpdateHeaderFunc**. It will replace any existing header in the row, and be shown in front of the row in the listbox.

    method row-set-header ( N-GObject() $row, N-GObject() $header )

  * $row; a **Gnome::Gtk3::ListBoxRow**

  * $header; the header, or `undefined`

row-set-selectable
------------------

Set the *selectable from Gnome::Gtk3::ListBoxRow* property for this row.

    method row-set-selectable ( N-GObject() $row, Bool $selectable )

  * $row; a **Gnome::Gtk3::ListBoxRow**

  * $selectable; `True` to mark the row as selectable

select-all
----------

Select all children of *box*, if the selection mode allows it.

    method select-all ( )

select-row
----------

Make *row* the currently selected row.

    method select-row ( N-GObject() $row )

  * $row; The row to select or `undefined`

selected-foreach
----------------

Calls a function for each selected child. Note that the selection cannot be modified from within this function.

    method selected-foreach (
      $callback-object, Str $callback_name, *%user-options
    )

  * $callback-object; Object wherein the callback method is declared

  * $callback-name; Name of the callback method

  * %user-options; named arguments which will be provided to the callback

The callback method signature is

    method f (
      N-GObject $listbox, N-GObject $row, *%user-options
    )

### Example

In the example below, the callback `cb` has the native objects provided as `N-GObject` coerced into **Gnome::Gtk3::ListBox** and **Gnome::Gtk3::ListBoxRow** using the `()`.

    class X {
      method cb (
        Gnome::Gtk3::ListBox() $lbx, Gnome::Gtk3::ListBoxRow() $lbxr, :$test ) {
        is $lbx.widget-get-name(), 'GtkListBox', 'listbox';
        is $lbxr.widget-get-name(), 'N-GObject', 'listboxrow';
        is $test, 'abc', 'user option';
      }
    }

    $lb.selected-foreach( X.new, 'cb', :test<abc>);

set-activate-on-single-click
----------------------------

If *single* is `True`, rows will be activated when you click on them, otherwise you need to double-click.

    method set-activate-on-single-click ( Bool $single )

  * $single; a boolean

set-adjustment
--------------

Sets the adjustment (if any) that the widget uses to for vertical scrolling. For instance, this is used to get the page size for PageUp/Down key handling.

In the normal case when the *box* is packed inside a **Gnome::Gtk3::ScrolledWindow** the adjustment from that will be picked up automatically, so there is no need to manually do that.

    method set-adjustment ( N-GObject() $adjustment )

  * $adjustment; the adjustment, or `undefined`

set-placeholder
---------------

Sets the placeholder widget that is shown in the list when it doesn't display any visible children.

    method set-placeholder ( N-GObject() $placeholder )

  * $placeholder; a **Gnome::Gtk3::Widget** or `undefined`

set-selection-mode
------------------

Sets how selection works in the listbox. See **Gnome::Gtk3::SelectionMode** for details.

    method set-selection-mode ( GtkSelectionMode $mode )

  * $mode; The **Gnome::Gtk3::SelectionMode**

unselect-all
------------

Unselect all children of *box*, if the selection mode allows it.

    method unselect-all ( )

unselect-row
------------

Unselects a single row of *box*, if the selection mode allows it.

    method unselect-row ( N-GObject() $row )

  * $row; the row to unselected

Signals
=======

activate
--------

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

activate-cursor-row
-------------------

This is a keybinding signal, which will cause this row to be activated.

If you want to be notified when the user activates a row (by key or not), use the *row-activated* signal on the row’s parent **Gnome::Gtk3::ListBox**.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

move-cursor
-----------

    method handler (
      GEnum $arg1,
      Int $arg2,
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $arg1; a GtkMovementStep enumeration

  * $arg2; ? (no information)

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

row-activated
-------------

The *row-activated* signal is emitted when a row has been activated by the user.

    method handler (
      N-GObject $row,
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $row; the activated row, a native **Gnome::Gtk3::ListBoxRow**

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

row-selected
------------

The *row-selected* signal is emitted when a new row is selected, or (with a `undefined` *row*) when the selection is cleared.

When the *box* is using **Gnome::Gio::TK_SELECTION_MULTIPLE**, this signal will not give you the full picture of selection changes, and you should use the *selected-rows-changed* signal instead.

    method handler (
      N-GObject $row,
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $row; the selected row , a native **Gnome::Gtk3::ListBoxRow**

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

select-all
----------

The *select-all* signal is a keybinding signal which gets emitted to select all children of the box, if the selection mode permits it.

The default bindings for this signal is Ctrl-a.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

selected-rows-changed
---------------------

The *selected-rows-changed* signal is emitted when the set of selected rows changes.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

toggle-cursor-row
-----------------

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

unselect-all
------------

The *unselect-all* signal is a [keybinding signal][GtkBindingSignal] which gets emitted to unselect all children of the box, if the selection mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

activatable
-----------

Whether this row can be activated

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

activate-on-single-click
------------------------

Activate row on a single click

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

selectable
----------

Whether this row can be selected

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

selection-mode
--------------

The selection mode

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * The type of this G_TYPE_ENUM object is GTK_TYPE_SELECTION_MODE

  * Parameter is readable and writable.

  * Default value is GTK_SELECTION_SINGLE.

