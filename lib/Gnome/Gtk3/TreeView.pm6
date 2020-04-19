#TL:1:Gnome::Gtk3::TreeView:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeView

A widget for displaying both trees and lists

![](images/list-and-tree.png)

=head1 Description

Widget that displays any object that implements the B<Gnome::Gtk3::TreeModel> interface.

Please refer to the [tree widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TreeWidget.html) for an overview of all the objects and data types related to the tree widget and how they work together.

=head2 Coordinate systems

Several different coordinate systems are exposed in the B<Gnome::Gtk3::TreeView> API.

![](images/tree-view-coordinates.png)

Coordinate systems in B<Gnome::Gtk3::TreeView> API:

=item Widget coordinates: Coordinates relative to the widget (usually `widget->window`).

=item Bin window coordinates: Coordinates relative to the window that B<Gnome::Gtk3::TreeView> renders to.

=item Tree coordinates: Coordinates relative to the entire scrollable area of B<Gnome::Gtk3::TreeView>. These coordinates start at (0, 0) for row 0 of the tree.

Several functions are available for converting between the different coordinate systems.  The most common translations are between widget and bin window coordinates and between bin window and tree coordinates. For the former you can use C<gtk_tree_view_convert_widget_to_bin_window_coords()> (and vice versa), for the latter C<gtk_tree_view_convert_bin_window_to_tree_coords()> (and vice versa).

=head2 Gnome::Gtk3::TreeView as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::TreeView> implementation of the B<Gnome::Gtk3::Buildable> interface accepts B<Gnome::Gtk3::TreeViewColumn> objects as <child> elements and exposes the internal B<Gnome::Gtk3::TreeSelection> in UI definitions.

An example of a UI definition fragment with B<Gnome::Gtk3::TreeView>:

  <object class="GtkTreeView" id="treeview">
    <property name="model">liststore1</property>
    <child>
      <object class="GtkTreeViewColumn" id="test-column">
        <property name="title">Test</property>
        <child>
          <object class="GtkCellRendererText" id="test-renderer"/>
          <attributes>
            <attribute name="text">1</attribute>
          </attributes>
        </child>
      </object>
    </child>
    <child internal-child="selection">
      <object class="GtkTreeSelection" id="selection">
        <signal name="changed" handler="on_treeview_selection_changed"/>
      </object>
    </child>
  </object>


=head2 Css Nodes

  treeview.view
  ├── header
  │   ├── <column header>
  ┊   ┊
  │   ╰── <column header>
  │
  ╰── [rubberband]


B<Gnome::Gtk3::TreeView> has a main CSS node with name treeview and style class .view. It has a subnode with name header, which is the parent for all the column header widgets' CSS nodes. For rubberband selection, a subnode with name rubberband is used.

=begin comment
=head2 Implemented Interfaces

Gnome::Gtk3::TreeView implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=comment item Gnome::Gtk3::Scrollable.
=end comment

=head2 See Also

B<Gnome::Gtk3::TreeViewColumn>, B<Gnome::Gtk3::TreeSelection>, B<Gnome::Gtk3::TreeModel>,

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeView;
  also is Gnome::Gtk3::Container;
=comment   also does Gnome::Gtk3::Buildable;
=comment also does Gnome::Atk::ImplementorIface
=comment also does Gnome::Gtk3::Scrollable.

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::TreeView;

  unit class MyGuiClass;
  also is Gnome::Gtk3::TreeView;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::TreeView class process the options
    self.bless( :GtkTreeView, |c);
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
use Gnome::Glib::List;
use Gnome::Gdk3::Types;
use Gnome::Gtk3::TreeViewColumn;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Buildable;
use Gnome::Gtk3::TreePath;
#use Gnome::Atk::ImplementorIface;
#use Gnome::Gtk3::Scrollable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TreeView:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Buildable;
#also does Gnome::Atk::ImplementorIface
#also does Gnome::Gtk3::Scrollable.


#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTreeViewDropPosition

An enum for determining where a dropped row goes.


=item GTK_TREE_VIEW_DROP_BEFORE: dropped row is inserted before
=item GTK_TREE_VIEW_DROP_AFTER: dropped row is inserted after
=item GTK_TREE_VIEW_DROP_INTO_OR_BEFORE: dropped row becomes a child or is inserted before
=item GTK_TREE_VIEW_DROP_INTO_OR_AFTER: dropped row becomes a child or is inserted after


=end pod

#TE:0:GtkTreeViewDropPosition:
enum GtkTreeViewDropPosition is export (
  'GTK_TREE_VIEW_DROP_INTO_OR_BEFORE',
  'GTK_TREE_VIEW_DROP_INTO_OR_AFTER'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create a new tree view object using a model. This can be e.g. a B<Gnome::Gtk3::ListStore> or B<Gnome::Gtk3::TreeStore>.

  multi method new ( Bool :model! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:1:new(:model):
#TM:0:new(:native-object):
#TM:0:new(:build-id):
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<columns-changed cursor-changed select-all unselect-all toggle-cursor-row select-cursor-parent start-interactive-search>,
    :w1<select-cursor-row>,
    :w2<row-activated test-expand-row test-collapse-row row-expanded row-collapsed move-cursor>,
    :w3<expand-collapse-cursor-row>,
  ) unless $signals-added;


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TreeView' or %options<GtkTreeView> {

    if self.is-valid { }

    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      # process all named arguments
      if %options<empty>:exists {
        Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
        $no = gtk_tree_view_new();
      }

      # process all named arguments
      elsif ? %options<model> {
        my $model = %options<model>;
        $model .= get-native-object-no-reffing
          if $model.^can('get-native-object-no-reffing');
        $no = gtk_tree_view_new_with_model($model);
      }

      else {
        $no = gtk_tree_view_new();
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkTreeView');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_view_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;
#use Gnome::Atk::ImplementorIface;
#use Gnome::Gtk3::Scrollable;

  self.set-class-name-of-sub('GtkTreeView');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_view_new:new()
=begin pod
=head2 [gtk_] tree_view_new

Creates a new B<Gnome::Gtk3::TreeView> widget.

  method gtk_tree_view_new ( --> N-GObject  )

=end pod

sub gtk_tree_view_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_new_with_model:new(:model)
=begin pod
=head2 [[gtk_] tree_view_] new_with_model

Creates a new B<Gnome::Gtk3::TreeView> widget with the model initialized to I<model>.

  method gtk_tree_view_new_with_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; the model.

=end pod

sub gtk_tree_view_new_with_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_model:
=begin pod
=head2 [[gtk_] tree_view_] get_model

Returns the model the B<Gnome::Gtk3::TreeView> is based on.  Returns C<Any> if the
model is unset.

Returns: (transfer none) (nullable): A B<Gnome::Gtk3::TreeModel>, or C<Any> if
none is currently being used.

  method gtk_tree_view_get_model ( --> N-GObject  )


=end pod

sub gtk_tree_view_get_model ( N-GObject $tree_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_set_model:
=begin pod
=head2 [[gtk_] tree_view_] set_model

Sets the model for a B<Gnome::Gtk3::TreeView>.  If the I<tree_view> already has a model
set, it will remove it before setting the new model.  If I<model> is C<Any>,
then it will unset the old model.

  method gtk_tree_view_set_model ( N-GObject $model )

=item N-GObject $model; (allow-none): The model.

=end pod

sub gtk_tree_view_set_model ( N-GObject $tree_view, N-GObject $model )
  is native(&gtk-lib)
  { * }

#`{{}}
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_selection:
=begin pod
=head2 [[gtk_] tree_view_] get_selection

Gets the B<Gnome::Gtk3::TreeSelection> associated with I<tree_view>.

  method gtk_tree_view_get_selection ( --> N-GObject  )

=end pod

sub gtk_tree_view_get_selection ( N-GObject $tree_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_headers_visible:
=begin pod
=head2 [[gtk_] tree_view_] get_headers_visible

Returns C<1> if the headers on the I<tree_view> are visible.

  method gtk_tree_view_get_headers_visible ( --> Int  )

=end pod

sub gtk_tree_view_get_headers_visible ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_set_headers_visible:
=begin pod
=head2 [[gtk_] tree_view_] set_headers_visible

Sets the visibility state of the headers.

  method gtk_tree_view_set_headers_visible ( Int $headers_visible )

=item Int $headers_visible; C<1> if the headers are visible

=end pod

sub gtk_tree_view_set_headers_visible ( N-GObject $tree_view, int32 $headers_visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_columns_autosize:
=begin pod
=head2 [[gtk_] tree_view_] columns_autosize

Resizes all columns to their optimal width. Only works after the treeview has been realized.

  method gtk_tree_view_columns_autosize ( )


=end pod

sub gtk_tree_view_columns_autosize ( N-GObject $tree_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_headers_clickable:
=begin pod
=head2 [[gtk_] tree_view_] get_headers_clickable

Returns C<1> if all header columns are clickable, otherwise C<0>


  method gtk_tree_view_get_headers_clickable ( --> Int  )

=end pod

sub gtk_tree_view_get_headers_clickable ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_headers_clickable:
=begin pod
=head2 [[gtk_] tree_view_] set_headers_clickable

Allow the column title buttons to be clicked.

  method gtk_tree_view_set_headers_clickable ( Int $setting )

=item Int $setting; C<1> if the columns are clickable.

=end pod

sub gtk_tree_view_set_headers_clickable ( N-GObject $tree_view, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_activate_on_single_click:
=begin pod
=head2 [[gtk_] tree_view_] get_activate_on_single_click

Gets the setting set by C<gtk_tree_view_set_activate_on_single_click()>. The method returns C<1> if row-activated will be emitted on a single click.


  method gtk_tree_view_get_activate_on_single_click ( --> Int  )

=end pod

sub gtk_tree_view_get_activate_on_single_click ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_set_activate_on_single_click:
=begin pod
=head2 [[gtk_] tree_view_] set_activate_on_single_click

Cause the  I<row-activated> signal to be emitted on a single click instead of a double click.


  method gtk_tree_view_set_activate_on_single_click ( Int $single )

=item Int $single; C<1> to emit row-activated on a single click

=end pod

sub gtk_tree_view_set_activate_on_single_click ( N-GObject $tree_view, int32 $single )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_append_column:
=begin pod
=head2 [[gtk_] tree_view_] append_column

Appends I<$column> to the list of columns. If this tree view has “fixed_height” mode enabled, then I<$column> must have its “sizing” property set to be GTK_TREE_VIEW_COLUMN_FIXED.

Returns: The number of columns in I<tree_view> after appending.

  method gtk_tree_view_append_column (
    Gnome::Gtk3::TreeViewColumn $column
    --> Int
  )

=item Gnome::Gtk3::TreeViewColumn $column; The column to add.

=end pod

sub gtk_tree_view_append_column ( N-GObject $tree_view, N-GObject $column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_remove_column:
=begin pod
=head2 [[gtk_] tree_view_] remove_column

Removes I<column> from I<tree_view>.

Returns: The number of columns in I<tree_view> after removing.

  method gtk_tree_view_remove_column ( N-GObject $column --> Int  )

=item N-GObject $column; The B<Gnome::Gtk3::TreeViewColumn> to remove.

=end pod

sub gtk_tree_view_remove_column ( N-GObject $tree_view, N-GObject $column )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_insert_column:
=begin pod
=head2 [[gtk_] tree_view_] insert_column

This inserts the I<column> into the I<tree_view> at I<position>.  If I<position> is
-1, then the column is inserted at the end. If I<tree_view> has
“fixed_height” mode enabled, then I<column> must have its “sizing” property
set to be GTK_TREE_VIEW_COLUMN_FIXED.

Returns: The number of columns in I<tree_view> after insertion.

  method gtk_tree_view_insert_column ( N-GObject $column, Int $position --> Int  )

=item N-GObject $column; The B<Gnome::Gtk3::TreeViewColumn> to be inserted.
=item Int $position; The position to insert I<column> in.

=end pod

sub gtk_tree_view_insert_column ( N-GObject $tree_view, N-GObject $column, int32 $position )
  returns int32
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_insert_column_with_attributes:
=begin pod
=comment head2 [gtk_tree_view_] insert_column_with_attributes
=head2 insert-column-with-attributes

Creates a new B<Gnome::Gtk3::TreeViewColumn> and inserts it into the I<tree_view> at I<position>.  If I<position> is -1, then the newly created column is inserted at the end.  The column is initialized with the attributes given. If I<tree_view> has “fixed_height” mode enabled, then the new column will have its sizing property set to be GTK_TREE_VIEW_COLUMN_FIXED.

Returns: The number of columns in this treeview after insertion.

  method insert-column-with-attributes (
    Int $insert-position,
    Str $title, Gnome::Gtk3::CellRenderer $cellrenderer, ...
    --> Int
  )

=item A repeating list of
=item2 Int $position; The position to insert the new column in
=item2 Str $title; The title to set the header to
=item2 Gnome::Gtk3::CellRenderer $cell; The cell renderer

=end pod

method insert-column-with-attributes ( *@attributes --> Int ) {

  my @parameter-list = ( );
  @parameter-list.push: Parameter.new(type => N-GObject);    # tree_view

  my @attrs = ( );
  for @attributes -> $insert, $title, $renderer {
    @parameter-list.push: Parameter.new(type => int32);      # insert position
    @parameter-list.push: Parameter.new(type => Str);        # title
    @parameter-list.push: Parameter.new(type => N-GObject);  # renderer

    @attrs.push: $insert;
    @attrs.push: $title;
    @attrs.push: $renderer.get-native-object;
  }

  # end list with 0
  @parameter-list.push: Parameter.new(type => int32);

  # create signature
  my Signature $signature .= new(
    :params(|@parameter-list),
    :returns(int32)
  );

note "S: ", $signature.perl;
note "A: ", (self.get-native-object, |@attrs, 0).join(', ');

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal(
    &gtk-lib, 'gtk_tree_view_insert_column_with_attributes', Pointer
  );
  my Callable $f = nativecast( $signature, $ptr);

  $f( self.get-native-object, |@attrs, 0)
}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_insert_column_with_data_func:
=begin pod
=head2 [[gtk_] tree_view_] insert_column_with_data_func

Convenience function that inserts a new column into the B<Gnome::Gtk3::TreeView>
with the given cell renderer and a B<Gnome::Gtk3::TreeCellDataFunc> to set cell renderer
attributes (normally using data from the model). See also
C<gtk_tree_view_column_set_cell_data_func()>, C<gtk_tree_view_column_pack_start()>.
If I<tree_view> has “fixed_height” mode enabled, then the new column will have its
“sizing” property set to be GTK_TREE_VIEW_COLUMN_FIXED.

Returns: number of columns in the tree view post-insert

  method gtk_tree_view_insert_column_with_data_func ( Int $position, Str $title, N-GObject $cell, GtkTreeCellDataFunc $func, Pointer $data, GDestroyNotify $dnotify --> Int  )

=item Int $position; Position to insert, -1 for append
=item Str $title; column title
=item N-GObject $cell; cell renderer for column
=item GtkTreeCellDataFunc $func; function to set attributes of cell renderer
=item Pointer $data; data for I<func>
=item GDestroyNotify $dnotify; destroy notifier for I<data>

=end pod

sub gtk_tree_view_insert_column_with_data_func ( N-GObject $tree_view, int32 $position, Str $title, N-GObject $cell, GtkTreeCellDataFunc $func, Pointer $data, GDestroyNotify $dnotify )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_n_columns:
=begin pod
=head2 [[gtk_] tree_view_] get_n_columns

Queries the number of columns in the given I<tree_view>.

Returns: The number of columns in the I<tree_view>


  method gtk_tree_view_get_n_columns ( --> UInt  )


=end pod

sub gtk_tree_view_get_n_columns ( N-GObject $tree_view )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_column:
=begin pod
=head2 [[gtk_] tree_view_] get_column

Gets the B<Gnome::Gtk3::TreeViewColumn> at the given position in the B<tree_view> or undefined if the position is outside the range of columns.

  method gtk_tree_view_get_column ( Int $n --> Gnome::Gtk3::TreeViewColumn )

=item Int $n; The position of the column, counting from 0.

=end pod

sub gtk_tree_view_get_column ( N-GObject $tree_view, int32 $n )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_view_get_columns:
=begin pod
=head2 [[gtk_] tree_view_] get_columns

Returns a B<GList> of all the B<Gnome::Gtk3::TreeViewColumn> s currently in I<tree_view>.
The returned list must be freed with C<g_list_free()>.

Returns: (element-type B<Gnome::Gtk3::TreeViewColumn>) (transfer container): A list of B<Gnome::Gtk3::TreeViewColumn> s

  method gtk_tree_view_get_columns ( --> N-GList  )


=end pod

sub gtk_tree_view_get_columns ( N-GObject $tree_view )
  returns N-GList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_move_column_after:
=begin pod
=head2 [[gtk_] tree_view_] move_column_after

Moves I<column> to be after to I<base_column>.  If I<base_column> is C<Any>, then
I<column> is placed in the first position.

  method gtk_tree_view_move_column_after ( N-GObject $column, N-GObject $base_column )

=item N-GObject $column; The B<Gnome::Gtk3::TreeViewColumn> to be moved.
=item N-GObject $base_column; (allow-none): The B<Gnome::Gtk3::TreeViewColumn> to be moved relative to, or C<Any>.

=end pod

sub gtk_tree_view_move_column_after ( N-GObject $tree_view, N-GObject $column, N-GObject $base_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_expander_column:
=begin pod
=head2 [[gtk_] tree_view_] set_expander_column

Sets the column to draw the expander arrow at. It must be in I<tree_view>.
If I<column> is C<Any>, then the expander arrow is always at the first
visible column.

If you do not want expander arrow to appear in your tree, set the
expander column to a hidden column.

  method gtk_tree_view_set_expander_column ( N-GObject $column )

=item N-GObject $column; C<Any>, or the column to draw the expander arrow at.

=end pod

sub gtk_tree_view_set_expander_column ( N-GObject $tree_view, N-GObject $column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_expander_column:
=begin pod
=head2 [[gtk_] tree_view_] get_expander_column

Returns the column that is the current expander column.
This column has the expander arrow drawn next to it.

Returns: (transfer none): The expander column.

  method gtk_tree_view_get_expander_column ( --> N-GObject  )


=end pod

sub gtk_tree_view_get_expander_column ( N-GObject $tree_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_column_drag_function:
=begin pod
=head2 [[gtk_] tree_view_] set_column_drag_function

Sets a user function for determining where a column may be dropped when
dragged.  This function is called on every column pair in turn at the
beginning of a column drag to determine where a drop can take place.  The
arguments passed to I<func> are: the I<tree_view>, the B<Gnome::Gtk3::TreeViewColumn> being
dragged, the two B<Gnome::Gtk3::TreeViewColumn> s determining the drop spot, and
I<user_data>.  If either of the B<Gnome::Gtk3::TreeViewColumn> arguments for the drop spot
are C<Any>, then they indicate an edge.  If I<func> is set to be C<Any>, then
I<tree_view> reverts to the default behavior of allowing all columns to be
dropped everywhere.

  method gtk_tree_view_set_column_drag_function ( GtkTreeViewColumnDropFunc $func, Pointer $user_data, GDestroyNotify $destroy )

=item GtkTreeViewColumnDropFunc $func; (allow-none): A function to determine which columns are reorderable, or C<Any>.
=item Pointer $user_data; (allow-none): User data to be passed to I<func>, or C<Any>
=item GDestroyNotify $destroy; (allow-none): Destroy notifier for I<user_data>, or C<Any>

=end pod

sub gtk_tree_view_set_column_drag_function ( N-GObject $tree_view, GtkTreeViewColumnDropFunc $func, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_scroll_to_point:
=begin pod
=head2 [[gtk_] tree_view_] scroll_to_point

Scrolls the tree view such that the top-left corner of the visible
area is I<tree_x>, I<tree_y>, where I<tree_x> and I<tree_y> are specified
in tree coordinates.  The I<tree_view> must be realized before
this function is called.  If it isn't, you probably want to be
using C<gtk_tree_view_scroll_to_cell()>.

If either I<tree_x> or I<tree_y> are -1, then that direction isn’t scrolled.

  method gtk_tree_view_scroll_to_point ( Int $tree_x, Int $tree_y )

=item Int $tree_x; X coordinate of new top-left pixel of visible area, or -1
=item Int $tree_y; Y coordinate of new top-left pixel of visible area, or -1

=end pod

sub gtk_tree_view_scroll_to_point ( N-GObject $tree_view, int32 $tree_x, int32 $tree_y )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_scroll_to_cell:
=begin pod
=head2 [[gtk_] tree_view_] scroll_to_cell

Moves the alignments of I<tree_view> to the position specified by I<column> and
I<path>.  If I<column> is C<Any>, then no horizontal scrolling occurs.  Likewise,
if I<path> is C<Any> no vertical scrolling occurs.  At a minimum, one of I<column>
or I<path> need to be non-C<Any>.  I<row_align> determines where the row is
placed, and I<col_align> determines where I<column> is placed.  Both are expected
to be between 0.0 and 1.0. 0.0 means left/top alignment, 1.0 means
right/bottom alignment, 0.5 means center.

If I<use_align> is C<0>, then the alignment arguments are ignored, and the
tree does the minimum amount of work to scroll the cell onto the screen.
This means that the cell will be scrolled to the edge closest to its current
position.  If the cell is currently visible on the screen, nothing is done.

This function only works if the model is set, and I<path> is a valid row on the
model.  If the model changes before the I<tree_view> is realized, the centered
path will be modified to reflect this change.

  method gtk_tree_view_scroll_to_cell ( N-GtkTreePath $path, N-GObject $column, Int $use_align, Num $row_align, Num $col_align )

=item N-GtkTreePath $path; (allow-none): The path of the row to move to, or C<Any>.
=item N-GObject $column; (allow-none): The B<Gnome::Gtk3::TreeViewColumn> to move horizontally to, or C<Any>.
=item Int $use_align; whether to use alignment arguments, or C<0>.
=item Num $row_align; The vertical alignment of the row specified by I<path>.
=item Num $col_align; The horizontal alignment of the column specified by I<column>.

=end pod

sub gtk_tree_view_scroll_to_cell ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $column, int32 $use_align, num32 $row_align, num32 $col_align )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_row_activated:
=begin pod
=head2 [[gtk_] tree_view_] row_activated

Activates the cell determined by I<path> and I<column>.

  method gtk_tree_view_row_activated ( N-GtkTreePath $path, N-GObject $column )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be activated.
=item N-GObject $column; The B<Gnome::Gtk3::TreeViewColumn> to be activated.

=end pod

sub gtk_tree_view_row_activated ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $column )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_expand_all:
=begin pod
=head2 [[gtk_] tree_view_] expand_all

Recursively expands all nodes in the I<tree_view>.

  method gtk_tree_view_expand_all ( )


=end pod

sub gtk_tree_view_expand_all ( N-GObject $tree_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_collapse_all:
=begin pod
=head2 [[gtk_] tree_view_] collapse_all

Recursively collapses all visible, expanded nodes in I<tree_view>.

  method gtk_tree_view_collapse_all ( )


=end pod

sub gtk_tree_view_collapse_all ( N-GObject $tree_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_tree_view_expand_to_path:QAManager
=begin pod
=head2 [[gtk_] tree_view_] expand_to_path

Expands the row at I<$path>. This will also expand all parent rows of I<$path> as necessary.

  method gtk_tree_view_expand_to_path ( N-GtkTreePath $path )

=item N-GtkTreePath $path; path to a row.

=end pod

sub gtk_tree_view_expand_to_path ( N-GObject $tree_view, N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_tree_view_expand_row:QAManager
=begin pod
=head2 [[gtk_] tree_view_] expand_row

Opens the row so its children are visible.

Returns: C<1> if the row existed and had children

  method gtk_tree_view_expand_row (
    N-GtkTreePath $path, Bool $open_all
    --> Int
  )

=item N-GtkTreePath $path; path to a row
=item Int $open_all; whether to recursively expand, or just expand immediate children

=end pod

sub gtk_tree_view_expand_row ( N-GObject $tree_view, N-GtkTreePath $path, int32 $open_all )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_tree_view_collapse_row:QAManager
=begin pod
=head2 [[gtk_] tree_view_] collapse_row

Collapses a row (hides its child rows, if they exist).

Returns: C<1> if the row was collapsed.

  method gtk_tree_view_collapse_row ( N-GtkTreePath $path --> Int  )

=item N-GtkTreePath $path; path to a row in the I<tree_view>

=end pod

sub gtk_tree_view_collapse_row ( N-GObject $tree_view, N-GtkTreePath $path )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_map_expanded_rows:
=begin pod
=head2 [[gtk_] tree_view_] map_expanded_rows

Calls I<func> on all expanded rows.

  method gtk_tree_view_map_expanded_rows ( GtkTreeViewMappingFunc $func, Pointer $data )

=item GtkTreeViewMappingFunc $func; (scope call): A function to be called
=item Pointer $data; User data to be passed to the function.

=end pod

sub gtk_tree_view_map_expanded_rows ( N-GObject $tree_view, GtkTreeViewMappingFunc $func, Pointer $data )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:gtk_tree_view_row_expanded:QAManager
=begin pod
=head2 [[gtk_] tree_view_] row_expanded

Returns C<1> if the node pointed to by I<$path> is expanded.

  method gtk_tree_view_row_expanded ( N-GtkTreePath $path --> Int  )

=end pod

sub gtk_tree_view_row_expanded ( N-GObject $tree_view, N-GtkTreePath $path )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_reorderable:
=begin pod
=head2 [[gtk_] tree_view_] set_reorderable

This function is a convenience function to allow you to reorder
models that support the B<Gnome::Gtk3::TreeDragSourceIface> and the
B<Gnome::Gtk3::TreeDragDestIface>.  Both B<Gnome::Gtk3::TreeStore> and B<Gnome::Gtk3::ListStore> support
these.  If I<reorderable> is C<1>, then the user can reorder the
model by dragging and dropping rows. The developer can listen to
these changes by connecting to the model’s  I<row-inserted>
and  I<row-deleted> signals. The reordering is implemented
by setting up the tree view as a drag source and destination.
Therefore, drag and drop can not be used in a reorderable view for any
other purpose.

This function does not give you any degree of control over the order -- any
reordering is allowed.  If more control is needed, you should probably
handle drag and drop manually.

  method gtk_tree_view_set_reorderable ( Int $reorderable )

=item Int $reorderable; C<1>, if the tree can be reordered.

=end pod

sub gtk_tree_view_set_reorderable ( N-GObject $tree_view, int32 $reorderable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_reorderable:
=begin pod
=head2 [[gtk_] tree_view_] get_reorderable

Retrieves whether the user can reorder the tree via drag-and-drop. See
C<gtk_tree_view_set_reorderable()>.

Returns: C<1> if the tree can be reordered.

  method gtk_tree_view_get_reorderable ( --> Int  )


=end pod

sub gtk_tree_view_get_reorderable ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_cursor:
=begin pod
=head2 [[gtk_] tree_view_] set_cursor

Sets the current keyboard focus to be at I<path>, and selects it.  This is
useful when you want to focus the user’s attention on a particular row.  If
I<focus_column> is not C<Any>, then focus is given to the column specified by
it. Additionally, if I<focus_column> is specified, and I<start_editing> is
C<1>, then editing should be started in the specified cell.
This function is often followed by I<gtk_widget_grab_focus> (I<tree_view>)
in order to give keyboard focus to the widget.  Please note that editing
can only happen when the widget is realized.

If I<path> is invalid for I<model>, the current cursor (if any) will be unset
and the function will return without failing.

  method gtk_tree_view_set_cursor ( N-GtkTreePath $path, N-GObject $focus_column, Int $start_editing )

=item N-GtkTreePath $path; A B<Gnome::Gtk3::TreePath>
=item N-GObject $focus_column; (allow-none): A B<Gnome::Gtk3::TreeViewColumn>, or C<Any>
=item Int $start_editing; C<1> if the specified cell should start being edited.

=end pod

sub gtk_tree_view_set_cursor ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $focus_column, int32 $start_editing )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_cursor_on_cell:
=begin pod
=head2 [[gtk_] tree_view_] set_cursor_on_cell

Sets the current keyboard focus to be at I<path>, and selects it.  This is
useful when you want to focus the user’s attention on a particular row.  If
I<focus_column> is not C<Any>, then focus is given to the column specified by
it. If I<focus_column> and I<focus_cell> are not C<Any>, and I<focus_column>
contains 2 or more editable or activatable cells, then focus is given to
the cell specified by I<focus_cell>. Additionally, if I<focus_column> is
specified, and I<start_editing> is C<1>, then editing should be started in
the specified cell.  This function is often followed by
I<gtk_widget_grab_focus> (I<tree_view>) in order to give keyboard focus to the
widget.  Please note that editing can only happen when the widget is
realized.

If I<path> is invalid for I<model>, the current cursor (if any) will be unset
and the function will return without failing.


  method gtk_tree_view_set_cursor_on_cell ( N-GtkTreePath $path, N-GObject $focus_column, N-GObject $focus_cell, Int $start_editing )

=item N-GtkTreePath $path; A B<Gnome::Gtk3::TreePath>
=item N-GObject $focus_column; (allow-none): A B<Gnome::Gtk3::TreeViewColumn>, or C<Any>
=item N-GObject $focus_cell; (allow-none): A B<Gnome::Gtk3::CellRenderer>, or C<Any>
=item Int $start_editing; C<1> if the specified cell should start being edited.

=end pod

sub gtk_tree_view_set_cursor_on_cell ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $focus_column, N-GObject $focus_cell, int32 $start_editing )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_cursor:
=begin pod
=head2 [[gtk_] tree_view_] get_cursor

Fills in I<path> and I<focus_column> with the current path and focus column.  If
the cursor isn’t currently set, then *I<path> will be C<Any>.  If no column
currently has focus, then *I<focus_column> will be C<Any>.

The returned B<Gnome::Gtk3::TreePath> must be freed with C<gtk_tree_path_free()> when
you are done with it.

  method gtk_tree_view_get_cursor ( N-GtkTreePath $path, N-GObject $focus_column )

=item N-GtkTreePath $path; (out) (transfer full) (optional) (nullable): A pointer to be filled with the current cursor path, or C<Any>
=item N-GObject $focus_column; (out) (transfer none) (optional) (nullable): A pointer to be filled with the current focus column, or C<Any>

=end pod

sub gtk_tree_view_get_cursor ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $focus_column )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_bin_window:
=begin pod
=head2 [[gtk_] tree_view_] get_bin_window

Returns the window that I<tree_view> renders to.
This is used primarily to compare to `event->window`
to confirm that the event on I<tree_view> is on the right window.

Returns: (nullable) (transfer none): A B<Gnome::Gdk3::Window>, or C<Any> when I<tree_view>
hasn’t been realized yet.

  method gtk_tree_view_get_bin_window ( --> N-GObject  )


=end pod

sub gtk_tree_view_get_bin_window ( N-GObject $tree_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_path_at_pos:
=begin pod
=head2 [[gtk_] tree_view_] get_path_at_pos

Finds the path at the point (I<x>, I<y>), relative to bin_window coordinates
(please see C<gtk_tree_view_get_bin_window()>).
That is, I<x> and I<y> are relative to an events coordinates. I<x> and I<y> must
come from an event on the I<tree_view> only where `event->window ==
C<gtk_tree_view_get_bin_window()>`. It is primarily for
things like popup menus. If I<path> is non-C<Any>, then it will be filled
with the B<Gnome::Gtk3::TreePath> at that point.  This path should be freed with
C<gtk_tree_path_free()>.  If I<column> is non-C<Any>, then it will be filled
with the column at that point.  I<cell_x> and I<cell_y> return the coordinates
relative to the cell background (i.e. the I<background_area> passed to
C<gtk_cell_renderer_render()>).  This function is only meaningful if
I<tree_view> is realized.  Therefore this function will always return C<0>
if I<tree_view> is not realized or does not have a model.

For converting widget coordinates (eg. the ones you get from
B<Gnome::Gtk3::Widget>::query-tooltip), please see
C<gtk_tree_view_convert_widget_to_bin_window_coords()>.

Returns: C<1> if a row exists at that coordinate.

  method gtk_tree_view_get_path_at_pos ( Int $x, Int $y, N-GtkTreePath $path, N-GObject $column, Int $cell_x, Int $cell_y --> Int  )

=item Int $x; The x position to be identified (relative to bin_window).
=item Int $y; The y position to be identified (relative to bin_window).
=item N-GtkTreePath $path; (out) (optional) (nullable): A pointer to a B<Gnome::Gtk3::TreePath> pointer to be filled in, or C<Any>
=item N-GObject $column; (out) (transfer none) (optional) (nullable): A pointer to a B<Gnome::Gtk3::TreeViewColumn> pointer to be filled in, or C<Any>
=item Int $cell_x; (out) (optional): A pointer where the X coordinate relative to the cell can be placed, or C<Any>
=item Int $cell_y; (out) (optional): A pointer where the Y coordinate relative to the cell can be placed, or C<Any>

=end pod

sub gtk_tree_view_get_path_at_pos ( N-GObject $tree_view, int32 $x, int32 $y, N-GtkTreePath $path, N-GObject $column, int32 $cell_x, int32 $cell_y )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_cell_area:
=begin pod
=head2 [[gtk_] tree_view_] get_cell_area

Fills the bounding rectangle in bin_window coordinates for the cell at the row specified by I<$path> and the column specified by I<$column>.  If I<$path> is undefined, or points to a path not currently displayed, the I<y> and I<height> fields of the rectangle will be filled with 0. If I<$column> is undefined, the I<x> and I<width> fields will be filled with 0.  The sum of all cell rects does not cover the entire tree; there are extra pixels in between rows, for example. The returned rectangle is equivalent to the I<cell_area> passed to C<gtk_cell_renderer_render()>.

  method gtk_tree_view_get_cell_area (
    N-GtkTreePath $path, N-GObject $column
    --> N-GdkRectangle
  )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath> for the row, or C<Any> to get only horizontal coordinates
=item N-GObject $column; a B<Gnome::Gtk3::TreeViewColumn> for the column, or C<Any> to get only vertical coordinates

Returns a N-GdkRectangle rectangle to fill with cell rectangle

=end pod

sub gtk_tree_view_get_cell_area (
  N-GObject $tree_view, N-GtkTreePath $path, N-GObject $column
  --> N-GdkRectangle
) {
  my N-GdkRectangle $rect .= new;
  _gtk_tree_view_get_cell_area( $tree_view, $path, $column, $rect);

  $rect
}

sub _gtk_tree_view_get_cell_area (
  N-GObject $tree_view, N-GtkTreePath $path, N-GObject $column,
  N-GdkRectangle $rect is rw
) is native(&gtk-lib)
  is symbol('gtk_tree_view_get_cell_area')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_background_area:
=begin pod
=head2 [[gtk_] tree_view_] get_background_area

Fills the bounding rectangle in bin_window coordinates for the cell at the
row specified by I<path> and the column specified by I<column>.  If I<path> is
C<Any>, or points to a node not found in the tree, the I<y> and I<height> fields of
the rectangle will be filled with 0. If I<column> is C<Any>, the I<x> and I<width>
fields will be filled with 0.  The returned rectangle is equivalent to the
I<background_area> passed to C<gtk_cell_renderer_render()>.  These background
areas tile to cover the entire bin window.  Contrast with the I<cell_area>,
returned by C<gtk_tree_view_get_cell_area()>, which returns only the cell
itself, excluding surrounding borders and the tree expander area.


  method gtk_tree_view_get_background_area ( N-GtkTreePath $path, N-GObject $column, N-GObject $rect )

=item N-GtkTreePath $path; (allow-none): a B<Gnome::Gtk3::TreePath> for the row, or C<Any> to get only horizontal coordinates
=item N-GObject $column; (allow-none): a B<Gnome::Gtk3::TreeViewColumn> for the column, or C<Any> to get only vertical coordiantes
=item N-GObject $rect; (out): rectangle to fill with cell background rect

=end pod

sub gtk_tree_view_get_background_area ( N-GObject $tree_view, N-GtkTreePath $path, N-GObject $column, N-GObject $rect )
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_visible_rect:
=begin pod
=head2 [[gtk_] tree_view_] get_visible_rect

Fills I<visible_rect> with the currently-visible region of the
buffer, in tree coordinates. Convert to bin_window coordinates with
C<gtk_tree_view_convert_tree_to_bin_window_coords()>.
Tree coordinates start at 0,0 for row 0 of the tree, and cover the entire
scrollable area of the tree.

  method gtk_tree_view_get_visible_rect ( N-GObject $visible_rect )

=item N-GObject $visible_rect; (out): rectangle to fill

=end pod

sub gtk_tree_view_get_visible_rect ( N-GObject $tree_view, N-GObject $visible_rect )
  is native(&gtk-lib)
  { * }
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_visible_range:
=begin pod
=head2 [[gtk_] tree_view_] get_visible_range

Sets I<start_path> and I<end_path> to be the first and last visible path.
Note that there may be invisible paths in between.

The paths should be freed with C<gtk_tree_path_free()> after use.

Returns: C<1>, if valid paths were placed in I<start_path> and I<end_path>.


  method gtk_tree_view_get_visible_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path --> Int  )

=item N-GtkTreePath $start_path; (out) (allow-none): Return location for start of region, or C<Any>.
=item N-GtkTreePath $end_path; (out) (allow-none): Return location for end of region, or C<Any>.

=end pod

sub gtk_tree_view_get_visible_range ( N-GObject $tree_view, N-GtkTreePath $start_path, N-GtkTreePath $end_path )
  returns int32
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_is_blank_at_pos:
=begin pod
=head2 [[gtk_] tree_view_] is_blank_at_pos

Determine whether the point (I<x>, I<y>) in I<tree_view> is blank, that is no
cell content nor an expander arrow is drawn at the location. If so, the
location can be considered as the background. You might wish to take
special action on clicks on the background, such as clearing a current
selection, having a custom context menu or starting rubber banding.

The I<x> and I<y> coordinate that are provided must be relative to bin_window
coordinates.  That is, I<x> and I<y> must come from an event on I<tree_view>
where `event->window == C<gtk_tree_view_get_bin_window()>`.

For converting widget coordinates (eg. the ones you get from
B<Gnome::Gtk3::Widget>::query-tooltip), please see
C<gtk_tree_view_convert_widget_to_bin_window_coords()>.

The I<path>, I<column>, I<cell_x> and I<cell_y> arguments will be filled in
likewise as for C<gtk_tree_view_get_path_at_pos()>.  Please see
C<gtk_tree_view_get_path_at_pos()> for more information.

Returns: C<1> if the area at the given coordinates is blank,
C<0> otherwise.


  method gtk_tree_view_is_blank_at_pos ( Int $x, Int $y, N-GtkTreePath $path, N-GObject $column, Int $cell_x, Int $cell_y --> Int  )

=item Int $x; The x position to be identified (relative to bin_window)
=item Int $y; The y position to be identified (relative to bin_window)
=item N-GtkTreePath $path; (out) (allow-none): A pointer to a B<Gnome::Gtk3::TreePath> pointer to be filled in, or C<Any>
=item N-GObject $column; (out) (allow-none): A pointer to a B<Gnome::Gtk3::TreeViewColumn> pointer to be filled in, or C<Any>
=item Int $cell_x; (out) (allow-none): A pointer where the X coordinate relative to the cell can be placed, or C<Any>
=item Int $cell_y; (out) (allow-none): A pointer where the Y coordinate relative to the cell can be placed, or C<Any>

=end pod

sub gtk_tree_view_is_blank_at_pos ( N-GObject $tree_view, int32 $x, int32 $y, N-GtkTreePath $path, N-GObject $column, int32 $cell_x, int32 $cell_y )
  returns int32
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_enable_model_drag_source:
=begin pod
=head2 [[gtk_] tree_view_] enable_model_drag_source

Turns I<tree_view> into a drag source for automatic DND. Calling this
method sets  I<reorderable> to C<0>.

  method gtk_tree_view_enable_model_drag_source ( GdkModifierType $start_button_mask, GtkTargetEntry $targets, Int $n_targets, GdkDragAction $actions )

=item GdkModifierType $start_button_mask; Mask of allowed buttons to start drag
=item GtkTargetEntry $targets; (array length=n_targets): the table of targets that the drag will support
=item Int $n_targets; the number of items in I<targets>
=item GdkDragAction $actions; the bitmask of possible actions for a drag from this widget

=end pod

sub gtk_tree_view_enable_model_drag_source ( N-GObject $tree_view, int32 $start_button_mask, GtkTargetEntry $targets, int32 $n_targets, GdkDragAction $actions )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_enable_model_drag_dest:
=begin pod
=head2 [[gtk_] tree_view_] enable_model_drag_dest

Turns I<tree_view> into a drop destination for automatic DND. Calling
this method sets  I<reorderable> to C<0>.

  method gtk_tree_view_enable_model_drag_dest ( GtkTargetEntry $targets, Int $n_targets, GdkDragAction $actions )

=item GtkTargetEntry $targets; (array length=n_targets): the table of targets that the drag will support
=item Int $n_targets; the number of items in I<targets>
=item GdkDragAction $actions; the bitmask of possible actions for a drag from this widget

=end pod

sub gtk_tree_view_enable_model_drag_dest ( N-GObject $tree_view, GtkTargetEntry $targets, int32 $n_targets, GdkDragAction $actions )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_unset_rows_drag_source:
=begin pod
=head2 [[gtk_] tree_view_] unset_rows_drag_source

Undoes the effect of
C<gtk_tree_view_enable_model_drag_source()>. Calling this method sets
 I<reorderable> to C<0>.

  method gtk_tree_view_unset_rows_drag_source ( )


=end pod

sub gtk_tree_view_unset_rows_drag_source ( N-GObject $tree_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_unset_rows_drag_dest:
=begin pod
=head2 [[gtk_] tree_view_] unset_rows_drag_dest

Undoes the effect of
C<gtk_tree_view_enable_model_drag_dest()>. Calling this method sets
 I<reorderable> to C<0>.

  method gtk_tree_view_unset_rows_drag_dest ( )


=end pod

sub gtk_tree_view_unset_rows_drag_dest ( N-GObject $tree_view )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_drag_dest_row:
=begin pod
=head2 [[gtk_] tree_view_] set_drag_dest_row

Sets the row that is highlighted for feedback.
If I<path> is C<Any>, an existing highlight is removed.

  method gtk_tree_view_set_drag_dest_row ( N-GtkTreePath $path, GtkTreeViewDropPosition $pos )

=item N-GtkTreePath $path; (allow-none): The path of the row to highlight, or C<Any>
=item GtkTreeViewDropPosition $pos; Specifies whether to drop before, after or into the row

=end pod

sub gtk_tree_view_set_drag_dest_row ( N-GObject $tree_view, N-GtkTreePath $path, int32 $pos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_drag_dest_row:
=begin pod
=head2 [[gtk_] tree_view_] get_drag_dest_row

Gets information about the row that is highlighted for feedback.

  method gtk_tree_view_get_drag_dest_row ( N-GtkTreePath $path, GtkTreeViewDropPosition $pos )

=item N-GtkTreePath $path; (out) (optional) (nullable): Return location for the path of the highlighted row, or C<Any>.
=item GtkTreeViewDropPosition $pos; (out) (optional): Return location for the drop position, or C<Any>

=end pod

sub gtk_tree_view_get_drag_dest_row ( N-GObject $tree_view, N-GtkTreePath $path, int32 $pos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_dest_row_at_pos:
=begin pod
=head2 [[gtk_] tree_view_] get_dest_row_at_pos

Determines the destination row for a given position.  I<drag_x> and
I<drag_y> are expected to be in widget coordinates.  This function is only
meaningful if I<tree_view> is realized.  Therefore this function will always
return C<0> if I<tree_view> is not realized or does not have a model.

Returns: whether there is a row at the given position, C<1> if this
is indeed the case.

  method gtk_tree_view_get_dest_row_at_pos ( Int $drag_x, Int $drag_y, N-GtkTreePath $path, GtkTreeViewDropPosition $pos --> Int  )

=item Int $drag_x; the position to determine the destination row for
=item Int $drag_y; the position to determine the destination row for
=item N-GtkTreePath $path; (out) (optional) (nullable): Return location for the path of the highlighted row, or C<Any>.
=item GtkTreeViewDropPosition $pos; (out) (optional): Return location for the drop position, or C<Any>

=end pod

sub gtk_tree_view_get_dest_row_at_pos ( N-GObject $tree_view, int32 $drag_x, int32 $drag_y, N-GtkTreePath $path, int32 $pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_create_row_drag_icon:
=begin pod
=head2 [[gtk_] tree_view_] create_row_drag_icon

Creates a B<cairo_surface_t> representation of the row at I<path>.
This image is used for a drag icon.

Returns: (transfer full): a newly-allocated surface of the drag icon.

  method gtk_tree_view_create_row_drag_icon ( N-GtkTreePath $path --> cairo_surface_t  )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath> in I<tree_view>

=end pod

sub gtk_tree_view_create_row_drag_icon ( N-GObject $tree_view, N-GtkTreePath $path )
  returns cairo_surface_t
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_enable_search:
=begin pod
=head2 [[gtk_] tree_view_] set_enable_search

If I<enable_search> is set, then the user can type in text to search through
the tree interactively (this is sometimes called "typeahead find").

Note that even if this is C<0>, the user can still initiate a search
using the “start-interactive-search” key binding.

  method gtk_tree_view_set_enable_search ( Int $enable_search )

=item Int $enable_search; C<1>, if the user can search interactively

=end pod

sub gtk_tree_view_set_enable_search ( N-GObject $tree_view, int32 $enable_search )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_enable_search:
=begin pod
=head2 [[gtk_] tree_view_] get_enable_search

Returns whether or not the tree allows to start interactive searching
by typing in text.

Returns: whether or not to let the user search interactively

  method gtk_tree_view_get_enable_search ( --> Int  )


=end pod

sub gtk_tree_view_get_enable_search ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_search_column:
=begin pod
=head2 [[gtk_] tree_view_] get_search_column

Gets the column searched on by the interactive search code.

Returns: the column the interactive search code searches in.

  method gtk_tree_view_get_search_column ( --> Int  )


=end pod

sub gtk_tree_view_get_search_column ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_search_column:
=begin pod
=head2 [[gtk_] tree_view_] set_search_column

Sets I<column> as the column where the interactive search code should
search in for the current model.

If the search column is set, users can use the “start-interactive-search”
key binding to bring up search popup. The enable-search property controls
whether simply typing text will also start an interactive search.

Note that I<column> refers to a column of the current model. The search
column is reset to -1 when the model is changed.

  method gtk_tree_view_set_search_column ( Int $column )

=item Int $column; the column of the model to search in, or -1 to disable searching

=end pod

sub gtk_tree_view_set_search_column ( N-GObject $tree_view, int32 $column )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_search_equal_func:
=begin pod
=head2 [[gtk_] tree_view_] get_search_equal_func

Returns the compare function currently in use.

Returns: the currently used compare function for the search code.

  method gtk_tree_view_get_search_equal_func ( --> GtkTreeViewSearchEqualFunc  )


=end pod

sub gtk_tree_view_get_search_equal_func ( N-GObject $tree_view )
  returns GtkTreeViewSearchEqualFunc
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_search_equal_func:
=begin pod
=head2 [[gtk_] tree_view_] set_search_equal_func

Sets the compare function for the interactive search capabilities; note
that somewhat like C<strcmp()> returning 0 for equality
B<Gnome::Gtk3::TreeViewSearchEqualFunc> returns C<0> on matches.

  method gtk_tree_view_set_search_equal_func ( GtkTreeViewSearchEqualFunc $search_equal_func, Pointer $search_user_data, GDestroyNotify $search_destroy )

=item GtkTreeViewSearchEqualFunc $search_equal_func; the compare function to use during the search
=item Pointer $search_user_data; (allow-none): user data to pass to I<search_equal_func>, or C<Any>
=item GDestroyNotify $search_destroy; (allow-none): Destroy notifier for I<search_user_data>, or C<Any>

=end pod

sub gtk_tree_view_set_search_equal_func ( N-GObject $tree_view, GtkTreeViewSearchEqualFunc $search_equal_func, Pointer $search_user_data, GDestroyNotify $search_destroy )
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_search_entry:
=begin pod
=head2 [[gtk_] tree_view_] get_search_entry

Returns the B<Gnome::Gtk3::Entry> which is currently in use as interactive search
entry for I<tree_view>.  In case the built-in entry is being used, C<Any>
will be returned.

Returns: (transfer none): the entry currently in use as search entry.


  method gtk_tree_view_get_search_entry ( --> N-GObject  )


=end pod

sub gtk_tree_view_get_search_entry ( N-GObject $tree_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_search_entry:
=begin pod
=head2 [[gtk_] tree_view_] set_search_entry

Sets the entry which the interactive search code will use for this
I<tree_view>.  This is useful when you want to provide a search entry
in our interface at all time at a fixed position.  Passing C<Any> for
I<entry> will make the interactive search code use the built-in popup
entry again.


  method gtk_tree_view_set_search_entry ( N-GObject $entry )

=item N-GObject $entry; (allow-none): the entry the interactive search code of I<tree_view> should use or C<Any>

=end pod

sub gtk_tree_view_set_search_entry ( N-GObject $tree_view, N-GObject $entry )
  is native(&gtk-lib)
  { * }
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_search_position_func:
=begin pod
=head2 [[gtk_] tree_view_] get_search_position_func

Returns the positioning function currently in use.

Returns: the currently used function for positioning the search dialog.


  method gtk_tree_view_get_search_position_func ( --> GtkTreeViewSearchPositionFunc  )


=end pod

sub gtk_tree_view_get_search_position_func ( N-GObject $tree_view )
  returns GtkTreeViewSearchPositionFunc
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_search_position_func:
=begin pod
=head2 [[gtk_] tree_view_] set_search_position_func

Sets the function to use when positioning the search dialog.


  method gtk_tree_view_set_search_position_func ( GtkTreeViewSearchPositionFunc $func, Pointer $data, GDestroyNotify $destroy )

=item GtkTreeViewSearchPositionFunc $func; (allow-none): the function to use to position the search dialog, or C<Any> to use the default search position function
=item Pointer $data; (allow-none): user data to pass to I<func>, or C<Any>
=item GDestroyNotify $destroy; (allow-none): Destroy notifier for I<data>, or C<Any>

=end pod

sub gtk_tree_view_set_search_position_func ( N-GObject $tree_view, GtkTreeViewSearchPositionFunc $func, Pointer $data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_widget_to_tree_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_widget_to_tree_coords

Converts widget coordinates to coordinates for the
tree (the full scrollable area of the tree).


  method gtk_tree_view_convert_widget_to_tree_coords ( Int $wx, Int $wy, Int $tx, Int $ty )

=item Int $wx; X coordinate relative to the widget
=item Int $wy; Y coordinate relative to the widget
=item Int $tx; (out): return location for tree X coordinate
=item Int $ty; (out): return location for tree Y coordinate

=end pod

sub gtk_tree_view_convert_widget_to_tree_coords ( N-GObject $tree_view, int32 $wx, int32 $wy, int32 $tx, int32 $ty )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_tree_to_widget_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_tree_to_widget_coords

Converts tree coordinates (coordinates in full scrollable area of the tree)
to widget coordinates.


  method gtk_tree_view_convert_tree_to_widget_coords ( Int $tx, Int $ty, Int $wx, Int $wy )

=item Int $tx; X coordinate relative to the tree
=item Int $ty; Y coordinate relative to the tree
=item Int $wx; (out): return location for widget X coordinate
=item Int $wy; (out): return location for widget Y coordinate

=end pod

sub gtk_tree_view_convert_tree_to_widget_coords ( N-GObject $tree_view, int32 $tx, int32 $ty, int32 $wx, int32 $wy )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_widget_to_bin_window_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_widget_to_bin_window_coords

Converts widget coordinates to coordinates for the bin_window
(see C<gtk_tree_view_get_bin_window()>).


  method gtk_tree_view_convert_widget_to_bin_window_coords ( Int $wx, Int $wy, Int $bx, Int $by )

=item Int $wx; X coordinate relative to the widget
=item Int $wy; Y coordinate relative to the widget
=item Int $bx; (out): return location for bin_window X coordinate
=item Int $by; (out): return location for bin_window Y coordinate

=end pod

sub gtk_tree_view_convert_widget_to_bin_window_coords ( N-GObject $tree_view, int32 $wx, int32 $wy, int32 $bx, int32 $by )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_bin_window_to_widget_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_bin_window_to_widget_coords

Converts bin_window coordinates (see C<gtk_tree_view_get_bin_window()>)
to widget relative coordinates.


  method gtk_tree_view_convert_bin_window_to_widget_coords ( Int $bx, Int $by, Int $wx, Int $wy )

=item Int $bx; bin_window X coordinate
=item Int $by; bin_window Y coordinate
=item Int $wx; (out): return location for widget X coordinate
=item Int $wy; (out): return location for widget Y coordinate

=end pod

sub gtk_tree_view_convert_bin_window_to_widget_coords ( N-GObject $tree_view, int32 $bx, int32 $by, int32 $wx, int32 $wy )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_tree_to_bin_window_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_tree_to_bin_window_coords

Converts tree coordinates (coordinates in full scrollable area of the tree)
to bin_window coordinates.


  method gtk_tree_view_convert_tree_to_bin_window_coords ( Int $tx, Int $ty, Int $bx, Int $by )

=item Int $tx; tree X coordinate
=item Int $ty; tree Y coordinate
=item Int $bx; (out): return location for X coordinate relative to bin_window
=item Int $by; (out): return location for Y coordinate relative to bin_window

=end pod

sub gtk_tree_view_convert_tree_to_bin_window_coords ( N-GObject $tree_view, int32 $tx, int32 $ty, int32 $bx, int32 $by )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_convert_bin_window_to_tree_coords:
=begin pod
=head2 [[gtk_] tree_view_] convert_bin_window_to_tree_coords

Converts bin_window coordinates to coordinates for the
tree (the full scrollable area of the tree).


  method gtk_tree_view_convert_bin_window_to_tree_coords ( Int $bx, Int $by, Int $tx, Int $ty )

=item Int $bx; X coordinate relative to bin_window
=item Int $by; Y coordinate relative to bin_window
=item Int $tx; (out): return location for tree X coordinate
=item Int $ty; (out): return location for tree Y coordinate

=end pod

sub gtk_tree_view_convert_bin_window_to_tree_coords ( N-GObject $tree_view, int32 $bx, int32 $by, int32 $tx, int32 $ty )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_fixed_height_mode:
=begin pod
=head2 [[gtk_] tree_view_] set_fixed_height_mode

Enables or disables the fixed height mode of I<tree_view>.
Fixed height mode speeds up B<Gnome::Gtk3::TreeView> by assuming that all
rows have the same height.
Only enable this option if all rows are the same height and all
columns are of type C<GTK_TREE_VIEW_COLUMN_FIXED>.


  method gtk_tree_view_set_fixed_height_mode ( Int $enable )

=item Int $enable; C<1> to enable fixed height mode

=end pod

sub gtk_tree_view_set_fixed_height_mode ( N-GObject $tree_view, int32 $enable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_fixed_height_mode:
=begin pod
=head2 [[gtk_] tree_view_] get_fixed_height_mode

Returns whether fixed height mode is turned on for I<tree_view>.

Returns: C<1> if I<tree_view> is in fixed height mode


  method gtk_tree_view_get_fixed_height_mode ( --> Int  )


=end pod

sub gtk_tree_view_get_fixed_height_mode ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_hover_selection:
=begin pod
=head2 [[gtk_] tree_view_] set_hover_selection

Enables or disables the hover selection mode of I<tree_view>.
Hover selection makes the selected row follow the pointer.
Currently, this works only for the selection modes
C<GTK_SELECTION_SINGLE> and C<GTK_SELECTION_BROWSE>.


  method gtk_tree_view_set_hover_selection ( Int $hover )

=item Int $hover; C<1> to enable hover selection mode

=end pod

sub gtk_tree_view_set_hover_selection ( N-GObject $tree_view, int32 $hover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_hover_selection:
=begin pod
=head2 [[gtk_] tree_view_] get_hover_selection

Returns whether hover selection mode is turned on for I<tree_view>.

Returns: C<1> if I<tree_view> is in hover selection mode


  method gtk_tree_view_get_hover_selection ( --> Int  )


=end pod

sub gtk_tree_view_get_hover_selection ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_hover_expand:
=begin pod
=head2 [[gtk_] tree_view_] set_hover_expand

Enables or disables the hover expansion mode of I<tree_view>.
Hover expansion makes rows expand or collapse if the pointer
moves over them.


  method gtk_tree_view_set_hover_expand ( Int $expand )

=item Int $expand; C<1> to enable hover selection mode

=end pod

sub gtk_tree_view_set_hover_expand ( N-GObject $tree_view, int32 $expand )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_hover_expand:
=begin pod
=head2 [[gtk_] tree_view_] get_hover_expand

Returns whether hover expansion mode is turned on for I<tree_view>.

Returns: C<1> if I<tree_view> is in hover expansion mode


  method gtk_tree_view_get_hover_expand ( --> Int  )


=end pod

sub gtk_tree_view_get_hover_expand ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_rubber_banding:
=begin pod
=head2 [[gtk_] tree_view_] set_rubber_banding

Enables or disables rubber banding in I<tree_view>.  If the selection mode
is B<GTK_SELECTION_MULTIPLE>, rubber banding will allow the user to select
multiple rows by dragging the mouse.


  method gtk_tree_view_set_rubber_banding ( Int $enable )

=item Int $enable; C<1> to enable rubber banding

=end pod

sub gtk_tree_view_set_rubber_banding ( N-GObject $tree_view, int32 $enable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_rubber_banding:
=begin pod
=head2 [[gtk_] tree_view_] get_rubber_banding

Returns whether rubber banding is turned on for I<tree_view>.  If the
selection mode is B<GTK_SELECTION_MULTIPLE>, rubber banding will allow the
user to select multiple rows by dragging the mouse.

Returns: C<1> if rubber banding in I<tree_view> is enabled.


  method gtk_tree_view_get_rubber_banding ( --> Int  )


=end pod

sub gtk_tree_view_get_rubber_banding ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_is_rubber_banding_active:
=begin pod
=head2 [[gtk_] tree_view_] is_rubber_banding_active

Returns whether a rubber banding operation is currently being done
in I<tree_view>.

Returns: C<1> if a rubber banding operation is currently being
done in I<tree_view>.


  method gtk_tree_view_is_rubber_banding_active ( --> Int  )


=end pod

sub gtk_tree_view_is_rubber_banding_active ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_row_separator_func:
=begin pod
=head2 [[gtk_] tree_view_] get_row_separator_func

Returns the current row separator function.

Returns: the current row separator function.


  method gtk_tree_view_get_row_separator_func ( --> GtkTreeViewRowSeparatorFunc  )


=end pod

sub gtk_tree_view_get_row_separator_func ( N-GObject $tree_view )
  returns GtkTreeViewRowSeparatorFunc
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_row_separator_func:
=begin pod
=head2 [[gtk_] tree_view_] set_row_separator_func

Sets the row separator function, which is used to determine
whether a row should be drawn as a separator. If the row separator
function is C<Any>, no separators are drawn. This is the default value.


  method gtk_tree_view_set_row_separator_func ( GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )

=item GtkTreeViewRowSeparatorFunc $func; (allow-none): a B<Gnome::Gtk3::TreeViewRowSeparatorFunc>
=item Pointer $data; (allow-none): user data to pass to I<func>, or C<Any>
=item GDestroyNotify $destroy; (allow-none): destroy notifier for I<data>, or C<Any>

=end pod

sub gtk_tree_view_set_row_separator_func ( N-GObject $tree_view, GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_grid_lines:
=begin pod
=head2 [[gtk_] tree_view_] get_grid_lines

Returns which grid lines are enabled in I<tree_view>.

Returns: a B<Gnome::Gtk3::TreeViewGridLines> value indicating which grid lines
are enabled.


  method gtk_tree_view_get_grid_lines ( --> GtkTreeViewGridLines  )


=end pod

sub gtk_tree_view_get_grid_lines ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_grid_lines:
=begin pod
=head2 [[gtk_] tree_view_] set_grid_lines

Sets which grid lines to draw in I<tree_view>.


  method gtk_tree_view_set_grid_lines ( GtkTreeViewGridLines $grid_lines )

=item GtkTreeViewGridLines $grid_lines; a B<Gnome::Gtk3::TreeViewGridLines> value indicating which grid lines to enable.

=end pod

sub gtk_tree_view_set_grid_lines ( N-GObject $tree_view, int32 $grid_lines )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_enable_tree_lines:
=begin pod
=head2 [[gtk_] tree_view_] get_enable_tree_lines

Returns whether or not tree lines are drawn in I<tree_view>.

Returns: C<1> if tree lines are drawn in I<tree_view>, C<0>
otherwise.


  method gtk_tree_view_get_enable_tree_lines ( --> Int  )


=end pod

sub gtk_tree_view_get_enable_tree_lines ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_enable_tree_lines:
=begin pod
=head2 [[gtk_] tree_view_] set_enable_tree_lines

Sets whether to draw lines interconnecting the expanders in I<tree_view>.
This does not have any visible effects for lists.


  method gtk_tree_view_set_enable_tree_lines ( Int $enabled )

=item Int $enabled; C<1> to enable tree line drawing, C<0> otherwise.

=end pod

sub gtk_tree_view_set_enable_tree_lines ( N-GObject $tree_view, int32 $enabled )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_show_expanders:
=begin pod
=head2 [[gtk_] tree_view_] set_show_expanders

Sets whether to draw and enable expanders and indent child rows in
I<tree_view>.  When disabled there will be no expanders visible in trees
and there will be no way to expand and collapse rows by default.  Also
note that hiding the expanders will disable the default indentation.  You
can set a custom indentation in this case using
C<gtk_tree_view_set_level_indentation()>.
This does not have any visible effects for lists.


  method gtk_tree_view_set_show_expanders ( Int $enabled )

=item Int $enabled; C<1> to enable expander drawing, C<0> otherwise.

=end pod

sub gtk_tree_view_set_show_expanders ( N-GObject $tree_view, int32 $enabled )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_show_expanders:
=begin pod
=head2 [[gtk_] tree_view_] get_show_expanders

Returns whether or not expanders are drawn in I<tree_view>.

Returns: C<1> if expanders are drawn in I<tree_view>, C<0>
otherwise.


  method gtk_tree_view_get_show_expanders ( --> Int  )


=end pod

sub gtk_tree_view_get_show_expanders ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_level_indentation:
=begin pod
=head2 [[gtk_] tree_view_] set_level_indentation

Sets the amount of extra indentation for child levels to use in I<tree_view>
in addition to the default indentation.  The value should be specified in
pixels, a value of 0 disables this feature and in this case only the default
indentation will be used.
This does not have any visible effects for lists.


  method gtk_tree_view_set_level_indentation ( Int $indentation )

=item Int $indentation; the amount, in pixels, of extra indentation in I<tree_view>.

=end pod

sub gtk_tree_view_set_level_indentation ( N-GObject $tree_view, int32 $indentation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_level_indentation:
=begin pod
=head2 [[gtk_] tree_view_] get_level_indentation

Returns the amount, in pixels, of extra indentation for child levels
in I<tree_view>.

Returns: the amount of extra indentation for child levels in
I<tree_view>.  A return value of 0 means that this feature is disabled.


  method gtk_tree_view_get_level_indentation ( --> Int  )


=end pod

sub gtk_tree_view_get_level_indentation ( N-GObject $tree_view )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_tooltip_row:
=begin pod
=head2 [[gtk_] tree_view_] set_tooltip_row

Sets the tip area of I<tooltip> to be the area covered by the row at I<path>.
See also C<gtk_tree_view_set_tooltip_column()> for a simpler alternative.
See also C<gtk_tooltip_set_tip_area()>.


  method gtk_tree_view_set_tooltip_row ( N-GObject $tooltip, N-GtkTreePath $path )

=item N-GObject $tooltip; a B<Gnome::Gtk3::Tooltip>
=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>

=end pod

sub gtk_tree_view_set_tooltip_row ( N-GObject $tree_view, N-GObject $tooltip, N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_tooltip_cell:
=begin pod
=head2 [[gtk_] tree_view_] set_tooltip_cell

Sets the tip area of I<tooltip> to the area I<path>, I<column> and I<cell> have
in common.  For example if I<path> is C<Any> and I<column> is set, the tip
area will be set to the full area covered by I<column>.  See also
C<gtk_tooltip_set_tip_area()>.

Note that if I<path> is not specified and I<cell> is set and part of a column
containing the expander, the tooltip might not show and hide at the correct
position.  In such cases I<path> must be set to the current node under the
mouse cursor for this function to operate correctly.

See also C<gtk_tree_view_set_tooltip_column()> for a simpler alternative.


  method gtk_tree_view_set_tooltip_cell ( N-GObject $tooltip, N-GtkTreePath $path, N-GObject $column, N-GObject $cell )

=item N-GObject $tooltip; a B<Gnome::Gtk3::Tooltip>
=item N-GtkTreePath $path; (allow-none): a B<Gnome::Gtk3::TreePath> or C<Any>
=item N-GObject $column; (allow-none): a B<Gnome::Gtk3::TreeViewColumn> or C<Any>
=item N-GObject $cell; (allow-none): a B<Gnome::Gtk3::CellRenderer> or C<Any>

=end pod

sub gtk_tree_view_set_tooltip_cell ( N-GObject $tree_view, N-GObject $tooltip, N-GtkTreePath $path, N-GObject $column, N-GObject $cell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_tooltip_context:
=begin pod
=head2 [[gtk_] tree_view_] get_tooltip_context

This function is supposed to be used in a  I<query-tooltip>
signal handler for B<Gnome::Gtk3::TreeView>.  The I<x>, I<y> and I<keyboard_tip> values
which are received in the signal handler, should be passed to this
function without modification.

The return value indicates whether there is a tree view row at the given
coordinates (C<1>) or not (C<0>) for mouse tooltips.  For keyboard
tooltips the row returned will be the cursor row.  When C<1>, then any of
I<model>, I<path> and I<iter> which have been provided will be set to point to
that row and the corresponding model.  I<x> and I<y> will always be converted
to be relative to I<tree_view>’s bin_window if I<keyboard_tooltip> is C<0>.

Returns: whether or not the given tooltip context points to a row.


  method gtk_tree_view_get_tooltip_context ( Int $x, Int $y, Int $keyboard_tip, N-GObject $model, N-GtkTreePath $path, GtkTreeIter $iter --> Int  )

=item Int $x; (inout): the x coordinate (relative to widget coordinates)
=item Int $y; (inout): the y coordinate (relative to widget coordinates)
=item Int $keyboard_tip; whether this is a keyboard tooltip or not
=item N-GObject $model; (out) (optional) (nullable) (transfer none): a pointer to receive a B<Gnome::Gtk3::TreeModel> or C<Any>
=item N-GtkTreePath $path; (out) (optional): a pointer to receive a B<Gnome::Gtk3::TreePath> or C<Any>
=item GtkTreeIter $iter; (out) (optional): a pointer to receive a B<Gnome::Gtk3::TreeIter> or C<Any>

=end pod

sub gtk_tree_view_get_tooltip_context ( N-GObject $tree_view, int32 $x, int32 $y, int32 $keyboard_tip, N-GObject $model, N-GtkTreePath $path, GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_set_tooltip_column:
=begin pod
=head2 [[gtk_] tree_view_] set_tooltip_column

If you only plan to have simple (text-only) tooltips on full rows, you
can use this function to have B<Gnome::Gtk3::TreeView> handle these automatically
for you. I<column> should be set to the column in I<tree_view>’s model
containing the tooltip texts, or -1 to disable this feature.

When enabled,  I<has-tooltip> will be set to C<1> and
I<tree_view> will connect a  I<query-tooltip> signal handler.

Note that the signal handler sets the text with C<gtk_tooltip_set_markup()>,
so &, <, etc have to be escaped in the text.


  method gtk_tree_view_set_tooltip_column ( Int $column )

=item Int $column; an integer, which is a valid column number for I<tree_view>’s model

=end pod

sub gtk_tree_view_set_tooltip_column ( N-GObject $tree_view, int32 $column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_view_get_tooltip_column:
=begin pod
=head2 [[gtk_] tree_view_] get_tooltip_column

Returns the column of I<tree_view>’s model which is being used for
displaying tooltips on I<tree_view>’s rows.

Returns: the index of the tooltip column that is currently being
used, or -1 if this is disabled.


  method gtk_tree_view_get_tooltip_column ( --> Int  )


=end pod

sub gtk_tree_view_get_tooltip_column ( N-GObject $tree_view )
  returns int32
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


=comment #TS:0:row-activated:
=head3 row-activated

The "row-activated" signal is emitted when the method C<gtk_tree_view_row_activated()> is called, when the user double clicks a treeview row with the "activate-on-single-click" property set to C<0>, or when the user single clicks a row when the "activate-on-single-click" property set to C<1>. It is also emitted when a non-editable row is selected and one of the keys: Space, Shift+Space, Return or Enter is pressed.

For selection handling refer to the [tree widget conceptual overview][TreeWidget] as well as B<Gnome::Gtk3::TreeSelection>.

  method handler (
    N-GtkTreePath $path,
    N-GObject $column,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );

=item $tree_view; the object on which the signal is emitted
=item $path; the native B<Gnome::Gtk3::TreePath> for the activated row
=item $column; the native B<Gnome::Gtk3::TreeViewColumn> in which the activation occurred


=comment #TS:0:test-expand-row:
=head3 test-expand-row

The given row is about to be expanded (show its children nodes). Use this
signal if you need to control the expandability of individual rows.

Returns: C<0> to allow expansion, C<1> to reject

  method handler (
    N-GtkTreeIter $iter,
    N-GtkTreePath $path,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
    --> Int
  );

=item $tree_view; the object on which the signal is emitted
=item N-GtkTreeIter $iter; the native B<Gnome::Gtk3::TreeIter> of the row to expand
=item N-GtkTreePath $path; the native B<Gnome::Gtk3::TreePath> that points to the row

=comment #TS:0:test-collapse-row:
=head3 test-collapse-row

The given row is about to be collapsed (hide its children nodes). Use this
signal if you need to control the collapsibility of individual rows.

Returns: C<0> to allow collapsing, C<1> to reject

  method handler (
    N-GtkTreeIter $iter,
    N-GtkTreePath $path,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
    --> Int
  );

=item $tree_view; the object on which the signal is emitted
=item $iter; the tree iter of the row to collapse
=item $path; a tree path that points to the row


=comment #TS:0:row-expanded:
=head3 row-expanded

The given row has been expanded (child nodes are shown).

  method handler (
    N-GtkTreeIter $iter,
    N-GtkTreePath $path,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );

=item $tree_view; the object on which the signal is emitted
=item $iter; the tree iter of the expanded row
=item $path; a tree path that points to the row


=comment #TS:0:row-collapsed:
=head3 row-collapsed

The given row has been collapsed (child nodes are hidden).

  method handler (
    N-GtkTreeIter $iter,
    N-GtkTreePath $path,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );

=item $tree_view; the object on which the signal is emitted
=item $iter; the tree iter of the collapsed row
=item $path; a tree path that points to the row


=comment #TS:0:columns-changed:
=head3 columns-changed

The number of columns of the treeview has changed.

  method handler (
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );

=item $tree_view; the object on which the signal is emitted


=comment #TS:0:cursor-changed:
=head3 cursor-changed

The position of the cursor (focused cell) has changed.

  method handler (
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );

=item $tree_view; the object on which the signal is emitted

=begin comment
=comment #TS:0:move-cursor:
=head3 move-cursor

The  I<move-cursor> signal is a [keybinding
signal][B<Gnome::Gtk3::BindingSignal>] which gets emitted when the user
presses one of the cursor keys.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically. In contrast to C<gtk_tree_view_set_cursor()> and
C<gtk_tree_view_set_cursor_on_cell()> when moving horizontally
 I<move-cursor> does not reset the current selection.

Returns: C<1> if I<step> is supported, C<0> otherwise.

  method handler (
    Unknown type GTK_TYPE_MOVEMENT_STEP $step,
    Int $direction,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
    --> Int
  );

=item $tree_view; the object on which the signal is emitted.

=item $step; the granularity of the move, as a

=item $direction; the direction to move: +1 to move forwards;
=end comment

=begin comment
=comment #TS:0:select-all:
=head3 select-all

  method handler (
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;

=comment #TS:0:unselect-all:
=head3 unselect-all

  method handler (
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;

=comment #TS:0:select-cursor-row:
=head3 select-cursor-row

  method handler (
    Int $int,
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;
=item $int;

=comment #TS:0:toggle-cursor-row:
=head3 toggle-cursor-row

  method handler (
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;

=comment #TS:0:expand-collapse-cursor-row:
=head3 expand-collapse-cursor-row

  method handler (
    Int $int,
    Int $int,
    Int $int,
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;
=item $int;
=item $int;
=item $int;

=comment #TS:0:select-cursor-parent:
=head3 select-cursor-parent

  method handler (
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;

=comment #TS:0:start-interactive-search:
=head3 start-interactive-search

  method handler (
    Gnome::GObject::Object :widget($treeview),
    *%user-options
    --> Int
  );

=item $treeview;
=end comment

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

=comment #TP:0:model:
=head3 TreeView Model

The model for the tree view
Widget type: GTK_TYPE_TREE_MODEL


The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

=comment #TP:0:headers-visible:
=head3 Headers Visible

Show the column header buttons
Default value: True


The B<Gnome::GObject::Value> type of property I<headers-visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:headers-clickable:
=head3 Headers Clickable

Column headers respond to click events
Default value: True


The B<Gnome::GObject::Value> type of property I<headers-clickable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:expander-column:
=head3 Expander Column

Set the column for the expander column
Widget type: GTK_TYPE_TREE_VIEW_COLUMN


The B<Gnome::GObject::Value> type of property I<expander-column> is C<G_TYPE_OBJECT>.

=comment #TP:0:reorderable:
=head3 Reorderable

View is reorderable
Default value: False


The B<Gnome::GObject::Value> type of property I<reorderable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:enable-search:
=head3 Enable Search

View allows user to search through columns interactively
Default value: True


The B<Gnome::GObject::Value> type of property I<enable-search> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:search-column:
=head3 Search Column



The B<Gnome::GObject::Value> type of property I<search-column> is C<G_TYPE_INT>.

=comment #TP:0:fixed-height-mode:
=head3 Fixed Height Mode


Setting the I<fixed-height-mode> property to C<1> speeds up
B<Gnome::Gtk3::TreeView> by assuming that all rows have the same height.
Only enable this option if all rows are the same height.
Please see C<gtk_tree_view_set_fixed_height_mode()> for more
information on this option.

The B<Gnome::GObject::Value> type of property I<fixed-height-mode> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:hover-selection:
=head3 Hover Selection


Enables or disables the hover selection mode of I<tree_view>.
Hover selection makes the selected row follow the pointer.
Currently, this works only for the selection modes
C<GTK_SELECTION_SINGLE> and C<GTK_SELECTION_BROWSE>.
This mode is primarily intended for treeviews in popups, e.g.
in B<Gnome::Gtk3::ComboBox> or B<Gnome::Gtk3::EntryCompletion>.

The B<Gnome::GObject::Value> type of property I<hover-selection> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:hover-expand:
=head3 Hover Expand


Enables or disables the hover expansion mode of I<tree_view>.
Hover expansion makes rows expand or collapse if the pointer moves
over them.
This mode is primarily intended for treeviews in popups, e.g.
in B<Gnome::Gtk3::ComboBox> or B<Gnome::Gtk3::EntryCompletion>.

The B<Gnome::GObject::Value> type of property I<hover-expand> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:show-expanders:
=head3 Show Expanders


C<1> if the view has expanders.

The B<Gnome::GObject::Value> type of property I<show-expanders> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:level-indentation:
=head3 Level Indentation


Extra indentation for each level.

The B<Gnome::GObject::Value> type of property I<level-indentation> is C<G_TYPE_INT>.

=comment #TP:0:rubber-banding:
=head3 Rubber Banding

Whether to enable selection of multiple items by dragging the mouse pointer
Default value: False


The B<Gnome::GObject::Value> type of property I<rubber-banding> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:enable-grid-lines:
=head3 Enable Grid Lines

Whether grid lines should be drawn in the tree view
Default value: False


The B<Gnome::GObject::Value> type of property I<enable-grid-lines> is C<G_TYPE_ENUM>.

=comment #TP:0:enable-tree-lines:
=head3 Enable Tree Lines

Whether tree lines should be drawn in the tree view
Default value: False


The B<Gnome::GObject::Value> type of property I<enable-tree-lines> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:tooltip-column:
=head3 Tooltip Column



The B<Gnome::GObject::Value> type of property I<tooltip-column> is C<G_TYPE_INT>.

=comment #TP:0:activate-on-single-click:
=head3 Activate on Single Click

The activate-on-single-click property specifies whether the "row-activated" signal will be emitted after a single click.

The B<Gnome::GObject::Value> type of property I<activate-on-single-click> is C<G_TYPE_BOOLEAN>.
=end pod
