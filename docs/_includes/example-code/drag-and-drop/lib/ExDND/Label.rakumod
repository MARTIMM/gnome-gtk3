use v6;

use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
unit class ExDND::Label is Gnome::Gtk3::Label;

#-----------------------------------------------------------------------------
method new ( Str :$text = ' ', |c ) {
  self.bless( :GtkLabel, :$text, |c);
}

#-----------------------------------------------------------------------------
submethod BUILD ( Str :$text ) {
  self.set-text($text);
  self.set-justify(GTK_JUSTIFY_FILL);
  self.set-halign(GTK_ALIGN_START);
  self.set-margin-start(3);
}
