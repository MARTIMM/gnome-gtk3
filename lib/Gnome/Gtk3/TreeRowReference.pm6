#TL:1:Gnome::Gtk3::TreeRowReference:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeRowReference

=head1 Description

A class that keeps a reference to a row in a list or tree. When set, this reference will keep pointing to the node, as long as it exists. Any changes that occur on the list or tree model are propagated, and the path is updated appropriately.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeRowReference;
  also is Gnome::GObject::Boxed;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Boxed;
use Gnome::Gtk3::TreeIter; # when placed after TreePath, the TreeRowReference
                           # type becomes unknown ?????
use Gnome::Gtk3::TreePath;

#use Gnome::Gtk3::TreeModel;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TreeRowReference:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTreeRowReference
=end pod

#TT:1:N-GtkTreeRowReference:
class N-GtkTreeRowReference
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
has Bool $.tree-row-reference-is-valid = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create an object taking the native object from elsewhere.

  multi method new ( N-GtkTreeRowReference :tree-row-reference! )

=end pod

#TM:1:new(:tree-row-reference):
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TreeRowReference';

  # process all named arguments
  if ? %options<tree-row-reference> {
    self.native-gboxed(%options<tree-row-reference>);
    $!tree-row-reference-is-valid = self.get-native-gboxed.defined;
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkTreeRowReference');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_row_reference_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkTreeRowReference');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# doc for attribute defined above
#TM:1:tree-row-reference-is-valid:
=begin pod
=head2 tree-row-reference-is-valid

Method to test if the native object is valid.

  method tree-row-reference-is-valid ( --> Bool )

=end pod

#-------------------------------------------------------------------------------
#TM:1:clear-tree-row-reference:
=begin pod
=head2 clear-tree-row-reference

Frees the native C<N-GtkTreeRowReference> object and after that, tree-row-reference-is-valid() returns False.

  method clear-tree-row-reference ( )

=end pod

method clear-tree-row-reference ( ) {
  _gtk_tree_row_reference_free(self.get-native-gboxed);
  $!tree-row-reference-is-valid = False;
#  self.native-gboxed(N-GtkTreeRowReference);
}

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_row_reference_new_proxy:
=begin pod
=head2 gtk_tree_row_reference_new_proxy

You do not need to use this function.

Creates a row reference based on I<path>.

This reference will keep pointing to the node pointed to
by I<path>, so long as it exists. If I<path> isn’t a valid
path in I<model>, then C<Any> is returned. However, unlike
references created with C<gtk_tree_row_reference_new()>, it
does not listen to the model for changes. The creator of
the row reference must do this explicitly using
C<gtk_tree_row_reference_inserted()>, C<gtk_tree_row_reference_deleted()>,
C<gtk_tree_row_reference_reordered()>.

These functions must be called exactly once per proxy when the
corresponding signal on the model is emitted. This single call
updates all row references for that proxy. Since built-in GTK+
objects like B<Gnome::Gtk3::TreeView> already use this mechanism internally,
using them as the proxy object will produce unpredictable results.
Further more, passing the same object as I<model> and I<proxy>
doesn’t work for reasons of internal implementation.

This type of row reference is primarily meant by structures that
need to carefully monitor exactly when a row reference updates
itself, and is not generally needed by most applications.

Returns: a newly allocated B<Gnome::Gtk3::TreeRowReference>, or C<Any>

  method gtk_tree_row_reference_new_proxy (
    N-GObject $proxy, N-GObject $model, N-GtkTreePath $path
    --> N-GtkTreeRowReference
  )

=item N-GObject $proxy; a proxy B<GObject>
=item N-GObject $model; a B<Gnome::Gtk3::TreeModel>
=item N-GtkTreePath $path; a valid B<Gnome::Gtk3::TreePath>-struct to monitor

=end pod

sub gtk_tree_row_reference_new_proxy ( N-GObject $proxy, N-GObject $model, N-GtkTreePath $path )
  returns N-GtkTreeRowReference
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_row_reference_get_path:
=begin pod
=head2 gtk_tree_row_reference_get_path

Returns a path that the row reference currently points to, or C<Any> if the path pointed to is no longer valid.

  method gtk_tree_row_reference_get_path ( --> Gnome::Gtk3::TreePath )

=end pod

sub gtk_tree_row_reference_get_path (
  N-GtkTreeRowReference $reference
  --> Gnome::Gtk3::TreePath
) {
  Gnome::Gtk3::TreePath.new(
    :tree-path(_gtk_tree_row_reference_get_path($reference))
  )
}

sub _gtk_tree_row_reference_get_path ( N-GtkTreeRowReference $reference )
  returns N-GtkTreePath
  is native(&gtk-lib)
  is symbol('gtk_tree_row_reference_get_path')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_row_reference_get_model:
=begin pod
=head2 gtk_tree_row_reference_get_model

Returns the model that the row reference is monitoring.

Since: 2.8

  method gtk_tree_row_reference_get_model ( --> N-GObject  )

=end pod

sub gtk_tree_row_reference_get_model ( N-GtkTreeRowReference $reference )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:1:gtk_tree_row_reference_valid:
=begin pod
=head2 gtk_tree_row_reference_valid

Returns C<1> if the reference is defined and refers to a current valid path.

  method gtk_tree_row_reference_valid ( --> Int )

=end pod

sub gtk_tree_row_reference_valid ( N-GtkTreeRowReference $reference )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_row_reference_copy:
=begin pod
=head2 gtk_tree_row_reference_copy

Copies a B<Gnome::Gtk3::TreeRowReference>.

Since: 2.2

  method gtk_tree_row_reference_copy ( --> N-GtkTreeRowReference  )

=end pod

sub gtk_tree_row_reference_copy ( N-GtkTreeRowReference $reference )
  returns N-GtkTreeRowReference
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{ use clear method above
#TM:0:gtk_tree_row_reference_free:
=begin pod
=head2 gtk_tree_row_reference_free

Free’s I<reference>. I<reference> may be C<Any>

  method gtk_tree_row_reference_free ( )

=end pod
}}

sub _gtk_tree_row_reference_free ( N-GtkTreeRowReference $reference )
  is native(&gtk-lib)
  is symbol('gtk_tree_row_reference_free')
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_row_reference_inserted:
=begin pod
=head2 gtk_tree_row_reference_inserted

Lets a set of row reference created by C<gtk_tree_row_reference_new_proxy()> know that the model emitted the  I<row-inserted> signal.

  method gtk_tree_row_reference_inserted (
    N-GObject $proxy, N-GtkTreePath $path
  )

=item N-GObject $proxy; a B<GObject>
=item N-GtkTreePath $path; the row position that was inserted

=end pod

sub gtk_tree_row_reference_inserted ( N-GObject $proxy, N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_tree_row_reference_deleted:
=begin pod
=head2 gtk_tree_row_reference_deleted

Lets a set of row reference created by
C<gtk_tree_row_reference_new_proxy()> know that the
model emitted the  I<row-deleted> signal.

  method gtk_tree_row_reference_deleted (
    N-GObject $proxy, N-GtkTreePath $path
  )

=item N-GObject $proxy; a B<GObject>
=item N-GtkTreePath $path; the path position that was deleted

=end pod

sub gtk_tree_row_reference_deleted ( N-GObject $proxy, N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_tree_row_reference_reordered:
=begin pod
=head2 gtk_tree_row_reference_reordered

Lets a set of row reference created by
C<gtk_tree_row_reference_new_proxy()> know that the
model emitted the  I<rows-reordered> signal.

  method gtk_tree_row_reference_reordered ( N-GObject $proxy, N-GtkTreePath $path, N-GtkTreeIter $iter, Int $new_order )

=item N-GObject $proxy; a B<GObject>
=item N-GtkTreePath $path; the parent path of the reordered signal
=item N-GtkTreeIter $iter; the iter pointing to the parent of the reordered
=item Int $new_order; (array): the new order of rows

=end pod

sub gtk_tree_row_reference_reordered ( N-GObject $proxy, N-GtkTreePath $path, N-GtkTreeIter $iter, int32 $new_order )
  is native(&gtk-lib)
  { * }
}}
