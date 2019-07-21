use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ColorChooserDialog

=SUBTITLE A dialog for choosing colors

=head1 Description


The C<Gnome::Gtk3::ColorChooserDialog> widget is a dialog for choosing
a color. It implements the C<Gnome::Gtk3::ColorChooser> interface.

Since: 3.4



=head2 See Also

C<Gnome::Gtk3::ColorChooser>, C<Gnome::Gtk3::Dialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooserDialog;
  also is Gnome::Gtk3::Dialog;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooserDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    # ... :type<signame>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::LIBRARYMODULE';

  # process all named arguments
  if ? %options<empty> {
    # self.native-gobject(gtk_color_chooser_dialog_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkColorChooserDialog');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_color_chooser_dialog_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkColorChooserDialog');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_color_chooser_dialog_new

Creates a new C<Gnome::Gtk3::ColorChooserDialog>.

Returns: a new C<Gnome::Gtk3::ColorChooserDialog>

Since: 3.4

  method gtk_color_chooser_dialog_new ( Str $title, N-GObject $parent --> N-GObject  )

=item Str $title; (allow-none): Title of the dialog, or C<Any>
=item N-GObject $parent; (allow-none): Transient parent of the dialog, or C<Any>

=end pod

sub gtk_color_chooser_dialog_new ( Str $title, N-GObject $parent )
  returns N-GObject
  is native(&gtk-lib)
  { * }
