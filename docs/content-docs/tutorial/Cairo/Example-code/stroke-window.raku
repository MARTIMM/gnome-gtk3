use v6.d;

use Gnome::Cairo::ImageSurface:api<1>;
use Gnome::Cairo::Types:api<1>;
use Gnome::Cairo::Enums:api<1>;
use Gnome::Cairo;

use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::DrawingArea:api<1>;

use Gnome::N::GlibToRakuTypes:api<1>;

#-------------------------------------------------------------------------------
class DA {
  #-----------------------------------------------------------------------------
  method draw-callback ( cairo_t $no-context --> gboolean ) {
    with my Gnome::Cairo $context .= new(:native-object($no-context)) {
      .set-line-width(10);
      .set-source-rgba( 0, 0, 0.4, 1);
      .rectangle( 20, 20, 80, 80);
      .stroke;
    }

    false;
  }

  #-----------------------------------------------------------------------------
  method quit ( ) {
    Gnome::Gtk3::Main.new.quit;
  }

  #-----------------------------------------------------------------------------
  method shoot (
    Gnome::Gtk3::DrawingArea:D $drawing-area, Str:D $snapshot-file
  ) {
    my Int $width = $drawing-area.get-allocated-width;
    my Int $height = $drawing-area.get-allocated-height;
    my Gnome::Cairo::ImageSurface $surface .= new(
      :format(CAIRO_FORMAT_ARGB32), :$width, :$height
    );

    my Gnome::Cairo $cairo-context .= new(:$surface);
    $drawing-area.draw($cairo-context);

    $surface.write-to-png($snapshot-file);
  }
}

#-------------------------------------------------------------------------------
my DA $da .= new;

with my Gnome::Gtk3::DrawingArea $drawing-area .= new {
  .set-size-request( 120, 120);
  .register-signal( $da, 'draw-callback', 'draw');
}

with my Gnome::Gtk3::Window $window .= new {
  .set-title('stroke');
  .register-signal( DA.new, 'quit', 'destroy');
  .add($drawing-area);
  .show-all;
}

# Take a snapshot
$da.shoot( $drawing-area, 'stroke-window.png');

Gnome::Gtk3::Main.new.main;
