Gnome::Gtk3::StackSwitcher
==========================

A controller for **Gnome::Gtk3::Stack**

![](images/stackswitcher.png)

Description
===========

The **Gnome::Gtk3::StackSwitcher** widget acts as a controller for a **Gnome::Gtk3::Stack**; it shows a row of buttons to switch between the various pages of the associated stack widget.

All the content for the buttons comes from the child properties of the **Gnome::Gtk3::Stack**; the button visibility in a **Gnome::Gtk3::StackSwitcher** widget is controlled by the visibility of the child in the **Gnome::Gtk3::Stack**.

It is possible to associate multiple **Gnome::Gtk3::StackSwitcher** widgets with the same **Gnome::Gtk3::Stack** widget.

The **Gnome::Gtk3::StackSwitcher** widget was added in 3.10.

Css Nodes
---------

**Gnome::Gtk3::StackSwitcher** has a single CSS node named stackswitcher and style class .stack-switcher.

When circumstances require it, **Gnome::Gtk3::StackSwitcher** adds the .needs-attention style class to the widgets representing the stack pages.

See Also
--------

**Gnome::Gtk3::Stack**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::StackSwitcher;
    also is Gnome::Gtk3::Box;

Methods
=======

new
---

Create a new StackSwitcher object.

    multi method new ( )

Create a StackSwitcher object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a StackSwitcher object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] stack_switcher_new
-------------------------

Create a new **Gnome::Gtk3::StackSwitcher**.

Returns: a new **Gnome::Gtk3::StackSwitcher**.

Since: 3.10

    method gtk_stack_switcher_new ( --> N-GObject )

[[gtk_] stack_switcher_] set_stack
----------------------------------

Sets the stack to control.

Since: 3.10

    method gtk_stack_switcher_set_stack ( N-GObject $stack )

  * N-GObject $stack; a **Gnome::Gtk3::Stack**

[[gtk_] stack_switcher_] get_stack
----------------------------------

Retrieves the stack, or `Any` if none has been set explicitly. See `gtk_stack_switcher_set_stack()`.

Since: 3.10

    method gtk_stack_switcher_get_stack ( --> N-GObject )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Icon Size

Use the "icon-size" property to change the size of the image displayed when a **Gnome::Gtk3::StackSwitcher** is displaying icons.

Since: 3.20

The **Gnome::GObject::Value** type of property *icon-size* is `G_TYPE_INT`.

### Stack

Stack

The **Gnome::GObject::Value** type of property *stack* is `G_TYPE_OBJECT`.

