Gnome::Glib::VariantBuilder
===========================

Helper class to build arrays and tuples

See Also
--------

[Gnome::Glib::VariantType](VariantType.html), [Gnome::Glib::VariantTypeBuilder](VariantTypeBuilder.html), [gvariant format strings](https://developer.gnome.org/glib/stable/gvariant-format-strings.html), [gvariant text format](https://developer.gnome.org/glib/stable/gvariant-text.html).

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::VariantBuilder;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

Create a new VariantNuilder object.

    multi method new ( Str :$type-string! )

Create a new VariantNuilder object.

    multi method new ( Gnome::Glib::VariantType :$type! )

Create a Variant object using a native object from elsewhere.

    multi method new ( N-GVariantBuilder :$native-object! )

[g_] variant_builder_new
------------------------

Allocates and initialises a new **Gnome::Glib::VariantBuilder**.

Returns: a **Gnome::Glib::VariantBuilder**

    method g_variant_builder_new ( N-GVariantType $type --> N-GVariantBuilder )

  * N-GVariantType $type; a container type

[g_] variant_builder_init
-------------------------

Initialises a **Gnome::Glib::VariantBuilder** structure. **Please note that the program will crash if the object is not valid!**

*$type* must be a defined variant type. It specifies the type of container to construct. It can be an indefinite type such as `G_VARIANT_TYPE_ARRAY` or a definite type such as "as" or "(ii)". Maybe, array, tuple, dictionary entry and variant-typed values may be constructed.

After the builder is initialised, values are added using `g_variant_builder_add_value()` or `g_variant_builder_add()`.

After all the child values are added, `g_variant_builder_end()` frees the memory associated with the builder and returns the **Gnome::Glib::Variant** that was created.

This function completely ignores the previous contents of *builder*. On one hand this means that it is valid to pass in completely uninitialised memory. On the other hand, this means that if you are initialising over top of an existing **Gnome::Glib::VariantBuilder** you need to first call `g_variant_builder_clear()` in order to avoid leaking memory.

    method g_variant_builder_init ( N-GVariantType $type )

    method g_variant_builder_init ( Str $type-string )

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

  * N-GVariantType $type; a container type

  * Str $type-string; In the second form a type string can be provided which is used to create a VariantType.

[g_] variant_builder_end
------------------------

Ends the builder process and returns the constructed value.

It is not permissible to use *builder* in any way after this call except for reference counting operations (in the case of a heap-allocated **Gnome::Glib::VariantBuilder**) or by reinitialising it with `g_variant_builder_init()` (in the case of stack-allocated). This means that for the stack-allocated builders there is no need to call `g_variant_builder_clear()` after the call to `g_variant_builder_end()`.

It is an error to call this function in any way that would create an inconsistent value to be constructed (ie: insufficient number of items added to a container with a specific number of children required). It is also an error to call this function if the builder was created with an indefinite array or maybe type and no children have been added; in this case it is impossible to infer the type of the empty array.

Returns: a new, floating native **Gnome::Glib::Variant**

    method g_variant_builder_end ( --> N-GVariant )

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

[g_] variant_builder_clear
--------------------------

Releases all memory associated with a **Gnome::Glib::VariantBuilder** without freeing the **Gnome::Glib::VariantBuilder** structure itself.

It typically only makes sense to do this on a stack-allocated **Gnome::Glib::VariantBuilder** if you want to abort building the value part-way through. This function need not be called if you call `g_variant_builder_end()` and it also doesn't need to be called on builders allocated with `g_variant_builder_new()` (see `g_variant_builder_unref()` for that).

This function leaves the **Gnome::Glib::VariantBuilder** structure set to all-zeros. It is valid to call this function on either an initialised **Gnome::Glib::VariantBuilder** or one that is set to all-zeros but it is not valid to call this function on uninitialised memory.

    method g_variant_builder_clear ( )

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

[g_] variant_builder_open
-------------------------

Opens a subcontainer inside the given *builder*. When done adding items to the subcontainer, `g_variant_builder_close()` must be called. *type* is the type of the container: so to build a tuple of several values, *type* must include the tuple itself.

It is an error to call this function in any way that would cause an inconsistent value to be constructed (ie: adding too many values or a value of an incorrect type).

    method g_variant_builder_open ( N-GVariantType $type )

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

  * N-GVariantType $type; the **Gnome::Glib::VariantType** of the container

[g_] variant_builder_close
--------------------------

Closes the subcontainer inside the given *builder* that was opened by the most recent call to `g_variant_builder_open()`.

It is an error to call this function in any way that would create an inconsistent value to be constructed (ie: too few values added to the subcontainer).

    method g_variant_builder_close ( )

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

[[g_] variant_builder_] add_value
---------------------------------

Adds *value* to *builder*.

It is an error to call this function in any way that would create an inconsistent value to be constructed. Some examples of this are putting different types of items into an array, putting the wrong types or number of items in a tuple, putting more than one value into a variant, etc.

If *value* is a floating reference (see `g_variant_ref_sink()`), the *builder* instance takes ownership of *value*.

    method g_variant_builder_add_value ( N-GVariant $value )

Note that gnome errors can be shown on the commandline like

    (process:3360): GLib-CRITICAL **: 17:40:21.705: g_variant_builder_add_value: assertion 'GVSB(builder)->offset < GVSB(builder)->max_items' failed

when too many insertions are done or

    (process:3430): GLib-CRITICAL **: 17:42:24.826: g_variant_builder_add_value: assertion '!GVSB(builder)->expected_type || g_variant_is_of_type (value, GVSB(builder)->expected_type)' failed

when a wrong type of value is inserted

  * N-GVariantBuilder $builder; a **Gnome::Glib::VariantBuilder**

  * N-GVariant $value; a **Gnome::Glib::Variant**

[g_] variant_builder_add_parsed
-------------------------------

Adds to a N-GVariantBuilder.

This call is a convenience wrapper that is exactly equivalent to calling g_variant_new_parsed() followed by g_variant_builder_add_value().

Note that the arguments must be of the correct width for their types specified in format_string. This can be achieved by casting them. See the GVariant varargs documentation.

This function might be used as follows:

    method make-pointless-dictionary ( --> Gnome::Glib::Variant ) {

      my Gnome::Glib::VariantBuilder $builder;

      $builder.variant-builder-init(G_VARIANT_TYPE_ARRAY);
      $builder.add-parsed('{"width": <600>}');
      $builder.add-parsed('{"title": <"foo">}');

      g_variant_builder_init (&builder, G_VARIANT_TYPE_ARRAY);
      g_variant_builder_add_parsed (&builder, "{'width', <%i>}", 600);
      g_variant_builder_add_parsed (&builder, "{'title', <%s>}", "foo");
      g_variant_builder_add_parsed (&builder, "{'transparency', <0.5>}");
      return g_variant_builder_end (&builder);
    }

    method g_variant_builder_add_parsed ( Str $data-string )

  * N-GVariantBuilder $builder;

  * Str $format;

