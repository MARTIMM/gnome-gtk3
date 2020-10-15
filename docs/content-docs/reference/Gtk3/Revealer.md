Gnome::Gtk3::Revealer
=====================

Hide and show a widget with animation.

Description
===========

The **Gnome::Gtk3::Revealer** widget is a container which animates the transition of its child from invisible to visible. The style of transition can be controlled with `gtk_revealer_set_transition_type()`. These animations respect the *gtk-enable-animations* setting.

CSS nodes
---------

**Gnome::Gtk3::Revealer** has a single CSS node with name revealer.

See Also
--------

**Gnome::Gtk3::Expander**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Revealer;
    also is Gnome::Gtk3::Bin;

Types
=====

GtkRevealerTransitionType
-------------------------

These enumeration values describe the possible transitions when the child of a GtkRevealer widget is shown or hidden.

  * GTK_REVEALER_TRANSITION_TYPE_NONE; No transition

  * GTK_REVEALER_TRANSITION_TYPE_CROSSFADE; Fade in

  * GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT; Slide in from the left

  * GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT; Slide in from the right

  * GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP; Slide in from the bottom

  * GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN; Slide in from the top

Methods
=======

new
---

### new()

Creates a new **Gnome::Gtk3::Revealer**.

    multi method new ( )

[[gtk_] revealer_] get_reveal_child
-----------------------------------

Returns whether the child is currently revealed. See `gtk_revealer_set_reveal_child()`. This function returns `1` as soon as the transition to the revealed state is started. To learn whether the child is fully revealed (ie the transition is completed), use `gtk_revealer_get_child_revealed()`.

Returns: `1` if the child is revealed.

    method gtk_revealer_get_reveal_child ( --> Int )

[[gtk_] revealer_] set_reveal_child
-----------------------------------

Tells the **Gnome::Gtk3::Revealer** to reveal or conceal its child. The transition will be animated with the current transition type of the *revealer*.

    method gtk_revealer_set_reveal_child ( Bool $reveal_child )

  * Int $reveal_child; `True` to reveal the child

[[gtk_] revealer_] get_child_revealed
-------------------------------------

Returns whether the child is fully revealed, in other words whether the transition to the revealed state is completed.

    method gtk_revealer_get_child_revealed ( --> Int )

[[gtk_] revealer_] get_transition_duration
------------------------------------------

Returns the amount of time (in milliseconds) that transitions will take.

    method gtk_revealer_get_transition_duration ( --> UInt )

[[gtk_] revealer_] set_transition_duration
------------------------------------------

Sets the duration that transitions will take.

    method gtk_revealer_set_transition_duration ( UInt $duration )

  * UInt $duration; the new duration, in milliseconds

[[gtk_] revealer_] set_transition_type
--------------------------------------

Sets the type of animation that will be used for transitions in *revealer*. Available types include various kinds of fades and slides.

    method gtk_revealer_set_transition_type (
      GtkRevealerTransitionType $transition
    )

  * GtkRevealerTransitionType $transition; the new transition type

[[gtk_] revealer_] get_transition_type
--------------------------------------

Gets the type of animation that will be used for transitions in *revealer*.

    method gtk_revealer_get_transition_type ( --> GtkRevealerTransitionType )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

#-------------------------------------------------------------------------------

### Transition type

The type of animation used to transition Default value: False.

The **Gnome::GObject::Value** type of property *transition-type* is `G_TYPE_ENUM`.

#-------------------------------------------------------------------------------

### Transition duration

The animation duration, in milliseconds.

The **Gnome::GObject::Value** type of property *transition-duration* is `G_TYPE_UINT`.

#-------------------------------------------------------------------------------

### Reveal Child

Whether the container should reveal the child Default value: False.

The **Gnome::GObject::Value** type of property *reveal-child* is `G_TYPE_BOOLEAN`.

#-------------------------------------------------------------------------------

### Child Revealed

Whether the child is revealed and the animation target reached Default value: False.

The **Gnome::GObject::Value** type of property *child-revealed* is `G_TYPE_BOOLEAN`.

