Gnome::Gtk3::LevelBar
=====================

A bar that can used as a level indicator

![](images/levelbar.png)

Description
===========

The **Gnome::Gtk3::LevelBar** is a bar widget that can be used as a level indicator. Typical use cases are displaying the strength of a password, or showing the charge level of a battery.

Use `gtk_level_bar_set_value()` to set the current value, and `gtk_level_bar_add_offset_value()` to set the value offsets at which the bar will be considered in a different state. GTK will add a few offsets by default on the level bar: **GTK_LEVEL_BAR_OFFSET_LOW**, **GTK_LEVEL_BAR_OFFSET_HIGH** and **GTK_LEVEL_BAR_OFFSET_FULL**, with values 0.25, 0.75 and 1.0 respectively.

Note that it is your responsibility to update preexisting offsets when changing the minimum or maximum value. GTK+ will simply clamp them to the new range.

Adding a custom offset on the bar
---------------------------------

    method create-level-bar ( ) {

      # The following adds a new offset to the bar; the application
      # will be able to change its color CSS like this:
      #
      # levelbar block.my-offset {
      #   background-color: magenta;
      #   border-style: solid;
      #   border-color: black;
      #   border-style: 1px;
      # }
      my Gnome::Gtk3::LevelBar $bar .= new;
      $bar.add-offset-value( "my-offset", 0.60);
    }

The default interval of values is between zero and one, but it’s possible to modify the interval using `gtk_level_bar_set_min_value()` and `gtk_level_bar_set_max_value()`. The value will be always drawn in proportion to the admissible interval, i.e. a value of 15 with a specified interval between 10 and 20 is equivalent to a value of 0.5 with an interval between 0 and 1. When **GTK_LEVEL_BAR_MODE_DISCRETE** is used, the bar level is rendered as a finite number of separated blocks instead of a single one. The number of blocks that will be rendered is equal to the number of units specified by the admissible interval.

For instance, to build a bar rendered with five blocks, it’s sufficient to set the minimum value to 0 and the maximum value to 5 after changing the indicator mode to discrete.

**Gnome::Gtk3::LevelBar** was introduced in GTK+ 3.6.

**Gnome::Gtk3::LevelBar** as **Gnome::Gtk3::Buildable**
-------------------------------------------------------

The **Gnome::Gtk3::LevelBar** implementation of the **Gnome::Gtk3::Buildable** interface supports a custom <offsets> element, which can contain any number of <offset> elements, each of which must have name and value attributes.

Css Nodes
---------

    levelbar[.discrete]
    ╰── trough
        ├── block.filled.level-name
        ┊
        ├── block.empty
        ┊

**Gnome::Gtk3::LevelBar** has a main CSS node with name levelbar and one of the style classes .discrete or .continuous and a subnode with name trough. Below the trough node are a number of nodes with name block and style class .filled or .empty. In continuous mode, there is exactly one node of each, in discrete mode, the number of filled and unfilled nodes corresponds to blocks that are drawn. The block.filled nodes also get a style class .level-name corresponding to the level for the current value.

In horizontal orientation, the nodes are always arranged from left to right, regardless of text direction.

Implemented Interfaces
----------------------

Gnome::Gtk3::LevelBar implements

  * [Gnome::Gtk3::Orientable](Orientable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::LevelBar;
    also is Gnome::Gtk3::Widget;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::Orientable;

Example
-------

    my Gnome::Gtk3::LevelBar $level-bar .= new;
    $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

Types
=====

GTK_LEVEL_BAR_OFFSET_LOW
------------------------

A predefined constant to be used with `gtk_level_bar_add_offset_value()`. The name isused for the stock low offset.

    constant GTK_LEVEL_BAR_OFFSET_LOW "low"

GTK_LEVEL_BAR_OFFSET_HIGH
-------------------------

A predefined constant to be used with `gtk_level_bar_add_offset_value()`. The name isused for the stock high offset.

    constant GTK_LEVEL_BAR_OFFSET_HIGH "high"

GTK_LEVEL_BAR_OFFSET_FULL
-------------------------

A predefined constant to be used with `gtk_level_bar_add_offset_value()`. The name isused for the stock high offset.

    constant GTK_LEVEL_BAR_OFFSET_FULL "full"

Methods
=======

new
---

    multi method new ( Bool :$empty! )

Create a GtkLevelBar object.

    multi method new ( Num :$min!, Num :$max! )

Create a new GtkLevelBar with a specified range.

    multi method new ( :$native-object! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

[gtk_] level_bar_new
--------------------

Creates a new **Gnome::Gtk3::LevelBar**.

Returns: a **Gnome::Gtk3::LevelBar**.

Since: 3.6

    method gtk_level_bar_new ( --> N-GObject  )

[[gtk_] level_bar_] new_for_interval
------------------------------------

Utility constructor that creates a new **Gnome::Gtk3::LevelBar** for the specified interval.

Returns: a **Gnome::Gtk3::LevelBar**

Since: 3.6

    method gtk_level_bar_new_for_interval ( Num $min_value, Num $max_value --> N-GObject  )

  * Num $min_value; a positive value

  * Num $max_value; a positive value

[[gtk_] level_bar_] set_mode
----------------------------

Sets the value of the *mode* property.

Since: 3.6

    method gtk_level_bar_set_mode ( GtkLevelBarMode $mode )

  * GtkLevelBarMode $mode; a **Gnome::Gtk3::LevelBarMode**

[[gtk_] level_bar_] get_mode
----------------------------

Returns the value of the *mode* property.

Returns: a **Gnome::Gtk3::LevelBarMode**

Since: 3.6

    method gtk_level_bar_get_mode ( --> GtkLevelBarMode  )

[[gtk_] level_bar_] set_value
-----------------------------

Sets the value of the *value* property.

Since: 3.6

    method gtk_level_bar_set_value ( Num $value )

  * Num $value; a value in the interval between *min-value* and *max-value*

[[gtk_] level_bar_] get_value
-----------------------------

Returns the value of the *value* property.

Returns: a value in the interval between *min-value* and *max-value*

Since: 3.6

    method gtk_level_bar_get_value ( --> Num  )

[[gtk_] level_bar_] set_min_value
---------------------------------

Sets the value of the *min-value* property.

You probably want to update preexisting level offsets after calling this function.

Since: 3.6

    method gtk_level_bar_set_min_value ( Num $value )

  * Num $value; a positive value

[[gtk_] level_bar_] get_min_value
---------------------------------

Returns the value of the *min-value* property.

Returns: a positive value

Since: 3.6

    method gtk_level_bar_get_min_value ( --> Num  )

[[gtk_] level_bar_] set_max_value
---------------------------------

Sets the value of the *max-value* property.

You probably want to update preexisting level offsets after calling this function.

Since: 3.6

    method gtk_level_bar_set_max_value ( Num $value )

  * Num $value; a positive value

[[gtk_] level_bar_] get_max_value
---------------------------------

Returns the value of the *max-value* property.

Returns: a positive value

Since: 3.6

    method gtk_level_bar_get_max_value ( --> Num  )

[[gtk_] level_bar_] set_inverted
--------------------------------

Sets the value of the *inverted* property.

Since: 3.8

    method gtk_level_bar_set_inverted ( Int $inverted )

  * Int $inverted; `1` to invert the level bar

[[gtk_] level_bar_] get_inverted
--------------------------------

Return the value of the *inverted* property.

Returns: `1` if the level bar is inverted

Since: 3.8

    method gtk_level_bar_get_inverted ( --> Int  )

[[gtk_] level_bar_] add_offset_value
------------------------------------

Adds a new offset marker on the levelbar at the position specified by *$value*. When the bar value is in the interval topped by *$value* (or between *$value* and *max-value* in case the offset is the last one on the bar) a style class named `level-`*$name* will be applied when rendering the level bar fill. If another offset marker named *$name* exists, its value will be replaced by *$value*.

Since: 3.6

    method gtk_level_bar_add_offset_value ( Str $name, Num $value )

  * Str $name; the name of the new offset

  * Num $value; the value for the new offset

[[gtk_] level_bar_] remove_offset_value
---------------------------------------

Removes an offset marker previously added with `gtk_level_bar_add_offset_value()`.

Since: 3.6

    method gtk_level_bar_remove_offset_value ( Str $name )

  * Str $name; (allow-none): the name of an offset in the bar

[[gtk_] level_bar_] get_offset_value
------------------------------------

Fetches the value specified for the offset marker *$name* in the level bar,

Since: 3.6

    method gtk_level_bar_get_offset_value ( Str $name --> List )

  * Str $name; the name of an offset in the bar or `Any`.

Returns a list of which;

  * Int status; `1` when name is found as an offset. When `0` $value is 0.

  * Num $value; location where to store the value.

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

### offset-changed

Emitted when an offset specified on the bar changes value as an effect to `gtk_level_bar_add_offset_value()` being called.

The signal supports detailed connections; you can connect to the detailed signal "changed::x" in order to only receive callbacks when the value of offset "x" changes.

Since: 3.6

    method handler (
      Str $name,
      Gnome::GObject::Object :widget($levelbar),
      *%user-options
    );

  * $levelbar; a **Gnome::Gtk3::LevelBar**

  * $name; the name of the offset that changed value

