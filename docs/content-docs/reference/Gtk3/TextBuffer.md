TITLE
=====

Gnome::Gtk3::TextBuffer

SUBTITLE
========

Stores attributed text for display in a `Gnome::Gtk3::TextView`

Description
===========

You may wish to begin by reading the [text widget conceptual overview][TextWidget] which gives an overview of all the objects and data types related to the text widget and how they work together.

See Also
--------

`Gnome::Gtk3::TextView`, `Gnome::Gtk3::TextIter`, `Gnome::Gtk3::TextMark`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextBuffer;

Example
-------

Types
=====

enum GtkTextBufferTargetInfo
----------------------------

These values are used as “info” for the targets contained in the lists returned by `gtk_text_buffer_get_copy_target_list()` and `gtk_text_buffer_get_paste_target_list()`.

The values counts down from `-1` to avoid clashes with application added drag destinations which usually start at 0.

  * GTK_TEXT_BUFFER_TARGET_INFO_BUFFER_CONTENTS: Buffer contents

  * GTK_TEXT_BUFFER_TARGET_INFO_RICH_TEXT: Rich text

  * GTK_TEXT_BUFFER_TARGET_INFO_TEXT: Text

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_text_buffer_new
-------------------

Creates a new text buffer.

Returns: a new text buffer

    method gtk_text_buffer_new ( N-GObject $table --> N-GObject  )

  * N-GObject $table; (allow-none): a tag table, or `Any` to create a new one

[gtk_text_buffer_] get_line_count
---------------------------------

Obtains the number of lines in the buffer. This value is cached, so the function is very fast.

Returns: number of lines in the buffer

    method gtk_text_buffer_get_line_count ( --> Int  )

[gtk_text_buffer_] get_char_count
---------------------------------

Gets the number of characters in the buffer; note that characters and bytes are not the same, you can’t e.g. expect the contents of the buffer in string form to be this many bytes long. The character count is cached, so this function is very fast.

Returns: number of characters in the buffer

    method gtk_text_buffer_get_char_count ( --> Int  )

[gtk_text_buffer_] get_tag_table
--------------------------------

Get the `Gnome::Gtk3::TextTagTable` associated with this buffer.

Returns: (transfer none): the buffer’s tag table

    method gtk_text_buffer_get_tag_table ( --> N-GObject  )

[gtk_text_buffer_] set_text
---------------------------

Deletes current contents of *buffer*, and inserts *text* instead. If *len* is -1, *text* must be nul-terminated. *text* must be valid UTF-8.

    method gtk_text_buffer_set_text ( Str $text, Int $len )

  * Str $text; UTF-8 text to insert

  * Int $len; length of *text* in bytes

gtk_text_buffer_insert
----------------------

Inserts *len* bytes of *text* at position *iter*. If *len* is -1, *text* must be nul-terminated and will be inserted in its entirety. Emits the “insert-text” signal; insertion actually occurs in the default handler for the signal. *iter* is invalidated when insertion occurs (because the buffer contents change), but the default signal handler revalidates it to point to the end of the inserted text.

    method gtk_text_buffer_insert ( N-GObject $iter, Str $text, Int $len )

  * N-GObject $iter; a position in the buffer

  * Str $text; text in UTF-8 format

  * Int $len; length of text in bytes, or -1

[gtk_text_buffer_] insert_at_cursor
-----------------------------------

Simply calls `gtk_text_buffer_insert()`, using the current cursor position as the insertion point.

    method gtk_text_buffer_insert_at_cursor ( Str $text, Int $len )

  * Str $text; text in UTF-8 format

  * Int $len; length of text, in bytes

[gtk_text_buffer_] insert_interactive
-------------------------------------

Like `gtk_text_buffer_insert()`, but the insertion will not occur if *iter* is at a non-editable location in the buffer. Usually you want to prevent insertions at ineditable locations if the insertion results from a user action (is interactive).

*default_editable* indicates the editability of text that doesn't have a tag affecting editability applied to it. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether text was actually inserted

    method gtk_text_buffer_insert_interactive ( N-GObject $iter, Str $text, Int $len, Int $default_editable --> Int  )

  * N-GObject $iter; a position in *buffer*

  * Str $text; some UTF-8 text

  * Int $len; length of text in bytes, or -1

  * Int $default_editable; default editability of buffer

[gtk_text_buffer_] insert_interactive_at_cursor
-----------------------------------------------

Calls `gtk_text_buffer_insert_interactive()` at the cursor position.

*default_editable* indicates the editability of text that doesn't have a tag affecting editability applied to it. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether text was actually inserted

    method gtk_text_buffer_insert_interactive_at_cursor ( Str $text, Int $len, Int $default_editable --> Int  )

  * Str $text; text in UTF-8 format

  * Int $len; length of text in bytes, or -1

  * Int $default_editable; default editability of buffer

[gtk_text_buffer_] insert_range
-------------------------------

Copies text, tags, and pixbufs between *start* and *end* (the order of *start* and *end* doesn’t matter) and inserts the copy at *iter*. Used instead of simply getting/inserting text because it preserves images and tags. If *start* and *end* are in a different buffer from *buffer*, the two buffers must share the same tag table.

Implemented via emissions of the insert_text and apply_tag signals, so expect those.

    method gtk_text_buffer_insert_range ( N-GObject $iter, N-GObject $start, N-GObject $end )

  * N-GObject $iter; a position in *buffer*

  * N-GObject $start; a position in a `Gnome::Gtk3::TextBuffer`

  * N-GObject $end; another position in the same buffer as *start*

[gtk_text_buffer_] insert_range_interactive
-------------------------------------------

Same as `gtk_text_buffer_insert_range()`, but does nothing if the insertion point isn’t editable. The *default_editable* parameter indicates whether the text is editable at *iter* if no tags enclosing *iter* affect editability. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether an insertion was possible at *iter*

    method gtk_text_buffer_insert_range_interactive ( N-GObject $iter, N-GObject $start, N-GObject $end, Int $default_editable --> Int  )

  * N-GObject $iter; a position in *buffer*

  * N-GObject $start; a position in a `Gnome::Gtk3::TextBuffer`

  * N-GObject $end; another position in the same buffer as *start*

  * Int $default_editable; default editability of the buffer

[gtk_text_buffer_] insert_markup
--------------------------------

Inserts the text in *markup* at position *iter*. *markup* will be inserted in its entirety and must be nul-terminated and valid UTF-8. Emits the sig `insert-text` signal, possibly multiple times; insertion actually occurs in the default handler for the signal. *iter* will point to the end of the inserted text on return.

Since: 3.16

    method gtk_text_buffer_insert_markup ( N-GObject $iter, Str $markup, Int $len )

  * N-GObject $iter; location to insert the markup

  * Str $markup; a nul-terminated UTF-8 string containing [Pango markup][PangoMarkupFormat]

  * Int $len; length of *markup* in bytes, or -1

gtk_text_buffer_delete
----------------------

Deletes text between *start* and *end*. The order of *start* and *end* is not actually relevant; `gtk_text_buffer_delete()` will reorder them. This function actually emits the “delete-range” signal, and the default handler of that signal deletes the text. Because the buffer is modified, all outstanding iterators become invalid after calling this function; however, the *start* and *end* will be re-initialized to point to the location where text was deleted.

    method gtk_text_buffer_delete ( N-GObject $start, N-GObject $end )

  * N-GObject $start; a position in *buffer*

  * N-GObject $end; another position in *buffer*

[gtk_text_buffer_] delete_interactive
-------------------------------------

Deletes all editable text in the given range. Calls `gtk_text_buffer_delete()` for each editable sub-range of [*start*,*end*). *start* and *end* are revalidated to point to the location of the last deleted range, or left untouched if no text was deleted.

Returns: whether some text was actually deleted

    method gtk_text_buffer_delete_interactive ( N-GObject $start_iter, N-GObject $end_iter, Int $default_editable --> Int  )

  * N-GObject $start_iter; start of range to delete

  * N-GObject $end_iter; end of range

  * Int $default_editable; whether the buffer is editable by default

gtk_text_buffer_backspace
-------------------------

Performs the appropriate action as if the user hit the delete key with the cursor at the position specified by *iter*. In the normal case a single character will be deleted, but when combining accents are involved, more than one character can be deleted, and when precomposed character and accent combinations are involved, less than one character will be deleted.

Because the buffer is modified, all outstanding iterators become invalid after calling this function; however, the *iter* will be re-initialized to point to the location where text was deleted.

Returns: `1` if the buffer was modified

Since: 2.6

    method gtk_text_buffer_backspace ( N-GObject $iter, Int $interactive, Int $default_editable --> Int  )

  * N-GObject $iter; a position in *buffer*

  * Int $interactive; whether the deletion is caused by user interaction

  * Int $default_editable; whether the buffer is editable by default

[gtk_text_buffer_] get_text
---------------------------

Returns the text in the range [*start*,*end*). Excludes undisplayed text (text marked with tags that set the invisibility attribute) if *include_hidden_chars* is `0`. Does not include characters representing embedded images, so byte and character indexes into the returned string do not correspond to byte and character indexes into the buffer. Contrast with `gtk_text_buffer_get_slice()`.

Returns: an allocated UTF-8 string

    method gtk_text_buffer_get_text ( N-GObject $start, N-GObject $end, Int $include_hidden_chars --> Str  )

  * N-GObject $start; start of a range

  * N-GObject $end; end of a range

  * Int $include_hidden_chars; whether to include invisible text

[gtk_text_buffer_] get_slice
----------------------------

Returns the text in the range [*start*,*end*). Excludes undisplayed text (text marked with tags that set the invisibility attribute) if *include_hidden_chars* is `0`. The returned string includes a 0xFFFC character whenever the buffer contains embedded images, so byte and character indexes into the returned string do correspond to byte and character indexes into the buffer. Contrast with `gtk_text_buffer_get_text()`. Note that 0xFFFC can occur in normal text as well, so it is not a reliable indicator that a pixbuf or widget is in the buffer.

Returns: an allocated UTF-8 string

    method gtk_text_buffer_get_slice ( N-GObject $start, N-GObject $end, Int $include_hidden_chars --> Str  )

  * N-GObject $start; start of a range

  * N-GObject $end; end of a range

  * Int $include_hidden_chars; whether to include invisible text

[gtk_text_buffer_] insert_pixbuf
--------------------------------

Inserts an image into the text buffer at *iter*. The image will be counted as one character in character counts, and when obtaining the buffer contents as a string, will be represented by the Unicode “object replacement character” 0xFFFC. Note that the “slice” variants for obtaining portions of the buffer as a string include this character for pixbufs, but the “text” variants do not. e.g. see `gtk_text_buffer_get_slice()` and `gtk_text_buffer_get_text()`.

    method gtk_text_buffer_insert_pixbuf ( N-GObject $iter, N-GObject $pixbuf )

  * N-GObject $iter; location to insert the pixbuf

  * N-GObject $pixbuf; a `Gnome::Gdk3::Pixbuf`

[gtk_text_buffer_] add_mark
---------------------------

Adds the mark at position *where*. The mark must not be added to another buffer, and if its name is not `Any` then there must not be another mark in the buffer with the same name.

Emits the sig `mark-set` signal as notification of the mark's initial placement.

Since: 2.12

    method gtk_text_buffer_add_mark ( N-GObject $mark, N-GObject $where )

  * N-GObject $mark; the mark to add

  * N-GObject $where; location to place mark

[gtk_text_buffer_] create_mark
------------------------------

Creates a mark at position *where*. If *mark_name* is `Any`, the mark is anonymous; otherwise, the mark can be retrieved by name using `gtk_text_buffer_get_mark()`. If a mark has left gravity, and text is inserted at the mark’s current location, the mark will be moved to the left of the newly-inserted text. If the mark has right gravity (*left_gravity* = `0`), the mark will end up on the right of newly-inserted text. The standard left-to-right cursor is a mark with right gravity (when you type, the cursor stays on the right side of the text you’re typing).

The caller of this function does not own a reference to the returned `Gnome::Gtk3::TextMark`, so you can ignore the return value if you like. Marks are owned by the buffer and go away when the buffer does.

Emits the sig `mark-set` signal as notification of the mark's initial placement.

Returns: (transfer none): the new `Gnome::Gtk3::TextMark` object

    method gtk_text_buffer_create_mark ( Str $mark_name, N-GObject $where, Int $left_gravity --> N-GObject  )

  * Str $mark_name; (allow-none): name for mark, or `Any`

  * N-GObject $where; location to place mark

  * Int $left_gravity; whether the mark has left gravity

[gtk_text_buffer_] move_mark
----------------------------

Moves *mark* to the new location *where*. Emits the sig `mark-set` signal as notification of the move.

    method gtk_text_buffer_move_mark ( N-GObject $mark, N-GObject $where )

  * N-GObject $mark; a `Gnome::Gtk3::TextMark`

  * N-GObject $where; new location for *mark* in *buffer*

[gtk_text_buffer_] delete_mark
------------------------------

Deletes *mark*, so that it’s no longer located anywhere in the buffer. Removes the reference the buffer holds to the mark, so if you haven’t called `g_object_ref()` on the mark, it will be freed. Even if the mark isn’t freed, most operations on *mark* become invalid, until it gets added to a buffer again with `gtk_text_buffer_add_mark()`. Use `gtk_text_mark_get_deleted()` to find out if a mark has been removed from its buffer. The sig `mark-deleted` signal will be emitted as notification after the mark is deleted.

    method gtk_text_buffer_delete_mark ( N-GObject $mark )

  * N-GObject $mark; a `Gnome::Gtk3::TextMark` in *buffer*

[gtk_text_buffer_] get_mark
---------------------------

Returns the mark named *name* in buffer *buffer*, or `Any` if no such mark exists in the buffer.

Returns: (nullable) (transfer none): a `Gnome::Gtk3::TextMark`, or `Any`

    method gtk_text_buffer_get_mark ( Str $name --> N-GObject  )

  * Str $name; a mark name

[gtk_text_buffer_] move_mark_by_name
------------------------------------

Moves the mark named *name* (which must exist) to location *where*. See `gtk_text_buffer_move_mark()` for details.

    method gtk_text_buffer_move_mark_by_name ( Str $name, N-GObject $where )

  * Str $name; name of a mark

  * N-GObject $where; new location for mark

[gtk_text_buffer_] delete_mark_by_name
--------------------------------------

Deletes the mark named *name*; the mark must exist. See `gtk_text_buffer_delete_mark()` for details.

    method gtk_text_buffer_delete_mark_by_name ( Str $name )

  * Str $name; name of a mark in *buffer*

[gtk_text_buffer_] get_insert
-----------------------------

Returns the mark that represents the cursor (insertion point). Equivalent to calling `gtk_text_buffer_get_mark()` to get the mark named “insert”, but very slightly more efficient, and involves less typing.

Returns: (transfer none): insertion point mark

    method gtk_text_buffer_get_insert ( --> N-GObject  )

[gtk_text_buffer_] get_selection_bound
--------------------------------------

Returns the mark that represents the selection bound. Equivalent to calling `gtk_text_buffer_get_mark()` to get the mark named “selection_bound”, but very slightly more efficient, and involves less typing.

The currently-selected text in *buffer* is the region between the “selection_bound” and “insert” marks. If “selection_bound” and “insert” are in the same place, then there is no current selection. `gtk_text_buffer_get_selection_bounds()` is another convenient function for handling the selection, if you just want to know whether there’s a selection and what its bounds are.

Returns: (transfer none): selection bound mark

    method gtk_text_buffer_get_selection_bound ( --> N-GObject  )

[gtk_text_buffer_] place_cursor
-------------------------------

This function moves the “insert” and “selection_bound” marks simultaneously. If you move them to the same place in two steps with `gtk_text_buffer_move_mark()`, you will temporarily select a region in between their old and new locations, which can be pretty inefficient since the temporarily-selected region will force stuff to be recalculated. This function moves them as a unit, which can be optimized.

    method gtk_text_buffer_place_cursor ( N-GObject $where )

  * N-GObject $where; where to put the cursor

[gtk_text_buffer_] select_range
-------------------------------

This function moves the “insert” and “selection_bound” marks simultaneously. If you move them in two steps with `gtk_text_buffer_move_mark()`, you will temporarily select a region in between their old and new locations, which can be pretty inefficient since the temporarily-selected region will force stuff to be recalculated. This function moves them as a unit, which can be optimized.

Since: 2.4

    method gtk_text_buffer_select_range ( N-GObject $ins, N-GObject $bound )

  * N-GObject $ins; where to put the “insert” mark

  * N-GObject $bound; where to put the “selection_bound” mark

[gtk_text_buffer_] apply_tag
----------------------------

Emits the “apply-tag” signal on *buffer*. The default handler for the signal applies *tag* to the given range. *start* and *end* do not have to be in order.

    method gtk_text_buffer_apply_tag ( N-GObject $tag, N-GObject $start, N-GObject $end )

  * N-GObject $tag; a `Gnome::Gtk3::TextTag`

  * N-GObject $start; one bound of range to be tagged

  * N-GObject $end; other bound of range to be tagged

[gtk_text_buffer_] remove_tag
-----------------------------

Emits the “remove-tag” signal. The default handler for the signal removes all occurrences of *tag* from the given range. *start* and *end* don’t have to be in order.

    method gtk_text_buffer_remove_tag ( N-GObject $tag, N-GObject $start, N-GObject $end )

  * N-GObject $tag; a `Gnome::Gtk3::TextTag`

  * N-GObject $start; one bound of range to be untagged

  * N-GObject $end; other bound of range to be untagged

[gtk_text_buffer_] apply_tag_by_name
------------------------------------

Calls `gtk_text_tag_table_lookup()` on the buffer’s tag table to get a `Gnome::Gtk3::TextTag`, then calls `gtk_text_buffer_apply_tag()`.

    method gtk_text_buffer_apply_tag_by_name ( Str $name, N-GObject $start, N-GObject $end )

  * Str $name; name of a named `Gnome::Gtk3::TextTag`

  * N-GObject $start; one bound of range to be tagged

  * N-GObject $end; other bound of range to be tagged

[gtk_text_buffer_] remove_tag_by_name
-------------------------------------

Calls `gtk_text_tag_table_lookup()` on the buffer’s tag table to get a `Gnome::Gtk3::TextTag`, then calls `gtk_text_buffer_remove_tag()`.

    method gtk_text_buffer_remove_tag_by_name ( Str $name, N-GObject $start, N-GObject $end )

  * Str $name; name of a `Gnome::Gtk3::TextTag`

  * N-GObject $start; one bound of range to be untagged

  * N-GObject $end; other bound of range to be untagged

[gtk_text_buffer_] remove_all_tags
----------------------------------

Removes all tags in the range between *start* and *end*. Be careful with this function; it could remove tags added in code unrelated to the code you’re currently writing. That is, using this function is probably a bad idea if you have two or more unrelated code sections that add tags.

    method gtk_text_buffer_remove_all_tags ( N-GObject $start, N-GObject $end )

  * N-GObject $start; one bound of range to be untagged

  * N-GObject $end; other bound of range to be untagged

[gtk_text_buffer_] get_iter_at_line_offset
------------------------------------------

Obtains an iterator pointing to *char_offset* within the given line. Note characters, not bytes; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if *line_number* is greater than the number of lines in the *buffer*, the end iterator is returned. And if *char_offset* is off the end of the line, the iterator at the end of the line is returned.

    method gtk_text_buffer_get_iter_at_line_offset ( N-GObject $iter, Int $line_number, Int $char_offset )

  * N-GObject $iter; (out): iterator to initialize

  * Int $line_number; line number counting from 0

  * Int $char_offset; char offset from start of line

[gtk_text_buffer_] get_iter_at_line_index
-----------------------------------------

Obtains an iterator pointing to *byte_index* within the given line. *byte_index* must be the start of a UTF-8 character. Note bytes, not characters; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if *line_number* is greater than the number of lines in the *buffer*, the end iterator is returned. And if *byte_index* is off the end of the line, the iterator at the end of the line is returned.

    method gtk_text_buffer_get_iter_at_line_index ( N-GObject $iter, Int $line_number, Int $byte_index )

  * N-GObject $iter; (out): iterator to initialize

  * Int $line_number; line number counting from 0

  * Int $byte_index; byte index from start of line

[gtk_text_buffer_] get_iter_at_offset
-------------------------------------

Initializes *iter* to a position *char_offset* chars from the start of the entire buffer. If *char_offset* is -1 or greater than the number of characters in the buffer, *iter* is initialized to the end iterator, the iterator one past the last valid character in the buffer.

    method gtk_text_buffer_get_iter_at_offset ( N-GObject $iter, Int $char_offset )

  * N-GObject $iter; (out): iterator to initialize

  * Int $char_offset; char offset from start of buffer, counting from 0, or -1

[gtk_text_buffer_] get_iter_at_line
-----------------------------------

Initializes *iter* to the start of the given line. If *line_number* is greater than the number of lines in the *buffer*, the end iterator is returned.

    method gtk_text_buffer_get_iter_at_line ( N-GObject $iter, Int $line_number )

  * N-GObject $iter; (out): iterator to initialize

  * Int $line_number; line number counting from 0

[gtk_text_buffer_] get_start_iter
---------------------------------

Initialized *iter* with the first position in the text buffer. This is the same as using `gtk_text_buffer_get_iter_at_offset()` to get the iter at character offset 0.

    method gtk_text_buffer_get_start_iter ( N-GObject $iter )

  * N-GObject $iter; (out): iterator to initialize

[gtk_text_buffer_] get_end_iter
-------------------------------

Initializes *iter* with the “end iterator,” one past the last valid character in the text buffer. If dereferenced with `gtk_text_iter_get_char()`, the end iterator has a character value of 0. The entire buffer lies in the range from the first position in the buffer (call `gtk_text_buffer_get_start_iter()` to get character position 0) to the end iterator.

    method gtk_text_buffer_get_end_iter ( N-GObject $iter )

  * N-GObject $iter; (out): iterator to initialize

[gtk_text_buffer_] get_bounds
-----------------------------

Retrieves the first and last iterators in the buffer, i.e. the entire buffer lies within the range [*start*,*end*).

    method gtk_text_buffer_get_bounds ( N-GObject $start, N-GObject $end )

  * N-GObject $start; (out): iterator to initialize with first position in the buffer

  * N-GObject $end; (out): iterator to initialize with the end iterator

[gtk_text_buffer_] get_iter_at_mark
-----------------------------------

Initializes *iter* with the current position of *mark*.

    method gtk_text_buffer_get_iter_at_mark ( N-GObject $iter, N-GObject $mark )

  * N-GObject $iter; (out): iterator to initialize

  * N-GObject $mark; a `Gnome::Gtk3::TextMark` in *buffer*

[gtk_text_buffer_] get_modified
-------------------------------

Indicates whether the buffer has been modified since the last call to `gtk_text_buffer_set_modified()` set the modification flag to `0`. Used for example to enable a “save” function in a text editor.

Returns: `1` if the buffer has been modified

    method gtk_text_buffer_get_modified ( --> Int  )

[gtk_text_buffer_] set_modified
-------------------------------

Used to keep track of whether the buffer has been modified since the last time it was saved. Whenever the buffer is saved to disk, call gtk_text_buffer_set_modified (*buffer*, FALSE). When the buffer is modified, it will automatically toggled on the modified bit again. When the modified bit flips, the buffer emits the sig `modified-changed` signal.

    method gtk_text_buffer_set_modified ( Int $setting )

  * Int $setting; modification flag setting

[gtk_text_buffer_] get_has_selection
------------------------------------

Indicates whether the buffer has some text currently selected.

Returns: `1` if the there is text selected

Since: 2.10

    method gtk_text_buffer_get_has_selection ( --> Int  )

[gtk_text_buffer_] add_selection_clipboard
------------------------------------------

Adds *clipboard* to the list of clipboards in which the selection contents of *buffer* are available. In most cases, *clipboard* will be the `Gnome::Gtk3::Clipboard` of type `GDK_SELECTION_PRIMARY` for a view of *buffer*.

    method gtk_text_buffer_add_selection_clipboard ( N-GObject $clipboard )

  * N-GObject $clipboard; a `Gnome::Gtk3::Clipboard`

[gtk_text_buffer_] remove_selection_clipboard
---------------------------------------------

Removes a `Gnome::Gtk3::Clipboard` added with `gtk_text_buffer_add_selection_clipboard()`.

    method gtk_text_buffer_remove_selection_clipboard ( N-GObject $clipboard )

  * N-GObject $clipboard; a `Gnome::Gtk3::Clipboard` added to *buffer* by `gtk_text_buffer_add_selection_clipboard()`

[gtk_text_buffer_] cut_clipboard
--------------------------------

Copies the currently-selected text to a clipboard, then deletes said text if it’s editable.

    method gtk_text_buffer_cut_clipboard ( N-GObject $clipboard, Int $default_editable )

  * N-GObject $clipboard; the `Gnome::Gtk3::Clipboard` object to cut to

  * Int $default_editable; default editability of the buffer

[gtk_text_buffer_] copy_clipboard
---------------------------------

Copies the currently-selected text to a clipboard.

    method gtk_text_buffer_copy_clipboard ( N-GObject $clipboard )

  * N-GObject $clipboard; the `Gnome::Gtk3::Clipboard` object to copy to

[gtk_text_buffer_] paste_clipboard
----------------------------------

Pastes the contents of a clipboard. If *override_location* is `Any`, the pasted text will be inserted at the cursor position, or the buffer selection will be replaced if the selection is non-empty.

Note: pasting is asynchronous, that is, we’ll ask for the paste data and return, and at some point later after the main loop runs, the paste data will be inserted.

    method gtk_text_buffer_paste_clipboard ( N-GObject $clipboard, N-GObject $override_location, Int $default_editable )

  * N-GObject $clipboard; the `Gnome::Gtk3::Clipboard` to paste from

  * N-GObject $override_location; (allow-none): location to insert pasted text, or `Any`

  * Int $default_editable; whether the buffer is editable by default

[gtk_text_buffer_] get_selection_bounds
---------------------------------------

Returns `1` if some text is selected; places the bounds of the selection in *start* and *end* (if the selection has length 0, then *start* and *end* are filled in with the same value). *start* and *end* will be in ascending order. If *start* and *end* are NULL, then they are not filled in, but the return value still indicates whether text is selected.

Returns: whether the selection has nonzero length

    method gtk_text_buffer_get_selection_bounds ( N-GObject $start, N-GObject $end --> Int  )

  * N-GObject $start; (out): iterator to initialize with selection start

  * N-GObject $end; (out): iterator to initialize with selection end

[gtk_text_buffer_] delete_selection
-----------------------------------

Deletes the range between the “insert” and “selection_bound” marks, that is, the currently-selected text. If *interactive* is `1`, the editability of the selection will be considered (users can’t delete uneditable text).

Returns: whether there was a non-empty selection to delete

    method gtk_text_buffer_delete_selection ( Int $interactive, Int $default_editable --> Int  )

  * Int $interactive; whether the deletion is caused by user interaction

  * Int $default_editable; whether the buffer is editable by default

[gtk_text_buffer_] begin_user_action
------------------------------------

Called to indicate that the buffer operations between here and a call to `gtk_text_buffer_end_user_action()` are part of a single user-visible operation. The operations between `gtk_text_buffer_begin_user_action()` and `gtk_text_buffer_end_user_action()` can then be grouped when creating an undo stack. `Gnome::Gtk3::TextBuffer` maintains a count of calls to `gtk_text_buffer_begin_user_action()` that have not been closed with a call to `gtk_text_buffer_end_user_action()`, and emits the “begin-user-action” and “end-user-action” signals only for the outermost pair of calls. This allows you to build user actions from other user actions.

The “interactive” buffer mutation functions, such as `gtk_text_buffer_insert_interactive()`, automatically call begin/end user action around the buffer operations they perform, so there's no need to add extra calls if you user action consists solely of a single call to one of those functions.

    method gtk_text_buffer_begin_user_action ( )

[gtk_text_buffer_] end_user_action
----------------------------------

Should be paired with a call to `gtk_text_buffer_begin_user_action()`. See that function for a full explanation.

    method gtk_text_buffer_end_user_action ( )

Not yet supported methods
=========================

method gtk_text_buffer_insert_child_anchor ( ... )
--------------------------------------------------

method gtk_text_buffer_create_child_anchor ( ... )
--------------------------------------------------

method gtk_text_buffer_get_iter_at_child_anchor ( ... )
-------------------------------------------------------

method gtk_text_buffer_get_copy_target_list ( ... )
---------------------------------------------------

method gtk_text_buffer_get_paste_target_list ( ... )
----------------------------------------------------

Methods which will not be implemented
=====================================

method gtk_text_buffer_create_tag ( ... )
-----------------------------------------

This method is not implemented because it can be accomplished using other methods. It is equivalent to calling `gtk_text_tag_new()` from `Gnome::Gtk3::TextTag` and then adding the tag to the buffer’s tag table. The returned tag is owned by the buffer’s tag table, so the ref count will be equal to one.

Signals
=======

Register any signal as follows. See also `Gnome::GObject::Object`.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Supported signals
-----------------

### begin-user-action

The *begin-user-action* signal is emitted at the beginning of a single user-visible operation on a `Gnome::Gtk3::TextBuffer`.

See also: `gtk_text_buffer_begin_user_action()`, `gtk_text_buffer_insert_interactive()`, `gtk_text_buffer_insert_range_interactive()`, `gtk_text_buffer_delete_interactive()`, `gtk_text_buffer_backspace()`, `gtk_text_buffer_delete_selection()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

Nil

### end-user-action

The *end-user-action* signal is emitted at the end of a single user-visible operation on the `Gnome::Gtk3::TextBuffer`.

See also: `gtk_text_buffer_end_user_action()`, `gtk_text_buffer_insert_interactive()`, `gtk_text_buffer_insert_range_interactive()`, `gtk_text_buffer_delete_interactive()`, `gtk_text_buffer_backspace()`, `gtk_text_buffer_delete_selection()`, `gtk_text_buffer_backspace()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

### changed

The *changed* signal is emitted when the content of a `Gnome::Gtk3::TextBuffer` has changed.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

### modified-changed

The *modified-changed* signal is emitted when the modified bit of a `Gnome::Gtk3::TextBuffer` flips.

See also: `gtk_text_buffer_set_modified()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

### mark-deleted

The *mark-deleted* signal is emitted as notification after a `Gnome::Gtk3::TextMark` is deleted.

See also: `gtk_text_buffer_delete_mark()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($mark),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $mark; The mark that was deleted

### paste-done

The *paste-done* signal is emitted after paste operation has been completed. This is useful to properly scroll the view to the end of the pasted text. See `gtk_text_buffer_paste_clipboard()` for more details.

Since: 2.16

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($clipboard),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $clipboard; the `Gnome::Gtk3::Clipboard` pasted from

Not yet supported signals
-------------------------

### insert-text

The *insert-text* signal is emitted to insert text in a `Gnome::Gtk3::TextBuffer`. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to point to the end of the inserted text.

See also: `gtk_text_buffer_insert()`, `gtk_text_buffer_insert_range()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($location),
      :handler-arg1($text),
      :handler-arg2($len),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *text* in *textbuffer*

  * $text; the UTF-8 text to be inserted

  * $len; length of the inserted text in bytes

### insert-pixbuf

The *insert-pixbuf* signal is emitted to insert a `Gnome::Gdk3::Pixbuf` in a `Gnome::Gtk3::TextBuffer`. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to be placed after the inserted *pixbuf*.

See also: `gtk_text_buffer_insert_pixbuf()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($location),
      :handler-arg1($pixbuf),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *pixbuf* in *textbuffer*

  * $pixbuf; the `Gnome::Gdk3::Pixbuf` to be inserted

### insert-child-anchor

The *insert-child-anchor* signal is emitted to insert a `Gnome::Gtk3::TextChildAnchor` in a `Gnome::Gtk3::TextBuffer`. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to be placed after the inserted *anchor*.

See also: `gtk_text_buffer_insert_child_anchor()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($location),
      :handler-arg1($anchor),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *anchor* in *textbuffer*

  * $anchor; the `Gnome::Gtk3::TextChildAnchor` to be inserted

### delete-range

The *delete-range* signal is emitted to delete a range from a `Gnome::Gtk3::TextBuffer`.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them). The default signal handler revalidates the *start* and *end* iters to both point to the location where text was deleted. Handlers which run after the default handler (see `g_signal_connect_after()`) do not have access to the deleted text.

See also: `gtk_text_buffer_delete()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($start),
      :handler-arg1($end),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $start; the start of the range to be deleted

  * $end; the end of the range to be deleted

### mark-set

The *mark-set* signal is emitted as notification after a `Gnome::Gtk3::TextMark` is set.

See also: `gtk_text_buffer_create_mark()`, `gtk_text_buffer_move_mark()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($location),
      :handler-arg1($mark),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $location; The location of *mark* in *textbuffer*

  * $mark; The mark that is set

### apply-tag

The *apply-tag* signal is emitted to apply a tag to a range of text in a `Gnome::Gtk3::TextBuffer`. Applying actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them).

See also: `gtk_text_buffer_apply_tag()`, `gtk_text_buffer_insert_with_tags()`, `gtk_text_buffer_insert_range()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($tag),
      :handler-arg1($start),
      :handler-arg2($end),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $tag; the applied tag

  * $start; the start of the range the tag is applied to

  * $end; the end of the range the tag is applied to

### remove-tag

The *remove-tag* signal is emitted to remove all occurrences of *tag* from a range of text in a `Gnome::Gtk3::TextBuffer`. Removal actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them).

See also: `gtk_text_buffer_remove_tag()`.

    method handler (
      Gnome::GObject::Object :widget($textbuffer),
      :handler-arg0($tag),
      :handler-arg1($start),
      :handler-arg2($end),
      :$user-option1, ..., :$user-optionN
    );

  * $textbuffer; the object which received the signal

  * $tag; the tag to be removed

  * $start; the start of the range the tag is removed from

  * $end; the end of the range the tag is removed from

Properties
==========

An example of using a string type property of a `Gnome::Gtk3::Label` object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Not yet supported properties
----------------------------

### text

The `Gnome::GObject::Value` type of property *text* is `G_TYPE_STRING`.

The text content of the buffer. Without child widgets and images, see `gtk_text_buffer_get_text()` for more information.

Since: 2.8

### has-selection

The `Gnome::GObject::Value` type of property *has-selection* is `G_TYPE_BOOLEAN`.

Whether the buffer has some text currently selected.

Since: 2.10

### cursor-position

The `Gnome::GObject::Value` type of property *cursor-position* is `G_TYPE_INT`.

The position of the insert mark (as offset from the beginning of the buffer). It is useful for getting notified when the cursor moves.

Since: 2.10

### copy-target-list

The `Gnome::GObject::Value` type of property *copy-target-list* is `G_TYPE_BOXED`.

The list of targets this buffer supports for clipboard copying and as DND source.

Since: 2.10

### paste-target-list

The `Gnome::GObject::Value` type of property *paste-target-list* is `G_TYPE_BOXED`.

The list of targets this buffer supports for clipboard pasting and as DND destination.

Since: 2.10

