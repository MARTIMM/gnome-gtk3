Gnome::Gtk3::AspectFrame
========================

A frame that constrains its child to a particular aspect ratio

Description
===========

The **Gnome::Gtk3::AspectFrame** is useful when you want pack a widget so that it can resize but always retains the same aspect ratio. For instance, one might be drawing a small preview of a larger image. **Gnome::Gtk3::AspectFrame** derives from **Gnome::Gtk3::Frame**, so it can draw a label and a frame around the child. The frame will be “shrink-wrapped” to the size of the child.

Css Nodes
---------

**Gnome::Gtk3::AspectFrame** uses a CSS node with name frame.

Implemented Interfaces
----------------------

Gnome::Gtk3::AspectFrame implements

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AspectFrame;
    also is Gnome::Gtk3::Frame;

Methods
=======

new
---

Create a new AspectFrame with all bells and wistles.

    multi method new (
      Str :$label!, Num :$xalign?, Num :$yalign?, Num :$ratio>?,
      Bool :$obey-child?
    )

  * Str $label; Label text.

  * Num $xalign; Horizontal alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (left aligned) to 1.0 (right aligned). By default set to 0.0.

  * Num $yalign; Vertical alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned). By default set to 0.0.

  * Num $ratio; The desired aspect ratio. By default set to 1.0.

  * Int $obey_child; If `True`, *ratio* is ignored, and the aspect ratio is taken from the requistion of the child. By default set to False if $ratio is defined or True if it isn't.

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_aspect_frame_new
--------------------

Create a new **Gnome::Gtk3::AspectFrame**.

Returns: the new **Gnome::Gtk3::AspectFrame**.

    method gtk_aspect_frame_new ( Str $label, Num $xalign, Num $yalign, Num $ratio, Int $obey_child --> N-GObject )

  * Str $label; (allow-none): Label text.

  * Num $xalign; Horizontal alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (left aligned) to 1.0 (right aligned)

  * Num $yalign; Vertical alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)

  * Num $ratio; The desired aspect ratio.

  * Int $obey_child; If `1`, *ratio* is ignored, and the aspect ratio is taken from the requistion of the child.

gtk_aspect_frame_set
--------------------

Set parameters for an existing **Gnome::Gtk3::AspectFrame**.

    method gtk_aspect_frame_set ( Num $xalign, Num $yalign, Num $ratio, Int $obey_child )

  * Num $xalign; Horizontal alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (left aligned) to 1.0 (right aligned)

  * Num $yalign; Vertical alignment of the child within the allocation of the **Gnome::Gtk3::AspectFrame**. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)

  * Num $ratio; The desired aspect ratio.

  * Int $obey_child; If `1`, *ratio* is ignored, and the aspect ratio is taken from the requistion of the child.

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Horizontal Alignment

X alignment of the child.

The **Gnome::GObject::Value** type of property *xalign* is `G_TYPE_FLOAT`.

### Vertical Alignment

Y alignment of the child.

The **Gnome::GObject::Value** type of property *yalign* is `G_TYPE_FLOAT`.

### Ratio

Aspect ratio if obey_child is FALSE.

The **Gnome::GObject::Value** type of property *ratio* is `G_TYPE_FLOAT`.

### Obey child

Force aspect ratio to match that of the frame's child Default value: True

The **Gnome::GObject::Value** type of property *obey-child* is `G_TYPE_BOOLEAN`.

