Gnome::Gtk3::Border
===================

Description
===========

A struct that specifies a border around a rectangular area that can be of different width on each side.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Border;
    also is Gnome::GObject::Boxed;

Types
=====

class N-GtkBorder
-----------------

A struct that specifies a border around a rectangular area that can be of different width on each side.

  * Int $.left: The width of the left border

  * Int $.right: The width of the right border

  * Int $.top: The width of the top border

  * Int $.bottom: The width of the bottom border

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object taking the native object from elsewhere.

    multi method new ( N-GtkBorder :native-object! )

Create an object and initialize to given values.

    multi method new ( Int :$left!, Int :$right!, Int :$top!, Int :$bottom! )

left
----

Modify left width of border if value is given. Returns left value after modification if any, otherwise the currently set value.

    method left ( Int $value? --> Int )

right
-----

Modify right width of border if value is given. Returns right value after modification if any, otherwise the currently set value.

    method right ( Int $value? --> Int )

top
---

Modify top width of border if value is given. Returns top value after modification if any, otherwise the currently set value.

    method top ( Int $value? --> Int )

bottom
------

Modify bottom width of border if value is given. Returns bottom value after modification if any, otherwise the currently set value.

    method bottom ( Int $value? --> Int )

border-is-valid
---------------

Return the validity of th native structure. After a call to clear-border() this flag is set to False and the object should not be used anymore.

    method border-is-valid ( --> Bool )

[gtk_] border_copy
------------------

Copies a `N-GtkBorder` struct.

Returns: a copy of the native object *N-GtkBorder*.

    method gtk_border_copy ( --> N-GtkBorder  )

