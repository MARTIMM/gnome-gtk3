Gnome::Gtk3::TreeModel
======================

The tree interface used by **Gnome::Gtk3::TreeView**

Description
===========

The **Gnome::Gtk3::TreeModel** interface defines a generic tree interface for use by the **Gnome::Gtk3::TreeView** widget. It is an abstract interface, and is designed to be usable with any appropriate data structure.

The model is represented as a hierarchical tree of strongly-typed, columned data. In other words, the model can be seen as a tree where every node has different values depending on which column is being queried. The type of data found in a column is determined by using the GType system (ie. **G_TYPE_INT**, **GTK_TYPE_BUTTON**, **G_TYPE_POINTER**, etc). The types are homogeneous per column across all nodes. It is important to note that this interface only provides a way of examining a model and observing changes. The implementation of each individual model decides how and if changes are made.

In order to make life simpler for programmers who do not need to write their own specialized model, two generic models are provided — the **Gnome::Gtk3::TreeStore** and the **Gnome::Gtk3::ListStore**. To use these, the developer simply pushes data into these models as necessary. These models provide the data structure as well as all appropriate tree interfaces. As a result, implementing drag and drop, sorting, and storing data is trivial. For the vast majority of trees and lists, these two models are sufficient.

Models are accessed on a node/column level of granularity. One can query for the value of a model at a certain node and a certain column on that node. There are two structures used to reference a particular node in a model. They are the **Gnome::Gtk3::TreePath**-struct and the **Gnome::Gtk3::TreeIter**-struct (“iter” is short for iterator). Most of the interface consists of operations on a **Gnome::Gtk3::TreeIter**-struct.

A path is essentially a potential node. It is a location on a model that may or may not actually correspond to a node on a specific model. The **Gnome::Gtk3::TreePath**-struct can be converted into either an array of unsigned integers or a string. The string form is a list of numbers separated by a colon. Each number refers to the offset at that level. Thus, the path `0` refers to the root node and the path `2:4` refers to the fifth child of the third node.

By contrast, a **Gnome::Gtk3::TreeIter** is a reference to a specific node on a specific model. It is a generic struct with an integer and three generic pointers. These are filled in by the model in a model-specific way. One can convert a path to an iterator by calling `gtk_tree_model_get_iter()`. These iterators are the primary way of accessing a model and are similar to the iterators used by **Gnome::Gtk3::TextBuffer**. They are generally statically allocated on the stack and only used for a short time. The model interface defines a set of operations using them for navigating the model.

It is expected that models fill in the iterator with private data. For example, the **Gnome::Gtk3::ListStore** model, which is internally a simple linked list, stores a list node in one of the pointers. The **Gnome::Gtk3::TreeModelSort** stores an array and an offset in two of the pointers. Additionally, there is an integer field. This field is generally filled with a unique stamp per model. This stamp is for catching errors resulting from using invalid iterators with a model.

The lifecycle of an iterator can be a little confusing at first. Iterators are expected to always be valid for as long as the model is unchanged (and doesn’t emit a signal). The model is considered to own all outstanding iterators and nothing needs to be done to free them from the user’s point of view. Additionally, some models guarantee that an iterator is valid for as long as the node it refers to is valid (most notably the **Gnome::Gtk3::TreeStore** and **Gnome::Gtk3::ListStore**). Although generally uninteresting, as one always has to allow for the case where iterators do not persist beyond a signal, some very important performance enhancements were made in the sort model. As a result, the **GTK_TREE_MODEL_ITERS_PERSIST** flag was added to indicate this behavior.

To help show some common operation of a model, some examples are provided. The first example shows three ways of getting the iter at the location `3:2:5`. While the first method shown is easier, the second is much more common, as you often get paths from callbacks.

Acquiring a Gnome::Gtk3::TreeIter
---------------------------------

    # A ListStore with two columns, an integer and a string
    my Gnome::Gtk3::ListStore $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));

    # Filling a ListStore needs also an iterator. This on points to the end.
    my Gnome::Gtk3::TreeIter $iter = $ls.gtk-list-store-append;
    $ls.gtk-list-store-set( $iter, 0, 1001, 1, 'first entry');
    $iter = $ls.gtk-list-store-append;
    $ls.gtk-list-store-set( $iter, 0, 2002, 1, 'second entry');

    # Get the iterator from a string. A ListStore has simple paths.
    $iter = $ls.get_iter_from_string("1");

    # Get the iterator from a path
    my Gnome::Gtk3::TreePath $path .= new(:string('0'));
    $iter = $ls.get-iter($path);
    $path.clear-tree-path;

Known implementations
---------------------

Gnome::Gtk3::TreeModel is implemented by

  * [Gnome::Gtk3::ListStore](ListStore.html)

  * Gnome::Gtk3::TreeModelFilter

  * Gnome::Gtk3::TreeModelSort

  * Gnome::Gtk3::TreeStore.

See Also
--------

**Gnome::Gtk3::TreeView**, **Gnome::Gtk3::TreeStore**, **Gnome::Gtk3::ListStore**,

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::TreeModel;

Types
=====

enum GtkTreeModelFlags
----------------------

These flags indicate various properties of a **Gnome::Gtk3::TreeModel**.

They are returned by `gtk_tree_model_get_flags()`, and must be static for the lifetime of the object. A more complete description of **GTK_TREE_MODEL_ITERS_PERSIST** can be found in the overview of this section.

  * GTK_TREE_MODEL_ITERS_PERSIST: iterators survive all signals emitted by the tree

  * GTK_TREE_MODEL_LIST_ONLY: the model is a list only, and never has children

Methods
=======

[gtk_tree_model_] get_flags
---------------------------

Returns a set of flags supported by this interface.

The flags are a bitwise combination of enum values of **GtkTreeModelFlags**. The flags supported should not change during the lifetime of the *tree_model*.

Returns: the flags supported by this interface

    method gtk_tree_model_get_flags ( --> GtkTreeModelFlags  )

[gtk_tree_model_] get_n_columns
-------------------------------

Returns the number of columns supported by *tree_model*.

Returns: the number of columns

    method gtk_tree_model_get_n_columns ( --> Int  )

[gtk_tree_model_] get_column_type
---------------------------------

Returns the type of the column.

Returns: the type of the column

    method gtk_tree_model_get_column_type ( Int $index_ --> int32  )

  * Int $index_; the column index

[gtk_tree_model_] get_iter
--------------------------

Returns a valid iterator pointing to *$path*. If *$path* does not exist, an invalid iterator is returned. Test with `.tree-iter-is-valid()` to see if the iterator is ok.

    method gtk_tree_model_get_iter (
      Gnome::Gtk3::TreePath $path
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreePath $path; The path to point the iterator to.

[gtk_tree_model_] get_iter_from_string
--------------------------------------

Returns a valid iterator pointing to *$path_string*, if it exists. Otherwise, an invalid iterator is returned. Test with `.tree-iter-is-valid()` to see if the iterator is ok.

    method gtk_tree_model_get_iter_from_string (
      Str $path_string
      --> N-GtkTreeIter
    )

  * Str $path_string; a string representation of a **Gnome::Gtk3::TreePath**-struct

[gtk_tree_model_] get_string_from_iter
--------------------------------------

Generates a string representation of the iter.

This string is a “:” separated list of numbers. For example, “4:10:0:3” would be an acceptable return value for this string.

Returns: a newly-allocated string.

Since: 2.2

    method gtk_tree_model_get_string_from_iter ( N-GtkTreeIter $iter --> Str  )

  * N-GtkTreeIter $iter; a **Gnome::Gtk3::TreeIter**-struct

[gtk_tree_model_] get_iter_first
--------------------------------

Initializes *iter* with the first iterator in the tree (the one at the path "0"). Returns an invalid iterator if the tree is empty.

    method gtk_tree_model_get_iter_first ( --> Gnome::Gtk3::TreeIter  )

[gtk_tree_model_] get_path
--------------------------

Returns a newly-created **Gnome::Gtk3::TreePath** referenced by *$iter*.

This path should be freed with `.clear-tree-path()`.

    method gtk_tree_model_get_path (
      Gnome::Gtk3::TreeIter $iter
      --> Gnome::Gtk3::TreePath
    )

  * Gnome::Gtk3::TreeIter $iter; the iterator

[gtk_tree_model_] get_value
---------------------------

Returns an array of values found at the *$iter* and *$column*s.

When done with each *value*, `.g_value_unset()` needs to be called to free any allocated memory.

    method gtk_tree_model_get_value (
      Gnome::Gtk3::TreeIter $iter, Int $column, ...
      --> Array[Gnome::GObject::Value]
    )

  * Gnome::Gtk3::TreeIter $iter; the iterator

  * Int $column; the column to lookup the value at

  * N-GObject $value; (out) (transfer none): an empty **GValue** to set

[gtk_tree_model_] iter_previous
-------------------------------

Sets *$iter* to point to the previous node at the current level.

If there is no previous *iter*, `0` is returned and *iter* is set to be invalid.

Returns: `1` if *iter* has been changed to the previous node

Since: 3.0

    method gtk_tree_model_iter_previous ( N-GtkTreeIter $iter --> Int  )

  * N-GtkTreeIter $iter; (in): the **Gnome::Gtk3::TreeIter**-struct

[gtk_tree_model_] iter_next
---------------------------

Sets *iter* to point to the node following it at the current level.

If there is no next *iter*, `0` is returned and *iter* is set to be invalid.

Returns: `1` if *iter* has been changed to the next node

    method gtk_tree_model_iter_next ( N-GtkTreeIter $iter --> Int  )

  * N-GtkTreeIter $iter; (in): the **Gnome::Gtk3::TreeIter**-struct

[gtk_tree_model_] iter_children
-------------------------------

Returns an iterator to point to the first child of *$parent*. **Gnome::Gtk3::ListStore** does not have children but a **Gnome::Gtk3::TreeStore** does.

If *$parent* has no children, an invalid iterator is returned. *$parent* will remain a valid node after this function has been called.

    method gtk_tree_model_iter_children (
      Gnome::Gtk3::TreeIter $parent
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; an iterator pointing to a parent.

[gtk_tree_model_] iter_has_child
--------------------------------

Returns `1` if *$iter* has children, `0` otherwise.

    method gtk_tree_model_iter_has_child (
      Gnome::Gtk3::TreeIter $iter
      --> Int
    )

  * Gnome::Gtk3::TreeIter $iter; iterator to test for children

[gtk_tree_model_] iter_n_children
---------------------------------

Returns the number of children that *iter* has. As a special case, if *iter* is undefined, then the number of toplevel nodes is returned.

    method gtk_tree_model_iter_n_children (
      Gnome::Gtk3::TreeIter $iter?
      --> Int
    )

  * Gnome::Gtk3::TreeIter $iter; the iterator

[gtk_tree_model_] iter_nth_child
--------------------------------

Returns an iterator to be the child of *$parent*, using the given index.

The first index is 0. If *$n* is too big, or *$parent* has no children, the returned iterator is invalid. *$parent* will remain a valid node after this function has been called. As a special case, if *$parent* is undefined, then the iterator is set to the *$n*-th root node is set.

    method gtk_tree_model_iter_nth_child (
      Gnome::Gtk3::TreeIter $parent, Int $n
      --> Gnome::Gtk3::TreeIter
    )

  * Gnome::Gtk3::TreeIter $parent; the parent iterator to get the child from, or `Any`.

  * Int $n; the index of the desired child

[gtk_tree_model_] iter_parent
-----------------------------

Sets *iter* to be the parent of *child*.

If *child* is at the toplevel, and doesn’t have a parent, then *iter* is set to an invalid iterator and `0` is returned. *child* will remain a valid node after this function has been called.

*iter* will be initialized before the lookup is performed, so *child* and *iter* cannot point to the same memory location.

Returns: `1`, if *iter* is set to the parent of *child*

    method gtk_tree_model_iter_parent ( N-GtkTreeIter $iter, N-GtkTreeIter $child --> Int  )

  * N-GtkTreeIter $iter; (out): the new **Gnome::Gtk3::TreeIter**-struct to set to the parent

  * N-GtkTreeIter $child; the **Gnome::Gtk3::TreeIter**-struct

foreach
-------

Calls func on each node in model in a depth-first fashion.

If *func* returns `1`, then the tree ceases to be walked, and `gtk_tree_model_foreach()` returns.

    method foreach ( $function-object, Str $function-name )

  * $function-object; an object where the function is defined

  * $function-name; the name of the function which is called

The function signature is

    method f (
      Gnome::Gtk3::TreeModel $store,
      Gnome::Gtk3::TreePath $path,
      Gnome::Gtk3::TreeIter $iter
    )

An example

    my Gnome::Gtk3::ListStore $ls;
    my Gnome::Gtk3::TreeIter $iter;

    # specify column types
    $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));

    # fill some rows
    $iter = $ls.gtk-list-store-append;
    $ls.gtk-list-store-set( $iter, 0, 1001, 1, 'some text');
    $iter = $ls.gtk-list-store-append;
    $ls.gtk-list-store-set( $iter, 0, 2002, 1, 'a bit more');

    # define class for handler
    class X {
      method row-loop (
        Gnome::Gtk3::ListStore $store,
        Gnome::Gtk3::TreePath $path,
        Gnome::Gtk3::TreeIter $iter
      ) {
        # get values for this iterator
        my Array[Gnome::GObject::Value] $va = $ls.get-value( $iter, 0);

        # do something with this row ...

        my Int $value = $va[0].get-int;
        $va[0].g-value-unset;

        if $value != 1001 {
          # let the search continue
          0
        }

        # value of col 0 == 1001
        else {
          # stop walking to the next row
          1
        }
      }
    }

    $ls.foreach( X.new, 'row-loop');

[gtk_tree_model_] row_changed
-----------------------------

Emits the *row-changed* signal on the tree model.

    method gtk_tree_model_row_changed (
      Gnome::Gtk3::TreePath $path,
      Gnome::Gtk3::TreeIter $iter
    )

  * Gnome::Gtk3::TreePath $path; a path pointing to the changed row

  * Gnome::Gtk3::TreeIter $iter; an iterator pointing to the changed row

[gtk_tree_model_] row_inserted
------------------------------

Emits the *row-inserted* signal on the tree model.

    method gtk_tree_model_row_inserted (
      Gnome::Gtk3::TreePath $path,
      Gnome::Gtk3::TreeIter $iter
    )

  * Gnome::Gtk3::TreePath $path; a path pointing to the changed row

  * Gnome::Gtk3::TreeIter $iter; an iterator pointing to the changed row

[gtk_tree_model_] row_has_child_toggled
---------------------------------------

Emits the *row-has-child-toggled* signal on *tree_model*. This should be called by models after the child state of a node changes.

    method gtk_tree_model_row_has_child_toggled ( N-GtkTreePath $path, N-GtkTreeIter $iter )

  * N-GtkTreePath $path; a **Gnome::Gtk3::TreePath**-struct pointing to the changed row

  * N-GtkTreeIter $iter; a valid **Gnome::Gtk3::TreeIter**-struct pointing to the changed row

[gtk_tree_model_] row_deleted
-----------------------------

Emits the *row-deleted* signal on *tree_model*.

This should be called by models after a row has been removed. The location pointed to by *path* should be the location that the row previously was at. It may not be a valid location anymore.

Nodes that are deleted are not unreffed, this means that any outstanding references on the deleted node should not be released.

    method gtk_tree_model_row_deleted ( N-GtkTreePath $path )

  * N-GtkTreePath $path; a **Gnome::Gtk3::TreePath**-struct pointing to the previous location of the deleted row

[gtk_tree_model_] rows_reordered
--------------------------------

Emits the *rows-reordered* signal on *tree_model*.

This should be called by models when their rows have been reordered.

    method gtk_tree_model_rows_reordered ( N-GtkTreePath $path, N-GtkTreeIter $iter, Int $new_order )

  * N-GtkTreePath $path; a **Gnome::Gtk3::TreePath**-struct pointing to the tree node whose children have been reordered

  * N-GtkTreeIter $iter; a valid **Gnome::Gtk3::TreeIter**-struct pointing to the node whose children have been reordered, or `Any` if the depth of *path* is 0

  * Int $new_order; an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. *new_order*`[newpos] = oldpos`

[gtk_tree_model_] rows_reordered_with_length
--------------------------------------------

Emits the *rows-reordered* signal on *tree_model*.

This should be called by models when their rows have been reordered.

Since: 3.10

    method gtk_tree_model_rows_reordered_with_length ( N-GtkTreePath $path, N-GtkTreeIter $iter, Int $new_order, Int $length )

  * N-GtkTreePath $path; a **Gnome::Gtk3::TreePath**-struct pointing to the tree node whose children have been reordered

  * N-GtkTreeIter $iter; (allow-none): a valid **Gnome::Gtk3::TreeIter**-struct pointing to the node whose children have been reordered, or `Any` if the depth of *path* is 0

  * Int $new_order; (array length=length): an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. *new_order*`[newpos] = oldpos`

  * Int $length; length of *new_order* array

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

### row-changed

This signal is emitted when a row in the model has changed.

    method handler (
      N-GObject $path,
      N-GtkTreeIter $iter,
      Gnome::GObject::Object :widget($tree_model),
      *%user-options
    );

  * Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted

  * N-GObject $path; a native **Gnome::Gtk3::TreePath** identifying the changed row

  * N-GtkTreeIter $iter; a native **Gnome::Gtk3::TreeIter** pointing to the changed row

### row-deleted

This signal is emitted when a row in the model is deleted.

    method handler (
      N-GObject $path,
      Gnome::GObject::Object :widget($tree_model),
      *%user-options
    );

  * Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted.

  * N-GObject $path; a native **Gnome::Gtk3::TreePath** identifying where the deleted row has been at. This path may not be a valid location anymore.

### row-inserted

This signal is emitted when a new row has been inserted in the model.

Note that the row may still be empty at this point, since it is a common pattern to first insert an empty row, and then fill it with the desired values.

    method handler (
      N-GObject $path,
      N-GtkTreeIter $iter,
      Gnome::GObject::Object :widget($tree_model),
      *%user-options
    );

  * Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted

  * $path; a native **Gnome::Gtk3::TreePath** identifying the new row

  * $iter; a native **Gnome::Gtk3::TreeIter** pointing to the new row

### row-has-child-toggled

This signal is emitted when a row has gotten the first child row or lost its last child row.

    method handler (
      N-GObject $path,
      N-GtkTreeIter $iter,
      Gnome::GObject::Object :widget($tree_model),
      *%user-options
    );

  * Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted

  * $path; a native **Gnome::Gtk3::TreePath** identifying the new row

  * $iter; a native **Gnome::Gtk3::TreeIter** pointing to the new row

### rows-reordered

This signal is emitted when the children of a node in the GtkTreeModel have been reordered.

Note that this signal is not emitted when rows are reordered by DND, since this is implemented by removing and then reinserting the row.

    method handler (
      N-GObject $path,
      N-GtkTreeIter $iter,
      CArray[int32] $new-order,
      Gnome::GObject::Object :widget($tree_model),
      *%user-options
    );

  * Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted

  * $path; a native **Gnome::Gtk3::TreePath** identifying the new row

  * $iter; a native **Gnome::Gtk3::TreeIter** pointing to the new row

  * $new-order; an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. `$new_order[newpos] = oldpos`.

