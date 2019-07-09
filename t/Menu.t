use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::MenuBar;
use Gnome::Gtk3::Menu;
use Gnome::Gtk3::MenuShell;
use Gnome::Gtk3::MenuItem;
use Gnome::Gtk3::MenuButton;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::MenuButton $mb .= new(:empty);
  isa-ok $mb, Gnome::Gtk3::MenuButton;

  my Gnome::Gtk3::Menu $m .= new(:empty);
  isa-ok $m, Gnome::Gtk3::Menu;
  isa-ok $m, Gnome::Gtk3::MenuShell;

  my Gnome::Gtk3::MenuItem $mi .= new(:empty);
  isa-ok $mi, Gnome::Gtk3::MenuItem;

  my Gnome::Gtk3::MenuBar $mba .= new(:empty);
  isa-ok $mba, Gnome::Gtk3::MenuBar;
}

#-------------------------------------------------------------------------------
subtest 'labels and such', {
  my Gnome::Gtk3::MenuItem $mi .= new(:label<Open>);
  isa-ok $mi, Gnome::Gtk3::MenuItem, 'MenuItem with label';
  is $mi.get-label, 'Open', 'label retrieved from menu item';

  $mi.set-label('Close');
  is $mi.get-label, 'Close', 'modified label retrieved from menu item';
}

#-------------------------------------------------------------------------------
done-testing;
