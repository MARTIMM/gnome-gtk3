use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AboutDialog;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::AboutDialog $v .= new(:empty);
  isa-ok $v, Gnome::Gtk3::AboutDialog;
}

#-------------------------------------------------------------------------------
done-testing;
