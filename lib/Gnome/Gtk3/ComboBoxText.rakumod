#TL:1:Gnome::Gtk3::ComboBoxText:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ComboBoxText

A simple, text-only combo box

![](images/combo-box-text.png)

=head1 Description


A B<Gnome::Gtk3::ComboBoxText> is a simple variant of B<Gnome::Gtk3::ComboBox> that hides the model-view complexity for simple text-only use cases.

To create a B<Gnome::Gtk3::ComboBoxText>, use .

You can add items to a C<Gnome::Gtk3::ComboBoxText> with C<append-text()>, C<insert_text()> or C<gprepend-text()> and remove options with C<remove()>.

If the B<Gnome::Gtk3::ComboBoxText> contains an entry (via the “has-entry” property), its contents can be retrieved using C<get-active-text()>. The entry itself can be accessed by calling C<Gnome::Gtk3::Bin get-child()> on the combo box.

You should not call C<Gnome::Gtk3::ComboBox set-model()> or attempt to pack more cells into this combo box via its B<Gnome::Gtk3::CellLayout> interface.


=head2 Gnome::Gtk3::ComboBoxText as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::ComboBoxText> implementation of the B<Gnome::Gtk3::Buildable> interface supports adding items directly using the <items> element and specifying <item> elements for each item. Each <item> element can specify the “id” corresponding to the appended text and also supports the regular translation attributes “translatable”, “context” and “comments”.

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

B<Gnome::Gtk3::ComboBoxText> has a single CSS node with name combobox. It adds the style class .combo to the main CSS nodes of its entry and button children, and the .linked class to the node of its internal box.


=head2 See Also

C<Gnome::Gtk3::ComboBox>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ComboBoxText;
  also is Gnome::Gtk3::ComboBox;


=head2 Uml Diagram

![](plantuml/ComboBox-ea.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ComboBoxText:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ComboBoxText;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ComboBoxText class process the options
    self.bless( :GtkComboBoxText, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::ComboBox:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcombobox.h
# https://developer.gnome.org/gtk3/stable/GtkComboBox.html
unit class Gnome::Gtk3::ComboBoxText:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::ComboBox;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying strings.

  multi method new ( )


=head3 :entry

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying strings. The combo box created by this function has an entry.

  multi method new ( Bool :$entry! )

=item $entry; named argument only checkd for its existence


=head3 :native-object

Create a ComboBoxText object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ComboBoxText object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ComboBoxText' or %options<GtkComboBoxText> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ?%options<entry>  {
        $no = _gtk_combo_box_text_new_with_entry;
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
        $no = _gtk_combo_box_text_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkComboBoxText');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_combo_box_text_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_combo_box_text_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('combo-box-text-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-combo-box-text-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkComboBoxText');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:append:
=begin pod
=head2 append

Appends I<$text> to the list of strings stored in this combo box. If I<id> is defined, then it is used as the ID of the row.

This is the same as calling C<insert()> with a position of -1.

  method append ( Str $id, Str $text )

=item $id; a string ID for this value, or C<undefined>
=item $text; A string
=end pod

method append ( Str $id, Str $text ) {
  gtk_combo_box_text_append( self._get-native-object-no-reffing, $id, $text);
}

sub gtk_combo_box_text_append (
  N-GObject $combo_box, gchar-ptr $id, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:append-text:
=begin pod
=head2 append-text

Appends I<text> to the list of strings stored in this combo box.

This is the same as calling C<insert_text()> with a position of -1.

  method append-text ( Str $text )

=item $text; A string
=end pod

method append-text ( Str $text ) {
  gtk_combo_box_text_append_text( self._get-native-object-no-reffing, $text);
}

sub gtk_combo_box_text_append_text (
  N-GObject $combo_box, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-active-text:
=begin pod
=head2 get-active-text

Returns the currently active string in this combo box, or C<undefined> if none is selected. If this combo box contains an entry, this function will return its contents (which will not necessarily be an item from the list).

Returns: a newly allocated string containing the currently active text. Must be freed with C<g_free()>.

  method get-active-text ( --> Str )

=end pod

method get-active-text ( --> Str ) {
  gtk_combo_box_text_get_active_text( self._get-native-object-no-reffing)
}

sub gtk_combo_box_text_get_active_text (
  N-GObject $combo_box --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert:
=begin pod
=head2 insert

Inserts I<$text> at I<$position> in the list of strings stored in this combo box. If I<$id> is defined, then it is used as the ID of the row. See I<id-column from Gnome::Gtk3::ComboBox>.

If I<$position> is negative then I<$text> is appended.

  method insert ( Int() $position, Str $id, Str $text )

=item $position; An index to insert I<$text>
=item $id; a string ID for this value, or C<undefined>
=item $text; A string to display
=end pod

method insert ( Int() $position, Str $id, Str $text ) {
  gtk_combo_box_text_insert( self._get-native-object-no-reffing, $position, $id, $text);
}

sub gtk_combo_box_text_insert (
  N-GObject $combo_box, gint $position, gchar-ptr $id, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-text:
=begin pod
=head2 insert-text

Inserts I<$text> at I<$position> in the list of strings stored in this combo box. If I<$position> is negative then I<$text> is appended.

This is the same as calling C<insert()> with a C<undefined> ID string.

  method insert-text ( Int() $position, Str $text )

=item $position; An index to insert I<text>
=item $text; A string
=end pod

method insert-text ( Int() $position, Str $text ) {
  gtk_combo_box_text_insert_text( self._get-native-object-no-reffing, $position, $text);
}

sub gtk_combo_box_text_insert_text (
  N-GObject $combo_box, gint $position, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prepend:
=begin pod
=head2 prepend

Prepends I<text> to the list of strings stored in this combo box. If I<id> is defined then it is used as the ID of the row.

This is the same as calling C<insert()> with a position of 0.

  method prepend ( Str $id, Str $text )

=item $id; a string ID for this value, or C<undefined>
=item $text; a string
=end pod

method prepend ( Str $id, Str $text ) {
  gtk_combo_box_text_prepend( self._get-native-object-no-reffing, $id, $text);
}

sub gtk_combo_box_text_prepend (
  N-GObject $combo_box, gchar-ptr $id, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prepend-text:
=begin pod
=head2 prepend-text

Prepends I<text> to the list of strings stored in this combo box.

This is the same as calling C<insert_text()> with a position of 0.

  method prepend-text ( Str $text )

=item $text; A string
=end pod

method prepend-text ( Str $text ) {
  gtk_combo_box_text_prepend_text( self._get-native-object-no-reffing, $text);
}

sub gtk_combo_box_text_prepend_text (
  N-GObject $combo_box, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove:
=begin pod
=head2 remove

Removes the string at I<position> from this combo box.

  method remove ( Int() $position )

=item $position; Index of the item to remove
=end pod

method remove ( Int() $position ) {
  gtk_combo_box_text_remove( self._get-native-object-no-reffing, $position);
}

sub gtk_combo_box_text_remove (
  N-GObject $combo_box, gint $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-all:
=begin pod
=head2 remove-all

Removes all the text entries from the combo box.

  method remove-all ( )

=end pod

method remove-all ( ) {
  gtk_combo_box_text_remove_all( self._get-native-object-no-reffing);
}

sub gtk_combo_box_text_remove_all (
  N-GObject $combo_box
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_combo_box_text_new:
#`{{
=begin pod
=head2 _gtk_combo_box_text_new

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying strings.

Returns: A new B<Gnome::Gtk3::ComboBoxText>

  method _gtk_combo_box_text_new ( --> N-GObject )

=end pod
}}

sub _gtk_combo_box_text_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_combo_box_text_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_combo_box_text_new_with_entry:
#`{{
=begin pod
=head2 _gtk_combo_box_text_new_with_entry

Creates a new B<Gnome::Gtk3::ComboBoxText>, which is a B<Gnome::Gtk3::ComboBox> just displaying strings. The combo box created by this function has an entry.

Returns: a new B<Gnome::Gtk3::ComboBoxText>

  method _gtk_combo_box_text_new_with_entry ( --> N-GObject )

=end pod
}}

sub _gtk_combo_box_text_new_with_entry (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_combo_box_text_new_with_entry')
  { * }
