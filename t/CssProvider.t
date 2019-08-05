use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CssProvider;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CssProvider $cp .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cp, Gnome::Gtk3::CssProvider;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  ;
}

#-------------------------------------------------------------------------------
done-testing;
