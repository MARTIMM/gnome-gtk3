Gnome::Gtk3::TreeViewColumn
===========================

A visible column in a **Gnome::Gtk3::TreeView** widget

Description
===========

The **Gnome::Gtk3::TreeViewColumn** object represents a visible column in a **Gnome::Gtk3::TreeView** widget. It allows to set properties of the column header, and functions as a holding pen for the cell renderers which determine how the data in the column is displayed.

Please refer to the [tree widget conceptual overview][TreeWidget] for an overview of all the objects and data types related to the tree widget and how they work together.

Implemented Interfaces
----------------------

Gnome::Gtk3::TreeViewColumn implements

See Also
--------

**Gnome::Gtk3::TreeView**, **Gnome::Gtk3::TreeSelection**, **Gnome::Gtk3::TreeModel**, **Gnome::Gtk3::TreeSortable**,

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TreeViewColumn;
    also is Gnome::GObject::InitiallyUnowned;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::CellLayout;

Types
=====

enum GtkTreeViewColumnSizing
----------------------------

The sizing method the column uses to determine its width. Please note that *GTK_TREE_VIEW_COLUMN_AUTOSIZE* are inefficient for large views, and can make columns appear choppy.

  * GTK_TREE_VIEW_COLUMN_GROW_ONLY: Columns only get bigger in reaction to changes in the model

  * GTK_TREE_VIEW_COLUMN_AUTOSIZE: Columns resize to be the optimal size everytime the model changes.

  * GTK_TREE_VIEW_COLUMN_FIXED: Columns are a fixed numbers of pixels wide.

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere.

    multi method new ( N-GObject :$column! )

[gtk_] tree_view_column_new
---------------------------

Creates a new **Gnome::Gtk3::TreeViewColumn**.

Returns: A newly created **Gnome::Gtk3::TreeViewColumn**.

    method gtk_tree_view_column_new ( --> N-GObject  )

[[gtk_] tree_view_column_] pack_start
-------------------------------------

Packs the *$cell* into the beginning of the column. If *$expand* is `0`, then the *$cell* is allocated no more space than it needs. Any unused space is divided evenly between cells for which *$expand* is `1`.

    method gtk_tree_view_column_pack_start (
      Gnome::Gtk3::CellRenderer $cell, Int $expand
    )

  * Gnome::Gtk3::CellRenderer $cell; The renderer.

  * Int $expand; `1` if *$cell* is to be given extra space allocated to this tree column.

[[gtk_] tree_view_column_] pack_end
-----------------------------------

Adds the *$cell* to end of the column. If *$expand* is `0`, then the *$cell* is allocated no more space than it needs. Any unused space is divided evenly between cells for which *$expand* is `1`.

    method gtk_tree_view_column_pack_end ( N-GObject $cell, Int $expand )

  * Gnome::Gtk3::CellRenderer $cell; The renderer.

  * Int $expand; `1` if *$cell* is to be given extra space allocated to this tree column.

[gtk_] tree_view_column_clear
-----------------------------

Unsets all the mappings on all renderers on this tree column.

    method gtk_tree_view_column_clear ( )

[[gtk_] tree_view_column_] add_attribute
----------------------------------------

Adds an attribute mapping to the list in this tree column. The *$column* is the column of the model to get a value from, and the *$attribute* is the parameter on *$cell_renderer* to be set from the value. So for example if column 2 of the model contains strings, you could have the “text” attribute of a **Gnome::Gtk3::CellRendererText** get its values from column 2.

    method gtk_tree_view_column_add_attribute (
      Gnome::Gtk3::CellRenderer $cell_renderer, Str $attribute, Int $column
    )

  * Gnome::Gtk3::CellRenderer $cell_renderer; the renderer to set attributes on

  * Str $attribute; An attribute on the renderer

  * Int $column; The column position on the model to get the attribute from.

[[gtk_] tree_view_column_] clear_attributes
-------------------------------------------

Clears all existing attributes previously set with `gtk_tree_view_column_set_attributes()`.

    method gtk_tree_view_column_clear_attributes (
      Gnome::Gtk3::CellRenderer $cell_renderer
    )

  * Gnome::Gtk3::CellRenderer $cell_renderer; a renderer to clear the attribute mapping on.

[[gtk_] tree_view_column_] set_spacing
--------------------------------------

Sets the spacing field of this tree column, which is the number of pixels to place between cell renderers packed into it.

    method gtk_tree_view_column_set_spacing ( Int $spacing )

  * Int $spacing; distance between cell renderers in pixels.

[[gtk_] tree_view_column_] get_spacing
--------------------------------------

Returns the spacing of this tree column.

    method gtk_tree_view_column_get_spacing ( --> Int  )

[[gtk_] tree_view_column_] set_visible
--------------------------------------

Sets the visibility of this tree column.

    method gtk_tree_view_column_set_visible ( Int $visible )

  * Int $visible; `1` if the tree column is visible.

[[gtk_] tree_view_column_] get_visible
--------------------------------------

Returns `1` if this tree column is visible. If it is visible, then the tree will show the column.

    method gtk_tree_view_column_get_visible ( --> Int  )

[[gtk_] tree_view_column_] set_resizable
----------------------------------------

If *$resizable* is `1`, then the user can explicitly resize the column by grabbing the outer edge of the column button. If resizable is `1` and sizing mode of the column is **GTK_TREE_VIEW_COLUMN_AUTOSIZE**, then the sizing mode is changed to **GTK_TREE_VIEW_COLUMN_GROW_ONLY**.

    method gtk_tree_view_column_set_resizable ( Int $resizable )

  * Int $resizable; `1`, if the column can be resized

[[gtk_] tree_view_column_] get_resizable
----------------------------------------

Returns `1` if this tree column can be resized by the end user.

    method gtk_tree_view_column_get_resizable ( --> Int  )

[[gtk_] tree_view_column_] set_sizing
-------------------------------------

Sets the growth behavior of this tree column to *$type*.

    method gtk_tree_view_column_set_sizing ( GtkTreeViewColumnSizing $type )

  * GtkTreeViewColumnSizing $type; An enumeration of types of sizing.

[[gtk_] tree_view_column_] get_sizing
-------------------------------------

Returns the current type of this tree column.

    method gtk_tree_view_column_get_sizing ( --> GtkTreeViewColumnSizing  )

[[gtk_] tree_view_column_] get_x_offset
---------------------------------------

Returns the current X offset of this tree column in pixels.

Since: 3.2

    method gtk_tree_view_column_get_x_offset ( --> Int  )

[[gtk_] tree_view_column_] get_width
------------------------------------

Returns the current size of this tree column in pixels.

    method gtk_tree_view_column_get_width ( --> Int  )

[[gtk_] tree_view_column_] get_fixed_width
------------------------------------------

Gets the fixed width of the column. This may not be the actual displayed width of the column; for that, use `gtk_tree_view_column_get_width()`.

Returns: The fixed width of the column.

    method gtk_tree_view_column_get_fixed_width ( --> Int  )

[[gtk_] tree_view_column_] set_fixed_width
------------------------------------------

If *$fixed_width* is not -1, sets the fixed width of this tree column; otherwise unsets it. The effective value of *fixed_width* is clamped between the minimum and maximum width of the column; however, the value stored in the “fixed-width” property is not clamped. If the column sizing is **GTK_TREE_VIEW_COLUMN_GROW_ONLY** or **GTK_TREE_VIEW_COLUMN_AUTOSIZE**, setting a fixed width overrides the automatically calculated width. Note that *$fixed_width* is only a hint to GTK+; the width actually allocated to the column may be greater or less than requested.

Along with “expand”, the “fixed-width” property changes when the column is resized by the user.

    method gtk_tree_view_column_set_fixed_width ( Int $fixed_width )

  * Int $fixed_width; The new fixed width, in pixels, or -1.

[[gtk_] tree_view_column_] set_min_width
----------------------------------------

Sets the minimum width of the this tree column. If *$min_width* is -1, then the minimum width is unset.

    method gtk_tree_view_column_set_min_width ( Int $min_width )

  * Int $min_width; The minimum width of the column in pixels, or -1.

[[gtk_] tree_view_column_] get_min_width
----------------------------------------

Returns the minimum width in pixels of the this tree column, or -1 if no minimum width is set.

    method gtk_tree_view_column_get_min_width ( --> Int  )

[[gtk_] tree_view_column_] set_max_width
----------------------------------------

Sets the maximum width of the this tree column. If *#max_width* is -1, then the maximum width is unset. Note, the column can actually be wider than max width if it’s the last column in a view. In this case, the column expands to fill any extra space.

    method gtk_tree_view_column_set_max_width ( Int $max_width )

  * Int $max_width; The maximum width of the column in pixels, or -1.

[[gtk_] tree_view_column_] get_max_width
----------------------------------------

Returns the maximum width in pixels of the this tree column, or -1 if no maximum width is set.

    method gtk_tree_view_column_get_max_width ( --> Int  )

[gtk_] tree_view_column_clicked
-------------------------------

Emits the “clicked” signal on the column. This function will only work if this tree column is clickable.

    method gtk_tree_view_column_clicked ( )

[[gtk_] tree_view_column_] set_title
------------------------------------

Sets the title of the this tree column. If a custom widget has been set, then this value is ignored.

    method gtk_tree_view_column_set_title ( Str $title )

  * Str $title; The title of the *tree_column*.

[[gtk_] tree_view_column_] get_title
------------------------------------

Returns the title of the column.

    method gtk_tree_view_column_get_title ( --> Str  )

[[gtk_] tree_view_column_] set_expand
-------------------------------------

Sets the column to take available extra space. This space is shared equally amongst all columns that have the expand set to `1`. If no column has this option set, then the last column gets all extra space. By default, every column is created with this `0`.

Along with “fixed-width”, the “expand” property changes when the column is resized by the user.

Since: 2.4

    method gtk_tree_view_column_set_expand ( Int $expand )

  * Int $expand; `1` if the column should expand to fill available space.

[[gtk_] tree_view_column_] get_expand
-------------------------------------

Returns `1` if the column expands to fill available space.

Since: 2.4

    method gtk_tree_view_column_get_expand ( --> Int  )

[[gtk_] tree_view_column_] set_clickable
----------------------------------------

Sets the header to be active if *$clickable* is `1`. When the header is active, then it can take keyboard focus, and can be clicked.

    method gtk_tree_view_column_set_clickable ( Int $clickable )

  * Int $clickable; `1` if the header is active.

[[gtk_] tree_view_column_] get_clickable
----------------------------------------

Returns `1` if the user can click on the header for the column.

    method gtk_tree_view_column_get_clickable ( --> Int  )

[[gtk_] tree_view_column_] set_widget
-------------------------------------

Sets the widget in the header to be *$widget*. Normally the header button is set with a **Gnome::Gtk3::Label** set to the title of this tree column.

    method gtk_tree_view_column_set_widget ( N-GObject $widget )

  * N-GObject $widget; A child **Gnome::Gtk3::Widget**.

[[gtk_] tree_view_column_] get_widget
-------------------------------------

Returns the **Gnome::Gtk3::Widget** in the button on the column header. If a custom widget has not been set then `Any` is returned.

    method gtk_tree_view_column_get_widget ( --> N-GObject  )

[[gtk_] tree_view_column_] set_alignment
----------------------------------------

Sets the alignment of the title or custom widget inside the column header. The alignment determines its location inside the button -- 0.0 for left, 0.5 for center, 1.0 for right.

    method gtk_tree_view_column_set_alignment ( Num $xalign )

  * Num $xalign; The alignment, which is between [0.0 and 1.0] inclusive.

[[gtk_] tree_view_column_] get_alignment
----------------------------------------

Returns the current x alignment of this tree column. This value can range between 0.0 and 1.0.

    method gtk_tree_view_column_get_alignment ( --> Num  )

[[gtk_] tree_view_column_] set_reorderable
------------------------------------------

If *reorderable* is `1`, then the column can be reordered by the end user dragging the header.

    method gtk_tree_view_column_set_reorderable ( Int $reorderable )

  * Int $reorderable; `1`, if the column can be reordered.

[[gtk_] tree_view_column_] get_reorderable
------------------------------------------

Returns `1` if this tree column can be reordered by the user.

    method gtk_tree_view_column_get_reorderable ( --> Int  )

[[gtk_] tree_view_column_] set_sort_column_id
---------------------------------------------

Sets the logical *$sort_column_id* that this column sorts on when this column is selected for sorting. Doing so makes the column header clickable.

    method gtk_tree_view_column_set_sort_column_id ( Int $sort_column_id )

  * Int $sort_column_id; The *sort_column_id* of the model to sort on.

[[gtk_] tree_view_column_] get_sort_column_id
---------------------------------------------

Gets the logical sort column id that the model sorts on when this column is selected for sorting. See `gtk_tree_view_column_set_sort_column_id()`.

    method gtk_tree_view_column_get_sort_column_id ( --> Int  )

[[gtk_] tree_view_column_] set_sort_indicator
---------------------------------------------

Call this function with a *$setting* of `1` to display an arrow in the header button indicating the column is sorted. Call `gtk_tree_view_column_set_sort_order()` to change the direction of the arrow.

    method gtk_tree_view_column_set_sort_indicator ( Int $setting )

  * Int $setting; `1` to display an indicator that the column is sorted

[[gtk_] tree_view_column_] get_sort_indicator
---------------------------------------------

Gets the value set by `gtk_tree_view_column_set_sort_indicator()`.

    method gtk_tree_view_column_get_sort_indicator ( --> Int  )

[[gtk_] tree_view_column_] set_sort_order
-----------------------------------------

Changes the appearance of the sort indicator.

This does not actually sort the model. Use `gtk_tree_view_column_set_sort_column_id()` if you want automatic sorting support. This function is primarily for custom sorting behavior, and should be used in conjunction with `gtk_tree_sortable_set_sort_column_id()` to do that. For custom models, the mechanism will vary.

The sort indicator changes direction to indicate normal sort or reverse sort. Note that you must have the sort indicator enabled to see anything when calling this function; see `gtk_tree_view_column_set_sort_indicator()`.

    method gtk_tree_view_column_set_sort_order ( GtkSortType $order )

  * GtkSortType $order; sort order that the sort indicator should indicate

[[gtk_] tree_view_column_] get_sort_order
-----------------------------------------

Gets the value set by `gtk_tree_view_column_set_sort_order()`.

    method gtk_tree_view_column_get_sort_order ( --> GtkSortType  )

[[gtk_] tree_view_column_] cell_set_cell_data
---------------------------------------------

Sets the cell renderer based on this tree column and *$iter*. That is, for every attribute mapping in this tree column, it will get a value from the set column on the *$iter*, and use that value to set the attribute on the cell renderer. This is used primarily by the **Gnome::Gtk3::TreeView**.

    method gtk_tree_view_column_cell_set_cell_data (
      Gnome::Gtk3::TreeModel $tree_model, Gnome::Gtk3::TreeIter $iter,
      Int $is_expander, Int $is_expanded
    )

  * Gnome::Gtk3::TreeModel $tree_model; The TreeModel to get the cell renderers attributes from. Examples of a model is Gnome::Gtk3::ListStore or Gnome::Gtk3::TreeStore.

  * Gnome::Gtk3::TreeIter $iter $iter; iterator to get the cell renderer’s attributes from.

  * Int $is_expander; `1`, if the row has children

  * Int $is_expanded; `1`, if the row has visible children

[[gtk_] tree_view_column_] cell_get_size
----------------------------------------

Obtains the width and height needed to render the column. This is used primarily by the **Gnome::Gtk3::TreeView**.

    method gtk_tree_view_column_cell_get_size ( N-GObject $cell_area, Int $x_offset, Int $y_offset, Int $width, Int $height )

  * N-GObject $cell_area; (allow-none): The area a cell in the column will be allocated, or `Any`

  * Int $x_offset; (out) (optional): location to return x offset of a cell relative to *cell_area*, or `Any`

  * Int $y_offset; (out) (optional): location to return y offset of a cell relative to *cell_area*, or `Any`

  * Int $width; (out) (optional): location to return width needed to render a cell, or `Any`

  * Int $height; (out) (optional): location to return height needed to render a cell, or `Any`

[[gtk_] tree_view_column_] cell_is_visible
------------------------------------------

Returns `1` if any of the cells packed into this tree column are visible. For this to be meaningful, you must first initialize the cells with `gtk_tree_view_column_cell_set_cell_data()`

    method gtk_tree_view_column_cell_is_visible ( --> Int  )

[[gtk_] tree_view_column_] focus_cell
-------------------------------------

Sets the current keyboard focus to be at *cell*, if the column contains 2 or more editable and activatable cells.

Since: 2.2

    method gtk_tree_view_column_focus_cell ( Gnome::Gtk3::CellRenderer $cell )

  * Gnome::Gtk3::CellRenderer $cell; A cell renderer

[[gtk_] tree_view_column_] cell_get_position
--------------------------------------------

Obtains the horizontal position and size of a cell in a column. If the cell is not found in the column, *start_pos* and *width* are not changed and `0` is returned.

Returns: `1` if *$cell* belongs to this tree column.

    method gtk_tree_view_column_cell_get_position (
      Gnome::Gtk3::CellRenderer $cell_renderer, Int $x_offset, Int $width
      --> Int
    )

  * Gnome::Gtk3::CellRenderer $cell_renderer; a cell renderer

  * Int $x_offset; (out) (allow-none): return location for the horizontal position of *cell* within *tree_column*, may be `Any`

  * Int $width; (out) (allow-none): return location for the width of *cell*, may be `Any`

[[gtk_] tree_view_column_] queue_resize
---------------------------------------

Flags the column, and the cell renderers added to this column, to have their sizes renegotiated.

Since: 2.8

    method gtk_tree_view_column_queue_resize ( )

[[gtk_] tree_view_column_] get_tree_view
----------------------------------------

Returns the **Gnome::Gtk3::TreeView** wherein *tree_column* has been inserted. If *column* is currently not inserted in any tree view, `Any` is returned.

Since: 2.12

    method gtk_tree_view_column_get_tree_view ( --> N-GObject  )

[[gtk_] tree_view_column_] get_button
-------------------------------------

Returns the button used in the treeview column header

Since: 3.0

    method gtk_tree_view_column_get_button ( --> N-GObject  )

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

### clicked

    method handler (
      Gnome::GObject::Object :widget($treeviewcolumn),
      *%user-options
    );

  * $treeviewcolumn;

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Visible

Whether to display the column Default value: True

The **Gnome::GObject::Value** type of property *visible* is `G_TYPE_BOOLEAN`.

### Resizable

Column is user-resizable Default value: False

The **Gnome::GObject::Value** type of property *resizable* is `G_TYPE_BOOLEAN`.

### X position

The **Gnome::GObject::Value** type of property *x-offset* is `G_TYPE_INT`.

### Width

The **Gnome::GObject::Value** type of property *width* is `G_TYPE_INT`.

### Spacing

The **Gnome::GObject::Value** type of property *spacing* is `G_TYPE_INT`.

### Sizing

Resize mode of the column Default value: False

The **Gnome::GObject::Value** type of property *sizing* is `G_TYPE_ENUM`.

### Fixed Width

The **Gnome::GObject::Value** type of property *fixed-width* is `G_TYPE_INT`.

### Minimum Width

The **Gnome::GObject::Value** type of property *min-width* is `G_TYPE_INT`.

### Maximum Width

The **Gnome::GObject::Value** type of property *max-width* is `G_TYPE_INT`.

### Title

Title to appear in column header Default value:

The **Gnome::GObject::Value** type of property *title* is `G_TYPE_STRING`.

### Expand

Column gets share of extra width allocated to the widget Default value: False

The **Gnome::GObject::Value** type of property *expand* is `G_TYPE_BOOLEAN`.

### Clickable

Whether the header can be clicked Default value: False

The **Gnome::GObject::Value** type of property *clickable* is `G_TYPE_BOOLEAN`.

### Widget

Widget to put in column header button instead of column title Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *widget* is `G_TYPE_OBJECT`.

### Alignment

The **Gnome::GObject::Value** type of property *alignment* is `G_TYPE_FLOAT`.

### Reorderable

Whether the column can be reordered around the headers Default value: False

The **Gnome::GObject::Value** type of property *reorderable* is `G_TYPE_BOOLEAN`.

### Sort indicator

Whether to show a sort indicator Default value: False

The **Gnome::GObject::Value** type of property *sort-indicator* is `G_TYPE_BOOLEAN`.

### Sort order

Sort direction the sort indicator should indicate Default value: False

The **Gnome::GObject::Value** type of property *sort-order* is `G_TYPE_ENUM`.

### Sort column ID

Logical sort column ID this column sorts on when selected for sorting. Setting the sort column ID makes the column header clickable. Set to -1 to make the column unsortable. Since: 2.18

The **Gnome::GObject::Value** type of property *sort-column-id* is `G_TYPE_INT`.

### Cell Area

The **Gnome::Gtk3::CellArea** used to layout cell renderers for this column. If no area is specified when creating the tree view column with `gtk_tree_view_column_new_with_area()` a horizontally oriented **Gnome::Gtk3::CellAreaBox** will be used. Since: 3.0 Widget type: GTK_TYPE_CELL_AREA

The **Gnome::GObject::Value** type of property *cell-area* is `G_TYPE_OBJECT`.

