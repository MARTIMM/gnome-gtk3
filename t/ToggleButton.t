use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ToggleButton;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ToggleButton $tb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tb .= new;
  isa-ok $tb, Gnome::Gtk3::ToggleButton, '.new()';

  $tb .= new(:label<Bold>);
  isa-ok $tb, Gnome::Gtk3::ToggleButton, '.new(:label)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $tb.get-active, 0, '.get-active()';
  $tb.set-active(1);
  is $tb.get-active, 1, '.set-active()';

  is $tb.get-mode, 0, '.get-mode()';
  $tb.set-mode(1);
  is $tb.get-mode, 1, '.set-mode()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  is $tb.get-label, 'Bold', '.get-label';
  $tb.set-label('Underline');
  is $tb.get-label, 'Underline', '.set-label';
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  my Bool $triggered = False;
  class X {
    method t-event ( :$widget ) {
      isa-ok $widget, Gnome::Gtk3::ToggleButton,
             'signal received on proper widget';
      is $widget.get-label, 'Underline', 'new label ok';
      $triggered = True;
    }
  }

  $tb.register-signal( X.new, 't-event', 'toggled');
  $tb.gtk-toggle-button-toggled;
  ok $triggered, 'signal is triggered';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  is 1, 1, 'ok';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
