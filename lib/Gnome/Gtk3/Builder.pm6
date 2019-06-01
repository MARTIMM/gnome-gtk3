use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::Builder

=SUBTITLE

  unit class Gnome::Gtk3::Builder;
  also is Gnome::GObject::Object;

=head2 Builder — Build an interface from an XML UI definition

=head1 Synopsis

  my Gnome::Gtk3::Builder $builder .= new(:filename($ui-file));
  my Gnome::Gtk3::Button $start-button .= new(:build-id<startButton>);

Note: C<GTK::Glade> is a package build around this builder class. That package is able to automatically register the signals defined in the UI file and connect them to the handlers defined in a users supplied class.
=end pod
# ==============================================================================
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
use Gnome::Gdk3::Screen;
use Gnome::Gtk3::Main;
#use Gnome::Glib::GError;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbuilder.h
# https://developer.gnome.org/gtk3/stable/GtkBuilder.html
unit class Gnome::Gtk3::Builder:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

# ==============================================================================
=begin pod
=head1 Methods

=head2 gtk_builder_new

  method gtk_builder_new ( --> N-GObject )

Creates a new builder object
=end pod
sub gtk_builder_new ()
  returns N-GObject       # GtkBuilder
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] new_from_file

  method gtk_builder_new_from_file ( Str $glade-ui-file --> N-GObject )

Creates a new builder object and loads the gui design into the builder
=end pod
sub gtk_builder_new_from_file ( Str $glade-ui )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] new_from_string

  method gtk_builder_new_from_string (
    Str $glade-ui-text, uint32 $length
    --> N-GObject
  )

Creates a new builder object and takes the gui design from the text argument
=end pod
sub gtk_builder_new_from_string ( Str $glade-ui, uint32 $length)
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] add_from_file

  method gtk_builder_add_from_file ( Str $glade-ui-file --> int32 )

Add another gui design from a file. The result 0 or 1 is returned. 1 means ok.
=end pod
sub gtk_builder_add_from_file (
  N-GObject $builder, Str $glade-ui, OpaquePointer
#  N-GObject $builder, Str $glade-ui, N-GError $error is rw
) returns int32         # 0 or 1, 1 = ok, 0 look into GError
  is native(&gtk-lib)
    { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] add_from_string

  method gtk_builder_add_from_string (
    Str $glade-ui-text, uint32 $length
    --> int32
  )

Add another gui design from the text argument. The result 0 or 1 is returned. 1 means ok.
=end pod
sub gtk_builder_add_from_string (
  N-GObject $builder, Str $glade-ui, uint32 $length, OpaquePointer
#  N-GObject $builder, Str $glade-ui, uint32 $size, N-GError $error is rw
) returns int32         # 0 or 1, 1 = ok, 0 look into GError
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] get_object

  method gtk_builder_get_object ( Str $object-id --> N-GObject )

Returns a native widget searched for by its id. See also L<GOBject :build-id>.
=end pod
sub gtk_builder_get_object (
  N-GObject $builder, Str $object-id
) returns N-GObject   # is GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_builder_] get-type-from-name

  method gtk_builder_get_type_from_name ( Str $type-name --> int32 )

Looks up a type by name. I below example it is shown that this is also accomplished using C<GType>. Furthermore, the codes are not constants! Every new run produces a different gtype code.

  my Gnome::Gtk3::Builder $builder .= new(:filename<my-ui.glade>);
  my Int $gtype = $builder.get-type-from-name('GtkButton');
  my Gnome::Glib::GType $t .= new;
  say $t.g-type-name($gtype);                     # GtkButton
  say $t.from-name('GtkButton');                  # $gtype
  say $t.g-type-name($t.g-type-parent($gtype));   # GtkBin

  #"Depth = 6: Button, Bin, Container, Widget, GInitiallyUnowned, GObject";
  say $t.g-type-depth($gtype);                    # 6

=end pod
sub gtk_builder_get_type_from_name ( N-GObject $builder, Str $type_name )
  returns int32         # is GType
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=begin pod
=head2 new

  multi method new ( Str :$filename )

Create builder object and load gui design.

  multi method new ( Str :$string )

Same as above but read the design from the string.

  multi method new ( Bool :$empty )

Create an empty builder.
=end pod
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Builder';

  if ? %options<filename> {
    self.native-gobject(gtk_builder_new_from_file(%options<filename>));
  }

  elsif ? %options<string> {
    self.native-gobject(
      gtk_builder_new_from_string( %options<string>, %options<string>.chars)
    );
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_builder_new());
  }

#TODO No widget or build-id for a builder!
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

  self.set-builder(self);
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_builder_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TODO check if these are needed
multi method add-gui ( Str:D :$filename! ) {

  my $g := self;
  my Int $e-code = gtk_builder_add_from_file( $g(), $filename, Any);
  die X::Gnome.new(:message("Error adding file '$filename' to the Gui"))
      if $e-code == 0;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
multi method add-gui ( Str:D :$string! ) {

  my $g := self;
  my Int $e-code = gtk_builder_add_from_string(
    $g(), $string, $string.chars, Any
  );

  die X::Gnome.new(:message("Error adding xml text to the Gui"))
      if $e-code == 0;
}
