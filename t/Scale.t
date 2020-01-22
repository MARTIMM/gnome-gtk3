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
subtest 'Manipulations', {
  $s.set-digits(2);
  is $s.get-digits, 2, '.set-digits() / .get-digits()';

  $s.set-draw-value(1);
  is $s.get-draw-value, 1, '.set-draw-value() / .get-draw-value()';

  $s.set-value-pos(GTK_POS_TOP);
  is GtkPositionType($s.get-value-pos), GTK_POS_TOP,
     '.set-value-pos() / .get-value-pos()';

  $s.set_has_origin(1);
  is $s.get_has_origin, 1, '.set_has_origin() / .get_has_origin()';
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
