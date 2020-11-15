use v6;
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
  my Gnome::Gtk3::Adjustment $adj .= new(
    :value(11.1), :lower(10), :upper(40), :step_increment(0.1),
    :page_increment(0.5), :page_size(10));
#  $adj.clamp-page( 10, 20);
#  $adj.set-value(11.2);

  $sb .= new( :adjustment($adj), :climb_rate(1), :digits(3));
  isa-ok $sb, Gnome::Gtk3::SpinButton, '.new()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::SpinButton', {
  class MyClass is Gnome::Gtk3::SpinButton {
    method new ( |c ) {
      self.bless( :GtkSpinButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::SpinButton, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::SpinButton $sb .= new;

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $sb.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  # example call
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
}

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
