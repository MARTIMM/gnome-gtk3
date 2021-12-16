#TL:1:Gnome::Gtk3::CellRendererSpin:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererSpin

Renders a spin button in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererSpin> renders text in a cell like B<Gnome::Gtk3::CellRendererText> from which it is derived. But while B<Gnome::Gtk3::CellRendererText> offers a simple entry to edit the text, B<Gnome::Gtk3::CellRendererSpin> offers a B<Gnome::Gtk3::SpinButton> widget. Of course, that means that the text has to be parseable as a floating point number.

The range of the spinbutton is taken from the I<adjustment> property of the cell renderer, which can be set explicitly or mapped to a column in the tree model, like all properties of cell renders. B<Gnome::Gtk3::CellRendererSpin> also has properties for the  I<climb-rate> and the number of  I<digits> to display. Other B<Gnome::Gtk3::SpinButton> properties can be set in a handler for the  I<editing-started> signal.

The B<Gnome::Gtk3::CellRendererSpin> cell renderer was added in GTK+ 2.10.

=head2 See Also

B<Gnome::Gtk3::CellRendererText>, B<Gnome::Gtk3::SpinButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererSpin;
  also is Gnome::Gtk3::CellRendererText;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererSpin:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRendererText;

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

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CellRendererSpin';

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
    self._set-native-object(gtk_cell_renderer_spin_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererSpin');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_spin_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCellRendererSpin');
  $s = callsame unless ?$s;

  $s;
}


#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk_cell_renderer_spin_get_type:
=begin pod
=head2 [gtk_cell_renderer_spin_] get_type

  method gtk_cell_renderer_spin_get_type ( --> UInt  )

=end pod

sub gtk_cell_renderer_spin_get_type (  )
  returns uint64
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_spin_new:new()
=begin pod
=head2 gtk_cell_renderer_spin_new

Creates a new B<Gnome::Gtk3::CellRendererSpin>.

Since: 2.10

  method gtk_cell_renderer_spin_new ( --> N-GObject  )


=end pod

sub gtk_cell_renderer_spin_new (  )
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

=comment #TP:0:adjustment:
=head3 Adjustment


The adjustment that holds the value of the spinbutton.
This must be non-C<Any> for the cell renderer to be editable.
Since: 2.10
Widget type: GTK_TYPE_ADJUSTMENT

The B<Gnome::GObject::Value> type of property I<adjustment> is C<G_TYPE_OBJECT>.

=comment #TP:0:climb-rate:
=head3 Climb rate


The acceleration rate when you hold down a button.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<climb-rate> is C<G_TYPE_DOUBLE>.

=comment #TP:0:digits:
=head3 Digits


The number of decimal places to display.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<digits> is C<G_TYPE_UINT>.
=end pod
