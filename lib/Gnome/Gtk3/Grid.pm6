#TL:1:Gnome::Gtk3::Grid:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Grid

Pack widgets in a rows and columns

=head1 Description

B<Gnome::Gtk3::Grid> is a container which arranges its child widgets in rows and columns, with arbitrary positions and horizontal/vertical spans.

Children are added using C<gtk_grid_attach()>. They can span multiple rows or columns. It is also possible to add a child next to an existing child, using C<gtk_grid_attach_next_to()>. The behaviour of B<Gnome::Gtk3::Grid> when several children occupy the same grid cell is undefined.

B<Gnome::Gtk3::Grid> can be used like a B<Gnome::Gtk3::Box> by just using C<gtk_container_add()>, which will place children next to each other in the direction determined by the  I<orientation> property. However, if all you want is a single row or column, then B<Gnome::Gtk3::Box> is the preferred widget.

Note that the HBox and VBox is deprecated and therefore not implemented in this Raku package.


=head2 Css Nodes

B<Gnome::Gtk3::Grid> uses a single CSS node with name grid.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Grid;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Orientable;


=head2 Uml Diagram

![](plantuml/Grid.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Grid;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Grid;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Grid class process the options
    self.bless( :GtkGrid, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;

use Gnome::Gtk3::Container;
use Gnome::Gtk3::Orientable;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkGrid.html
unit class Gnome::Gtk3::Grid:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 default, no options

Create a new Grid object.

  multi method new ( )

=head3 :native-object

Create a Grid object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a Grid object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:4:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Grid' or %options<GtkGrid> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      self.set-native-object(_gtk_grid_new());
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkGrid');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  try { $s = &::("gtk_grid_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkGrid');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:attach:
=begin pod
=head2 attach

Adds a widget to the grid.  The position of I<$child> is determined by I<$left> and I<$top>. The number of “cells” that I<$child> will occupy is determined by I<$width> and I<$height>.

  method attach (
    N-GObject $child, Int $left, Int $top, Int $width, Int $height
  )

=item N-GObject $child; the widget to add
=item Int $left; the column number to attach the left side of I<child> to
=item Int $top; the row number to attach the top side of I<child> to
=item Int $width; the number of columns that I<child> will span
=item Int $height; the number of rows that I<child> will span

=end pod

method attach ( $child, Int $left, Int $top, Int $width, Int $height ) {
  my $no = $child;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_grid_attach(
    self.get-native-object-no-reffing, $no, $left, $top, $width, $height
  );
}

sub gtk_grid_attach ( N-GObject $grid, N-GObject $child, gint $left, gint $top, gint $width, gint $height  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:attach-next-to:
=begin pod
=head2 attach-next-to

Adds a widget to the grid.  The widget is placed next to I<$sibling>, on the side determined by I<$side>. When I<$sibling> is undefined, the widget is placed in row (for left or right placement) or column 0 (for top or bottom placement), at the end indicated by I<$side>.  Attaching widgets labeled [1], [2], [3] with I<$sibling> == C<Any> and I<$side> == C<GTK_POS_LEFT> yields a layout of [3][2][1].

  method attach-next-to (
    N-GObject $child, N-GObject $sibling,
    GtkPositionType $side, Int $width, Int $height
  )

=item N-GObject $child; the widget to add
=item N-GObject $sibling; (allow-none): the child of I<grid> that I<child> will be placed next to, or C<Any> to place I<child> at the beginning or end
=item GtkPositionType $side; the side of I<sibling> that I<child> is positioned next to
=item Int $width; the number of columns that I<child> will span
=item Int $height; the number of rows that I<child> will span

=end pod

method attach-next-to (
  $child, $sibling, GtkPositionType $side, Int $width, Int $height
) {
  my $no1 = $child;
  $no1 .= get-native-object-no-reffing unless $no1 ~~ N-GObject;
  my $no2 = $sibling;
  $no2 .= get-native-object-no-reffing unless $no2 ~~ N-GObject;

  gtk_grid_attach_next_to(
    self.get-native-object-no-reffing, $no1, $no2, $side.value, $width, $height
  );
}

sub gtk_grid_attach_next_to ( N-GObject $grid, N-GObject $child, N-GObject $sibling, GEnum $side, gint $width, gint $height  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-baseline-row:
=begin pod
=head2 get-baseline-row

Returns which row defines the global baseline of I<grid>.

  method get-baseline-row ( --> Int )

=end pod

method get-baseline-row ( --> Int ) {
  gtk_grid_get_baseline_row(
    self.get-native-object-no-reffing,
  );
}

sub gtk_grid_get_baseline_row ( N-GObject $grid --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-child-at:
#TM:1:get-child-at-rk:
=begin pod
=head2 get-child-at, get-child-at-rk

Gets the child of I<grid> whose area covers the grid cell whose upper left corner is at I<left>, I<top>.

Returns: the child (a native object) at the given position, or undefined. In the C<get-child-at-rk> the raku object which can be an invalid object.

  method get-child-at ( Int $left, Int $top --> N-GObject )
  method get-child-at-rk (
    Int $left, Int $top, :$child-type?
    --> Gnome::GObject::Object
  )

=item Int $left; the left edge of the cell
=item Int $top; the top edge of the cell
=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.

=head3 Example

  my Gnome::Gtk3::Button $button .= new(:label('press here'));
  $g.attach( $button, 0, 0, 1, 1);
  …
  # Some time later and elsewhere
  my Gnome::Gtk3::Button $b = $g.get-child-at-rk( 0, 0);
  if $b.is-valid {
    …
  }

=end pod

method get-child-at ( Int $left, Int $top --> N-GObject ) {
  gtk_grid_get_child_at(
    self.get-native-object-no-reffing, $left, $top
  );
}

method get-child-at-rk (
  Int $left, Int $top, *%options --> Gnome::GObject::Object
) {
  self._wrap-native-type-from-no(
    gtk_grid_get_child_at( self.get-native-object-no-reffing, $left, $top),
    |%options
  );
}

sub gtk_grid_get_child_at ( N-GObject $grid, gint $left, gint $top --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-column-homogeneous:
=begin pod
=head2 get-column-homogeneous

Returns whether all columns of I<grid> have the same width.

  method get-column-homogeneous ( --> Bool )

=end pod

method get-column-homogeneous ( --> Bool ) {
  gtk_grid_get_column_homogeneous(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_grid_get_column_homogeneous ( N-GObject $grid --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-column-spacing:
=begin pod
=head2 get-column-spacing

Returns the amount of space between the columns of I<grid>.

  method get-column-spacing ( --> UInt )

=end pod

method get-column-spacing ( --> UInt ) {
  gtk_grid_get_column_spacing(
    self.get-native-object-no-reffing,
  );
}

sub gtk_grid_get_column_spacing ( N-GObject $grid --> guint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-row-baseline-position:
=begin pod
=head2 get-row-baseline-position

Returns the baseline position of I<row> as set by C<gtk_grid_set_row_baseline_position()> or the default value C<GTK_BASELINE_POSITION_CENTER>.

Returns: the baseline position of I<row>

  method get-row-baseline-position (
    Int $row --> GtkBaselinePosition
  )

=item Int $row; a row index

=end pod

method get-row-baseline-position ( Int $row --> GtkBaselinePosition ) {
  GtkBaselinePosition(
    gtk_grid_get_row_baseline_position(
      self.get-native-object-no-reffing, $row
    )
  );
}

sub gtk_grid_get_row_baseline_position ( N-GObject $grid, gint $row --> GEnum )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-row-homogeneous:
=begin pod
=head2 get-row-homogeneous

Returns whether all rows of I<grid> have the same height.

  method get-row-homogeneous ( --> Bool )

=end pod

method get-row-homogeneous ( --> Bool ) {
  gtk_grid_get_row_homogeneous(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_grid_get_row_homogeneous ( N-GObject $grid --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-row-spacing:
=begin pod
=head2 get-row-spacing

Returns the amount of space between the rows of I<grid>.

Returns: the row spacing of I<grid>

  method get-row-spacing ( --> UInt )

=end pod

method get-row-spacing ( --> UInt ) {
  gtk_grid_get_row_spacing(
    self.get-native-object-no-reffing,
  );
}

sub gtk_grid_get_row_spacing ( N-GObject $grid --> guint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:insert-row:
=begin pod
=head2 insert-row

Inserts a row at the specified position.  Children which are attached at or below this position are moved one row down. Children which span across this position are grown to span the new row.

  method insert-row ( Int $position )

=item Int $position; the position to insert the row at

=end pod

method insert-row ( Int $position ) {
  gtk_grid_insert_row(
    self.get-native-object-no-reffing, $position
  );
}

sub gtk_grid_insert_row ( N-GObject $grid, gint $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:insert-column:
=begin pod
=head2 insert-column

Inserts a column at the specified position.  Children which are attached at or to the right of this position are moved one column to the right. Children which span across this position are grown to span the new column.

  method insert-column ( Int $position )

=item Int $position; the position to insert the column at

=end pod

method insert-column ( Int $position ) {
  gtk_grid_insert_column(
    self.get-native-object-no-reffing, $position
  );
}

sub gtk_grid_insert_column ( N-GObject $grid, gint $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-next-to:
=begin pod
=head2 insert-next-to

Inserts a row or column at the specified position.  The new row or column is placed next to I<sibling>, on the side determined by I<side>. If I<side> is C<GTK_POS_TOP> or C<GTK_POS_BOTTOM>, a row is inserted. If I<side> is C<GTK_POS_LEFT> of C<GTK_POS_RIGHT>, a column is inserted.

  method insert-next-to ( N-GObject $sibling, GtkPositionType $side )

=item N-GObject $sibling; the child of I<grid> that the new row or column will be placed next to
=item GtkPositionType $side; the side of I<sibling> that I<child> is positioned next to

=end pod

method insert-next-to ( $sibling, GtkPositionType $side ) {
  my $no = $sibling;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_grid_insert_next_to(
    self.get-native-object-no-reffing, $no, $side
  );
}

sub gtk_grid_insert_next_to (
  N-GObject $grid, N-GObject $sibling, GEnum $side
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:remove-column:
=begin pod
=head2 remove-column

Removes a column from the grid.  Children that are placed in this column are removed, spanning children that overlap this column have their width reduced by one, and children after the column are moved to the left.

  method remove-column ( Int $position )

=item Int $position; the position of the column to remove

=end pod

method remove-column ( Int $position ) {
  gtk_grid_remove_column(
    self.get-native-object-no-reffing, $position
  );
}

sub gtk_grid_remove_column ( N-GObject $grid, gint $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-row:
=begin pod
=head2 remove-row

Removes a row from the grid.  Children that are placed in this row are removed, spanning children that overlap this row have their height reduced by one, and children below the row are moved up.

  method remove-row ( Int $position )

=item Int $position; the position of the row to remove

=end pod

method remove-row ( Int $position ) {
  gtk_grid_remove_row( self.get-native-object-no-reffing, $position);
}

sub gtk_grid_remove_row ( N-GObject $grid, gint $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-baseline-row:
=begin pod
=head2 set-baseline-row

Sets which row defines the global baseline for the entire grid. Each row in the grid can have its own local baseline, but only one of those is global, meaning it will be the baseline in the parent of the I<grid>.

  method set-baseline-row ( Int $row )

=item Int $row; the row index

=end pod

method set-baseline-row ( Int $row ) {
  gtk_grid_set_baseline_row( self.get-native-object-no-reffing, $row);
}

sub gtk_grid_set_baseline_row ( N-GObject $grid, gint $row  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-column-homogeneous:
=begin pod
=head2 set-column-homogeneous

Sets whether all columns of I<grid> will have the same width.

  method set-column-homogeneous ( Bool $homogeneous )

=item Int $homogeneous; C<True> to make columns homogeneous

=end pod

method set-column-homogeneous ( Bool $homogeneous ) {
  gtk_grid_set_column_homogeneous(
    self.get-native-object-no-reffing, $homogeneous.Int
  );
}

sub gtk_grid_set_column_homogeneous ( N-GObject $grid, gboolean $homogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-column-spacing:
=begin pod
=head2 set-column-spacing

Sets the amount of space between columns of I<grid>.

  method set-column-spacing ( UInt $spacing )

=item UInt $spacing; the amount of space to insert between columns

=end pod

method set-column-spacing ( UInt $spacing ) {
  gtk_grid_set_column_spacing(
    self.get-native-object-no-reffing, $spacing
  );
}

sub gtk_grid_set_column_spacing ( N-GObject $grid, guint $spacing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-row-baseline-position:
=begin pod
=head2 set-row-baseline-position

Sets how the baseline should be positioned on I<row> of the grid, in case that row is assigned more space than is requested.

  method set-row-baseline-position (
    Int $row, GtkBaselinePosition $pos
  )

=item Int $row; a row index
=item GtkBaselinePosition $pos; an enumeration type

=end pod

method set-row-baseline-position ( Int $row, GtkBaselinePosition $pos ) {
  gtk_grid_set_row_baseline_position(
    self.get-native-object-no-reffing, $row, $pos.value
  );
}

sub gtk_grid_set_row_baseline_position ( N-GObject $grid, gint $row, GEnum $pos  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-row-homogeneous:
=begin pod
=head2 set-row-homogeneous

Sets whether all rows of I<grid> will have the same height.

  method set-row-homogeneous ( Bool $homogeneous )

=item Int $homogeneous; C<True> to make rows homogeneous

=end pod

method set-row-homogeneous ( Bool $homogeneous ) {
  gtk_grid_set_row_homogeneous(
    self.get-native-object-no-reffing, $homogeneous.Int
  );
}

sub gtk_grid_set_row_homogeneous ( N-GObject $grid, gboolean $homogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-row-spacing:
=begin pod
=head2 set-row-spacing

Sets the amount of space between rows of I<grid>.

  method set-row-spacing ( UInt $spacing )

=item UInt $spacing; the amount of space to insert between rows

=end pod

method set-row-spacing ( UInt $spacing ) {
  gtk_grid_set_row_spacing(
    self.get-native-object-no-reffing, $spacing
  );
}

sub gtk_grid_set_row_spacing ( N-GObject $grid, guint $spacing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_grid_new:
#`{{
=begin pod
=head2 _gtk_grid_new

Creates a new grid widget.

Returns: the new B<Gnome::Gtk3::Grid>

  method _gtk_grid_new ( --> N-GObject )

=end pod
}}

sub _gtk_grid_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_grid_new')
  { * }
