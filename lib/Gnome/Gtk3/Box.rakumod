#TL:1:Gnome::Gtk3::Box:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Box

A container box for packing widgets in a single row or column

=head1 Description

The B<Gnome::Gtk3::Box> widget arranges child widgets into a single row or column, depending upon the value of its  I<orientation> property. Within the other dimension, all children are allocated the same size. Of course, the  I<halign> and  I<valign> properties can be used on the children to influence their allocation.

B<Gnome::Gtk3::Box> uses a notion of packing. Packing refers to adding widgets with reference to a particular position in a B<Gnome::Gtk3::Container>. For a B<Gnome::Gtk3::Box>, there are two reference positions: the start and the end of the box. For a vertical B<Gnome::Gtk3::Box>, the start is defined as the top of the box and the end is defined as the bottom. For a horizontal B<Gnome::Gtk3::Box> the start is defined as the left side and the end is defined as the right side.

Use repeated calls to C<pack-start()> to pack widgets into a B<Gnome::Gtk3::Box> from start to end. Use C<gtk-box-pack-end()> to add widgets from end to start. You may intersperse these calls and add widgets from both ends of the same B<Gnome::Gtk3::Box>.

Because B<Gnome::Gtk3::Box> is a B<Gnome::Gtk3::Container>, you may also use C<gtk-container-add()> to insert widgets into the box, and they will be packed with the default values for expand and fill child properties. Use C<gtk-container-remove()> to remove widgets from the B<Gnome::Gtk3::Box>.

Use C<gtk-box-set-homogeneous()> to specify whether or not all children of the B<Gnome::Gtk3::Box> are forced to get the same amount of space.

Use C<gtk-box-set-spacing()> to determine how much space will be minimally placed between all children in the B<Gnome::Gtk3::Box>. Note that spacing is added between the children, while padding added by C<gtk-box-pack-start()> or C<gtk-box-pack-end()> is added on either side of the widget it belongs to.

Use C<gtk-box-reorder-child()> to move a B<Gnome::Gtk3::Box> child to a different place in the box.

Use C<gtk-box-set-child-packing()> to reset the expand, fill and padding child properties. Use C<gtk-box-query-child-packing()> to query these fields.


=head2 Css Nodes

B<Gnome::Gtk3::Box> uses a single CSS node with name box.

In horizontal orientation, the nodes of the children are always arranged from left to right. So C<first-child> will always select the leftmost child, regardless of text direction.


=head2 See Also

B<Gnome::Gtk3::Frame>, B<Gnome::Gtk3::Grid>, B<Gnome::Gtk3::Layout>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Box;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Orientable;

=comment also does Gnome::Atk::ImplementorIface


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Box:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Box;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Box class process the options
    self.bless( :GtkBox, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Container:api<1>;
use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Orientable:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Box:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new plain object growing horizontally. Default spacing between inserted widgets is by default 0 pixels.

  multi method new ( )


=head3 :spacing

Create a new plain object growing horizontally. Specify spacing between inserted widgets with C<:spacing>.

  multi method new ( Int() :$spacing )


=head3 :orientation, :spacing

Create a new plain object using orientation for extension of the container.

  multi method new (
    GtkOrientation :$orientation!, Int() :$spacing = 0
  )


=head3 :native-object

Create a Box object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Box object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:orientable):
#TM:1:new(:orientable,:spacing):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::Box' #`{{ or %options<GtkBox> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if %options<orientation>:exists {
        $no = _gtk_box_new(
          %options<orientation>, (%options<spacing> // 0).Int
        );
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_box_new(
          GTK_ORIENTATION_HORIZONTAL, (%options<spacing> // 0).Int
        );
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkBox');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_box_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_box_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('box-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-box-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkBox');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:get-baseline-position:
=begin pod
=head2 get-baseline-position

Gets the value set by C<set-baseline-position()>.

Returns: the baseline position

  method get-baseline-position ( --> GtkBaselinePosition )

=end pod

method get-baseline-position ( --> GtkBaselinePosition ) {
  GtkBaselinePosition(gtk_box_get_baseline_position(self._f('GtkBox')))
}

sub gtk_box_get_baseline_position (
  N-GObject $box --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-center-widget:
#TM:1:get-center-widget-rk:
=begin pod
=head2 get-center-widget, get-center-widget-rk

Retrieves the center widget of the box.

Returns: the center widget or C<undefined> in case no center widget is set.

  method get-center-widget ( --> N-GObject )
  method get-center-widget ( --> Gnome::GObject::Object )

=end pod

method get-center-widget ( --> N-GObject ) {
  gtk_box_get_center_widget(self._f('GtkBox'))
}

method get-center-widget-rk ( *%options --> Gnome::GObject::Object ) {
  my $o = self._wrap-native-type-from-no(
    gtk_box_get_center_widget(self._f('GtkBox')),
    |%options
  );

  $o ~~ N-GObject ?? Gnome::GObject::Widget.new(:native-object($o)) !! $o
}

sub gtk_box_get_center_widget (
  N-GObject $box --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-homogeneous:
=begin pod
=head2 get-homogeneous

Returns whether the box is homogeneous (all children are the same size). See C<set-homogeneous()>.

Returns: C<True> if the box is homogeneous.

  method get-homogeneous ( --> Bool )

=end pod

method get-homogeneous ( --> Bool ) {
  gtk_box_get_homogeneous(self._f('GtkBox')).Bool
}

sub gtk_box_get_homogeneous (
  N-GObject $box --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-spacing:
=begin pod
=head2 get-spacing

Gets the value set by C<set-spacing()>.

Returns: spacing between children

  method get-spacing ( --> Int )

=end pod

method get-spacing ( --> Int ) {

  gtk_box_get_spacing(
    self._f('GtkBox'),
  )
}

sub gtk_box_get_spacing (
  N-GObject $box --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-end:
=begin pod
=head2 pack-end

Adds I<child> to I<box>, packed with reference to the end of I<box>. The I<child> is packed after (away from end of) any other child packed with reference to the end of I<box>.

  method pack-end (
    N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
  )

=item $child; the B<Gnome::Gtk3::Widget> to be added to I<box>
=item $expand; C<True> if the new child is to be given extra space allocated to I<box>. The extra space will be divided evenly between all children of I<box> that use this option
=item $fill; C<True> if space given to I<child> by the I<expand> option is actually allocated to I<child>, rather than just padding it.  This parameter has no effect if I<expand> is set to C<False>.  A child is always allocated the full height of a horizontal B<Gnome::Gtk3::Box> and the full width of a vertical B<Gnome::Gtk3::Box>.  This option affects the other dimension
=item $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by  I<spacing> property.  If I<child> is a widget at one of the reference ends of I<box>, then I<padding> pixels are also put between I<child> and the reference edge of I<box>
=end pod

method pack-end (
  N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
) {
  gtk_box_pack_end(
    self._f('GtkBox'), $child, $expand, $fill, $padding
  );
}

sub gtk_box_pack_end (
  N-GObject $box, N-GObject $child, gboolean $expand, gboolean $fill, guint $padding
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-start:
=begin pod
=head2 pack-start

Adds I<child> to I<box>, packed with reference to the start of I<box>. The I<child> is packed after any other child packed with reference to the start of I<box>.

  method pack-start (
    N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
  )

=item $child; the B<Gnome::Gtk3::Widget> to be added to I<box>
=item $expand; C<True> if the new child is to be given extra space allocated to I<box>. The extra space will be divided evenly between all children that use this option
=item $fill; C<True> if space given to I<child> by the I<expand> option is actually allocated to I<child>, rather than just padding it.  This parameter has no effect if I<expand> is set to C<False>.  A child is always allocated the full height of a horizontal B<Gnome::Gtk3::Box> and the full width of a vertical B<Gnome::Gtk3::Box>. This option affects the other dimension
=item $padding; extra space in pixels to put between this child and its neighbors, over and above the global amount specified by  I<spacing> property.  If I<child> is a widget at one of the reference ends of I<box>, then I<padding> pixels are also put between I<child> and the reference edge of I<box>
=end pod

method pack-start (
  N-GObject() $child, Bool $expand, Bool $fill, UInt $padding
) {
  gtk_box_pack_start( self._f('GtkBox'), $child, $expand, $fill, $padding);
}

sub gtk_box_pack_start (
  N-GObject $box, N-GObject $child, gboolean $expand, gboolean $fill, guint $padding
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:query-child-packing:
=begin pod
=head2 query-child-packing

Obtains information about how I<child> is packed into I<box>.

  method query-child-packing ( N-GObject() $child --> List )

=item $child; the B<Gnome::Gtk3::Widget> of the child to query

The returned List contains;
=item $expand; expand child property
=item $fill; fill child property
=item $padding; padding child property
=item $pack_type; pack-type child property
=end pod

method query-child-packing ( N-GObject() $child --> List ) {

  my gboolean $expand;
  my gboolean $fill;
  my guint $padding;
  my GEnum $pack_type;

  gtk_box_query_child_packing(
    self._f('GtkBox'), $child, $expand, $fill, $padding, $pack_type
  );

  ( $expand ?? True !! False, $fill ?? True !! False, $padding,
    GtkPackType($pack_type)
  )
}

sub gtk_box_query_child_packing (
  N-GObject $box, N-GObject $child, gboolean $expand is rw,
  gboolean $fill is rw, guint $padding is rw, GEnum $pack_type is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:reorder-child:
=begin pod
=head2 reorder-child

Moves I<child> to a new I<position> in the list of I<box> children. The list contains widgets packed C<GTK-PACK-START> as well as widgets packed C<GTK-PACK-END>, in the order that these widgets were added to I<box>.

A widget’s position in the I<box> children list determines where the widget is packed into I<box>. A child widget at some position in the list will be packed just after all other widgets of the same packing type that appear earlier in the list.

  method reorder-child ( N-GObject() $child, Int() $position )

=item $child; the B<Gnome::Gtk3::Widget> to move
=item $position; the new position for I<child> in the list of children of I<box>, starting from 0. If negative, indicates the end of the list
=end pod

method reorder-child ( N-GObject() $child, Int() $position ) {
  gtk_box_reorder_child( self._f('GtkBox'), $child, $position);
}

sub gtk_box_reorder_child (
  N-GObject $box, N-GObject $child, gint $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-baseline-position:
=begin pod
=head2 set-baseline-position

Sets the baseline position of a box. This affects only horizontal boxes with at least one baseline aligned child. If there is more vertical space available than requested, and the baseline is not allocated by the parent then I<position> is used to allocate the baseline wrt the extra space available.

  method set-baseline-position ( GtkBaselinePosition $position )

=item $position; a B<Gnome::Gtk3::BaselinePosition>
=end pod

method set-baseline-position ( GtkBaselinePosition $position ) {
  gtk_box_set_baseline_position( self._f('GtkBox'), $position.value);
}

sub gtk_box_set_baseline_position (
  N-GObject $box, GEnum $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-center-widget:
=begin pod
=head2 set-center-widget

Sets a center widget; that is a child widget that will be centered with respect to the full width of the box, even if the children at either side take up different amounts of space.

  method set-center-widget ( N-GObject() $widget )

=item $widget; the widget to center
=end pod

method set-center-widget ( N-GObject() $widget ) {
  gtk_box_set_center_widget( self._f('GtkBox'), $widget);
}

sub gtk_box_set_center_widget (
  N-GObject $box, N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-child-packing:
=begin pod
=head2 set-child-packing

Sets the way I<child> is packed into I<box>.

  method set-child-packing (
    N-GObject() $child, Bool $expand, Bool $fill,
    UInt $padding, GtkPackType $pack_type
  )

=item $child; the B<Gnome::Gtk3::Widget> of the child to set
=item $expand; the new value of the expand child property
=item $fill; the new value of the fill child property
=item $padding; the new value of the padding child property
=item $pack_type; the new value of the pack-type child property
=end pod

method set-child-packing (
  N-GObject() $child, Bool $expand, Bool $fill, UInt $padding,
  GtkPackType $pack_type
) {
  gtk_box_set_child_packing(
    self._f('GtkBox'), $child, $expand, $fill, $padding, $pack_type
  );
}

sub gtk_box_set_child_packing (
  N-GObject $box, N-GObject $child, gboolean $expand, gboolean $fill, guint $padding, GEnum $pack_type
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-homogeneous:
=begin pod
=head2 set-homogeneous

Sets the  I<homogeneous> property of I<box>, controlling whether or not all children of I<box> are given equal space in the box.

  method set-homogeneous ( Bool $homogeneous )

=item $homogeneous; a boolean value, C<True> to create equal allotments, C<False> for variable allotments
=end pod

method set-homogeneous ( Bool $homogeneous ) {

  gtk_box_set_homogeneous(
    self._f('GtkBox'), $homogeneous
  );
}

sub gtk_box_set_homogeneous (
  N-GObject $box, gboolean $homogeneous
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-spacing:
=begin pod
=head2 set-spacing

Sets the  I<spacing> property of I<box>, which is the number of pixels to place between children of I<box>.

  method set-spacing ( Int() $spacing )

=item $spacing; the number of pixels to put between children
=end pod

method set-spacing ( Int() $spacing ) {

  gtk_box_set_spacing(
    self._f('GtkBox'), $spacing
  );
}

sub gtk_box_set_spacing (
  N-GObject $box, gint $spacing
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_box_new:
#`{{
=begin pod
=head2 _gtk_box_new

Creates a new B<Gnome::Gtk3::Box>.

Returns: a new B<Gnome::Gtk3::Box>.

  method _gtk_box_new ( GtkOrientation $orientation, Int() $spacing --> N-GObject )

=item $orientation; the box’s orientation.
=item $spacing; the number of pixels to place by default between children.
=end pod
}}

sub _gtk_box_new ( GEnum $orientation, gint $spacing --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_box_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:baseline-position:
=head2 baseline-position

The position of the baseline aligned widgets if extra space is available

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_BASELINE_POSITION
=item Parameter is readable and writable.
=item Default value is GTK_BASELINE_POSITION_CENTER.


=comment -----------------------------------------------------------------------
=comment #TP:1:homogeneous:
=head2 homogeneous

Whether the children should all be the same size

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:spacing:
=head2 spacing

The amount of space between children

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Child Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:expand:
=head2 expand

Whether the child should receive extra space when the parent grows

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:fill:
=head2 fill

Whether extra space given to the child should be allocated to the child or used as padding

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:pack-type:
=head2 pack-type

A GtkPackType indicating whether the child is packed with reference to the start or end of the parent

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_PACK_TYPE
=item Parameter is readable and writable.
=item Default value is GTK_PACK_START.


=comment -----------------------------------------------------------------------
=comment #TP:0:padding:
=head2 padding

Extra space to put between the child and its neighbors, in pixels

=item B<Gnome::GObject::Value> type of this property is G_TYPE_UINT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:position:
=head2 position

The index of the child in the parent

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is 0.

=end pod

















=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:baseline-position:
=head2 baseline-position

The position of the baseline aligned widgets if extra space is available

The B<Gnome::GObject::Value> type of property I<baseline-position> is C<G_TYPE_ENUM>.

=item Parameter is readable and writable.
=item Default value is GTK_BASELINE_POSITION_CENTER.


=comment -----------------------------------------------------------------------
=comment #TP:0:expand:
=head2 expand

Whether the child should receive extra space when the parent grows

The B<Gnome::GObject::Value> type of property I<expand> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:fill:
=head2 fill

Whether extra space given to the child should be allocated to the child or used as padding

The B<Gnome::GObject::Value> type of property I<fill> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:1:homogeneous:
=head2 homogeneous

Whether the children should all be the same size

The B<Gnome::GObject::Value> type of property I<homogeneous> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:pack-type:
=head2 pack-type

A GtkPackType indicating whether the child is packed with reference to the start or end of the parent

The B<Gnome::GObject::Value> type of property I<pack-type> is C<G_TYPE_ENUM>.

=item Parameter is readable and writable.
=item Default value is GTK_PACK_START.


=comment -----------------------------------------------------------------------
=comment #TP:0:padding:
=head2 padding

Extra space to put between the child and its neighbors, in pixels

The B<Gnome::GObject::Value> type of property I<padding> is C<G_TYPE_UINT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:position:
=head2 position

The index of the child in the parent

The B<Gnome::GObject::Value> type of property I<position> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:1:spacing:
=head2 spacing

The amount of space between children

The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.

=end pod





=finish

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:baseline-position:
=head3 Baseline position: baseline-position

The position of the baseline aligned widgets if extra space is available
Default value: False

The B<Gnome::GObject::Value> type of property I<baseline-position> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:1:homogeneous:
=head3 Homogeneous: homogeneous

Whether the children should all be the same size
Default value: False

The B<Gnome::GObject::Value> type of property I<homogeneous> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:spacing:
=head3 Spacing: spacing

The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.



=begin comment
--- Child properties ---
=comment -----------------------------------------------------------------------
=comment # TP:1:expand:
=head3 Expand: expand

Whether the child should receive extra space when the parent grows.

Note that the default value for this property is C<False> for GtkBox,
but B<Gnome::Gtk3::HBox>, B<Gnome::Gtk3::VBox> and other subclasses use the old default
of C<True>.

Note: The  I<hexpand> or  I<vexpand> properties are the
preferred way to influence whether the child receives extra space, by
setting the child’s expand property corresponding to the box’s orientation.

In contrast to  I<hexpand>, the expand child property does
   * not cause the box to expand itself.
The B<Gnome::GObject::Value> type of property I<expand> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment # TP:1:fill:
=head3 Fill: fill

Whether the child should fill extra space or use it as padding.

Note: The  I<halign> or  I<valign> properties are the
preferred way to influence whether the child fills available space, by
setting the child’s align property corresponding to the box’s orientation
   * to C<GTK-ALIGN-FILL> to fill, or to something else to refrain from filling.
The B<Gnome::GObject::Value> type of property I<fill> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment # TP:0:pack-type:
=head3 Pack type: pack-type

A GtkPackType indicating whether the child is packed with reference to the start or end of the parent
Default value: False

The B<Gnome::GObject::Value> type of property I<pack-type> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment # TP:1:padding:
=head3 Padding: padding


Extra space to put between the child and its neighbors, in pixels.

Note: The CSS padding properties are the preferred way to add space among
   * widgets, by setting the paddings corresponding to the box’s orientation.
The B<Gnome::GObject::Value> type of property I<padding> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment # TP:1:position:
=head3 Position: position

The B<Gnome::GObject::Value> type of property I<position> is C<G_TYPE_INT>.

=end pod
