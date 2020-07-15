Gnome::Gtk3::CellRendererCombo
==============================

Renders a combobox in a cell

Description
===========

**Gnome::Gtk3::CellRendererCombo** renders text in a cell like **Gnome::Gtk3::CellRendererText** from which it is derived. But while **Gnome::Gtk3::CellRendererText** offers a simple entry to edit the text, **Gnome::Gtk3::CellRendererCombo** offers a **Gnome::Gtk3::ComboBox** widget to edit the text. The values to display in the combo box are taken from the tree model specified in the *model* property.

The combo cell renderer takes care of adding a text cell renderer to the combo box and sets it to display the column specified by its *text-column* property. Further properties of the combo box can be set in a handler for the *editing-started* signal.

The **Gnome::Gtk3::CellRendererCombo** cell renderer was added in GTK+ 2.6.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRendererCombo;
    also is Gnome::Gtk3::CellRendererText;

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

gtk_cell_renderer_combo_new
---------------------------

Creates a new **Gnome::Gtk3::CellRendererCombo**. Adjust how text is drawn using object properties. Object properties can be set globally (with `g_object_set()`). Also, with **Gnome::Gtk3::TreeViewColumn**, you can bind a property to a value in a **Gnome::Gtk3::TreeModel**. For example, you can bind the “text” property on the cell renderer to a string value in the model, thus rendering a different string in each row of the **Gnome::Gtk3::TreeView**.

Returns: the new cell renderer

Since: 2.6

    method gtk_cell_renderer_combo_new ( --> N-GObject  )

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

This signal is emitted each time after the user selected an item in the combo box, either by using the mouse or the arrow keys. Contrary to **Gnome::Gtk3::ComboBox**, **Gnome::Gtk3::CellRendererCombo**::changed is not emitted for changes made to a selected item in the entry. The argument *new_iter* corresponds to the newly selected item in the combo box and it is relative to the **Gnome::Gtk3::TreeModel** set via the model property on **Gnome::Gtk3::CellRendererCombo**.

Note that as soon as you change the model displayed in the tree view, the tree view will immediately cease the editing operating. This means that you most probably want to refrain from changing the model until the combo cell renderer emits the edited or editing_canceled signal.

Since: 2.14

    method handler (
      Str $path_string,
      N-GtkTreeIter $new_iter,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($combo),
      *%user-options
    );

  * $combo; the object on which the signal is emitted

  * $path_string; a string of the path identifying the edited cell (relative to the tree view model)

  * $new_iter; the new iterator selected in the combo box (relative to the combo box model)

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Model

Holds a tree model containing the possible values for the combo box. Use the *text_column* property to specify the column holding the values. Since: 2.6 Widget type: GTK_TYPE_TREE_MODEL

The **Gnome::GObject::Value** type of property *model* is `G_TYPE_OBJECT`.

### Text Column

Specifies the model column which holds the possible values for the combo box. Note that this refers to the model specified in the model property, not the model backing the tree view to which this cell renderer is attached. **Gnome::Gtk3::CellRendererCombo** automatically adds a text cell renderer for this column to its combo box. Since: 2.6

The **Gnome::GObject::Value** type of property *text-column* is `G_TYPE_INT`.

### Has Entry

If `1`, the cell renderer will include an entry and allow to enter values other than the ones in the popup list. Since: 2.6

The **Gnome::GObject::Value** type of property *has-entry* is `G_TYPE_BOOLEAN`.

