Gnome::Gtk3::Grid
=================

Pack widgets in a rows and columns

Description
===========

**Gnome::Gtk3::Grid** is a container which arranges its child widgets in rows and columns. It is a very similar to **Gnome::Gtk3::Table** and **Gnome::Gtk3::Box**, but it consistently uses **Gnome::Gtk3::Widget**’s *margin* and *expand* properties instead of custom child properties, and it fully supports height-for-width geometry management.

Children are added using `gtk_grid_attach()`. They can span multiple rows or columns. It is also possible to add a child next to an existing child, using `gtk_grid_attach_next_to()`. The behaviour of **Gnome::Gtk3::Grid** when several children occupy the same grid cell is undefined.

**Gnome::Gtk3::Grid** can be used like a **Gnome::Gtk3::Box** by just using `gtk_container_add()`, which will place children next to each other in the direction determined by the *orientation* property.

Css Nodes
---------

**Gnome::Gtk3::Grid** uses a single CSS node with name grid.

Implemented Interfaces
----------------------

Gnome::Gtk3::Grid implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * [Gnome::Gtk3::Orientable](Orientable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Grid;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Buildable;

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

gtk_grid_new
------------

Creates a new grid widget.

Returns: the new **Gnome::Gtk3::Grid**

    method gtk_grid_new ( --> N-GObject  )

gtk_grid_attach
---------------

Adds a widget to the grid.

The position of *child* is determined by *left* and *top*. The number of “cells” that *child* will occupy is determined by *width* and *height*.

    method gtk_grid_attach ( N-GObject $child, Int $left, Int $top, Int $width, Int $height )

  * N-GObject $child; the widget to add

  * Int $left; the column number to attach the left side of *child* to

  * Int $top; the row number to attach the top side of *child* to

  * Int $width; the number of columns that *child* will span

  * Int $height; the number of rows that *child* will span

[gtk_grid_] attach_next_to
--------------------------

Adds a widget to the grid.

The widget is placed next to *$sibling*, on the side determined by *$side*. When *$sibling* is `Any`, the widget is placed in row (for left or right placement) or column 0 (for top or bottom placement), at the end indicated by *side*.

Attaching widgets labeled [1], [2], [3] with *$sibling* == `Any` and *$side* == `GTK_POS_LEFT` yields a layout of [3][2][1].

    method gtk_grid_attach_next_to ( N-GObject $child, N-GObject $sibling, GtkPositionType $side, Int $width, Int $height )

  * N-GObject $child; the widget to add

  * N-GObject $sibling; (allow-none): the child of the grid that *$child* will be placed next to, or `Any` to place *$child* at the beginning or end

  * GtkPositionType $side; the side of *$sibling* that *$child* is positioned next to

  * Int $width; the number of columns that *$child* will span

  * Int $height; the number of rows that *$child* will span

[gtk_grid_] get_child_at
------------------------

Gets the child of the grid whose area covers the grid cell whose upper left corner is at *$left*, *$top*.

Returns: (transfer none) (nullable): the child at the given position, or `Any`

Since: 3.2

    method gtk_grid_get_child_at ( Int $left, Int $top --> N-GObject  )

  * Int $left; the left edge of the cell

  * Int $top; the top edge of the cell

[gtk_grid_] insert_row
----------------------

Inserts a row at the specified position.

Children which are attached at or below this position are moved one row down. Children which span across this position are grown to span the new row.

Since: 3.2

    method gtk_grid_insert_row ( Int $position )

  * Int $position; the position to insert the row at

[gtk_grid_] insert_column
-------------------------

Inserts a column at the specified position.

Children which are attached at or to the right of this position are moved one column to the right. Children which span across this position are grown to span the new column.

Since: 3.2

    method gtk_grid_insert_column ( Int $position )

  * Int $position; the position to insert the column at

[gtk_grid_] remove_row
----------------------

Removes a row from the grid.

Children that are placed in this row are removed, spanning children that overlap this row have their height reduced by one, and children below the row are moved up.

Since: 3.10

    method gtk_grid_remove_row ( Int $position )

  * Int $position; the position of the row to remove

[gtk_grid_] remove_column
-------------------------

Removes a column from the grid.

Children that are placed in this column are removed, spanning children that overlap this column have their width reduced by one, and children after the column are moved to the left.

Since: 3.10

    method gtk_grid_remove_column ( Int $position )

  * Int $position; the position of the column to remove

[gtk_grid_] insert_next_to
--------------------------

Inserts a row or column at the specified position.

The new row or column is placed next to *$sibling*, on the side determined by *$side*. If *$side* is `GTK_POS_TOP` or `GTK_POS_BOTTOM`, a row is inserted. If *$side* is `GTK_POS_LEFT` of `GTK_POS_RIGHT`, a column is inserted.

Since: 3.2

    method gtk_grid_insert_next_to ( N-GObject $sibling, GtkPositionType $side )

  * N-GObject $sibling; the child of *grid* that the new row or column will be placed next to

  * GtkPositionType $side; the side of *sibling* that *child* is positioned next to

[gtk_grid_] set_row_homogeneous
-------------------------------

Sets whether all rows of the grid will have the same height.

    method gtk_grid_set_row_homogeneous ( Int $homogeneous )

  * Int $homogeneous; `1` to make rows homogeneous

[gtk_grid_] get_row_homogeneous
-------------------------------

Returns whether all rows of the grid have the same height.

    method gtk_grid_get_row_homogeneous ( --> Int  )

[gtk_grid_] set_row_spacing
---------------------------

Sets the amount of space between rows of the grid.

    method gtk_grid_set_row_spacing ( UInt $spacing )

  * UInt $spacing; the amount of space to insert between rows

[gtk_grid_] get_row_spacing
---------------------------

Returns the amount of space between the rows of *grid*.

Returns: the row spacing of *grid*

    method gtk_grid_get_row_spacing ( --> UInt  )

[gtk_grid_] set_column_homogeneous
----------------------------------

Sets whether all columns of *grid* will have the same width.

    method gtk_grid_set_column_homogeneous ( Int $homogeneous )

  * Int $homogeneous; `1` to make columns homogeneous

[gtk_grid_] get_column_homogeneous
----------------------------------

Returns whether all columns of *grid* have the same width.

Returns: whether all columns of *grid* have the same width.

    method gtk_grid_get_column_homogeneous ( --> Int  )

[gtk_grid_] set_column_spacing
------------------------------

Sets the amount of space between columns of *grid*.

    method gtk_grid_set_column_spacing ( UInt $spacing )

  * UInt $spacing; the amount of space to insert between columns

[gtk_grid_] get_column_spacing
------------------------------

Returns the amount of space between the columns of *grid*.

Returns: the column spacing of *grid*

    method gtk_grid_get_column_spacing ( --> UInt  )

[gtk_grid_] set_row_baseline_position
-------------------------------------

Sets how the baseline should be positioned on *row* of the grid, in case that row is assigned more space than is requested.

Since: 3.10

    method gtk_grid_set_row_baseline_position ( Int $row, GtkBaselinePosition $pos )

  * Int $row; a row index

  * GtkBaselinePosition $pos; a **Gnome::Gtk3::BaselinePosition**

[gtk_grid_] get_row_baseline_position
-------------------------------------

Returns the baseline position of *row* as set by `gtk_grid_set_row_baseline_position()` or the default value `GTK_BASELINE_POSITION_CENTER`.

Returns: the baseline position of *row*

Since: 3.10

    method gtk_grid_get_row_baseline_position ( Int $row --> GtkBaselinePosition  )

  * Int $row; a row index

[gtk_grid_] set_baseline_row
----------------------------

Sets which row defines the global baseline for the entire grid. Each row in the grid can have its own local baseline, but only one of those is global, meaning it will be the baseline in the parent of the *grid*.

Since: 3.10

    method gtk_grid_set_baseline_row ( Int $row )

  * Int $row; the row index

[gtk_grid_] get_baseline_row
----------------------------

Returns which row defines the global baseline of *grid*.

Returns: the row index defining the global baseline

Since: 3.10

    method gtk_grid_get_baseline_row ( --> Int  )

