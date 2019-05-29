use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Range

=SUBTITLE Range — Base class for widgets which visualize an adjustment

  unit class Gnome::Gtk3::Range;
  also is Gnome::Gtk3::Widget;

=head1 Synopsis


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gdk::Types;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkrange.h
# https://developer.gnome.org/stable/GtkRange.html#gtk-range-get-fill-level
unit class Gnome::Gtk3::Range:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( :$widget! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<value-changed>,
    :double<adjust-bounds>,
    :scrollDouble<change-value>,
    :scroll<move-slider>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Range';

  if ? %options<widget> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_range_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_fill_level

Gets the current position of the fill level indicator.

  method gtk_range_get_fill_level ( --> Num )

Returns the current fill level

=end pod

sub gtk_range_get_fill_level ( N-GObject $range )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_restrict_to_fill_level

Gets whether the range is restricted to the fill level.

  method gtk_range_get_restrict_to_fill_level ( --> Int )

Returns 1 if range is restricted to the fill level.

=end pod

sub gtk_range_get_restrict_to_fill_level ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_show_fill_level

  method gtk_range_get_show_fill_level ( --> Int )

Returns 1 if range shows the fill level.

=end pod

sub gtk_range_get_show_fill_level ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_fill_level

Set the new position of the fill level indicator.

The “fill level” is probably best described by its most prominent use case, which is an indicator for the amount of pre-buffering in a streaming media player. In that use case, the value of the range would indicate the current play position, and the fill level would be the position up to which the file/stream has been downloaded.

This amount of prebuffering can be displayed on the range’s trough and is themeable separately from the trough. To enable fill level display, use C<gtk_range_set_show_fill_level()>. The range defaults to not showing the fill level.

Additionally, it’s possible to restrict the range’s slider position to values which are smaller than the fill level. This is controller by C<gtk_range_set_restrict_to_fill_level()> and is by default enabled.

  method gtk_range_set_fill_level ( Num $fill-level )

=item $fill-level; the new position of the fill level indicator.

=end pod

sub gtk_range_set_fill_level ( N-GObject $range, num64 $fill-level )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_restrict_to_fill_level

Sets whether the slider is restricted to the fill level. See gtk_range_set_fill_level() for a general description of the fill level concept.

  method gtk_range_set_restrict_to_fill_level ( Int $show )

=item $show; Whether a fill level indicator graphics is shown. Values are 0 or 1.

=end pod

sub gtk_range_set_restrict_to_fill_level ( N-GObject $range, int32 $show )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{
=begin pod
=head2 gtk_range_get_adjustment

Get the GtkAdjustment which is the “model” object for GtkRange. See C<gtk_range_set_adjustment()> for details. The return value does not have a reference added, so should not be unreferenced.

  method gtk_range_get_adjustment ( --> N-GObject )

Returns a native GtkAdjustment object.

=end pod

sub gtk_range_get_adjustment ( N-GObject $range )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_range_set_adjustment

Sets the adjustment to be used as the “model” object for this range widget. The adjustment indicates the current range value, the minimum and maximum range values, the step/page increments used for keybindings and scrolling, and the page size. The page size is normally 0 for GtkScale and nonzero for GtkScrollbar, and indicates the size of the visible area of the widget being scrolled. The page size affects the size of the scrollbar slider.
  method gtk_range_set_adjustment ( N-GObject $adjustment )

=item $adjustment; a GtkAdjustment

=end pod

sub gtk_range_set_adjustment ( N-GObject $range, N-GObject $adjustment )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_inverted

Gets the value set by C<gtk_range_set_inverted()>.

  method gtk_range_get_inverted ( --> Int )

Returns 1 if the range is inverted

=end pod

sub gtk_range_get_inverted ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_inverted

Ranges normally move from lower to higher values as the slider moves from top to bottom or left to right. Inverted ranges have higher values at the top or on the right rather than on the bottom or left.

  method gtk_range_set_inverted ( Int $setting )

=item $setting; 1 to invert the range

=end pod

sub gtk_range_set_inverted ( N-GObject $range, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_value

Gets the current value of the range.

  method gtk_range_get_value ( --> Num )

=end pod

sub gtk_range_get_value ( N-GObject $range )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_value

Sets the current value of the range; if the value is outside the minimum or maximum range values, it will be clamped to fit inside them. The range emits the “value-changed” signal if the value changes.

  method gtk_range_set_value ( Num $value )

=item $value; new value of the range

=end pod

sub gtk_range_set_value ( N-GObject $range, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_increments

Sets the step and page sizes for the range. The step size is used when the user clicks the GtkScrollbar arrows or moves GtkScale via arrow keys. The page size is used for example when moving via B<Page Up> or B<Page Down> keys.

  method gtk_range_set_increments ( Num $step, Num $page )

=item $step; step size
=item $page; page size

=end pod

sub gtk_range_set_increments ( N-GObject $range, num64 $step, num64 $page )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_range

Sets the allowable values in the GtkRange, and clamps the range value to be between min and max. (If the range has a non-zero page size, it is clamped between min and max- page-size.)

  method gtk_range_set_range ( Num $min, Num $max )

=item $min; minimum range value
=item $max; maximum range value

=end pod

sub gtk_range_set_range ( N-GObject $range, num64 $min, num64 $max )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_round_digits

  method gtk_range_get_round_digits ( --> Int )

Returns the number of digits to round to

=end pod

sub gtk_range_get_round_digits ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_round_digits

Sets the number of digits to round the value to when it changes. See “change-value”.

  method gtk_range_set_round_digits ( Int $round-digits )

=item $round-digits; the precision in digits, or -1

=end pod

sub gtk_range_set_round_digits ( N-GObject $range, int32 $round-digits )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_lower_stepper_sensitivity

Sets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

  method gtk_range_set_lower_stepper_sensitivity (
    GtkSensitivityType $sensitivity
  )

=item $sensitivity; the lower stepper’s sensitivity policy. GtkSensitivityType is defined in GtkEnums.

=end pod

sub gtk_range_set_lower_stepper_sensitivity (
  N-GObject $range, int32 $sensitivity
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_lower_stepper_sensitivity

Gets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

  method gtk_range_get_lower_stepper_sensitivity (
    GtkSensitivityType $sensitivity
  )

Returns the lower stepper’s sensitivity policy. This is an enum value of type GtkSensitivityType and is defined in GtkEnums.

=end pod

sub gtk_range_get_lower_stepper_sensitivity ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_upper_stepper_sensitivity

Sets the sensitivity policy for the stepper that points to the 'upper' end of the GtkRange’s adjustment.

  method gtk_range_set_upper_stepper_sensitivity (
    GtkSensitivityType $sensitivity
  )

=item $sensitivity; the upper stepper’s sensitivity policy. GtkSensitivityType is defined in GtkEnums.

=end pod

sub gtk_range_set_upper_stepper_sensitivity (
  N-GObject $range, int32 $sensitivity
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_upper_stepper_sensitivity

Gets the sensitivity policy for the stepper that points to the 'lower' end of the GtkRange’s adjustment.

  method gtk_range_get_upper_stepper_sensitivity (
    GtkSensitivityType $sensitivity
  )

Returns the upper stepper’s sensitivity policy. This is an enum value of type GtkSensitivityType and is defined in GtkEnums.

=end pod

sub gtk_range_get_upper_stepper_sensitivity ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_flippable

Gets the value set by C<gtk_range_set_flippable()>.

  method gtk_range_get_flippable ( --> Int )

Returns 1 if the range is flippable.

=end pod

sub gtk_range_get_flippable ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_flippable

If a range is flippable, it will switch its direction if it is horizontal and its direction is C<GTK_TEXT_DIR_RTL>.

See C<gtk_widget_get_direction()>.

  method gtk_range_set_flippable ( Int $flippable )

=item $flippable; 1 to make the range flippable.

=end pod

sub gtk_range_set_flippable ( N-GObject $range, int32 $flippable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_range_rect

This function returns the area that contains the range’s trough and its steppers, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

  method gtk_range_get_range_rect ( Gnome::Gdk::Rectangle $rectangle )

=item $rectangle. Location for the range rectangleType to return. GdkRectangle is defined in GdkTypes.

=end pod

sub gtk_range_get_range_rect (
  N-GObject $range, Pointer $rectangle
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_slider_range

This function returns sliders range along the long dimension, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

  method gtk_range_get_slider_range ( Int $slider_start, Int $slider_end )

=item $slider_start; return location for the slider's start, or NULL.
=item $slider_end; return location for the slider's end, or NULL.

=end pod

sub gtk_range_get_slider_range (
  N-GObject $range, int32 $slider_start, int32 $slider_end
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] get_slider_size_fixed

This function is useful mainly for GtkRange subclasses.

  method gtk_range_get_slider_size_fixed ( --> Int )

Returns 1 if the range’s slider has a fixed size.

=end pod

sub gtk_range_get_slider_size_fixed ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_range_] set_slider_size_fixed

Sets whether the range’s slider has a fixed size, or a size that depends on its adjustment’s page size.

This function is useful mainly for GtkRange subclasses.

  method gtk_range_set_slider_size_fixed ( Int $size_fixed )

=item $size_fixed; 1 to make the slider size constant.

=end pod

sub gtk_range_set_slider_size_fixed ( N-GObject $range )
  is native(&gtk-lib)
  { * }

#`{{

#-------------------------------------------------------------------------------
=begin pod
=head2

  method  (  -->  )

=item

Returns

=end pod

sub  ( N-GObject $range )
  returns
  is native(&gtk-lib)
  { * }
}}

#`{{
sub  ( N-GObject  )
  returns
  is native(&gdk-lib)
  { * }

sub  ( N-GObject  )
  returns
  is native(&g-lib)
  { * }



  is symbol('')
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Supported signals
=head3 value-changed

Emitted when the range value changes.


=head2 Not yet supported signals
=head3 adjust-bounds

Emitted before clamping a value, to give the application a chance to adjust the bounds.

=head3 change-value

The “change-value” signal is emitted when a scroll action is performed on a range. It allows an application to determine the type of scroll event that occurred and the resultant new value. The application can handle the event itself and return TRUE to prevent further processing. Or, by returning FALSE, it can pass the event to other handlers until the default GTK+ handler is reached.

The value parameter is unrounded. An application that overrides the GtkRange::change-value signal is responsible for clamping the value to the desired number of decimal digits; the default GTK+ handler clamps the value based on “round-digits”.

=head3 move-slider

Virtual function that moves the slider. Used for keybindings.

=end pod
