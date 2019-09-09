use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Button;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Button $button .= new(:label('xyz'));
  isa-ok $button, Gnome::Gtk3::Bin;

  diag "gtk_bin_get_child";
  isa-ok $button.get-child, N-GObject, 'Native object from get-child()';

  my Gnome::Gtk3::Widget $w .= new(:widget($button.get-child));
  is $w.get-name, 'GtkLabel', 'child widget of button is a label';
}

#-------------------------------------------------------------------------------
done-testing;
