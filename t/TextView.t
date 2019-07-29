use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TextView;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextView $tv .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $tv, Gnome::Gtk3::TextView;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is 1, 1, 'ok';
}

#-------------------------------------------------------------------------------
done-testing;

