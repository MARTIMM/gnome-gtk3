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
