Gnome::Gtk3::RecentChooserMenu
==============================

Displays recently used files in a menu

Description
===========

**Gnome::Gtk3::RecentChooserMenu** is a widget suitable for displaying recently used files inside a menu. It can be used to set a sub-menu of a **Gnome::Gtk3::MenuItem** using `.set-submenu()`, or as the menu of a **Gnome::Gtk3::MenuToolButton**.

Note that **Gnome::Gtk3::RecentChooserMenu** does not have any many methods of its own. Instead, you should use the functions of its role **Gnome::Gtk3::RecentChooser**.

Note also that **Gnome::Gtk3::RecentChooserMenu** does not support multiple filters, as it has no way to let the user choose between them as the **Gnome::Gtk3::RecentChooserWidget** and **Gnome::Gtk3::RecentChooserDialog** widgets do. Thus using `.add_filter()` on a **Gnome::Gtk3::RecentChooserMenu** widget will yield the same effects as using `.set_filter()`, replacing any currently set filter with the supplied filter; `.remove_filter()` will remove any currently set **Gnome::Gtk3::RecentFilter** object and will unset the current filter; `.list_filters()` will return a list containing a single **Gnome::Gtk3::RecentFilter** object.

See Also
--------

**Gnome::Gtk3::RecentChooser**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RecentChooserMenu;
    also is Gnome::Gtk3::Menu;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::RecentChooserMenu;

    unit class MyGuiClass;
    also is Gnome::Gtk3::RecentChooserMenu;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::RecentChooserMenu class process the options
      self.bless( :GtkRecentChooserMenu, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new RecentChooserMenu object.

    multi method new ( )

### :manager

Creates a new **Gnome::Gtk3::RecentChooserMenu** widget using *$manager* as the underlying recently used resources manager.

This is useful if you have implemented your own recent manager, or if you have a customized instance of a **Gnome::Gtk3::RecentManager** object or if you wish to share a common **Gnome::Gtk3::RecentManager** object among multiple **Gnome::Gtk3::RecentChooser** widgets.

    multi method new ( N-GObject :$manager! )

get-show-numbers
----------------

Returns the value set by `set-show-numbers()`.

Returns: `True` if numbers should be shown.

    method get-show-numbers ( --> Bool )

set-show-numbers
----------------

Sets whether a number should be added to the items of *menu*. The numbers are shown to provide a unique character for a mnemonic to be used inside the menu item’s label. Only the first ten items get a number to avoid clashes.

    method set-show-numbers ( Bool $show_numbers )

  * Int $show_numbers; whether to show numbers

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Show Numbers

Whether the first ten items in the menu should be prepended by a number acting as a unique mnemonic.

The **Gnome::GObject::Value** type of property *show-numbers* is `G_TYPE_BOOLEAN`.

