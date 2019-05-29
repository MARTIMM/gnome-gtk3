use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextview.h
# https://developer.gnome.org/gtk3/stable/GtkTextView.html
unit class Gnome::Gtk3::TextView:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
sub gtk_text_view_new ( )
  returns N-GObject # buffer
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_buffer ( N-GObject $view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_editable ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_editable ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_cursor_visible ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_cursor_visible ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_monospace ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_monospace ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<backspace copy-clipboard cut-clipboard insert-emoji
            paste-clipboard set-anchor toggle-cursor-visible
            toggle-overwrite
           >,
    :nativewidget<populate-popup>,
    :GtkDeleteType<delete-from-cursor>,
    :GtkTextExtendSelection<extend-selection>,
    :str<insert-at-cursor preedit-changed>,
    :mvintbool<move-cursor>,
    :scroll<move-viewport>,
    :bool<select-all>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextView';

  if ? %options<empty> {
    self.native-gobject(gtk_text_view_new());
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
  try { $s = &::("gtk_text_view_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
