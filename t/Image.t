use v6;
use NativeCall;
use Test;

#use Gnome::Cairo;
#use Gnome::Cairo::Enums;
use Gnome::Cairo::Types;
use Gnome::Cairo::ImageSurface;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Image;
#use Gnome::Gtk3::Window;

use Gnome::Gdk3::Pixbuf;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Image $i;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $i .= new;
  isa-ok $i, Gnome::Gtk3::Image, ".new";
  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY,
     '.get-storage-type() empty';

  $i .= new(:filename<t/data/Add.png>);
  isa-ok $i, Gnome::Gtk3::Image, ".new(:filename)";
  is $i.get-storage-type, GTK_IMAGE_PIXBUF, '.get-storage-type() pixbuf';

  $i .= new(:filename<desktop>);
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.get-storage-type() icon name';

  $i .= new(:filename<t/data/Alexis-Kaufman.gif>);
  is $i.get-storage-type, GTK_IMAGE_ANIMATION, '.get-storage-type() animation';

  $i .= new( :icon-name<media-seek-forward>, :size(GTK_ICON_SIZE_DIALOG));
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.new( :icon, :size)';

  my Gnome::Cairo::ImageSurface $is .= new(:png<t/data/Add.png>);
  $i .= new(:surface($is));
  is $i.get-storage-type, GTK_IMAGE_SURFACE, '.new(:surface)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $i.image-clear;
  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY, '.image-clear()';

  $i .= new(:filename<t/data/Add.png>);
  my Gnome::Gdk3::Pixbuf $pb .= new(:native-object($i.get-pixbuf));
  is $pb.get-width, 16, '.get-pixbuf()';
#  note $i.get-pixel-size;

  $i .= new( :icon-name<media-seek-forward>, :size(GTK_ICON_SIZE_DIALOG));

  my List $info = $i.get-icon-name;
  is-deeply $info, ( 'media-seek-forward', GTK_ICON_SIZE_DIALOG),
            '.get-icon-name()';

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
