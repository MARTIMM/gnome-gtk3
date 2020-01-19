#TL:1:Gnome::Gtk3::Grid:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Grid

Pack widgets in a rows and columns

=head1 Description

B<Gnome::Gtk3::Grid> is a container which arranges its child widgets in
rows and columns. It is a very similar to B<Gnome::Gtk3::Table> and B<Gnome::Gtk3::Box>,
but it consistently uses B<Gnome::Gtk3::Widget>’s  I<margin> and  I<expand>
properties instead of custom child properties, and it fully supports
height-for-width geometry management.

Children are added using C<gtk_grid_attach()>. They can span multiple
rows or columns. It is also possible to add a child next to an
existing child, using C<gtk_grid_attach_next_to()>. The behaviour of
B<Gnome::Gtk3::Grid> when several children occupy the same grid cell is undefined.

B<Gnome::Gtk3::Grid> can be used like a B<Gnome::Gtk3::Box> by just using C<gtk_container_add()>,
which will place children next to each other in the direction determined
by the  I<orientation> property.


=head2 Css Nodes

B<Gnome::Gtk3::Grid> uses a single CSS node with name grid.



=head2 Implemented Interfaces

Gnome::Gtk3::Grid implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item [Gnome::Gtk3::Orientable](Orientable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Grid;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gtk3::Container;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkGrid.html
unit class Gnome::Gtk3::Grid:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Grid';

  if ? %options<empty> {
    self.set-native-object(gtk_grid_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkGrid');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  try { $s = &::("gtk_grid_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkGrid');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_grid_new:
=begin pod
=head2 [gtk_] grid_new

Creates a new grid widget.

Returns: the new B<Gnome::Gtk3::Grid>

  method gtk_grid_new ( --> N-GObject  )


=end pod

sub gtk_grid_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_attach:
=begin pod
=head2 [gtk_] grid_attach

Adds a widget to the grid.

The position of I<child> is determined by I<left> and I<top>. The
number of “cells” that I<child> will occupy is determined by
I<width> and I<height>.

  method gtk_grid_attach ( N-GObject $child, Int $left, Int $top, Int $width, Int $height )

=item N-GObject $child; the widget to add
=item Int $left; the column number to attach the left side of I<child> to
=item Int $top; the row number to attach the top side of I<child> to
=item Int $width; the number of columns that I<child> will span
=item Int $height; the number of rows that I<child> will span

=end pod

sub gtk_grid_attach ( N-GObject $grid, N-GObject $child, int32 $left, int32 $top, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_attach_next_to:
=begin pod
=head2 [[gtk_] grid_] attach_next_to

Adds a widget to the grid.

The widget is placed next to I<$sibling>, on the side determined by
I<$side>. When I<$sibling> is C<Any>, the widget is placed in row (for
left or right placement) or column 0 (for top or bottom placement),
at the end indicated by I<side>.

Attaching widgets labeled [1], [2], [3] with I<$sibling> == C<Any> and
I<$side> == C<GTK_POS_LEFT> yields a layout of [3][2][1].

  method gtk_grid_attach_next_to ( N-GObject $child, N-GObject $sibling, GtkPositionType $side, Int $width, Int $height )

=item N-GObject $child; the widget to add
=item N-GObject $sibling; (allow-none): the child of the grid that I<$child> will be placed next to, or C<Any> to place I<$child> at the beginning or end
=item GtkPositionType $side; the side of I<$sibling> that I<$child> is positioned next to
=item Int $width; the number of columns that I<$child> will span
=item Int $height; the number of rows that I<$child> will span

=end pod

sub gtk_grid_attach_next_to ( N-GObject $grid, N-GObject $child, N-GObject $sibling, int32 $side, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_get_child_at:
=begin pod
=head2 [[gtk_] grid_] get_child_at

Gets the child of the grid whose area covers the grid
cell whose upper left corner is at I<$left>, I<$top>.

Returns: (transfer none) (nullable): the child at the given position, or C<Any>

Since: 3.2

  method gtk_grid_get_child_at ( Int $left, Int $top --> N-GObject  )

=item Int $left; the left edge of the cell
=item Int $top; the top edge of the cell

=end pod

sub gtk_grid_get_child_at ( N-GObject $grid, int32 $left, int32 $top )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_insert_row:
=begin pod
=head2 [[gtk_] grid_] insert_row

Inserts a row at the specified position.

Children which are attached at or below this position
are moved one row down. Children which span across this
position are grown to span the new row.

Since: 3.2

  method gtk_grid_insert_row ( Int $position )

=item Int $position; the position to insert the row at

=end pod

sub gtk_grid_insert_row ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_insert_column:
=begin pod
=head2 [[gtk_] grid_] insert_column

Inserts a column at the specified position.

Children which are attached at or to the right of this position
are moved one column to the right. Children which span across this
position are grown to span the new column.

Since: 3.2

  method gtk_grid_insert_column ( Int $position )

=item Int $position; the position to insert the column at

=end pod

sub gtk_grid_insert_column ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_remove_row:
=begin pod
=head2 [[gtk_] grid_] remove_row

Removes a row from the grid.

Children that are placed in this row are removed and destroyed, spanning children that overlap this row have their height reduced by one, and children below the row are moved up. The native object in the Raku object becomes invalid.

Since: 3.10

  method gtk_grid_remove_row ( Int $position )

=item Int $position; the position of the row to remove

=end pod

sub gtk_grid_remove_row ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_remove_column:
=begin pod
=head2 [[gtk_] grid_] remove_column

Removes a column from the grid.

Children that are placed in this column are removed, spanning children that overlap this column have their width reduced by one, and children after the column are moved to the left. The native object in the Raku object becomes invalid.

Since: 3.10

  method gtk_grid_remove_column ( Int $position )

=item Int $position; the position of the column to remove

=end pod

sub gtk_grid_remove_column ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_insert_next_to:
=begin pod
=head2 [[gtk_] grid_] insert_next_to

Inserts a row or column at the specified position.

The new row or column is placed next to I<$sibling>, on the side
determined by I<$side>. If I<$side> is C<GTK_POS_TOP> or C<GTK_POS_BOTTOM>,
a row is inserted. If I<$side> is C<GTK_POS_LEFT> of C<GTK_POS_RIGHT>,
a column is inserted.

Since: 3.2

  method gtk_grid_insert_next_to ( N-GObject $sibling, GtkPositionType $side )

=item N-GObject $sibling; the child of I<grid> that the new row or column will be placed next to
=item GtkPositionType $side; the side of I<sibling> that I<child> is positioned next to

=end pod

sub gtk_grid_insert_next_to ( N-GObject $grid, N-GObject $sibling, int32 $side )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_set_row_homogeneous:
=begin pod
=head2 [[gtk_] grid_] set_row_homogeneous

Sets whether all rows of the grid will have the same height.

  method gtk_grid_set_row_homogeneous ( Int $homogeneous )

=item Int $homogeneous; C<1> to make rows homogeneous

=end pod

sub gtk_grid_set_row_homogeneous ( N-GObject $grid, int32 $homogeneous )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_get_row_homogeneous:
=begin pod
=head2 [[gtk_] grid_] get_row_homogeneous

Returns whether all rows of the grid have the same height.

  method gtk_grid_get_row_homogeneous ( --> Int  )


=end pod

sub gtk_grid_get_row_homogeneous ( N-GObject $grid )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_set_row_spacing:
=begin pod
=head2 [[gtk_] grid_] set_row_spacing

Sets the amount of space between rows of the grid.

  method gtk_grid_set_row_spacing ( UInt $spacing )

=item UInt $spacing; the amount of space to insert between rows

=end pod

sub gtk_grid_set_row_spacing ( N-GObject $grid, uint32 $spacing )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_get_row_spacing:
=begin pod
=head2 [[gtk_] grid_] get_row_spacing

Returns the amount of space between the rows of I<grid>.

Returns: the row spacing of I<grid>

  method gtk_grid_get_row_spacing ( --> UInt  )


=end pod

sub gtk_grid_get_row_spacing ( N-GObject $grid )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_set_column_homogeneous:
=begin pod
=head2 [[gtk_] grid_] set_column_homogeneous

Sets whether all columns of I<grid> will have the same width.

  method gtk_grid_set_column_homogeneous ( Int $homogeneous )

=item Int $homogeneous; C<1> to make columns homogeneous

=end pod

sub gtk_grid_set_column_homogeneous ( N-GObject $grid, int32 $homogeneous )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_get_column_homogeneous:
=begin pod
=head2 [[gtk_] grid_] get_column_homogeneous

Returns whether all columns of I<grid> have the same width.

Returns: whether all columns of I<grid> have the same width.

  method gtk_grid_get_column_homogeneous ( --> Int  )


=end pod

sub gtk_grid_get_column_homogeneous ( N-GObject $grid )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_set_column_spacing:
=begin pod
=head2 [[gtk_] grid_] set_column_spacing

Sets the amount of space between columns of I<grid>.

  method gtk_grid_set_column_spacing ( UInt $spacing )

=item UInt $spacing; the amount of space to insert between columns

=end pod

sub gtk_grid_set_column_spacing ( N-GObject $grid, uint32 $spacing )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_grid_get_column_spacing:
=begin pod
=head2 [[gtk_] grid_] get_column_spacing

Returns the amount of space between the columns of I<grid>.

Returns: the column spacing of I<grid>

  method gtk_grid_get_column_spacing ( --> UInt  )


=end pod

sub gtk_grid_get_column_spacing ( N-GObject $grid )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_set_row_baseline_position:
=begin pod
=head2 [[gtk_] grid_] set_row_baseline_position

Sets how the baseline should be positioned on I<row> of the
grid, in case that row is assigned more space than is requested.

Since: 3.10

  method gtk_grid_set_row_baseline_position ( Int $row, GtkBaselinePosition $pos )

=item Int $row; a row index
=item GtkBaselinePosition $pos; a B<Gnome::Gtk3::BaselinePosition>

=end pod

sub gtk_grid_set_row_baseline_position ( N-GObject $grid, int32 $row, int32 $pos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_get_row_baseline_position:
=begin pod
=head2 [[gtk_] grid_] get_row_baseline_position

Returns the baseline position of I<row> as set
by C<gtk_grid_set_row_baseline_position()> or the default value
C<GTK_BASELINE_POSITION_CENTER>.

Returns: the baseline position of I<row>

Since: 3.10

  method gtk_grid_get_row_baseline_position ( Int $row --> GtkBaselinePosition  )

=item Int $row; a row index

=end pod

sub gtk_grid_get_row_baseline_position ( N-GObject $grid, int32 $row )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_set_baseline_row:
=begin pod
=head2 [[gtk_] grid_] set_baseline_row

Sets which row defines the global baseline for the entire grid.
Each row in the grid can have its own local baseline, but only
one of those is global, meaning it will be the baseline in the
parent of the I<grid>.

Since: 3.10

  method gtk_grid_set_baseline_row ( Int $row )

=item Int $row; the row index

=end pod

sub gtk_grid_set_baseline_row ( N-GObject $grid, int32 $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grid_get_baseline_row:
=begin pod
=head2 [[gtk_] grid_] get_baseline_row

Returns which row defines the global baseline of I<grid>.

Returns: the row index defining the global baseline

Since: 3.10

  method gtk_grid_get_baseline_row ( --> Int  )


=end pod

sub gtk_grid_get_baseline_row ( N-GObject $grid )
  returns int32
  is native(&gtk-lib)
  { * }


















=finish
#-------------------------------------------------------------------------------
sub gtk_grid_new()
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_grid_attach (
  N-GObject $grid, N-GObject $child, int32 $x, int32 $y, int32 $w, int32 $h
) is native(&gtk-lib)
  { * }

sub gtk_grid_insert_row ( N-GObject $grid, int32 $position)
  is native(&gtk-lib)
  { * }

sub gtk_grid_insert_column ( N-GObject $grid, int32 $position)
  is native(&gtk-lib)
  { * }

sub gtk_grid_get_child_at ( N-GObject $grid, uint32 $left, uint32 $top)
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_grid_set_row_spacing ( N-GObject $grid, uint32 $spacing)
  is native(&gtk-lib)
  { * }

sub gtk_grid_remove_row ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }

sub gtk_grid_remove_column ( N-GObject $grid, int32 $position )
  is native(&gtk-lib)
  { * }
