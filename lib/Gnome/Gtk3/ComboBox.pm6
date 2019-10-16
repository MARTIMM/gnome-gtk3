#TL:1:Gnome::Gtk3::ComboBox:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ComboBox

A widget used to choose from a list of items

![](images/combo-box.png)

=head1 Description

A B<Gnome::Gtk3::ComboBox> is a widget that allows the user to choose from a list of valid choices. The B<Gnome::Gtk3::ComboBox> displays the selected choice. When activated, the B<Gnome::Gtk3::ComboBox> displays a popup which allows the user to make a new choice. The style in which the selected value is displayed, and the style of the popup is determined by the current theme. It may be similar to a Windows-style combo box.

The B<Gnome::Gtk3::ComboBox> uses the model-view pattern; the list of valid choices is specified in the form of a tree model, and the display of the choices can be adapted to the data in the model by using cell renderers, as you would in a tree view. This is possible since B<Gnome::Gtk3::ComboBox> implements the B<Gnome::Gtk3::CellLayout> interface. The tree model holding the valid choices is not restricted to a flat list, it can be a real tree, and the popup will reflect the tree structure.

To allow the user to enter values not in the model, the “has-entry” property allows the B<Gnome::Gtk3::ComboBox> to contain a B<Gnome::Gtk3::Entry>. This entry can be accessed by calling C<gtk_bin_get_child()> on the combo box.

For a simple list of textual choices, the model-view API of B<Gnome::Gtk3::ComboBox> can be a bit overwhelming. In this case, B<Gnome::Gtk3::ComboBoxText> offers a simple alternative. Both B<Gnome::Gtk3::ComboBox> and B<Gnome::Gtk3::ComboBoxText> can contain an entry.

=head2 Css Nodes

  combobox
  ├── box.linked
  │   ╰── button.combo
  │       ╰── box
  │           ├── cellview
  │           ╰── arrow
  ╰── window.popup

A normal combobox contains a box with the .linked class, a button
with the .combo class and inside those buttons, there are a cellview and
an arrow.

  combobox
  ├── box.linked
  │   ├── entry.combo
  │   ╰── button.combo
  │       ╰── box
  │           ╰── arrow
  ╰── window.popup

A B<Gnome::Gtk3::ComboBox> with an entry has a single CSS node with name combobox. It contains a bx with the .linked class and that box contains an entry and a button, both with the .combo class added. The button also contains another node with name arrow.

=head2 Implemented Interfaces

Gnome::Gtk3::ComboBox implements
=comment item Gnome::AtkImplementorIface
=item Gnome::Gtk3::Buildable
=item Gnome::Gtk3::CellLayout
=item Gnome::Gtk3::CellEditable

=head2 See Also

B<Gnome::Gtk3::ComboBoxText>, B<Gnome::Gtk3::TreeModel>, B<Gnome::Gtk3::CellRenderer>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ComboBox;
  also is Gnome::Gtk3::Bin;

=head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ComboBox:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod
submethod BUILD ( *%options ) {

#TM:0:new():inheriting
#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<changed popup popdown>, :w1<move-active format-entry-text>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ComboBox';

  #TODO %options.keys ~~ any(<widget build-id id name>) { ... }
  if ? %options<empty> {
    self.native-gobject(gtk_combo_box_new());
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
  self.set-class-info('GtkComboBox');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_combo_box_$native-sub"); } unless ?$s;

  # search in the interface modules, name all interfaces which are implemented
  # for this module. not implemented ones are skipped.
  if !$s {
    $s = self._query_interfaces(
      $native-sub, <
        Gnome::Atk::ImplementorIface Gnome::Gtk3::Buildable
        Gnome::Gtk3::CellLayout Gnome::Gtk3::CellEditable
      >
    );
  }

  self.set-class-name-of-sub('GtkComboBox');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new:
=begin pod
=head2 gtk_combo_box_new

Creates a new empty B<Gnome::Gtk3::ComboBox>.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.4

  method gtk_combo_box_new ( --> N-GObject  )


=end pod

sub gtk_combo_box_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new_with_area:
=begin pod
=head2 [gtk_combo_box_] new_with_area

Creates a new empty B<Gnome::Gtk3::ComboBox> using I<area> to layout cells.

Returns: A new B<Gnome::Gtk3::ComboBox>.

  method gtk_combo_box_new_with_area ( N-GObject $area --> N-GObject  )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> to use to layout cell renderers

=end pod

sub gtk_combo_box_new_with_area ( N-GObject $area )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new_with_area_and_entry:
=begin pod
=head2 [gtk_combo_box_] new_with_area_and_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry.

The new combo box will use I<area> to layout cells.

Returns: A new B<Gnome::Gtk3::ComboBox>.

  method gtk_combo_box_new_with_area_and_entry ( N-GObject $area --> N-GObject  )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> to use to layout cell renderers

=end pod

sub gtk_combo_box_new_with_area_and_entry ( N-GObject $area )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new_with_entry:
=begin pod
=head2 [gtk_combo_box_] new_with_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.24

  method gtk_combo_box_new_with_entry ( --> N-GObject  )


=end pod

sub gtk_combo_box_new_with_entry (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new_with_model:
=begin pod
=head2 [gtk_combo_box_] new_with_model

Creates a new B<Gnome::Gtk3::ComboBox> with the model initialized to I<model>.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.4

  method gtk_combo_box_new_with_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; A B<Gnome::Gtk3::TreeModel>.

=end pod

sub gtk_combo_box_new_with_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_new_with_model_and_entry:
=begin pod
=head2 [gtk_combo_box_] new_with_model_and_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry
and with the model initialized to I<model>.

Returns: A new B<Gnome::Gtk3::ComboBox>

Since: 2.24

  method gtk_combo_box_new_with_model_and_entry ( N-GObject $model --> N-GObject  )

=item N-GObject $model; A B<Gnome::Gtk3::TreeModel>

=end pod

sub gtk_combo_box_new_with_model_and_entry ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_wrap_width:
=begin pod
=head2 [gtk_combo_box_] get_wrap_width

Returns the wrap width which is used to determine the number of columns
for the popup menu. If the wrap width is larger than 1, the combo box
is in table mode.

Returns: the wrap width.

Since: 2.6

  method gtk_combo_box_get_wrap_width ( --> Int  )


=end pod

sub gtk_combo_box_get_wrap_width ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_wrap_width:
=begin pod
=head2 [gtk_combo_box_] set_wrap_width

Sets the wrap width of I<combo_box> to be I<width>. The wrap width is basically
the preferred number of columns when you want the popup to be layed out
in a table.

Since: 2.4

  method gtk_combo_box_set_wrap_width ( Int $width )

=item Int $width; Preferred number of columns

=end pod

sub gtk_combo_box_set_wrap_width ( N-GObject $combo_box, int32 $width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_row_span_column:
=begin pod
=head2 [gtk_combo_box_] get_row_span_column

Returns the column with row span information for I<combo_box>.

Returns: the row span column.

Since: 2.6

  method gtk_combo_box_get_row_span_column ( --> Int  )


=end pod

sub gtk_combo_box_get_row_span_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_row_span_column:
=begin pod
=head2 [gtk_combo_box_] set_row_span_column

Sets the column with row span information for I<combo_box> to be I<row_span>.
The row span column contains integers which indicate how many rows
an item should span.

Since: 2.4

  method gtk_combo_box_set_row_span_column ( Int $row_span )

=item Int $row_span; A column in the model passed during construction.

=end pod

sub gtk_combo_box_set_row_span_column ( N-GObject $combo_box, int32 $row_span )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_column_span_column:
=begin pod
=head2 [gtk_combo_box_] get_column_span_column

Returns the column with column span information for I<combo_box>.

Returns: the column span column.

Since: 2.6

  method gtk_combo_box_get_column_span_column ( --> Int  )


=end pod

sub gtk_combo_box_get_column_span_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_column_span_column:
=begin pod
=head2 [gtk_combo_box_] set_column_span_column

Sets the column with column span information for I<combo_box> to be
I<column_span>. The column span column contains integers which indicate
how many columns an item should span.

Since: 2.4

  method gtk_combo_box_set_column_span_column ( Int $column_span )

=item Int $column_span; A column in the model passed during construction

=end pod

sub gtk_combo_box_set_column_span_column ( N-GObject $combo_box, int32 $column_span )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_active:
=begin pod
=head2 [gtk_combo_box_] get_active

Returns the index of the currently active item, or -1 if there’s no
active item. If the model is a non-flat treemodel, and the active item
is not an immediate child of the root of the tree, this function returns
`gtk_tree_path_get_indices (path)[0]`, where
`path` is the B<Gnome::Gtk3::TreePath> of the active item.

Returns: An integer which is the index of the currently active item,
or -1 if there’s no active item.

Since: 2.4

  method gtk_combo_box_get_active ( --> Int  )


=end pod

sub gtk_combo_box_get_active ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_active:
=begin pod
=head2 [gtk_combo_box_] set_active

Sets the active item of I<combo_box> to be the item at I<index>.

Since: 2.4

  method gtk_combo_box_set_active ( Int $index_ )

=item Int $index_; An index in the model passed during construction, or -1 to have no active item

=end pod

sub gtk_combo_box_set_active ( N-GObject $combo_box, int32 $index_ )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{
#TM:0:gtk_combo_box_get_active_iter:
=begin pod
=head2 [gtk_combo_box_] get_active_iter

Sets I<iter> to point to the current active item, if it exists.

Returns: C<1>, if I<iter> was set

Since: 2.4

  method gtk_combo_box_get_active_iter ( GtkTreeIter $iter --> Int  )

=item GtkTreeIter $iter; (out): The uninitialized B<Gnome::Gtk3::TreeIter>

=end pod

sub gtk_combo_box_get_active_iter ( N-GObject $combo_box, GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_active_iter:
=begin pod
=head2 [gtk_combo_box_] set_active_iter

Sets the current active item to be the one referenced by I<iter>, or
unsets the active item if I<iter> is C<Any>.

Since: 2.4

  method gtk_combo_box_set_active_iter ( GtkTreeIter $iter )

=item GtkTreeIter $iter; (allow-none): The B<Gnome::Gtk3::TreeIter>, or C<Any>

=end pod

sub gtk_combo_box_set_active_iter ( N-GObject $combo_box, GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_model:
=begin pod
=head2 [gtk_combo_box_] set_model

Sets the model used by I<combo_box> to be I<model>. Will unset a previously set
model (if applicable). If model is C<Any>, then it will unset the model.

Note that this function does not clear the cell renderers, you have to
call C<gtk_cell_layout_clear()> yourself if you need to set up different
cell renderers for the new model.

Since: 2.4

  method gtk_combo_box_set_model ( N-GObject $model )

=item N-GObject $model; (allow-none): A B<Gnome::Gtk3::TreeModel>

=end pod

sub gtk_combo_box_set_model ( N-GObject $combo_box, N-GObject $model )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_model:
=begin pod
=head2 [gtk_combo_box_] get_model

Returns the B<Gnome::Gtk3::TreeModel> which is acting as data source for I<combo_box>.

Returns: (transfer none): A B<Gnome::Gtk3::TreeModel> which was passed
during construction.

Since: 2.4

  method gtk_combo_box_get_model ( --> N-GObject  )


=end pod

sub gtk_combo_box_get_model ( N-GObject $combo_box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_row_separator_func:
=begin pod
=head2 [gtk_combo_box_] get_row_separator_func

Returns the current row separator function.

Returns: the current row separator function.

Since: 2.6

  method gtk_combo_box_get_row_separator_func ( --> GtkTreeViewRowSeparatorFunc  )


=end pod

sub gtk_combo_box_get_row_separator_func ( N-GObject $combo_box )
  returns GtkTreeViewRowSeparatorFunc
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_row_separator_func:
=begin pod
=head2 [gtk_combo_box_] set_row_separator_func

Sets the row separator function, which is used to determine
whether a row should be drawn as a separator. If the row separator
function is C<Any>, no separators are drawn. This is the default value.

Since: 2.6

  method gtk_combo_box_set_row_separator_func ( GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )

=item GtkTreeViewRowSeparatorFunc $func; a B<Gnome::Gtk3::TreeViewRowSeparatorFunc>
=item Pointer $data; (allow-none): user data to pass to I<func>, or C<Any>
=item GDestroyNotify $destroy; (allow-none): destroy notifier for I<data>, or C<Any>

=end pod

sub gtk_combo_box_set_row_separator_func ( N-GObject $combo_box, GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_button_sensitivity:
=begin pod
=head2 [gtk_combo_box_] set_button_sensitivity

Sets whether the dropdown button of the combo box should be
always sensitive (C<GTK_SENSITIVITY_ON>), never sensitive (C<GTK_SENSITIVITY_OFF>)
or only if there is at least one item to display (C<GTK_SENSITIVITY_AUTO>).

Since: 2.14

  method gtk_combo_box_set_button_sensitivity ( GtkSensitivityType $sensitivity )

=item GtkSensitivityType $sensitivity; specify the sensitivity of the dropdown button

=end pod

sub gtk_combo_box_set_button_sensitivity ( N-GObject $combo_box, int32 $sensitivity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_button_sensitivity:
=begin pod
=head2 [gtk_combo_box_] get_button_sensitivity

Returns whether the combo box sets the dropdown button
sensitive or not when there are no items in the model.

Returns: C<GTK_SENSITIVITY_ON> if the dropdown button
is sensitive when the model is empty, C<GTK_SENSITIVITY_OFF>
if the button is always insensitive or
C<GTK_SENSITIVITY_AUTO> if it is only sensitive as long as
the model has one item to be selected.

Since: 2.14

  method gtk_combo_box_get_button_sensitivity ( --> GtkSensitivityType  )


=end pod

sub gtk_combo_box_get_button_sensitivity ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_combo_box_get_has_entry:
=begin pod
=head2 [gtk_combo_box_] get_has_entry

Returns whether the combo box has an entry.

Returns: whether there is an entry in I<combo_box>.

Since: 2.24

  method gtk_combo_box_get_has_entry ( --> Int )


=end pod

sub gtk_combo_box_get_has_entry ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_entry_text_column:
=begin pod
=head2 [gtk_combo_box_] set_entry_text_column

Sets the model column which I<combo_box> should use to get strings from
to be I<text_column>. The column I<text_column> in the model of I<combo_box>
must be of type C<G_TYPE_STRING>.

This is only relevant if I<combo_box> has been created with
 I<has-entry> as C<1>.

Since: 2.24

  method gtk_combo_box_set_entry_text_column ( Int $text_column )

=item Int $text_column; A column in I<model> to get the strings from for the internal entry

=end pod

sub gtk_combo_box_set_entry_text_column ( N-GObject $combo_box, int32 $text_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_entry_text_column:
=begin pod
=head2 [gtk_combo_box_] get_entry_text_column

Returns the column which I<combo_box> is using to get the strings
from to display in the internal entry.

Returns: A column in the data source model of I<combo_box>.

Since: 2.24

  method gtk_combo_box_get_entry_text_column ( --> Int  )


=end pod

sub gtk_combo_box_get_entry_text_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_popup_fixed_width:
=begin pod
=head2 [gtk_combo_box_] set_popup_fixed_width

Specifies whether the popup’s width should be a fixed width
matching the allocated width of the combo box.

Since: 3.0

  method gtk_combo_box_set_popup_fixed_width ( Int $fixed )

=item Int $fixed; whether to use a fixed popup width

=end pod

sub gtk_combo_box_set_popup_fixed_width ( N-GObject $combo_box, int32 $fixed )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_popup_fixed_width:
=begin pod
=head2 [gtk_combo_box_] get_popup_fixed_width

Gets whether the popup uses a fixed width matching
the allocated width of the combo box.

Returns: C<1> if the popup uses a fixed width

Since: 3.0

  method gtk_combo_box_get_popup_fixed_width ( --> Int  )


=end pod

sub gtk_combo_box_get_popup_fixed_width ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_popup:
=begin pod
=head2 gtk_combo_box_popup

Pops up the menu or dropdown list of I<combo_box>.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Since: 2.4

  method gtk_combo_box_popup ( )


=end pod

sub gtk_combo_box_popup ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_popup_for_device:
=begin pod
=head2 [gtk_combo_box_] popup_for_device

Pops up the menu or dropdown list of I<combo_box>, the popup window
will be grabbed so only I<device> and its associated pointer/keyboard
are the only B<Gnome::Gdk3::Devices> able to send events to it.

Since: 3.0

  method gtk_combo_box_popup_for_device ( N-GObject $device )

=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gtk_combo_box_popup_for_device ( N-GObject $combo_box, N-GObject $device )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_popdown:
=begin pod
=head2 gtk_combo_box_popdown

Hides the menu or dropdown list of I<combo_box>.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Since: 2.4

  method gtk_combo_box_popdown ( )


=end pod

sub gtk_combo_box_popdown ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_popup_accessible:
=begin pod
=head2 [gtk_combo_box_] get_popup_accessible

Gets the accessible object corresponding to the combo box’s popup.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Returns: (transfer none): the accessible object corresponding
to the combo box’s popup.

Since: 2.6

  method gtk_combo_box_get_popup_accessible ( --> AtkObject  )


=end pod

sub gtk_combo_box_get_popup_accessible ( N-GObject $combo_box )
  returns AtkObject
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_id_column:
=begin pod
=head2 [gtk_combo_box_] get_id_column

Returns the column which I<combo_box> is using to get string IDs
for values from.

Returns: A column in the data source model of I<combo_box>.

Since: 3.0

  method gtk_combo_box_get_id_column ( --> Int  )


=end pod

sub gtk_combo_box_get_id_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_id_column:
=begin pod
=head2 [gtk_combo_box_] set_id_column

Sets the model column which I<combo_box> should use to get string IDs
for values from. The column I<id_column> in the model of I<combo_box>
must be of type C<G_TYPE_STRING>.

Since: 3.0

  method gtk_combo_box_set_id_column ( Int $id_column )

=item Int $id_column; A column in I<model> to get string IDs for values from

=end pod

sub gtk_combo_box_set_id_column ( N-GObject $combo_box, int32 $id_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_get_active_id:
=begin pod
=head2 [gtk_combo_box_] get_active_id

Returns the ID of the active row of I<combo_box>.  This value is taken
from the active row and the column specified by the  I<id-column>
property of I<combo_box> (see C<gtk_combo_box_set_id_column()>).

The returned value is an interned string which means that you can
compare the pointer by value to other interned strings and that you
must not free it.

If the  I<id-column> property of I<combo_box> is not set, or if
no row is active, or if the active row has a C<Any> ID value, then C<Any>
is returned.

Returns: (nullable): the ID of the active row, or C<Any>

Since: 3.0

  method gtk_combo_box_get_active_id ( --> Str  )


=end pod

sub gtk_combo_box_get_active_id ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_set_active_id:
=begin pod
=head2 [gtk_combo_box_] set_active_id

Changes the active row of I<combo_box> to the one that has an ID equal to
I<active_id>, or unsets the active row if I<active_id> is C<Any>.  Rows having
a C<Any> ID string cannot be made active by this function.

If the  I<id-column> property of I<combo_box> is unset or if no
row has the given ID then the function does nothing and returns C<0>.

Returns: C<1> if a row with a matching ID was found.  If a C<Any>
I<active_id> was given to unset the active row, the function
always returns C<1>.

Since: 3.0

  method gtk_combo_box_set_active_id ( Str $active_id --> Int  )

=item Str $active_id; (allow-none): the ID of the row to select, or C<Any>

=end pod

sub gtk_combo_box_set_active_id ( N-GObject $combo_box, Str $active_id )
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


=comment #TS:0:changed:
=head3 changed

The changed signal is emitted when the active
item is changed. The can be due to the user selecting
a different item from the list, or due to a
call to C<gtk_combo_box_set_active_iter()>.
It will also be emitted while typing into the entry of a combo box
with an entry.

Since: 2.4

  method handler (
    Gnome::GObject::Object :widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal


=comment #TS:0:move-active:
=head3 move-active

The I<move-active> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to move the active selection.

Since: 2.12

  method handler (
    Gnome::Gtk3::ScrollType $scroll_type,
    Gnome::GObject::Object :widget($widget),
    *%user-options
  );

=item $widget; the object that received the signal

=item $scroll_type; a B<Gnome::Gtk3::ScrollType>


=comment #TS:0:popup:
=head3 popup

The I<popup> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to popup the combo box list.

The default binding for this signal is Alt+Down.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    *%user-options
  );

=item $widget; the object that received the signal


=comment #TS:0:popdown:
=head3 popdown

The I<popdown> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to popdown the combo box list.

The default bindings for this signal are Alt+Up and Escape.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($button),
    *%user-options
    --> Int
  );

=item $button; the object which received the signal


=comment #TS:0:format-entry-text:
=head3 format-entry-text

For combo boxes that are created with an entry (See B<Gnome::Gtk3::ComboBox>:has-entry).

A signal which allows you to change how the text displayed in a combo box's
entry is displayed.

Connect a signal handler which returns an allocated string representing
I<path>. That string will then be used to set the text in the combo box's entry.
The default signal handler uses the text from the B<Gnome::Gtk3::ComboBox>::entry-text-column
model column.

=begin comment
Here's an example signal handler which fetches data from the model and
displays it in the entry.
|[<!-- language="C" -->
static gchar*
format_entry_text_callback (B<Gnome::Gtk3::ComboBox> *combo,
const gchar *path,
gpointer     user_data)
{
B<Gnome::Gtk3::TreeIter> iter;
B<Gnome::Gtk3::TreeModel> model;
gdouble      value;

model = gtk_combo_box_get_model (combo);

gtk_tree_model_get_iter_from_string (model, &iter, path);
gtk_tree_model_get (model, &iter,
THE_DOUBLE_VALUE_COLUMN, &value,
-1);

return g_strdup_printf ("C<g>", value);
}
]|
=end comment

Returns: (transfer full): a newly allocated string representing I<path>
for the current B<Gnome::Gtk3::ComboBox> model.

Since: 3.4

  method handler (
    Str $path,
    Gnome::GObject::Object :widget($combo),
    *%user-options
    --> Unknown type G_TYPE_STRING
  );

=item $combo; the object which received the signal

=item $path; the B<Gnome::Gtk3::TreePath> string from the combo box's current model to format text for


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=begin comment
=comment #TP:0:model:
=head3 ComboBox model


The model from which the combo box takes the values shown
in the list.
Since: 2.4
Widget type: GTK_TYPE_TREE_MODEL

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:wrap-width:
=head3 Wrap width


If wrap-width is set to a positive value, the list will be
displayed in multiple columns, the number of columns is
determined by wrap-width.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<wrap-width> is C<G_TYPE_INT>.

=comment #TP:0:row-span-column:
=head3 Row span column


If this is set to a non-negative value, it must be the index of a column
of type C<G_TYPE_INT> in the model.
The values of that column are used to determine how many rows a value in
the list will span. Therefore, the values in the model column pointed to
by this property must be greater than zero and not larger than wrap-width.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<row-span-column> is C<G_TYPE_INT>.

=comment #TP:0:column-span-column:
=head3 Column span column


If this is set to a non-negative value, it must be the index of a column
of type C<G_TYPE_INT> in the model.
The values of that column are used to determine how many columns a value
in the list will span.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<column-span-column> is C<G_TYPE_INT>.

=comment #TP:0:active:
=head3 Active item


The item which is currently active. If the model is a non-flat treemodel,
and the active item is not an immediate child of the root of the tree,
this property has the value
`gtk_tree_path_get_indices (path)[0]`,
where `path` is the B<Gnome::Gtk3::TreePath> of the active item.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_INT>.

=comment #TP:0:has-frame:
=head3 Has Frame


The has-frame property controls whether a frame
is drawn around the entry.
Since: 2.6

The B<Gnome::GObject::Value> type of property I<has-frame> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:popup-shown:
=head3 Popup shown


Whether the combo boxes dropdown is popped up.
Note that this property is mainly useful, because
it allows you to connect to notify::popup-shown.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<popup-shown> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:button-sensitivity:
=head3 Button Sensitivity


Whether the dropdown button is sensitive when
the model is empty.
Since: 2.14
Widget type: GTK_TYPE_SENSITIVITY_TYPE

The B<Gnome::GObject::Value> type of property I<button-sensitivity> is C<G_TYPE_ENUM>.

=comment #TP:0:has-entry:
=head3 Has Entry


Whether the combo box has an entry.
Since: 2.24

The B<Gnome::GObject::Value> type of property I<has-entry> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:entry-text-column:
=head3 Entry Text Column


The column in the combo box's model to associate with strings from the entry
if the combo was created with  I<has-entry> = C<1>.
Since: 2.24

The B<Gnome::GObject::Value> type of property I<entry-text-column> is C<G_TYPE_INT>.

=comment #TP:0:id-column:
=head3 ID Column


The column in the combo box's model that provides string
IDs for the values in the model, if != -1.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<id-column> is C<G_TYPE_INT>.

=comment #TP:0:active-id:
=head3 Active id


The value of the ID column of the active row.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<active-id> is C<G_TYPE_STRING>.

=comment #TP:0:popup-fixed-width:
=head3 Popup Fixed Width


Whether the popup's width should be a fixed width matching the
allocated width of the combo box.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<popup-fixed-width> is C<G_TYPE_BOOLEAN>.


=begin comment
=comment #TP:0:cell-area:
=head3 Cell Area


The B<Gnome::Gtk3::CellArea> used to layout cell renderers for this combo box.
If no area is specified when creating the combo box with C<gtk_combo_box_new_with_area()>
a horizontally oriented B<Gnome::Gtk3::CellAreaBox> will be used.
Since: 3.0
Widget type: GTK_TYPE_CELL_AREA

The B<Gnome::GObject::Value> type of property I<cell-area> is C<G_TYPE_OBJECT>.
=end comment
=end pod



















=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_new

Creates a new empty B<Gnome::Gtk3::ComboBox>.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.4

  method gtk_combo_box_new ( --> N-GObject  )


=end pod

sub gtk_combo_box_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] new_with_area

Creates a new empty B<Gnome::Gtk3::ComboBox> using I<area> to layout cells.

Returns: A new B<Gnome::Gtk3::ComboBox>.

  method gtk_combo_box_new_with_area ( N-GObject $area --> N-GObject  )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> to use to layout cell renderers

=end pod

sub gtk_combo_box_new_with_area ( N-GObject $area )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] new_with_area_and_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry.

The new combo box will use I<area> to layout cells.

Returns: A new B<Gnome::Gtk3::ComboBox>.

  method gtk_combo_box_new_with_area_and_entry ( N-GObject $area --> N-GObject  )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> to use to layout cell renderers

=end pod

sub gtk_combo_box_new_with_area_and_entry ( N-GObject $area )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] new_with_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.24

  method gtk_combo_box_new_with_entry ( --> N-GObject  )


=end pod

sub gtk_combo_box_new_with_entry (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] new_with_model

Creates a new B<Gnome::Gtk3::ComboBox> with the model initialized to I<model>.

Returns: A new B<Gnome::Gtk3::ComboBox>.

Since: 2.4

  method gtk_combo_box_new_with_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; A B<Gnome::Gtk3::TreeModel>.

=end pod

sub gtk_combo_box_new_with_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] new_with_model_and_entry

Creates a new empty B<Gnome::Gtk3::ComboBox> with an entry
and with the model initialized to I<model>.

Returns: A new B<Gnome::Gtk3::ComboBox>

Since: 2.24

  method gtk_combo_box_new_with_model_and_entry ( N-GObject $model --> N-GObject  )

=item N-GObject $model; A B<Gnome::Gtk3::TreeModel>

=end pod

sub gtk_combo_box_new_with_model_and_entry ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_wrap_width

Returns the wrap width which is used to determine the number of columns
for the popup menu. If the wrap width is larger than 1, the combo box
is in table mode.

Returns: the wrap width.

Since: 2.6

  method gtk_combo_box_get_wrap_width ( --> Int  )


=end pod

sub gtk_combo_box_get_wrap_width ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_wrap_width

Sets the wrap width of I<combo_box> to be I<width>. The wrap width is basically
the preferred number of columns when you want the popup to be layed out
in a table.

Since: 2.4

  method gtk_combo_box_set_wrap_width ( Int $width )

=item Int $width; Preferred number of columns

=end pod

sub gtk_combo_box_set_wrap_width ( N-GObject $combo_box, int32 $width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_row_span_column

Returns the column with row span information for I<combo_box>.

Returns: the row span column.

Since: 2.6

  method gtk_combo_box_get_row_span_column ( --> Int  )


=end pod

sub gtk_combo_box_get_row_span_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_row_span_column

Sets the column with row span information for I<combo_box> to be I<row_span>.
The row span column contains integers which indicate how many rows
an item should span.

Since: 2.4

  method gtk_combo_box_set_row_span_column ( Int $row_span )

=item Int $row_span; A column in the model passed during construction.

=end pod

sub gtk_combo_box_set_row_span_column ( N-GObject $combo_box, int32 $row_span )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_column_span_column

Returns the column with column span information for I<combo_box>.

Returns: the column span column.

Since: 2.6

  method gtk_combo_box_get_column_span_column ( --> Int  )


=end pod

sub gtk_combo_box_get_column_span_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_column_span_column

Sets the column with column span information for I<combo_box> to be
I<column_span>. The column span column contains integers which indicate
how many columns an item should span.

Since: 2.4

  method gtk_combo_box_set_column_span_column ( Int $column_span )

=item Int $column_span; A column in the model passed during construction

=end pod

sub gtk_combo_box_set_column_span_column ( N-GObject $combo_box, int32 $column_span )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_active

Returns the index of the currently active item, or -1 if there’s no
active item. If the model is a non-flat treemodel, and the active item
is not an immediate child of the root of the tree, this function returns
`gtk_tree_path_get_indices (path)[0]`, where
`path` is the B<Gnome::Gtk3::TreePath> of the active item.

Returns: An integer which is the index of the currently active item,
or -1 if there’s no active item.

Since: 2.4

  method gtk_combo_box_get_active ( --> Int  )


=end pod

sub gtk_combo_box_get_active ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_active

Sets the active item of I<combo_box> to be the item at I<index>.

Since: 2.4

  method gtk_combo_box_set_active ( Int $index_ )

=item Int $index_; An index in the model passed during construction, or -1 to have no active item

=end pod

sub gtk_combo_box_set_active ( N-GObject $combo_box, int32 $index_ )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_active_iter

Sets I<iter> to point to the current active item, if it exists.

Returns: C<1>, if I<iter> was set

Since: 2.4

  method gtk_combo_box_get_active_iter ( GtkTreeIter $iter --> Int  )

=item GtkTreeIter $iter; (out): The uninitialized B<Gnome::Gtk3::TreeIter>

=end pod

sub gtk_combo_box_get_active_iter ( N-GObject $combo_box, GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_active_iter

Sets the current active item to be the one referenced by I<iter>, or
unsets the active item if I<iter> is C<Any>.

Since: 2.4

  method gtk_combo_box_set_active_iter ( GtkTreeIter $iter )

=item GtkTreeIter $iter; (allow-none): The B<Gnome::Gtk3::TreeIter>, or C<Any>

=end pod

sub gtk_combo_box_set_active_iter ( N-GObject $combo_box, GtkTreeIter $iter )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_model

Sets the model used by I<combo_box> to be I<model>. Will unset a previously set
model (if applicable). If model is C<Any>, then it will unset the model.

Note that this function does not clear the cell renderers, you have to
call C<gtk_cell_layout_clear()> yourself if you need to set up different
cell renderers for the new model.

Since: 2.4

  method gtk_combo_box_set_model ( N-GObject $model )

=item N-GObject $model; (allow-none): A B<Gnome::Gtk3::TreeModel>

=end pod

sub gtk_combo_box_set_model ( N-GObject $combo_box, N-GObject $model )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_model

Returns the B<Gnome::Gtk3::TreeModel> which is acting as data source for I<combo_box>.

Returns: (transfer none): A B<Gnome::Gtk3::TreeModel> which was passed
during construction.

Since: 2.4

  method gtk_combo_box_get_model ( --> N-GObject  )


=end pod

sub gtk_combo_box_get_model ( N-GObject $combo_box )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_row_separator_func

Returns the current row separator function.

Returns: the current row separator function.

Since: 2.6

  method gtk_combo_box_get_row_separator_func ( --> GtkTreeViewRowSeparatorFunc  )


=end pod

sub gtk_combo_box_get_row_separator_func ( N-GObject $combo_box )
  returns GtkTreeViewRowSeparatorFunc
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_row_separator_func

Sets the row separator function, which is used to determine
whether a row should be drawn as a separator. If the row separator
function is C<Any>, no separators are drawn. This is the default value.

Since: 2.6

  method gtk_combo_box_set_row_separator_func ( GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )

=item GtkTreeViewRowSeparatorFunc $func; a B<Gnome::Gtk3::TreeViewRowSeparatorFunc>
=item Pointer $data; (allow-none): user data to pass to I<func>, or C<Any>
=item GDestroyNotify $destroy; (allow-none): destroy notifier for I<data>, or C<Any>

=end pod

sub gtk_combo_box_set_row_separator_func ( N-GObject $combo_box, GtkTreeViewRowSeparatorFunc $func, Pointer $data, GDestroyNotify $destroy )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_button_sensitivity

Sets whether the dropdown button of the combo box should be
always sensitive (C<GTK_SENSITIVITY_ON>), never sensitive (C<GTK_SENSITIVITY_OFF>)
or only if there is at least one item to display (C<GTK_SENSITIVITY_AUTO>).

Since: 2.14

  method gtk_combo_box_set_button_sensitivity ( GtkSensitivityType $sensitivity )

=item GtkSensitivityType $sensitivity; specify the sensitivity of the dropdown button

=end pod

sub gtk_combo_box_set_button_sensitivity ( N-GObject $combo_box, int32 $sensitivity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_button_sensitivity

Returns whether the combo box sets the dropdown button
sensitive or not when there are no items in the model.

Returns: C<GTK_SENSITIVITY_ON> if the dropdown button
is sensitive when the model is empty, C<GTK_SENSITIVITY_OFF>
if the button is always insensitive or
C<GTK_SENSITIVITY_AUTO> if it is only sensitive as long as
the model has one item to be selected.

Since: 2.14

  method gtk_combo_box_get_button_sensitivity ( --> GtkSensitivityType  )


=end pod

sub gtk_combo_box_get_button_sensitivity ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_has_entry

Returns whether the combo box has an entry.

Returns: whether there is an entry in I<combo_box>.

Since: 2.24

  method gtk_combo_box_get_has_entry ( --> Int  )


=end pod

sub gtk_combo_box_get_has_entry ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_entry_text_column

Sets the model column which I<combo_box> should use to get strings from
to be I<text_column>. The column I<text_column> in the model of I<combo_box>
must be of type C<G_TYPE_STRING>.

This is only relevant if I<combo_box> has been created with
prop C<has-entry> as C<1>.

Since: 2.24

  method gtk_combo_box_set_entry_text_column ( Int $text_column )

=item Int $text_column; A column in I<model> to get the strings from for the internal entry

=end pod

sub gtk_combo_box_set_entry_text_column ( N-GObject $combo_box, int32 $text_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_entry_text_column

Returns the column which I<combo_box> is using to get the strings
from to display in the internal entry.

Returns: A column in the data source model of I<combo_box>.

Since: 2.24

  method gtk_combo_box_get_entry_text_column ( --> Int  )


=end pod

sub gtk_combo_box_get_entry_text_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_popup_fixed_width

Specifies whether the popup’s width should be a fixed width
matching the allocated width of the combo box.

Since: 3.0

  method gtk_combo_box_set_popup_fixed_width ( Int $fixed )

=item Int $fixed; whether to use a fixed popup width

=end pod

sub gtk_combo_box_set_popup_fixed_width ( N-GObject $combo_box, int32 $fixed )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_popup_fixed_width

Gets whether the popup uses a fixed width matching
the allocated width of the combo box.

Returns: C<1> if the popup uses a fixed width

Since: 3.0

  method gtk_combo_box_get_popup_fixed_width ( --> Int  )


=end pod

sub gtk_combo_box_get_popup_fixed_width ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_popup

Pops up the menu or dropdown list of I<combo_box>.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Since: 2.4

  method gtk_combo_box_popup ( )


=end pod

sub gtk_combo_box_popup ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] popup_for_device

Pops up the menu or dropdown list of I<combo_box>, the popup window
will be grabbed so only I<device> and its associated pointer/keyboard
are the only B<Gnome::Gdk3::Devices> able to send events to it.

Since: 3.0

  method gtk_combo_box_popup_for_device ( N-GObject $device )

=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gtk_combo_box_popup_for_device ( N-GObject $combo_box, N-GObject $device )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_popdown

Hides the menu or dropdown list of I<combo_box>.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Since: 2.4

  method gtk_combo_box_popdown ( )


=end pod

sub gtk_combo_box_popdown ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_popup_accessible

Gets the accessible object corresponding to the combo box’s popup.

This function is mostly intended for use by accessibility technologies;
applications should have little use for it.

Returns: (transfer none): the accessible object corresponding
to the combo box’s popup.

Since: 2.6

  method gtk_combo_box_get_popup_accessible ( --> AtkObject  )


=end pod

sub gtk_combo_box_get_popup_accessible ( N-GObject $combo_box )
  returns AtkObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_id_column

Returns the column which I<combo_box> is using to get string IDs
for values from.

Returns: A column in the data source model of I<combo_box>.

Since: 3.0

  method gtk_combo_box_get_id_column ( --> Int  )


=end pod

sub gtk_combo_box_get_id_column ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_id_column

Sets the model column which I<combo_box> should use to get string IDs
for values from. The column I<id_column> in the model of I<combo_box>
must be of type C<G_TYPE_STRING>.

Since: 3.0

  method gtk_combo_box_set_id_column ( Int $id_column )

=item Int $id_column; A column in I<model> to get string IDs for values from

=end pod

sub gtk_combo_box_set_id_column ( N-GObject $combo_box, int32 $id_column )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] get_active_id

Returns the ID of the active row of I<combo_box>.  This value is taken
from the active row and the column specified by the prop C<id-column>
property of I<combo_box> (see C<gtk_combo_box_set_id_column()>).

The returned value is an interned string which means that you can
compare the pointer by value to other interned strings and that you
must not free it.

If the prop C<id-column> property of I<combo_box> is not set, or if
no row is active, or if the active row has a C<Any> ID value, then C<Any>
is returned.

Returns: (nullable): the ID of the active row, or C<Any>

Since: 3.0

  method gtk_combo_box_get_active_id ( --> Str  )


=end pod

sub gtk_combo_box_get_active_id ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_] set_active_id

Changes the active row of I<combo_box> to the one that has an ID equal to
I<active_id>, or unsets the active row if I<active_id> is C<Any>.  Rows having
a C<Any> ID string cannot be made active by this function.

If the prop C<id-column> property of I<combo_box> is unset or if no
row has the given ID then the function does nothing and returns C<0>.

Returns: C<1> if a row with a matching ID was found.  If a C<Any>
I<active_id> was given to unset the active row, the function
always returns C<1>.

Since: 3.0

  method gtk_combo_box_set_active_id ( Str $active_id --> Int  )

=item Str $active_id; (allow-none): the ID of the row to select, or C<Any>

=end pod

sub gtk_combo_box_set_active_id ( N-GObject $combo_box, Str $active_id )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.10
=head3 method gtk_combo_box_get_add_tearoffs ( --> Int  )
=head3 method gtk_combo_box_set_add_tearoffs ( Int $add_tearoffs )
=head3 method gtk_combo_box_get_title ( --> Str  )
=head3 method gtk_combo_box_set_title ( Str $title )

=head2 Since 3.20.
=head3 method gtk_combo_box_get_focus_on_click ( --> Int  )
=head3 method gtk_combo_box_set_focus_on_click ( Int $focus_on_click )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of not yet supported methods

=head2 method get_active_iter ( ... )
=head2 method set_active_iter ( ... )
=head2 method gtk_combo_box_get_row_separator_func ( ... )
=head2 method gtk_combo_box_set_row_separator_func ( ... )
=head2 method gtk_combo_box_get_popup_accessible ( ... )

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

=head3 changed

The changed signal is emitted when the active
item is changed. The can be due to the user selecting
a different item from the list, or due to a
call to C<gtk_combo_box_set_active_iter()>.
It will also be emitted while typing into the entry of a combo box
with an entry.

Since: 2.4

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=head3 popup

The ::popup signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to popup the combo box list.

The default binding for this signal is Alt+Down.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object that received the signal


=head3 popdown

The ::popdown signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to popdown the combo box list.

The default bindings for this signal are Alt+Up and Escape.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($button),
    :$user-option1, ..., :$user-optionN
  );

=item $button; the object which received the signal


=begin comment

=head2 Unsupported signals

=end comment

=head2 Not yet supported signals

=head3 move-active

The I<move-active signal> is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>] which gets emitted to move the active selection.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handler-arg0($scroll_type),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object that received the signal

=item $scroll_type; a B<Gnome::Gtk3::ScrollType>

=head3 format-entry-text

For combo boxes that are created with an entry (See sig I<has-entry>).

A signal which allows you to change how the text displayed in a combo box's entry is displayed.

Connect a signal handler which returns an allocated string representing I<path>. That string will then be used to set the text in the combo box's entry. The default signal handler uses the text from the prop I<entry-text-column> model column.

Here's an example signal handler which fetches data from the model and displays it in the entry (Still in C and must be converted to perl6...).


  method format_entry_text_callback (
    Gnome::Gtk3::ComboBox :widget($combo),
    Str :handler-arg0($path)
    --> Str
  ) {
    Gnome::Gtk3::TreeIter $iter;
    Gnome::Gtk3::TreeModel $model;
    Num $value;

    $model .= new(:combo-box($combo)); # use sub gtk_combo_box_get_model

    $model.gtk_tree_model_get_iter_from_string( $iter, $path); # $iter is rw
    $model.gtk_tree_model_get(
      $model, $iter, THE_DOUBLE_VALUE_COLUMN, $value, -1       # $value is rw
    );

    sprintf( "%g", $value);
  }

Returns: (transfer full): a newly allocated string representing I<path>
for the current B<Gnome::Gtk3::ComboBox> model.

Since: 3.4

  method handler (
    Gnome::GObject::Object :widget($combo),
    :handler-arg0($path),
    :$user-option1, ..., :$user-optionN
  );

=item $combo; the object which received the signal

=item $path; the B<Gnome::Gtk3::TreePath> string from the combo box's current model to format text for


=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties


=head3 model

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

The model from which the combo box takes the values shown
in the list.

Since: 2.4



=head3 wrap-width

The B<Gnome::GObject::Value> type of property I<wrap-width> is C<G_TYPE_INT>.

If wrap-width is set to a positive value, the list will be
displayed in multiple columns, the number of columns is
determined by wrap-width.

Since: 2.4



=head3 row-span-column

The B<Gnome::GObject::Value> type of property I<row-span-column> is C<G_TYPE_INT>.

If this is set to a non-negative value, it must be the index of a column
of type C<G_TYPE_INT> in the model.

The values of that column are used to determine how many rows a value in
the list will span. Therefore, the values in the model column pointed to
by this property must be greater than zero and not larger than wrap-width.

Since: 2.4



=head3 column-span-column

The B<Gnome::GObject::Value> type of property I<column-span-column> is C<G_TYPE_INT>.

If this is set to a non-negative value, it must be the index of a column
of type C<G_TYPE_INT> in the model.

The values of that column are used to determine how many columns a value
in the list will span.

Since: 2.4



=head3 active

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_INT>.

The item which is currently active. If the model is a non-flat treemodel,
and the active item is not an immediate child of the root of the tree,
this property has the value
`gtk_tree_path_get_indices (path)[0]`,
where `path` is the B<Gnome::Gtk3::TreePath> of the active item.

Since: 2.4



=head3 has-frame

The B<Gnome::GObject::Value> type of property I<has-frame> is C<G_TYPE_BOOLEAN>.

The has-frame property controls whether a frame
is drawn around the entry.

Since: 2.6



=head3 popup-shown

The B<Gnome::GObject::Value> type of property I<popup-shown> is C<G_TYPE_BOOLEAN>.

Whether the combo boxes dropdown is popped up.
Note that this property is mainly useful, because
it allows you to connect to notify::popup-shown.

Since: 2.10



=head3 button-sensitivity

The B<Gnome::GObject::Value> type of property I<button-sensitivity> is C<G_TYPE_ENUM>.

Whether the dropdown button is sensitive when
the model is empty.

Since: 2.14



=head3 has-entry

The B<Gnome::GObject::Value> type of property I<has-entry> is C<G_TYPE_BOOLEAN>.

Whether the combo box has an entry.

Since: 2.24



=head3 entry-text-column

The B<Gnome::GObject::Value> type of property I<entry-text-column> is C<G_TYPE_INT>.

The column in the combo box's model to associate with strings from the entry
if the combo was created with prop C<has-entry> = C<1>.

Since: 2.24



=head3 id-column

The B<Gnome::GObject::Value> type of property I<id-column> is C<G_TYPE_INT>.

The column in the combo box's model that provides string
IDs for the values in the model, if != -1.

Since: 3.0



=head3 active-id

The B<Gnome::GObject::Value> type of property I<active-id> is C<G_TYPE_STRING>.

The value of the ID column of the active row.

Since: 3.0



=head3 popup-fixed-width

The B<Gnome::GObject::Value> type of property I<popup-fixed-width> is C<G_TYPE_BOOLEAN>.

Whether the popup's width should be a fixed width matching the
allocated width of the combo box.

Since: 3.0



=head3 cell-area

The B<Gnome::GObject::Value> type of property I<cell-area> is C<G_TYPE_OBJECT>.

The B<Gnome::Gtk3::CellArea> used to layout cell renderers for this combo box.

If no area is specified when creating the combo box with C<gtk_combo_box_new_with_area()>
a horizontally oriented B<Gnome::Gtk3::CellAreaBox> will be used.

Since: 3.0


=end pod
