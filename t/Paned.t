use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Paned;
use Gnome::Gtk3::ListBox;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Paned $p;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $p .= new(:orientation(GTK_ORIENTATION_VERTICAL));
  isa-ok $p, Gnome::Gtk3::Paned, ".new(:orientation)";
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::ListBox $lb-left .= new;
  $lb-left.set-name('leftListbox');
  my Gnome::Gtk3::ListBox $lb-right .= new;
  $lb-right.set-name('rightListbox');
  $p .= new(:orientation(GTK_ORIENTATION_HORIZONTAL));
  $p.gtk-paned-add1($lb-left);
  $p.gtk-paned-add2($lb-right);

  # when retrieved, native widget addresses are changed. cannot compare with
  # native object using $lb-left.native-gobject().
  isa-ok $p.get-child1, N-GObject, 'native object from .get-child1()';
  isa-ok $p.get-child2, N-GObject, 'native object from .get-child2()';

  # testing the set names is more accurate.
  my Gnome::Gtk3::ListBox $lb .= new(:native_object($p.get-child1));
  is $lb.get-name, 'leftListbox', 'left listbox found';
  $lb .= new(:native_object($p.get-child2));
  is $lb.get-name, 'rightListbox', 'right listbox found';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
