use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TextTagTable;
use Gnome::Gtk3::TextTag;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextTagTable $ttt .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $ttt, Gnome::Gtk3::TextTagTable;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::TextTag $tt .= new(:tag-name<my-tt>);
  ok $ttt.gtk-text-tag-table-add($tt), 'tag added';

  # create another one with same name
  $tt .= new(:tag-name<my-tt>);
  nok $ttt.gtk-text-tag-table-add($tt), 'tag not added';
  $tt .= new(:tag-name<my-tt2>);
  ok $ttt.gtk-text-tag-table-add($tt), '2nd tag added';

#  $tt .= new(:tag-name<my-tt>);
#  $ttt.gtk-text-tag-table-remove($tt);
}

#-------------------------------------------------------------------------------
done-testing;
