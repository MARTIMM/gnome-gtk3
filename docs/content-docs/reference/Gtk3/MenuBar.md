Gnome::Gtk3::MenuBar
====================

A subclass of **Gnome::Gtk3::MenuShell** which holds **Gnome::Gtk3::MenuItem** widgets

![](images/menubar.png)

Description
===========

The **Gnome::Gtk3::MenuBar** is a subclass of **Gnome::Gtk3::MenuShell** which contains one or more **Gnome::Gtk3::MenuItems**. The result is a standard menu bar which can hold many menu items.

Css Nodes
---------

**Gnome::Gtk3::MenuBar** has a single CSS node with name menubar.

Implemented Interfaces
----------------------

Gnome::Gtk3::MenuBar implements

  * Gnome::Atk::ImplementorIface

  * [Gnome::Gtk3::Buildable](Buildable.html)

See Also
--------

**Gnome::Gtk3::MenuShell**, **Gnome::Gtk3::Menu**, **Gnome::Gtk3::MenuItem**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::MenuBar;
    also is Gnome::Gtk3::MenuShell;
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

[gtk_] menu_bar_new
-------------------

Creates a new **Gnome::Gtk3::MenuBar**

Returns: the new menu bar, as a **Gnome::Gtk3::Widget**

    method gtk_menu_bar_new ( --> N-GObject  )

[[gtk_] menu_bar_] new_from_model
---------------------------------

Creates a new **Gnome::Gtk3::MenuBar** and populates it with menu items and submenus according to *model*.

The created menu items are connected to actions found in the **Gnome::Gtk3::ApplicationWindow** to which the menu bar belongs - typically by means of being contained within the **Gnome::Gtk3::ApplicationWindows** widget hierarchy.

Returns: a new **Gnome::Gtk3::MenuBar**

Since: 3.4

    method gtk_menu_bar_new_from_model ( N-GObject $model --> N-GObject  )

  * N-GObject $model; a **GMenuModel**

[[gtk_] menu_bar_] get_pack_direction
-------------------------------------

Retrieves the current pack direction of the menubar. See `gtk_menu_bar_set_pack_direction()`.

Returns: the pack direction

Since: 2.8

    method gtk_menu_bar_get_pack_direction ( --> GtkPackDirection  )

[[gtk_] menu_bar_] set_pack_direction
-------------------------------------

Sets how items should be packed inside a menubar.

Since: 2.8

    method gtk_menu_bar_set_pack_direction ( GtkPackDirection $pack_dir )

  * GtkPackDirection $pack_dir; a new **Gnome::Gtk3::PackDirection**

[[gtk_] menu_bar_] get_child_pack_direction
-------------------------------------------

Retrieves the current child pack direction of the menubar. See `gtk_menu_bar_set_child_pack_direction()`.

Returns: the child pack direction

Since: 2.8

    method gtk_menu_bar_get_child_pack_direction ( --> GtkPackDirection  )

[[gtk_] menu_bar_] set_child_pack_direction
-------------------------------------------

Sets how widgets should be packed inside the children of a menubar.

Since: 2.8

    method gtk_menu_bar_set_child_pack_direction ( GtkPackDirection $child_pack_dir )

  * GtkPackDirection $child_pack_dir; a new **Gnome::Gtk3::PackDirection**

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Pack direction

The pack direction of the menubar. It determines how menuitems are arranged in the menubar. Since: 2.8 Widget type: GTK_TYPE_PACK_DIRECTION

The **Gnome::GObject::Value** type of property *pack-direction* is `G_TYPE_ENUM`.

### Child Pack direction

The child pack direction of the menubar. It determines how the widgets contained in child menuitems are arranged. Since: 2.8 Widget type: GTK_TYPE_PACK_DIRECTION

The **Gnome::GObject::Value** type of property *child-pack-direction* is `G_TYPE_ENUM`.

