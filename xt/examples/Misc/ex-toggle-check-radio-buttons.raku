use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::CheckButton:api<1>;
use Gnome::Gtk3::ToggleButton:api<1>;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  # Handle 'Hello World' button click
  method b-events ( :$widget, Str :$type, Int :$nbr ) {
    note "$type button $nbr, ",
         $widget.get-active.Bool ?? '' !! 'not ', 'activated';
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
my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

# Create toggle and check buttons
my Gnome::Gtk3::ToggleButton $tb1 .= new(:label('Hi, i\’m a toggle button.'));

# This check button will look like a toggle button
my Gnome::Gtk3::CheckButton $cb1 .= new(:label('Hi, i\’m a check button.'));
$cb1.set-mode(1);

my Gnome::Gtk3::CheckButton $cb2 .= new(:label('Hi, i\’m a check button.'));
$cb1.set-mode(0);

# Add buttons to the grid
$grid.gtk-grid-attach( $tb1, 0, 0, 1, 1);
$grid.gtk-grid-attach( $cb1, 0, 2, 1, 1);
$grid.gtk-grid-attach( $cb2, 0, 3, 1, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$tb1.register-signal( $ash, 'b-events', 'toggled', :type<toggle>, :nbr(1));
$cb1.register-signal( $ash, 'b-events', 'toggled', :type<check>, :nbr(1));
$cb2.register-signal( $ash, 'b-events', 'toggled', :type<check>, :nbr(2));

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

$m.gtk-main;
