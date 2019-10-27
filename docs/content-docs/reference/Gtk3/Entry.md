Gnome::Gtk3::Entry
==================

A single line text entry field

![](images/entry.png)

Description
===========

The **Gnome::Gtk3::Entry** widget is a single line text entry widget. A fairly large set of key bindings are supported by default. If the entered text is longer than the allocation of the widget, the widget will scroll so that the cursor position is visible.

When using an entry for passwords and other sensitive information, it can be put into “password mode” using `gtk_entry_set_visibility()`. In this mode, entered text is displayed using a “invisible” character. By default, GTK+ picks the best invisible character that is available in the current font, but it can be changed with `gtk_entry_set_invisible_char()`. Since 2.16, GTK+ displays a warning when Caps Lock or input methods might interfere with entering text in a password entry. The warning can be turned off with the *caps-lock-warning* property.

Since 2.16, **Gnome::Gtk3::Entry** has the ability to display progress or activity information behind the text. To make an entry display such information, use `gtk_entry_set_progress_fraction()` or `gtk_entry_set_progress_pulse_step()`.

Additionally, **Gnome::Gtk3::Entry** can show icons at either side of the entry. These icons can be activatable by clicking, can be set up as drag source and can have tooltips. To add an icon, use `gtk_entry_set_icon_from_gicon()` or one of the various other functions that set an icon from a stock id, an icon name or a pixbuf. To trigger an action when the user clicks an icon, connect to the *icon-press* signal. To allow DND operations from an icon, use `gtk_entry_set_icon_drag_source()`. To set a tooltip on an icon, use `gtk_entry_set_icon_tooltip_text()` or the corresponding function for markup.

Note that functionality or information that is only available by clicking on an icon in an entry may not be accessible at all to users which are not able to use a mouse or other pointing device. It is therefore recommended that any such functionality should also be available by other means, e.g. via the context menu of the entry.

Css Nodes
---------

    entry
    ├── image.left
    ├── image.right
    ├── undershoot.left
    ├── undershoot.right
    ├── [selection]
    ├── [progress[.pulse]]
    ╰── [window.popup]

**Gnome::Gtk3::Entry** has a main node with the name entry. Depending on the properties of the entry, the style classes .read-only and .flat may appear. The style classes .warning and .error may also be used with entries.

When the entry shows icons, it adds subnodes with the name image and the style class .left or .right, depending on where the icon appears.

When the entry has a selection, it adds a subnode with the name selection.

When the entry shows progress, it adds a subnode with the name progress. The node has the style class .pulse when the shown progress is pulsing.

The CSS node for a context menu is added as a subnode below entry as well.

The undershoot nodes are used to draw the underflow indication when content is scrolled out of view. These nodes get the .left and .right style classes added depending on where the indication is drawn.

When touch is used and touch selection handles are shown, they are using CSS nodes with name cursor-handle. They get the .top or .bottom style class depending on where they are shown in relation to the selection. If there is just a single handle for the text cursor, it gets the style class .insertion-cursor.

Implemented Interfaces
----------------------

Gnome::Gtk3::Entry implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * Gnome::Gtk3::Editable

  * Gnome::Gtk3::CellEditable

See Also
--------

**Gnome::Gtk3::TextView**, **Gnome::Gtk3::EntryCompletion**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Entry;
    also is Gnome::Gtk3::Widget;
    also does Gnome::Gtk3::Buildable;

Types
=====

enum GtkEntryIconPosition
-------------------------

Specifies the side of the entry at which an icon is placed.

Since: 2.16

  * GTK_ENTRY_ICON_PRIMARY: At the beginning of the entry (depending on the text direction).

  * GTK_ENTRY_ICON_SECONDARY: At the end of the entry (depending on the text direction).

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_entry_new
-------------

Creates a new entry.

Returns: a new **Gnome::Gtk3::Entry**.

    method gtk_entry_new ( --> N-GObject  )

[gtk_entry_] new_with_buffer
----------------------------

Creates a new entry with the specified text buffer.

Returns: a new **Gnome::Gtk3::Entry**

Since: 2.18

    method gtk_entry_new_with_buffer ( N-GObject $buffer --> N-GObject  )

  * N-GObject $buffer; The buffer to use for the new **Gnome::Gtk3::Entry**.

[gtk_entry_] get_buffer
-----------------------

Get the **Gnome::Gtk3::EntryBuffer** object which holds the text for this widget.

Since: 2.18

Returns: (transfer none): A **Gnome::Gtk3::EntryBuffer** object.

    method gtk_entry_get_buffer ( --> N-GObject  )

[gtk_entry_] set_buffer
-----------------------

Set the **Gnome::Gtk3::EntryBuffer** object which holds the text for this widget.

Since: 2.18

    method gtk_entry_set_buffer ( N-GObject $buffer )

  * N-GObject $buffer; a **Gnome::Gtk3::EntryBuffer**

[gtk_entry_] get_text_area
--------------------------

Gets the area where the entry’s text is drawn. This function is useful when drawing something to the entry in a draw callback.

If the entry is not realized, *text_area* is filled with zeros.

See also `gtk_entry_get_icon_area()`.

Since: 3.0

    method gtk_entry_get_text_area ( N-GObject $text_area )

  * N-GObject $text_area; (out): Return location for the text area.

[gtk_entry_] set_visibility
---------------------------

Sets whether the contents of the entry are visible or not. When visibility is set to `0`, characters are displayed as the invisible char, and will also appear that way when the text in the entry widget is copied elsewhere.

By default, GTK+ picks the best invisible character available in the current font, but it can be changed with `gtk_entry_set_invisible_char()`.

Note that you probably want to set *input-purpose* to `GTK_INPUT_PURPOSE_PASSWORD` or `GTK_INPUT_PURPOSE_PIN` to inform input methods about the purpose of this entry, in addition to setting visibility to `0`.

    method gtk_entry_set_visibility ( Int $visible )

  * Int $visible; `1` if the contents of the entry are displayed as plaintext

[gtk_entry_] get_visibility
---------------------------

Retrieves whether the text in *entry* is visible. See `gtk_entry_set_visibility()`.

Returns: `1` if the text is currently visible

    method gtk_entry_get_visibility ( --> Int  )

[gtk_entry_] set_invisible_char
-------------------------------

Sets the character to use in place of the actual text when `gtk_entry_set_visibility()` has been called to set text visibility to `0`. i.e. this is the character used in “password mode” to show the user how many characters have been typed. By default, GTK+ picks the best invisible char available in the current font. If you set the invisible char to 0, then the user will get no feedback at all; there will be no text on the screen as they type.

    method gtk_entry_set_invisible_char ( gunichar $ch )

  * UInt $ch; a Unicode character. This is a 4 byte UCS representation of

[gtk_entry_] get_invisible_char
-------------------------------

Retrieves the character displayed in place of the real characters for entries with visibility set to false. See `gtk_entry_set_invisible_char()`.

Returns: the current invisible char, or 0, if the entry does not show invisible text at all.

    method gtk_entry_get_invisible_char ( --> UInt  )

[gtk_entry_] unset_invisible_char
---------------------------------

Unsets the invisible char previously set with `gtk_entry_set_invisible_char()`. So that the default invisible char is used again.

Since: 2.16

    method gtk_entry_unset_invisible_char ( )

[gtk_entry_] set_has_frame
--------------------------

Sets whether the entry has a beveled frame around it.

    method gtk_entry_set_has_frame ( Int $setting )

  * Int $setting; new value

[gtk_entry_] get_has_frame
--------------------------

Gets the value set by `gtk_entry_set_has_frame()`.

Returns: whether the entry has a beveled frame

    method gtk_entry_get_has_frame ( --> Int  )

[gtk_entry_] set_overwrite_mode
-------------------------------

Sets whether the text is overwritten when typing in the **Gnome::Gtk3::Entry**.

Since: 2.14

    method gtk_entry_set_overwrite_mode ( Int $overwrite )

  * Int $overwrite; new value

[gtk_entry_] get_overwrite_mode
-------------------------------

Gets the value set by `gtk_entry_set_overwrite_mode()`.

Returns: whether the text is overwritten when typing.

Since: 2.14

    method gtk_entry_get_overwrite_mode ( --> Int  )

[gtk_entry_] set_max_length
---------------------------

Sets the maximum allowed length of the contents of the widget. If the current contents are longer than the given length, then they will be truncated to fit.

This is equivalent to:

|[<!-- language="C" --> **Gnome::Gtk3::EntryBuffer** *buffer; buffer = gtk_entry_get_buffer (entry); gtk_entry_buffer_set_max_length (buffer, max); ]|

    method gtk_entry_set_max_length ( Int $max )

  * Int $max; the maximum length of the entry, or 0 for no maximum. (other than the maximum length of entries.) The value passed in will be clamped to the range 0-65536.

[gtk_entry_] get_max_length
---------------------------

Retrieves the maximum allowed length of the text in *entry*. See `gtk_entry_set_max_length()`.

This is equivalent to:

|[<!-- language="C" --> **Gnome::Gtk3::EntryBuffer** *buffer; buffer = gtk_entry_get_buffer (entry); gtk_entry_buffer_get_max_length (buffer); ]|

Returns: the maximum allowed number of characters in **Gnome::Gtk3::Entry**, or 0 if there is no maximum.

    method gtk_entry_get_max_length ( --> Int  )

[gtk_entry_] get_text_length
----------------------------

Retrieves the current length of the text in *entry*.

This is equivalent to:

|[<!-- language="C" --> **Gnome::Gtk3::EntryBuffer** *buffer; buffer = gtk_entry_get_buffer (entry); gtk_entry_buffer_get_length (buffer); ]|

Returns: the current number of characters in **Gnome::Gtk3::Entry**, or 0 if there are none.

Since: 2.14

    method gtk_entry_get_text_length ( --> UInt  )

[gtk_entry_] set_activates_default
----------------------------------

If *setting* is `1`, pressing Enter in the *entry* will activate the default widget for the window containing the entry. This usually means that the dialog box containing the entry will be closed, since the default widget is usually one of the dialog buttons.

(For experts: if *setting* is `1`, the entry calls `gtk_window_activate_default()` on the window containing the entry, in the default handler for the *activate* signal.)

    method gtk_entry_set_activates_default ( Int $setting )

  * Int $setting; `1` to activate window’s default widget on Enter keypress

[gtk_entry_] get_activates_default
----------------------------------

Retrieves the value set by `gtk_entry_set_activates_default()`.

Returns: `1` if the entry will activate the default widget

    method gtk_entry_get_activates_default ( --> Int  )

[gtk_entry_] set_width_chars
----------------------------

Changes the size request of the entry to be about the right size for *n_chars* characters. Note that it changes the size request, the size can still be affected by how you pack the widget into containers. If *n_chars* is -1, the size reverts to the default entry size.

    method gtk_entry_set_width_chars ( Int $n_chars )

  * Int $n_chars; width in chars

[gtk_entry_] get_width_chars
----------------------------

Gets the value set by `gtk_entry_set_width_chars()`.

Returns: number of chars to request space for, or negative if unset

    method gtk_entry_get_width_chars ( --> Int  )

[gtk_entry_] set_max_width_chars
--------------------------------

Sets the desired maximum width in characters of *entry*.

Since: 3.12

    method gtk_entry_set_max_width_chars ( Int $n_chars )

  * Int $n_chars; the new desired maximum width, in characters

[gtk_entry_] get_max_width_chars
--------------------------------

Retrieves the desired maximum width of *entry*, in characters. See `gtk_entry_set_max_width_chars()`.

Returns: the maximum width of the entry, in characters

Since: 3.12

    method gtk_entry_get_max_width_chars ( --> Int  )

[gtk_entry_] set_text
---------------------

Sets the text in the widget to the given value, replacing the current contents.

See `gtk_entry_buffer_set_text()`.

    method gtk_entry_set_text ( Str $text )

  * Str $text; the new text

[gtk_entry_] get_text
---------------------

Retrieves the contents of the entry widget. See also `gtk_editable_get_chars()`.

This is equivalent to:

|[<!-- language="C" --> **Gnome::Gtk3::EntryBuffer** *buffer; buffer = gtk_entry_get_buffer (entry); gtk_entry_buffer_get_text (buffer); ]|

Returns: a pointer to the contents of the widget as a string. This string points to internally allocated storage in the widget and must not be freed, modified or stored.

    method gtk_entry_get_text ( --> Str  )

[gtk_entry_] set_alignment
--------------------------

Sets the alignment for the contents of the entry. This controls the horizontal positioning of the contents when the displayed text is shorter than the width of the entry.

Since: 2.4

    method gtk_entry_set_alignment ( Num $xalign )

  * Num $xalign; The horizontal alignment, from 0 (left) to 1 (right). Reversed for RTL layouts

[gtk_entry_] get_alignment
--------------------------

Gets the value set by `gtk_entry_set_alignment()`.

Returns: the alignment

Since: 2.4

    method gtk_entry_get_alignment ( --> Num  )

[gtk_entry_] set_completion
---------------------------

Sets *completion* to be the auxiliary completion object to use with *entry*. All further configuration of the completion mechanism is done on *completion* using the **Gnome::Gtk3::EntryCompletion** API. Completion is disabled if *completion* is set to `Any`.

Since: 2.4

    method gtk_entry_set_completion ( N-GObject $completion )

  * N-GObject $completion; (allow-none): The **Gnome::Gtk3::EntryCompletion** or `Any`

[gtk_entry_] get_completion
---------------------------

Returns the auxiliary completion object currently in use by *entry*.

Returns: (transfer none): The auxiliary completion object currently in use by *entry*.

Since: 2.4

    method gtk_entry_get_completion ( --> N-GObject  )

[gtk_entry_] set_cursor_hadjustment
-----------------------------------

Hooks up an adjustment to the cursor position in an entry, so that when the cursor is moved, the adjustment is scrolled to show that position. See `gtk_scrolled_window_get_hadjustment()` for a typical way of obtaining the adjustment.

The adjustment has to be in pixel units and in the same coordinate system as the entry.

Since: 2.12

    method gtk_entry_set_cursor_hadjustment ( N-GObject $adjustment )

  * N-GObject $adjustment; (nullable): an adjustment which should be adjusted when the cursor is moved, or `Any`

[gtk_entry_] get_cursor_hadjustment
-----------------------------------

Retrieves the horizontal cursor adjustment for the entry. See `gtk_entry_set_cursor_hadjustment()`.

Returns: (transfer none) (nullable): the horizontal cursor adjustment, or `Any` if none has been set.

Since: 2.12

    method gtk_entry_get_cursor_hadjustment ( --> N-GObject  )

[gtk_entry_] set_progress_fraction
----------------------------------

Causes the entry’s progress indicator to “fill in” the given fraction of the bar. The fraction should be between 0.0 and 1.0, inclusive.

Since: 2.16

    method gtk_entry_set_progress_fraction ( Num $fraction )

  * Num $fraction; fraction of the task that’s been completed

[gtk_entry_] get_progress_fraction
----------------------------------

Returns the current fraction of the task that’s been completed. See `gtk_entry_set_progress_fraction()`.

Returns: a fraction from 0.0 to 1.0

Since: 2.16

    method gtk_entry_get_progress_fraction ( --> Num  )

[gtk_entry_] set_progress_pulse_step
------------------------------------

Sets the fraction of total entry width to move the progress bouncing block for each call to `gtk_entry_progress_pulse()`.

Since: 2.16

    method gtk_entry_set_progress_pulse_step ( Num $fraction )

  * Num $fraction; fraction between 0.0 and 1.0

[gtk_entry_] get_progress_pulse_step
------------------------------------

Retrieves the pulse step set with `gtk_entry_set_progress_pulse_step()`.

Returns: a fraction from 0.0 to 1.0

Since: 2.16

    method gtk_entry_get_progress_pulse_step ( --> Num  )

[gtk_entry_] progress_pulse
---------------------------

Indicates that some progress is made, but you don’t know how much. Causes the entry’s progress indicator to enter “activity mode,” where a block bounces back and forth. Each call to `gtk_entry_progress_pulse()` causes the block to move by a little bit (the amount of movement per pulse is determined by `gtk_entry_set_progress_pulse_step()`).

Since: 2.16

    method gtk_entry_progress_pulse ( )

[gtk_entry_] get_placeholder_text
---------------------------------

Retrieves the text that will be displayed when *entry* is empty and unfocused

Returns: a pointer to the placeholder text as a string. This string points to internally allocated storage in the widget and must not be freed, modified or stored.

Since: 3.2

    method gtk_entry_get_placeholder_text ( --> Str  )

[gtk_entry_] set_placeholder_text
---------------------------------

Sets text to be displayed in *entry* when it is empty and unfocused. This can be used to give a visual hint of the expected contents of the **Gnome::Gtk3::Entry**.

Note that since the placeholder text gets removed when the entry received focus, using this feature is a bit problematic if the entry is given the initial focus in a window. Sometimes this can be worked around by delaying the initial focus setting until the first key event arrives.

Since: 3.2

    method gtk_entry_set_placeholder_text ( Str $text )

  * Str $text; (nullable): a string to be displayed when *entry* is empty and unfocused, or `Any`

[gtk_entry_] set_icon_from_pixbuf
---------------------------------

Sets the icon shown in the specified position using a pixbuf.

If *pixbuf* is `Any`, no icon will be shown in the specified position.

Since: 2.16

    method gtk_entry_set_icon_from_pixbuf (
      GtkEntryIconPosition $icon_pos, N-GObject $pixbuf
    )

  * GtkEntryIconPosition $icon_pos; Icon position

  * N-GObject $pixbuf; (allow-none): A **Gnome::Gdk3::Pixbuf**, or `Any`

[gtk_entry_] set_icon_from_icon_name
------------------------------------

Sets the icon shown in the entry at the specified position from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be displayed instead.

If *icon_name* is `Any`, no icon will be shown in the specified position.

Since: 2.16

    method gtk_entry_set_icon_from_icon_name (
      GtkEntryIconPosition $icon_pos, Str $icon_name
    )

  * GtkEntryIconPosition $icon_pos; The position at which to set the icon

  * Str $icon_name; (allow-none): An icon name, or `Any`

[gtk_entry_] set_icon_from_gicon
--------------------------------

Sets the icon shown in the entry at the specified position from the current icon theme. If the icon isn’t known, a “broken image” icon will be displayed instead.

If *icon* is `Any`, no icon will be shown in the specified position.

Since: 2.16

    method gtk_entry_set_icon_from_gicon (
      GtkEntryIconPosition $icon_pos, N-GObject $icon
    )

  * GtkEntryIconPosition $icon_pos; The position at which to set the icon

  * N-GObject $icon; (allow-none): The icon to set, or `Any`

[gtk_entry_] get_icon_storage_type
----------------------------------

Gets the type of representation being used by the icon to store image data. If the icon has no image data, the return value will be `GTK_IMAGE_EMPTY`.

Returns: image representation being used

Since: 2.16

    method gtk_entry_get_icon_storage_type (
      GtkEntryIconPosition $icon_pos
      --> GtkImageType
    )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] get_icon_pixbuf
----------------------------

Retrieves the image used for the icon.

Unlike the other methods of setting and getting icon data, this method will work regardless of whether the icon was set using a **Gnome::Gdk3::Pixbuf**, a **GIcon**, a stock item, or an icon name.

Returns: (transfer none) (nullable): A **Gnome::Gdk3::Pixbuf**, or `Any` if no icon is set for this position.

Since: 2.16

    method gtk_entry_get_icon_pixbuf (
      GtkEntryIconPosition $icon_pos --> N-GObject
    )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] get_icon_name
--------------------------

Retrieves the icon name used for the icon, or `Any` if there is no icon or if the icon was set by some other method (e.g., by pixbuf, stock or gicon).

Returns: (nullable): An icon name, or `Any` if no icon is set or if the icon wasn’t set from an icon name

Since: 2.16

    method gtk_entry_get_icon_name ( GtkEntryIconPosition $icon_pos --> Str )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] get_icon_gicon
---------------------------

Retrieves the **GIcon** used for the icon, or `Any` if there is no icon or if the icon was set by some other method (e.g., by stock, pixbuf, or icon name).

Returns: (transfer none) (nullable): A **GIcon**, or `Any` if no icon is set or if the icon is not a **GIcon**

Since: 2.16

    method gtk_entry_get_icon_gicon (
      GtkEntryIconPosition $icon_pos --> N-GObject
    )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] set_icon_activatable
---------------------------------

Sets whether the icon is activatable.

Since: 2.16

    method gtk_entry_set_icon_activatable (
      GtkEntryIconPosition $icon_pos, Int $activatable
    )

  * GtkEntryIconPosition $icon_pos; Icon position

  * Int $activatable; `1` if the icon should be activatable

[gtk_entry_] get_icon_activatable
---------------------------------

Returns whether the icon is activatable.

Returns: `1` if the icon is activatable.

Since: 2.16

    method gtk_entry_get_icon_activatable (
      GtkEntryIconPosition $icon_pos --> Int
    )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] set_icon_sensitive
-------------------------------

Sets the sensitivity for the specified icon.

Since: 2.16

    method gtk_entry_set_icon_sensitive (
      GtkEntryIconPosition $icon_pos, Int $sensitive
    )

  * GtkEntryIconPosition $icon_pos; Icon position

  * Int $sensitive; Specifies whether the icon should appear sensitive or insensitive

[gtk_entry_] get_icon_sensitive
-------------------------------

Returns whether the icon appears sensitive or insensitive.

Returns: `1` if the icon is sensitive.

Since: 2.16

    method gtk_entry_get_icon_sensitive (
      GtkEntryIconPosition $icon_pos --> Int
    )

  * GtkEntryIconPosition $icon_pos; Icon position

[gtk_entry_] get_icon_at_pos
----------------------------

Finds the icon at the given position and return its index. The position’s coordinates are relative to the *entry*’s top left corner. If *x*, *y* doesn’t lie inside an icon, -1 is returned. This function is intended for use in a *query-tooltip* signal handler.

Returns: the index of the icon at the given position, or -1

Since: 2.16

    method gtk_entry_get_icon_at_pos ( Int $x, Int $y --> Int  )

  * Int $x; the x coordinate of the position to find

  * Int $y; the y coordinate of the position to find

[gtk_entry_] set_icon_tooltip_text
----------------------------------

Sets *tooltip* as the contents of the tooltip for the icon at the specified position.

Use `Any` for *tooltip* to remove an existing tooltip.

See also `gtk_widget_set_tooltip_text()` and `gtk_entry_set_icon_tooltip_markup()`.

Since: 2.16

    method gtk_entry_set_icon_tooltip_text (
      GtkEntryIconPosition $icon_pos, Str $tooltip
    )

  * GtkEntryIconPosition $icon_pos; the icon position

  * Str $tooltip; (allow-none): the contents of the tooltip for the icon, or `Any`

[gtk_entry_] get_icon_tooltip_text
----------------------------------

Gets the contents of the tooltip on the icon at the specified position in *entry*.

Returns: (nullable): the tooltip text, or `Any`. Free the returned string with `g_free()` when done.

Since: 2.16

    method gtk_entry_get_icon_tooltip_text (
      GtkEntryIconPosition $icon_pos --> Str
    )

  * GtkEntryIconPosition $icon_pos; the icon position

[gtk_entry_] get_icon_tooltip_markup
------------------------------------

Gets the contents of the tooltip on the icon at the specified position in *entry*.

Returns: (nullable): the tooltip text, or `Any`. Free the returned string with `g_free()` when done.

Since: 2.16

    method gtk_entry_get_icon_tooltip_markup (
      GtkEntryIconPosition $icon_pos --> Str
    )

  * GtkEntryIconPosition $icon_pos; the icon position

[gtk_entry_] get_current_icon_drag_source
-----------------------------------------

Returns the index of the icon which is the source of the current DND operation, or -1.

This function is meant to be used in a *drag-data-get* callback.

Returns: index of the icon which is the source of the current DND operation, or -1.

Since: 2.16

    method gtk_entry_get_current_icon_drag_source ( --> Int  )

[gtk_entry_] get_icon_area
--------------------------

Gets the area where entry’s icon at *icon_pos* is drawn. This function is useful when drawing something to the entry in a draw callback.

If the entry is not realized or has no icon at the given position, *icon_area* is filled with zeros.

See also `gtk_entry_get_text_area()`

Since: 3.0

    method gtk_entry_get_icon_area (
      GtkEntryIconPosition $icon_pos, N-GObject $icon_area
    )

  * GtkEntryIconPosition $icon_pos; Icon position

  * N-GObject $icon_area; (out): Return location for the icon’s area

[gtk_entry_] im_context_filter_keypress
---------------------------------------

Allow the **Gnome::Gtk3::Entry** input method to internally handle key press and release events. If this function returns `1`, then no further processing should be done for this key event. See `gtk_im_context_filter_keypress()`.

Note that you are expected to call this function from your handler when overriding key event handling. This is needed in the case when you need to insert your own key handling between the input method and the default key event handling of the **Gnome::Gtk3::Entry**. See `gtk_text_view_reset_im_context()` for an example of use.

Returns: `1` if the input method handled the key event.

Since: 2.22

    method gtk_entry_im_context_filter_keypress ( GdkEventKey $event --> Int  )

  * GdkEventKey $event; (type **Gnome::Gdk3::.EventKey**): the key event

[gtk_entry_] reset_im_context
-----------------------------

Reset the input method context of the entry if needed.

This can be necessary in the case where modifying the buffer would confuse on-going input method behavior.

Since: 2.22

    method gtk_entry_reset_im_context ( )

[gtk_entry_] set_input_purpose
------------------------------

Sets the *input-purpose* property which can be used by on-screen keyboards and other input methods to adjust their behaviour.

Since: 3.6

    method gtk_entry_set_input_purpose ( GtkInputPurpose $purpose )

  * GtkInputPurpose $purpose; the purpose

[gtk_entry_] get_input_purpose
------------------------------

Gets the value of the *input-purpose* property.

Since: 3.6

    method gtk_entry_get_input_purpose ( --> GtkInputPurpose  )

[gtk_entry_] set_input_hints
----------------------------

Sets the *input-hints* property, which allows input methods to fine-tune their behaviour.

Since: 3.6

    method gtk_entry_set_input_hints ( GtkInputHints $hints )

  * GtkInputHints $hints; the hints

[gtk_entry_] get_input_hints
----------------------------

Gets the value of the *input-hints* property.

Since: 3.6

    method gtk_entry_get_input_hints ( --> GtkInputHints  )

[gtk_entry_] grab_focus_without_selecting
-----------------------------------------

Causes *entry* to have keyboard focus.

It behaves like `gtk_widget_grab_focus()`, except that it doesn't select the contents of the entry. You only want to call this on some special entries which the user usually doesn't want to replace all text in, such as search-as-you-type entries.

Since: 3.16

    method gtk_entry_grab_focus_without_selecting ( )

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

### tabs

A list of tabstops to apply to the text of the entry.

Since: 3.8

    method handler (
      ,
      *%user-options
    );

### populate-popup

The *populate-popup* signal gets emitted before showing the context menu of the entry.

If you need to add items to the context menu, connect to this signal and append your items to the *widget*, which will be a **Gnome::Gtk3::Menu** in this case.

If *populate-all* is `1`, this signal will also be emitted to populate touch popups. In this case, *widget* will be a different container, e.g. a **Gnome::Gtk3::Toolbar**. The signal handler should not make assumptions about the type of *widget*.

    method handler (
      - $popup,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; The entry on which the signal is emitted

  * $popup; the container that is being populated

### activate

The *activate* signal is emitted when the user hits the Enter key.

While this signal is used as a [keybinding signal][**Gnome::Gtk3::BindingSignal**], it is also commonly used by applications to intercept activation of entries.

The default bindings for this signal are all forms of the Enter key.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; The entry on which the signal is emitted

### move-cursor

The *move-cursor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates a cursor movement. If the cursor is not visible in *entry*, this signal causes the viewport to be moved instead.

Applications should not connect to it, but may emit it with `g_signal_emit_by_name()` if they need to control the cursor programmatically.

The default bindings for this signal come in two variants, the variant with the Shift modifier extends the selection, the variant without the Shift modifer does not. There are too many key combinations to list them all here. - Arrow keys move by individual characters/lines - Ctrl-arrow key combinations move by words/paragraphs - Home/End keys move to the ends of the buffer

    method handler (
      Str $step,
      - $count,
      - $extend_selection,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

  * $step; the granularity of the move, as a **Gnome::Gtk3::MovementStep**

  * $count; the number of *step* units to move

  * $extend_selection; `1` if the move should extend the selection

### insert-at-cursor

The *insert-at-cursor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates the insertion of a fixed string at the cursor.

This signal has no default bindings.

    method handler (
      Unknown type GTK_TYPE_DELETE_TYPE $string,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

  * $string; the string to insert

### delete-from-cursor

The *delete-from-cursor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates a text deletion.

If the *type* is `GTK_DELETE_CHARS`, GTK+ deletes the selection if there is one, otherwise it deletes the requested number of characters.

The default bindings for this signal are Delete for deleting a character and Ctrl-Delete for deleting a word.

    method handler (
      - $type,
      - $count,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

  * $type; the granularity of the deletion, as a **Gnome::Gtk3::DeleteType**

  * $count; the number of *type* units to delete

### backspace

The *backspace* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user asks for it.

The default bindings for this signal are Backspace and Shift-Backspace.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

### cut-clipboard

The *cut-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are Ctrl-x and Shift-Delete.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

### copy-clipboard

The *copy-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are Ctrl-c and Ctrl-Insert.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

### paste-clipboard

The *paste-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to paste the contents of the clipboard into the text view.

The default bindings for this signal are Ctrl-v and Shift-Insert.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

### toggle-overwrite

The *toggle-overwrite* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to toggle the overwrite mode of the entry.

The default bindings for this signal is Insert.

    method handler (
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

### icon-press

The *icon-press* signal is emitted when an activatable icon is clicked.

Since: 2.16

    method handler (
      Unknown type GTK_TYPE_ENTRY_ICON_POSITION $icon_pos,
      Unknown type GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $event,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; The entry on which the signal is emitted

  * $icon_pos; The position of the clicked icon

  * $event; (type **Gnome::Gdk3::.EventButton**): the button press event

### icon-release

The *icon-release* signal is emitted on the button release from a mouse click over an activatable icon.

Since: 2.16

    method handler (
      Str $icon_pos,
      - $event,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; The entry on which the signal is emitted

  * $icon_pos; The position of the clicked icon

  * $event; (type **Gnome::Gdk3::.EventButton**): the button release event

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Cursor Position

The **Gnome::GObject::Value** type of property *cursor-position* is `G_TYPE_INT`.

### Selection Bound

The **Gnome::GObject::Value** type of property *selection-bound* is `G_TYPE_INT`.

### Editable

Whether the entry contents can be edited Default value: True

The **Gnome::GObject::Value** type of property *editable* is `G_TYPE_BOOLEAN`.

### Maximum length

The **Gnome::GObject::Value** type of property *max-length* is `G_TYPE_INT`.

### Visibility

FALSE displays the \invisible char\ instead of the actual text (password mode) Default value: True

The **Gnome::GObject::Value** type of property *visibility* is `G_TYPE_BOOLEAN`.

### Has Frame

FALSE removes outside bevel from entry Default value: True

The **Gnome::GObject::Value** type of property *has-frame* is `G_TYPE_BOOLEAN`.

### Invisible character

The **Gnome::GObject::Value** type of property *invisible-char* is `G_TYPE_UNICHAR`.

### Activates default

Whether to activate the default widget (such as the default button in a dialog when Enter is pressed) Default value: False

The **Gnome::GObject::Value** type of property *activates-default* is `G_TYPE_BOOLEAN`.

### Width in chars

The **Gnome::GObject::Value** type of property *width-chars* is `G_TYPE_INT`.

### Maximum width in characters

The desired maximum width of the entry, in characters. If this property is set to -1, the width will be calculated automatically. Since: 3.12

The **Gnome::GObject::Value** type of property *max-width-chars* is `G_TYPE_INT`.

### Scroll offset

The **Gnome::GObject::Value** type of property *scroll-offset* is `G_TYPE_INT`.

### Text

The contents of the entry Default value:

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### X align

The horizontal alignment, from 0 (left) to 1 (right). Reversed for RTL layouts. Since: 2.4

The **Gnome::GObject::Value** type of property *xalign* is `G_TYPE_FLOAT`.

### Truncate multiline

When `1`, pasted multi-line text is truncated to the first line. Since: 2.10

The **Gnome::GObject::Value** type of property *truncate-multiline* is `G_TYPE_BOOLEAN`.

### Overwrite mode

If text is overwritten when typing in the **Gnome::Gtk3::Entry**. Since: 2.14

The **Gnome::GObject::Value** type of property *overwrite-mode* is `G_TYPE_BOOLEAN`.

### Text length

The length of the text in the **Gnome::Gtk3::Entry**. Since: 2.14

The **Gnome::GObject::Value** type of property *text-length* is `G_TYPE_UINT`.

### Invisible character set

Whether the invisible char has been set for the **Gnome::Gtk3::Entry**. Since: 2.16

The **Gnome::GObject::Value** type of property *invisible-char-set* is `G_TYPE_BOOLEAN`.

### Caps Lock warning

Whether password entries will show a warning when Caps Lock is on. Note that the warning is shown using a secondary icon, and thus does not work if you are using the secondary icon position for some other purpose. Since: 2.16

The **Gnome::GObject::Value** type of property *caps-lock-warning* is `G_TYPE_BOOLEAN`.

### Progress Fraction

The current fraction of the task that's been completed. Since: 2.16

The **Gnome::GObject::Value** type of property *progress-fraction* is `G_TYPE_DOUBLE`.

### Progress Pulse Step

The fraction of total entry width to move the progress bouncing block for each call to `gtk_entry_progress_pulse()`. Since: 2.16

The **Gnome::GObject::Value** type of property *progress-pulse-step* is `G_TYPE_DOUBLE`.

### Placeholder text

The text that will be displayed in the **Gnome::Gtk3::Entry** when it is empty and unfocused. Since: 3.2

The **Gnome::GObject::Value** type of property *placeholder-text* is `G_TYPE_STRING`.

### Primary icon name

The icon name to use for the primary icon for the entry. Since: 2.16

The **Gnome::GObject::Value** type of property *primary-icon-name* is `G_TYPE_STRING`.

### Secondary icon name

The icon name to use for the secondary icon for the entry. Since: 2.16

The **Gnome::GObject::Value** type of property *secondary-icon-name* is `G_TYPE_STRING`.

### Primary storage type

The representation which is used for the primary icon of the entry. Since: 2.16 Widget type: GTK_TYPE_IMAGE_TYPE

The **Gnome::GObject::Value** type of property *primary-icon-storage-type* is `G_TYPE_ENUM`.

### Secondary storage type

The representation which is used for the secondary icon of the entry. Since: 2.16 Widget type: GTK_TYPE_IMAGE_TYPE

The **Gnome::GObject::Value** type of property *secondary-icon-storage-type* is `G_TYPE_ENUM`.

### Primary icon activatable

Whether the primary icon is activatable. GTK+ emits the *icon-press* and *icon-release* signals only on sensitive, activatable icons. Sensitive, but non-activatable icons can be used for purely informational purposes. Since: 2.16

The **Gnome::GObject::Value** type of property *primary-icon-activatable* is `G_TYPE_BOOLEAN`.

### Secondary icon activatable

Whether the secondary icon is activatable. GTK+ emits the *icon-press* and *icon-release* signals only on sensitive, activatable icons. Sensitive, but non-activatable icons can be used for purely informational purposes. Since: 2.16

The **Gnome::GObject::Value** type of property *secondary-icon-activatable* is `G_TYPE_BOOLEAN`.

### Primary icon sensitive

Whether the primary icon is sensitive. An insensitive icon appears grayed out. GTK+ does not emit the *icon-press* and *icon-release* signals and does not allow DND from insensitive icons. An icon should be set insensitive if the action that would trigger when clicked is currently not available. Since: 2.16

The **Gnome::GObject::Value** type of property *primary-icon-sensitive* is `G_TYPE_BOOLEAN`.

### Secondary icon sensitive

Whether the secondary icon is sensitive. An insensitive icon appears grayed out. GTK+ does not emit the *icon-press* and *icon-release* signals and does not allow DND from insensitive icons. An icon should be set insensitive if the action that would trigger when clicked is currently not available. Since: 2.16

The **Gnome::GObject::Value** type of property *secondary-icon-sensitive* is `G_TYPE_BOOLEAN`.

### Primary icon tooltip text

The contents of the tooltip on the primary icon. Also see `gtk_entry_set_icon_tooltip_text()`. Since: 2.16

The **Gnome::GObject::Value** type of property *primary-icon-tooltip-text* is `G_TYPE_STRING`.

### Secondary icon tooltip text

The contents of the tooltip on the secondary icon. Also see `gtk_entry_set_icon_tooltip_text()`. Since: 2.16

The **Gnome::GObject::Value** type of property *secondary-icon-tooltip-text* is `G_TYPE_STRING`.

### Primary icon tooltip markup

The contents of the tooltip on the primary icon, which is marked up with the [Pango text markup language][PangoMarkupFormat]. Also see `gtk_entry_set_icon_tooltip_markup()`. Since: 2.16

The **Gnome::GObject::Value** type of property *primary-icon-tooltip-markup* is `G_TYPE_STRING`.

### Secondary icon tooltip markup

The contents of the tooltip on the secondary icon, which is marked up with the [Pango text markup language][PangoMarkupFormat]. Also see `gtk_entry_set_icon_tooltip_markup()`. Since: 2.16

The **Gnome::GObject::Value** type of property *secondary-icon-tooltip-markup* is `G_TYPE_STRING`.

### IM module

Which IM (input method) module should be used for this entry. See **Gnome::Gtk3::IMContext**. Setting this to a non-`Any` value overrides the system-wide IM module setting. See the **Gnome::Gtk3::Settings** *gtk-im-module* property. Since: 2.16

The **Gnome::GObject::Value** type of property *im-module* is `G_TYPE_STRING`.

### Purpose

The purpose of this text field. This property can be used by on-screen keyboards and other input methods to adjust their behaviour. Note that setting the purpose to `GTK_INPUT_PURPOSE_PASSWORD` or `GTK_INPUT_PURPOSE_PIN` is independent from setting *visibility*. Since: 3.6 Widget type: GTK_TYPE_INPUT_PURPOSE

The **Gnome::GObject::Value** type of property *input-purpose* is `G_TYPE_ENUM`.

### hints

Additional hints (beyond *input-purpose*) that allow input methods to fine-tune their behaviour. Since: 3.6

The **Gnome::GObject::Value** type of property *input-hints* is `G_TYPE_FLAGS`.

### Populate all

If *populate-all* is `1`, the *populate-popup* signal is also emitted for touch popups. Since: 3.8

The **Gnome::GObject::Value** type of property *populate-all* is `G_TYPE_BOOLEAN`.

