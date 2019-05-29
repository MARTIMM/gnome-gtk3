use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::CheckButton

=SUBTITLE

  unit class Gnome::Gtk3::CheckButton;
  also is Gnome::Gtk3::ToggleButton;

=head2 CheckButton — Create widgets with a discrete toggle button

=head1 Synopsis

  my Gnome::Gtk3::CheckButton $bold-option .= new(:label<Bold>);

  # later ...
  if $bold-option.get-active {
    # Insert text in bold
  }
=end pod
# ==============================================================================
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::ToggleButton;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcheckbutton.h
# https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
unit class Gnome::Gtk3::CheckButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToggleButton;

# ==============================================================================
=begin pod
=head1 Methods

=head2 gtk_check_button_new

  method gtk_check_button_new ( --> N-GObject )

Creates a new native checkbutton object
=end pod
sub gtk_check_button_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_check_button_] new_with_label

  method gtk_check_button_new_with_label ( Str $label --> N-GObject )

Creates a new native checkbutton object with a label
=end pod
sub gtk_check_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_check_button_] new_with_mnemonic

  method gtk_check_button_new_with_mnemonic ( Str $label --> N-GObject )

Creates a new check button containing a label. The label will be created using gtk_label_new_with_mnemonic(), so underscores in label indicate the mnemonic for the check button.
=end pod
sub gtk_check_button_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=begin pod
=head2 new

  multi method new ( Str :$label )

Create GtkCheckButton object with a label.

  multi method new ( Bool :$empty )

Create an empty GtkCheckButton.

  multi method new ( :$widget! )

Create a check button using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create a check button using a native object from a builder. See also Gnome::GObject::Object.
=end pod
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CheckButton';

  if %options<label>.defined {
    self.native-gobject(gtk_check_button_new_with_label(%options<label>));
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_check_button_new());
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
  try { $s = &::("gtk_check_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
