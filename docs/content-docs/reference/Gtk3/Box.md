Gnome::Gtk3::Box
================

A container box for packing widgets in a single row or column

Description
===========

The **Gnome::Gtk3::Box** widget arranges child widgets into a single row or column, depending upon the value of its *orientation* property. Within the other dimension, all children are allocated the same size. Of course, the *halign* and *valign* properties can be used on the children to influence their allocation.

**Gnome::Gtk3::Box** uses a notion of packing. Packing refers to adding widgets with reference to a particular position in a **Gnome::Gtk3::Container**. For a **Gnome::Gtk3::Box**, there are two reference positions: the start and the end of the box. For a vertical **Gnome::Gtk3::Box**, the start is defined as the top of the box and the end is defined as the bottom. For a horizontal **Gnome::Gtk3::Box** the start is defined as the left side and the end is defined as the right side.

Use repeated calls to `pack-start()` to pack widgets into a **Gnome::Gtk3::Box** from start to end. Use `gtk-box-pack-end()` to add widgets from end to start. You may intersperse these calls and add widgets from both ends of the same **Gnome::Gtk3::Box**.

Because **Gnome::Gtk3::Box** is a **Gnome::Gtk3::Container**, you may also use `gtk-container-add()` to insert widgets into the box, and they will be packed with the default values for expand and fill child properties. Use `gtk-container-remove()` to remove widgets from the **Gnome::Gtk3::Box**.

Use `gtk-box-set-homogeneous()` to specify whether or not all children of the **Gnome::Gtk3::Box** are forced to get the same amount of space.

Use `gtk-box-set-spacing()` to determine how much space will be minimally placed between all children in the **Gnome::Gtk3::Box**. Note that spacing is added between the children, while padding added by `gtk-box-pack-start()` or `gtk-box-pack-end()` is added on either side of the widget it belongs to.

Use `gtk-box-reorder-child()` to move a **Gnome::Gtk3::Box** child to a different place in the box.

Use `gtk-box-set-child-packing()` to reset the expand, fill and padding child properties. Use `gtk-box-query-child-packing()` to query these fields.

Css Nodes
---------

**Gnome::Gtk3::Box** uses a single CSS node with name box.

In horizontal orientation, the nodes of the children are always arranged from left to right. So `first-child` will always select the leftmost child, regardless of text direction.

Implemented Interfaces
----------------------

  * [Gnome::Gtk3::Orientable](Orientable.html)

See Also
--------

**Gnome::Gtk3::Frame**, **Gnome::Gtk3::Grid**, **Gnome::Gtk3::Layout**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Box;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Orientable;

Methods
=======

new
---

### default, no options

Create a new plain object growing horizontally. Default spacing between inserted widgets is by default 0 pixels.

    multi method new ( )

### :spacing

Create a new plain object growing horizontally. Specify spacing between inserted widgets with `:spacing`.

    multi method new ( Int() :$spacing )

### :orientation, :spacing

Create a new plain object using orientation for extension of the container.

    multi method new (
      GtkOrientation :$orientation!, Int() :$spacing = 0
    )

### :native-object

Create a Box object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Box object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-baseline-position
---------------------

Gets the value set by `set-baseline-position()`.

Returns: the baseline position

    method get-baseline-position ( --> GtkBaselinePosition )

get-center-widget, get-center-widget-rk
---------------------------------------

Retrieves the center widget of the box.

Returns: the center widget or `undefined` in case no center widget is set.

    method get-center-widget ( --> N-GObject )
    method get-center-widget ( --> Gnome::GObject::Object )

get-homogeneous
---------------

Returns whether the box is homogeneous (all children are the same size). See `set-homogeneous()`.

Returns: `True` if the box is homogeneous.

    method get-homogeneous ( --> Bool )

get-spacing
-----------

Gets the value set by `set-spacing()`.

Returns: spacing between children

    method get-spacing ( --> Int )

pack-end
--------

Adds *child* to *box*, packed with reference to the end of *box*. The *child* is packed after (away from end of) any other child packed with reference to the end of *box*.

    method pack-end (
      N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
    )

  * $child; the **Gnome::Gtk3::Widget** to be added to *box*

  * $expand; `True` if the new child is to be given extra space allocated to *box*. The extra space will be divided evenly between all children of *box* that use this option

  * $fill; `True` if space given to *child* by the *expand* option is actually allocated to *child*, rather than just padding it. This parameter has no effect if *expand* is set to `False`. A child is always allocated the full height of a horizontal **Gnome::Gtk3::Box** and the full width of a vertical **Gnome::Gtk3::Box**. This option affects the other dimension

  * $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by *spacing* property. If *child* is a widget at one of the reference ends of *box*, then *padding* pixels are also put between *child* and the reference edge of *box*

pack-start
----------

Adds *child* to *box*, packed with reference to the start of *box*. The *child* is packed after any other child packed with reference to the start of *box*.

    method pack-start (
      N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
    )

  * $child; the **Gnome::Gtk3::Widget** to be added to *box*

  * $expand; `True` if the new child is to be given extra space allocated to *box*. The extra space will be divided evenly between all children that use this option

  * $fill; `True` if space given to *child* by the *expand* option is actually allocated to *child*, rather than just padding it. This parameter has no effect if *expand* is set to `False`. A child is always allocated the full height of a horizontal **Gnome::Gtk3::Box** and the full width of a vertical **Gnome::Gtk3::Box**. This option affects the other dimension

  * $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by *spacing* property. If *child* is a widget at one of the reference ends of *box*, then *padding* pixels are also put between *child* and the reference edge of *box*

query-child-packing
-------------------

Obtains information about how *child* is packed into *box*.

    method query-child-packing ( N-GObject() $child --> List )

  * $child; the **Gnome::Gtk3::Widget** of the child to query

The returned List contains;

  * $expand; expand child property

  * $fill; fill child property

  * $padding; padding child property

  * $pack_type; pack-type child property

reorder-child
-------------

Moves *child* to a new *position* in the list of *box* children. The list contains widgets packed `GTK-PACK-START` as well as widgets packed `GTK-PACK-END`, in the order that these widgets were added to *box*.

A widget’s position in the *box* children list determines where the widget is packed into *box*. A child widget at some position in the list will be packed just after all other widgets of the same packing type that appear earlier in the list.

    method reorder-child ( N-GObject() $child, Int() $position )

  * $child; the **Gnome::Gtk3::Widget** to move

  * $position; the new position for *child* in the list of children of *box*, starting from 0. If negative, indicates the end of the list

set-baseline-position
---------------------

Sets the baseline position of a box. This affects only horizontal boxes with at least one baseline aligned child. If there is more vertical space available than requested, and the baseline is not allocated by the parent then *position* is used to allocate the baseline wrt the extra space available.

    method set-baseline-position ( GtkBaselinePosition $position )

  * $position; a **Gnome::Gtk3::BaselinePosition**

set-center-widget
-----------------

Sets a center widget; that is a child widget that will be centered with respect to the full width of the box, even if the children at either side take up different amounts of space.

    method set-center-widget ( N-GObject() $widget )

  * $widget; the widget to center

set-child-packing
-----------------

Sets the way *child* is packed into *box*.

    method set-child-packing (
      N-GObject() $child, Bool $expand, Bool $fill,
      UInt $padding, GtkPackType $pack_type
    )

  * $child; the **Gnome::Gtk3::Widget** of the child to set

  * $expand; the new value of the expand child property

  * $fill; the new value of the fill child property

  * $padding; the new value of the padding child property

  * $pack_type; the new value of the pack-type child property

set-homogeneous
---------------

Sets the *homogeneous* property of *box*, controlling whether or not all children of *box* are given equal space in the box.

    method set-homogeneous ( Bool $homogeneous )

  * $homogeneous; a boolean value, `True` to create equal allotments, `False` for variable allotments

set-spacing
-----------

Sets the *spacing* property of *box*, which is the number of pixels to place between children of *box*.

    method set-spacing ( Int() $spacing )

  * $spacing; the number of pixels to put between children

Properties
==========

baseline-position
-----------------

The position of the baseline aligned widgets if extra space is available

The **Gnome::GObject::Value** type of property *baseline-position* is `G_TYPE_ENUM`.

  * Parameter is readable and writable.

  * Default value is GTK_BASELINE_POSITION_CENTER.

expand
------

Whether the child should receive extra space when the parent grows

The **Gnome::GObject::Value** type of property *expand* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

fill
----

Whether extra space given to the child should be allocated to the child or used as padding

The **Gnome::GObject::Value** type of property *fill* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is TRUE.

homogeneous
-----------

Whether the children should all be the same size

The **Gnome::GObject::Value** type of property *homogeneous* is `G_TYPE_BOOLEAN`.

  * Parameter is readable and writable.

  * Default value is FALSE.

pack-type
---------

A GtkPackType indicating whether the child is packed with reference to the start or end of the parent

The **Gnome::GObject::Value** type of property *pack-type* is `G_TYPE_ENUM`.

  * Parameter is readable and writable.

  * Default value is GTK_PACK_START.

padding
-------

Extra space to put between the child and its neighbors, in pixels

The **Gnome::GObject::Value** type of property *padding* is `G_TYPE_UINT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXINT.

  * Default value is 0.

position
--------

The index of the child in the parent

The **Gnome::GObject::Value** type of property *position* is `G_TYPE_INT`.

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is 0.

spacing
-------

The amount of space between children

The **Gnome::GObject::Value** type of property *spacing* is `G_TYPE_INT`.

  * Parameter is readable and writable.

  * Minimum value is 0.

  * Maximum value is G_MAXINT.

  * Default value is 0.

