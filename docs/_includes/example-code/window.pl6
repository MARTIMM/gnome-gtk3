use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Window');

# Show everything and activate all
$top-window.show-all;

$m.main;
