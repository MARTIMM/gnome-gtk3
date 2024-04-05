use v6.d;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-cairo/lib';

use Gnome::Cairo::ImageSurface:api<1>;
use Gnome::Cairo::Pattern:api<1>;
use Gnome::Cairo;
use Gnome::Cairo::Types:api<1>;
use Gnome::Cairo::Enums:api<1>;

use Gnome::Gdk3::Pixbuf:api<1>;

#-------------------------------------------------------------------------------
my Gnome::Cairo::ImageSurface $surface;
my Gnome::Cairo $context;

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :120width, :120height);
with $context .= new(:$surface) {
  .scale( 120, 120);

  .set-source-rgb( 0, 0, 0);
  .move-to( 0, 0);
  .line-to( 1, 1);
  .move-to( 1, 0);
  .line-to( 0, 1);
  .set-line-width( 0.2);
  .stroke;

  .rectangle( 0, 0, 0.5, 0.5);
  .set-source-rgba( 1, 0, 0, 0.80);
  .fill;

  .rectangle( 0, 0.5, 0.5, 0.5);
  .set-source-rgba( 0, 1, 0, 0.60);
  .fill;

  .rectangle( 0.5, 0, 0.5, 0.5);
  .set-source-rgba( 0, 0, 1, 0.40);
  .fill;
}

$surface.write-to-png('source-color.png');

#-------------------------------------------------------------------------------
my Gnome::Cairo::Pattern $radpat .= new(
  :radial( 0.25, 0.25, 0.1,  0.5, 0.5, 0.5)
);

with $radpat {
  .pattern-add-color-stop-rgb( 0, 1.0, 0.8, 0.8);
  .pattern-add-color-stop-rgb( 1, 0.9, 0.0, 0.0);
}

my Gnome::Cairo::Pattern $linpat .= new(
  :linear( 0.25, 0.35, 0.75, 0.65)
);

with $linpat {
  .pattern-add-color-stop-rgba( 0.00, 1, 1, 1, 0);
  .pattern-add-color-stop-rgba( 0.25, 0, 1, 0, 0.5);
  .pattern-add-color-stop-rgba( 0.50, 1, 1, 1, 0);
  .pattern-add-color-stop-rgba( 0.75, 0, 0, 1, 0.5);
  .pattern-add-color-stop-rgba( 1.00, 1, 1, 1, 0);
}

$surface .= new(
  :format(CAIRO_FORMAT_ARGB32), :120width, :120height
);

with $context .= new(:$surface) {
  .scale( 120, 120);

  loop ( my Int $i = 1; $i < 10; $i++ ) {
    loop ( my Int $j = 1; $j < 10; $j++ ) {
      .rectangle( $i/10.0 - 0.04, $j/10.0 - 0.04, 0.08, 0.08);
    }
  }

  .set-source($radpat);
  .fill;

  .rectangle( 0.0, 0.0, 1, 1);
  .set-source($linpat);
  .fill;
}

$surface.write-to-png('source-gradient.png');

#`{{ TODO not yet available on my system
#-------------------------------------------------------------------------------
my Gnome::Gdk3::Pixbuf $pixbuf .= new(
  :file<t/Data/gtk-raku.png>, :120width, :120height
);

$surface .= new(
  :format(CAIRO_FORMAT_ARGB32), :120width, :120height
);
with $context .= new(:$surface) {
  .set-source-pixbuf( $pixbuf, 10, 10);

  .scale( 120, 120);

  .set-line-width(0.1);
  .set-source-rgb( 0, 0, 0);
  .rectangle( 0.25, 0.25, 0.5, 0.5);
  .stroke;
}

$surface.write-to-png('source-image.png');
}}
