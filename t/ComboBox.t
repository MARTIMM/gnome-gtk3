use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ComboBox;

#use Gnome::N::X;
#X::Gnome.debug(:on);


my Gnome::Gtk3::ComboBox $cb .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cb, Gnome::Gtk3::ComboBox;
}

#-------------------------------------------------------------------------------
subtest 'Manips', {
  is $cb.get-active, -1, 'Nothing selected';
  is $cb.get-has-entry, 0, 'No entries';

}

#-------------------------------------------------------------------------------
done-testing;
