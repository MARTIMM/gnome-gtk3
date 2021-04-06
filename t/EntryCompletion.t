use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Entry;
use Gnome::Gtk3::EntryCompletion;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::EntryCompletion $ec;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ec .= new;
  isa-ok $ec, Gnome::Gtk3::EntryCompletion, '.new()';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $ec.set-minimum-key-length(3);
  is $ec.get-minimum-key-length, 3,
    '.set-minimum-key-length() / .get-minimum-key-length()';

  my Gnome::Gtk3::Entry $e .= new;
  $e.set-completion($ec);
  $e.set-text('abc');
  $ec.complete;
  is $ec.get-text-column, -1, '.get-text-column()';
  $ec.set-text-column(1);
  is $ec.get-text-column, 1, '.set-text-column()';
  $ec.set-inline-selection(True);
  ok $ec.get-inline-selection,
    '.set-inline-selection() / .get-inline-selection()';

  $ec.set-inline-completion(True);
  ok $ec.get-inline-completion,
    '.set-inline-completion() / .get-inline-completion()';

  is $ec.get-completion-prefix, Str,    # no completion ongoing …
    '.set-completion-prefix() / .get-completion-prefix()';

#  $ec.insert-prefix;
#  note $ec.compute-prefix('ab');
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::EntryCompletion $ec .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $ec.get-property( $prop, $gv);
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

test-property( G_TYPE_BOOLEAN, 'inline-completion', 'get-boolean', 1);
test-property( G_TYPE_BOOLEAN, 'inline-selection', 'get-boolean', 1);
test-property( G_TYPE_INT, 'minimum-key-length', 'get-int', 3);
test-property( G_TYPE_BOOLEAN, 'popup-completion', 'get-boolean', 1);
test-property( G_TYPE_BOOLEAN, 'popup-set-width', 'get-boolean', 1);
test-property( G_TYPE_BOOLEAN, 'popup-single-match', 'get-boolean', 1);
test-property( G_TYPE_INT, 'text-column', 'get-int', 1);

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::EntryCompletion', {
  class MyClass is Gnome::Gtk3::EntryCompletion {
    method new ( |c ) {
      self.bless( :GtkEntryCompletion, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::EntryCompletion, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
      Gnome::Gtk3::EntryCompletion :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::EntryCompletion;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::EntryCompletion :$widget --> Str ) {

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

  my Gnome::Gtk3::EntryCompletion $ec .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $ec.register-signal( $sh, 'method', 'signal');

  my Promise $p = $ec.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
