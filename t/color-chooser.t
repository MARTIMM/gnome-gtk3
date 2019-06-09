use v6;

use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooserDialog;
use Gnome::Gtk3::ColorChooser;
use Gnome::Gtk3::ColorButton;
use Gnome::Gtk3::Enums;

my Gnome::Gtk3::ColorChooserDialog $ccd;
my Gnome::Gtk3::ColorChooser $cc;

#-------------------------------------------------------------------------------
subtest 'default color from chooser dialog', {

  $ccd .= new(:title('my color chooser dialog'));

  # get color chooser widget
  $cc .= new(:widget($ccd));
  isa-ok $cc, Gnome::Gtk3::ColorChooser;

  # must have an initialized object to get it filled
  my GdkRGBA $color .= new;
  $cc.get-rgba($color);
  is $color.red, 1.0, 'red is 1.0';
  is $color.green, 1.0, 'green is 1.0';
  is $color.blue, 1.0, 'blue is 1.0';
  is $color.alpha, 1.0, 'alpha is 1.0';
}

#-------------------------------------------------------------------------------
subtest 'color set from GdkRGBA', {
  my GdkRGBA $color .= new( :blue(.5e0), :alpha(.5e0));
  $cc.set-rgba($color);

  my GdkRGBA $color2 .= new;
  $cc.get-rgba($color2);
  is $color.red, 0.0, 'red is 0.0';
  is $color.green, 0.0, 'green is 0.0';
  is $color2.blue, .5, 'blue is .5';
  is $color2.alpha, .5, 'alpha is .5';
}

#-------------------------------------------------------------------------------
subtest 'color chooser alpha use', {
  my GdkRGBA $color .= new( :blue(.5e0), :alpha(.5e0));
  $cc.set-rgba($color);

  is $cc.get-use-alpha, 1, 'chooser did use alpha';
  $cc.set-use-alpha(0);
  is $cc.get-use-alpha, 0, 'chooser will not use alpha';
}

#-------------------------------------------------------------------------------
subtest 'color chooser palette', {
  my CArray[GdkRGBA] $palette .= new(
    GdkRGBA.new( :red(.0e0), :green(.0e0), :blue(.0e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.1e0), :green(.1e0), :blue(.1e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.2e0), :green(.2e0), :blue(.2e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.3e0), :green(.3e0), :blue(.3e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.4e0), :green(.4e0), :blue(.4e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.6e0), :green(.6e0), :blue(.6e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.7e0), :green(.7e0), :blue(.7e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.8e0), :green(.8e0), :blue(.8e0), :alpha(.5e0)),
    GdkRGBA.new( :red(.9e0), :green(.9e0), :blue(.9e0), :alpha(.5e0)),
  );

  $cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 5, 9, $palette);
}

#-------------------------------------------------------------------------------
subtest 'color chooser from color button', {
  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );
  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  isa-ok $cb, Gnome::Gtk3::ColorButton;

  $cc .= new(:widget($cb));
  isa-ok $cc, Gnome::Gtk3::ColorChooser;
  $cc.get-rgba($color);
  is $color.red, 0.5, 'red is 0.5';
  is $color.green, 0.5, 'green is 0.5';
  is $color.blue, 0.5, 'blue is 0.5';
  is $color.alpha, 0.5, 'alpha is 0.5';
}

#-------------------------------------------------------------------------------
done-testing;
