Gnome::Pango::Item
==================

Rendering — Functions to run the rendering pipeline

Description
===========

The Pango rendering pipeline takes a string of Unicode characters and converts it into glyphs. The functions described in this section accomplish various steps of this process.

![](images/pipeline.png)

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::Item;
    also is Gnome::GObject::Boxed;

class N-PangoItem
-----------------

The **N-PangoItem** structure stores information about a segment of text.

  * Int $.offset: byte offset of the start of this item in text.

  * Int $.length: length of this item in bytes.

  * Int $.num_chars: number of Unicode characters in the item.

  * PangoAnalysis $.analysis: analysis results for the item.

Methods
=======

new
---

### default, no options

Create a new pango item.

    multi method new ( )

### :native-object

Create a Item object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

copy
----

Copy an existing `PangoItem` structure.

Return value: : the newly allocated `PangoItem`

    method copy ( --> N-PangoItem )

