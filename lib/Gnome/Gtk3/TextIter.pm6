#TL:1:Gnome::Gtk3::TextIter:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TextIter

Text buffer iterator

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextIter;
  also is Gnome::GObject::Boxed;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Glib::SList;
use Gnome::GObject::Boxed;
#use Gnome::Gtk3::TextBuffer;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextiter.h
# https://developer.gnome.org/gtk3/stable/GtkTextIter.html
# https://developer.gnome.org/gtk3/stable/TextWidget.html
unit class Gnome::Gtk3::TextIter:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# This is a representation of an opaque structure. Spelled out here
# to set proper size.
#TE:2:N-GTextIter:

class N-GTextIter is repr('CStruct') is export {
  has Pointer $!dummy1;
  has Pointer $!dummy2;
  has int32 $!dummy3;
  has int32 $!dummy4;
  has int32 $!dummy5;
  has int32 $!dummy6;
  has int32 $!dummy7;
  has int32 $!dummy8;
  has Pointer $!dummy9;
  has Pointer $!dummy10;
  has int32 $!dummy11;
  has int32 $!dummy12;
  # padding
  has int32 $!dummy13;
  has Pointer $!dummy14;
};
#`{{
class N-GTextIter
  is repr('CPointer')
  is export
  { }
}}
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextSearchFlags

Flags affecting how a search is done.

If neither C<GTK_TEXT_SEARCH_VISIBLE_ONLY> nor C<GTK_TEXT_SEARCH_TEXT_ONLY> are
enabled, the match must be exact; the special 0xFFFC character will match
embedded pixbufs or child widgets.


=item GTK_TEXT_SEARCH_VISIBLE_ONLY: Search only visible data. A search match may have invisible text interspersed.
=item GTK_TEXT_SEARCH_TEXT_ONLY: Search only text. A match may have pixbufs or child widgets mixed inside the matched range.
=item GTK_TEXT_SEARCH_CASE_INSENSITIVE: The text will be matched regardless of what case it is in.

=end pod

#TE:0:GtkTextSearchFlags:
enum GtkTextSearchFlags is export (
  'GTK_TEXT_SEARCH_VISIBLE_ONLY'     => 1 +< 0,
  'GTK_TEXT_SEARCH_TEXT_ONLY'        => 1 +< 1,
  'GTK_TEXT_SEARCH_CASE_INSENSITIVE' => 1 +< 2
);

=begin pod
=head1 Methods
=end pod

#`{{
=begin pod
=head2 new

Create a new plain object.

  multi method new ( )


Create a new object using a native object from elsewhere.

  multi method new ( Bool :$native-object! )
=end pod
}}

#TM:1:new():
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::TextIter';

  if self.is-valid { }

  # process all named arguments
  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self.set-native-object(N-GTextIter.new);
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkTextIter');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_text_iter_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkTextIter');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object --> N-GTextIter ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _gtk_text_iter_free($n-native-object);
}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_buffer:
=begin pod
=head2 [[gtk_] text_iter_] get_buffer

Returns the B<Gnome::Gtk3::TextBuffer> this iterator is associated with.

Returns: (transfer none): the buffer

  method gtk_text_iter_get_buffer ( --> N-GObject  )


=end pod

sub gtk_text_iter_get_buffer ( N-GTextIter $iter )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_copy:
=begin pod
=head2 [gtk_] text_iter_copy

Creates a dynamically-allocated copy of an iterator. This function
is not useful in applications, because iterators can be copied with a
simple assignment (`B<Gnome::Gtk3::TextIter> i = j;`). The
function is used by language bindings.

Returns: a copy of the I<iter>, free with C<gtk_text_iter_free()>

  method gtk_text_iter_copy ( --> N-GObject  )


=end pod

sub gtk_text_iter_copy ( N-GTextIter $iter --> N-GTextIter)
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{
#TM:0:_gtk_text_iter_free:
=begin pod
=head2 [gtk_] text_iter_free

Free an iterator allocated on the heap. This function
is intended for use in language bindings, and is not
especially useful for applications, because iterators can
simply be allocated on the stack.

  method gtk_text_iter_free ( )


=end pod
}}

sub _gtk_text_iter_free ( N-GTextIter $iter )
  is native(&gtk-lib)
  is symbol('gtk_text_iter_free')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_assign:
=begin pod
=head2 [gtk_] text_iter_assign

Assigns the value of I<other> to I<iter>.  This function
is not useful in applications, because iterators can be assigned
with `B<Gnome::Gtk3::TextIter> i = j;`. The
function is used by language bindings.

Since: 3.2

  method gtk_text_iter_assign ( N-GObject $other )

=item N-GObject $other; another B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_iter_assign ( N-GTextIter $iter, N-GObject $other )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_offset:
=begin pod
=head2 [[gtk_] text_iter_] get_offset

Returns the character offset of an iterator.
Each character in a B<Gnome::Gtk3::TextBuffer> has an offset,
starting with 0 for the first character in the buffer.
Use C<gtk_text_buffer_get_iter_at_offset()> to convert an
offset back into an iterator.

Returns: a character offset

  method gtk_text_iter_get_offset ( --> Int  )


=end pod

sub gtk_text_iter_get_offset ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_line:
=begin pod
=head2 [[gtk_] text_iter_] get_line

Returns the line number containing the iterator. Lines in
a B<Gnome::Gtk3::TextBuffer> are numbered beginning with 0 for the first
line in the buffer.

Returns: a line number

  method gtk_text_iter_get_line ( --> Int  )


=end pod

sub gtk_text_iter_get_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_line_offset:
=begin pod
=head2 [[gtk_] text_iter_] get_line_offset

Returns the character offset of the iterator,
counting from the start of a newline-terminated line.
The first character on the line has offset 0.

Returns: offset from start of line

  method gtk_text_iter_get_line_offset ( --> Int  )


=end pod

sub gtk_text_iter_get_line_offset ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_line_index:
=begin pod
=head2 [[gtk_] text_iter_] get_line_index

Returns the byte index of the iterator, counting
from the start of a newline-terminated line.
Remember that B<Gnome::Gtk3::TextBuffer> encodes text in
UTF-8, and that characters can require a variable
number of bytes to represent.

Returns: distance from start of line, in bytes

  method gtk_text_iter_get_line_index ( --> Int  )


=end pod

sub gtk_text_iter_get_line_index ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_visible_line_offset:
=begin pod
=head2 [[gtk_] text_iter_] get_visible_line_offset

Returns the offset in characters from the start of the
line to the given I<iter>, not counting characters that
are invisible due to tags with the “invisible” flag
toggled on.

Returns: offset in visible characters from the start of the line

  method gtk_text_iter_get_visible_line_offset ( --> Int  )


=end pod

sub gtk_text_iter_get_visible_line_offset ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_visible_line_index:
=begin pod
=head2 [[gtk_] text_iter_] get_visible_line_index

Returns the number of bytes from the start of the
line to the given I<iter>, not counting bytes that
are invisible due to tags with the “invisible” flag
toggled on.

Returns: byte index of I<iter> with respect to the start of the line

  method gtk_text_iter_get_visible_line_index ( --> Int  )


=end pod

sub gtk_text_iter_get_visible_line_index ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_char:
=begin pod
=head2 [[gtk_] text_iter_] get_char

The Unicode character at this iterator is returned.  (Equivalent to
operator* on a C++ iterator.)  If the element at this iterator is a
non-character element, such as an image embedded in the buffer, the
Unicode “unknown” character 0xFFFC is returned. If invoked on
the end iterator, zero is returned; zero is not a valid Unicode character.
So you can write a loop which ends when C<gtk_text_iter_get_char()>
returns 0.

Returns: a Unicode character, or 0 if I<iter> is not dereferenceable

  method gtk_text_iter_get_char ( --> uint32 )


=end pod

sub gtk_text_iter_get_char ( N-GTextIter $iter )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_slice:
=begin pod
=head2 [[gtk_] text_iter_] get_slice

Returns the text in the given range. A “slice” is an array of
characters encoded in UTF-8 format, including the Unicode “unknown”
character 0xFFFC for iterable non-character elements in the buffer,
such as images.  Because images are encoded in the slice, byte and
character offsets in the returned array will correspond to byte
offsets in the text buffer. Note that 0xFFFC can occur in normal
text as well, so it is not a reliable indicator that a pixbuf or
widget is in the buffer.

Returns: (transfer full): slice of text from the buffer

  method gtk_text_iter_get_slice ( N-GObject $end --> Str  )

=item N-GObject $end; iterator at end of a range

=end pod

sub gtk_text_iter_get_slice ( N-GTextIter $start, N-GTextIter $end )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_text_iter_get_text:TextBuffer.t
=begin pod
=head2 [[gtk_] text_iter_] get_text

Returns text in the given range.  If the range
contains non-text elements such as images, the character and byte
offsets in the returned string will not correspond to character and
byte offsets in the buffer. If you want offsets to correspond, see
C<gtk_text_iter_get_slice()>.

Returns: (transfer full): array of characters from the buffer

  method gtk_text_iter_get_text ( N-GObject $end --> Str  )

=item N-GObject $end; iterator at end of a range

=end pod

sub gtk_text_iter_get_text ( N-GTextIter $start, N-GTextIter $end )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_visible_slice:
=begin pod
=head2 [[gtk_] text_iter_] get_visible_slice

Like C<gtk_text_iter_get_slice()>, but invisible text is not included.
Invisible text is usually invisible because a B<Gnome::Gtk3::TextTag> with the
“invisible” attribute turned on has been applied to it.

Returns: (transfer full): slice of text from the buffer

  method gtk_text_iter_get_visible_slice ( N-GObject $end --> Str  )

=item N-GObject $end; iterator at end of range

=end pod

sub gtk_text_iter_get_visible_slice ( N-GTextIter $start, N-GTextIter $end )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_visible_text:
=begin pod
=head2 [[gtk_] text_iter_] get_visible_text

Like C<gtk_text_iter_get_text()>, but invisible text is not included.
Invisible text is usually invisible because a B<Gnome::Gtk3::TextTag> with the
“invisible” attribute turned on has been applied to it.

Returns: (transfer full): string containing visible text in the
range

  method gtk_text_iter_get_visible_text ( N-GObject $end --> Str  )

=item N-GObject $end; iterator at end of range

=end pod

sub gtk_text_iter_get_visible_text ( N-GTextIter $start, N-GTextIter $end )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_pixbuf:
=begin pod
=head2 [[gtk_] text_iter_] get_pixbuf

If the element at I<iter> is a pixbuf, the pixbuf is returned
(with no new reference count added). Otherwise,
C<Any> is returned.

Returns: (transfer none): the pixbuf at I<iter>

  method gtk_text_iter_get_pixbuf ( --> N-GObject  )


=end pod

sub gtk_text_iter_get_pixbuf ( N-GTextIter $iter )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_marks:
=begin pod
=head2 [[gtk_] text_iter_] get_marks

Returns a list of all B<Gnome::Gtk3::TextMark> at this location. Because marks
are not iterable (they don’t take up any "space" in the buffer,
they are just marks in between iterable locations), multiple marks
can exist in the same place. The returned list is not in any
meaningful order.

Returns: (element-type B<Gnome::Gtk3::TextMark>) (transfer container): list of B<Gnome::Gtk3::TextMark>

  method gtk_text_iter_get_marks ( --> N-GSList  )


=end pod

sub gtk_text_iter_get_marks ( N-GTextIter $iter )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_child_anchor:
=begin pod
=head2 [[gtk_] text_iter_] get_child_anchor

If the location at I<iter> contains a child anchor, the
anchor is returned (with no new reference count added). Otherwise,
C<Any> is returned.

Returns: (transfer none): the anchor at I<iter>

  method gtk_text_iter_get_child_anchor ( --> GtkTextChildAnchor  )


=end pod

sub gtk_text_iter_get_child_anchor ( N-GObject $iter )
  returns GtkTextChildAnchor
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_toggled_tags:
=begin pod
=head2 [[gtk_] text_iter_] get_toggled_tags

Returns a list of B<Gnome::Gtk3::TextTag> that are toggled on or off at this
point.  (If I<toggled_on> is C<1>, the list contains tags that are
toggled on.) If a tag is toggled on at I<iter>, then some non-empty
range of characters following I<iter> has that tag applied to it.  If
a tag is toggled off, then some non-empty range following I<iter>
does not have the tag applied to it.

Returns: (element-type B<Gnome::Gtk3::TextTag>) (transfer container): tags toggled at this point

  method gtk_text_iter_get_toggled_tags ( Int $toggled_on --> N-GSList  )

=item Int $toggled_on; C<1> to get toggled-on tags

=end pod

sub gtk_text_iter_get_toggled_tags ( N-GTextIter $iter, int32 $toggled_on )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_starts_tag:
=begin pod
=head2 [[gtk_] text_iter_] starts_tag

Returns C<1> if I<tag> is toggled on at exactly this point. If I<tag>
is C<Any>, returns C<1> if any tag is toggled on at this point.

Note that if C<gtk_text_iter_starts_tag()> returns C<1>, it means that I<iter> is
at the beginning of the tagged range, and that the
character at I<iter> is inside the tagged range. In other
words, unlike C<gtk_text_iter_ends_tag()>, if C<gtk_text_iter_starts_tag()> returns
C<1>, C<gtk_text_iter_has_tag()> will also return C<1> for the same
parameters.

Returns: whether I<iter> is the start of a range tagged with I<tag>
Since: 3.20

  method gtk_text_iter_starts_tag ( N-GObject $tag --> Int  )

=item N-GObject $tag; (nullable): a B<Gnome::Gtk3::TextTag>, or C<Any>

=end pod

sub gtk_text_iter_starts_tag ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_ends_tag:
=begin pod
=head2 [[gtk_] text_iter_] ends_tag

Returns C<1> if I<tag> is toggled off at exactly this point. If I<tag>
is C<Any>, returns C<1> if any tag is toggled off at this point.

Note that if C<gtk_text_iter_ends_tag()> returns C<1>, it means that I<iter> is
at the end of the tagged range, but that the character
at I<iter> is outside the tagged range. In other words,
unlike C<gtk_text_iter_starts_tag()>, if C<gtk_text_iter_ends_tag()> returns C<1>,
C<gtk_text_iter_has_tag()> will return C<0> for the same parameters.

Returns: whether I<iter> is the end of a range tagged with I<tag>

  method gtk_text_iter_ends_tag ( N-GObject $tag --> Int  )

=item N-GObject $tag; (allow-none): a B<Gnome::Gtk3::TextTag>, or C<Any>

=end pod

sub gtk_text_iter_ends_tag ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_toggles_tag:
=begin pod
=head2 [[gtk_] text_iter_] toggles_tag

This is equivalent to (C<gtk_text_iter_starts_tag()> ||
C<gtk_text_iter_ends_tag()>), i.e. it tells you whether a range with
I<tag> applied to it begins or ends at I<iter>.

Returns: whether I<tag> is toggled on or off at I<iter>

  method gtk_text_iter_toggles_tag ( N-GObject $tag --> Int  )

=item N-GObject $tag; (allow-none): a B<Gnome::Gtk3::TextTag>, or C<Any>

=end pod

sub gtk_text_iter_toggles_tag ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_has_tag:
=begin pod
=head2 [[gtk_] text_iter_] has_tag

Returns C<1> if I<iter> points to a character that is part of a range tagged
with I<tag>. See also C<gtk_text_iter_starts_tag()> and C<gtk_text_iter_ends_tag()>.

Returns: whether I<iter> is tagged with I<tag>

  method gtk_text_iter_has_tag ( N-GObject $tag --> Int  )

=item N-GObject $tag; a B<Gnome::Gtk3::TextTag>

=end pod

sub gtk_text_iter_has_tag ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_tags:
=begin pod
=head2 [[gtk_] text_iter_] get_tags

Returns a list of tags that apply to I<iter>, in ascending order of
priority (highest-priority tags are last). The B<Gnome::Gtk3::TextTag> in the
list don’t have a reference added, but you have to free the list
itself.

Returns: (element-type B<Gnome::Gtk3::TextTag>) (transfer container): list of B<Gnome::Gtk3::TextTag>

  method gtk_text_iter_get_tags ( --> N-GSList  )


=end pod

sub gtk_text_iter_get_tags ( N-GTextIter $iter )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_editable:
=begin pod
=head2 [gtk_] text_iter_editable

Returns whether the character at I<iter> is within an editable region
of text.  Non-editable text is “locked” and can’t be changed by the
user via B<Gnome::Gtk3::TextView>. This function is simply a convenience
wrapper around C<gtk_text_iter_get_attributes()>. If no tags applied
to this text affect editability, I<default_setting> will be returned.

You don’t want to use this function to decide whether text can be
inserted at I<iter>, because for insertion you don’t want to know
whether the char at I<iter> is inside an editable range, you want to
know whether a new character inserted at I<iter> would be inside an
editable range. Use C<gtk_text_iter_can_insert()> to handle this
case.

Returns: whether I<iter> is inside an editable range

  method gtk_text_iter_editable ( Int $default_setting --> Int  )

=item Int $default_setting; C<1> if text is editable by default

=end pod

sub gtk_text_iter_editable ( N-GTextIter $iter, int32 $default_setting )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_can_insert:
=begin pod
=head2 [[gtk_] text_iter_] can_insert

Considering the default editability of the buffer, and tags that
affect editability, determines whether text inserted at I<iter> would
be editable. If text inserted at I<iter> would be editable then the
user should be allowed to insert text at I<iter>.
C<gtk_text_buffer_insert_interactive()> uses this function to decide
whether insertions are allowed at a given position.

Returns: whether text inserted at I<iter> would be editable

  method gtk_text_iter_can_insert ( Int $default_editability --> Int  )

=item Int $default_editability; C<1> if text is editable by default

=end pod

sub gtk_text_iter_can_insert ( N-GTextIter $iter, int32 $default_editability )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_starts_word:
=begin pod
=head2 [[gtk_] text_iter_] starts_word

Determines whether I<iter> begins a natural-language word.  Word
breaks are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> is at the start of a word

  method gtk_text_iter_starts_word ( --> Int  )


=end pod

sub gtk_text_iter_starts_word ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_ends_word:
=begin pod
=head2 [[gtk_] text_iter_] ends_word

Determines whether I<iter> ends a natural-language word.  Word breaks
are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> is at the end of a word

  method gtk_text_iter_ends_word ( --> Int  )


=end pod

sub gtk_text_iter_ends_word ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_inside_word:
=begin pod
=head2 [[gtk_] text_iter_] inside_word

Determines whether the character pointed by I<iter> is part of a
natural-language word (as opposed to say inside some whitespace).  Word
breaks are determined by Pango and should be correct for nearly any language
(if not, the correct fix would be to the Pango word break algorithms).

Note that if C<gtk_text_iter_starts_word()> returns C<1>, then this function
returns C<1> too, since I<iter> points to the first character of the word.

Returns: C<1> if I<iter> is inside a word

  method gtk_text_iter_inside_word ( --> Int  )


=end pod

sub gtk_text_iter_inside_word ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_starts_sentence:
=begin pod
=head2 [[gtk_] text_iter_] starts_sentence

Determines whether I<iter> begins a sentence.  Sentence boundaries are
determined by Pango and should be correct for nearly any language
(if not, the correct fix would be to the Pango text boundary
algorithms).

Returns: C<1> if I<iter> is at the start of a sentence.

  method gtk_text_iter_starts_sentence ( --> Int  )


=end pod

sub gtk_text_iter_starts_sentence ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_ends_sentence:
=begin pod
=head2 [[gtk_] text_iter_] ends_sentence

Determines whether I<iter> ends a sentence.  Sentence boundaries are
determined by Pango and should be correct for nearly any language
(if not, the correct fix would be to the Pango text boundary
algorithms).

Returns: C<1> if I<iter> is at the end of a sentence.

  method gtk_text_iter_ends_sentence ( --> Int  )


=end pod

sub gtk_text_iter_ends_sentence ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_inside_sentence:
=begin pod
=head2 [[gtk_] text_iter_] inside_sentence

Determines whether I<iter> is inside a sentence (as opposed to in
between two sentences, e.g. after a period and before the first
letter of the next sentence).  Sentence boundaries are determined
by Pango and should be correct for nearly any language (if not, the
correct fix would be to the Pango text boundary algorithms).

Returns: C<1> if I<iter> is inside a sentence.

  method gtk_text_iter_inside_sentence ( --> Int  )


=end pod

sub gtk_text_iter_inside_sentence ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_starts_line:
=begin pod
=head2 [[gtk_] text_iter_] starts_line

Returns C<1> if I<iter> begins a paragraph,
i.e. if C<gtk_text_iter_get_line_offset()> would return 0.
However this function is potentially more efficient than
C<gtk_text_iter_get_line_offset()> because it doesn’t have to compute
the offset, it just has to see whether it’s 0.

Returns: whether I<iter> begins a line

  method gtk_text_iter_starts_line ( --> Int  )


=end pod

sub gtk_text_iter_starts_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_ends_line:
=begin pod
=head2 [[gtk_] text_iter_] ends_line

Returns C<1> if I<iter> points to the start of the paragraph
delimiter characters for a line (delimiters will be either a
newline, a carriage return, a carriage return followed by a
newline, or a Unicode paragraph separator character). Note that an
iterator pointing to the \n of a \r\n pair will not be counted as
the end of a line, the line ends before the \r. The end iterator is
considered to be at the end of a line, even though there are no
paragraph delimiter chars there.

Returns: whether I<iter> is at the end of a line

  method gtk_text_iter_ends_line ( --> Int  )


=end pod

sub gtk_text_iter_ends_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_is_cursor_position:
=begin pod
=head2 [[gtk_] text_iter_] is_cursor_position

See C<gtk_text_iter_forward_cursor_position()> or B<PangoLogAttr> or
C<pango_break()> for details on what a cursor position is.

Returns: C<1> if the cursor can be placed at I<iter>

  method gtk_text_iter_is_cursor_position ( --> Int  )


=end pod

sub gtk_text_iter_is_cursor_position ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_chars_in_line:
=begin pod
=head2 [[gtk_] text_iter_] get_chars_in_line

Returns the number of characters in the line containing I<iter>,
including the paragraph delimiters.

Returns: number of characters in the line

  method gtk_text_iter_get_chars_in_line ( --> Int  )


=end pod

sub gtk_text_iter_get_chars_in_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_bytes_in_line:
=begin pod
=head2 [[gtk_] text_iter_] get_bytes_in_line

Returns the number of bytes in the line containing I<iter>,
including the paragraph delimiters.

Returns: number of bytes in the line

  method gtk_text_iter_get_bytes_in_line ( --> Int  )


=end pod

sub gtk_text_iter_get_bytes_in_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_attributes:
=begin pod
=head2 [[gtk_] text_iter_] get_attributes

Computes the effect of any tags applied to this spot in the
text. The I<values> parameter should be initialized to the default
settings you wish to use if no tags are in effect. You’d typically
obtain the defaults from C<gtk_text_view_get_default_attributes()>.

C<gtk_text_iter_get_attributes()> will modify I<values>, applying the
effects of any tags present at I<iter>. If any tags affected I<values>,
the function returns C<1>.

Returns: C<1> if I<values> was modified

  method gtk_text_iter_get_attributes ( N-GObject $values --> Int  )

=item N-GObject $values; (out): a B<Gnome::Gtk3::TextAttributes> to be filled in

=end pod

sub gtk_text_iter_get_attributes ( N-GTextIter $iter, N-GObject $values )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_get_language:
=begin pod
=head2 [[gtk_] text_iter_] get_language

A convenience wrapper around C<gtk_text_iter_get_attributes()>,
which returns the language in effect at I<iter>. If no tags affecting
language apply to I<iter>, the return value is identical to that of
C<gtk_get_default_language()>.

Returns: (transfer full): language in effect at I<iter>

  method gtk_text_iter_get_language ( --> PangoLanguage  )


=end pod

sub gtk_text_iter_get_language ( N-GTextIter $iter )
  returns PangoLanguage
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_is_end:
=begin pod
=head2 [[gtk_] text_iter_] is_end

Returns C<1> if I<iter> is the end iterator, i.e. one past the last
dereferenceable iterator in the buffer. C<gtk_text_iter_is_end()> is
the most efficient way to check whether an iterator is the end
iterator.

Returns: whether I<iter> is the end iterator

  method gtk_text_iter_is_end ( --> Int  )


=end pod

sub gtk_text_iter_is_end ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_is_start:
=begin pod
=head2 [[gtk_] text_iter_] is_start

Returns C<1> if I<iter> is the first iterator in the buffer, that is
if I<iter> has a character offset of 0.

Returns: whether I<iter> is the first in the buffer

  method gtk_text_iter_is_start ( --> Int  )


=end pod

sub gtk_text_iter_is_start ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_char:
=begin pod
=head2 [[gtk_] text_iter_] forward_char

Moves I<iter> forward by one character offset. Note that images
embedded in the buffer occupy 1 character slot, so
C<gtk_text_iter_forward_char()> may actually move onto an image instead
of a character, if you have images in your buffer.  If I<iter> is the
end iterator or one character before it, I<iter> will now point at
the end iterator, and C<gtk_text_iter_forward_char()> returns C<0> for
convenience when writing loops.

Returns: whether I<iter> moved and is dereferenceable

  method gtk_text_iter_forward_char ( --> Int  )


=end pod

sub gtk_text_iter_forward_char ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_char:
=begin pod
=head2 [[gtk_] text_iter_] backward_char

Moves backward by one character offset. Returns C<1> if movement
was possible; if I<iter> was the first in the buffer (character
offset 0), C<gtk_text_iter_backward_char()> returns C<0> for convenience when
writing loops.

Returns: whether movement was possible

  method gtk_text_iter_backward_char ( --> Int  )


=end pod

sub gtk_text_iter_backward_char ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_chars:
=begin pod
=head2 [[gtk_] text_iter_] forward_chars

Moves I<count> characters if possible (if I<count> would move past the
start or end of the buffer, moves to the start or end of the
buffer). The return value indicates whether the new position of
I<iter> is different from its original position, and dereferenceable
(the last iterator in the buffer is not dereferenceable). If I<count>
is 0, the function does nothing and returns C<0>.

Returns: whether I<iter> moved and is dereferenceable

  method gtk_text_iter_forward_chars ( Int $count --> Int  )

=item Int $count; number of characters to move, may be negative

=end pod

sub gtk_text_iter_forward_chars ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_chars:
=begin pod
=head2 [[gtk_] text_iter_] backward_chars

Moves I<count> characters backward, if possible (if I<count> would move
past the start or end of the buffer, moves to the start or end of
the buffer).  The return value indicates whether the iterator moved
onto a dereferenceable position; if the iterator didn’t move, or
moved onto the end iterator, then C<0> is returned. If I<count> is 0,
the function does nothing and returns C<0>.

Returns: whether I<iter> moved and is dereferenceable


  method gtk_text_iter_backward_chars ( Int $count --> Int  )

=item Int $count; number of characters to move

=end pod

sub gtk_text_iter_backward_chars ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_line:
=begin pod
=head2 [[gtk_] text_iter_] forward_line

Moves I<iter> to the start of the next line. If the iter is already on the
last line of the buffer, moves the iter to the end of the current line.
If after the operation, the iter is at the end of the buffer and not
dereferencable, returns C<0>. Otherwise, returns C<1>.

Returns: whether I<iter> can be dereferenced

  method gtk_text_iter_forward_line ( --> Int  )


=end pod

sub gtk_text_iter_forward_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_line:
=begin pod
=head2 [[gtk_] text_iter_] backward_line

Moves I<iter> to the start of the previous line. Returns C<1> if
I<iter> could be moved; i.e. if I<iter> was at character offset 0, this
function returns C<0>. Therefore if I<iter> was already on line 0,
but not at the start of the line, I<iter> is snapped to the start of
the line and the function returns C<1>. (Note that this implies that
in a loop calling this function, the line number may not change on
every iteration, if your first iteration is on line 0.)

Returns: whether I<iter> moved

  method gtk_text_iter_backward_line ( --> Int  )


=end pod

sub gtk_text_iter_backward_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_lines:
=begin pod
=head2 [[gtk_] text_iter_] forward_lines

Moves I<count> lines forward, if possible (if I<count> would move
past the start or end of the buffer, moves to the start or end of
the buffer).  The return value indicates whether the iterator moved
onto a dereferenceable position; if the iterator didn’t move, or
moved onto the end iterator, then C<0> is returned. If I<count> is 0,
the function does nothing and returns C<0>. If I<count> is negative,
moves backward by 0 - I<count> lines.

Returns: whether I<iter> moved and is dereferenceable

  method gtk_text_iter_forward_lines ( Int $count --> Int  )

=item Int $count; number of lines to move forward

=end pod

sub gtk_text_iter_forward_lines ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_lines:
=begin pod
=head2 [[gtk_] text_iter_] backward_lines

Moves I<count> lines backward, if possible (if I<count> would move
past the start or end of the buffer, moves to the start or end of
the buffer).  The return value indicates whether the iterator moved
onto a dereferenceable position; if the iterator didn’t move, or
moved onto the end iterator, then C<0> is returned. If I<count> is 0,
the function does nothing and returns C<0>. If I<count> is negative,
moves forward by 0 - I<count> lines.

Returns: whether I<iter> moved and is dereferenceable

  method gtk_text_iter_backward_lines ( Int $count --> Int  )

=item Int $count; number of lines to move backward

=end pod

sub gtk_text_iter_backward_lines ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_word_end:
=begin pod
=head2 [[gtk_] text_iter_] forward_word_end

Moves forward to the next word end. (If I<iter> is currently on a
word end, moves forward to the next one after that.) Word breaks
are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_forward_word_end ( --> Int  )


=end pod

sub gtk_text_iter_forward_word_end ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_word_start:
=begin pod
=head2 [[gtk_] text_iter_] backward_word_start

Moves backward to the previous word start. (If I<iter> is currently on a
word start, moves backward to the next one after that.) Word breaks
are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_backward_word_start ( --> Int  )


=end pod

sub gtk_text_iter_backward_word_start ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_word_ends:
=begin pod
=head2 [[gtk_] text_iter_] forward_word_ends

Calls C<gtk_text_iter_forward_word_end()> up to I<count> times.

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_forward_word_ends ( Int $count --> Int  )

=item Int $count; number of times to move

=end pod

sub gtk_text_iter_forward_word_ends ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_word_starts:
=begin pod
=head2 [[gtk_] text_iter_] backward_word_starts

Calls C<gtk_text_iter_backward_word_start()> up to I<count> times.

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_backward_word_starts ( Int $count --> Int  )

=item Int $count; number of times to move

=end pod

sub gtk_text_iter_backward_word_starts ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_line:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_line

Moves I<iter> to the start of the next visible line. Returns C<1> if there
was a next line to move to, and C<0> if I<iter> was simply moved to
the end of the buffer and is now not dereferenceable, or if I<iter> was
already at the end of the buffer.

Returns: whether I<iter> can be dereferenced

Since: 2.8

  method gtk_text_iter_forward_visible_line ( --> Int  )


=end pod

sub gtk_text_iter_forward_visible_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_line:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_line

Moves I<iter> to the start of the previous visible line. Returns C<1> if
I<iter> could be moved; i.e. if I<iter> was at character offset 0, this
function returns C<0>. Therefore if I<iter> was already on line 0,
but not at the start of the line, I<iter> is snapped to the start of
the line and the function returns C<1>. (Note that this implies that
in a loop calling this function, the line number may not change on
every iteration, if your first iteration is on line 0.)

Returns: whether I<iter> moved

Since: 2.8

  method gtk_text_iter_backward_visible_line ( --> Int  )


=end pod

sub gtk_text_iter_backward_visible_line ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_lines:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_lines

Moves I<count> visible lines forward, if possible (if I<count> would move
past the start or end of the buffer, moves to the start or end of
the buffer).  The return value indicates whether the iterator moved
onto a dereferenceable position; if the iterator didn’t move, or
moved onto the end iterator, then C<0> is returned. If I<count> is 0,
the function does nothing and returns C<0>. If I<count> is negative,
moves backward by 0 - I<count> lines.

Returns: whether I<iter> moved and is dereferenceable

Since: 2.8

  method gtk_text_iter_forward_visible_lines ( Int $count --> Int  )

=item Int $count; number of lines to move forward

=end pod

sub gtk_text_iter_forward_visible_lines ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_lines:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_lines

Moves I<count> visible lines backward, if possible (if I<count> would move
past the start or end of the buffer, moves to the start or end of
the buffer).  The return value indicates whether the iterator moved
onto a dereferenceable position; if the iterator didn’t move, or
moved onto the end iterator, then C<0> is returned. If I<count> is 0,
the function does nothing and returns C<0>. If I<count> is negative,
moves forward by 0 - I<count> lines.

Returns: whether I<iter> moved and is dereferenceable

Since: 2.8

  method gtk_text_iter_backward_visible_lines ( Int $count --> Int  )

=item Int $count; number of lines to move backward

=end pod

sub gtk_text_iter_backward_visible_lines ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_word_end:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_word_end

Moves forward to the next visible word end. (If I<iter> is currently on a
word end, moves forward to the next one after that.) Word breaks
are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

Since: 2.4

  method gtk_text_iter_forward_visible_word_end ( --> Int  )


=end pod

sub gtk_text_iter_forward_visible_word_end ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_word_start:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_word_start

Moves backward to the previous visible word start. (If I<iter> is currently
on a word start, moves backward to the next one after that.) Word breaks
are determined by Pango and should be correct for nearly any
language (if not, the correct fix would be to the Pango word break
algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

Since: 2.4

  method gtk_text_iter_backward_visible_word_start ( --> Int  )


=end pod

sub gtk_text_iter_backward_visible_word_start ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_word_ends:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_word_ends

Calls C<gtk_text_iter_forward_visible_word_end()> up to I<count> times.

Returns: C<1> if I<iter> moved and is not the end iterator

Since: 2.4

  method gtk_text_iter_forward_visible_word_ends ( Int $count --> Int  )

=item Int $count; number of times to move

=end pod

sub gtk_text_iter_forward_visible_word_ends ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_word_starts:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_word_starts

Calls C<gtk_text_iter_backward_visible_word_start()> up to I<count> times.

Returns: C<1> if I<iter> moved and is not the end iterator

Since: 2.4

  method gtk_text_iter_backward_visible_word_starts ( Int $count --> Int  )

=item Int $count; number of times to move

=end pod

sub gtk_text_iter_backward_visible_word_starts ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_sentence_end:
=begin pod
=head2 [[gtk_] text_iter_] forward_sentence_end

Moves forward to the next sentence end. (If I<iter> is at the end of
a sentence, moves to the next end of sentence.)  Sentence
boundaries are determined by Pango and should be correct for nearly
any language (if not, the correct fix would be to the Pango text
boundary algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_forward_sentence_end ( --> Int  )


=end pod

sub gtk_text_iter_forward_sentence_end ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_sentence_start:
=begin pod
=head2 [[gtk_] text_iter_] backward_sentence_start

Moves backward to the previous sentence start; if I<iter> is already at
the start of a sentence, moves backward to the next one.  Sentence
boundaries are determined by Pango and should be correct for nearly
any language (if not, the correct fix would be to the Pango text
boundary algorithms).

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_backward_sentence_start ( --> Int  )


=end pod

sub gtk_text_iter_backward_sentence_start ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_sentence_ends:
=begin pod
=head2 [[gtk_] text_iter_] forward_sentence_ends

Calls C<gtk_text_iter_forward_sentence_end()> I<count> times (or until
C<gtk_text_iter_forward_sentence_end()> returns C<0>). If I<count> is
negative, moves backward instead of forward.

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_forward_sentence_ends ( Int $count --> Int  )

=item Int $count; number of sentences to move

=end pod

sub gtk_text_iter_forward_sentence_ends ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_sentence_starts:
=begin pod
=head2 [[gtk_] text_iter_] backward_sentence_starts

Calls C<gtk_text_iter_backward_sentence_start()> up to I<count> times,
or until it returns C<0>. If I<count> is negative, moves forward
instead of backward.

Returns: C<1> if I<iter> moved and is not the end iterator

  method gtk_text_iter_backward_sentence_starts ( Int $count --> Int  )

=item Int $count; number of sentences to move

=end pod

sub gtk_text_iter_backward_sentence_starts ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_cursor_position:
=begin pod
=head2 [[gtk_] text_iter_] forward_cursor_position

Moves I<iter> forward by a single cursor position. Cursor positions
are (unsurprisingly) positions where the cursor can appear. Perhaps
surprisingly, there may not be a cursor position between all
characters. The most common example for European languages would be
a carriage return/newline sequence. For some Unicode characters,
the equivalent of say the letter “a” with an accent mark will be
represented as two characters, first the letter then a "combining
mark" that causes the accent to be rendered; so the cursor can’t go
between those two characters. See also the B<PangoLogAttr>-struct and
C<pango_break()> function.

Returns: C<1> if we moved and the new position is dereferenceable

  method gtk_text_iter_forward_cursor_position ( --> Int  )


=end pod

sub gtk_text_iter_forward_cursor_position ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_cursor_position:
=begin pod
=head2 [[gtk_] text_iter_] backward_cursor_position

Like C<gtk_text_iter_forward_cursor_position()>, but moves backward.

Returns: C<1> if we moved

  method gtk_text_iter_backward_cursor_position ( --> Int  )


=end pod

sub gtk_text_iter_backward_cursor_position ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_cursor_positions:
=begin pod
=head2 [[gtk_] text_iter_] forward_cursor_positions

Moves up to I<count> cursor positions. See
C<gtk_text_iter_forward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

  method gtk_text_iter_forward_cursor_positions ( Int $count --> Int  )

=item Int $count; number of positions to move

=end pod

sub gtk_text_iter_forward_cursor_positions ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_cursor_positions:
=begin pod
=head2 [[gtk_] text_iter_] backward_cursor_positions

Moves up to I<count> cursor positions. See
C<gtk_text_iter_forward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

  method gtk_text_iter_backward_cursor_positions ( Int $count --> Int  )

=item Int $count; number of positions to move

=end pod

sub gtk_text_iter_backward_cursor_positions ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_cursor_position:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_cursor_position

Moves I<iter> forward to the next visible cursor position. See
C<gtk_text_iter_forward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

Since: 2.4

  method gtk_text_iter_forward_visible_cursor_position ( --> Int  )


=end pod

sub gtk_text_iter_forward_visible_cursor_position ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_cursor_position:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_cursor_position

Moves I<iter> forward to the previous visible cursor position. See
C<gtk_text_iter_backward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

Since: 2.4

  method gtk_text_iter_backward_visible_cursor_position ( --> Int  )


=end pod

sub gtk_text_iter_backward_visible_cursor_position ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_visible_cursor_positions:
=begin pod
=head2 [[gtk_] text_iter_] forward_visible_cursor_positions

Moves up to I<count> visible cursor positions. See
C<gtk_text_iter_forward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

Since: 2.4

  method gtk_text_iter_forward_visible_cursor_positions ( Int $count --> Int  )

=item Int $count; number of positions to move

=end pod

sub gtk_text_iter_forward_visible_cursor_positions ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_visible_cursor_positions:
=begin pod
=head2 [[gtk_] text_iter_] backward_visible_cursor_positions

Moves up to I<count> visible cursor positions. See
C<gtk_text_iter_backward_cursor_position()> for details.

Returns: C<1> if we moved and the new position is dereferenceable

Since: 2.4

  method gtk_text_iter_backward_visible_cursor_positions ( Int $count --> Int  )

=item Int $count; number of positions to move

=end pod

sub gtk_text_iter_backward_visible_cursor_positions ( N-GTextIter $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_offset:
=begin pod
=head2 [[gtk_] text_iter_] set_offset

Sets I<iter> to point to I<char_offset>. I<char_offset> counts from the start
of the entire text buffer, starting with 0.

  method gtk_text_iter_set_offset ( Int $char_offset )

=item Int $char_offset; a character number

=end pod

sub gtk_text_iter_set_offset ( N-GTextIter $iter, int32 $char_offset )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_line:
=begin pod
=head2 [[gtk_] text_iter_] set_line

Moves iterator I<iter> to the start of the line I<line_number>.  If
I<line_number> is negative or larger than the number of lines in the
buffer, moves I<iter> to the start of the last line in the buffer.


  method gtk_text_iter_set_line ( Int $line_number )

=item Int $line_number; line number (counted from 0)

=end pod

sub gtk_text_iter_set_line ( N-GTextIter $iter, int32 $line_number )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_line_offset:
=begin pod
=head2 [[gtk_] text_iter_] set_line_offset

Moves I<iter> within a line, to a new character
(not byte) offset. The given character offset must be less than or
equal to the number of characters in the line; if equal, I<iter>
moves to the start of the next line. See
C<gtk_text_iter_set_line_index()> if you have a byte index rather than
a character offset.


  method gtk_text_iter_set_line_offset ( Int $char_on_line )

=item Int $char_on_line; a character offset relative to the start of I<iter>’s current line

=end pod

sub gtk_text_iter_set_line_offset ( N-GTextIter $iter, int32 $char_on_line )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_line_index:
=begin pod
=head2 [[gtk_] text_iter_] set_line_index

Same as C<gtk_text_iter_set_line_offset()>, but works with a
byte index. The given byte index must be at
the start of a character, it can’t be in the middle of a UTF-8
encoded character.


  method gtk_text_iter_set_line_index ( Int $byte_on_line )

=item Int $byte_on_line; a byte index relative to the start of I<iter>’s current line

=end pod

sub gtk_text_iter_set_line_index ( N-GTextIter $iter, int32 $byte_on_line )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_to_end:
=begin pod
=head2 [[gtk_] text_iter_] forward_to_end

Moves I<iter> forward to the “end iterator,” which points one past the last
valid character in the buffer. C<gtk_text_iter_get_char()> called on the
end iterator returns 0, which is convenient for writing loops.

  method gtk_text_iter_forward_to_end ( )


=end pod

sub gtk_text_iter_forward_to_end ( N-GTextIter $iter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_to_line_end:
=begin pod
=head2 [[gtk_] text_iter_] forward_to_line_end

Moves the iterator to point to the paragraph delimiter characters,
which will be either a newline, a carriage return, a carriage
return/newline in sequence, or the Unicode paragraph separator
character. If the iterator is already at the paragraph delimiter
characters, moves to the paragraph delimiter characters for the
next line. If I<iter> is on the last line in the buffer, which does
not end in paragraph delimiters, moves to the end iterator (end of
the last line), and returns C<0>.

Returns: C<1> if we moved and the new location is not the end iterator

  method gtk_text_iter_forward_to_line_end ( --> Int  )


=end pod

sub gtk_text_iter_forward_to_line_end ( N-GTextIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_visible_line_offset:
=begin pod
=head2 [[gtk_] text_iter_] set_visible_line_offset

Like C<gtk_text_iter_set_line_offset()>, but the offset is in visible
characters, i.e. text with a tag making it invisible is not
counted in the offset.

  method gtk_text_iter_set_visible_line_offset ( Int $char_on_line )

=item Int $char_on_line; a character offset

=end pod

sub gtk_text_iter_set_visible_line_offset ( N-GTextIter $iter, int32 $char_on_line )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_set_visible_line_index:
=begin pod
=head2 [[gtk_] text_iter_] set_visible_line_index

Like C<gtk_text_iter_set_line_index()>, but the index is in visible
bytes, i.e. text with a tag making it invisible is not counted
in the index.

  method gtk_text_iter_set_visible_line_index ( Int $byte_on_line )

=item Int $byte_on_line; a byte index

=end pod

sub gtk_text_iter_set_visible_line_index ( N-GTextIter $iter, int32 $byte_on_line )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_to_tag_toggle:
=begin pod
=head2 [[gtk_] text_iter_] forward_to_tag_toggle

Moves forward to the next toggle (on or off) of the
B<Gnome::Gtk3::TextTag> I<tag>, or to the next toggle of any tag if
I<tag> is C<Any>. If no matching tag toggles are found,
returns C<0>, otherwise C<1>. Does not return toggles
located at I<iter>, only toggles after I<iter>. Sets I<iter> to
the location of the toggle, or to the end of the buffer
if no toggle is found.

Returns: whether we found a tag toggle after I<iter>

  method gtk_text_iter_forward_to_tag_toggle ( N-GObject $tag --> Int  )

=item N-GObject $tag; (allow-none): a B<Gnome::Gtk3::TextTag>, or C<Any>

=end pod

sub gtk_text_iter_forward_to_tag_toggle ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_to_tag_toggle:
=begin pod
=head2 [[gtk_] text_iter_] backward_to_tag_toggle

Moves backward to the next toggle (on or off) of the
B<Gnome::Gtk3::TextTag> I<tag>, or to the next toggle of any tag if
I<tag> is C<Any>. If no matching tag toggles are found,
returns C<0>, otherwise C<1>. Does not return toggles
located at I<iter>, only toggles before I<iter>. Sets I<iter>
to the location of the toggle, or the start of the buffer
if no toggle is found.

Returns: whether we found a tag toggle before I<iter>

  method gtk_text_iter_backward_to_tag_toggle ( N-GObject $tag --> Int  )

=item N-GObject $tag; (allow-none): a B<Gnome::Gtk3::TextTag>, or C<Any>

=end pod

sub gtk_text_iter_backward_to_tag_toggle ( N-GTextIter $iter, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_find_char:
=begin pod
=head2 [[gtk_] text_iter_] forward_find_char

Advances I<iter>, calling I<pred> on each character. If
I<pred> returns C<1>, returns C<1> and stops scanning.
If I<pred> never returns C<1>, I<iter> is set to I<limit> if
I<limit> is non-C<Any>, otherwise to the end iterator.

Returns: whether a match was found

  method gtk_text_iter_forward_find_char ( GtkTextCharPredicate $pred, Pointer $user_data, N-GObject $limit --> Int  )

=item GtkTextCharPredicate $pred; (scope call): a function to be called on each character
=item Pointer $user_data; user data for I<pred>
=item N-GObject $limit; (allow-none): search limit, or C<Any> for none

=end pod

sub gtk_text_iter_forward_find_char ( N-GTextIter $iter, GtkTextCharPredicate $pred, Pointer $user_data, N-GObject $limit )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_find_char:
=begin pod
=head2 [[gtk_] text_iter_] backward_find_char

Same as C<gtk_text_iter_forward_find_char()>, but goes backward from I<iter>.

Returns: whether a match was found

  method gtk_text_iter_backward_find_char ( GtkTextCharPredicate $pred, Pointer $user_data, N-GObject $limit --> Int  )

=item GtkTextCharPredicate $pred; (scope call): function to be called on each character
=item Pointer $user_data; user data for I<pred>
=item N-GObject $limit; (allow-none): search limit, or C<Any> for none

=end pod

sub gtk_text_iter_backward_find_char ( N-GTextIter $iter, GtkTextCharPredicate $pred, Pointer $user_data, N-GObject $limit )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_forward_search:
=begin pod
=head2 [[gtk_] text_iter_] forward_search

Searches forward for I<str>. Any match is returned by setting
I<match_start> to the first character of the match and I<match_end> to the
first character after the match. The search will not continue past
I<limit>. Note that a search is a linear or O(n) operation, so you
may wish to use I<limit> to avoid locking up your UI on large
buffers.

I<match_start> will never be set to a B<Gnome::Gtk3::TextIter> located before I<iter>, even if
there is a possible I<match_end> after or at I<iter>.

Returns: whether a match was found

  method gtk_text_iter_forward_search ( Str $str, GtkTextSearchFlags $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit --> Int  )

=item Str $str; a search string
=item GtkTextSearchFlags $flags; flags affecting how the search is done
=item N-GObject $match_start; (out caller-allocates) (allow-none): return location for start of match, or C<Any>
=item N-GObject $match_end; (out caller-allocates) (allow-none): return location for end of match, or C<Any>
=item N-GObject $limit; (allow-none): location of last possible I<match_end>, or C<Any> for the end of the buffer

=end pod

sub gtk_text_iter_forward_search ( N-GTextIter $iter, Str $str, int32 $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_backward_search:
=begin pod
=head2 [[gtk_] text_iter_] backward_search

Same as C<gtk_text_iter_forward_search()>, but moves backward.

I<match_end> will never be set to a B<Gnome::Gtk3::TextIter> located after I<iter>, even if
there is a possible I<match_start> before or at I<iter>.

Returns: whether a match was found

  method gtk_text_iter_backward_search ( Str $str, GtkTextSearchFlags $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit --> Int  )

=item Str $str; search string
=item GtkTextSearchFlags $flags; bitmask of flags affecting the search
=item N-GObject $match_start; (out caller-allocates) (allow-none): return location for start of match, or C<Any>
=item N-GObject $match_end; (out caller-allocates) (allow-none): return location for end of match, or C<Any>
=item N-GObject $limit; (allow-none): location of last possible I<match_start>, or C<Any> for start of buffer

=end pod

sub gtk_text_iter_backward_search ( N-GTextIter $iter, Str $str, int32 $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_equal:
=begin pod
=head2 [gtk_] text_iter_equal

Tests whether two iterators are equal, using the fastest possible
mechanism. This function is very fast; you can expect it to perform
better than e.g. getting the character offset for each iterator and
comparing the offsets yourself. Also, it’s a bit faster than
C<gtk_text_iter_compare()>.

Returns: C<1> if the iterators point to the same place in the buffer

  method gtk_text_iter_equal ( N-GTextIter $rhs --> Int  )

=item N-GTextIter $rhs; another B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_iter_equal ( N-GTextIter $lhs, N-GTextIter $rhs )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_compare:
=begin pod
=head2 [gtk_] text_iter_compare

A C<qsort()>-style function that returns negative if I<lhs> is less than
I<rhs>, positive if I<lhs> is greater than I<rhs>, and 0 if they’re equal.
Ordering is in character offset order, i.e. the first character in the buffer
is less than the second character in the buffer.

Returns: -1 if I<lhs> is less than I<rhs>, 1 if I<lhs> is greater, 0 if they are equal

  method gtk_text_iter_compare ( N-GTextIter $rhs --> Int  )

=item N-GTextIter $rhs; another B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_iter_compare ( N-GTextIter $lhs, N-GTextIter $rhs )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_in_range:
=begin pod
=head2 [[gtk_] text_iter_] in_range

Checks whether I<iter> falls in the range [I<start>, I<end>).
I<start> and I<end> must be in ascending order.

Returns: C<1> if I<iter> is in the range

  method gtk_text_iter_in_range ( N-GTextIter $start, N-GTextIter $end --> Int  )

=item N-GTextIter $start; start of range
=item N-GTextIter $end; end of range

=end pod

sub gtk_text_iter_in_range ( N-GTextIter $iter, N-GTextIter $start, N-GTextIter $end )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_iter_order:
=begin pod
=head2 [gtk_] text_iter_order

Swaps the value of I<first> and I<second> if I<second> comes before
I<first> in the buffer. That is, ensures that I<first> and I<second> are
in sequence. Most text buffer functions that take a range call this
automatically on your behalf, so there’s no real reason to call it yourself
in those cases. There are some exceptions, such as C<gtk_text_iter_in_range()>,
that expect a pre-sorted range.


  method gtk_text_iter_order ( N-GTextIter $second )

=item N-GTextIter $second; another B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_iter_order ( N-GTextIter $first, N-GTextIter $second )
  is native(&gtk-lib)
  { * }
