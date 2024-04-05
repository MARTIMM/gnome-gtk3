use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Button:api<1>;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;


# Class to handle signals
class AppSignalHandlers {

  # Handle 'Hello World' button click
  method first-button-click ( :_widget($b1), :other-button($b2) ) {
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  # Handle 'Goodbye' button click
  method second-button-click ( ) {
    $m.gtk-main-quit;
 }

  # Handle window managers 'close app' button
  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;


# Create buttons and disable the second one
with my Gnome::Gtk3::Button $second .= new(:label('Goodbye')) {
  .set-sensitive(False);
  .register-signal( $ash, 'second-button-click', 'clicked');
}

with my Gnome::Gtk3::Button $button .= new(:label('Hello World')) {
  .register-signal(
    $ash, 'first-button-click', 'clicked',  :other-button($second)
  );
}

# Create grid and add buttons to the grid
with my Gnome::Gtk3::Grid $grid .= new {
  .attach( $button, 0, 0, 1, 1);
  .attach( $second, 0, 1, 1, 1);
}

# Create a top level window and set a title among other things
with my Gnome::Gtk3::Window $top-window .= new {
  .set-title('Hello GTK!');
  .set-border-width(20);

  # Create a grid and add it to the window
  .add($grid);

  .register-signal( $ash, 'exit-program', 'destroy');

  # Show everything and activate all
  .show-all;
}

# Start the event loop
$m.gtk-main;
