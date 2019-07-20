TITLE
=====

Gnome::Gtk3::LevelBar

SUBTITLE
========

LevelBar — A bar that can used as a level indicator

    unit class Gnome::Gtk3::LevelBar;
    also is Gnome::Gtk3::Widget;

Synopsis
========

    my Gnome::Gtk3::LevelBar $level-bar .= new(:empty);
    my Gnome::Gtk3::Orientable $o .= new(:widget($level-bar));
    $o.set-orientation(GTK_ORIENTATION_VERTICAL);

Methods
=======

new
---

    multi method new ( Bool :$empty! )

Create a GtkLevelBar object.

    multi method new ( Num :$min!, Num :$min! )

Create a new GtkLevelBar with a specified range.

    multi method new ( :$widget! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

[gtk_level_bar_] set_mode
-------------------------

    method gtk_level_bar_set_mode ( GtkLevelBarMode $mode )

  * $mode; the way that increments are made visible. This is a GtkLevelBarMode enum type defined in GtkEnums.

[gtk_level_bar_] get_mode
-------------------------

    method gtk_level_bar_get_mode ( --> GtkLevelBarMode )

Returns current mode. This is a GtkLevelBarMode enum type defined in GtkEnums.

[gtk_level_bar_] set_value
--------------------------

    method gtk_level_bar_set_value ( Num $value )

  * $value; set the level bar value.

[gtk_level_bar_] get_value
--------------------------

    method gtk_level_bar_get_value ( --> Num )

Returns current value.

[gtk_level_bar_] set_min_value
------------------------------

    method gtk_level_bar_set_min_value ( Num $value )

  * $value; set the minimum value of the bar.

[gtk_level_bar_] get_min_value
------------------------------

    method gtk_level_bar_get_min_value ( --> Num )

Returns the minimum value of the bar.

[gtk_level_bar_] set_max_value
------------------------------

    method gtk_level_bar_set_max_value ( Num $value )

  * $value; set the maximum value of the bar.

[gtk_level_bar_] get_max_value
------------------------------

    method gtk_level_bar_get_max_value ( --> Num )

Returns the maximum value of the bar.

[gtk_level_bar_] set_inverted
-----------------------------

    method gtk_level_bar_set_inverted ( Int $invert )

  * $invert; When 1, the bar is inverted. That is, right to left or bottom to top.

[gtk_level_bar_] get_inverted
-----------------------------

    method gtk_level_bar_get_inverted ( --> Int )

Returns invert mode; When 1, the bar is inverted. That is, right to left or bottom to top.

[gtk_level_bar_] add_offset_value
---------------------------------

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value .

    method gtk_level_bar_add_offset_value ( Str $name, Num $value )

  * $name; the name of the new offset.

  * $value; the value for the new offset.

[gtk_level_bar_] get_offset_value
---------------------------------

Fetches the value specified for the offset marker name.

    method gtk_level_bar_get_offset_value ( Str $name, Num $value --> Int )

  * $name; the name of the new offset.

  * $value; the value of the offset is returned.

Returns Int where 1 means that name is found.

[gtk_level_bar_] remove_offset_value
------------------------------------

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value. This offset name can be used to change color and view of the level bar after passing this offset by setting information in a css file. For example when name is `my-offset` one can do the following.

    levelbar block.my-offset {
       background-color: magenta;
       border-style: solid;
       border-color: black;
       border-style: 1px;
    }

    method gtk_level_bar_remove_offset_value ( Str $name )

  * $name; the name of the offset.

Signals
=======

Not yet supported signals
-------------------------

### offset-changed

Emitted when an offset specified on the bar changes value as an effect to `gtk_level_bar_add_offset_value()` being called.

The signal supports detailed connections; you can connect to the detailed signal "changed::x" in order to only receive callbacks when the value of offset "x" changes.

