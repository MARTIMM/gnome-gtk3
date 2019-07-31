use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ColorChooserWidget;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::ColorChooserWidget $v .= new(:empty);
  isa-ok $v, Gnome::Gtk3::ColorChooserWidget;
}

#-------------------------------------------------------------------------------
done-testing;
