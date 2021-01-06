use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Scale;
use Gnome::Gtk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Scale $s;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gtk3::Scale, '.new';

  $s .= new(
    :orientation(GTK_ORIENTATION_HORIZONTAL),
    :min(1e0), :max(10e0), :step(1e0)
  );
  isa-ok $s, Gnome::Gtk3::Scale, '.new( :orientation, :min, :max, :step)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  given $s {
    .set-digits(2);
    is .get-digits, 2, '.set-digits() / .get-digits()';

    .set-draw-value(True);
    ok .get-draw-value, '.set-draw-value() / .get-draw-value()';

    .set-value-pos(GTK_POS_TOP);
    is GtkPositionType(.get-value-pos), GTK_POS_TOP,
       '.set-value-pos() / .get-value-pos()';

    .set-has-origin(True);
    ok .get-has-origin, '.set-has-origin() / .get-has-origin()';

    .add-mark( 2.2, GTK_POS_TOP, '11e-1');
    .clear-marks;
  }
}

#`{{
#does not seem to trigger...
#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  class X {
    has $.signal-processed = False;

    method format-value-callback (
      num64 $value, Gnome::Gtk3::Scale :native-object($scale)
      --> Str
    ) {
      $!signal-processed = True;
      $value.fmt('-->%.2f<--')
    }
  }

  my Gnome::Gtk3::Window $w .= new;
  $w.gtk-container-add($s);
  $w.show-all;

  my X $x .= new;
  $s.register-signal( $x, 'format-value-callback', 'format-value');
  $s.set-value(1.2e0);
  $s.set-value(1.3e0);
  ok $x.signal-processed, 'signal \'format-value-callback\' processed';
}
}}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
