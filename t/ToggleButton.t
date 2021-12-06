use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ToggleButton;
use Gnome::N::GlibToRakuTypes;

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
  $tb.set-active(True);
  ok $tb.get-active, '.set-active() / .get-active()';

  $tb.set-mode(True);
  ok $tb.get-mode, '.set-mode() / .get-mode()';

  $tb.set-inconsistent(True);
  ok $tb.get-inconsistent, '.set-inconsistent() / .get-inconsistent()';
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
  $tb.toggled;
  ok $triggered, 'signal is triggered';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @r = $tb.get-properties(
    'active', gboolean, 'draw-indicator', gboolean, 'inconsistent', gboolean
  );
  is-deeply @r, [ 1, 1, 1], 'active, draw-indicator, inconsistent';
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
