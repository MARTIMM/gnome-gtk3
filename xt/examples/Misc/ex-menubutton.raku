use v6.d;

use Gnome::Gtk3::Main;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::MenuButton;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Popover;

use Gnome::Gio::Menu;
use Gnome::Gio::MenuItem;
use Gnome::Gio::SimpleAction;
use Gnome::Gio::SimpleActionGroup;

use Gnome::N::N-GObject;

class HC {
  method exit ( ) {
    Gnome::Gtk3::Main.quit;
  }

  method set-toolbar ( N-GObject $n-parameter ) {
    note 'set toolbar';
  }

  method set-statusbar ( N-GObject $n-parameter ) {
    note 'set statusbar';
  }
}

my HC $hc .= new;

# make window
my Gnome::Gtk3::Window $window .= new;
$window.set-title('window with a menu button');
$window.set-size-request( 600, 400);
$window.register-signal( $hc, 'exit', 'destroy');

my Gnome::Gtk3::Grid $grid .= new;
$window.add($grid);
$grid.set-border-width(20);

# make two menu buttons and place in the grid
my Gnome::Gtk3::MenuButton $menu-button1 .= new;
$menu-button1.set-direction(GTK_ARROW_RIGHT);
$menu-button1.set-valign(GTK_ALIGN_START);
$menu-button1.set-use-popover(False);
$grid.attach( $menu-button1, 0, 0, 1, 1);

my Gnome::Gtk3::MenuButton $menu-button2 .= new;
$menu-button2.set-direction(GTK_ARROW_LEFT);
$menu-button2.set-halign(GTK_ALIGN_END);
$menu-button2.set-use-popover(False);
$grid.attach( $menu-button2, 1, 0, 1, 1);

# Make a section menu with 2 items in it; Toolbar and Statusbar.
# refer to actions from the 'local' action group
my Gnome::Gio::Menu $section .= new;
$section.append( 'Toolbar', 'local.set-toolbar');
$section.append( 'Statusbar', 'local.set-statusbar');

# make the top menu and append 1st section made above
my Gnome::Gio::Menu $menu .= new;
$menu.append-item(Gnome::Gio::MenuItem.new(:section($section)));
$section.clear-object;

# attach menus to the buttons
$menu-button1.set-menu-model($menu);
$menu-button2.set-menu-model($menu);

# create actions for the menu entries
my Gnome::Gio::SimpleActionGroup $sa-group .= new;
my Gnome::Gio::SimpleAction $simple-action;

# action for the toolbar entry
$simple-action .= new(:name<set-toolbar>);
$simple-action.set-enabled(True);
$simple-action.register-signal( $hc, 'set-toolbar', 'activate');
$sa-group.add-action($simple-action);
$simple-action.clear-object;

# action for the statusbar entry
$simple-action .= new(:name<set-statusbar>);
$simple-action.set-enabled(True);
$simple-action.register-signal( $hc, 'set-statusbar', 'activate');
$sa-group.add-action($simple-action);
$simple-action.clear-object;

# add the actions in the 'local' group
$menu-button1.insert-action-group( 'local', $sa-group);
$menu-button2.insert-action-group( 'local', $sa-group);

$window.show-all;

Gnome::Gtk3::Main.main;
