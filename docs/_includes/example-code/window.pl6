use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Window');

# Show everything and activate all
$top-window.show-all;

$m.main;
