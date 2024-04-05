Gnome::Gtk3::RadioMenuItem
==========================

A choice from multiple check menu items

Description
===========

A radio menu item is a check menu item that belongs to a group. At each instant exactly one of the radio menu items from a group is selected.

The group list does not need to be freed, as each **Gnome::Gtk3::RadioMenuItem** will remove itself and its list item when it is destroyed.

The correct way to create a group of radio menu items is approximatively this:

    my Gnome::Glib::SList $group .= new;
    my Gnome::Gtk3::RadioMenuItem $item;
    for ^5 -> $i {

      # Create radio menu item
      $item .= new( :$group, :label("This is an example: entry $i");

      # Get the group list to be used for the next radio menu item.
      # however, only once is enough!
      $group .= new(:native-object($item.get-group)) if $i == 0;

      # Activate 2nd item
      $item.set_active(TRUE) if $i == 1;
    }

Css Nodes
---------

    menuitem
    ├── radio.left
    ╰── <child>

**Gnome::Gtk3::RadioMenuItem** has a main CSS node with name menuitem, and a subnode with name radio, which gets the .left or .right style class.

See Also
--------

**Gnome::Gtk3::MenuItem**, **Gnome::Gtk3::CheckMenuItem**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RadioMenuItem;
    also is Gnome::Gtk3::CheckMenuItem;
    also does Gnome::Gtk3::Actionable;

Uml Diagram
-----------

![](plantuml/MenuItem-ea.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::RadioMenuItem:api<1>;

    unit class MyGuiClass;
    also is Gnome::Gtk3::RadioMenuItem;

    has Gnome::Glib::SList $!group;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::RadioMenuItem class process the options
      self.bless( :GtkRadioMenuItem, |c, :group(N-GSList), :label<1st>);
    }

    submethod BUILD ( ... ) {
      $!group .= new(:native-object(self.get-group));
      ...
    }

Methods
=======

new
---

### :group

Create a new RadioMenuItem object.

    multi method new ( N-GSList :$group! )

  * N-GSList $group; (element-type a native **Gnome::Gtk3::RadioMenuItem**) group the radio menu item inside, or undefined

### :group, :label

Creates a new **Gnome::Gtk3::RadioMenuItem** whose child is a simple **Gnome::Gtk3::Label**.

    multi method new ( N-GSList :$group!, Str :$label! )

  * N-GSList $group; (element-type a native **Gnome::Gtk3::RadioMenuItem**) group the radio menu item inside, or undefined

  * Str $label; the text for the label

### :group, :mnemonic

Creates a new **Gnome::Gtk3::RadioMenuItem** containing a label. The label will be created using the `:mnemonic` option to the `.new()` call of **Gnome::Gtk3::Label**, so underscores in *label* indicate the mnemonic for the menu item.

    multi method new ( N-GSList :$group!, Str :$mnemonic! )

  * N-GSList $group; (element-type a native **Gnome::Gtk3::RadioMenuItem**) group the radio menu item inside, or undefined

  * Str $mnemonic; the text of the menu item, with an underscore in front of the mnemonic character

### :group-widget

Create a new RadioMenuItem object.

    multi method new ( N-GObject :$group-widget! )

  * N-GObject $group-widget; a **Gnome::Gtk3::RadioMenuItem** used to group the radio menu items. The first one creates the group.

### :group-widget, :label

Creates a new **Gnome::Gtk3::RadioMenuItem** whose child is a simple **Gnome::Gtk3::Label**.

    multi method new ( N-GObject :$group-widget!, Str :$label! )

  * N-GSList $group; (element-type a native **Gnome::Gtk3::RadioMenuItem**) group the radio menu item inside, or undefined

  * Str $label; the text for the label

### :group-widget, :mnemonic

Creates a new **Gnome::Gtk3::RadioMenuItem** containing a label. The label will be created using the `:mnemonic` option to the `.new()` call of **Gnome::Gtk3::Label**, so underscores in *label* indicate the mnemonic for the menu item.

    multi method new ( N-GObject :$group-widget!, Str :$mnemonic! )

  * N-GSList $group; (element-type a native **Gnome::Gtk3::RadioMenuItem**) group the radio menu item inside, or undefined

  * Str $mnemonic; the text of the menu item, with an underscore in front of the mnemonic character

### :native-object

Create a RadioMenuItem object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a RadioMenuItem object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-group
---------

Returns the group to which the radio menu item belongs, as a **GList** of **Gnome::Gtk3::RadioMenuItem**. The list belongs to GTK+ and should not be freed.

Returns: (element-type **Gnome::Gtk3::RadioMenuItem**) (transfer none): the group of *radio_menu_item*

    method get-group ( --> N-GSList )

set-group
---------

Sets the group of a radio menu item, or changes it.

    method set-group ( N-GSList $group )

  * N-GSList $group; (element-type **Gnome::Gtk3::RadioMenuItem**) (allow-none): the new group, or undefined.

join-group
----------

Joins a **Gnome::Gtk3::RadioMenuItem** object to the group of another **Gnome::Gtk3::RadioMenuItem** object. This function should be used by language bindings to avoid the memory manangement of the opaque **GSList** of `gtk_radio_menu_item_get_group()` and `gtk_radio_menu_item_set_group()`. A common way to set up a group of **Gnome::Gtk3::RadioMenuItem** instances is: |[ **Gnome::Gtk3::RadioMenuItem** *last_item = NULL; while ( ...more items to add... ) { **Gnome::Gtk3::RadioMenuItem** *radio_item; radio_item = gtk_radio_menu_item_new (...); gtk_radio_menu_item_join_group (radio_item, last_item); last_item = radio_item; } ]|

    method join-group ( N-GObject $group-source )

  * N-GObject $group_source; (allow-none): a **Gnome::Gtk3::RadioMenuItem** whose group we are joining, or `Any` to remove the *radio_menu_item* from its current group

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

### group-changed

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($radiomenuitem),
      *%user-options
    );

  * $radiomenuitem;

