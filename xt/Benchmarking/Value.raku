use v6;
use lib '../gnome-gobject/lib';
use lib '../gnome-native/lib';

#use NativeCall;

use Gnome::N::N-GObject:api<1>;
use Gnome::GObject::Type:api<1>;
use Gnome::GObject::Value:api<1>;
#use Gnome::Gtk3::TreeModel:api<1>;
use Gnome::Gtk3::TreeIter:api<1>;
#use Gnome::Gtk3::TreePath:api<1>;
use Gnome::Gtk3::ListStore:api<1>;

use Gnome::N::X:api<1>;
Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListStore $ls;
my Gnome::Gtk3::TreeIter $iter;
my Gnome::Gtk3::TreePath $tp;

enum ColumnNames < Col0 Col1 >;

for ^1000 {
  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  $iter = $ls.gtk-list-store-append;
  $ls.set-value( $iter, Col0, 1001);
  $ls.set-value( $iter, Col1, 'duizend en een nacht');

#  my Str $row = $c-path.to-string;
  my Array[Gnome::GObject::Value] $va = $ls.get-value( $iter, Col0, Col1);

  $va[Col0].clear-object;
  $va[Col1].clear-object;
}
