use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TreeIter;
ok 1, 'loads ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeIter $tv;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my N-GtkTreeIter $ti .= new(
    :stamp(1001), :userdata1(CArray[Str].new('a')),
    :userdata2(CArray[Str].new('b')), :userdata3(CArray[Str].new('c'))
  );
  $tv .= new(:tree-iter($ti));
  isa-ok $tv, Gnome::Gtk3::TreeIter, '.new(:tree-iter)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TreeIter $tv-copy .= new(:tree-iter($tv.gtk-tree-iter-copy));
  is $tv-copy.get-native-gboxed.stamp, 1001, '.gtk-tree-iter-copy()';
  ok $tv-copy.tree-iter-is-valid, '.tree-iter-is-valid()';
  $tv-copy.clear-tree-iter;
  nok $tv-copy.tree-iter-is-valid, '.clear-tree-iter()';
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
