use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TreeModel;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::TreeStore;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeStore $ts;
my Gnome::Gtk3::TreeIter $iter;
my Gnome::Gtk3::TreeIter $parent-iter;
my Gnome::Gtk3::TreeIter $child-iter;
my Gnome::Gtk3::TreePath $tp;
my Array[Gnome::GObject::Value] $va;

enum ColumnNames < Col0 Col1 Col2 >; # Col2 is not used or set!

my class ShowTabel {
  submethod BUILD ( ) {
    note "\n Row  | Number | String\n------+--------+-------------------";
  }

  method show-entry (
    Gnome::Gtk3::TreeStore $c-ts,
    Gnome::Gtk3::TreePath $c-path,
    Gnome::Gtk3::TreeIter $c-iter
  ) {
    my Str $row = $c-path.to-string;

    my Array[Gnome::GObject::Value] $va;
    $va = $c-ts.get-value( $c-iter, Col0, Col1);

    note $row.fmt('%5.5s'), ' | ',
         $va[Col0].get-int.fmt('%6d'), ' | ',
         $va[Col1].get-string;

    $va[Col0].unset;
    $va[Col1].unset;

    0
  }
}

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ts .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  isa-ok $ts, Gnome::Gtk3::TreeStore, '.new(:field-types)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $iter = $ts.gtk-tree-store-append(Any);
  is $ts.get-path($iter).to-string, '0', '.gtk-tree-store-append()';
  $ts.set-value( $iter, Col0, 1001);
  $ts.set-value( $iter, Col1, 'duizend en een nacht');
  $va = $ts.get-value( $iter, Col0, Col1);
  is $va[Col0].get-int, 1001, 'col 0:.set-value() / .get-value()';
  is $va[Col1].get-string, 'duizend en een nacht',
      'col 1:.set-value() / .get-value()';
  $va[Col0].unset;
  $va[Col1].unset;

  $tp .= new(:string('0'));
  $parent-iter = $ts.get-iter($tp);
  $iter = $ts.gtk-tree-store-append($parent-iter);
  is $ts.get-path($iter).to-string, '0:0',
     'path: ' ~ $ts.get-path($iter).to-string;
  $ts.set-value( $iter, Col0, 1002);
  $ts.set-value( $iter, Col1, 'en nog wat nachten');
  $va = $ts.get-value( $iter, Col0, Col1);
  is $va[Col0].get-int, 1002, 'col 0:.set-value() / .get-value()';
  is $va[Col1].get-string, 'en nog wat nachten',
      'col 1:.set-value() / .get-value()';
  $va[Col0].unset;
  $va[Col1].unset;
#  $ts.gtk-tree-store-set( $iter, Col0, 2002, Col1, 'een beetje later');


  $ts.foreach( ShowTabel.new, 'show-entry');
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
