use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TreePath;
ok 1, 'loads ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreePath $tp;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tp .= new;
  isa-ok $tp, Gnome::Gtk3::TreePath, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TreePath $tp-copy .= new(
    :native-object($tp.gtk-tree-path-copy)
  );
  isa-ok $tp-copy.get-native-object, N-GtkTreePath, '.gtk-tree-path-copy()';
  ok $tp-copy.is-valid, '.is-valid()';
  $tp-copy.clear-object;
  nok $tp-copy.is-valid, '.clear-object()';

  $tp .= new(:first);
  isa-ok $tp.get-native-object, N-GtkTreePath, '.new(:first)';
  is $tp.to-string, '0', '.to-string()';
  $tp.append-index(10);
  is $tp.to-string, '0:10', '.append-index()';
  $tp.prepend-index(2);
  is $tp.to-string, '2:0:10', '.prepend-index()';
  is $tp.get-depth, '3', '.get-depth()';
  is-deeply [ 2, 0, 10], $tp.get-indices, '.get-indices()';
  is-deeply ( 3, [ 2, 0, 10]), $tp.get-indices-with-depth,
      '.get-indices-with-depth()';

  my Gnome::Gtk3::TreePath $tp2 .= new(:string('1:3'));
  is $tp2.to-string, '1:3', '.new(:string)';

  my Gnome::Gtk3::TreePath $tp3 .= new(:indices(1, 3));
  is $tp3.to-string, '1:3', '.new(:indices)';
  is $tp3.gtk-tree-path-compare($tp2), 0, '.gtk-tree-path-compare() equal';
  $tp2 .= new(:string('0:3'));
  is $tp3.gtk-tree-path-compare($tp2), 1, '.gtk-tree-path-compare() before';
  $tp2 .= new(:string('1:3:1'));
  is $tp3.gtk-tree-path-compare($tp2), -1, '.gtk-tree-path-compare() after';

  $tp2.gtk-tree-path-next;
  is $tp2.to-string, '1:3:2', '.gtk-tree-path-next()';
  $tp2.gtk-tree-path-prev;
  is $tp2.to-string, '1:3:1', '.gtk-tree-path-prev()';
  $tp2.gtk-tree-path-up;
  is $tp2.to-string, '1:3', '.gtk-tree-path-up()';
  $tp2.gtk-tree-path-down;
  is $tp2.to-string, '1:3:0', '.gtk-tree-path-down()';

  ok $tp3.is-ancestor($tp2), '.is-ancestor()';
  ok $tp2.is-descendant($tp3), '.is-descendant()';
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
