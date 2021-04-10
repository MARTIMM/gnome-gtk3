use v6;
#use lib '../gnome-gobject/lib';

use NativeCall;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::MenuBar;
use Gnome::Gtk3::Menu;
#use Gnome::Gtk3::MenuShell;
use Gnome::Gtk3::MenuItem;
use Gnome::Gtk3::MenuButton;

use Gnome::N::X;
#Gnome::N::debug(:on);

# This example is translated from C shown on the site at
# https://developer.gnome.org/gtk-tutorial/stable/x1577.html

my $t0 = now;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# A callback handler class to respond to the 'close application event'
class AppSignalHandlers {

  method menuitem_response ( :widget($menu-item) --> Int ) {
    note "Entry '$menu-item.get-label()' selected";

    1
  }

  method menubutton-press (
    :widget($menu-button), :handler-arg0($event) --> Int
  ) {
    note "Button pressed";

    1
  }

  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}

# Initialize the callback handler class
my AppSignalHandlers $ash .= new;

#my Gnome::GObject::Type $type .= new;
#my int32 $menu-shell-gtype = $type.g_type_from_name('GtkMenuShell');

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('A window with a menu');
$top-window.set-size-request( 300, 300);

my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

my Gnome::Gtk3::Menu $menu = make-menubar-menu( $ash, 'menuitem_response');

# This is the root menu, and will be the label displayed on the menu bar.
# There won't be a signal handler attached, as it only pops up the rest
# of the menu when pressed.
my Gnome::Gtk3::MenuItem $root-menu .= new(:label('Root Menu'));
$root-menu.set-submenu($menu);

my Gnome::Gtk3::MenuBar $menu-bar .= new;
$grid.gtk_grid_attach( $menu-bar, 0, 0, 1, 1);
$menu-bar.gtk-menu-shell-append($root-menu);

# In the C example a plain button is used. Here I'll try a button
# specially made to show a popup menu
my Gnome::Gtk3::MenuButton $menu-button .= new;
$grid.gtk-grid-attach( $menu-button, 0, 1, 1, 1);
$menu-button.set-label('press me');

# Create a new menu and attach to the button
my Gnome::Gtk3::Menu $popup-menu = make-menubutton-menu(
  $ash, 'menuitem_response'
);
$menu-button.set-popup($popup-menu);

#$menu-button.register-signal( $ash, 'menubutton-press', 'event');




# Register the exit-program() method for the event
$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.gtk-main;


# Create menu for the menu bar
sub make-menubar-menu (
  AppSignalHandlers $ash, Str $handler-name
  --> Gnome::Gtk3::Menu
) {
  my Gnome::Gtk3::Menu $menu .= new;

  #note "native menu: $menu()";
  #note "menu shell gtype code: $menu-shell-gtype";
  #note "cast to: ", $type.check-instance-cast( $menu(), $menu-shell-gtype);

  #my Gnome::Gtk3::MenuShell $menu-shell .= new(
  #  :widget($type.check-instance-cast( $menu(), $menu-shell-gtype))
  #);

  # Next we make a little loop that makes three menu-entries for "test-menu".
  # Notice the call to gtk_menu_shell_append.  Here we are adding a list of
  # menu items to our menu.  Normally, we'd also catch the "clicked" signal on
  # each of the menu items and setup a callback for it, but it's omitted here
  # to save space.
  for 1..3 -> $i {

    # Create a new menu-item with a name ...
    my Gnome::Gtk3::MenuItem $menu-item .= new(:label("Menu entry - $i"));

    # ... and add it to the menu.
    $menu.gtk-menu-shell-append($menu-item);

    # Do something interesting when the menuitem is selected
    $menu-item.register-signal( $ash, $handler-name, 'activate');
  }

  $menu
}

# Create menu for the popup menu on the menu button
sub make-menubutton-menu (
  AppSignalHandlers $ash, Str $handler-name
  --> Gnome::Gtk3::Menu
) {
  my Gnome::Gtk3::Menu $menu .= new;

  #note "native menu: $menu()";
  #note "menu shell gtype code: $menu-shell-gtype";
  #note "cast to: ", $type.check-instance-cast( $menu(), $menu-shell-gtype);

  #my Gnome::Gtk3::MenuShell $menu-shell .= new(
  #  :widget($type.check-instance-cast( $menu(), $menu-shell-gtype))
  #);

  # Next we make a little loop that makes three menu-entries for "test-menu".
  # Notice the call to gtk_menu_shell_append.  Here we are adding a list of
  # menu items to our menu.  Normally, we'd also catch the "clicked" signal on
  # each of the menu items and setup a callback for it, but it's omitted here
  # to save space.
  for 1..3 -> $i {

    # Create a new menu-item with a name ...
    my Gnome::Gtk3::MenuItem $menu-item .= new(:label("Popup entry - $i"));

    # ... and add it to the menu.
    $menu.gtk-menu-shell-append($menu-item);

    # Do something interesting when the menuitem is selected
    $menu-item.register-signal( $ash, $handler-name, 'activate');

    # Need to do this explicitly because `$top-window.show-all()` does not
    # see this menu, perhaps because the menu button creates the menu
    # later when pressed.
    $menu-item.gtk-widget-show;
  }

  $menu
}
