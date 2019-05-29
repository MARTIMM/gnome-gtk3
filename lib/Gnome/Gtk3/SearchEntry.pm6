use v6;

use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Entry;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtksearchentry.h
# https://developer.gnome.org/gtk3/stable/GtkSearchEntry.html
unit class Gnome::Gtk3::SearchEntry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Entry;

# ==============================================================================
sub gtk_search_entry_new ( )
  returns N-GObject       # GtkWidget
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<next-match previous-match search-changed stop-search>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::SearchEntry';

  if ? %options<empty> {
    self.native-gobject(gtk_search_entry_new());
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
  try { $s = &::("gtk_search_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
