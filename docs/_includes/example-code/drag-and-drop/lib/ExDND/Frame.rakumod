use v6;

use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Label;

#-------------------------------------------------------------------------------
unit class ExDND::Frame is Gnome::Gtk3::Frame;

#-----------------------------------------------------------------------------
method new ( |c ) {
  self.bless( :GtkFrame, |c);
}

#-----------------------------------------------------------------------------
submethod BUILD ( Str :$label = '' ) {
  my Gnome::Gtk3::Label $l .= new(:text("<b>$label\</b>"));
  $l.set-use-markup(True);
  self.set-label-widget($l);
  self.set-label-align( 0.04, 0.5);
  self.set-margin-bottom(3);
  self.set-hexpand(True);
}
