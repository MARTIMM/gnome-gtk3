Gnome::GObject::Enums
=====================

Enumeration and flags types

Description
===========

The GLib type system provides fundamental types for enumeration and flags types. (Flags types are like enumerations, but allow their values to be combined by bitwise or). A registered enumeration or flags type associates a name and a nickname with each allowed value, and the methods `g_enum_get_value_by_name()`, `g_enum_get_value_by_nick()`, `g_flags_get_value_by_name()` and `g_flags_get_value_by_nick()` can look up values by their name or nickname. When an enumeration or flags type is registered with the GLib type system, it can be used as value type for object properties, using `g_param_spec_enum()` or `g_param_spec_flags()`.

GObject ships with a utility called [glib-mkenums][glib-mkenums], that can construct suitable type registration functions from C enumeration definitions.

Example of how to get a string representation of an enum value:

See Also
--------

**GParamSpecEnum**, **GParamSpecFlags**, `g_param_spec_enum()`,

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Enums;

class N-GEnumValue
------------------

A structure which contains a single enum value, its name, and its nickname.

  * Int $.value: the enum value

  * Str $.value_name: the name of the value

  * Str $.value_nick: the nickname of the value

class N-GFlagsValue
-------------------

A structure which contains a single flags value, its name, and its nickname.

  * UInt $.value: the flags value

  * Str $.value_name: the name of the value

  * Str $.value_nick: the nickname of the value

class N-GEnumClass
------------------

class N-GFlagsClass
-------------------

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

[g_] enum_get_value
-------------------

Returns the **N-GEnumValue** for a value.

Returns: (transfer none): the **N-GEnumValue** for *value*, or `Any` if *value* is not a member of the enumeration

    method g_enum_get_value ( N-GEnumClass $enum_class, Int $value --> N-GEnumValue  )

  * N-GEnumClass $enum_class; a **N-GEnumClass**

  * Int $value; the value to look up

[g_] enum_get_value_by_name
---------------------------

Looks up a **N-GEnumValue** by name.

Returns: (transfer none): the **N-GEnumValue** with name *name*, or `Any` if the enumeration doesn't have a member with that name

    method g_enum_get_value_by_name ( N-GEnumClass $enum_class, Str $name --> N-GEnumValue  )

  * N-GEnumClass $enum_class; a **N-GEnumClass**

  * Str $name; the name to look up

[g_] enum_get_value_by_nick
---------------------------

Looks up a **N-GEnumValue** by nickname.

Returns: (transfer none): the **N-GEnumValue** with nickname *nick*, or `Any` if the enumeration doesn't have a member with that nickname

    method g_enum_get_value_by_nick ( N-GEnumClass $enum_class, Str $nick --> N-GEnumValue  )

  * N-GEnumClass $enum_class; a **N-GEnumClass**

  * Str $nick; the nickname to look up

[g_] flags_get_first_value
--------------------------

Returns the first **N-GFlagsValue** which is set in *value*.

Returns: (transfer none): the first **N-GFlagsValue** which is set in *value*, or `Any` if none is set

    method g_flags_get_first_value ( N-GFlagsClass $flags_class, UInt $value --> N-GFlagsValue  )

  * N-GFlagsClass $flags_class; a **N-GFlagsClass**

  * UInt $value; the value

[g_] flags_get_value_by_name
----------------------------

Looks up a **N-GFlagsValue** by name.

Returns: (transfer none): the **N-GFlagsValue** with name *name*, or `Any` if there is no flag with that name

    method g_flags_get_value_by_name ( N-GFlagsClass $flags_class, Str $name --> N-GFlagsValue  )

  * N-GFlagsClass $flags_class; a **N-GFlagsClass**

  * Str $name; the name to look up

[g_] flags_get_value_by_nick
----------------------------

Looks up a **N-GFlagsValue** by nickname.

Returns: (transfer none): the **N-GFlagsValue** with nickname *nick*, or `Any` if there is no flag with that nickname

    method g_flags_get_value_by_nick ( N-GFlagsClass $flags_class, Str $nick --> N-GFlagsValue  )

  * N-GFlagsClass $flags_class; a **N-GFlagsClass**

  * Str $nick; the nickname to look up

[g_] enum_to_string
-------------------

Pretty-prints *value* in the form of the enum’s name.

This is intended to be used for debugging purposes. The format of the output may change in the future.

Returns: (transfer full): a newly-allocated text string

Since: 2.54

    method g_enum_to_string ( int32 $g_enum_type, Int $value --> Str  )

  * int32 $g_enum_type; the type identifier of a **N-GEnumClass** type

  * Int $value; the value

[g_] flags_to_string
--------------------

Pretty-prints *value* in the form of the flag names separated by ` | ` and sorted. Any extra bits will be shown at the end as a hexadecimal number.

This is intended to be used for debugging purposes. The format of the output may change in the future.

Returns: (transfer full): a newly-allocated text string

Since: 2.54

    method g_flags_to_string ( int32 $flags_type, UInt $value --> Str  )

  * int32 $flags_type; the type identifier of a **N-GFlagsClass** type

  * UInt $value; the value

[g_] value_set_enum
-------------------

Set the contents of a `G_TYPE_ENUM` **GValue** to *v_enum*.

    method g_value_set_enum ( N-GObject $value, Int $v_enum )

  * N-GObject $value; a valid **GValue** whose type is derived from `G_TYPE_ENUM`

  * Int $v_enum; enum value to be set

[g_] value_get_enum
-------------------

Get the contents of a `G_TYPE_ENUM` **GValue**.

Returns: enum contents of *value*

    method g_value_get_enum ( N-GObject $value --> Int  )

  * N-GObject $value; a valid **GValue** whose type is derived from `G_TYPE_ENUM`

[g_] value_set_flags
--------------------

Set the contents of a `G_TYPE_FLAGS` **GValue** to *v_flags*.

    method g_value_set_flags ( N-GObject $value, UInt $v_flags )

  * N-GObject $value; a valid **GValue** whose type is derived from `G_TYPE_FLAGS`

  * UInt $v_flags; flags value to be set

[g_] value_get_flags
--------------------

Get the contents of a `G_TYPE_FLAGS` **GValue**.

Returns: flags contents of *value*

    method g_value_get_flags ( N-GObject $value --> UInt  )

  * N-GObject $value; a valid **GValue** whose type is derived from `G_TYPE_FLAGS`

[g_] enum_register_static
-------------------------

Registers a new static enumeration type with the name *name*.

It is normally more convenient to let [glib-mkenums][glib-mkenums], generate a `my_enum_get_type()` function from a usual C enumeration definition than to write one yourself using `g_enum_register_static()`.

Returns: The new type identifier.

    method g_enum_register_static ( Str $name, N-GEnumValue $const_static_values --> int32  )

  * Str $name; A nul-terminated string used as the name of the new type.

  * N-GEnumValue $const_static_values; An array of **N-GEnumValue** structs for the possible enumeration values. The array is terminated by a struct with all members being 0. GObject keeps a reference to the data, so it cannot be stack-allocated.

[g_] flags_register_static
--------------------------

Registers a new static flags type with the name *name*.

It is normally more convenient to let [glib-mkenums][glib-mkenums] generate a `my_flags_get_type()` function from a usual C enumeration definition than to write one yourself using `g_flags_register_static()`.

Returns: The new type identifier.

    method g_flags_register_static ( Str $name, N-GFlagsValue $const_static_values --> int32  )

  * Str $name; A nul-terminated string used as the name of the new type.

  * N-GFlagsValue $const_static_values; An array of **N-GFlagsValue** structs for the possible flags values. The array is terminated by a struct with all members being 0. GObject keeps a reference to the data, so it cannot be stack-allocated.

[g_] enum_complete_type_info
----------------------------

This function is meant to be called from the `complete_type_info` function of a **GTypePlugin** implementation, as in the following example:

|[<!-- language="C" --> static void my_enum_complete_type_info (GTypePlugin *plugin, GType g_type, GTypeInfo *info, GTypeValueTable *value_table) { static const N-GEnumValue values[] = { { MY_ENUM_FOO, "MY_ENUM_FOO", "foo" }, { MY_ENUM_BAR, "MY_ENUM_BAR", "bar" }, { 0, NULL, NULL } };

g_enum_complete_type_info (type, info, values); } ]|

    method g_enum_complete_type_info ( int32 $g_enum_type, int32 $info, N-GEnumValue $const_values )

  * int32 $g_enum_type; the type identifier of the type being completed

  * int32 $info; (out callee-allocates): the **GTypeInfo** struct to be filled in

  * N-GEnumValue $const_values; An array of **N-GEnumValue** structs for the possible enumeration values. The array is terminated by a struct with all members being 0.

[g_] flags_complete_type_info
-----------------------------

This function is meant to be called from the `complete_type_info()` function of a **GTypePlugin** implementation, see the example for `g_enum_complete_type_info()` above.

    method g_flags_complete_type_info ( int32 $g_flags_type, int32 $info, N-GFlagsValue $const_values )

  * int32 $g_flags_type; the type identifier of the type being completed

  * int32 $info; (out callee-allocates): the **GTypeInfo** struct to be filled in

  * N-GFlagsValue $const_values; An array of **N-GFlagsValue** structs for the possible enumeration values. The array is terminated by a struct with all members being 0.

