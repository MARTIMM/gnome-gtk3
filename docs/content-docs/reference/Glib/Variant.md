Gnome::Glib::Variant
====================

Strongly typed value datatype

Description
===========

**Gnome::Glib::Variant** is a variant datatype; it can contain one or more values along with information about the type of the values.

A **Gnome::Glib::Variant** may contain simple types, like an integer, or a boolean value; or complex types, like an array of two strings, or a dictionary of key value pairs. A **Gnome::Glib::Variant** is also immutable: once it's been created neither its type nor its content can be modified further.

**Gnome::Glib::Variant** is useful whenever data needs to be serialized, for example when sending method parameters in DBus, or when saving settings using **Gnome::Glib::Settings**.

When creating a new **Gnome::Glib::Variant**, you pass the data you want to store in it along with a string representing the type of data you wish to pass to it.

For instance, if you want to create a **Gnome::Glib::Variant** holding an integer value you can use:

    my Gnome::Glib::Variant $v .= new(
      :type-string<u>, :value(42)
    );

The string "u" in the first argument tells **Gnome::Glib::Variant** that the data passed to the constructor (40) is going to be an unsigned 32 bit integer.

As an alternative you can write

    my Gnome::Glib::Variant $v .= new(:parse('-42'));

where the default used type is a signed 32 bit integer. To use an other integer type, write the type with it.

    my Gnome::Glib::Variant $v .= new(:parse('uint64 42'));

More advanced examples of **Gnome::Glib::Variant** in use can be found in documentation for GVariant format strings.

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

### Type Information Cache

For each GVariant type that currently exists in the program a type information structure is kept in the type information cache. The type information structure is required for rapid deserialisation.

Continuing with the above example, if a **Gnome::Glib::Variant** exists with the type "a{sv}" then a type information struct will exist for "a{sv}", "{sv}", "s", and "v". Multiple uses of the same type will share the same type information. Additionally, all single-digit types are stored in read-only static memory and do not contribute to the writable memory footprint of a program using **Gnome::Glib::Variant**.

Aside from the type information structures stored in read-only memory, there are two forms of type information. One is used for container types where there is a single element type: arrays and maybe types. The other is used for container types where there are multiple element types: tuples and dictionary entries.

Array type info structures are 6 * sizeof (void *), plus the memory required to store the type string itself. This means that on 32-bit systems, the cache entry for "a{sv}" would require 30 bytes of memory (plus malloc overhead).

Tuple type info structures are 6 * sizeof (void *), plus 4 * sizeof (void *) for each item in the tuple, plus the memory required to store the type string itself. A 2-item tuple, for example, would have a type information structure that consumed writable memory in the size of 14 * sizeof (void *) (plus type string) This means that on 32-bit systems, the cache entry for "{sv}" would require 61 bytes of memory (plus malloc overhead).

This means that in total, for our "a{sv}" example, 91 bytes of type information would be allocated.

The type information cache, additionally, uses a **GHashTable** to store and lookup the cached items and stores a pointer to this hash table in static storage. The hash table is freed when there are zero items in the type cache.

Although these sizes may seem large it is important to remember that a program will probably only have a very small number of different types of values in it and that only one type information structure is required for many different values of the same type.

### Buffer Management Memory

**Gnome::Glib::Variant** uses an internal buffer management structure to deal with the various different possible sources of serialised data that it uses. The buffer is responsible for ensuring that the correct call is made when the data is no longer in use by **Gnome::Glib::Variant**. This may involve a `g_free()` or a `g_slice_free()` or even `g_mapped_file_unref()`.

One buffer management structure is used for each chunk of serialised data. The size of the buffer management structure is 4 * (void *). On 32-bit systems, that's 16 bytes.

## GVariant structure

The size of a **Gnome::Glib::Variant** structure is 6 * (void *). On 32-bit systems, that's 24 bytes.

**Gnome::Glib::Variant** structures only exist if they are explicitly created with API calls. For example, if a **Gnome::Glib::Variant** is constructed out of serialised data for the example given above (with the dictionary) then although there are 9 individual values that comprise the entire dictionary (two keys, two values, two variants containing the values, two dictionary entries, plus the dictionary itself), only 1 **Gnome::Glib::Variant** instance exists -- the one referring to the dictionary.

If calls are made to start accessing the other values then **Gnome::Glib::Variant** instances will exist for those values only for as long as they are in use (ie: until you call `g_variant_unref()`). The type information is shared. The serialised data and the buffer management structure for that serialised data is shared by the child.

### Summary

To put the entire example together, for our dictionary mapping strings to variants (with two entries, as given above), we are using 91 bytes of memory for type information, 29 bytes of memory for the serialised data, 16 bytes for buffer management and 24 bytes for the **Gnome::Glib::Variant** instance, or a total of 160 bytes, plus malloc overhead. If we were to use `g_variant_get_child_value()` to access the two dictionary entries, we would use an additional 48 bytes. If we were to have other dictionaries of the same type, we would use more memory for the serialised data and buffer management for those dictionaries, but the type information would be shared.

See Also
--------

[Gnome::Glib::VariantType](VariantType.html), [variant format strings](https://developer.gnome.org/glib/stable/gvariant-format-strings.html), [variant text format](https://developer.gnome.org/glib/stable/gvariant-text.html).

  * [Variant dictionaries](VariantDict.html)

  * [Variant types](VariantType.html)

  * [Variant format strings](https://developer.gnome.org/glib/stable/gvariant-format-strings.html)

  * [Variant text format](https://developer.gnome.org/glib/stable/gvariant-text.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Variant;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

GVariantClass
-------------

The range of possible top-level types of GVariant instances.

  * G_VARIANT_CLASS_BOOLEAN; The GVariant is a boolean.

  * G_VARIANT_CLASS_BYTE; The GVariant is a byte.

  * G_VARIANT_CLASS_INT16; The GVariant is a signed 16 bit integer.

  * G_VARIANT_CLASS_UINT16; The GVariant is an unsigned 16 bit integer.

  * G_VARIANT_CLASS_INT32; The GVariant is a signed 32 bit integer.

  * G_VARIANT_CLASS_UINT32; The GVariant is an unsigned 32 bit integer.

  * G_VARIANT_CLASS_INT64; The GVariant is a signed 64 bit integer.

  * G_VARIANT_CLASS_UINT64; The GVariant is an unsigned 64 bit integer.

  * G_VARIANT_CLASS_HANDLE; The GVariant is a file handle index.

  * G_VARIANT_CLASS_DOUBLE; The GVariant is a double precision floating point value.

  * G_VARIANT_CLASS_STRING; The GVariant is a normal string.

  * G_VARIANT_CLASS_OBJECT_PATH; The GVariant is a D-Bus object path string.

  * G_VARIANT_CLASS_SIGNATURE; The GVariant is a D-Bus signature string.

  * G_VARIANT_CLASS_VARIANT; The GVariant is a variant.

  * G_VARIANT_CLASS_MAYBE; The GVariant is a maybe-typed value.

  * G_VARIANT_CLASS_ARRAY; The GVariant is an array.

  * G_VARIANT_CLASS_TUPLE; The GVariant is a tuple.

  * G_VARIANT_CLASS_DICT_ENTRY; The GVariant is a dictionary entry.

Methods
=======

new
---

### :array

Create a new Variant object. The type of the array elements is taken from the first element.

    multi method new ( Array :$array! )

#### Example

Create a Variant array type containing integers;

    my Array $array = [];
    for 40, 41, 42 -> $value {
      $array.push: Gnome::Glib::Variant.new( :type-string<i>, :$value);
    }
    my Gnome::Glib::Variant $v .= new(:$array);
    say $v.get-type-string;      # ai

### :boolean

Creates a new boolean Variant -- either `True` or `False`. Note that the value in the variant is stored as an integer. Its type becomes 'b'.

    multi method new ( Bool :$boolean! )

### :byte

Creates a new byte Variant. Its type becomes 'y'.

    multi method new ( Int :$byte! )

### :byte-string

Creates a new byte-string Variant. Its type becomes 'ay' which is essentially an array of bytes. This can be an ascii type of string which does not have to be UTF complient.

    multi method new ( Str :$byte-string! )

### :byte-string-array

Creates a new byte-string-array Variant. Its type becomes 'aay'. which is essentially an array of an array of bytes.

    multi method new ( Array :$byte-string-array! )

### :dict

Creates a new dictionary Variant. Its type becomes '{}'.

    multi method new ( List :$dict! )

The List `$dict` has two values, a *key* and a *value* and must both be valid **Gnome::Glib::Variant** objects. *key* must be a value of a basic type (ie: not a container). It will mostly be a string (variant type 's').

#### Example

    my Gnome::Glib::Variant $v .= new(
      :dict(
        Gnome::Glib::Variant.new(:parse<width>),
        Gnome::Glib::Variant.new(:parse<200>)
      )
    );

    say $v.print; #

### :double

Creates a new double Variant. Its type becomes 'd'.

    multi method new ( Num :$double! )

### :int16

Creates a new int16 Variant. Its type becomes 'n'.

    multi method new ( Int :$int16! )

### :int32

Creates a new int32 Variant. Its type becomes 'i'.

    multi method new ( Int :$int32! )

### :int64

Creates a new int64 Variant. Its type becomes 'x'.

    multi method new ( Int :$int64! )

### :string

Creates a new string Variant. Its type becomes 's'.

    multi method new ( Str :$string! )

### :strv

Creates a new string array Variant. Its type becomes 'as'.

    multi method new ( Array :$strv! )

#### Example

    my Gnome::Glib::Variant $v .= new(:string-array([<abc def ghi αβ ⓒ™⅔>]));
    say $v.get-type-string; #    as

### :tuple

Creates a new tuple Variant. Its type becomes ''.

    multi method new ( Array :$tuple! )

#### Example

    my Array $tuple = [];
    $tuple.push: Gnome::Glib::Variant.new( :type-string<i>, :value(40));
    $tuple.push: Gnome::Glib::Variant.new( :type-string<s>, :value<fourtyone>);
    $tuple.push: Gnome::Glib::Variant.new( :type-string<x>, :value(42));
    my Gnome::Glib::Variant $v .= new(:$tuple);
    say $v.get-type-string; #    (isx)

### :uint16

Creates a new uint16 Variant. Its type becomes 'q'.

    multi method new ( UInt :$uint16! )

### :uint32

Creates a new uint32 Variant. Its type becomes 'u'.

    multi method new ( UInt :$uint32! )

### :uint64

Creates a new uint64 Variant. Its type becomes 't'.

    multi method new ( UInt :$uint64! )

### :variant

Creates a new variant Variant. Its type becomes 'v'.

    multi method new ( N-GVariant :$variant! )

#### Example

    my Gnome::Glib::Variant $v .= new(
      :variant(Gnome::Glib::Variant.new( :type-string<i>, :value(40)))
    );
    say $v.get-type-string; #    v

### :type-string, :parse

Create a new Variant object by parsing the type and data provided in strings. The format of the parse string is [described here](https://developer.gnome.org/glib/stable/gvariant-text.html).

    multi method new ( Str :$type-string?, Str :$parse! )

#### Example

Create a Variant tuple containing a string, an unsigned integer and a boolean (Note the lowercase 'true'!);

    my Gnome::Glib::Variant $v .= new(
      :type-string<(sub)>, :parse('("abc",20,true)')
    );

Because the values in the :parse string take the default types you can also leave out the type string;

    my Gnome::Glib::Variant $v .= new(:parse('("abc",20,true)'));

### :type-string, :value

Create a new Variant object by parsing the type and a provided value. The type strings are simple like (unsigned) integer ('u' or 'i') but no arrays ('a') etc.

    multi method new ( Str :$type-string!, Any :$value! )

### :native-object

Create a Variant object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-boolean
-----------

Returns the boolean value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_BOOLEAN`.

Returns: `True` or `False`

    method get-boolean ( --> Bool )

get-byte
--------

Returns the byte value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_BYTE`.

Returns: a **guint8**

    method get-byte ( --> UInt )

get-bytestring
--------------

Returns the string value of a **N-GVariant** instance with an array-of-bytes type. The string has no particular encoding.

    method get-bytestring ( -->  Str  )

get-bytestring-array
--------------------

Gets the contents of an array of array of bytes **N-GVariant**.

    method get-bytestring-array ( -->  Array[Str]  )

get-double
----------

Returns the double precision floating point value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_DOUBLE`.

Returns: a **gdouble**

    method get-double ( --> Num )

get-int16
---------

Returns the 16-bit signed integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT16`.

Returns: a **gint16**

    method get-int16 ( --> Int )

get-int32
---------

Returns the 32-bit signed integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT32`.

Returns: a **gint32**

    method get-int32 ( --> Int )

get-int64
---------

Returns the 64-bit signed integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_INT64`.

Returns: a **gint64**

    method get-int64 ( --> Int )

get-string
----------

Returns the string value of a **N-GVariant** instance with a string type.

    method get-string ( -->  Str  )

get-strv
--------

Gets the contents of an array of strings **N-GVariant**. This call makes a shallow copy.

    method get-strv ( --> Array[Str]  )

get-type
--------

Determines the type of *value*. The return value is valid for the lifetime of *value* and must not be freed.

Returns: a **GVariantType**

    method get-type ( --> Gnome::Glib::Variant )

get-type-string
---------------

Returns the type string of *value*. Unlike the result of calling `g_variant_type_peek_string()`, this string is nul-terminated. This string belongs to **N-GVariant** and must not be freed.

Returns: the type string for the type of *value*

    method get-type-string ( -->  Str  )

get-uint16
----------

Returns the 16-bit unsigned integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT16`.

Returns: a **guint16**

    method get-uint16 ( --> UInt )

get-uint32
----------

Returns the 32-bit unsigned integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT32`.

Returns: a **guint32**

    method get-uint32 ( --> UInt )

get-uint64
----------

Returns the 64-bit unsigned integer value of *value*. It is an error to call this function with a *value* of any type other than `G_VARIANT_TYPE_UINT64`.

Returns: a **guint64**

    method get-uint64 ( --> UInt )

get-variant
-----------

Unboxes *value*. The result is the **Gnome::Glib::Variant** that was contained in *value*.

Returns: the item contained in the variant

    method get-variant ( --> Gnome::Glib::Variant )

is-container
------------

Checks if *value* is a container.

Returns: `1` if *value* is a container

    method is-container ( --> Int )

is-of-type
----------

Checks if a value has a type matching the provided type.

Returns: `True` if the type of *value* matches *type*

    method is-of-type ( N-GVariantType $type --> Bool )

  * N-GVariantType $type; a **GVariantType**

print
-----

Pretty-prints *value* in the format understood by `parse()`. If *$type_annotate* is `True`, then type information is included in the output.

Returns: a newly-allocated string holding the result.

    method print ( Bool $type_annotate = False --> Str )

  * Int $type_annotate; `True` if type information should be included in the output

