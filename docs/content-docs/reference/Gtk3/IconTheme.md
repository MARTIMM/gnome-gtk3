Gnome::Gtk3::IconTheme
======================

Looking up icons by name

Description
===========

**Gnome::Gtk3::IconTheme** provides a facility for looking up icons by name and size. The main reason for using a name rather than simply providing a filename is to allow different icons to be used depending on what “icon theme” is selected by the user. The operation of icon themes on Linux and Unix follows the [Icon Theme Specification](http://www.freedesktop.org/Standards/icon-theme-spec) There is a fallback icon theme, named `hicolor`, where applications should install their icons, but additional icon themes can be installed as operating system vendors and users choose.

The **Gnome::Gtk3::IconTheme** object acts as a database of all the icons in the current theme. You can create new **Gnome::Gtk3::IconTheme** objects, but it’s much more efficient to use the standard icon theme for the **Gnome::Gdk3::Screen** so that the icon information is shared with other people looking up icons.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::IconTheme;
    also is Gnome::GObject::Object;

Uml Diagram
-----------

![](plantuml/IconTheme.svg)

Example
-------

This example shows how to load an icon and check for errors

    my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
    my Gnome::Gdk3::Pixbuf() $pixbuf = $icon-theme.load-icon(
      'server-database',    # an icon name
      48,                   # icon size
      0,                    # flags
    );

    unless $pixbuf.is-valid {
      my Gnome::Glib::Error() $e = $icon-theme.last-error;
      die "Couldn’t load icon: " ~ $e.message;
    }

Types
=====

enum GtkIconLookupFlags
-----------------------

Used to specify options for `.lookup-icon()`

  * GTK_ICON_LOOKUP_NO_SVG: Never get SVG icons, even if gdk-pixbuf supports them. Cannot be used together with `GTK_ICON_LOOKUP_FORCE_SVG`.

  * GTK_ICON_LOOKUP_FORCE_SVG: Get SVG icons, even if gdk-pixbuf doesn’t support them. Cannot be used together with `GTK_ICON_LOOKUP_NO_SVG`.

  * GTK_ICON_LOOKUP_USE_BUILTIN: When passed to `.lookup-icon()` includes builtin icons as well as files. For a builtin icon, `Gnome::Gtk3::IconInfo.get-filename()` is `Any` and you need to call `Gnome::Gtk3::IconInfo.get-builtin-pixbuf()`.

  * GTK_ICON_LOOKUP_GENERIC_FALLBACK: Try to shorten icon name at '-' characters before looking at inherited themes. This flag is only supported in functions that take a single icon name. For more general fallback, see `.choose-icon()`.

  * GTK_ICON_LOOKUP_FORCE_SIZE: Always get the icon scaled to the requested size.

  * GTK_ICON_LOOKUP_FORCE_REGULAR: Try to always load regular icons, even when symbolic icon names are given.

  * GTK_ICON_LOOKUP_FORCE_SYMBOLIC: Try to always load symbolic icons, even when regular icon names are given.

  * GTK_ICON_LOOKUP_DIR_LTR: Try to load a variant of the icon for left-to-right text direction.

  * GTK_ICON_LOOKUP_DIR_RTL: Try to load a variant of the icon for right-to-left text direction.

enum GtkIconThemeError
----------------------

Error codes for **Gnome::Gtk3::IconTheme** operations.

  * GTK_ICON_THEME_NOT_FOUND: The icon specified does not exist in the theme

  * GTK_ICON_THEME_FAILED: An unspecified error occurred.

Methods
=======

new
---

### default, no options

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use `.new(:default)` or `.new(:screen)` rather than creating a new icon theme object from scratch.

    multi method new ( )

### new(:default)

Gets the icon theme for the default screen. See `.get-for-screen()`. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it. Use of named attribute is enough to select this action.

    multi method new ( Bool :$default )

### new(:screen)

Gets the icon theme object associated with *$screen*; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling `.new()` and setting the screen yourself; by using this function a single icon theme object will be shared between users. This icon theme is associated with the screen and can be used as long as the screen is open.

    multi method new ( N-GObject :$screen )

error-quark
-----------

Get the error code for icon theme errors

    method error-quark ( --> Int )




Get the last error code for icon theme errors

    method last-error ( --> N-GError )

add-resource-path
-----------------

Adds a resource path that will be looked at when looking for icons, similar to search paths.

This function should be used to make application-specific icons available as part of the icon theme.

The resources are considered as part of the hicolor icon theme and must be located in subdirectories that are defined in the hicolor icon theme, such as `*path*/16x16/actions/run.png`. Icons that are directly placed in the resource path instead of a subdirectory are also considered as ultimate fallback.

    method add-resource-path ( Str $path )

  * $path; a resource path

append-search-path
------------------

Appends a directory to the search path. See `.set-search-path()`.

    method append-search-path ( Str $path )

  * $path; (type filename): directory name to append to the icon path

get-example-icon-name
---------------------

Gets the name of an icon that is representative of the current theme (for instance, to use when presenting a list of themes to the user.)

Returns: the name of an example icon or undefined.

    method get-example-icon-name ( --> Str )

has-icon
--------

Checks whether an icon theme includes an icon for a particular name.

Returns: `True` if *icon_theme* includes an icon for *icon-name*.

    method has-icon ( Str $icon_name --> Bool )

  * $icon_name; the name of an icon

list-contexts
-------------

Gets the list of contexts available within the current hierarchy of icon themes. See `list-icons()` for details about contexts.

Returns: (element-type utf8) : a **Gnome::Gio::List** list holding the names of all the contexts in the theme.

    method list-contexts ( --> N-GList )

list-icons
----------

Lists the icons in the current icon theme. Only a subset of the icons can be listed by providing a context string. The set of values for the context string is system dependent, but will typically include such values as “Applications” and “MimeTypes”. Contexts are explained in the [Icon Theme Specification](http://www.freedesktop.org/wiki/Specifications/icon-theme-spec). The standard contexts are listed in the [Icon Naming Specification](http://www.freedesktop.org/wiki/Specifications/icon-naming-spec). Also see `list-contexts()`.

Returns: (element-type utf8) : a **Gnome::Gio::List** list holding the names of all the icons in the theme.

    method list-icons ( Str $context --> N-GList )

  * $context; a string identifying a particular type of icon, or `undefined` to list all icons.

load-icon
---------

Looks up an icon in an icon theme, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use `lookup-icon()` followed by `Gnome::Gtk3::Info.load-icon()`.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the style-set signal defined in **Gnome::Gtk3::Widget**.

Returns: the rendered icon (a native **Gnome::Gdk3::Pixbuf**); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Returns an undefined object if the icon isn’t found.

    method load-icon (
      Str $icon_name, Int() $size, UInt $flags
      --> N-GObject
    )

  * $icon_name; the name of the icon to lookup

  * $size; the desired icon size. The resulting icon may not be exactly this size; see `Gnome::Gtk3::IconInfo.load-icon()`.

  * $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup

When an error occurs, check the last error attribute;

### Example

    my Gnome::Gdk3::Pixbuf() $pixbuf;
    $pixbuf = $icon-theme.load-icon( 'server-database', 32, 0);
    unless $pixbuf.is-valid {
      my Gnome::Glib::Error() $e = $icon-theme.last-error;
      die "Couldn’t load icon: " ~ $e.message;
    }

load-icon-for-scale
-------------------

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use `lookup-icon()` followed by `Gnome::Gtk3::Info.load-icon()`.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal.

Returns: the rendered icon (a native **Gnome::Gdk3::Pixbuf**); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Returns an undefined object if the icon isn’t found.

    method load-icon-for-scale (
      Str $icon-name, Int() $size, Int() $scale, UInt $flags
      --> N-GObject
    )

  * $icon-name; the name of the icon to lookup

  * $size; the desired icon size. The resulting icon may not be exactly this size; see `Gnome::Gtk3::Info.load-icon()`.

  * $scale; desired scale

  * $flags; flags modifying the behavior of the icon lookup

load-surface
------------

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a cairo surface. This is a convenience function; if more details about the icon are needed, use `lookup-icon()` followed by `Gnome::Gtk3::Info.load-surface()`.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal.

Returns: the rendered icon (a cairo surface_t); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use `cairo-surface-destroy()` to release your reference to the icon. `undefined` if the icon isn’t found.

    method load-surface (
      Str $icon_name, Int() $size, Int() $scale,
      N-GObject() $for-window, UInt $flags
      --> cairo_surface_t
    )

  * $icon_name; the name of the icon to lookup

  * $size; the desired icon size. The resulting icon may not be exactly this size; see `Gnome::Gtk3::Info.load-icon()`.

  * $scale; desired scale

  * $for-window; **Gnome::Gdk3::Window** to optimize drawing for, or `undefined`

  * $flags; flags modifying the behavior of the icon lookup

lookup-by-gicon
---------------

Looks up an icon and returns a native **Gnome::Gtk3::IconInfo** containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using `Gnome::Gtk3::IconInfo.load-icon()`.

When rendering on displays with high pixel densities you should not use a *size* multiplied by the scaling factor returned by functions like `gdk-window-get-scale-factor()`. Instead, you should use `lookup-by-gicon-for-scale()`, as the assets loaded for a given scaling factor may be different.

Returns: a native **Gnome::Gtk3::IconInfo** containing information about the icon, or `undefined` if the icon wasn’t found.

    method lookup-by-gicon (
      N-GObject() $icon, Int() $size, UInt() $flags
      --> N-GObject
    )

  * $icon; the **Gnome::Gio::Icon** to look up

  * $size; desired icon size

  * $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup

lookup-by-gicon-for-scale
-------------------------

Looks up an icon and returns a native **Gnome::Gtk3::IconInfo** containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using `Gnome::Gtk3::IconInfo.load-icon()`.

Returns: a native **Gnome::Gtk3::IconInfo** containing information about the icon, or `undefined` if the icon wasn’t found.

    method lookup-by-gicon-for-scale (
      N-GObject() $icon, Int() $size, Int() $scale, UInt $flags
      --> N-GObject
    )

  * $icon; the **Gnome::Gio::Icon** to look up

  * $size; desired icon size

  * $scale; the desired scale

  * $flags; flags modifying the behavior of the icon lookup

lookup-icon
-----------

Looks up a named icon and returns a native **Gnome::Gtk3::IconInfo** containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using `Gnome::Gtk3::IconInfo.load-icon()`. (`.load-icon()` combines these two steps if all you need is the pixbuf.)

When rendering on displays with high pixel densities you should not use a *size* multiplied by the scaling factor returned by functions like `gdk-window-get-scale-factor()`. Instead, you should use `lookup-icon-for-scale()`, as the assets loaded for a given scaling factor may be different.

Returns: a native **Gnome::Gtk3::IconInfo** object containing information about the icon, or `undefined` if the icon wasn’t found.

    method lookup-icon (
      Str $icon-name, Int() $size, UInt $flags --> N-GObject
    )

  * $icon_name; the name of the icon to lookup

  * $size; desired icon size

  * $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup

lookup-icon-for-scale
---------------------

Looks up a named icon for a particular window scale and returns a native **Gnome::Gtk3::IconInfo** containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using `Gnome::Gtk3::IconInfo.load-icon()`. (`load-icon()` combines these two steps if all you need is the pixbuf.)

Returns: a native **Gnome::Gtk3::IconInfo** object containing information about the icon, or `undefined` if the icon wasn’t found.

    method lookup-icon-for-scale (
      Str $icon_name, Int() $size, Int() $scale, UInt $flags
      --> N-GObject
    )

  * $icon_name; the name of the icon to lookup

  * $size; desired icon size

  * $scale; the desired scale

  * $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup

prepend-search-path
-------------------

Prepends a directory to the search path. See `set-search-path()`.

    method prepend-search-path ( Str $path )

  * $path; (type filename): directory name to prepend to the icon path

rescan-if-needed
----------------

Checks to see if the icon theme has changed; if it has, any currently cached information is discarded and will be reloaded next time *icon_theme* is accessed.

Returns: `True` if the icon theme has changed and needed to be reloaded.

    method rescan-if-needed ( --> Bool )

set-custom-theme
----------------

Sets the name of the icon theme that the **Gnome::Gtk3::IconTheme** object uses overriding system configuration. This function cannot be called on the icon theme objects returned from `get-default()` and `get-for-screen()`.

    method set-custom-theme ( Str $theme_name )

  * $theme_name; name of icon theme to use instead of configured theme, or `undefined` to unset a previously set custom theme

set-screen
----------

Sets the screen for an icon theme; the screen is used to track the user’s currently configured icon theme, which might be different for different screens.

    method set-screen ( N-GObject() $screen )

  * $screen; a **Gnome::Gdk3::Screen**

set-search-path
---------------

Sets the search path for the icon theme object. When looking for an icon theme, GTK+ will search for a subdirectory of one or more of the directories in *path* with the same name as the icon theme containing an index.theme file. (Themes from multiple of the path elements are combined to allow themes to be extended by adding icons in the user’s home directory.)

In addition if an icon found isn’t found either in the current icon theme or the default icon theme, and an image file with the right name is found directly in one of the elements of *path*, then that image will be used for the icon name. (This is legacy feature, and new icons should be put into the fallback icon theme, which is called hicolor, rather than directly on the icon path.)

    method set-search-path (  $const gchar *path[], Int() $n_elements )

  * $const gchar *path[]; (array length=n_elements) (element-type filename): array of directories that are searched for icon themes

  * $n_elements; number of elements in *path*.

Signals
=======

changed
-------

Emitted when the current icon theme is switched or GTK+ detects that a change has occurred in the contents of the current icon theme.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

