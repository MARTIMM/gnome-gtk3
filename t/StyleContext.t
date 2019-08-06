use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::StyleContext;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::StyleContext $sc .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $sc, Gnome::Gtk3::StyleContext;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is 1, 1, 'ok';
}

#-------------------------------------------------------------------------------
done-testing;

