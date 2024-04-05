use v6;

use Gnome::Gtk3::Label:api<1>;
use Gnome::Gtk3::Enums:api<1>;

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
