Gnome::GObject::Type
====================

The GLib Runtime type identification and management system

***Note: The methods described here are mostly used internally and is not of much interest for the normal Raku user.***

Description
===========

The GType API is the foundation of the GObject system. It provides the facilities for registering and managing all fundamental data types. To have a type stored next to its value. The class **Gnome::GObject::Value** serves as a vehicle to get values in and out of an object. This class controls a `N-GValue` object which has a type and a value.

The Glib types such as `gint` and `gfloat` are used to type variables and functions directly and are compiled to the proper sizes when used in code. These types are mapped to the C types like `int` and `float`. In the module **Gnome::N::GlibToRakuTypes**, a mapping is made to be able to map the Glib types to the Raku types.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Type;

class N-GTypeQuery
------------------

A structure holding information for a specific type. It is filled in by the `query()` function.

  * UInt $.type: the GType value of the type.

  * Str $.type_name: the name of the type.

  * UInt $.class_size: the size of the class structure.

  * UInt $.instance_size: the size of the instance structure.

Type names
----------

  * G_TYPE_CHAR; An 8 bit integer.

  * G_TYPE_UCHAR; An 8 bit unsigned integer.

  * G_TYPE_BOOLEAN; A boolean. This is the size of an int32.

  * G_TYPE_INT; An integer, also the size of an int32.

  * G_TYPE_UINT; An unsigned integer.

  * G_TYPE_LONG; A larger type integer.

  * G_TYPE_ULONG; A larger type unsigned integer.

  * G_TYPE_INT64; A larger type integer.

  * G_TYPE_UINT64; A larger type unsigned integer.

  * G_TYPE_ENUM; An integer used for C enumerations.

  * G_TYPE_FLAGS; An integer used for bitmap flags.

  * G_TYPE_FLOAT; A floating point value.

  * G_TYPE_DOUBLE; A large floating point value.

  * G_TYPE_STRING; A string.

  * G_TYPE_OBJECT; A gnome object.

  * G_TYPE_VARIANT; A variant.

To show the glib types together with the Raku types and the type names mentioned above a small table is shown below;

<table class="pod-table">
<thead><tr>
<th>Type name</th> <th>Glib type</th> <th>Raku type</th>
</tr></thead>
<tbody>
<tr> <td>G_TYPE_CHAR</td> <td>gchar</td> <td>int8</td> </tr> <tr> <td>G_TYPE_UCHAR</td> <td>guchar</td> <td>uint8</td> </tr> <tr> <td>G_TYPE_BOOLEAN</td> <td>gboolean</td> <td>int32</td> </tr> <tr> <td>G_TYPE_INT</td> <td>gint</td> <td>int32</td> </tr> <tr> <td>G_TYPE_UINT</td> <td>guint</td> <td>uint32</td> </tr> <tr> <td>G_TYPE_LONG</td> <td>glong</td> <td>int64</td> </tr> <tr> <td>G_TYPE_ULONG</td> <td>gulong</td> <td>uint64</td> </tr> <tr> <td>G_TYPE_INT64</td> <td>gint64</td> <td>int64</td> </tr> <tr> <td>G_TYPE_UINT64</td> <td>guint64</td> <td>uint64</td> </tr> <tr> <td>G_TYPE_ENUM</td> <td>GEnum</td> <td>int32</td> </tr> <tr> <td>G_TYPE_FLAGS</td> <td>GFlag</td> <td>uint32</td> </tr> <tr> <td>G_TYPE_FLOAT</td> <td>gfloat</td> <td>num32</td> </tr> <tr> <td>G_TYPE_DOUBLE</td> <td>gdouble</td> <td>num64</td> </tr> <tr> <td>G_TYPE_STRING</td> <td>gchar-ptr</td> <td>Str</td> </tr> <tr> <td>G_TYPE_OBJECT</td> <td>-</td> <td>Gnome::GObject::Object</td> </tr> <tr> <td>G_TYPE_VARIANT</td> <td>-</td> <td>Gnome::Glib::Variant</td> </tr>
</tbody>
</table>

Some types might have a longer or shorter size depending on the OS Raku is running on. It is a reflection of the C macro types of the C compiler include files. So to use the proper types, always use the glib type instead of the Raku type which are generated in the **Gnome::N::GlibToRakuTypes** module at Build time when `Gnome::N` is installed.

Methods
=======

new
---

### default, no options

Create a new plain object. In contrast with other objects, this class doesn't wrap a native object, so therefore no options to specify something.

check-instance-cast
-------------------

Checks that instance is an instance of the type identified by g_type and issues a warning if this is not the case. Returns instance casted to a pointer to c_type.

No warning will be issued if instance is NULL, and NULL will be returned.

    method check-instance-cast (
      N-GObject $instance, UInt $iface_type --> N-GObject
    )

  * N-GObject $instance;

  * UInt $iface_type;

check-instance-is-a
-------------------

Check if an instance is of type `$iface-gtype`. Returns True if it is.

    method check-instance-is-a (
      N-GObject $instance, UInt $iface_gtype --> Bool
    )

  * N-GObject $instance;

  * UInt $iface_type;

depth
-----

Returns the length of the ancestry of the passed in type. This includes the type itself, so that e.g. a fundamental type has depth 1.

Returns: the depth of *$gtype*

    method depth ( UInt $gtype --> UInt )

from-name
---------

Lookup the type ID from a given type name, returning 0 if no type has been registered under this name (this is the preferred method to find out by name whether a specific type has been registered yet).

Returns: corresponding type ID or 0

    method from-name ( Str $name --> UInt )

  * Str $name; type name to lookup

gtype-get-type
--------------

Get dynamic type for a GTyped value. In C there is this name G_TYPE_GTYPE.

    method gtype_get_type ( --> UInt )

is-a
----

If *$is-a-gtype* is a derivable type, check whether *$gtype* is a descendant of *$is-a-gtype*. If *$is-a-gtype* is an interface, check whether *$gtype* conforms to it.

Returns: `True` if *$gtype* is a *$is-a-gtype*

    method is-a ( UInt $gtype, UInt $is_a_gtype --> Bool )

  * UInt $is_a_gtype; possible anchestor of *$gtype* or interface that *$gtype* could conform to

name
----

Get the unique name that is assigned to a type ID. Note that this function (like all other GType API) cannot cope with invalid type IDs. `G-TYPE-INVALID` may be passed to this function, as may be any other validly registered type ID, but randomized type IDs should not be passed in and will most likely lead to a crash.

Returns: static type name or `undefined`

    method name ( UInt $gtype --> Str )

name-from-instance
------------------

Get name of type from the instance.

    method name-from-instance ( N-GObject $instance --> Str )

  * N-GObject $instance;

parent
------

Return the direct parent type of the passed in type. If the passed in type has no parent, i.e. is a fundamental type, 0 is returned.

Returns: the parent type

    method parent ( UInt $parent-gtype --> UInt )

qname
-----

Get the corresponding quark of the type IDs name.

Returns: the type names quark or 0

    method qname ( UInt $gtype --> UInt )

query
-----

Queries the type system for information about a specific type. This function will fill in a user-provided structure to hold type-specific information. If an invalid **Gnome::GObject::Type** is passed in, the *$type* member of the **N-GTypeQuery** is 0. All members filled into the **N-GTypeQuery** structure should be considered constant and have to be left untouched.

    method query ( UInt $gtype --> N-GTypeQuery )

