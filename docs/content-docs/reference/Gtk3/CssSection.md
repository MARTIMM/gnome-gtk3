Gnome::Gtk3::CssSection
=======================

Defines a part of a CSS document

Description
===========

Defines a part of a CSS document. Because sections are nested into one another, you can use `get-parent()` to get the containing region.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CssSection;
    also is Gnome::GObject::Boxed;

Example
-------

    my Gnome::Gtk3::CssProvider $css-provider .= new;
    $css-provider.load-from-path('my-style.css');

    my Gnome::Gtk3::StyleContext $context .= new;
    $context.add-provider-for-screen(
      Gnome::Gdk3::Screen.new, $css-provider, GTK_STYLE_PROVIDER_PRIORITY_USER
    );

    my Gnome::Gtk3::CssSection $section .= new(
      :native-object($context.get-section('window')
    );

Types
=====

enum GtkCssSectionType
----------------------

The different types of sections indicate parts of a CSS document as parsed by GTK’s CSS parser. They are oriented towards the [CSS Grammar](http://www.w3.org/TR/CSS21/grammar.html), but may contain extensions.

More types might be added in the future as the parser incorporates more features.

  * GTK-CSS-SECTION-DOCUMENT: The section describes a complete document. This section time is the only one where `get-parent()` might return `undefined`.

  * GTK-CSS-SECTION-IMPORT: The section defines an import rule.

  * GTK-CSS-SECTION-COLOR-DEFINITION: The section defines a color. This is a GTK extension to CSS.

  * GTK-CSS-SECTION-BINDING-SET: The section defines a binding set. This is a GTK extension to CSS.

  * GTK-CSS-SECTION-RULESET: The section defines a CSS ruleset.

  * GTK-CSS-SECTION-SELECTOR: The section defines a CSS selector.

  * GTK-CSS-SECTION-DECLARATION: The section defines the declaration of a CSS variable.

  * GTK-CSS-SECTION-VALUE: The section defines the value of a CSS declaration.

  * GTK-CSS-SECTION-KEYFRAMES: The section defines keyframes. See [CSS Animations](http://dev.w3.org/csswg/css3-animations/**keyframes**) for details.

Methods
=======

new
---

### :native-object

Create a CssSection object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-end-line
------------

Returns the line in the CSS document where this section end. The line number is 0-indexed, so the first line of the document will return 0. This value may change in future invocations of this function if *section* is not yet parsed completely. This will for example happen in the GtkCssProvider::parsing-error signal. The end position and line may be identical to the start position and line for sections which failed to parse anything successfully.

Returns: the line number

    method get-end-line ( --> UInt )

get-end-position
----------------

Returns the offset in bytes from the start of the current line returned via `get-end-line()`. This value may change in future invocations of this function if *section* is not yet parsed completely. This will for example happen in the GtkCssProvider::parsing-error signal. The end position and line may be identical to the start position and line for sections which failed to parse anything successfully.

Returns: the offset in bytes from the start of the line.

    method get-end-position ( --> UInt )

get-file
--------

Gets the file that *section* was parsed from. If no such file exists, for example because the CSS was loaded via *gtk-css-provider-load-from-data*(), then `undefined` is returned.

Returns: the native **Gnome::Gtk3::File** that *section* was parsed from or `undefined` if *section* was parsed from other data

    method get-file ( --> N-GObject )

get-parent
----------

Gets the parent section for the given *section*. The parent section is the section that contains this *section*. A special case are sections of type `GTK-CSS-SECTION-DOCUMENT`. Their parent will either be `undefined` if they are the original CSS document that was loaded by `Gnome::Gtk3::CssProvider.load-from-file()` or a section of type `GTK-CSS-SECTION-IMPORT` if it was loaded with an import rule from a different file.

Returns: the parent section or `undefined` if none

    method get-parent ( --> N-GObject )

get-section-type
----------------

Gets the type of information that *section* describes.

Returns: the type of *section*

    method get-section-type ( --> GtkCssSectionType )

get-start-line
--------------

Returns the line in the CSS document where this section starts. The line number is 0-indexed, so the first line of the document will return 0.

Returns: the line number

    method get-start-line ( --> UInt )

get-start-position
------------------

Returns the offset in bytes from the start of the current line returned via `get-start-line()`.

Returns: the offset in bytes from the start of the line.

    method get-start-position ( --> UInt )

