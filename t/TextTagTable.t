use v6;
#use lib '../gnome-gobject/lib', '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TextTagTable;
use Gnome::Gtk3::TextTag;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextTagTable $ttt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ttt .= new;
  isa-ok $ttt, Gnome::Gtk3::TextTagTable, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::TextTag $tt .= new(:tag-name<my-tt>);
  ok $ttt.gtk-text-tag-table-add($tt), '.gtk-text-tag-table-add()';

  # create another one with same name
  $tt .= new(:tag-name<my-tt>);
  nok $ttt.gtk-text-tag-table-add($tt), 'tag not added';
  $tt .= new(:tag-name<my-tt2>);
  ok $ttt.gtk-text-tag-table-add($tt), '2nd tag added';
  is $ttt.get-size, 2, '.get-size()';

  $ttt.gtk-text-tag-table-remove($tt);
  is $ttt.get-size, 1, '.gtk-text-tag-table-remove()';

  $tt .= new(:native-object($ttt.gtk-text-tag-table-lookup('my-tt')));
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $tt.get-property( 'name', $gv);
  is $gv.get-string, 'my-tt', '.gtk-text-tag-table-lookup()';

  $gv = $tt.get-property( 'name', G_TYPE_STRING);
  is $gv.get-string, 'my-tt', '.gtk-text-tag-table-lookup()';

  subtest 'gtk-text-tag-table-foreach', {
    class X {
      method cb ( Gnome::Gtk3::TextTag $tt, :$test ) {
#        note "WN: $tt.perl(), $test";
        my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
        $tt.g-object-get-property( 'name', $gv);
        is $gv.g-value-get-string, 'my-tt', 'tag name';

        $gv .= new(:init(G_TYPE_BOOLEAN));
        $tt.g-object-get-property( 'editable', $gv);
        is $gv.g-value-get-boolean, 1, 'editable';
      }
    }

#Gnome::N::debug(:on);
    $ttt.gtk-text-tag-table-foreach( X.new, 'cb', :test<abcdef>);
    #Gnome::N::debug(:off);
  }
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
