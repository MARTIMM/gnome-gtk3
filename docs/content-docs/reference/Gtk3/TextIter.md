Gnome::Gtk3::TextIter
=====================

Text buffer iterator

Description
===========

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextIter;
    also is Gnome::GObject::Boxed;

enum GtkTextSearchFlags
-----------------------

Flags affecting how a search is done.

If neither `GTK_TEXT_SEARCH_VISIBLE_ONLY` nor `GTK_TEXT_SEARCH_TEXT_ONLY` are enabled, the match must be exact; the special 0xFFFC character will match embedded pixbufs or child widgets.

  * GTK_TEXT_SEARCH_VISIBLE_ONLY: Search only visible data. A search match may have invisible text interspersed.

  * GTK_TEXT_SEARCH_TEXT_ONLY: Search only text. A match may have pixbufs or child widgets mixed inside the matched range.

  * GTK_TEXT_SEARCH_CASE_INSENSITIVE: The text will be matched regardless of what case it is in.

Methods
=======

[[gtk_] text_iter_] get_buffer
------------------------------

Returns the **Gnome::Gtk3::TextBuffer** this iterator is associated with.

Returns: (transfer none): the buffer

    method gtk_text_iter_get_buffer ( --> N-GObject  )

[gtk_] text_iter_copy
---------------------

Creates a dynamically-allocated copy of an iterator. This function is not useful in applications, because iterators can be copied with a simple assignment (`**Gnome::Gtk3::TextIter** i = j;`). The function is used by language bindings.

Returns: a copy of the *iter*, free with `gtk_text_iter_free()`

    method gtk_text_iter_copy ( --> N-GObject  )

[gtk_] text_iter_assign
-----------------------

Assigns the value of *other* to *iter*. This function is not useful in applications, because iterators can be assigned with `**Gnome::Gtk3::TextIter** i = j;`. The function is used by language bindings.

Since: 3.2

    method gtk_text_iter_assign ( N-GObject $other )

  * N-GObject $other; another **Gnome::Gtk3::TextIter**

[[gtk_] text_iter_] get_offset
------------------------------

Returns the character offset of an iterator. Each character in a **Gnome::Gtk3::TextBuffer** has an offset, starting with 0 for the first character in the buffer. Use `gtk_text_buffer_get_iter_at_offset()` to convert an offset back into an iterator.

Returns: a character offset

    method gtk_text_iter_get_offset ( --> Int  )

[[gtk_] text_iter_] get_line
----------------------------

Returns the line number containing the iterator. Lines in a **Gnome::Gtk3::TextBuffer** are numbered beginning with 0 for the first line in the buffer.

Returns: a line number

    method gtk_text_iter_get_line ( --> Int  )

[[gtk_] text_iter_] get_line_offset
-----------------------------------

Returns the character offset of the iterator, counting from the start of a newline-terminated line. The first character on the line has offset 0.

Returns: offset from start of line

    method gtk_text_iter_get_line_offset ( --> Int  )

[[gtk_] text_iter_] get_line_index
----------------------------------

Returns the byte index of the iterator, counting from the start of a newline-terminated line. Remember that **Gnome::Gtk3::TextBuffer** encodes text in UTF-8, and that characters can require a variable number of bytes to represent.

Returns: distance from start of line, in bytes

    method gtk_text_iter_get_line_index ( --> Int  )

[[gtk_] text_iter_] get_visible_line_offset
-------------------------------------------

Returns the offset in characters from the start of the line to the given *iter*, not counting characters that are invisible due to tags with the “invisible” flag toggled on.

Returns: offset in visible characters from the start of the line

    method gtk_text_iter_get_visible_line_offset ( --> Int  )

[[gtk_] text_iter_] get_visible_line_index
------------------------------------------

Returns the number of bytes from the start of the line to the given *iter*, not counting bytes that are invisible due to tags with the “invisible” flag toggled on.

Returns: byte index of *iter* with respect to the start of the line

    method gtk_text_iter_get_visible_line_index ( --> Int  )

[[gtk_] text_iter_] get_char
----------------------------

The Unicode character at this iterator is returned. (Equivalent to operator* on a C++ iterator.) If the element at this iterator is a non-character element, such as an image embedded in the buffer, the Unicode “unknown” character 0xFFFC is returned. If invoked on the end iterator, zero is returned; zero is not a valid Unicode character. So you can write a loop which ends when `gtk_text_iter_get_char()` returns 0.

Returns: a Unicode character, or 0 if *iter* is not dereferenceable

    method gtk_text_iter_get_char ( --> uint32 )

[[gtk_] text_iter_] get_slice
-----------------------------

Returns the text in the given range. A “slice” is an array of characters encoded in UTF-8 format, including the Unicode “unknown” character 0xFFFC for iterable non-character elements in the buffer, such as images. Because images are encoded in the slice, byte and character offsets in the returned array will correspond to byte offsets in the text buffer. Note that 0xFFFC can occur in normal text as well, so it is not a reliable indicator that a pixbuf or widget is in the buffer.

Returns: (transfer full): slice of text from the buffer

    method gtk_text_iter_get_slice ( N-GObject $end --> Str  )

  * N-GObject $end; iterator at end of a range

[[gtk_] text_iter_] get_text
----------------------------

Returns text in the given range. If the range contains non-text elements such as images, the character and byte offsets in the returned string will not correspond to character and byte offsets in the buffer. If you want offsets to correspond, see `gtk_text_iter_get_slice()`.

Returns: (transfer full): array of characters from the buffer

    method gtk_text_iter_get_text ( N-GObject $end --> Str  )

  * N-GObject $end; iterator at end of a range

[[gtk_] text_iter_] get_visible_slice
-------------------------------------

Like `gtk_text_iter_get_slice()`, but invisible text is not included. Invisible text is usually invisible because a **Gnome::Gtk3::TextTag** with the “invisible” attribute turned on has been applied to it.

Returns: (transfer full): slice of text from the buffer

    method gtk_text_iter_get_visible_slice ( N-GObject $end --> Str  )

  * N-GObject $end; iterator at end of range

[[gtk_] text_iter_] get_visible_text
------------------------------------

Like `gtk_text_iter_get_text()`, but invisible text is not included. Invisible text is usually invisible because a **Gnome::Gtk3::TextTag** with the “invisible” attribute turned on has been applied to it.

Returns: (transfer full): string containing visible text in the range

    method gtk_text_iter_get_visible_text ( N-GObject $end --> Str  )

  * N-GObject $end; iterator at end of range

[[gtk_] text_iter_] get_pixbuf
------------------------------

If the element at *iter* is a pixbuf, the pixbuf is returned (with no new reference count added). Otherwise, `Any` is returned.

Returns: (transfer none): the pixbuf at *iter*

    method gtk_text_iter_get_pixbuf ( --> N-GObject  )

[[gtk_] text_iter_] get_marks
-----------------------------

Returns a list of all **Gnome::Gtk3::TextMark** at this location. Because marks are not iterable (they don’t take up any "space" in the buffer, they are just marks in between iterable locations), multiple marks can exist in the same place. The returned list is not in any meaningful order.

Returns: (element-type **Gnome::Gtk3::TextMark**) (transfer container): list of **Gnome::Gtk3::TextMark**

    method gtk_text_iter_get_marks ( --> N-GSList  )

[[gtk_] text_iter_] get_toggled_tags
------------------------------------

Returns a list of **Gnome::Gtk3::TextTag** that are toggled on or off at this point. (If *toggled_on* is `1`, the list contains tags that are toggled on.) If a tag is toggled on at *iter*, then some non-empty range of characters following *iter* has that tag applied to it. If a tag is toggled off, then some non-empty range following *iter* does not have the tag applied to it.

Returns: (element-type **Gnome::Gtk3::TextTag**) (transfer container): tags toggled at this point

    method gtk_text_iter_get_toggled_tags ( Int $toggled_on --> N-GSList  )

  * Int $toggled_on; `1` to get toggled-on tags

[[gtk_] text_iter_] starts_tag
------------------------------

Returns `1` if *tag* is toggled on at exactly this point. If *tag* is `Any`, returns `1` if any tag is toggled on at this point.

Note that if `gtk_text_iter_starts_tag()` returns `1`, it means that *iter* is at the beginning of the tagged range, and that the character at *iter* is inside the tagged range. In other words, unlike `gtk_text_iter_ends_tag()`, if `gtk_text_iter_starts_tag()` returns `1`, `gtk_text_iter_has_tag()` will also return `1` for the same parameters.

Returns: whether *iter* is the start of a range tagged with *tag* Since: 3.20

    method gtk_text_iter_starts_tag ( N-GObject $tag --> Int  )

  * N-GObject $tag; (nullable): a **Gnome::Gtk3::TextTag**, or `Any`

[[gtk_] text_iter_] ends_tag
----------------------------

Returns `1` if *tag* is toggled off at exactly this point. If *tag* is `Any`, returns `1` if any tag is toggled off at this point.

Note that if `gtk_text_iter_ends_tag()` returns `1`, it means that *iter* is at the end of the tagged range, but that the character at *iter* is outside the tagged range. In other words, unlike `gtk_text_iter_starts_tag()`, if `gtk_text_iter_ends_tag()` returns `1`, `gtk_text_iter_has_tag()` will return `0` for the same parameters.

Returns: whether *iter* is the end of a range tagged with *tag*

    method gtk_text_iter_ends_tag ( N-GObject $tag --> Int  )

  * N-GObject $tag; (allow-none): a **Gnome::Gtk3::TextTag**, or `Any`

[[gtk_] text_iter_] toggles_tag
-------------------------------

This is equivalent to (`gtk_text_iter_starts_tag()` || `gtk_text_iter_ends_tag()`), i.e. it tells you whether a range with *tag* applied to it begins or ends at *iter*.

Returns: whether *tag* is toggled on or off at *iter*

    method gtk_text_iter_toggles_tag ( N-GObject $tag --> Int  )

  * N-GObject $tag; (allow-none): a **Gnome::Gtk3::TextTag**, or `Any`

[[gtk_] text_iter_] has_tag
---------------------------

Returns `1` if *iter* points to a character that is part of a range tagged with *tag*. See also `gtk_text_iter_starts_tag()` and `gtk_text_iter_ends_tag()`.

Returns: whether *iter* is tagged with *tag*

    method gtk_text_iter_has_tag ( N-GObject $tag --> Int  )

  * N-GObject $tag; a **Gnome::Gtk3::TextTag**

[[gtk_] text_iter_] get_tags
----------------------------

Returns a list of tags that apply to *iter*, in ascending order of priority (highest-priority tags are last). The **Gnome::Gtk3::TextTag** in the list don’t have a reference added, but you have to free the list itself.

Returns: (element-type **Gnome::Gtk3::TextTag**) (transfer container): list of **Gnome::Gtk3::TextTag**

    method gtk_text_iter_get_tags ( --> N-GSList  )

[gtk_] text_iter_editable
-------------------------

Returns whether the character at *iter* is within an editable region of text. Non-editable text is “locked” and can’t be changed by the user via **Gnome::Gtk3::TextView**. This function is simply a convenience wrapper around `gtk_text_iter_get_attributes()`. If no tags applied to this text affect editability, *default_setting* will be returned.

You don’t want to use this function to decide whether text can be inserted at *iter*, because for insertion you don’t want to know whether the char at *iter* is inside an editable range, you want to know whether a new character inserted at *iter* would be inside an editable range. Use `gtk_text_iter_can_insert()` to handle this case.

Returns: whether *iter* is inside an editable range

    method gtk_text_iter_editable ( Int $default_setting --> Int  )

  * Int $default_setting; `1` if text is editable by default

[[gtk_] text_iter_] can_insert
------------------------------

Considering the default editability of the buffer, and tags that affect editability, determines whether text inserted at *iter* would be editable. If text inserted at *iter* would be editable then the user should be allowed to insert text at *iter*. `gtk_text_buffer_insert_interactive()` uses this function to decide whether insertions are allowed at a given position.

Returns: whether text inserted at *iter* would be editable

    method gtk_text_iter_can_insert ( Int $default_editability --> Int  )

  * Int $default_editability; `1` if text is editable by default

[[gtk_] text_iter_] starts_word
-------------------------------

Determines whether *iter* begins a natural-language word. Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* is at the start of a word

    method gtk_text_iter_starts_word ( --> Int  )

[[gtk_] text_iter_] ends_word
-----------------------------

Determines whether *iter* ends a natural-language word. Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* is at the end of a word

    method gtk_text_iter_ends_word ( --> Int  )

[[gtk_] text_iter_] inside_word
-------------------------------

Determines whether the character pointed by *iter* is part of a natural-language word (as opposed to say inside some whitespace). Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Note that if `gtk_text_iter_starts_word()` returns `1`, then this function returns `1` too, since *iter* points to the first character of the word.

Returns: `1` if *iter* is inside a word

    method gtk_text_iter_inside_word ( --> Int  )

[[gtk_] text_iter_] starts_sentence
-----------------------------------

Determines whether *iter* begins a sentence. Sentence boundaries are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango text boundary algorithms).

Returns: `1` if *iter* is at the start of a sentence.

    method gtk_text_iter_starts_sentence ( --> Int  )

[[gtk_] text_iter_] ends_sentence
---------------------------------

Determines whether *iter* ends a sentence. Sentence boundaries are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango text boundary algorithms).

Returns: `1` if *iter* is at the end of a sentence.

    method gtk_text_iter_ends_sentence ( --> Int  )

[[gtk_] text_iter_] inside_sentence
-----------------------------------

Determines whether *iter* is inside a sentence (as opposed to in between two sentences, e.g. after a period and before the first letter of the next sentence). Sentence boundaries are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango text boundary algorithms).

Returns: `1` if *iter* is inside a sentence.

    method gtk_text_iter_inside_sentence ( --> Int  )

[[gtk_] text_iter_] starts_line
-------------------------------

Returns `1` if *iter* begins a paragraph, i.e. if `gtk_text_iter_get_line_offset()` would return 0. However this function is potentially more efficient than `gtk_text_iter_get_line_offset()` because it doesn’t have to compute the offset, it just has to see whether it’s 0.

Returns: whether *iter* begins a line

    method gtk_text_iter_starts_line ( --> Int  )

[[gtk_] text_iter_] ends_line
-----------------------------

Returns `1` if *iter* points to the start of the paragraph delimiter characters for a line (delimiters will be either a newline, a carriage return, a carriage return followed by a newline, or a Unicode paragraph separator character). Note that an iterator pointing to the \n of a \r\n pair will not be counted as the end of a line, the line ends before the \r. The end iterator is considered to be at the end of a line, even though there are no paragraph delimiter chars there.

Returns: whether *iter* is at the end of a line

    method gtk_text_iter_ends_line ( --> Int  )

[[gtk_] text_iter_] is_cursor_position
--------------------------------------

See `gtk_text_iter_forward_cursor_position()` or **PangoLogAttr** or `pango_break()` for details on what a cursor position is.

Returns: `1` if the cursor can be placed at *iter*

    method gtk_text_iter_is_cursor_position ( --> Int  )

[[gtk_] text_iter_] get_chars_in_line
-------------------------------------

Returns the number of characters in the line containing *iter*, including the paragraph delimiters.

Returns: number of characters in the line

    method gtk_text_iter_get_chars_in_line ( --> Int  )

[[gtk_] text_iter_] get_bytes_in_line
-------------------------------------

Returns the number of bytes in the line containing *iter*, including the paragraph delimiters.

Returns: number of bytes in the line

    method gtk_text_iter_get_bytes_in_line ( --> Int  )

[[gtk_] text_iter_] get_attributes
----------------------------------

Computes the effect of any tags applied to this spot in the text. The *values* parameter should be initialized to the default settings you wish to use if no tags are in effect. You’d typically obtain the defaults from `gtk_text_view_get_default_attributes()`.

`gtk_text_iter_get_attributes()` will modify *values*, applying the effects of any tags present at *iter*. If any tags affected *values*, the function returns `1`.

Returns: `1` if *values* was modified

    method gtk_text_iter_get_attributes ( N-GObject $values --> Int  )

  * N-GObject $values; (out): a **Gnome::Gtk3::TextAttributes** to be filled in

[[gtk_] text_iter_] is_end
--------------------------

Returns `1` if *iter* is the end iterator, i.e. one past the last dereferenceable iterator in the buffer. `gtk_text_iter_is_end()` is the most efficient way to check whether an iterator is the end iterator.

Returns: whether *iter* is the end iterator

    method gtk_text_iter_is_end ( --> Int  )

[[gtk_] text_iter_] is_start
----------------------------

Returns `1` if *iter* is the first iterator in the buffer, that is if *iter* has a character offset of 0.

Returns: whether *iter* is the first in the buffer

    method gtk_text_iter_is_start ( --> Int  )

[[gtk_] text_iter_] forward_char
--------------------------------

Moves *iter* forward by one character offset. Note that images embedded in the buffer occupy 1 character slot, so `gtk_text_iter_forward_char()` may actually move onto an image instead of a character, if you have images in your buffer. If *iter* is the end iterator or one character before it, *iter* will now point at the end iterator, and `gtk_text_iter_forward_char()` returns `0` for convenience when writing loops.

Returns: whether *iter* moved and is dereferenceable

    method gtk_text_iter_forward_char ( --> Int  )

[[gtk_] text_iter_] backward_char
---------------------------------

Moves backward by one character offset. Returns `1` if movement was possible; if *iter* was the first in the buffer (character offset 0), `gtk_text_iter_backward_char()` returns `0` for convenience when writing loops.

Returns: whether movement was possible

    method gtk_text_iter_backward_char ( --> Int  )

[[gtk_] text_iter_] forward_chars
---------------------------------

Moves *count* characters if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the new position of *iter* is different from its original position, and dereferenceable (the last iterator in the buffer is not dereferenceable). If *count* is 0, the function does nothing and returns `0`.

Returns: whether *iter* moved and is dereferenceable

    method gtk_text_iter_forward_chars ( Int $count --> Int  )

  * Int $count; number of characters to move, may be negative

[[gtk_] text_iter_] backward_chars
----------------------------------

Moves *count* characters backward, if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the iterator moved onto a dereferenceable position; if the iterator didn’t move, or moved onto the end iterator, then `0` is returned. If *count* is 0, the function does nothing and returns `0`.

Returns: whether *iter* moved and is dereferenceable

    method gtk_text_iter_backward_chars ( Int $count --> Int  )

  * Int $count; number of characters to move

[[gtk_] text_iter_] forward_line
--------------------------------

Moves *iter* to the start of the next line. If the iter is already on the last line of the buffer, moves the iter to the end of the current line. If after the operation, the iter is at the end of the buffer and not dereferencable, returns `0`. Otherwise, returns `1`.

Returns: whether *iter* can be dereferenced

    method gtk_text_iter_forward_line ( --> Int  )

[[gtk_] text_iter_] backward_line
---------------------------------

Moves *iter* to the start of the previous line. Returns `1` if *iter* could be moved; i.e. if *iter* was at character offset 0, this function returns `0`. Therefore if *iter* was already on line 0, but not at the start of the line, *iter* is snapped to the start of the line and the function returns `1`. (Note that this implies that in a loop calling this function, the line number may not change on every iteration, if your first iteration is on line 0.)

Returns: whether *iter* moved

    method gtk_text_iter_backward_line ( --> Int  )

[[gtk_] text_iter_] forward_lines
---------------------------------

Moves *count* lines forward, if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the iterator moved onto a dereferenceable position; if the iterator didn’t move, or moved onto the end iterator, then `0` is returned. If *count* is 0, the function does nothing and returns `0`. If *count* is negative, moves backward by 0 - *count* lines.

Returns: whether *iter* moved and is dereferenceable

    method gtk_text_iter_forward_lines ( Int $count --> Int  )

  * Int $count; number of lines to move forward

[[gtk_] text_iter_] backward_lines
----------------------------------

Moves *count* lines backward, if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the iterator moved onto a dereferenceable position; if the iterator didn’t move, or moved onto the end iterator, then `0` is returned. If *count* is 0, the function does nothing and returns `0`. If *count* is negative, moves forward by 0 - *count* lines.

Returns: whether *iter* moved and is dereferenceable

    method gtk_text_iter_backward_lines ( Int $count --> Int  )

  * Int $count; number of lines to move backward

[[gtk_] text_iter_] forward_word_end
------------------------------------

Moves forward to the next word end. (If *iter* is currently on a word end, moves forward to the next one after that.) Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_forward_word_end ( --> Int  )

[[gtk_] text_iter_] backward_word_start
---------------------------------------

Moves backward to the previous word start. (If *iter* is currently on a word start, moves backward to the next one after that.) Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_backward_word_start ( --> Int  )

[[gtk_] text_iter_] forward_word_ends
-------------------------------------

Calls `gtk_text_iter_forward_word_end()` up to *count* times.

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_forward_word_ends ( Int $count --> Int  )

  * Int $count; number of times to move

[[gtk_] text_iter_] backward_word_starts
----------------------------------------

Calls `gtk_text_iter_backward_word_start()` up to *count* times.

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_backward_word_starts ( Int $count --> Int  )

  * Int $count; number of times to move

[[gtk_] text_iter_] forward_visible_line
----------------------------------------

Moves *iter* to the start of the next visible line. Returns `1` if there was a next line to move to, and `0` if *iter* was simply moved to the end of the buffer and is now not dereferenceable, or if *iter* was already at the end of the buffer.

Returns: whether *iter* can be dereferenced

Since: 2.8

    method gtk_text_iter_forward_visible_line ( --> Int  )

[[gtk_] text_iter_] backward_visible_line
-----------------------------------------

Moves *iter* to the start of the previous visible line. Returns `1` if *iter* could be moved; i.e. if *iter* was at character offset 0, this function returns `0`. Therefore if *iter* was already on line 0, but not at the start of the line, *iter* is snapped to the start of the line and the function returns `1`. (Note that this implies that in a loop calling this function, the line number may not change on every iteration, if your first iteration is on line 0.)

Returns: whether *iter* moved

Since: 2.8

    method gtk_text_iter_backward_visible_line ( --> Int  )

[[gtk_] text_iter_] forward_visible_lines
-----------------------------------------

Moves *count* visible lines forward, if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the iterator moved onto a dereferenceable position; if the iterator didn’t move, or moved onto the end iterator, then `0` is returned. If *count* is 0, the function does nothing and returns `0`. If *count* is negative, moves backward by 0 - *count* lines.

Returns: whether *iter* moved and is dereferenceable

Since: 2.8

    method gtk_text_iter_forward_visible_lines ( Int $count --> Int  )

  * Int $count; number of lines to move forward

[[gtk_] text_iter_] backward_visible_lines
------------------------------------------

Moves *count* visible lines backward, if possible (if *count* would move past the start or end of the buffer, moves to the start or end of the buffer). The return value indicates whether the iterator moved onto a dereferenceable position; if the iterator didn’t move, or moved onto the end iterator, then `0` is returned. If *count* is 0, the function does nothing and returns `0`. If *count* is negative, moves forward by 0 - *count* lines.

Returns: whether *iter* moved and is dereferenceable

Since: 2.8

    method gtk_text_iter_backward_visible_lines ( Int $count --> Int  )

  * Int $count; number of lines to move backward

[[gtk_] text_iter_] forward_visible_word_end
--------------------------------------------

Moves forward to the next visible word end. (If *iter* is currently on a word end, moves forward to the next one after that.) Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* moved and is not the end iterator

Since: 2.4

    method gtk_text_iter_forward_visible_word_end ( --> Int  )

[[gtk_] text_iter_] backward_visible_word_start
-----------------------------------------------

Moves backward to the previous visible word start. (If *iter* is currently on a word start, moves backward to the next one after that.) Word breaks are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango word break algorithms).

Returns: `1` if *iter* moved and is not the end iterator

Since: 2.4

    method gtk_text_iter_backward_visible_word_start ( --> Int  )

[[gtk_] text_iter_] forward_visible_word_ends
---------------------------------------------

Calls `gtk_text_iter_forward_visible_word_end()` up to *count* times.

Returns: `1` if *iter* moved and is not the end iterator

Since: 2.4

    method gtk_text_iter_forward_visible_word_ends ( Int $count --> Int  )

  * Int $count; number of times to move

[[gtk_] text_iter_] backward_visible_word_starts
------------------------------------------------

Calls `gtk_text_iter_backward_visible_word_start()` up to *count* times.

Returns: `1` if *iter* moved and is not the end iterator

Since: 2.4

    method gtk_text_iter_backward_visible_word_starts ( Int $count --> Int  )

  * Int $count; number of times to move

[[gtk_] text_iter_] forward_sentence_end
----------------------------------------

Moves forward to the next sentence end. (If *iter* is at the end of a sentence, moves to the next end of sentence.) Sentence boundaries are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango text boundary algorithms).

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_forward_sentence_end ( --> Int  )

[[gtk_] text_iter_] backward_sentence_start
-------------------------------------------

Moves backward to the previous sentence start; if *iter* is already at the start of a sentence, moves backward to the next one. Sentence boundaries are determined by Pango and should be correct for nearly any language (if not, the correct fix would be to the Pango text boundary algorithms).

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_backward_sentence_start ( --> Int  )

[[gtk_] text_iter_] forward_sentence_ends
-----------------------------------------

Calls `gtk_text_iter_forward_sentence_end()` *count* times (or until `gtk_text_iter_forward_sentence_end()` returns `0`). If *count* is negative, moves backward instead of forward.

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_forward_sentence_ends ( Int $count --> Int  )

  * Int $count; number of sentences to move

[[gtk_] text_iter_] backward_sentence_starts
--------------------------------------------

Calls `gtk_text_iter_backward_sentence_start()` up to *count* times, or until it returns `0`. If *count* is negative, moves forward instead of backward.

Returns: `1` if *iter* moved and is not the end iterator

    method gtk_text_iter_backward_sentence_starts ( Int $count --> Int  )

  * Int $count; number of sentences to move

[[gtk_] text_iter_] forward_cursor_position
-------------------------------------------

Moves *iter* forward by a single cursor position. Cursor positions are (unsurprisingly) positions where the cursor can appear. Perhaps surprisingly, there may not be a cursor position between all characters. The most common example for European languages would be a carriage return/newline sequence. For some Unicode characters, the equivalent of say the letter “a” with an accent mark will be represented as two characters, first the letter then a "combining mark" that causes the accent to be rendered; so the cursor can’t go between those two characters. See also the **PangoLogAttr**-struct and `pango_break()` function.

Returns: `1` if we moved and the new position is dereferenceable

    method gtk_text_iter_forward_cursor_position ( --> Int  )

[[gtk_] text_iter_] backward_cursor_position
--------------------------------------------

Like `gtk_text_iter_forward_cursor_position()`, but moves backward.

Returns: `1` if we moved

    method gtk_text_iter_backward_cursor_position ( --> Int  )

[[gtk_] text_iter_] forward_cursor_positions
--------------------------------------------

Moves up to *count* cursor positions. See `gtk_text_iter_forward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

    method gtk_text_iter_forward_cursor_positions ( Int $count --> Int  )

  * Int $count; number of positions to move

[[gtk_] text_iter_] backward_cursor_positions
---------------------------------------------

Moves up to *count* cursor positions. See `gtk_text_iter_forward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

    method gtk_text_iter_backward_cursor_positions ( Int $count --> Int  )

  * Int $count; number of positions to move

[[gtk_] text_iter_] forward_visible_cursor_position
---------------------------------------------------

Moves *iter* forward to the next visible cursor position. See `gtk_text_iter_forward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

Since: 2.4

    method gtk_text_iter_forward_visible_cursor_position ( --> Int  )

[[gtk_] text_iter_] backward_visible_cursor_position
----------------------------------------------------

Moves *iter* forward to the previous visible cursor position. See `gtk_text_iter_backward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

Since: 2.4

    method gtk_text_iter_backward_visible_cursor_position ( --> Int  )

[[gtk_] text_iter_] forward_visible_cursor_positions
----------------------------------------------------

Moves up to *count* visible cursor positions. See `gtk_text_iter_forward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

Since: 2.4

    method gtk_text_iter_forward_visible_cursor_positions ( Int $count --> Int  )

  * Int $count; number of positions to move

[[gtk_] text_iter_] backward_visible_cursor_positions
-----------------------------------------------------

Moves up to *count* visible cursor positions. See `gtk_text_iter_backward_cursor_position()` for details.

Returns: `1` if we moved and the new position is dereferenceable

Since: 2.4

    method gtk_text_iter_backward_visible_cursor_positions ( Int $count --> Int  )

  * Int $count; number of positions to move

[[gtk_] text_iter_] set_offset
------------------------------

Sets *iter* to point to *char_offset*. *char_offset* counts from the start of the entire text buffer, starting with 0.

    method gtk_text_iter_set_offset ( Int $char_offset )

  * Int $char_offset; a character number

[[gtk_] text_iter_] set_line
----------------------------

Moves iterator *iter* to the start of the line *line_number*. If *line_number* is negative or larger than the number of lines in the buffer, moves *iter* to the start of the last line in the buffer.

    method gtk_text_iter_set_line ( Int $line_number )

  * Int $line_number; line number (counted from 0)

[[gtk_] text_iter_] set_line_offset
-----------------------------------

Moves *iter* within a line, to a new character (not byte) offset. The given character offset must be less than or equal to the number of characters in the line; if equal, *iter* moves to the start of the next line. See `gtk_text_iter_set_line_index()` if you have a byte index rather than a character offset.

    method gtk_text_iter_set_line_offset ( Int $char_on_line )

  * Int $char_on_line; a character offset relative to the start of *iter*’s current line

[[gtk_] text_iter_] set_line_index
----------------------------------

Same as `gtk_text_iter_set_line_offset()`, but works with a byte index. The given byte index must be at the start of a character, it can’t be in the middle of a UTF-8 encoded character.

    method gtk_text_iter_set_line_index ( Int $byte_on_line )

  * Int $byte_on_line; a byte index relative to the start of *iter*’s current line

[[gtk_] text_iter_] forward_to_end
----------------------------------

Moves *iter* forward to the “end iterator,” which points one past the last valid character in the buffer. `gtk_text_iter_get_char()` called on the end iterator returns 0, which is convenient for writing loops.

    method gtk_text_iter_forward_to_end ( )

[[gtk_] text_iter_] forward_to_line_end
---------------------------------------

Moves the iterator to point to the paragraph delimiter characters, which will be either a newline, a carriage return, a carriage return/newline in sequence, or the Unicode paragraph separator character. If the iterator is already at the paragraph delimiter characters, moves to the paragraph delimiter characters for the next line. If *iter* is on the last line in the buffer, which does not end in paragraph delimiters, moves to the end iterator (end of the last line), and returns `0`.

Returns: `1` if we moved and the new location is not the end iterator

    method gtk_text_iter_forward_to_line_end ( --> Int  )

[[gtk_] text_iter_] set_visible_line_offset
-------------------------------------------

Like `gtk_text_iter_set_line_offset()`, but the offset is in visible characters, i.e. text with a tag making it invisible is not counted in the offset.

    method gtk_text_iter_set_visible_line_offset ( Int $char_on_line )

  * Int $char_on_line; a character offset

[[gtk_] text_iter_] set_visible_line_index
------------------------------------------

Like `gtk_text_iter_set_line_index()`, but the index is in visible bytes, i.e. text with a tag making it invisible is not counted in the index.

    method gtk_text_iter_set_visible_line_index ( Int $byte_on_line )

  * Int $byte_on_line; a byte index

[[gtk_] text_iter_] forward_to_tag_toggle
-----------------------------------------

Moves forward to the next toggle (on or off) of the **Gnome::Gtk3::TextTag** *tag*, or to the next toggle of any tag if *tag* is `Any`. If no matching tag toggles are found, returns `0`, otherwise `1`. Does not return toggles located at *iter*, only toggles after *iter*. Sets *iter* to the location of the toggle, or to the end of the buffer if no toggle is found.

Returns: whether we found a tag toggle after *iter*

    method gtk_text_iter_forward_to_tag_toggle ( N-GObject $tag --> Int  )

  * N-GObject $tag; (allow-none): a **Gnome::Gtk3::TextTag**, or `Any`

[[gtk_] text_iter_] backward_to_tag_toggle
------------------------------------------

Moves backward to the next toggle (on or off) of the **Gnome::Gtk3::TextTag** *tag*, or to the next toggle of any tag if *tag* is `Any`. If no matching tag toggles are found, returns `0`, otherwise `1`. Does not return toggles located at *iter*, only toggles before *iter*. Sets *iter* to the location of the toggle, or the start of the buffer if no toggle is found.

Returns: whether we found a tag toggle before *iter*

    method gtk_text_iter_backward_to_tag_toggle ( N-GObject $tag --> Int  )

  * N-GObject $tag; (allow-none): a **Gnome::Gtk3::TextTag**, or `Any`

[[gtk_] text_iter_] forward_search
----------------------------------

Searches forward for *str*. Any match is returned by setting *match_start* to the first character of the match and *match_end* to the first character after the match. The search will not continue past *limit*. Note that a search is a linear or O(n) operation, so you may wish to use *limit* to avoid locking up your UI on large buffers.

*match_start* will never be set to a **Gnome::Gtk3::TextIter** located before *iter*, even if there is a possible *match_end* after or at *iter*.

Returns: whether a match was found

    method gtk_text_iter_forward_search ( Str $str, GtkTextSearchFlags $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit --> Int  )

  * Str $str; a search string

  * GtkTextSearchFlags $flags; flags affecting how the search is done

  * N-GObject $match_start; (out caller-allocates) (allow-none): return location for start of match, or `Any`

  * N-GObject $match_end; (out caller-allocates) (allow-none): return location for end of match, or `Any`

  * N-GObject $limit; (allow-none): location of last possible *match_end*, or `Any` for the end of the buffer

[[gtk_] text_iter_] backward_search
-----------------------------------

Same as `gtk_text_iter_forward_search()`, but moves backward.

*match_end* will never be set to a **Gnome::Gtk3::TextIter** located after *iter*, even if there is a possible *match_start* before or at *iter*.

Returns: whether a match was found

    method gtk_text_iter_backward_search ( Str $str, GtkTextSearchFlags $flags, N-GObject $match_start, N-GObject $match_end, N-GObject $limit --> Int  )

  * Str $str; search string

  * GtkTextSearchFlags $flags; bitmask of flags affecting the search

  * N-GObject $match_start; (out caller-allocates) (allow-none): return location for start of match, or `Any`

  * N-GObject $match_end; (out caller-allocates) (allow-none): return location for end of match, or `Any`

  * N-GObject $limit; (allow-none): location of last possible *match_start*, or `Any` for start of buffer

[gtk_] text_iter_equal
----------------------

Tests whether two iterators are equal, using the fastest possible mechanism. This function is very fast; you can expect it to perform better than e.g. getting the character offset for each iterator and comparing the offsets yourself. Also, it’s a bit faster than `gtk_text_iter_compare()`.

Returns: `1` if the iterators point to the same place in the buffer

    method gtk_text_iter_equal ( N-GTextIter $rhs --> Int  )

  * N-GTextIter $rhs; another **Gnome::Gtk3::TextIter**

[gtk_] text_iter_compare
------------------------

A `qsort()`-style function that returns negative if *lhs* is less than *rhs*, positive if *lhs* is greater than *rhs*, and 0 if they’re equal. Ordering is in character offset order, i.e. the first character in the buffer is less than the second character in the buffer.

Returns: -1 if *lhs* is less than *rhs*, 1 if *lhs* is greater, 0 if they are equal

    method gtk_text_iter_compare ( N-GTextIter $rhs --> Int  )

  * N-GTextIter $rhs; another **Gnome::Gtk3::TextIter**

[[gtk_] text_iter_] in_range
----------------------------

Checks whether *iter* falls in the range [*start*, *end*). *start* and *end* must be in ascending order.

Returns: `1` if *iter* is in the range

    method gtk_text_iter_in_range ( N-GTextIter $start, N-GTextIter $end --> Int  )

  * N-GTextIter $start; start of range

  * N-GTextIter $end; end of range

[gtk_] text_iter_order
----------------------

Swaps the value of *first* and *second* if *second* comes before *first* in the buffer. That is, ensures that *first* and *second* are in sequence. Most text buffer functions that take a range call this automatically on your behalf, so there’s no real reason to call it yourself in those cases. There are some exceptions, such as `gtk_text_iter_in_range()`, that expect a pre-sorted range.

    method gtk_text_iter_order ( N-GTextIter $second )

  * N-GTextIter $second; another **Gnome::Gtk3::TextIter**

