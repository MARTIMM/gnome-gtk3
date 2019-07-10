use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ColorChooserDialog;


#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::ColorChooserDialog $ccd .= new(
    :title('my color chooser dialog')
  );
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog;
}

#-------------------------------------------------------------------------------
done-testing;
