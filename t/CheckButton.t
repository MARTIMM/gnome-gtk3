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

  diag ".new";
  $cb .= new;
  isa-ok $cb, Gnome::Gtk3::CheckButton;
  isa-ok $cb, Gnome::Gtk3::ToggleButton;
  isa-ok $cb, Gnome::Gtk3::Button;

  diag ".new(:widget)";
  $cb .= new(:native_object($cb.new-with-label('some label')));
  isa-ok $cb, Gnome::Gtk3::CheckButton;
}

#-------------------------------------------------------------------------------
subtest 'Inherit Button', {
  diag ".set-label() / .get-label()";
  $cb.set-label('set bold');
  is $cb.get-label, 'set bold', 'label set';

  diag ".new(:label)";
  $cb .= new(:label<left-justify>);
  is $cb.get-label, 'left-justify', 'label set from new()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ToggleButton', {
  diag ".set-active() / .get-active()";
  is $cb.get-active, 0, 'Not active';
  $cb.set-active(1);
  is $cb.get-active, 1, 'Active';
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
