use v6;
#use NativeCall;
use Test;

use Gnome::Gtk3::TextIter;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextIter $ti .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $ti, Gnome::Gtk3::TextIter;
}

#-------------------------------------------------------------------------------
done-testing;
