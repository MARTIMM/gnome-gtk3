Gnome::Gio::File
================

File and Directory Handling

Description
===========

**Gnome::Gio::File** is a high level abstraction for manipulating files on a virtual file system. **N-GFiles** are lightweight, immutable objects that do no I/O upon creation. It is necessary to understand that **Gnome::Gio::File** objects do not represent files, merely an identifier for a file.

To construct a **Gnome::Gio::File**, you can use:

  * `.new(:path)` if you have a path.

  * `.new(:uri)` if you have a URI.

  * `.new(:commandline-arg)` for a command line argument.

One way to think of a **Gnome::Gio::File** is as an abstraction of a pathname. For normal files the system pathname is what is stored internally, but as **N-GFiles** are extensible it could also be something else that corresponds to a pathname in a userspace implementation of a filesystem.

Many of the native subroutines originally in this module are not implemented in this Raku class. This is because I/O is very well supported by Raku and there is no need to provide I/O routines here. This class mainly exists to handle returned native objects from other classes. The most important calls needed are thus to get the name of a file or url.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::File;
    also is Gnome::N::TopLevelClassSupport;

Note
----

**Gnome::Gio::File** is defined as an interface in the Gnome libraries and therefore should be defined as a Raku role. However, many Gnome modules return native **Gnome::Gio::File** objects as if they are class objects. There aren't even Gnome classes using it as an interface. Presumably, it is defined like that so the developer can create classes using the File class as an interface which will not be the case in Raku.

Note
----

**Gnome::Gio::File** has many functions of which a large part will not be made available in Raku. This is because many are about read/write, move and rename which Raku is able to do very nice.

Types
=====

class N-GFile
-------------

Native object to hold a file representation

Methods
=======

new
---

### :path

Create a new File object using a path to a file.

    multi method new ( Str :$path! )

### :uri

Create a new File object using a uri.

    multi method new ( Str :$uri! )

### :commandline-arg, :cwd

Creates a **Gnome::Gio::File** with the given argument from the command line. The value of *arg* can be either a URI, an absolute path or a relative path resolved relative to the current working directory. This operation never fails, but the returned object might not support any I/O operation if *arg* points to a malformed path.

Note that on Windows, this function expects its argument to be in UTF-8 -- not the system code page. This means that you should not use this function with string from argv as it is passed to `main()`. `g-win32-get-command-line()` will return a UTF-8 version of the commandline. **Gnome::Gio::Application** also uses UTF-8 but `g-application-command-line-create-file-for-arg()` may be more useful for you there. It is also always possible to use this function with **Gnome::Gio::OptionContext** arguments of type `G-OPTION-ARG-FILENAME`.

Optionally a directory relative to the argument can be given in $cwd. Otherwise the working directory of the application is used.

    multi method new ( Str :$commandline-arg!, Str :$cwd? )

### :native-object

Create a File object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-basename
------------

Gets the base name (the last component of the path) for a given **Gnome::Gio::File**.

If called for the top level of a system (such as the filesystem root or a uri like sftp://host/) it will return a single directory separator (and on Windows, possibly a drive letter).

The base name is a byte string (not UTF-8). It has no defined encoding or rules other than it may not contain zero bytes. If you want to use filenames in a user interface you should use the display name that you can get by requesting the `G-FILE-ATTRIBUTE-STANDARD-DISPLAY-NAME` attribute with `query-info()`.

This call does no blocking I/O.

Returns: (type filename) : string containing the **Gnome::Gio::File**'s base name, or `undefined` if given **Gnome::Gio::File** is invalid. The returned string should be freed with `g-free()` when no longer needed.

    method get-basename ( --> Str )

get-child, get-child-rk
-----------------------

Gets a child of this *File* with basename equal to *name*.

Note that the file with that specific name might not exist, but you can still have a **Gnome::Gio::File** that points to it. You can use this for instance to create that file.

This call does no blocking I/O.

Returns: a **Gnome::Gio::File** to a child specified by *name*. Free the returned object with `.clear-object()`.

    method get-child ( Str $name --> N-GFile )
    method get-child-rk ( Str $name --> Gnome::Gio::File )

  * Str $name; (type filename): string containing the child's basename

get-child-for-display-name, get-child-for-display-name-rk
---------------------------------------------------------

Gets the child for a given *display-name* (i.e. a UTF-8 version of the name). If this function fails, it returns `undefined` and *error* will be set. This is very useful when constructing a **Gnome::Gio::File** for a new file and the user entered the filename in the user interface, for instance when you select a directory and type a filename in the file selector.

This call does no blocking I/O.

Returns: a native File object to the specified child, or `undefined` if the display name couldn't be converted.

For the `-rk()` version, when an error takes place, an error object is set and the returned object is invalid. The error is stored in the attribute `$.last-error`. Free the returned object with `clear-object()`.

    method get-child-for-display-name (
      Str $display_name --> N-GFile
    )

    method get-child-for-display-name-rk (
      Str $display_name --> Gnome::Gio::File
    )

### Example

    my Gnome::Gio::File $f .= new(:path<t/data/g-resources>);
    my Gnome::Gio::File $f2 = $f.get-child-for-display-name-rk('rtest')
    die $f.last-error.message unless $f2.is-valid;

  * Str $display_name; string to a possible child

get-parent, get-parent-rk
-------------------------

Gets the parent directory for the *file*. If the *file* represents the root directory of the file system, then `undefined` will be returned.

This call does no blocking I/O.

Returns: a **Gnome::Gio::File** structure to the parent of the given **Gnome::Gio::File** or `undefined` if there is no parent. Free the returned object with `clear-object()`.

    method get-parent ( --> N-GFile )
    method get-parent-rk ( --> Gnome::Gio::File )

get-parse-name
--------------

Gets the parse name of the *file*. A parse name is a UTF-8 string that describes the file such that one can get the **Gnome::Gio::File** back using `parse-name()`.

This is generally used to show the **Gnome::Gio::File** as a nice full-pathname kind of string in a user interface, like in a location entry.

For local files with names that can safely be converted to UTF-8 the pathname is used, otherwise the IRI is used (a form of URI that allows UTF-8 characters unescaped).

This call does no blocking I/O.

Returns: a string containing the **Gnome::Gio::File**'s parse name.

    method get-parse-name ( --> Str )

get-path
--------

Gets the local pathname for **Gnome::Gio::File**, if one exists. If non-`undefined`, this is guaranteed to be an absolute, canonical path. It might contain symlinks.

This call does no blocking I/O.

Returns: (type filename) : string containing the **Gnome::Gio::File**'s path, or `undefined` if no such path exists. The returned string should be freed with `g-free()` when no longer needed.

    method get-path ( --> Str )

get-relative-path
-----------------

Gets the path for *descendant* relative to *parent*.

This call does no blocking I/O.

Returns: string with the relative path from *descendant* to *parent*, or `undefined` if *descendant* doesn't have *parent* as prefix.

    method get-relative-path ( N-GFile $descendant --> Str )

  * N-GFile $descendant; input **Gnome::Gio::File**

get-uri
-------

Gets the URI for the *file*.

This call does no blocking I/O.

Returns: a string containing the **Gnome::Gio::File**'s URI. The returned string should be freed with `g-free()` when no longer needed.

    method get-uri ( --> Str )

get-uri-scheme
--------------

Gets the URI scheme for a **Gnome::Gio::File**. RFC 3986 decodes the scheme as:

    URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

Common schemes include "file", "http", "ftp", etc.

This call does no blocking I/O.

Returns: a string containing the URI scheme for the given **Gnome::Gio::File**. The returned string should be freed with `g-free()` when no longer needed.

    method get-uri-scheme ( --> Str )

has-parent
----------

Checks if *file* has a parent, and optionally, if it is *parent*.

If *parent* is `undefined` then this function returns `True` if *file* has any parent at all. If *parent* is non-`undefined` then `True` is only returned if *file* is an immediate child of *parent*.

Returns: `True` if *file* is an immediate child of *parent* (or any parent in the case that *parent* is `undefined`).

    method has-parent ( N-GFile $parent --> Bool )

  * N-GFile $parent; the parent to check for, or `undefined`

has-prefix
----------

Checks whether *file* has the prefix specified by *prefix*.

In other words, if the names of initial elements of *file*'s pathname match *prefix*. Only full pathname elements are matched, so a path like /foo is not considered a prefix of /foobar, only of /foo/bar.

A **Gnome::Gio::File** is not a prefix of itself. If you want to check for equality, use `equal()`.

This call does no I/O, as it works purely on names. As such it can sometimes return `False` even if *file* is inside a *prefix* (from a filesystem point of view), because the prefix of *file* is an alias of *prefix*.

Virtual: prefix-matches

Returns: `True` if the *files*'s parent, grandparent, etc is *prefix*, `False` otherwise.

    method has-prefix ( N-GFile $prefix --> Bool )

  * N-GFile $prefix; input **Gnome::Gio::File**

has-uri-scheme
--------------

Checks to see if a **Gnome::Gio::File** has a given URI scheme.

This call does no blocking I/O.

Returns: `True` if **Gnome::Gio::File**'s backend supports the given URI scheme, `False` if URI scheme is `undefined`, not supported, or **Gnome::Gio::File** is invalid.

    method has-uri-scheme ( Str $uri_scheme --> Bool )

  * Str $uri_scheme; a string containing a URI scheme

is-native
---------

Checks to see if a file is native to the platform.

A native file is one expressed in the platform-native filename format, e.g. "C:\Windows" or "/usr/bin/". This does not mean the file is local, as it might be on a locally mounted remote filesystem.

On some systems non-native files may be available using the native filesystem via a userspace filesystem (FUSE), in these cases this call will return `False`, but `get-path()` will still return a native path.

This call does no blocking I/O.

Returns: `True` if *file* is native

    method is-native ( --> Bool )

query-default-handler
---------------------

Returns the **Gnome::Gio::AppInfo** that is registered as the default application to handle the file specified by *file*.

If *cancellable* is not `undefined`, then the operation can be cancelled by triggering the cancellable object from another thread. If the operation was cancelled, the error `G-IO-ERROR-CANCELLED` will be returned.

Returns: a **Gnome::Gio::AppInfo** if the handle was found, `undefined` if there were errors and `$.last-error` becomes valid. When you are done with it, release it with `clear-object()`

    method query-default-handler (
      N-GObject $cancellable --> Gnome::Gio::AppInfo
    )

  * N-GObject $cancellable; optional **Gnome::Gio::Cancellable** object, `undefined` to ignore. (TODO: Cancellable not defined yet)

query-info
----------

Gets the requested information about specified *file*. The result is a **Gnome::Gio::FileInfo** object that contains key-value attributes (such as the type or size of the file).

The *attributes* value is a string that specifies the file attributes that should be gathered. It is not an error if it's not possible to read a particular requested attribute from a file - it just won't be set. *attributes* should be a comma-separated list of attributes or attribute wildcards. The wildcard "*" means all attributes, and a wildcard like "standard::*" means all attributes in the standard namespace. An example attribute query be "standard::*,owner::user". The standard attributes are available as defines, like **Gnome::Gio::-FILE-ATTRIBUTE-STANDARD-NAME**.

If *cancellable* is not `undefined`, then the operation can be cancelled by triggering the cancellable object from another thread. If the operation was cancelled, the error `G-IO-ERROR-CANCELLED` will be returned.

For symlinks, normally the information about the target of the symlink is returned, rather than information about the symlink itself. However if you pass **Gnome::Gio::-FILE-QUERY-INFO-NOFOLLOW-SYMLINKS** in *flags* the information about the symlink itself will be returned. Also, for symlinks that point to non-existing files the information about the symlink itself will be returned.

If the file does not exist, the `G-IO-ERROR-NOT-FOUND` error will be returned. Other errors are possible too, and depend on what kind of filesystem the file is on.

Returns: a **Gnome::Gio::FileInfo** for the given *file*, or `undefined` on error. Free the returned object with `clear-object()`.

    method query-info ( Str $attributes, GFileQueryInfoFlags $flags, GCancellable $cancellable, N-GError $error --> GFileInfo )

  * Str $attributes; an attribute query string

  * UInt $flags; a set of GFileQueryInfoFlags

  * N-GObject $cancellable; optional **Gnome::Gio::Cancellable** object, `undefined` to ignore

