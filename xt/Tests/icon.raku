use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
#use Gnome::Gtk3::Button;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::IconTheme;
use Gnome::Gtk3::IconInfo;

use Gnome::Gio::File;
use Gnome::Gio::FileIcon;
use Gnome::Gio::EmblemedIcon;

use Gnome::Gdk3::Pixbuf;

use Gnome::Glib::Error;

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
