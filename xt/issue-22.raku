use v6.d;

use Gnome::N::GlibToRakuTypes;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;

class Handlers {
	method on-close ( N-GdkEvent $event --> gboolean ) {
		say 'staying open: ', GdkEventType($event.event-any.type);
		1;
	}
}

my Gnome::Gtk3::Main $m .= new;
my Handlers $handler .= new;

given Gnome::Gtk3::Window.new {
  .set-size-request( 600, 300);
  .show-all;
  .register-signal($handler, 'on-close', 'delete-event');
}

$m.gtk-main;
