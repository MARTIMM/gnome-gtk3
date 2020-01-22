#TL:0:Gnome::Gtk3::AspectFrame:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AspectFrame

A frame that constrains its child to a particular aspect ratio

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::AspectFrame> is useful when you want pack a widget so that it can resize but always retains the same aspect ratio. For instance, one might be drawing a small preview of a larger image. B<Gnome::Gtk3::AspectFrame> derives from B<Gnome::Gtk3::Frame>, so it can draw a label and a frame around the child. The frame will be “shrink-wrapped” to the size of the child.

=head2 Css Nodes

B<Gnome::Gtk3::AspectFrame> uses a CSS node with name frame.

=head2 Implemented Interfaces

Gnome::Gtk3::AspectFrame implements
=comment item Gnome::Atk::ImplementorIface
[Gnome::Gtk3::Buildable](Buildable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AspectFrame;
  also is Gnome::Gtk3::Frame;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::AspectFrame:auth<github:MARTIMM>;
also is Gnome::Gtk3::Frame;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new AspectFrame.

  multi method new (
    Str :$label!, Num :$xalign!, Num :$yalign, Num :$ratio!,
    Bool :$obey-child!
  )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:label,:xalign,:yalign,:ratio,:obey-child):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::AspectFrame';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported, undefined or wrongly typed options for ' ~
               self.^name ~ ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # create default object
  else {
    # self.set-native-object(gtk_aspect_frame_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkAspectFrame');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_aspect_frame_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
#  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkAspectFrame');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:gtk_aspect_frame_new:
=begin pod
=head2 gtk_aspect_frame_new

Create a new B<Gnome::Gtk3::AspectFrame>.

Returns: the new B<Gnome::Gtk3::AspectFrame>.

  method gtk_aspect_frame_new ( Str $label, Num $xalign, Num $yalign, Num $ratio, Int $obey_child --> N-GObject )

=item Str $label; (allow-none): Label text.
=item Num $xalign; Horizontal alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
=item Num $yalign; Vertical alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
=item Num $ratio; The desired aspect ratio.
=item Int $obey_child; If C<1>, I<ratio> is ignored, and the aspect ratio is taken from the requistion of the child.

=end pod

sub gtk_aspect_frame_new ( Str $label, num32 $xalign, num32 $yalign, num32 $ratio, int32 $obey_child --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_aspect_frame_set:
=begin pod
=head2 gtk_aspect_frame_set

Set parameters for an existing B<Gnome::Gtk3::AspectFrame>.

  method gtk_aspect_frame_set ( Num $xalign, Num $yalign, Num $ratio, Int $obey_child )

=item Num $xalign; Horizontal alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
=item Num $yalign; Vertical alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
=item Num $ratio; The desired aspect ratio.
=item Int $obey_child; If C<1>, I<ratio> is ignored, and the aspect ratio is taken from the requistion of the child.

=end pod

sub gtk_aspect_frame_set ( N-GObject $aspect_frame, num32 $xalign, num32 $yalign, num32 $ratio, int32 $obey_child  )
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

=comment #TP:0:xalign:
=head3 Horizontal Alignment



The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:yalign:
=head3 Vertical Alignment



The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:ratio:
=head3 Ratio



The B<Gnome::GObject::Value> type of property I<ratio> is C<G_TYPE_FLOAT>.

=comment #TP:0:obey-child:
=head3 Obey child

Force aspect ratio to match that of the frame's child
Default value: True


The B<Gnome::GObject::Value> type of property I<obey-child> is C<G_TYPE_BOOLEAN>.
=end pod
