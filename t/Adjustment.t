use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;

use Gnome::Gtk3::Adjustment;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::Adjustment {
  submethod new ( |c ) {
    self.bless( :GtkAdjustment, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Adjustment, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::Adjustment $a;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $a .= new(
    :value(1e1), :lower(0e0), :upper(1e2),
    :step-increment(1e0), :page-increment(1e1), :page-size(2e1)
  );
  isa-ok $a, Gnome::Gtk3::Adjustment, '.new( options … )';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $a.get-value, 10e0, '.get-value()';
  $a.clamp-page( 11e0, 1e2);
  is $a.get-value, 11e0, '.clamp-page()';

  $a.set-value(5e0);
  is $a.get-value, 5e0, '.set-value()';
  $a.set-value(-1e0);
  is $a.get-value, 0e0, '.set-value() clamped to lower';

  is $a.get-lower, 0e0, '.get-lower()';
  $a.set-lower(2e0);
  is $a.get-lower, 2e0, '.set-lower()';

  $a.set-upper(1.1e2);
  is $a.get-upper, 1.1e2, '.get-upper() / .set-upper()';

  $a.set-step-increment(2.1);
  is $a.get-step-increment, 21e-1,
     '.set-step-increment() / .get-step-increment()';

  $a.set-page-increment(25.31);
  is $a.get-page-increment, 2531e-2,
     '.set-page-increment() / .get-page-increment()';

  $a.set-page-size(21e-1);
  is $a.get-page-size, 21e-1, '.set-page-size() / .get-page-size()';

  $a.configure( 11.2, 10, 50, 0.5, 2, 10);
  is $a.get-page-size, 1e1, '.configure(): page-size';
  is $a.get-value, 112e-1, '.configure(): value';

  is $a.get-minimum-increment, 5e-1, '.get-minimum-increment()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
#    my Gnome::GObject::Value $gv .= new(:init($type));
    my Gnome::GObject::Value $gv = $a.get-property( $prop, $type);
#    $a.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  $a.set-value(111e-1);
  test-property( G_TYPE_DOUBLE, 'value', 'get-double', 111e-1);
  test-property( G_TYPE_DOUBLE, 'lower', 'get-double', 1e1);
  test-property( G_TYPE_DOUBLE, 'upper', 'get-double', 5e1);
  test-property( G_TYPE_DOUBLE, 'step-increment', 'get-double', 5e-1);
  test-property( G_TYPE_DOUBLE, 'page-increment', 'get-double', 2e0);
  test-property( G_TYPE_DOUBLE, 'page-size', 'get-double', 1e1);
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method a-ch (
      Gnome::Gtk3::Adjustment :$_widget, gulong :$_handler-id
    ) {
      isa-ok $_widget, Gnome::Gtk3::Adjustment;
      $!signal-processed = True;
    }

    method a-vch (
      Gnome::Gtk3::Adjustment :$_widget, gulong :$_handler-id
    ) {
      isa-ok $_widget, Gnome::Gtk3::Adjustment;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Adjustment :$_widget --> Str ) {

      $_widget.set-step-increment(2.1);
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      is $!signal-processed, True, '\'changed\' signal processed';

      $!signal-processed = False;
      $_widget.set-value(2.1);
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      is $!signal-processed, True, '\'value-changed\' signal processed';

      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #while $main.gtk-events-pending() { $main.iteration-do(False); }
      #is $!signal-processed, True, '\'...\' signal processed';

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::Adjustment $a .= new(
    :value(10), :lower(0), :upper(100),
    :step-increment(1), :page-increment(10), :page-size(20)
  );

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $a.register-signal( $sh, 'a-ch', 'changed');
  $a.register-signal( $sh, 'a-vch', 'value-changed');

  my Promise $p = $a.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
