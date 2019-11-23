use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TreeIter;
ok 1, 'loads ok';

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeIter $ti;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my N-GtkTreeIter $nti .= new(
    :stamp(1001), :userdata1(CArray[Str].new('a')),
    :userdata2(CArray[Str].new('b')), :userdata3(CArray[Str].new('c'))
  );
  $ti .= new(:tree-iter($nti));
  isa-ok $ti, Gnome::Gtk3::TreeIter, '.new(:tree-iter)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TreeIter $ti-copy .= new(:tree-iter($ti.copy));
  is $ti-copy.get-native-gboxed.stamp, 1001, '.gtk-tree-iter-copy()';
  ok $ti-copy.tree-iter-is-valid, '.tree-iter-is-valid()';
  $ti-copy.clear-tree-iter;
  nok $ti-copy.tree-iter-is-valid, '.clear-tree-iter()';
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
