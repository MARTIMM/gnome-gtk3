Gnome::Gtk3::ComboBox
=====================

A widget used to choose from a list of items

![](images/combo-box.png)

Description
===========

A **Gnome::Gtk3::ComboBox** is a widget that allows the user to choose from a list of valid choices. The **Gnome::Gtk3::ComboBox** displays the selected choice. When activated, the **Gnome::Gtk3::ComboBox** displays a popup which allows the user to make a new choice. The style in which the selected value is displayed, and the style of the popup is determined by the current theme. It may be similar to a Windows-style combo box.

The **Gnome::Gtk3::ComboBox** uses the model-view pattern; the list of valid choices is specified in the form of a tree model, and the display of the choices can be adapted to the data in the model by using cell renderers, as you would in a tree view. This is possible since **Gnome::Gtk3::ComboBox** implements the **Gnome::Gtk3::CellLayout** interface. The tree model holding the valid choices is not restricted to a flat list, it can be a real tree, and the popup will reflect the tree structure.

To allow the user to enter values not in the model, the “has-entry” property allows the **Gnome::Gtk3::ComboBox** to contain a **Gnome::Gtk3::Entry**. This entry can be accessed by calling `gtk_bin_get_child()` on the combo box.

For a simple list of textual choices, the model-view API of **Gnome::Gtk3::ComboBox** can be a bit overwhelming. In this case, **Gnome::Gtk3::ComboBoxText** offers a simple alternative. Both **Gnome::Gtk3::ComboBox** and **Gnome::Gtk3::ComboBoxText** can contain an entry.

Css Nodes
---------

    combobox
    ├── box.linked
    │   ╰── button.combo
    │       ╰── box
    │           ├── cellview
    │           ╰── arrow
    ╰── window.popup

A normal combobox contains a box with the .linked class, a button with the .combo class and inside those buttons, there are a cellview and an arrow.

    combobox
    ├── box.linked
    │   ├── entry.combo
    │   ╰── button.combo
    │       ╰── box
    │           ╰── arrow
    ╰── window.popup

A **Gnome::Gtk3::ComboBox** with an entry has a single CSS node with name combobox. It contains a bx with the .linked class and that box contains an entry and a button, both with the .combo class added. The button also contains another node with name arrow.

See Also
--------

**Gnome::Gtk3::ComboBoxText**, **Gnome::Gtk3::TreeModel**, **Gnome::Gtk3::CellRenderer**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ComboBox;
    also is Gnome::Gtk3::Bin;
    also does Gnome::Gtk3::CellLayout;

Uml Diagram
-----------

![](plantuml/ComboBox-ea.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::ComboBox;

    unit class MyGuiClass;
    also is Gnome::Gtk3::ComboBox;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::ComboBox class process the options
      self.bless( :GtkComboBox, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

Methods
=======

new
---

### default, no options

Create a new ComboBox object.

    multi method new ( )

### :native-object

Create a ComboBox object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a ComboBox object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-active
----------

Returns the index of the currently active item, or -1 if there’s no active item. If the model is a non-flat treemodel, and the active item is not an immediate child of the root of the tree, this function returns `gtk_tree_path_get_indices (path)[0]`, where `path` is the **Gnome::Gtk3::TreePath** of the active item.

Returns: An integer which is the index of the currently active item, or -1 if there’s no active item.

    method get-active ( --> Int )

get-active-id
-------------

Returns the ID of the active row of *combo_box*. This value is taken from the active row and the column specified by the *id-column* property of *combo_box* (see `set_id_column()`).

The returned value is an interned string which means that you can compare the pointer by value to other interned strings and that you must not free it.

If the *id-column* property of *combo_box* is not set, or if no row is active, or if the active row has a `undefined` ID value, then `undefined` is returned.

Returns: the ID of the active row, or `undefined`

    method get-active-id ( --> Str )

get-active-iter
---------------

Sets *iter* to point to the currently active item, if any item is active. Otherwise, *iter* is left unchanged.

Returns: `True` if *iter* was set, `False` otherwise

    method get-active-iter ( N-GtkTreeIter $iter --> Bool )

  * $iter; A **Gnome::Gtk3::TreeIter**

get-button-sensitivity
----------------------

Returns whether the combo box sets the dropdown button sensitive or not when there are no items in the model.

Returns: `GTK_SENSITIVITY_ON` if the dropdown button is sensitive when the model is empty, `GTK_SENSITIVITY_OFF` if the button is always insensitive or `GTK_SENSITIVITY_AUTO` if it is only sensitive as long as the model has one item to be selected.

    method get-button-sensitivity ( --> GtkSensitivityType )

get-column-span-column
----------------------

Returns the column with column span information for *combo_box*.

Returns: the column span column.

    method get-column-span-column ( --> Int )

get-entry-text-column
---------------------

Returns the column which *combo_box* is using to get the strings from to display in the internal entry.

Returns: A column in the data source model of *combo_box*.

    method get-entry-text-column ( --> Int )

get-has-entry
-------------

Returns whether the combo box has an entry.

Returns: whether there is an entry in *combo_box*.

    method get-has-entry ( --> Bool )

get-id-column
-------------

Returns the column which *combo_box* is using to get string IDs for values from.

Returns: A column in the data source model of *combo_box*.

    method get-id-column ( --> Int )

get-model
---------

Returns the **Gnome::Gtk3::TreeModel** which is acting as data source for *combo_box*.

Returns: A **Gnome::Gtk3::TreeModel** which was passed during construction.

    method get-model ( --> N-GObject )

get-popup-fixed-width
---------------------

Gets whether the popup uses a fixed width matching the allocated width of the combo box.

Returns: `True` if the popup uses a fixed width

    method get-popup-fixed-width ( --> Bool )

get-row-span-column
-------------------

Returns the column with row span information for *combo_box*.

Returns: the row span column.

    method get-row-span-column ( --> Int )

get-wrap-width
--------------

Returns the wrap width which is used to determine the number of columns for the popup menu. If the wrap width is larger than 1, the combo box is in table mode.

Returns: the wrap width.

    method get-wrap-width ( --> Int )

popdown
-------

Hides the menu or dropdown list of *combo_box*.

This function is mostly intended for use by accessibility technologies; applications should have little use for it.

    method popdown ( )

popup
-----

Pops up the menu or dropdown list of *combo_box*.

This function is mostly intended for use by accessibility technologies; applications should have little use for it.

Before calling this, *combo_box* must be mapped, or nothing will happen.

    method popup ( )

popup-for-device
----------------

Pops up the menu or dropdown list of *combo_box*, the popup window will be grabbed so only *device* and its associated pointer/keyboard are the only **Gnome::Gdk3::Devices** able to send events to it.

    method popup-for-device ( N-GObject() $device )

  * $device; a **Gnome::Gdk3::Device**

set-active
----------

Sets the active item of *combo_box* to be the item at *index*.

    method set-active ( Int() $index )

  * $index; An index in the model passed during construction, or -1 to have no active item

set-active-id
-------------

Changes the active row of *combo_box* to the one that has an ID equal to *active_id*, or unsets the active row if *active_id* is `undefined`. Rows having a `undefined` ID string cannot be made active by this function.

If the *id-column* property of *combo_box* is unset or if no row has the given ID then the function does nothing and returns `False`.

Returns: `True` if a row with a matching ID was found. If a `undefined` *active_id* was given to unset the active row, the function always returns `True`.

    method set-active-id ( Str $active_id --> Bool )

  * $active_id; the ID of the row to select, or `undefined`

set-active-iter
---------------

Sets the current active item to be the one referenced by *iter*, or unsets the active item if *iter* is `undefined`.

    method set-active-iter ( N-GtkTreeIter $iter )

  * $iter; The **Gnome::Gtk3::TreeIter**, or `undefined`

set-button-sensitivity
----------------------

Sets whether the dropdown button of the combo box should be always sensitive (`GTK_SENSITIVITY_ON`), never sensitive (`GTK_SENSITIVITY_OFF`) or only if there is at least one item to display (`GTK_SENSITIVITY_AUTO`).

    method set-button-sensitivity ( GtkSensitivityType $sensitivity )

  * $sensitivity; specify the sensitivity of the dropdown button

set-column-span-column
----------------------

Sets the column with column span information for *combo_box* to be *column_span*. The column span column contains integers which indicate how many columns an item should span.

    method set-column-span-column ( Int() $column_span )

  * $column_span; A column in the model passed during construction

set-entry-text-column
---------------------

Sets the model column which *combo_box* should use to get strings from to be *text_column*. The column *text_column* in the model of *combo_box* must be of type `G_TYPE_STRING`.

This is only relevant if *combo_box* has been created with *has-entry* as `True`.

    method set-entry-text-column ( Int() $text_column )

  * $text_column; A column in *model* to get the strings from for the internal entry

set-id-column
-------------

Sets the model column which *combo_box* should use to get string IDs for values from. The column *id_column* in the model of *combo_box* must be of type `G_TYPE_STRING`.

    method set-id-column ( Int() $id_column )

  * $id_column; A column in *model* to get string IDs for values from

set-model
---------

Sets the model used by *combo_box* to be *model*. Will unset a previously set model (if applicable). If model is `undefined`, then it will unset the model.

Note that this function does not clear the cell renderers, you have to call `gtk_cell_layout_clear()` yourself if you need to set up different cell renderers for the new model.

    method set-model ( N-GObject() $model )

  * $model; A **Gnome::Gtk3::TreeModel**

set-popup-fixed-width
---------------------

Specifies whether the popup’s width should be a fixed width matching the allocated width of the combo box.

    method set-popup-fixed-width ( Bool $fixed )

  * $fixed; whether to use a fixed popup width

set-row-span-column
-------------------

Sets the column with row span information for *combo_box* to be *row_span*. The row span column contains integers which indicate how many rows an item should span.

    method set-row-span-column ( Int() $row_span )

  * $row_span; A column in the model passed during construction.

set-wrap-width
--------------

Sets the wrap width of *combo_box* to be *width*. The wrap width is basically the preferred number of columns when you want the popup to be layed out in a table.

    method set-wrap-width ( Int() $width )

  * $width; Preferred number of columns

Signals
=======

changed
-------

The changed signal is emitted when the active item is changed. The can be due to the user selecting a different item from the list, or due to a call to `set_active_iter()`. It will also be emitted while typing into the entry of a combo box with an entry.

    method handler (
      Gnome::Gtk3::ComboBox :_widget($widget),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $widget; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

format-entry-text
-----------------

For combo boxes that are created with an entry (See GtkComboBox:has-entry).

A signal which allows you to change how the text displayed in a combo box's entry is displayed.

Connect a signal handler which returns an allocated string representing *path*. That string will then be used to set the text in the combo box's entry. The default signal handler uses the text from the GtkComboBox::entry-text-column model column.

Returns: (transfer full): a newly allocated string representing *path* for the current GtkComboBox model.

    method handler (
      Gnome::Gtk3::ComboBox :_widget($combo),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path; the GtkTreePath string from the combo box's current model to format text for

  * $combo; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

move-active
-----------

The *move-active* signal is a [keybinding signal][GtkBindingSignal] which gets emitted to move the active selection.

    method handler (
      Gnome::Gtk3::ComboBox :_widget($widget),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $scroll_type; a **Gnome::Gtk3::ScrollType**

  * $widget; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

popdown
-------

The *popdown* signal is a [keybinding signal][GtkBindingSignal] which gets emitted to popdown the combo box list.

The default bindings for this signal are Alt+Up and Escape.

    method handler (
      Gnome::Gtk3::ComboBox :_widget($button),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $button; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

popup
-----

The *popup* signal is a [keybinding signal][GtkBindingSignal] which gets emitted to popup the combo box list.

The default binding for this signal is Alt+Down.

    method handler (
      Gnome::Gtk3::ComboBox :_widget($widget),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $widget; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

active
------

The item which is currently active

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

active-id
---------

The value of the id column for the active row

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

button-sensitivity
------------------

Whether the dropdown button is sensitive when the model is empty

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * The type of this G_TYPE_ENUM object is GTK_TYPE_SENSITIVITY_TYPE

  * Parameter is readable and writable.

  * Default value is GTK_SENSITIVITY_AUTO.

cell-area
---------

The GtkCellArea used to layout cells

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_CELL_AREA

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

column-span-column
------------------

TreeModel column containing the column span values

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

entry-text-column The column in the combo box's model to associate with strings from the entry if the combo was created with ComboBox has-entry = 1
---------------------------------------------------------------------------------------------------------------------------------------------------

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

has-entry
---------

Whether combo box has an entry

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is FALSE.

has-frame
---------

Whether the combo box draws a frame around the child

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

id-column
---------

The column in the combo box's model that provides string IDs for the values in the model

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

model
-----

The model for the combo box

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_TREE_MODEL

  * Parameter is readable and writable.

popup-fixed-width
-----------------

Whether the popup's width should be a fixed width matching the allocated width of the combo box

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

popup-shown
-----------

Whether the combo's dropdown is shown

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable.

  * Default value is FALSE.

row-span-column
---------------

TreeModel column containing the row span values

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

wrap-width
----------

Wrap width for laying out the items in a grid

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXINT.

  * Default value is 0.

