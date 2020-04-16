Gnome::Gtk3::TreeSelection
==========================

The selection object for **Gnome::Gtk3::TreeView**

Description
===========

The **Gnome::Gtk3::TreeSelection** object is a helper object to manage the selection for a **Gnome::Gtk3::TreeView** widget. The **Gnome::Gtk3::TreeSelection** object is automatically created when a new **Gnome::Gtk3::TreeView** widget is created, and cannot exist independently of this widget. The primary reason the **Gnome::Gtk3::TreeSelection** objects exists is for cleanliness of code and API. That is, there is no conceptual reason all these functions could not be methods on the **Gnome::Gtk3::TreeView** widget instead of a separate function.

The **Gnome::Gtk3::TreeSelection** object is gotten from a **Gnome::Gtk3::TreeView** by calling `gtk_tree_view_get_selection()`. It can be manipulated to check the selection status of the tree, as well as select and deselect individual rows. Selection is done completely view side. As a result, multiple views of the same model can have completely different selections. Additionally, you cannot change the selection of a row on the model that is not currently displayed by the view without expanding its parents first.

One of the important things to remember when monitoring the selection of a view is that the *changed* signal is mostly a hint. That is, it may only emit one signal when a range of rows is selected. Additionally, it may on occasion emit a *changed* signal when nothing has happened (mostly as a result of programmers calling select_row on an already selected row).

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TreeSelection;
    also is Gnome::GObject::Object;

Methods
=======

new
---

Create a new TreeSelection object. The argument must be a valid **Gnome::Gtk3::TreeView** from which the current selection is asked and stored here.

    multi method new ( :$treeview! )

Create a TreeSelection object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

[gtk_tree_selection_] set_mode
------------------------------

Sets the selection mode of the *selection*. If the previous type was **GTK_SELECTION_MULTIPLE**, then the anchor is kept selected, if it was previously selected.

    method gtk_tree_selection_set_mode ( GtkSelectionMode $type )

  * GtkSelectionMode $type; The selection mode

[gtk_tree_selection_] get_mode
------------------------------

Gets the selection mode for *selection*. See `gtk_tree_selection_set_mode()`.

Returns: the current selection mode

    method gtk_tree_selection_get_mode ( --> GtkSelectionMode )

[gtk_tree_selection_] get_user_data
-----------------------------------

Returns the user data for the selection function.

Returns: The user data.

    method gtk_tree_selection_get_user_data ( --> Pointer )

[gtk_tree_selection_] get_tree_view
-----------------------------------

Returns the tree view associated with *selection*.

Returns: (transfer none): A **Gnome::Gtk3::TreeView**

    method gtk_tree_selection_get_tree_view ( --> N-GObject )

[gtk_tree_selection_] get_selected
----------------------------------

Sets *iter* to the currently selected node if *selection* is set to **GTK_SELECTION_SINGLE** or **GTK_SELECTION_BROWSE**. *iter* may be NULL if you just want to test if *selection* has any selected nodes. *model* is filled with the current model as a convenience. This function will not work if you use *selection* is **GTK_SELECTION_MULTIPLE**.

Returns: TRUE, if there is a selected node.

    method gtk_tree_selection_get_selected ( N-GObject $model, N-GtkTreeIter $iter --> Int )

  * N-GObject $model; (out) (allow-none) (transfer none): A pointer to set to the **Gnome::Gtk3::TreeModel**, or NULL.

  * N-GtkTreeIter $iter; (out) (allow-none): The **Gnome::Gtk3::TreeIter**, or NULL.

[gtk_tree_selection_] get_selected_rows
---------------------------------------

Creates a list of path of all selected rows. Additionally, if you are planning on modifying the model after calling this function, you may want to convert the returned list into a list of **Gnome::Gtk3::TreeRowReferences**. To do this, you can use `gtk_tree_row_reference_new()`.

Returns: (element-type **Gnome::Gtk3::TreePath**) (transfer full): A **GList** containing a **Gnome::Gtk3::TreePath** for each selected row.

    method gtk_tree_selection_get_selected_rows ( N-GObject $model --> N-GList )

  * N-GObject $model; (out) (allow-none) (transfer none): A pointer to set to the **Gnome::Gtk3::TreeModel**, or `Any`.

[gtk_tree_selection_] count_selected_rows
-----------------------------------------

Returns the number of rows that have been selected in *tree*.

Returns: The number of rows selected.

    method gtk_tree_selection_count_selected_rows ( --> Int )

[gtk_tree_selection_] select_path
---------------------------------

Select the row at *path*.

    method gtk_tree_selection_select_path ( N-GtkTreePath $path )

  * N-GtkTreePath $path; The **Gnome::Gtk3::TreePath** to be selected.

[gtk_tree_selection_] unselect_path
-----------------------------------

Unselects the row at *path*.

    method gtk_tree_selection_unselect_path ( N-GtkTreePath $path )

  * N-GtkTreePath $path; The **Gnome::Gtk3::TreePath** to be unselected.

[gtk_tree_selection_] select_iter
---------------------------------

Selects the specified iterator.

    method gtk_tree_selection_select_iter ( N-GtkTreeIter $iter )

  * N-GtkTreeIter $iter; The **Gnome::Gtk3::TreeIter** to be selected.

[gtk_tree_selection_] unselect_iter
-----------------------------------

Unselects the specified iterator.

    method gtk_tree_selection_unselect_iter ( N-GtkTreeIter $iter )

  * N-GtkTreeIter $iter; The **Gnome::Gtk3::TreeIter** to be unselected.

[gtk_tree_selection_] path_is_selected
--------------------------------------

Returns `1` if the row pointed to by *path* is currently selected. If *path* does not point to a valid location, `0` is returned

Returns: `1` if *path* is selected.

    method gtk_tree_selection_path_is_selected ( N-GtkTreePath $path --> Int )

  * N-GtkTreePath $path; A **Gnome::Gtk3::TreePath** to check selection on.

[gtk_tree_selection_] iter_is_selected
--------------------------------------

Returns `1` if the row at *iter* is currently selected.

Returns: `1`, if *iter* is selected

    method gtk_tree_selection_iter_is_selected ( N-GtkTreeIter $iter --> Int )

  * N-GtkTreeIter $iter; A valid **Gnome::Gtk3::TreeIter**

[gtk_tree_selection_] select_all
--------------------------------

Selects all the nodes. *selection* must be set to **GTK_SELECTION_MULTIPLE** mode.

    method gtk_tree_selection_select_all ( )

[gtk_tree_selection_] unselect_all
----------------------------------

Unselects all the nodes.

    method gtk_tree_selection_unselect_all ( )

[gtk_tree_selection_] select_range
----------------------------------

Selects a range of nodes, determined by *start_path* and *end_path* inclusive. *selection* must be set to **GTK_SELECTION_MULTIPLE** mode.

    method gtk_tree_selection_select_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path )

  * N-GtkTreePath $start_path; The initial node of the range.

  * N-GtkTreePath $end_path; The final node of the range.

[gtk_tree_selection_] unselect_range
------------------------------------

Unselects a range of nodes, determined by *start_path* and *end_path* inclusive.

    method gtk_tree_selection_unselect_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path )

  * N-GtkTreePath $start_path; The initial node of the range.

  * N-GtkTreePath $end_path; The initial node of the range.

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

### changed

Emitted whenever the selection has (possibly) changed. Please note that this signal is mostly a hint. It may only be emitted once when a range of rows are selected, and it may occasionally be emitted when nothing has happened.

    method handler (
      Gnome::GObject::Object :widget($treeselection),
      *%user-options
    );

  * $treeselection; the object which received the signal.

