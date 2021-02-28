Gnome::Gio::MenuAttributeIter
=============================

An iterator for attributes

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::MenuAttributeIter;
    also is Gnome::GObject::Object;

Uml Diagram
-----------

![](plantuml/MenuModel.svg)

Methods
=======

new
---

### :native-object

Create a Menu object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

attribute-iter-get-name
-----------------------

Gets the name of the attribute at the current iterator position, as a string.

The iterator is not advanced.

Returns: the name of the attribute

    method attribute-iter-get-name ( --> Str )

attribute-iter-get-next
-----------------------

This function combines `attribute-iter-next()` with `attribute-iter-get-name()` and `attribute-iter-get-value()`.

First the iterator is advanced to the next (possibly first) attribute. If that fails, then `False` is returned and there are no other effects.

If successful, *name* and *value* are set to the name and value of the attribute that has just been advanced to. At this point,`attribute-iter-get-name()` and `attribute-iter-get-value()` will return the same values again.

The value returned in *name* remains valid for as long as the iterator remains at the current position. The value returned in *value* must be unreffed using `g-variant-unref()` when it is no longer in use.

Returns: `True` on success, or `False` if there is no additional attribute

    method attribute-iter-get-next (
      CArray[Str] $out_name, N-GVariant $value
      --> Int
    )

  * CArray[Str] $out_name; (out) (optional) (transfer none): the type of the attribute

  * N-GVariant $value; (out) (optional) (transfer full): the attribute value

attribute-iter-get-value
------------------------

Gets the value of the attribute at the current iterator position.

The iterator is not advanced.

Returns: (transfer full): the value of the current attribute

    method attribute-iter-get-value ( --> N-GVariant )

attribute-iter-next
-------------------

Attempts to advance the iterator to the next (possibly first) attribute.

`True` is returned on success, or `False` if there are no more attributes.

You must call this function when you first acquire the iterator to advance it to the first attribute (and determine if the first attribute exists at all).

Returns: `True` on success, or `False` when there are no more attributes

    method attribute-iter-next ( --> Int )

