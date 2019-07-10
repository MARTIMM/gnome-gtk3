use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::FileChooserDialog;


#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::FileChooserDialog $fcd .= new(:title('Search for files'));
  isa-ok $fcd, Gnome::Gtk3::FileChooserDialog;
}

#-------------------------------------------------------------------------------
done-testing;
