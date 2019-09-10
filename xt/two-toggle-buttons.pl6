use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::ToggleButton;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  has Gnome::Gtk3::ToggleButton $!toggle1;
  has Gnome::Gtk3::ToggleButton $!toggle2;

  submethod BUILD ( :$!toggle1, :$!toggle2 ) { }

  # Handle 'Hello World' button click
  method tb1-click ( --> Int ) {

    1
  }

  # Handle 'Goodbye' button click
  method tb2-click ( --> Int ) {

    1
  }

  # Handle window managers 'close app' button
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new(:title('Two Toggles'));
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

# Create buttons and disable the second one
my Gnome::Gtk3::ToggleButton $tb1 .= new(:label('Hi, i’m a toggle button.'));
$tb1.set-mode(1);

my Gnome::Gtk3::ToggleButton $tb2 .= new(:label(''));
$second.set-sensitive(False);

# Add buttons to the grid
$grid.gtk-grid-attach( $tb1, 0, 0, 1, 1);
$grid.gtk-grid-attach( $tb2, 0, 1, 1, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new( :toggle1($tb1), :toggle2($tb2));
$tb1.register-signal( $ash, 'tb1-click', 'toggled');
$tb2.register-signal( $ash, 'tb2-click', 'toggled');

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

$m.gtk-main;
