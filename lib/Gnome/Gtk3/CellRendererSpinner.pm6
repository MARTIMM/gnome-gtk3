#TL:1:Gnome::Gtk3::CellRendererSpinner:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererSpinner

Renders a spinning animation in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererSpinner> renders a spinning animation in a cell, very similar to B<Gnome::Gtk3::Spinner>. It can often be used as an alternative to a B<Gnome::Gtk3::CellRendererProgress> for displaying indefinite activity, instead of actual progress.

To start the animation in a cell, set the  I<active> property to C<1> and increment the  I<pulse> property at regular intervals. The usual way to set the cell renderer properties for each cell is to bind them to columns in your tree model using e.g. C<gtk_tree_view_column_add_attribute()>.

=head2 See Also

B<Gnome::Gtk3::Spinner>, B<Gnome::Gtk3::CellRendererProgress>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererSpinner;
  also is Gnome::Gtk3::CellRenderer;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererSpinner:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRenderer;

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

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CellRendererSpinner';

  # process all named arguments
  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
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
    self._set-native-object(gtk_cell_renderer_spinner_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererSpinner');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_spinner_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCellRendererSpinner');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_spinner_new:new()
=begin pod
=head2 gtk_cell_renderer_spinner_new

Returns a new cell renderer which will show a spinner to indicate activity.

Since: 2.20

  method gtk_cell_renderer_spinner_new ( --> N-GObject  )


=end pod

sub gtk_cell_renderer_spinner_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:active:
=head3 Active

Whether the spinner is active (ie. shown in the cell)
Default value: False

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:pulse:
=head3 Pulse

Pulse of the spinner. Increment this value to draw the next frame of the
spinner animation. Usually, you would update this value in a timeout.
By default, the B<Gnome::Gtk3::Spinner> widget draws one full cycle of the animation,
consisting of 12 frames, in 750 milliseconds.
Since: 2.20

The B<Gnome::GObject::Value> type of property I<pulse> is C<G_TYPE_UINT>.

=comment #TP:0:size:
=head3 Size


The B<Gnome::Gtk3::IconSize> value that specifies the size of the rendered spinner.
Since: 2.20
Widget type: GTK_TYPE_ICON_SIZE

The B<Gnome::GObject::Value> type of property I<size> is C<G_TYPE_ENUM>.
=end pod
