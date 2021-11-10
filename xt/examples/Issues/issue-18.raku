use v6.d;

#use Gnome::Cairo;
use Gnome::Cairo::Types;

use Gnome::Gtk3::DrawingArea;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Fixed;

my Gnome::Gtk3::Main $m .= new;

class AppSignalHandlers {
	method exit() {
    $m.main-quit;
  }

	method draw( cairo_t $no --> Int ) {
    say 'drew';
  }
}


my Gnome::Gtk3::Window $top-window .= new;
my Gnome::Gtk3::Fixed $fixed .= new;
my Gnome::Gtk3::DrawingArea $draw .= new;

my AppSignalHandlers $ash .= new;

$top-window.register-signal( $ash, 'exit', 'destroy');
$draw.register-signal( $ash, 'draw', 'draw');

$top-window.add($fixed);
$fixed.put( $draw, 0,0);

$top-window.show-all;
$m.main;
