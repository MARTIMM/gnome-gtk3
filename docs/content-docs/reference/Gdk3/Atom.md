Gnome::Gdk3::Atom
=================

Functions to manipulate properties on windows

Description
===========

Each window under X can have any number of associated “properties” attached to it. Properties are arbitrary chunks of data identified by “atom”s. (An “atom” is a numeric index into a string table on the X server. They are used to transfer strings efficiently between clients without having to transfer the entire string.) A property has an associated type, which is also identified using an atom.

A property has an associated “format”, an integer describing how many bits are in each unit of data inside the property. It must be 8, 16, or 32. When data is transferred between the server and client, if they are of different endianesses it will be byteswapped as necessary according to the format of the property. Note that on the client side, properties of format 32 will be stored with one unit per long, even if a long integer has more than 32 bits on the platform. (This decision was apparently made for Xlib to maintain compatibility with programs that assumed longs were 32 bits, at the expense of programs that knew better.)

The functions in this section are used to add, remove and change properties on windows, to convert atoms to and from strings and to manipulate some types of data commonly stored in X window properties.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Atom;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

enum GdkPropMode
----------------

Describes how existing data is combined with new data when using `gdk-property-change()`.

  * GDK-PROP-MODE-REPLACE: the new data replaces the existing data.

  * GDK-PROP-MODE-PREPEND: the new data is prepended to the existing data.

  * GDK-PROP-MODE-APPEND: the new data is appended to the existing data.

Methods
=======

new
---

### :intern

Finds or creates an atom corresponding to a given string.

    multi method new ( Str :$intern! )

  * Str $atom_name; a string.

### :native-object

Create a Drag object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

property-change
---------------

Changes the contents of a property on a window.

    method property-change (
      N-GObject $window, N-GObject $property, N-GObject $type,
      Int() $format where * ~~ any( 8, 16, 32),
      GdkPropMode $mode, Str $data
    )

  * N-GObject $window; A Gnome::Gdk3::Window

  * N-GObject $property; A Gnome::Gdk3::Atom, the property to change

  * N-GObject $type; A Gnome::Gdk3::Atom, the new type for the property. If mode is GDK_PROP_MODE_PREPEND or GDK_PROP_MODE_APPEND, then this must match the existing type or an error will occur.

  * Int() $format; the new format for the property. If mode is GDK_PROP_MODE_PREPEND or GDK_PROP_MODE_APPEND, then this must match the existing format or an error will occur.

  * GdkPropMode $mode; a value describing how the new data is to be combined with the current data.

  * Str $data; the data.

property-delete
---------------

Deletes a property from a window.

    method property-delete ( N-GObject $window, N-GObject $property )

  * N-GObject $window; A Gnome::Gdk3::Window

  * N-GObject $property; A Gnome::Gdk3::Atom, the property to delete

property-get
------------

    method property-get (
      N-GObject $window, N-GObject $property, N-GObject $type,
      UInt $offset, UInt $length, Bool $pdelete = False,
      --> List
    )

  * N-GObject $window; A Gnome::Gdk3::Window

  * N-GObject $property; A Gnome::Gdk3::Atom, the property to retrieve

  * N-GObject $type; A Gnome::Gdk3::Atom, the desired property type, or GDK_NONE, if any type of data is acceptable. If this does not match the actual type, then actual_format and actual_length will be filled in, a warning will be printed to stderr and no data will be returned.

  * UInt $offset; the offset into the property at which to begin retrieving data, in 4 byte units.

  * UInt $length; the length of the data to retrieve in bytes. Data is considered to be retrieved in 4 byte chunks, so length will be rounded up to the next highest 4 byte boundary (so be careful not to pass a value that might overflow when rounded up).

  * Bool $pdelete; if TRUE, delete the property after retrieving the data.

Returned List holds

  * Bool result; TRUE if data was successfully received and stored in data , otherwise FALSE.

  * N-GObject $actual_property_type;

  * Int $actual_format; the actual format of the data; either 8, 16 or 32 bits

  * Int $actual_length; Data returned in the 32 bit format is stored in a long variable, so the actual number of 32 bit elements should be be calculated via actual_length / sizeof(glong) to ensure portability to 64 bit systems.

  * Str $data;

utf8-to-string-target
---------------------

    method utf8-to-string-target ( Str $str --> Buf )

  * Str $str; a UTF-8 string

name
----

Determines the string corresponding to an atom.

Returns: a newly-allocated string containing the string corresponding to *atom*.

    method name ( --> Str )

