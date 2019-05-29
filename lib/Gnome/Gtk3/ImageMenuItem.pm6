use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::MenuItem;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkimagemenuitem.h
# https://developer.gnome.org/gtk3/stable/GtkImageMenuItem.html
unit class Gnome::Gtk3::ImageMenuItem:auth<github:MARTIMM>;
also is Gnome::Gtk3::MenuItem;

#-------------------------------------------------------------------------------
sub gtk_image_menu_item_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ImageMenuItem';

  if ? %options<empty> {
    self.native-gobject(gtk_image_menu_item_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_image_menu_item_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
