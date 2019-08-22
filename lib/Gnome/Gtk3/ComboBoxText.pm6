use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ComboBoxText

![](images/combo-box-text.png)

=SUBTITLE A simple, text-only combo box

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
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create a simple text combobox using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create a simple text combobox using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

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

  self.set-class-name-of-sub('GtkComboBoxText');
  $s = callsame unless ?$s;

  $s;
}


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












=finish
# ==============================================================================
=begin pod

=head1 Methods

=head2 gtk_combo_box_text_append

  method gtk_combo_box_text_append ( Str $id, Str $text )

Appends text. See also L<gnome developer docs| https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-append>.
=end pod
sub gtk_combo_box_text_append ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 gtk_combo_box_text_prepend

  method gtk_combo_box_text_prepend ( Str $id, Str $text )

Prepends text. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-prepend>.

This is the same as calling gtk_combo_box_text_insert() with a position of 0.
=end pod
sub gtk_combo_box_text_prepend ( N-GObject $combo_box, Str $id, Str $text )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 gtk_combo_box_text_insert

  method gtk_combo_box_text_insert ( Int $position, Str $id, Str $text )

Insert text at position. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-insert>.
=end pod
sub gtk_combo_box_text_insert (
  N-GObject $combo_box, int32 $position, Str $id, Str $text
) is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_text_] append_text

  method gtk_combo_box_text_append_text ( Str $text )

Append text. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-append-text>.
=end pod
sub gtk_combo_box_text_append_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_text_] prepend_text

  method gtk_combo_box_text_prepend_text ( Str $text )

Prepend text. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-prepend-text>.
=end pod
sub gtk_combo_box_text_prepend_text ( N-GObject $combo_box, Str $text )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_text_] insert_text

  method gtk_combo_box_text_insert_text ( int32 $position, Str $text )

Insert text at position. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-insert-text>.
=end pod
sub gtk_combo_box_text_insert_text (
  N-GObject $combo_box, int32 $position, Str $text
) is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 gtk_combo_box_text_remove

  method gtk_combo_box_text_remove ( Int $position )

Remove text at position. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-remove>.
=end pod
sub gtk_combo_box_text_remove ( N-GObject $combo_box, int32 $position )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_text_] remove_all

  method gtk_combo_box_text_remove_all ( )

Remove all text entries. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-remove-all>.
=end pod
sub gtk_combo_box_text_remove_all ( N-GObject $combo_box )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 gtk_combo_box_text_get_active_text

  method gtk_combo_box_text_get_active_text ( )

Get selected entry. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-get-active-text>.
=end pod
sub gtk_combo_box_text_get_active_text ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=begin pod
=head2 new

  multi method new ( :$widget! )

Create a simple text combobox using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create a simple text combobox using a native object from a builder. See also Gnome::GObject::Object.

=end pod
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ComboBoxText';

  if ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_combo_box_text_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
