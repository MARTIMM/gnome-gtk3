Gnome::Gtk3::Targets
====================

Description
===========

This module is mainly used to check out targets for its capabilities.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Targets;

Example
-------

    my Gnome::Gtk3::Targets $t .= new;
    my Array $targets = [
      Gnome::Gdk3::Atom.new(:intern<text/plain>),
      Gnome::Gdk3::Atom.new(:intern<image/bmp>),
    ];

    if $t.include-image( $targets, True) {
      … we can handle an image …
    }

Methods
=======

new
---

### default, no options

Create a new Targets object.

    multi method new ( )

include-image
-------------

Determines if any of the targets in *targets* can be used to provide a **Gnome::Gtk3::Pixbuf**.

Returns: `True` if *targets* include a suitable target for images, otherwise `False`.

    method include-image ( Array $targets, Bool $writable --> Bool )

  * Array $targets; an array of **Gnome::Gtk3::Atoms**

  * Bool $writable; whether to accept only targets for which GTK+ knows how to convert a pixbuf into the format

include-rich-text
-----------------

Determines if any of the targets in *$targets* can be used to provide rich text.

Returns: `True` if *targets* include a suitable target for rich text, otherwise `False`.

    method include-rich-text ( Array $targets, N-GObject $buffer --> Bool )

  * Array $targets; an array of **Gnome::Gtk3::Atoms**

  * N-GObject $buffer; a **Gnome::Gtk3::TextBuffer**

include-text
------------

Determines if any of the targets in *targets* can be used to provide text.

Returns: `True` if *targets* include a suitable target for text, otherwise `False`.

    method include-text ( Array $targets --> Bool )

  * Array $targets; an array of **Gnome::Gtk3::Atoms**

include-uri
-----------

Determines if any of the targets in *targets* can be used to provide an uri list.

Returns: `True` if *targets* include a suitable target for uri lists, otherwise `False`.

    method include-uri ( Array $targets --> Bool )

  * Array $targets; an array of **Gnome::Gtk3::Atoms**

