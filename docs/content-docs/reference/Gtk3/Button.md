TITLE
=====

Gnome::Gtk3::Button

![](images/button.png)

SUBTITLE
========

A widget that emits a signal when clicked on

Description
===========

The `Gnome::Gtk3::Button` widget is generally used to trigger a callback function that is called when the button is pressed. The various signals and how to use them are outlined below.

The `Gnome::Gtk3::Button` widget can hold any valid child widget. That is, it can hold almost any other standard `Gnome::Gtk3::Widget`. The most commonly used child is the `Gnome::Gtk3::Label`.

Css Nodes
---------

`Gnome::Gtk3::Button` has a single CSS node with name button. The node will get the style classes .image-button or .text-button, if the content is just an image or label, respectively. It may also receive the .flat style class.

Other style classes that are commonly used with `Gnome::Gtk3::Button` include .suggested-action and .destructive-action. In special cases, buttons can be made round by adding the .circular style class.

Button-like widgets like `Gnome::Gtk3::ToggleButton`, `Gnome::Gtk3::MenuButton`, `Gnome::Gtk3::VolumeButton`, `Gnome::Gtk3::LockButton`, `Gnome::Gtk3::ColorButton`, `Gnome::Gtk3::FontButton` or `Gnome::Gtk3::FileChooserButton` use style classes such as .toggle, .popup, .scale, .lock, .color, .font, .file to differentiate themselves from a plain `Gnome::Gtk3::Button`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Button;
    also is Gnome::Gtk3::Bin;

Example
-------

    my Gnome::Gtk3::Button $start-button .= new(:label<Start>);

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create an empty button

### multi method new ( Str :$label! )

Creates a new button object with a label

### multi method new ( N-GObject :$widget! )

Create a button using a native object from elsewhere. See also Gnome::GObject::Object.

### multi method new ( Str :$build-id! )

Create a button using a native object from a builder. See also Gnome::GObject::Object.

gtk_button_new
--------------

Creates a new `Gnome::Gtk3::Button` widget. To add a child widget to the button, use `gtk_container_add()`.

Returns: The newly created `Gnome::Gtk3::Button` widget.

    method gtk_button_new ( --> N-GObject  )

[gtk_button_] new_with_label
----------------------------

Creates a `Gnome::Gtk3::Button` widget with a `Gnome::Gtk3::Label` child containing the given text.

Returns: The newly created `Gnome::Gtk3::Button` widget.

    method gtk_button_new_with_label ( Str $label --> N-GObject  )

  * Str $label; The text you want the `Gnome::Gtk3::Label` to hold.

[gtk_button_] new_from_icon_name
--------------------------------

Creates a new button containing an icon from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be displayed instead. If the current icon theme is changed, the icon will be updated appropriately.

This function is a convenience wrapper around `gtk_button_new()` and `gtk_button_set_image()`.

Returns: a new `Gnome::Gtk3::Button` displaying the themed icon

Since: 3.10

    method gtk_button_new_from_icon_name ( Str $icon_name, GtkIconSize $size --> N-GObject  )

  * Str $icon_name; an icon name

  * GtkIconSize $size; (type int): an icon size (`Gnome::Gtk3::IconSize`)

[gtk_button_] new_with_mnemonic
-------------------------------

Creates a new `Gnome::Gtk3::Button` containing a label. If characters in *label* are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use “__” (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. Pressing Alt and that key activates the button.

Returns: a new `Gnome::Gtk3::Button`

    method gtk_button_new_with_mnemonic ( Str $label --> N-GObject  )

  * Str $label; The text of the button, with an underscore in front of the mnemonic character

gtk_button_clicked
------------------

Emits a sig `clicked` signal to the given `Gnome::Gtk3::Button`.

    method gtk_button_clicked ( )

[gtk_button_] set_relief
------------------------

Sets the relief style of the edges of the given `Gnome::Gtk3::Button` widget. Two styles exist, `GTK_RELIEF_NORMAL` and `GTK_RELIEF_NONE`. The default style is, as one can guess, `GTK_RELIEF_NORMAL`. The deprecated value `GTK_RELIEF_HALF` behaves the same as `GTK_RELIEF_NORMAL`.

    method gtk_button_set_relief ( GtkReliefStyle $relief )

  * GtkReliefStyle $relief; The `Gnome::Gtk3::ReliefStyle` as described above

[gtk_button_] get_relief
------------------------

Returns the current relief style of the given `Gnome::Gtk3::Button`.

Returns: The current `Gnome::Gtk3::ReliefStyle`

    method gtk_button_get_relief ( --> GtkReliefStyle  )

[gtk_button_] set_label
-----------------------

Sets the text of the label of the button to *str*. This text is also used to select the stock item if `gtk_button_set_use_stock()` is used.

This will also clear any previously set labels.

    method gtk_button_set_label ( Str $label )

  * Str $label; a string

[gtk_button_] get_label
-----------------------

Fetches the text from the label of the button, as set by `gtk_button_set_label()`. If the label text has not been set the return value will be `Any`. This will be the case if you create an empty button with `gtk_button_new()` to use as a container.

Returns: The text of the label widget. This string is owned by the widget and must not be modified or freed.

    method gtk_button_get_label ( --> Str  )

[gtk_button_] set_use_underline
-------------------------------

If true, an underline in the text of the button label indicates the next character should be used for the mnemonic accelerator key.

    method gtk_button_set_use_underline ( Int $use_underline )

  * Int $use_underline; `1` if underlines in the text indicate mnemonics

[gtk_button_] get_use_underline
-------------------------------

Returns whether an embedded underline in the button label indicates a mnemonic. See `gtk_button_set_use_underline()`.

Returns: `1` if an embedded underline in the button label indicates the mnemonic accelerator keys.

    method gtk_button_get_use_underline ( --> Int  )

[gtk_button_] set_image
-----------------------

Set the image of *button* to the given widget. The image will be displayed if the label text is `Any` or if prop `always-show-image` is `1`. You don’t have to call `gtk_widget_show()` on *image* yourself.

Since: 2.6

    method gtk_button_set_image ( N-GObject $image )

  * N-GObject $image; a widget to set as the image for the button

[gtk_button_] get_image
-----------------------

Gets the widget that is currenty set as the image of *button*. This may have been explicitly set by `gtk_button_set_image()` or constructed by `gtk_button_new_from_stock()`.

Returns: (nullable) (transfer none): a `Gnome::Gtk3::Widget` or `Any` in case there is no image

Since: 2.6

    method gtk_button_get_image ( --> N-GObject  )

[gtk_button_] set_image_position
--------------------------------

Sets the position of the image relative to the text inside the button.

Since: 2.10

    method gtk_button_set_image_position ( GtkPositionType $position )

  * GtkPositionType $position; the position

[gtk_button_] get_image_position
--------------------------------

Gets the position of the image relative to the text inside the button.

Returns: the position

Since: 2.10

    method gtk_button_get_image_position ( --> GtkPositionType  )

[gtk_button_] set_always_show_image
-----------------------------------

If `1`, the button will ignore the prop `gtk-button-images` setting and always show the image, if available.

Use this property if the button would be useless or hard to use without the image.

Since: 3.6

    method gtk_button_set_always_show_image ( Int $always_show )

  * Int $always_show; `1` if the menuitem should always show the image

[gtk_button_] get_always_show_image
-----------------------------------

Returns whether the button will ignore the prop `gtk-button-images` setting and always show the image, if available.

Returns: `1` if the button will always show the image

Since: 3.6

    method gtk_button_get_always_show_image ( --> Int  )

[gtk_button_] get_event_window
------------------------------

Returns the button’s event window if it is realized, `Any` otherwise. This function should be rarely needed.

Returns: (transfer none): *button*’s event window.

Since: 2.22

    method gtk_button_get_event_window ( --> N-GObject  )

List of deprecated (not implemented!) methods
=============================================

Since 3.10
----------

### method gtk_button_set_use_stock ( Int $use_stock )

### method gtk_button_get_use_stock ( --> Int )

Since 3.10.
-----------

### method gtk_button_new_from_stock ( Str $stock_id --> N-GObject )

Since 3.14
----------

### method gtk_button_set_alignment ( Num $xalign, Num $yalign )

### method gtk_button_get_alignment ( Num $xalign, Num $yalign )

Since 3.20.
-----------

### method gtk_button_set_focus_on_click ( Int $focus_on_click )

### method gtk_button_get_focus_on_click ( --> Int )

Signals
=======

Register any signal as follows. See also `Gnome::GObject::Object`.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Supported signals
-----------------

### clicked

Emitted when the button has been activated (pressed and released).

    method handler (
      Gnome::GObject::Object :widget($button),
      :$user-option1, ..., :$user-optionN
    );

  * $button; the object that received the signal

Unsupported / Deprecated signals
--------------------------------

### pressed

Emitted when the button is pressed.

Deprecated: 2.8: Use the sig `button-press-event` signal.

### released

Emitted when the button is released.

Deprecated: 2.8: Use the sig `button-release-event` signal.

### enter

Emitted when the pointer enters the button.

Deprecated: 2.8: Use the sig `enter-notify-event` signal.

### leave

Emitted when the pointer leaves the button.

Deprecated: 2.8: Use the sig `leave-notify-event` signal.

### activate

The ::activate signal on `Gnome::Gtk3::Button` is an action signal and emitting it causes the button to animate press then release. Applications should never connect to this signal, but use the sig `clicked` signal.

### image-spacing

Spacing in pixels between the image and label.

Since: 2.10

Deprecated: 3.20: Use CSS margins and padding instead.

Properties
==========

An example of using a string type property of a `Gnome::Gtk3::Label` object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### image-position

The `Gnome::GObject::Value` type of property *image-position* is `G_TYPE_ENUM`.

The position of the image relative to the text inside the button.

Since: 2.10

### always-show-image

The `Gnome::GObject::Value` type of property *always-show-image* is `G_TYPE_BOOLEAN`.

If `1`, the button will ignore the prop `gtk-button-images` setting and always show the image, if available.

Use this property if the button would be useless or hard to use without the image.

Since: 3.6

Not yet supported properties
----------------------------

### image

The `Gnome::GObject::Value` type of property *image* is `G_TYPE_OBJECT`.

The child widget to appear next to the button text.

Since: 2.6

