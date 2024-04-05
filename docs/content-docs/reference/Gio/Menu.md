Gnome::Gio::Menu
================

A simple implementation of N-GObject

Description
===========

**Gnome::Gio::Menu** is a simple implementation of **Gnome::Gio::MenuModel**. You populate a **Gnome::Gio::Menu** by adding **Gnome::Gio::MenuItem** instances to it.

There are some convenience functions to allow you to directly add items (avoiding **Gnome::Gio::MenuItem**) for the common cases. To add a regular item, use `insert()`. To add a section, use `insert-section()`. To add a submenu, use `insert-submenu()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::Menu;
    also is Gnome::Gio::MenuModel;

Uml Diagram
-----------

![](plantuml/MenuModel.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gio::Menu:api<1>;

    unit class MyGuiClass;
    also is Gnome::Gio::Menu;

    submethod new ( |c ) {
      # let the Gnome::Gio::Menu class process the options
      self.bless( :N-GObject, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new Menu object.

    multi method new ( )

### :native-object

Create a Menu object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Menu object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

append
------

Convenience function for appending a normal menu item to the end of *menu*. Combine `Gnome::Gio::MenuItem.new()` and `insert-item()` for a more flexible alternative.

    method append ( Str $label, Str $detailed_action )

  * Str $label; the section label, or `undefined`

  * Str $detailed_action;the detailed action string, or `undefined`

append-item
-----------

Appends *$item* to the end of *menu*. See `insert-item()` for more information.

    method append-item ( N-GObject $item )

  * N-GObject $item; a **Gnome::Gio::MenuItem** to append

append-section
--------------

Convenience function for appending a section menu item to the end of *menu*. Combine `Gnome::Gio::MenuItem(:section)` and `insert-item()` for a more flexible alternative.

    method append-section ( Str $label, N-GObject $section )

  * Str $label; the section label, or `undefined`

  * N-GObject $section; a **Gnome::Gio::MenuModel** with the items of the section

append-submenu
--------------

Convenience function for appending a submenu menu item to the end of *menu*. Combine `Gnome::Gio::MenuItem(:submenu)` and `insert-item()` for a more flexible alternative.

    method append-submenu ( Str $label, N-GObject $submenu )

  * Str $label; (nullable): the section label, or `undefined`

  * N-GObject $submenu; a **Gnome::Gio::MenuModel** with the items of the submenu

freeze
------

Marks *menu* as frozen.

After the menu is frozen, it is an error to attempt to make any changes to it. In effect this means that the **Gnome::Gio::Menu** API must no longer be used.

This function causes `model-is-mutable()` to begin returning `False`, which has some positive performance implications.

    method freeze ( )

insert
------

Convenience function for inserting a normal menu item into *menu*. Combine `Gnome::Gio::MenuItem.new()` and `insert-item()` for a more flexible alternative.

    method insert ( Int $position, Str $label, Str $detailed_action )

  * Int $position; the position at which to insert the item

  * Str $label; the section label, or `undefined`

  * Str $detailed_action; the detailed action string, or `undefined`

insert-item
-----------

Inserts *$item* into *menu*.

The "insertion" is actually done by copying all of the attribute and link values of *item* and using them to form a new item within *menu*. As such, *item* itself is not really inserted, but rather, a menu item that is exactly the same as the one presently described by *item*.

This means that *item* is essentially useless after the insertion occurs. Any changes you make to it are ignored unless it is inserted again (at which point its updated values will be copied).

You should probably just free *item* once you're done.

There are many convenience functions to take care of common cases. See `insert()`, `insert-section()` and `insert-submenu()` as well as "prepend" and "append" variants of each of these functions.

    method insert-item ( Int $position, N-GObject $item )

  * Int $position; the position at which to insert the item

  * N-GObject $item; the **Gnome::Gio::MenuItem** to insert

insert-section
--------------

Convenience function for inserting a section menu item into *menu*. Combine `Gnome::Gio::MenuItem.new(:section)` and `insert-item()` for a more flexible alternative.

    method insert-section ( Int $position, Str $label, N-GObject $section )

  * Int $position; the position at which to insert the item

  * Str $label; the section label, or `undefined`

  * N-GObject $section; a **Gnome::Gio::MenuModel** with the items of the section

insert-submenu
--------------

Convenience function for inserting a submenu menu item into *menu*. Combine `Gnome::Gio::MenuItem.new(:submenu)` and `insert-item()` for a more flexible alternative.

    method insert-submenu ( Int $position, Str $label, N-GObject $submenu )

  * Int $position; the position at which to insert the item

  * Str $label; the section label, or `undefined`

  * N-GObject $submenu; a **Gnome::Gio::MenuModel** with the items of the submenu

prepend
-------

Convenience function for prepending a normal menu item to the start of *menu*. Combine `Gnome::Gio::MenuItem.new()` and `insert-item()` for a more flexible alternative.

    method prepend ( Str $label, Str $detailed_action )

  * Str $label; the section label, or `undefined`

  * Str $detailed_action; the detailed action string, or `undefined`

prepend-item
------------

Prepends *item* to the start of *menu*.

See `insert-item()` for more information.

    method prepend-item ( N-GObject $item )

  * N-GObject $item; a **Gnome::Gio::MenuItem** to prepend

prepend-section
---------------

Convenience function for prepending a section menu item to the start of *menu*. Combine `Gnome::Gio::MenuItem.new(:section)` and `insert-item()` for a more flexible alternative.

    method prepend-section ( Str $label, N-GObject $section )

  * Str $label; (nullable): the section label, or `undefined`

  * N-GObject $section; a **Gnome::Gio::MenuModel** with the items of the section

prepend-submenu
---------------

Convenience function for prepending a submenu menu item to the start of *menu*. Combine `Gnome::Gio::MenuItem.new(:submenu)` and `insert-item()` for a more flexible alternative.

    method prepend-submenu ( Str $label, N-GObject $submenu )

  * Str $label; the section label, or `undefined`

  * N-GObject $submenu; a **Gnome::Gio::MenuModel** with the items of the submenu

remove
------

Removes an item from the menu.

*$position* gives the index of the item to remove.

It is an error if position is not in range the range from 0 to one less than the number of items in the menu.

It is not possible to remove items by identity since items are added to the menu simply by copying their links and attributes (ie: identity of the item itself is not preserved).

    method remove ( Int $position )

  * Int $position; the position of the item to remove

remove-all
----------

Removes all items in the menu.

    method remove-all ( )

