Gnome::Gtk3::IconInfo
=====================

Looking up icons by name

Description
===========

**Gnome::Gtk3::IconInfo** contains information found when looking up an icon in an icon theme.

**Gnome::Gtk3::IconTheme** provides a facility for looking up icons by name and size. The main reason for using a name rather than simply providing a filename is to allow different icons to be used depending on what “icon theme” is selected by the user. The operation of icon themes on Linux and Unix follows the [Icon Theme Specification](http://www.freedesktop.org/Standards/icon-theme-spec) There is a fallback icon theme, named `hicolor`, where applications should install their icons, but additional icon themes can be installed as operating system vendors and users choose.

In many cases, named themes are used indirectly, via **Gnome::Gtk3::Image** or stock items, rather than directly, but looking up icons directly is also simple. The **Gnome::Gtk3::IconTheme** object acts as a database of all the icons in the current theme. You can create new **Gnome::Gtk3::IconTheme** objects, but it’s much more efficient to use the standard icon theme for the **Gnome::Gdk3::Screen** so that the icon information is shared with other people looking up icons.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::IconInfo;
    also is Gnome::GObject::Object;

Uml Diagram
-----------

![](plantuml/IconInfo.svg)

Example
-------

To get information from a theme, do the following;

    my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
    my Gnome::Gtk3::IconInfo $ii = $icon-theme.lookup-icon('server-database');
    say $ii.get-base-scale;

Types
=====

Methods
=======

new
---

### :pixbuf, :theme

Create a new **Gnome::Gtk3::IconInfo** object using a **Gnome::Gdk3::Pixbuf**.

    multi method new (
      Gnome::Gdk3::Pixbuf :$pixbuf!,
      Gnome::Gtk3::IconTheme :$theme!
    )

  * $pixbuf; The pixbuf to wrap in

  * $theme; An icon theme

### :native-object

Create a IconInfo object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )




Get the last error code for icon info errors

    method last-error ( --> Gnome::Glib::Error )

get-base-scale
--------------

Gets the base scale for the icon. The base scale is a scale for the icon that was specified by the icon theme creator. For instance an icon drawn for a high-dpi screen with window scale 2 for a base size of 32 will be 64 pixels tall and have a base scale of 2.

Returns: the base scale

    method get-base-scale ( --> Int )

get-base-size
-------------

Gets the base size for the icon. The base size is a size for the icon that was specified by the icon theme creator. This may be different than the actual size of image; an example of this is small emblem icons that can be attached to a larger icon. These icons will be given the same base size as the larger icons to which they are attached.

Note that for scaled icons the base size does not include the base scale.

Returns: the base size, or 0, if no base size is known for the icon.

    method get-base-size ( --> Int )

get-filename
------------

Gets the filename for the icon. If the `GTK_ICON_LOOKUP_USE_BUILTIN` flag was passed to `Gnome::Gtk3::IconTheme.lookup_icon()`, there may be no filename if a builtin icon is returned; in this case, you should use `Gnome::Gtk3::IconInfo.get-builtin-pixbuf()`.

Returns: (type filename): the filename for the icon, or `undefined` if `Gnome::Gtk3::IconInfo.get-builtin-pixbuf()` should be used instead. The return value is owned by GTK+ and should not be modified or freed.

    method get-filename ( --> Str )

is-symbolic
-----------

Checks if the icon is symbolic or not. This currently uses only the file name and not the file contents for determining this. This behaviour may change in the future.

Returns: `True` if the icon is symbolic, `False` otherwise

    method is-symbolic ( --> Bool )

load-icon
---------

Renders an icon previously looked up in an icon theme using `Gnome::Gtk3::IconTheme.lookup_icon()`; the size will be based on the size passed to `Gnome::Gtk3::IconTheme.lookup_icon()`. Note that the resulting pixbuf may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the `GTK_ICON_LOOKUP_FORCE_SIZE` flag when obtaining the **Gnome::Gtk3::IconInfo**. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use `Gnome::GObject::Object.unref()` to release your reference to the icon.

    method load-icon ( --> N-GObject )

When an error occurs, check the last error attribute;

Example

    my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
    my Gnome::Gtk3::IconInfo $ii = $icon-theme.lookup-icon('server-database');
    my Gnome::Gdk3::Pixbuf() $pixbuf = $ii.load-icon;
    unless $pixbuf.is-valid {
      die "Couldn’t load icon: " ~ $ii.last-error.message;
    }

load-surface
------------

Renders an icon previously looked up in an icon theme using `Gnome::Gtk3::IconTheme.lookup_icon()`; the size will be based on the size passed to `Gnome::Gtk3::IconTheme.lookup_icon()`. Note that the resulting surface may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the `GTK_ICON_LOOKUP_FORCE_SIZE` flag when obtaining the **Gnome::Gtk3::IconInfo**. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use `Gnome::Cairo::Surface.destroy()` to release your reference to the icon.

    method load-surface ( N-GObject() $for_window --> cairo_surface_t )

  * $for_window; **Gnome::Gdk3::Window** to optimize drawing for, or `undefined`

When an error occurs, check the last error attribute;

load-symbolic
-------------

Loads an icon, modifying it to match the system colours for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from `.load_icon()`.

This allows loading symbolic icons that will match the system theme.

As implementation details, the icon loaded needs to be of SVG type, contain the “symbolic” term as the last component of the icon name, and use the “fg”, “success”, “warning” and “error” CSS styles in the SVG file itself.

See the [Symbolic Icons Specification](http://www.freedesktop.org/wiki/SymbolicIcons) for more information about symbolic icons.

Returns: a **Gnome::Gdk3::Pixbuf** representing the loaded icon

    method load-symbolic (
      N-GObject() $fg, N-GObject() $success_color,
      N-GObject() $warning_color, N-GObject() $error_color,
      Bool $was_symbolic
      --> N-GObject )

  * $fg; a **Gnome::Gdk3::RGBA** representing the foreground color of the icon

  * $success_color; a **Gnome::Gdk3::RGBA** representing the warning color of the icon or `undefined` to use the default color

  * $warning_color; a **Gnome::Gdk3::RGBA** representing the warning color of the icon or `undefined` to use the default color

  * $error_color; a **Gnome::Gdk3::RGBA** representing the error color of the icon or `undefined` to use the default color 

  * $was_symbolic; a **gboolean**, returns whether the loaded icon was a symbolic one and whether the *fg* color was applied to it.

  * $error; location to store error information on failure, or `undefined`.

When an error occurs, check the last error attribute;

load-symbolic-for-context
-------------------------

Loads an icon, modifying it to match the system colors for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from `.load_icon()`. This function uses the regular foreground color and the symbolic colors with the names “success_color”, “warning_color” and “error_color” from the context.

This allows loading symbolic icons that will match the system theme.

See `.load-symbolic()` for more details.

Returns: a **Gnome::Gdk3::Pixbuf** representing the loaded icon

    method load-symbolic-for-context (
      N-GObject() $context, Bool $was_symbolic
      --> N-GObject
    )

  * $context; a **Gnome::Gtk3::StyleContext**

  * $was_symbolic; a **gboolean**, returns whether the loaded icon was a symbolic one and whether the *fg* color was applied to it.

  * $error; location to store error information on failure, or `undefined`.

When an error occurs, check the last error attribute;

