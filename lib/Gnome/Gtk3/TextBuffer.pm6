#TL:1:Gnome::Gtk3::TextBuffer:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TextBuffer

Stores attributed text for display in a B<Gnome::Gtk3::TextView>

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

=head2 See Also

B<Gnome::Gtk3::TextView>, B<Gnome::Gtk3::TextIter>, B<Gnome::Gtk3::TextMark>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextBuffer;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
use Gnome::Gtk3::TextTag;
use Gnome::Gtk3::TextTagTable;
use Gnome::Gtk3::TextIter;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextbuffer.h
# https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
# https://developer.gnome.org/gtk3/stable/TextWidget.html
unit class Gnome::Gtk3::TextBuffer:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextBufferTargetInfo

These values are used as “info” for the targets contained in the
lists returned by C<gtk_text_buffer_get_copy_target_list()> and
C<gtk_text_buffer_get_paste_target_list()>.

The values counts down from `-1` to avoid clashes
with application added drag destinations which usually start at 0.


=item GTK_TEXT_BUFFER_TARGET_INFO_BUFFER_CONTENTS: Buffer contents
=item GTK_TEXT_BUFFER_TARGET_INFO_RICH_TEXT: Rich text
=item GTK_TEXT_BUFFER_TARGET_INFO_TEXT: Text


=end pod

#TE:0:GtkTextBufferTargetInfo:
enum GtkTextBufferTargetInfo is export (
  'GTK_TEXT_BUFFER_TARGET_INFO_BUFFER_CONTENTS' => - 1,
  'GTK_TEXT_BUFFER_TARGET_INFO_RICH_TEXT'       => - 2,
  'GTK_TEXT_BUFFER_TARGET_INFO_TEXT'            => - 3
);

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

  # prevent creating wrong native-objects
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<changed modified-changed begin-user-action end-user-action>,
    :w1<mark-deleted paste-done>,
    :w2<insert-pixbuf insert-child-anchor delete-range mark-set>,
    :w3<insert-text apply-tag remove-tag>,
  ) unless $signals-added;

  return unless self.^name eq 'Gnome::Gtk3::TextBuffer';

  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    my Gnome::Gtk3::TextTagTable $tag-table .= new;
    self.set-native-object(gtk_text_buffer_new($tag-table()));
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

  else {# if ? %options<empty> {
    my Gnome::Gtk3::TextTagTable $tag-table .= new;
    self.set-native-object(gtk_text_buffer_new($tag-table.get-native-object));
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkTextBuffer');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_text_buffer_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkTextBuffer');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_text_buffer_new:new()
=begin pod
=head2 [gtk_] text_buffer_new

Creates a new text buffer.

Returns: a new text buffer

  method gtk_text_buffer_new ( N-GObject $table --> N-GObject  )

=item N-GObject $table; (allow-none): a tag table, or C<Any> to create a new one

=end pod

sub gtk_text_buffer_new ( N-GObject $table )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_line_count:
=begin pod
=head2 [[gtk_] text_buffer_] get_line_count

Obtains the number of lines in the buffer. This value is cached, so
the function is very fast.

Returns: number of lines in the buffer

  method gtk_text_buffer_get_line_count ( --> Int  )


=end pod

sub gtk_text_buffer_get_line_count ( N-GObject $buffer )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_char_count:
=begin pod
=head2 [[gtk_] text_buffer_] get_char_count

Gets the number of characters in the buffer; note that characters
and bytes are not the same, you can’t e.g. expect the contents of
the buffer in string form to be this many bytes long. The character
count is cached, so this function is very fast.

Returns: number of characters in the buffer

  method gtk_text_buffer_get_char_count ( --> Int  )


=end pod

sub gtk_text_buffer_get_char_count ( N-GObject $buffer )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_tag_table:
=begin pod
=head2 [[gtk_] text_buffer_] get_tag_table

Get the B<Gnome::Gtk3::TextTagTable> associated with this buffer.

Returns: (transfer none): the buffer’s tag table

  method gtk_text_buffer_get_tag_table ( --> N-GObject  )


=end pod

sub gtk_text_buffer_get_tag_table ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_set_text:
=begin pod
=head2 [[gtk_] text_buffer_] set_text

Deletes current contents of I<buffer>, and inserts I<text> instead. If
I<len> is -1, I<text> must be nul-terminated. I<text> must be valid UTF-8.

  method gtk_text_buffer_set_text ( Str $text, Int $len )

=item Str $text; UTF-8 text to insert
=item Int $len; length of I<text> in bytes

=end pod

proto sub gtk_text_buffer_set_text ( N-GObject $buffer, Str, | ) {*}
multi sub gtk_text_buffer_set_text (
  N-GObject $buffer, Str $text, Int $len
) {
  Gnome::N::deprecate(
    '.gtk_text_buffer_set_text( Str $text, Int $len)',
    '.gtk_text_buffer_set_text(Str $text)',
     '0.23.2', '0.25.0'
  );
  _gtk_text_buffer_set_text( $buffer, $text, $len);
}

multi sub gtk_text_buffer_set_text ( N-GObject $buffer, Str $text ) {
  _gtk_text_buffer_set_text(
    $buffer, $text, $text.encode.bytes #`{{$text.chars}}
  );
}

sub _gtk_text_buffer_set_text ( N-GObject $buffer, Str $text, int32 $len )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_set_text')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_insert:
=begin pod
=head2 [gtk_] text_buffer_insert

Inserts I<$len> bytes of I<$text> at position I<$iter>.  If I<$len> is -1,
I<text> must be nul-terminated and will be inserted in its
entirety. Emits the “insert-text” signal; insertion actually occurs
in the default handler for the signal. I<iter> is invalidated when
insertion occurs (because the buffer contents change), but the
default signal handler revalidates it to point to the end of the
inserted text.

  method gtk_text_buffer_insert (
    Gnome::Gtk3::TextIter $iter, Str $text, Int $len
  )

=item Gnome::Gtk3::TextIter $iter; a position in the buffer
=item Str $text; text in UTF-8 format
=item Int $len; length of text in bytes, or -1

=end pod

sub gtk_text_buffer_insert ( N-GObject $buffer, N-GTextIter $iter, Str $text, int32 $len )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_at_cursor:
=begin pod
=head2 [[gtk_] text_buffer_] insert_at_cursor

Simply calls C<gtk_text_buffer_insert()>, using the current
cursor position as the insertion point.

  method gtk_text_buffer_insert_at_cursor ( Str $text, Int $len )

=item Str $text; text in UTF-8 format
=item Int $len; length of text, in bytes

=end pod

sub gtk_text_buffer_insert_at_cursor ( N-GObject $buffer, Str $text, int32 $len )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_interactive:
=begin pod
=head2 [[gtk_] text_buffer_] insert_interactive

Like C<gtk_text_buffer_insert()>, but the insertion will not occur if
I<iter> is at a non-editable location in the buffer. Usually you
want to prevent insertions at ineditable locations if the insertion
results from a user action (is interactive).

I<default_editable> indicates the editability of text that doesn't
have a tag affecting editability applied to it. Typically the
result of C<gtk_text_view_get_editable()> is appropriate here.

Returns: whether text was actually inserted

  method gtk_text_buffer_insert_interactive (
    Gnome::Gtk3::TextIter $iter, Str $text, Int $len,
    Int $default_editable
    --> Int
  )

=item Gnome::Gtk3::TextIter $iter; a position in I<buffer>
=item Str $text; some UTF-8 text
=item Int $len; length of text in bytes, or -1
=item Int $default_editable; default editability of buffer

=end pod

sub gtk_text_buffer_insert_interactive ( N-GObject $buffer, N-GTextIter $iter, Str $text, int32 $len, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_interactive_at_cursor:
=begin pod
=head2 [[gtk_] text_buffer_] insert_interactive_at_cursor

Calls C<gtk_text_buffer_insert_interactive()> at the cursor
position.

I<default_editable> indicates the editability of text that doesn't
have a tag affecting editability applied to it. Typically the
result of C<gtk_text_view_get_editable()> is appropriate here.

Returns: whether text was actually inserted

  method gtk_text_buffer_insert_interactive_at_cursor ( Str $text, Int $len, Int $default_editable --> Int  )

=item Str $text; text in UTF-8 format
=item Int $len; length of text in bytes, or -1
=item Int $default_editable; default editability of buffer

=end pod

sub gtk_text_buffer_insert_interactive_at_cursor ( N-GObject $buffer, Str $text, int32 $len, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_range:
=begin pod
=head2 [[gtk_] text_buffer_] insert_range

Copies text, tags, and pixbufs between I<start> and I<end> (the order
of I<start> and I<end> doesn’t matter) and inserts the copy at I<iter>.
Used instead of simply getting/inserting text because it preserves
images and tags. If I<start> and I<end> are in a different buffer from
I<buffer>, the two buffers must share the same tag table.

Implemented via emissions of the insert_text and apply_tag signals,
so expect those.

  method gtk_text_buffer_insert_range (
    Gnome::Gtk3::TextIter $iter,
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Gnome::Gtk3::TextIter $iter; a position in I<buffer>
=item Gnome::Gtk3::TextIter $start; a position in a B<Gnome::Gtk3::TextBuffer>
=item Gnome::Gtk3::TextIter $end; another position in the same buffer as I<start>

=end pod

sub gtk_text_buffer_insert_range ( N-GObject $buffer, N-GTextIter $iter, N-GObject $start, N-GObject $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_range_interactive:
=begin pod
=head2 [[gtk_] text_buffer_] insert_range_interactive

Same as C<gtk_text_buffer_insert_range()>, but does nothing if the
insertion point isn’t editable. The I<default_editable> parameter
indicates whether the text is editable at I<iter> if no tags
enclosing I<iter> affect editability. Typically the result of
C<gtk_text_view_get_editable()> is appropriate here.

Returns: whether an insertion was possible at I<iter>

  method gtk_text_buffer_insert_range_interactive (
    Gnome::Gtk3::TextIter $iter,
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
    Int $default_editable
    --> Int
  )

=item Gnome::Gtk3::TextIter $iter; a position in I<buffer>
=item Gnome::Gtk3::TextIter $start; a position in a B<Gnome::Gtk3::TextBuffer>
=item Gnome::Gtk3::TextIter $end; another position in the same buffer as I<start>
=item Int $default_editable; default editability of the buffer

=end pod

sub gtk_text_buffer_insert_range_interactive ( N-GObject $buffer, N-GTextIter $iter, N-GTextIter $start, N-GTextIter $end, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_with_tags:
=begin pod
=head2 [[gtk_] text_buffer_] insert_with_tags

Inserts I<text> into I<buffer> at I<iter>, applying the list of tags to
the newly-inserted text. The last tag specified must be C<Any> to
terminate the list. Equivalent to calling C<gtk_text_buffer_insert()>,
then C<gtk_text_buffer_apply_tag()> on the inserted text;
C<gtk_text_buffer_insert_with_tags()> is just a convenience function.

  method gtk_text_buffer_insert_with_tags ( Gnome::Gtk3::TextIter $iter, Str $text, Int $len, N-GObject $first_tag )

=item Gnome::Gtk3::TextIter $iter; an iterator in I<buffer>
=item Str $text; UTF-8 text
=item Int $len; length of I<text>, or -1
=item N-GObject $first_tag; first tag to apply to I<text> @...: C<Any>-terminated list of tags to apply

=end pod

sub gtk_text_buffer_insert_with_tags ( N-GObject $buffer, N-GTextIter $iter, Str $text, int32 $len, N-GObject $first_tag, Any $any = Any )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_with_tags_by_name:
=begin pod
=head2 [[gtk_] text_buffer_] insert_with_tags_by_name

Same as C<gtk_text_buffer_insert_with_tags()>, but allows you
to pass in tag names instead of tag objects.

  method gtk_text_buffer_insert_with_tags_by_name ( Gnome::Gtk3::TextIter $iter, Str $text, Int $len, Str $first_tag_name )

=item Gnome::Gtk3::TextIter $iter; position in I<buffer>
=item Str $text; UTF-8 text
=item Int $len; length of I<text>, or -1
=item Str $first_tag_name; name of a tag to apply to I<text> @...: more tag names

=end pod

sub gtk_text_buffer_insert_with_tags_by_name ( N-GObject $buffer, N-GTextIter $iter, Str $text, int32 $len, Str $first_tag_name, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_markup:
=begin pod
=head2 [[gtk_] text_buffer_] insert_markup

Inserts the text in I<markup> at position I<iter>. I<markup> will be inserted
in its entirety and must be nul-terminated and valid UTF-8. Emits the
 I<insert-text> signal, possibly multiple times; insertion
actually occurs in the default handler for the signal. I<iter> will point
to the end of the inserted text on return.


  method gtk_text_buffer_insert_markup (
    Gnome::Gtk3::TextIter $iter, Str $markup, Int $len
  )

=item Gnome::Gtk3::TextIter $iter; location to insert the markup
=item Str $markup; a nul-terminated UTF-8 string containing Pango markup
=item Int $len; length of I<markup> in bytes, or -1

=end pod

sub gtk_text_buffer_insert_markup ( N-GObject $buffer, N-GTextIter $iter, Str $markup, int32 $len )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_delete:
=begin pod
=head2 [gtk_] text_buffer_delete

Deletes text between I<start> and I<end>. The order of I<start> and I<end>
is not actually relevant; C<gtk_text_buffer_delete()> will reorder
them. This function actually emits the “delete-range” signal, and
the default handler of that signal deletes the text. Because the
buffer is modified, all outstanding iterators become invalid after
calling this function; however, the I<start> and I<end> will be
re-initialized to point to the location where text was deleted.

  method gtk_text_buffer_delete (
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Gnome::Gtk3::TextIter $start; a position in I<buffer>
=item Gnome::Gtk3::TextIter $end; another position in I<buffer>

=end pod

sub gtk_text_buffer_delete ( N-GObject $buffer, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_delete_interactive:
=begin pod
=head2 [[gtk_] text_buffer_] delete_interactive

Deletes all editable text in the given range.
Calls C<gtk_text_buffer_delete()> for each editable sub-range of
[I<start>,I<end>). I<start> and I<end> are revalidated to point to
the location of the last deleted range, or left untouched if
no text was deleted.

Returns: whether some text was actually deleted

  method gtk_text_buffer_delete_interactive (
    Gnome::Gtk3::TextIter $start_iter, Gnome::Gtk3::TextIter $end_iter,
    Int $default_editable
    --> Int
  )

=item Gnome::Gtk3::TextIter $start_iter; start of range to delete
=item Gnome::Gtk3::TextIter $end_iter; end of range
=item Int $default_editable; whether the buffer is editable by default

=end pod

sub gtk_text_buffer_delete_interactive ( N-GObject $buffer, N-GTextIter $start_iter, N-GTextIter $end_iter, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_backspace:
=begin pod
=head2 [gtk_] text_buffer_backspace

Performs the appropriate action as if the user hit the delete
key with the cursor at the position specified by I<iter>. In the
normal case a single character will be deleted, but when
combining accents are involved, more than one character can
be deleted, and when precomposed character and accent combinations
are involved, less than one character will be deleted.

Because the buffer is modified, all outstanding iterators become
invalid after calling this function; however, the I<iter> will be
re-initialized to point to the location where text was deleted.

Returns: C<1> if the buffer was modified


  method gtk_text_buffer_backspace (
    Gnome::Gtk3::TextIter $iter, Int $interactive, Int $default_editable
    --> Int
  )

=item N-GObject $iter; a position in I<buffer>
=item Int $interactive; whether the deletion is caused by user interaction
=item Int $default_editable; whether the buffer is editable by default

=end pod

sub gtk_text_buffer_backspace ( N-GObject $buffer, N-GTextIter $iter, int32 $interactive, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_text:
=begin pod
=head2 [[gtk_] text_buffer_] get_text

Returns the text in the range [I<start>,I<end>). Excludes undisplayed
text (text marked with tags that set the invisibility attribute) if
I<include_hidden_chars> is C<0>. Does not include characters
representing embedded images, so byte and character indexes into
the returned string do not correspond to byte
and character indexes into the buffer. Contrast with
C<gtk_text_buffer_get_slice()>.

Returns: an allocated UTF-8 string

  method gtk_text_buffer_get_text (
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
    Int $include_hidden_chars --> Str
  )

=item Gnome::Gtk3::TextIter $start; start of a range
=item Gnome::Gtk3::TextIter $end; end of a range
=item Int $include_hidden_chars; whether to include invisible text

=end pod

sub gtk_text_buffer_get_text (
  N-GObject $buffer, N-GTextIter $start, N-GTextIter $end,
  int32 $include_hidden_chars
  --> Str
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_slice:
=begin pod
=head2 [[gtk_] text_buffer_] get_slice

Returns the text in the range [I<start>,I<end>). Excludes undisplayed
text (text marked with tags that set the invisibility attribute) if
I<include_hidden_chars> is C<0>. The returned string includes a
0xFFFC character whenever the buffer contains
embedded images, so byte and character indexes into
the returned string do correspond to byte
and character indexes into the buffer. Contrast with
C<gtk_text_buffer_get_text()>. Note that 0xFFFC can occur in normal
text as well, so it is not a reliable indicator that a pixbuf or
widget is in the buffer.

Returns: an allocated UTF-8 string

  method gtk_text_buffer_get_slice (
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
    Int $include_hidden_chars
    --> Str
  )

=item Gnome::Gtk3::TextIter $start; start of a range
=item Gnome::Gtk3::TextIter $end; end of a range
=item Int $include_hidden_chars; whether to include invisible text

=end pod

sub gtk_text_buffer_get_slice ( N-GObject $buffer, N-GTextIter $start, N-GTextIter $end, int32 $include_hidden_chars )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_pixbuf:
=begin pod
=head2 [[gtk_] text_buffer_] insert_pixbuf

Inserts an image into the text buffer at I<iter>. The image will be
counted as one character in character counts, and when obtaining
the buffer contents as a string, will be represented by the Unicode
“object replacement character” 0xFFFC. Note that the “slice”
variants for obtaining portions of the buffer as a string include
this character for pixbufs, but the “text” variants do
not. e.g. see C<gtk_text_buffer_get_slice()> and
C<gtk_text_buffer_get_text()>.

  method gtk_text_buffer_insert_pixbuf ( Gnome::Gtk3::TextIter $iter, N-GObject $pixbuf )

=item Gnome::Gtk3::TextIter $iter; location to insert the pixbuf
=item N-GObject $pixbuf; a B<Gnome::Gdk3::Pixbuf>

=end pod

sub gtk_text_buffer_insert_pixbuf ( N-GObject $buffer, N-GTextIter $iter, N-GObject $pixbuf )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_insert_child_anchor:
=begin pod
=head2 [[gtk_] text_buffer_] insert_child_anchor

Inserts a child widget anchor into the text buffer at I<iter>. The
anchor will be counted as one character in character counts, and
when obtaining the buffer contents as a string, will be represented
by the Unicode “object replacement character” 0xFFFC. Note that the
“slice” variants for obtaining portions of the buffer as a string
include this character for child anchors, but the “text” variants do
not. E.g. see C<gtk_text_buffer_get_slice()> and
C<gtk_text_buffer_get_text()>. Consider
C<gtk_text_buffer_create_child_anchor()> as a more convenient
alternative to this function. The buffer will add a reference to
the anchor, so you can unref it after insertion.

  method gtk_text_buffer_insert_child_anchor ( Gnome::Gtk3::TextIter $iter, GtkTextChildAnchor $anchor )

=item Gnome::Gtk3::TextIter $iter; location to insert the anchor
=item GtkTextChildAnchor $anchor; a B<Gnome::Gtk3::TextChildAnchor>

=end pod

sub gtk_text_buffer_insert_child_anchor ( N-GObject $buffer, N-GTextIter $iter, GtkTextChildAnchor $anchor )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_create_child_anchor:
=begin pod
=head2 [[gtk_] text_buffer_] create_child_anchor

This is a convenience function which simply creates a child anchor
with C<gtk_text_child_anchor_new()> and inserts it into the buffer
with C<gtk_text_buffer_insert_child_anchor()>. The new anchor is
owned by the buffer; no reference count is returned to
the caller of C<gtk_text_buffer_create_child_anchor()>.

Returns: (transfer none): the created child anchor

  method gtk_text_buffer_create_child_anchor ( Gnome::Gtk3::TextIter $iter --> GtkTextChildAnchor  )

=item Gnome::Gtk3::TextIter $iter; location in the buffer

=end pod

sub gtk_text_buffer_create_child_anchor ( N-GObject $buffer, N-GTextIter $iter )
  returns GtkTextChildAnchor
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_add_mark:
=begin pod
=head2 [[gtk_] text_buffer_] add_mark

Adds the mark at position I<where>. The mark must not be added to
another buffer, and if its name is not C<Any> then there must not
be another mark in the buffer with the same name.

Emits the  I<mark-set> signal as notification of the mark's
initial placement.


  method gtk_text_buffer_add_mark ( N-GObject $mark, N-GObject $where )

=item N-GObject $mark; the mark to add
=item N-GObject $where; location to place mark

=end pod

sub gtk_text_buffer_add_mark ( N-GObject $buffer, N-GObject $mark, N-GObject $where )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_create_mark:
=begin pod
=head2 [[gtk_] text_buffer_] create_mark

Creates a mark at position I<where>. If I<mark_name> is C<Any>, the mark
is anonymous; otherwise, the mark can be retrieved by name using
C<gtk_text_buffer_get_mark()>. If a mark has left gravity, and text is
inserted at the mark’s current location, the mark will be moved to
the left of the newly-inserted text. If the mark has right gravity
(I<left_gravity> = C<0>), the mark will end up on the right of
newly-inserted text. The standard left-to-right cursor is a mark
with right gravity (when you type, the cursor stays on the right
side of the text you’re typing).

The caller of this function does not own a
reference to the returned B<Gnome::Gtk3::TextMark>, so you can ignore the
return value if you like. Marks are owned by the buffer and go
away when the buffer does.

Emits the  I<mark-set> signal as notification of the mark's
initial placement.

Returns: (transfer none): the new B<Gnome::Gtk3::TextMark> object

  method gtk_text_buffer_create_mark ( Str $mark_name, N-GObject $where, Int $left_gravity --> N-GObject  )

=item Str $mark_name; (allow-none): name for mark, or C<Any>
=item N-GObject $where; location to place mark
=item Int $left_gravity; whether the mark has left gravity

=end pod

sub gtk_text_buffer_create_mark ( N-GObject $buffer, Str $mark_name, N-GObject $where, int32 $left_gravity )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_move_mark:
=begin pod
=head2 [[gtk_] text_buffer_] move_mark

Moves I<mark> to the new location I<where>. Emits the  I<mark-set>
signal as notification of the move.

  method gtk_text_buffer_move_mark ( N-GObject $mark, N-GObject $where )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark>
=item N-GObject $where; new location for I<mark> in I<buffer>

=end pod

sub gtk_text_buffer_move_mark ( N-GObject $buffer, N-GObject $mark, N-GObject $where )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_delete_mark:
=begin pod
=head2 [[gtk_] text_buffer_] delete_mark

Deletes I<mark>, so that it’s no longer located anywhere in the
buffer. Removes the reference the buffer holds to the mark, so if
you haven’t called C<g_object_ref()> on the mark, it will be freed. Even
if the mark isn’t freed, most operations on I<mark> become
invalid, until it gets added to a buffer again with
C<gtk_text_buffer_add_mark()>. Use C<gtk_text_mark_get_deleted()> to
find out if a mark has been removed from its buffer.
The  I<mark-deleted> signal will be emitted as notification after
the mark is deleted.

  method gtk_text_buffer_delete_mark ( N-GObject $mark )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark> in I<buffer>

=end pod

sub gtk_text_buffer_delete_mark ( N-GObject $buffer, N-GObject $mark )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_mark:
=begin pod
=head2 [[gtk_] text_buffer_] get_mark

Returns the mark named I<name> in buffer I<buffer>, or C<Any> if no such
mark exists in the buffer.

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::TextMark>, or C<Any>

  method gtk_text_buffer_get_mark ( Str $name --> N-GObject  )

=item Str $name; a mark name

=end pod

sub gtk_text_buffer_get_mark ( N-GObject $buffer, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_move_mark_by_name:
=begin pod
=head2 [[gtk_] text_buffer_] move_mark_by_name

Moves the mark named I<name> (which must exist) to location I<where>.
See C<gtk_text_buffer_move_mark()> for details.

  method gtk_text_buffer_move_mark_by_name ( Str $name, N-GObject $where )

=item Str $name; name of a mark
=item N-GObject $where; new location for mark

=end pod

sub gtk_text_buffer_move_mark_by_name ( N-GObject $buffer, Str $name, N-GObject $where )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_delete_mark_by_name:
=begin pod
=head2 [[gtk_] text_buffer_] delete_mark_by_name

Deletes the mark named I<name>; the mark must exist. See
C<gtk_text_buffer_delete_mark()> for details.

  method gtk_text_buffer_delete_mark_by_name ( Str $name )

=item Str $name; name of a mark in I<buffer>

=end pod

sub gtk_text_buffer_delete_mark_by_name ( N-GObject $buffer, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_insert:
=begin pod
=head2 [[gtk_] text_buffer_] get_insert

Returns the mark that represents the cursor (insertion point).
Equivalent to calling C<gtk_text_buffer_get_mark()> to get the mark
named “insert”, but very slightly more efficient, and involves less
typing.

Returns: (transfer none): insertion point mark

  method gtk_text_buffer_get_insert ( --> N-GObject  )


=end pod

sub gtk_text_buffer_get_insert ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_selection_bound:
=begin pod
=head2 [[gtk_] text_buffer_] get_selection_bound

Returns the mark that represents the selection bound.  Equivalent
to calling C<gtk_text_buffer_get_mark()> to get the mark named
“selection_bound”, but very slightly more efficient, and involves
less typing.

The currently-selected text in I<buffer> is the region between the
“selection_bound” and “insert” marks. If “selection_bound” and
“insert” are in the same place, then there is no current selection.
C<gtk_text_buffer_get_selection_bounds()> is another convenient function
for handling the selection, if you just want to know whether there’s a
selection and what its bounds are.

Returns: (transfer none): selection bound mark

  method gtk_text_buffer_get_selection_bound ( --> N-GObject  )


=end pod

sub gtk_text_buffer_get_selection_bound ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_place_cursor:
=begin pod
=head2 [[gtk_] text_buffer_] place_cursor

This function moves the “insert” and “selection_bound” marks
simultaneously.  If you move them to the same place in two steps
with C<gtk_text_buffer_move_mark()>, you will temporarily select a
region in between their old and new locations, which can be pretty
inefficient since the temporarily-selected region will force stuff
to be recalculated. This function moves them as a unit, which can
be optimized.

  method gtk_text_buffer_place_cursor ( N-GObject $where )

=item N-GObject $where; where to put the cursor

=end pod

sub gtk_text_buffer_place_cursor ( N-GObject $buffer, N-GObject $where )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_select_range:
=begin pod
=head2 [[gtk_] text_buffer_] select_range

This function moves the “insert” and “selection_bound” marks
simultaneously.  If you move them in two steps
with C<gtk_text_buffer_move_mark()>, you will temporarily select a
region in between their old and new locations, which can be pretty
inefficient since the temporarily-selected region will force stuff
to be recalculated. This function moves them as a unit, which can
be optimized.


  method gtk_text_buffer_select_range ( N-GObject $ins, N-GObject $bound )

=item N-GObject $ins; where to put the “insert” mark
=item N-GObject $bound; where to put the “selection_bound” mark

=end pod

sub gtk_text_buffer_select_range ( N-GObject $buffer, N-GObject $ins, N-GObject $bound )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_apply_tag:
=begin pod
=head2 [[gtk_] text_buffer_] apply_tag

Emits the “apply-tag” signal on I<buffer>. The default
handler for the signal applies I<tag> to the given range.
I<start> and I<end> do not have to be in order.

  method gtk_text_buffer_apply_tag (
    Gnome::Gtk3::TextTag $tag,
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Gnome::Gtk3::TextTag $tag
=item Gnome::Gtk3::TextIter $start; one bound of range to be tagged
=item Gnome::Gtk3::TextIter $end; other bound of range to be tagged

=end pod

sub gtk_text_buffer_apply_tag ( N-GObject $buffer, N-GObject $tag, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_remove_tag:
=begin pod
=head2 [[gtk_] text_buffer_] remove_tag

Emits the “remove-tag” signal. The default handler for the signal
removes all occurrences of I<tag> from the given range. I<start> and
I<end> don’t have to be in order.

  method gtk_text_buffer_remove_tag ( N-GObject $tag, N-GObject $start, N-GObject $end )

=item Gnome::Gtk3::TextTag $tag
=item Gnome::Gtk3::TextIter $start; one bound of range to be untagged
=item Gnome::Gtk3::TextIter $end; other bound of range to be untagged

=end pod

sub gtk_text_buffer_remove_tag ( N-GObject $buffer, N-GObject $tag, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_apply_tag_by_name:
=begin pod
=head2 [[gtk_] text_buffer_] apply_tag_by_name

Calls C<gtk_text_tag_table_lookup()> on the buffer’s tag table to
get a B<Gnome::Gtk3::TextTag>, then calls C<gtk_text_buffer_apply_tag()>.

  method gtk_text_buffer_apply_tag_by_name (
    Str $name, Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Str $name; name of a named B<Gnome::Gtk3::TextTag>
=item Gnome::Gtk3::TextIter $start; one bound of range to be tagged
=item Gnome::Gtk3::TextIter $end; other bound of range to be tagged

=end pod

sub gtk_text_buffer_apply_tag_by_name ( N-GObject $buffer, Str $name, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_remove_tag_by_name:
=begin pod
=head2 [[gtk_] text_buffer_] remove_tag_by_name

Calls C<gtk_text_tag_table_lookup()> on the buffer’s tag table to
get a B<Gnome::Gtk3::TextTag>, then calls C<gtk_text_buffer_remove_tag()>.

  method gtk_text_buffer_remove_tag_by_name (
    Str $name, Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Str $name; name of a B<Gnome::Gtk3::TextTag>
=item Gnome::Gtk3::TextIter $start; one bound of range to be untagged
=item Gnome::Gtk3::TextIter $end; other bound of range to be untagged

=end pod

sub gtk_text_buffer_remove_tag_by_name ( N-GObject $buffer, Str $name, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_remove_all_tags:
=begin pod
=head2 [[gtk_] text_buffer_] remove_all_tags

Removes all tags in the range between I<start> and I<end>.  Be careful
with this function; it could remove tags added in code unrelated to
the code you’re currently writing. That is, using this function is
probably a bad idea if you have two or more unrelated code sections
that add tags.

  method gtk_text_buffer_remove_all_tags (
    Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
  )

=item Gnome::Gtk3::TextIter $start; one bound of range to be untagged
=item Gnome::Gtk3::TextIter $end; other bound of range to be untagged

=end pod

sub gtk_text_buffer_remove_all_tags ( N-GObject $buffer, N-GTextIter $start, N-GTextIter $end )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_create_tag:
=begin pod
=head2 [[gtk_] text_buffer_] create_tag

Creates a tag and adds it to the tag table for I<buffer>.
Equivalent to calling C<gtk_text_tag_new()> and then adding the
tag to the buffer’s tag table. The returned tag is owned by
the buffer’s tag table, so the ref count will be equal to one.

If I<tag_name> is C<Any>, the tag is anonymous.

If I<tag_name> is non-C<Any>, a tag called I<tag_name> must not already
exist in the tag table for this buffer.

The I<first_property_name> argument and subsequent arguments are a list
of properties to set on the tag, as with C<g_object_set()>.

Returns: (transfer none): a new tag

  method gtk_text_buffer_create_tag ( Str $tag_name, Str $first_property_name --> N-GObject  )

=item Str $tag_name; (allow-none): name of the new tag, or C<Any>
=item Str $first_property_name; (allow-none): name of first property to set, or C<Any> @...: C<Any>-terminated list of property names and values

=end pod

sub gtk_text_buffer_create_tag ( N-GObject $buffer, Str $tag_name, Str $first_property_name, Any $any = Any )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_iter_at_line_offset:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_line_offset

Obtains an iterator pointing to I<$char_offset> within the given line. Note
characters, not bytes; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if I<$line_number> is greater than the number of lines
in the I<buffer>, the end iterator is returned. And if I<$char_offset> is off the end of the line, the iterator at the end of the line is returned.

  method gtk_text_buffer_get_iter_at_line_offset (
    Int $line_number, Int $char_offset
    --> Gnome::Gtk3::TextIter
  )

=item Int $line_number; line number counting from 0
=item Int $char_offset; char offset from start of line

=end pod

sub gtk_text_buffer_get_iter_at_line_offset (
  N-GObject $buffer, Int $line_number, Int $char_offset
  --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $iter .= new;
#  my N-GTextIter $no = $iter.get-native-object;
  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_iter_at_line_offset(
    $buffer, $no, $line_number, $char_offset
  );
  Gnome::Gtk3::TextIter.new(:native-object($no))
#  $iter.set-native-object($no);

#  $iter
}

sub _gtk_text_buffer_get_iter_at_line_offset ( N-GObject $buffer, N-GTextIter $iter is rw, int32 $line_number, int32 $char_offset )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_iter_at_line_offset')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_iter_at_line_index:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_line_index

Obtains an iterator pointing to I<byte_index> within the given line.
I<byte_index> must be the start of a UTF-8 character. Note bytes, not
characters; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if I<line_number> is greater than the number of lines
in the I<buffer>, the end iterator is returned. And if I<byte_index> is off the
end of the line, the iterator at the end of the line is returned.

  method gtk_text_buffer_get_iter_at_line_index (
    Int $line_number, Int $byte_index
    --> Gnome::Gtk3::TextIter
  )

=item Int $line_number; line number counting from 0
=item Int $byte_index; byte index from start of line

=end pod

sub gtk_text_buffer_get_iter_at_line_index (
  N-GObject $buffer, Int $line_number, Int $byte_index
  --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $iter .= new;
#  my N-GTextIter $no = $iter.get-native-object;
  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_iter_at_line_index(
    $buffer, $no, $line_number, $byte_index
  );
  Gnome::Gtk3::TextIter.new(:native-object($no))
#  $iter.set-native-object($no);

#  $iter
}

sub _gtk_text_buffer_get_iter_at_line_index ( N-GObject $buffer, N-GTextIter $iter is rw, int32 $line_number, int32 $byte_index )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_iter_at_line_index')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_iter_at_offset:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_offset

Initializes I<iter> to a position I<char_offset> chars from the start
of the entire buffer. If I<char_offset> is -1 or greater than the number
of characters in the buffer, I<iter> is initialized to the end iterator,
the iterator one past the last valid character in the buffer.

  method gtk_text_buffer_get_iter_at_offset (
    Int $char_offset
    --> Gnome::Gtk3::TextIter
  )

=item Int $char_offset; char offset from start of buffer, counting from 0, or -1

=end pod


sub gtk_text_buffer_get_iter_at_offset (
  N-GObject $buffer, Int $char_offset
  --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $iter .= new;
#  my N-GTextIter $no = $iter.get-native-object;
  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_iter_at_offset( $buffer, $no, $char_offset);
  Gnome::Gtk3::TextIter.new(:native-object($no))
#  $iter.set-native-object($no);

#  $iter
}

sub _gtk_text_buffer_get_iter_at_offset ( N-GObject $buffer, N-GTextIter $iter is rw, int32 $char_offset )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_iter_at_offset')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_iter_at_line:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_line

Returns an I<iter> to the start of the given line. If I<$line_number> is greater
than the number of lines in the I<buffer>, the end iterator is returned.

  method gtk_text_buffer_get_iter_at_line (
    Int $line_number
    --> Gnome::Gtk3::TextIter
  )

=item Int $line_number; line number counting from 0

=end pod

sub gtk_text_buffer_get_iter_at_line (
  N-GObject $buffer, Int $line_number
  --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $iter .= new;
#  my N-GTextIter $no = $iter.get-native-object;
  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_iter_at_line( $buffer, $no, $line_number);
  Gnome::Gtk3::TextIter.new(:native-object($no))
#  $iter.set-native-object($no);

#  $iter
}

sub _gtk_text_buffer_get_iter_at_line ( N-GObject $buffer, N-GTextIter $iter is rw, int32 $line_number )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_iter_at_line')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_start_iter:
=begin pod
=head2 [[gtk_] text_buffer_] get_start_iter

Initialized I<$iter> with the first position in the text buffer. This
is the same as using C<gtk_text_buffer_get_iter_at_offset()> to get
the iter at character offset 0.

  method gtk_text_buffer_get_start_iter ( --> Gnome::Gtk3::TextIter )

=item N-GObject $iter; (out): iterator to initialize

=end pod

sub gtk_text_buffer_get_start_iter (
  N-GObject $buffer --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $start .= new;
#  my N-GTextIter $no = $start.get-native-object;

  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_start_iter( $buffer, $no);
#  $start.set-native-object($no);
  Gnome::Gtk3::TextIter.new(:native-object($no))

#  $start
}

sub _gtk_text_buffer_get_start_iter ( N-GObject $buffer, N-GTextIter $iter is rw )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_start_iter')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_end_iter:
=begin pod
=head2 [[gtk_] text_buffer_] get_end_iter

Initializes I<iter> with the “end iterator,” one past the last valid
character in the text buffer. If dereferenced with
C<gtk_text_iter_get_char()>, the end iterator has a character value of 0.
The entire buffer lies in the range from the first position in
the buffer (call C<gtk_text_buffer_get_start_iter()> to get
character position 0) to the end iterator.

  method gtk_text_buffer_get_end_iter ( --> Gnome::Gtk3::TextIter )

=item N-GObject $iter; (out): iterator to initialize

=end pod

sub gtk_text_buffer_get_end_iter (
  N-GObject $buffer --> Gnome::Gtk3::TextIter
) {
#  my Gnome::Gtk3::TextIter $end .= new;
#  my N-GTextIter $no = $end.get-native-object;
  my N-GTextIter $no .= new;
  _gtk_text_buffer_get_end_iter( $buffer, $no);
  Gnome::Gtk3::TextIter.new(:native-object($no))
#  $end.set-native-object($no);

#  $end
}

sub _gtk_text_buffer_get_end_iter ( N-GObject $buffer, N-GTextIter $iter is rw )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_end_iter')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_bounds:
=begin pod
=head2 [[gtk_] text_buffer_] get_bounds

Retrieves the first and last iterators in the buffer, i.e. the
entire buffer lies within the range [I<start>,I<end>).

  method gtk_text_buffer_get_bounds ( --> List )

Returns a list of
=item Gnome::Gtk3::TextIter $start; iterator to initialize with first position in the buffer
=item Gnome::Gtk3::TextIter $end; iterator to initialize with the end iterator

=end pod

sub gtk_text_buffer_get_bounds ( N-GObject $buffer --> List ) {
#  my Gnome::Gtk3::TextIter $i1 .= new;
#  my N-GTextIter $no1 = $i1.get-native-object;
#  my Gnome::Gtk3::TextIter $i2 .= new;
#  my N-GTextIter $no2 = $i2.get-native-object;

  my N-GTextIter $no1 .= new;
  my N-GTextIter $no2 .= new;
  _gtk_text_buffer_get_bounds( $buffer, $no1, $no2);

#  $i1.set-native-object($no1);
#  $i2.set-native-object($no2);

  ( Gnome::Gtk3::TextIter.new(:native-object($no1)),
    Gnome::Gtk3::TextIter.new(:native-object($no2))
  )
}

sub _gtk_text_buffer_get_bounds ( N-GObject $buffer, N-GTextIter $start is rw, N-GTextIter $end is rw )
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_bounds')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_iter_at_mark:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_mark

Initializes I<iter> with the current position of I<mark>.

  method gtk_text_buffer_get_iter_at_mark ( Gnome::Gtk3::TextIter $iter, N-GObject $mark )

=item Gnome::Gtk3::TextIter $iter; (out): iterator to initialize
=item N-GObject $mark; a B<Gnome::Gtk3::TextMark> in I<buffer>

=end pod

sub gtk_text_buffer_get_iter_at_mark ( N-GObject $buffer, N-GTextIter $iter, N-GObject $mark )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_iter_at_child_anchor:
=begin pod
=head2 [[gtk_] text_buffer_] get_iter_at_child_anchor

Obtains the location of I<anchor> within I<buffer>.

  method gtk_text_buffer_get_iter_at_child_anchor ( Gnome::Gtk3::TextIter $iter, GtkTextChildAnchor $anchor )

=item Gnome::Gtk3::TextIter $iter; (out): an iterator to be initialized
=item GtkTextChildAnchor $anchor; a child anchor that appears in I<buffer>

=end pod

sub gtk_text_buffer_get_iter_at_child_anchor ( N-GObject $buffer, N-GTextIter $iter, GtkTextChildAnchor $anchor )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_modified:
=begin pod
=head2 [[gtk_] text_buffer_] get_modified

Indicates whether the buffer has been modified since the last call
to C<gtk_text_buffer_set_modified()> set the modification flag to
C<0>. Used for example to enable a “save” function in a text
editor.

Returns: C<1> if the buffer has been modified

  method gtk_text_buffer_get_modified ( --> Int  )


=end pod

sub gtk_text_buffer_get_modified ( N-GObject $buffer )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_set_modified:
=begin pod
=head2 [[gtk_] text_buffer_] set_modified

Used to keep track of whether the buffer has been modified since the
last time it was saved. Whenever the buffer is saved to disk, call
gtk_text_buffer_set_modified (I<buffer>, FALSE). When the buffer is modified,
it will automatically toggled on the modified bit again. When the modified
bit flips, the buffer emits the  I<modified-changed> signal.

  method gtk_text_buffer_set_modified ( Int $setting )

=item Int $setting; modification flag setting

=end pod

sub gtk_text_buffer_set_modified ( N-GObject $buffer, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_has_selection:
=begin pod
=head2 [[gtk_] text_buffer_] get_has_selection

Indicates whether the buffer has some text currently selected.

Returns: C<1> if the there is text selected


  method gtk_text_buffer_get_has_selection ( --> Int  )


=end pod

sub gtk_text_buffer_get_has_selection ( N-GObject $buffer )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_add_selection_clipboard:
=begin pod
=head2 [[gtk_] text_buffer_] add_selection_clipboard

Adds I<clipboard> to the list of clipboards in which the selection
contents of I<buffer> are available. In most cases, I<clipboard> will be
the B<Gnome::Gtk3::Clipboard> of type C<GDK_SELECTION_PRIMARY> for a view of I<buffer>.

  method gtk_text_buffer_add_selection_clipboard ( N-GObject $clipboard )

=item N-GObject $clipboard; a B<Gnome::Gtk3::Clipboard>

=end pod

sub gtk_text_buffer_add_selection_clipboard ( N-GObject $buffer, N-GObject $clipboard )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_remove_selection_clipboard:
=begin pod
=head2 [[gtk_] text_buffer_] remove_selection_clipboard

Removes a B<Gnome::Gtk3::Clipboard> added with
C<gtk_text_buffer_add_selection_clipboard()>.

  method gtk_text_buffer_remove_selection_clipboard ( N-GObject $clipboard )

=item N-GObject $clipboard; a B<Gnome::Gtk3::Clipboard> added to I<buffer> by  C<gtk_text_buffer_add_selection_clipboard()>

=end pod

sub gtk_text_buffer_remove_selection_clipboard ( N-GObject $buffer, N-GObject $clipboard )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_cut_clipboard:
=begin pod
=head2 [[gtk_] text_buffer_] cut_clipboard

Copies the currently-selected text to a clipboard, then deletes
said text if it’s editable.

  method gtk_text_buffer_cut_clipboard ( N-GObject $clipboard, Int $default_editable )

=item N-GObject $clipboard; the B<Gnome::Gtk3::Clipboard> object to cut to
=item Int $default_editable; default editability of the buffer

=end pod

sub gtk_text_buffer_cut_clipboard ( N-GObject $buffer, N-GObject $clipboard, int32 $default_editable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_copy_clipboard:
=begin pod
=head2 [[gtk_] text_buffer_] copy_clipboard

Copies the currently-selected text to a clipboard.

  method gtk_text_buffer_copy_clipboard ( N-GObject $clipboard )

=item N-GObject $clipboard; the B<Gnome::Gtk3::Clipboard> object to copy to

=end pod

sub gtk_text_buffer_copy_clipboard ( N-GObject $buffer, N-GObject $clipboard )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_paste_clipboard:
=begin pod
=head2 [[gtk_] text_buffer_] paste_clipboard

Pastes the contents of a clipboard. If I<override_location> is C<Any>, the
pasted text will be inserted at the cursor position, or the buffer selection
will be replaced if the selection is non-empty.

Note: pasting is asynchronous, that is, we’ll ask for the paste data and
return, and at some point later after the main loop runs, the paste data will
be inserted.

  method gtk_text_buffer_paste_clipboard ( N-GObject $clipboard, N-GObject $override_location, Int $default_editable )

=item N-GObject $clipboard; the B<Gnome::Gtk3::Clipboard> to paste from
=item N-GObject $override_location; (allow-none): location to insert pasted text, or C<Any>
=item Int $default_editable; whether the buffer is editable by default

=end pod

sub gtk_text_buffer_paste_clipboard ( N-GObject $buffer, N-GObject $clipboard, N-GObject $override_location, int32 $default_editable )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_text_buffer_get_selection_bounds:
=begin pod
=head2 [[gtk_] text_buffer_] get_selection_bounds

Returns C<1> if some text is selected; places the bounds
of the selection in I<start> and I<end> (if the selection has length 0,
then I<start> and I<end> are filled in with the same value).
I<start> and I<end> will be in ascending order. If I<start> and I<end> are
NULL, then they are not filled in, but the return value still indicates
whether text is selected.

  method gtk_text_buffer_get_selection_bounds ( --> List )

Returned List contains
=item Int $status; C<1> when the selection has nonzero length
=item Gnome::Gtk3::TextIter $start; iterator to initialize with selection start
=item Gnome::Gtk3::TextIter $end; iterator to initialize with selection end

=end pod

sub gtk_text_buffer_get_selection_bounds ( N-GObject $buffer --> List ) {
#  my Gnome::Gtk3::TextIter $i1 .= new;
#  my N-GTextIter $no1 = $i1.get-native-object;
#  my Gnome::Gtk3::TextIter $i2 .= new;
#  my N-GTextIter $no2 = $i2.get-native-object;
  my N-GTextIter $no1 .= new;
  my N-GTextIter $no2 .= new;
  my Int $sts = _gtk_text_buffer_get_selection_bounds( $buffer, $no1, $no2);
#  $i1.set-native-object($no1);
#  $i2.set-native-object($no2);

  ( $sts,
    Gnome::Gtk3::TextIter.new(:native-object($no1)),
    Gnome::Gtk3::TextIter.new(:native-object($no2))
  )
}

sub _gtk_text_buffer_get_selection_bounds ( N-GObject $buffer, N-GTextIter $start, N-GTextIter $end )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_text_buffer_get_selection_bounds')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_delete_selection:
=begin pod
=head2 [[gtk_] text_buffer_] delete_selection

Deletes the range between the “insert” and “selection_bound” marks,
that is, the currently-selected text. If I<interactive> is C<1>,
the editability of the selection will be considered (users can’t delete
uneditable text).

Returns: whether there was a non-empty selection to delete

  method gtk_text_buffer_delete_selection ( Int $interactive, Int $default_editable --> Int  )

=item Int $interactive; whether the deletion is caused by user interaction
=item Int $default_editable; whether the buffer is editable by default

=end pod

sub gtk_text_buffer_delete_selection ( N-GObject $buffer, int32 $interactive, int32 $default_editable )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_begin_user_action:
=begin pod
=head2 [[gtk_] text_buffer_] begin_user_action

Called to indicate that the buffer operations between here and a
call to C<gtk_text_buffer_end_user_action()> are part of a single
user-visible operation. The operations between
C<gtk_text_buffer_begin_user_action()> and
C<gtk_text_buffer_end_user_action()> can then be grouped when creating
an undo stack. B<Gnome::Gtk3::TextBuffer> maintains a count of calls to
C<gtk_text_buffer_begin_user_action()> that have not been closed with
a call to C<gtk_text_buffer_end_user_action()>, and emits the
“begin-user-action” and “end-user-action” signals only for the
outermost pair of calls. This allows you to build user actions
from other user actions.

The “interactive” buffer mutation functions, such as
C<gtk_text_buffer_insert_interactive()>, automatically call begin/end
user action around the buffer operations they perform, so there's
no need to add extra calls if you user action consists solely of a
single call to one of those functions.

  method gtk_text_buffer_begin_user_action ( )


=end pod

sub gtk_text_buffer_begin_user_action ( N-GObject $buffer )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_end_user_action:
=begin pod
=head2 [[gtk_] text_buffer_] end_user_action

Should be paired with a call to C<gtk_text_buffer_begin_user_action()>.
See that function for a full explanation.

  method gtk_text_buffer_end_user_action ( )


=end pod

sub gtk_text_buffer_end_user_action ( N-GObject $buffer )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_copy_target_list:
=begin pod
=head2 [[gtk_] text_buffer_] get_copy_target_list

This function returns the list of targets this text buffer can
provide for copying and as DND source. The targets in the list are
added with I<info> values from the B<Gnome::Gtk3::TextBufferTargetInfo> enum,
using C<gtk_target_list_add_rich_text_targets()> and
C<gtk_target_list_add_text_targets()>.

Returns: (transfer none): the B<Gnome::Gtk3::TargetList>


  method gtk_text_buffer_get_copy_target_list ( --> GtkTargetList  )


=end pod

sub gtk_text_buffer_get_copy_target_list ( N-GObject $buffer )
  returns GtkTargetList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_buffer_get_paste_target_list:
=begin pod
=head2 [[gtk_] text_buffer_] get_paste_target_list

This function returns the list of targets this text buffer supports
for pasting and as DND destination. The targets in the list are
added with I<info> values from the B<Gnome::Gtk3::TextBufferTargetInfo> enum,
using C<gtk_target_list_add_rich_text_targets()> and
C<gtk_target_list_add_text_targets()>.

Returns: (transfer none): the B<Gnome::Gtk3::TargetList>


  method gtk_text_buffer_get_paste_target_list ( --> GtkTargetList  )


=end pod

sub gtk_text_buffer_get_paste_target_list ( N-GObject $buffer )
  returns GtkTargetList
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


=comment #TS:1:insert-text:
=head3 insert-text

The I<insert-text> signal is emitted to insert text in a B<Gnome::Gtk3::TextBuffer>.
Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not
invalidate the I<location> iter (or has to revalidate it).
The default signal handler revalidates it to point to the end of the
inserted text.

See also:
C<gtk_text_buffer_insert()>,
C<gtk_text_buffer_insert_range()>.

  method handler (
    N-GObject $location,
    Str $text,
    Int $len,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $location; position to insert I<text> in I<textbuffer>. A native GtkTextIter object.

=item $text; the UTF-8 text to be inserted

=item $len; length of the inserted text in bytes


=comment #TS:0:insert-pixbuf:
=head3 insert-pixbuf

The I<insert-pixbuf> signal is emitted to insert a B<Gnome::Gdk3::Pixbuf>
in a B<Gnome::Gtk3::TextBuffer>. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not
invalidate the I<location> iter (or has to revalidate it).
The default signal handler revalidates it to be placed after the
inserted I<pixbuf>.

See also: C<gtk_text_buffer_insert_pixbuf()>.

  method handler (
    N-GObject $location,
    N-GObject $pixbuf,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $location; position to insert I<pixbuf> in I<textbuffer>. A native GtkTextIter object.

=item $pixbuf; a native GdkPixbuf to be inserted


=comment #TS:0:insert-child-anchor:
=head3 insert-child-anchor

The I<insert-child-anchor> signal is emitted to insert a
B<Gnome::Gtk3::TextChildAnchor> in a B<Gnome::Gtk3::TextBuffer>.
Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must
not invalidate the I<location> iter (or has to revalidate it).
The default signal handler revalidates it to be placed after the
inserted I<anchor>.

See also: C<gtk_text_buffer_insert_child_anchor()>.

  method handler (
    N-GObject $location,
    N-GObject $anchor,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $location; position to insert I<anchor> in I<textbuffer>. A native GtkTextIter object.

=item $anchor; the native GtkTextChildAnchor object to be inserted


=comment #TS:0:delete-range:
=head3 delete-range

The I<delete-range> signal is emitted to delete a range
from a B<Gnome::Gtk3::TextBuffer>.

Note that if your handler runs before the default handler it must not
invalidate the I<start> and I<end> iters (or has to revalidate them).
The default signal handler revalidates the I<start> and I<end> iters to
both point to the location where text was deleted. Handlers
which run after the default handler (see C<g_signal_connect_after()>)
do not have access to the deleted text.

See also: C<gtk_text_buffer_delete()>.

  method handler (
    N-GObject $start,
    N-GObject $end,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $start; the start of the range to be deleted. A native GtkTextIter object.

=item $end; the end of the range to be deleted. A native GtkTextIter object.


=comment #TS:0:changed:
=head3 changed

The I<changed> signal is emitted when the content of a B<Gnome::Gtk3::TextBuffer>
has changed.

  method handler (
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal


=comment #TS:0:modified-changed:
=head3 modified-changed

The I<modified-changed> signal is emitted when the modified bit of a
B<Gnome::Gtk3::TextBuffer> flips.

See also:
C<gtk_text_buffer_set_modified()>.

  method handler (
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal


=comment #TS:0:mark-set:
=head3 mark-set

The I<mark-set> signal is emitted as notification
after a B<Gnome::Gtk3::TextMark> is set.

See also:
C<gtk_text_buffer_create_mark()>,
C<gtk_text_buffer_move_mark()>.

  method handler (
    N-GObject $location,
    N-GObject $mark,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $location; The location of I<mark> in I<textbuffer>. A native GtkTextIter object.

=item $mark; The mark that is set. A native GtkTextMark object.


=comment #TS:0:mark-deleted:
=head3 mark-deleted

The I<mark-deleted> signal is emitted as notification
after a B<Gnome::Gtk3::TextMark> is deleted.

See also:
C<gtk_text_buffer_delete_mark()>.

  method handler (
    N-GObject $mark,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $mark; The mark that was deleted. A native GtkTextMark object.


=comment #TS:0:apply-tag:
=head3 apply-tag

The I<apply-tag> signal is emitted to apply a tag to a
range of text in a B<Gnome::Gtk3::TextBuffer>.
Applying actually occurs in the default handler.

Note that if your handler runs before the default handler it must not
invalidate the I<start> and I<end> iters (or has to revalidate them).

See also:
C<gtk_text_buffer_apply_tag()>,
C<gtk_text_buffer_insert_with_tags()>,
C<gtk_text_buffer_insert_range()>.

  method handler (
    N-GObject $tag,
    N-GObject $start,
    N-GObject $end,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $tag; the applied tag. A native GtkTextTag object.

=item $start; the start of the range the tag is applied to. A native GtkTextIter object.

=item $end; the end of the range the tag is applied to. A native GtkTextIter object.


=comment #TS:0:remove-tag:
=head3 remove-tag

The I<remove-tag> signal is emitted to remove all occurrences of I<tag> from
a range of text in a B<Gnome::Gtk3::TextBuffer>.
Removal actually occurs in the default handler.

Note that if your handler runs before the default handler it must not
invalidate the I<start> and I<end> iters (or has to revalidate them).

See also:
C<gtk_text_buffer_remove_tag()>.

  method handler (
    N-GObject $tag,
    N-GObject $start,
    N-GObject $end,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $tag; the tag to be removed. A native GtkTextTag object.

=item $start; the start of the range the tag is removed from. A native GtkTextIter object.

=item $end; the end of the range the tag is removed from. A native GtkTextIter object.


=comment #TS:0:begin-user-action:
=head3 begin-user-action

The I<begin-user-action> signal is emitted at the beginning of a single
user-visible operation on a B<Gnome::Gtk3::TextBuffer>.

See also:
C<gtk_text_buffer_begin_user_action()>,
C<gtk_text_buffer_insert_interactive()>,
C<gtk_text_buffer_insert_range_interactive()>,
C<gtk_text_buffer_delete_interactive()>,
C<gtk_text_buffer_backspace()>,
C<gtk_text_buffer_delete_selection()>.

  method handler (
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal


=comment #TS:0:end-user-action:
=head3 end-user-action

The I<end-user-action> signal is emitted at the end of a single
user-visible operation on the B<Gnome::Gtk3::TextBuffer>.

See also:
C<gtk_text_buffer_end_user_action()>,
C<gtk_text_buffer_insert_interactive()>,
C<gtk_text_buffer_insert_range_interactive()>,
C<gtk_text_buffer_delete_interactive()>,
C<gtk_text_buffer_backspace()>,
C<gtk_text_buffer_delete_selection()>,
C<gtk_text_buffer_backspace()>.

  method handler (
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal


=comment #TS:0:paste-done:
=head3 paste-done

The paste-done signal is emitted after paste operation has been completed.
This is useful to properly scroll the view to the end of the pasted text.
See C<gtk_text_buffer_paste_clipboard()> for more details.


  method handler (
    N-GObject $clipboard,
    Gnome::GObject::Object :widget($textbuffer),
    *%user-options
  );

=item $textbuffer; the object which received the signal

=item $clipboard; the native GtkClipboard pasted from


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=begin comment
=comment #TP:0:tag-table:
=head3 Tag Table

Text Tag Table
Widget type: GTK_TYPE_TEXT_TAG_TABLE


The B<Gnome::GObject::Value> type of property I<tag-table> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:text:
=head3 Text


The text content of the buffer. Without child widgets and images,
see C<gtk_text_buffer_get_text()> for more information.

The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=comment #TP:0:has-selection:
=head3 Has selection


Whether the buffer has some text currently selected.

The B<Gnome::GObject::Value> type of property I<has-selection> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:cursor-position:
=head3 Cursor position


The position of the insert mark (as offset from the beginning
of the buffer). It is useful for getting notified when the
cursor moves.

The B<Gnome::GObject::Value> type of property I<cursor-position> is C<G_TYPE_INT>.

=begin comment
=comment #TP:0:copy-target-list:
=head3 Copy target list


The list of targets this buffer supports for clipboard copying
and as DND source.

The B<Gnome::GObject::Value> type of property I<copy-target-list> is C<G_TYPE_BOXED>.

=comment #TP:0:paste-target-list:
=head3 Paste target list


The list of targets this buffer supports for clipboard pasting
and as DND destination.

The B<Gnome::GObject::Value> type of property I<paste-target-list> is C<G_TYPE_BOXED>.
=end comment
=end pod
