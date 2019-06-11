use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Enums

=SUBTITLE Standard Enumerations — Public enumerated types used throughout GTK+

  unit class Gnome::Gtk3::Enums;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktypes.h
unit class Gnome::Gtk3::Enums:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Enumerations
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 GtkAlign

Controls how a widget deals with extra space in a single (x or y) dimension.

Alignment only matters if the widget receives a “too large” allocation, for example if you packed the widget with the #GtkWidget:expand flag inside a #GtkBox, then the widget might get extra space. If you have for example a 16x16 icon inside a 32x32 space, the icon could be scaled and stretched, it could be centered, or it could be positioned to one side of the space.

Note that in horizontal context @GTK_ALIGN_START and @GTK_ALIGN_END are interpreted relative to text direction.

GTK_ALIGN_BASELINE support for it is optional for containers and widgets, and it is only supported for vertical alignment.  When its not supported by a child or a container it is treated as @GTK_ALIGN_FILL.

=item GTK_ALIGN_FILL: stretch to fill all space if possible, center if no meaningful way to stretch
=item GTK_ALIGN_START: snap to left or top side, leaving space on right or bottom
=item GTK_ALIGN_END: snap to right or bottom side, leaving space on left or top
=item GTK_ALIGN_BASELINE: align the widget according to the baseline. Since 3.10.
=end pod

enum GtkAlign is export <
  GTK_ALIGN_FILL GTK_ALIGN_START GTK_ALIGN_END GTK_ALIGN_CENTER
  GTK_ALIGN_BASELINE
>;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2
=item
=item
=item
=item
=end pod
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkLevelBarMode

Describes how GtkLevelBar contents should be rendered. Note that this enumeration could be extended with additional modes in the future.

=item GTK_LEVEL_BAR_MODE_CONTINUOUS; the bar has a continuous mode.
=item GTK_LEVEL_BAR_MODE_DISCRETE; the bar has a discrete mode.

=end pod

enum GtkLevelBarMode is export <
  GTK_LEVEL_BAR_MODE_CONTINUOUS GTK_LEVEL_BAR_MODE_DISCRETE
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkBaselinePosition

Whenever a container has some form of natural row it may align
*hildren in that row along a common typographical baseline. If
the amount of verical space in the row is taller than the total
requested height of the baseline-aligned children then it can use a
C<GtkBaselinePosition> to select where to put the baseline inside the
extra availible space.

=item GTK_BASELINE_POSITION_TOP; Align the baseline at the top
=item GTK_BASELINE_POSITION_CENTER; Center the baseline
=item GTK_BASELINE_POSITION_BOTTOM; Align the baseline at the bottom

=end pod

enum GtkBaselinePosition is export <
  GTK_BASELINE_POSITION_TOP GTK_BASELINE_POSITION_CENTER
  GTK_BASELINE_POSITION_BOTTOM
>;


#-------------------------------------------------------------------------------
=begin pod
=head2 GtkPackType

 Represents the packing location C<Gnome::Gtk3::Box> children. (See: C<Gnome::Gtk3::VBox>, C<Gnome::Gtk3::HBox> and C<Gnome::Gtk3::ButtonBox>.

=item GTK_PACK_START; The child is packed into the start of the box
=item GTK_PACK_END; The child is packed into the end of the box

=end pod

enum GtkPackType is export <
  GTK_PACK_START GTK_PACK_END
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkOrientation

The orientation of the orientable.

=item GTK_ORIENTATION_HORIZONTAL; horizontal orientation.
=item GTK_ORIENTATION_VERTICAL; vertical orientation.

=end pod

enum GtkOrientation is export <
  GTK_ORIENTATION_HORIZONTAL GTK_ORIENTATION_VERTICAL
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkPositionType

Describes which edge of a widget a certain feature is positioned at, e.g. the tabs of a GtkNotebook, the handle of a GtkHandleBox or the label of a GtkScale.

=item GTK_POS_LEFT: The feature is at the left edge.
=item GTK_POS_RIGHT: The feature is at the right edge.
=item GTK_POS_TOP: The feature is at the top edge.
=item GTK_POS_BOTTOM: The feature is at the bottom edge.
=end pod

enum GtkPositionType is export <
  GTK_POS_LEFT GTK_POS_RIGHT GTK_POS_TOP GTK_POS_BOTTOM
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkTextDirection

Reading directions for text.

=item GTK_TEXT_DIR_NONE; No direction.
=item GTK_TEXT_DIR_LTR; Left to right text direction.
=item GTK_TEXT_DIR_RTL; Right to left text direction.

=end pod

enum GtkTextDirection is export <
  GTK_TEXT_DIR_NONE GTK_TEXT_DIR_LTR GTK_TEXT_DIR_RTL
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkSensitivityType

Determines how GTK+ handles the sensitivity of stepper arrows at the end of range widgets.

=item GTK_SENSITIVITY_AUTO: The arrow is made insensitive if the thumb is at the end
=item GTK_SENSITIVITY_ON: The arrow is always sensitive
=item GTK_SENSITIVITY_OFF: The arrow is always insensitive

=end pod

enum GtkSensitivityType is export <
  GTK_SENSITIVITY_AUTO GTK_SENSITIVITY_ON GTK_SENSITIVITY_OFF
>;
