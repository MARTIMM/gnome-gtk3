use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Revealer;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Revealer $r;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $r .= new;
  isa-ok $r, Gnome::Gtk3::Revealer, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $r.set_transition_type(GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT);
  is GtkRevealerTransitionType($r.get_transition_type),
    GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT,
    '.get_transition_type() / .set_transition_type()';

  $r.set_transition_duration(111);
  is $r.get_transition_duration, 111,
    '.set_transition_duration() / .get_transition_duration()';

  $r.set_reveal_child(True);
  ok $r.get-reveal-child, '.set_reveal_child() / .get-reveal-child()';
  ok $r.get_child_revealed, '.get_child_revealed()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  my Gnome::Gtk3::Revealer $r .= new;

  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_UINT));
  $r.g-object-get-property( 'transition-duration', $gv);
  $gv.g-value-set-uint(510);
  is $gv.get-uint, 510, 'property transition-duration';
  $gv.clear-object;

  $gv .= new(:init(G_TYPE_BOOLEAN));
  $r.g-object-get-property( 'reveal-child', $gv);
  $gv.g-value-set-boolean(True);
  is $gv.get-boolean, 1, 'property reveal-child';
  $gv.clear-object;

  $gv .= new(:init(G_TYPE_BOOLEAN));
  $r.g-object-get-property( 'child-revealed', $gv);
  $gv.g-value-set-boolean(True);
  is $gv.get-boolean, 1, 'property child-revealed';
  $gv.clear-object;
}


#`{{

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Revealer', {
  class MyClass is Gnome::Gtk3::Revealer {
    method new ( |c ) {
      self.bless( :GtkRevealer, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Revealer, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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

    method ... ( 'any-args', Gnome::Gtk3::Revealer :$widget #`{{ --> ...}} ) {

      isa-ok $widget, Gnome::Gtk3::Revealer;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Revealer :$widget --> Str ) {

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

  my Gnome::Gtk3::Revealer $r .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $r.register-signal( $sh, 'method', 'signal');

  my Promise $p = $r.start-thread(
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
