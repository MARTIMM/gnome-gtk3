use v6;

my $t0 = now;

use Gnome::Gtk3::Window;
use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorChooserWidget;
use Gnome::Gtk3::ColorButton;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Grid;

#use Gnome::N::X;
#Gnome::N::debug(:on);

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  method exit-program ( ) {
    $m.quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Color Chooser Widget Demo');
$top-window.set-border-width(20);

my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

my Gnome::Gtk3::ColorChooserWidget $ccw .= new;
$grid.attach( $ccw, 0, 0, 4, 1);

my N-GdkRGBA $color .= new( :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0));
my Gnome::Gtk3::ColorButton $cb .= new(:$color);
$grid.attach( $cb, 0, 3, 1, 1);

my Array[Num] $palette1 .= new(
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

my Array[N-GdkRGBA] $palette2 .= new;
for .5, .6 ... 1.0 -> $rgb-gray {
  $palette2.push: N-GdkRGBA.new(
    :red($rgb-gray.Num), :green(0e0),
    :blue(0e0), :alpha(1e0)
  );
  $palette2.push: N-GdkRGBA.new(
    :red(0e0), :green($rgb-gray.Num),
    :blue(0e0), :alpha(1e0)
  );
  $palette2.push: N-GdkRGBA.new(
    :red(0e0), :green(0e0),
    :blue($rgb-gray.Num), :alpha(1e0)
  );

  $palette2.push: N-GdkRGBA.new(
    :red($rgb-gray.Num), :green($rgb-gray.Num),
    :blue(0e0), :alpha(1e0)
  );
  $palette2.push: N-GdkRGBA.new(
    :red(0e0), :green($rgb-gray.Num),
    :blue($rgb-gray.Num), :alpha(1e0)
  );
  $palette2.push: N-GdkRGBA.new(
    :red($rgb-gray.Num), :green(0e0),
    :blue($rgb-gray.Num), :alpha(1e0)
  );
}

use Gnome::N::X;
#Gnome::N::debug(:on);

$ccw.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette1);
$cb.add-palette( GTK_ORIENTATION_VERTICAL, 6, 36, $palette2);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.main;
