Gnome::Gtk3::RadioButton
========================

A choice from multiple check buttons

![](images/radio-group.png)

Description
===========

A single radio button performs the same basic function as a **Gnome::Gtk3::CheckButton**, as its position in the object hierarchy reflects. It is only when multiple radio buttons are grouped together that they become a different user interface component in their own right.

Every radio button is a member of some group of radio buttons. When one is selected, all other radio buttons in the same group are deselected. A **Gnome::Gtk3::RadioButton** is one way of giving the user a choice from many options.

Radio button widgets are created with `gtk_radio_button_new()`, passing `Any` as the argument if this is the first radio button in a group. In subsequent calls, the group you wish to add this button to should be passed as an argument. Optionally, `new(:label())` or `gtk_radio_button_new_with_label()` can be used if you want a text label on the radio button.

Alternatively, when adding widgets to an existing group of radio buttons, use `gtk_radio_button_new_from_widget()` with a **Gnome::Gtk3::RadioButton** that already has a group assigned to it. The convenience function `gtk_radio_button_new_with_label_from_widget()` is also provided.

To retrieve the group a **Gnome::Gtk3::RadioButton** is assigned to, use `gtk_radio_button_get_group()`.

To remove a **Gnome::Gtk3::RadioButton** from one group and make it part of a new one, use `gtk_radio_button_set_group()`.

The group list does not need to be freed, as each **Gnome::Gtk3::RadioButton** will remove itself and its list item when it is destroyed.

Css Nodes
---------

    radiobutton
    ├── radio
    ╰── <child>

A **Gnome::Gtk3::RadioButton** with indicator (see `gtk_toggle_button_set_mode()`) has a main CSS node with name radiobutton and a subnode with name radio.

    button.radio
    ├── radio
    ╰── <child>

A **Gnome::Gtk3::RadioButton** without indicator changes the name of its main node to button and adds a .radio style class to it. The subnode is invisible in this case.

When an unselected button in the group is clicked the clicked button receives the *toggled* signal, as does the previously selected button. Inside the *toggled* handler, `gtk_toggle_button_get_active()` can be used to determine if the button has been selected or deselected.

Implemented Interfaces
----------------------

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * Gnome::Gtk3::Actionable

  * Gnome::Gtk3::Activatable

See Also
--------

**Gnome::Gtk3::ComboBox**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RadioButton;
    also is Gnome::Gtk3::CheckButton;
    also does Gnome::Gtk3::Buildable;

Example
-------

Create a group with two radio buttons

    # Create a top level window and set a title
    my Gnome::Gtk3::Window $top-window .= new(:title('Two Radio Buttons'));
    $top-window.set-border-width(20);

    # Create a grid and add it to the window
    my Gnome::Gtk3::Grid $grid .= new(:empty);
    $top-window.gtk-container-add($grid);

    # Creat the radio buttons
    my Gnome::Gtk3::RadioButton $rb1 .= new(:label('Radio One'));
    my Gnome::Gtk3::RadioButton $rb2 .= new(
      :group-from($rb1), :label('Radio Two')
    );

    # First button selected
    $rb1.set-active(1);

    # Add radio buttons to the grid
    $grid.gtk-grid-attach( $rb1, 0, 0, 1, 1);
    $grid.gtk-grid-attach( $rb2, 0, 1, 1, 1);

    # Show everything and activate all
    $top-window.show-all;

Methods
=======

Create a new plain object.

    multi method new ( Bool :empty! )

Create a new object and add to the group defined by the list.

    multi method new ( Gnome::Glib::SList :$group!, Str :$label! )

Create a new object and add to the group defined by another radio button object.

    multi method new ( Gnome::Gtk3::RadioButton :$group-from!, Str :$label! )

Create a new object with a label.

    multi method new ( Str :$label! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] radio_button_new
-----------------------

Creates a new **Gnome::Gtk3::RadioButton**. To be of any practical value, a widget should then be packed into the radio button.

Returns: a new radio button

    method gtk_radio_button_new ( N-GSList $group --> N-GObject  )

  * N-GSList $group; (element-type **Gnome::Gtk3::RadioButton**) (allow-none): an existing radio button group, or `Any` if you are creating a new group.

[[gtk_] radio_button_] new_from_widget
--------------------------------------

Creates a new **Gnome::Gtk3::RadioButton**, adding it to the same group as *radio_group_member*. As with `gtk_radio_button_new()`, a widget should be packed into the radio button.

Returns: (transfer none): a new radio button.

    method gtk_radio_button_new_from_widget ( --> N-GObject  )

[[gtk_] radio_button_] new_with_label
-------------------------------------

Creates a new **Gnome::Gtk3::RadioButton** with a text label.

Returns: a new radio button.

    method gtk_radio_button_new_with_label ( N-GSList $group, Str $label --> N-GObject  )

  * N-GSList $group; (element-type **Gnome::Gtk3::RadioButton**) (allow-none): an existing radio button group, or `Any` if you are creating a new group.

  * Str $label; the text label to display next to the radio button.

[[gtk_] radio_button_] new_with_label_from_widget
-------------------------------------------------

Creates a new **Gnome::Gtk3::RadioButton** with a text label, adding it to the same group.

Returns: (transfer none): a new radio button.

    method gtk_radio_button_new_with_label_from_widget ( Str $label --> N-GObject  )

  * Str $label; a text string to display next to the radio button.

[[gtk_] radio_button_] new_with_mnemonic
----------------------------------------

Creates a new **Gnome::Gtk3::RadioButton** containing a label, adding it to the same group as *group*. The label will be created using `gtk_label_new_with_mnemonic()`, so underscores in *label* indicate the mnemonic for the button.

Returns: a new **Gnome::Gtk3::RadioButton**

    method gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label --> N-GObject  )

  * N-GSList $group; (element-type **Gnome::Gtk3::RadioButton**) (allow-none): the radio button group, or `Any`

  * Str $label; the text of the button, with an underscore in front of the mnemonic character

[[gtk_] radio_button_] new_with_mnemonic_from_widget
----------------------------------------------------

Creates a new **Gnome::Gtk3::RadioButton** containing a label. The label will be created using `gtk_label_new_with_mnemonic()`, so underscores in *label* indicate the mnemonic for the button.

Returns: (transfer none): a new **Gnome::Gtk3::RadioButton**

    method gtk_radio_button_new_with_mnemonic_from_widget ( Str $label --> N-GObject  )

  * Str $label; the text of the button, with an underscore in front of the mnemonic character

[[gtk_] radio_button_] get_group
--------------------------------

Retrieves the group assigned to a radio button.

Returns: (element-type **Gnome::Gtk3::RadioButton**) (transfer none): a linked list containing all the radio buttons in the same group as *radio_button*. The returned list is owned by the radio button and must not be modified or freed.

    method gtk_radio_button_get_group ( --> N-GSList  )

[[gtk_] radio_button_] set_group
--------------------------------

Sets a **Gnome::Gtk3::RadioButton**’s group. It should be noted that this does not change the layout of your interface in any way, so if you are changing the group, it is likely you will need to re-arrange the user interface to reflect these changes.

    method gtk_radio_button_set_group ( N-GSList $group )

  * N-GSList $group; (element-type **Gnome::Gtk3::RadioButton**) (allow-none): an existing radio button group, such as one returned from `gtk_radio_button_get_group()`, or `Any`.

[[gtk_] radio_button_] join_group
---------------------------------

Joins a **Gnome::Gtk3::RadioButton** object to the group of another **Gnome::Gtk3::RadioButton** object

Use this in language bindings instead of the `gtk_radio_button_get_group()` and `gtk_radio_button_set_group()` methods

Since: 3.0

    method gtk_radio_button_join_group ( N-GObject $group_source )

  * N-GObject $group_source; (allow-none): a radio button object whos group we are joining, or `Any` to remove the radio button from its group

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

Emitted when the group of radio buttons that a radio button belongs to changes. This is emitted when a radio button switches from being alone to being part of a group of 2 or more buttons, or vice-versa, and when a button is moved from one group of 2 or more buttons to a different one, but not when the composition of the group that a button belongs to changes.

Since: 2.4

    method handler (
      Gnome::GObject::Object :widget($button),
      *%user-options
    );

  * $button; the object which received the signal

