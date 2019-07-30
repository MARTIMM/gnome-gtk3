use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Dialog;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::Dialog $d .= new(:empty);
  isa-ok $d, Gnome::Gtk3::Dialog;
}

#-------------------------------------------------------------------------------
done-testing;
