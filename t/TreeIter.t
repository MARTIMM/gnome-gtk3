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
  $ti .= new(:native-object($nti));
  isa-ok $ti, Gnome::Gtk3::TreeIter, '.new(:native-object)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TreeIter $ti-copy .= new(:native-object($ti.copy));
  is $ti-copy.get-native-object.stamp, 1001, '.gtk-tree-iter-copy()';
  ok $ti-copy.is-valid, '.is-valid()';
  $ti-copy.clear-object;
  nok $ti-copy.is-valid, '.clear-object()';
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
