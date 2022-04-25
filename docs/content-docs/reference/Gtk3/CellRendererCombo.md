Gnome::Gtk3::CellRendererCombo
==============================

Renders a combobox in a cell

Description
===========

**Gnome::Gtk3::CellRendererCombo** renders text in a cell like **Gnome::Gtk3::CellRendererText** from which it is derived. But while **Gnome::Gtk3::CellRendererText** offers a simple entry to edit the text, **Gnome::Gtk3::CellRendererCombo** offers a **Gnome::Gtk3::ComboBox** widget to edit the text. The values to display in the combo box are taken from the tree model specified in the *model* property.

The combo cell renderer takes care of adding a text cell renderer to the combo box and sets it to display the column specified by its *text-column* property. Further properties of the combo box can be set in a handler for the *editing-started* signal.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererCombo;
    also is Gnome::Gtk3::CellRendererText;

Uml Diagram
-----------

![](plantuml/.svg)

Methods
=======

new
---

### default, no options

Create a new CellRendererCombo object.

    multi method new ( )

### :native-object

Create a CellRendererCombo object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a CellRendererCombo object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

Signals
=======

changed
-------

This signal is emitted each time after the user selected an item in the combo box, either by using the mouse or the arrow keys. Contrary to GtkComboBox, GtkCellRendererCombo::changed is not emitted for changes made to a selected item in the entry. The argument *new_iter* corresponds to the newly selected item in the combo box and it is relative to the GtkTreeModel set via the model property on GtkCellRendererCombo.

Note that as soon as you change the model displayed in the tree view, the tree view will immediately cease the editing operating. This means that you most probably want to refrain from changing the model until the combo cell renderer emits the edited or editing_canceled signal.

    method handler (
      Str $path_string,
      N-GtkTreeIter $new_iter,
      Gnome::Gtk3::CellRendererCombo :_widget($combo),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $path_string; a string of the path identifying the edited cell (relative to the tree view model)

  * $new_iter; the new iter selected in the combo box (relative to the combo box model)

  * $combo; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

has-entry
---------

If FALSE, don't allow to enter strings other than the chosen ones

The **Gnome::GObject::Value** type of property *has-entry* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is TRUE.

model
-----

The model containing the possible values for the combo box

The **Gnome::GObject::Value** type of property *model* is `G_TYPE_OBJECT`.

  * Parameter is readable and writable.

text-column
-----------

A column in the data source model to get the strings from

The **Gnome::GObject::Value** type of property *text-column* is `G_TYPE_INT`.

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

