use v6;
#use lib '../gnome-gobject/lib';

use NativeCall;
use Test;

use Gnome::Gtk3::SpinButton;
use Gnome::Gtk3::Adjustment;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::SpinButton $sb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {

  $sb .= new( :step(1), :min(0), :max(10));
  isa-ok $sb, Gnome::Gtk3::SpinButton, '.new( :step, :min, :max)';

  my Gnome::Gtk3::Adjustment $adj .= new(
    :value(11.1), :lower(10), :upper(40), :step-increment(0.1),
    :page-increment(0.5), :page-size(10)
  );

  $sb .= new( :adjustment($adj), :climb_rate(1), :digits(3));
  isa-ok $sb, Gnome::Gtk3::SpinButton,
          '.new( :adjustment, :climb_rate, :digits)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Adjustment $adj .= new(
    :value(11.2), :lower(10), :upper(40), :step-increment(0.1),
    :page-increment(0.5), :page-size(10)
  );

  $sb.spin_button_configure( $adj, 1, 2);
  my Gnome::Gtk3::Adjustment $adj2 .= new(:native-object($sb.get_adjustment));
  is $adj.get-lower, 10e0, '.spin_button_configure()';

  $sb.set_adjustment($adj);
  $adj2 .= new(:native-object($sb.get_adjustment));
  is $adj.get-value, 11.2e0, '.set_adjustment() / .get_adjustment()';

  $sb.set-digits(3);
  is $sb.get-digits, 3, '.set-digits() / .get-digits()';

  $sb.set-increments( 1.12, 4.5);
  my Num ( $step, $page) = $sb.get-increments;
  is $step, 1.12e0, '.set-increments() / .get-increments(): step';
  is $page, 4.5e0, '.set-increments() / .get-increments(): page';

  $sb.set-range( 11, 101);
  my Num ( $min, $max) = $sb.get-range;
  is $min, 11e0, '.set-range() / .get-range(): min';
  is $max, 101e0, '.set-range() / .get-range(): max';

  $sb.set-value(11.3);
  is $sb.get-value, 11.3e0, '.set-value() / .get-value()';
  is $sb.get-value-as-int, 11, '.get-value-as-int()';

  $sb.set-update-policy(GTK_UPDATE_IF_VALID);
  is $sb.get-update-policy, GTK_UPDATE_IF_VALID,
     '.set-update-policy() / .get-update-policy()';

  $sb.set-numeric(True);
  ok ?$sb.get-numeric, '.set-numeric() / .get-numeric()';

  $sb.spin_button_spin( GTK_SPIN_STEP_BACKWARD, 0.01);
  is-approx $sb.get-value, 11.29e0, '.spin_button_spin()';

  $sb.set-wrap(True);
  ok ?$sb.get-wrap, '.set-wrap() / .get-wrap()';

  $sb.set-snap-to-ticks(True);
  ok ?$sb.get-snap-to-ticks, '.set-snap-to-ticks() / .get-snap-to-ticks()';

  $sb.spin_button_update;
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::SpinButton', {
  class MyClass is Gnome::Gtk3::SpinButton {
    method new ( |c ) {
      self.bless( :GtkSpinButton, :step(1), :min(0.5), :max(10), |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::SpinButton, '.new()';
  my Gnome::Gtk3::Adjustment $adj .= new(:native-object($mgc.get_adjustment));
  is $adj.get-lower, 5e-1, '.spin_button_configure()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

#`{{
  my Gnome::Gtk3::Adjustment $adj .= new(
    :value(11.1), :lower(10), :upper(40), :step-increment(0.1),
    :page-increment(0.5), :page-size(10)
  );

  my Gnome::Gtk3::SpinButton $sb2 .= new(
    :adjustment($adj), :climb_rate(1e0), :digits(3)
  );
}}

  sub test-property ( Int$type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv = $sb.get-property( $prop, $type);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  # example call
  test-property( G_TYPE_DOUBLE, 'climb-rate', 'get-double', 1e0);
  test-property( G_TYPE_UINT, 'digits', 'get-uint', 3);
  test-property( G_TYPE_BOOLEAN, 'snap-to-ticks', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'numeric', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'wrap', 'get-boolean', 1);
  test-property( G_TYPE_ENUM, 'update-policy', 'get-enum', 1);
  $sb.set-value(11.3);
  test-property( G_TYPE_DOUBLE, 'value', 'get-double', 11.3e0);
#  test-property( G_TYPE_BOOLEAN, '', '', );
#  test-property( G_TYPE_BOOLEAN, '', '', );
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  #use Gnome::Glib::Main;
  use Gnome::Gtk3::Main;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... ( 'any-args', Gnome::Gtk3::SpinButton :$widget #`{{ --> ...}} ) {

      isa-ok $widget, Gnome::Gtk3::SpinButton;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::SpinButton :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

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

  my Gnome::Gtk3::SpinButton $sb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $sb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $sb.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,       # enable 'use Gnome::Glib::Main'
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
}}

#-------------------------------------------------------------------------------
done-testing;
