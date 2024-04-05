#TL:1:Gnome::Gtk3::TreeViewColumn:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeViewColumn

A visible column in a B<Gnome::Gtk3::TreeView> widget

=head1 Description

The B<Gnome::Gtk3::TreeViewColumn> object represents a visible column in a B<Gnome::Gtk3::TreeView> widget. It allows to set properties of the column header, and functions as a holding pen for the cell renderers which determine how the data in the column is displayed.

Please refer to the [tree widget conceptual overview][TreeWidget] for an overview of all the objects and data types related to the tree widget and how they work together.


=head2 See Also

B<Gnome::Gtk3::TreeView>, B<Gnome::Gtk3::TreeSelection>, B<Gnome::Gtk3::TreeModel>, B<Gnome::Gtk3::TreeSortable>,


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeViewColumn;
  also is Gnome::GObject::InitiallyUnowned;
  also does Gnome::Gtk3::Buildable;
  also does Gnome::Gtk3::CellLayout;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::GObject::InitiallyUnowned:api<1>;
use Gnome::Gtk3::Buildable:api<1>;
use Gnome::Gtk3::TreeIter:api<1>;
use Gnome::Gtk3::CellLayout:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TreeViewColumn:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::InitiallyUnowned;
also does Gnome::Gtk3::Buildable;
also does Gnome::Gtk3::CellLayout;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTreeViewColumnSizing

The sizing method the column uses to determine its width.  Please note
that I<GTK_TREE_VIEW_COLUMN_AUTOSIZE> are inefficient for large views, and
can make columns appear choppy.


=item GTK_TREE_VIEW_COLUMN_GROW_ONLY: Columns only get bigger in reaction to changes in the model
=item GTK_TREE_VIEW_COLUMN_AUTOSIZE: Columns resize to be the optimal size everytime the model changes.
=item GTK_TREE_VIEW_COLUMN_FIXED: Columns are a fixed numbers of pixels wide.


=end pod

#TE:1:GtkTreeViewColumnSizing:
enum GtkTreeViewColumnSizing is export (
  'GTK_TREE_VIEW_COLUMN_GROW_ONLY',
  'GTK_TREE_VIEW_COLUMN_AUTOSIZE',
  'GTK_TREE_VIEW_COLUMN_FIXED'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

=begin comment
Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():
#TM:1:new(:column):
# TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<clicked>,
  ) unless $signals-added;


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TreeViewColumn' #`{{ or %options<GtkTreeViewColumn> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all named arguments

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;

      if ? %options<column> {
        Gnome::N::deprecate(
          '.new(:column)', '.new(:native-object)', '0.34.0', '0.39.0'
        );
        my $no = %options<column>;
        $no = $no._get-native-object-no-reffing
          if $no.^can('_get-native-object-no-reffing');

#        self._set-native-object(%options<column>);
      }

#      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
#      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      else {
        $no = _gtk_tree_view_column_new;
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkTreeViewColumn');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_view_column_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self._set-class-name-of-sub('GtkTreeViewColumn');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_tree_view_column_new:new()
#`{{
=begin pod
=head2 [gtk_] tree_view_column_new

Creates a new B<Gnome::Gtk3::TreeViewColumn>.

Returns: A newly created B<Gnome::Gtk3::TreeViewColumn>.

  method gtk_tree_view_column_new ( --> N-GObject  )


=end pod
}}

sub _gtk_tree_view_column_new ( --> N-GObject )
  is symbol('gtk_tree_view_column_new')
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_new_with_area:
=begin pod
=head2 [[gtk_] tree_view_column_] new_with_area

Creates a new B<Gnome::Gtk3::TreeViewColumn> using I<area> to render its cells.

Returns: A newly created B<Gnome::Gtk3::TreeViewColumn>.

  method gtk_tree_view_column_new_with_area ( N-GObject $area --> N-GObject  )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> that the newly created column should use to layout cells.

=end pod

sub gtk_tree_view_column_new_with_area ( N-GObject $area )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_new_with_attributes:
=begin pod
=head2 [[gtk_] tree_view_column_] new_with_attributes

Creates a new B<Gnome::Gtk3::TreeViewColumn> with a number of default values. This is equivalent to calling C<gtk_tree_view_column_set_title()>, C<gtk_tree_view_column_pack_start()>, and C<gtk_tree_view_column_set_attributes()> on the newly created B<Gnome::Gtk3::TreeViewColumn>.

Here’s a simple example:
|[<!-- language="C" -->
enum { TEXT_COLUMN, COLOR_COLUMN, N_COLUMNS };
...
{
B<Gnome::Gtk3::TreeViewColumn> *column;
B<Gnome::Gtk3::CellRenderer>   *renderer = C<gtk_cell_renderer_text_new()>;

column = gtk_tree_view_column_new_with_attributes ("Title",
renderer,
"text", TEXT_COLUMN,
"foreground", COLOR_COLUMN,
NULL);
}
]|

Returns: A newly created B<Gnome::Gtk3::TreeViewColumn>.

  method gtk_tree_view_column_new_with_attributes ( Str $title, N-GObject $cell --> N-GObject  )

=item Str $title; The title to set the header to
=item N-GObject $cell; The B<Gnome::Gtk3::CellRenderer> @...: A C<Any>-terminated list of attributes

=end pod

sub gtk_tree_view_column_new_with_attributes (
  Str $title, N-GObject $cell, Any $any = Any
)



  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:1:gtk_tree_view_column_pack_start:
=begin pod
=head2 [[gtk_] tree_view_column_] pack_start

Packs the I<$cell> into the beginning of the column. If I<$expand> is C<0>, then the I<$cell> is allocated no more space than it needs. Any unused space is divided evenly between cells for which I<$expand> is C<1>.

  method gtk_tree_view_column_pack_start (
    Gnome::Gtk3::CellRenderer $cell, Int $expand
  )

=item Gnome::Gtk3::CellRenderer $cell; The renderer.
=item Int $expand; C<1> if I<$cell> is to be given extra space allocated to this tree column.

=end pod

sub gtk_tree_view_column_pack_start ( N-GObject $tree_column, N-GObject $cell, int32 $expand )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:1:gtk_tree_view_column_pack_end:
=begin pod
=head2 [[gtk_] tree_view_column_] pack_end

Adds the I<$cell> to end of the column. If I<$expand> is C<0>, then the I<$cell> is allocated no more space than it needs. Any unused space is divided evenly between cells for which I<$expand> is C<1>.

  method gtk_tree_view_column_pack_end ( N-GObject $cell, Int $expand )

=item Gnome::Gtk3::CellRenderer $cell; The renderer.
=item Int $expand; C<1> if I<$cell> is to be given extra space allocated to this tree column.

=end pod

sub gtk_tree_view_column_pack_end ( N-GObject $tree_column, N-GObject $cell, int32 $expand )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_clear:
=begin pod
=head2 [gtk_] tree_view_column_clear

Unsets all the mappings on all renderers on this tree column.

  method gtk_tree_view_column_clear ( )

=end pod

sub gtk_tree_view_column_clear ( N-GObject $tree_column )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:1:gtk_tree_view_column_add_attribute:
=begin pod
=head2 [[gtk_] tree_view_column_] add_attribute

Adds an attribute mapping to the list in this tree column.  The I<$column> is the column of the model to get a value from, and the I<$attribute> is the parameter on I<$cell_renderer> to be set from the value. So for example if column 2 of the model contains strings, you could have the “text” attribute of a B<Gnome::Gtk3::CellRendererText> get its values from column 2.

  method gtk_tree_view_column_add_attribute (
    Gnome::Gtk3::CellRenderer $cell_renderer, Str $attribute, Int $column
  )

=item Gnome::Gtk3::CellRenderer $cell_renderer; the renderer to set attributes on
=item Str $attribute; An attribute on the renderer
=item Int $column; The column position on the model to get the attribute from.

=end pod

sub gtk_tree_view_column_add_attribute ( N-GObject $tree_column, N-GObject $cell_renderer, Str $attribute, int32 $column )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_view_column_set_attributes:
=begin pod
=head2 [[gtk_] tree_view_column_] set_attributes

Sets the attributes in the list as the attributes of I<tree_column>.
The attributes should be in attribute/column order, as in
C<gtk_tree_view_column_add_attribute()>. All existing attributes
are removed, and replaced with the new attributes.

  method gtk_tree_view_column_set_attributes ( N-GObject $cell_renderer )

=item N-GObject $cell_renderer; the B<Gnome::Gtk3::CellRenderer> we’re setting the attributes of @...: A C<Any>-terminated list of attributes

=end pod

sub gtk_tree_view_column_set_attributes ( N-GObject $tree_column, N-GObject $cell_renderer, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_view_column_set_cell_data_func:
=begin pod
=head2 [[gtk_] tree_view_column_] set_cell_data_func

Sets the B<Gnome::Gtk3::TreeCellDataFunc> to use for the column.  This
function is used instead of the standard attributes mapping for
setting the column value, and should set the value of I<tree_column>'s
cell renderer as appropriate.  I<func> may be C<Any> to remove an
older one.

  method gtk_tree_view_column_set_cell_data_func ( N-GObject $cell_renderer, GtkTreeCellDataFunc $func, Pointer $func_data, GDestroyNotify $destroy )

=item N-GObject $cell_renderer; A B<Gnome::Gtk3::CellRenderer>
=item GtkTreeCellDataFunc $func; (allow-none): The B<Gnome::Gtk3::TreeCellDataFunc> to use.
=item Pointer $func_data; (closure): The user data for I<func>.
=item GDestroyNotify $destroy; The destroy notification for I<func_data>

=end pod

sub gtk_tree_view_column_set_cell_data_func ( N-GObject $tree_column, N-GObject $cell_renderer, GtkTreeCellDataFunc $func, Pointer $func_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#`{{ available in CellLayout
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_view_column_clear_attributes:
=begin pod
=head2 [[gtk_] tree_view_column_] clear_attributes

Clears all existing attributes previously set with C<gtk_tree_view_column_set_attributes()>.

  method gtk_tree_view_column_clear_attributes (
    Gnome::Gtk3::CellRenderer $cell_renderer
  )

=item Gnome::Gtk3::CellRenderer $cell_renderer; a renderer to clear the attribute mapping on.

=end pod

sub gtk_tree_view_column_clear_attributes ( N-GObject $tree_column, N-GObject $cell_renderer )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_spacing:
=begin pod
=head2 [[gtk_] tree_view_column_] set_spacing

Sets the spacing field of this tree column, which is the number of pixels to place between cell renderers packed into it.

  method gtk_tree_view_column_set_spacing ( Int $spacing )

=item Int $spacing; distance between cell renderers in pixels.

=end pod

sub gtk_tree_view_column_set_spacing ( N-GObject $tree_column, int32 $spacing )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_spacing:
=begin pod
=head2 [[gtk_] tree_view_column_] get_spacing

Returns the spacing of this tree column.

  method gtk_tree_view_column_get_spacing ( --> Int  )


=end pod

sub gtk_tree_view_column_get_spacing ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_visible:
=begin pod
=head2 [[gtk_] tree_view_column_] set_visible

Sets the visibility of this tree column.

  method gtk_tree_view_column_set_visible ( Int $visible )

=item Int $visible; C<1> if the tree column is visible.

=end pod

sub gtk_tree_view_column_set_visible ( N-GObject $tree_column, int32 $visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_visible:
=begin pod
=head2 [[gtk_] tree_view_column_] get_visible

Returns C<1> if this tree column is visible. If it is visible, then the tree will show the column.

  method gtk_tree_view_column_get_visible ( --> Int  )


=end pod

sub gtk_tree_view_column_get_visible ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_resizable:
=begin pod
=head2 [[gtk_] tree_view_column_] set_resizable

If I<$resizable> is C<1>, then the user can explicitly resize the column by grabbing the outer edge of the column button.  If resizable is C<1> and sizing mode of the column is B<GTK_TREE_VIEW_COLUMN_AUTOSIZE>, then the sizing mode is changed to B<GTK_TREE_VIEW_COLUMN_GROW_ONLY>.

  method gtk_tree_view_column_set_resizable ( Int $resizable )

=item Int $resizable; C<1>, if the column can be resized

=end pod

sub gtk_tree_view_column_set_resizable ( N-GObject $tree_column, int32 $resizable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_resizable:
=begin pod
=head2 [[gtk_] tree_view_column_] get_resizable

Returns C<1> if this tree column can be resized by the end user.

  method gtk_tree_view_column_get_resizable ( --> Int  )

=end pod

sub gtk_tree_view_column_get_resizable ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_set_sizing:
=begin pod
=head2 [[gtk_] tree_view_column_] set_sizing

Sets the growth behavior of this tree column to I<$type>.

  method gtk_tree_view_column_set_sizing ( GtkTreeViewColumnSizing $type )

=item GtkTreeViewColumnSizing $type; An enumeration of types of sizing.

=end pod

sub gtk_tree_view_column_set_sizing ( N-GObject $tree_column, int32 $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_get_sizing:
=begin pod
=head2 [[gtk_] tree_view_column_] get_sizing

Returns the current type of this tree column.

  method gtk_tree_view_column_get_sizing ( --> GtkTreeViewColumnSizing  )


=end pod

sub gtk_tree_view_column_get_sizing ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_x_offset:
=begin pod
=head2 [[gtk_] tree_view_column_] get_x_offset

Returns the current X offset of this tree column in pixels.

  method gtk_tree_view_column_get_x_offset ( --> Int  )

=end pod

sub gtk_tree_view_column_get_x_offset ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_width:
=begin pod
=head2 [[gtk_] tree_view_column_] get_width

Returns the current size of this tree column in pixels.

  method gtk_tree_view_column_get_width ( --> Int  )

=end pod

sub gtk_tree_view_column_get_width ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_fixed_width:
=begin pod
=head2 [[gtk_] tree_view_column_] get_fixed_width

Gets the fixed width of the column.  This may not be the actual displayed width of the column; for that, use C<gtk_tree_view_column_get_width()>.

Returns: The fixed width of the column.

  method gtk_tree_view_column_get_fixed_width ( --> Int  )


=end pod

sub gtk_tree_view_column_get_fixed_width ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_fixed_width:
=begin pod
=head2 [[gtk_] tree_view_column_] set_fixed_width

If I<$fixed_width> is not -1, sets the fixed width of this tree column; otherwise unsets it.  The effective value of I<fixed_width> is clamped between the minimum and maximum width of the column; however, the value stored in the “fixed-width” property is not clamped.  If the column sizing is B<GTK_TREE_VIEW_COLUMN_GROW_ONLY> or B<GTK_TREE_VIEW_COLUMN_AUTOSIZE>, setting a fixed width overrides the automatically calculated width.  Note that I<$fixed_width> is only a hint to GTK+; the width actually allocated to the column may be greater or less than requested.

Along with “expand”, the “fixed-width” property changes when the column is resized by the user.

  method gtk_tree_view_column_set_fixed_width ( Int $fixed_width )

=item Int $fixed_width; The new fixed width, in pixels, or -1.

=end pod

sub gtk_tree_view_column_set_fixed_width ( N-GObject $tree_column, int32 $fixed_width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_min_width:
=begin pod
=head2 [[gtk_] tree_view_column_] set_min_width

Sets the minimum width of the this tree column.  If I<$min_width> is -1, then the minimum width is unset.

  method gtk_tree_view_column_set_min_width ( Int $min_width )

=item Int $min_width; The minimum width of the column in pixels, or -1.

=end pod

sub gtk_tree_view_column_set_min_width ( N-GObject $tree_column, int32 $min_width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_min_width:
=begin pod
=head2 [[gtk_] tree_view_column_] get_min_width

Returns the minimum width in pixels of the this tree column, or -1 if no minimum width is set.

  method gtk_tree_view_column_get_min_width ( --> Int  )


=end pod

sub gtk_tree_view_column_get_min_width ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_max_width:
=begin pod
=head2 [[gtk_] tree_view_column_] set_max_width

Sets the maximum width of the this tree column.  If I<#max_width> is -1, then the maximum width is unset.  Note, the column can actually be wider than max width if it’s the last column in a view.  In this case, the column expands to fill any extra space.

  method gtk_tree_view_column_set_max_width ( Int $max_width )

=item Int $max_width; The maximum width of the column in pixels, or -1.

=end pod

sub gtk_tree_view_column_set_max_width ( N-GObject $tree_column, int32 $max_width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_max_width:
=begin pod
=head2 [[gtk_] tree_view_column_] get_max_width

Returns the maximum width in pixels of the this tree column, or -1 if no maximum width is set.

  method gtk_tree_view_column_get_max_width ( --> Int  )

=end pod

sub gtk_tree_view_column_get_max_width ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_clicked:
=begin pod
=head2 [gtk_] tree_view_column_clicked

Emits the “clicked” signal on the column.  This function will only work if this tree column is clickable.

  method gtk_tree_view_column_clicked ( )


=end pod

sub gtk_tree_view_column_clicked ( N-GObject $tree_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_set_title:
=begin pod
=head2 [[gtk_] tree_view_column_] set_title

Sets the title of the this tree column.  If a custom widget has been set, then this value is ignored.

  method gtk_tree_view_column_set_title ( Str $title )

=item Str $title; The title of the I<tree_column>.

=end pod

sub gtk_tree_view_column_set_title ( N-GObject $tree_column, Str $title )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_get_title:
=begin pod
=head2 [[gtk_] tree_view_column_] get_title

Returns the title of the column.

  method gtk_tree_view_column_get_title ( --> Str  )

=end pod

sub gtk_tree_view_column_get_title ( N-GObject $tree_column )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_set_expand:
=begin pod
=head2 [[gtk_] tree_view_column_] set_expand

Sets the column to take available extra space.  This space is shared equally amongst all columns that have the expand set to C<1>.  If no column has this option set, then the last column gets all extra space.  By default, every column is created with this C<0>.

Along with “fixed-width”, the “expand” property changes when the column is resized by the user.

  method gtk_tree_view_column_set_expand ( Int $expand )

=item Int $expand; C<1> if the column should expand to fill available space.

=end pod

sub gtk_tree_view_column_set_expand ( N-GObject $tree_column, int32 $expand )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_get_expand:
=begin pod
=head2 [[gtk_] tree_view_column_] get_expand

Returns C<1> if the column expands to fill available space.

  method gtk_tree_view_column_get_expand ( --> Int  )


=end pod

sub gtk_tree_view_column_get_expand ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_clickable:
=begin pod
=head2 [[gtk_] tree_view_column_] set_clickable

Sets the header to be active if I<$clickable> is C<1>.  When the header is
active, then it can take keyboard focus, and can be clicked.

  method gtk_tree_view_column_set_clickable ( Int $clickable )

=item Int $clickable; C<1> if the header is active.

=end pod

sub gtk_tree_view_column_set_clickable ( N-GObject $tree_column, int32 $clickable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_clickable:
=begin pod
=head2 [[gtk_] tree_view_column_] get_clickable

Returns C<1> if the user can click on the header for the column.

  method gtk_tree_view_column_get_clickable ( --> Int  )


=end pod

sub gtk_tree_view_column_get_clickable ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_widget:
=begin pod
=head2 [[gtk_] tree_view_column_] set_widget

Sets the widget in the header to be I<$widget>. Normally the header button is set with a B<Gnome::Gtk3::Label> set to the title of this tree column.

  method gtk_tree_view_column_set_widget ( N-GObject $widget )

=item N-GObject $widget; A child B<Gnome::Gtk3::Widget>.

=end pod

sub gtk_tree_view_column_set_widget ( N-GObject $tree_column, N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_widget:
=begin pod
=head2 [[gtk_] tree_view_column_] get_widget

Returns the B<Gnome::Gtk3::Widget> in the button on the column header. If a custom widget has not been set then C<Any> is returned.

  method gtk_tree_view_column_get_widget ( --> N-GObject  )

=end pod

sub gtk_tree_view_column_get_widget ( N-GObject $tree_column )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_alignment:
=begin pod
=head2 [[gtk_] tree_view_column_] set_alignment

Sets the alignment of the title or custom widget inside the column header. The alignment determines its location inside the button -- 0.0 for left, 0.5 for center, 1.0 for right.

  method gtk_tree_view_column_set_alignment ( Num $xalign )

=item Num $xalign; The alignment, which is between [0.0 and 1.0] inclusive.

=end pod

sub gtk_tree_view_column_set_alignment ( N-GObject $tree_column, num32 $xalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_alignment:
=begin pod
=head2 [[gtk_] tree_view_column_] get_alignment

Returns the current x alignment of this tree column.  This value can range between 0.0 and 1.0.

  method gtk_tree_view_column_get_alignment ( --> Num  )

=end pod

sub gtk_tree_view_column_get_alignment ( N-GObject $tree_column )
  returns num32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_reorderable:
=begin pod
=head2 [[gtk_] tree_view_column_] set_reorderable

If I<reorderable> is C<1>, then the column can be reordered by the end user dragging the header.

  method gtk_tree_view_column_set_reorderable ( Int $reorderable )

=item Int $reorderable; C<1>, if the column can be reordered.

=end pod

sub gtk_tree_view_column_set_reorderable ( N-GObject $tree_column, int32 $reorderable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_reorderable:
=begin pod
=head2 [[gtk_] tree_view_column_] get_reorderable

Returns C<1> if this tree column can be reordered by the user.

  method gtk_tree_view_column_get_reorderable ( --> Int  )


=end pod

sub gtk_tree_view_column_get_reorderable ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_sort_column_id:
=begin pod
=head2 [[gtk_] tree_view_column_] set_sort_column_id

Sets the logical I<$sort_column_id> that this column sorts on when this column is selected for sorting.  Doing so makes the column header clickable.

  method gtk_tree_view_column_set_sort_column_id ( Int $sort_column_id )

=item Int $sort_column_id; The I<sort_column_id> of the model to sort on.

=end pod

sub gtk_tree_view_column_set_sort_column_id ( N-GObject $tree_column, int32 $sort_column_id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_sort_column_id:
=begin pod
=head2 [[gtk_] tree_view_column_] get_sort_column_id

Gets the logical sort column id that the model sorts on when this column is selected for sorting. See C<gtk_tree_view_column_set_sort_column_id()>.

  method gtk_tree_view_column_get_sort_column_id ( --> Int  )

=end pod

sub gtk_tree_view_column_get_sort_column_id ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_sort_indicator:
=begin pod
=head2 [[gtk_] tree_view_column_] set_sort_indicator

Call this function with a I<$setting> of C<1> to display an arrow in the header button indicating the column is sorted. Call C<gtk_tree_view_column_set_sort_order()> to change the direction of the arrow.

  method gtk_tree_view_column_set_sort_indicator ( Int $setting )

=item Int $setting; C<1> to display an indicator that the column is sorted

=end pod

sub gtk_tree_view_column_set_sort_indicator ( N-GObject $tree_column, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_sort_indicator:
=begin pod
=head2 [[gtk_] tree_view_column_] get_sort_indicator

Gets the value set by C<gtk_tree_view_column_set_sort_indicator()>.

  method gtk_tree_view_column_get_sort_indicator ( --> Int  )


=end pod

sub gtk_tree_view_column_get_sort_indicator ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_set_sort_order:
=begin pod
=head2 [[gtk_] tree_view_column_] set_sort_order

Changes the appearance of the sort indicator.

This does not actually sort the model.  Use C<gtk_tree_view_column_set_sort_column_id()> if you want automatic sorting support.  This function is primarily for custom sorting behavior, and should be used in conjunction with C<gtk_tree_sortable_set_sort_column_id()> to do that. For custom models, the mechanism will vary.

The sort indicator changes direction to indicate normal sort or reverse sort. Note that you must have the sort indicator enabled to see anything when calling this function; see C<gtk_tree_view_column_set_sort_indicator()>.

  method gtk_tree_view_column_set_sort_order ( GtkSortType $order )

=item GtkSortType $order; sort order that the sort indicator should indicate

=end pod

sub gtk_tree_view_column_set_sort_order ( N-GObject $tree_column, int32 $order )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_sort_order:
=begin pod
=head2 [[gtk_] tree_view_column_] get_sort_order

Gets the value set by C<gtk_tree_view_column_set_sort_order()>.

  method gtk_tree_view_column_get_sort_order ( --> GtkSortType  )


=end pod

sub gtk_tree_view_column_get_sort_order ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_cell_set_cell_data:
=begin pod
=head2 [[gtk_] tree_view_column_] cell_set_cell_data

Sets the cell renderer based on this tree column and I<$iter>.  That is, for every attribute mapping in this tree column, it will get a value from the set column on the I<$iter>, and use that value to set the attribute on the cell renderer. This is used primarily by the B<Gnome::Gtk3::TreeView>.

  method gtk_tree_view_column_cell_set_cell_data (
    Gnome::Gtk3::TreeModel $tree_model, Gnome::Gtk3::TreeIter $iter,
    Int $is_expander, Int $is_expanded
  )

=item Gnome::Gtk3::TreeModel $tree_model; The TreeModel to get the cell renderers attributes from. Examples of a model is Gnome::Gtk3::ListStore or Gnome::Gtk3::TreeStore.
=item Gnome::Gtk3::TreeIter $iter $iter; iterator to get the cell renderer’s attributes from.
=item Int $is_expander; C<1>, if the row has children
=item Int $is_expanded; C<1>, if the row has visible children

=end pod

sub gtk_tree_view_column_cell_set_cell_data ( N-GObject $tree_column, N-GObject $tree_model, N-GtkTreeIter $iter, int32 $is_expander, int32 $is_expanded )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_cell_get_size:
=begin pod
=head2 [[gtk_] tree_view_column_] cell_get_size

Obtains the width and height needed to render the column.  This is used primarily by the B<Gnome::Gtk3::TreeView>.

  method gtk_tree_view_column_cell_get_size ( N-GObject $cell_area, Int $x_offset, Int $y_offset, Int $width, Int $height )

=item N-GObject $cell_area; (allow-none): The area a cell in the column will be allocated, or C<Any>
=item Int $x_offset; (out) (optional): location to return x offset of a cell relative to I<cell_area>, or C<Any>
=item Int $y_offset; (out) (optional): location to return y offset of a cell relative to I<cell_area>, or C<Any>
=item Int $width; (out) (optional): location to return width needed to render a cell, or C<Any>
=item Int $height; (out) (optional): location to return height needed to render a cell, or C<Any>

=end pod

sub gtk_tree_view_column_cell_get_size ( N-GObject $tree_column, N-GObject $cell_area, int32 $x_offset, int32 $y_offset, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_column_cell_is_visible:
=begin pod
=head2 [[gtk_] tree_view_column_] cell_is_visible

Returns C<1> if any of the cells packed into this tree column are visible. For this to be meaningful, you must first initialize the cells with C<gtk_tree_view_column_cell_set_cell_data()>

  method gtk_tree_view_column_cell_is_visible ( --> Int  )

=end pod

sub gtk_tree_view_column_cell_is_visible ( N-GObject $tree_column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_focus_cell:
=begin pod
=head2 [[gtk_] tree_view_column_] focus_cell

Sets the current keyboard focus to be at I<cell>, if the column contains 2 or more editable and activatable cells.

  method gtk_tree_view_column_focus_cell ( Gnome::Gtk3::CellRenderer $cell )

=item Gnome::Gtk3::CellRenderer $cell; A cell renderer

=end pod

sub gtk_tree_view_column_focus_cell ( N-GObject $tree_column, N-GObject $cell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_cell_get_position:
=begin pod
=head2 [[gtk_] tree_view_column_] cell_get_position

Obtains the horizontal position and size of a cell in a column. If the cell is not found in the column, I<start_pos> and I<width> are not changed and C<0> is returned.

Returns: C<1> if I<$cell> belongs to this tree column.

  method gtk_tree_view_column_cell_get_position (
    Gnome::Gtk3::CellRenderer $cell_renderer, Int $x_offset, Int $width
    --> Int
  )

=item Gnome::Gtk3::CellRenderer $cell_renderer; a cell renderer
=item Int $x_offset; (out) (allow-none): return location for the horizontal position of I<cell> within I<tree_column>, may be C<Any>
=item Int $width; (out) (allow-none): return location for the width of I<cell>, may be C<Any>

=end pod

sub gtk_tree_view_column_cell_get_position ( N-GObject $tree_column, N-GObject $cell_renderer, int32 $x_offset, int32 $width )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_queue_resize:
=begin pod
=head2 [[gtk_] tree_view_column_] queue_resize

Flags the column, and the cell renderers added to this column, to have their sizes renegotiated.

  method gtk_tree_view_column_queue_resize ( )


=end pod

sub gtk_tree_view_column_queue_resize ( N-GObject $tree_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_tree_view:
=begin pod
=head2 [[gtk_] tree_view_column_] get_tree_view

Returns the B<Gnome::Gtk3::TreeView> wherein I<tree_column> has been inserted. If I<column> is currently not inserted in any tree view, C<Any> is returned.

  method gtk_tree_view_column_get_tree_view ( --> N-GObject  )

=end pod

sub gtk_tree_view_column_get_tree_view ( N-GObject $tree_column )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_column_get_button:
=begin pod
=head2 [[gtk_] tree_view_column_] get_button

Returns the button used in the treeview column header

  method gtk_tree_view_column_get_button ( --> N-GObject  )

=end pod

sub gtk_tree_view_column_get_button ( N-GObject $tree_column )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:clicked:
=head3 clicked

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($treeviewcolumn),
    *%user-options
  );

=item $treeviewcolumn;

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:1:visible:
=head3 Visible

Whether to display the column
Default value: True


The B<Gnome::GObject::Value> type of property I<visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:resizable:
=head3 Resizable

Column is user-resizable
Default value: False


The B<Gnome::GObject::Value> type of property I<resizable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:x-offset:
=head3 X position



The B<Gnome::GObject::Value> type of property I<x-offset> is C<G_TYPE_INT>.

=comment #TP:0:width:
=head3 Width



The B<Gnome::GObject::Value> type of property I<width> is C<G_TYPE_INT>.

=comment #TP:0:spacing:
=head3 Spacing



The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.

=comment #TP:0:sizing:
=head3 Sizing

Resize mode of the column
Default value: False


The B<Gnome::GObject::Value> type of property I<sizing> is C<G_TYPE_ENUM>.

=comment #TP:0:fixed-width:
=head3 Fixed Width



The B<Gnome::GObject::Value> type of property I<fixed-width> is C<G_TYPE_INT>.

=comment #TP:0:min-width:
=head3 Minimum Width



The B<Gnome::GObject::Value> type of property I<min-width> is C<G_TYPE_INT>.

=comment #TP:0:max-width:
=head3 Maximum Width



The B<Gnome::GObject::Value> type of property I<max-width> is C<G_TYPE_INT>.

=comment #TP:0:title:
=head3 Title

Title to appear in column header
Default value:


The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment #TP:0:expand:
=head3 Expand

Column gets share of extra width allocated to the widget
Default value: False


The B<Gnome::GObject::Value> type of property I<expand> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:clickable:
=head3 Clickable

Whether the header can be clicked
Default value: False


The B<Gnome::GObject::Value> type of property I<clickable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:widget:
=head3 Widget

Widget to put in column header button instead of column title
Widget type: GTK_TYPE_WIDGET


The B<Gnome::GObject::Value> type of property I<widget> is C<G_TYPE_OBJECT>.

=comment #TP:0:alignment:
=head3 Alignment



The B<Gnome::GObject::Value> type of property I<alignment> is C<G_TYPE_FLOAT>.

=comment #TP:0:reorderable:
=head3 Reorderable

Whether the column can be reordered around the headers
Default value: False


The B<Gnome::GObject::Value> type of property I<reorderable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:sort-indicator:
=head3 Sort indicator

Whether to show a sort indicator
Default value: False


The B<Gnome::GObject::Value> type of property I<sort-indicator> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:sort-order:
=head3 Sort order

Sort direction the sort indicator should indicate
Default value: False


The B<Gnome::GObject::Value> type of property I<sort-order> is C<G_TYPE_ENUM>.

=comment #TP:0:sort-column-id:
=head3 Sort column ID


Logical sort column ID this column sorts on when selected for sorting. Setting the sort column ID makes the column header
clickable. Set to -1 to make the column unsortable.

The B<Gnome::GObject::Value> type of property I<sort-column-id> is C<G_TYPE_INT>.

=comment #TP:0:cell-area:
=head3 Cell Area


The B<Gnome::Gtk3::CellArea> used to layout cell renderers for this column.
If no area is specified when creating the tree view column with C<gtk_tree_view_column_new_with_area()>
a horizontally oriented B<Gnome::Gtk3::CellAreaBox> will be used.Widget type: GTK_TYPE_CELL_AREA

The B<Gnome::GObject::Value> type of property I<cell-area> is C<G_TYPE_OBJECT>.
=end pod
