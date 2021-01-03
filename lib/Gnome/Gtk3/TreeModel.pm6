#TL:1:Gnome::Gtk3::TreeModel:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeModel

The tree interface used by B<Gnome::Gtk3::TreeView>

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::TreeModel> interface defines a generic tree interface for use by the B<Gnome::Gtk3::TreeView> widget. It is an abstract interface, and is designed to be usable with any appropriate data structure.

=begin comment
The
programmer just has to implement this interface on their own data
type for it to be viewable by a B<Gnome::Gtk3::TreeView> widget.
=end comment

The model is represented as a hierarchical tree of strongly-typed, columned data. In other words, the model can be seen as a tree where every node has different values depending on which column is being queried. The type of data found in a column is determined by using the GType system
=begin comment
 (ie. B<G_TYPE_INT>, B<GTK_TYPE_BUTTON>, B<G_TYPE_POINTER>, etc).
=end comment
The types are homogeneous per column across all nodes. It is important to note that this interface only provides a way of examining a model and observing changes. The implementation of each individual model decides how and if changes are made.

In order to make life simpler for programmers who do not need to write their own specialized model, two generic models are provided — the B<Gnome::Gtk3::TreeStore> and the B<Gnome::Gtk3::ListStore>. To use these, the developer simply pushes data into these models as necessary. These models provide the data structure as well as all appropriate tree interfaces. As a result, implementing drag and drop, sorting, and storing data is trivial. For the vast majority of trees and lists, these two models are sufficient.

Models are accessed on a node/column level of granularity. One can query for the value of a model at a certain node and a certain column on that node. There are two structures used to reference a particular node in a model. They are the B<Gnome::Gtk3::TreePath>-struct and the B<Gnome::Gtk3::TreeIter>-struct (“iter” is short for iterator). Most of the interface consists of operations on a B<Gnome::Gtk3::TreeIter>-struct.

A path is essentially a potential node. It is a location on a model that may or may not actually correspond to a node on a specific model. The B<Gnome::Gtk3::TreePath>-struct can be converted into either an array of unsigned integers or a string. The string form is a list of numbers separated by a colon. Each number refers to the offset at that level. Thus, the path `0` refers to the root node and the path `2:4` refers to the fifth child of the third node.

By contrast, a B<Gnome::Gtk3::TreeIter> is a reference to a specific node on a specific model. It is a generic struct with an integer and three generic pointers. These are filled in by the model in a model-specific way. One can convert a path to an iterator by calling C<gtk_tree_model_get_iter()>. These iterators are the primary way of accessing a model and are similar to the iterators used by B<Gnome::Gtk3::TextBuffer>. They are generally statically allocated on the stack and only used for a short time. The model interface defines a set of operations using them for navigating the model.

It is expected that models fill in the iterator with private data. For example, the B<Gnome::Gtk3::ListStore> model, which is internally a simple linked list, stores a list node in one of the pointers. The B<Gnome::Gtk3::TreeModelSort> stores an array and an offset in two of the pointers. Additionally, there is an integer field. This field is generally filled with a unique stamp per model. This stamp is for catching errors resulting from using invalid iterators with a model.

The lifecycle of an iterator can be a little confusing at first. Iterators are expected to always be valid for as long as the model is unchanged (and doesn’t emit a signal). The model is considered to own all outstanding iterators and nothing needs to be done to free them from the user’s point of view. Additionally, some models guarantee that an iterator is valid for as long as the node it refers to is valid (most notably the B<Gnome::Gtk3::TreeStore> and B<Gnome::Gtk3::ListStore>). Although generally uninteresting, as one always has to allow for the case where iterators do not persist beyond a signal, some very important performance enhancements were made in the sort model. As a result, the B<GTK_TREE_MODEL_ITERS_PERSIST> flag was added to indicate this behavior.

To help show some common operation of a model, some examples are provided. The first example shows three ways of getting the iter at the location `3:2:5`. While the first method shown is easier, the second is much more common, as you often get paths from callbacks.

=head2 Acquiring a Gnome::Gtk3::TreeIter

  # A ListStore with two columns, an integer and a string
  my Gnome::Gtk3::ListStore $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));

  # Filling a ListStore needs also an iterator. This on points to the end.
  my Gnome::Gtk3::TreeIter $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, 0, 1001, 1, 'first entry');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, 0, 2002, 1, 'second entry');

  # Get the iterator from a string. A ListStore has simple paths.
  $iter = $ls.get_iter_from_string("1");

  # Get the iterator from a path
  my Gnome::Gtk3::TreePath $path .= new(:string('0'));
  $iter = $ls.get-iter($path);
  $path.clear-tree-path;


=begin comment
# walk the tree to find the iterator.
$iter = $ls.iter-nth-child( Any, 1);
my Gnome::Gtk3::TreeIter $parent-iter = $iter;
$ls.iter-nth-child( $iter, $parent-iter, 2);
parent_iter = iter;
gtk_tree_model_iter_nth_child (model, &iter,
                               &parent_iter, 5);

This second example shows a quick way of iterating through a list
and getting a string and an integer from each row. The
C<populate_model()> function used below is not
shown, as it is specific to the B<Gnome::Gtk3::ListStore>. For information on
how to write such a function, see the B<Gnome::Gtk3::ListStore> documentation.

## Reading data from a B<Gnome::Gtk3::TreeModel>

|[<!-- language="C" -->
enum
{
  STRING_COLUMN,
  INT_COLUMN,
  N_COLUMNS
};

...

B<Gnome::Gtk3::TreeModel> *list_store;
B<Gnome::Gtk3::TreeIter> iter;
gboolean valid;
gint row_count = 0;

// make a new list_store
list_store = gtk_list_store_new (N_COLUMNS,
                                 G_TYPE_STRING,
                                 G_TYPE_INT);

// Fill the list store with data
populate_model (list_store);

// Get the first iter in the list, check it is valid and walk
// through the list, reading each row.

valid = gtk_tree_model_get_iter_first (list_store,
                                       &iter);
while (valid)
 {
   gchar *str_data;
   gint   int_data;

   // Make sure you terminate calls to C<gtk_tree_model_get()> with a “-1” value
   gtk_tree_model_get (list_store, &iter,
                       STRING_COLUMN, &str_data,
                       INT_COLUMN, &int_data,
                       -1);

   // Do something with the data
   g_print ("Row C<d>: (C<s>,C<d>)\n",
            row_count, str_data, int_data);
   g_free (str_data);

   valid = gtk_tree_model_iter_next (list_store,
                                     &iter);
   row_count++;
 }
]|
=end comment

=begin comment
The B<Gnome::Gtk3::TreeModel> interface contains two methods for reference
counting: C<gtk_tree_model_ref_node()> and C<gtk_tree_model_unref_node()>.
These two methods are optional to implement. The reference counting
is meant as a way for views to let models know when nodes are being
displayed. B<Gnome::Gtk3::TreeView> will take a reference on a node when it is
visible, which means the node is either in the toplevel or expanded.
Being displayed does not mean that the node is currently directly
visible to the user in the viewport. Based on this reference counting
scheme a caching model, for example, can decide whether or not to cache
a node based on the reference count. A file-system based model would
not want to keep the entire file hierarchy in memory, but just the
folders that are currently expanded in every current view.

When working with reference counting, the following rules must be taken
into account:

- Never take a reference on a node without owning a reference on its parent.
  This means that all parent nodes of a referenced node must be referenced
  as well.

- Outstanding references on a deleted node are not released. This is not
  possible because the node has already been deleted by the time the
  row-deleted signal is received.

- Models are not obligated to emit a signal on rows of which none of its
  siblings are referenced. To phrase this differently, signals are only
  required for levels in which nodes are referenced. For the root level
  however, signals must be emitted at all times (however the root level
  is always referenced when any view is attached).
=end comment


=head2 See Also

B<Gnome::Gtk3::TreeView>, B<Gnome::Gtk3::TreeStore>, B<Gnome::Gtk3::ListStore>,


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::TreeModel;


=head2 Uml Diagram
![](plantuml/TreeModel.svg)


=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
#use Gnome::GObject::Object;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::TreeRowReference;


#-------------------------------------------------------------------------------
# types cannot be declared inside a role decleration
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTreeModelFlags

These flags indicate various properties of a B<Gnome::Gtk3::TreeModel>.

They are returned by C<gtk_tree_model_get_flags()>, and must be
static for the lifetime of the object. A more complete description
of B<GTK_TREE_MODEL_ITERS_PERSIST> can be found in the overview of
this section.


=item GTK_TREE_MODEL_ITERS_PERSIST: iterators survive all signals emitted by the tree
=item GTK_TREE_MODEL_LIST_ONLY: the model is a list only, and never has children


=end pod

#TE:2:GtkTreeModelFlags:t/ListStore.t
enum GtkTreeModelFlags is export (
  'GTK_TREE_MODEL_ITERS_PERSIST' => 1 +< 0,
  'GTK_TREE_MODEL_LIST_ONLY' => 1 +< 1
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTreeModelIface




=item ___row_changed: Signal emitted when a row in the model has changed.
=item ___row_inserted: Signal emitted when a new row has been inserted in the model.
=item ___row_has_child_toggled: Signal emitted when a row has gotten the first child row or lost its last child row.
=item ___row_deleted: Signal emitted when a row has been deleted.
=item ___rows_reordered: Signal emitted when the children of a node in the B<Gnome::Gtk3::TreeModel> have been reordered.
=item ___get_flags: Get B<Gnome::Gtk3::TreeModelFlags> supported by this interface.
=item ___get_n_columns: Get the number of columns supported by the model.
=item ___get_column_type: Get the type of the column.
=item ___get_iter: Sets iter to a valid iterator pointing to path.
=item ___get_path: Gets a newly-created B<Gnome::Gtk3::TreePath> referenced by iter.
=item ___get_value: Initializes and sets value to that at column.
=item ___iter_next: Sets iter to point to the node following it at the current level.
=item ___iter_previous: Sets iter to point to the previous node at the current level.
=item ___iter_children: Sets iter to point to the first child of parent.
=item ___iter_has_child: C<1> if iter has children, C<0> otherwise.
=item ___iter_n_children: Gets the number of children that iter has.
=item ___iter_nth_child: Sets iter to be the child of parent, using the given index.
=item ___iter_parent: Sets iter to be the parent of child.
=item ___ref_node: Lets the tree ref the node.
=item ___unref_node: Lets the tree unref the node.


=end pod

#TT:0:N-GtkTreeModelIface:
class N-GtkTreeModelIface is export is repr('CStruct') {
  has int32 $.g_iface;
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.iter);
  has N-GtkTreePath $.path);
  has int32 $.new_order);
  has GtkTreeModelFlag $.s (* get_flags)  (GtkTreeModel *tree_model);
  has gin $.t         (* get_n_columns)   (GtkTreeModel *tree_model);
  has int32 $.index_);
  has N-GtkTreePath $.path);
  has N-GtkTreeIter $.iter);
  has N-GObject $.value);
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.parent);
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.iter);
  has int32 $.n);
  has N-GtkTreeIter $.child);
  has N-GtkTreeIter $.iter);
  has N-GtkTreeIter $.iter);
}
}}

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit role Gnome::Gtk3::TreeModel:auth<github:MARTIMM>;


#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#TM:2:new():interfacing:t/ListStore.t
# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# setup signals from interface
method _add_tree_model_signal_types ( Str $class-name ) {

  self.add-signal-types( $class-name,
    :w1<row-deleted>,
    :w2<row-changed row-inserted row-has-child-toggled>,
    :w3<rows-reordered>
  );
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _tree_model_interface ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_model_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_row_reference_new:
=begin pod
=head2 [gtk_] tree_row_reference_new

Creates a row reference based on I<$path>.

This reference will keep pointing to the node pointed to by I<$path>, so long as it exists. Any changes that occur on I<$model> are propagated, and the path is updated appropriately. If I<$path> isn’t a valid path in I<$model>, then C<Any> is returned.

Returns: a newly allocated B<Gnome::Gtk3::TreeRowReference>, or C<Any>

  method gtk_tree_row_reference_new (
    N-GtkTreePath $path --> N-GtkTreeRowReference
  )

=item N-GtkTreePath $path; a valid B<Gnome::Gtk3::TreePath>-struct to monitor

=end pod

sub gtk_tree_row_reference_new ( N-GObject $model, N-GtkTreePath $path )
  returns N-GtkTreeRowReference
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_flags:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_flags

Returns a set of flags supported by this interface.

The flags are a bitwise combination of enum values of B<GtkTreeModelFlags>. The flags supported should not change during the lifetime of the I<tree_model>.

Returns: the flags supported by this interface

  method gtk_tree_model_get_flags ( --> GtkTreeModelFlags  )

=end pod

sub gtk_tree_model_get_flags ( N-GObject $tree_model )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_n_columns:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_n_columns

Returns the number of columns supported by I<tree_model>.

  method gtk_tree_model_get_n_columns ( --> Int  )

=end pod

sub gtk_tree_model_get_n_columns ( N-GObject $tree_model )
  returns int32
  is native(&gtk-lib)
  is export
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_column_type:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_column_type

Returns the type of the column.

  method gtk_tree_model_get_column_type ( Int $index --> UInt )

=item Int $index; the column index

=end pod

sub gtk_tree_model_get_column_type (
  N-GObject $tree_model, int32 $index --> uint32
) is native(&gtk-lib)
  is export
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_iter:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_iter

Returns a valid iterator pointing to I<$path>.  If I<$path> does not exist, an invalid iterator is returned. Test with C<.tree-iter-is-valid()> to see if the iterator is ok.

  method gtk_tree_model_get_iter (
    Gnome::Gtk3::TreePath $path
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreePath $path; The path to point the iterator to.

=end pod

sub gtk_tree_model_get_iter (
  N-GObject $tree_model, N-GtkTreePath $path
  --> Gnome::Gtk3::TreeIter
) {
#  my Gnome::Gtk3::TreeIter $iter;
  my N-GtkTreeIter $ni .= new;
  my Int $sts = _gtk_tree_model_get_iter( $tree_model, $ni, $path);

  if $sts {
    Gnome::Gtk3::TreeIter.new(:native-object($ni));
  }

  else {
    # create an invalid object
    Gnome::Gtk3::TreeIter.new(:native-object(N-GtkTreeIter));
  }

#  $iter
}

sub _gtk_tree_model_get_iter (
  N-GObject $tree_model, N-GtkTreeIter $iter, N-GtkTreePath $path
) returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_get_iter')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_iter_from_string:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_iter_from_string

Returns a valid iterator pointing to I<$path_string>, if it exists. Otherwise, an invalid iterator is returned. Test with C<.tree-iter-is-valid()> to see if the iterator is ok.

  method gtk_tree_model_get_iter_from_string (
    Str $path_string
    --> N-GtkTreeIter
  )

=item Str $path_string; a string representation of a B<Gnome::Gtk3::TreePath>-struct

=end pod

sub gtk_tree_model_get_iter_from_string (
  N-GObject $tree_model, Str $path
  --> Gnome::Gtk3::TreeIter
) {
  my Gnome::Gtk3::TreeIter $iter;
  my N-GtkTreeIter $ni .= new;
  my Int $sts = _gtk_tree_model_get_iter_from_string( $tree_model, $ni, $path);

  if $sts {
    $iter .= new(:native-object($ni));
  }

  else {
    # create an invalid object
    $iter .= new(:native-object(N-GtkTreeIter));
  }

  $iter
}

sub _gtk_tree_model_get_iter_from_string (
  N-GObject $tree_model, N-GtkTreeIter $iter, Str $path_string
) returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_get_iter_from_string')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_string_from_iter:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_string_from_iter

Generates a string representation of the iter.

This string is a “:” separated list of numbers. For example, “4:10:0:3” would be an acceptable return value for this string.

Returns: a newly-allocated string.

Since: 2.2

  method gtk_tree_model_get_string_from_iter ( N-GtkTreeIter $iter --> Str  )

=item N-GtkTreeIter $iter; a B<Gnome::Gtk3::TreeIter>-struct

=end pod

#TODO: Must be freed with C<g_free()>.
sub gtk_tree_model_get_string_from_iter (
  N-GObject $tree_model, N-GtkTreeIter $iter
) returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_iter_first:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_iter_first

Initializes I<iter> with the first iterator in the tree (the one at the path "0"). Returns an invalid iterator if the tree is empty.

  method gtk_tree_model_get_iter_first ( --> Gnome::Gtk3::TreeIter  )

=end pod

sub gtk_tree_model_get_iter_first (
  N-GObject $tree_model --> Gnome::Gtk3::TreeIter
) {
  my Gnome::Gtk3::TreeIter $iter;
  my N-GtkTreeIter $ni .= new;
  my Int $sts = _gtk_tree_model_get_iter_first( $tree_model, $ni);

  if $sts {
    $iter .= new(:native-object($ni));
  }

  else {
    # create an invalid object
    $iter .= new(:native-object(N-GtkTreeIter));
  }

  $iter
}

sub _gtk_tree_model_get_iter_first (
  N-GObject $tree_model, N-GtkTreeIter $iter
) returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_get_iter_first')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_path:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_path

Returns a newly-created B<Gnome::Gtk3::TreePath> referenced by I<$iter>.

This path should be freed with C<.clear-tree-path()>.

  method gtk_tree_model_get_path (
    Gnome::Gtk3::TreeIter $iter
    --> Gnome::Gtk3::TreePath
  )

=item Gnome::Gtk3::TreeIter $iter; the iterator

=end pod

sub gtk_tree_model_get_path (
  N-GObject $tree_model, N-GtkTreeIter $iter
  --> Gnome::Gtk3::TreePath
) {
#note"tree iter: $iter";
#note"tree model: $tree_model";

  my N-GtkTreePath $tree-path = _gtk_tree_model_get_path( $tree_model, $iter);
  Gnome::Gtk3::TreePath.new(:native-object($tree-path))
}

sub _gtk_tree_model_get_path ( N-GObject $tree_model, N-GtkTreeIter $iter )
  returns N-GtkTreePath
  is native(&gtk-lib)
  is symbol('gtk_tree_model_get_path')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_get_value:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] get_value

Returns an array of values found at the I<$iter> and I<$column>s.

When done with each I<value>, C<.clear-object()> needs to be called to free any allocated memory.

  method gtk_tree_model_get_value (
    Gnome::Gtk3::TreeIter $iter, Int $column, ...
    --> Array[Gnome::GObject::Value]
  )

=item Gnome::Gtk3::TreeIter $iter; the iterator
=item Int $column; the column to lookup the value at
=item N-GObject $value; (out) (transfer none): an empty B<GValue> to set

=end pod

sub gtk_tree_model_get_value (
  N-GObject $tree_model, N-GtkTreeIter $iter, *@columns
  --> Array[Gnome::GObject::Value]
) {
  my Array[Gnome::GObject::Value] $va .= new;

  for @columns -> $column {
    my N-GValue $v .= new;
    _gtk_tree_model_get_value( $tree_model, $iter, $column, $v);
    $va.push: Gnome::GObject::Value.new(:native-object($v));
  }

  $va
}

sub _gtk_tree_model_get_value (
  N-GObject $tree_model, N-GtkTreeIter $iter, int32 $column, N-GValue $value
) is native(&gtk-lib)
  is symbol('gtk_tree_model_get_value')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_previous:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_previous

Sets I<$iter> to point to the previous node at the current level.

If there is no previous I<iter>, C<0> is returned and I<iter> is
set to be invalid.

Returns: C<1> if I<iter> has been changed to the previous node

Since: 3.0

  method gtk_tree_model_iter_previous ( N-GtkTreeIter $iter --> Int  )

=item N-GtkTreeIter $iter; (in): the B<Gnome::Gtk3::TreeIter>-struct

=end pod

sub gtk_tree_model_iter_previous ( N-GObject $tree_model, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_next:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_next

Sets I<iter> to point to the node following it at the current level.

If there is no next I<iter>, C<0> is returned and I<iter> is set
to be invalid.

Returns: C<1> if I<iter> has been changed to the next node

  method gtk_tree_model_iter_next ( N-GtkTreeIter $iter --> Int  )

=item N-GtkTreeIter $iter; (in): the B<Gnome::Gtk3::TreeIter>-struct

=end pod

sub gtk_tree_model_iter_next ( N-GObject $tree_model, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_children:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_children

Returns an iterator to point to the first child of I<$parent>. B<Gnome::Gtk3::ListStore> does not have children but a B<Gnome::Gtk3::TreeStore> does.

If I<$parent> has no children, an invalid iterator is returned. I<$parent> will remain a valid node after this function has been called.

  method gtk_tree_model_iter_children (
    Gnome::Gtk3::TreeIter $parent
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; an iterator pointing to a parent.

=end pod

sub gtk_tree_model_iter_children (
  N-GObject $tree_model, N-GtkTreeIter $parent
  --> Gnome::Gtk3::TreeIter
) {
  my Gnome::Gtk3::TreeIter $iter;
  my N-GtkTreeIter $ni .= new;
  my Int $sts = _gtk_tree_model_iter_children( $tree_model, $ni, $parent);

  if $sts {
    $iter .= new(:native-object($ni));
  }

  else {
    # create an invalid object
    $iter .= new(:native-object(N-GtkTreeIter));
  }

  $iter
}

sub _gtk_tree_model_iter_children ( N-GObject $tree_model, N-GtkTreeIter $iter, N-GtkTreeIter $parent )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_iter_children')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_has_child:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_has_child

Returns C<1> if I<$iter> has children, C<0> otherwise.

  method gtk_tree_model_iter_has_child (
    Gnome::Gtk3::TreeIter $iter
    --> Int
  )

=item Gnome::Gtk3::TreeIter $iter; iterator to test for children

=end pod

sub gtk_tree_model_iter_has_child ( N-GObject $tree_model, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_n_children:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_n_children

Returns the number of children that I<iter> has. As a special case, if I<iter> is undefined, then the number of toplevel nodes is returned.

  method gtk_tree_model_iter_n_children (
    Gnome::Gtk3::TreeIter $iter?
    --> Int
  )

=item Gnome::Gtk3::TreeIter $iter; the iterator

=end pod

# $iter does not have a type. This is to be able to provide Any
sub gtk_tree_model_iter_n_children ( N-GObject $tree_model, $iter --> Int ) {
  my N-GtkTreeIter $ti = $iter if $iter.defined;
  _gtk_tree_model_iter_n_children( $tree_model, $ti)
}

sub _gtk_tree_model_iter_n_children (
  N-GObject $tree_model, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_iter_n_children')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_iter_nth_child:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] iter_nth_child

Returns an iterator to be the child of I<$parent>, using the given index.

The first index is 0. If I<$n> is too big, or I<$parent> has no children, the returned iterator is invalid. I<$parent> will remain a valid node after this function has been called. As a special case, if I<$parent> is undefined, then the iterator is set to the I<$n>-th root node is set.

  method gtk_tree_model_iter_nth_child (
    Gnome::Gtk3::TreeIter $parent, Int $n
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; the parent iterator to get the child from, or C<Any>.
=item Int $n; the index of the desired child

=end pod

sub gtk_tree_model_iter_nth_child (
  N-GObject $tree_model, $parent, int32 $n
  --> Gnome::Gtk3::TreeIter
) {

  my Gnome::Gtk3::TreeIter $iter;
  my N-GtkTreeIter $p = $parent.defined ?? $parent !! N-GtkTreeIter.new;
  my N-GtkTreeIter $ni .= new;

  my Int $sts = _gtk_tree_model_iter_nth_child( $tree_model, $ni, $parent, $n);
  if $sts {
    $iter .= new(:native-object($ni));
  }

  else {
    # create an invalid object
    $iter .= new(:native-object(N-GtkTreeIter));
  }

  $iter
}

sub _gtk_tree_model_iter_nth_child ( N-GObject $tree_model, N-GtkTreeIter $iter, N-GtkTreeIter $parent, int32 $n )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_model_iter_nth_child')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_model_iter_parent:
=begin pod
=head2 [[gtk_] tree_model_] iter_parent

Sets I<iter> to be the parent of I<child>.

If I<child> is at the toplevel, and doesn’t have a parent, then
I<iter> is set to an invalid iterator and C<0> is returned.
I<child> will remain a valid node after this function has been
called.

I<iter> will be initialized before the lookup is performed, so I<child>
and I<iter> cannot point to the same memory location.

Returns: C<1>, if I<iter> is set to the parent of I<child>

  method gtk_tree_model_iter_parent ( N-GtkTreeIter $iter, N-GtkTreeIter $child --> Int  )

=item N-GtkTreeIter $iter; (out): the new B<Gnome::Gtk3::TreeIter>-struct to set to the parent
=item N-GtkTreeIter $child; the B<Gnome::Gtk3::TreeIter>-struct

=end pod

sub gtk_tree_model_iter_parent ( N-GObject $tree_model, N-GtkTreeIter $iter, N-GtkTreeIter $child )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{ only when a model is designed and created
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_model_ref_node:
=begin pod
=head2 [[gtk_] tree_model_] ref_node

Lets the tree ref the node.

This is an optional method for models to implement.
To be more specific, models may ignore this call as it exists
primarily for performance reasons.

This function is primarily meant as a way for views to let
caching models know when nodes are being displayed (and hence,
whether or not to cache that node). Being displayed means a node
is in an expanded branch, regardless of whether the node is currently
visible in the viewport. For example, a file-system based model
would not want to keep the entire file-hierarchy in memory,
just the sections that are currently being displayed by
every current view.

A model should be expected to be able to get an iter independent
of its reffed state.

  method gtk_tree_model_ref_node ( N-GtkTreeIter $iter )

=item N-GtkTreeIter $iter; the B<Gnome::Gtk3::TreeIter>-struct

=end pod

sub gtk_tree_model_ref_node ( N-GObject $tree_model, N-GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_tree_model_unref_node:
=begin pod
=head2 [[gtk_] tree_model_] unref_node

Lets the tree unref the node.

This is an optional method for models to implement.
To be more specific, models may ignore this call as it exists
primarily for performance reasons. For more information on what
this means, see C<gtk_tree_model_ref_node()>.

Please note that nodes that are deleted are not unreffed.

  method gtk_tree_model_unref_node ( N-GtkTreeIter $iter )

=item N-GtkTreeIter $iter; the B<Gnome::Gtk3::TreeIter>-struct

=end pod

sub gtk_tree_model_unref_node ( N-GObject $tree_model, N-GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }
}}

#`{{ too complex!! --> extend get-value
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_model_get:
=begin pod
=head2 [gtk_] tree_model_get

Gets the value of a cell in the row referenced by I<$iter>. (Note that the API is not the same as it is shown on the GTK developers site!)

=begin comment
The variable argument list should contain integer column numbers,
each column number followed by a place to store the value being
retrieved.  The list is terminated by a -1. For example, to get a
value from column 0 with type C<G_TYPE_STRING>, you would
write: `gtk_tree_model_get (model, iter, 0, &place_string_here, -1)`,
where `place_string_here` is a B<gchararray>
to be filled with the string.

Returned values with type C<G_TYPE_OBJECT> have to be unreferenced,
values with type C<G_TYPE_STRING> or C<G_TYPE_BOXED> have to be freed.
Other values are passed by value.
=end comment

  method gtk_tree_model_get (
    N-GtkTreeIter $iter, Int $column-gtype, $column-number, ...
    --> Any
  )

=item N-GtkTreeIter $iter; a row in this tree_model
=item Int $column-number: column numbers of wanted values

=end pod

sub gtk_tree_model_get (
  N-GObject $tree_model, N-GtkTreeIter $iter,
  Int $column-gtype, Int $column-number
  --> Any
) {
  my N-TypesMap $tm .= new;
  my CArray[N-TypesMap] $ret-loc .= new($tm);
  _gtk_tree_model_get( $tree_model, $iter, $column-number, $ret-loc, -1);

  my $ret-val;
  given $column-gtype {
    when G_TYPE_CHAR { $ret-val = $ret-loc[0].int8.Int; }
    when G_TYPE_UCHAR { $ret-val = $ret-loc[0].uint8.UInt; }
    when G_TYPE_UINT { $ret-val = $ret-loc[0].uint32.UInt; }
    when G_TYPE_UINT64 { $ret-val = $ret-loc[0].uint64.UInt; }
    when G_TYPE_FLOAT { $ret-val = $ret-loc[0].float.Num; }
    when G_TYPE_DOUBLE { $ret-val = $ret-loc[0].double.Num; }
    when G_TYPE_STRING { $ret-val = $ret-loc[0].string.Str; }
    when G_TYPE_OBJECT { $ret-val = $ret-loc[0].object; }

    when any(G_TYPE_BOOLEAN|G_TYPE_INT|G_TYPE_ENUM|G_TYPE_FLAGS) {
$ret-loc[0]
      $ret-val = $ret-loc[0].int32.Int;
    }

    when any(G_TYPE_LONG|G_TYPE_INT64) {
      $ret-val = $ret-loc[0].int64.Int;
    }

    when any(G_TYPE_POINTER|G_TYPE_BOXED|G_TYPE_PARAM|G_TYPE_VARIANT) {
      $ret-val = $ret-loc[0].pointer;
    }
  }

  $ret-val
}

sub _gtk_tree_model_get (
  N-GObject $tree_model, N-GtkTreeIter $iter,
  int32 $column-number, CArray[N-TypesMap] $location, int32 $end-list
) is native(&gtk-lib)
  is symbol('gtk_tree_model_get')
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tree_model_get_valist:
=begin pod
=head2 [[gtk_] tree_model_] get_valist

See C<gtk_tree_model_get()>, this version takes a va_list
for language bindings to use.

  method gtk_tree_model_get_valist ( N-GtkTreeIter $iter, va_list $var_args )

=item N-GtkTreeIter $iter; a row in I<tree_model>
=item va_list $var_args; va_list of column/return location pairs

=end pod

sub gtk_tree_model_get_valist ( N-GObject $tree_model, N-GtkTreeIter $iter, va_list $var_args )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:foreach:t/ListStore.t
=begin pod
=head2 foreach

Calls func on each node in model in a depth-first fashion.

If I<func> returns C<1>, then the tree ceases to be walked, and C<foreach()> returns.

  method foreach (
    $function-object, Str $function-name, *%user-options
  )

=item $function-object; an object where the function is defined
=item $function-name; the name of the function which is called
=item %user-options; named arguments which will be provided to the callback

The function signature is

  method f (
    N-GObject $n-store,
    Gnome::Gtk3::TreePath $path,
    Gnome::Gtk3::TreeIter $iter,
    *%user-options
    --> Bool
  )

The value in $n-store is a native object and cannot be created into a Raku object here because it is not known if this is a ListStore or a TreeStore object.

An example

  my Gnome::Gtk3::ListStore $ls;
  my Gnome::Gtk3::TreeIter $iter;

  # specify column types
  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));

  # fill some rows
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, 0, 1001, 1, 'some text');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, 0, 2002, 1, 'a bit more');

  # define class for handler
  class X {
    method row-loop (
      N-GObject $n-store,
      Gnome::Gtk3::TreePath $path,
      Gnome::Gtk3::TreeIter $iter
      --> Bool
    ) {
      # get values for this iterator
      my Gnome::Gtk3::ListStore $store .= new(:native-object($n-store));
      my Array[Gnome::GObject::Value] $va = $store.get-value( $iter, 0);

      # do something with this row ...

      my Int $value = $va[0].get-int;
      $va[0].clear-object;

      if $value of col 0 != 1001 {
        # let the search continue
        False
      }

      # value of col 0 == 1001
      else {
        # stop walking to the next row
        True
      }
    }
  }

  $ls.foreach( X.new, 'row-loop');

=end pod

method foreach ( $function-object, Str $function-name, *%user-options ) {

  if $function-object.^can($function-name) {
    sub local-handler (
      N-GObject $n-m, N-GtkTreePath $n-p, N-GtkTreeIter $n-i,
      OpaquePointer $d
      --> gboolean
    ) {
      CATCH { default { .message.note; .backtrace.concise.note } }
#note "TP 0: $n-p, $n-i";
#note "TP 1: ", gtk_tree_model_get_string_from_iter( $m, $n-i);
      my Bool $sts = $function-object."$function-name"(
        $n-m,
        Gnome::Gtk3::TreePath.new(:native-object($n-p)),
        Gnome::Gtk3::TreeIter.new(:native-object($n-i)),
        |%user-options
      );

#note "returns $sts";
      $sts ?? 1 !! 0
    }

    _gtk_tree_model_foreach(
      self._f('GtkTreeModel'), &local-handler, OpaquePointer,
    ) if self.iter-n-children(Any);
  }

  else {
    note "Method $function-name not found in object $function-object.gist()"
      if $Gnome::N::x-debug;
  }
}

sub gtk_tree_model_foreach (
  N-GObject:D $m, Any:D $func-object, Str:D $func-name, *%user-options
) {
  Gnome::N::deprecate( 'gtk_tree_model_foreach', 'foreach', '0.34.2', '0.40.0');

  if $func-object.^can($func-name) {
    _gtk_tree_model_foreach(
      $m,
      sub (
        N-GObject $n-m, N-GtkTreePath $n-p, N-GtkTreeIter $n-i,
        OpaquePointer $d
        --> int32
      ) {
        CATCH { default { .message.note; .backtrace.concise.note } }
#note "TP 0: $n-p, $n-i";
#note "TP 1: ", gtk_tree_model_get_string_from_iter( $m, $n-i);

#TODO? Cannot find type of model: liststore or treestore
#        my Gnome::GObject::Object $tm .= new(:native-object($n-m));
#        note $tm.perl, ', ', $tm.get-class-name;
        my int32 $sts = $func-object."$func-name"(
          $n-m,
          Gnome::Gtk3::TreePath.new(:native-object($n-p)),
          Gnome::Gtk3::TreeIter.new(:native-object($n-i)),
          |%user-options
        );
#note "returns $sts";
#$sts
      },
      OpaquePointer
    );
  }

  else {
    note "Method $func-name not found in object $func-object.perl()"
      if $Gnome::N::x-debug;
  }
}

sub _gtk_tree_model_foreach (
  N-GObject $model,
  Callable $func (
    N-GObject $m, N-GtkTreePath $p, N-GtkTreeIter $i, OpaquePointer $d
    --> int32
  ), OpaquePointer $user_data
) is native(&gtk-lib)
  is symbol('gtk_tree_model_foreach')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_row_changed:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] row_changed

Emits the  I<row-changed> signal on the tree model.

  method gtk_tree_model_row_changed (
    Gnome::Gtk3::TreePath $path,
    Gnome::Gtk3::TreeIter $iter
  )

=item Gnome::Gtk3::TreePath $path; a path pointing to the changed row
=item Gnome::Gtk3::TreeIter $iter; an iterator pointing to the changed row

=end pod

sub gtk_tree_model_row_changed (
  N-GObject $tree_model, N-GtkTreePath $path, N-GtkTreeIter $iter
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_row_inserted:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] row_inserted

Emits the  I<row-inserted> signal on the tree model.

  method gtk_tree_model_row_inserted (
    Gnome::Gtk3::TreePath $path,
    Gnome::Gtk3::TreeIter $iter
  )

=item Gnome::Gtk3::TreePath $path; a path pointing to the changed row
=item Gnome::Gtk3::TreeIter $iter; an iterator pointing to the changed row

=end pod

sub gtk_tree_model_row_inserted ( N-GObject $tree_model, N-GtkTreePath $path, N-GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_row_has_child_toggled:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] row_has_child_toggled

Emits the  I<row-has-child-toggled> signal on
I<tree_model>. This should be called by models after the child
state of a node changes.

  method gtk_tree_model_row_has_child_toggled ( N-GtkTreePath $path, N-GtkTreeIter $iter )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>-struct pointing to the changed row
=item N-GtkTreeIter $iter; a valid B<Gnome::Gtk3::TreeIter>-struct pointing to the changed row

=end pod

sub gtk_tree_model_row_has_child_toggled ( N-GObject $tree_model, N-GtkTreePath $path, N-GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_row_deleted:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] row_deleted

Emits the  I<row-deleted> signal on I<tree_model>.

This should be called by models after a row has been removed.
The location pointed to by I<path> should be the location that
the row previously was at. It may not be a valid location anymore.

Nodes that are deleted are not unreffed, this means that any
outstanding references on the deleted node should not be released.

  method gtk_tree_model_row_deleted ( N-GtkTreePath $path )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>-struct pointing to the previous location of the deleted row

=end pod

sub gtk_tree_model_row_deleted ( N-GObject $tree_model, N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_rows_reordered:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] rows_reordered

Emits the  I<rows-reordered> signal on I<tree_model>.

This should be called by models when their rows have been
reordered.

  method gtk_tree_model_rows_reordered ( N-GtkTreePath $path, N-GtkTreeIter $iter, Int $new_order )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>-struct pointing to the tree node whose children have been reordered
=item N-GtkTreeIter $iter; a valid B<Gnome::Gtk3::TreeIter>-struct pointing to the node whose children have been reordered, or C<Any> if the depth of I<path> is 0
=item Int $new_order; an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. I<new_order>`[newpos] = oldpos`

=end pod

sub gtk_tree_model_rows_reordered (
  N-GObject $tree_model, N-GtkTreePath $path,
  N-GtkTreeIter $iter, CArray[int32] $new_order
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tree_model_rows_reordered_with_length:t/ListStore.t
=begin pod
=head2 [[gtk_] tree_model_] rows_reordered_with_length

Emits the  I<rows-reordered> signal on I<tree_model>.

This should be called by models when their rows have been
reordered.

Since: 3.10

  method gtk_tree_model_rows_reordered_with_length ( N-GtkTreePath $path, N-GtkTreeIter $iter, Int $new_order, Int $length )

=item N-GtkTreePath $path; a B<Gnome::Gtk3::TreePath>-struct pointing to the tree node whose children have been reordered
=item N-GtkTreeIter $iter; (allow-none): a valid B<Gnome::Gtk3::TreeIter>-struct pointing to the node whose children have been reordered, or C<Any> if the depth of I<path> is 0
=item Int $new_order; (array length=length): an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. I<new_order>`[newpos] = oldpos`
=item Int $length; length of I<new_order> array

=end pod

sub gtk_tree_model_rows_reordered_with_length (
  N-GObject $tree_model, N-GtkTreePath $path,
  N-GtkTreeIter $iter, CArray[int32] $new_order, int32 $length
) is native(&gtk-lib)
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


=comment #TS:2:row-changed:t/ListStore.t
=head3 row-changed

This signal is emitted when a row in the model has changed.

  method handler (
    N-GObject $path,
    N-GtkTreeIter $iter,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tree_model),
    *%user-options
  );

=item Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted
=item N-GObject $path; a native B<Gnome::Gtk3::TreePath> identifying the changed row
=item N-GtkTreeIter $iter; a native B<Gnome::Gtk3::TreeIter> pointing to the changed row


=comment #TS:2:row-deleted:t/ListStore.t
=head3 row-deleted

This signal is emitted when a row in the model is deleted.

  method handler (
    N-GObject $path,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tree_model),
    *%user-options
  );

=item Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted.
=item N-GObject $path; a native B<Gnome::Gtk3::TreePath> identifying where the deleted row has been at. This path may not be a valid location anymore.


=comment #TS:0=2:row-inserted:t/ListStore.t
=head3 row-inserted

This signal is emitted when a new row has been inserted in
the model.

Note that the row may still be empty at this point, since it is a common pattern to first insert an empty row, and then fill it with the desired values.

  method handler (
    N-GObject $path,
    N-GtkTreeIter $iter,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tree_model),
    *%user-options
  );

=item Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted
=item $path; a native B<Gnome::Gtk3::TreePath> identifying the new row
=item $iter; a native B<Gnome::Gtk3::TreeIter> pointing to the new row


=comment #TS:2:row-has-child-toggled:t/ListStore.t
=head3 row-has-child-toggled

This signal is emitted when a row has gotten the first child row or lost its last child row.

  method handler (
    N-GObject $path,
    N-GtkTreeIter $iter,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tree_model),
    *%user-options
  );

=item Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted
=item $path; a native B<Gnome::Gtk3::TreePath> identifying the new row
=item $iter; a native B<Gnome::Gtk3::TreeIter> pointing to the new row


=comment #TS:2:rows-reordered:t/ListStore.t
=head3 rows-reordered

This signal is emitted when the children of a node in the GtkTreeModel have been reordered.

Note that this signal is not emitted when rows are reordered by DND, since this is implemented by removing and then reinserting the row.

  method handler (
    N-GObject $path,
    N-GtkTreeIter $iter,
    CArray[int32] $new-order,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tree_model),
    *%user-options
  );

=item Gnome::Gtk3::TreeModel $tree_model; the model on which the signal is emitted
=item $path; a native B<Gnome::Gtk3::TreePath> identifying the new row
=item $iter; a native B<Gnome::Gtk3::TreeIter> pointing to the new row
=item $new-order; an array of integers mapping the current position of each child to its old position before the re-ordering, i.e. C<$new_order[newpos] = oldpos>.


=end pod
