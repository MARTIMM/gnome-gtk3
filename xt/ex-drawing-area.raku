use v6.d;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::DrawingArea;
use Gnome::Gtk3::StyleContext;

use Gnome::Cairo;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;

use Gnome::Gdk3::Events;
use Gnome::Gdk3::RGBA;

use Gnome::N::GlibToRakuTypes;


class Events {
	method exit {
		Gnome::Gtk3::Main.new.quit;
	}
}

class DA {
  method draw-callback (
    cairo_t $cr-no, Gnome::Gtk3::DrawingArea :_widget($area)
  ) {
    my UInt ( $width, $height);
    my Gnome::Gtk3::StyleContext $context .= new(
      :native-object($area.get-style-context)
    );
    $width = $area.get-allocated-width;
    $height = $area.get-allocated-height;

    my Gnome::Cairo $cr .= new(:native-object($cr-no));
    $context.render-background( $cr, 0, 0, $width, $height);

    $cr.cairo-arc(
      $width/2.0, $height/2.0, min( $width, $height)/2.0, 0, 2.0 * π
    );

    my N-GdkRGBA $color-no .= new;
    $context.get-color( $context.get-state, $color-no);
    $cr.set-source-rgba(
      $color-no.red, $color-no.green, $color-no.blue, $color-no.alpha
    );

    $cr.cairo-fill;

    False;
  }
}


given my Gnome::Gtk3::DrawingArea $drawing-area .= new {
  .set-size-request( 100, 100);
  .register-signal( DA.new, 'draw-callback', 'draw');
}

given my Gnome::Gtk3::Window $window .= new {
  .add($drawing-area);
  .register-signal( Events.new, 'exit', 'destroy');
  .show-all;
}

Gnome::Gtk3::Main.new.main;
