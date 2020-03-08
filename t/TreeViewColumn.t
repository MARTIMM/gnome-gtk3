use v6;
use lib '../gnome-gobject/lib', '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::CellRendererText;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::TreeViewColumn;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::TreeIter;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeViewColumn $tvc;
my Gnome::Gtk3::CellRendererText $crt;
my Gnome::Gtk3::ListStore $ls;
my Gnome::Gtk3::TreeView $tv;
my Gnome::Gtk3::TreeIter $iter;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tvc .= new;
  isa-ok $tvc, Gnome::Gtk3::TreeViewColumn, '.new';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
#  $crt .= new;
#  $tvc.add-attribute( $crt, 'text', 0);

  $tvc.set-title('book title');
  is $tvc.get-title, 'book title', '.set-title() / .get-title()';

  nok $tvc.get-expand, '.get-expand()';
  $tvc.set-expand(1);
  ok $tvc.get-expand, '.set-expand()';

  $crt .= new;
  $tvc.pack-start( $crt, 1);
  $tvc.add-attribute( $crt, 'text', 0);
  ok $tvc.cell-is-visible, '.cell-is-visible()';

  # need a new renderer
  $crt .= new;
  $tvc.pack-end( $crt, 1);

  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  $tv .= new(:model($ls.get-native-object));
  $iter = $ls.gtk-list-store-append;
  $tvc.cell-set-cell-data( $ls, $iter, 0, 0);
#  ok $tvc.cell-is-visible, '.cell-is-visible()';

  $tvc.set-sizing(GTK_TREE_VIEW_COLUMN_AUTOSIZE);
  is GtkTreeViewColumnSizing($tvc.get-sizing), GTK_TREE_VIEW_COLUMN_AUTOSIZE,
     '.set-sizing() / .get-sizing()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my Gnome::GObject::Value $gv = $tvc.get-property( 'visible', G_TYPE_BOOLEAN);
  ok $gv.get-boolean, 'property visible';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
