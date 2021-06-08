use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Grid;
#use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::DrawingArea;

use Gnome::Gdk3::Events;
use Gnome::Gdk3::Types;

use Gnome::N::GlibToRakuTypes;

class Events {
	method on-scroll-event(N-GdkEventScroll $event --> gboolean) {
		say 'scrolled the mouse wheel at ', $event.x, ' ', $event.y;
	}
	method on-any-button-clicked(N-GdkEventButton $event) {
		say 'button clicked at ', $event.x, ' ', $event.y;
	}
}

my Gnome::Gtk3::Window $w .= new;
my Gnome::Gtk3::Grid $g .= new;
#my Gnome::Gtk3::EventBox $eb .= new;
my Gnome::Gtk3::DrawingArea $da .= new;

$da.set-hexpand(True);
$da.set-vexpand(True);
my Events $e .= new;

#$eb.add-events(GDK_SCROLL_MASK);
#$eb.register-signal($e, 'on-scroll-event', 'scroll-event');
#$eb.register-signal($e, 'on-any-button-clicked', 'button-press-event');
#$eb.add($da);
#$g.attach($eb, 0, 0 , 1, 1);

$da.add-events(GDK_SCROLL_MASK +| GDK_BUTTON_PRESS_MASK);
$da.register-signal($e, 'on-scroll-event', 'scroll-event');
$da.register-signal($e, 'on-any-button-clicked', 'button-press-event');
$g.attach($da, 0, 0 , 1, 1);

$w.add($g);
$w.show-all;
Gnome::Gtk3::Main.new.main;
