use v6;
use NativeCall;
use Test;

use Gnome::Glib::Variant;
use Gnome::Glib::VariantType;

use Gnome::Gtk3::Actionable;
use Gnome::Gtk3::Button;
#ok 1, 'Gnome::Gtk3::Actionable loads ok';



#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
# a button is an actionable
my Gnome::Gtk3::Button $b;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $b .= new(:label<Stop>);
  does-ok $b, Gnome::Gtk3::Actionable;
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $b.set-action-name('act-1');
  is $b.get-action-name, 'act-1', '.set-action-name() / .get-action-name()';

  my Gnome::Glib::Variant $v .= new(:parse('int64 23456'));
  $b.set-action-target-value($v);
  $v.clear-object;

  $v .= new(:native-object($b.get-action-target-value));
  is $v.get-type-string, 'x',
    '.set-action-target-value() / .get-action-target-value() type ok';
  is $v.get-int64, 23456,
    '.set-action-target-value() / .get-action-target-value() value ok';

  $b.set-detailed-action-name('win.set-button(42)');
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Actionable', {
  class MyClass is Gnome::Gtk3::Actionable {
    method new ( |c ) {
      self.bless( :GtkActionable, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Actionable, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Actionable $a .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $b.get-property( $prop, $gv);
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

  test-property(
    G_TYPE_STRING, 'action-name', 'get-string', 'win.set-button', :is-local
  );

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#`{{
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
      Gnome::Gtk3::Actionable() :_native-object($_widget), gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Actionable;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Actionable :$widget --> Str ) {

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

  my Gnome::Gtk3::Actionable $a .= new;

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
}}

#-------------------------------------------------------------------------------
done-testing;
