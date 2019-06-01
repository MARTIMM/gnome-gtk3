use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
#use Gnome::Gdk3::Screen;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcssprovider.h
# https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
unit class Gnome::Gtk3::CssProvider:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
sub gtk_css_provider_new ( )
  returns N-GObject       # GtkCssProvider
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_get_named ( Str $name, Str $variant )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $css-file, OpaquePointer
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :parseerr<parsing-error>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CssProvider';

  if ? %options<empty> {
    self.native-gobject(gtk_css_provider_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
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
  try { $s = &::("gtk_css_provider_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
