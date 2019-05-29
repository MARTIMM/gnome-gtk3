use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilefilter.h
# https://developer.gnome.org/gtk3/stable/GtkFileFilter.html
unit class Gnome::Gtk3::FileFilter:auth<github:MARTIMM>;
also is Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
enum GtkFileFilterFlags is export (
  GTK_FILE_FILTER_FILENAME     => 0x01,
  GTK_FILE_FILTER_URI          => 0x02,
  GTK_FILE_FILTER_DISPLAY_NAME => 0x04,
  GTK_FILE_FILTER_MIME_TYPE    => 0x08,
);

#-------------------------------------------------------------------------------
class GtkFileFilterInfo is repr('CStruct') is export {
  # contains: flags indicating which of the following fields need are filled
  has int32 $.contains;          # bits from GtkFileFilterFlags
  has Str $.filename;
  has Str $.uri;
  has Str $.display_name;
  has Str $.mime_type;
}

#-------------------------------------------------------------------------------
sub gtk_file_filter_new ( )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_set_name ( N-GObject $filter, Str $name)
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_get_name ( N-GObject $filter )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_mime_type ( N-GObject $filter, Str $mime_type)
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_pattern ( N-GObject $filter, Str $pattern )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_pixbuf_formats ( N-GObject $filter )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_custom (
  N-GObject $filter, int32 $filter-flags-needed,
  &filter-func ( GtkFileFilterInfo $filter_info, OpaquePointer),
  OpaquePointer, &notify ( OpaquePointer )
) is native(&gtk-lib)
  { * }

sub gtk_file_filter_get_needed ( N-GObject $filter )
  returns int32 # GtkFileFilterFlags
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_filter ( N-GObject $filter, int32 $filter_info )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::FileFilter';

  if ? %options<empty> {
    self.native-gobject(gtk_file_filter_new());
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
  try { $s = &::("gtk_file_filter_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
