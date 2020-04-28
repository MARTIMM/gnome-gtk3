use v6;
use lib '../gnome-gobject/lib';

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {
  has Int $!hid2;

  # Handle 'Hello World' button click
  method chng-sig ( :$button2 --> Int ) {

    $button2.handler-disconnect($!hid2) if $!hid2;
    $!hid2 = $button2.register-signal(
      self, 'test-sig', 'clicked', :text('test ' ~ rand)
    );

    note "new handler id: $!hid2";

    1
  }

  # Handle 'Goodbye' button click
  method test-sig ( :$text --> Int ) {
    note "Text: $text";

    1
  }

  # Handle window managers 'close app' button
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Hello GTK!');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new;
$top-window.gtk-container-add($grid);

# Create buttons and disable the second one
my Gnome::Gtk3::Button $button1 .= new(:label('Change 2nd bttn signal'));
my Gnome::Gtk3::Button $button2 .= new(:label('Test 2nd bttn signal'));

# Add buttons to the grid
$grid.gtk-grid-attach( $button1, 0, 0, 1, 1);
$grid.gtk-grid-attach( $button2, 0, 1, 1, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$button1.register-signal( $ash, 'chng-sig', 'clicked', :$button2);

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

$m.gtk-main;
