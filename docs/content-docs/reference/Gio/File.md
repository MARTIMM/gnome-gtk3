Gnome::Gio::File
================

File and Directory Handling

Description
===========

*include*: gio/gio.h

**N-GFile** is a high level abstraction for manipulating files on a virtual file system. **N-GFiles** are lightweight, immutable objects that do no I/O upon creation. It is necessary to understand that **N-GFile** objects do not represent files, merely an identifier for a file.

To construct a **N-GFile**, you can use:

  * `g_file_new_for_path()` if you have a path.

  * `g_file_new_for_uri()` if you have a URI.

One way to think of a **N-GFile** is as an abstraction of a pathname. For normal files the system pathname is what is stored internally, but as **N-GFiles** are extensible it could also be something else that corresponds to a pathname in a userspace implementation of a filesystem.

Many of the native subroutines originally in this module are not implemented in this Raku class. This is because I/O is very well supported by Raku and there is no need to provide I/O routines here. This class mainly exists to handle returned native objects from other classes. The most important calls needed are thus to get the name of a file or url.

See Also
--------

**GFileInfo**, **GFileEnumerator**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::File;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

class N-GFile
-------------

Native object to hold a file representation

Methods
=======

new
---

Create a new File object.

    multi method new ( )

Create a File object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a File object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[g_] object_unref
-----------------

Decreases the reference count of the native object. When its reference count drops to 0, the object is finalized (i.e. its memory is freed).

    method g_object_unref ( N-GFile $object )

  * N-GObject $object; a *N-GFile*

[g_file_] get_basename
----------------------

Gets the base name (the last component of the path) for a given **N-GFile**.

If called for the top level of a system (such as the filesystem root or a uri like sftp://host/) it will return a single directory separator (and on Windows, possibly a drive letter).

The base name is a byte string (not UTF-8). It has no defined encoding or rules other than it may not contain zero bytes. If you want to use filenames in a user interface you should use the display name that you can get by requesting the `G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME` attribute with `g_file_query_info()`.

This call does no blocking I/O.

Returns: (type filename) (nullable): string containing the **N-GFile**'s base name, or `Any` if given **N-GFile** is invalid. The returned string should be freed with `g_free()` when no longer needed.

    method g_file_get_basename ( --> Str )

[g_file_] get_path
------------------

Gets the local pathname for **N-GFile**, if one exists. If non-`Any`, this is guaranteed to be an absolute, canonical path. It might contain symlinks.

This call does no blocking I/O.

Returns: (type filename) (nullable): string containing the **N-GFile**'s path, or `Any` if no such path exists. The returned string should be freed with `g_free()` when no longer needed.

    method g_file_get_path ( --> Str )

[g_file_] get_uri
-----------------

Gets the URI for the *file*.

This call does no blocking I/O.

Returns: a string containing the **N-GFile**'s URI. The returned string should be freed with `g_free()` when no longer needed.

    method g_file_get_uri ( --> Str )

[g_file_] get_parse_name
------------------------

Gets the parse name of the *file*. A parse name is a UTF-8 string that describes the file such that one can get the **N-GFile** back using `g_file_parse_name()`.

This is generally used to show the **N-GFile** as a nice full-pathname kind of string in a user interface, like in a location entry.

For local files with names that can safely be converted to UTF-8 the pathname is used, otherwise the IRI is used (a form of URI that allows UTF-8 characters unescaped).

This call does no blocking I/O.

Returns: a string containing the **N-GFile**'s parse name. The returned string should be freed with `g_free()` when no longer needed.

    method g_file_get_parse_name ( --> Str )

[g_file_] is_native
-------------------

Checks to see if a file is native to the platform.

A native file is one expressed in the platform-native filename format, e.g. "C:\Windows" or "/usr/bin/". This does not mean the file is local, as it might be on a locally mounted remote filesystem.

On some systems non-native files may be available using the native filesystem via a userspace filesystem (FUSE), in these cases this call will return `0`, but `g_file_get_path()` will still return a native path.

This call does no blocking I/O.

Returns: `1` if *file* is native

    method g_file_is_native ( --> Int )

[g_file_] has_uri_scheme
------------------------

Checks to see if a **N-GFile** has a given URI scheme.

This call does no blocking I/O.

Returns: `1` if **N-GFile**'s backend supports the given URI scheme, `0` if URI scheme is `Any`, not supported, or **N-GFile** is invalid.

    method g_file_has_uri_scheme ( Str $uri_scheme --> Int )

  * Str $uri_scheme; a string containing a URI scheme

[g_file_] get_uri_scheme
------------------------

Gets the URI scheme for a **N-GFile**. RFC 3986 decodes the scheme as: |[ URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ] ]| Common schemes include "file", "http", "ftp", etc.

This call does no blocking I/O.

Returns: a string containing the URI scheme for the given **N-GFile**. The returned string should be freed with `g_free()` when no longer needed.

    method g_file_get_uri_scheme ( --> Str )

