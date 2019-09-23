use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Image;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Image $i;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $i .= new(:empty);
  isa-ok $i, Gnome::Gtk3::Image, ".new(:empty)";
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY, '.get-storage-type()';
  $i .= new(:filename<data/handles.png>);
  is GtkImageType($i.get-storage-type), GTK_IMAGE_ICON_NAME, '.new(:filename)';

#  my @info = $i.get-icon-name;
#  is @info[0], 'abc', '.get-icon-name() name';
#  is @info[1], 660, '.get-icon-name() size';
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
