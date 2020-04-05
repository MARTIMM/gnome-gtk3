use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  # Handle button click
  method button-click ( :widget($b) --> Int ) {
    note $b.widget-get-name, ', ', 1000 / 0;
    $m.gtk-main-quit;

    1
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Hello GTK!');
$top-window.set-border-width(20);

# Create buttons and disable the second one
my Gnome::Gtk3::Button $button .= new(:label('Crash me'));
$top-window.gtk-container-add($button);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$button.register-signal( $ash, 'button-click', 'clicked');

# Show everything and activate all
$top-window.show-all;

$m.gtk-main;
