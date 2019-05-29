use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktexttagtable.h
# https://developer.gnome.org/gtk3/stable/GtkTextTagTable.html
unit class Gnome::Gtk3::TextTagTable:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
sub gtk_text_tag_table_new ( )
  returns N-GObject         # GtkTextTagTable
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :nativewidget<tag-added tag-removed>,
    :tagbool<tag-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextTagTable';

  if ? %options<empty> {
    self.native-gobject(gtk_text_tag_table_new());
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
  try { $s = &::("gtk_text_tag_table_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
