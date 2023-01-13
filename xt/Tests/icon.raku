use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
#use Gnome::Gtk3::Button;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;

use Gnome::Gio::File;
use Gnome::Gio::FileIcon;
use Gnome::Gio::EmblemedIcon;

#use Gnome::Gdk3::Pixbuf;

#-------------------------------------------------------------------------------
class SH {
  method exit ( ) {
    Gnome::Gtk3::Main.new.quit;
  }
}

my SH $sh .= new;


#-------------------------------------------------------------------------------
my Gnome::Gio::File $file .= new(:path<xt/data/bullseye.jpg>);
my Gnome::Gio::FileIcon $gicon .= new(:$file);
my Gnome::Gtk3::Image $i .= new( :$gicon, :size(GTK_ICON_SIZE_DIALOG));
with my Gnome::Gtk3::Grid $grid .= new {
  .set-border-width(20);
  .attach( $i, 1, 1, 1, 1);
}

with my Gnome::Gtk3::Window $w .= new {
  .add($grid);
  .register-signal( $sh, 'exit', 'destroy');
  .show-all;
}

Gnome::Gtk3::Main.new.main;
