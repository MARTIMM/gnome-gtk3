#TL:1:Gnome::Gtk3::Frame:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Frame

A bin with a decorative frame and optional label

![](images/frame.png)

=head1 Description

The frame widget is a bin that surrounds its child with a decorative frame and an optional label. If present, the label is drawn in a gap in the top side of the frame. The position of the label can be controlled with C<gtk_frame_set_label_align()>.


=head2 B<Gnome::Gtk3::Frame> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::Frame> implementation of the B<Gnome::Gtk3::Buildable> interface supports placing a child in the label position by specifying “label” as the “type” attribute of a <child> element. A normal content child can be specified without specifying a <child> type attribute.

An example of a UI definition fragment with B<Gnome::Gtk3::Frame>:

  <object class="GtkFrame">
    <child type="label">
      <object class="GtkLabel" id="frame-label"/>
    </child>
    <child>
      <object class="GtkEntry" id="frame-content"/>
    </child>
  </object>

=head2 Css Nodes

  frame
  ├── border[.flat]
  ├── <label widget>
  ╰── <child>

B<Gnome::Gtk3::Frame> has a main CSS node named “frame” and a subnode named “border”. The “border” node is used to draw the visible border. You can set the appearance of the border using CSS properties like “border-style” on the “border” node.

The border node can be given the style class “.flat”, which is used by themes to disable drawing of the border. To do this from code, call C<gtk_frame_set_shadow_type()> with C<GTK_SHADOW_NONE> to add the “.flat” class or any other shadow type to remove it.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Frame;
  also is Gnome::Gtk3::Bin;
=comment  also does Gnome::Gtk3::Buildable;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Frame;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Frame;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Frame class process the options
    self.bless( :GtkFrame, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Frame:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new default Frame.

  multi method new ( )

Create a new Frame with a label.

  multi method new ( :label! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Frame' or %options<GtkFrame> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<widget>:exists or %options<native-object>:exists or
       %options<build-id>:exists { }

    else {
      my $no;

      if ? %options<label> {
        $no = gtk_frame_new(%options<label>);
      }

      # create default object
      else {
        $no = gtk_frame_new(Str);
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkFrame');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_frame_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkFrame');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_frame_new:new():new(:label)
=begin pod
=head2 gtk_frame_new

Creates a new B<Gnome::Gtk3::Frame>, with optional label I<$label>.
If I<$label> is C<Any>, the label is omitted.

Returns: a new B<Gnome::Gtk3::Frame> widget

  method gtk_frame_new ( Str $label --> N-GObject )

=item Str $label; the text to use as the label of the frame

=end pod

sub gtk_frame_new ( Str $label --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_set_label:
=begin pod
=head2 [gtk_frame_] set_label

Removes the current  I<label-widget>. If I<$label> is not C<Any>, creates a
new B<Gnome::Gtk3::Label> with that text and adds it as the  I<label-widget>.

  method gtk_frame_set_label ( Str $label )

=item Str $label; the text to use as the label of the frame

=end pod

sub gtk_frame_set_label ( N-GObject $frame, Str $label  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_get_label:
=begin pod
=head2 [gtk_frame_] get_label

If the frame’s label widget is a B<Gnome::Gtk3::Label>, returns the
text in the label widget. (The frame will have a B<Gnome::Gtk3::Label>
for the label widget if a non-C<Any> argument was passed
to C<gtk_frame_new()>.)

Returns: (nullable): the text in the label, or C<Any> if there
was no label widget or the lable widget was not
a B<Gnome::Gtk3::Label>. This string is owned by GTK+ and
must not be modified or freed.

  method gtk_frame_get_label ( --> Str )

=end pod

sub gtk_frame_get_label ( N-GObject $frame --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_set_label_widget:
=begin pod
=head2 [gtk_frame_] set_label_widget

Sets the  I<$label-widget> for the frame. This is the widget that
will appear embedded in the top edge of the frame as a title.

  method gtk_frame_set_label_widget ( N-GObject $label_widget )

=item N-GObject $label_widget; the new label widget

=end pod

sub gtk_frame_set_label_widget ( N-GObject $frame, N-GObject $label_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_get_label_widget:
=begin pod
=head2 [gtk_frame_] get_label_widget

Retrieves the label widget for the frame. See
C<gtk_frame_set_label_widget()>.

Returns: (nullable) (transfer none): the label widget, or C<Any> if
there is none.

  method gtk_frame_get_label_widget ( --> N-GObject )

=end pod

sub gtk_frame_get_label_widget ( N-GObject $frame --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_set_label_align:
=begin pod
=head2 [gtk_frame_] set_label_align

Sets the alignment of the frame widget’s label. The
default values for a newly created frame are 0.0 and 0.5.

  method gtk_frame_set_label_align ( Num $xalign, Num $yalign )

=item Num $xalign; The position of the label along the top edge of the widget. A value of 0.0 represents left alignment; 1.0 represents right alignment.
=item Num $yalign; The y alignment of the label. A value of 0.0 aligns under  the frame; 1.0 aligns above the frame. If the values are exactly 0.0 or 1.0 the gap in the frame won’t be painted because the label will be completely above or below the frame.

=end pod

sub gtk_frame_set_label_align ( N-GObject $frame, num32 $xalign, num32 $yalign  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_get_label_align:
=begin pod
=head2 [gtk_frame_] get_label_align

Retrieves the X and Y alignment of the frame’s label. See
C<gtk_frame_set_label_align()>.

  method gtk_frame_get_label_align ( --> List )

The list has the following items
=item Num $xalign; location to store X alignment of frame’s label, or C<Any>
=item Num $yalign; location to store Y alignment of frame’s label, or C<Any>

=end pod

sub gtk_frame_get_label_align ( N-GObject $frame --> List ) {
  _gtk_frame_get_label_align( $frame, my num32 $xa, my num32 $ya);
  ( $xa, $ya)
}

sub _gtk_frame_get_label_align (
  N-GObject $frame, num32 $xalign is rw, num32 $yalign is rw
) is native(&gtk-lib)
  is symbol('gtk_frame_get_label_align')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_set_shadow_type:
=begin pod
=head2 [gtk_frame_] set_shadow_type

Sets the  I<shadow-type> for I<frame>, i.e. whether it is drawn without
(C<GTK_SHADOW_NONE>) or with (other values) a visible border. Values other than
C<GTK_SHADOW_NONE> are treated identically by B<Gnome::Gtk3::Frame>. The chosen type is
applied by removing or adding the .flat class to the CSS node named border.

  method gtk_frame_set_shadow_type ( GtkShadowType $type )

=item GtkShadowType $type; the new B<Gnome::Gtk3::ShadowType>

=end pod

sub gtk_frame_set_shadow_type ( N-GObject $frame, int32 $type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_frame_get_shadow_type:
=begin pod
=head2 [gtk_frame_] get_shadow_type

Retrieves the shadow type of the frame. See
C<gtk_frame_set_shadow_type()>.

Returns: the current shadow type of the frame.

  method gtk_frame_get_shadow_type ( --> GtkShadowType )


=end pod

sub gtk_frame_get_shadow_type ( N-GObject $frame --> int32 )
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

=comment #TP:1:label:
=head3 Label

Text of the frame's label
Default value: Any

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.


=comment #TP:1:label-xalign:
=head3 Label xalign

The horizontal alignment of the label.

The B<Gnome::GObject::Value> type of property I<label-xalign> is C<G_TYPE_FLOAT>.


=comment #TP:1:label-yalign:
=head3 Label yalign

The vertical alignment of the label.

The B<Gnome::GObject::Value> type of property I<label-yalign> is C<G_TYPE_FLOAT>.


=comment #TP:0:shadow-type:
=head3 Frame shadow

Appearance of the frame border
Default value: False


The B<Gnome::GObject::Value> type of property I<shadow-type> is C<G_TYPE_ENUM>.

=comment #TP:0:label-widget:
=head3 Label widget

A widget to display in place of the usual frame label
Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<label-widget> is C<G_TYPE_OBJECT>.
=end pod
