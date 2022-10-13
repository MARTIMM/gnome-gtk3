use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AccelMap;
use Gnome::Gtk3::AccelGroup;

use Gnome::Gdk3::Types;
use Gnome::Gdk3::Keysyms;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AccelMap $am;

class AMTest {
  method foreach-test (
    Str $accel-path, UInt $accel-key, UInt $accel-mods,
    Bool $changed, Str :$path-changed
  ) {
    diag "'$accel-path', $accel-key, $accel-mods, $changed";

    ok $changed, "$accel-path is changed and should be saved"
      if $accel-path ~~ $path-changed;
  }
}

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  dies-ok { $am .= new; }, 'cannot use .new()';

  $am .= instance;
  isa-ok $am, Gnome::Gtk3::AccelMap, '.instance()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  lives-ok {
    $am.add-entry( '<AccelMap-test>/File/Save',     GDK_KEY_s, GDK_MOD1_MASK);
    $am.add-entry( '<AccelMap-test>/File/Load',     GDK_KEY_l, GDK_MOD1_MASK);
    $am.add-entry( '<AccelMap-test>/File/Quit',     GDK_KEY_q, GDK_MOD1_MASK);
    $am.add-entry( '<AccelMap-test>/Edit/Set ...',  GDK_KEY_s, GDK_MOD1_MASK);
    $am.add-entry(
      '<AccelMap-test>/Help/Index', GDK_KEY_i, GDK_CONTROL_MASK
    );
    $am.add-entry(
      '<AccelMap-test>/Help/About', GDK_KEY_a, GDK_CONTROL_MASK
    );
  }, '.add-entry()';

  lives-ok {
    my N-GtkAccelKey $ak;
    with $ak = $am.lookup-entry('<AccelMap-test>/File/Save') {
      is .accel-key, GDK_KEY_s, 'N-GtkAccelKey.accel-key';
      is .accel-mods, GDK_MOD1_MASK.value, 'N-GtkAccelKey.accel-mods';
    }

    with $ak = $am.lookup-entry('<AccelMap-test>/Foo/Bar') {
      is-deeply [ .accel-key, .accel-mods, .accel-flags], [ 0, 0, 0],
      '.lookup-entry(): entry not found';
    }

  }, '.lookup-entry() / N-GtkAccelKey.*()';


  lives-ok {
    $am.lock-path('<AccelMap-test>/File/Load');
    $am.unlock-path('<AccelMap-test>/File/Load');
  }, '.lock-path() / .unlock-path()';

  lives-ok {
    $am.add-filter('<AccelMap-test>/File/*');
    $am.add-filter('<AccelMap-test>/He??/*');
  }, '.add-filter()';

  ok $am.change-entry(
    '<AccelMap-test>/Edit/Set ...', GDK_KEY_s, GDK_SHIFT_MASK, False
  ), '.change-entry()';

  lives-ok {
    $am.foreach(
      AMTest.new, 'foreach-test', :path-changed('<AccelMap-test>/Edit/Set ...')
    );
  }, '.foreach()';

  lives-ok {
    $am.foreach-unfiltered(
      AMTest.new, 'foreach-test', :path-changed('<AccelMap-test>/Edit/Set ...')
    );
  }, '.foreach-unfiltered()';

  lives-ok {
    my Str $filename = 't/___key-accels.rc';
    $am.save($filename);
    $am.load($filename);
    ok $filename.IO ~~ :r, 'file is saved';
    $filename.IO.unlink;
  }, '.save() / .load()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::AccelMap', {
  class MyClass is Gnome::Gtk3::AccelMap {
    method new ( |c ) {
      self.bless( :GtkAccelMap, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::AccelMap, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::AccelMap $am .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $am.get-property( $prop, $gv);
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
      Gnome::Gtk3::AccelMap() :_native-object($_widget), gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::AccelMap;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::AccelMap :$widget --> Str ) {

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

  my Gnome::Gtk3::AccelMap $am .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $am.register-signal( $sh, 'method', 'signal');

  my Promise $p = $am.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
