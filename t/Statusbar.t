use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Statusbar;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Statusbar $sb1;
my Gnome::Gtk3::Statusbar $sb2;
#my Gnome::Gtk3::Label $l;
#my Gnome::Gtk3::Box $b;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $sb1 .= new;
  isa-ok $sb1, Gnome::Gtk3::Statusbar, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
class X {

  method test-label ( N-GObject $nw, Str :$test, Str :$testing ) {
    my Gnome::Gtk3::Label $l .= new(:native-object($nw));
    is $l.get-label(), $test, $testing;
  }

  method do-test ( Gnome::Gtk3::Statusbar $sb, Str :$test, Str :$testing ) {
    my Gnome::Gtk3::Box $b .= new(:native-object($sb.get-message-area));
    $b.container-foreach( self, 'test-label', :$test, :$testing);
  }
}

subtest 'Manipulations', {
  my X $x .= new;

  my Int $cid1 = $sb1.get-context-id('network messages');
  is $cid1, 1, '.get-context-id)(): 1st context 1st StatusBar';
  my Int $cid2 = $sb1.get-context-id('input messages');
  is $cid2, 2, '.get-context-id)(): 2nd context 1st StatusBar';

  $sb2 .= new;
  my Int $cid3 = $sb2.get-context-id('input messages');
  is $cid3, 1, '.get-context-id)(): 1st context 2nd StatusBar';

  my Str $msg1 = 'zou je dat wel doen?';
  my Int $mid1 = $sb1.statusbar-push( $cid1, $msg1);
  is $mid1, 1, "message id = $mid1, $msg1";
  my Gnome::Gtk3::Box $b .= new(:native-object($sb1.get-message-area));
  is $b.get-name, 'GtkBox', '.get-message-area()';

  $x.do-test( $sb1, :test('zou je dat wel doen?'), :testing<.statusbar-push()>);

  my Str $msg2 = 'of moet ik het doen?';
  my Int $mid2 = $sb1.statusbar-push( $cid1, $msg2);
  is $mid2, 2, "message id = $mid2, $msg2";

  my Str $msg3 = 'dan nog, ...';
  my Int $mid3 = $sb1.statusbar-push( $cid1, $msg3);
  is $mid3, 3, "message id = $mid3, $msg3";
  $x.do-test( $sb1, :test('dan nog, ...'), :testing('3x .statusbar-push()'));

  # pop: 'dan nog, ...', top: 'of moet ik het doen?', left 2 msgs
  $sb1.statusbar-pop($cid1);
  $x.do-test(
    $sb1, :test('of moet ik het doen?'), :testing('.statusbar-pop()')
  );

  # remove 'of moet ik het doen?', top: 'zou je dat wel doen?'
  $sb1.statusbar-remove( $cid1, 2);
  $x.do-test(
    $sb1, :test('zou je dat wel doen?'), :testing('.statusbar-remove()')
  );

  # drop all messages
  $sb1.statusbar-remove-all($cid1);
  $x.do-test(
    $sb1, :test(''), :testing('.statusbar-remove-all()')
  );
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Statusbar', {
  class MyClass is Gnome::Gtk3::Statusbar {
    method new ( |c ) {
      self.bless( :GtkStatusbar, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Statusbar, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  #use Gnome::Glib::Main;
  use Gnome::Gtk3::Main;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method push-pop (
      Int $cid, Str $text, Gnome::Gtk3::Statusbar :$widget,
      Int :$test-cid, Str :$test-text
    ) {
      $!signal-processed = True;
      is $cid, $test-cid, 'cid ok';
      is $text, $test-text, 'text ok';
    }

    method signal-emitter (
      Gnome::Gtk3::Statusbar :$widget, Int :$cid, Str :$msg --> Str
    ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.statusbar-push( $cid, $msg);
      is $!signal-processed, True, '\'text-pushed\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $!signal-processed = False;
      $widget.statusbar-pop($cid);
      is $!signal-processed, True, '\'text-popped\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::Statusbar $sb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my Int $cid = $sb.get-context-id('network messages');
  my Str $msg = 'zou je dat wel doen?';

  my SignalHandlers $sh .= new;
  $sb.register-signal(
    $sh, 'push-pop', 'text-pushed', :test-cid($cid), :test-text($msg)
  );

  $sb.register-signal(
    $sh, 'push-pop', 'text-popped', :test-cid(0), :test-text(Str)
  );

  my Promise $p = $sb.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,       # enable 'use Gnome::Glib::Main'
    # :!new-context,
    # :start-time(now + 1)
    :$cid, :$msg
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
