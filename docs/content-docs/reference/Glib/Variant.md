Gnome::Glib::Variant
====================

strongly typed value datatype

Description
===========

**Gnome::Glib::Variant** is a variant datatype; it can contain one or more values along with information about the type of the values.

A **Gnome::Glib::Variant** may contain simple types, like an integer, or a boolean value; or complex types, like an array of two strings, or a dictionary of key value pairs. A **Gnome::Glib::Variant** is also immutable: once it's been created neither its type nor its content can be modified further.

Gnome::Glib::Variant is useful whenever data needs to be serialized, for example when sending method parameters in DBus, or when saving settings using GSettings.

When creating a new **Gnome::Glib::Variant**, you pass the data you want to store in it along with a string representing the type of data you wish to pass to it.

For instance, if you want to create a **Gnome::Glib::Variant** holding an integer value you can use:

    my Gnome::Glib::Variant $v .= new( :type-string<ui>, :values([ 40, -40]));

The string "u" in the first argument tells **Gnome::Glib::Variant** that the data passed to the constructor (40) is going to be an unsigned integer.

More advanced examples of **Gnome::Glib::Variant** in use can be found in documentation for [GVariant format strings][gvariant-format-strings-pointers].

The range of possible values is determined by the type.

The type system used by **Gnome::Glib::Variant** is **Gnome::Glib::VariantType**.

**Gnome::Glib::Variant** instances always have a type and a value (which are given at construction time). The type and value of a **Gnome::Glib::Variant** instance can never change other than by the **Gnome::Glib::Variant** itself being destroyed. A **Gnome::Glib::Variant** cannot contain a pointer.

**Gnome::Glib::Variant** is completely threadsafe. A **Gnome::Glib::Variant** instance can be concurrently accessed in any way from any number of threads without problems.

**Gnome::Glib::Variant** is heavily optimised for dealing with data in serialised form. It works particularly well with data located in memory-mapped files. It can perform nearly all deserialisation operations in a small constant time, usually touching only a single memory page. Serialised **Gnome::Glib::Variant** data can also be sent over the network.

**Gnome::Glib::Variant** is largely compatible with D-Bus. Almost all types of **Gnome::Glib::Variant** instances can be sent over D-Bus. See **Gnome::Glib::VariantType** for exceptions. (However, **Gnome::Glib::Variant**'s serialisation format is not the same as the serialisation format of a D-Bus message body: use **GDBusMessage**, in the gio library, for those.)

For space-efficiency, the **Gnome::Glib::Variant** serialisation format does not automatically include the variant's length, type or endianness, which must either be implied from context (such as knowledge that a particular file format always contains a little-endian `G_VARIANT_TYPE_VARIANT` which occupies the whole length of the file) or supplied out-of-band (for instance, a length, type and/or endianness indicator could be placed at the beginning of a file, network message or network stream).

A **Gnome::Glib::Variant**'s size is limited mainly by any lower level operating system constraints, such as the number of bits in **gsize**. For example, it is reasonable to have a 2GB file mapped into memory with **GMappedFile**, and call `g_variant_new_from_data()` on it.

For convenience to C programmers, **Gnome::Glib::Variant** features powerful varargs-based value construction and destruction. This feature is designed to be embedded in other libraries.

Memory Use
----------

**Gnome::Glib::Variant** tries to be quite efficient with respect to memory use. This section gives a rough idea of how much memory is used by the current implementation. The information here is subject to change in the future.

The memory allocated by **Gnome::Glib::Variant** can be grouped into 4 broad purposes: memory for serialised data, memory for the type information cache, buffer management memory and memory for the **Gnome::Glib::Variant** structure itself.

### Serialised Data Memory

This is the memory that is used for storing GVariant data in serialised form. This is what would be sent over the network or what would end up on disk, not counting any indicator of the endianness, or of the length or type of the top-level variant.

The amount of memory required to store a boolean is 1 byte. 16, 32 and 64 bit integers and double precision floating point numbers use their "natural" size. Strings (including object path and signature strings) are stored with a nul terminator, and as such use the length of the string plus 1 byte.

Maybe types use no space at all to represent the null value and use the same amount of space (sometimes plus one byte) as the equivalent non-maybe-typed value to represent the non-null case.

Arrays use the amount of space required to store each of their members, concatenated. Additionally, if the items stored in an array are not of a fixed-size (ie: strings, other arrays, etc) then an additional framing offset is stored for each item. The size of this offset is either 1, 2 or 4 bytes depending on the overall size of the container. Additionally, extra padding bytes are added as required for alignment of child values.

Tuples (including dictionary entries) use the amount of space required to store each of their members, concatenated, plus one framing offset (as per arrays) for each non-fixed-sized item in the tuple, except for the last one. Additionally, extra padding bytes are added as required for alignment of child values.

Variants use the same amount of space as the item inside of the variant, plus 1 byte, plus the length of the type string for the item inside the variant.

As an example, consider a dictionary mapping strings to variants. In the case that the dictionary is empty, 0 bytes are required for the serialisation.

If we add an item "width" that maps to the int32 value of 500 then we will use 4 byte to store the int32 (so 6 for the variant containing it) and 6 bytes for the string. The variant must be aligned to 8 after the 6 bytes of the string, so that's 2 extra bytes. 6 (string) + 2 (padding) + 6 (variant) is 14 bytes used for the dictionary entry. An additional 1 byte is added to the array as a framing offset making a total of 15 bytes.

If we add another entry, "title" that maps to a nullable string that happens to have a value of null, then we use 0 bytes for the null value (and 3 bytes for the variant to contain it along with its type string) plus 6 bytes for the string. Again, we need 2 padding bytes. That makes a total of 6 + 2 + 3 = 11 bytes.

We now require extra padding between the two items in the array. After the 14 bytes of the first item, that's 2 bytes required. We now require 2 framing offsets for an extra two bytes. 14 + 2 + 11 + 2 = 29 bytes to encode the entire two-item dictionary.

## Type Information Cache

For each GVariant type that currently exists in the program a type information structure is kept in the type information cache. The type information structure is required for rapid deserialisation.

Continuing with the above example, if a **Gnome::Glib::Variant** exists with the type "a{sv}" then a type information struct will exist for "a{sv}", "{sv}", "s", and "v". Multiple uses of the same type will share the same type information. Additionally, all single-digit types are stored in read-only static memory and do not contribute to the writable memory footprint of a program using **Gnome::Glib::Variant**.

Aside from the type information structures stored in read-only memory, there are two forms of type information. One is used for container types where there is a single element type: arrays and maybe types. The other is used for container types where there are multiple element types: tuples and dictionary entries.

Array type info structures are 6 * sizeof (void *), plus the memory required to store the type string itself. This means that on 32-bit systems, the cache entry for "a{sv}" would require 30 bytes of memory (plus malloc overhead).

Tuple type info structures are 6 * sizeof (void *), plus 4 * sizeof (void *) for each item in the tuple, plus the memory required to store the type string itself. A 2-item tuple, for example, would have a type information structure that consumed writable memory in the size of 14 * sizeof (void *) (plus type string) This means that on 32-bit systems, the cache entry for "{sv}" would require 61 bytes of memory (plus malloc overhead).

This means that in total, for our "a{sv}" example, 91 bytes of type information would be allocated.

The type information cache, additionally, uses a **GHashTable** to store and lookup the cached items and stores a pointer to this hash table in static storage. The hash table is freed when there are zero items in the type cache.

Although these sizes may seem large it is important to remember that a program will probably only have a very small number of different types of values in it and that only one type information structure is required for many different values of the same type.

## Buffer Management Memory

**Gnome::Glib::Variant** uses an internal buffer management structure to deal with the various different possible sources of serialised data that it uses. The buffer is responsible for ensuring that the correct call is made when the data is no longer in use by **Gnome::Glib::Variant**. This may involve a `g_free()` or a `g_slice_free()` or even `g_mapped_file_unref()`.

One buffer management structure is used for each chunk of serialised data. The size of the buffer management structure is 4 * (void *). On 32-bit systems, that's 16 bytes.

## GVariant structure

The size of a **Gnome::Glib::Variant** structure is 6 * (void *). On 32-bit systems, that's 24 bytes.

**Gnome::Glib::Variant** structures only exist if they are explicitly created with API calls. For example, if a **Gnome::Glib::Variant** is constructed out of serialised data for the example given above (with the dictionary) then although there are 9 individual values that comprise the entire dictionary (two keys, two values, two variants containing the values, two dictionary entries, plus the dictionary itself), only 1 **Gnome::Glib::Variant** instance exists -- the one referring to the dictionary.

If calls are made to start accessing the other values then **Gnome::Glib::Variant** instances will exist for those values only for as long as they are in use (ie: until you call `g_variant_unref()`). The type information is shared. The serialised data and the buffer management structure for that serialised data is shared by the child.

## Summary

To put the entire example together, for our dictionary mapping strings to variants (with two entries, as given above), we are using 91 bytes of memory for type information, 29 bytes of memory for the serialised data, 16 bytes for buffer management and 24 bytes for the **Gnome::Glib::Variant** instance, or a total of 160 bytes, plus malloc overhead. If we were to use `g_variant_get_child_value()` to access the two dictionary entries, we would use an additional 48 bytes. If we were to have other dictionaries of the same type, we would use more memory for the serialised data and buffer management for those dictionaries, but the type information would be shared.

See Also
--------

[Gnome::Glib::VariantType](VariantType.html), [gvariant format strings](https://developer.gnome.org/glib/stable/gvariant-format-strings.html), [gvariant text format](https://developer.gnome.org/glib/stable/gvariant-text.html).

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Variant;

GVariantClass
-------------

Type constants
--------------

  * G_VARIANT_TYPE_BOOLEAN; The type of a value that can be either TRUE or FALSE.

  * G_VARIANT_TYPE_BYTE; The type of an integer value that can range from 0 to 255.

  * G_VARIANT_TYPE_INT16; The type of an integer value that can range from -32768 to 32767.

  * G_VARIANT_TYPE_UINT16; The type of an integer value that can range from 0 to 65535. There were about this many people living in Toronto in the 1870s.

  * G_VARIANT_TYPE_INT32; The type of an integer value that can range from -2147483648 to 2147483647.

  * G_VARIANT_TYPE_UINT32; The type of an integer value that can range from 0 to 4294967295. That's one number for everyone who was around in the late 1970s.

  * G_VARIANT_TYPE_INT64; The type of an integer value that can range from -9223372036854775808 to 9223372036854775807.

  * G_VARIANT_TYPE_UINT64; The type of an integer value that can range from 0 to 18446744073709551615 (inclusive). That's a really big number, but a Rubik's cube can have a bit more than twice as many possible positions.

  * G_VARIANT_TYPE_HANDLE; The type of a 32bit signed integer value, that by convention, is used as an index into an array of file descriptors that are sent alongside a D-Bus message. If you are not interacting with D-Bus, then there is no reason to make use of this type.

  * G_VARIANT_TYPE_DOUBLE; The type of a double precision IEEE754 floating point number. These guys go up to about 1.80e308 (plus and minus) but miss out on some numbers in between. In any case, that's far greater than the estimated number of fundamental particles in the observable universe.

  * G_VARIANT_TYPE_STRING; The type of a string. "" is a string. NULL is not a string.

  * G_VARIANT_TYPE_OBJECT_PATH; The type of a D-Bus object reference. These are strings of a specific format used to identify objects at a given destination on the bus. If you are not interacting with D-Bus, then there is no reason to make use of this type. If you are, then the D-Bus specification contains a precise description of valid object paths.

  * G_VARIANT_TYPE_SIGNATURE; The type of a D-Bus type signature. These are strings of a specific format used as type signatures for D-Bus methods and messages. If you are not interacting with D-Bus, then there is no reason to make use of this type. If you are, then the D-Bus specification contains a precise description of valid signature strings.

  * G_VARIANT_TYPE_VARIANT; The type of a box that contains any other value (including another variant).

  * G_VARIANT_TYPE_ANY; An indefinite type that is a supertype of every type (including itself).

  * G_VARIANT_TYPE_BASIC; An indefinite type that is a supertype of every basic (ie: non-container) type.

  * G_VARIANT_TYPE_MAYBE; An indefinite type that is a supertype of every maybe type.

  * G_VARIANT_TYPE_ARRAY; An indefinite type that is a supertype of every array type.

  * G_VARIANT_TYPE_TUPLE; An indefinite type that is a supertype of every tuple type, regardless of the number of items in the tuple.

  * G_VARIANT_TYPE_UNIT; The empty tuple type. Has only one instance. Known also as "triv" or "void".

  * G_VARIANT_TYPE_DICT_ENTRY; An indefinite type that is a supertype of every dictionary entry type.

  * G_VARIANT_TYPE_DICTIONARY; An indefinite type that is a supertype of every dictionary type -- that is, any array type that has an element type equal to any dictionary entry type.

  * G_VARIANT_TYPE_STRINGARRAY; The type of an array of strings.

  * G_VARIANT_TYPE_OBJECT_PATH_ARRAY; The type of an array of object paths.

  * G_VARIANT_TYPE_BYTESTRING; The type of an array of bytes. This type is commonly used to pass around strings that may not be valid utf8. In that case, the convention is that the nul terminator character should be included as the last character in the array.

  * G_VARIANT_TYPE_BYTESTRING_ARRAY; The type of an array of byte strings (an array of arrays of bytes).

  * G_VARIANT_TYPE_VARDICT; The type of a dictionary mapping strings to variants (the ubiquitous "a{sv}" type).

Methods
=======

new
---

Create a new Variant object.

    multi method new ( Str :$type-string!, Array :$values! )

Create a new Variant object by parsing the type and data provided in strings.

    multi method new ( Str :$type-string!, Str :$data-string! )

Create a Variant object using a native object from elsewhere.

    multi method new ( N-GVariant :$native-object! )

clear-object
------------

Clear the error and return data to memory pool. The error object is not valid after this call and `is-valid()` will return `False`.

    method clear-object ()

[g_variant_] get_type
---------------------

Determines the type of *value*.

The return value is valid for the lifetime of *value* and must not be freed.

Returns: a **Gnome::Glib::VariantType**

    method g_variant_get_type ( --> N-GVariant )

[g_variant_] get_type_string
----------------------------

Returns the type string of *value*. Unlike the result of calling `g_variant_type_peek_string()`, this string is nul-terminated. This string belongs to **Gnome::Glib::Variant** and must not be freed.

Returns: the type string for the type of *value*

    method g_variant_get_type_string ( --> Str )

[g_variant_] is_of_type
-----------------------

Checks if a value has a type matching the provided type.

Returns: `1` if the type of *value* matches *type*

    method g_variant_is_of_type ( N-GVariant $type --> Int )

  * N-GVariant $type; a **Gnome::Glib::VariantType**

[g_variant_] is_container
-------------------------

Checks if *value* is a container.

Returns: `1` if *value* is a container

    method g_variant_is_container ( --> Int )

g_variant_classify
------------------

Classifies *value* according to its top-level type.

Returns: the **Gnome::Glib::VariantClass** of *value*

    method g_variant_classify ( --> int32 )

To get the enumerated value do

    GVariantClass(Buf.new($v.g-variant-classify).decode)

[g_variant_] new_boolean
------------------------

Creates a new boolean **Gnome::Glib::Variant** instance -- either `1` or `0`.

Returns: (transfer none): a floating reference to a new boolean **Gnome::Glib::Variant** instance

    method g_variant_new_boolean ( Int $value --> N-GVariant )

  * Int $value; a **gboolean** value

[g_variant_] new_byte
---------------------

Creates a new byte **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new byte **Gnome::Glib::Variant** instance

    method g_variant_new_byte ( UInt $value --> N-GVariant )

  * UInt $value; a **guint8** value

[g_variant_] new_int16
----------------------

Creates a new int16 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new int16 **Gnome::Glib::Variant** instance

    method g_variant_new_int16 ( Int $value --> N-GVariant )

  * Int $value; a **gint16** value

[g_variant_] new_uint16
-----------------------

Creates a new uint16 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new uint16 **Gnome::Glib::Variant** instance

    method g_variant_new_uint16 ( UInt $value --> N-GVariant )

  * UInt $value; a **guint16** value

[g_variant_] new_int32
----------------------

Creates a new int32 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new int32 **Gnome::Glib::Variant** instance

    method g_variant_new_int32 ( Int $value --> N-GVariant )

  * Int $value; a **gint32** value

[g_variant_] new_uint32
-----------------------

Creates a new uint32 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new uint32 **Gnome::Glib::Variant** instance

    method g_variant_new_uint32 ( UInt $value --> N-GVariant )

  * UInt $value; a **guint32** value

[g_variant_] new_int64
----------------------

Creates a new int64 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new int64 **Gnome::Glib::Variant** instance

    method g_variant_new_int64 ( Int $value --> N-GVariant )

  * Int $value; a **gint64** value

[g_variant_] new_uint64
-----------------------

Creates a new uint64 **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new uint64 **Gnome::Glib::Variant** instance

    method g_variant_new_uint64 ( UInt $value --> N-GVariant )

  * UInt $value; a **guint64** value

[g_variant_] new_handle
-----------------------

Creates a new handle **Gnome::Glib::Variant** instance.

By convention, handles are indexes into an array of file descriptors that are sent alongside a D-Bus message. If you're not interacting with D-Bus, you probably don't need them.

Returns: (transfer none): a floating reference to a new handle **Gnome::Glib::Variant** instance

    method g_variant_new_handle ( Int $value --> N-GVariant )

  * Int $value; a **gint32** value

[g_variant_] new_double
-----------------------

Creates a new double **Gnome::Glib::Variant** instance.

Returns: (transfer none): a floating reference to a new double **Gnome::Glib::Variant** instance

    method g_variant_new_double ( Num $value --> N-GVariant )

  * Num $value; a **gdouble** floating point value

[g_variant_] new_string
-----------------------

Creates a string **Gnome::Glib::Variant** with the contents of *string*.

*string* must be valid UTF-8, and must not be `Any`. To encode potentially-`Any` strings, use `g_variant_new()` with `ms` as the [format string][gvariant-format-strings-maybe-types].

Returns: (transfer none): a floating reference to a new string **Gnome::Glib::Variant** instance

    method g_variant_new_string ( Str $string --> N-GVariant )

  * Str $string; a normal UTF-8 nul-terminated string

[g_variant_] new_take_string
----------------------------

Creates a string **Gnome::Glib::Variant** with the contents of *string*.

*string* must be valid UTF-8, and must not be `Any`. To encode potentially-`Any` strings, use this with `g_variant_new_maybe()`.

This function consumes *string*. `g_free()` will be called on *string* when it is no longer required.

You must not modify or access *string* in any other way after passing it to this function. It is even possible that *string* is immediately freed.

Returns: (transfer none): a floating reference to a new string **Gnome::Glib::Variant** instance

    method g_variant_new_take_string ( Str $string --> N-GVariant )

  * Str $string; a normal UTF-8 nul-terminated string

[g_variant_] new_object_path
----------------------------

Creates a D-Bus object path **Gnome::Glib::Variant** with the contents of *string*. *string* must be a valid D-Bus object path. Use `g_variant_is_object_path()` if you're not sure.

Returns: (transfer none): a floating reference to a new object path **Gnome::Glib::Variant** instance

    method g_variant_new_object_path ( Str $object_path --> N-GVariant )

  * Str $object_path; a normal C nul-terminated string

[g_variant_] is_object_path
---------------------------

Determines if a given string is a valid D-Bus object path. You should ensure that a string is a valid D-Bus object path before passing it to `g_variant_new_object_path()`.

A valid object path starts with `/` followed by zero or more sequences of characters separated by `/` characters. Each sequence must contain only the characters `[A-Z][a-z][0-9]_`. No sequence (including the one following the final `/` character) may be empty.

Returns: `1` if *string* is a D-Bus object path

    method g_variant_is_object_path ( Str $string --> Int )

  * Str $string; a normal C nul-terminated string

[g_variant_] new_signature
--------------------------

Creates a D-Bus type signature **Gnome::Glib::Variant** with the contents of *string*. *string* must be a valid D-Bus type signature. Use `g_variant_is_signature()` if you're not sure.

Returns: (transfer none): a floating reference to a new signature **Gnome::Glib::Variant** instance

    method g_variant_new_signature ( Str $signature --> N-GVariant )

  * Str $signature; a normal C nul-terminated string

[g_variant_] is_signature
-------------------------

Determines if a given string is a valid D-Bus type signature. You should ensure that a string is a valid D-Bus type signature before passing it to `g_variant_new_signature()`.

D-Bus type signatures consist of zero or more definite **Gnome::Glib::VariantType** strings in sequence.

Returns: `1` if *string* is a D-Bus type signature

    method g_variant_is_signature ( Str $string --> Int )

  * Str $string; a normal C nul-terminated string

[g_variant_] new_variant
------------------------

Boxes *value*. The result is a **Gnome::Glib::Variant** instance representing a variant containing the original value.

If *child* is a floating reference (see `g_variant_ref_sink()`), the new instance takes ownership of *child*.

Returns: (transfer none): a floating reference to a new variant **Gnome::Glib::Variant** instance

    method g_variant_new_variant ( --> N-GVariant )

[g_variant_] new_strv
---------------------

Constructs an array of strings **Gnome::Glib::Variant** from the given array of strings.

If *length* is -1 then *strv* is `Any`-terminated.

Returns: (transfer none): a new floating **Gnome::Glib::Variant** instance

    method g_variant_new_strv ( CArray[Str] $strv, Int $length --> N-GVariant )

  * CArray[Str] $strv; (array length=length) (element-type utf8): an array of strings

  * Int $length; the length of *strv*, or -1

[g_variant_] new_bytestring
---------------------------

Creates an array-of-bytes **Gnome::Glib::Variant** with the contents of *string*. This function is just like `g_variant_new_string()` except that the string need not be valid UTF-8.

The nul terminator character at the end of the string is stored in the array.

Returns: (transfer none): a floating reference to a new bytestring **Gnome::Glib::Variant** instance

    method g_variant_new_bytestring ( Str $string --> N-GVariant )

  * Str $string; (array zero-terminated=1) (element-type guint8): a normal nul-terminated string in no particular encoding

[g_variant_] new_bytestring_array
---------------------------------

Constructs an array of bytestring **Gnome::Glib::Variant** from the given array of strings.

If *length* is -1 then *strv* is `Any`-terminated.

Returns: (transfer none): a new floating **Gnome::Glib::Variant** instance

    method g_variant_new_bytestring_array ( CArray[Str] $strv, Int $length --> N-GVariant )

  * CArray[Str] $strv; (array length=length): an array of strings

  * Int $length; the length of *strv*, or -1

[g_variant_] new_fixed_array
----------------------------

Constructs a new array **Gnome::Glib::Variant** instance, where the elements are of *element_type* type.

*elements* must be an array with fixed-sized elements. Numeric types are fixed-size as are tuples containing only other fixed-sized types.

*element_size* must be the size of a single element in the array. For example, if calling this function for an array of 32-bit integers, you might say sizeof(gint32). This value isn't used except for the purpose of a double-check that the form of the serialised data matches the caller's expectation.

*n_elements* must be the length of the *elements* array.

Returns: (transfer none): a floating reference to a new array **Gnome::Glib::Variant** instance

    method g_variant_new_fixed_array ( N-GVariant $element_type, Pointer $elements, UInt $n_elements, UInt $element_size --> N-GVariant )

  * N-GVariant $element_type; the **Gnome::Glib::VariantType** of each element

  * Pointer $elements; a pointer to the fixed array of contiguous elements

  * UInt $n_elements; the number of elements

  * UInt $element_size; the size of each element

[g_variant_] get_boolean
------------------------

Returns the boolean value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_BOOLEAN`.

Returns: `1` or `0`

    method g_variant_get_boolean ( --> Int )

[g_variant_] get_byte
---------------------

Returns the byte value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_BYTE`.

Returns: a **guint8**

    method g_variant_get_byte ( --> UInt )

[g_variant_] get_int16
----------------------

Returns the 16-bit signed integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT16`.

Returns: a **gint16**

    method g_variant_get_int16 ( --> Int )

[g_variant_] get_uint16
-----------------------

Returns the 16-bit unsigned integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT16`.

Returns: a **guint16**

    method g_variant_get_uint16 ( --> UInt )

[g_variant_] get_int32
----------------------

Returns the 32-bit signed integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT32`.

Returns: a **gint32**

    method g_variant_get_int32 ( --> Int )

[g_variant_] get_uint32
-----------------------

Returns the 32-bit unsigned integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT32`.

Returns: a **guint32**

    method g_variant_get_uint32 ( --> UInt )

[g_variant_] get_int64
----------------------

Returns the 64-bit signed integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT64`.

Returns: a **gint64**

    method g_variant_get_int64 ( --> Int )

[g_variant_] get_uint64
-----------------------

Returns the 64-bit unsigned integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT64`.

Returns: a **guint64**

    method g_variant_get_uint64 ( --> UInt )

[g_variant_] get_handle
-----------------------

Returns the 32-bit signed integer value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_HANDLE`.

By convention, handles are indexes into an array of file descriptors that are sent alongside a D-Bus message. If you're not interacting with D-Bus, you probably don't need them.

Returns: a **gint32**

    method g_variant_get_handle ( --> Int )

[g_variant_] get_double
-----------------------

Returns the double precision floating point value of *value*.

It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_DOUBLE`.

Returns: a **gdouble**

    method g_variant_get_double ( --> Num )

[g_variant_] get_variant
------------------------

Unboxes *value*. The result is the **Gnome::Glib::Variant** instance that was contained in *value*.

Returns: (transfer full): the item contained in the variant

    method g_variant_get_variant ( --> N-GVariant )

[g_variant_] get_string
-----------------------

Returns the string value of a **Gnome::Glib::Variant** instance with a string type. This includes the types `G_VARIANT_TYPE_STRING`, `G_VARIANT_TYPE_OBJECT_PATH` and `G_VARIANT_TYPE_SIGNATURE`.

The string will always be UTF-8 encoded, and will never be `Any`.

If *length* is non-`Any` then the length of the string (in bytes) is returned there. For trusted values, this information is already known. For untrusted values, a `strlen()` will be performed.

It is an error to call this function with a *value* of any type other than those three.

The return value remains valid as long as *value* exists.

Returns: (transfer none): the constant string, UTF-8 encoded

    method g_variant_get_string ( UInt $length --> Str )

  * UInt $length; (optional) (default 0) (out): a pointer to a **gsize**, to store the length

[g_variant_] dup_string
-----------------------

Similar to `g_variant_get_string()` except that instead of returning a constant string, the string is duplicated.

The string will always be UTF-8 encoded.

The return value must be freed using `g_free()`.

Returns: (transfer full): a newly allocated string, UTF-8 encoded

    method g_variant_dup_string ( UInt $length --> Str )

  * UInt $length; (out): a pointer to a **gsize**, to store the length

[g_variant_] get_strv
---------------------

Gets the contents of an array of strings **Gnome::Glib::Variant**. This call makes a shallow copy; the return result should be released with `g_free()`, but the individual strings must not be modified.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length zero-terminated=1) (transfer container): an array of constant strings

    method g_variant_get_strv ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] dup_strv
---------------------

Gets the contents of an array of strings **Gnome::Glib::Variant**. This call makes a deep copy; the return result should be released with `g_strfreev()`.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length zero-terminated=1) (transfer full): an array of strings

    method g_variant_dup_strv ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] get_objv
---------------------

Gets the contents of an array of object paths **Gnome::Glib::Variant**. This call makes a shallow copy; the return result should be released with `g_free()`, but the individual strings must not be modified.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length zero-terminated=1) (transfer container): an array of constant strings

    method g_variant_get_objv ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] dup_objv
---------------------

Gets the contents of an array of object paths **Gnome::Glib::Variant**. This call makes a deep copy; the return result should be released with `g_strfreev()`.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length zero-terminated=1) (transfer full): an array of strings

    method g_variant_dup_objv ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] get_bytestring
---------------------------

Returns the string value of a **Gnome::Glib::Variant** instance with an array-of-bytes type. The string has no particular encoding.

If the array does not end with a nul terminator character, the empty string is returned. For this reason, you can always trust that a non-`Any` nul-terminated string will be returned by this function.

If the array contains a nul terminator character somewhere other than the last byte then the returned string is the string, up to the first such nul character.

`g_variant_get_fixed_array()` should be used instead if the array contains arbitrary data that could not be nul-terminated or could contain nul bytes.

It is an error to call this function with a *value* that is not an array of bytes.

The return value remains valid as long as *value* exists.

Returns: (transfer none) (array zero-terminated=1) (element-type guint8): the constant string

    method g_variant_get_bytestring ( --> Str )

[g_variant_] dup_bytestring
---------------------------

Similar to `g_variant_get_bytestring()` except that instead of returning a constant string, the string is duplicated.

The return value must be freed using `g_free()`.

Returns: (transfer full) (array zero-terminated=1 length=length) (element-type guint8): a newly allocated string

    method g_variant_dup_bytestring ( UInt $length --> Str )

  * UInt $length; (out) (optional) (default NULL): a pointer to a **gsize**, to store the length (not including the nul terminator)

[g_variant_] get_bytestring_array
---------------------------------

Gets the contents of an array of array of bytes **Gnome::Glib::Variant**. This call makes a shallow copy; the return result should be released with `g_free()`, but the individual strings must not be modified.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length) (transfer container): an array of constant strings

    method g_variant_get_bytestring_array ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] dup_bytestring_array
---------------------------------

Gets the contents of an array of array of bytes **Gnome::Glib::Variant**. This call makes a deep copy; the return result should be released with `g_strfreev()`.

If *length* is non-`Any` then the number of elements in the result is stored there. In any case, the resulting array will be `Any`-terminated.

For an empty array, *length* will be set to 0 and a pointer to a `Any` pointer will be returned.

Returns: (array length=length) (transfer full): an array of strings

    method g_variant_dup_bytestring_array ( UInt $length --> CArray[Str] )

  * UInt $length; (out) (optional): the length of the result, or `Any`

[g_variant_] new_maybe
----------------------

Depending on if *child* is `Any`, either wraps *child* inside of a maybe container or creates a Nothing instance for the given *type*.

At least one of *child_type* and *child* must be non-`Any`. If *child_type* is non-`Any` then it must be a definite type. If they are both non-`Any` then *child_type* must be the type of *child*.

If *child* is a floating reference (see `g_variant_ref_sink()`), the new instance takes ownership of *child*.

Returns: (transfer none): a floating reference to a new **Gnome::Glib::Variant** maybe instance

    method g_variant_new_maybe ( N-GVariant $child_type, N-GVariant $child --> N-GVariant )

  * N-GVariant $child_type; (nullable): the **Gnome::Glib::VariantType** of the child, or `Any`

  * N-GVariant $child; (nullable): the child value, or `Any`

[g_variant_] new_dict_entry
---------------------------

Creates a new dictionary entry **Gnome::Glib::Variant**. *key* and *value* must be non-`Any`. *key* must be a value of a basic type (ie: not a container).

If the *key* or *value* are floating references (see `g_variant_ref_sink()`), the new instance takes ownership of them as if via `g_variant_ref_sink()`.

Returns: (transfer none): a floating reference to a new dictionary entry **Gnome::Glib::Variant**

    method g_variant_new_dict_entry ( N-GVariant $value --> N-GVariant )

  * N-GVariant $value; a **Gnome::Glib::Variant**, the value

[g_variant_] get_maybe
----------------------

Given a maybe-typed **Gnome::Glib::Variant** instance, extract its value. If the value is Nothing, then this function returns `Any`.

Returns: (nullable) (transfer full): the contents of *value*, or `Any`

    method g_variant_get_maybe ( --> N-GVariant )

[g_variant_] n_children
-----------------------

    method g_variant_n_children ( --> UInt )

[g_variant_] get_child_value
----------------------------

    method g_variant_get_child_value ( UInt $index --> N-GVariant )

  * UInt $index;

[g_variant_] lookup_value
-------------------------

Looks up a value in a dictionary **Gnome::Glib::Variant**.

This function works with dictionaries of the type a{s*} (and equally well with type a{o*}, but we only further discuss the string case for sake of clarity).

In the event that *dictionary* has the type a{sv}, the *expected_type* string specifies what type of value is expected to be inside of the variant. If the value inside the variant has a different type then `Any` is returned. In the event that *dictionary* has a value type other than v then *expected_type* must directly match the value type and it is used to unpack the value directly or an error occurs.

In either case, if *key* is not found in *dictionary*, `Any` is returned.

If the key is found and the value has the correct type, it is returned. If *expected_type* was specified then any non-`Any` return value will have this type.

This function is currently implemented with a linear scan. If you plan to do many lookups then **Gnome::Glib::VariantDict** may be more efficient.

Returns: (transfer full): the value of the dictionary key, or `Any`

    method g_variant_lookup_value ( Str $key, N-GVariant $expected_type --> N-GVariant )

  * Str $key; the key to lookup in the dictionary

  * N-GVariant $expected_type; (nullable): a **Gnome::Glib::VariantType**, or `Any`

[g_variant_] get_fixed_array
----------------------------

Provides access to the serialised data for an array of fixed-sized items.

*value* must be an array with fixed-sized elements. Numeric types are fixed-size, as are tuples containing only other fixed-sized types.

*element_size* must be the size of a single element in the array, as given by the section on [serialized data memory][gvariant-serialised-data-memory].

In particular, arrays of these fixed-sized types can be interpreted as an array of the given C type, with *element_size* set to the size the appropriate type: - `G_VARIANT_TYPE_INT16` (etc.): **gint16** (etc.) - `G_VARIANT_TYPE_BOOLEAN`: **guchar** (not **gboolean**!) - `G_VARIANT_TYPE_BYTE`: **guint8** - `G_VARIANT_TYPE_HANDLE`: **guint32** - `G_VARIANT_TYPE_DOUBLE`: **gdouble**

For example, if calling this function for an array of 32-bit integers, you might say `sizeof(gint32)`. This value isn't used except for the purpose of a double-check that the form of the serialised data matches the caller's expectation.

*n_elements*, which must be non-`Any`, is set equal to the number of items in the array.

Returns: (array length=n_elements) (transfer none): a pointer to the fixed array

    method g_variant_get_fixed_array ( UInt $n_elements, UInt $element_size --> Pointer )

  * UInt $n_elements; (out): a pointer to the location to store the number of items

  * UInt $element_size; the size of each element

[g_variant_] get_size
---------------------

    method g_variant_get_size ( --> UInt )

[g_variant_] get_data
---------------------

    method g_variant_get_data ( --> Pointer )

[g_variant_] get_data_as_bytes
------------------------------

    method g_variant_get_data_as_bytes ( --> N-GVariant )

g_variant_store
---------------

    method g_variant_store ( Pointer $data )

  * Pointer $data;

g_variant_print
---------------

Pretty-prints *value* in the format understood by `g_variant_parse()`.

The format is described [here][gvariant-text].

If *type_annotate* is `1`, then type information is included in the output.

Returns: (transfer full): a newly-allocated string holding the result.

    method g_variant_print ( Int $type_annotate --> Str )

  * Int $type_annotate; `1` if type information should be included in the output

[g_variant_] print_string
-------------------------

Behaves as `g_variant_print()`, but operates on a **GString**.

If *string* is non-`Any` then it is appended to and returned. Else, a new empty **GString** is allocated and it is returned.

Returns: a **GString** containing the string

    method g_variant_print_string ( N-GVariant $string, Int $type_annotate --> N-GVariant )

  * N-GVariant $string; (nullable) (default NULL): a **GString**, or `Any`

  * Int $type_annotate; `1` if type information should be included in the output

g_variant_hash
--------------

Generates a hash value for a **Gnome::Glib::Variant** instance.

The output of this function is guaranteed to be the same for a given value only per-process. It may change between different processor architectures or even different versions of GLib. Do not use this function as a basis for building protocols or file formats.

The type of *value* is **gconstpointer** only to allow use of this function with **GHashTable**. *value* must be a **Gnome::Glib::Variant**.

Returns: a hash value corresponding to *value*

    method g_variant_hash ( Pointer $value --> UInt )

  * Pointer $value; (type GVariant): a basic **Gnome::Glib::Variant** value as a **gconstpointer**

g_variant_equal
---------------

Checks if *one* and *two* have the same type and value.

The types of *one* and *two* are **gconstpointer** only to allow use of this function with **GHashTable**. They must each be a **Gnome::Glib::Variant**.

Returns: `1` if *one* and *two* are equal

    method g_variant_equal ( Pointer $one, Pointer $two --> Int )

  * Pointer $one; (type GVariant): a **Gnome::Glib::Variant** instance

  * Pointer $two; (type GVariant): a **Gnome::Glib::Variant** instance

[g_variant_] get_normal_form
----------------------------

Gets a **Gnome::Glib::Variant** instance that has the same value as *value* and is trusted to be in normal form.

If *value* is already trusted to be in normal form then a new reference to *value* is returned.

If *value* is not already trusted, then it is scanned to check if it is in normal form. If it is found to be in normal form then it is marked as trusted and a new reference to it is returned.

If *value* is found not to be in normal form then a new trusted **Gnome::Glib::Variant** is created with the same value as *value*.

It makes sense to call this function if you've received **Gnome::Glib::Variant** data from untrusted sources and you want to ensure your serialised output is definitely in normal form.

If *value* is already in normal form, a new reference will be returned (which will be floating if *value* is floating). If it is not in normal form, the newly created **Gnome::Glib::Variant** will be returned with a single non-floating reference. Typically, `g_variant_take_ref()` should be called on the return value from this function to guarantee ownership of a single non-floating reference to it.

Returns: (transfer full): a trusted **Gnome::Glib::Variant**

    method g_variant_get_normal_form ( --> N-GVariant )

[g_variant_] is_normal_form
---------------------------

    method g_variant_is_normal_form ( --> Int )

g_variant_byteswap
------------------

Performs a byteswapping operation on the contents of *value*. The result is that all multi-byte numeric data contained in *value* is byteswapped. That includes 16, 32, and 64bit signed and unsigned integers as well as file handles and double precision floating point values.

This function is an identity mapping on any value that does not contain multi-byte numeric data. That include strings, booleans, bytes and containers containing only these things (recursively).

The returned value is always in normal form and is marked as trusted.

Returns: (transfer full): the byteswapped form of *value*

    method g_variant_byteswap ( --> N-GVariant )

[g_variant_] new_from_bytes
---------------------------

    method g_variant_new_from_bytes ( N-GVariant $type, N-GVariant $bytes, Int $trusted --> N-GVariant )

  * N-GVariant $type;

  * N-GVariant $bytes;

  * Int $trusted;

[g_variant_] parse_error_quark
------------------------------

    method g_variant_parse_error_quark ( --> Int )

g_variant_new
-------------

Creates a new GVariant instance.

The type of the created instance and the arguments that are expected by this function are determined by format_string. Please note that the syntax of the format string is very likely to be extended in the future.

The first character of the format string must not be '*' '?' '@' or 'r'; in essence, a new Gnome::Glib::Variant must always be constructed by this function (and not merely passed through it unmodified).

Note that the arguments must be of the correct width for their types specified in format_string.

    method g_variant_new ( Str $type-string --> N-GVariant )

  * Str $format_string;

[g_variant_] check_format_string
--------------------------------

Checks if calling `g_variant_get()` with *format_string* on *value* would be valid from a type-compatibility standpoint. *format_string* is assumed to be a valid format string (from a syntactic standpoint).

If *copy_only* is `1` then this function additionally checks that it would be safe to call `g_variant_unref()` on *value* immediately after the call to `g_variant_get()` without invalidating the result. This is only possible if deep copies are made (ie: there are no pointers to the data inside of the soon-to-be-freed **Gnome::Glib::Variant** instance). If this check fails then a `g_critical()` is printed and `0` is returned.

This function is meant to be used by functions that wish to provide varargs accessors to **Gnome::Glib::Variant** values of uncertain values (eg: `g_variant_lookup()` or `g_menu_model_get_item_attribute()`).

Returns: `1` if *format_string* is safe to use

    method g_variant_check_format_string ( Str $format_string, Int $copy_only --> Int )

  * Str $format_string; a valid **Gnome::Glib::Variant** format string

  * Int $copy_only; `1` to ensure the format string makes deep copies

g_variant_parse
---------------

Parses a GVariant from a text representation.

In the event that the parsing is successful, the resulting GVariant is returned.

In case of any error, NULL will be returned. If error is non-NULL then it will be set to reflect the error that occurred.

There may be implementation specific restrictions on deeply nested values, which would result in a G_VARIANT_PARSE_ERROR_RECURSION error. GVariant is guaranteed to handle nesting up to at least 64 levels.

    method g_variant_parse ( Str $type-string, Str $text --> List )

  * Str $type-string; String like it is used to create a Gnome::Glib::VariantType

  * Str $text; Textual representation of data.

The returned List has members

  * N-GVariant object. A native variant object

  * Gnome::Glib::Error. The error object. Test for `.is-valid() ~~ False` to see if parsing went ok and that the variant object is defined.

An example

    # Create an empty Variant to be able to call the parse method
    my Gnome::Glib::Variant $v .= new(:native-object(N-GVariant));

    # Then create a native variant object holding an array of 2 unsigned integers
    my ( N-GVariant $nv, Gnome::Glib::Error $e) =
      $v.g-variant-parse( 'au', '[100,200]');

See also the [GVariant Text Format](https://developer.gnome.org/glib/stable/gvariant-text.html).

[g_variant_] parse_error_print_context
--------------------------------------

    method g_variant_parse_error_print_context ( N-GError $error, Str $source_str --> Str )

  * N-GError $error;

  * Str $source_str;

g_variant_compare
-----------------

Compares *one* and *two*.

The types of *one* and *two* are **gconstpointer** only to allow use of this function with **GTree**, **GPtrArray**, etc. They must each be a **Gnome::Glib::Variant**.

Comparison is only defined for basic types (ie: booleans, numbers, strings). For booleans, `0` is less than `1`. Numbers are ordered in the usual way. Strings are in ASCII lexographical order.

It is a programmer error to attempt to compare container values or two values that have types that are not exactly equal. For example, you cannot compare a 32-bit signed integer with a 32-bit unsigned integer. Also note that this function is not particularly well-behaved when it comes to comparison of doubles; in particular, the handling of incomparable values (ie: NaN) is undefined.

If you only require an equality comparison, `g_variant_equal()` is more general.

Returns: negative value if a < b; zero if a = b; positive value if a > b.

    method g_variant_compare ( Pointer $one, Pointer $two --> Int )

  * Pointer $one; (type GVariant): a basic-typed **Gnome::Glib::Variant** instance

  * Pointer $two; (type GVariant): a **Gnome::Glib::Variant** instance of the same type

