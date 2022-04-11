use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AccelMap;
use Gnome::Gtk3::AccelGroup;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;

use Gnome::Gdk3::Types;
use Gnome::Gdk3::Keysyms;

use Gnome::GObject::Closure;

use Gnome::Glib::Quark;

use Gnome::N::N-GObject;
use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AccelGroup $ag;
my Gnome::Glib::Quark $quark .= new;
my Gnome::Gtk3::AccelMap $am .= instance;

#-------------------------------------------------------------------------------
class CTest {
  has Bool $!accel-processed;
  has Bool $!signal-processed;
  has Gnome::Gtk3::Main $!main .= new;

  method ctrl-a-pressed ( Str :$arg1 ) {
    diag "Ctrl-A pressed, user argument = '$arg1'";
    $!accel-processed = True;
  }

  method alt-s-pressed ( Str :$arg1 ) {
    diag "Alt-S pressed, user argument = '$arg1'";
    $!accel-processed = True;
  }

  method signal-test (
    N-GObject $acceleratable, UInt $keyval, UInt $modifier,
    Gnome::Gtk3::AccelGroup :_widget($accel_group)
    --> Int
  ) {
    diag "accel group activate signal";
    $!signal-processed = True;

    # return 0 to get the accel handlers running. returns from activate() and
    # groups-activate will then be False.
    0
  }

  method accel-test1 (
    Gnome::Gtk3::AccelGroup :widget($ag),
    Gnome::Gtk3::Window :$window,
    --> Str
  ) {
    $!accel-processed = False;
    $!signal-processed = False;
    my Str $accel-name = $ag.accelerator-name( GDK_KEY_A, GDK_CONTROL_MASK);
    my UInt $accel-quark = $quark.from-string($accel-name);
    diag [~] 'activate 1: ', $accel-quark, ', ', $ag.activate(
      $accel-quark, $window, GDK_KEY_a, GDK_CONTROL_MASK
    );
    ok $!accel-processed, '.accelerator-name() / .activate()';
    ok $!signal-processed, 'signal accel-activate';


    while $!main.gtk-events-pending() { $!main.iteration-do(False); }

    $!accel-processed = False;
    $accel-name = $ag.accelerator-name( GDK_KEY_S, GDK_MOD1_MASK);
    $accel-quark = $quark.from-string($accel-name);
    diag [~] 'activate 2: ', $accel-quark, ', ', $ag.activate(
      $accel-quark, $window, GDK_KEY_a, GDK_CONTROL_MASK
    );
    ok $!accel-processed, '.accelerator-name() / .activate()';


    while $!main.gtk-events-pending() { $!main.iteration-do(False); }

    $!accel-processed = False;
    diag [~] 'groups activate 1: ', $ag.groups-activate(
      $window, GDK_KEY_a, GDK_CONTROL_MASK
    );
    ok $!accel-processed, '.groups-activate()';


    while $!main.gtk-events-pending() { $!main.iteration-do(False); }

    $!accel-processed = False;
    diag [~] 'groups activate 2: ', $ag.groups-activate(
      $window, GDK_KEY_S, GDK_MOD1_MASK
    );
    ok $!accel-processed, '.groups-activate()';


    while $!main.events-pending() { $!main.iteration-do(False); }
    sleep(0.4);
    $!main.quit;

    "done test 1\n"
  }

  method accel-test2 (
    Gnome::Gtk3::AccelGroup :widget($ag),
    Gnome::Gtk3::Window :$window, Gnome::GObject::Closure :$c1,
    Gnome::GObject::Closure :$c2
    --> Str
  ) {
    my Gnome::Gtk3::AccelGroup() $nag = $ag.from-accel-closure($c1);
    is $nag.get-data( 'name', Str), 'acceleration-group-1',
        '.from-accel-closure-rk()';

    nok $ag.get-is-locked, '.get-is-locked()';
    $ag.lock;
    ok $ag.get-is-locked, '.lock()';
    $ag.unlock;
    nok $ag.get-is-locked, '.unlock()';

    # the sum of all modifiers used
#    my $used-mask = GDK_MOD1_MASK +| GDK_CONTROL_MASK;
#    my $ret-mask = $ag.get-modifier-mask;
#    diag [~] 'set mask is ', $ret-mask.base(2), ', returned mask is ',
#        $used-mask.base(2);
    ok (my $mask = $ag.get-modifier-mask) > 1, '.get-modifier-mask(): ' ~ $mask.base(2);

#`{{ TODO Object does not seem initialized
    my Array $r = $ag.groups-from-object-rk($window);
    note $r;
}}

    $ag.accelerator-set-default-mod-mask(
      0b11100000000000000000000001101 +| GDK_BUTTON1_MASK
    );
    $mask = $ag.accelerator-get-default-mod-mask;
    ok $mask +& GDK_BUTTON1_MASK,
      '.accelerator-set-default-mod-mask() / .accelerator-get-default-mod-mask(): ' ~ $mask.base(2);

    is $ag.accelerator-get-label( GDK_KEY_A, GDK_CONTROL_MASK), 'Ctrl+A',
      '.accelerator-get-label()';

#    while $!main.events-pending() { $!main.iteration-do(False); }
#    sleep(0.4);
    $!main.quit;

    "done test 2\n"
  }

  method accel-test3 (
    Gnome::Gtk3::AccelGroup :widget($ag),
    Gnome::Gtk3::Window :$window, Gnome::GObject::Closure :$c1,
    Gnome::GObject::Closure :$c2
    --> Str
  ) {
    my Gnome::Gtk3::AccelGroup() $nag = $ag.from-accel-closure($c1);
    is $nag.get-data( 'name', Str), 'acceleration-group-1',
        '.from-accel-closure-rk()';


    $!accel-processed = False;
    nok $ag.get-is-locked, '.get-is-locked()';
    $ag.lock;
    ok $ag.get-is-locked, '.lock()';
    $ag.unlock;
    nok $ag.get-is-locked, '.unlock()';


    $!accel-processed = False;
    ok $ag.disconnect($c1), '.disconnect()';
    diag [~] 'groups activate 1: ', $ag.groups-activate(
      $window, GDK_KEY_A, GDK_CONTROL_MASK
    );
    nok $!accel-processed, '.disconnect()';


    ok $ag.disconnect-key( GDK_KEY_S, GDK_MOD1_MASK), '.disconnect-key()';
    diag [~] 'groups activate 1: ', $ag.groups-activate(
      $window, GDK_KEY_S, GDK_MOD1_MASK
    );
    nok $!accel-processed, '.disconnect-key()';


    while $!main.events-pending() { $!main.iteration-do(False); }
    sleep(0.4);
    $!main.quit;

    "done test 3\n"
  }
}

my CTest $ctest .= new;

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ag .= new;
  isa-ok $ag, Gnome::Gtk3::AccelGroup, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $ag.register-signal( $ctest, 'signal-test', 'accel-activate');

  my UInt ( $accelerator-key, $accelerator-mods) =
    $ag.accelerator-parse('<Ctrl>a');
  is $accelerator-key, GDK_KEY_a, 'accelerator-parse()';

  $ag.set-data( 'name', 'acceleration-group-1');

#Gnome::N::debug(:on);
  my Gnome::GObject::Closure $c1 .= new(
    :handler-object($ctest), :handler-name<ctrl-a-pressed>,
    :handler-opts(:arg1<foo>)
  );
#note $?LINE;

  $ag.connect( $accelerator-key, $accelerator-mods, GTK_ACCEL_VISIBLE, $c1);
#note $?LINE;

  $am.add-entry( '<window>/File/Save', GDK_KEY_S, GDK_MOD1_MASK);
  $ag.connect-by-path(
    '<window>/File/Save',
    my Gnome::GObject::Closure $c2 .= new(
      :handler-object($ctest), :handler-name<alt-s-pressed>,
      :handler-opts(:arg1<bar>)
    )
  );

  with my Gnome::Gtk3::Window $window .= new {
    .add-accel-group($ag);
#    .register-signal( $ctest, 'stop-test', 'destroy');
    .show;
  }

  my Promise $p = $ag.start-thread( $ctest, 'accel-test1', :$window);
  Gnome::Gtk3::Main.new.main;
  diag $p.result;


  $p = $ag.start-thread( $ctest, 'accel-test2', :$window, :$c1, :$c2);
  Gnome::Gtk3::Main.new.main;
  diag $p.result;


  $p = $ag.start-thread( $ctest, 'accel-test3', :$window, :$c1, :$c2);
  Gnome::Gtk3::Main.new.main;
  diag $p.result;



#  my Int $accel-quark = $quark.try-string('<Ctrl>A');
#  note 'A: ', $accel-quark, ', ', $ag.activate( $accel-quark, $window, GDK_KEY_A, GDK_CONTROL_MASK);

#  note 'GS: ', $ag.gtk-accel-groups-activate( $window, GDK_KEY_A, GDK_CONTROL_MASK);
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::AccelGroup', {
  class MyClass is Gnome::Gtk3::AccelGroup {
    method new ( |c ) {
      self.bless( :GtkAccelGroup, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::AccelGroup, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::AccelGroup $ag .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $ag.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    # dependency on local settings might result in different values
    elsif $is-local {
      if $gv-value ~~ /$value/ {
        like $gv-value, /$value/, "property $prop, value: " ~ $gv-value;
      }

      else {
        ok 1, "property $prop, value: " ~ $gv-value;
      }
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', False);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... (
      'any-args',
      Gnome::Gtk3::AccelGroup :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::AccelGroup;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::AccelGroup :$widget --> Str ) {

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

  my Gnome::Gtk3::AccelGroup $ag .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $ag.register-signal( $sh, 'method', 'signal');

  my Promise $p = $ag.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
