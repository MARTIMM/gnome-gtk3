Gnome::Gtk3::ToolButton
=======================

A **Gnome::Gtk3::ToolItem** subclass that displays buttons

Description
===========

**Gnome::Gtk3::ToolButtons** are **Gnome::Gtk3::ToolItems** containing buttons.

Use `gtk_tool_button_new()` to create a new **Gnome::Gtk3::ToolButton**.

The label of a **Gnome::Gtk3::ToolButton** is determined by the properties *label-widget*, *label*, and *stock-id*. If *label-widget* is defined, then that widget is used as the label. Otherwise, if *label* is defined, that string is used as the label. Otherwise, if *stock-id* is defined, the label is determined by the stock item. Otherwise, the button does not have a label.

The icon of a **Gnome::Gtk3::ToolButton** is determined by the properties *icon-widget* and *stock-id*. If *icon-widget* is non-`Any`, then that widget is used as the icon. Otherwise, if *stock-id* is non-`Any`, the icon is determined by the stock item. Otherwise, the button does not have a icon.

Css Nodes
---------

**Gnome::Gtk3::ToolButton** has a single CSS node with name toolbutton.

Implemented Interfaces
----------------------

Gnome::Gtk3::ToolButton implements

See Also
--------

**Gnome::Gtk3::Toolbar**, **Gnome::Gtk3::MenuToolButton**, **Gnome::Gtk3::ToggleToolButton**, **Gnome::Gtk3::RadioToolButton**, **Gnome::Gtk3::SeparatorToolItem**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ToolButton;
    also is Gnome::Gtk3::ToolItem;

Methods
=======

new
---

Create a new ToolButton object. No icon or label is displayed.

    multi method new ( )

Create a new ToolButton object with a label

    multi method new ( Str :$label! )

Create a new ToolButton object with an icon

    multi method new ( N-GObject :$icon! )

Create a ToolButton object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a ToolButton object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_tool_button_new
-------------------

Creates a new **Gnome::Gtk3::ToolButton** using *icon_widget* as contents and *label* as label.

Returns: A new **Gnome::Gtk3::ToolButton**

Since: 2.4

    method gtk_tool_button_new ( N-GObject $icon_widget, Str $label --> N-GObject )

  * N-GObject $icon_widget; (allow-none): a string that will be used as label, or `Any`

  * Str $label; (allow-none): a widget that will be used as the button contents, or `Any`

[gtk_tool_button_] set_label
----------------------------

Sets *label* as the label used for the tool button. The *label* property only has an effect if not overridden by a non-`Any` *label-widget* property. If both the *label-widget* and *label* properties are `Any`, the label is determined by the *stock-id* property. If the *stock-id* property is also `Any`, *button* will not have a label.

Since: 2.4

    method gtk_tool_button_set_label ( Str $label )

  * Str $label; (allow-none): a string that will be used as label, or `Any`.

[gtk_tool_button_] get_label
----------------------------

Returns the label used by the tool button, or `Any` if the tool button doesn’t have a label. or uses a the label from a stock item. The returned string is owned by GTK+, and must not be modified or freed.

Returns: (nullable): The label, or `Any`

Since: 2.4

    method gtk_tool_button_get_label ( --> Str )

[gtk_tool_button_] set_use_underline
------------------------------------

If set, an underline in the label property indicates that the next character should be used for the mnemonic accelerator key in the overflow menu. For example, if the label property is “_Open” and *use_underline* is `1`, the label on the tool button will be “Open” and the item on the overflow menu will have an underlined “O”.

Labels shown on tool buttons never have mnemonics on them; this property only affects the menu item on the overflow menu.

Since: 2.4

    method gtk_tool_button_set_use_underline ( Int $use_underline )

  * Int $use_underline; whether the button label has the form “_Open”

[gtk_tool_button_] get_use_underline
------------------------------------

Returns whether underscores in the label property are used as mnemonics on menu items on the overflow menu. See `gtk_tool_button_set_use_underline()`.

Returns: `1` if underscores in the label property are used as mnemonics on menu items on the overflow menu.

Since: 2.4

    method gtk_tool_button_get_use_underline ( --> Int )

[gtk_tool_button_] set_icon_name
--------------------------------

Sets the icon for the tool button from a named themed icon. See the docs for **Gnome::Gtk3::IconTheme** for more details. The *icon-name* property only has an effect if not overridden by non-`Any` *label-widget*, *icon-widget* and *stock-id* properties.

Since: 2.8

    method gtk_tool_button_set_icon_name ( Str $icon_name )

  * Str $icon_name; (allow-none): the name of the themed icon

[gtk_tool_button_] get_icon_name
--------------------------------

Returns the name of the themed icon for the tool button, see `gtk_tool_button_set_icon_name()`.

Returns: (nullable): the icon name or `Any` if the tool button has no themed icon

Since: 2.8

    method gtk_tool_button_get_icon_name ( --> Str )

[gtk_tool_button_] set_icon_widget
----------------------------------

Sets *icon* as the widget used as icon on *button*. If *icon_widget* is `Any` the icon is determined by the *stock-id* property. If the *stock-id* property is also `Any`, *button* will not have an icon.

Since: 2.4

    method gtk_tool_button_set_icon_widget ( N-GObject $icon_widget )

  * N-GObject $icon_widget; (allow-none): the widget used as icon, or `Any`

[gtk_tool_button_] get_icon_widget
----------------------------------

Return the widget used as icon widget on *button*. See `gtk_tool_button_set_icon_widget()`.

Returns: (nullable) (transfer none): The widget used as icon on *button*, or `Any`.

Since: 2.4

    method gtk_tool_button_get_icon_widget ( --> N-GObject )

[gtk_tool_button_] set_label_widget
-----------------------------------

Sets *label_widget* as the widget that will be used as the label for *button*. If *label_widget* is `Any` the *label* property is used as label. If *label* is also `Any`, the label in the stock item determined by the *stock-id* property is used as label. If *stock-id* is also `Any`, *button* does not have a label.

Since: 2.4

    method gtk_tool_button_set_label_widget ( N-GObject $label_widget )

  * N-GObject $label_widget; (allow-none): the widget used as label, or `Any`

[gtk_tool_button_] get_label_widget
-----------------------------------

Returns the widget used as label on *button*. See `gtk_tool_button_set_label_widget()`.

Returns: (nullable) (transfer none): The widget used as label on *button*, or `Any`.

Since: 2.4

    method gtk_tool_button_get_label_widget ( --> N-GObject )

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

This signal is emitted when the tool button is clicked with the mouse or activated with the keyboard.

    method handler (
      Gnome::GObject::Object :widget($toolbutton),
      *%user-options
    );

  * $toolbutton; the object that emitted the signal

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Label

Text to show in the item. Default value: Any

The **Gnome::GObject::Value** type of property *label* is `G_TYPE_STRING`.

### Use underline

If set, an underline in the label property indicates that the next character should be used for the mnemonic accelerator key in the overflow menu Default value: False

The **Gnome::GObject::Value** type of property *use-underline* is `G_TYPE_BOOLEAN`.

### Label widget

Widget to use as the item label Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *label-widget* is `G_TYPE_OBJECT`.

### Icon name

The name of the themed icon displayed on the item. This property only has an effect if not overridden by *label-widget*, *icon-widget* or *stock-id* properties. Since: 2.8

The **Gnome::GObject::Value** type of property *icon-name* is `G_TYPE_STRING`.

### Icon widget

Icon widget to display in the item Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *icon-widget* is `G_TYPE_OBJECT`.

