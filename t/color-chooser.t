use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ColorChooserDialog;
use Gnome::Gtk3::ColorChooser;
use Gnome::Gdk3::RGBA;

use Gnome::N::X;
X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'color chooser dialog', {
  my Gnome::Gtk3::ColorChooserDialog $ccd .= new(
    :title('my color chooser dialog')
  );
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog;

  # get color chooser widget
  my Gnome::Gtk3::ColorChooser $cc .= new(:widget($ccd));
  my GdkRGBA $color;
  $cc.get-rgba($color);
  note $color.perl;
}

#-------------------------------------------------------------------------------
done-testing;
