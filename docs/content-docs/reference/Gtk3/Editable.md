Gnome::Gtk3::Editable
=====================

Interface for text-editing widgets

Description
===========

The **Gnome::Gtk3::Editable** interface is an interface which should be implemented by text editing widgets, such as **Gnome::Gtk3::Entry** and **Gnome::Gtk3::SpinButton**. It contains functions for generically manipulating an editable widget, a large number of action signals used for key bindings, and several signals that an application can connect to to modify the behavior of a widget.

As an example of the latter usage, by connecting the following handler to *insert-text*, an application can convert all entry into a widget into uppercase.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Editable;

Methods
=======

copy-clipboard
--------------

Copies the contents of the currently selected content in the editable and puts it on the clipboard.

    method copy-clipboard ( )

cut-clipboard
-------------

Removes the contents of the currently selected content in the editable and puts it on the clipboard.

    method cut-clipboard ( )

delete-selection
----------------

Deletes the currently selected text of the editable. This call doesn’t do anything if there is no selected text.

    method delete-selection ( )

delete-text
-----------

Deletes a sequence of characters. The characters that are deleted are those characters at positions from *start-pos* up to, but not including *end-pos*. If *end-pos* is negative, then the characters deleted are those from *start-pos* to the end of the text.

Note that the positions are specified in characters, not bytes.

    method delete-text ( Int $start_pos, Int $end_pos )

  * Int $start_pos; start position

  * Int $end_pos; end position

get-chars
---------

Retrieves a sequence of characters. The characters that are retrieved are those characters at positions from *start-pos* up to, but not including *end-pos*. If *end-pos* is negative, then the characters retrieved are those characters from *start-pos* to the end of the text.

Note that positions are specified in characters, not bytes.

Returns: a pointer to the contents of the widget as a string. This string is allocated by the **Gnome::Gtk3::Editable** implementation and should be freed by the caller.

    method get-chars ( Int $start_pos, Int $end_pos --> Str )

  * Int $start_pos; start of text

  * Int $end_pos; end of text

get-editable
------------

Retrieves whether *editable* is editable. See `set-editable()`.

Returns: `True` if *editable* is editable.

    method get-editable ( --> Bool )

get-position
------------

Retrieves the current position of the cursor relative to the start of the content of the editable.

Note that this position is in characters, not in bytes.

Returns: the cursor position

    method get-position ( --> Int )

get-selection-bounds
--------------------

Retrieves the selection bound of the editable. start-pos will be filled with the start of the selection and *end-pos* with end. If no text was selected both will be identical and `False` will be returned.

Note that positions are specified in characters, not bytes.

Returns: `True` if an area is selected, `False` otherwise

    method get-selection-bounds ( --> Bool )

  * Int $start_pos; location to store the starting position, or `undefined`

  * Int $end_pos; location to store the end position, or `undefined`

insert-text
-----------

Inserts *new-text-length* bytes of *new-text* into the contents of the widget, at position *position*.

Note that the position is in characters, not in bytes. The function updates *position* to point after the newly inserted text.

    method insert-text ( Str $new_text, Int $new_text_length )

  * Str $new_text; the text to append

  * Int $new_text_length; the length of the text in bytes, or -1

  * Int $position; location of the position text will be inserted at

paste-clipboard
---------------

Pastes the content of the clipboard to the current position of the cursor in the editable.

    method paste-clipboard ( )

select-region
-------------

Selects a region of text. The characters that are selected are those characters at positions from *start-pos* up to, but not including *end-pos*. If *end-pos* is negative, then the characters selected are those characters from *start-pos* to the end of the text.

Note that positions are specified in characters, not bytes.

    method select-region ( Int $start_pos, Int $end_pos )

  * Int $start_pos; start of region

  * Int $end_pos; end of region

set-editable
------------

Determines if the user can edit the text in the editable widget or not.

    method set-editable ( Bool $is_editable )

  * Bool $is_editable; `True` if the user is allowed to edit the text in the widget

set-position
------------

Sets the cursor position in the editable to the given value.

The cursor is displayed before the character with the given (base 0) index in the contents of the editable. The value must be less than or equal to the number of characters in the editable. A value of -1 indicates that the position should be set after the last character of the editable. Note that *position* is in characters, not in bytes.

    method set-position ( Int $position )

  * Int $position; the position of the cursor

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### changed

The *changed* signal is emitted at the end of a single user-visible operation on the contents of the **Gnome::Gtk3::Editable**.

E.g., a paste operation that replaces the contents of the selection will cause only one signal emission (even though it is implemented by first deleting the selection, then inserting the new content, and may cause multiple *notify*::text signals to be emitted).

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($editable),
      *%user-options
    );

  * $editable; the object which received the signal

### delete-text

This signal is emitted when text is deleted from the widget by the user. The default handler for this signal will normally be responsible for deleting the text, so by connecting to this signal and then stopping the signal with `g-signal-stop-emission()`, it is possible to modify the range of deleted text, or prevent it from being deleted entirely. The *start-pos* and *end-pos* parameters are interpreted as for `delete-text()`.

    method handler (
      Int $start_pos,
      Int $end_pos,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($editable),
      *%user-options
    );

  * $editable; the object which received the signal

  * $start_pos; the starting position

  * $end_pos; the end position

### insert-text

This signal is emitted when text is inserted into the widget by the user. The default handler for this signal will normally be responsible for inserting the text, so by connecting to this signal and then stopping the signal with `g-signal-stop-emission()`, it is possible to modify the inserted text, or prevent it from being inserted entirely.

    method handler (
      Str $new_text,
      Int $new_text_length,
      Unknown type G_TYPE_POINTER $position,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($editable),
      *%user-options
    );

  * $editable; the object which received the signal

  * $new_text; the new text to insert

  * $new_text_length; the length of the new text, in bytes, or -1 if new-text is nul-terminated

  * $position; (inout) (type int): the position, in characters, at which to insert the new text. this is an in-outparameter. After the signal emission is finished, itshould point after the newly inserted text.

