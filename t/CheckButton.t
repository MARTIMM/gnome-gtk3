use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CheckButton;
use Gnome::Gtk3::ToggleButton;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CheckButton $cb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {

  $cb .= new;
  isa-ok $cb, Gnome::Gtk3::CheckButton, '.new()';

  $cb .= new(:native-object($cb.new-with-label('some label')));
  isa-ok $cb, Gnome::Gtk3::CheckButton, '.new(:native-object)';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Button', {
  $cb.set-label('set bold');
  is $cb.get-label, 'set bold', '.set-label() / .get-label()';

  $cb .= new(:label<left-justify>);
  is $cb.get-label, 'left-justify', '.new(:label)';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ToggleButton', {
  is $cb.get-active, 0, '.get-active()';
  $cb.set-active(1);
  is $cb.get-active, 1, '.set-active()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
