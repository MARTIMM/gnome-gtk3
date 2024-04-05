use v6;
#use lib '../gnome-gobject/lib';

use NativeCall;
use Test;

#use Gnome::GObject::Type:api<1>;
use Gnome::Gtk3::MenuBar:api<1>;
use Gnome::Gtk3::Menu:api<1>;
use Gnome::Gtk3::MenuShell:api<1>;
use Gnome::Gtk3::MenuItem:api<1>;
use Gnome::Gtk3::MenuButton:api<1>;

#use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);


#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::MenuButton $mb .= new;
  isa-ok $mb, Gnome::Gtk3::MenuButton;

  my Gnome::Gtk3::Menu $m .= new;
  isa-ok $m, Gnome::Gtk3::Menu;
  isa-ok $m, Gnome::Gtk3::MenuShell;

  my Gnome::Gtk3::MenuItem $mi .= new;
  isa-ok $mi, Gnome::Gtk3::MenuItem;

  my Gnome::Gtk3::MenuBar $mba .= new;
  isa-ok $mba, Gnome::Gtk3::MenuBar;
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'menu item labels and such', {
  my Gnome::Gtk3::MenuItem $mi .= new(:label<Open>);
  isa-ok $mi, Gnome::Gtk3::MenuItem, 'MenuItem with label';
  is $mi.get-label, 'Open', 'label retrieved from menu item';

  $mi.set-label('Close');
  is $mi.get-label, 'Close', 'modified label retrieved from menu item';
}

#-------------------------------------------------------------------------------
done-testing;
