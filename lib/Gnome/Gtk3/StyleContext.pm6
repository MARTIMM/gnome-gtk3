use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
use Gnome::Gdk::Screen;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkstylecontext.h
# https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
unit class Gnome::Gtk3::StyleContext:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
enum GtkStyleProviderPriority is export (
  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK => 1,
  GTK_STYLE_PROVIDER_PRIORITY_THEME => 200,
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS => 400,
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION => 600,
  GTK_STYLE_PROVIDER_PRIORITY_USER => 800,
);

#-------------------------------------------------------------------------------
sub gtk_style_context_new ( --> N-GObject )
  is native(&gtk-lib)
  { * }

# special method to cope with automatically inserted first argument caused by
# its type, thinking that would be a GtkStyleContext type but it is a GdkScreen
# type. Sometimes smart thinking goes the wrong way. By having the argument list
# as '|c' the first argument is not recognized and will be kept the same.
sub gtk_style_context_add_provider_for_screen( |c ) is inlinable {
  hidden__gtk_style_context_add_provider_for_screen(|c);
}
sub hidden__gtk_style_context_add_provider_for_screen (
  N-GObject $screen, int32 $provider, int32 $priority
) is native(&gtk-lib)
  is symbol('gtk_style_context_add_provider_for_screen')
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::StyleContext';

  if ? %options<empty> {
    self.native-gobject(gtk_style_context_new());
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
  try { $s = &::("gtk_style_context_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
