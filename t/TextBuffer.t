use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TextBuffer;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextBuffer $tb .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $tb, Gnome::Gtk3::TextBuffer;
}

#-------------------------------------------------------------------------------
done-testing;
