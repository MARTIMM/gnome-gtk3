TITLE
=====

Gnome::Glib::Error

SUBTITLE
========

a system for reporting errors

Description
===========

GLib provides a standard method of reporting errors from a called function to the calling code. Functions that can fail take a return location for a `N-GError` as their last argument. On error, a new `N-GError` instance will be allocated and returned to the caller via this argument. After handling the error, the error object must be freed. Do this using `clear-error()`.

The `N-GError` object contains three fields: *domain* indicates the module the error-reporting function is located in, *code* indicates the specific error that occurred, and *message* is a user-readable error message with as many details as possible. Several functions are provided to deal with an error received from a called function: `g_error_matches()` returns `1` if the error matches a given domain and code. To display an error to the user, simply call the `message()` method, perhaps along with additional context known only to the calling function.

This class is greatly simplified because in Raku one can use Exception classes to throw any errors. It exists mainly to handle errors coming from other GTK+ functions.

Error domains and codes are conventionally named as follows:

  * The error domain is called *NAMESPACE*_*MODULE*_ERROR. For instance glib file utilities uses G_FILE_ERROR.

  * The quark function for the error domain is called <namespace>_<module>_error_quark, for example `g-file-error-quark()`.

  * The error codes are in an enumeration called <Namespace><Module>Error, for example `GFileError`.

  * Members of the error code enumeration are called <NAMESPACE>_<MODULE>_ERROR_<CODE>, for example `G_FILE_ERROR_NOENT`.

  * If there's a "generic" or "unknown" error code for unrecoverable errors it doesn't make sense to distinguish with specific codes, it should be called <NAMESPACE>_<MODULE>_ERROR_FAILED, for example `G_SPAWN_ERROR_FAILED`. In the case of error code enumerations that may be extended in future releases, you should generally not handle this error code explicitly, but should instead treat any unrecognized error code as equivalent to FAILED.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Error;
    also is Gnome::N::TopLevelClassSupport;

Example
-------

    my Gnome::Gtk3::Builder $builder .= new;

    # Try to read non existing file
    my Gnome::Glib::Error $e = $builder.add-from-file('x.glade');
    die $e.message if $e.is-valid;

Types
=====

class N-GError;
---------------

  * has uint32 $.domain; The set domain.

  * has int32 $.code; The set error code.

  * has Str $.message; The error message.

Methods
=======

new
---

Create a new Error object. A domain, which is a string must be converted to an unsigned integer with one of the Quark conversion methods. See **Gnome::Glib::Quark**.

    multi method new ( UInt :$domain!, Int :$code!, Str :$error-message! )

Create a new Error object using an other native error object.

    multi method new ( N-GError :$native-object! )

domain
------

Get the domain code from the error object. Use `to-string()` from *Gnome::Glib::Quark* to get the domain text representation of it. Returns `UInt` if object is invalid.

    method domain ( --> UInt )

code
----

Return the error code of the error. Returns `Int` if object is invalid.

    method code ( --> Int )

message
-------

Return the error message in the error object. Returns `Str` if object is invalid.

    method message ( --> Str )

[[g_] error_] new_literal
-------------------------

Creates a new `N-GError`.

    method g_error_new_literal (
      UInt $domain, Int $code, Str $message --> N-GError
    )

  * UInt $domain; error domain

  * Int $code; error code

  * Str $message; error message

[g_] error_copy
---------------

Makes a copy of the native error object.

    # create or get the error object from somewhere
    my Gnome::Glib::Error $e = ...;

    # later one can copy the error if needed and create a second object
    my Gnome::Glib::Error $e2 .= new(:native-object($e.g-error-copy));

Returns: a new `N-GError`

    method g_error_copy ( --> N-GError )

[g_] error_matches
------------------

Returns `1` if Gnome::Glib::Error> matches *$domain* and *$code*, `0` otherwise. In particular, when *error* is `Any`, `0` will be returned.

    method g_error_matches ( UInt $domain, Int $code --> Int  )

  * Uint $domain; an error domain

  * Int $code; an error code

