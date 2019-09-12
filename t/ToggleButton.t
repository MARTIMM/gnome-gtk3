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
  diag ".new(:empty)";
  $tb .= new(:empty);
  isa-ok $tb, Gnome::Gtk3::ToggleButton;

  diag ".new(:label)";
  $tb .= new(:label<Bold>);
  isa-ok $tb, Gnome::Gtk3::ToggleButton;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  diag ".set-active() / .get-active()";
  is $tb.get-active, 0, 'Not active';
  $tb.set-active(1);
  is $tb.get-active, 1, 'Active';

  diag ".set-mode() / .get-mode()";
  is $tb.get-mode, 0, 'Not a separate indicator';
  $tb.set-mode(1);
  is $tb.get-mode, 1, 'Separate indicator';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  diag ".get-label / .set-label";
  is $tb.get-label, 'Bold', 'label ok';
  $tb.set-label('Underline');
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  diag "signal 'toggled'";
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
