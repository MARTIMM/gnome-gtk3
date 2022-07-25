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


=head2 B<Gnome::Gtk3::ListBox> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::ListBox> implementation of the B<Gnome::Gtk3::Buildable> interface supports setting a child as the placeholder by specifying “placeholder” as the “type” attribute of a <child> element. See C<set-placeholder()> for info.


=head2 Css Nodes

B<Gnome::Gtk3::ListBox> uses a single CSS node with name list. B<Gnome::Gtk3::ListBoxRow> uses a single CSS node with name row. The row nodes get the .activatable style class added when appropriate.


=head2 See Also

B<Gnome::Gtk3::ScrolledWindow>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ListBox;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Buildable;


=comment head2 Uml Diagram

=comment ![](plantuml/ListBox.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ListBox;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ListBox;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ListBox class process the options
    self.bless( :GtkListBox, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }



=head2 Example

Create a ListBox with one row. This row is a grid holding a CheckBox and Label.

  my Gnome::Gtk3::ListBox $lb .= new;

  # The widgets
  my Gnome::Gtk3::CheckButton $check .= new(:label('bold'));
  my Gnome::Gtk3::Label $label .= new(:text('Turn on bold font'));

  # Add the widgets to the Grid
  my Gnome::Gtk3::Grid $grid .= new;
  $grid.attach( $check, 0, 0, 1, 1);
  $grid.attach( $label, 1, 0, 1, 1);

  # Add the Grid to the ListBox
  $lb.add($grid);

To check its values one can register signals on each important widget (e.g. C<$check> in this case) or read the listbox entries.

  my Int $index = 0;
  while my $nw = $lb.get-row-at-index($index) {
    my Gnome::Gtk3::ListBoxRow() $row = $nw;
    my Gnome::Gtk3::Grid $grid() = $row.get-child;
    my Gnome::Gtk3::CheckButton() $check = $grid.get-child-at( 0, 0);
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
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::List;

use Gnome::Gtk3::ListBoxRow;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Enums;

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

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<selected-rows-changed select-all unselect-all activate-cursor-row toggle-cursor-row activate>, :w1<row-selected row-activated>, :w2<move-cursor>,
  ) unless $signals-added;


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ListBox' or %options<GtkListBox> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my N-GObject() $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_list_box_new___x___($no);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_list_box_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkListBox');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_list_box_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_list_box_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('list-box-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          $native-sub, $new-patt.subst('gtk-list-box-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkListBox');
  $s = callsame unless ?$s;

  $s;
}

#`{{
#-------------------------------------------------------------------------------
#TM:0:bind-model:
=begin pod
=head2 bind-model

Binds I<model> to I<box>.

If I<box> was already bound to a model, that previous binding is destroyed.

The contents of I<box> are cleared and then filled with widgets that represent items from I<model>. I<box> is updated whenever I<model> changes. If I<model> is C<undefined>, I<box> is left empty.

It is undefined to add or remove widgets directly (for example, with C<insert()> or C<gtk_container_add()>) while I<box> is bound to a model.

Note that using a model is incompatible with the filtering and sorting functionality in GtkListBox. When using a model, filtering and sorting should be implemented by the model.

  method bind-model ( N-GList $model, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func )

=item $model; the B<Gnome::Gio::ListModel> to be bound to I<box>
=item $create_widget_func; a function that creates widgets for items or C<undefined> in case you also passed C<undefined> as I<model>
=item $user_data; user data passed to I<create_widget_func>
=item $user_data_free_func; function for freeing I<user_data>
=end pod

method bind-model ( $model is copy, GtkListBoxCreateWidgetFunc $create_widget_func, Pointer $user_data, GDestroyNotify $user_data_free_func ) {
  $model .= _get-native-object-no-reffing unless $model ~~ N-GList;
  gtk_list_box_bind_model( self._get-native-object-no-reffing, $model, $create_widget_func, $user_data, $user_data_free_func);
}

sub gtk_list_box_bind_model (
  N-GObject $box, N-GList $model, GtkListBoxCreateWidgetFunc $create_widget_func, gpointer $user_data, GDestroyNotify $user_data_free_func
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:drag-highlight-row:
=begin pod
=head2 drag-highlight-row

This is a helper function for implementing DnD onto a B<Gnome::Gtk3::ListBox>. The passed in I<row> will be highlighted via C<gtk_drag_highlight()>, and any previously highlighted row will be unhighlighted.

The row will also be unhighlighted when the widget gets a drag leave event.

  method drag-highlight-row ( N-GObject() $row )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method drag-highlight-row ( N-GObject() $row ) {
  gtk_list_box_drag_highlight_row( self._get-native-object-no-reffing, $row);
}

sub gtk_list_box_drag_highlight_row (
  N-GObject $box, N-GObject $row
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:drag-unhighlight-row:
=begin pod
=head2 drag-unhighlight-row

If a row has previously been highlighted via C<drag_highlight_row()> it will have the highlight removed.

  method drag-unhighlight-row ( )

=end pod

method drag-unhighlight-row ( ) {
  gtk_list_box_drag_unhighlight_row(self._get-native-object-no-reffing);
}

sub gtk_list_box_drag_unhighlight_row (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-activate-on-single-click:
=begin pod
=head2 get-activate-on-single-click

Returns whether rows activate on single clicks.

Returns: C<True> if rows are activated on single click, C<False> otherwise

  method get-activate-on-single-click ( --> Bool )

=end pod

method get-activate-on-single-click ( --> Bool ) {
  gtk_list_box_get_activate_on_single_click( self._get-native-object-no-reffing).Bool
}

sub gtk_list_box_get_activate_on_single_click (
  N-GObject $box --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-adjustment:
=begin pod
=head2 get-adjustment

Gets the adjustment (if any) that the widget uses to for vertical scrolling.

Returns: the adjustment

  method get-adjustment ( --> N-GObject )

=end pod

method get-adjustment ( --> N-GObject ) {
  gtk_list_box_get_adjustment( self._get-native-object-no-reffing)
}

sub gtk_list_box_get_adjustment (
  N-GObject $box --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-row-at-index:
=begin pod
=head2 get-row-at-index

Gets the n-th child in the list (not counting headers). If I<_index> is negative or larger than the number of items in the list, C<undefined> is returned.

Returns: the child B<Gnome::Gtk3::Widget> or C<undefined>

  method get-row-at-index ( Int() $index --> N-GObject )

=item $index; the index of the row
=end pod

method get-row-at-index ( Int() $index --> N-GObject ) {
  gtk_list_box_get_row_at_index( self._get-native-object-no-reffing, $index)
}

sub gtk_list_box_get_row_at_index (
  N-GObject $box, gint $index --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-row-at-y:
=begin pod
=head2 get-row-at-y

Gets the row at the I<y> position.

Returns: the row or C<undefined> in case no row exists for the given y coordinate.

  method get-row-at-y ( Int() $y --> N-GObject )

=item $y; position
=end pod

method get-row-at-y ( Int() $y --> N-GObject ) {
  gtk_list_box_get_row_at_y( self._get-native-object-no-reffing, $y)
}

sub gtk_list_box_get_row_at_y (
  N-GObject $box, gint $y --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selected-row:
=begin pod
=head2 get-selected-row

Gets the selected row.

Note that the box may allow multiple selection, in which case you should use C<selected_foreach()> to find all selected rows.

Returns: the selected row

  method get-selected-row ( --> N-GObject )

=end pod

method get-selected-row ( --> N-GObject ) {
  gtk_list_box_get_selected_row( self._get-native-object-no-reffing)
}

sub gtk_list_box_get_selected_row (
  N-GObject $box --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selected-rows:
=begin pod
=head2 get-selected-rows

Creates a list of all selected children.

Returns: A B<Gnome::Gio::List> containing the B<Gnome::Gtk3::Widget> for each selected child. Free with C<clear-object()> when done.

  method get-selected-rows ( --> N-GList )

=end pod

method get-selected-rows ( --> N-GList ) {
  gtk_list_box_get_selected_rows( self._get-native-object-no-reffing)
}

sub gtk_list_box_get_selected_rows (
  N-GObject $box --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selection-mode:
=begin pod
=head2 get-selection-mode

Gets the selection mode of the listbox.

Returns: a B<Gnome::Gtk3::SelectionMode>

  method get-selection-mode ( --> GtkSelectionMode )

=end pod

method get-selection-mode ( --> GtkSelectionMode ) {
  GtkSelectionMode(
    gtk_list_box_get_selection_mode( self._get-native-object-no-reffing)
  )
}

sub gtk_list_box_get_selection_mode (
  N-GObject $box --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:insert:
=begin pod
=head2 insert

Insert the I<child> into the I<box> at I<position>. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of C<gtk_container_add()>.

If I<position> is -1, or larger than the total number of items in the I<box>, then the I<child> will be appended to the end.

  method insert ( N-GObject() $child, Int() $position )

=item $child; the B<Gnome::Gtk3::Widget> to add
=item $position; the position to insert I<child> in
=end pod

method insert ( N-GObject() $child, Int() $position ) {
  gtk_list_box_insert( self._get-native-object-no-reffing, $child, $position);
}

sub gtk_list_box_insert (
  N-GObject $box, N-GObject $child, gint $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:invalidate-filter:
=begin pod
=head2 invalidate-filter

Update the filtering for all rows. Call this when result of the filter function on the I<box> is changed due to an external factor. For instance, this would be used if the filter function just looked for a specific search string and the entry with the search string has changed.

  method invalidate-filter ( )

=end pod

method invalidate-filter ( ) {
  gtk_list_box_invalidate_filter(self._get-native-object-no-reffing);
}

sub gtk_list_box_invalidate_filter (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:invalidate-headers:
=begin pod
=head2 invalidate-headers

Update the separators for all rows. Call this when result of the header function on the I<box> is changed due to an external factor.

  method invalidate-headers ( )

=end pod

method invalidate-headers ( ) {
  gtk_list_box_invalidate_headers(self._get-native-object-no-reffing);
}

sub gtk_list_box_invalidate_headers (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:invalidate-sort:
=begin pod
=head2 invalidate-sort

Update the sorting for all rows. Call this when result of the sort function on the I<box> is changed due to an external factor.

  method invalidate-sort ( )

=end pod

method invalidate-sort ( ) {
  gtk_list_box_invalidate_sort(self._get-native-object-no-reffing);
}

sub gtk_list_box_invalidate_sort (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:prepend:
=begin pod
=head2 prepend

Prepend a widget to the list. If a sort function is set, the widget will actually be inserted at the calculated position and this function has the same effect of C<gtk_container_add()>.

  method prepend ( N-GObject() $child )

=item $child; the B<Gnome::Gtk3::Widget> to add
=end pod

method prepend ( N-GObject() $child ) {
  gtk_list_box_prepend( self._get-native-object-no-reffing, $child);
}

sub gtk_list_box_prepend (
  N-GObject $box, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-changed:
=begin pod
=head2 row-changed

Marks I<row> as changed, causing any state that depends on this to be updated. This affects sorting, filtering and headers.

Note that calls to this method must be in sync with the data used for the row functions. For instance, if the list is mirroring some external data set, and *two* rows changed in the external data set then when you call C<row_changed()> on the first row the sort function must only read the new data for the first of the two changed rows, otherwise the resorting of the rows will be wrong.

This generally means that if you don’t fully control the data model you have to duplicate the data that affects the listbox row functions into the row widgets themselves. Another alternative is to call C<invalidate_sort()> on any model change, but that is more expensive.

  method row-changed ( N-GObject() $row )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-changed ( N-GObject() $row ) {
  gtk_list_box_row_changed( self._get-native-object-no-reffing, $row);
}

sub gtk_list_box_row_changed (
  N-GObject $row
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-get-activatable:
=begin pod
=head2 row-get-activatable

Gets the value of the I<activatable from Gnome::Gtk3::ListBoxRow> property for this row.

Returns: C<True> if the row is activatable

  method row-get-activatable ( N-GObject() $row --> Bool )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-get-activatable ( N-GObject() $row --> Bool ) {
  gtk_list_box_row_get_activatable( self._get-native-object-no-reffing, $row).Bool
}

sub gtk_list_box_row_get_activatable (
  N-GObject $row --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-get-header:
=begin pod
=head2 row-get-header

Returns the current header of the I<row>. This can be used in a B<Gnome::Gtk3::ListBoxUpdateHeaderFunc> to see if there is a header set already, and if so to update the state of it.

Returns: the current header, or C<undefined> if none

  method row-get-header ( N-GObject() $row --> N-GObject )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-get-header ( N-GObject() $row --> N-GObject ) {
  gtk_list_box_row_get_header( self._get-native-object-no-reffing, $row)
}

sub gtk_list_box_row_get_header (
  N-GObject $row --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-get-index:
=begin pod
=head2 row-get-index

Gets the current index of the I<row> in its B<Gnome::Gtk3::ListBox> container.

Returns: the index of the I<row>, or -1 if the I<row> is not in a listbox

  method row-get-index ( N-GObject() $row --> Int )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-get-index ( N-GObject() $row --> Int ) {
  gtk_list_box_row_get_index( self._get-native-object-no-reffing, $row)
}

sub gtk_list_box_row_get_index (
  N-GObject $row --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-get-selectable:
=begin pod
=head2 row-get-selectable

Gets the value of the I<selectable from Gnome::Gtk3::ListBoxRow> property for this row.

Returns: C<True> if the row is selectable

  method row-get-selectable ( N-GObject() $row --> Bool )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-get-selectable ( N-GObject() $row --> Bool ) {
  gtk_list_box_row_get_selectable( self._get-native-object-no-reffing, $row).Bool
}

sub gtk_list_box_row_get_selectable (
  N-GObject $row --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-is-selected:
=begin pod
=head2 row-is-selected

Returns whether the child is currently selected in its B<Gnome::Gtk3::ListBox> container.

Returns: C<True> if I<row> is selected

  method row-is-selected ( N-GObject() $row --> Bool )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=end pod

method row-is-selected ( N-GObject() $row --> Bool ) {
  gtk_list_box_row_is_selected( self._get-native-object-no-reffing, $row).Bool
}

sub gtk_list_box_row_is_selected (
  N-GObject $row --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-new:
=begin pod
=head2 row-new

Creates a new B<Gnome::Gtk3::ListBoxRow>, to be used as a child of a B<Gnome::Gtk3::ListBox>.

Returns: a new B<Gnome::Gtk3::ListBoxRow>

  method row-new ( --> N-GObject )

=end pod

method row-new ( --> N-GObject ) {
  gtk_list_box_row_new( self._get-native-object-no-reffing)
}

sub gtk_list_box_row_new (
   --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-set-activatable:
=begin pod
=head2 row-set-activatable

Set the I<activatable from Gnome::Gtk3::ListBoxRow> property for this row.

  method row-set-activatable ( N-GObject() $row, Bool $activatable )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=item $activatable; C<True> to mark the row as activatable
=end pod

method row-set-activatable ( N-GObject() $row, Bool $activatable ) {
  gtk_list_box_row_set_activatable( self._get-native-object-no-reffing, $row, $activatable);
}

sub gtk_list_box_row_set_activatable (
  N-GObject $row, gboolean $activatable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-set-header:
=begin pod
=head2 row-set-header

Sets the current header of the I<row>. This is only allowed to be called from a B<Gnome::Gtk3::ListBoxUpdateHeaderFunc>. It will replace any existing header in the row, and be shown in front of the row in the listbox.

  method row-set-header ( N-GObject() $row, N-GObject() $header )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=item $header; the header, or C<undefined>
=end pod

method row-set-header ( N-GObject() $row, N-GObject() $header ) {
  gtk_list_box_row_set_header( self._get-native-object-no-reffing, $row, $header);
}

sub gtk_list_box_row_set_header (
  N-GObject $row, N-GObject $header
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:row-set-selectable:
=begin pod
=head2 row-set-selectable

Set the I<selectable from Gnome::Gtk3::ListBoxRow> property for this row.

  method row-set-selectable ( N-GObject() $row, Bool $selectable )

=item $row; a B<Gnome::Gtk3::ListBoxRow>
=item $selectable; C<True> to mark the row as selectable
=end pod

method row-set-selectable ( N-GObject() $row, Bool $selectable ) {
  gtk_list_box_row_set_selectable( self._get-native-object-no-reffing, $row, $selectable);
}

sub gtk_list_box_row_set_selectable (
  N-GObject $row, gboolean $selectable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-all:
=begin pod
=head2 select-all

Select all children of I<box>, if the selection mode allows it.

  method select-all ( )

=end pod

method select-all ( ) {
  gtk_list_box_select_all( self._get-native-object-no-reffing);
}

sub gtk_list_box_select_all (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-row:
=begin pod
=head2 select-row

Make I<row> the currently selected row.

  method select-row ( N-GObject() $row )

=item $row; The row to select or C<undefined>
=end pod

method select-row ( N-GObject() $row ) {
  gtk_list_box_select_row( self._get-native-object-no-reffing, $row);
}

sub gtk_list_box_select_row (
  N-GObject $box, N-GObject $row
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:selected-foreach:
=begin pod
=head2 selected-foreach

Calls a function for each selected child.

Note that the selection cannot be modified from within this function.

  method selected-foreach ( GtkListBoxForeachFunc $func, Pointer $data )

=item $func; (scope call): the function to call for each selected child
=item $data; user data to pass to the function
=end pod

method selected-foreach ( GtkListBoxForeachFunc $func, Pointer $data ) {
  gtk_list_box_selected_foreach( self._get-native-object-no-reffing, $func, $data);
}

sub gtk_list_box_selected_foreach (
  N-GObject $box, GtkListBoxForeachFunc $func, gpointer $data
) is native(&gtk-lib)
  { * }
}}


#-------------------------------------------------------------------------------
#TM:1:selected-foreach:
=begin pod
=head2 selected-foreach

Calls a function for each selected child. Note that the selection cannot be modified from within this function.

  method selected-foreach (
    $callback-object, Str $callback_name, *%user-options
  )

=item $callback-object; Object wherein the callback method is declared
=item $callback-name; Name of the callback method
=item %user-options; named arguments which will be provided to the callback

The callback method signature is

  method f (
    N-GObject $listbox, N-GObject $row, *%user-options
  )


=head3 Example

In the example below, the callback C<cb> has the native objects provided as C<N-GObject> coerced into B<Gnome::Gtk3::ListBox> and B<Gnome::Gtk3::ListBoxRow> using the C<()>.

  class X {
    method cb (
      Gnome::Gtk3::ListBox() $lbx, Gnome::Gtk3::ListBoxRow() $lbxr, :$test ) {
      is $lbx.widget-get-name(), 'GtkListBox', 'listbox';
      is $lbxr.widget-get-name(), 'N-GObject', 'listboxrow';
      is $test, 'abc', 'user option';
    }
  }

  $lb.selected-foreach( X.new, 'cb', :test<abc>);

=end pod

method selected-foreach (
  Any:D $func-object, Str:D $func-name, *%user-options
) {
  if $func-object.^can($func-name) {
    gtk_list_box_selected_foreach(
      self._f('GtkListBox'),
      sub ( $n-lb, $n-lbr, $d ) {
        CATCH { default { .message.note; .backtrace.concise.note } }

# TODO; after deprecation, the call to user function must be like
# $func-object."$func-name"( $n-lb, $n-lbr, |%user-options)
#
my Method $sh = $func-object.^lookup($func-name);
my @ps = $sh.signature.params;
#note 'foreach handler: ', @ps>>.type;
my ( $arg1, $arg2);
if @ps[1].type.^name ~~ /^ 'Gnome::Gtk3::ListBox(' .*? ')' $/ {
  $arg1 = $n-lb;
}

elsif @ps[1].type.^name ~~ /^ 'Gnome::Gtk3::ListBox' $/ {
  $arg1 = Gnome::Gtk3::ListBox.new(:native-object($n-lb));
  Gnome::N::deprecate(
    'arg type Gnome::Gtk3::ListBox in callback handler',
    'Gnome::Gtk3::ListBox()',
    '0.48.6', '0.50.0'
  );
}

else {
  $arg1 = $n-lb;
}


if @ps[2].type.^name ~~ /^ 'Gnome::Gtk3::ListBoxRow(' .*? ')' $/ {
  $arg2 = $n-lbr;
}

elsif @ps[2].type.^name ~~ /^ 'Gnome::Gtk3::ListBoxRow' $/ {
  $arg2 = Gnome::Gtk3::ListBoxRow.new(:native-object($n-lbr));
  Gnome::N::deprecate(
    'arg type Gnome::Gtk3::ListBoxRow in callback handler',
    'Gnome::Gtk3::ListBoxRow()',
    '0.48.6', '0.50.0'
  );
}

else {
  $arg2 = $n-lbr;
}

        $func-object."$func-name"(
          # $n-lb, $n-lbr,
          $arg1, $arg2,
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

sub gtk_list_box_selected_foreach (
  N-GObject $box,
  Callable $callback (
    N-GObject $n-listbox, N-GObject $n-listboxrow, OpaquePointer $d
  ),
  OpaquePointer $user_data
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-activate-on-single-click:
=begin pod
=head2 set-activate-on-single-click

If I<single> is C<True>, rows will be activated when you click on them, otherwise you need to double-click.

  method set-activate-on-single-click ( Bool $single )

=item $single; a boolean
=end pod

method set-activate-on-single-click ( Bool $single ) {
  gtk_list_box_set_activate_on_single_click( self._get-native-object-no-reffing, $single);
}

sub gtk_list_box_set_activate_on_single_click (
  N-GObject $box, gboolean $single
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-adjustment:
=begin pod
=head2 set-adjustment

Sets the adjustment (if any) that the widget uses to for vertical scrolling. For instance, this is used to get the page size for PageUp/Down key handling.

In the normal case when the I<box> is packed inside a B<Gnome::Gtk3::ScrolledWindow> the adjustment from that will be picked up automatically, so there is no need to manually do that.

  method set-adjustment ( N-GObject() $adjustment )

=item $adjustment; the adjustment, or C<undefined>
=end pod

method set-adjustment ( N-GObject() $adjustment ) {
  gtk_list_box_set_adjustment( self._get-native-object-no-reffing, $adjustment);
}

sub gtk_list_box_set_adjustment (
  N-GObject $box, N-GObject $adjustment
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-filter-func:
=begin pod
=head2 set-filter-func

By setting a filter function on the I<box> one can decide dynamically which of the rows to show. For instance, to implement a search function on a list that filters the original list to only show the matching rows.

The I<filter_func> will be called for each row after the call, and it will continue to be called each time a row changes (via C<row_changed()>) or when C<invalidate_filter()> is called.

Note that using a filter function is incompatible with using a model (see C<bind_model()>).

  method set-filter-func ( GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy )

=item $filter_func; (closure user_data) : callback that lets you filter which rows to show
=item $user_data; user data passed to I<filter_func>
=item $destroy; destroy notifier for I<user_data>
=end pod

method set-filter-func ( GtkListBoxFilterFunc $filter_func, Pointer $user_data, GDestroyNotify $destroy ) {
  gtk_list_box_set_filter_func( self._get-native-object-no-reffing, $filter_func, $user_data, $destroy);
}

sub gtk_list_box_set_filter_func (
  N-GObject $box, GtkListBoxFilterFunc $filter_func, gpointer $user_data, GDestroyNotify $destroy
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:set-header-func:
=begin pod
=head2 set-header-func

By setting a header function on the I<box> one can dynamically add headers in front of rows, depending on the contents of the row and its position in the list. For instance, one could use it to add headers in front of the first item of a new kind, in a list sorted by the kind.

The I<update_header> can look at the current header widget using C<row_get_header()> and either update the state of the widget as needed, or set a new one using C<row_set_header()>. If no header is needed, set the header to C<undefined>.

Note that you may get many calls I<update_header> to this for a particular row when e.g. changing things that don’t affect the header. In this case it is important for performance to not blindly replace an existing header with an identical one.

The I<update_header> function will be called for each row after the call, and it will continue to be called each time a row changes (via C<row_changed()>) and when the row before changes (either by C<row_changed()> on the previous row, or when the previous row becomes a different row). It is also called for all rows when C<invalidate_headers()> is called.

  method set-header-func ( GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy )

=item $update_header; (closure user_data) : callback that lets you add row headers
=item $user_data; user data passed to I<update_header>
=item $destroy; destroy notifier for I<user_data>
=end pod

method set-header-func ( GtkListBoxUpdateHeaderFunc $update_header, Pointer $user_data, GDestroyNotify $destroy ) {
  gtk_list_box_set_header_func( self._get-native-object-no-reffing, $update_header, $user_data, $destroy);
}

sub gtk_list_box_set_header_func (
  N-GObject $box, GtkListBoxUpdateHeaderFunc $update_header, gpointer $user_data, GDestroyNotify $destroy
) is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:set-placeholder:
=begin pod
=head2 set-placeholder

Sets the placeholder widget that is shown in the list when it doesn't display any visible children.

  method set-placeholder ( N-GObject() $placeholder )

=item $placeholder; a B<Gnome::Gtk3::Widget> or C<undefined>
=end pod

method set-placeholder ( N-GObject() $placeholder ) {
  gtk_list_box_set_placeholder(
    self._get-native-object-no-reffing, $placeholder
  );
}

sub gtk_list_box_set_placeholder (
  N-GObject $box, N-GObject $placeholder
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-selection-mode:
=begin pod
=head2 set-selection-mode

Sets how selection works in the listbox. See B<Gnome::Gtk3::SelectionMode> for details.

  method set-selection-mode ( GtkSelectionMode $mode )

=item $mode; The B<Gnome::Gtk3::SelectionMode>
=end pod

method set-selection-mode ( GtkSelectionMode $mode ) {
  gtk_list_box_set_selection_mode( self._get-native-object-no-reffing, $mode);
}

sub gtk_list_box_set_selection_mode (
  N-GObject $box, GEnum $mode
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-sort-func:
=begin pod
=head2 set-sort-func

By setting a sort function on the I<box> one can dynamically reorder the rows of the list, based on the contents of the rows.

The I<sort_func> will be called for each row after the call, and will continue to be called each time a row changes (via C<row_changed()>) and when C<invalidate_sort()> is called.

Note that using a sort function is incompatible with using a model (see C<bind_model()>).

  method set-sort-func ( GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy )

=item $sort_func; (closure user_data) : the sort function
=item $user_data; user data passed to I<sort_func>
=item $destroy; destroy notifier for I<user_data>
=end pod

method set-sort-func ( GtkListBoxSortFunc $sort_func, Pointer $user_data, GDestroyNotify $destroy ) {
  gtk_list_box_set_sort_func( self._get-native-object-no-reffing, $sort_func, $user_data, $destroy);
}

sub gtk_list_box_set_sort_func (
  N-GObject $box, GtkListBoxSortFunc $sort_func, gpointer $user_data, GDestroyNotify $destroy
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:unselect-all:
=begin pod
=head2 unselect-all

Unselect all children of I<box>, if the selection mode allows it.

  method unselect-all ( )

=end pod

method unselect-all ( ) {
  gtk_list_box_unselect_all(self._get-native-object-no-reffing);
}

sub gtk_list_box_unselect_all (
  N-GObject $box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-row:
=begin pod
=head2 unselect-row

Unselects a single row of I<box>, if the selection mode allows it.

  method unselect-row ( N-GObject() $row )

=item $row; the row to unselected
=end pod

method unselect-row ( N-GObject() $row ) {
  gtk_list_box_unselect_row( self._get-native-object-no-reffing, $row);
}

sub gtk_list_box_unselect_row (
  N-GObject $box, N-GObject $row
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_list_box_new:
#`{{
=begin pod
=head2 _gtk_list_box_new

Creates a new B<Gnome::Gtk3::ListBox> container.

Returns: a new B<Gnome::Gtk3::ListBox>

  method _gtk_list_box_new ( --> N-GObject )

=end pod
}}

sub _gtk_list_box_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_list_box_new')
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:activate:
=head2 activate

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:activate-cursor-row:
=head2 activate-cursor-row

This is a keybinding signal, which will cause this row to be activated.

If you want to be notified when the user activates a row (by key or not),
use the I<row-activated> signal on the row’s parent B<Gnome::Gtk3::ListBox>.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:move-cursor:
=head2 move-cursor

  method handler (
    GEnum $arg1,
    Int $arg2,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $arg1; a GtkMovementStep enumeration
=item $arg2; ? (no information)
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:row-activated:
=head2 row-activated

The I<row-activated> signal is emitted when a row has been activated by the user.

  method handler (
    N-GObject $row,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $row; the activated row, a native B<Gnome::Gtk3::ListBoxRow>
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:row-selected:
=head2 row-selected

The I<row-selected> signal is emitted when a new row is selected, or
(with a C<undefined> I<row>) when the selection is cleared.

When the I<box> is using B<Gnome::Gio::TK_SELECTION_MULTIPLE>, this signal will not
give you the full picture of selection changes, and you should use
the I<selected-rows-changed> signal instead.

  method handler (
    N-GObject $row,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $row; the selected row , a native B<Gnome::Gtk3::ListBoxRow>
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:select-all:
=head2 select-all

The I<select-all> signal is a keybinding signal which gets emitted to select all children of the box, if the selection mode permits it.

The default bindings for this signal is Ctrl-a.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:selected-rows-changed:
=head2 selected-rows-changed

The I<selected-rows-changed> signal is emitted when the set of selected rows changes.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:toggle-cursor-row:
=head2 toggle-cursor-row

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:unselect-all:
=head2 unselect-all

The I<unselect-all> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted to unselect all children of the box, if the selection
mode permits it.

The default bindings for this signal is Ctrl-Shift-a.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:activatable:
=head2 activatable

Whether this row can be activated

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:activate-on-single-click:
=head2 activate-on-single-click

Activate row on a single click

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:selectable:
=head2 selectable

Whether this row can be selected

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:selection-mode:
=head2 selection-mode

The selection mode

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_SELECTION_MODE
=item Parameter is readable and writable.
=item Default value is GTK_SELECTION_SINGLE.

=end pod

























=finish
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

  method gtk_list_box_select_row ( N-GObject $row )

=item N-GObject $row; (allow-none): The row to select or C<Any>

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
#TM:1:selected-foreach:
=begin pod
=head2 selected-foreach

Calls a function for each selected child. Note that the selection cannot be modified from within this function.

  method selected-foreach (
    $callback-object, Str $callback_name, *%user-options
  )

=item $callback-object; Object wherein the callback method is declared
=item $callback-name; Name of the callback method
=item %user-options; named arguments which will be provided to the callback

The callback method signature is

  method f (
    N-GObject $listbox, N-GObject $row, *%user-options
  )


=head3 Example

In the example below, the callback C<cb> has the native objects provided as C<N-GObject> coerced into B<Gnome::Gtk3::ListBox> and B<Gnome::Gtk3::ListBoxRow> using the C<()>.

  class X {
    method cb (
      Gnome::Gtk3::ListBox() $lbx, Gnome::Gtk3::ListBoxRow() $lbxr, :$test ) {
      is $lbx.widget-get-name(), 'GtkListBox', 'listbox';
      is $lbxr.widget-get-name(), 'N-GObject', 'listboxrow';
      is $test, 'abc', 'user option';
    }
  }

  $lb.selected-foreach( X.new, 'cb', :test<abc>);


=end pod
method selected-foreach (
  Any:D $func-object, Str:D $func-name, *%user-options
) {
  if $func-object.^can($func-name) {
    _gtk_list_box_selected_foreach(
      self._f('GtkListBox'),
      sub ( $n-lb, $n-lbr, $d ) {
        CATCH { default { .message.note; .backtrace.concise.note } }

# TODO; after deprecation, the call to user function must be like
# $func-object."$func-name"( $n-lb, $n-lbr, |%user-options)
#
my Method $sh = $func-object.^lookup($func-name);
my @ps = $sh.signature.params;
#note 'foreach handler: ', @ps>>.type;
my ( $arg1, $arg2);
if @ps[1].type.^name ~~ /^ 'Gnome::Gtk3::ListBox(' .*? ')' $/ {
  $arg1 = $n-lb;
}

elsif @ps[1].type.^name ~~ /^ 'Gnome::Gtk3::ListBox' $/ {
  $arg1 = Gnome::Gtk3::ListBox.new(:native-object($n-lb));
  Gnome::N::deprecate(
    'arg type Gnome::Gtk3::ListBox in callback handler',
    'Gnome::Gtk3::ListBox()',
    '0.48.6', '0.50.0'
  );
}

else {
  $arg1 = $n-lb;
}


if @ps[2].type.^name ~~ /^ 'Gnome::Gtk3::ListBoxRow(' .*? ')' $/ {
  $arg2 = $n-lbr;
}

elsif @ps[2].type.^name ~~ /^ 'Gnome::Gtk3::ListBoxRow' $/ {
  $arg2 = Gnome::Gtk3::ListBoxRow.new(:native-object($n-lbr));
  Gnome::N::deprecate(
    'arg type Gnome::Gtk3::ListBoxRow in callback handler',
    'Gnome::Gtk3::ListBoxRow()',
    '0.48.6', '0.50.0'
  );
}

else {
  $arg2 = $n-lbr;
}

        $func-object."$func-name"(
          # $n-lb, $n-lbr,
          $arg1, $arg2,
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

  method gtk_list_box_unselect_row ( N-GObject $row )

=item N-GObject $row; the row to unselected

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

  method gtk_list_box_drag_highlight_row ( N-GObject $row )

=item N-GObject $row; a B<Gnome::Gtk3::ListBoxRow>

=end pod

sub gtk_list_box_drag_highlight_row ( N-GObject $box, N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_list_box_new:
#`{{
=begin pod
=head2 _gtk_list_box_new

Creates a new B<Gnome::Gtk3::ListBox> container.

Returns: a new B<Gnome::Gtk3::ListBox>

  method _gtk_list_box_new ( --> N-GObject )

=end pod
}}

sub _gtk_list_box_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_list_box_new')
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
