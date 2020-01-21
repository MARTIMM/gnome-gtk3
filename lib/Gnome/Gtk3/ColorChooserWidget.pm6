#TL:1:Gnome::Gtk3::ColorChooserWidget:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorChooserWidget

A widget for choosing colors

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::ColorChooserWidget> widget lets the user select a
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

The B<Gnome::Gtk3::ColorChooserWidget> is used in the B<Gnome::Gtk3::ColorChooserDialog>
to provide a dialog for selecting colors.


=head2 CSS names

B<Gnome::Gtk3::ColorChooserWidget> has a single CSS node with name colorchooser.

Since: 3.4



=begin comment
=head2 Implemented Interfaces

Gnome::Gtk3::ColorChooserWidget implements

=item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item [Gnome::Gtk3::Orientable](Orientable.html)
=item [Gnome::Gtk3::ColorChooser](ColorChooser.html)

=end comment

=head2 See Also

B<Gnome::Gtk3::ColorChooserDialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooserWidget;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::Buildable;
  also does Gnome::Gtk3::Orientable;
  also does Gnome::Gtk3::ColorChooser;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Box;

use Gnome::Gtk3::Buildable;
use Gnome::Gtk3::Orientable;
use Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooserWidget:auth<github:MARTIMM>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::Buildable;
also does Gnome::Gtk3::Orientable;
also does Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  if $signals-added {
    # no signals of its own
    $signals-added = True;

    # signals from interfaces
    self._add_color_chooser_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ColorChooserWidget';

  # process all named arguments
  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.24.0');
    self.set-native-object(gtk_color_chooser_widget_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self.set-native-object(gtk_color_chooser_widget_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkColorChooserWidget');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_color_chooser_widget_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;
  $s = self._orientable_interface($native-sub) unless ?$s;
  $s = self._color_chooser_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkColorChooserWidget');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_widget_new:new()
=begin pod
=head2 [gtk_] color_chooser_widget_new

Creates a new B<Gnome::Gtk3::ColorChooserWidget>.

Returns: a new B<Gnome::Gtk3::ColorChooserWidget>

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

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:show-editor:
=head3 Show editor

The I<show-editor> property is C<1> when the color chooser
is showing the single-color editor. It can be set to switch
the color chooser into single-color editing mode.
Since: 3.4

The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.

=end pod
