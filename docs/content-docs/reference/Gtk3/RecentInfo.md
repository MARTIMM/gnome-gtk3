Gnome::Gtk3::RecentInfo
=======================

Class for recently used files information

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RecentInfo;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

class N-GtkRecentInfo
---------------------

**N-GtkRecentInfo**-struct contains only private data and should be accessed using the provided API.

Methods
=======

new()
-----

### :native-object

Create a RecentInfo object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GtkRecentInfo :$native-object! )

get-uri
-------

Gets the URI of the resource.

Returns: the URI of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-uri ( -->  Str  )

get-display-name
----------------

Gets the name of the resource. If none has been defined, the basename of the resource is obtained.

Returns: the display name of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-display-name ( -->  Str  )

get-description
---------------

Gets the (short) description of the resource.

Returns: the description of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-description ( -->  Str  )

get-mime-type
-------------

Gets the MIME type of the resource.

Returns: the MIME type of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-mime-type ( -->  Str  )

get-added
---------

Gets the timestamp (seconds from system’s Epoch) when the resource was added to the recently used resources list.

Returns: the number of seconds elapsed from system’s Epoch when the resource was added to the list, or -1 on failure.

    method get-added ( --> Int )

get-modified
------------

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last modified.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last modified, or -1 on failure.

    method get-modified ( --> Int )

get-visited
-----------

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last visited.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last visited, or -1 on failure.

    method get-visited ( --> Int )

get-private-hint
----------------

Gets the value of the “private” flag. Resources in the recently used list that have this flag set to `True` should only be displayed by the applications that have registered them.

Returns: `True` if the private flag was found, `False` otherwise

    method get-private-hint ( --> Bool )

get-application-info
--------------------

Gets the data regarding the application that has registered the resource. If the command line contains any escape characters defined inside the storage specification, they will be expanded.

if an application with *app_name* has registered this resource inside the recently used list a 3 element **List** is returned. An empty list is returned otherwise.

    method get-application-info ( Str $app_name --> List )

  * Str $app_name; the name of the application that has registered this item

The returned list holds;

  * Str $app_exec; the string containing the command line

  * UInt $count; the number of times this item was registered

  * Int $time; the timestamp this item was last registered for this application

get-applications
----------------

Retrieves the list of applications that have registered this resource.

Returns: an array of strings.

    method get-applications ( --> Array )

last-application
----------------

Gets the name of the last application that have registered the recently used resource represented by *info*.

Returns: an application name.

    method last-application ( --> Str )

has-application
---------------

Checks whether an application registered this resource using *$app_name*.

Returns: `True` if an application with name *$app_name* was found, `False` otherwise

    method has-application ( Str  $app_name --> Bool )

  * Str $app_name; a string containing an application name

get-groups
----------

Returns all groups registered for the recently used item *info*.

    method get-groups ( --> Array )

has-group
---------

Checks whether *group_name* appears inside the groups registered for the recently used item *info*.

Returns: `True` if the group was found

    method has-group ( Str  $group_name --> Bool )

  * Str $group_name; name of a group

get-icon
--------

Retrieves the icon of size *size* associated to the resource MIME type.

Returns: (nullable) (transfer full): a **Gnome::Gdk3::Pixbuf** containing the icon, or `Any`. Use `clear-object()` when finished using the icon.

    method get-icon ( Int $size --> N-GObject )

  * Int $size; the size of the icon in pixels

get-short-name
--------------

Computes a valid UTF-8 string that can be used as the name of the item in a menu or list. For example, calling this function on an item that refers to “file:///foo/bar.txt” will yield “bar.txt”.

Returns: A newly-allocated string in UTF-8 encoding.

    method get-short-name ( --> Str )

get-uri-display
---------------

Gets a displayable version of the resource’s URI. If the resource is local, it returns a local path; if the resource is not local, it returns the UTF-8 encoded content of `get-uri()`.

Returns: (nullable): a newly allocated UTF-8 string containing the resource’s URI or `Any`. Use `g_free()` when done using it.

    method get-uri-display ( --> Str )

get-age
-------

Gets the number of days elapsed since the last update of the resource pointed by *info*.

Returns: a positive integer containing the number of days elapsed since the time this resource was last modified

    method get-age ( --> Int )

is-local
--------

Checks whether the resource is local or not by looking at the scheme of its URI.

Returns: `True` if the resource is local

    method is-local ( --> Bool )

exists
------

Checks whether the resource still exists. At the moment this check is done only on resources pointing to local files.

Returns: `True` if the resource exists

    method exists ( --> Bool )

match
-----

Checks whether two **Gnome::Gtk3::RecentInfo**-struct point to the same resource.

Returns: `True` if both **Gnome::Gtk3::RecentInfo**-struct point to the same resource, `False` otherwise.

    method match ( N-GtkRecentInfo $info --> Bool )

  * N-GtkRecentInfo $info; a native **Gnome::Gtk3::RecentInfo** object.

