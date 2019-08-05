TITLE
=====

Gnome::Glib::Quark

SUBTITLE
========

a 2-way association between a string and a unique integer identifier

Description
===========

Quarks are associations between strings and integer identifiers or a `GQuark`. Given either the string or the `GQuark` identifier it is possible to retrieve the other.

Quarks are used for example for error domains, see also `Gnome::Glib::Error`.

To create a new quark from a string, use `g_quark_from_string()` or `g_quark_from_static_string()`.

To find the string corresponding to a given `GQuark`, use `g_quark_to_string()`.

To find the `GQuark` corresponding to a given string, use `g_quark_try_string()`.

Another use for the string pool maintained for the quark functions is string interning, using `g_intern_string()` or `g_intern_static_string()`. An interned string is a canonical representation for a string. One important advantage of interned strings is that they can be compared for equality by a simple pointer comparison, rather than using `strcmp()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Quark;

Example
-------

    use Test;
    use Gnome::Glib::Quark;

    my Int $q = $quark.try-string('my string');
    is $q, 0, 'no quark for string';

    $q = $quark.from-string('my 2nd string');
    is $quark.from-string('my 2nd string'), $q, "2nd string has got quark $q";
    is $quark.to-string($q), 'my 2nd string', "2nd string found from quark";

[g_quark_] try_string
---------------------

Gets the `GQuark` associated with the given string, or 0 if string is `Any` or it has no associated `GQuark`.

If you want the GQuark to be created if it doesn't already exist, use `g_quark_from_string()` or `g_quark_from_static_string()`.

Returns: the `GQuark` associated with the string, or 0 if *string* is `Any` or there is no `GQuark` associated with it

    method g_quark_try_string ( Str $string --> Int  )

  * Str $string; (nullable): a string

[g_quark_] from_string
----------------------

Gets the `GQuark` identifying the given string. If the string does not currently have an associated `GQuark`, a new `GQuark` is created, using a copy of the string.

Returns: the `GQuark` identifying the string, or 0 if *string* is `Any`

    method g_quark_from_string ( Str $string --> Int  )

  * Str $string; (nullable): a string

[g_quark_] to_string
--------------------

Gets the string associated with the given GQuark.

    method g_quark_to_string ( Int $quark --> Str  )

Not implemented methods
=======================

### method g_quark_from_static_string ( ... )

### method g_intern_string ( ... )

### method g_intern_static_string ( ... )

### method ( ... )

