Gnome::Gtk3::ListStore
======================

A list-like data structure that can be used with the **Gnome::Gtk3::TreeView**

Description
===========

The **Gnome::Gtk3::ListStore** object is a list model for use with a **Gnome::Gtk3::TreeView** widget. It implements the **Gnome::Gtk3::TreeModel** interface, and consequentialy, can use all of the methods available there. It also implements the **Gnome::Gtk3::TreeSortable** interface so it can be sorted by the view. Finally, it also implements the tree [drag and drop](https://developer.gnome.org/gtk3/3.24/gtk3-GtkTreeView-drag-and-drop.html) interfaces.

The **Gnome::Gtk3::ListStore** can accept most GObject types as a column type, though it can’t accept all custom types. Internally, it will keep a copy of data passed in (such as a string or a boxed pointer). Columns that accept **GObjects** are handled a little differently. The **Gnome::Gtk3::ListStore** will keep a reference to the object instead of copying the value. As a result, if the object is modified, it is up to the application writer to call `gtk_tree_model_row_changed()` to emit the *row_changed* signal. This most commonly affects lists with **Gnome::Gdk3::Pixbufs** stored.

An example for creating a simple list store:

    enum ColumnNames { < COLUMN_STRING COLUMN_INT COLUMN_BOOLEAN > };

    my Gnome::Gtk3::TreePath $path;
    my Gnome::Gtk3::TreeIter $iter;
    my Gnome::Gtk3::ListStore $list-store .= new(
      :field-types( G_TYPE_STRING, G_TYPE_INT, G_TYPE_BOOLEAN)
    );

    # Create 10 entries in the ListStore
    for ^10 -> $i {

      # Get data from somewhere
      my Str $some-data = get-some-data($i);

      # Add a new row to the model
      $iter = $list-store.gtk-list-store-append;
      $list-store.gtk-list-store-set(
        $iter, COLUMN_STRING,   some_data,
               COLUMN_INT,      i,
               COLUMN_BOOLEAN,  0
      );
    }

    # Modify a particular row, here it is the boolean value on the 5th row.
    $path .= new(:string("4"));
    $iter = $list-store.get-iter($path);
    $path.clear-tree-path;
    $list-store.gtk-list-store-set( $iter, COLUMN_BOOLEAN, 1);

Atomic Operations
-----------------

It is important to note that only the methods `gtk_list_store_insert_with_values()` and `gtk_list_store_insert_with_valuesv()` are atomic, in the sense that the row is being appended to the store and the values filled in in a single operation with regard to **Gnome::Gtk3::TreeModel** signaling. In contrast, using e.g. `gtk_list_store_append()` and then `gtk_list_store_set()` will first create a row, which triggers the *row-inserted* signal on **Gnome::Gtk3::ListStore**. The row, however, is still empty, and any signal handler connecting to *row-inserted* on this particular store should be prepared for the situation that the row might be empty. This is especially important if you are wrapping the **Gnome::Gtk3::ListStore** inside a **Gnome::Gtk3::TreeModelFilter** and are using a **Gnome::Gtk3::TreeModelFilterVisibleFunc**. Using any of the non-atomic operations to append rows to the **Gnome::Gtk3::ListStore** will cause the **Gnome::Gtk3::TreeModelFilterVisibleFunc** to be visited with an empty row first; the function must be prepared for that.

**Gnome::Gtk3::ListStore** as **Gnome::Gtk3::Buildable**
--------------------------------------------------------

The **Gnome::Gtk3::ListStore** implementation of the **Gnome::Gtk3::Buildable** interface allows to specify the model columns with a <columns> element that may contain multiple <column> elements, each specifying one model column. The “type” attribute specifies the data type for the column.

Additionally, it is possible to specify content for the list store in the UI definition, with the <data> element. It can contain multiple <row> elements, each specifying to content for one row of the list model. Inside a <row>, the <col> elements specify the content for individual cells.

Note that it is probably more common to define your models in the code, and one might consider it a layering violation to specify the content of a list store in a UI definition, data, not presentation, and common wisdom is to separate the two, as far as possible.

An example of a UI Definition fragment for a list store: |[<!-- language="C" --> <object class="**Gnome::Gtk3::ListStore**"> <columns> <column type="gchararray"/> <column type="gchararray"/> <column type="gint"/> </columns> <data> <row> <col id="0">John</col> <col id="1">Doe</col> <col id="2">25</col> </row> <row> <col id="0">Johan</col> <col id="1">Dahlin</col> <col id="2">50</col> </row> </data> </object> ]|

Implemented Interfaces
----------------------

Gnome::Gtk3::ListStore implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * [Gnome::Gtk3::TreeModel](TreeModel.html)

  * Gnome::Gtk3::TreeDragSource

  * Gnome::Gtk3::TreeDragDest

  * Gnome::Gtk3::TreeSortable

See Also
--------

**Gnome::Gtk3::TreeModel**, **Gnome::Gtk3::TreeStore**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ListStore;
    also is Gnome::GObject::Object;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::TreeModel;
    also does Gnome::Gtk3::TreeDragSource;
    also does Gnome::Gtk3::TreeDragDest;
    also does Gnome::Gtk3::TreeSortable;

Methods
=======

new
---

Create a new ListStore object with the given field types.

    multi method new ( Bool :@field-types! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_list_store_new
------------------

Creates a new list store with columns each of the types passed in. Note that only types derived from standard GObject fundamental types are supported.

As an example, `$l.gtk_list_store_new( 3, G_TYPE_INT, G_TYPE_STRING, G_TYPE_STRING);` will create a new **Gnome::Gtk3::ListStore** with three columns, of type int, and two of type string respectively.

Returns: a new **Gnome::Gtk3::ListStore**

    method gtk_list_store_new ( *@column-types --> N-GObject )

  * @column-types: all **GType** types for the columns, from first to last

[gtk_list_store_] set_column_types
----------------------------------

This function is meant primarily for **GObjects** that inherit from **Gnome::Gtk3::ListStore**, and should only be used when constructing a new **Gnome::Gtk3::ListStore**. It will not function after a row has been added, or a method on the **Gnome::Gtk3::TreeModel** interface is called.

    method gtk_list_store_set_column_types ( Int $n_columns, int32 $types )

  * Int $n_columns; Number of columns for the list store

  * int32 $types; (array length=n_columns): An array length n of **GTypes**

set-value
---------

Sets the data in the cell specified by *iter* and *column*. The type of *value* must be convertible to the type of the column.

    method gtk_list_store_set_value (
      Gnome::Gtk3::TreeIter $iter, Int $column, Any $value
    )

  * Gnome::Gtk3::TreeIter $iter; A valid **Gnome::Gtk3::TreeIter** for the row being modified

  * Int $column; column number to modify

  * Any $value; new value for the cell

gtk-list-store-set
------------------

Sets the value of one or more cells in the row referenced by the iterator. The variable argument list should contain integer column numbers, each column number followed by the value to be set. For example, to set column 0 with type `G_TYPE_STRING` to “Foo”, you would write `gtk_list_store_set( iter, 0, "Foo")`.

The value will be referenced by the store if it is a `G_TYPE_OBJECT`, and it will be copied if it is a `G_TYPE_STRING` or `G_TYPE_BOXED`.

    method gtk-list-store-set ( Gnome::Gtk3::TreeIter $iter, $col, $val, ... )

  * $iter; row iterator

  * $col, $val; pairs of column number and value

gtk_list_store_remove
---------------------

Removes the given row from the list store. After being removed, the returned iterator is set to be the next valid row, or invalidated if it pointed to the last row in the list_store.

    method gtk_list_store_remove (
      Gnome::Gtk3::TreeIter $iter
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $iter; The iterator pointing to the row which must be removed

gtk_list_store_insert
---------------------

Creates a new row at *$position*. The returned iterator will be changed to point to this new row. If *$position* is -1 or is larger than the number of rows on the list, then the new row will be appended to the list. The row will be empty after this function is called. To fill in values, you need to call `gtk_list_store_set()` or `gtk_list_store_set_value()`.

    method gtk_list_store_insert ( Int $position --> Gnome::Gtk3::TreeIter )

  * N-GtkTreeIter $iter; (out): An unset **Gnome::Gtk3::TreeIter** to set to the new row

  * Int $position; position to insert the new row, or -1 for last

[gtk_list_store_] insert_before
-------------------------------

Inserts a new row before *$sibling*. If *$sibling* is `Any`, then the row will be appended to the end of the list. The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_list_store_set()` or `gtk_list_store_set_value()`.

    method gtk_list_store_insert_before (
      Gnome::Gtk3::TreeIter $sibling
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $sibling; A valid **Gnome::Gtk3::TreeIter** or `Any`

[gtk_list_store_] insert_after
------------------------------

Inserts a new row after *$sibling*. If *$sibling* is `Any`, then the row will be prepended to the beginning of the list. The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_list_store_set()` or `gtk_list_store_set_value()`.

    method gtk_list_store_insert_after (
      Gnome::Gtk3::TreeIter $sibling
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $sibling; A valid **Gnome::Gtk3::TreeIter**, or `Any`

insert-with-values
------------------

Creates a new row at *position*. *iter* will be changed to point to this new row. If *position* is -1, or larger than the number of rows in the list, then the new row will be appended to the list. The row will be filled with the values given to this function.

Calling `$list-store.insert-with-values( position, ...)` has the same effect as calling;

    $iter = $list-store.gtk-list-store-insert($position);
    $list-store.gtk-list-store-set( $iter, ...);

with the difference that the former will only emit a *row-inserted* signal, while the latter will emit *row-inserted*, *row-changed* and, if the list store is sorted, *rows-reordered*. Since emitting the *rows-reordered* signal repeatedly can affect the performance of the program, `gtk_list_store_insert_with_values()` should generally be preferred when inserting rows in a sorted list store.

Since: 2.6

    method insert-with-values (
      Int $position, Int $column, $value, ...
      --> Gnome::Gtk3::TreeIter
    )

  * Int $position; row position to insert the new row, or -1 to append after existing rows

  * ...; the rest are pairs of column number and value

gtk_list_store_prepend
----------------------

Prepends a new row to the list store. The returned iterator will be changed to point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_list_store_set()` or `gtk_list_store_set_value()`.

    method gtk_list_store_prepend ( --> Gnome::Gtk3::TreeIter )

gtk_list_store_append
---------------------

Appends a new row to the list_store. The returned iterator will be changed to point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_list_store_set()` or `gtk_list_store_set_value()`.

    method gtk_list_store_append ( --> Gnome::Gtk3::TreeIter )

Returns a **Gnome::Gtk3::TreeIter** pointing to the new row.

gtk_list_store_clear
--------------------

Removes all rows from the list store.

    method gtk_list_store_clear ( )

[gtk_list_store_] iter_is_valid
-------------------------------

> This function is slow. Only use it for debugging and/or testing > purposes.

Checks if the given iter is a valid iter for this **Gnome::Gtk3::ListStore**.

Returns: `1` if the iter is valid, `0` if the iter is invalid.

Since: 2.2

    method gtk_list_store_iter_is_valid ( N-GtkTreeIter $iter --> Int  )

  * N-GtkTreeIter $iter; A **Gnome::Gtk3::TreeIter**.

gtk_list_store_reorder
----------------------

Reorders *store* to follow the order indicated by *new_order*. Note that this function only works with unsorted stores.

Since: 2.2

    method gtk_list_store_reorder ( Int $new_order )

  * Int $new_order; (array zero-terminated=1): an array of integers mapping the new position of each child to its old position before the re-ordering, i.e. *new_order*`[newpos] = oldpos`. It must have exactly as many items as the list store’s length.

gtk_list_store_swap
-------------------

Swaps *a* and *b* in *store*. Note that this function only works with unsorted stores.

Since: 2.2

    method gtk_list_store_swap ( N-GtkTreeIter $a, N-GtkTreeIter $b )

  * N-GtkTreeIter $a; A **Gnome::Gtk3::TreeIter**.

  * N-GtkTreeIter $b; Another **Gnome::Gtk3::TreeIter**.

[gtk_list_store_] move_after
----------------------------

Moves *iter* in *store* to the position after *position*. Note that this function only works with unsorted stores. If *position* is `Any`, *iter* will be moved to the start of the list.

Since: 2.2

    method gtk_list_store_move_after ( N-GtkTreeIter $iter, N-GtkTreeIter $position )

  * N-GtkTreeIter $iter; A **Gnome::Gtk3::TreeIter**.

  * N-GtkTreeIter $position; (allow-none): A **Gnome::Gtk3::TreeIter** or `Any`.

[gtk_list_store_] move_before
-----------------------------

Moves *iter* in *store* to the position before *position*. Note that this function only works with unsorted stores. If *position* is `Any`, *iter* will be moved to the end of the list.

Since: 2.2

    method gtk_list_store_move_before ( N-GtkTreeIter $iter, N-GtkTreeIter $position )

  * N-GtkTreeIter $iter; A **Gnome::Gtk3::TreeIter**.

  * N-GtkTreeIter $position; (allow-none): A **Gnome::Gtk3::TreeIter**, or `Any`.

