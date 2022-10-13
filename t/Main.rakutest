use v6;
use NativeCall;
use Test;
#use trace;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Main;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Main $m;
#-------------------------------------------------------------------------------
#%*ENV<GDK_DEBUG> = 'interactive';

@*ARGS.push: '--raku-option';

# test to show that only the $raku-option is needed to specify. There should
# not be any usage message.

subtest 'ISA test', {
  $m .= new;
  ok $m.is-valid, ".new()";
  $m.init-check;
  is-deeply @*ARGS, ['--raku-option'], '.init-check()';
}

#subtest 'Manipulations', {
#depending on version, which might differ, skip tests
#  ok !$m.gtk-check-version( 3, 24, 0), 'version ok';
#  is $m.gtk-check-version( 2, 0, 0), 'GTK+ version too new (major mismatch)',
#     'GTK+ version too new';

#  diag GtkTextDirection($m.get-locale-direction);
#}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  ok 1, $m.check-version( 4, 26, 0) // 'version 4.26.0';
  ok 1, $m.gtk-check-version( 3, 24, 0) // 'version 3.24.0';
  ok 1, $m.gtk-check-version( 2, 0, 0) // 'version 2.0.0';
}

#-------------------------------------------------------------------------------
done-testing;

# place after all test because;
# * commandline arguments are adjusted
# * MAIN is called before the other tests?
sub MAIN ( Bool :$raku-option ) { }

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Main', {
  class MyClass is Gnome::Gtk3::Main {
    method new ( |c ) {
      self.bless( :GtkMain, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Main, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Main $m .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $m.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
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
      Gnome::Gtk3::Main() :_native-object($_widget), gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Main;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Main :$widget --> Str ) {

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

  my Gnome::Gtk3::Main $m .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $m.register-signal( $sh, 'method', 'signal');

  my Promise $p = $m.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
