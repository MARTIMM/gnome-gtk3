use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreeRowReference;
ok 1, 'loads ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListStore $ls;
my Gnome::Gtk3::TreeIter $iter;
my Gnome::Gtk3::TreePath $tp;
my Gnome::Gtk3::TreeRowReference $tr;

enum ColumnNames < Col0 Col1 >;
#-------------------------------------------------------------------------------
subtest 'ISA test', {

  # preparations
  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, Col0, 2002, Col1, 'een stukje tekst');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, Col0, 2003, Col1, 'een beetje later');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, Col0, 4, Col1, 'wat meer tekst');

  $tp .= new(:first);
  $tr .= new(:tree-row-reference($ls.gtk-tree-row-reference-new($tp)));
  isa-ok $tr, Gnome::Gtk3::TreeRowReference, '.new(:tree-row-reference)';
  ok $tr.tree-row-reference-is-valid, '.tree-row-reference-is-valid()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $tp = $tr.get-path;
  is $tp.to-string, '0', '.get-path()';

  my Gnome::Gtk3::ListStore $ls2 .= new(:native_object($tr.get-model));
  is $ls2.get-n-columns, 2, '.get-model()';
#  ok $tr.valid, '.gtk_tree_row_reference_valid()';

  my Gnome::Gtk3::TreeRowReference $tr2 .= new(:tree-row-reference($tr.copy));
  $tp = $tr2.get-path;
  is $tp.to-string, '0', '.gtk_tree_row_reference_copy()';



  $tr.clear-tree-row-reference;
  nok $tr.tree-row-reference-is-valid, '.clear-tree-row-reference()';
#  nok $tr.valid, '.gtk_tree_row_reference_valid() not valid';
}

#`{{

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
