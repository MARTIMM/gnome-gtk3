use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Glib::SList;
use Gnome::Gtk3::CheckButton;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkradiobutton.h
# https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
unit class Gnome::Gtk3::RadioButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::CheckButton;

#-------------------------------------------------------------------------------
sub gtk_radio_button_new ( N-GSList $group --> N-GObject )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_from_widget ( N-GObject $group_member --> N-GObject )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_with_label ( N-GSList $group, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_with_label_from_widget (
  N-GObject $group_member, Str $label
) returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_set_group ( N-GObject $radio_button, N-GSList $group )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_get_group ( N-GObject $radio_button )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_join_group (
  N-GObject $radio_button, N-GObject $group_source
) returns N-GSList
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<group-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::RadioButton';

  if ? %options<empty> {
    self.native-gobject(gtk_radio_button_new(Any));
  }

  elsif ? %options<group> and ? %options<label> {
    self.native-gobject(
      gtk_radio_button_new_with_label( %options<group>, %options<label>)
    );
  }

  elsif ? %options<group-from> and ? %options<label> {
    my $w = %options<group-from>;
    $w = $w() if $w ~~ Gnome::GObject::Object;
    self.native-gobject(
      gtk_radio_button_new_with_label_from_widget( $w, %options<label>)
    );
  }

  elsif ? %options<group-from> {
    my $w = %options<group-from>;
    $w = $w() if $w ~~ Gnome::GObject::Object;
    self.native-gobject(gtk_radio_button_new_from_widget($w));
  }

  elsif ? %options<label> {
    self.native-gobject(gtk_radio_button_new_with_label( Any, %options<label>));
  }

  elsif ? %options<group> {
    self.native-gobject(gtk_radio_button_new(%options<group>));
  }

  elsif ? %options<widget> || %options<build-id> {
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
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_radio_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
