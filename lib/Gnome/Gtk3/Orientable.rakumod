#TL:1:Gnome::Gtk3::Orientable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Orientable

An interface for flippable widgets

=head1 Description


The B<Gnome::Gtk3::Orientable> interface is implemented by all widgets that can be oriented horizontally or vertically. Historically, such widgets have been realized as subclasses of a common base class (e.g B<HBox>/B<VBox> or B<HScale>/B<VScale>). B<Gnome::Gtk3::Orientable> is more flexible in that it allows the orientation to be changed at runtime, allowing the widgets to “flip”.

Note that B<HBox>/B<VBox> or B<HScale>/B<VScale> are not implemented in this Raku package because these classes are deprecated.


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Orientable;

=head2 Example

  my Gnome::Gtk3::LevelBar $level-bar .= new;
  $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;

use Gnome::Gtk3::Enums:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkorientable.h
# https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
unit role Gnome::Gtk3::Orientable:auth<github:MARTIMM>:api<1>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#TM:1:new():interfacing
# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
#TM:1:get-orientation:
=begin pod
=head2 get-orientation

  method get-orientation ( --> GtkOrientation )

Retrieves the orientation of the I<orientable>.

=end pod

method get-orientation ( --> GtkOrientation ) {
  GtkOrientation(
    gtk_orientable_get_orientation(self._get-native-object-no-reffing)
  );
}

sub gtk_orientable_get_orientation ( N-GObject $orientable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-orientation:
=begin pod
=head2 set-orientation

  method set-orientation ( GtkOrientation $orientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

method set-orientation ( GtkOrientation $orientation ) {
  gtk_orientable_set_orientation(
    self._get-native-object-no-reffing, $orientation.value
  );
}

sub gtk_orientable_set_orientation ( N-GObject $orientable, int32 $orientation )
  is native(&gtk-lib)
  { * }



=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:orientation:
=head3 Orientation

The orientation of the orientable.
Widget type: GTK_TYPE_ORIENTATION

The B<Gnome::GObject::Value> type of property I<orientation> is C<G_TYPE_ENUM>.
=end pod
