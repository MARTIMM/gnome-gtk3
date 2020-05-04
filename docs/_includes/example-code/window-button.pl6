use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

class AppSignalHandlers {

  method button-exit ( ) { $m.gtk-main-quit; }
  method exit-program ( ) { $m.gtk-main-quit; }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.gtk-window-set-title('With Button');

# Create button
my Gnome::Gtk3::Button $button .= new(
  :label('Exit Our Very Lovely Program')
);
$top-window.gtk-container-add($button);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$button.register-signal( $ash, 'button-exit', 'clicked');
$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.gtk-widget-show-all;

$m.gtk-main;
