#TL:1:Gnome::Gtk3::IconView:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::IconView

A widget which displays a list of icons in a grid

![](images/icon-view.png)

=head1 Description

B<Gnome::Gtk3::IconView> provides an alternative view on a B<Gnome::Gtk3::TreeModel>. It displays the model as a grid of icons with labels. Like B<Gnome::Gtk3::TreeView>, it allows to select one or multiple items (depending on the selection mode, see C<gtk_icon_view_set_selection_mode()>). In addition to selection with the arrow keys, B<Gnome::Gtk3::IconView> supports rubberband selection, which is controlled by dragging the pointer.

Note that if the tree model is backed by an actual tree store (as opposed to a flat list where the mapping to icons is obvious), B<Gnome::Gtk3::IconView> will only display the first level of the tree and ignore the tree’s branches.


=head2 Css Nodes

  iconview.view
  ╰── [rubberband]

B<Gnome::Gtk3::IconView> has a single CSS node with name iconview and style class .view. For rubberband selection, a subnode with name rubberband is used.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::IconView;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::CellLayout;
  also does Gnome::Gtk3::Scrollable;


=head2 Uml Diagram

![](plantuml/IconView.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::IconView:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::IconView;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::IconView class process the options
    self.bless( :GtkIconView, |c);
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

use Gnome::Glib::List:api<1>;

use Gnome::Gtk3::Container:api<1>;
use Gnome::Gtk3::TreeIter:api<1>;
use Gnome::Gtk3::TreePath:api<1>;
use Gnome::Gtk3::CellLayout:api<1>;
use Gnome::Gtk3::Scrollable:api<1>;

use Gnome::Cairo::Types:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::IconView:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::CellLayout;
also does Gnome::Gtk3::Scrollable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIconViewDropPosition

An enum for determining where a dropped item goes.

=item GTK_ICON_VIEW_NO_DROP: no drop possible
=item GTK_ICON_VIEW_DROP_INTO: dropped item replaces the item
=item GTK_ICON_VIEW_DROP_LEFT: droppped item is inserted to the left
=item GTK_ICON_VIEW_DROP_RIGHT: dropped item is inserted to the right
=item GTK_ICON_VIEW_DROP_ABOVE: dropped item is inserted above
=item GTK_ICON_VIEW_DROP_BELOW: dropped item is inserted below

=end pod

#TE:0:GtkIconViewDropPosition:
enum GtkIconViewDropPosition is export (
  'GTK_ICON_VIEW_NO_DROP',
  'GTK_ICON_VIEW_DROP_INTO',
  'GTK_ICON_VIEW_DROP_LEFT',
  'GTK_ICON_VIEW_DROP_RIGHT',
  'GTK_ICON_VIEW_DROP_ABOVE',
  'GTK_ICON_VIEW_DROP_BELOW'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::IconView> widget

  multi method new ( )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:0:new(:cell-area):
#TM:0:new(:model):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<move-cursor>, :w1<item-activated>, :w0<selection-changed select-all unselect-all select-cursor-item toggle-cursor-item activate-cursor-item>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::IconView' #`{{ or %options<GtkIconView> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<model> {
        $no = %options<model>;
        $no .= _get-native-object-no-reffing
          if $no.^can('_get-native-object-no-reffing');
        $no = _gtk_icon_view_new_with_model($no);
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

#      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_icon_view_new();
      }
#      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkIconView');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_icon_view_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkIconView');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_view_new:
#`{{
=begin pod
=head2 [gtk_] icon_view_new

Creates a new B<Gnome::Gtk3::IconView> widget

Returns: A newly created B<Gnome::Gtk3::IconView> widget

  method gtk_icon_view_new ( --> N-GObject )


=end pod
}}

sub _gtk_icon_view_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_view_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_icon_view_new_with_area:
#`{{
=begin pod
=head2 [[gtk_] icon_view_] new_with_area

Creates a new B<Gnome::Gtk3::IconView> widget using the specified I<area> to layout cells inside the icons.

Returns: A newly created B<Gnome::Gtk3::IconView> widget

  method gtk_icon_view_new_with_area ( N-GObject $area --> N-GObject )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> to use to layout cells

=end pod
}}

sub _gtk_icon_view_new_with_area ( N-GObject $area --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_view_new_with_area')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_icon_view_new_with_model:
#`{{
=begin pod
=head2 [[gtk_] icon_view_] new_with_model

Creates a new B<Gnome::Gtk3::IconView> widget with the model I<model>.

Returns: A newly created B<Gnome::Gtk3::IconView> widget.

  method gtk_icon_view_new_with_model ( N-GObject $model --> N-GObject )

=item N-GObject $model; The model.

=end pod
}}

sub _gtk_icon_view_new_with_model ( N-GObject $model --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_view_new_with_model')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_model:
=begin pod
=head2 [[gtk_] icon_view_] set_model

Sets the model for a B<Gnome::Gtk3::IconView>. If the I<icon_view> already has a model set, it will remove it before setting the new model.  If I<model> is C<Any>, then it will unset the old model.

  method gtk_icon_view_set_model ( N-GObject $model )

=item N-GObject $model; (allow-none): The model.

=end pod

sub gtk_icon_view_set_model ( N-GObject $icon_view, N-GObject $model  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_icon_view_get_model:
=begin pod
=head2 [[gtk_] icon_view_] get_model

Returns the model the B<Gnome::Gtk3::IconView> is based on.  Returns C<Any> if the model is unset.

Returns: (nullable) (transfer none): A B<Gnome::Gtk3::TreeModel>, or C<Any> if none is currently being used.

  method gtk_icon_view_get_model ( --> N-GObject )


=end pod

sub gtk_icon_view_get_model ( N-GObject $icon_view --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_text_column:
=begin pod
=head2 [[gtk_] icon_view_] set_text_column

Sets the column with text for I<icon_view> to be I<column>. The text column must be of type B<G_TYPE_STRING>.

  method gtk_icon_view_set_text_column ( Int $column )

=item Int $column; A column in the currently used model, or -1 to display no text

=end pod

sub gtk_icon_view_set_text_column ( N-GObject $icon_view, int32 $column  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_text_column:
=begin pod
=head2 [[gtk_] icon_view_] get_text_column

Returns the column with text for I<icon_view>.

Returns: the text column, or -1 if it’s unset.

  method gtk_icon_view_get_text_column ( --> Int )


=end pod

sub gtk_icon_view_get_text_column ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_markup_column:
=begin pod
=head2 [[gtk_] icon_view_] set_markup_column

Sets the column with markup information for I<icon_view> to be I<column>. The markup column must be of type B<G_TYPE_STRING>. If the markup column is set to something, it overrides the text column set by C<gtk_icon_view_set_text_column()>.

  method gtk_icon_view_set_markup_column ( Int $column )

=item Int $column; A column in the currently used model, or -1 to display no text

=end pod

sub gtk_icon_view_set_markup_column ( N-GObject $icon_view, int32 $column  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_markup_column:
=begin pod
=head2 [[gtk_] icon_view_] get_markup_column

Returns the column with markup text for I<icon_view>.

Returns: the markup column, or -1 if it’s unset.

  method gtk_icon_view_get_markup_column ( --> Int )


=end pod

sub gtk_icon_view_get_markup_column ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_pixbuf_column:
=begin pod
=head2 [[gtk_] icon_view_] set_pixbuf_column

Sets the column with pixbufs for I<icon_view> to be I<column>. The pixbuf column must be of type B<GDK_TYPE_PIXBUF>

  method gtk_icon_view_set_pixbuf_column ( Int $column )

=item Int $column; A column in the currently used model, or -1 to disable

=end pod

sub gtk_icon_view_set_pixbuf_column ( N-GObject $icon_view, int32 $column  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_pixbuf_column:
=begin pod
=head2 [[gtk_] icon_view_] get_pixbuf_column

Returns the column with pixbufs for I<icon_view>.

Returns: the pixbuf column, or -1 if it’s unset.

  method gtk_icon_view_get_pixbuf_column ( --> Int )


=end pod

sub gtk_icon_view_get_pixbuf_column ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_item_orientation:
=begin pod
=head2 [[gtk_] icon_view_] set_item_orientation

Sets the I<item-orientation> property which determines whether the labels  are drawn beside the icons instead of below.

  method gtk_icon_view_set_item_orientation ( GtkOrientation $orientation )

=item GtkOrientation $orientation; the relative position of texts and icons

=end pod

sub gtk_icon_view_set_item_orientation ( N-GObject $icon_view, int32 $orientation  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_orientation:
=begin pod
=head2 [[gtk_] icon_view_] get_item_orientation

Returns the value of the I<item-orientation> property which determines  whether the labels are drawn beside the icons instead of below.

Returns: the relative position of texts and icons

  method gtk_icon_view_get_item_orientation ( --> GtkOrientation )


=end pod

sub gtk_icon_view_get_item_orientation ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_columns:
=begin pod
=head2 [[gtk_] icon_view_] set_columns

Sets the I<columns> property which determines in how many columns the icons are arranged. If I<columns> is -1, the number of columns will be chosen automatically  to fill the available area.

  method gtk_icon_view_set_columns ( Int $columns )

=item Int $columns; the number of columns

=end pod

sub gtk_icon_view_set_columns ( N-GObject $icon_view, int32 $columns  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_columns:
=begin pod
=head2 [[gtk_] icon_view_] get_columns

Returns the value of the I<columns> property.

Returns: the number of columns, or -1

  method gtk_icon_view_get_columns ( --> Int )


=end pod

sub gtk_icon_view_get_columns ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_item_width:
=begin pod
=head2 [[gtk_] icon_view_] set_item_width

Sets the I<item-width> property which specifies the width  to use for each item. If it is set to -1, the icon view will  automatically determine a suitable item size.

  method gtk_icon_view_set_item_width ( Int $item_width )

=item Int $item_width; the width for each item

=end pod

sub gtk_icon_view_set_item_width ( N-GObject $icon_view, int32 $item_width  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_width:
=begin pod
=head2 [[gtk_] icon_view_] get_item_width

Returns the value of the I<item-width> property.

Returns: the width of a single item, or -1

  method gtk_icon_view_get_item_width ( --> Int )


=end pod

sub gtk_icon_view_get_item_width ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_spacing:
=begin pod
=head2 [[gtk_] icon_view_] set_spacing

Sets the I<spacing> property which specifies the space  which is inserted between the cells (i.e. the icon and  the text) of an item.

  method gtk_icon_view_set_spacing ( Int $spacing )

=item Int $spacing; the spacing

=end pod

sub gtk_icon_view_set_spacing ( N-GObject $icon_view, int32 $spacing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_spacing:
=begin pod
=head2 [[gtk_] icon_view_] get_spacing

Returns the value of the I<spacing> property.

Returns: the space between cells

  method gtk_icon_view_get_spacing ( --> Int )


=end pod

sub gtk_icon_view_get_spacing ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_row_spacing:
=begin pod
=head2 [[gtk_] icon_view_] set_row_spacing

Sets the I<row-spacing> property which specifies the space  which is inserted between the rows of the icon view.

  method gtk_icon_view_set_row_spacing ( Int $row_spacing )

=item Int $row_spacing; the row spacing

=end pod

sub gtk_icon_view_set_row_spacing ( N-GObject $icon_view, int32 $row_spacing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_row_spacing:
=begin pod
=head2 [[gtk_] icon_view_] get_row_spacing

Returns the value of the I<row-spacing> property.

Returns: the space between rows

  method gtk_icon_view_get_row_spacing ( --> Int )


=end pod

sub gtk_icon_view_get_row_spacing ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_column_spacing:
=begin pod
=head2 [[gtk_] icon_view_] set_column_spacing

Sets the I<column-spacing> property which specifies the space  which is inserted between the columns of the icon view.

  method gtk_icon_view_set_column_spacing ( Int $column_spacing )

=item Int $column_spacing; the column spacing

=end pod

sub gtk_icon_view_set_column_spacing ( N-GObject $icon_view, int32 $column_spacing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_column_spacing:
=begin pod
=head2 [[gtk_] icon_view_] get_column_spacing

Returns the value of the I<column-spacing> property.

Returns: the space between columns

  method gtk_icon_view_get_column_spacing ( --> Int )


=end pod

sub gtk_icon_view_get_column_spacing ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_margin:
=begin pod
=head2 [[gtk_] icon_view_] set_margin

Sets the I<margin> property which specifies the space  which is inserted at the top, bottom, left and right  of the icon view.

  method gtk_icon_view_set_margin ( Int $margin )

=item Int $margin; the margin

=end pod

sub gtk_icon_view_set_margin ( N-GObject $icon_view, int32 $margin  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_margin:
=begin pod
=head2 [[gtk_] icon_view_] get_margin

Returns the value of the I<margin> property.

Returns: the space at the borders

  method gtk_icon_view_get_margin ( --> Int )


=end pod

sub gtk_icon_view_get_margin ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_item_padding:
=begin pod
=head2 [[gtk_] icon_view_] set_item_padding

Sets the  I<item-padding> property which specifies the padding around each of the icon view’s items.

  method gtk_icon_view_set_item_padding ( Int $item_padding )

=item Int $item_padding; the item padding

=end pod

sub gtk_icon_view_set_item_padding ( N-GObject $icon_view, int32 $item_padding  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_padding:
=begin pod
=head2 [[gtk_] icon_view_] get_item_padding

Returns the value of the I<item-padding> property.

Returns: the padding around items

  method gtk_icon_view_get_item_padding ( --> Int )


=end pod

sub gtk_icon_view_get_item_padding ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_path_at_pos:
=begin pod
=head2 [[gtk_] icon_view_] get_path_at_pos

Finds the path at the point (I<x>, I<y>), relative to bin_window coordinates. See C<gtk_icon_view_get_item_at_pos()>, if you are also interested in the cell at the specified position.  See C<gtk_icon_view_convert_widget_to_bin_window_coords()> for converting widget coordinates to bin_window coordinates.

Returns: (nullable) (transfer full): The B<Gnome::Gtk3::TreePath> corresponding to the icon or C<Any> if no icon exists at that position.

  method gtk_icon_view_get_path_at_pos ( Int $x, Int $y --> N-GtkTreePath )

=item Int $x; The x position to be identified
=item Int $y; The y position to be identified

=end pod

sub gtk_icon_view_get_path_at_pos ( N-GObject $icon_view, int32 $x, int32 $y --> N-GtkTreePath )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_at_pos:
=begin pod
=head2 [[gtk_] icon_view_] get_item_at_pos

Finds the path at the point (I<x>, I<y>), relative to bin_window coordinates. In contrast to C<gtk_icon_view_get_path_at_pos()>, this function also  obtains the cell at the specified position. The returned path should be freed with C<gtk_tree_path_free()>. See C<gtk_icon_view_convert_widget_to_bin_window_coords()> for converting widget coordinates to bin_window coordinates.

Returns: C<1> if an item exists at the specified position

  method gtk_icon_view_get_item_at_pos ( Int $x, Int $y, N-GtkTreePath $path, N-GObject $cell --> Int )

=item Int $x; The x position to be identified
=item Int $y; The y position to be identified
=item N-GtkTreePath $path; (out) (allow-none): Return location for the path, or C<Any>
=item N-GObject $cell; (out) (allow-none) (transfer none): Return location for the renderer responsible for the cell at (I<x>, I<y>), or C<Any>

=end pod

sub gtk_icon_view_get_item_at_pos ( N-GObject $icon_view, int32 $x, int32 $y, N-GtkTreePath $path, N-GObject $cell --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_visible_range:
=begin pod
=head2 [[gtk_] icon_view_] get_visible_range

Sets I<start_path> and I<end_path> to be the first and last visible path.  Note that there may be invisible paths in between.  Both paths should be freed with C<gtk_tree_path_free()> after use.

Returns: C<1>, if valid paths were placed in I<start_path> and I<end_path>

  method gtk_icon_view_get_visible_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path --> Int )

=item N-GtkTreePath $start_path; (out) (allow-none): Return location for start of region, or C<Any>
=item N-GtkTreePath $end_path; (out) (allow-none): Return location for end of region, or C<Any>

=end pod

sub gtk_icon_view_get_visible_range ( N-GObject $icon_view, N-GtkTreePath $start_path, N-GtkTreePath $end_path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_activate_on_single_click:
=begin pod
=head2 [[gtk_] icon_view_] set_activate_on_single_click

Causes the  I<item-activated> signal to be emitted on a single click instead of a double click.

  method gtk_icon_view_set_activate_on_single_click ( Int $single )

=item Int $single; C<1> to emit item-activated on a single click

=end pod

sub gtk_icon_view_set_activate_on_single_click ( N-GObject $icon_view, int32 $single  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_activate_on_single_click:
=begin pod
=head2 [[gtk_] icon_view_] get_activate_on_single_click

Gets the setting set by C<gtk_icon_view_set_activate_on_single_click()>.

Returns: C<1> if item-activated will be emitted on a single click

  method gtk_icon_view_get_activate_on_single_click ( --> Int )


=end pod

sub gtk_icon_view_get_activate_on_single_click ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_selected_foreach:
=begin pod
=head2 [[gtk_] icon_view_] selected_foreach

Calls a function for each selected icon. Note that the model or selection cannot be modified from within this function.

  method gtk_icon_view_selected_foreach ( GtkIconViewForeachFunc $func, Pointer $data )

=item GtkIconViewForeachFunc $func; (scope call): The function to call for each selected icon.
=item Pointer $data; User data to pass to the function.

=end pod

sub gtk_icon_view_selected_foreach ( N-GObject $icon_view, GtkIconViewForeachFunc $func, Pointer $data  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_selection_mode:
=begin pod
=head2 [[gtk_] icon_view_] set_selection_mode

Sets the selection mode of the I<icon_view>.

  method gtk_icon_view_set_selection_mode ( GtkSelectionMode $mode )

=item GtkSelectionMode $mode; The selection mode

=end pod

sub gtk_icon_view_set_selection_mode ( N-GObject $icon_view, int32 $mode  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_selection_mode:
=begin pod
=head2 [[gtk_] icon_view_] get_selection_mode

Gets the selection mode of the I<icon_view>.

Returns: the current selection mode

  method gtk_icon_view_get_selection_mode ( --> GtkSelectionMode )


=end pod

sub gtk_icon_view_get_selection_mode ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_select_path:
=begin pod
=head2 [[gtk_] icon_view_] select_path

Selects the row at I<path>.

  method gtk_icon_view_select_path ( N-GtkTreePath $path )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be selected.

=end pod

sub gtk_icon_view_select_path ( N-GObject $icon_view, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_unselect_path:
=begin pod
=head2 [[gtk_] icon_view_] unselect_path

Unselects the row at I<path>.

  method gtk_icon_view_unselect_path ( N-GtkTreePath $path )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be unselected.

=end pod

sub gtk_icon_view_unselect_path ( N-GObject $icon_view, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_path_is_selected:
=begin pod
=head2 [[gtk_] icon_view_] path_is_selected

Returns C<1> if the icon pointed to by I<path> is currently selected. If I<path> does not point to a valid location, C<0> is returned.

Returns: C<1> if I<path> is selected.

  method gtk_icon_view_path_is_selected ( N-GtkTreePath $path --> Int )

=item N-GtkTreePath $path; A B<Gnome::Gtk3::TreePath> to check selection on.

=end pod

sub gtk_icon_view_path_is_selected ( N-GObject $icon_view, N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_row:
=begin pod
=head2 [[gtk_] icon_view_] get_item_row

Gets the row in which the item I<path> is currently displayed. Row numbers start at 0.

Returns: The row in which the item is displayed

  method gtk_icon_view_get_item_row ( N-GtkTreePath $path --> Int )

=item N-GtkTreePath $path; the B<Gnome::Gtk3::TreePath> of the item

=end pod

sub gtk_icon_view_get_item_row ( N-GObject $icon_view, N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_item_column:
=begin pod
=head2 [[gtk_] icon_view_] get_item_column

Gets the column in which the item I<path> is currently displayed. Column numbers start at 0.

Returns: The column in which the item is displayed

  method gtk_icon_view_get_item_column ( N-GtkTreePath $path --> Int )

=item N-GtkTreePath $path; the B<Gnome::Gtk3::TreePath> of the item

=end pod

sub gtk_icon_view_get_item_column ( N-GObject $icon_view, N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_selected_items:
=begin pod
=head2 [[gtk_] icon_view_] get_selected_items

Creates a list of paths of all selected items. Additionally, if you are planning on modifying the model after calling this function, you may want to convert the returned list into a list of B<Gnome::Gtk3::TreeRowReferences>. To do this, you can use C<gtk_tree_row_reference_new()>.  To free the return value, use: |[<!-- language="C" --> g_list_free_full (list, (GDestroyNotify) gtk_tree_path_free); ]|

Returns: (element-type B<Gnome::Gtk3::TreePath>) (transfer full): A B<GList> containing a B<Gnome::Gtk3::TreePath> for each selected row.

  method gtk_icon_view_get_selected_items ( --> N-GList )


=end pod

sub gtk_icon_view_get_selected_items ( N-GObject $icon_view --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_select_all:
=begin pod
=head2 [[gtk_] icon_view_] select_all

Selects all the icons. I<icon_view> must has its selection mode set to B<GTK_SELECTION_MULTIPLE>.

  method gtk_icon_view_select_all ( )


=end pod

sub gtk_icon_view_select_all ( N-GObject $icon_view  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_unselect_all:
=begin pod
=head2 [[gtk_] icon_view_] unselect_all

Unselects all the icons.

  method gtk_icon_view_unselect_all ( )


=end pod

sub gtk_icon_view_unselect_all ( N-GObject $icon_view  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_item_activated:
=begin pod
=head2 [[gtk_] icon_view_] item_activated

Activates the item determined by I<path>.

  method gtk_icon_view_item_activated ( N-GtkTreePath $path )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be activated

=end pod

sub gtk_icon_view_item_activated ( N-GObject $icon_view, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_cursor:
=begin pod
=head2 [[gtk_] icon_view_] set_cursor

Sets the current keyboard focus to be at I<path>, and selects it.  This is useful when you want to focus the user’s attention on a particular item. If I<cell> is not C<Any>, then focus is given to the cell specified by  it. Additionally, if I<start_editing> is C<1>, then editing should be  started in the specified cell.    This function is often followed by `gtk_widget_grab_focus  (icon_view)` in order to give keyboard focus to the widget.   Please note that editing can only happen when the widget is realized.

  method gtk_icon_view_set_cursor ( N-GtkTreePath $path, N-GObject $cell, Int $start_editing )

=item N-GtkTreePath $path; A B<Gnome::Gtk3::TreePath>
=item N-GObject $cell; (allow-none): One of the cell renderers of I<icon_view>, or C<Any>
=item Int $start_editing; C<1> if the specified cell should start being edited.

=end pod

sub gtk_icon_view_set_cursor ( N-GObject $icon_view, N-GtkTreePath $path, N-GObject $cell, int32 $start_editing  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_cursor:
=begin pod
=head2 [[gtk_] icon_view_] get_cursor

Fills in I<path> and I<cell> with the current cursor path and cell.  If the cursor isn’t currently set, then *I<path> will be C<Any>.   If no cell currently has focus, then *I<cell> will be C<Any>.  The returned B<Gnome::Gtk3::TreePath> must be freed with C<gtk_tree_path_free()>.

Returns: C<1> if the cursor is set.

  method gtk_icon_view_get_cursor ( N-GtkTreePath $path, N-GObject $cell --> Int )

=item N-GtkTreePath $path; (out) (allow-none) (transfer full): Return location for the current cursor path, or C<Any>
=item N-GObject $cell; (out) (allow-none) (transfer none): Return location the current focus cell, or C<Any>

=end pod

sub gtk_icon_view_get_cursor ( N-GObject $icon_view, N-GtkTreePath $path, N-GObject $cell --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_scroll_to_path:
=begin pod
=head2 [[gtk_] icon_view_] scroll_to_path

Moves the alignments of I<icon_view> to the position specified by I<path>.   I<row_align> determines where the row is placed, and I<col_align> determines  where I<column> is placed.  Both are expected to be between 0.0 and 1.0.  0.0 means left/top alignment, 1.0 means right/bottom alignment, 0.5 means  center.  If I<use_align> is C<0>, then the alignment arguments are ignored, and the tree does the minimum amount of work to scroll the item onto the screen. This means that the item will be scrolled to the edge closest to its current position.  If the item is currently visible on the screen, nothing is done.  This function only works if the model is set, and I<path> is a valid row on  the model. If the model changes before the I<icon_view> is realized, the  centered path will be modified to reflect this change.

  method gtk_icon_view_scroll_to_path ( N-GtkTreePath $path, Int $use_align, Num $row_align, Num $col_align )

=item N-GtkTreePath $path; The path of the item to move to.
=item Int $use_align; whether to use alignment arguments, or C<0>.
=item Num $row_align; The vertical alignment of the item specified by I<path>.
=item Num $col_align; The horizontal alignment of the item specified by I<path>.

=end pod

sub gtk_icon_view_scroll_to_path ( N-GObject $icon_view, N-GtkTreePath $path, int32 $use_align, num32 $row_align, num32 $col_align  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_enable_model_drag_source:
=begin pod
=head2 [[gtk_] icon_view_] enable_model_drag_source

Turns I<icon_view> into a drag source for automatic DND. Calling this method sets  I<reorderable> to C<0>.

  method gtk_icon_view_enable_model_drag_source ( GdkModifierType $start_button_mask, GtkTargetEntry $targets, Int $n_targets, GdkDragAction $actions )

=item GdkModifierType $start_button_mask; Mask of allowed buttons to start drag
=item GtkTargetEntry $targets; (array length=n_targets): the table of targets that the drag will support
=item Int $n_targets; the number of items in I<targets>
=item GdkDragAction $actions; the bitmask of possible actions for a drag from this widget

=end pod

sub gtk_icon_view_enable_model_drag_source ( N-GObject $icon_view, int32 $start_button_mask, GtkTargetEntry $targets, int32 $n_targets, GdkDragAction $actions  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_enable_model_drag_dest:
=begin pod
=head2 [[gtk_] icon_view_] enable_model_drag_dest

Turns I<icon_view> into a drop destination for automatic DND. Calling this method sets  I<reorderable> to C<0>.

  method gtk_icon_view_enable_model_drag_dest ( GtkTargetEntry $targets, Int $n_targets, GdkDragAction $actions )

=item GtkTargetEntry $targets; (array length=n_targets): the table of targets that the drag will support
=item Int $n_targets; the number of items in I<targets>
=item GdkDragAction $actions; the bitmask of possible actions for a drag to this widget

=end pod

sub gtk_icon_view_enable_model_drag_dest ( N-GObject $icon_view, GtkTargetEntry $targets, int32 $n_targets, GdkDragAction $actions  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_unset_model_drag_source:
=begin pod
=head2 [[gtk_] icon_view_] unset_model_drag_source

Undoes the effect of C<gtk_icon_view_enable_model_drag_source()>. Calling this method sets  I<reorderable> to C<0>.

  method gtk_icon_view_unset_model_drag_source ( )


=end pod

sub gtk_icon_view_unset_model_drag_source ( N-GObject $icon_view  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_unset_model_drag_dest:
=begin pod
=head2 [[gtk_] icon_view_] unset_model_drag_dest

Undoes the effect of C<gtk_icon_view_enable_model_drag_dest()>. Calling this method sets  I<reorderable> to C<0>.

  method gtk_icon_view_unset_model_drag_dest ( )


=end pod

sub gtk_icon_view_unset_model_drag_dest ( N-GObject $icon_view  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_reorderable:
=begin pod
=head2 [[gtk_] icon_view_] set_reorderable

This function is a convenience function to allow you to reorder models that support the B<Gnome::Gtk3::TreeDragSourceIface> and the B<Gnome::Gtk3::TreeDragDestIface>.  Both B<Gnome::Gtk3::TreeStore> and B<Gnome::Gtk3::ListStore> support these.  If I<reorderable> is C<1>, then the user can reorder the model by dragging and dropping rows.  The developer can listen to these changes by connecting to the model's row_inserted and row_deleted signals. The reordering is implemented by setting up the icon view as a drag source and destination. Therefore, drag and drop can not be used in a reorderable view for any other purpose.  This function does not give you any degree of control over the order -- any reordering is allowed.  If more control is needed, you should probably handle drag and drop manually.

  method gtk_icon_view_set_reorderable ( Int $reorderable )

=item Int $reorderable; C<1>, if the list of items can be reordered.

=end pod

sub gtk_icon_view_set_reorderable ( N-GObject $icon_view, int32 $reorderable  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_reorderable:
=begin pod
=head2 [[gtk_] icon_view_] get_reorderable

Retrieves whether the user can reorder the list via drag-and-drop.  See C<gtk_icon_view_set_reorderable()>.

Returns: C<1> if the list can be reordered.

  method gtk_icon_view_get_reorderable ( --> Int )


=end pod

sub gtk_icon_view_get_reorderable ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_drag_dest_item:
=begin pod
=head2 [[gtk_] icon_view_] set_drag_dest_item

Sets the item that is highlighted for feedback.

  method gtk_icon_view_set_drag_dest_item ( N-GtkTreePath $path, GtkIconViewDropPosition $pos )

=item N-GtkTreePath $path; (allow-none): The path of the item to highlight, or C<Any>.
=item GtkIconViewDropPosition $pos; Specifies where to drop, relative to the item

=end pod

sub gtk_icon_view_set_drag_dest_item ( N-GObject $icon_view, N-GtkTreePath $path, int32 $pos  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_drag_dest_item:
=begin pod
=head2 [[gtk_] icon_view_] get_drag_dest_item

Gets information about the item that is highlighted for feedback.

  method gtk_icon_view_get_drag_dest_item ( N-GtkTreePath $path, GtkIconViewDropPosition $pos )

=item N-GtkTreePath $path; (out) (allow-none): Return location for the path of the highlighted item, or C<Any>.
=item GtkIconViewDropPosition $pos; (out) (allow-none): Return location for the drop position, or C<Any>

=end pod

sub gtk_icon_view_get_drag_dest_item ( N-GObject $icon_view, N-GtkTreePath $path, int32 $pos  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_dest_item_at_pos:
=begin pod
=head2 [[gtk_] icon_view_] get_dest_item_at_pos

Determines the destination item for a given position.

Returns: whether there is an item at the given position.

  method gtk_icon_view_get_dest_item_at_pos ( Int $drag_x, Int $drag_y, N-GtkTreePath $path, GtkIconViewDropPosition $pos --> Int )

=item Int $drag_x; the position to determine the destination item for
=item Int $drag_y; the position to determine the destination item for
=item N-GtkTreePath $path; (out) (allow-none): Return location for the path of the item, or C<Any>.
=item GtkIconViewDropPosition $pos; (out) (allow-none): Return location for the drop position, or C<Any>

=end pod

sub gtk_icon_view_get_dest_item_at_pos ( N-GObject $icon_view, int32 $drag_x, int32 $drag_y, N-GtkTreePath $path, int32 $pos --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_create_drag_icon:
=begin pod
=head2 [[gtk_] icon_view_] create_drag_icon

Creates a B<cairo_surface_t> representation of the item at I<path>.   This image is used for a drag icon.

Returns: (transfer full): a newly-allocated surface of the drag icon.

  method gtk_icon_view_create_drag_icon ( N-GtkTreePath $path --> cairo_surface_t )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath> in I<icon_view>

=end pod

sub gtk_icon_view_create_drag_icon ( N-GObject $icon_view, N-GtkTreePath $path --> cairo_surface_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_convert_widget_to_bin_window_coords:
=begin pod
=head2 [[gtk_] icon_view_] convert_widget_to_bin_window_coords

Converts widget coordinates to coordinates for the bin_window, as expected by e.g. C<gtk_icon_view_get_path_at_pos()>.

  method gtk_icon_view_convert_widget_to_bin_window_coords ( Int $wx, Int $wy, Int $bx, Int $by )

=item Int $wx; X coordinate relative to the widget
=item Int $wy; Y coordinate relative to the widget
=item Int $bx; (out): return location for bin_window X coordinate
=item Int $by; (out): return location for bin_window Y coordinate

=end pod

sub gtk_icon_view_convert_widget_to_bin_window_coords ( N-GObject $icon_view, int32 $wx, int32 $wy, int32 $bx, int32 $by  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_cell_rect:
=begin pod
=head2 [[gtk_] icon_view_] get_cell_rect

Fills the bounding rectangle in widget coordinates for the cell specified by I<path> and I<cell>. If I<cell> is C<Any> the main cell area is used.  This function is only valid if I<icon_view> is realized.

Returns: C<0> if there is no such item, C<1> otherwise

  method gtk_icon_view_get_cell_rect ( N-GtkTreePath $path, N-GObject $cell, N-GObject $rect --> Int )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>
=item N-GObject $cell; (allow-none): a B<Gnome::Gtk3::CellRenderer> or C<Any>
=item N-GObject $rect; (out): rectangle to fill with cell rect

=end pod

sub gtk_icon_view_get_cell_rect ( N-GObject $icon_view, N-GtkTreePath $path, N-GObject $cell, N-GObject $rect --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_tooltip_item:
=begin pod
=head2 [[gtk_] icon_view_] set_tooltip_item

Sets the tip area of I<tooltip> to be the area covered by the item at I<path>. See also C<gtk_icon_view_set_tooltip_column()> for a simpler alternative. See also C<gtk_tooltip_set_tip_area()>.

  method gtk_icon_view_set_tooltip_item ( N-GObject $tooltip, N-GtkTreePath $path )

=item N-GObject $tooltip; a B<Gnome::Gtk3::Tooltip>
=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>

=end pod

sub gtk_icon_view_set_tooltip_item ( N-GObject $icon_view, N-GObject $tooltip, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_tooltip_cell:
=begin pod
=head2 [[gtk_] icon_view_] set_tooltip_cell

Sets the tip area of I<tooltip> to the area which I<cell> occupies in the item pointed to by I<path>. See also C<gtk_tooltip_set_tip_area()>.  See also C<gtk_icon_view_set_tooltip_column()> for a simpler alternative.

  method gtk_icon_view_set_tooltip_cell ( N-GObject $tooltip, N-GtkTreePath $path, N-GObject $cell )

=item N-GObject $tooltip; a B<Gnome::Gtk3::Tooltip>
=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>
=item N-GObject $cell; (allow-none): a B<Gnome::Gtk3::CellRenderer> or C<Any>

=end pod

sub gtk_icon_view_set_tooltip_cell ( N-GObject $icon_view, N-GObject $tooltip, N-GtkTreePath $path, N-GObject $cell  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_tooltip_context:
=begin pod
=head2 [[gtk_] icon_view_] get_tooltip_context

This function is supposed to be used in a  I<query-tooltip> signal handler for B<Gnome::Gtk3::IconView>.  The I<x>, I<y> and I<keyboard_tip> values which are received in the signal handler, should be passed to this function without modification.  The return value indicates whether there is an icon view item at the given coordinates (C<1>) or not (C<0>) for mouse tooltips. For keyboard tooltips the item returned will be the cursor item. When C<1>, then any of I<model>, I<path> and I<iter> which have been provided will be set to point to that row and the corresponding model. I<x> and I<y> will always be converted to be relative to I<icon_view>’s bin_window if I<keyboard_tooltip> is C<0>.

Returns: whether or not the given tooltip context points to a item

  method gtk_icon_view_get_tooltip_context ( Int $x, Int $y, Int $keyboard_tip, N-GObject $model, N-GtkTreePath $path, N-GtkTreeIter $iter --> Int )

=item Int $x; (inout): the x coordinate (relative to widget coordinates)
=item Int $y; (inout): the y coordinate (relative to widget coordinates)
=item Int $keyboard_tip; whether this is a keyboard tooltip or not
=item N-GObject $model; (out) (allow-none) (transfer none): a pointer to receive a B<Gnome::Gtk3::TreeModel> or C<Any>
=item N-GtkTreePath $path; (out) (allow-none): a pointer to receive a B<Gnome::Gtk3::TreePath> or C<Any>
=item N-GtkTreeIter $iter; (out) (allow-none): a pointer to receive a B<Gnome::Gtk3::TreeIter> or C<Any>

=end pod

sub gtk_icon_view_get_tooltip_context ( N-GObject $icon_view, int32 $x, int32 $y, int32 $keyboard_tip, N-GObject $model, N-GtkTreePath $path, N-GtkTreeIter $iter --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_set_tooltip_column:
=begin pod
=head2 [[gtk_] icon_view_] set_tooltip_column

If you only plan to have simple (text-only) tooltips on full items, you can use this function to have B<Gnome::Gtk3::IconView> handle these automatically for you. I<column> should be set to the column in I<icon_view>’s model containing the tooltip texts, or -1 to disable this feature.  When enabled,  I<has-tooltip> will be set to C<1> and I<icon_view> will connect a  I<query-tooltip> signal handler.  Note that the signal handler sets the text with C<gtk_tooltip_set_markup()>, so &, <, etc have to be escaped in the text.

  method gtk_icon_view_set_tooltip_column ( Int $column )

=item Int $column; an integer, which is a valid column number for I<icon_view>’s model

=end pod

sub gtk_icon_view_set_tooltip_column ( N-GObject $icon_view, int32 $column  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_view_get_tooltip_column:
=begin pod
=head2 [[gtk_] icon_view_] get_tooltip_column

Returns the column of I<icon_view>’s model which is being used for displaying tooltips on I<icon_view>’s rows.

Returns: the index of the tooltip column that is currently being used, or -1 if this is disabled.

  method gtk_icon_view_get_tooltip_column ( --> Int )


=end pod

sub gtk_icon_view_get_tooltip_column ( N-GObject $icon_view --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:item-activated:
=head3 item-activated

The I<item-activated> signal is emitted when the method
C<gtk_icon_view_item_activated()> is called, when the user double
clicks an item with the "activate-on-single-click" property set
to C<0>, or when the user single clicks an item when the
"activate-on-single-click" property set to C<1>. It is also
emitted when a non-editable item is selected and one of the keys:
Space, Return or Enter is pressed.

  method handler (
    Unknown type GTK_TYPE_TREE_PATH $path,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted

=item $path; the B<Gnome::Gtk3::TreePath> for the activated item


=comment #TS:0:selection-changed:
=head3 selection-changed

The I<selection-changed> signal is emitted when the selection
(i.e. the set of selected items) changes.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:select-all:
=head3 select-all

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user selects all items.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control selection
programmatically.

The default binding for this signal is Ctrl-a.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:unselect-all:
=head3 unselect-all

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user unselects all items.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control selection
programmatically.

The default binding for this signal is Ctrl-Shift-a.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:select-cursor-item:
=head3 select-cursor-item

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user selects the item that is currently
focused.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control selection
programmatically.

There is no default binding for this signal.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:toggle-cursor-item:
=head3 toggle-cursor-item

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user toggles whether the currently
focused item is selected or not. The exact effect of this
depend on the selection mode.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control selection
programmatically.

There is no default binding for this signal is Ctrl-Space.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:activate-cursor-item:
=head3 activate-cursor-item

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user activates the currently
focused item.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control activation
programmatically.

The default bindings for this signal are Space, Return and Enter.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
    --> Int
  );

=item $iconview; the object on which the signal is emitted


=comment #TS:0:move-cursor:
=head3 move-cursor

The I<move-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a cursor movement.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically.

The default bindings for this signal include
- Arrow keys which move by individual steps
- Home/End keys which move to the first/last item
- PageUp/PageDown which move by "pages"
All of these will extend the selection when combined with
the Shift modifier.

  method handler (
    Unknown type GTK_TYPE_MOVEMENT_STEP $step,
    Int $count,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($iconview),
    *%user-options
    --> Int
  );

=item $iconview; the object which received the signal

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>

=item $count; the number of I<step> units to move


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

=comment #TP:0:selection-mode:
=head3 Selection mode


The I<selection-mode> property specifies the selection mode of
icon view. If the mode is B<GTK_SELECTION_MULTIPLE>, rubberband selection
is enabled, for the other modes, only keyboard selection is possible.

   * Since: 2.6Widget type: GTK_TYPE_SELECTION_MODE

The B<Gnome::GObject::Value> type of property I<selection-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:pixbuf-column:
=head3 Pixbuf column


The I<pixbuf-column> property contains the number of the model column
containing the pixbufs which are displayed. The pixbuf column must be
of type B<GDK_TYPE_PIXBUF>. Setting this property to -1 turns off the
display of pixbufs.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<pixbuf-column> is C<G_TYPE_INT>.

=comment #TP:0:text-column:
=head3 Text column


The I<text-column> property contains the number of the model column
containing the texts which are displayed. The text column must be
of type B<G_TYPE_STRING>. If this property and the I<markup-column>
property are both set to -1, no texts are displayed.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<text-column> is C<G_TYPE_INT>.

=comment #TP:0:markup-column:
=head3 Markup column


The I<markup-column> property contains the number of the model column
containing markup information to be displayed. The markup column must be
of type B<G_TYPE_STRING>. If this property and the I<text-column> property
are both set to column numbers, it overrides the text column.
If both are set to -1, no texts are displayed.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<markup-column> is C<G_TYPE_INT>.

=comment #TP:0:model:
=head3 Icon View Model

The model for the icon view
Widget type: GTK_TYPE_TREE_MODEL

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

=comment #TP:0:columns:
=head3 Number of columns


The columns property contains the number of the columns in which the
items should be displayed. If it is -1, the number of columns will
be chosen automatically to fill the available area.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<columns> is C<G_TYPE_INT>.

=comment #TP:0:item-width:
=head3 Width for each item


The item-width property specifies the width to use for each item.
If it is set to -1, the icon view will automatically determine a
suitable item size.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<item-width> is C<G_TYPE_INT>.

=comment #TP:0:spacing:
=head3 Spacing


The spacing property specifies the space which is inserted between
the cells (i.e. the icon and the text) of an item.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.

=comment #TP:0:row-spacing:
=head3 Row Spacing


The row-spacing property specifies the space which is inserted between
the rows of the icon view.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<row-spacing> is C<G_TYPE_INT>.

=comment #TP:0:column-spacing:
=head3 Column Spacing


The column-spacing property specifies the space which is inserted between
the columns of the icon view.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<column-spacing> is C<G_TYPE_INT>.

=comment #TP:0:margin:
=head3 Margin


The margin property specifies the space which is inserted
at the edges of the icon view.

   * Since: 2.6
The B<Gnome::GObject::Value> type of property I<margin> is C<G_TYPE_INT>.

=comment #TP:0:item-orientation:
=head3 Item Orientation


The item-orientation property specifies how the cells (i.e. the icon and
the text) of the item are positioned relative to each other.

   * Since: 2.6Widget type: GTK_TYPE_ORIENTATION

The B<Gnome::GObject::Value> type of property I<item-orientation> is C<G_TYPE_ENUM>.

=comment #TP:0:reorderable:
=head3 Reorderable


The reorderable property specifies if the items can be reordered
by DND.

   * Since: 2.8
The B<Gnome::GObject::Value> type of property I<reorderable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:tooltip-column:
=head3 Tooltip Column


The B<Gnome::GObject::Value> type of property I<tooltip-column> is C<G_TYPE_INT>.

=comment #TP:0:item-padding:
=head3 Item Padding


The item-padding property specifies the padding around each
of the icon view's item.

   * Since: 2.18
The B<Gnome::GObject::Value> type of property I<item-padding> is C<G_TYPE_INT>.

=comment #TP:0:cell-area:
=head3 Cell Area


The B<Gnome::Gtk3::CellArea> used to layout cell renderers for this view.

If no area is specified when creating the icon view with C<gtk_icon_view_new_with_area()>
a B<Gnome::Gtk3::CellAreaBox> will be used.

   * Since: 3.0Widget type: GTK_TYPE_CELL_AREA

The B<Gnome::GObject::Value> type of property I<cell-area> is C<G_TYPE_OBJECT>.

=comment #TP:0:activate-on-single-click:
=head3 Activate on Single Click


The activate-on-single-click property specifies whether the "item-activated" signal
will be emitted after a single click.

   * Since: 3.8
The B<Gnome::GObject::Value> type of property I<activate-on-single-click> is C<G_TYPE_BOOLEAN>.
=end pod
