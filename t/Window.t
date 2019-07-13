use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Window;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Window $v .= new(:empty);
  isa-ok $v, Gnome::Gtk3::Window;
}

#-------------------------------------------------------------------------------
subtest 'Manips', {
  my Gnome::Gtk3::Window $v .= new(:empty);
  $v.set-title('empty window');
  is $v.get-title, 'empty window', 'title returned';
}

#-------------------------------------------------------------------------------
done-testing;
