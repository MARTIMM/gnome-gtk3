Gnome::Gtk3::CssProvider
========================

CSS-like styling for widgets

Description
===========

**Gnome::Gtk3::CssProvider** is an object implementing the **Gnome::Gtk3::StyleProvider** interface. It is able to parse [CSS-like](https://developer.gnome.org/gtk3/3.24/chap-css-overview.html#css-overview) input in order to style widgets.

An application can make GTK+ parse a specific CSS style sheet by calling `gtk_css_provider_load_from_file()` or `gtk_css_provider_load_from_resource()` and adding the provider with `gtk_style_context_add_provider()` or `gtk_style_context_add_provider_for_screen()`. In addition, certain files will be read when GTK+ is initialized. First, the file `$XDG_CONFIG_HOME/gtk-3.0/gtk.css` is loaded if it exists. Then, GTK+ loads the first existing file among `XDG_DATA_HOME/themes/theme-name/gtk-VERSION/gtk.css`, `$HOME/.themes/theme-name/gtk-VERSION/gtk.css`, `$XDG_DATA_DIRS/themes/theme-name/gtk-VERSION/gtk.css` and `DATADIR/share/themes/THEME/gtk-VERSION/gtk.css`, where `THEME` is the name of the current theme (see the prop `gtk-theme-name` setting), `DATADIR` is the prefix configured when GTK+ was compiled (unless overridden by the `GTK_DATA_PREFIX` environment variable), and `VERSION` is the GTK+ version number. If no file is found for the current version, GTK+ tries older versions all the way back to 3.0.

In the same way, GTK+ tries to load a gtk-keys.css file for the current key theme, as defined by prop `gtk-key-theme-name`.

Implemented Interfaces
----------------------

Gnome::Gtk3::CssProvider implements

  * [Gnome::Gtk3::StyleProvider](StyleProvider.html)

  * Gnome::Gtk3::StyleProviderPrivate

See Also
--------

**Gnome::Gtk3::StyleContext**, **Gnome::Gtk3::StyleProvider**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CssProvider;
    also is Gnome::GObject::Object;
    also does Gnome::Gtk3::StyleProvider;

Example
-------

Types
=====

enum GtkCssProviderError
------------------------

Error codes for `GTK_CSS_PROVIDER_ERROR`.

  * GTK_CSS_PROVIDER_ERROR_FAILED: Failed.

  * GTK_CSS_PROVIDER_ERROR_SYNTAX: Syntax error.

  * GTK_CSS_PROVIDER_ERROR_IMPORT: Import error.

  * GTK_CSS_PROVIDER_ERROR_NAME: Name error.

  * GTK_CSS_PROVIDER_ERROR_DEPRECATED: Deprecation error.

  * GTK_CSS_PROVIDER_ERROR_UNKNOWN_VALUE: Unknown value.

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[[gtk_] css_provider_] error_quark
----------------------------------

Return the domain code of the builder error domain.

    method gtk_css_provider_error_quark ( --> Int )

[gtk_] css_provider_new
-----------------------

Returns a newly created **Gnome::Gtk3::CssProvider**.

    method gtk_css_provider_new ( --> N-GObject )

[[gtk_] css_provider_] to_string
--------------------------------

Converts the provider into a string representation in CSS format.

Using `gtk_css_provider_load_from_data()` with the return value from this function on a new provider created with `gtk_css_provider_new()` will basically create a duplicate of the provider.

Returns: a new string representing the *provider*.

Since: 3.2

    method gtk_css_provider_to_string ( --> char  )

[[gtk_] css_provider_] load_from_data
-------------------------------------

Loads *$data* into the provider, and by doing so clears any previously loaded information.

Returns: Gnome::Glib::Error. Test the error-is-valid flag of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig `parsing-error` signal.

    method gtk_css_provider_load_from_data (
      Str $data, Int $length
      --> Gnome::Glib::Error
    )

  * Str $data; (array length=length) (element-type guint8): CSS data loaded in memory

  * Int $length; the length of *data* in bytes, or -1 for NUL terminated strings. If *length* is not -1, the code will assume it is not NUL terminated and will potentially do a copy.

[[gtk_] css_provider_] load_from_path
-------------------------------------

Loads the data contained in *$path* into the provider, clearing any previously loaded information.

Returns: Gnome::Glib::Error. Test the error-is-valid flag of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig `parsing-error` signal.

    method gtk_css_provider_load_from_path ( Str $path --> Gnome::Glib::Error )

  * Str $path; the path of a filename to load, in the GLib filename encoding

[[gtk_] css_provider_] get_named
--------------------------------

Loads a theme from the usual theme paths

Returns: (transfer none): a **Gnome::Gtk3::CssProvider** with the theme loaded. This memory is owned by GTK+, and you must not free it.

    method gtk_css_provider_get_named ( Str $name, Str $variant --> N-GObject  )

  * Str $name; A theme name

  * Str $variant; (allow-none): variant to load, for example, "dark", or `Any` for the default

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### parsing-error

Signals that a parsing error occurred. the *path*, *line* and *position* describe the actual location of the error as accurately as possible.

Parsing errors are never fatal, so the parsing will resume after the error. Errors may however cause parts of the given data or even all of it to not be parsed at all. So it is a useful idea to check that the parsing succeeds by connecting to this signal.

Note that this signal may be emitted at any time as the css provider may opt to defer parsing parts or all of the input to a later time than when a loading function was called.

    method handler (
      N-GObject $section,
      N-GError $error,
      Gnome::GObject::Object :widget($provider),
      *%user-options
    );

  * $provider; the provider that had a parsing error

  * $section; a native (GtkCssSection) section the error happened in

  * $error; The parsing error

