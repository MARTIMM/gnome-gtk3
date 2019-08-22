use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkimage.h
# https://developer.gnome.org/gtk3/stable/GtkImage.html
unit class Gnome::Gtk3::Image:auth<github:MARTIMM>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
enum GtkImageType  is export <
  GTK_IMAGE_EMPTY
  GTK_IMAGE_PIXBUF
  GTK_IMAGE_STOCK
  GTK_IMAGE_ICON_SET
  GTK_IMAGE_ANIMATION
  GTK_IMAGE_ICON_NAME
  GTK_IMAGE_GICON
  GTK_IMAGE_SURFACE
>;

#-------------------------------------------------------------------------------
sub gtk_image_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_image_new_from_file ( Str $filename )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# image is a GtkImage
sub gtk_image_set_from_file ( N-GObject $image, Str $filename)
  is native(&gtk-lib)
  { * }

sub gtk_image_clear ( N-GObject $image )
  is native(&gtk-lib)
  { * }

# GtkImageType is an enum -> uint32
sub gtk_image_get_storage_type ( N-GObject $image )
  returns uint32
  is native(&gtk-lib)
  { * }

sub gtk_image_get_pixbuf ( N-GObject $image )
  returns OpaquePointer
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Image';

  if %options<filename>.defined {
    self.native-gobject(gtk_image_new_from_file(%options<filename>));
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_image_new());
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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_image_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
