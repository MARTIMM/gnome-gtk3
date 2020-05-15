use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::Gtk3::Window;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Window $w .= new;
  isa-ok $w, Gnome::Gtk3::Window, '.new';
#  $w .= new(:title('My test window'));
#  isa-ok $w, Gnome::Gtk3::Window, '.new(:title)';
#  is $w.get-title, 'My test window', '.get-title()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Window $w .= new;
  is GtkWindowType($w.get-window-type), GTK_WINDOW_TOPLEVEL,
     '.get-window-type()';

  $w.set-title('My test window');
  is $w.get-title, 'My test window', '.set-title() / .get-title()';

#Gnome::N::debug(:on);
  ok 1, ".get-default-size() defaults";
  my Int ( $ww, $wh) = $w.get-default-size;
  ok Any || $ww == -1, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == -1, '.get-size(), h=' ~ ($wh//'Any');
  ok 1, '.set-default-size( 123, 356)';
  $w.set-default-size( 123, 356);
  ( $ww, $wh) = $w.get-default-size;
  ok Any || $ww == 123, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == 356, '.get-size(), h=' ~ ($wh//'Any');

#Gnome::N::debug(:off);

  $w.set-title('empty window');
  is $w.get-title, 'empty window', '.set-title()';

  ok 1, '.set-position()';
  $w.set-position(GTK_WIN_POS_MOUSE);
  my Int ( $rx, $ry) = $w.get-position;
  ok Any || $rx >= 0, '.get-position(), x=' ~ ($rx//'Any');
  ok Any || $ry >= 0, '.get-position(), y=' ~ ($ry//'Any');

  ok 1, '.gtk-window-move( 900, 250)';
  $w.gtk-window-move( 900, 250);
  ( $rx, $ry) = $w.get-position;
  ok Any || $rx == 900, '.get-position(), x=' ~ ($rx//'Any');
  ok Any || $ry == 250, '.get-position(), y=' ~ ($ry//'Any');

  ok 1, '.gtk-window-resize( 240, 341)';
  $w.gtk-window-resize( 240, 341);
  ( $ww, $wh) = $w.get-size;
  ok Any || $ww == 240, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == 341, '.get-size(), h=' ~ ($wh//'Any');
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Window', {
  class MyClass is Gnome::Gtk3::Window {
    method new ( |c ) {
      self.bless( :GtkWindow, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Window, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  my Gnome::Gtk3::Window $w .= new;
  $w.set-title('new title');

  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $w.g-object-get-property( 'title', $gv);
  #$gv.g-value-set-...(...);
  is $gv.g-value-get-string(), 'new title', 'property title';
  $gv.clear-object;
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

##`{{
#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  #use Gnome::Glib::Main;
  use Gnome::Gtk3::Main;
  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method enable-debugging-handler (
      Int $toggle, Gnome::Gtk3::Window :$widget
      --> Int
    ) {

      isa-ok $widget, Gnome::Gtk3::Window;
      is $toggle, 1, 'test $toggle';
      $!signal-processed = True;

      1
    }

    method signal-emitter ( Gnome::Gtk3::Window :$widget --> Str ) {
#Gnome::N::debug(:on);
      while $main.gtk-events-pending() { $main.iteration-do(False); }

      note 'rv: ', $widget.emit-by-name(
        'enable-debugging', 1, :return-type(int32), :parameters([int32,])
      );

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      is $!signal-processed, True, '\'enable-debugging\' signal processed';

      #$!signal-processed = False;
      #$mh-in-handler.emit-by-name( ..., $mh-in-handler);
      #is $!signal-processed, True, '\'...\' signal processed';

      sleep(0.3);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::Window $w .= new;
  my SignalHandlers $sh .= new;
  $w.register-signal( $sh, 'enable-debugging-handler', 'enable-debugging');

  my Promise $p = $w.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,
    # :!new-context,
    # :start-time(now + 3)
  );

  $w.show-all;

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
#}}

#-------------------------------------------------------------------------------
done-testing;
