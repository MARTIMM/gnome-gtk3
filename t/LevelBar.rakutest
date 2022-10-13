use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::LevelBar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::LevelBar $lb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $lb .= new;
  isa-ok $lb, Gnome::Gtk3::LevelBar, ".new";
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $lb .= new( :min(2.3e0), :max(3.8e0));
  is $lb.get-min-value, 2.3e0, '.new( :min, :max) / .get-min-value()';
  is $lb.get-max-value, 3.8e0, '.new( :min, :max) / .get-max-value()';
  $lb.set-min-value(1.1e3);
  $lb.set-max-value(1.3e3);
  is $lb.get-min-value, 1.1e3, '.set-min-value() / .get-min-value()';
  is $lb.get-max-value, 1.3e3, '.set-max-value() / .get-max-value()';

  $lb.add-offset-value( GTK_LEVEL_BAR_OFFSET_LOW, 1.12e3);

  my ( $ret, $value ) = $lb.get-offset-value(GTK_LEVEL_BAR_OFFSET_LOW);
  is $ret, 1, '.add-offset-value() / .get-offset-value() return state';
  is $value, 1.12e3,'.add-offset-value() / .get-offset-value() return val';

  ( $ret, $value ) = $lb.get-offset-value('unknown');
  is $ret, 0, 'offset; "unknown" -> state is 0';
  is $value, 0,'offset; "unknown" -> value 0';
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  class X {
    has Bool $.signal-processed = False;

    method x ( Str $name, :native-object($levelbar) ) {
      is $name, GTK_LEVEL_BAR_OFFSET_LOW, 'offset name ok';
      $!signal-processed = True;
    }
  }

  my X $x .= new;
  $lb.register-signal( $x, 'x', 'offset-changed');
  $lb.add-offset-value( GTK_LEVEL_BAR_OFFSET_LOW, 1.125e3);
  ok $x.signal-processed, 'signal processed';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  $lb.set-orientation(GTK_ORIENTATION_VERTICAL);
  is GtkOrientation($lb.get-orientation), GTK_ORIENTATION_VERTICAL,
     '.set-orientation() / .get-orientation()';
}

#`{{

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
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
