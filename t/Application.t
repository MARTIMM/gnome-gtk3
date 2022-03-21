use v6;
use NativeCall;
use Test;

#use Gnome::Gio::Application;
use Gnome::Gio::Enums;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Button;

use Gnome::Glib::List;
#ok 1, 'loads ok';

use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Application $a;
my Gnome::Gtk3::ApplicationWindow $aw;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $a .= new(
    :app-id('io.github.martimm.test.application'),
    :flags(G_APPLICATION_HANDLES_OPEN)
  );

  isa-ok $a, Gnome::Gtk3::Application, '.new( :app-id, :flags)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
#  $aw .= new(:application($a));
#  $a.add-window(Gnome::Gtk3::Button.new(:label<Start>));

  is $a.get-accels-for-action('test')[0], Any,
     '.get-accels-for-action()';

  is $a.get-actions-for-accel('<Control>a')[0], Any,
     '.get-actions-for-accel()';

  nok $a.get-active-window.defined, '.get-active-window()';
  nok $a.get-app-menu.defined, '.get-app-menu()';
  nok $a.get-menu-by-id('no-menu'), '.get-menu-by-id()';
  nok $a.get-menubar, '.get-menubar()';
  nok $a.get-window-by-id(1).defined, '.get-window-by-id()';

  my Gnome::Glib::List $l .= new(:native-object($a.get-windows));
  is $l.length, 0, '.get-windows()';

  # registering is necessary for next few tests
  $a.register;
  my UInt $cookie = $a.inhibit(
    N-GObject, GTK_APPLICATION_INHIBIT_LOGOUT, 'dont wanna logout'
  );
  ok $cookie > 0, '.inhibit(): cookie = ' ~ $cookie;

  #TODO inhibit gives int > 0 but is-inhibited returns False on al flags set
  #ok $a.is-inhibited(0xff), '.is-inhibited()';
  lives-ok { $a.uninhibit($cookie); }, '.uninhibit()';

  my Str $actname = 'app.start';
  $a.set-accels-for-action( $actname, [ '<Control><Shift>s',]);
  is $a.list-action-descriptions[0], $actname,
    '.set-accels-for-action() / .list-action-descriptions()';

  is $a.get-accels-for-action($actname).elems, 1, '.get-accels-for-action()';

  lives-ok {$a.prefers-app-menu}, '.prefers-app-menu()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Application', {
  class MyClass is Gnome::Gtk3::Application {
    method new ( |c ) {
      self.bless( :GtkApplication, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Application, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Application $a .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $a.get-property( $prop, $gv);
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
      Gnome::Gtk3::Application :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Application;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Application :$widget --> Str ) {

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

  my Gnome::Gtk3::Application $a .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $a.register-signal( $sh, 'method', 'signal');

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
