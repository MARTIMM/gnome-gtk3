use v6.d;

#use lib '/home/marcel/Languages/Raku/Projects/gnome-gtk3/lib';

use Gnome::Cairo::ImageSurface;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;
use Gnome::Cairo;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::DrawingArea;

use Gnome::N::GlibToRakuTypes;

class DA {

  method draw-callback (
    cairo_t $no-context, Gnome::Gtk3::DrawingArea :_widget($area)
    --> gboolean
  ) {

    my UInt ( $width, $height);
    $width = $area.get-allocated-width;
    $height = $area.get-allocated-height;

    with my Gnome::Cairo $context .= new(:native-object($no-context)) {
      .set-line-width(10);
      .set-source-rgba( 0, 0, 0.4, 1);
      .rectangle( 20, 20, 80, 80);
      .stroke;
    }

    0;
  }

  method quit ( ) {
    Gnome::Gtk3::Main.new.quit;
  }
}


with my Gnome::Gtk3::DrawingArea $drawing-area .= new {
  .set-size-request( 120, 120);
  .register-signal( DA.new, 'draw-callback', 'draw');
}

with my Gnome::Gtk3::Window $window .= new {
  .set-title('stroke');
  .register-signal( DA.new, 'quit', 'destroy');
  .add($drawing-area);
  .show-all;
}

#`{{
my Gnome::Cairo::ImageSurface $surface .= new(
  :format(CAIRO_FORMAT_ARGB32), :width(120), :height(120)
);

with my Gnome::Cairo $context .= new(:$surface) {
  .set-line-width(0.1);
  .set-source-rgb( 0, 0, 0);
  .rectangle( 0.25, 0.25, .5, .5);
  .stroke;
      .set-line-width(10);
      .set-source-rgba( 0, 0, 0.4, 1);
      .rectangle( 20, 20, 80, 80);
      .stroke;
}

$surface.write-to-png('stroke.png');
}}

Gnome::Gtk3::Main.new.main;
