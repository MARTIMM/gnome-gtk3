use v6;
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Glib::List;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcontainer.h
# https://developer.gnome.org/gtk3/stable/GtkContainer.html
unit class Gnome::Gtk3::Container:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
sub gtk_container_add ( N-GObject $container, N-GObject $widget )
  is native(&gtk-lib)
  { * }

sub gtk_container_get_border_width ( N-GObject $container )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_container_get_children ( N-GObject $container )
  returns N-GList
  is native(&gtk-lib)
  { * }

sub gtk_container_set_border_width (
  N-GObject $container, int32 $border_width
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<check-resize>,
    :nativewidget<add remove set-focus-child>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Container';

  if ? %options<widget> || %options<build-id> {
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
  try { $s = &::("gtk_container_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
