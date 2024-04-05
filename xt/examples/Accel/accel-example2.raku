use v6;

#`{{
  Example transformed from C.
  https://github.com/bstpierre/gtk-examples/blob/master/c/accel.c
}}

use Gnome::GObject::Closure:api<1>;

use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::AccelGroup:api<1>;
use Gnome::Gtk3::AccelMap:api<1>;
#use Gnome::Gtk3::Enums:api<1>;

use Gnome::Gdk3::Types:api<1>;
use Gnome::Gdk3::Keysyms:api<1>;

#use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class CTest {
  method accelerator-pressed ( Str :$arg1 ) {
    note "accelerator pressed, user argument = '$arg1'";
  }

  method stop-test ( ) {
    note "program stopped";
    Gnome::Gtk3::Main.new.quit;
  }
}

my CTest $ctest .= new;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AccelMap $am .= instance;
with my Gnome::Gtk3::AccelGroup $accel-group .= new {
  # <Alt>S will show text on the console
    $am.add-entry( '<window>/File/Save', GDK_KEY_S, GDK_MOD1_MASK);

  .connect-by-path(
    '<window>/File/Save',
    Gnome::GObject::Closure.new(
      :handler-object($ctest), :handler-name<accelerator-pressed>,
      :handler-opts(:arg1<'foo'>)
    )
  );

  # <ctrl>Q will stop the program
  $am.add-entry( '<window>/File/Quit', GDK_KEY_Q, GDK_CONTROL_MASK);
  .connect-by-path(
    '<window>/File/Quit',
    Gnome::GObject::Closure.new(
      :handler-object($ctest), :handler-name<stop-test>
    )
  );
}

with my Gnome::Gtk3::Window $window .= new {
  .add-accel-group($accel-group);
  .register-signal( $ctest, 'stop-test', 'destroy');
  .show;
}

note Q:q:to/EONOTE/;

  Demonstrates acceleration keys using
    Gnome::Gtk3::AccelGroup
    Gnome::Gtk3::AccelMap
    Gnome::GObject::Closure

  You can use the following control keys

  <Alt> S   - show a string on the konsole
  <Ctrl> Q  - stop the program


EONOTE

Gnome::Gtk3::Main.new.main;
