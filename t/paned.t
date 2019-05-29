use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Paned;
use Gnome::Gtk3::ListBox;

diag "\n";

#-------------------------------------------------------------------------------
subtest 'Create paned windows', {
  my Gnome::Gtk3::ListBox $lb-left .= new(:empty);
  $lb-left.set-name('leftListbox');
  my Gnome::Gtk3::ListBox $lb-right .= new(:empty);
  $lb-right.set-name('rightListbox');
  my Gnome::Gtk3::Paned $p .= new(:orientation(GTK_ORIENTATION_HORIZONTAL));
  $p.gtk-paned-add1($lb-left);
  $p.gtk-paned-add2($lb-right);

  # when retrieved, native widget addresses are changed. cannot compare with
  # native object using $lb-left(). so only test its type.
  isa-ok $p.get-child1, N-GObject;
  isa-ok $p.get-child2, N-GObject;

  # testing the set names is more accurate.
  my Gnome::Gtk3::ListBox $lb .= new(:widget($p.get-child1));
  is $lb.get-name, 'leftListbox', 'left listbox found';
  $lb .= new(:widget($p.get-child2));
  is $lb.get-name, 'rightListbox', 'right listbox found';
}

#-------------------------------------------------------------------------------
done-testing;
