Gnome::GObject::Value
=====================

Standard Parameter and Value Types

Description
===========

This class provides an abstract container structure which can be copied, transformed and compared while holding a value of any (derived) type, which is registered as a GType with a GTypeValueTable in its GTypeInfo structure. Parameter specifications for most value types can be created as GParamSpec derived instances, to implement e.g. GObject properties which operate on GValue containers. (note that not everything is implemented in Raku)

Parameter names need to start with a letter (a-z or A-Z). Subsequent characters can be letters, numbers or a '-'. All other characters are replaced by a '-' during construction.

**N-GValue** is a polymorphic type that can hold values of any other type operations and thus can be used as a type initializer for `new(:$init)` and are defined by a separate interface. See the standard values API for details

The **N-GValue** structure is basically a variable container that consists of a type identifier and a specific value of that type. The type identifier within a **N-GValue** structure always determines the type of the associated value. To create an undefined **N-GValue** structure, simply create a zero-filled **N-GValue** structure. To initialize the **N-GValue**, use the `new(:$init)` function. A **N-GValue** cannot be used until it is initialized. The basic type operations (such as freeing and copying) are determined by the **GTypeValueTable** associated with the type ID stored in the **N-GValue**. Other **N-GValue** operations (such as converting values between types) are provided by this interface.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Value;
    also is Gnome::GObject::Boxed;

Uml Diagram
-----------

![](plantuml/Value.svg)

Types
=====

N-GValue
--------

A structure to hold a type and a value.

coment
======

Its type is readable from the structure as a 32 bit integer and holds type values like `G_TYPE_UCHAR` and `G_TYPE_LONG`.

Dynamic types from native widgets are also stored. The static type names like `G_TYPE_UCHAR` and `G_TYPE_LONG`, are defined in **Gnome::GObject::Type**.

Methods
=======

new
---

### :init

Create a value object and initialize to type. Exampes of a type is G_TYPE_INT or G_TYPE_BOOLEAN.

    multi method new ( Int :$init! )

### :type, :value

Create a value object and initialize to type and set a value.

    multi method new ( Int :$type!, Any :$value! )

### :gvalue

Create an object using a native object from elsewhere.

    multi method new ( N-GValue :$gvalue! )

### :native-object

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelSupportClass**.

    multi method new ( N-GValue :$native-object! )

copy, copy-rk
-------------

Copies the value of this Value object.

    method copy ( --> N-GValue )
    method copy-rk ( --> Gnome::GObject::Value )

  * N-GValue $dest_value; An initialized **Gnome::GObject::Value** structure of the same type as *src-value*.

get-boolean
-----------

Get the contents of a `G-TYPE-BOOLEAN` **Gnome::GObject::Value**.

Returns: boolean contents of *value*

    method get-boolean ( --> Bool )

get-double
----------

Get the contents of a `G-TYPE-DOUBLE` **Gnome::GObject::Value**.

Returns: double contents of *value*

    method get-double ( --> Num )

get-enum
--------

Get the contents of a `G-TYPE-ENUM` **Gnome::GObject::Value**.

    method get-enum ( --> Int )

get-flags
---------

Get the contents of a `G-TYPE-FLAGS` **Gnome::GObject::Value**.

Returns: flags contents of *value*

    method get-flags ( --> UInt )

get-float
---------

Get the contents of a `G-TYPE-FLOAT` **Gnome::GObject::Value**.

Returns: float contents of *value*

    method get-float ( --> Num )

get-gtype
---------

Get the contents of a `G-TYPE-GTYPE` **Gnome::GObject::Value**.

Returns: the **Gnome::GObject::Type** stored in *value*

    method get-gtype ( --> N-GValue )

get-int
-------

Get the contents of a `G-TYPE-INT` **Gnome::GObject::Value**.

Returns: integer contents of *value*

    method get-int ( --> Int )

get-int64
---------

Get the contents of a `G-TYPE-INT64` **Gnome::GObject::Value**.

Returns: 64bit integer contents of *value*

    method get-int64 ( --> Int )

get-long
--------

Get the contents of a `G-TYPE-LONG` **Gnome::GObject::Value**.

Returns: long integer contents of *value*

    method get-long ( --> Int )

get-pointer
-----------

Get the contents of a pointer **Gnome::GObject::Value**.

Returns: pointer contents of *value*

    method get-pointer ( --> Pointer )

get-schar
---------

Get the contents of a `G-TYPE-CHAR` **Gnome::GObject::Value**.

Returns: signed 8 bit integer contents of *value*

    method get-schar ( --> Int )

get-string
----------

Get the contents of a `G-TYPE-STRING` **Gnome::GObject::Value**.

Returns: string content of *value*

    method get-string ( --> Str )

get-uchar
---------

Get the contents of a `G-TYPE-UCHAR` **Gnome::GObject::Value**.

Returns: unsigned character contents of *value*

    method get-uchar ( --> UInt )

get-uint
--------

Get the contents of a `G-TYPE-UINT` **Gnome::GObject::Value**.

Returns: unsigned integer contents of *value*

    method get-uint ( --> UInt )

get-uint64
----------

Get the contents of a `G-TYPE-UINT64` **Gnome::GObject::Value**.

Returns: unsigned 64bit integer contents of *value*

    method get-uint64 ( --> UInt )

get-ulong
---------

Get the contents of a `G-TYPE-ULONG` **Gnome::GObject::Value**.

Returns: unsigned long integer contents of *value*

    method get-ulong ( --> UInt )

get-variant
-----------

Get the contents of a variant **Gnome::GObject::Value**.

Returns: variant contents of *value* (may be `undefined`)

    method get-variant ( --> N-GValue )

reset
-----

Clears the current value in *value* and resets it to the default value (as if the value had just been initialized).

Returns: the **Gnome::GObject::Value** structure that has been passed in

    method reset ( --> N-GValue )

set-boolean
-----------

Set the contents of a `G-TYPE-BOOLEAN` **Gnome::GObject::Value** to *v-boolean*.

    method set-boolean ( Bool $v_boolean )

  * Bool $v_boolean; boolean value to be set

set-double
----------

Set the contents of a `G-TYPE-DOUBLE` **Gnome::GObject::Value** to *v-double*.

    method set-double ( Num() $v_double )

  * Num() $v_double; double value to be set

set-enum
--------

Set the contents of a `G-TYPE-ENUM` **Gnome::GObject::Value** to *v-enum*.

    method set-enum ( Int() $v_enum )

  * Int() $v_enum; enum value to be set

set-flags
---------

Set the contents of a `G-TYPE-FLAGS` **Gnome::GObject::Value** to *v-flags*.

    method set-flags ( UInt $v_flags )

  * UInt $v_flags; flags value to be set

set-float
---------

Set the contents of a `G-TYPE-FLOAT` **Gnome::GObject::Value** to *v-float*.

    method set-float ( Num() $v_float )

  * Num() $v_float; float value to be set

set-gtype
---------

Set the contents of a `G-TYPE-GTYPE` **Gnome::GObject::Value** to *v-gtype*.

    method set-gtype ( N-GValue $v_gtype )

  * N-GValue $v_gtype; **Gnome::GObject::Type** to be set

set-int
-------

Set the contents of a `G-TYPE-INT` **Gnome::GObject::Value** to *v-int*.

    method set-int ( Int() $v_int )

  * Int() $v_int; integer value to be set

set-int64
---------

Set the contents of a `G-TYPE-INT64` **Gnome::GObject::Value** to *v-int64*.

    method set-int64 ( Int() $v_int64 )

  * Int() $v_int64; 64bit integer value to be set

set-long
--------

Set the contents of a `G-TYPE-LONG` **Gnome::GObject::Value** to *v-long*.

    method set-long ( Int() $v_long )

  * Int() $v_long; long integer value to be set

set-pointer
-----------

Set the contents of a pointer **Gnome::GObject::Value** to *v-pointer*.

    method set-pointer ( Pointer $v_pointer )

  * Pointer $v_pointer; pointer value to be set

set-schar
---------

Set the contents of a `G-TYPE-CHAR` **Gnome::GObject::Value** to *v-char*.

    method set-schar ( Int() $v_char )

  * Int() $v_char; signed 8 bit integer to be set

set-string
----------

Set the contents of a `G-TYPE-STRING` **Gnome::GObject::Value** to *v-string*.

    method set-string ( Str $v_string )

  * Str $v_string; caller-owned string to be duplicated for the **Gnome::GObject::Value**

set-uchar
---------

Set the contents of a `G-TYPE-UCHAR` **Gnome::GObject::Value** to *v-uchar*.

    method set-uchar ( UInt $v_uchar )

  * UInt $v_uchar; unsigned character value to be set

set-uint
--------

Set the contents of a `G-TYPE-UINT` **Gnome::GObject::Value** to *v-uint*.

    method set-uint ( UInt $v_uint )

  * UInt $v_uint; unsigned integer value to be set

set-uint64
----------

Set the contents of a `G-TYPE-UINT64` **Gnome::GObject::Value** to *v-uint64*.

    method set-uint64 ( UInt $v_uint64 )

  * UInt $v_uint64; unsigned 64bit integer value to be set

set-ulong
---------

Set the contents of a `G-TYPE-ULONG` **Gnome::GObject::Value** to *v-ulong*.

    method set-ulong ( UInt $v_ulong )

  * UInt $v_ulong; unsigned long integer value to be set

set-variant
-----------

Set the contents of a variant **Gnome::GObject::Value** to *variant*. If the variant is floating, it is consumed.

    method set-variant ( N-GValue $variant )

  * N-GValue $variant; a **Gnome::GObject::Variant**, or `undefined`

take-string
-----------

Sets the contents of a `G-TYPE-STRING` **Gnome::GObject::Value** to *v-string*.

    method take-string ( Str $v_string )

  * Str $v_string; string to take ownership of

take-variant
------------

Set the contents of a variant **Gnome::GObject::Value** to *variant*, and takes over the ownership of the caller's reference to *variant*; the caller doesn't have to unref it any more (i.e. the reference count of the variant is not increased).

If *variant* was floating then its floating reference is converted to a hard reference.

If you want the **Gnome::GObject::Value** to hold its own reference to *variant*, use `set-variant()` instead.

This is an internal function introduced mainly for C marshallers.

    method take-variant ( N-GValue $variant )

  * N-GValue $variant; a **Gnome::GObject::Variant**, or `undefined`

transform
---------

Tries to cast the contents of this into a type appropriate to store in *$dest-value*, e.g. to transform a `G-TYPE-INT` value into a `G-TYPE-FLOAT` value. Performing transformations between value types might incur precision lossage. Especially transformations into strings might reveal seemingly arbitrary results and shouldn't be relied upon for production code (such as rcfile value or object property serialization).

Returns: Whether a transformation rule was found and could be applied. Upon failing transformations, *$dest-value* is left untouched.

    method transform ( N-GValue $dest_value --> Bool )

  * N-GValue $dest_value; Target value.

type-compatible
---------------

Returns whether a **N-GValue** of type *$src-type* can be copied into a **-GValue** of type *$dest-type*.

Returns: `True` if `copy()` is possible with *src-type* and *dest-type*.

    method type-compatible ( UInt $src_type, UInt $dest_type --> Bool )

  * UInt $src_type; source type to be copied.

  * UInt $dest_type; destination type for copying.

type-transformable
------------------

Check whether `transform()` is able to transform values of type *src-type* into values of type *dest-type*. Note that for the types to be transformable, they must be compatible or a transformation function must be registered.

Returns: `True` if the transformation is possible, `False` otherwise.

    method type-transformable ( UInt $src_type, UInt $dest_type --> Bool )

  * UInt $src_type; Source type.

  * UInt $dest_type; Target type.

