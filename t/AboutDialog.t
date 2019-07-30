use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AboutDialog;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::AboutDialog $a .= new(:empty);
  isa-ok $a, Gnome::Gtk3::AboutDialog;
}

#-------------------------------------------------------------------------------
done-testing;
