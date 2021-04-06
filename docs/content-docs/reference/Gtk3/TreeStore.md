Gnome::Gtk3::TreeStore
======================

A tree-like data structure that can be used with the **Gnome::Gtk3::TreeView**

Description
===========

The **Gnome::Gtk3::TreeStore** object is a list model for use with a **Gnome::Gtk3::TreeView** widget. It implements the **Gnome::Gtk3::TreeModel** interface, and consequentially, can use all of the methods available there. It also implements the **Gnome::Gtk3::TreeSortable** interface so it can be sorted by the view. Finally, it also implements the tree drag and drop interfaces.

Gnome::Gtk3::TreeStore as Gnome::Gtk3::Buildable
------------------------------------------------

The **Gnome::Gtk3::TreeStore** implementation of the **Gnome::Gtk3::Buildable** interface allows to specify the model columns with a <columns> element that may contain multiple <column> elements, each specifying one model column. The “type” attribute specifies the data type for the column.

An example of a UI Definition fragment for a tree store:

    <object class="GtkTreeStore">
      <columns>
        <column type="gchararray"/>
        <column type="gchararray"/>
        <column type="gint"/>
      </columns>
    </object>

See Also
--------

**Gnome::Gtk3::TreeModel**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TreeStore;
    also is Gnome::GObject::Object;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::TreeModel;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::TreeStore;

    unit class MyGuiClass;
    also is Gnome::Gtk3::TreeStore;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::TreeStore class process the options
      self.bless( :GtkTreeStore, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

Creates a new tree store as with columns each of the types passed in. Note that only types derived from standard GObject fundamental types are supported.

As an example, `.new( :field-types( G_TYPE_INT, G_TYPE_STRING, $pixbuf.get-type());` will create a new **Gnome::Gtk3::TreeStore** with three columns, of type int, string and a pixbuf respectively. Note that there is no `GDK_TYPE_PIXBUF` type because it is not a fundamental type like `G_TYPE_INT`.

    multi method new ( Bool :@field-types! )

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[[gtk_] tree_store_] set_value
------------------------------

Sets the data in the cell specified by *$iter* and *$column*. The type of *$value* must be convertible to the type of the column.

    method gtk_tree_store_set_value (
      Gnome::Gtk3::TreeIter $iter, Int $column, Any $value
    )

  * Gnome::Gtk3::TreeIter $iter; A valid iterator for the row being modified

  * Int $column; column number to modify

  * Any $value; new value for the cell

[gtk_] tree_store_set
---------------------

Sets the value of one or more cells in the row referenced by *$iter*. The variable argument list should contain integer column numbers, each column number followed by the value to be set. For example, to set column 0 with type `G_TYPE_STRING` to “Foo”, you would write `$ts.gtk_tree_store_set( $iter, 0, "Foo")`.

The value will be referenced by the store if it is a `G_TYPE_OBJECT`, and it will be copied if it is a `G_TYPE_STRING` or `G_TYPE_BOXED`.

    method gtk_tree_store_set ( Gnome::Gtk3::TreeIter $iter, $col, $val, ... )

  * Gnome::Gtk3::TreeIter $iter; A valid row iterator for the row being modified

  * $col, $val; pairs of column number and value

[gtk_] tree_store_remove
------------------------

Removes the given row from the tree store. After being removed, the returned iterator is set to the next valid row at that level, or invalidated if it previously pointed to the last one.

    method gtk_tree_store_remove (
      Gnome::Gtk3::TreeIter $iter
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $iter; The iterator pointing to the row which must be removed

[gtk_] tree_store_insert
------------------------

Creates a new row at *$position*. If parent is non-`Any`, then the row will be made a child of *$parent*. Otherwise, the row will be created at the toplevel. If *$position* is -1 or is larger than the number of rows at that level, then the new row will be inserted to the end of the list. *$iter* will be changed to point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_tree_store_set()` or `gtk_tree_store_set_value()`.

    method gtk_tree_store_insert (
      Gnome::Gtk3::TreeIter $parent, Int $position
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator, or `Any`

  * Int $position; position to insert the new row, or -1 for last

[[gtk_] tree_store_] insert_before
----------------------------------

Inserts a new row before *$sibling*. If *$sibling* is `Any`, then the row will be appended to *$parent* ’s children. If *$parent* and *$sibling* are `Any`, then the row will be appended to the toplevel. If both *$sibling* and *$parent* are set, then *$parent* must be the parent of *$sibling*. When *$sibling* is set, *$parent* is optional.

The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_tree_store_set()` or `gtk_tree_store_set_value()`.

    method gtk_tree_store_insert_before (
      Gnome::Gtk3::TreeIter $parent, Gnome::Gtk3::TreeIter $sibling
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator or `Any`

  * Gnome::Gtk3::TreeIter $sibling; A valid iterator or `Any`

[[gtk_] tree_store_] insert_after
---------------------------------

Inserts a new row after *$sibling*. If *$sibling* is `+`, then the row will be prepended to *$parent* ’s children. If *$parent* and *$sibling* are `Any`, then the row will be prepended to the toplevel. If both *$sibling* and *$parent* are set, then *$parent* must be the parent of *$sibling*. When *$sibling* is set, *$parent* is optional.

The returned iterator will to point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_tree_store_set()` or `gtk_tree_store_set_value()`.

    method gtk_tree_store_insert_after (
      Gnome::Gtk3::TreeIter $parent, Gnome::Gtk3::TreeIter $sibling
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator or `Any`

  * Gnome::Gtk3::TreeIter $sibling; A valid iterator or `Any`

[[gtk_] tree_store_] insert_with_values
---------------------------------------

Creates a new row at *position*. *iter* will be changed to point to this new row. If *position* is -1, or larger than the number of rows on the list, then the new row will be appended to the list. The row will be filled with the values given to this function.

Calling `$ts.gtk_tree_store_insert_with_values(...)` has the same effect as calling;

    $iter = $ts.gtk_tree_store_insert( $parent-iter, $position);
    $ts.gtk_tree_store_set( $iter, ...);

with the difference that the former will only emit a *row-inserted* signal, while the latter will emit *row-inserted*, *row-changed* and if the tree store is sorted, *rows-reordered*. Since emitting the `rows-reordered` signal repeatedly can affect the performance of the program, `gtk_tree_store_insert_with_values()` should generally be preferred when inserting rows in a sorted tree store.

Since: 2.10

    method gtk_tree_store_insert_with_values (
      Gnome::Gtk3::TreeIter $parent, Int $position, Int $column, $value, ...
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator, or undefined.

  * Int $position; position to insert the new row, or -1 to append after existing rows

  * Int $column, $value, ...; the rest are pairs of column number and value

[gtk_] tree_store_prepend
-------------------------

Prepends a new row to the tree_store. If *$parent* is non-`Any`, then it will prepend the new row before the first child of *$parent*, otherwise it will prepend a row to the top level. The returned iterator will point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_tree_store_set()` or `gtk_tree_store_set_value()`.

    method gtk_tree_store_prepend (
      Gnome::Gtk3::TreeIter $parent
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator, or `Any`

[gtk_] tree_store_append
------------------------

Appends a new row to $list_store. If *parent* is non-`Any`, then it will append the new row after the last child of *parent*, otherwise it will append a row to the top level. *iter* will be changed to point to this new row. The row will be empty after this function is called. To fill in values, you need to call `gtk_tree_store_set()` or `gtk_tree_store_set_value()`.

    method gtk_tree_store_append (
      Gnome::Gtk3::TreeIter $parent
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; A valid iterator, or `Any`

[[gtk_] tree_store_] is_ancestor
--------------------------------

Returns `1` if *$iter* is an ancestor of *$descendant*. That is, *$iter* is the parent (or grandparent or great-grandparent) of *$descendant*.

    method gtk_tree_store_is_ancestor (
      Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $descendant
      --> Int
    )

  * Gnome::Gtk3::TreeIter $iter; A valid iterator

  * Gnome::Gtk3::TreeIter $descendant; A valid iterator

[[gtk_] tree_store_] iter_depth
-------------------------------

Returns the depth of *$iter*. This will be 0 for anything on the root level, 1 for anything down a level, etc.

    method gtk_tree_store_iter_depth ( Gnome::Gtk3::TreeIter $iter --> Int  )

  * Gnome::Gtk3::TreeIter $iter; A valid iterator

[gtk_] tree_store_clear
-----------------------

Removes all rows from $list_store

    method gtk_tree_store_clear ( )

[[gtk_] tree_store_] iter_is_valid
----------------------------------

WARNING: This function is slow. Only use it for debugging and/or testing purposes.

Checks if the given *$iter* is a valid iter for this tree store.

Returns: `1` if the *$iter* is valid, `0` if the iter is invalid.

Since: 2.2

    method gtk_tree_store_iter_is_valid ( Gnome::Gtk3::TreeIter $iter --> Int  )

  * Gnome::Gtk3::TreeIter $iter; A **Gnome::Gtk3::TreeIter**.

[gtk_] tree_store_reorder
-------------------------

Reorders the children of *parent* in $list_store to follow the order indicated by *new_order*. Note that this function only works with unsorted stores.

Since: 2.2

    method gtk_tree_store_reorder (
      Gnome::Gtk3::TreeIter $parent, Int $new_order
    )

  * Gnome::Gtk3::TreeIter $parent; (nullable): An iterator, or `Any`

  * Int $new_order; (array): an array of integers mapping the new position of each child to its old position before the re-ordering, i.e. *new_order*`[newpos] = oldpos`.

[gtk_] tree_store_swap
----------------------

Swaps *$a* and *$b* in the same level of $list_store. Note that this function only works with unsorted stores.

Since: 2.2

    method gtk_tree_store_swap (
      Gnome::Gtk3::TreeIter $a, Gnome::Gtk3::TreeIter $b
    )

  * Gnome::Gtk3::TreeIter $a; An iterator.

  * Gnome::Gtk3::TreeIter $b; Another iterator.

[[gtk_] tree_store_] move_before
--------------------------------

Moves *$iter* in $list_store to the position before *$position*. *$iter* and *$position* should be in the same level. Note that this function only works with unsorted stores. If *$position* is `Any`, *$iter* will be moved to the end of the level.

Since: 2.2

    method gtk_tree_store_move_before (
      Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $position
    )

  * Gnome::Gtk3::TreeIter $iter; An iterator.

  * Gnome::Gtk3::TreeIter $position; (allow-none): An iterator or `Any`.

[[gtk_] tree_store_] move_after
-------------------------------

Moves *$iter* in $list_store to the position after *$position*. *$iter* and *position* should be in the same level. Note that this function only works with unsorted stores. If *$position* is `Any`, *$iter* will be moved to the start of the level.

Since: 2.2

    method gtk_tree_store_move_after (
      Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $position
    )

  * Gnome::Gtk3::TreeIter $iter; A **Gnome::Gtk3::TreeIter**.

  * Gnome::Gtk3::TreeIter $position; (allow-none): A **Gnome::Gtk3::TreeIter**.

