use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Button $button .= new(:label('xyz'));
  isa-ok $button, Gnome::Gtk3::Bin;

  isa-ok $button.get-child, N-GObject, '.get-child()';

  my Gnome::Gtk3::Label $l .= new(:native-object($button.get-child));
  is $l.widget-get-name, 'GtkLabel', 'child widget of button is a label';
}

#-------------------------------------------------------------------------------
done-testing;
