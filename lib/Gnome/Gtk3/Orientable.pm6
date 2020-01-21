#TL:1:Gnome::Gtk3::Orientable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Orientable

An interface for flippable widgets

=head1 Description


The B<Gnome::Gtk3::Orientable> interface is implemented by all widgets that can be oriented horizontally or vertically. Historically, such widgets have been realized as subclasses of a common base class (e.g B<Gnome::Gtk3::Box>/B<Gnome::Gtk3::HBox>/B<Gnome::Gtk3::VBox> or B<Gnome::Gtk3::Scale>/B<Gnome::Gtk3::HScale>/B<Gnome::Gtk3::VScale>). B<Gnome::Gtk3::Orientable> is more flexible in that it allows the orientation to be changed at runtime, allowing the widgets to “flip”.

B<Gnome::Gtk3::Orientable> was introduced in GTK+ 2.16.

=head2 Known implementations

Gnome::Gtk3::Orientable is implemented by Gnome::Gtk3::AppChooserWidget, Gnome::Gtk3::Box, Gnome::Gtk3::ButtonBox, Gnome::Gtk3::CellAreaBox, Gnome::Gtk3::CellRendererProgress, Gnome::Gtk3::CellView, Gnome::Gtk3::ColorChooserWidget, Gnome::Gtk3::ColorSelection, Gnome::Gtk3::FileChooserButton, Gnome::Gtk3::FileChooserWidget, Gnome::Gtk3::FlowBox, Gnome::Gtk3::FontChooserWidget, Gnome::Gtk3::FontSelection, Gnome::Gtk3::Grid, Gnome::Gtk3::InfoBar, Gnome::Gtk3::LevelBar, Gnome::Gtk3::Paned, Gnome::Gtk3::ProgressBar, Gnome::Gtk3::Range, Gnome::Gtk3::RecentChooserWidget, Gnome::Gtk3::Scale, Gnome::Gtk3::ScaleButton, Gnome::Gtk3::Scrollbar, Gnome::Gtk3::Separator, Gnome::Gtk3::ShortcutsGroup, Gnome::Gtk3::ShortcutsSection, Gnome::Gtk3::ShortcutsShortcut, Gnome::Gtk3::SpinButton, Gnome::Gtk3::StackSwitcher, Gnome::Gtk3::Statusbar, Gnome::Gtk3::ToolPalette, Gnome::Gtk3::Toolbar and Gnome::Gtk3::VolumeButton.


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Orientable;

=head2 Example

  my Gnome::Gtk3::LevelBar $level-bar .= new;
  $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkorientable.h
# https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
unit role Gnome::Gtk3::Orientable:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#TM:1:new():interfacing
# interfaces are not instantiated
submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instated object
method _orientable_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_orientable_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:gtk_orientable_set_orientation:
=begin pod
=head2 [[gtk_] orientable_] set_orientation

  method gtk_orientable_get_orientation ( GtkOrientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

sub gtk_orientable_set_orientation ( N-GObject $orientable, int32 $orientation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_orientable_get_orientation:
=begin pod
=head2 [[gtk_] orientable_] get_orientation

  method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Retrieves the orientation of the I<orientable>.

=end pod

sub gtk_orientable_get_orientation ( N-GObject $orientable )
  returns int32
  is native(&gtk-lib)
  { * }
