Gnome::Gtk3::ToolItem
=====================

The base class of tool typed widgets <!-- that can be added to **Gnome::Gtk3::ToolShell** -->

Description
===========

**Gnome::Gtk3::ToolItems** are widgets that can appear on a toolbar. To create a toolbar item that contain something else than a button, use `gtk_tool_item_new()`. Use `gtk_container_add()` to add a child widget to the tool item.

For toolbar items that contain buttons, see the **Gnome::Gtk3::ToolButton**, **Gnome::Gtk3::ToggleToolButton** and **Gnome::Gtk3::RadioToolButton** classes.

See the **Gnome::Gtk3::Toolbar** class for a description of the toolbar widget, and **Gnome::Gtk3::ToolShell** for a description of the tool shell interface.

See Also
--------

**Gnome::Gtk3::Toolbar**, **Gnome::Gtk3::ToolButton**, **Gnome::Gtk3::SeparatorToolItem**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ToolItem;
    also is Gnome::Gtk3::Bin;

Methods
=======

new
---

Create a new ToolItem object.

    multi method new ( )

Create a ToolItem object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a ToolItem object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_tool_item_new
-----------------

Creates a new **Gnome::Gtk3::ToolItem**

Returns: the new **Gnome::Gtk3::ToolItem**

Since: 2.4

    method gtk_tool_item_new ( --> N-GObject )

[gtk_tool_item_] set_homogeneous
--------------------------------

Sets whether *tool_item* is to be allocated the same size as other homogeneous items. The effect is that all homogeneous items will have the same width as the widest of the items.

Since: 2.4

    method gtk_tool_item_set_homogeneous ( Int $homogeneous )

  * Int $homogeneous; whether *tool_item* is the same size as other homogeneous items

[gtk_tool_item_] get_homogeneous
--------------------------------

Returns whether *tool_item* is the same size as other homogeneous items. See `gtk_tool_item_set_homogeneous()`.

Returns: `1` if the item is the same size as other homogeneous items.

Since: 2.4

    method gtk_tool_item_get_homogeneous ( --> Int )

[gtk_tool_item_] set_expand
---------------------------

Sets whether *tool_item* is allocated extra space when there is more room on the toolbar then needed for the items. The effect is that the item gets bigger when the toolbar gets bigger and smaller when the toolbar gets smaller.

Since: 2.4

    method gtk_tool_item_set_expand ( Int $expand )

  * Int $expand; Whether *tool_item* is allocated extra space

[gtk_tool_item_] get_expand
---------------------------

Returns whether *tool_item* is allocated extra space. See `gtk_tool_item_set_expand()`.

Returns: `1` if *tool_item* is allocated extra space.

Since: 2.4

    method gtk_tool_item_get_expand ( --> Int )

[gtk_tool_item_] set_tooltip_text
---------------------------------

Sets the text to be displayed as tooltip on the item. See `gtk_widget_set_tooltip_text()`.

Since: 2.12

    method gtk_tool_item_set_tooltip_text ( Str $text )

  * Str $text; text to be used as tooltip for *tool_item*

[gtk_tool_item_] set_tooltip_markup
-----------------------------------

Sets the markup text to be displayed as tooltip on the item. See `gtk_widget_set_tooltip_markup()`.

Since: 2.12

    method gtk_tool_item_set_tooltip_markup ( Str $markup )

  * Str $markup; markup text to be used as tooltip for *tool_item*

[gtk_tool_item_] set_use_drag_window
------------------------------------

Sets whether *tool_item* has a drag window. When `1` the toolitem can be used as a drag source through `gtk_drag_source_set()`. When *tool_item* has a drag window it will intercept all events, even those that would otherwise be sent to a child of *tool_item*.

Since: 2.4

    method gtk_tool_item_set_use_drag_window ( Int $use_drag_window )

  * Int $use_drag_window; Whether *tool_item* has a drag window.

[gtk_tool_item_] get_use_drag_window
------------------------------------

Returns whether *tool_item* has a drag window. See `gtk_tool_item_set_use_drag_window()`.

Returns: `1` if *tool_item* uses a drag window.

Since: 2.4

    method gtk_tool_item_get_use_drag_window ( --> Int )

[gtk_tool_item_] set_visible_horizontal
---------------------------------------

Sets whether *tool_item* is visible when the toolbar is docked horizontally.

Since: 2.4

    method gtk_tool_item_set_visible_horizontal ( Int $visible_horizontal )

  * Int $visible_horizontal; Whether *tool_item* is visible when in horizontal mode

[gtk_tool_item_] get_visible_horizontal
---------------------------------------

Returns whether the *tool_item* is visible on toolbars that are docked horizontally.

Returns: `1` if *tool_item* is visible on toolbars that are docked horizontally.

Since: 2.4

    method gtk_tool_item_get_visible_horizontal ( --> Int )

[gtk_tool_item_] set_visible_vertical
-------------------------------------

Sets whether *tool_item* is visible when the toolbar is docked vertically. Some tool items, such as text entries, are too wide to be useful on a vertically docked toolbar. If *visible_vertical* is `0` *tool_item* will not appear on toolbars that are docked vertically.

Since: 2.4

    method gtk_tool_item_set_visible_vertical ( Int $visible_vertical )

  * Int $visible_vertical; whether *tool_item* is visible when the toolbar is in vertical mode

[gtk_tool_item_] get_visible_vertical
-------------------------------------

Returns whether *tool_item* is visible when the toolbar is docked vertically. See `gtk_tool_item_set_visible_vertical()`.

Returns: Whether *tool_item* is visible when the toolbar is docked vertically

Since: 2.4

    method gtk_tool_item_get_visible_vertical ( --> Int )

[gtk_tool_item_] get_is_important
---------------------------------

Returns whether *tool_item* is considered important. See `gtk_tool_item_set_is_important()`

Returns: `1` if *tool_item* is considered important.

Since: 2.4

    method gtk_tool_item_get_is_important ( --> Int )

[gtk_tool_item_] set_is_important
---------------------------------

Sets whether *tool_item* should be considered important. The **Gnome::Gtk3::ToolButton** class uses this property to determine whether to show or hide its label when the toolbar style is `GTK_TOOLBAR_BOTH_HORIZ`. The result is that only tool buttons with the “is_important” property set have labels, an effect known as “priority text”

Since: 2.4

    method gtk_tool_item_set_is_important ( Int $is_important )

  * Int $is_important; whether the tool item should be considered important

[gtk_tool_item_] get_ellipsize_mode
-----------------------------------

Returns the ellipsize mode used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function to find out how text should be ellipsized.

Returns: a **PangoEllipsizeMode** indicating how text in *tool_item* should be ellipsized.

Since: 2.20

    method gtk_tool_item_get_ellipsize_mode ( --> PangoEllipsizeMode )

[gtk_tool_item_] get_icon_size
------------------------------

Returns the icon size used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function to find out what size icons they should use.

Returns: (type int): a **Gnome::Gtk3::IconSize** indicating the icon size used for *tool_item*

Since: 2.4

    method gtk_tool_item_get_icon_size ( --> GtkIconSize )

[gtk_tool_item_] get_orientation
--------------------------------

Returns the orientation used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function to find out what size icons they should use.

Returns: a **Gnome::Gtk3::Orientation** indicating the orientation used for *tool_item*

Since: 2.4

    method gtk_tool_item_get_orientation ( --> GtkOrientation )

[gtk_tool_item_] get_toolbar_style
----------------------------------

Returns the toolbar style used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function in the handler of the **Gnome::Gtk3::ToolItem**::toolbar_reconfigured signal to find out in what style the toolbar is displayed and change themselves accordingly

Possibilities are: - `GTK_TOOLBAR_BOTH`, meaning the tool item should show both an icon and a label, stacked vertically - `GTK_TOOLBAR_ICONS`, meaning the toolbar shows only icons - `GTK_TOOLBAR_TEXT`, meaning the tool item should only show text - `GTK_TOOLBAR_BOTH_HORIZ`, meaning the tool item should show both an icon and a label, arranged horizontally

Returns: A **Gnome::Gtk3::ToolbarStyle** indicating the toolbar style used for *tool_item*.

Since: 2.4

    method gtk_tool_item_get_toolbar_style ( --> GtkToolbarStyle )

[gtk_tool_item_] get_relief_style
---------------------------------

Returns the relief style of *tool_item*. See `gtk_button_set_relief()`. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function in the handler of the *toolbar_reconfigured* signal to find out the relief style of buttons.

Returns: a **Gnome::Gtk3::ReliefStyle** indicating the relief style used for *tool_item*.

Since: 2.4

    method gtk_tool_item_get_relief_style ( --> GtkReliefStyle )

[gtk_tool_item_] get_text_alignment
-----------------------------------

Returns the text alignment used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function to find out how text should be aligned.

Returns: a **gfloat** indicating the horizontal text alignment used for *tool_item*

Since: 2.20

    method gtk_tool_item_get_text_alignment ( --> Num )

[gtk_tool_item_] get_text_orientation
-------------------------------------

Returns the text orientation used for *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function to find out how text should be orientated.

Returns: a **Gnome::Gtk3::Orientation** indicating the text orientation used for *tool_item*

Since: 2.20

    method gtk_tool_item_get_text_orientation ( --> GtkOrientation )

[gtk_tool_item_] get_text_size_group
------------------------------------

Returns the size group used for labels in *tool_item*. Custom subclasses of **Gnome::Gtk3::ToolItem** should call this function and use the size group for labels.

Returns: (transfer none): a **Gnome::Gtk3::SizeGroup**

Since: 2.20

    method gtk_tool_item_get_text_size_group ( --> N-GObject )

[gtk_tool_item_] retrieve_proxy_menu_item
-----------------------------------------

Returns the **Gnome::Gtk3::MenuItem** that was last set by `gtk_tool_item_set_proxy_menu_item()`, ie. the **Gnome::Gtk3::MenuItem** that is going to appear in the overflow menu.

Returns: (transfer none): The **Gnome::Gtk3::MenuItem** that is going to appear in the overflow menu for *tool_item*.

Since: 2.4

    method gtk_tool_item_retrieve_proxy_menu_item ( --> N-GObject )

[gtk_tool_item_] get_proxy_menu_item
------------------------------------

If *menu_item_id* matches the string passed to `gtk_tool_item_set_proxy_menu_item()` return the corresponding **Gnome::Gtk3::MenuItem**.

Custom subclasses of **Gnome::Gtk3::ToolItem** should use this function to update their menu item when the **Gnome::Gtk3::ToolItem** changes. That the *menu_item_ids* must match ensures that a **Gnome::Gtk3::ToolItem** will not inadvertently change a menu item that they did not create.

Returns: (transfer none) (nullable): The **Gnome::Gtk3::MenuItem** passed to `gtk_tool_item_set_proxy_menu_item()`, if the *menu_item_ids* match.

Since: 2.4

    method gtk_tool_item_get_proxy_menu_item ( Str $menu_item_id --> N-GObject )

  * Str $menu_item_id; a string used to identify the menu item

[gtk_tool_item_] set_proxy_menu_item
------------------------------------

Sets the **Gnome::Gtk3::MenuItem** used in the toolbar overflow menu. The *menu_item_id* is used to identify the caller of this function and should also be used with `gtk_tool_item_get_proxy_menu_item()`.

See also *create-menu-proxy*.

Since: 2.4

    method gtk_tool_item_set_proxy_menu_item ( Str $menu_item_id, N-GObject $menu_item )

  * Str $menu_item_id; a string used to identify *menu_item*

  * N-GObject $menu_item; (nullable): a **Gnome::Gtk3::MenuItem** to use in the overflow menu, or `Any`

[gtk_tool_item_] rebuild_menu
-----------------------------

Calling this function signals to the toolbar that the overflow menu item for *tool_item* has changed. If the overflow menu is visible when this function it called, the menu will be rebuilt.

The function must be called when the tool item changes what it will do in response to the *create-menu-proxy* signal.

Since: 2.6

    method gtk_tool_item_rebuild_menu ( )

[gtk_tool_item_] toolbar_reconfigured
-------------------------------------

Emits the signal *toolbar_reconfigured* on *tool_item*. **Gnome::Gtk3::Toolbar** and other **Gnome::Gtk3::ToolShell** implementations use this function to notify children, when some aspect of their configuration changes.

Since: 2.14

    method gtk_tool_item_toolbar_reconfigured ( )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, N-GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### create-menu-proxy

This signal is emitted when the toolbar needs information from *tool_item* about whether the item should appear in the toolbar overflow menu. In response the tool item should either

- call `gtk_tool_item_set_proxy_menu_item()` with a `Any` pointer and return `1` to indicate that the item should not appear in the overflow menu

- call `gtk_tool_item_set_proxy_menu_item()` with a new menu item and return `1`, or

- return `0` to indicate that the signal was not handled by the item. This means that the item will not appear in the overflow menu unless a later handler installs a menu item.

The toolbar may cache the result of this signal. When the tool item changes how it will respond to this signal it must call `gtk_tool_item_rebuild_menu()` to invalidate the cache and ensure that the toolbar rebuilds its overflow menu.

Returns: `1` if the signal was handled, `0` if not

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($tool_item),
      *%user-options
      --> Int
    );

  * $tool_item; the object the signal was emitted on

### toolbar-reconfigured

This signal is emitted when some property of the toolbar that the item is a child of changes. For custom subclasses of **Gnome::Gtk3::ToolItem**, the default handler of this signal use the functions - `gtk_tool_shell_get_orientation()` - `gtk_tool_shell_get_style()` - `gtk_tool_shell_get_icon_size()` - `gtk_tool_shell_get_relief_style()` to find out what the toolbar should look like and change themselves accordingly.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($tool_item),
      *%user-options
    );

  * $tool_item; the object the signal was emitted on

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Visible when horizontal

Whether the toolbar item is visible when the toolbar is in a horizontal orientation. Default value: True

The **Gnome::GObject::Value** type of property *visible-horizontal* is `G_TYPE_BOOLEAN`.

### Visible when vertical

Whether the toolbar item is visible when the toolbar is in a vertical orientation. Default value: True

The **Gnome::GObject::Value** type of property *visible-vertical* is `G_TYPE_BOOLEAN`.

### Is important

Whether the toolbar item is considered important. When TRUE, toolbar buttons show text in GTK_TOOLBAR_BOTH_HORIZ mode Default value: False

The **Gnome::GObject::Value** type of property *is-important* is `G_TYPE_BOOLEAN`.

