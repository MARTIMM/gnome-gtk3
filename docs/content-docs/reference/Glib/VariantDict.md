Gnome::Glib::VariantDict
========================

Description
===========

**Gnome::Glib::VariantDict** is a mutable interface to GVariant dictionaries.

It can be used for doing a sequence of dictionary lookups in an efficient way on an existing GVariant dictionary or it can be used to construct new dictionaries with a hashtable-like interface. It can also be used for taking existing dictionaries and modifying them in order to create new ones.

**Gnome::Glib::VariantDict** can only be used with G_VARIANT_TYPE_VARDICT dictionaries.

`end()` is used to convert the **Gnome::Glib::VariantDict** back into a dictionary-type **Gnome::Glib::Variant**. You must call `clear-object()` afterwards.

### Example

    my Gnome::Glib::VariantDict $vd .= new(
      :variant(
        Gnome::Glib::Variant.new(:parse(Q:q/{ 'width': <350>, 'height': <200>}/))
      )
    );

    $vd.insert-value( 'depth', Gnome::Glib::Variant.new(:parse('-40')));
    say $vd.lookup-value( 'width', 'i').get-int32;  # 350
    $vd.remove('width');

    my Gnome::Glib::Variant $v .= new(:native-object($vd.end));
    $vd.clear-object;
    say 'dict: ' ~ $v.print(False); # dict: {'height': <200>, 'vd01': <-40>}

See Also
--------

  * [Variants](Variant.html)

  * [Variant types](VariantType.html)

  * [Gnome::Glib::VariantType](VariantType.html)

  * [Variant format strings](https://developer.gnome.org/glib/stable/gvariant-format-strings.html)

  * [Variant text format](https://developer.gnome.org/glib/stable/gvariant-text.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::VariantDict;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### default no options

### :variant

clear
-----

Releases all memory associated with a **Gnome::Glib::VariantDict** without freeing the **Gnome::Glib::VariantDict** structure itself. It typically only makes sense to do this on a stack-allocated **Gnome::Glib::VariantDict** if you want to abort building the value part-way through. This function need not be called if you call `g_variant_dict_end()` and it also doesn't need to be called on dicts allocated with g_variant_dict_new (see `clear-object()` for that). It is valid to call this function on either an initialised **Gnome::Glib::VariantDict** or one that was previously cleared by an earlier call to `g_variant_dict_clear()` but it is not valid to call this function on uninitialised memory.

    method clear ( )

contains
--------

Checks if *$key* exists in *dict*.

Returns: `True` if *$key* is in *dict*

    method contains ( Str $key --> Bool )

  * Str $key; the key to lookup in the dictionary

end
---

Returns the current value of *dict* as a **Gnome::Glib::VariantDict** of type `G_VARIANT_TYPE_VARDICT`, clearing it in the process. It is not permissible to use *dict* in any way after this call except for `clear-object()`, `clear()`

    method end ( --> N-GVariant )

insert-value
------------

Inserts (or replaces) a key in a **Gnome::Glib::VariantDict**. *value* is consumed if it is floating.

    method insert-value ( Str $key, N-GVariant $value )

  * Str $key; the key to insert a value for

  * N-GVariant $value; the value to insert

lookup-value
------------

Looks up a value in a **Gnome::Glib::VariantDict**. If *$key* is not found in *dictionary*, an invalid **Gnome::Glib::Variant** is returned. The *$expected_type* string specifies what type of value is expected. If the value associated with *$key* has a different type then an invalid **Gnome::Glib::Variant** is returned. If the key is found and the value has the correct type, it is returned. If *$expected_type* was specified then any valid return value will have this type.

Returns: the value of the dictionary key, or undefined

    method lookup-value (
      Str $key, N-GVariantType $expected_type --> Gnome::Glib::Variant
    )

  * Str $key; the key to lookup in the dictionary

  * N-GVariantType $expected_type; a **GVariantType**, or `undefined`

remove
------

Removes a key and its associated value from a **Gnome::Glib::VariantDict**.

Returns: `True` if the key was found and removed

    method remove ( Str $key --> Bool )

  * Str $key; the key to remove

