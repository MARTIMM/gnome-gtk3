#TL:1:Gnome::Gtk3::Box:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Box

A container box

=head1 Description

The B<Gnome::Gtk3::Box> widget organizes child widgets into a rectangular area.

The rectangular area of a B<Gnome::Gtk3::Box> is organized into either a single row
or a single column of child widgets depending upon the orientation.
Thus, all children of a B<Gnome::Gtk3::Box> are allocated one dimension in common,
which is the height of a row, or the width of a column.

B<Gnome::Gtk3::Box> uses a notion of packing. Packing refers
to adding widgets with reference to a particular position in a
B<Gnome::Gtk3::Container>. For a B<Gnome::Gtk3::Box>, there are two reference positions: the
start and the end of the box.
For a vertical B<Gnome::Gtk3::Box>, the start is defined as the top of the box and
the end is defined as the bottom. For a horizontal B<Gnome::Gtk3::Box> the start
is defined as the left side and the end is defined as the right side.

Use repeated calls to C<gtk_box_pack_start()> to pack widgets into a
B<Gnome::Gtk3::Box> from start to end. Use C<gtk_box_pack_end()> to add widgets from
end to start. You may intersperse these calls and add widgets from
both ends of the same B<Gnome::Gtk3::Box>.

Because B<Gnome::Gtk3::Box> is a B<Gnome::Gtk3::Container>, you may also use C<gtk_container_add()>
to insert widgets into the box, and they will be packed with the default
values for expand and fill child properties. Use C<gtk_container_remove()>
to remove widgets from the B<Gnome::Gtk3::Box>.

Use C<gtk_box_set_homogeneous()> to specify whether or not all children
of the B<Gnome::Gtk3::Box> are forced to get the same amount of space.

Use C<gtk_box_set_spacing()> to determine how much space will be
minimally placed between all children in the B<Gnome::Gtk3::Box>. Note that
spacing is added between the children, while
padding added by C<gtk_box_pack_start()> or C<gtk_box_pack_end()> is added
on either side of the widget it belongs to.

Use C<gtk_box_reorder_child()> to move a B<Gnome::Gtk3::Box> child to a different
place in the box.

Use C<gtk_box_set_child_packing()> to reset the expand,
fill and padding child properties.
Use C<gtk_box_query_child_packing()> to query these fields.

Note that a single-row or single-column B<Gnome::Gtk3::Grid> provides exactly
the same functionality as B<Gnome::Gtk3::Box>.

=head2 Css Nodes

B<Gnome::Gtk3::Box> uses a single CSS node with name box.

In horizontal orientation, the nodes of the children are always arranged
from left to right. So C<first-child> will always select the leftmost child,
regardless of text direction.

=head2 Implemented Interfaces
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Orientable](Orientable.html)

=head2 See Also

B<Gnome::Gtk3::Frame>, B<Gnome::Gtk3::Grid>, B<Gnome::Gtk3::Layout>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Box;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Orientable;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Enums;

use Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Box:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( :$orientation! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Box';

  # process all named arguments
  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    self.set-native-object(
      gtk_box_new(
        ? %options<orientation>
          ?? %options<orientation> !! GTK_ORIENTATION_HORIZONTAL,
        %options<spacing>.defined ?? %options<spacing> !! 1
      )
    );
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

  else { #if ? %options<empty> {
    self.set-native-object(
      gtk_box_new(
        ? %options<orientation>
          ?? %options<orientation> !! GTK_ORIENTATION_HORIZONTAL,
        %options<spacing>.defined ?? %options<spacing> !! 1
      )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkBox');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_box_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkBox');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_box_new:
=begin pod
=head2 [gtk_] box_new

Creates a new B<Gnome::Gtk3::Box>.

Returns: a new B<Gnome::Gtk3::Box>.

Since: 3.0

  method gtk_box_new ( GtkOrientation $orientation, Int $spacing --> N-GObject  )

=item GtkOrientation $orientation; the box’s orientation.
=item Int $spacing; the number of pixels to place by default between children.

=end pod

sub gtk_box_new ( int32 $orientation, int32 $spacing )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_pack_start:
=begin pod
=head2 [[gtk_] box_] pack_start

Adds I<child> to I<box>, packed with reference to the start of I<box>.
The I<child> is packed after any other child packed with reference
to the start of I<box>.

  method gtk_box_pack_start ( N-GObject $child, Int $expand, Int $fill, UInt $padding )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to be added to I<box>
=item Int $expand; C<1> if the new child is to be given extra space allocated to I<box>. The extra space will be divided evenly between all children that use this option
=item Int $fill; C<1> if space given to I<child> by the I<expand> option is actually allocated to I<child>, rather than just padding it.  This parameter has no effect if I<expand> is set to C<0>.  A child is always allocated the full height of a horizontal B<Gnome::Gtk3::Box> and the full width of a vertical B<Gnome::Gtk3::Box>. This option affects the other dimension
=item UInt $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by  I<spacing> property.  If I<child> is a widget at one of the reference ends of I<box>, then I<padding> pixels are also put between I<child> and the reference edge of I<box>

=end pod

sub gtk_box_pack_start ( N-GObject $box, N-GObject $child, int32 $expand, int32 $fill, uint32 $padding )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_pack_end:
=begin pod
=head2 [[gtk_] box_] pack_end

Adds I<child> to I<box>, packed with reference to the end of I<box>.
The I<child> is packed after (away from end of) any other child
packed with reference to the end of I<box>.

  method gtk_box_pack_end ( N-GObject $child, Int $expand, Int $fill, UInt $padding )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to be added to I<box>
=item Int $expand; C<1> if the new child is to be given extra space allocated to I<box>. The extra space will be divided evenly between all children of I<box> that use this option
=item Int $fill; C<1> if space given to I<child> by the I<expand> option is actually allocated to I<child>, rather than just padding it.  This parameter has no effect if I<expand> is set to C<0>.  A child is always allocated the full height of a horizontal B<Gnome::Gtk3::Box> and the full width of a vertical B<Gnome::Gtk3::Box>.  This option affects the other dimension
=item UInt $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by  I<spacing> property.  If I<child> is a widget at one of the reference ends of I<box>, then I<padding> pixels are also put between I<child> and the reference edge of I<box>

=end pod

sub gtk_box_pack_end ( N-GObject $box, N-GObject $child, int32 $expand, int32 $fill, uint32 $padding )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_set_homogeneous:
=begin pod
=head2 [[gtk_] box_] set_homogeneous

Sets the  I<homogeneous> property of I<box>, controlling
whether or not all children of I<box> are given equal space
in the box.

  method gtk_box_set_homogeneous ( Int $homogeneous )

=item Int $homogeneous; a boolean value, C<1> to create equal allotments, C<0> for variable allotments

=end pod

sub gtk_box_set_homogeneous ( N-GObject $box, int32 $homogeneous )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_get_homogeneous:
=begin pod
=head2 [[gtk_] box_] get_homogeneous

Returns whether the box is homogeneous (all children are the
same size). See C<gtk_box_set_homogeneous()>.

Returns: C<1> if the box is homogeneous.

  method gtk_box_get_homogeneous ( --> Int  )


=end pod

sub gtk_box_get_homogeneous ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_set_spacing:
=begin pod
=head2 [[gtk_] box_] set_spacing

Sets the  I<spacing> property of I<box>, which is the
number of pixels to place between children of I<box>.

  method gtk_box_set_spacing ( Int $spacing )

=item Int $spacing; the number of pixels to put between children

=end pod

sub gtk_box_set_spacing ( N-GObject $box, int32 $spacing )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_get_spacing:
=begin pod
=head2 [[gtk_] box_] get_spacing

Gets the value set by C<gtk_box_set_spacing()>.

Returns: spacing between children

  method gtk_box_get_spacing ( --> Int  )


=end pod

sub gtk_box_get_spacing ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_set_baseline_position:
=begin pod
=head2 [[gtk_] box_] set_baseline_position

Sets the baseline position of a box. This affects
only horizontal boxes with at least one baseline aligned
child. If there is more vertical space available than requested,
and the baseline is not allocated by the parent then
I<position> is used to allocate the baseline wrt the
extra space available.

Since: 3.10

  method gtk_box_set_baseline_position ( GtkBaselinePosition $position )

=item GtkBaselinePosition $position; a B<Gnome::Gtk3::BaselinePosition>

=end pod

sub gtk_box_set_baseline_position ( N-GObject $box, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_get_baseline_position:
=begin pod
=head2 [[gtk_] box_] get_baseline_position

Gets the value set by C<gtk_box_set_baseline_position()>.

Returns: the baseline position

Since: 3.10

  method gtk_box_get_baseline_position ( --> GtkBaselinePosition  )


=end pod

sub gtk_box_get_baseline_position ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_reorder_child:
=begin pod
=head2 [[gtk_] box_] reorder_child

Moves I<child> to a new I<position> in the list of I<box> children.
The list contains widgets packed B<GTK_PACK_START>
as well as widgets packed B<GTK_PACK_END>, in the order that these
widgets were added to I<box>.

A widget’s position in the I<box> children list determines where
the widget is packed into I<box>.  A child widget at some position
in the list will be packed just after all other widgets of the
same packing type that appear earlier in the list.

  method gtk_box_reorder_child ( N-GObject $child, Int $position )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to move
=item Int $position; the new position for I<child> in the list of children of I<box>, starting from 0. If negative, indicates the end of the list

=end pod

sub gtk_box_reorder_child ( N-GObject $box, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_query_child_packing:
=begin pod
=head2 [[gtk_] box_] query_child_packing

Obtains information about how I<child> is packed into I<box>.

  method gtk_box_query_child_packing ( N-GObject $child, Int $expand, Int $fill, UInt $padding, GtkPackType $pack_type )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> of the child to query
=item Int $expand; (out): pointer to return location for expand child property
=item Int $fill; (out): pointer to return location for fill child property
=item UInt $padding; (out): pointer to return location for padding child property
=item GtkPackType $pack_type; (out): pointer to return location for pack-type child property

=end pod

sub gtk_box_query_child_packing ( N-GObject $box, N-GObject $child, int32 $expand, int32 $fill, uint32 $padding, int32 $pack_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_set_child_packing:
=begin pod
=head2 [[gtk_] box_] set_child_packing

Sets the way I<child> is packed into I<box>.

  method gtk_box_set_child_packing ( N-GObject $child, Int $expand, Int $fill, UInt $padding, GtkPackType $pack_type )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> of the child to set
=item Int $expand; the new value of the expand child property
=item Int $fill; the new value of the fill child property
=item UInt $padding; the new value of the padding child property
=item GtkPackType $pack_type; the new value of the pack-type child property

=end pod

sub gtk_box_set_child_packing ( N-GObject $box, N-GObject $child, int32 $expand, int32 $fill, uint32 $padding, int32 $pack_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_set_center_widget:
=begin pod
=head2 [[gtk_] box_] set_center_widget

Sets a center widget; that is a child widget that will be
centered with respect to the full width of the box, even
if the children at either side take up different amounts
of space.

Since: 3.12

  method gtk_box_set_center_widget ( N-GObject $widget )

=item N-GObject $widget; (allow-none): the widget to center

=end pod

sub gtk_box_set_center_widget ( N-GObject $box, N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_box_get_center_widget:
=begin pod
=head2 [[gtk_] box_] get_center_widget

Retrieves the center widget of the box.

Returns: (transfer none) (nullable): the center widget
or C<Any> in case no center widget is set.

Since: 3.12

  method gtk_box_get_center_widget ( --> N-GObject  )


=end pod

sub gtk_box_get_center_widget ( N-GObject $box )
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

=comment #TP:0:spacing:
=head3 Spacing

The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.

=comment #TP:0:homogeneous:
=head3 Homogeneous

Whether the children should all be the same size
Default value: False

The B<Gnome::GObject::Value> type of property I<homogeneous> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:baseline-position:
=head3 Baseline position

The position of the baseline aligned widgets if extra space is available
Default value: False

The B<Gnome::GObject::Value> type of property I<baseline-position> is C<G_TYPE_ENUM>.

=end pod
