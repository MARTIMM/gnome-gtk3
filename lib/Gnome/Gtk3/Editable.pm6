#TL:1:Gnome::Gtk3::Editable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Editable

Interface for text-editing widgets

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::Editable> interface is an interface which should be implemented by text editing widgets, such as B<Gnome::Gtk3::Entry> and B<Gnome::Gtk3::SpinButton>. It contains functions for generically manipulating an editable widget, a large number of action signals used for key bindings, and several signals that an application can connect to to modify the behavior of a widget.

As an example of the latter usage, by connecting the following handler to  I<insert-text>, an application can convert all entry into a widget into uppercase.

=begin comment
## Forcing entry to uppercase.

|[<!-- language="C" -->
B<include> <ctype.h>;

void
insert-text-handler (GtkEditable *editable,
                     const gchar *text,
                     gint         length,
                     gint        *position,
                     gpointer     data)
{
  gchar *result = g-utf8-strup (text, length);

  g-signal-handlers-block-by-func (editable,
                               (gpointer) insert-text-handler, data);
  insert-text (editable, result, length, position);
  g-signal-handlers-unblock-by-func (editable,
                                     (gpointer) insert-text-handler, data);

  g-signal-stop-emission-by-name (editable, "insert-text");

  g-free (result);
}
 * ]|
=end comment



=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Editable;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;


#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Editable:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
# setup signals from interface
method _add_editable_interface_signal_types ( Str $class-name ) {
  # add signal info in the form of w*<signal-name>.
  self.add-signal-types( $?CLASS.^name,
    :w2<delete-text>, :w0<changed>, :w3<insert-text>,
  );
}

#-------------------------------------------------------------------------------
#TM:0:copy-clipboard:
=begin pod
=head2 copy-clipboard

Copies the contents of the currently selected content in the editable and puts it on the clipboard.

  method copy-clipboard ( )

=end pod

method copy-clipboard ( ) {
  gtk_editable_copy_clipboard(self._f('GtkEditable'));
}

sub gtk_editable_copy_clipboard (
  N-GObject $editable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:cut-clipboard:
=begin pod
=head2 cut-clipboard

Removes the contents of the currently selected content in the editable and puts it on the clipboard.

  method cut-clipboard ( )

=end pod

method cut-clipboard ( ) {
  gtk_editable_cut_clipboard(self._f('GtkEditable'));
}

sub gtk_editable_cut_clipboard (
  N-GObject $editable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:delete-selection:
=begin pod
=head2 delete-selection

Deletes the currently selected text of the editable. This call doesn’t do anything if there is no selected text.

  method delete-selection ( )

=end pod

method delete-selection ( ) {
  gtk_editable_delete_selection(self._f('GtkEditable'));
}

sub gtk_editable_delete_selection (
  N-GObject $editable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:delete-text:
=begin pod
=head2 delete-text

Deletes a sequence of characters. The characters that are deleted are those characters at positions from I<$start-pos> up to, but not including I<$end-pos>. If I<$end-pos> is negative, then the characters deleted are those from I<$start-pos> to the end of the text.

Note that the positions are specified in characters, not bytes.

  method delete-text ( Int() $start_pos, Int() $end_pos )

=item $start_pos; start position
=item $end_pos; end position
=end pod

method delete-text ( Int() $start_pos, Int() $end_pos ) {
  gtk_editable_delete_text( self._f('GtkEditable'), $start_pos, $end_pos);
}

sub gtk_editable_delete_text (
  N-GObject $editable, gint $start_pos, gint $end_pos
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-chars:
=begin pod
=head2 get-chars

Retrieves a sequence of characters. The characters that are retrieved are those characters at positions from I<$start-pos> up to, but not including I<$end-pos>. If I<$end-pos> is negative, then the characters retrieved are those characters from I<$start-pos> to the end of the text.

Note that positions are specified in characters, not bytes.

Returns: a pointer to the contents of the widget as a string. This string is allocated by the B<Gnome::Gtk3::Editable> implementation and should be freed by the caller.

  method get-chars ( Int() $start_pos, Int() $end_pos --> Str )

=item $start_pos; start of text
=item $end_pos; end of text
=end pod

method get-chars ( Int() $start_pos, Int() $end_pos --> Str ) {
  gtk_editable_get_chars( self._f('GtkEditable'), $start_pos, $end_pos)
}

sub gtk_editable_get_chars (
  N-GObject $editable, gint $start_pos, gint $end_pos --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-editable:
=begin pod
=head2 get-editable

Retrieves whether I<editable> is editable. See C<set-editable()>.

Returns: C<True> if I<editable> is editable.

  method get-editable ( --> Bool )

=end pod

method get-editable ( --> Bool ) {
  gtk_editable_get_editable(self._f('GtkEditable')).Bool
}

sub gtk_editable_get_editable (
  N-GObject $editable --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-position:
=begin pod
=head2 get-position

Retrieves the current position of the cursor relative to the start of the content of the editable.

Note that this position is in characters, not in bytes.

Returns: the cursor position

  method get-position ( --> Int )

=end pod

method get-position ( --> Int ) {
  gtk_editable_get_position(self._f('GtkEditable'))
}

sub gtk_editable_get_position (
  N-GObject $editable --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selection-bounds:
=begin pod
=head2 get-selection-bounds

Retrieves the selection bound of the editable. start-pos will be filled with the start of the selection and I<end-pos> with end. If no text was selected both will be identical and C<False> will be returned.

Note that positions are specified in characters, not bytes.

Returns: a List with defined values if an area is selected, undefined C<Int> otherwise.

  method get-selection-bounds ( --> List )

Returns a List with
=item Int; location to store the starting position, or C<undefined>
=item Int; location to store the end position, or C<undefined>
=end pod

method get-selection-bounds ( --> List ) {
  my Bool $r = gtk_editable_get_selection_bounds(
    self._f('GtkEditable'), my gint $start_pos, my gint $end_pos
  ).Bool;

  $r ?? ( $start_pos, $start_pos) !! ( Int, Int)
}

sub gtk_editable_get_selection_bounds (
  N-GObject $editable, gint $start_pos is rw, gint $end_pos is rw --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:insert-text:
=begin pod
=head2 insert-text

Inserts I<$new-text> into the contents of the widget, at position I<$position>.

Note that the position is in characters, not in bytes. The method returns a new position to point after the newly inserted text.

  method insert-text ( Str $new-text, Int() $position --> Int )

=item $new-text; the text to append
=item $position; location of the position text will be inserted at
=end pod

method insert-text ( Str $new_text, Int() $position --> Int ) {
  gtk_editable_insert_text(
    self._f('GtkEditable'), $new_text, $new_text.chars,
    my gint $new-osition = $position
  );

  $new-osition
}

sub gtk_editable_insert_text (
  N-GObject $editable, gchar-ptr $new_text, gint $new_text_length, gint $position is rw
) is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:paste-clipboard:
=begin pod
=head2 paste-clipboard

Pastes the content of the clipboard to the current position of the cursor in the editable.

  method paste-clipboard ( )

=end pod

method paste-clipboard ( ) {
  gtk_editable_paste_clipboard(self._f('GtkEditable'));
}

sub gtk_editable_paste_clipboard (
  N-GObject $editable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-region:
=begin pod
=head2 select-region

Selects a region of text. The characters that are selected are those characters at positions from I<$start-pos> up to, but not including I<$end-pos>. If I<$end-pos> is negative, then the characters selected are those characters from I<$start-pos> to the end of the text.

Note that positions are specified in characters, not bytes.

  method select-region ( Int() $start_pos, Int() $end_pos )

=item $start_pos; start of region
=item $end_pos; end of region
=end pod

method select-region ( Int() $start_pos, Int() $end_pos ) {
  gtk_editable_select_region( self._f('GtkEditable'), $start_pos, $end_pos);
}

sub gtk_editable_select_region (
  N-GObject $editable, gint $start_pos, gint $end_pos
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-editable:
=begin pod
=head2 set-editable

Determines if the user can edit the text in the editable widget or not.

  method set-editable ( Bool $is_editable )

=item Bool $is_editable; C<True> if the user is allowed to edit the text in the widget
=end pod

method set-editable ( Bool $is_editable ) {
  gtk_editable_set_editable( self._f('GtkEditable'), $is_editable);
}

sub gtk_editable_set_editable (
  N-GObject $editable, gboolean $is_editable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-position:
=begin pod
=head2 set-position

Sets the cursor position in the editable to the given value.

The cursor is displayed before the character with the given (base 0) index in the contents of the editable. The value must be less than or equal to the number of characters in the editable. A value of -1 indicates that the position should be set after the last character of the editable. Note that I<position> is in characters, not in bytes.

  method set-position ( Int() $position )

=item $position; the position of the cursor
=end pod

method set-position ( Int() $position ) {
  gtk_editable_set_position( self._f('GtkEditable'), $position);
}

sub gtk_editable_set_position (
  N-GObject $editable, gint $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:0:changed:
=head2 changed

The I<changed> signal is emitted at the end of a single user-visible operation on the contents of the B<Gnome::Gtk3::Editable>.

E.g., a paste operation that replaces the contents of the selection will cause only one signal emission (even though it is implemented by first deleting the selection, then inserting the new content, and may cause multiple I<notify>::text signals to be emitted).

  method handler (
    Gnome::GObject::Object :_widget($editable),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  );

=item $editable; the object which received the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method


=comment -----------------------------------------------------------------------
=comment #TS:0:delete-text:
=head2 delete-text

This signal is emitted when text is deleted from the widget by the user. The default handler for this signal will normally be responsible for deleting the text, so by connecting to this signal and then stopping the signal with C<g-signal-stop-emission()> (I<not yet defined!!>), it is possible to modify the range of deleted text, or prevent it from being deleted entirely. The I<$start-pos> and I<$end-pos> parameters are interpreted as for C<delete-text()>.

  method handler (
    Int $start_pos,
    Int $end_pos,
    Gnome::GObject::Object :_widget($editable),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  );

=item $editable; the object which received the signal
=item $start_pos; the starting position
=item $end_pos; the end position
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method


=comment -----------------------------------------------------------------------
=comment #TS:0:insert-text:
=head2 insert-text

This signal is emitted when text is inserted into the widget by the user. The default handler for this signal will normally be responsible for inserting the text, so by connecting to this signal and then stopping the signal with C<g-signal-stop-emission()> (I<not yet defined!!>), it is possible to modify the inserted text, or prevent it from being inserted entirely.

  method handler (
    Str $new_text,
    Int $new_text_length,
    CArray[glong] $position,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($editable),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  );

=item $editable; the object which received the signal
=item $new_text; the new text to insert
=item $new_text_length; the length of the new text, in bytes, or -1 if new-text is nul-terminated.
=item $position; a pointer to the position in characters, at which to insert the new text. this is an in-outparameter. After the signal emission is finished, it should point after the newly inserted text.
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.

=end pod
