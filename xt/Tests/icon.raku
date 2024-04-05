use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
#use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Image:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::IconTheme:api<1>;
use Gnome::Gtk3::IconInfo:api<1>;

use Gnome::Gio::File:api<1>;
use Gnome::Gio::FileIcon:api<1>;
use Gnome::Gio::EmblemedIcon:api<1>;

use Gnome::Gdk3::Pixbuf:api<1>;

use Gnome::Glib::Error:api<1>;

#-------------------------------------------------------------------------------
class SH {
  method exit ( ) {
    Gnome::Gtk3::Main.new.quit;
  }
}

my SH $sh .= new;


#-------------------------------------------------------------------------------
my Gnome::Glib::Error() $e;
my Gnome::Gio::File $file .= new(:path<xt/data/bullseye.jpg>);
my Gnome::Gio::FileIcon $gicon .= new(:$file);
my Gnome::Gtk3::Image $i1 .= new( :$gicon, :size(GTK_ICON_SIZE_DIALOG));

my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
my Gnome::Gdk3::Pixbuf() $pixbuf;
$pixbuf = $icon-theme.load-icon( 'server-database', 48, 0);
unless $pixbuf.is-valid {
  $e = $icon-theme.last-error;
  die "Couldn’t load icon: " ~ $e.message;
}
my Gnome::Gtk3::Image $i2 .= new(:pixbuf($pixbuf));

$pixbuf = $icon-theme.load-icon-for-scale( 'gtk-yes', 48, 6, 0);
unless $pixbuf.is-valid {
  $e = $icon-theme.last-error;
  die "Couldn’t load icon: " ~ $e.message;
}
my Gnome::Gtk3::Image $i3 .= new(:pixbuf($pixbuf));



with my Gnome::Gtk3::Grid $grid .= new {
  .set-border-width(20);
  .attach( $i1, 1, 1, 1, 1);
  .attach( $i2, 1, 2, 1, 1);
  .attach( $i3, 1, 3, 1, 1);
}

with my Gnome::Gtk3::Window $w .= new {
  .add($grid);
  .register-signal( $sh, 'exit', 'destroy');
  .show-all;
}

Gnome::Gtk3::Main.new.main;
