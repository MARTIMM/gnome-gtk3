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
   $tt .= new;
  isa-ok $tt, Gnome::Gtk3::TextTag, '.new';

  $tt .= new(:tag-name<my-very-own-tag-name>);
  isa-ok $tt, Gnome::Gtk3::TextTag, '.new(:tag-name)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::TextTagTable $ttt .= new;
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
