#TL:1:Gnome::Gtk3::ListBox:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ListBox

A list container

![](images/list-box.png)

=head1 Description

A B<Gnome::Gtk3::ListBox> is a vertical container that contains B<Gnome::Gtk3::ListBoxRow> children. These rows can be dynamically sorted and filtered, and headers can be added dynamically depending on the row content. It also allows keyboard and mouse navigation and selection like a typical list.

Using B<Gnome::Gtk3::ListBox> is often an alternative to B<Gnome::Gtk3::TreeView>, especially when the list contents has a more complicated layout than what is allowed by a B<Gnome::Gtk3::CellRenderer>, or when the contents is interactive (i.e. has a button in it).

Although a B<Gnome::Gtk3::ListBox> must have only B<Gnome::Gtk3::ListBoxRow> children you can add any kind of widget to it via C<gtk_container_add()>, and a B<Gnome::Gtk3::ListBoxRow> widget will automatically be inserted between the list and the widget.

B<Gnome::Gtk3::ListBoxRows> can be marked as activatable or selectable. If a row is activatable, sig C<row-activated> will be emitted for it when the user tries to activate it. If it is selectable, the row will be marked as selected when the user tries to select it.

The B<Gnome::Gtk3::ListBox> widget was added in GTK+ 3.10.

=head2 Css Nodes

B<Gnome::Gtk3::ListBox> uses a single CSS node with name list. B<Gnome::Gtk3::ListBoxRow> uses a single CSS node with name row. The row nodes get the .activatable style class added when appropriate.

=head2 See Also

B<Gnome::Gtk3::ScrolledWindow>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ListBox;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Buildable;

=head2 Example

Create a ListBox with one row. This row is a grid holding a CheckBox and Label.

  my Gnome::Gtk3::ListBox $lb .= new;

  # The widgets
  my Gnome::Gtk3::CheckButton $check .= new(:label('bold'));
  my Gnome::Gtk3::Label $label .= new(:text('Turn on bold font'));

  # Add the widgets to the Grid
  my Gnome::Gtk3::Grid $grid .= new;
  $grid.gtk-grid-attach( $check, 0, 0, 1, 1);
  $grid.gtk-grid-attach( $label, 1, 0, 1, 1);

  # Add the Grid to the ListBox
  $lb.gtk-container-add($grid);

To check its values one can register signals on each important widget (e.g. $check in this case) or read the listbox entries.

  my Int $index = 0;
  while my $nw = $lb.get-row-at-index($index) {
    my Gnome::Gtk3::ListBoxRow $row .= new(:widget($nw));
    my Gnome::Gtk3::Grid $grid .= new(:widget($row.get-child));
    my Gnome::Gtk3::CheckButton $check .=
       new(:widget($grid.get-child-at( 0, 0)));
    if $check.get-active {
      ...
    }
  }

Every check in this list looks the same, so it is useful to set a name on each of the check widgets. This name can then be retrieved within the handler or the code example above. If it is simple, like above, on can use the label text instead.

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Glib::List;
use Gnome::Gtk3::ListBoxRow;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklistbox.h
# https://developer.gnome.org/gtk3/stable/GtkListBox.html
unit class Gnome::Gtk3::ListBox:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<selected-rows-changed select-all unselect-all activate-cursor-row toggle-cursor-row activate>, :w1<row-selected row-activated>, :w2<move-cursor>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ListBox';

  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    self.set-native-object(gtk_list_box_new());
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

  else {#if ? %options<empty> {
    self.set-native-object(gtk_list_box_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkListBox');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_list_box_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkListBox');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_prepend:
=begin pod
=head2 [gtk_] list_box_prepend

Prepend a widget to the list. If a sort function is set, the widget will
actually be inserted at the calculated position and this function has the
same effect of C<gtk_container_add()>.

Since: 3.10

  method gtk_list_box_prepend ( N-GObject $child )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to add

=end pod

sub gtk_list_box_prepend ( N-GObject $box, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_insert:
=begin pod
=head2 [gtk_] list_box_insert

Insert the I<child> into the I<box> at I<position>. If a sort function is
set, the widget will actually be inserted at the calculated position and
this function has the same effect of C<gtk_container_add()>.

If I<position> is -1, or larger than the total number of items in the
I<box>, then the I<child> will be appended to the end.

Since: 3.10

  method gtk_list_box_insert ( N-GObject $child, Int $position )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to add
=item Int $position; the position to insert I<child> in

=end pod

sub gtk_list_box_insert ( N-GObject $box, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_selected_row:
=begin pod
=head2 [[gtk_] list_box_] get_selected_row

Gets the selected row.

Note that the box may allow multiple selection, in which
case you should use C<gtk_list_box_selected_foreach()> to
find all selected rows.

Returns: (transfer none): the selected row as a native ListBoxRow

Since: 3.10

  method gtk_list_box_get_selected_row ( --> N-GObject  )


=end pod

sub gtk_list_box_get_selected_row ( N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_box_get_row_at_index:
=begin pod
=head2 [[gtk_] list_box_] get_row_at_index

Gets the n-th child in the list (not counting headers).
If I<_index> is negative or larger than the number of items in the
list, C<Any> is returned.

Returns: a native ListBoxRow

Since: 3.10

  method gtk_list_box_get_row_at_index ( Int $index --> N-GObject  )

=item Int $index; the index of the row

=end pod

sub gtk_list_box_get_row_at_index ( N-GObject $box, int32 $index )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_row_at_y:
=begin pod
=head2 [[gtk_] list_box_] get_row_at_y

Gets the row at the I<y> position.

Returns: the row or C<Any> in case no row exists for the given y coordinate.

Since: 3.10

  method gtk_list_box_get_row_at_y ( Int $y --> N-GObject  )

=item Int $y; position

=end pod

sub gtk_list_box_get_row_at_y ( N-GObject $box, int32 $y )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_select_row:
=begin pod
=head2 [[gtk_] list_box_] select_row

Make I<row> the currently selected row.

Since: 3.10

  method gtk_list_box_select_row ( GtkListBoxRow $row )

=item GtkListBoxRow $row; (allow-none): The row to select or C<Any>

=end pod

sub gtk_list_box_select_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_placeholder:
=begin pod
=head2 [[gtk_] list_box_] set_placeholder

Sets the placeholder widget that is shown in the list when
it doesn't display any visible children.

Since: 3.10

  method gtk_list_box_set_placeholder ( N-GObject $placeholder )

=item N-GObject $placeholder; (allow-none): a B<Gnome::Gtk3::Widget> or C<Any>

=end pod

sub gtk_list_box_set_placeholder ( N-GObject $box, N-GObject $placeholder )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_adjustment:
=begin pod
=head2 [[gtk_] list_box_] set_adjustment

Sets the adjustment (if any) that the widget uses to
for vertical scrolling. For instance, this is used
to get the page size for PageUp/Down key handling.

In the normal case when the I<box> is packed inside
a B<Gnome::Gtk3::ScrolledWindow> the adjustment from that will
be picked up automatically, so there is no need
to manually do that.

Since: 3.10

  method gtk_list_box_set_adjustment ( N-GObject $adjustment )

=item N-GObject $adjustment; (allow-none): the adjustment, or C<Any>

=end pod

sub gtk_list_box_set_adjustment ( N-GObject $box, N-GObject $adjustment )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_adjustment:
=begin pod
=head2 [[gtk_] list_box_] get_adjustment

Gets the adjustment (if any) that the widget uses to
for vertical scrolling.

Returns: (transfer none): the adjustment

Since: 3.10

  method gtk_list_box_get_adjustment ( --> N-GObject  )


=end pod

sub gtk_list_box_get_adjustment ( N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_list_box_selected_foreach:
=begin pod
=head2 [[gtk_] list_box_] selected_foreach

Calls a function for each selected child. Note that the selection cannot be modified from within this function.

Since: 3.14

  method gtk_list_box_selected_foreach (
    $callback-object, Str $callback_name, *%user-options
  )

=item $callback-object; Object wherein the callback method is declared
=item Str $callback-name; Name of the callback method
=item %user-options; named arguments which will be provided to the callback

The callback method signature is

  method f (
    Gnome::Gtk3::ListBox $listbox, Gnome::Gtk3::GtkListRow $row,
    *%user-options
  )

=end pod
sub gtk_list_box_selected_foreach (
  N-GObject $box, Any:D $func-object, Str:D $func-name, *%user-options
) {
  if $func-object.^can($func-name) {
    _gtk_list_box_selected_foreach(
      $box,
      sub ( $n-lb, $n-lbr, $d ) {
        CATCH { default { .message.note; .backtrace.concise.note } }
        $func-object."$func-name"(
          Gnome::Gtk3::ListBox.new(:native-object($n-lb)),
          Gnome::Gtk3::ListBoxRow.new(:native-object($n-lbr)),
          |%user-options
        )
      },
      OpaquePointer
    );
  }

  else {
    note "Method $func-name not found in object $func-object.perl()"
      if $Gnome::N::x-debug;
  }
}

sub _gtk_list_box_selected_foreach (
  N-GObject $box,
  Callable $callback (
    N-GObject $n-listbox, N-GObject $n-listboxrow, OpaquePointer $d
  ),
  OpaquePointer $user_data
) is native(&gtk-lib)
  is symbol('gtk_list_box_selected_foreach')
  { * }


#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_selected_rows:
=begin pod
=head2 [[gtk_] list_box_] get_selected_rows

Creates a list of all selected children.

Returns: (element-type B<Gnome::Gtk3::ListBoxRow>) (transfer container):
A B<GList> containing the B<Gnome::Gtk3::Widget> for each selected child.
Free with C<g_list_free()> when done.

Since: 3.14

  method gtk_list_box_get_selected_rows ( --> N-GList  )


=end pod

sub gtk_list_box_get_selected_rows ( N-GObject $box )
  returns N-GList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_unselect_row:
=begin pod
=head2 [[gtk_] list_box_] unselect_row

Unselects a single row of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_unselect_row ( GtkListBoxRow $row )

=item GtkListBoxRow $row; the row to unselected

=end pod

sub gtk_list_box_unselect_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_select_all:
=begin pod
=head2 [[gtk_] list_box_] select_all

Select all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_select_all ( )


=end pod

sub gtk_list_box_select_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_unselect_all:
=begin pod
=head2 [[gtk_] list_box_] unselect_all

Unselect all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_unselect_all ( )


=end pod

sub gtk_list_box_unselect_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_selection_mode:
=begin pod
=head2 [[gtk_] list_box_] set_selection_mode

Sets how selection works in the listbox.
See B<Gnome::Gtk3::SelectionMode> for details.

Since: 3.10

  method gtk_list_box_set_selection_mode ( GtkSelectionMode $mode )

=item GtkSelectionMode $mode; The B<Gnome::Gtk3::SelectionMode>

=end pod

sub gtk_list_box_set_selection_mode ( N-GObject $box, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_selection_mode:
=begin pod
=head2 [[gtk_] list_box_] get_selection_mode

Gets the selection mode of the listbox.

Returns: a B<Gnome::Gtk3::SelectionMode>

Since: 3.10

  method gtk_list_box_get_selection_mode ( --> GtkSelectionMode  )


=end pod

sub gtk_list_box_get_selection_mode ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_filter_func:
=begin pod
=head2 [[gtk_] list_box_] set_filter_func

By setting a filter function on the I<box> one can decide dynamically which
of the rows to show. For instance, to implement a search function on a list that
filters the original list to only show the matching rows.

The I<filter_func> will be called for each row after the call, and it will
continue to be called each time a row changes (via C<gtk_list_box_row_changed()>) or
when C<gtk_list_box_invalidate_filter()> is called.

Note that using a filter function is incompatible with using a model
(see C<gtk_list_box_bind_model()>).

Since: 3.10

  method gtk_list_box_set_filter_func ( GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxFilterFunc $filter_func; (closure user_data) (allow-none): callback that lets you filter which rows to show
=item Pointer $user_data; user data passed to I<filter_func>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_filter_func ( N-GObject $box, GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_header_func:
=begin pod
=head2 [[gtk_] list_box_] set_header_func

By setting a header function on the I<box> one can dynamically add headers
in front of rows, depending on the contents of the row and its position in the list.
For instance, one could use it to add headers in front of the first item of a
new kind, in a list sorted by the kind.

The I<update_header> can look at the current header widget using C<gtk_list_box_row_get_header()>
and either update the state of the widget as needed, or set a new one using
C<gtk_list_box_row_set_header()>. If no header is needed, set the header to C<Any>.

Note that you may get many calls I<update_header> to this for a particular row when e.g.
changing things that don’t affect the header. In this case it is important for performance
to not blindly replace an existing header with an identical one.

The I<update_header> function will be called for each row after the call, and it will
continue to be called each time a row changes (via C<gtk_list_box_row_changed()>) and when
the row before changes (either by C<gtk_list_box_row_changed()> on the previous row, or when
the previous row becomes a different row). It is also called for all rows when
C<gtk_list_box_invalidate_headers()> is called.

Since: 3.10

  method gtk_list_box_set_header_func ( GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxUpdateHeaderFunc $update_header; (closure user_data) (allow-none): callback that lets you add row headers
=item Pointer $user_data; user data passed to I<update_header>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_header_func ( N-GObject $box, GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_invalidate_filter:
=begin pod
=head2 [[gtk_] list_box_] invalidate_filter

Update the filtering for all rows. Call this when result
of the filter function on the I<box> is changed due
to an external factor. For instance, this would be used
if the filter function just looked for a specific search
string and the entry with the search string has changed.

Since: 3.10

  method gtk_list_box_invalidate_filter ( )


=end pod

sub gtk_list_box_invalidate_filter ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_invalidate_sort:
=begin pod
=head2 [[gtk_] list_box_] invalidate_sort

Update the sorting for all rows. Call this when result
of the sort function on the I<box> is changed due
to an external factor.

Since: 3.10

  method gtk_list_box_invalidate_sort ( )


=end pod

sub gtk_list_box_invalidate_sort ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_invalidate_headers:
=begin pod
=head2 [[gtk_] list_box_] invalidate_headers

Update the separators for all rows. Call this when result
of the header function on the I<box> is changed due
to an external factor.

Since: 3.10

  method gtk_list_box_invalidate_headers ( )


=end pod

sub gtk_list_box_invalidate_headers ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_sort_func:
=begin pod
=head2 [[gtk_] list_box_] set_sort_func

By setting a sort function on the I<box> one can dynamically reorder the rows
of the list, based on the contents of the rows.

The I<sort_func> will be called for each row after the call, and will continue to
be called each time a row changes (via C<gtk_list_box_row_changed()>) and when
C<gtk_list_box_invalidate_sort()> is called.

Note that using a sort function is incompatible with using a model
(see C<gtk_list_box_bind_model()>).

Since: 3.10

  method gtk_list_box_set_sort_func ( GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxSortFunc $sort_func; (closure user_data) (allow-none): the sort function
=item Pointer $user_data; user data passed to I<sort_func>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_sort_func ( N-GObject $box, GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_set_activate_on_single_click:
=begin pod
=head2 [[gtk_] list_box_] set_activate_on_single_click

If I<single> is C<1>, rows will be activated when you click on them,
otherwise you need to double-click.

Since: 3.10

  method gtk_list_box_set_activate_on_single_click ( Int $single )

=item Int $single; a boolean

=end pod

sub gtk_list_box_set_activate_on_single_click ( N-GObject $box, int32 $single )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_get_activate_on_single_click:
=begin pod
=head2 [[gtk_] list_box_] get_activate_on_single_click

Returns whether rows activate on single clicks.

Returns: C<1> if rows are activated on single click, C<0> otherwise

Since: 3.10

  method gtk_list_box_get_activate_on_single_click ( --> Int  )


=end pod

sub gtk_list_box_get_activate_on_single_click ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_drag_unhighlight_row:
=begin pod
=head2 [[gtk_] list_box_] drag_unhighlight_row

If a row has previously been highlighted via C<gtk_list_box_drag_highlight_row()>
it will have the highlight removed.

Since: 3.10

  method gtk_list_box_drag_unhighlight_row ( )


=end pod

sub gtk_list_box_drag_unhighlight_row ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_drag_highlight_row:
=begin pod
=head2 [[gtk_] list_box_] drag_highlight_row

This is a helper function for implementing DnD onto a B<Gnome::Gtk3::ListBox>.
The passed in I<row> will be highlighted via C<gtk_drag_highlight()>,
and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets
a drag leave event.

Since: 3.10

  method gtk_list_box_drag_highlight_row ( GtkListBoxRow $row )

=item GtkListBoxRow $row; a B<Gnome::Gtk3::ListBoxRow>

=end pod

sub gtk_list_box_drag_highlight_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_list_box_new:new()
=begin pod
=head2 [gtk_] list_box_new

Creates a new B<Gnome::Gtk3::ListBox> container.

Returns: a new B<Gnome::Gtk3::ListBox>

Since: 3.10

  method gtk_list_box_new ( --> N-GObject  )


=end pod

sub gtk_list_box_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_list_box_bind_model:
=begin pod
=head2 [[gtk_] list_box_] bind_model

Binds I<model> to I<box>.

If I<box> was already bound to a model, that previous binding is
destroyed.

The contents of I<box> are cleared and then filled with widgets that
represent items from I<model>. I<box> is updated whenever I<model> changes.
If I<model> is C<Any>, I<box> is left empty.

It is undefined to add or remove widgets directly (for example, with
C<gtk_list_box_insert()> or C<gtk_container_add()>) while I<box> is bound to a
model.

Note that using a model is incompatible with the filtering and sorting
functionality in B<Gnome::Gtk3::ListBox>. When using a model, filtering and sorting
should be implemented by the model.

Since: 3.16

  method gtk_list_box_bind_model ( N-GList $model, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func )

=item N-GList $model; (nullable): the B<GListModel> to be bound to I<box>
=item GtkListBoxCreateWidgetFunc $create_widget_func; (nullable): a function that creates widgets for items or C<Any> in case you also passed C<Any> as I<model>
=item Pointer $user_data; user data passed to I<create_widget_func>
=item GDestroyNotify $user_data_free_func; function for freeing I<user_data>

=end pod

sub gtk_list_box_bind_model ( N-GObject $box, N-GList $model, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func )
  is native(&gtk-lib)
  { * }
}}

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


=comment #TS:0:row-selected:
=head3 row-selected

The I<row-selected> signal is emitted when a new row is selected, or
(with a C<Any> I<row>) when the selection is cleared.

When the I<box> is using B<GTK_SELECTION_MULTIPLE>, this signal will not
give you the full picture of selection changes, and you should use
the  I<selected-rows-changed> signal instead.

Since: 3.10

  method handler (
    N-GObject $row,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    *%user-options
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted
=item $row; the selected row, a native ListBoxRow


=comment #TS:0:selected-rows-changed:
=head3 selected-rows-changed

The I<selected-rows-changed> signal is emitted when the
set of selected rows changes.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    *%user-options
  );

=item $box; the B<Gnome::Gtk3::ListBox> on wich the signal is emitted


=comment #TS:0:select-all:
=head3 select-all

The I<select-all> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to select all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-a.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    *%user-options
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted


=comment #TS:0:unselect-all:
=head3 unselect-all

The I<unselect-all> signal is a keybinding signal
which gets emitted to unselect all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    *%user-options
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted


=comment #TS:0:row-activated:
=head3 row-activated

The I<row-activated> signal is emitted when a row has been activated by the user.

Since: 3.10

  method handler (
    N-GObject $row,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    *%user-options
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted
=item $row; the activated row, a native ListBoxRow


=comment #TS:0:activate-cursor-row:
=head3 activate-cursor-row

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($listbox),
    *%user-options
  );

=item $listbox; the B<Gnome::Gtk3::ListBox> on which the signal is emitted

=comment #TS:0:toggle-cursor-row:
=head3 toggle-cursor-row

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($listbox),
    *%user-options
  );

=item $listbox; object receiving the signal

=comment #TS:0:move-cursor:
=head3 move-cursor

  method handler (
    GtkMovementStep $arg1,
    Int $arg2,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($listbox),
    *%user-options
  );

=item $listbox; the B<Gnome::Gtk3::ListBox> on which the signal is emitted
=item $arg1; a GtkMovementStep
=item $arg2; ?

=comment #TS:0:activate:
=head3 activate

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($listbox),
    *%user-options
  );

=item $listbox;

=end pod
























=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] list_box_prepend

Prepend a widget to the list. If a sort function is set, the widget will
actually be inserted at the calculated position and this function has the
same effect of C<gtk_container_add()>.

Since: 3.10

  method gtk_list_box_prepend ( N-GObject $child )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to add

=end pod

sub gtk_list_box_prepend ( N-GObject $box, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] list_box_insert

Insert the I<child> into the I<box> at I<position>. If a sort function is
set, the widget will actually be inserted at the calculated position and
this function has the same effect of C<gtk_container_add()>.

If I<position> is -1, or larger than the total number of items in the
I<box>, then the I<child> will be appended to the end.

Since: 3.10

  method gtk_list_box_insert ( N-GObject $child, Int $position )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to add
=item Int $position; the position to insert I<child> in

=end pod

sub gtk_list_box_insert ( N-GObject $box, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_selected_row

Gets the selected row.

Note that the box may allow multiple selection, in which
case you should use C<gtk_list_box_selected_foreach()> to
find all selected rows.

Returns: (transfer none): the selected row

Since: 3.10

  method gtk_list_box_get_selected_row ( --> N-GObject  )


=end pod

sub gtk_list_box_get_selected_row ( N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_row_at_index

Gets the n-th child in the list (not counting headers).
If I<_index> is negative or larger than the number of items in the
list, C<Any> is returned.

Returns: (transfer none) (nullable): the child B<Gnome::Gtk3::Widget> or C<Any>

Since: 3.10

  method gtk_list_box_get_row_at_index ( Int $index_ --> N-GObject  )

=item Int $index_; the index of the row

=end pod

sub gtk_list_box_get_row_at_index ( N-GObject $box, int32 $index_ )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_row_at_y

Gets the row at the I<y> position.

Returns: (transfer none) (nullable): the row or C<Any>
in case no row exists for the given y coordinate.

Since: 3.10

  method gtk_list_box_get_row_at_y ( Int $y --> N-GObject  )

=item Int $y; position

=end pod

sub gtk_list_box_get_row_at_y ( N-GObject $box, int32 $y )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] select_row

Make I<row> the currently selected row.

Since: 3.10

  method gtk_list_box_select_row ( N-GObject $row )

=item N-GObject $row; (allow-none): The row to select or C<Any>

=end pod

sub gtk_list_box_select_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_placeholder

Sets the placeholder widget that is shown in the list when
it doesn't display any visible children.

Since: 3.10

  method gtk_list_box_set_placeholder ( N-GObject $placeholder )

=item N-GObject $placeholder; (allow-none): a B<Gnome::Gtk3::Widget> or C<Any>

=end pod

sub gtk_list_box_set_placeholder ( N-GObject $box, N-GObject $placeholder )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_adjustment

Sets the adjustment (if any) that the widget uses to
for vertical scrolling. For instance, this is used
to get the page size for PageUp/Down key handling.

In the normal case when the I<box> is packed inside
a B<Gnome::Gtk3::ScrolledWindow> the adjustment from that will
be picked up automatically, so there is no need
to manually do that.

Since: 3.10

  method gtk_list_box_set_adjustment ( N-GObject $adjustment )

=item N-GObject $adjustment; (allow-none): the adjustment, or C<Any>

=end pod

sub gtk_list_box_set_adjustment ( N-GObject $box, N-GObject $adjustment )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_adjustment

Gets the adjustment (if any) that the widget uses to
for vertical scrolling.

Returns: (transfer none): the adjustment

Since: 3.10

  method gtk_list_box_get_adjustment ( --> N-GObject  )


=end pod

sub gtk_list_box_get_adjustment ( N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] selected_foreach

Calls a function for each selected child.

Note that the selection cannot be modified from within this function.

Since: 3.14

  method gtk_list_box_selected_foreach ( GtkListBoxForeachFunc $func, Pointer $data )

=item GtkListBoxForeachFunc $func; (scope call): the function to call for each selected child
=item Pointer $data; user data to pass to the function

=end pod

sub gtk_list_box_selected_foreach ( N-GObject $box, GtkListBoxForeachFunc $func, Pointer $data )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_selected_rows

Creates a list of all selected children.

Returns: (element-type B<Gnome::Gtk3::ListBoxRow>) (transfer container):
A C<GList> containing the B<Gnome::Gtk3::Widget> for each selected child.
Free with C<g_list_free()> when done.

Since: 3.14

  method gtk_list_box_get_selected_rows ( --> N-GObject  )


=end pod

sub gtk_list_box_get_selected_rows ( N-GObject $box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] unselect_row

Unselects a single row of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_unselect_row ( N-GObject $row )

=item N-GObject $row; the row to unselected

=end pod

sub gtk_list_box_unselect_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] select_all

Select all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_select_all ( )


=end pod

sub gtk_list_box_select_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] unselect_all

Unselect all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_unselect_all ( )


=end pod

sub gtk_list_box_unselect_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_selection_mode

Sets how selection works in the listbox.
See B<Gnome::Gtk3::SelectionMode> for details.

Since: 3.10

  method gtk_list_box_set_selection_mode ( GtkSelectionMode $mode )

=item GtkSelectionMode $mode; The B<Gnome::Gtk3::SelectionMode>

=end pod

sub gtk_list_box_set_selection_mode ( N-GObject $box, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_selection_mode

Gets the selection mode of the listbox.

Returns: a B<Gnome::Gtk3::SelectionMode>

Since: 3.10

  method gtk_list_box_get_selection_mode ( --> GtkSelectionMode  )


=end pod

sub gtk_list_box_get_selection_mode ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_filter_func

By setting a filter function on the I<box> one can decide dynamically which
of the rows to show. For instance, to implement a search function on a list that
filters the original list to only show the matching rows.

The I<filter_func> will be called for each row after the call, and it will
continue to be called each time a row changes (via C<gtk_list_box_row_changed()>) or
when C<gtk_list_box_invalidate_filter()> is called.

Note that using a filter function is incompatible with using a model
(see C<gtk_list_box_bind_model()>).

Since: 3.10

  method gtk_list_box_set_filter_func ( GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxFilterFunc $filter_func; (closure user_data) (allow-none): callback that lets you filter which rows to show
=item Pointer $user_data; user data passed to I<filter_func>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_filter_func ( N-GObject $box, GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_header_func

By setting a header function on the I<box> one can dynamically add headers
in front of rows, depending on the contents of the row and its position in the list.
For instance, one could use it to add headers in front of the first item of a
new kind, in a list sorted by the kind.

The I<update_header> can look at the current header widget using C<gtk_list_box_row_get_header()>
and either update the state of the widget as needed, or set a new one using
C<gtk_list_box_row_set_header()>. If no header is needed, set the header to C<Any>.

Note that you may get many calls I<update_header> to this for a particular row when e.g.
changing things that don’t affect the header. In this case it is important for performance
to not blindly replace an existing header with an identical one.

The I<update_header> function will be called for each row after the call, and it will
continue to be called each time a row changes (via C<gtk_list_box_row_changed()>) and when
the row before changes (either by C<gtk_list_box_row_changed()> on the previous row, or when
the previous row becomes a different row). It is also called for all rows when
C<gtk_list_box_invalidate_headers()> is called.

Since: 3.10

  method gtk_list_box_set_header_func ( GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxUpdateHeaderFunc $update_header; (closure user_data) (allow-none): callback that lets you add row headers
=item Pointer $user_data; user data passed to I<update_header>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_header_func ( N-GObject $box, GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] invalidate_filter

Update the filtering for all rows. Call this when result
of the filter function on the I<box> is changed due
to an external factor. For instance, this would be used
if the filter function just looked for a specific search
string and the entry with the search string has changed.

Since: 3.10

  method gtk_list_box_invalidate_filter ( )


=end pod

sub gtk_list_box_invalidate_filter ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] invalidate_sort

Update the sorting for all rows. Call this when result
of the sort function on the I<box> is changed due
to an external factor.

Since: 3.10

  method gtk_list_box_invalidate_sort ( )


=end pod

sub gtk_list_box_invalidate_sort ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] invalidate_headers

Update the separators for all rows. Call this when result
of the header function on the I<box> is changed due
to an external factor.

Since: 3.10

  method gtk_list_box_invalidate_headers ( )


=end pod

sub gtk_list_box_invalidate_headers ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_sort_func

By setting a sort function on the I<box> one can dynamically reorder the rows
of the list, based on the contents of the rows.

The I<sort_func> will be called for each row after the call, and will continue to
be called each time a row changes (via C<gtk_list_box_row_changed()>) and when
C<gtk_list_box_invalidate_sort()> is called.

Note that using a sort function is incompatible with using a model
(see C<gtk_list_box_bind_model()>).

Since: 3.10

  method gtk_list_box_set_sort_func ( GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy )

=item GtkListBoxSortFunc $sort_func; (closure user_data) (allow-none): the sort function
=item Pointer $user_data; user data passed to I<sort_func>
=item GDestroyNotify $destroy; destroy notifier for I<user_data>

=end pod

sub gtk_list_box_set_sort_func ( N-GObject $box, GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] set_activate_on_single_click

If I<single> is C<1>, rows will be activated when you click on them,
otherwise you need to double-click.

Since: 3.10

  method gtk_list_box_set_activate_on_single_click ( Int $single )

=item Int $single; a boolean

=end pod

sub gtk_list_box_set_activate_on_single_click ( N-GObject $box, int32 $single )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] get_activate_on_single_click

Returns whether rows activate on single clicks.

Returns: C<1> if rows are activated on single click, C<0> otherwise

Since: 3.10

  method gtk_list_box_get_activate_on_single_click ( --> Int  )


=end pod

sub gtk_list_box_get_activate_on_single_click ( N-GObject $box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] drag_unhighlight_row

If a row has previously been highlighted via C<gtk_list_box_drag_highlight_row()>
it will have the highlight removed.

Since: 3.10

  method gtk_list_box_drag_unhighlight_row ( )


=end pod

sub gtk_list_box_drag_unhighlight_row ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] drag_highlight_row

This is a helper function for implementing DnD onto a B<Gnome::Gtk3::ListBox>.
The passed in I<row> will be highlighted via C<gtk_drag_highlight()>,
and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets
a drag leave event.

Since: 3.10

  method gtk_list_box_drag_highlight_row ( N-GObject $row )

=item N-GObject $row; a B<Gnome::Gtk3::ListBoxRow>

=end pod

sub gtk_list_box_drag_highlight_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] list_box_new

Creates a new B<Gnome::Gtk3::ListBox> container.

Returns: a new B<Gnome::Gtk3::ListBox>

Since: 3.10

  method gtk_list_box_new ( --> N-GObject  )


=end pod

sub gtk_list_box_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] list_box_] bind_model

Binds I<model> to I<box>.

If I<box> was already bound to a model, that previous binding is
destroyed.

The contents of I<box> are cleared and then filled with widgets that
represent items from I<model>. I<box> is updated whenever I<model> changes.
If I<model> is C<Any>, I<box> is left empty.

It is undefined to add or remove widgets directly (for example, with
C<gtk_list_box_insert()> or C<gtk_container_add()>) while I<box> is bound to a
model.

Note that using a model is incompatible with the filtering and sorting
functionality in B<Gnome::Gtk3::ListBox>. When using a model, filtering and sorting
should be implemented by the model.

Since: 3.16

  method gtk_list_box_bind_model ( N-GObject $model, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func )

=item N-GObject $model; (nullable): the C<GListModel> to be bound to I<box>
=item GtkListBoxCreateWidgetFunc $create_widget_func; (nullable): a function that creates widgets for items or C<Any> in case you also passed C<Any> as I<model>
=item Pointer $user_data; user data passed to I<create_widget_func>
=item GDestroyNotify $user_data_free_func; function for freeing I<user_data>

=end pod

sub gtk_list_box_bind_model ( N-GObject $box, N-GObject $model, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Not yet implemented methods

=head2 method gtk_list_box_selected_foreach ( ... )
gtk_list_box_set_filter_func
gtk_list_box_set_header_func
gtk_list_box_set_sort_func
gtk_list_box_bind_model

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 activate

This is a keybinding signal, which will cause this row to be activated.

If you want to be notified when the user activates a row (by key or not), use the “row-activated” signal on the row’s parent GtkListBox.

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on wich the signal is emitted

=head3 activate-cursor-row

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on wich the signal is emitted

=head3 selected-rows-changed

The sig I<selected-rows-changed> signal is emitted when the
set of selected rows changes.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on wich the signal is emitted


=head3 select-all

The sig I<select-all> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to select all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-a.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted


=head3 unselect-all

The sig I<unselect-all> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to unselect all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

Since: 3.14

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted

=head3 toggle-cursor-row

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on which the signal is emitted

=head3 row-selected

The sig I<row-selected> signal is emitted when a new row is selected, or
(with a C<Any> I<row>) when the selection is cleared.

When the I<box> is using C<GTK_SELECTION_MULTIPLE>, this signal will not
give you the full picture of selection changes, and you should use
the sig C<selected-rows-changed> signal instead.

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :handler-arg0($row),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox>

=item $row; (nullable): the selected row

=head3 row-activated

The sig I<row-activated> signal is emitted when a row has been activated by the user.

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    :handler-arg0($row),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox>

=item $row; the activated row

=begin comment
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals


=head3 move-cursor

Since: 3.10

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($box),
    GtkMovementStep :handler-arg0($arg1),
    Int :handler-arg1($arg2),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the B<Gnome::Gtk3::ListBox> on wich the signal is emitted




=end pod












=finish
#-------------------------------------------------------------------------------
sub gtk_list_box_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_list_box_insert ( N-GObject $box, N-GObject $child, int32 $position)
  is native(&gtk-lib)
  { * }

# The widget in the argument list is a GtkListBox
# returned widget is a GtkListBoxRow
sub gtk_list_box_get_row_at_index ( N-GObject $box, int32 $index)
  returns N-GObject
  is native(&gtk-lib)
  { * }
