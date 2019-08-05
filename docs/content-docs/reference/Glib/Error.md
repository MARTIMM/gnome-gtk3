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

This class is greatly simplified because in Perl6 one can use Exception classes to throw any errors. It exists mainly to handle errors coming from other GTK+ functions.

Error domains and codes are conventionally named as follows:

- The error domain is called *NAMESPACE*_*MODULE*_ERROR. For instance glib file utilities uses G_FILE_ERROR.

- The quark function for the error domain is called <namespace>_<module>_error_quark, for example `g-file-error-quark()`.

- The error codes are in an enumeration called <Namespace><Module>Error, for example `GFileError`.

- Members of the error code enumeration are called <NAMESPACE>_<MODULE>_ERROR_<CODE>, for example `G_FILE_ERROR_NOENT`.

- If there's a "generic" or "unknown" error code for unrecoverable errors it doesn't make sense to distinguish with specific codes, it should be called <NAMESPACE>_<MODULE>_ERROR_FAILED, for example `G_SPAWN_ERROR_FAILED`. In the case of error code enumerations that may be extended in future releases, you should generally not handle this error code explicitly, but should instead treat any unrecognized error code as equivalent to FAILED.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Error;

Example
-------

    my Gnome::Gtk3::Builder $builder .= new(:empty);

    # try to read non existing file
    my Gnome::Glib::Error $e = $builder.add-from-file('x.glade');
    die $e.message if $e.error-is-valid;

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

### multi method new ( UInt :$domain!, Int :$code!, Str :$error-message! )

Create a new error object. A domain, which is a string must be converted to an unsigned integer with one of the Quark conversion methods. See `Gnome::Glib::Quark`.

### multi method new ( N-GError :gerror! )

Create a new error object using an other native error object.

error-is-valid
--------------

Returns True if native error object is valid, otherwise False.

    method error-is-valid ( --> Bool )

clear-error
-----------

Clear the error and return data to memory to pool. The error object is not valid after this call and error-is-valid() will return False.

    method clear-error ()

domain
------

Get the domain code from the error object. Use `to-string()` from `Gnome::Glib::Quark` to get the domain text representation of it. Returns 0 if object is invalid.

    method domain ( --> UInt )

code
----

Return the error code of the error. Returns 0 if object is invalid.

    method code ( --> Int )

message
-------

Return the error message in the error object. Returns '' if object is invalid.

    method message ( --> Str )

[g_error_] new_literal
----------------------

Creates a new `N-GError`.

Returns: a new `N-GError`

    method g_error_new_literal (
      UInt $domain, Int $code, Str $message --> N-GError
    )

  * N-GObject $domain; error domain

  * Int $code; error code

  * Str $message; error message

g_error_copy
------------

Makes a copy of *error*.

Returns: a new `N-GError`

    method g_error_copy ( --> N-GError )

g_error_matches
---------------

Returns `1` if *error* matches *domain* and *code*, `0` otherwise. In particular, when *error* is `Any`, `0` will be returned.

If *domain* contains a `FAILED` (or otherwise generic) error code, you should generally not check for it explicitly, but should instead treat any not-explicitly-recognized error code as being equivalent to the `FAILED` code. This way, if the domain is extended in the future to provide a more specific error code for a certain case, your code will still work.

    method g_error_matches ( UInt $domain, Int $code --> Int  )

  * Uint $domain; an error domain

  * Int $code; an error code

