use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CheckButton;
use Gnome::Gtk3::ToggleButton;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CheckButton $cb .= new(:empty);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cb, Gnome::Gtk3::CheckButton;
  isa-ok $cb, Gnome::Gtk3::ToggleButton;
}

subtest 'Manips', {
  $cb.set-label('set bold');
  is $cb.get-label, 'set bold', 'label set';

  $cb .= new(:label<left-justify>);
  is $cb.get-label, 'left-justify', 'label set from new()';
}

#-------------------------------------------------------------------------------
done-testing;
