use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Container;
use Gnome::Gtk3::Button;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Button $b .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $b, Gnome::Gtk3::Container;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $b.get-border-width, 0, 'border is 0';
  $b.set-border-width(10);
  is $b.get-border-width, 10, 'border is now 10';
}

#-------------------------------------------------------------------------------
done-testing;
