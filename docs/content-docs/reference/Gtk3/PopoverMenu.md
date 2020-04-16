Gnome::Gtk3::PopoverMenu
========================

Popovers to use as menus

Description
===========

**Gnome::Gtk3::PopoverMenu** is a subclass of **Gnome::Gtk3::Popover** that treats its children like menus and allows switching between them. It is meant to be used primarily together with **Gnome::Gtk3::ModelButton**, but any widget can be used, such as **Gnome::Gtk3::SpinButton** or **Gnome::Gtk3::Scale**. In this respect, **Gnome::Gtk3::PopoverMenu** is more flexible than popovers that are created from a **GMenuModel** with `gtk_popover_new_from_model()`. Besides that, GMenu is deprecated.

Just like normal popovers, **Gnome::Gtk3::PopoverMenu** instances have a single css node called "popover" and get the .menu style class.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::PopoverMenu;
    also is Gnome::Gtk3::Popover;

Methods
=======

new
---

Create a new PopoverMenu object.

    multi method new ( )

Create a PopoverMenu object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a PopoverMenu object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_popover_menu_] open_submenu
--------------------------------

Opens a submenu of the *popover*. The *name* must be one of the names given to the submenus of *popover* with *submenu*, or "main" to switch back to the main menu.

**Gnome::Gtk3::ModelButton** will open submenus automatically when the *menu-name* property is set, so this function is only needed when you are using other kinds of widgets to initiate menu changes.

    method gtk_popover_menu_open_submenu ( Str $name )

  * Str $name; the name of the menu to switch to

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Visible submenu

The name of the visible submenu Default value: Any

The **Gnome::GObject::Value** type of property *visible-submenu* is `G_TYPE_STRING`.

