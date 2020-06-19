use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::DrawingArea;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::DrawingArea $da;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $da .= new;
  isa-ok $da, Gnome::Gtk3::DrawingArea, '.new()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::DrawingArea', {
  class MyClass is Gnome::Gtk3::DrawingArea {
    method new ( |c ) {
      self.bless( :GtkDrawingArea, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::DrawingArea, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  my Gnome::Gtk3::DrawingArea $da .= new;

  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_...));
  $da.g-object-get-property( '...', $gv);
  #$gv.g-value-set-...(...);
  is $gv.g-value-get-...(...), ..., 'property ...';
  $gv.clear-object;
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

    method ... ( 'any-args', Gnome::Gtk3::DrawingArea :$widget #`{{ --> ...}} ) {

      isa-ok $widget, Gnome::Gtk3::DrawingArea;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::DrawingArea :$widget --> Str ) {

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

  my Gnome::Gtk3::DrawingArea $da .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $da.register-signal( $sh, 'method', 'signal');

  my Promise $p = $da.start-thread(
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

