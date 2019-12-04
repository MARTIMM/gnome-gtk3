TITLE
=====

Gnome::GObject::Type

SUBTITLE
========

The GLib Runtime type identification and management system

***Note: The methods described here are mostly used internally and is not interesting for the normal Perl6 user.***

Description
===========

The GType API is the foundation of the GObject system. It provides the facilities for registering and managing all fundamental data types, user-defined object and interface types.

For type creation and registration purposes, all types fall into one of two categories: static or dynamic. Static types are never loaded or unloaded at run-time as dynamic types may be.

As mentioned in the [GType conventions](https://developer.gnome.org/gobject/stable/gtype-conventions.html), type names must be at least three characters long. There is no upper length limit. The first character must be a letter (a–z or A–Z) or an underscore (‘_’). Subsequent characters can be letters, numbers or any of ‘-_+’.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Type;

class N-GTypeInstance
---------------------

An opaque structure used as the base of all type instances.

class N-GTypeInterface
----------------------

An opaque structure used as the base of all interface types.

class N-GTypeClass
------------------

An opaque structure used as the base of all type instances.

class N-GTypeQuery
------------------

A structure holding information for a specific type. It is filled in by the `g_type_query()` function.

  * int32 $.type: the **N-GType** value of the type.

  * Str $.type_name: the name of the type.

  * UInt $.class_size: the size of the class structure.

  * UInt $.instance_size: the size of the instance structure.

class N-GTypeInfo
-----------------

This structure is used to provide the type system with the information required to initialize and destruct (finalize) a type's class and its instances.

The initialized structure is passed to the `g_type_register_static()` function (or is copied into the provided *N-GTypeInfo* structure in the `g_type_plugin_complete_type_info()`). The type system will perform a deep copy of this structure, so its memory does not need to be persistent across invocation of `g_type_register_static()`.

  * UInt $.class_size: Size of the class structure (required for interface, classed and instantiatable types)

  * GBaseInitFunc $.base_init: Location of the base initialization function (optional)

  * GBaseFinalizeFunc $.base_finalize: Location of the base finalization function (optional)

  * GClassInitFunc $.class_init: Location of the class initialization function for classed and instantiatable types. Location of the default vtable inititalization function for interface types. (optional) This function is used both to fill in virtual functions in the class or default vtable, and to do type-specific setup such as registering signals and object properties.

  * GClassFinalizeFunc $.class_finalize: Location of the class finalization function for classed and instantiatable types. Location of the default vtable finalization function for interface types. (optional)

  * Pointer $.class_data: User-supplied data passed to the class init/finalize functions

  * UInt $.instance_size: Size of the instance (object) structure (required for instantiatable types only)

  * UInt $.n_preallocs: Prior to GLib 2.10, it specified the number of pre-allocated (cached) instances to reserve memory for (0 indicates no caching). Since GLib 2.10, it is ignored, since instances are allocated with the [slice allocator][glib-Memory-Slices] now.

  * GInstanceInitFunc $.instance_init: Location of the instance initialization function (optional, for instantiatable types only)

  * int32 $.value_table: A *N-GTypeValueTable* function table for generic handling of GValues of this type (usually only useful for fundamental types)

class N-GTypeFundamentalInfo
----------------------------

A structure that provides information to the type system which is used specifically for managing fundamental types.

  * int32 $.type_flags: *N-GTypeFundamentalFlags* describing the characteristics of the fundamental type

class N-GInterfaceInfo
----------------------

A structure that provides information to the type system which is used specifically for managing interface types.

  * GInterfaceInitFunc $.interface_init: location of the interface initialization function

  * GInterfaceFinalizeFunc $.interface_finalize: location of the interface finalization function

  * Pointer $.interface_data: user-supplied data passed to the interface init/finalize functions

Methods
=======

new
---

### multi method new ( )

Create a new plain object. In contrast with other objects, this class doesn't wrap a native object, so therefore no named arguments to specify something

[g_] type_name
--------------

Get the unique name that is assigned to a type ID. Note that this function (like all other GType API) cannot cope with invalid type IDs. `G_TYPE_INVALID` may be passed to this function, as may be any other validly registered type ID, but randomized type IDs should not be passed in and will most likely lead to a crash.

Returns: static type name or `Any`

    method g_type_name ( UInt $type --> Str )

[[g_] type_] from_name
----------------------

Lookup the type ID from a given type name, returning 0 if no type has been registered under this name (this is the preferred method to find out by name whether a specific type has been registered yet).

Returns: corresponding type ID or 0

    method g_type_from_name ( Str $name --> UInt )

  * Str $name; type name to lookup

[g_] type_parent
----------------

Return the direct parent type of the passed in type. If the passed in type has no parent, i.e. is a fundamental type, 0 is returned.

Returns: the parent type

    method g_type_parent ( UInt --> UInt )

[g_] type_depth
---------------

Returns the length of the ancestry of the passed in type. This includes the type itself, so that e.g. a fundamental type has depth 1.

Returns: the depth of *type*

    method g_type_depth ( --> UInt  )

[[g_] type_] is_a
-----------------

If *$is_a_type* is a derivable type, check whether *$type* is a descendant of *$is_a_type*. If *$is_a_type* is an interface, check whether *$type* conforms to it.

Returns: `1` if *$type* is a *$is_a_type*.

    method g_type_is_a ( UInt $type, UInt $is_a_type --> Int  )

  * UInt $is_a_type; possible anchestor of *$type* or interface that *$type* could conform to.

[[g_] type_] check_instance_cast
--------------------------------

Checks that instance is an instance of the type identified by g_type and issues a warning if this is not the case. Returns instance casted to a pointer to c_type.

No warning will be issued if instance is NULL, and NULL will be returned.

This macro should only be used in type implementations.

    method g_type_check_instance_cast (
      N-GObject $instance, UInt $iface_type
      --> N-GObject
    )

  * N-GObject $instance;

  * UInt $iface_type;

[[g_] type_] check_instance_is_a
--------------------------------

    method g_type_check_instance_is_a (
      N-GObject $instance, UInt $iface_type --> Int
    )

  * int32 $instance;

  * int32 $iface_type;

[[g_] type_] check_value
------------------------

    method g_type_check_value ( N-GObject $value --> Int  )

  * N-GObject $value;

