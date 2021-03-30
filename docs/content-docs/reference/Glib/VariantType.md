Gnome::Glib::VariantType
========================

introduction to the Gnome::Glib::Variant type system

Description
===========

This section introduces the Gnome::Glib::Variant type system. It is based, in large part, on the D-Bus type system, with two major changes and some minor lifting of restrictions. The [D-Bus specification](http://dbus.freedesktop.org/doc/dbus-specification.html), therefore, provides a significant amount of information that is useful when working with Gnome::Glib::Variant.

The first major change with respect to the D-Bus type system is the introduction of maybe (or "nullable") types. Any type in Gnome::Glib::Variant can be converted to a maybe type, in which case, "nothing" (or "null") becomes a valid value. Maybe types have been added by introducing the character "m" to type strings.

The second major change is that the Gnome::Glib::Variant type system supports the concept of "indefinite types" -- types that are less specific than the normal types found in D-Bus. For example, it is possible to speak of "an array of any type" in Gnome::Glib::Variant, where the D-Bus type system would require you to speak of "an array of integers" or "an array of strings". Indefinite types have been added by introducing the characters "*", "?" and "r" to type strings.

Finally, all arbitrary restrictions relating to the complexity of types are lifted along with the restriction that dictionary entries may only appear nested inside of arrays.

Just as in D-Bus, Gnome::Glib::Variant types are described with strings ("type strings"). Subject to the differences mentioned above, these strings are of the same form as those found in DBus. Note, however: D-Bus always works in terms of messages and therefore individual type strings appear nowhere in its interface. Instead, "signatures" are a concatenation of the strings of the type of each argument in a message. Gnome::Glib::Variant deals with single values directly so Gnome::Glib::Variant type strings always describe the type of exactly one value. This means that a D-Bus signature string is generally not a valid Gnome::Glib::Variant type string -- except in the case that it is the signature of a message containing exactly one argument.

An indefinite type is similar in spirit to what may be called an abstract type in other type systems. No value can exist that has an indefinite type as its type, but values can exist that have types that are subtypes of indefinite types. That is to say, `g_variant_get_type()` will never return an indefinite type, but calling `g_variant_is_of_type()` with an indefinite type may return `True`. For example, you cannot have a value that represents "an array of no particular type", but you can have an "array of integers" which certainly matches the type of "an array of no particular type", since "array of integers" is a subtype of "array of no particular type".

This is similar to how instances of abstract classes may not directly exist in other type systems, but instances of their non-abstract subtypes may.

Gnome::Glib::Variant Type Strings
---------------------------------

A Gnome::Glib::Variant type string can be any of the following:

  * any basic type string (listed below)

  * "v", "r" or "*"

  * one of the characters 'a' or 'm', followed by another type string

  * the character '(', followed by a concatenation of zero or more other type strings, followed by the character ')'

  * the character '{', followed by a basic type string (see below), followed by another type string, followed by the character '}'

A basic type string describes a basic type (as per `g_variant_type_is_basic()`) and is always a single character in length. The valid basic type strings are "b", "y", "n", "q", "i", "u", "x", "t", "h", "d", "s", "o", "g" and "?".

The above definition is recursive to arbitrary depth. "aaaaai" and "(ui(nq((y)))s)" are both valid type strings, as is "a(aa(ui)(qna{ya(yd)}))". In order to not hit memory limits, **Gnome::Glib::Variant** imposes a limit on recursion depth of 65 nested containers. This is the limit in the D-Bus specification (64) plus one to allow a **GDBusMessage** to be nested in a top-level tuple.

The meaning of each of the characters is as follows:

  * `b`: the type string of `G_VARIANT_TYPE_BOOLEAN`; a boolean value.

  * `y`: the type string of `G_VARIANT_TYPE_BYTE`; a byte.

  * `n`: the type string of `G_VARIANT_TYPE_INT16`; a signed 16 bit integer.

  * `q`: the type string of `G_VARIANT_TYPE_UINT16`; an unsigned 16 bit integer.

  * `i`: the type string of `G_VARIANT_TYPE_INT32`; a signed 32 bit integer.

  * `u`: the type string of `G_VARIANT_TYPE_UINT32`; an unsigned 32 bit integer.

  * `x`: the type string of `G_VARIANT_TYPE_INT64`; a signed 64 bit integer.

  * `t`: the type string of `G_VARIANT_TYPE_UINT64`; an unsigned 64 bit integer.

  * `h`: the type string of `G_VARIANT_TYPE_HANDLE`; a signed 32 bit value that, by convention, is used as an index into an array of file descriptors that are sent alongside a D-Bus message.

  * `d`: the type string of `G_VARIANT_TYPE_DOUBLE`; a double precision floating point value.

  * `s`: the type string of `G_VARIANT_TYPE_STRING`; a string.

  * `o`: the type string of `G_VARIANT_TYPE_OBJECT_PATH`; a string in the form of a D-Bus object path.

  * `g`: the type string of `G_VARIANT_TYPE_SIGNATURE`; a string in the form of a D-Bus type signature.

  * `?`: the type string of `G_VARIANT_TYPE_BASIC`; an indefinite type that is a supertype of any of the basic types.

  * `v`: the type string of `G_VARIANT_TYPE_VARIANT`; a container type that contain any other type of value.

  * `a`: used as a prefix on another type string to mean an array of that type; the type string "ai", for example, is the type of an array of signed 32-bit integers.

  * `m`: used as a prefix on another type string to mean a "maybe", or "nullable", version of that type; the type string "ms", for example, is the type of a value that maybe contains a string, or maybe contains nothing.

  * `()`: used to enclose zero or more other concatenated type strings to create a tuple type; the type string "(is)", for example, is the type of a pair of an integer and a string.

  * `r`: the type string of `G_VARIANT_TYPE_TUPLE`; an indefinite type that is a supertype of any tuple type, regardless of the number of items.

  * `{}`: used to enclose a basic type string concatenated with another type string to create a dictionary entry type, which usually appears inside of an array to form a dictionary; the type string "a{sd}", for example, is the type of a dictionary that maps strings to double precision floating point values. The first type (the basic type) is the key type and the second type is the value type. The reason that the first type is restricted to being a basic type is so that it can easily be hashed.

  * `*`: the type string of `G_VARIANT_TYPE_ANY`; the indefinite type that is a supertype of all types. Note that, as with all type strings, this character represents exactly one type. It cannot be used inside of tuples to mean "any number of items".

Any type string of a container that contains an indefinite type is, itself, an indefinite type. For example, the type string "a*" (corresponding to `G_VARIANT_TYPE_ARRAY`) is an indefinite type that is a supertype of every array type. "(*s)" is a supertype of all tuples that contain exactly two items where the second item is a string.

"a{?*}" is an indefinite type that is a supertype of all arrays containing dictionary entries where the key is any basic type and the value is any type at all. This is, by definition, a dictionary, so this type string corresponds to `G_VARIANT_TYPE_DICTIONARY`. Note that, due to the restriction that the key of a dictionary entry must be a basic type, "{**}" is not a valid type string.

Errors
------

When you provide faulty type strings you can expect gnome errors on the commandline like for example

    (process:1660): GLib-CRITICAL **: 16:40:45.734: g_variant_type_checked_: assertion 'g_variant_type_string_is_valid (type_string)' failed

This, unfortunately, doesn't tell you where it happens.

See Also
--------

**Gnome::Glib::Variant**

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::VariantType;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

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

### :array

Constructs the type corresponding to an array of elements of the given type in `$array`.

    multi method new ( N-GObject :$array!! )

### :maybe

Constructs the type corresponding to a maybe instance containing in given type

    multi method new ( N-GObject :$maybe! )

### :type-string

Creates a new **Gnome::Glib::VariantType** corresponding to the type string given by *$type_string*.

It is a programmer error to call this function with an invalid type string. The string is checked to be sure resulting in a (in)valid object. Test with `.is-valid()` to be sure.

    multi method new ( Str :$type-string! )

### :native-object

Create a VariantType object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

copy
----

Makes a copy of a **GVariantType**. It is appropriate to call `clear-object()` on the return value.

Returns: a new **GVariantType**

    method copy ( --> Gnome::Glib::VariantType )

dup-string
----------

Returns a copy of the type string corresponding to *type*.

Returns: (transfer full): the corresponding type string

    method dup-string ( -->  Str  )

element
-------

Determines the element type of an array or maybe type. This function may only be used with array or maybe types.

Returns: the element type of *type*

    method element ( --> Gnome::Glib::VariantType )

equal
-----

Compares this type and *$type2* for equality. Only returns `True` if the types are exactly equal. Even if one type is an indefinite type and the other is a subtype of it, `False` will be returned if they are not exactly equal. If you want to check for subtypes, use `is-subtype-of()`.

    method equal ( N-GObject $type2 --> Bool )

  * N-GObject $type2; a **GVariantType**

first
-----

Determines the first item type of a tuple or dictionary entry type. This function may only be used with tuple or dictionary entry types, but must not be used with the generic tuple type `G_VARIANT_TYPE_TUPLE`. In the case of a dictionary entry type, this returns the type of the key. `Any` is returned in case of *type* being `G_VARIANT_TYPE_UNIT`. This call, together with `g_variant_type_next()` provides an iterator interface over tuple and dictionary entry types.

Returns: the first item type of *type*, or invalid

    method first ( --> N-GObject )

get-string-length
-----------------

Returns the length of the type string corresponding to the given *type*. This function must be used to determine the valid extent of the memory region returned by `g_variant_type_peek_string()`.

Returns: the length of the corresponding type string

    method get-string-length ( --> UInt )

hash
----

Hashes *type*.

Returns: the hash value

    method hash ( N-GObject $type --> UInt )

  * N-GObject $type; a **N-GObject**

is-array
--------

Determines if the given *type* is an array type. This is true if the type string for *type* starts with an 'a'. This function returns `True` for any indefinite type for which every definite subtype is an array type -- `G_VARIANT_TYPE_ARRAY`, for example.

Returns: `True` if *type* is an array type

    method is-array ( --> Bool )

is-basic
--------

Determines if the given *type* is a basic type. Basic types are booleans, bytes, integers, doubles, strings, object paths and signatures. Only a basic type may be used as the key of a dictionary entry. This function returns `False` for all indefinite types except `G_VARIANT_TYPE_BASIC`.

Returns: `True` if *type* is a basic type

    method is-basic ( --> Bool )

is-container
------------

Determines if the given *type* is a container type. Container types are any array, maybe, tuple, or dictionary entry types plus the variant type. This function returns `True` for any indefinite type for which every definite subtype is a container -- `G_VARIANT_TYPE_ARRAY`, for example.

Returns: `True` if *type* is a container type

    method is-container ( --> Bool )

is-definite
-----------

Determines if the given *type* is definite (ie: not indefinite). A type is definite if its type string does not contain any indefinite type characters ('*', '?', or 'r'). A **GVariant** instance may not have an indefinite type, so calling this function on the result of `g_variant_get_type()` will always result in `True` being returned. Calling this function on an indefinite type like `G_VARIANT_TYPE_ARRAY`, however, will result in `False` being returned.

Returns: `True` if *type* is definite

    method is-definite ( --> Bool )

is-dict-entry
-------------

Determines if the given *type* is a dictionary entry type. This is true if the type string for *type* starts with a '{'. This function returns `True` for any indefinite type for which every definite subtype is a dictionary entry type -- `G_VARIANT_TYPE_DICT_ENTRY`, for example.

Returns: `True` if *type* is a dictionary entry type

    method is-dict-entry ( --> Bool )

is-maybe
--------

Determines if the given *type* is a maybe type. This is true if the type string for *type* starts with an 'm'. This function returns `True` for any indefinite type for which every definite subtype is a maybe type -- `G_VARIANT_TYPE_MAYBE`, for example.

Returns: `True` if *type* is a maybe type

    method is-maybe ( --> Bool )

is-subtype-of
-------------

Checks if this type is a subtype of *$supertype*. This function returns `True` if *type* is a subtype of *$supertype*. All types are considered to be subtypes of themselves. Aside from that, only indefinite types can have subtypes.

Returns: `True` if *type* is a subtype of *$supertype*

    method is-subtype-of ( N-GObject $supertype --> Bool )

  * N-GObject $supertype; a **GVariantType**

is-tuple
--------

Determines if the given *type* is a tuple type. This is true if the type string for *type* starts with a '(' or if *type* is `G_VARIANT_TYPE_TUPLE`. This function returns `True` for any indefinite type for which every definite subtype is a tuple type -- `G_VARIANT_TYPE_TUPLE`, for example.

Returns: `True` if *type* is a tuple type

    method is-tuple ( --> Bool )

string-is-valid
---------------

Checks if *type_string* is a valid Gnome::Glib::Variant type string. This call is equivalent to calling `string-scan()` and confirming that the following character is a nul terminator.

Returns: `True` if *$type_string* is exactly one valid type string

    method string-is-valid ( Str $type_string --> Bool )

  * Str $type_string; a pointer to any string

is-variant
----------

Determines if the given *type* is the variant type.

Returns: `True` if *type* is the variant type

    method is-variant ( --> Bool )

key
---

Determines the key type of a dictionary entry type. This function may only be used with a dictionary entry type. Other than the additional restriction, this call is equivalent to `g_variant_type_first()`.

Returns: the key type of the dictionary entry

    method key ( --> Gnome::Glib::VariantType )

n-items
-------

Determines the number of items contained in a tuple or dictionary entry type. This function may only be used with tuple or dictionary entry types, but must not be used with the generic tuple type `G_VARIANT_TYPE_TUPLE`. In the case of a dictionary entry type, this function will always return 2.

Returns: the number of items in *type*

    method n-items ( --> UInt )

next
----

Determines the next item type of a tuple or dictionary entry type. *type* must be the result of a previous call to `first()` or `next()`. If called on the key type of a dictionary entry then this call returns the value type. If called on the value type of a dictionary entry then this call returns `Any`. For tuples, `Any` is returned when *type* is the last item in a tuple.

Returns: the next **Gnome::Glib::VariantType** after *type*, or invalid

    method next ( --> Gnome::Glib::VariantType )

value
-----

Determines the value type of a dictionary entry type. This function may only be used with a dictionary entry type.

Returns: the value type of the dictionary entry

    method value ( --> Gnome::Glib::VariantType )

