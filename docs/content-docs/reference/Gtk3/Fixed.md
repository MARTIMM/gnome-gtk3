Gnome::Gtk3::Fixed
==================

A container which allows you to position widgets at fixed coordinates

Description
===========

The **Gnome::Gtk3::Fixed** widget is a container which can place child widgets at fixed positions and with fixed sizes, given in pixels. **Gnome::Gtk3::Fixed** performs no automatic layout management.

For most applications, you should not use this container! It keeps you from having to learn about the other GTK+ containers, but it results in broken applications. With **Gnome::Gtk3::Fixed**, the following things will result in truncated text, overlapping widgets, and other display bugs:

  * Themes, which may change widget sizes. *

  * Fonts other than the one you used to write the app will of course * change the size of widgets containing text; keep in mind that users may use a larger font because of difficulty reading the default, or they may be using a different OS that provides different fonts.

  * Translation of text into other languages changes its size. Also, * display of non-English text will use a different font in many cases.

In addition, **Gnome::Gtk3::Fixed** does not pay attention to text direction and thus may produce unwanted results if your app is run under right-to-left languages such as Hebrew or Arabic. That is: normally GTK+ will order containers appropriately for the text direction, e.g. to put labels to the right of the thing they label when using an RTL language, but it can’t do that with **Gnome::Gtk3::Fixed**. So if you need to reorder widgets depending on the text direction, you would need to manually detect it and adjust child positions accordingly.

Finally, fixed positioning makes it kind of annoying to add/remove GUI elements, since you have to reposition all the other elements. This is a long-term maintenance problem for your application.

If you know none of these things are an issue for your application, and prefer the simplicity of **Gnome::Gtk3::Fixed**, by all means use the widget. But you should be aware of the tradeoffs.

See also **Gnome::Gtk3::Layout**, which shares the ability to perform fixed positioning of child widgets and additionally adds custom drawing and scrollability.

See Also
--------

**Gnome::Gtk3::Layout**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Fixed;
    also is Gnome::Gtk3::Container;

Uml Diagram
-----------

![](plantuml/Fixed.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Fixed;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Fixed;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Fixed class process the options
      self.bless( :GtkFixed, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new Fixed object.

    multi method new ( )

### :native-object

Create a Fixed object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Fixed object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

put
---

Adds a widget to a **Gnome::Gtk3::Fixed** container at the given position.

    method put ( N-GObject $widget, Int $x, Int $y )

  * N-GObject $widget; the widget to add.

  * Int $x; the horizontal position to place the widget at.

  * Int $y; the vertical position to place the widget at.

move
----

Moves a child of a **Gnome::Gtk3::Fixed** container to the given position.

    method move ( N-GObject $widget, Int $x, Int $y )

  * N-GObject $widget; the child widget.

  * Int $x; the horizontal position to move the widget to.

  * Int $y; the vertical position to move the widget to.

