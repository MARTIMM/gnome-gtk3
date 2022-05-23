Gnome::Gio::DesktopAppInfo
==========================

Application information from desktop files

Description
===========

**Gnome::Gio::DesktopAppInfo** is an implementation of **Gnome::Gio::AppInfo** based on desktop files.

Note that this module belongs to the UNIX-specific GIO interfaces.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::DesktopAppInfo;
    also is Gnome::GObject::Object;

Methods
=======

new
---

### :desktop-id

Create a new **Gnome::Gio::DesktopAppInfo** object.

    multi method new ( Str :$desktop-id! )

  * $desktop-id; The name of a desktop entry file. The file must be found in one of the directories set by one of the XDG environment variables. See also [the freedesktop](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

### :filename

Creates a new **Gnome::Gio::DesktopAppInfo** using a path to a file.

    multi method new ( Str :$filename! )

  * $filename; The name of a desktop entry file using a full path.

### :native-object

Create a DesktopAppInfo object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-action-name
---------------

Gets the user-visible display name of the "additional application action" specified by *action_name*.

This corresponds to the "Name" key within the keyfile group for the action.

Returns: the locale-specific action name

    method get-action-name ( Str $action_name --> Str )

  * $action_name; the name of the action as from `list_actions()`

get-boolean
-----------

Looks up a boolean value in the keyfile backing *info*.

The *key* is looked up in the "Desktop Entry" group.

Returns: the boolean value, or `False` if the key is not found

    method get-boolean ( Str $key --> Bool )

  * $key; the key to look up

get-categories
--------------

Gets the categories from the desktop file.

Returns: The unparsed Categories key from the desktop file; i.e. no attempt is made to split it by ';' or validate it.

    method get-categories ( --> Str )

get-filename
------------

When *info* was created from a known filename, return it. In some situations such as the **Gnome::Gio::DesktopAppInfo** returned from `new_from_keyfile()`, this function will return `undefined`.

Returns: (type filename): The full path to the file for *info*, or `undefined` if not known.

    method get-filename ( --> Str )

get-generic-name
----------------

Gets the generic name from the desktop file.

Returns: The value of the GenericName key

    method get-generic-name ( --> Str )

get-implementations
-------------------

Gets all applications that implement *interface*.

An application implements an interface if that interface is listed in the Implements= line of the desktop file of the application.

Returns: (element-type GDesktopAppInfo) : a list of **Gnome::Gio::DesktopAppInfo** objects.

    method get-implementations ( Str $interface --> N-GList )

  * $interface; the name of the interface

get-is-hidden
-------------

A desktop file is hidden if the Hidden key in it is set to True.

Returns: `True` if hidden, `False` otherwise.

    method get-is-hidden ( --> Bool )

get-keywords
------------

Gets the keywords from the desktop file.

Returns: The value of the Keywords key

    method get-keywords ( --> CArray[Str] )

get-locale-string
-----------------

Looks up a localized string value in the keyfile backing *info* translated to the current locale.

The *key* is looked up in the "Desktop Entry" group.

Returns: a newly allocated string, or `undefined` if the key is not found

    method get-locale-string ( Str $key --> Str )

  * $key; the key to look up

get-nodisplay
-------------

Gets the value of the NoDisplay key, which helps determine if the application info should be shown in menus. See `G_KEY_FILE_DESKTOP_KEY_NO_DISPLAY` and `g_app_info_should_show()`.

Returns: The value of the NoDisplay key

    method get-nodisplay ( --> Bool )

get-show-in
-----------

Checks if the application info should be shown in menus that list available applications for a specific name of the desktop, based on the `OnlyShowIn` and `NotShowIn` keys.

*desktop_env* should typically be given as `undefined`, in which case the `XDG_CURRENT_DESKTOP` environment variable is consulted. If you want to override the default mechanism then you may specify *desktop_env*, but this is not recommended.

Note that `g_app_info_should_show()` for *info* will include this check (with `undefined` for *desktop_env*) as well as additional checks.

Returns: `True` if the *info* should be shown in *desktop_env* according to the `OnlyShowIn` and `NotShowIn` keys, `False` otherwise.

    method get-show-in ( Str $desktop_env --> Bool )

  * $desktop_env; a string specifying a desktop name

get-startup-wm-class
--------------------

Retrieves the StartupWMClass field from *info*. This represents the WM_CLASS property of the main window of the application, if launched through *info*.

Returns: the startup WM class, or `undefined` if none is set in the desktop file.

    method get-startup-wm-class ( --> Str )

get-string
----------

Looks up a string value in the keyfile backing *info*.

The *key* is looked up in the "Desktop Entry" group.

Returns: a newly allocated string, or `undefined` if the key is not found

    method get-string ( Str $key --> Str )

  * $key; the key to look up

get-string-list
---------------

Looks up a string list value in the keyfile backing *info*.

The *key* is looked up in the "Desktop Entry" group.

Returns: (array zero-terminated=1 length=length) (element-type utf8) : a `undefined`-terminated string array or `undefined` if the specified key cannot be found. The array should be freed with `g_strfreev()`.

    method get-string-list ( Str $key, UInt $length --> CArray[Str] )

  * $key; the key to look up

  * $length; return location for the number of returned strings, or `undefined`

has-key
-------

Returns whether *key* exists in the "Desktop Entry" group of the keyfile backing *info*.

Returns: `True` if the *key* exists

    method has-key ( Str $key --> Bool )

  * $key; the key to look up

launch-action
-------------

Activates the named application action.

You may only call this function on action names that were returned from `list_actions()`.

Note that if the main entry of the desktop file indicates that the application supports startup notification, and *launch_context* is non-`undefined`, then startup notification will be used when activating the action (and as such, invocation of the action on the receiving side must signal the end of startup notification when it is completed). This is the expected behaviour of applications declaring additional actions, as per the desktop file specification.

As with `g_app_info_launch()` there is no way to detect failures that occur while using this function.

    method launch-action ( Str $action_name, N-GObject $launch_context )

  * $action_name; the name of the action as from `list_actions()`

  * $launch_context; a **Gnome::Gio::AppLaunchContext**

list-actions
------------

Returns the list of "additional application actions" supported on the desktop file, as per the desktop file specification.

As per the specification, this is the list of actions that are explicitly listed in the "Actions" key of the [Desktop Entry] group.

Returns: (element-type utf8) : a list of strings, always non-`undefined`

    method list-actions ( --> CArray[Str] )

search
------

Searches desktop files for ones that match *search_string*.

The return value is an array of strvs. Each strv contains a list of applications that matched *search_string* with an equal score. The outer list is sorted by score so that the first strv contains the best-matching applications, and so on. The algorithm for determining matches is undefined and may change at any time.

None of the search results are subjected to the normal validation checks performed by `new()` (for example, checking that the executable referenced by a result exists), and so it is possible for `new()` to return `undefined` when passed an app ID returned by this function. It is expected that calling code will do this when subsequently creating a **Gnome::Gio::DesktopAppInfo** for each result.

Returns: (element-type GStrv) : a list of strvs. Free each item with `g_strfreev()` and free the outer list with `g_free()`.

    method search ( Str $search_string --> CArray[CArray[Str]] )

  * $search_string; the search string to use

Properties
==========

filename
--------

The filename path of the desktop entry file

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is undefined.

