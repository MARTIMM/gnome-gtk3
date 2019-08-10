use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::StyleProvider;

ok True, 'No tests, only to see if module loads well';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
my Gnome::Gtk3::StyleProvider $sp .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $sp, Gnome::Gtk3::StyleProvider;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is 1, 1, 'ok';
}
}}

#-------------------------------------------------------------------------------
done-testing;
