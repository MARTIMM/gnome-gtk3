use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ListBox

![](images/list-box.png)

=SUBTITLE A list container

=head1 Description


A C<Gnome::Gtk3::ListBox> is a vertical container that contains C<Gnome::Gtk3::ListBoxRow> children. These rows can be dynamically sorted and filtered, and headers can be added dynamically depending on the row content. It also allows keyboard and mouse navigation and selection like a typical list.

Using C<Gnome::Gtk3::ListBox> is often an alternative to C<Gnome::Gtk3::TreeView>, especially when the list contents has a more complicated layout than what is allowed by a C<Gnome::Gtk3::CellRenderer>, or when the contents is interactive (i.e. has a button in it).

Although a C<Gnome::Gtk3::ListBox> must have only C<Gnome::Gtk3::ListBoxRow> children you can add any kind of widget to it via C<gtk_container_add()>, and a C<Gnome::Gtk3::ListBoxRow> widget will automatically be inserted between the list and the widget.

C<Gnome::Gtk3::ListBoxRows> can be marked as activatable or selectable. If a row is activatable, sig C<row-activated> will be emitted for it when the user tries to activate it. If it is selectable, the row will be marked as selected when the user tries to select it.

The C<Gnome::Gtk3::ListBox> widget was added in GTK+ 3.10.

=head2 Css Nodes

C<Gnome::Gtk3::ListBox> uses a single CSS node with name list. C<Gnome::Gtk3::ListBoxRow> uses a single CSS node with name row. The row nodes get the .activatable style class added when appropriate.

=head2 See Also

C<Gnome::Gtk3::ScrolledWindow>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ListBox;
  also is Gnome::Gtk3::Container;

=head2 Example

  # Create a ListBox with one row. This row is a grid holding a
  # CheckBox and Label.
  my Gnome::Gtk3::ListBox $lb .= new(:empty);

  # The widgets
  my Gnome::Gtk3::CheckButton $check .= new(:label('bold'));
  my Gnome::Gtk3::Label $label .= new(:label('Turn on bold font'));

  # Add the widgets to the Grid
  my Gnome::Gtk3::Grid $grid .= new(:empty);
  $grid.gtk-grid-attach( $check(), 0, 0, 1, 1);
  $grid.gtk-grid-attach( $label(), 1, 0, 1, 1);

  # Add the Grid to the ListBox
  $lb.gtk-container-add($grid);

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
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
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=begin comment
=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.
=end comment
=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<activate-cursor-row select-all selected-rows-changed
            toggle-cursor-row unselect-all activate
           >,
    :int2<move-cursor>,
    :nativewidget<row-activated row-selected>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ListBox';

  if ? %options<empty> {
    self.native-gobject(gtk_list_box_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkListBox');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_list_box_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkListBox');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_list_box_prepend

Prepend a widget to the list. If a sort function is set, the widget will
actually be inserted at the calculated position and this function has the
same effect of C<gtk_container_add()>.

Since: 3.10

  method gtk_list_box_prepend ( N-GObject $child )

=item N-GObject $child; the C<Gnome::Gtk3::Widget> to add

=end pod

sub gtk_list_box_prepend ( N-GObject $box, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_list_box_insert

Insert the I<child> into the I<box> at I<position>. If a sort function is
set, the widget will actually be inserted at the calculated position and
this function has the same effect of C<gtk_container_add()>.

If I<position> is -1, or larger than the total number of items in the
I<box>, then the I<child> will be appended to the end.

Since: 3.10

  method gtk_list_box_insert ( N-GObject $child, Int $position )

=item N-GObject $child; the C<Gnome::Gtk3::Widget> to add
=item Int $position; the position to insert I<child> in

=end pod

sub gtk_list_box_insert ( N-GObject $box, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_] get_selected_row

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
=head2 [gtk_list_box_] get_row_at_index

Gets the n-th child in the list (not counting headers).
If I<_index> is negative or larger than the number of items in the
list, C<Any> is returned.

Returns: (transfer none) (nullable): the child C<Gnome::Gtk3::Widget> or C<Any>

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
=head2 [gtk_list_box_] get_row_at_y

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
=head2 [gtk_list_box_] select_row

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
=head2 [gtk_list_box_] set_placeholder

Sets the placeholder widget that is shown in the list when
it doesn't display any visible children.

Since: 3.10

  method gtk_list_box_set_placeholder ( N-GObject $placeholder )

=item N-GObject $placeholder; (allow-none): a C<Gnome::Gtk3::Widget> or C<Any>

=end pod

sub gtk_list_box_set_placeholder ( N-GObject $box, N-GObject $placeholder )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_] set_adjustment

Sets the adjustment (if any) that the widget uses to
for vertical scrolling. For instance, this is used
to get the page size for PageUp/Down key handling.

In the normal case when the I<box> is packed inside
a C<Gnome::Gtk3::ScrolledWindow> the adjustment from that will
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
=head2 [gtk_list_box_] get_adjustment

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
=head2 [gtk_list_box_] selected_foreach

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
=head2 [gtk_list_box_] get_selected_rows

Creates a list of all selected children.

Returns: (element-type C<Gnome::Gtk3::ListBoxRow>) (transfer container):
A C<GList> containing the C<Gnome::Gtk3::Widget> for each selected child.
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
=head2 [gtk_list_box_] unselect_row

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
=head2 [gtk_list_box_] select_all

Select all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_select_all ( )


=end pod

sub gtk_list_box_select_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_] unselect_all

Unselect all children of I<box>, if the selection mode allows it.

Since: 3.14

  method gtk_list_box_unselect_all ( )


=end pod

sub gtk_list_box_unselect_all ( N-GObject $box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_] set_selection_mode

Sets how selection works in the listbox.
See C<Gnome::Gtk3::SelectionMode> for details.

Since: 3.10

  method gtk_list_box_set_selection_mode ( GtkSelectionMode $mode )

=item GtkSelectionMode $mode; The C<Gnome::Gtk3::SelectionMode>

=end pod

sub gtk_list_box_set_selection_mode ( N-GObject $box, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_] get_selection_mode

Gets the selection mode of the listbox.

Returns: a C<Gnome::Gtk3::SelectionMode>

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
=head2 [gtk_list_box_] set_filter_func

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
=head2 [gtk_list_box_] set_header_func

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
=head2 [gtk_list_box_] invalidate_filter

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
=head2 [gtk_list_box_] invalidate_sort

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
=head2 [gtk_list_box_] invalidate_headers

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
=head2 [gtk_list_box_] set_sort_func

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
=head2 [gtk_list_box_] set_activate_on_single_click

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
=head2 [gtk_list_box_] get_activate_on_single_click

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
=head2 [gtk_list_box_] drag_unhighlight_row

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
=head2 [gtk_list_box_] drag_highlight_row

This is a helper function for implementing DnD onto a C<Gnome::Gtk3::ListBox>.
The passed in I<row> will be highlighted via C<gtk_drag_highlight()>,
and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets
a drag leave event.

Since: 3.10

  method gtk_list_box_drag_highlight_row ( N-GObject $row )

=item N-GObject $row; a C<Gnome::Gtk3::ListBoxRow>

=end pod

sub gtk_list_box_drag_highlight_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_list_box_new

Creates a new C<Gnome::Gtk3::ListBox> container.

Returns: a new C<Gnome::Gtk3::ListBox>

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
=head2 [gtk_list_box_] bind_model

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
functionality in C<Gnome::Gtk3::ListBox>. When using a model, filtering and sorting
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

Register any signal as follows. See also C<Gnome::GObject::Object>.

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
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on wich the signal is emitted

=head3 activate-cursor-row

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on wich the signal is emitted

=head3 selected-rows-changed

The sig I<selected-rows-changed> signal is emitted when the
set of selected rows changes.

Since: 3.14

  method handler (
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on wich the signal is emitted


=head3 select-all

The sig I<select-all> signal is a [keybinding signal][C<Gnome::Gtk3::BindingSignal>]
which gets emitted to select all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-a.

Since: 3.14

  method handler (
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on which the signal is emitted


=head3 unselect-all

The sig I<unselect-all> signal is a [keybinding signal][C<Gnome::Gtk3::BindingSignal>]
which gets emitted to unselect all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

Since: 3.14

  method handler (
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on which the signal is emitted

=head3 toggle-cursor-row

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($box),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on which the signal is emitted

=head3 row-selected

The sig I<row-selected> signal is emitted when a new row is selected, or
(with a C<Any> I<row>) when the selection is cleared.

When the I<box> is using C<GTK_SELECTION_MULTIPLE>, this signal will not
give you the full picture of selection changes, and you should use
the sig C<selected-rows-changed> signal instead.

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($box),
    :handler-arg0($row),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox>

=item $row; (nullable): the selected row

=head3 row-activated

The sig I<row-activated> signal is emitted when a row has been activated by the user.

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($box),
    :handler-arg0($row),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox>

=item $row; the activated row

=begin comment
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals


=head3 move-cursor

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($box),
    GtkMovementStep :handler-arg0($arg1),
    Int :handler-arg1($arg2),
    :$user-option1, ..., :$user-optionN
  );

=item $box; the C<Gnome::Gtk3::ListBox> on wich the signal is emitted




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
