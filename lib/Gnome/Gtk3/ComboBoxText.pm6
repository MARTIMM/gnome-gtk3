#TL:1:Gnome::Gtk3::ComboBoxText:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ComboBoxText

A simple, text-only combo box

![](images/combo-box-text.png)

=head1 Description


A C<Gnome::Gtk3::ComboBoxText> is a simple variant of C<Gnome::Gtk3::ComboBox> that hides the model-view complexity for simple text-only use cases.

To create a C<Gnome::Gtk3::ComboBoxText>, use C<gtk_combo_box_text_new()> or
C<gtk_combo_box_text_new_with_entry()>.

You can add items to a C<Gnome::Gtk3::ComboBoxText> with C<gtk_combo_box_text_append_text()>, C<gtk_combo_box_text_insert_text()> or C<gtk_combo_box_text_prepend_text()> and remove options with C<gtk_combo_box_text_remove()>.

If the C<Gnome::Gtk3::ComboBoxText> contains an entry (via the “has-entry” property), its contents can be retrieved using C<gtk_combo_box_text_get_active_text()>. The entry itself can be accessed by calling C<gtk_bin_get_child()> on the combo box.

You should not call C<gtk_combo_box_set_model()> or attempt to pack more cells into this combo box via its C<Gnome::Gtk3::CellLayout> interface.

=head2 Gnome::Gtk3::ComboBoxText as Gnome::Gtk3::Buildable

The C<Gnome::Gtk3::ComboBoxText> implementation of the C<Gnome::Gtk3::Buildable> interface supports adding items directly using the <items> element and specifying <item> elements for each item. Each <item> element can specify the “id” corresponding to the appended text and also supports the regular translation attributes “translatable”, “context” and “comments”.

Here is a UI definition fragment specifying C<GtkComboBoxText> items:

  <object class="GtkComboBoxText">
    <items>
      <item translatable="yes" id="factory">Factory</item>
      <item translatable="yes" id="home">Home</item>
      <item translatable="yes" id="subway">Subway</item>
    </items>
  </object>

=head2 Css Nodes

  combobox
  ╰── box.linked
      ├── entry.combo
      ├── button.combo
      ╰── window.popup

C<Gnome::Gtk3::ComboBoxText> has a single CSS node with name combobox. It adds the style class .combo to the main CSS nodes of its entry and button children, and the .linked class to the node of its internal box.

=head2 Implemented Interfaces

Gnome::Gtk3::ComboBoxText implements
=comment item Gnome::Atk::ImplementorIface
=item Gnome::Gtk3::Buildable
=item Gnome::Gtk3::CellLayout
=item Gnome::Gtk3::CellEditable


=head2 See Also

C<Gnome::Gtk3::ComboBox>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ComboBoxText;
  also is Gnome::Gtk3::ComboBox;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::ComboBox;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcombobox.h
# https://developer.gnome.org/gtk3/stable/GtkComboBox.html
unit class Gnome::Gtk3::ComboBoxText:auth<github:MARTIMM>;
also is Gnome::Gtk3::ComboBox;

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

#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ComboBoxText';

  if ? %options<empty> {
    self.native-gobject(gtk_combo_box_text_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkComboBoxText');
}


#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_combo_box_text_$native-sub"); } unless ?$s;

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

  self.set-class-name-of-sub('GtkComboBoxText');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_combo_box_text_new:new(:empty)
=begin pod
=head2 gtk_combo_box_text_new

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying
strings.

Returns: A new B<Gnome::Gtk3::ComboBoxText>

Since: 2.24

  method gtk_combo_box_text_new ( --> N-GObject  )


=end pod

sub gtk_combo_box_text_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_new_with_entry:
=begin pod
=head2 [gtk_combo_box_text_] new_with_entry

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying
strings. The combo box created by this function has an entry.

Returns: a new B<Gnome::Gtk3::ComboBoxText>

Since: 2.24

  method gtk_combo_box_text_new_with_entry ( --> N-GObject  )


=end pod

sub gtk_combo_box_text_new_with_entry (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_combo_box_text_append_text:
=begin pod
=head2 [gtk_combo_box_text_] append_text

Appends I<text> to the list of strings stored in I<combo_box>.

This is the same as calling C<gtk_combo_box_text_insert_text()> with a
position of -1.

Since: 2.24

  method gtk_combo_box_text_append_text ( Str $text )

=item Str $text; A string

=end pod

sub gtk_combo_box_text_append_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_insert_text:
=begin pod
=head2 [gtk_combo_box_text_] insert_text

Inserts I<text> at I<position> in the list of strings stored in I<combo_box>.

If I<position> is negative then I<text> is appended.

This is the same as calling C<gtk_combo_box_text_insert()> with a C<Any>
ID string.

Since: 2.24

  method gtk_combo_box_text_insert_text ( Int $position, Str $text )

=item Int $position; An index to insert I<text>
=item Str $text; A string

=end pod

sub gtk_combo_box_text_insert_text ( N-GObject $combo_box, int32 $position, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_prepend_text:
=begin pod
=head2 [gtk_combo_box_text_] prepend_text

Prepends I<text> to the list of strings stored in I<combo_box>.

This is the same as calling C<gtk_combo_box_text_insert_text()> with a
position of 0.

Since: 2.24

  method gtk_combo_box_text_prepend_text ( Str $text )

=item Str $text; A string

=end pod

sub gtk_combo_box_text_prepend_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_remove:
=begin pod
=head2 gtk_combo_box_text_remove

Removes the string at I<position> from I<combo_box>.

Since: 2.24

  method gtk_combo_box_text_remove ( Int $position )

=item Int $position; Index of the item to remove

=end pod

sub gtk_combo_box_text_remove ( N-GObject $combo_box, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_remove_all:
=begin pod
=head2 [gtk_combo_box_text_] remove_all

Removes all the text entries from the combo box.

Since: 3.0

  method gtk_combo_box_text_remove_all ( )


=end pod

sub gtk_combo_box_text_remove_all ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_combo_box_text_get_active_text:
=begin pod
=head2 [gtk_combo_box_text_] get_active_text

Returns the currently active string in I<combo_box>, or C<Any>
if none is selected. If I<combo_box> contains an entry, this
function will return its contents (which will not necessarily
be an item from the list).

Returns: (transfer full): a newly allocated string containing the
currently active text. Must be freed with C<g_free()>.

Since: 2.24

  method gtk_combo_box_text_get_active_text ( --> Str  )


=end pod

sub gtk_combo_box_text_get_active_text ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_insert:
=begin pod
=head2 gtk_combo_box_text_insert

Inserts I<text> at I<position> in the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.  See
 I<id-column>.

If I<position> is negative then I<text> is appended.

Since: 3.0

  method gtk_combo_box_text_insert ( Int $position, Str $id, Str $text )

=item Int $position; An index to insert I<text>
=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; A string to display

=end pod

sub gtk_combo_box_text_insert ( N-GObject $combo_box, int32 $position, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_append:
=begin pod
=head2 gtk_combo_box_text_append

Appends I<text> to the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.

This is the same as calling C<gtk_combo_box_text_insert()> with a
position of -1.

Since: 2.24

  method gtk_combo_box_text_append ( Str $id, Str $text )

=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; A string

=end pod

sub gtk_combo_box_text_append ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_combo_box_text_prepend:
=begin pod
=head2 gtk_combo_box_text_prepend

Prepends I<text> to the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.

This is the same as calling C<gtk_combo_box_text_insert()> with a
position of 0.

Since: 2.24

  method gtk_combo_box_text_prepend ( Str $id, Str $text )

=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; a string

=end pod

sub gtk_combo_box_text_prepend ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }









=finish

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_text_new

Creates a new C<Gnome::Gtk3::ComboBoxText>, which is a C<Gnome::Gtk3::ComboBox> just displaying
strings.

Returns: A new C<Gnome::Gtk3::ComboBoxText>

Since: 2.24

  method gtk_combo_box_text_new ( --> N-GObject  )


=end pod

sub gtk_combo_box_text_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] new_with_entry

Creates a new C<Gnome::Gtk3::ComboBoxText>, which is a C<Gnome::Gtk3::ComboBox> just displaying
strings. The combo box created by this function has an entry.

Returns: a new C<Gnome::Gtk3::ComboBoxText>

Since: 2.24

  method gtk_combo_box_text_new_with_entry ( --> N-GObject  )


=end pod

sub gtk_combo_box_text_new_with_entry (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] append_text

Appends I<text> to the list of strings stored in I<combo_box>.

This is the same as calling C<gtk_combo_box_text_insert_text()> with a
position of -1.

Since: 2.24

  method gtk_combo_box_text_append_text ( Str $text )

=item Str $text; A string

=end pod

sub gtk_combo_box_text_append_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] insert_text

Inserts I<text> at I<position> in the list of strings stored in I<combo_box>.

If I<position> is negative then I<text> is appended.

This is the same as calling C<gtk_combo_box_text_insert()> with a C<Any>
ID string.

Since: 2.24

  method gtk_combo_box_text_insert_text ( Int $position, Str $text )

=item Int $position; An index to insert I<text>
=item Str $text; A string

=end pod

sub gtk_combo_box_text_insert_text ( N-GObject $combo_box, int32 $position, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] prepend_text

Prepends I<text> to the list of strings stored in I<combo_box>.

This is the same as calling C<gtk_combo_box_text_insert_text()> with a
position of 0.

Since: 2.24

  method gtk_combo_box_text_prepend_text ( Str $text )

=item Str $text; A string

=end pod

sub gtk_combo_box_text_prepend_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_text_remove

Removes the string at I<position> from I<combo_box>.

Since: 2.24

  method gtk_combo_box_text_remove ( Int $position )

=item Int $position; Index of the item to remove

=end pod

sub gtk_combo_box_text_remove ( N-GObject $combo_box, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] remove_all

Removes all the text entries from the combo box.

Since: 3.0

  method gtk_combo_box_text_remove_all ( )


=end pod

sub gtk_combo_box_text_remove_all ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_combo_box_text_] get_active_text

Returns the currently active string in I<combo_box>, or C<Any>
if none is selected. If I<combo_box> contains an entry, this
function will return its contents (which will not necessarily
be an item from the list).

Returns: (transfer full): a newly allocated string containing the
currently active text. Must be freed with C<g_free()>.

Since: 2.24

  method gtk_combo_box_text_get_active_text ( --> Str  )


=end pod

sub gtk_combo_box_text_get_active_text ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_text_insert

Inserts I<text> at I<position> in the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.  See
prop C<id-column>.

If I<position> is negative then I<text> is appended.

Since: 3.0

  method gtk_combo_box_text_insert ( Int $position, Str $id, Str $text )

=item Int $position; An index to insert I<text>
=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; A string to display

=end pod

sub gtk_combo_box_text_insert ( N-GObject $combo_box, int32 $position, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_text_append

Appends I<text> to the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.

This is the same as calling C<gtk_combo_box_text_insert()> with a
position of -1.

Since: 2.24

  method gtk_combo_box_text_append ( Str $id, Str $text )

=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; A string

=end pod

sub gtk_combo_box_text_append ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_combo_box_text_prepend

Prepends I<text> to the list of strings stored in I<combo_box>.
If I<id> is non-C<Any> then it is used as the ID of the row.

This is the same as calling C<gtk_combo_box_text_insert()> with a
position of 0.

Since: 2.24

  method gtk_combo_box_text_prepend ( Str $id, Str $text )

=item Str $id; (allow-none): a string ID for this value, or C<Any>
=item Str $text; a string

=end pod

sub gtk_combo_box_text_prepend ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }
