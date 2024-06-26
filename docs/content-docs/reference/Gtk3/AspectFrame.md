Gnome::Gtk3::AspectFrame
========================

A frame that constrains its child to a particular aspect ratio

Description
===========

The **Gnome::Gtk3::AspectFrame** is useful when you want pack a widget so that it can resize but always retains the same aspect ratio. For instance, one might be drawing a small preview of a larger image. **Gnome::Gtk3::AspectFrame** derives from **Gnome::Gtk3::Frame**, so it can draw a label and a frame around the child. The frame will be “shrink-wrapped” to the size of the child.

Css Nodes
---------

**Gnome::Gtk3::AspectFrame** uses a CSS node with name frame.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AspectFrame;
    also is Gnome::Gtk3::Frame;

Uml Diagram
-----------

![](plantuml/AspectFrame.svg)

Methods
=======

new
---

### :label, :xalign, :yalign, :ratio, :obey-child

Create a new AspectFrame with all bells and wistles.

    multi method new (
      Str :$label!, Num :$xalign = 0.0e0, Num :$yalign = 0.0e0,
      Num :$ratio = 1.0e0, Bool :$obey-child?
    )

  * $label; Label text.

  * $xalign; Horizontal alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (left aligned) to 1.0 (right aligned). By default set to 0.0.

  * $yalign; Vertical alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned). By default set to 0.0.

  * $ratio; The desired aspect ratio. By default set to 1.0.

  * $obey_child; If `True`, *ratio* is ignored, and the aspect ratio is taken from the requistion of the child. By default set to False if $ratio is defined or True if it isn't.

### :native-object

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelSupportClass**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

set
---

Set parameters for an existing **Gnome::Gtk3::AspectFrame**.

    method set (
      Num $xalign, Num $yalign, Num $ratio, Int $obey_child
    )

  * $xalign; Horizontal alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (left aligned) to 1.0 (right aligned)

  * $yalign; Vertical alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)

  * $ratio; The desired aspect ratio.

  * $obey_child; If `1`, *ratio* is ignored, and the aspect ratio is taken from the requistion of the child.

Properties
==========

obey-child
----------

Force aspect ratio to match that of the frame's child

The **Gnome::GObject::Value** type of property *obey-child* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is TRUE.

ratio
-----

Aspect ratio if obey_child is FALSE

The **Gnome::GObject::Value** type of property *ratio* is `G_TYPE_FLOAT`.

  * Parameter is readable and writable.

  * Minimum value is MIN_RATIO.

  * Maximum value is MAX_RATIO.

  * Default value is 1.0.

xalign
------

X alignment of the child

The **Gnome::GObject::Value** type of property *xalign* is `G_TYPE_FLOAT`.

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.5.

yalign
------

Y alignment of the child

The **Gnome::GObject::Value** type of property *yalign* is `G_TYPE_FLOAT`.

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.5.

