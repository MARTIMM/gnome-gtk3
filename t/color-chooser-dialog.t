use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ColorChooserDialog;

#-------------------------------------------------------------------------------
subtest 'color chooser dialog', {
  my Gnome::Gtk3::ColorChooserDialog $ccd .= new(
    :title('my color chooser dialog')
  );
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog;
}

#-------------------------------------------------------------------------------
done-testing;
