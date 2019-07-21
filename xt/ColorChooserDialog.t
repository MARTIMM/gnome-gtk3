use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ColorChooserDialog;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::ColorChooserDialog $v .= new(...);
  isa-ok $v, Gnome::Gtk3::ColorChooserDialog;
}

#-------------------------------------------------------------------------------
done-testing;

