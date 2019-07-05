use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Menu;
use Gnome::Gtk3::MenuShell;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Menu $v .= new(:empty);
  isa-ok $v, Gnome::Gtk3::Menu;
  isa-ok $v, Gnome::Gtk3::MenuShell;
}

#-------------------------------------------------------------------------------
done-testing;
