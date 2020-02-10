Gnome::Gtk3::Stack
==================

A stacking container

![](images/stack.png)

Description
===========

The **Gnome::Gtk3::Stack** widget is a container which only shows one of its children at a time. In contrast to **Gnome::Gtk3::Notebook**, **Gnome::Gtk3::Stack** does not provide a means for users to change the visible child. Instead, the **Gnome::Gtk3::StackSwitcher** widget can be used with **Gnome::Gtk3::Stack** to provide this functionality.

Transitions between pages can be animated as slides or fades. This can be controlled with `gtk_stack_set_transition_type()`. These animations respect the *gtk-enable-animations* setting.

The **Gnome::Gtk3::Stack** widget was added in GTK+ 3.10.

Css Nodes
---------

**Gnome::Gtk3::Stack** has a single CSS node named stack.

Implemented Interfaces
----------------------

Gnome::Gtk3::Stack implements

See Also
--------

**Gnome::Gtk3::Notebook**, **Gnome::Gtk3::StackSwitcher**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Stack;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Buildable;

Types
=====

enum GtkStackTransitionType
---------------------------

These enumeration values describe the possible transitions between pages in a GtkStack widget.

New values may be added to this enumeration over time.

Methods
=======

new
---

Create a new Stack object.

    multi method new ( )

Create a Stack object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a Stack object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_stack_new
-------------

Creates a new **Gnome::Gtk3::Stack** container.

Since: 3.10

    method gtk_stack_new ( --> N-GObject )

[gtk_stack_] add_named
----------------------

Adds a child to *stack*. The child is identified by the *name*.

Since: 3.10

    method gtk_stack_add_named ( N-GObject $child, Str $name )

  * N-GObject $child; the widget to add

  * Str $name; the name for *child*

[gtk_stack_] add_titled
-----------------------

Adds a child to *stack*. The child is identified by the *name*. The *title* will be used by **Gnome::Gtk3::StackSwitcher** to represent *child* in a tab bar, so it should be short.

Since: 3.10

    method gtk_stack_add_titled ( N-GObject $child, Str $name, Str $title )

  * N-GObject $child; the widget to add

  * Str $name; the name for *child*

  * Str $title; a human-readable title for *child*

[gtk_stack_] get_child_by_name
------------------------------

Finds the child of the **Gnome::Gtk3::Stack** with the name given as the argument. Returns `Any` if there is no child with this name.

Returns: (transfer none) (nullable): the requested child of the **Gnome::Gtk3::Stack**

Since: 3.12

    method gtk_stack_get_child_by_name ( Str $name --> N-GObject )

  * Str $name; the name of the child to find

[gtk_stack_] set_visible_child
------------------------------

Makes *child* the visible child of *stack*.

If *child* is different from the currently visible child, the transition between the two will be animated with the current transition type of *stack*.

Note that the *child* widget has to be visible itself (see `gtk_widget_show()`) in order to become the visible child of *stack*.

Since: 3.10

    method gtk_stack_set_visible_child ( N-GObject $child )

  * N-GObject $child; a child of *stack*

[gtk_stack_] get_visible_child
------------------------------

Gets the currently visible child of *stack*, or `Any` if there are no visible children.

Returns: (transfer none) (nullable): the visible child of the **Gnome::Gtk3::Stack**

Since: 3.10

    method gtk_stack_get_visible_child ( --> N-GObject )

[gtk_stack_] set_visible_child_name
-----------------------------------

Makes the child with the given name visible.

If *child* is different from the currently visible child, the transition between the two will be animated with the current transition type of *stack*.

Note that the child widget has to be visible itself (see `gtk_widget_show()`) in order to become the visible child of *stack*.

Since: 3.10

    method gtk_stack_set_visible_child_name ( Str $name )

  * Str $name; the name of the child to make visible

[gtk_stack_] get_visible_child_name
-----------------------------------

Returns the name of the currently visible child of *stack*, or `Any` if there is no visible child.

Returns: (transfer none) (nullable): the name of the visible child of the **Gnome::Gtk3::Stack**

Since: 3.10

    method gtk_stack_get_visible_child_name ( --> Str )

[gtk_stack_] set_visible_child_full
-----------------------------------

Makes the child with the given name visible.

Note that the child widget has to be visible itself (see `gtk_widget_show()`) in order to become the visible child of *stack*.

Since: 3.10

    method gtk_stack_set_visible_child_full ( Str $name, GtkStackTransitionType $transition )

  * Str $name; the name of the child to make visible

  * GtkStackTransitionType $transition; the transition type to use

[gtk_stack_] set_homogeneous
----------------------------

Sets the **Gnome::Gtk3::Stack** to be homogeneous or not. If it is homogeneous, the **Gnome::Gtk3::Stack** will request the same size for all its children. If it isn't, the stack may change size when a different child becomes visible.

Since 3.16, homogeneity can be controlled separately for horizontal and vertical size, with the *hhomogeneous* and *vhomogeneous*.

Since: 3.10

    method gtk_stack_set_homogeneous ( Int $homogeneous )

  * Int $homogeneous; `1` to make *stack* homogeneous

[gtk_stack_] get_homogeneous
----------------------------

Gets whether *stack* is homogeneous. See `gtk_stack_set_homogeneous()`.

Returns: whether *stack* is homogeneous.

Since: 3.10

    method gtk_stack_get_homogeneous ( --> Int )

[gtk_stack_] set_hhomogeneous
-----------------------------

Sets the **Gnome::Gtk3::Stack** to be horizontally homogeneous or not. If it is homogeneous, the **Gnome::Gtk3::Stack** will request the same width for all its children. If it isn't, the stack may change width when a different child becomes visible.

Since: 3.16

    method gtk_stack_set_hhomogeneous ( Int $hhomogeneous )

  * Int $hhomogeneous; `1` to make *stack* horizontally homogeneous

[gtk_stack_] get_hhomogeneous
-----------------------------

Gets whether *stack* is horizontally homogeneous. See `gtk_stack_set_hhomogeneous()`.

Returns: whether *stack* is horizontally homogeneous.

Since: 3.16

    method gtk_stack_get_hhomogeneous ( --> Int )

[gtk_stack_] set_vhomogeneous
-----------------------------

Sets the **Gnome::Gtk3::Stack** to be vertically homogeneous or not. If it is homogeneous, the **Gnome::Gtk3::Stack** will request the same height for all its children. If it isn't, the stack may change height when a different child becomes visible.

Since: 3.16

    method gtk_stack_set_vhomogeneous ( Int $vhomogeneous )

  * Int $vhomogeneous; `1` to make *stack* vertically homogeneous

[gtk_stack_] get_vhomogeneous
-----------------------------

Gets whether *stack* is vertically homogeneous. See `gtk_stack_set_vhomogeneous()`.

Returns: whether *stack* is vertically homogeneous.

Since: 3.16

    method gtk_stack_get_vhomogeneous ( --> Int )

[gtk_stack_] set_transition_duration
------------------------------------

Sets the duration that transitions between pages in *stack* will take.

Since: 3.10

    method gtk_stack_set_transition_duration ( UInt $duration )

  * UInt $duration; the new duration, in milliseconds

[gtk_stack_] get_transition_duration
------------------------------------

Returns the amount of time (in milliseconds) that transitions between pages in *stack* will take.

Returns: the transition duration

Since: 3.10

    method gtk_stack_get_transition_duration ( --> UInt )

[gtk_stack_] set_transition_type
--------------------------------

Sets the type of animation that will be used for transitions between pages in *stack*. Available types include various kinds of fades and slides.

The transition type can be changed without problems at runtime, so it is possible to change the animation based on the page that is about to become current.

Since: 3.10

    method gtk_stack_set_transition_type ( GtkStackTransitionType $transition )

  * GtkStackTransitionType $transition; the new transition type

[gtk_stack_] get_transition_type
--------------------------------

Gets the type of animation that will be used for transitions between pages in *stack*.

Returns: the current transition type of *stack*

Since: 3.10

    method gtk_stack_get_transition_type ( --> GtkStackTransitionType )

[gtk_stack_] get_transition_running
-----------------------------------

Returns whether the *stack* is currently in a transition from one page to another.

Returns: `1` if the transition is currently running, `0` otherwise.

Since: 3.12

    method gtk_stack_get_transition_running ( --> Int )

[gtk_stack_] set_interpolate_size
---------------------------------

Sets whether or not *stack* will interpolate its size when changing the visible child. If the *interpolate-size* property is set to `1`, *stack* will interpolate its size between the current one and the one it'll take after changing the visible child, according to the set transition duration.

Since: 3.18

    method gtk_stack_set_interpolate_size ( Int $interpolate_size )

  * Int $interpolate_size; the new value

[gtk_stack_] get_interpolate_size
---------------------------------

Returns wether the **Gnome::Gtk3::Stack** is set up to interpolate between the sizes of children on page switch.

Returns: `1` if child sizes are interpolated

Since: 3.18

    method gtk_stack_get_interpolate_size ( --> Int )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Homogeneous

Homogeneous sizing Default value: True

The **Gnome::GObject::Value** type of property *homogeneous* is `G_TYPE_BOOLEAN`.

### Horizontally homogeneous

`1` if the stack allocates the same width for all children. Since: 3.16

The **Gnome::GObject::Value** type of property *hhomogeneous* is `G_TYPE_BOOLEAN`.

### Vertically homogeneous

`1` if the stack allocates the same height for all children. Since: 3.16

The **Gnome::GObject::Value** type of property *vhomogeneous* is `G_TYPE_BOOLEAN`.

### Visible child

The widget currently visible in the stack Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *visible-child* is `G_TYPE_OBJECT`.

### Name of visible child

The name of the widget currently visible in the stack Default value: Any

The **Gnome::GObject::Value** type of property *visible-child-name* is `G_TYPE_STRING`.

### Transition duration

The **Gnome::GObject::Value** type of property *transition-duration* is `G_TYPE_UINT`.

### Transition type

The type of animation used to transition Default value: False

The **Gnome::GObject::Value** type of property *transition-type* is `G_TYPE_ENUM`.

### Transition running

Whether or not the transition is currently running Default value: False

The **Gnome::GObject::Value** type of property *transition-running* is `G_TYPE_BOOLEAN`.

### Interpolate size

Whether or not the size should smoothly change when changing between differently sized children Default value: False

The **Gnome::GObject::Value** type of property *interpolate-size* is `G_TYPE_BOOLEAN`.

### Name

The name of the child page Default value: Any

The **Gnome::GObject::Value** type of property *name* is `G_TYPE_STRING`.

### Title

The title of the child page Default value: Any

The **Gnome::GObject::Value** type of property *title* is `G_TYPE_STRING`.

### Icon name

The icon name of the child page Default value: Any

The **Gnome::GObject::Value** type of property *icon-name* is `G_TYPE_STRING`.

### Position

The **Gnome::GObject::Value** type of property *position* is `G_TYPE_INT`.

### Needs Attention

Sets a flag specifying whether the child requires the user attention. This is used by the **Gnome::Gtk3::StackSwitcher** to change the appearance of the corresponding button when a page needs attention and it is not the current one. Since: 3.12

The **Gnome::GObject::Value** type of property *needs-attention* is `G_TYPE_BOOLEAN`.

