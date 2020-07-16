#TL:1:Gnome::Gtk3::TreeSelection:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeSelection

The selection object for B<Gnome::Gtk3::TreeView>

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::TreeSelection> object is a helper object to manage the selection for a B<Gnome::Gtk3::TreeView> widget. The B<Gnome::Gtk3::TreeSelection> object is automatically created when a new B<Gnome::Gtk3::TreeView> widget is created, and cannot exist independently of this widget. The primary reason the B<Gnome::Gtk3::TreeSelection> objects exists is for cleanliness of code and API. That is, there is no conceptual reason all these functions could not be methods on the B<Gnome::Gtk3::TreeView> widget instead of a separate function.

The B<Gnome::Gtk3::TreeSelection> object is gotten from a B<Gnome::Gtk3::TreeView> by calling C<gtk_tree_view_get_selection()>.  It can be manipulated to check the selection status of the tree, as well as select and deselect individual rows.  Selection is done completely view side.  As a result, multiple views of the same model can have completely different selections. Additionally, you cannot change the selection of a row on the model that is not currently displayed by the view without expanding its parents first.

One of the important things to remember when monitoring the selection of a view is that the  I<changed> signal is mostly a hint. That is, it may only emit one signal when a range of rows is selected. Additionally, it may on occasion emit a  I<changed> signal when nothing has happened (mostly as a result of programmers calling select_row on an already selected row).

=begin comment
=head2 See Also

B<Gnome::Gtk3::TreeView>, B<Gnome::Gtk3::TreeViewColumn>, B<Gnome::Gtk3::TreeModel>,
  B<Gnome::Gtk3::TreeSortable>, B<Gnome::Gtk3::TreeModelSort>, B<Gnome::Gtk3::ListStore>, B<Gnome::Gtk3::TreeStore>,
  B<Gnome::Gtk3::CellRenderer>, B<Gnome::Gtk3::CellEditable>, B<Gnome::Gtk3::CellRendererPixbuf>,
  B<Gnome::Gtk3::CellRendererText>, B<Gnome::Gtk3::CellRendererToggle>, [B<Gnome::Gtk3::TreeView> drag-and-drop][gtk3-B<Gnome::Gtk3::TreeView>-drag-and-drop]
=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeSelection;
  also is Gnome::GObject::Object;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::TreeSelection;

  unit class MyGuiClass;
  also is Gnome::Gtk3::TreeSelection;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::TreeSelection class process the options
    self.bless( :GtkTreeSelection, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Glib::List;
use Gnome::GObject::Object;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreePath;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TreeSelection:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new TreeSelection object. The argument must be a valid B<Gnome::Gtk3::TreeView> from which the current selection is asked and stored here.

  multi method new ( :$treeview! )

Create a TreeSelection object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:0:new(:treeview):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TreeSelection' #`{{ or %options<GtkTreeSelection> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

#    # check if common options are handled by some parent
#    elsif %options<native-object>:exists or %options<widget>:exists { }
#    elsif %options<build-id>:exists { }

    elsif ? %options<treeview> and
            %options<treeview>.^name eq 'Gnome::Gtk3::TreeView' {

      self.set-native-object(%options<treeview>.gtk_tree_view_get_selection());
    }

    # check if there are unknown options
    elsif %options.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }

    ##`{{ when there are no defaults use this
    # check if there are any options
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }
    #}}

    #`{{ when there are defaults use this instead
    # create default object
    else {
      self.set-native-object(gtk_tree_selection_new());
    }
    }}

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkTreeSelection');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_selection_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkTreeSelection');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_set_mode:
=begin pod
=head2 [gtk_tree_selection_] set_mode

Sets the selection mode of the I<selection>.  If the previous type was
B<GTK_SELECTION_MULTIPLE>, then the anchor is kept selected, if it was
previously selected.

  method gtk_tree_selection_set_mode ( GtkSelectionMode $type )

=item GtkSelectionMode $type; The selection mode

=end pod

sub gtk_tree_selection_set_mode ( N-GObject $selection, int32 $type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_get_mode:
=begin pod
=head2 [gtk_tree_selection_] get_mode

Gets the selection mode for I<selection>. See
C<gtk_tree_selection_set_mode()>.

Returns: the current selection mode

  method gtk_tree_selection_get_mode ( --> GtkSelectionMode )


=end pod

sub gtk_tree_selection_get_mode ( N-GObject $selection --> int32 )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_set_select_function:
=begin pod
=head2 [gtk_tree_selection_] set_select_function

Sets the selection function.

If set, this function is called before any node is selected or unselected,
giving some control over which nodes are selected. The select function
should return C<1> if the state of the node may be toggled, and C<0>
if the state of the node should be left unchanged.

  method gtk_tree_selection_set_select_function ( GtkTreeSelectionFunc $func, Pointer $data, GDestroyNotify $destroy )

=item GtkTreeSelectionFunc $func; (nullable): The selection function. May be C<Any>
=item Pointer $data; The selection function’s data. May be C<Any>
=item GDestroyNotify $destroy; The destroy function for user data.  May be C<Any>

=end pod

sub gtk_tree_selection_set_select_function ( N-GObject $selection, GtkTreeSelectionFunc $func, Pointer $data, GDestroyNotify $destroy  )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_selection_get_user_data:
=begin pod
=head2 [gtk_tree_selection_] get_user_data

Returns the user data for the selection function.

Returns: The user data.

  method gtk_tree_selection_get_user_data ( --> Pointer )


=end pod

sub gtk_tree_selection_get_user_data ( N-GObject $selection --> Pointer )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_get_tree_view:
=begin pod
=head2 [gtk_tree_selection_] get_tree_view

Returns the tree view associated with I<selection>.

Returns: (transfer none): A B<Gnome::Gtk3::TreeView>

  method gtk_tree_selection_get_tree_view ( --> N-GObject )


=end pod

sub gtk_tree_selection_get_tree_view ( N-GObject $selection --> N-GObject )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_get_select_function:
=begin pod
=head2 [gtk_tree_selection_] get_select_function

Returns the current selection function.

Returns: The function.


  method gtk_tree_selection_get_select_function ( --> GtkTreeSelectionFunc )


=end pod

sub gtk_tree_selection_get_select_function ( N-GObject $selection --> GtkTreeSelectionFunc )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_get_selected:
=begin pod
=head2 [gtk_tree_selection_] get_selected

Sets I<$iter> to the currently selected node if I<selection> is set to B<GTK_SELECTION_SINGLE> or B<GTK_SELECTION_BROWSE>. I<$iter> may be NULL if you just want to test if I<selection> has any selected nodes.  I<model> is filled with the current model as a convenience.  This function will not work if you use I<selection> is B<GTK_SELECTION_MULTIPLE>.

Returns: 1, if there is a selected node.

  method gtk_tree_selection_get_selected (
    N-GObject $model, N-GtkTreeIter $iter --> Int
  )

  =item N-GObject $model; A pointer to set to the B<Gnome::Gtk3::TreeModel>, or undefined.
  =item N-GtkTreeIter $iter; The B<Gnome::Gtk3::TreeIter>, or undefined.

  method gtk_tree_selection_get_selected ( --> List )

  The list will return the status, model and iter. If status is 1, then there is a selected node.

=end pod

sub gtk_tree_selection_get_selected ( N-GObject $selection --> List ) {
  my N-GtkTreeIter $n-ti;
  my N-GObject $n-mdl;
  my Int $sts = _gtk_tree_selection_get_selected(
    $selection, $n-mdl, $n-ti
  );

  ( $sts, $n-ti, $n-mdl)
}

sub _gtk_tree_selection_get_selected (
  N-GObject $selection, N-GObject $model is rw, N-GtkTreeIter $iter is rw
  --> int32
) is native(&gtk-lib)
  is symbol('gtk_tree_selection_get_selected')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_get_selected_rows:
=begin pod
=head2 [gtk_tree_selection_] get_selected_rows

Creates a list of path of all selected rows. Additionally, if you are planning on modifying the model after calling this function, you may want to convert the returned list into a list of B<Gnome::Gtk3::TreeRowReferences>. To do this, you can use C<gtk_tree_row_reference_new()>.

=begin comment
To free the return value, use:
|[<!-- language="C" -->
g_list_free_full (list, (GDestroyNotify) gtk_tree_path_free);
]|
=end comment

Returns: (element-type B<Gnome::Gtk3::TreePath>) (transfer full): A B<GList> containing a B<Gnome::Gtk3::TreePath> for each selected row.


  method gtk_tree_selection_get_selected_rows ( N-GObject $model --> N-GList )

=item N-GObject $model; A pointer to set to the B<Gnome::Gtk3::TreeModel>, or C<Any>.

=end pod

sub gtk_tree_selection_get_selected_rows (
  N-GObject $selection, N-GObject $model
  --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_count_selected_rows:
=begin pod
=head2 [gtk_tree_selection_] count_selected_rows

Returns the number of rows that have been selected in I<tree>.

Returns: The number of rows selected.


  method gtk_tree_selection_count_selected_rows ( --> Int )


=end pod

sub gtk_tree_selection_count_selected_rows ( N-GObject $selection --> int32 )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_selected_foreach:
=begin pod
=head2 [gtk_tree_selection_] selected_foreach

Calls a function for each selected node. Note that you cannot modify
the tree or selection from within this function. As a result,
C<gtk_tree_selection_get_selected_rows()> might be more useful.

  method gtk_tree_selection_selected_foreach ( GtkTreeSelectionForeachFunc $func, Pointer $data )

=item GtkTreeSelectionForeachFunc $func; (scope call): The function to call for each selected node.
=item Pointer $data; user data to pass to the function.

=end pod

sub gtk_tree_selection_selected_foreach ( N-GObject $selection, GtkTreeSelectionForeachFunc $func, Pointer $data  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_select_path:
=begin pod
=head2 [gtk_tree_selection_] select_path

Select the row at I<path>.

  method gtk_tree_selection_select_path ( N-GtkTreePath $path )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be selected.

=end pod

sub gtk_tree_selection_select_path ( N-GObject $selection, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_unselect_path:
=begin pod
=head2 [gtk_tree_selection_] unselect_path

Unselects the row at I<path>.

  method gtk_tree_selection_unselect_path ( N-GtkTreePath $path )

=item N-GtkTreePath $path; The B<Gnome::Gtk3::TreePath> to be unselected.

=end pod

sub gtk_tree_selection_unselect_path ( N-GObject $selection, N-GtkTreePath $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_select_iter:
=begin pod
=head2 [gtk_tree_selection_] select_iter

Selects the specified iterator.

  method gtk_tree_selection_select_iter ( N-GtkTreeIter $iter )

=item N-GtkTreeIter $iter; The B<Gnome::Gtk3::TreeIter> to be selected.

=end pod

sub gtk_tree_selection_select_iter ( N-GObject $selection, N-GtkTreeIter $iter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_unselect_iter:
=begin pod
=head2 [gtk_tree_selection_] unselect_iter

Unselects the specified iterator.

  method gtk_tree_selection_unselect_iter ( N-GtkTreeIter $iter )

=item N-GtkTreeIter $iter; The B<Gnome::Gtk3::TreeIter> to be unselected.

=end pod

sub gtk_tree_selection_unselect_iter ( N-GObject $selection, N-GtkTreeIter $iter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_path_is_selected:
=begin pod
=head2 [gtk_tree_selection_] path_is_selected

Returns C<1> if the row pointed to by I<path> is currently selected.  If I<path>
does not point to a valid location, C<0> is returned

Returns: C<1> if I<path> is selected.

  method gtk_tree_selection_path_is_selected ( N-GtkTreePath $path --> Int )

=item N-GtkTreePath $path; A B<Gnome::Gtk3::TreePath> to check selection on.

=end pod

sub gtk_tree_selection_path_is_selected ( N-GObject $selection, N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_iter_is_selected:
=begin pod
=head2 [gtk_tree_selection_] iter_is_selected

Returns C<1> if the row at I<iter> is currently selected.

Returns: C<1>, if I<iter> is selected

  method gtk_tree_selection_iter_is_selected ( N-GtkTreeIter $iter --> Int )

=item N-GtkTreeIter $iter; A valid B<Gnome::Gtk3::TreeIter>

=end pod

sub gtk_tree_selection_iter_is_selected ( N-GObject $selection, N-GtkTreeIter $iter --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_select_all:
=begin pod
=head2 [gtk_tree_selection_] select_all

Selects all the nodes. I<selection> must be set to B<GTK_SELECTION_MULTIPLE>
mode.

  method gtk_tree_selection_select_all ( )


=end pod

sub gtk_tree_selection_select_all ( N-GObject $selection  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_unselect_all:
=begin pod
=head2 [gtk_tree_selection_] unselect_all

Unselects all the nodes.

  method gtk_tree_selection_unselect_all ( )


=end pod

sub gtk_tree_selection_unselect_all ( N-GObject $selection  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_select_range:
=begin pod
=head2 [gtk_tree_selection_] select_range

Selects a range of nodes, determined by I<start_path> and I<end_path> inclusive.
I<selection> must be set to B<GTK_SELECTION_MULTIPLE> mode.

  method gtk_tree_selection_select_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path )

=item N-GtkTreePath $start_path; The initial node of the range.
=item N-GtkTreePath $end_path; The final node of the range.

=end pod

sub gtk_tree_selection_select_range ( N-GObject $selection, N-GtkTreePath $start_path, N-GtkTreePath $end_path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_selection_unselect_range:
=begin pod
=head2 [gtk_tree_selection_] unselect_range

Unselects a range of nodes, determined by I<start_path> and I<end_path>
inclusive.


  method gtk_tree_selection_unselect_range ( N-GtkTreePath $start_path, N-GtkTreePath $end_path )

=item N-GtkTreePath $start_path; The initial node of the range.
=item N-GtkTreePath $end_path; The initial node of the range.

=end pod

sub gtk_tree_selection_unselect_range ( N-GObject $selection, N-GtkTreePath $start_path, N-GtkTreePath $end_path  )
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


=comment #TS:0:changed:
=head3 changed

Emitted whenever the selection has (possibly) changed. Please note that
this signal is mostly a hint.  It may only be emitted once when a range
of rows are selected, and it may occasionally be emitted when nothing
has happened.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($treeselection),
    *%user-options
  );

=item $treeselection; the object which received the signal.


=end pod
