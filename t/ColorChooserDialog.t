use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooserDialog;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ColorChooserDialog $ccd;
#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  $ccd .= new(:title('my color chooser dialog'));
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog, '.new(:title)';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {

  # must have an initialized object to get it filled
  my GdkRGBA $color .= new;
  $ccd.get-rgba($color);
  is $color.red, 1.0, 'red is 1.0';
  is $color.green, 1.0, 'green is 1.0';
  is $color.blue, 1.0, 'blue is 1.0';
  is $color.alpha, 1.0, 'alpha is 1.0';

  $color .= new( :blue(.5e0), :alpha(.5e0));
  $ccd.set-rgba($color);

  my GdkRGBA $color2 .= new;
  $ccd.get-rgba($color2);
  is $color.red, 0.0, 'red is 0.0';
  is $color.green, 0.0, 'green is 0.0';
  is $color2.blue, .5, 'blue is .5';
  is $color2.alpha, .5, 'alpha is .5';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
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
