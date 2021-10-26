use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AppChooserWidget;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AppChooserWidget $acw;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $acw .= new(:content-type<text/plain>);
  isa-ok $acw, Gnome::Gtk3::AppChooserWidget, '.new(:content-type)';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $acw.set-default-text('foo bar');
  is $acw.get-default-text, 'foo bar',
    '.set-default-text() / .get-default-text()';

  $acw.set-show-all(True);
  ok $acw.get-show-all, '.set-show-all() / .get-show-all()';

  $acw.set-show-default(True);
  ok $acw.get-show-default, '.set-show-default() / .get-show-default()';

  $acw.set-show-fallback(True);
  ok $acw.get-show-fallback, '.set-show-fallback() / .get-show-fallback()';

  $acw.set-show-other(True);
  ok $acw.get-show-other, '.set-show-other() / .get-show-other()';

  $acw.set-show-recommended(True);
  ok $acw.get-show-recommended,
    '.set-show-recommended() / .get-show-recommended()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::AppChooserWidget', {
  class MyClass is Gnome::Gtk3::AppChooserWidget {
    method new ( |c ) {
      self.bless( :GtkAppChooserWidget, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::AppChooserWidget, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @r = $acw.get-properties(
    'default-text', Str, 'show-all', Bool, 'show-default', Bool,
    'show-fallback', Bool, 'show-other', Bool, 'show-recommended', Bool
  );

  is-deeply @r, [
    'foo bar', True.Int, True.Int, True.Int, True.Int, True.Int
  ], 'default-text show-all show-default show-fallback show-other show-recommended';
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

  #my Gnome::Gtk3::AppChooserWidget $acw .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $acw.get-property( $prop, $gv);
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
      Gnome::Gtk3::AppChooserWidget :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::AppChooserWidget;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::AppChooserWidget :$widget --> Str ) {

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

  my Gnome::Gtk3::AppChooserWidget $acw .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $acw.register-signal( $sh, 'method', 'signal');

  my Promise $p = $acw.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
