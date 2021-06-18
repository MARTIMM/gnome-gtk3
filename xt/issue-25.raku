use v6.d;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::DrawingArea;
use Gnome::Gdk3::Events;
use Gnome::Cairo;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;
use Gnome::N::GlibToRakuTypes;

class Events {
	method exit {
		Gnome::Gtk3::Main.new.quit;
	}
}

class DA is Gnome::Gtk3::DrawingArea {
	submethod new (|c) {
		self.bless(:GtkDrawingArea, |c);
	}
	submethod BUILD ( ) {
		self.register-signal( self, 'on-draw', 'draw');
		self.set-hexpand(True);
		self.set-vexpand(True);
	}

	my gdouble $zero = 0e0;
	method on-draw(cairo_t $cr) {
		my Gnome::Cairo $surface .= new(:native-object($cr));

		given $surface {
			.set-source-rgb($zero, $zero, $zero);
			.set-line-width(2);
			.move-to(10,10);
			.line-to(30, 23);
			.stroke;
		}
	}
}

my Gnome::Gtk3::Window $w .= new;
my Gnome::Gtk3::Grid $g .= new;
my DA $da .= new;
my Events $e .= new;

$g.attach($da, 0, 0 , 1, 1);
$w.add($g);
$w.register-signal($e, 'exit', 'destroy');
$w.show-all;
Gnome::Gtk3::Main.new.main;
