use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TextTag;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextTag $tt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
   $tt .= new(:empty);
  isa-ok $tt, Gnome::Gtk3::TextTag;

  $tt .= new(:tag-name<my-very-own-tag-name>);
  isa-ok $tt, Gnome::Gtk3::TextTag;
}

#-------------------------------------------------------------------------------
#subtest 'Manipulations', {
#  is 1, 1, 'ok';
#}

#-------------------------------------------------------------------------------
done-testing;
