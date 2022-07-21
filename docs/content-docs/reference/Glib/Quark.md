Gnome::Glib::Quark
==================

Quark - a 2-way association between a string and a unique integer identifier

Description
===========

Quarks are associations between strings and integer identifiers or a *GQuark*. Given either the string or the *GQuark* identifier it is possible to retrieve the other.

Quarks are used for example to specify error domains, see also *Gnome::Glib::Error*.

To create a new quark from a string, use `from-string()`.

To find the string corresponding to a given *GQuark*, use `to-string()`.

To find the *GQuark* corresponding to a given string, use `try-string()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Quark;

Example
-------

    use Test;
    use Gnome::Glib::Quark;

    my Gnome::Glib::Quark $quark .= new;
    my UInt $q = $quark.try-string('my string'); # 0

    $q = $quark.from-string('my 2nd string');
    $quark.to-string($q);                        # 'my 2nd string'

new
---

### default, no options

Create a new quark object.

    multi method new ( )

from-string
-----------

Gets the *GQuark* identifying the given string. If the string does not currently have an associated *GQuark*, a new *GQuark* is created, using a copy of the string.

Returns: the *GQuark* identifying the string, or 0 if *$string* is undefined

    method from-string ( Str $string --> GQuark )

  * Str $string: a string

to-string
---------

Gets the string associated with the given GQuark.

    method to-string ( GQuark $quark --> Str  )

try-string
----------

Gets the *GQuark* associated with the given string, or 0 if string is undefined or it has no associated *GQuark*.

If you want the GQuark to be created if it doesn't already exist, use `g_quark_from_string()` or `g_quark_from_static_string()`.

Returns: the *GQuark* associated with the string, or 0 if *$string* is undefined or there is no *GQuark* associated with it.

    method try-string ( Str $string --> GQuark )

  * Str $string: a string

