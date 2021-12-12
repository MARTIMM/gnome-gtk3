#TL:1:Gnome::Gtk3::CellRendererProgress:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererProgress

Renders numbers as progress bars

=head1 Description

B<Gnome::Gtk3::CellRendererProgress> renders a numeric value as a progress par in a cell. Additionally, it can display a text on top of the progress bar.

The B<Gnome::Gtk3::CellRendererProgress> cell renderer was added in GTK+ 2.6.

=head2 Implemented Interfaces

Gnome::Gtk3::CellRendererProgress implements
=comment item [Gnome::Gtk3::Orientable](Orientable.html)


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererProgress;
  also is Gnome::Gtk3::CellRenderer;
  also does Gnome::Gtk3::Orientable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRenderer;
use Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererProgress:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRenderer;
also does Gnome::Gtk3::Orientable;

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

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRendererProgress';

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

  else { #if ? %options<empty> {
    self.set-native-object(gtk_cell_renderer_progress_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererProgress');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_progress_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCellRendererProgress');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_progress_new:new()
=begin pod
=head2 [gtk_] cell_renderer_progress_new

Creates a new B<Gnome::Gtk3::CellRendererProgress>.

Returns: the new cell renderer

Since: 2.6

  method gtk_cell_renderer_progress_new ( --> N-GObject  )

=end pod

sub gtk_cell_renderer_progress_new (  )
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

=comment #TP:0:value:
=head3 Value


The "value" property determines the percentage to which the
progress bar will be "filled in".
Since: 2.6


The B<Gnome::GObject::Value> type of property I<value> is C<G_TYPE_INT>.

=comment #TP:0:text:
=head3 Text


The "text" property determines the label which will be drawn
over the progress bar. Setting this property to C<Any> causes the default
label to be displayed. Setting this property to an empty string causes
no label to be displayed.
Since: 2.6


The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=comment #TP:0:pulse:
=head3 Pulse


Setting this to a non-negative value causes the cell renderer to
enter "activity mode", where a block bounces back and forth to
indicate that some progress is made, without specifying exactly how
much.
Each increment of the property causes the block to move by a little
bit.
To indicate that the activity has not started yet, set the property
to zero. To indicate completion, set the property to C<G_MAXINT>.
Since: 2.12

The B<Gnome::GObject::Value> type of property I<pulse> is C<G_TYPE_INT>.

=comment #TP:0:text-xalign:
=head3 Text x alignment


The "text-xalign" property controls the horizontal alignment of the
text in the progress bar.  Valid values range from 0 (left) to 1
(right).  Reserved for RTL layouts.
Since: 2.12

The B<Gnome::GObject::Value> type of property I<text-xalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:text-yalign:
=head3 Text y alignment


The "text-yalign" property controls the vertical alignment of the
text in the progress bar.  Valid values range from 0 (top) to 1
(bottom).
Since: 2.12

The B<Gnome::GObject::Value> type of property I<text-yalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:inverted:
=head3 Inverted

Invert the direction in which the progress bar grows
Default value: False


The B<Gnome::GObject::Value> type of property I<inverted> is C<G_TYPE_BOOLEAN>.
=end pod
