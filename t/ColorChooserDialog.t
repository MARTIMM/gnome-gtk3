use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooser;
use Gnome::Gtk3::ColorChooserDialog;
use Gnome::Gtk3::ColorButton;
use Gnome::Gtk3::Enums;


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
subtest 'Interface ColorChooser', {
  $ccd .= new(:title('my color chooser dialog'));
  isa-ok $ccd, Gnome::Gtk3::ColorChooserDialog;
  my Gnome::Gdk3::RGBA $r .= new(:rgba($ccd.get-rgba));
  is $r.to-string, 'rgb(255,255,255)', '.get-rgba()';

  $r.gdk-rgba-parse('rgba(0,255,0,0.5)');
  $ccd.set-rgba($r);

  is $ccd.get-use-alpha, 1, '.get-use-alpha()';
  $ccd.set-use-alpha(0);
  is $ccd.get-use-alpha, 0, '.set-use-alpha()';

  my Array[N-GdkRGBA] $palette1 .= new(
    N-GdkRGBA.new( :red(.0e0), :green(.0e0), :blue(.0e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.1e0), :green(.1e0), :blue(.1e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.2e0), :green(.2e0), :blue(.2e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.3e0), :green(.3e0), :blue(.3e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.4e0), :green(.4e0), :blue(.4e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.6e0), :green(.6e0), :blue(.6e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.7e0), :green(.7e0), :blue(.7e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.8e0), :green(.8e0), :blue(.8e0), :alpha(.5e0)),
    N-GdkRGBA.new( :red(.9e0), :green(.9e0), :blue(.9e0), :alpha(.5e0)),
  );

  $ccd.add-palette( GTK_ORIENTATION_HORIZONTAL, 5, 9, $palette1);
  ok 1, '.add-palette(Array[N-GdkRGBA]) didn\'t choke';

  # colors can be Str, Int, Num or Rat as long as it is within 0 ,, 1.
  my Array $palette2 = [
    0, 0, 0, 1,             # color1: red, green, blue, opacity
    .1e0, 0, 0, 1,          # color2: ...
    '0.2', 0, 0, 1,
    0.3, 0, 0, 1,
  ];

  $ccd.add-palette( GTK_ORIENTATION_HORIZONTAL, 2, 4, $palette2);
  ok 1, '.add-palette(Array[Num]) didn\'t choke';
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
