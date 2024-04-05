use v6.d;

#use Gnome::Cairo;
use Gnome::Cairo::Types:api<1>;

use Gnome::Gtk3::DrawingArea:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Fixed:api<1>;

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
