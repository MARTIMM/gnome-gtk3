use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Box

=SUBTITLE A container box

=head1 Description


The C<Gnome::Gtk3::Box> widget organizes child widgets into a rectangular area.

The rectangular area of a C<Gnome::Gtk3::Box> is organized into either a single row
or a single column of child widgets depending upon the orientation.
Thus, all children of a C<Gnome::Gtk3::Box> are allocated one dimension in common,
which is the height of a row, or the width of a column.

C<Gnome::Gtk3::Box> uses a notion of packing. Packing refers
to adding widgets with reference to a particular position in a
C<Gnome::Gtk3::Container>. For a C<Gnome::Gtk3::Box>, there are two reference positions: the
start and the end of the box.
For a vertical C<Gnome::Gtk3::Box>, the start is defined as the top of the box and
the end is defined as the bottom. For a horizontal C<Gnome::Gtk3::Box> the start
is defined as the left side and the end is defined as the right side.

Use repeated calls to gtk_box_pack_start() to pack widgets into a
C<Gnome::Gtk3::Box> from start to end. Use gtk_box_pack_end() to add widgets from
end to start. You may intersperse these calls and add widgets from
both ends of the same C<Gnome::Gtk3::Box>.

Because C<Gnome::Gtk3::Box> is a C<Gnome::Gtk3::Container>, you may also use gtk_container_add()
to insert widgets into the box, and they will be packed with the default
values for expand and fill child properties. Use gtk_container_remove()
to remove widgets from the C<Gnome::Gtk3::Box>.

Use gtk_box_set_homogeneous() to specify whether or not all children
of the C<Gnome::Gtk3::Box> are forced to get the same amount of space.

Use gtk_box_set_spacing() to determine how much space will be
minimally placed between all children in the C<Gnome::Gtk3::Box>. Note that
spacing is added between the children, while
padding added by gtk_box_pack_start() or gtk_box_pack_end() is added
on either side of the widget it belongs to.

Use gtk_box_reorder_child() to move a C<Gnome::Gtk3::Box> child to a different
place in the box.

Use gtk_box_set_child_packing() to reset the expand,
fill and padding child properties.
Use gtk_box_query_child_packing() to query these fields.

Note that a single-row or single-column C<Gnome::Gtk3::Grid> provides exactly
the same functionality as C<Gnome::Gtk3::Box>.


=head2 Css Nodes


C<Gnome::Gtk3::Box> uses a single CSS node with name box.

In horizontal orientation, the nodes of the children are always arranged
from left to right. So C<first-child> will always select the leftmost child,
regardless of text direction.



=head2 See Also

C<Gnome::Gtk3::Frame>, C<Gnome::Gtk3::Grid>, C<Gnome::Gtk3::Layout>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Box;
  also is Gnome::Gtk3::Container;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Box:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create a new empty box.

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
#  $signals-added = self.add-signal-types( $?CLASS.^name,
#    ... :type<signame>
#  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Box';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(
      gtk_box_new(
        ? %options<orientation>
          ?? %options<orientation> !! GTK_ORIENTATION_HORIZONTAL,
        %options<spacing>.defined ?? %options<spacing> !! 1
      )
    );
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_box_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_box_new

Creates a new C<Gnome::Gtk3::Box>.

  method gtk_box_new (
    GtkOrientation $orientation, Int $spacing
    --> N-GObject
  )

=item GtkOrientation $orientation;  the box’s orientation.
=item Int $spacing;  the number of pixels to place by default between children.

Returns N-GObject; a new C<Gnome::Gtk3::Box>.
=end pod

sub gtk_box_new ( int32 $orientation,  int32 $spacing )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] pack_start

Adds @child to @box, packed with reference to the start of @box.
The @child is packed after any other child packed with reference
to the start of @box.


  method gtk_box_pack_start ( N-GObject $child, Int $expand, Int $fill, UInt $padding)

=item Gnome::Gtk3::Widget $child; the widget to be added to the box
=item Int $expand;  1 if the new child is to be given extra space allocated to box. The extra space will be divided evenly between all children that use this option
=item Int $fill; 1 if space given to C<$child> by the C<$expand> option is actually allocated to @child, rather than just padding it.  This parameter has no effect if @expand is set to 0.  A child is always allocated the full height of a horizontal C<Gnome::Gtk3::Box> and the full width of a vertical C<Gnome::Gtk3::Box>. This option affects the other dimension
=item UInt $padding;  extra space in pixels to put between this child and its neighbors, over and above the global amount specified by C<Gnome::Gtk3::Box>:spacing property.  If @child is a widget at one of the reference ends of @box, then @padding pixels are also put between @child and the reference edge of @box

=end pod

sub gtk_box_pack_start (  N-GObject $box,  N-GObject $child,  int32 $expand,  int32 $fill,  uint32 $padding )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] pack_end

  to @box. The extra space will be divided evenly between all children
  of @box that use this option
  actually allocated to @child, rather than just padding it.  This
  parameter has no effect if @expand is set to 0.  A child is
  always allocated the full height of a horizontal C<Gnome::Gtk3::Box> and the full width
  of a vertical C<Gnome::Gtk3::Box>.  This option affects the other dimension
  neighbors, over and above the global amount specified by
  C<Gnome::Gtk3::Box>:spacing property.  If @child is a widget at one of the
  reference ends of @box, then @padding pixels are also put between
  @child and the reference edge of @box

Adds @child to @box, packed with reference to the end of @box.
The @child is packed after (away from end of) any other child
packed with reference to the end of @box.


  method gtk_box_pack_end ( N-GObject $child, Int $expand, Int $fill, UInt $padding)

=item N-GObject $child;  the C<Gnome::Gtk3::Widget> to be added to @box
=item Int $expand;  1 if the new child is to be given extra space allocated
=item Int $fill;  %TRUE if space given to @child by the @expand option is
=item UInt $padding;  extra space in pixels to put between this child and its

=end pod

sub gtk_box_pack_end (  N-GObject $box,  N-GObject $child,  int32 $expand,  int32 $fill,  uint32 $padding )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] set_homogeneous

Sets the C<Gnome::Gtk3::Box>:homogeneous property of @box, controlling
whether or not all children of @box are given equal space
in the box.

  method gtk_box_set_homogeneous ( Int $homogeneous)

=item Int $homogeneous;  a boolean value, 1 to create equal allotments, 0 for variable allotments

=end pod

sub gtk_box_set_homogeneous (  N-GObject $box,  int32 $homogeneous )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] get_homogeneous

Returns whether the box is homogeneous (all children are the
same size). See gtk_box_set_homogeneous().

  method gtk_box_get_homogeneous ( --> Int )

Returns int32; 1 if the box is homogeneous.
=end pod

sub gtk_box_get_homogeneous (  N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] set_spacing

Sets the C<Gnome::Gtk3::Box>:spacing property of @box, which is the
number of pixels to place between children of @box.

  method gtk_box_set_spacing ( Int $spacing)

=item Int $spacing;  the number of pixels to put between children

=end pod

sub gtk_box_set_spacing (  N-GObject $box,  int32 $spacing )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] get_spacing

Gets the value set by gtk_box_set_spacing().

  method gtk_box_get_spacing ( --> Int )


Returns int32; spacing between children
=end pod

sub gtk_box_get_spacing (  N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] set_baseline_position

Sets the baseline position of a box. This affects
only horizontal boxes with at least one baseline aligned
child. If there is more vertical space available than requested,
and the baseline is not allocated by the parent then
@position is used to allocate the baseline wrt the
extra space available.

  method gtk_box_set_baseline_position ( GtkBaselinePosition $position)

=item GtkBaselinePosition $position;  a C<Gnome::Gtk3::BaselinePosition>

=end pod

sub gtk_box_set_baseline_position (  N-GObject $box,  int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] get_baseline_position

Gets the value set by gtk_box_set_baseline_position().

  method gtk_box_get_baseline_position ( --> GtkBaselinePosition )

Returns GtkBaselinePosition; the baseline position
=end pod

sub gtk_box_get_baseline_position (  N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] reorder_child

  of @box, starting from 0. If negative, indicates the end of
  the list

Moves @child to a new @position in the list of @box children.
The list contains widgets packed C<GTK_PACK_START>
as well as widgets packed C<GTK_PACK_END>, in the order that these
widgets were added to @box.

A widget’s position in the @box children list determines where
the widget is packed into @box.  A child widget at some position
in the list will be packed just after all other widgets of the
same packing type that appear earlier in the list.


  method gtk_box_reorder_child ( N-GObject $child, Int $position)

=item N-GObject $child;  the C<Gnome::Gtk3::Widget> to move
=item Int $position;  the new position for @child in the list of children

=end pod

sub gtk_box_reorder_child (  N-GObject $box,  N-GObject $child,  int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] query_child_packing

    property
    property
    child property
    child property

Obtains information about how @child is packed into @box.


  method gtk_box_query_child_packing ( N-GObject $child, Int $expand, Int $fill, UInt $padding, GtkPackType $pack_type)

=item N-GObject $child;  the C<Gnome::Gtk3::Widget> of the child to query
=item Int $expand;  (out): pointer to return location for expand child
=item Int $fill;  (out): pointer to return location for fill child
=item UInt $padding;  (out): pointer to return location for padding
=item GtkPackType $pack_type;  (out): pointer to return location for pack-type

=end pod

sub gtk_box_query_child_packing (  N-GObject $box,  N-GObject $child,  int32 $expand,  int32 $fill,  uint32 $padding,  int32 $pack_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] set_child_packing

Sets the way @child is packed into @box.

  method gtk_box_set_child_packing ( N-GObject $child, Int $expand, Int $fill, UInt $padding, GtkPackType $pack_type)

=item N-GObject $child;  the C<Gnome::Gtk3::Widget> of the child to set
=item Int $expand;  the new value of the expand child property
=item Int $fill;  the new value of the fill child property
=item UInt $padding;  the new value of the padding child property
=item GtkPackType $pack_type;  the new value of the pack-type child property

=end pod

sub gtk_box_set_child_packing (  N-GObject $box,  N-GObject $child,  int32 $expand,  int32 $fill,  uint32 $padding,  int32 $pack_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] set_center_widget

Sets a center widget; that is a child widget that will be
centered with respect to the full width of the box, even
if the children at either side take up different amounts
of space.

  method gtk_box_set_center_widget ( N-GObject $widget)

=item N-GObject $widget;  (allow-none): the widget to center

=end pod

sub gtk_box_set_center_widget (  N-GObject $box,  N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_box_] get_center_widget


Retrieves the center widget of the box.

  method gtk_box_get_center_widget ( --> N-GObject )


Returns N-GObject; (transfer none) (nullable): the center widget or Any in case no center widget is set.
=end pod

sub gtk_box_get_center_widget (  N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TODO Must add type info
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');


=head2 expand

Whether the child should receive extra space when the parent grows.

Note that the default value for this property is 0 for C<Gnome::Gtk3::Box>,
but C<Gnome::Gtk3::HBox>, C<Gnome::Gtk3::VBox> and other subclasses use the old default
of 1.

Note that the C<Gnome::Gtk3::Widget>:halign, C<Gnome::Gtk3::Widget>:valign, C<Gnome::Gtk3::Widget>:hexpand
and C<Gnome::Gtk3::Widget>:vexpand properties are the preferred way to influence
child size allocation in containers.

In contrast to C<Gnome::Gtk3::Widget>:hexpand, the expand child property does
not cause the box to expand itself.



=head2 fill

Whether the child should receive extra space when the parent grows.

Note that the C<Gnome::Gtk3::Widget>:halign, C<Gnome::Gtk3::Widget>:valign, C<Gnome::Gtk3::Widget>:hexpand
and C<Gnome::Gtk3::Widget>:vexpand properties are the preferred way to influence
child size allocation in containers.


=end pod


#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod
}}
#-------------------------------------------------------------------------------
=begin pod
=begin comment
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., $user-optionN
  )


=head2 Supported signals

=head2 Unsupported signals

=head2 Not yet supported signals
=end comment






=begin comment

=head4 Signal Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, :$user-option1, ..., $user-optionN
  )

=head4 Event Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, GdkEvent :$event,
    :$user-option1, ..., $user-optionN
  )

=head4 Native Object Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, N-GObject :$nativewidget,
    :$user-option1, ..., :$user-optionN
  )

=end comment


=begin comment

=head4 Handler Method Arguments
=item $widget; This can be any perl6 widget with C<Gnome::GObject::Object> as the top parent class e.g. C<Gnome::Gtk3::Button>.
=item $event; A structure defined in C<Gnome::Gdk3::EventTypes>.
=item $nativewidget; A native widget (a C<N-GObject>) which can be turned into a perl6 widget using C<.new(:widget())> on the appropriate class.
=item $user-option*; Any extra options given by the user when registering the signal.

=end comment

=end pod
