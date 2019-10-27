Gnome::Gtk3::Range
==================

Base class for widgets which visualize an adjustment

Description
===========

**Gnome::Gtk3::Range** is the common base class for widgets which visualize an adjustment, e.g **Gnome::Gtk3::Scale** or **Gnome::Gtk3::Scrollbar**.

Apart from signals for monitoring the parameters of the adjustment, **Gnome::Gtk3::Range** provides properties and methods for influencing the sensitivity of the “steppers”. It also provides properties and methods for setting a “fill level” on range widgets. See `gtk_range_set_fill_level()`.

Implemented Interfaces
----------------------

Gnome::Gtk3::Range implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * [Gnome::Gtk3::Orientable](Orientable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Range;
    also is Gnome::Gtk3::Widget;
    also does Gnome::Gtk3::Buildable;
    also does Gnome::Gtk3::Orientable;

Methods
=======

new
---

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( :$widget! )

[gtk_range_] set_adjustment
---------------------------

Sets the adjustment to be used as the “model” object for this range widget. The adjustment indicates the current range value, the minimum and maximum range values, the step/page increments used for keybindings and scrolling, and the page size. The page size is normally 0 for **Gnome::Gtk3::Scale** and nonzero for **Gnome::Gtk3::Scrollbar**, and indicates the size of the visible area of the widget being scrolled. The page size affects the size of the scrollbar slider.

    method gtk_range_set_adjustment ( N-GObject $adjustment )

  * N-GObject $adjustment; a **Gnome::Gtk3::Adjustment**

[gtk_range_] get_adjustment
---------------------------

Get the **Gnome::Gtk3::Adjustment** which is the “model” object for **Gnome::Gtk3::Range**. See `gtk_range_set_adjustment()` for details. The return value does not have a reference added, so should not be unreferenced.

Returns: (transfer none): a **Gnome::Gtk3::Adjustment**

    method gtk_range_get_adjustment ( --> N-GObject  )

[gtk_range_] set_inverted
-------------------------

Ranges normally move from lower to higher values as the slider moves from top to bottom or left to right. Inverted ranges have higher values at the top or on the right rather than on the bottom or left.

    method gtk_range_set_inverted ( Int $setting )

  * Int $setting; `1` to invert the range

[gtk_range_] get_inverted
-------------------------

Gets the value set by `gtk_range_set_inverted()`.

Returns: `1` if the range is inverted

    method gtk_range_get_inverted ( --> Int  )

[gtk_range_] set_flippable
--------------------------

If a range is flippable, it will switch its direction if it is horizontal and its direction is `GTK_TEXT_DIR_RTL`.

See `gtk_widget_get_direction()`.

Since: 2.18

    method gtk_range_set_flippable ( Int $flippable )

  * Int $flippable; `1` to make the range flippable

[gtk_range_] get_flippable
--------------------------

Gets the value set by `gtk_range_set_flippable()`.

Returns: `1` if the range is flippable

Since: 2.18

    method gtk_range_get_flippable ( --> Int  )

[gtk_range_] set_slider_size_fixed
----------------------------------

Sets whether the range’s slider has a fixed size, or a size that depends on its adjustment’s page size.

This function is useful mainly for **Gnome::Gtk3::Range** subclasses.

Since: 2.20

    method gtk_range_set_slider_size_fixed ( Int $size_fixed )

  * Int $size_fixed; `1` to make the slider size constant

[gtk_range_] get_slider_size_fixed
----------------------------------

This function is useful mainly for **Gnome::Gtk3::Range** subclasses.

See `gtk_range_set_slider_size_fixed()`.

Returns: whether the range’s slider has a fixed size.

Since: 2.20

    method gtk_range_get_slider_size_fixed ( --> Int  )

[gtk_range_] get_range_rect
---------------------------

This function returns the area that contains the range’s trough and its steppers, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

    method gtk_range_get_range_rect ( --> Gnome::Gdk3::Rectangle )

  * $rectangle. Location for the range rectangleType to return. N-GdkRectangle is defined in GdkTypes.

[gtk_range_] get_slider_range
-----------------------------

This function returns sliders range along the long dimension, in widget->window coordinates.

This function is useful mainly for **Gnome::Gtk3::Range** subclasses.

Since: 2.20

    method gtk_range_get_slider_range ( --> List )

Returns a `List` where

  * Int $slider_start; the slider's start, or `Any`

  * Int $slider_end; the slider's end, or `Any`

[gtk_range_] set_lower_stepper_sensitivity
------------------------------------------

Sets the sensitivity policy for the stepper that points to the 'lower' end of the **Gnome::Gtk3::Range**’s adjustment.

Since: 2.10

    method gtk_range_set_lower_stepper_sensitivity ( GtkSensitivityType $sensitivity )

  * GtkSensitivityType $sensitivity; the lower stepper’s sensitivity policy.

[gtk_range_] get_lower_stepper_sensitivity
------------------------------------------

Gets the sensitivity policy for the stepper that points to the 'lower' end of the **Gnome::Gtk3::Range**’s adjustment.

Returns: The lower stepper’s sensitivity policy.

Since: 2.10

    method gtk_range_get_lower_stepper_sensitivity ( --> GtkSensitivityType  )

[gtk_range_] set_upper_stepper_sensitivity
------------------------------------------

Sets the sensitivity policy for the stepper that points to the 'upper' end of the **Gnome::Gtk3::Range**’s adjustment.

Since: 2.10

    method gtk_range_set_upper_stepper_sensitivity ( GtkSensitivityType $sensitivity )

  * GtkSensitivityType $sensitivity; the upper stepper’s sensitivity policy.

[gtk_range_] get_upper_stepper_sensitivity
------------------------------------------

Gets the sensitivity policy for the stepper that points to the 'upper' end of the **Gnome::Gtk3::Range**’s adjustment.

Returns: The upper stepper’s sensitivity policy.

Since: 2.10

    method gtk_range_get_upper_stepper_sensitivity ( --> GtkSensitivityType  )

[gtk_range_] set_increments
---------------------------

Sets the step and page sizes for the range. The step size is used when the user clicks the **Gnome::Gtk3::Scrollbar** arrows or moves **Gnome::Gtk3::Scale** via arrow keys. The page size is used for example when moving via Page Up or Page Down keys.

    method gtk_range_set_increments ( Num $step, Num $page )

  * Num $step; step size

  * Num $page; page size

[gtk_range_] set_range
----------------------

Sets the allowable values in the **Gnome::Gtk3::Range**, and clamps the range value to be between *min* and *max*. (If the range has a non-zero page size, it is clamped between *min* and *max* - page-size.)

    method gtk_range_set_range ( Num $min, Num $max )

  * Num $min; minimum range value

  * Num $max; maximum range value

[gtk_range_] set_value
----------------------

Sets the current value of the range; if the value is outside the minimum or maximum range values, it will be clamped to fit inside them. The range emits the *value-changed* signal if the value changes.

    method gtk_range_set_value ( Num $value )

  * Num $value; new value of the range

[gtk_range_] get_value
----------------------

Gets the current value of the range.

Returns: current value of the range.

    method gtk_range_get_value ( --> Num  )

[gtk_range_] set_show_fill_level
--------------------------------

Sets whether a graphical fill level is show on the trough. See `gtk_range_set_fill_level()` for a general description of the fill level concept.

Since: 2.12

    method gtk_range_set_show_fill_level ( Int $show_fill_level )

  * Int $show_fill_level; Whether a fill level indicator graphics is shown.

[gtk_range_] get_show_fill_level
--------------------------------

Gets whether the range displays the fill level graphically.

Returns: `1` if *range* shows the fill level.

Since: 2.12

    method gtk_range_get_show_fill_level ( --> Int  )

[gtk_range_] set_restrict_to_fill_level
---------------------------------------

Sets whether the slider is restricted to the fill level. See `gtk_range_set_fill_level()` for a general description of the fill level concept.

Since: 2.12

    method gtk_range_set_restrict_to_fill_level ( Int $restrict_to_fill_level )

  * Int $restrict_to_fill_level; Whether the fill level restricts slider movement.

[gtk_range_] get_restrict_to_fill_level
---------------------------------------

Gets whether the range is restricted to the fill level.

Returns: `1` if *range* is restricted to the fill level.

Since: 2.12

    method gtk_range_get_restrict_to_fill_level ( --> Int  )

[gtk_range_] set_fill_level
---------------------------

Set the new position of the fill level indicator.

The “fill level” is probably best described by its most prominent use case, which is an indicator for the amount of pre-buffering in a streaming media player. In that use case, the value of the range would indicate the current play position, and the fill level would be the position up to which the file/stream has been downloaded.

This amount of prebuffering can be displayed on the range’s trough and is themeable separately from the trough. To enable fill level display, use `gtk_range_set_show_fill_level()`. The range defaults to not showing the fill level.

Additionally, it’s possible to restrict the range’s slider position to values which are smaller than the fill level. This is controller by `gtk_range_set_restrict_to_fill_level()` and is by default enabled.

Since: 2.12

    method gtk_range_set_fill_level ( Num $fill_level )

  * Num $fill_level; the new position of the fill level indicator

[gtk_range_] get_fill_level
---------------------------

Gets the current position of the fill level indicator.

Returns: The current fill level

Since: 2.12

    method gtk_range_get_fill_level ( --> Num  )

[gtk_range_] set_round_digits
-----------------------------

Sets the number of digits to round the value to when it changes. See *change-value*.

Since: 2.24

    method gtk_range_set_round_digits ( Int $round_digits )

  * Int $round_digits; the precision in digits, or -1

[gtk_range_] get_round_digits
-----------------------------

Gets the number of digits to round the value to when it changes. See *change-value*.

Returns: the number of digits to round to

Since: 2.24

    method gtk_range_get_round_digits ( --> Int  )

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

### value-changed

Emitted when the range value changes.

    method handler (
      Gnome::GObject::Object :widget($range),
      *%user-options
    );

  * $range; the **Gnome::Gtk3::Range** that received the signal

### adjust-bounds

Emitted before clamping a value, to give the application a chance to adjust the bounds.

    method handler (
      Unknown type G_TYPE_DOUBLE $value,
      Gnome::GObject::Object :widget($range),
      *%user-options
    );

  * $range; the **Gnome::Gtk3::Range** that received the signal

  * $value; the value before we clamp

### move-slider

Virtual function that moves the slider. Used for keybindings.

    method handler (
      Unknown type GTK_TYPE_SCROLL_TYPE $step,
      Gnome::GObject::Object :widget($range),
      *%user-options
    );

  * $range; the **Gnome::Gtk3::Range** that received the signal

  * $step; how to move the slider

### change-value

The *change-value* signal is emitted when a scroll action is performed on a range. It allows an application to determine the type of scroll event that occurred and the resultant new value. The application can handle the event itself and return `1` to prevent further processing. Or, by returning `0`, it can pass the event to other handlers until the default GTK+ handler is reached.

The value parameter is unrounded. An application that overrides the **Gnome::Gtk3::Range**::change-value signal is responsible for clamping the value to the desired number of decimal digits; the default GTK+ handler clamps the value based on *round-digits*.

It is not possible to use delayed update policies in an overridden *change-value* handler.

Returns: `1` to prevent other handlers from being invoked for the signal, `0` to propagate the signal further

Since: 2.6

    method handler (
      Unknown type GTK_TYPE_SCROLL_TYPE $scroll,
      Unknown type G_TYPE_DOUBLE $value,
      Gnome::GObject::Object :widget($range),
      *%user-options
      --> Int
    );

  * $range; the **Gnome::Gtk3::Range** that received the signal

  * $scroll; the type of scroll action that was performed

  * $value; the new value resulting from the scroll action

