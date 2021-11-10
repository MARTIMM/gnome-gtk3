use v6;

#`{{
  Example transformed from C.
  https://github.com/bstpierre/gtk-examples/blob/master/c/accel.c
}}

use Gnome::GObject::Closure;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::AccelGroup;
#use Gnome::Gtk3::Enums;

use Gnome::Gdk3::Types;
use Gnome::Gdk3::Keysyms;

#use Gnome::N::X;
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
with my Gnome::Gtk3::AccelGroup $accel-group .= new {
  # <ctrl>A will show text on the console
  .connect(
    GDK_KEY_A, GDK_CONTROL_MASK, 0,
#    my $c = Gnome::GObject::Closure.new(
    Gnome::GObject::Closure.new(
      :handler-object($ctest), :handler-name<accelerator-pressed>,
      :handler-opts(:arg1<'foo'>)
    )
  );

#  my N-GClosure $no = $c.get-native-object;
#  note 'M: ' ~ $no.in-marshal;
#  note 'V: ' ~ $no.is-invalid;

  # <ctrl><shift>C will stop the program
  .connect(
    GDK_KEY_C, GDK_CONTROL_MASK +| GDK_SHIFT_MASK, 0,
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

Gnome::Gtk3::Main.new.main;
