use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::ToggleButton

=SUBTITLE

  unit class Gnome::Gtk3::ToggleButton;
  also is Gnome::Gtk3::Button;

=head2 ToggleButton — Create buttons which retain their state

=head1 Synopsis

  my Gnome::Gtk3::ToggleButton $start-tggl .= new(:label('Start Process'));

  # later in another class ...
  method start-stop-process-handle( :widget($start-tggl) ) {
    if $start-tggl.get-active {
      $start-tggl.set-label('Stop Process');
      # start process ...
    }

    else {
      $start-tggl.set-label('Start Process');
      # stop process ...
    }
  }

=end pod
# ==============================================================================
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktogglebutton.h
# https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
unit class Gnome::Gtk3::ToggleButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::Button;

# ==============================================================================
=begin pod
=head1 Methods

=head2 gtk_toggle_button_new

  method gtk_toggle_button_new ( --> N-GObject )

Creates a new native toggle button object
=end pod
sub gtk_toggle_button_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_toggle_button_] new_with_label

  method gtk_toggle_button_new_with_label ( Str $label --> N-GObject )

Creates a new native toggle button object with a label
=end pod
sub gtk_toggle_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_toggle_button_] new_with_mnemonic

  method gtk_toggle_button_new_with_mnemonic ( Str $label --> N-GObject )

Creates a new GtkToggleButton containing a label. The label will be created using gtk_label_new_with_mnemonic(), so underscores in label indicate the mnemonic for the button.
=end pod
sub gtk_toggle_button_new_with_mnemonic ( Str $label )
  returns N-GObject # GtkWidget
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_toggle_button_] get_active

  method gtk_toggle_button_get_active ( --> Int )

Get the button state.
=end pod
sub gtk_toggle_button_get_active ( N-GObject $w )
  returns int32
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_toggle_button_] set_active

  method gtk_toggle_button_set_active ( Int $active --> N-GObject )

Set the button state.
=end pod
sub gtk_toggle_button_set_active ( N-GObject $w, int32 $active )
  returns int32
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head2 new

  multi method new ( Str :$label )

Create a GtkToggleButton with a label.

  multi method new ( Bool :$empty )

Create an empty GtkToggleButton.

  multi method new ( :$widget! )

Create a button using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create a button using a native object from a builder. See also Gnome::GObject::Object.
=end pod
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<toggled>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ToggleButton';

  if %options<label>.defined {
    self.native-gobject(gtk_toggle_button_new_with_label(%options<label>));
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_toggle_button_new());
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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_toggle_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
