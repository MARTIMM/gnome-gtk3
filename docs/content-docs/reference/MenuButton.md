TITLE
=====

Gnome::Gtk3::MenuButton

SUBTITLE
========

A widget that shows a popup when clicked on

![Image](images/menu-button.png)

Description
===========

The `Gnome::Gtk3::MenuButton` widget is used to display a popup when clicked on. This popup can be provided either as a `Gnome::Gtk3::Menu`, a `Gnome::Gtk3::Popover` or an abstract `GMenuModel`.

The `Gnome::Gtk3::MenuButton` widget can hold any valid child widget. That is, it can hold almost any other standard `Gnome::Gtk3::Widget`. The most commonly used child is `Gnome::Gtk3::Image`. If no widget is explicitely added to the `Gnome::Gtk3::MenuButton`, a `Gnome::Gtk3::Image` is automatically created, using an arrow image oriented according to `direction` or the generic "view-context-menu" icon if the direction is not set.

The positioning of the popup is determined by the `direction` property of the menu button.

For menus, the `halign` and `valign` properties of the menu are also taken into account. For example, when the direction is `GTK_ARROW_DOWN` and the horizontal alignment is `GTK_ALIGN_START`, the menu will be positioned below the button, with the starting edge (depending on the text direction) of the menu aligned with the starting edge of the button. If there is not enough space below the button, the menu is popped up above the button instead. If the alignment would move part of the menu offscreen, it is “pushed in”.

## Direction = Down

![Image](images/down-start.png)

- halign = start

    ![Image](down-start.png)

- halign = center

    ![Image](down-center.png)

- halign = end

    ![Image](down-end.png)

## Direction = Up

- halign = start

    ![Image](up-start.png)

- halign = center

    ![Image](up-center.png)

- halign = end

    ![Image](up-end.png)

## Direction = Left

- valign = start

    ![](left-start.png)

- valign = center

    ![](left-center.png)

- valign = end

    ![](left-end.png)

## Direction = Right

- valign = start

    ![](right-start.png)

- valign = center

    ![](right-center.png)

- valign = end

    ![](right-end.png)

Css Nodes
---------

`Gnome::Gtk3::MenuButton` has a single CSS node with name button. To differentiate it from a plain `Gnome::Gtk3::Button`, it gets the .popup style class.

See Also
--------

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::MenuButton;
    also is Gnome::Gtk3::ToggleButton;

Example
-------

Methods
=======

new
---

    multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

    multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

    multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_menu_button_new
-------------------

Creates a new `Gnome::Gtk3::MenuButton` widget with downwards-pointing arrow as the only child. You can replace the child widget with another `Gnome::Gtk3::Widget` should you wish to.

    method gtk_menu_button_new ( --> N-GObject  )

Returns N-GObject; The newly created `Gnome::Gtk3::MenuButton` widget

[gtk_menu_button_] set_popup
----------------------------

Sets the `Gnome::Gtk3::Menu` that will be popped up when the button is clicked, or `Any` to disable the button. If `menu`-model or `popover` are set, they will be set to `Any`.

    method gtk_menu_button_set_popup ( N-GObject $menu )

  * N-GObject $menu; (allow-none): a `Gnome::Gtk3::Menu`

[gtk_menu_button_] get_popup
----------------------------

Returns the `Gnome::Gtk3::Menu` that pops out of the button. If the button does not use a `Gnome::Gtk3::Menu`, this function returns `Any`.

    method gtk_menu_button_get_popup ( --> N-GObject  )

Returns N-GObject; (nullable) (transfer none): a `Gnome::Gtk3::Menu` or `Any`

[gtk_menu_button_] set_popover
------------------------------

Sets the `Gnome::Gtk3::Popover` that will be popped up when the button is clicked, or `Any` to disable the button. If `menu`-model or `popup` are set, they will be set to `Any`.

    method gtk_menu_button_set_popover ( N-GObject $popover )

  * N-GObject $popover; (allow-none): a `Gnome::Gtk3::Popover`

[gtk_menu_button_] get_popover
------------------------------

Returns the `Gnome::Gtk3::Popover` that pops out of the button. If the button is not using a `Gnome::Gtk3::Popover`, this function returns `Any`.

    method gtk_menu_button_get_popover ( --> N-GObject  )

Returns N-GObject; (nullable) (transfer none): a `Gnome::Gtk3::Popover` or `Any`

[gtk_menu_button_] set_direction
--------------------------------

Sets the direction in which the popup will be popped up, as well as changing the arrow’s direction. The child will not be changed to an arrow if it was customized.

    method gtk_menu_button_set_direction ( GtkArrowType $direction )

  * GtkArrowType $direction; a `Gnome::Gtk3::ArrowType`

[gtk_menu_button_] get_direction
--------------------------------

Returns the direction the popup will be pointing at when popped up.

    method gtk_menu_button_get_direction ( --> GtkArrowType  )

Returns GtkArrowType; a `Gnome::Gtk3::ArrowType` value

[gtk_menu_button_] set_menu_model
---------------------------------

Sets the `GMenuModel` from which the popup will be constructed, or `Any` to disable the button.

    method gtk_menu_button_set_menu_model ( GMenuModel $menu_model )

  * GMenuModel $menu_model; (allow-none): a `GMenuModel`

[gtk_menu_button_] get_menu_model
---------------------------------

Returns the `GMenuModel` used to generate the popup.

    method gtk_menu_button_get_menu_model ( --> GMenuModel  )

Returns GMenuModel; (nullable) (transfer none): a `GMenuModel` or `Any`

[gtk_menu_button_] set_align_widget
-----------------------------------

Sets the `Gnome::Gtk3::Widget` to use to line the menu with when popped up. Note that the *align_widget* must contain the `Gnome::Gtk3::MenuButton` itself.

    method gtk_menu_button_set_align_widget ( N-GObject $align_widget )

  * N-GObject $align_widget; (allow-none): a `Gnome::Gtk3::Widget`

[gtk_menu_button_] get_align_widget
-----------------------------------

Returns the parent `Gnome::Gtk3::Widget` to use to line up with menu.

    method gtk_menu_button_get_align_widget ( --> N-GObject  )

Returns N-GObject; (nullable) (transfer none): a `Gnome::Gtk3::Widget` value or `Any`

[gtk_menu_button_] set_use_popover
----------------------------------

Sets whether to construct a `Gnome::Gtk3::Popover` instead of `Gnome::Gtk3::Menu` when `gtk_menu_button_set_menu_model()` is called. Note that this property is only consulted when a new menu model is set.

    method gtk_menu_button_set_use_popover ( Int $use_popover )

  * Int $use_popover; `1` to construct a popover from the menu model

[gtk_menu_button_] get_use_popover
----------------------------------

Returns whether a `Gnome::Gtk3::Popover` or a `Gnome::Gtk3::Menu` will be constructed from the menu model.

    method gtk_menu_button_get_use_popover ( --> Int  )

Returns Int; `1` if using a `Gnome::Gtk3::Popover`
