Gnome::Gtk3::TextBuffer
=======================

Stores attributed text for display in a **Gnome::Gtk3::TextView**

Description
===========

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

See Also
--------

**Gnome::Gtk3::TextView**, **Gnome::Gtk3::TextIter**, **Gnome::Gtk3::TextMark**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextBuffer;
    also is Gnome::GObject::Object;

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

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] text_buffer_new
----------------------

Creates a new text buffer.

Returns: a new text buffer

    method gtk_text_buffer_new ( N-GObject $table --> N-GObject  )

  * N-GObject $table; (allow-none): a tag table, or `Any` to create a new one

[[gtk_] text_buffer_] get_line_count
------------------------------------

Obtains the number of lines in the buffer. This value is cached, so the function is very fast.

Returns: number of lines in the buffer

    method gtk_text_buffer_get_line_count ( --> Int  )

[[gtk_] text_buffer_] get_char_count
------------------------------------

Gets the number of characters in the buffer; note that characters and bytes are not the same, you can’t e.g. expect the contents of the buffer in string form to be this many bytes long. The character count is cached, so this function is very fast.

Returns: number of characters in the buffer

    method gtk_text_buffer_get_char_count ( --> Int  )

[[gtk_] text_buffer_] get_tag_table
-----------------------------------

Get the **Gnome::Gtk3::TextTagTable** associated with this buffer.

Returns: (transfer none): the buffer’s tag table

    method gtk_text_buffer_get_tag_table ( --> N-GObject  )

[[gtk_] text_buffer_] set_text
------------------------------

Deletes current contents of *buffer*, and inserts *text* instead. If *len* is -1, *text* must be nul-terminated. *text* must be valid UTF-8.

    method gtk_text_buffer_set_text ( Str $text, Int $len )

  * Str $text; UTF-8 text to insert

  * Int $len; length of *text* in bytes

[gtk_] text_buffer_insert
-------------------------

Inserts *$len* bytes of *$text* at position *$iter*. If *$len* is -1, *text* must be nul-terminated and will be inserted in its entirety. Emits the “insert-text” signal; insertion actually occurs in the default handler for the signal. *iter* is invalidated when insertion occurs (because the buffer contents change), but the default signal handler revalidates it to point to the end of the inserted text.

    method gtk_text_buffer_insert (
      Gnome::Gtk3::TextIter $iter, Str $text, Int $len
    )

  * Gnome::Gtk3::TextIter $iter; a position in the buffer

  * Str $text; text in UTF-8 format

  * Int $len; length of text in bytes, or -1

[[gtk_] text_buffer_] insert_at_cursor
--------------------------------------

Simply calls `gtk_text_buffer_insert()`, using the current cursor position as the insertion point.

    method gtk_text_buffer_insert_at_cursor ( Str $text, Int $len )

  * Str $text; text in UTF-8 format

  * Int $len; length of text, in bytes

[[gtk_] text_buffer_] insert_interactive
----------------------------------------

Like `gtk_text_buffer_insert()`, but the insertion will not occur if *iter* is at a non-editable location in the buffer. Usually you want to prevent insertions at ineditable locations if the insertion results from a user action (is interactive).

*default_editable* indicates the editability of text that doesn't have a tag affecting editability applied to it. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether text was actually inserted

    method gtk_text_buffer_insert_interactive (
      Gnome::Gtk3::TextIter $iter, Str $text, Int $len,
      Int $default_editable
      --> Int
    )

  * Gnome::Gtk3::TextIter $iter; a position in *buffer*

  * Str $text; some UTF-8 text

  * Int $len; length of text in bytes, or -1

  * Int $default_editable; default editability of buffer

[[gtk_] text_buffer_] insert_interactive_at_cursor
--------------------------------------------------

Calls `gtk_text_buffer_insert_interactive()` at the cursor position.

*default_editable* indicates the editability of text that doesn't have a tag affecting editability applied to it. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether text was actually inserted

    method gtk_text_buffer_insert_interactive_at_cursor ( Str $text, Int $len, Int $default_editable --> Int  )

  * Str $text; text in UTF-8 format

  * Int $len; length of text in bytes, or -1

  * Int $default_editable; default editability of buffer

[[gtk_] text_buffer_] insert_range
----------------------------------

Copies text, tags, and pixbufs between *start* and *end* (the order of *start* and *end* doesn’t matter) and inserts the copy at *iter*. Used instead of simply getting/inserting text because it preserves images and tags. If *start* and *end* are in a different buffer from *buffer*, the two buffers must share the same tag table.

Implemented via emissions of the insert_text and apply_tag signals, so expect those.

    method gtk_text_buffer_insert_range (
      Gnome::Gtk3::TextIter $iter,
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Gnome::Gtk3::TextIter $iter; a position in *buffer*

  * Gnome::Gtk3::TextIter $start; a position in a **Gnome::Gtk3::TextBuffer**

  * Gnome::Gtk3::TextIter $end; another position in the same buffer as *start*

[[gtk_] text_buffer_] insert_range_interactive
----------------------------------------------

Same as `gtk_text_buffer_insert_range()`, but does nothing if the insertion point isn’t editable. The *default_editable* parameter indicates whether the text is editable at *iter* if no tags enclosing *iter* affect editability. Typically the result of `gtk_text_view_get_editable()` is appropriate here.

Returns: whether an insertion was possible at *iter*

    method gtk_text_buffer_insert_range_interactive (
      Gnome::Gtk3::TextIter $iter,
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
      Int $default_editable
      --> Int
    )

  * Gnome::Gtk3::TextIter $iter; a position in *buffer*

  * Gnome::Gtk3::TextIter $start; a position in a **Gnome::Gtk3::TextBuffer**

  * Gnome::Gtk3::TextIter $end; another position in the same buffer as *start*

  * Int $default_editable; default editability of the buffer

[[gtk_] text_buffer_] insert_markup
-----------------------------------

Inserts the text in *markup* at position *iter*. *markup* will be inserted in its entirety and must be nul-terminated and valid UTF-8. Emits the *insert-text* signal, possibly multiple times; insertion actually occurs in the default handler for the signal. *iter* will point to the end of the inserted text on return.

    method gtk_text_buffer_insert_markup (
      Gnome::Gtk3::TextIter $iter, Str $markup, Int $len
    )

  * Gnome::Gtk3::TextIter $iter; location to insert the markup

  * Str $markup; a nul-terminated UTF-8 string containing Pango markup

  * Int $len; length of *markup* in bytes, or -1

[gtk_] text_buffer_delete
-------------------------

Deletes text between *start* and *end*. The order of *start* and *end* is not actually relevant; `gtk_text_buffer_delete()` will reorder them. This function actually emits the “delete-range” signal, and the default handler of that signal deletes the text. Because the buffer is modified, all outstanding iterators become invalid after calling this function; however, the *start* and *end* will be re-initialized to point to the location where text was deleted.

    method gtk_text_buffer_delete (
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Gnome::Gtk3::TextIter $start; a position in *buffer*

  * Gnome::Gtk3::TextIter $end; another position in *buffer*

[[gtk_] text_buffer_] delete_interactive
----------------------------------------

Deletes all editable text in the given range. Calls `gtk_text_buffer_delete()` for each editable sub-range of [*start*,*end*). *start* and *end* are revalidated to point to the location of the last deleted range, or left untouched if no text was deleted.

Returns: whether some text was actually deleted

    method gtk_text_buffer_delete_interactive (
      Gnome::Gtk3::TextIter $start_iter, Gnome::Gtk3::TextIter $end_iter,
      Int $default_editable
      --> Int
    )

  * Gnome::Gtk3::TextIter $start_iter; start of range to delete

  * Gnome::Gtk3::TextIter $end_iter; end of range

  * Int $default_editable; whether the buffer is editable by default

[gtk_] text_buffer_backspace
----------------------------

Performs the appropriate action as if the user hit the delete key with the cursor at the position specified by *iter*. In the normal case a single character will be deleted, but when combining accents are involved, more than one character can be deleted, and when precomposed character and accent combinations are involved, less than one character will be deleted.

Because the buffer is modified, all outstanding iterators become invalid after calling this function; however, the *iter* will be re-initialized to point to the location where text was deleted.

Returns: `1` if the buffer was modified

    method gtk_text_buffer_backspace (
      Gnome::Gtk3::TextIter $iter, Int $interactive, Int $default_editable
      --> Int
    )

  * N-GObject $iter; a position in *buffer*

  * Int $interactive; whether the deletion is caused by user interaction

  * Int $default_editable; whether the buffer is editable by default

[[gtk_] text_buffer_] get_text
------------------------------

Returns the text in the range [*start*,*end*). Excludes undisplayed text (text marked with tags that set the invisibility attribute) if *include_hidden_chars* is `0`. Does not include characters representing embedded images, so byte and character indexes into the returned string do not correspond to byte and character indexes into the buffer. Contrast with `gtk_text_buffer_get_slice()`.

Returns: an allocated UTF-8 string

    method gtk_text_buffer_get_text (
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
      Int $include_hidden_chars --> Str
    )

  * Gnome::Gtk3::TextIter $start; start of a range

  * Gnome::Gtk3::TextIter $end; end of a range

  * Int $include_hidden_chars; whether to include invisible text

[[gtk_] text_buffer_] get_slice
-------------------------------

Returns the text in the range [*start*,*end*). Excludes undisplayed text (text marked with tags that set the invisibility attribute) if *include_hidden_chars* is `0`. The returned string includes a 0xFFFC character whenever the buffer contains embedded images, so byte and character indexes into the returned string do correspond to byte and character indexes into the buffer. Contrast with `gtk_text_buffer_get_text()`. Note that 0xFFFC can occur in normal text as well, so it is not a reliable indicator that a pixbuf or widget is in the buffer.

Returns: an allocated UTF-8 string

    method gtk_text_buffer_get_slice (
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end,
      Int $include_hidden_chars
      --> Str
    )

  * Gnome::Gtk3::TextIter $start; start of a range

  * Gnome::Gtk3::TextIter $end; end of a range

  * Int $include_hidden_chars; whether to include invisible text

[[gtk_] text_buffer_] apply_tag
-------------------------------

Emits the “apply-tag” signal on *buffer*. The default handler for the signal applies *tag* to the given range. *start* and *end* do not have to be in order.

    method gtk_text_buffer_apply_tag (
      Gnome::Gtk3::TextTag $tag,
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Gnome::Gtk3::TextTag $tag

  * Gnome::Gtk3::TextIter $start; one bound of range to be tagged

  * Gnome::Gtk3::TextIter $end; other bound of range to be tagged

[[gtk_] text_buffer_] remove_tag
--------------------------------

Emits the “remove-tag” signal. The default handler for the signal removes all occurrences of *tag* from the given range. *start* and *end* don’t have to be in order.

    method gtk_text_buffer_remove_tag ( N-GObject $tag, N-GObject $start, N-GObject $end )

  * Gnome::Gtk3::TextTag $tag

  * Gnome::Gtk3::TextIter $start; one bound of range to be untagged

  * Gnome::Gtk3::TextIter $end; other bound of range to be untagged

[[gtk_] text_buffer_] apply_tag_by_name
---------------------------------------

Calls `gtk_text_tag_table_lookup()` on the buffer’s tag table to get a **Gnome::Gtk3::TextTag**, then calls `gtk_text_buffer_apply_tag()`.

    method gtk_text_buffer_apply_tag_by_name (
      Str $name, Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Str $name; name of a named **Gnome::Gtk3::TextTag**

  * Gnome::Gtk3::TextIter $start; one bound of range to be tagged

  * Gnome::Gtk3::TextIter $end; other bound of range to be tagged

[[gtk_] text_buffer_] remove_tag_by_name
----------------------------------------

Calls `gtk_text_tag_table_lookup()` on the buffer’s tag table to get a **Gnome::Gtk3::TextTag**, then calls `gtk_text_buffer_remove_tag()`.

    method gtk_text_buffer_remove_tag_by_name (
      Str $name, Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Str $name; name of a **Gnome::Gtk3::TextTag**

  * Gnome::Gtk3::TextIter $start; one bound of range to be untagged

  * Gnome::Gtk3::TextIter $end; other bound of range to be untagged

[[gtk_] text_buffer_] remove_all_tags
-------------------------------------

Removes all tags in the range between *start* and *end*. Be careful with this function; it could remove tags added in code unrelated to the code you’re currently writing. That is, using this function is probably a bad idea if you have two or more unrelated code sections that add tags.

    method gtk_text_buffer_remove_all_tags (
      Gnome::Gtk3::TextIter $start, Gnome::Gtk3::TextIter $end
    )

  * Gnome::Gtk3::TextIter $start; one bound of range to be untagged

  * Gnome::Gtk3::TextIter $end; other bound of range to be untagged

[[gtk_] text_buffer_] get_iter_at_line_offset
---------------------------------------------

Obtains an iterator pointing to *$char_offset* within the given line. Note characters, not bytes; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if *$line_number* is greater than the number of lines in the *buffer*, the end iterator is returned. And if *$char_offset* is off the end of the line, the iterator at the end of the line is returned.

    method gtk_text_buffer_get_iter_at_line_offset (
      Int $line_number, Int $char_offset
      --> Gnome::Gtk3::TextIter
    )

  * Int $line_number; line number counting from 0

  * Int $char_offset; char offset from start of line

[[gtk_] text_buffer_] get_iter_at_line_index
--------------------------------------------

Obtains an iterator pointing to *byte_index* within the given line. *byte_index* must be the start of a UTF-8 character. Note bytes, not characters; UTF-8 may encode one character as multiple bytes.

Before the 3.20 version, it was not allowed to pass an invalid location.

Since the 3.20 version, if *line_number* is greater than the number of lines in the *buffer*, the end iterator is returned. And if *byte_index* is off the end of the line, the iterator at the end of the line is returned.

    method gtk_text_buffer_get_iter_at_line_index (
      Int $line_number, Int $byte_index
      --> Gnome::Gtk3::TextIter
    )

  * Int $line_number; line number counting from 0

  * Int $byte_index; byte index from start of line

[[gtk_] text_buffer_] get_iter_at_offset
----------------------------------------

Initializes *iter* to a position *char_offset* chars from the start of the entire buffer. If *char_offset* is -1 or greater than the number of characters in the buffer, *iter* is initialized to the end iterator, the iterator one past the last valid character in the buffer.

    method gtk_text_buffer_get_iter_at_offset (
      Int $char_offset
      --> Gnome::Gtk3::TextIter
    )

  * Int $char_offset; char offset from start of buffer, counting from 0, or -1

[[gtk_] text_buffer_] get_iter_at_line
--------------------------------------

Returns an *iter* to the start of the given line. If *$line_number* is greater than the number of lines in the *buffer*, the end iterator is returned.

    method gtk_text_buffer_get_iter_at_line (
      Int $line_number
      --> Gnome::Gtk3::TextIter
    )

  * Int $line_number; line number counting from 0

[[gtk_] text_buffer_] get_start_iter
------------------------------------

Initialized *$iter* with the first position in the text buffer. This is the same as using `gtk_text_buffer_get_iter_at_offset()` to get the iter at character offset 0.

    method gtk_text_buffer_get_start_iter ( --> Gnome::Gtk3::TextIter )

  * N-GObject $iter; (out): iterator to initialize

[[gtk_] text_buffer_] get_end_iter
----------------------------------

Initializes *iter* with the “end iterator,” one past the last valid character in the text buffer. If dereferenced with `gtk_text_iter_get_char()`, the end iterator has a character value of 0. The entire buffer lies in the range from the first position in the buffer (call `gtk_text_buffer_get_start_iter()` to get character position 0) to the end iterator.

    method gtk_text_buffer_get_end_iter ( --> Gnome::Gtk3::TextIter )

  * N-GObject $iter; (out): iterator to initialize

[[gtk_] text_buffer_] get_bounds
--------------------------------

Retrieves the first and last iterators in the buffer, i.e. the entire buffer lies within the range [*start*,*end*).

    method gtk_text_buffer_get_bounds ( --> List )

Returns a list of

  * Gnome::Gtk3::TextIter $start; iterator to initialize with first position in the buffer

  * Gnome::Gtk3::TextIter $end; iterator to initialize with the end iterator

[[gtk_] text_buffer_] get_modified
----------------------------------

Indicates whether the buffer has been modified since the last call to `gtk_text_buffer_set_modified()` set the modification flag to `0`. Used for example to enable a “save” function in a text editor.

Returns: `1` if the buffer has been modified

    method gtk_text_buffer_get_modified ( --> Int  )

[[gtk_] text_buffer_] set_modified
----------------------------------

Used to keep track of whether the buffer has been modified since the last time it was saved. Whenever the buffer is saved to disk, call gtk_text_buffer_set_modified (*buffer*, FALSE). When the buffer is modified, it will automatically toggled on the modified bit again. When the modified bit flips, the buffer emits the *modified-changed* signal.

    method gtk_text_buffer_set_modified ( Int $setting )

  * Int $setting; modification flag setting

[[gtk_] text_buffer_] get_has_selection
---------------------------------------

Indicates whether the buffer has some text currently selected.

Returns: `1` if the there is text selected

    method gtk_text_buffer_get_has_selection ( --> Int  )

[[gtk_] text_buffer_] get_selection_bounds
------------------------------------------

Returns `1` if some text is selected; places the bounds of the selection in *start* and *end* (if the selection has length 0, then *start* and *end* are filled in with the same value). *start* and *end* will be in ascending order. If *start* and *end* are NULL, then they are not filled in, but the return value still indicates whether text is selected.

    method gtk_text_buffer_get_selection_bounds ( --> List )

Returned List contains

  * Int $status; `1` when the selection has nonzero length

  * Gnome::Gtk3::TextIter $start; iterator to initialize with selection start

  * Gnome::Gtk3::TextIter $end; iterator to initialize with selection end

[[gtk_] text_buffer_] delete_selection
--------------------------------------

Deletes the range between the “insert” and “selection_bound” marks, that is, the currently-selected text. If *interactive* is `1`, the editability of the selection will be considered (users can’t delete uneditable text).

Returns: whether there was a non-empty selection to delete

    method gtk_text_buffer_delete_selection ( Int $interactive, Int $default_editable --> Int  )

  * Int $interactive; whether the deletion is caused by user interaction

  * Int $default_editable; whether the buffer is editable by default

[[gtk_] text_buffer_] begin_user_action
---------------------------------------

Called to indicate that the buffer operations between here and a call to `gtk_text_buffer_end_user_action()` are part of a single user-visible operation. The operations between `gtk_text_buffer_begin_user_action()` and `gtk_text_buffer_end_user_action()` can then be grouped when creating an undo stack. **Gnome::Gtk3::TextBuffer** maintains a count of calls to `gtk_text_buffer_begin_user_action()` that have not been closed with a call to `gtk_text_buffer_end_user_action()`, and emits the “begin-user-action” and “end-user-action” signals only for the outermost pair of calls. This allows you to build user actions from other user actions.

The “interactive” buffer mutation functions, such as `gtk_text_buffer_insert_interactive()`, automatically call begin/end user action around the buffer operations they perform, so there's no need to add extra calls if you user action consists solely of a single call to one of those functions.

    method gtk_text_buffer_begin_user_action ( )

[[gtk_] text_buffer_] end_user_action
-------------------------------------

Should be paired with a call to `gtk_text_buffer_begin_user_action()`. See that function for a full explanation.

    method gtk_text_buffer_end_user_action ( )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### insert-text

The *insert-text* signal is emitted to insert text in a **Gnome::Gtk3::TextBuffer**. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to point to the end of the inserted text.

See also: `gtk_text_buffer_insert()`, `gtk_text_buffer_insert_range()`.

    method handler (
      N-GObject $location,
      Str $text,
      Int $len,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *text* in *textbuffer*. A native GtkTextIter object.

  * $text; the UTF-8 text to be inserted

  * $len; length of the inserted text in bytes

### insert-pixbuf

The *insert-pixbuf* signal is emitted to insert a **Gnome::Gdk3::Pixbuf** in a **Gnome::Gtk3::TextBuffer**. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to be placed after the inserted *pixbuf*.

See also: `gtk_text_buffer_insert_pixbuf()`.

    method handler (
      N-GObject $location,
      N-GObject $pixbuf,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *pixbuf* in *textbuffer*. A native GtkTextIter object.

  * $pixbuf; a native GdkPixbuf to be inserted

### insert-child-anchor

The *insert-child-anchor* signal is emitted to insert a **Gnome::Gtk3::TextChildAnchor** in a **Gnome::Gtk3::TextBuffer**. Insertion actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *location* iter (or has to revalidate it). The default signal handler revalidates it to be placed after the inserted *anchor*.

See also: `gtk_text_buffer_insert_child_anchor()`.

    method handler (
      N-GObject $location,
      N-GObject $anchor,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $location; position to insert *anchor* in *textbuffer*. A native GtkTextIter object.

  * $anchor; the native GtkTextChildAnchor object to be inserted

### delete-range

The *delete-range* signal is emitted to delete a range from a **Gnome::Gtk3::TextBuffer**.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them). The default signal handler revalidates the *start* and *end* iters to both point to the location where text was deleted. Handlers which run after the default handler (see `g_signal_connect_after()`) do not have access to the deleted text.

See also: `gtk_text_buffer_delete()`.

    method handler (
      N-GObject $start,
      N-GObject $end,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $start; the start of the range to be deleted. A native GtkTextIter object.

  * $end; the end of the range to be deleted. A native GtkTextIter object.

### changed

The *changed* signal is emitted when the content of a **Gnome::Gtk3::TextBuffer** has changed.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

### modified-changed

The *modified-changed* signal is emitted when the modified bit of a **Gnome::Gtk3::TextBuffer** flips.

See also: `gtk_text_buffer_set_modified()`.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

### mark-set

The *mark-set* signal is emitted as notification after a **Gnome::Gtk3::TextMark** is set.

See also: `gtk_text_buffer_create_mark()`, `gtk_text_buffer_move_mark()`.

    method handler (
      N-GObject $location,
      N-GObject $mark,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $location; The location of *mark* in *textbuffer*. A native GtkTextIter object.

  * $mark; The mark that is set. A native GtkTextMark object.

### mark-deleted

The *mark-deleted* signal is emitted as notification after a **Gnome::Gtk3::TextMark** is deleted.

See also: `gtk_text_buffer_delete_mark()`.

    method handler (
      N-GObject $mark,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $mark; The mark that was deleted. A native GtkTextMark object.

### apply-tag

The *apply-tag* signal is emitted to apply a tag to a range of text in a **Gnome::Gtk3::TextBuffer**. Applying actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them).

See also: `gtk_text_buffer_apply_tag()`, `gtk_text_buffer_insert_with_tags()`, `gtk_text_buffer_insert_range()`.

    method handler (
      N-GObject $tag,
      N-GObject $start,
      N-GObject $end,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $tag; the applied tag. A native GtkTextTag object.

  * $start; the start of the range the tag is applied to. A native GtkTextIter object.

  * $end; the end of the range the tag is applied to. A native GtkTextIter object.

### remove-tag

The *remove-tag* signal is emitted to remove all occurrences of *tag* from a range of text in a **Gnome::Gtk3::TextBuffer**. Removal actually occurs in the default handler.

Note that if your handler runs before the default handler it must not invalidate the *start* and *end* iters (or has to revalidate them).

See also: `gtk_text_buffer_remove_tag()`.

    method handler (
      N-GObject $tag,
      N-GObject $start,
      N-GObject $end,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $tag; the tag to be removed. A native GtkTextTag object.

  * $start; the start of the range the tag is removed from. A native GtkTextIter object.

  * $end; the end of the range the tag is removed from. A native GtkTextIter object.

### begin-user-action

The *begin-user-action* signal is emitted at the beginning of a single user-visible operation on a **Gnome::Gtk3::TextBuffer**.

See also: `gtk_text_buffer_begin_user_action()`, `gtk_text_buffer_insert_interactive()`, `gtk_text_buffer_insert_range_interactive()`, `gtk_text_buffer_delete_interactive()`, `gtk_text_buffer_backspace()`, `gtk_text_buffer_delete_selection()`.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

### end-user-action

The *end-user-action* signal is emitted at the end of a single user-visible operation on the **Gnome::Gtk3::TextBuffer**.

See also: `gtk_text_buffer_end_user_action()`, `gtk_text_buffer_insert_interactive()`, `gtk_text_buffer_insert_range_interactive()`, `gtk_text_buffer_delete_interactive()`, `gtk_text_buffer_backspace()`, `gtk_text_buffer_delete_selection()`, `gtk_text_buffer_backspace()`.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

### paste-done

The paste-done signal is emitted after paste operation has been completed. This is useful to properly scroll the view to the end of the pasted text. See `gtk_text_buffer_paste_clipboard()` for more details.

    method handler (
      N-GObject $clipboard,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($textbuffer),
      *%user-options
    );

  * $textbuffer; the object which received the signal

  * $clipboard; the native GtkClipboard pasted from

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Text

The text content of the buffer. Without child widgets and images, see `gtk_text_buffer_get_text()` for more information.

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### Has selection

Whether the buffer has some text currently selected.

The **Gnome::GObject::Value** type of property *has-selection* is `G_TYPE_BOOLEAN`.

### Cursor position

The position of the insert mark (as offset from the beginning of the buffer). It is useful for getting notified when the cursor moves.

The **Gnome::GObject::Value** type of property *cursor-position* is `G_TYPE_INT`.

