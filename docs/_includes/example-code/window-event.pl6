use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# A callback handler class to respond to the 'close application event'
class AppSignalHandlers {
  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new(:title<Example>);

# Initialize the callback handler class and register the method for the event
my AppSignalHandlers $ash .= new;
$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate
$top-window.show-all;

$m.gtk-main;
