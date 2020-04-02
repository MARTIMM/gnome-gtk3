Gnome::Gtk3::RecentChooserMenu
==============================

Displays recently used files in a menu

Description
===========

**Gnome::Gtk3::RecentChooserMenu** is a widget suitable for displaying recently used files inside a menu. It can be used to set a sub-menu of a **Gnome::Gtk3::MenuItem** using `gtk_menu_item_set_submenu()`, or as the menu of a **Gnome::Gtk3::MenuToolButton**.

Note that **Gnome::Gtk3::RecentChooserMenu** does not have any methods of its own. Instead, you should use the functions that work on a **Gnome::Gtk3::RecentChooser**.

Note also that **Gnome::Gtk3::RecentChooserMenu** does not support multiple filters, as it has no way to let the user choose between them as the **Gnome::Gtk3::RecentChooserWidget** and **Gnome::Gtk3::RecentChooserDialog** widgets do. Thus using `gtk_recent_chooser_add_filter()` on a **Gnome::Gtk3::RecentChooserMenu** widget will yield the same effects as using `gtk_recent_chooser_set_filter()`, replacing any currently set filter with the supplied filter; `gtk_recent_chooser_remove_filter()` will remove any currently set **Gnome::Gtk3::RecentFilter** object and will unset the current filter; `gtk_recent_chooser_list_filters()` will return a list containing a single **Gnome::Gtk3::RecentFilter** object.

Recently used files are supported since GTK+ 2.10.

Implemented Interfaces
----------------------

Gnome::Gtk3::RecentChooserMenu implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

See Also
--------

**Gnome::Gtk3::RecentChooser**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RecentChooserMenu;
    also is Gnome::Gtk3::Menu;
    also does Gnome::Gtk3::Buildable;

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

Create a new RecentChooserMenu object.

    multi method new ( )

Create a RecentChooserMenu object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a RecentChooserMenu object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_recent_chooser_menu_] get_show_numbers
-------------------------------------------

Returns the value set by `gtk_recent_chooser_menu_set_show_numbers()`.

Returns: `1` if numbers should be shown.

    method gtk_recent_chooser_menu_get_show_numbers ( --> Int )

[gtk_recent_chooser_menu_] set_show_numbers
-------------------------------------------

Sets whether a number should be added to the items of *menu*. The numbers are shown to provide a unique character for a mnemonic to be used inside ten menu item’s label. Only the first the items get a number to avoid clashes.

    method gtk_recent_chooser_menu_set_show_numbers ( Int $show_numbers )

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

