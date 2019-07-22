use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ColorChooserWidget

=SUBTITLE A widget for choosing colors

=head1 Description


The C<Gnome::Gtk3::ColorChooserWidget> widget lets the user select a
color. By default, the chooser presents a predefined palette
of colors, plus a small number of settable custom colors.
It is also possible to select a different color with the
single-color editor. To enter the single-color editing mode,
use the context menu of any color of the palette, or use the
'+' button to add a new custom color.

The chooser automatically remembers the last selection, as well
as custom colors.

To change the initially selected color, use C<gtk_color_chooser_set_rgba()>.
To get the selected color use C<gtk_color_chooser_get_rgba()>.

The C<Gnome::Gtk3::ColorChooserWidget> is used in the C<Gnome::Gtk3::ColorChooserDialog>
to provide a dialog for selecting colors.

# CSS names

C<Gnome::Gtk3::ColorChooserWidget> has a single CSS node with name colorchooser.




=head2 See Also

C<Gnome::Gtk3::ColorChooserDialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooserWidget;
  also is Gnome::Gtk3::Box;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooserWidget:auth<github:MARTIMM>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 multi method new ( Bool :$empty! )

Create a new object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ColorChooserWidget';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_color_chooser_widget_new());
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
  self.set-class-info('GtkColorChooserWidget');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_color_chooser_widget_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkColorChooserWidget');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_color_chooser_widget_new

Creates a new native C<GtkColorChooserWidget>.

Returns: a new C<Gnome::Gtk3::ColorChooserWidget>

Since: 3.4

  method gtk_color_chooser_widget_new ( --> N-GObject )

=end pod

sub gtk_color_chooser_widget_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TODO Must add type info
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 show-editor

The C<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.

The ::show-editor property is C<1> when the color chooser
is showing the single-color editor. It can be set to switch
the color chooser into single-color editing mode.

Since: 3.4

=end pod
