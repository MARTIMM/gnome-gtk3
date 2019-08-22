use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Orientable

=SUBTITLE Orientable — An interface for flippable widgets

  unit class Gnome::Gtk3::Orientable;
  also is Gnome::Glib::GInterface;

=head1 Synopsis

  my Gnome::Gtk3::LevelBar $level-bar .= new(:empty);
  my Gnome::Gtk3::Orientable $o .= new(:widget($level-bar));
  $o.set-orientation(GTK_ORIENTATION_VERTICAL);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkorientable.h
# https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
unit class Gnome::Gtk3::Orientable:auth<github:MARTIMM>;
also is Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create an orientable object.

  multi method new ( :$widget )

Create an orientable object using a native object from elsewhere. See also Gnome::GObject::Object.

=end pod

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Orientable';

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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_orientable_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_orientable_] set_orientation

  method gtk_orientable_get_orientation ( GtkOrientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

sub gtk_orientable_set_orientation ( N-GObject $orientable, int32 $orientation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_orientable_] get_orientation

  method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Set the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

sub gtk_orientable_get_orientation ( N-GObject $orientable )
  is native(&gtk-lib)
  { * }
