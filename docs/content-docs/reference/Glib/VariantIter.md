Gnome::Glib::VariantIter
========================

Variant iterator

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::VariantIter;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

Create a new VariantIter object using a Variant object. Must be freed using `.g_variant_iter_free()`.

    multi method new ( N-GVariant :$variant! )

Create a VariantIter object using a native object from elsewhere.

    multi method new ( N-GVariantType :$native-object! )

[g_variant_] iter_init
----------------------

Initialises (without allocating) a **Gnome::Glib::VariantIter**. *iter* may be completely uninitialised prior to this call; its old value is ignored.

The iterator remains valid for as long as *value* exists, and need not be freed in any way.

Returns: the number of items in *value*

    method g_variant_iter_init ( N-GVariantIter $iter, N-GVariant $value --> UInt )

  * N-GVariantIter $iter; a pointer to a **Gnome::Glib::VariantIter**

  * N-GVariant $value; a container **Gnome::Glib::Variant**

[g_variant_] iter_copy
----------------------

Creates a new heap-allocated **Gnome::Glib::VariantIter** to iterate over the container that was being iterated over by *iter*. Iteration begins on the new iterator from the current position of the old iterator but the two copies are independent past that point.

Use `g_variant_iter_free()` to free the return value when you no longer need it.

A reference is taken to the container that *iter* is iterating over and will be releated only when `g_variant_iter_free()` is called.

Returns: (transfer full): a new heap-allocated **Gnome::Glib::VariantIter**

    method g_variant_iter_copy ( N-GVariantIter $iter --> N-GVariantIter )

  * N-GVariantIter $iter; a **Gnome::Glib::VariantIter**

[g_variant_] iter_n_children
----------------------------

Queries the number of child items in the container that we are iterating over. This is the total number of items -- not the number of items remaining.

This function might be useful for preallocation of arrays.

Returns: the number of children in the container

    method g_variant_iter_n_children ( N-GVariantIter $iter --> UInt )

  * N-GVariantIter $iter; a **Gnome::Glib::VariantIter**

[g_variant_] iter_free
----------------------

Frees a heap-allocated **Gnome::Glib::VariantIter**. Only call this function on iterators that were returned by `.new(:$variant))` or `g_variant_iter_copy()`.

    method g_variant_iter_free ( N-GVariantIter $iter )

  * N-GVariantIter $iter; (transfer full): a heap-allocated **Gnome::Glib::VariantIter**

[g_variant_] iter_next_value
----------------------------

Gets the next item in the container. If no more items remain then `Any` is returned.

Use `g_variant_unref()` to drop your reference on the return value when you no longer need it.

Here is an example for iterating with `g_variant_iter_next_value()`: |[<!-- language="C" --> // recursively iterate a container void iterate_container_recursive (GVariant *container) { N-GVariantIter iter; GVariant *child;

g_variant_iter_init (&iter, container); while ((child = g_variant_iter_next_value (&iter))) { g_print ("type '`s`'\n", g_variant_get_type_string (child));

if (g_variant_is_container (child)) iterate_container_recursive (child);

g_variant_unref (child); } } ]|

Returns: (nullable) (transfer full): a **Gnome::Glib::Variant**, or `Any`

    method g_variant_iter_next_value ( N-GVariantIter $iter --> N-GVariant )

  * N-GVariantIter $iter; a **Gnome::Glib::VariantIter**

