Gnome::GObject::Value
=====================

Standard Parameter and Value Types

Description
===========

GValue provides an abstract container structure which can be copied, transformed and compared while holding a value of any (derived) type, which is registered as a GType with a GTypeValueTable in its GTypeInfo structure. Parameter specifications for most value types can be created as GParamSpec derived instances, to implement e.g. GObject properties which operate on GValue containers.

Parameter names need to start with a letter (a-z or A-Z). Subsequent characters can be letters, numbers or a '-'. All other characters are replaced by a '-' during construction.

GValue is a polymorphic type that can hold values of any other type operations and thus can be used as a type initializer for `g_value_init()` and are defined by a separate interface. See the [standard values API][gobject-Standard-Parameter-and-Value-Types] for details

The **N-GValue** structure is basically a variable container that consists of a type identifier and a specific value of that type. The type identifier within a **N-GValue** structure always determines the type of the associated value. To create an undefined **N-GValue** structure, simply create a zero-filled **N-GValue** structure. To initialize the **N-GValue**, use the `g_value_init()` function. A **N-GValue** cannot be used until it is initialized. The basic type operations (such as freeing and copying) are determined by the **GTypeValueTable** associated with the type ID stored in the **N-GValue**. Other **N-GValue** operations (such as converting values between types) are provided by this interface.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Value;
    also is Gnome::GObject::Boxed;

Types
=====

N-GValue
--------

A structure to hold a type and a value. Its type is readable from the structure as a 32 bit integer and holds type values like `G_TYPE_UCHAR` and `G_TYPE_LONG`. These names are defined in **Gnome::GObject::Type**.

    my Gnome::GObject::Value $v .= new( :type(G_TYPE_ULONG), :value(765237654));
    say $v.get-native-object.g-type;  # 36

Methods
=======

new
---

Create a value object and initialize to type. Exampes of a type is G_TYPE_INT or G_TYPE_BOOLEAN.

    multi method new ( Int :$init! )

Create a value object and initialize to type and set a value.

    multi method new ( Int :$type!, Any :$value! )

Create an object using a native object from elsewhere.

    multi method new ( N-GObject :$gvalue! )

[g_] value_init
---------------

Initializes *$value* with the default value of *$g_type*.

Returns: the **N-GValue** structure that has been passed in

    method g_value_init ( UInt $g_type --> N-GValue  )

  * uInt $g_type; Type the **N-GValue** should hold values of.

[g_] value_reset
----------------

Clears the current value in this object and resets it to the default value (as if the value had just been initialized).

Returns: the **N-GValue** structure that has been passed in

    method g_value_reset ( --> N-GValue  )

[g_] value_unset
----------------

Clears the current value (if any) and "unsets" the type, this releases all resources associated with this GValue. An unset value is the same as an uninitialized (zero-filled) **N-GValue** structure. The method `.is-valid()` will return False after the call.

    method g_value_unset ( )

[[g_] value_] set_instance
--------------------------

Sets the value from an instantiatable type via the value_table's `collect_value()` function.

    method g_value_set_instance ( Pointer $instance )

  * Pointer $instance; (nullable): the instance

[[g_] value_] init_from_instance
--------------------------------

Initializes and sets *value* from an instantiatable type via the value_table's `collect_value()` function.

Note: The *value* will be initialised with the exact type of *instance*. If you wish to set the *value*'s type to a different GType (such as a parent class GType), you need to manually call `g_value_init()` and `g_value_set_instance()`.

Since: 2.42

    method g_value_init_from_instance ( Pointer $instance )

  * Pointer $instance; (type GObject.TypeInstance): the instance

[[g_] value_] fits_pointer
--------------------------

Determines if *value* will fit inside the size of a pointer value. This is an internal function introduced mainly for C marshallers.

Returns: `1` if *value* will fit inside a pointer value.

    method g_value_fits_pointer ( --> Int  )

[[g_] value_] peek_pointer
--------------------------

Returns the value contents as pointer. This function asserts that `g_value_fits_pointer()` returned `1` for the passed in value. This is an internal function introduced mainly for C marshallers.

Returns: (transfer none): the value contents as pointer

    method g_value_peek_pointer ( --> Pointer  )

[[g_] value_] type_compatible
-----------------------------

Returns whether a **N-GValue** of type *src_type* can be copied into a **N-GValue** of type *dest_type*.

Returns: `1` if `g_value_copy()` is possible with *src_type* and *dest_type*.

    method g_value_type_compatible ( uInt $src_type, uInt $dest_type --> Int  )

  * uInt $src_type; source type to be copied.

  * uInt $dest_type; destination type for copying.

[[g_] value_] type_transformable
--------------------------------

Check whether `g_value_transform()` is able to transform values of type *src_type* into values of type *dest_type*. Note that for the types to be transformable, they must be compatible or a transformation function must be registered.

Returns: `1` if the transformation is possible, `0` otherwise.

    method g_value_type_transformable ( uInt $src_type, uInt $dest_type --> Int  )

  * uInt $src_type; Source type.

  * uInt $dest_type; Target type.

[g_] value_transform
--------------------

Tries to cast the contents of *src_value* into a type appropriate to store in *dest_value*, e.g. to transform a `G_TYPE_INT` value into a `G_TYPE_FLOAT` value. Performing transformations between value types might incur precision lossage. Especially transformations into strings might reveal seemingly arbitrary results and shouldn't be relied upon for production code (such as rcfile value or object property serialization).

Returns: Whether a transformation rule was found and could be applied. Upon failing transformations, *dest_value* is left untouched.

    method g_value_transform ( N-GValue $dest_value --> Int  )

  * N-GValue $dest_value; Target value.

[g_] value_set_schar
--------------------

Set the contents of a `G_TYPE_CHAR` typed **N-GValue** to *$v_char*.

Since: 2.32

    method g_value_set_schar ( Int $v_char )

  * Int $v_char; signed 8 bit integer to be set

[g_] value_get_schar
--------------------

Get the signed 8 bit integer contents of a `G_TYPE_CHAR` typed **N-GValue**.

Since: 2.32

    method g_value_get_schar ( --> Int  )

[g_] value_set_uchar
--------------------

Set the contents of a `G_TYPE_UCHAR` typed **N-GValue** to *$v_uchar*.

    method g_value_set_uchar ( UInt $v_uchar )

  * UInt $v_uchar; unsigned character value to be set

[g_] value_get_uchar
--------------------

Get the contents of a `G_TYPE_UCHAR` typed **N-GValue**.

    method g_value_get_uchar ( --> UInt  )

[g_] value_set_boolean
----------------------

Set the contents of a `G_TYPE_BOOLEAN` typed **N-GValue** to *$v_boolean*.

    method g_value_set_boolean ( Bool $v_boolean )

  * Int $v_boolean; boolean value to be set

[g_] value_get_boolean
----------------------

Get the contents of a `G_TYPE_BOOLEAN` typed **N-GValue**. Returns 0 or 1.

    method g_value_get_boolean ( --> Int  )

[g_] value_set_int
------------------

Set the contents of a `G_TYPE_INT` typed **N-GValue** to *$v_int*.

    method g_value_set_int ( Int $v_int )

  * Int $v_int; integer value to be set

[g_] value_get_int
------------------

Get the contents of a `G_TYPE_INT` typed **N-GValue**.

    method g_value_get_int ( --> Int  )

[g_] value_set_uint
-------------------

Set the contents of a `G_TYPE_UINT` typed **N-GValue** to *$v_uint*.

    method g_value_set_uint ( guInt $v_uint )

  * guInt $v_uint; unsigned integer value to be set

[g_] value_get_uint
-------------------

Get the contents of a `G_TYPE_UINT` typed **N-GValue**.

    method g_value_get_uint ( --> guInt  )

[g_] value_set_long
-------------------

Set the contents of a `G_TYPE_LONG` typed **N-GValue** to *$v_long*.

    method g_value_set_long ( Int $v_long )

  * Int $v_long; long integer value to be set

[g_] value_get_long
-------------------

Get the contents of a `G_TYPE_LONG` typed **N-GValue**.

    method g_value_get_long ( --> Int  )

[g_] value_set_ulong
--------------------

Set the contents of a `G_TYPE_ULONG` typed **N-GValue** to *$v_ulong*.

    method g_value_set_ulong ( UInt $v_ulong )

  * UInt $v_ulong; unsigned long integer value to be set

[g_] value_get_ulong
--------------------

Get the contents of a `G_TYPE_ULONG` typed **N-GValue**.

    method g_value_get_ulong ( --> UInt  )

[g_] value_set_int64
--------------------

Set the contents of a `G_TYPE_INT64` typed **N-GValue** to *$v_int64*.

    method g_value_set_int64 ( Int $v_int64 )

  * Int $v_int64; 64bit integer value to be set

[g_] value_get_int64
--------------------

Get the contents of a `G_TYPE_INT64` typed **N-GValue**.

    method g_value_get_int64 ( --> Int  )

[g_] value_set_uint64
---------------------

Set the contents of a `G_TYPE_UINT64` typed **N-GValue** to *$v_uint64*.

    method g_value_set_uint64 ( UInt $v_uint64 )

  * guInt $v_uint64; unsigned 64bit integer value to be set

[g_] value_get_uint64
---------------------

Get the contents of a `G_TYPE_UINT64` typed **N-GValue**.

    method g_value_get_uint64 ( --> guInt  )

[g_] value_set_float
--------------------

Set the contents of a `G_TYPE_FLOAT` typed **N-GValue** to *$v_float*.

    method g_value_set_float ( Num $v_float )

  * Num $v_float; float value to be set

[g_] value_get_float
--------------------

Get the contents of a `G_TYPE_FLOAT` typed **N-GValue**.

    method g_value_get_float ( --> Num  )

[g_] value_set_double
---------------------

Set the contents of a `G_TYPE_DOUBLE` typed **N-GValue** to *$v_double*.

    method g_value_set_double ( Num $v_double )

  * Num $v_double; double value to be set

[g_] value_get_double
---------------------

Get the contents of a `G_TYPE_DOUBLE` typed **N-GValue**.

    method g_value_get_double ( --> Num  )

[g_] value_set_string
---------------------

Set the contents of a `G_TYPE_STRING` typed **N-GValue** to *$v_string*.

    method g_value_set_string ( Str $v_string )

  * Str $v_string; caller-owned string to be duplicated for the **N-GValue**

[g_] value_get_string
---------------------

Get the contents of a `G_TYPE_STRING` typed **N-GValue**.

Returns: string content of *$value*

    method g_value_get_string ( --> Str  )

