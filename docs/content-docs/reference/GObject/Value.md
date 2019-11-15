Gnome::GObject::Value
=====================

Standard Parameter and Value Types

Description
===========

GValue provides an abstract container structure which can be copied, transformed and compared while holding a value of any (derived) type, which is registered as a GType with a GTypeValueTable in its GTypeInfo structure. Parameter specifications for most value types can be created as GParamSpec derived instances, to implement e.g. GObject properties which operate on GValue containers.

Parameter names need to start with a letter (a-z or A-Z). Subsequent characters can be letters, numbers or a '-'. All other characters are replaced by a '-' during construction.

GValue is a polymorphic type that can hold values of any other type operations and thus can be used as a type initializer for `g_value_init()` and are defined by a separate interface. See the [standard values API][gobject-Standard-Parameter-and-Value-Types] for details

The **GValue** structure is basically a variable container that consists of a type identifier and a specific value of that type. The type identifier within a **GValue** structure always determines the type of the associated value. To create a undefined **GValue** structure, simply create a zero-filled **GValue** structure. To initialize the **GValue**, use the `g_value_init()` function. A **GValue** cannot be used until it is initialized. The basic type operations (such as freeing and copying) are determined by the **GTypeValueTable** associated with the type ID stored in the **GValue**. Other **GValue** operations (such as converting values between types) are provided by this interface.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Value;
    also is Gnome::GObject::Boxed;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

g_value_init
------------

Initializes *$value* with the default value of *$g_type*.

Returns: (transfer none): the **GValue** structure that has been passed in

    method g_value_init ( UInt $g_type --> N-GValue  )

  * uInt $g_type; Type the **GValue** should hold values of.

g_value_reset
-------------

Clears the current value in this object and resets it to the default value (as if the value had just been initialized).

Returns: the **GValue** structure that has been passed in

    method g_value_reset ( --> N-GValue  )

g_value_unset
-------------

Clears the current value in *value* (if any) and "unsets" the type, this releases all resources associated with this GValue. An unset value is the same as an uninitialized (zero-filled) **GValue** structure.

    method g_value_unset ( )

[g_value_] set_instance
-----------------------

Sets the value from an instantiatable type via the value_table's `collect_value()` function.

    method g_value_set_instance ( Pointer $instance )

  * Pointer $instance; (nullable): the instance

[g_value_] init_from_instance
-----------------------------

Initializes and sets *value* from an instantiatable type via the value_table's `collect_value()` function.

Note: The *value* will be initialised with the exact type of *instance*. If you wish to set the *value*'s type to a different GType (such as a parent class GType), you need to manually call `g_value_init()` and `g_value_set_instance()`.

Since: 2.42

    method g_value_init_from_instance ( Pointer $instance )

  * Pointer $instance; (type GObject.TypeInstance): the instance

[g_value_] fits_pointer
-----------------------

Determines if *value* will fit inside the size of a pointer value. This is an internal function introduced mainly for C marshallers.

Returns: `1` if *value* will fit inside a pointer value.

    method g_value_fits_pointer ( --> Int  )

[g_value_] peek_pointer
-----------------------

Returns the value contents as pointer. This function asserts that `g_value_fits_pointer()` returned `1` for the passed in value. This is an internal function introduced mainly for C marshallers.

Returns: (transfer none): the value contents as pointer

    method g_value_peek_pointer ( --> Pointer  )

[g_value_] type_compatible
--------------------------

Returns whether a **GValue** of type *src_type* can be copied into a **GValue** of type *dest_type*.

Returns: `1` if `g_value_copy()` is possible with *src_type* and *dest_type*.

    method g_value_type_compatible ( uInt $src_type, uInt $dest_type --> Int  )

  * uInt $src_type; source type to be copied.

  * uInt $dest_type; destination type for copying.

[g_value_] type_transformable
-----------------------------

Check whether `g_value_transform()` is able to transform values of type *src_type* into values of type *dest_type*. Note that for the types to be transformable, they must be compatible or a transformation function must be registered.

Returns: `1` if the transformation is possible, `0` otherwise.

    method g_value_type_transformable ( uInt $src_type, uInt $dest_type --> Int  )

  * uInt $src_type; Source type.

  * uInt $dest_type; Target type.

g_value_transform
-----------------

Tries to cast the contents of *src_value* into a type appropriate to store in *dest_value*, e.g. to transform a `G_TYPE_INT` value into a `G_TYPE_FLOAT` value. Performing transformations between value types might incur precision lossage. Especially transformations into strings might reveal seemingly arbitrary results and shouldn't be relied upon for production code (such as rcfile value or object property serialization).

Returns: Whether a transformation rule was found and could be applied. Upon failing transformations, *dest_value* is left untouched.

    method g_value_transform ( N-GValue $dest_value --> Int  )

  * N-GValue $dest_value; Target value.

g_value_set_schar
-----------------

Set the contents of a `G_TYPE_CHAR` **GValue** to *v_char*.

Since: 2.32

    method g_value_set_schar ( Int $v_char )

  * Int $v_char; signed 8 bit integer to be set

g_value_get_schar
-----------------

Get the contents of a `G_TYPE_CHAR` **GValue**.

Returns: signed 8 bit integer contents of *value* Since: 2.32

    method g_value_get_schar ( --> Int  )

g_value_set_uchar
-----------------

Set the contents of a `G_TYPE_UCHAR` **GValue** to *v_uchar*.

    method g_value_set_uchar ( UInt $v_uchar )

  * UInt $v_uchar; unsigned character value to be set

g_value_get_uchar
-----------------

Get the contents of a `G_TYPE_UCHAR` **GValue**.

Returns: unsigned character contents of *value*

    method g_value_get_uchar ( --> UInt  )

g_value_set_boolean
-------------------

Set the contents of a `G_TYPE_BOOLEAN` **GValue** to *v_boolean*.

    method g_value_set_boolean ( Int $v_boolean )

  * Int $v_boolean; boolean value to be set

g_value_get_boolean
-------------------

Get the contents of a `G_TYPE_BOOLEAN` **GValue**.

Returns: boolean contents of *value*

    method g_value_get_boolean ( --> Int  )

g_value_set_int
---------------

Set the contents of a `G_TYPE_INT` **GValue** to *v_int*.

    method g_value_set_int ( Int $v_int )

  * Int $v_int; integer value to be set

g_value_get_int
---------------

Get the contents of a `G_TYPE_INT` **GValue**.

Returns: integer contents of *value*

    method g_value_get_int ( --> Int  )

g_value_set_uint
----------------

Set the contents of a `G_TYPE_UINT` **GValue** to *v_uint*.

    method g_value_set_uint ( guInt $v_uint )

  * guInt $v_uint; unsigned integer value to be set

g_value_get_uint
----------------

Get the contents of a `G_TYPE_UINT` **GValue**.

Returns: unsigned integer contents of *value*

    method g_value_get_uint ( --> guInt  )

g_value_set_long
----------------

Set the contents of a `G_TYPE_LONG` **GValue** to *v_long*.

    method g_value_set_long ( Int $v_long )

  * Int $v_long; long integer value to be set

g_value_get_long
----------------

Get the contents of a `G_TYPE_LONG` **GValue**.

Returns: long integer contents of *value*

    method g_value_get_long ( --> Int  )

g_value_set_ulong
-----------------

Set the contents of a `G_TYPE_ULONG` **GValue** to *v_ulong*.

    method g_value_set_ulong ( UInt $v_ulong )

  * UInt $v_ulong; unsigned long integer value to be set

g_value_get_ulong
-----------------

Get the contents of a `G_TYPE_ULONG` **GValue**.

Returns: unsigned long integer contents of *value*

    method g_value_get_ulong ( --> UInt  )

g_value_set_int64
-----------------

Set the contents of a `G_TYPE_INT64` **GValue** to *v_int64*.

    method g_value_set_int64 ( Int $v_int64 )

  * Int $v_int64; 64bit integer value to be set

g_value_get_int64
-----------------

Get the contents of a `G_TYPE_INT64` **GValue**.

Returns: 64bit integer contents of *value*

    method g_value_get_int64 ( --> Int  )

g_value_set_uint64
------------------

Set the contents of a `G_TYPE_UINT64` **GValue** to *v_uint64*.

    method g_value_set_uint64 ( guInt $v_uint64 )

  * guInt $v_uint64; unsigned 64bit integer value to be set

g_value_get_uint64
------------------

Get the contents of a `G_TYPE_UINT64` **GValue**.

Returns: unsigned 64bit integer contents of *value*

    method g_value_get_uint64 ( --> guInt  )

g_value_set_float
-----------------

Set the contents of a `G_TYPE_FLOAT` **GValue** to *v_float*.

    method g_value_set_float ( Num $v_float )

  * Num $v_float; float value to be set

g_value_get_float
-----------------

Get the contents of a `G_TYPE_FLOAT` **GValue**.

Returns: float contents of *value*

    method g_value_get_float ( --> Num  )

g_value_set_double
------------------

Set the contents of a `G_TYPE_DOUBLE` **GValue** to *v_double*.

    method g_value_set_double ( Num $v_double )

  * Num $v_double; double value to be set

g_value_get_double
------------------

Get the contents of a `G_TYPE_DOUBLE` **GValue**.

Returns: double contents of *value*

    method g_value_get_double ( --> Num  )

g_value_set_string
------------------

Set the contents of a `G_TYPE_STRING` **GValue** to *v_string*.

    method g_value_set_string ( Str $v_string )

  * Str $v_string; (nullable): caller-owned string to be duplicated for the **GValue**

g_value_set_static_string
-------------------------

Set the contents of a `G_TYPE_STRING` **GValue** to *v_string*. The string is assumed to be static, and is thus not duplicated when setting the **GValue**.

    method g_value_set_static_string ( Str $v_string )

  * Str $v_string; (nullable): static string to be set

g_value_get_string
------------------

Get the contents of a `G_TYPE_STRING` **GValue**.

Returns: string content of *$value*

    method g_value_get_string ( --> Str  )

g_value_dup_string
------------------

Get a copy the contents of a `G_TYPE_STRING` **GValue**.

Returns: a newly allocated copy of the string content of *value*

    method g_value_dup_string ( --> Str  )

g_value_set_pointer
-------------------

Set the contents of a pointer **GValue** to *v_pointer*.

    method g_value_set_pointer ( Pointer $v_pointer )

  * Pointer $v_pointer; pointer value to be set

g_value_get_pointer
-------------------

Get the contents of a pointer **GValue**.

Returns: (transfer none): pointer contents of *value*

    method g_value_get_pointer ( --> Pointer  )

g_gtype_get_type
----------------

    method g_gtype_get_type ( --> uInt  )

g_value_set_gtype
-----------------

Set the contents of a `G_TYPE_GTYPE` **GValue** to *v_gtype*.

Since: 2.12

    method g_value_set_gtype ( uInt $v_gtype )

  * uInt $v_gtype; **GType** to be set

g_value_get_gtype
-----------------

Get the contents of a `G_TYPE_GTYPE` **GValue**.

Since: 2.12

Returns: the **GType** stored in *value*

    method g_value_get_gtype ( --> uInt  )

g_value_set_variant
-------------------

Set the contents of a variant **GValue** to *variant*. If the variant is floating, it is consumed.

Since: 2.26

    method g_value_set_variant ( N-GValue $variant )

  * N-GValue $variant; (nullable): a **GVariant**, or `Any`

g_value_take_variant
--------------------

Set the contents of a variant **GValue** to *variant*, and takes over the ownership of the caller's reference to *variant*; the caller doesn't have to unref it any more (i.e. the reference count of the variant is not increased).

If *variant* was floating then its floating reference is converted to a hard reference.

If you want the **GValue** to hold its own reference to *variant*, use `g_value_set_variant()` instead.

This is an internal function introduced mainly for C marshallers.

Since: 2.26

    method g_value_take_variant ( N-GValue $variant )

  * N-GValue $variant; (nullable) (transfer full): a **GVariant**, or `Any`

g_value_get_variant
-------------------

Get the contents of a variant **GValue**.

Returns: (transfer none) (nullable): variant contents of *value* (may be `Any`)

Since: 2.26

    method g_value_get_variant ( --> N-GValue  )

g_value_dup_variant
-------------------

Get the contents of a variant **GValue**, increasing its refcount. The returned **GVariant** is never floating.

Returns: (transfer full) (nullable): variant contents of *value* (may be `Any`); should be unreffed using `g_variant_unref()` when no longer needed

Since: 2.26

    method g_value_dup_variant ( --> N-GValue  )

g_pointer_type_register_static
------------------------------

Creates a new `G_TYPE_POINTER` derived type id for a new pointer type with name *name*.

Returns: a new `G_TYPE_POINTER` derived type id for *name*.

    method g_pointer_type_register_static ( Str $name --> uInt  )

  * Str $name; the name of the new pointer type.

g_strdup_value_contents
-----------------------

Return a newly allocated string, which describes the contents of a **GValue**. The main purpose of this function is to describe **GValue** contents for debugging output, the way in which the contents are described may change between different GLib versions.

Returns: Newly allocated string.

    method g_strdup_value_contents ( --> Str  )

g_value_take_string
-------------------

Sets the contents of a `G_TYPE_STRING` **GValue** to *v_string*.

Since: 2.4

    method g_value_take_string ( Str $v_string )

  * Str $v_string; (nullable): string to take ownership of

