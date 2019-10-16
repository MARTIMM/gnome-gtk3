use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TextTag;
use Gnome::Gtk3::TextTagTable;
#use Gnome::Gtk3::TextBuffer;
#use Gnome::Gtk3::TextIter;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TextTag $tt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
   $tt .= new(:empty);
  isa-ok $tt, Gnome::Gtk3::TextTag, '.new(:empty)';

  $tt .= new(:tag-name<my-very-own-tag-name>);
  isa-ok $tt, Gnome::Gtk3::TextTag, '.new(:tag-name)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TextTagTable $ttt .= new(:empty);
  $ttt.gtk-text-tag-table-add($tt);
  my Gnome::Gtk3::TextTag $tt2 .= new(:tag-name<my-second-tag-name>);
  $ttt.gtk-text-tag-table-add($tt2);

  is $tt.get-priority, 0, '.get-priority()';

  $tt.set-priority(1);
  is $tt.get-priority, 1, '.set-priority()';
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
}}


#-------------------------------------------------------------------------------
done-testing;
