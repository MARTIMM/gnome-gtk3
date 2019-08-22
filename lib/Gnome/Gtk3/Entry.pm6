use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkentry.h
# https://developer.gnome.org/gtk3/stable/GtkEntry.html
unit class Gnome::Gtk3::Entry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
sub gtk_entry_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_entry_get_text ( N-GObject $entry )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_text ( N-GObject $entry, Str $text )
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_visibility ( N-GObject $entry, int32 $visible )
  is native(&gtk-lib)
  { * }

# hints is an enum with type GtkInputHints -> int
# The values are defined in Enums.pm6
sub gtk_entry_set_input_hints ( N-GObject $entry, uint32 $hints )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
#submethod BUILD ( ) {
#  self.native-gobject(gtk_entry_new);
#}
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<activate backspace copy-clipboard cut-clipboard insert-emoji
            paste-clipboard toggle-overwrite
           >,
    :nativewidget<populate-popup>,
    :GtkDeleteType<delete-from-cursor>,
    :iconEvent<icon-press icon-release>,
    :str<insert-at-cursor preedit-changed>,
    :intbool<move-cursor>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Entry';

  if ? %options<empty> {
    self.native-gobject(gtk_entry_new());
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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
