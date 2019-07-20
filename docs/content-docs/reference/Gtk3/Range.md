TITLE
=====

Gnome::Gtk3::Range

SUBTITLE
========

Range — Base class for widgets which visualize an adjustment

    unit class Gnome::Gtk3::Range;
    also is Gnome::Gtk3::Widget;

Synopsis
========

Methods
=======

new
---

    multi method new ( :$widget! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

[gtk_range_] get_fill_level
---------------------------

Gets the current position of the fill level indicator.

    method gtk_range_get_fill_level ( --> Num )

Returns the current fill level

[gtk_range_] get_restrict_to_fill_level
---------------------------------------

Gets whether the range is restricted to the fill level.

    method gtk_range_get_restrict_to_fill_level ( --> Int )

Returns 1 if range is restricted to the fill level.

[gtk_range_] get_show_fill_level
--------------------------------

    method gtk_range_get_show_fill_level ( --> Int )

Returns 1 if range shows the fill level.

[gtk_range_] set_fill_level
---------------------------

Set the new position of the fill level indicator.

The “fill level” is probably best described by its most prominent use case, which is an indicator for the amount of pre-buffering in a streaming media player. In that use case, the value of the range would indicate the current play position, and the fill level would be the position up to which the file/stream has been downloaded.

This amount of prebuffering can be displayed on the range’s trough and is themeable separately from the trough. To enable fill level display, use `gtk_range_set_show_fill_level()`. The range defaults to not showing the fill level.

Additionally, it’s possible to restrict the range’s slider position to values which are smaller than the fill level. This is controller by `gtk_range_set_restrict_to_fill_level()` and is by default enabled.

    method gtk_range_set_fill_level ( Num $fill-level )

  * $fill-level; the new position of the fill level indicator.

[gtk_range_] set_restrict_to_fill_level
---------------------------------------

Sets whether the slider is restricted to the fill level. See gtk_range_set_fill_level() for a general description of the fill level concept.

    method gtk_range_set_restrict_to_fill_level ( Int $show )

  * $show; Whether a fill level indicator graphics is shown. Values are 0 or 1.

[gtk_range_] get_inverted
-------------------------

Gets the value set by `gtk_range_set_inverted()`.

    method gtk_range_get_inverted ( --> Int )

Returns 1 if the range is inverted

[gtk_range_] set_inverted
-------------------------

Ranges normally move from lower to higher values as the slider moves from top to bottom or left to right. Inverted ranges have higher values at the top or on the right rather than on the bottom or left.

    method gtk_range_set_inverted ( Int $setting )

  * $setting; 1 to invert the range

[gtk_range_] get_value
----------------------

Gets the current value of the range.

    method gtk_range_get_value ( --> Num )

[gtk_range_] set_value
----------------------

Sets the current value of the range; if the value is outside the minimum or maximum range values, it will be clamped to fit inside them. The range emits the “value-changed” signal if the value changes.

    method gtk_range_set_value ( Num $value )

  * $value; new value of the range

[gtk_range_] set_increments
---------------------------

Sets the step and page sizes for the range. The step size is used when the user clicks the GtkScrollbar arrows or moves GtkScale via arrow keys. The page size is used for example when moving via **Page Up** or **Page Down** keys.

    method gtk_range_set_increments ( Num $step, Num $page )

  * $step; step size

  * $page; page size

[gtk_range_] set_range
----------------------

Sets the allowable values in the GtkRange, and clamps the range value to be between min and max. (If the range has a non-zero page size, it is clamped between min and max- page-size.)

    method gtk_range_set_range ( Num $min, Num $max )

  * $min; minimum range value

  * $max; maximum range value

[gtk_range_] get_round_digits
-----------------------------

    method gtk_range_get_round_digits ( --> Int )

Returns the number of digits to round to

[gtk_range_] set_round_digits
-----------------------------

Sets the number of digits to round the value to when it changes. See “change-value”.

    method gtk_range_set_round_digits ( Int $round-digits )

  * $round-digits; the precision in digits, or -1

[gtk_range_] set_lower_stepper_sensitivity
------------------------------------------

Sets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

    method gtk_range_set_lower_stepper_sensitivity (
      GtkSensitivityType $sensitivity
    )

  * $sensitivity; the lower stepper’s sensitivity policy. GtkSensitivityType is defined in GtkEnums.

[gtk_range_] get_lower_stepper_sensitivity
------------------------------------------

Gets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

    method gtk_range_get_lower_stepper_sensitivity (
      GtkSensitivityType $sensitivity
    )

Returns the lower stepper’s sensitivity policy. This is an enum value of type GtkSensitivityType and is defined in GtkEnums.

[gtk_range_] set_upper_stepper_sensitivity
------------------------------------------

Sets the sensitivity policy for the stepper that points to the 'upper' end of the GtkRange’s adjustment.

    method gtk_range_set_upper_stepper_sensitivity (
      GtkSensitivityType $sensitivity
    )

  * $sensitivity; the upper stepper’s sensitivity policy. GtkSensitivityType is defined in GtkEnums.

[gtk_range_] get_upper_stepper_sensitivity
------------------------------------------

Gets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

    method gtk_range_get_upper_stepper_sensitivity (
      GtkSensitivityType $sensitivity
    )

Returns the upper stepper’s sensitivity policy. This is an enum value of type GtkSensitivityType and is defined in GtkEnums.

[gtk_range_] get_flippable
--------------------------

Gets the value set by `gtk_range_set_flippable()`.

    method gtk_range_get_flippable ( --> Int )

Returns 1 if the range is flippable.

[gtk_range_] set_flippable
--------------------------

If a range is flippable, it will switch its direction if it is horizontal and its direction is `GTK_TEXT_DIR_RTL`.

See `gtk_widget_get_direction()`.

    method gtk_range_set_flippable ( Int $flippable )

  * $flippable; 1 to make the range flippable.

[gtk_range_] get_range_rect
---------------------------

This function returns the area that contains the range’s trough and its steppers, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

    method gtk_range_get_range_rect ( Gnome::Gdk3::Rectangle $rectangle )

  * $rectangle. Location for the range rectangleType to return. GdkRectangle is defined in GdkTypes.

[gtk_range_] get_slider_range
-----------------------------

This function returns sliders range along the long dimension, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

    method gtk_range_get_slider_range ( Int $slider_start, Int $slider_end )

  * $slider_start; return location for the slider's start, or NULL.

  * $slider_end; return location for the slider's end, or NULL.

[gtk_range_] get_slider_size_fixed
----------------------------------

This function is useful mainly for GtkRange subclasses.

    method gtk_range_get_slider_size_fixed ( --> Int )

Returns 1 if the range’s slider has a fixed size.

[gtk_range_] set_slider_size_fixed
----------------------------------

Sets whether the range’s slider has a fixed size, or a size that depends on its adjustment’s page size.

This function is useful mainly for GtkRange subclasses.

    method gtk_range_set_slider_size_fixed ( Int $size_fixed )

  * $size_fixed; 1 to make the slider size constant.

Types
=====




  * 

Signals
=======

Supported signals
-----------------

### value-changed

Emitted when the range value changes.

Not yet supported signals
-------------------------

### adjust-bounds

Emitted before clamping a value, to give the application a chance to adjust the bounds.

### change-value

The “change-value” signal is emitted when a scroll action is performed on a range. It allows an application to determine the type of scroll event that occurred and the resultant new value. The application can handle the event itself and return TRUE to prevent further processing. Or, by returning FALSE, it can pass the event to other handlers until the default GTK+ handler is reached.

The value parameter is unrounded. An application that overrides the GtkRange::change-value signal is responsible for clamping the value to the desired number of decimal digits; the default GTK+ handler clamps the value based on “round-digits”.

### move-slider

Virtual function that moves the slider. Used for keybindings.

