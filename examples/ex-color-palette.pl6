use v6;

my $t0 = now;

#use lib '../perl6-gnome-gobject/lib';
#use lib '../perl6-gnome-gdk3/lib';

use NativeCall;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooserWidget;
use Gnome::Gtk3::ColorChooser;
use Gnome::Gtk3::ColorButton;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;

#use Gnome::N::X;
#X::Gnome.debug(:on);

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  #submethod BUILD ( ) { }


  method exit-program ( ) {
#    note "exit program";
    $m.gtk-main-quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new(:empty);
$top-window.set-title('Color Chooser Widget Demo');
$top-window.set-border-width(20);

my Gnome::Gtk3::Grid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

my GdkRGBA $color .= new(
  :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
);
my Gnome::Gtk3::ColorButton $cb .= new(:$color);
$grid.gtk-grid-attach( $cb, 0, 3, 1, 1);

#my Gnome::Gtk3::ColorChooserWidget $ccw .= new(:empty);
#my Gnome::Gtk3::ColorChooser $cc .= new(:widget($ccw));
my Gnome::Gtk3::ColorChooser $cc .= new(:widget($cb));


my $palette = CArray[num64].new(
  .0e0, .0e0, .0e0, 1e0,
  .1e0, .0e0, .0e0, 1e0,
  .2e0, .0e0, .0e0, 1e0,
  .3e0, .0e0, .0e0, 1e0,
  .4e0, .0e0, .0e0, 1e0,
  .5e0, .0e0, .0e0, 1e0,
  .6e0, .0e0, .0e0, 1e0,
  .7e0, .0e0, .0e0, 1e0,
  .8e0, .0e0, .0e0, 1e0,
  .9e0, .0e0, .0e0, 1e0,
  .0e0, .0e0, .0e0, 1e0,
  .0e0, .1e0, .0e0, 1e0,
  .0e0, .2e0, .0e0, 1e0,
  .0e0, .3e0, .0e0, 1e0,
  .0e0, .4e0, .0e0, 1e0,
  .0e0, .5e0, .0e0, 1e0,
  .0e0, .6e0, .0e0, 1e0,
  .0e0, .7e0, .0e0, 1e0,
  .0e0, .8e0, .0e0, 1e0,
  .0e0, .9e0, .0e0, 1e0,
);

#`{{
class Palette is repr('CStruct') {
  HAS GdkRGBA $.c1;
  HAS GdkRGBA $.c2;
  HAS GdkRGBA $.c3;
  HAS GdkRGBA $.c4;

  submethod TWEAK {
#`{{
my $palette = CArray[GdkRGBA].new;
$palette[0] = GdkRGBA.new( :red(.0e0), :green(.0e0), :blue(.0e0), :alpha(1e0));
$palette[1] = GdkRGBA.new( :red(.1e0), :green(.1e0), :blue(.1e0), :alpha(1e0));
$palette[2] = GdkRGBA.new( :red(.2e0), :green(.2e0), :blue(.2e0), :alpha(1e0));
$palette[3] = GdkRGBA.new( :red(.3e0), :green(.3e0), :blue(.3e0), :alpha(1e0));
$palette[4] = GdkRGBA.new( :red(.4e0), :green(.4e0), :blue(.4e0), :alpha(1e0));
$palette[5] = GdkRGBA.new( :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(1e0));
$palette[6] = GdkRGBA.new( :red(.6e0), :green(.6e0), :blue(.6e0), :alpha(1e0));
$palette[7] = GdkRGBA.new( :red(.7e0), :green(.7e0), :blue(.7e0), :alpha(1e0));
$palette[8] = GdkRGBA.new( :red(.8e0), :green(.8e0), :blue(.8e0), :alpha(1e0));
$palette[9] = GdkRGBA.new( :red(.9e0), :green(.9e0), :blue(.9e0), :alpha(1e0));
}}
    $!c1 := GdkRGBA.new( :red(.6e0), :green(.6e0), :blue(.6e0), :alpha(1e0));
    $!c2 := GdkRGBA.new( :red(.7e0), :green(.7e0), :blue(.7e0), :alpha(1e0));
    $!c3 := GdkRGBA.new( :red(.8e0), :green(.8e0), :blue(.8e0), :alpha(1e0));
    $!c4 := GdkRGBA.new( :red(.9e0), :green(.9e0), :blue(.9e0), :alpha(1e0));
  }
}
}}

#note "P2: $palette[2].red()";
#$cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, Palette.new);
$cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette);
#$grid.gtk-grid-attach( $ccw, 0, 0, 3, 3);



# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$top-window.register-signal( $ash, 'exit-program', 'delete-event');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.gtk-main;
