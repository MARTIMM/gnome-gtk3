Gnome::GObject::Type
====================

The GLib Runtime type identification and management system

***Note: The methods described here are mostly used internally and is not of much interest for the normal Raku user.***

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

class N-GTypeQuery
------------------

A structure holding information for a specific type. It is filled in by the `g_type_query()` function.

  * UInt $.type: the GType value of the type.

  * Str $.type_name: the name of the type.

  * UInt $.class_size: the size of the class structure.

  * UInt $.instance_size: the size of the instance structure.

Methods
=======

new
---

### default, no options

Create a new plain object. In contrast with other objects, this class doesn't wrap a native object, so therefore no options to specify something.

[g_] type_name
--------------

Get the unique name that is assigned to a type ID. Note that this function (like all other GType API) cannot cope with invalid type IDs. `G_TYPE_INVALID` may be passed to this function, as may be any other validly registered type ID, but randomized type IDs should not be passed in and will most likely lead to a crash.

Returns: static type name or undefined

    method g_type_name ( UInt $gtype --> Str )

[g_] type_qname
---------------

Get the corresponding quark of the type IDs name.

Returns: the type names quark or 0

    method g_type_qname ( --> UInt  )

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

    method g_type_parent ( UInt $parent-type --> UInt )

[g_] type_depth
---------------

Returns the length of the ancestry of the passed in type. This includes the type itself, so that e.g. a fundamental type has depth 1.

Returns: the depth of *$type*

    method g_type_depth ( UInt $type --> UInt  )

[[g_] type_] is_a
-----------------

If *$is_a_type* is a derivable type, check whether *$type* is a descendant of *$is_a_type*. If *$is_a_type* is an interface, check whether *$type* conforms to it.

Returns: `1` if *$type* is a *$is_a_type*.

    method g_type_is_a ( UInt $type, UInt $is_a_type --> Int )

  * UInt $is_a_type; possible anchestor of *$type* or interface that *$type* could conform to.

[g_] type_query
---------------

Queries the type system for information about a specific type. This function will fill in a user-provided structure to hold type-specific information. If an invalid *GType* is passed in, the *$type* member of the *N-GTypeQuery* is 0. All members filled into the *N-GTypeQuery* structure should be considered constant and have to be left untouched.

    method g_type_query ( int32 $type --> N-GTypeQuery )

  * N-GTypeQuery $query; a structure that is filled in with constant values upon success

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

  * N-GObject $instance; the native object to check.

  * UInt $iface_type; the gtype the instance is inheriting from.

[[g_] type_] name_from_instance
-------------------------------

Get name of type from the instance.

    method g_type_name_from_instance ( N-GObject $instance --> Str  )

  * int32 $instance;

Returns the name of the instance.

