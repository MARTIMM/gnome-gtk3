Gnome::Gtk3::TextView
=====================

Widget that displays a **Gnome::Gtk3::TextBuffer**

![](images/multiline-text.png)

Description
===========

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Css Nodes
---------

    textview.view
    ├── border.top
    ├── border.left
    ├── text
    │   ╰── [selection]
    ├── border.right
    ├── border.bottom
    ╰── [window.popup]

**Gnome::Gtk3::TextView** has a main css node with name textview and style class .view, and subnodes for each of the border windows, and the main text area, with names border and text, respectively. The border nodes each get one of the style classes .left, .right, .top or .bottom.

A node representing the selection will appear below the text node.

If a context menu is opened, the window node will appear as a subnode of the main node.

Implemented Interfaces
----------------------

Gnome::Gtk3::TextView implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

  * Gnome::Gtk3::Scrollable

See Also
--------

**Gnome::Gtk3::TextBuffer**, **Gnome::Gtk3::TextIter**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TextView;
    also is Gnome::Gtk3::Container;
    also does Gnome::Gtk3::Buildable;

Types
=====

enum GtkTextWindowType
----------------------

Used to reference the parts of **Gnome::Gtk3::TextView**.

  * GTK_TEXT_WINDOW_PRIVATE: Invalid value, used as a marker

  * GTK_TEXT_WINDOW_WIDGET: Window that floats over scrolling areas.

  * GTK_TEXT_WINDOW_TEXT: Scrollable text window.

  * GTK_TEXT_WINDOW_LEFT: Left side border window.

  * GTK_TEXT_WINDOW_RIGHT: Right side border window.

  * GTK_TEXT_WINDOW_TOP: Top border window.

  * GTK_TEXT_WINDOW_BOTTOM: Bottom border window.

enum GtkTextViewLayer
---------------------

Used to reference the layers of **Gnome::Gtk3::TextView** for the purpose of customized drawing with the sig *draw_layer* vfunc.

  * GTK_TEXT_VIEW_LAYER_BELOW: Old deprecated layer, use `GTK_TEXT_VIEW_LAYER_BELOW_TEXT` instead

  * GTK_TEXT_VIEW_LAYER_ABOVE: Old deprecated layer, use `GTK_TEXT_VIEW_LAYER_ABOVE_TEXT` instead

  * GTK_TEXT_VIEW_LAYER_BELOW_TEXT: The layer rendered below the text (but above the background). Since: 3.20

  * GTK_TEXT_VIEW_LAYER_ABOVE_TEXT: The layer rendered above the text. Since: 3.20

enum GtkTextExtendSelection
---------------------------

Granularity types that extend the text selection. Use the sig `extend-selection` signal to customize the selection.

Since: 3.16

  * GTK_TEXT_EXTEND_SELECTION_WORD: Selects the current word. It is triggered by a double-click for example.

  * GTK_TEXT_EXTEND_SELECTION_LINE: Selects the current line. It is triggered by a triple-click for example.

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

[gtk_] text_view_new
--------------------

Creates a new **Gnome::Gtk3::TextView**. If you don’t call `gtk_text_view_set_buffer()` before using the text view, an empty default buffer will be created for you. Get the buffer with `gtk_text_view_get_buffer()`. If you want to specify your own buffer, consider `gtk_text_view_new_with_buffer()`.

Returns: a new **Gnome::Gtk3::TextView**

    method gtk_text_view_new ( --> N-GObject  )

[[gtk_] text_view_] new_with_buffer
-----------------------------------

Creates a new **Gnome::Gtk3::TextView** widget displaying the buffer *buffer*. One buffer can be shared among many widgets. *buffer* may be `Any` to create a default buffer, in which case this function is equivalent to `gtk_text_view_new()`. The text view adds its own reference count to the buffer; it does not take over an existing reference.

Returns: a new **Gnome::Gtk3::TextView**.

    method gtk_text_view_new_with_buffer ( N-GObject $buffer --> N-GObject  )

  * N-GObject $buffer; a **Gnome::Gtk3::TextBuffer**

[[gtk_] text_view_] set_buffer
------------------------------

Sets *buffer* as the buffer being displayed by *text_view*. The previous buffer displayed by the text view is unreferenced, and a reference is added to *buffer*. If you owned a reference to *buffer* before passing it to this function, you must remove that reference yourself; **Gnome::Gtk3::TextView** will not “adopt” it.

    method gtk_text_view_set_buffer ( N-GObject $buffer )

  * N-GObject $buffer; (allow-none): a **Gnome::Gtk3::TextBuffer**

[[gtk_] text_view_] get_buffer
------------------------------

Returns the **Gnome::Gtk3::TextBuffer** being displayed by this text view. The reference count on the buffer is not incremented; the caller of this function won’t own a new reference.

Returns: (transfer none): a **Gnome::Gtk3::TextBuffer**

    method gtk_text_view_get_buffer ( --> N-GObject  )

[[gtk_] text_view_] scroll_to_iter
----------------------------------

Scrolls *text_view* so that *iter* is on the screen in the position indicated by *xalign* and *yalign*. An alignment of 0.0 indicates left or top, 1.0 indicates right or bottom, 0.5 means center. If *use_align* is `0`, the text scrolls the minimal distance to get the mark onscreen, possibly not scrolling at all. The effective screen for purposes of this function is reduced by a margin of size *within_margin*.

Note that this function uses the currently-computed height of the lines in the text buffer. Line heights are computed in an idle handler; so this function may not have the desired effect if it’s called before the height computations. To avoid oddness, consider using `gtk_text_view_scroll_to_mark()` which saves a point to be scrolled to after line validation.

Returns: `1` if scrolling occurred

    method gtk_text_view_scroll_to_iter ( N-GObject $iter, Num $within_margin, Int $use_align, Num $xalign, Num $yalign --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

  * Num $within_margin; margin as a [0.0,0.5) fraction of screen size

  * Int $use_align; whether to use alignment arguments (if `0`, just get the mark onscreen)

  * Num $xalign; horizontal alignment of mark within visible area

  * Num $yalign; vertical alignment of mark within visible area

[[gtk_] text_view_] scroll_to_mark
----------------------------------

Scrolls *text_view* so that *mark* is on the screen in the position indicated by *xalign* and *yalign*. An alignment of 0.0 indicates left or top, 1.0 indicates right or bottom, 0.5 means center. If *use_align* is `0`, the text scrolls the minimal distance to get the mark onscreen, possibly not scrolling at all. The effective screen for purposes of this function is reduced by a margin of size *within_margin*.

    method gtk_text_view_scroll_to_mark ( N-GObject $mark, Num $within_margin, Int $use_align, Num $xalign, Num $yalign )

  * N-GObject $mark; a **Gnome::Gtk3::TextMark**

  * Num $within_margin; margin as a [0.0,0.5) fraction of screen size

  * Int $use_align; whether to use alignment arguments (if `0`, just get the mark onscreen)

  * Num $xalign; horizontal alignment of mark within visible area

  * Num $yalign; vertical alignment of mark within visible area

[[gtk_] text_view_] scroll_mark_onscreen
----------------------------------------

Scrolls *text_view* the minimum distance such that *mark* is contained within the visible area of the widget.

    method gtk_text_view_scroll_mark_onscreen ( N-GObject $mark )

  * N-GObject $mark; a mark in the buffer for *text_view*

[[gtk_] text_view_] move_mark_onscreen
--------------------------------------

Moves a mark within the buffer so that it's located within the currently-visible text area.

Returns: `1` if the mark moved (wasn’t already onscreen)

    method gtk_text_view_move_mark_onscreen ( N-GObject $mark --> Int  )

  * N-GObject $mark; a **Gnome::Gtk3::TextMark**

[[gtk_] text_view_] place_cursor_onscreen
-----------------------------------------

Moves the cursor to the currently visible region of the buffer, it it isn’t there already.

Returns: `1` if the cursor had to be moved.

    method gtk_text_view_place_cursor_onscreen ( --> Int  )

[[gtk_] text_view_] get_visible_rect
------------------------------------

Fills *visible_rect* with the currently-visible region of the buffer, in buffer coordinates. Convert to window coordinates with `gtk_text_view_buffer_to_window_coords()`.

    method gtk_text_view_get_visible_rect ( N-GObject $visible_rect )

  * N-GObject $visible_rect; (out): rectangle to fill

[[gtk_] text_view_] set_cursor_visible
--------------------------------------

Toggles whether the insertion point should be displayed. A buffer with no editable text probably shouldn’t have a visible cursor, so you may want to turn the cursor off.

Note that this property may be overridden by the *gtk-keynave-use-caret* settings.

    method gtk_text_view_set_cursor_visible ( Int $setting )

  * Int $setting; whether to show the insertion cursor

[[gtk_] text_view_] get_cursor_visible
--------------------------------------

Find out whether the cursor should be displayed.

Returns: whether the insertion mark is visible

    method gtk_text_view_get_cursor_visible ( --> Int  )

[[gtk_] text_view_] reset_cursor_blink
--------------------------------------

Ensures that the cursor is shown (i.e. not in an 'off' blink interval) and resets the time that it will stay blinking (or visible, in case blinking is disabled).

This function should be called in response to user input (e.g. from derived classes that override the textview's *key-press-event* handler).

Since: 3.20

    method gtk_text_view_reset_cursor_blink ( )

[[gtk_] text_view_] get_cursor_locations
----------------------------------------

Given an *iter* within a text layout, determine the positions of the strong and weak cursors if the insertion point is at that iterator. The position of each cursor is stored as a zero-width rectangle. The strong cursor location is the location where characters of the directionality equal to the base direction of the paragraph are inserted. The weak cursor location is the location where characters of the directionality opposite to the base direction of the paragraph are inserted.

If *iter* is `Any`, the actual cursor position is used.

Note that if *iter* happens to be the actual cursor position, and there is currently an IM preedit sequence being entered, the returned locations will be adjusted to account for the preedit cursor’s offset within the preedit sequence.

The rectangle position is in buffer coordinates; use `gtk_text_view_buffer_to_window_coords()` to convert these coordinates to coordinates for one of the windows in the text view.

Since: 3.0

    method gtk_text_view_get_cursor_locations ( N-GObject $iter, N-GObject $strong, N-GObject $weak )

  * N-GObject $iter; (allow-none): a **Gnome::Gtk3::TextIter**

  * N-GObject $strong; (out) (allow-none): location to store the strong cursor position (may be `Any`)

  * N-GObject $weak; (out) (allow-none): location to store the weak cursor position (may be `Any`)

[[gtk_] text_view_] get_iter_location
-------------------------------------

Gets a rectangle which roughly contains the character at *iter*. The rectangle position is in buffer coordinates; use `gtk_text_view_buffer_to_window_coords()` to convert these coordinates to coordinates for one of the windows in the text view.

    method gtk_text_view_get_iter_location ( N-GObject $iter, N-GObject $location )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

  * N-GObject $location; (out): bounds of the character at *iter*

[[gtk_] text_view_] get_iter_at_location
----------------------------------------

Retrieves the iterator at buffer coordinates *x* and *y*. Buffer coordinates are coordinates for the entire buffer, not just the currently-displayed portion. If you have coordinates from an event, you have to convert those to buffer coordinates with `gtk_text_view_window_to_buffer_coords()`.

Returns: `1` if the position is over text

    method gtk_text_view_get_iter_at_location ( N-GObject $iter, Int $x, Int $y --> Int  )

  * N-GObject $iter; (out): a **Gnome::Gtk3::TextIter**

  * Int $x; x position, in buffer coordinates

  * Int $y; y position, in buffer coordinates

[[gtk_] text_view_] get_iter_at_position
----------------------------------------

Retrieves the iterator pointing to the character at buffer coordinates *x* and *y*. Buffer coordinates are coordinates for the entire buffer, not just the currently-displayed portion. If you have coordinates from an event, you have to convert those to buffer coordinates with `gtk_text_view_window_to_buffer_coords()`.

Note that this is different from `gtk_text_view_get_iter_at_location()`, which returns cursor locations, i.e. positions between characters.

Returns: `1` if the position is over text

Since: 2.6

    method gtk_text_view_get_iter_at_position ( N-GObject $iter, Int $trailing, Int $x, Int $y --> Int  )

  * N-GObject $iter; (out): a **Gnome::Gtk3::TextIter**

  * Int $trailing; (out) (allow-none): if non-`Any`, location to store an integer indicating where in the grapheme the user clicked. It will either be zero, or the number of characters in the grapheme. 0 represents the trailing edge of the grapheme.

  * Int $x; x position, in buffer coordinates

  * Int $y; y position, in buffer coordinates

[[gtk_] text_view_] get_line_yrange
-----------------------------------

Gets the y coordinate of the top of the line containing *iter*, and the height of the line. The coordinate is a buffer coordinate; convert to window coordinates with `gtk_text_view_buffer_to_window_coords()`.

    method gtk_text_view_get_line_yrange ( N-GObject $iter, Int $y, Int $height )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

  * Int $y; (out): return location for a y coordinate

  * Int $height; (out): return location for a height

[[gtk_] text_view_] get_line_at_y
---------------------------------

Gets the **Gnome::Gtk3::TextIter** at the start of the line containing the coordinate *y*. *y* is in buffer coordinates, convert from window coordinates with `gtk_text_view_window_to_buffer_coords()`. If non-`Any`, *line_top* will be filled with the coordinate of the top edge of the line.

    method gtk_text_view_get_line_at_y ( N-GObject $target_iter, Int $y, Int $line_top )

  * N-GObject $target_iter; (out): a **Gnome::Gtk3::TextIter**

  * Int $y; a y coordinate

  * Int $line_top; (out): return location for top coordinate of the line

[[gtk_] text_view_] buffer_to_window_coords
-------------------------------------------

Converts coordinate (*buffer_x*, *buffer_y*) to coordinates for the window *win*, and stores the result in (*window_x*, *window_y*).

Note that you can’t convert coordinates for a nonexisting window (see `gtk_text_view_set_border_window_size()`).

    method gtk_text_view_buffer_to_window_coords ( GtkTextWindowType $win, Int $buffer_x, Int $buffer_y, Int $window_x, Int $window_y )

  * GtkTextWindowType $win; a **Gnome::Gtk3::TextWindowType** except **GTK_TEXT_WINDOW_PRIVATE**

  * Int $buffer_x; buffer x coordinate

  * Int $buffer_y; buffer y coordinate

  * Int $window_x; (out) (allow-none): window x coordinate return location or `Any`

  * Int $window_y; (out) (allow-none): window y coordinate return location or `Any`

[[gtk_] text_view_] window_to_buffer_coords
-------------------------------------------

Converts coordinates on the window identified by *win* to buffer coordinates, storing the result in (*buffer_x*,*buffer_y*).

Note that you can’t convert coordinates for a nonexisting window (see `gtk_text_view_set_border_window_size()`).

    method gtk_text_view_window_to_buffer_coords ( GtkTextWindowType $win, Int $window_x, Int $window_y, Int $buffer_x, Int $buffer_y )

  * GtkTextWindowType $win; a **Gnome::Gtk3::TextWindowType** except **GTK_TEXT_WINDOW_PRIVATE**

  * Int $window_x; window x coordinate

  * Int $window_y; window y coordinate

  * Int $buffer_x; (out) (allow-none): buffer x coordinate return location or `Any`

  * Int $buffer_y; (out) (allow-none): buffer y coordinate return location or `Any`

[[gtk_] text_view_] get_window
------------------------------

Retrieves the **Gnome::Gdk3::Window** corresponding to an area of the text view; possible windows include the overall widget window, child windows on the left, right, top, bottom, and the window that displays the text buffer. Windows are `Any` and nonexistent if their width or height is 0, and are nonexistent before the widget has been realized.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::Window**, or `Any`

    method gtk_text_view_get_window ( GtkTextWindowType $win --> N-GObject  )

  * GtkTextWindowType $win; window to get

[[gtk_] text_view_] get_window_type
-----------------------------------

Usually used to find out which window an event corresponds to. If you connect to an event signal on *text_view*, this function should be called on `event->window` to see which window it was.

Returns: the window type.

    method gtk_text_view_get_window_type ( N-GObject $window --> GtkTextWindowType  )

  * N-GObject $window; a window type

[[gtk_] text_view_] set_border_window_size
------------------------------------------

Sets the width of `GTK_TEXT_WINDOW_LEFT` or `GTK_TEXT_WINDOW_RIGHT`, or the height of `GTK_TEXT_WINDOW_TOP` or `GTK_TEXT_WINDOW_BOTTOM`. Automatically destroys the corresponding window if the size is set to 0, and creates the window if the size is set to non-zero. This function can only be used for the “border windows,” it doesn’t work with **GTK_TEXT_WINDOW_WIDGET**, **GTK_TEXT_WINDOW_TEXT**, or **GTK_TEXT_WINDOW_PRIVATE**.

    method gtk_text_view_set_border_window_size ( GtkTextWindowType $type, Int $size )

  * GtkTextWindowType $type; window to affect

  * Int $size; width or height of the window

[[gtk_] text_view_] get_border_window_size
------------------------------------------

Gets the width of the specified border window. See `gtk_text_view_set_border_window_size()`.

Returns: width of window

    method gtk_text_view_get_border_window_size ( GtkTextWindowType $type --> Int  )

  * GtkTextWindowType $type; window to return size from

[[gtk_] text_view_] forward_display_line
----------------------------------------

Moves the given *iter* forward by one display (wrapped) line. A display line is different from a paragraph. Paragraphs are separated by newlines or other paragraph separator characters. Display lines are created by line-wrapping a paragraph. If wrapping is turned off, display lines and paragraphs will be the same. Display lines are divided differently for each view, since they depend on the view’s width; paragraphs are the same in all views, since they depend on the contents of the **Gnome::Gtk3::TextBuffer**.

Returns: `1` if *iter* was moved and is not on the end iterator

    method gtk_text_view_forward_display_line ( N-GObject $iter --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

[[gtk_] text_view_] backward_display_line
-----------------------------------------

Moves the given *iter* backward by one display (wrapped) line. A display line is different from a paragraph. Paragraphs are separated by newlines or other paragraph separator characters. Display lines are created by line-wrapping a paragraph. If wrapping is turned off, display lines and paragraphs will be the same. Display lines are divided differently for each view, since they depend on the view’s width; paragraphs are the same in all views, since they depend on the contents of the **Gnome::Gtk3::TextBuffer**.

Returns: `1` if *iter* was moved and is not on the end iterator

    method gtk_text_view_backward_display_line ( N-GObject $iter --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

[[gtk_] text_view_] forward_display_line_end
--------------------------------------------

Moves the given *iter* forward to the next display line end. A display line is different from a paragraph. Paragraphs are separated by newlines or other paragraph separator characters. Display lines are created by line-wrapping a paragraph. If wrapping is turned off, display lines and paragraphs will be the same. Display lines are divided differently for each view, since they depend on the view’s width; paragraphs are the same in all views, since they depend on the contents of the **Gnome::Gtk3::TextBuffer**.

Returns: `1` if *iter* was moved and is not on the end iterator

    method gtk_text_view_forward_display_line_end ( N-GObject $iter --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

[[gtk_] text_view_] backward_display_line_start
-----------------------------------------------

Moves the given *iter* backward to the next display line start. A display line is different from a paragraph. Paragraphs are separated by newlines or other paragraph separator characters. Display lines are created by line-wrapping a paragraph. If wrapping is turned off, display lines and paragraphs will be the same. Display lines are divided differently for each view, since they depend on the view’s width; paragraphs are the same in all views, since they depend on the contents of the **Gnome::Gtk3::TextBuffer**.

Returns: `1` if *iter* was moved and is not on the end iterator

    method gtk_text_view_backward_display_line_start ( N-GObject $iter --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

[[gtk_] text_view_] starts_display_line
---------------------------------------

Determines whether *iter* is at the start of a display line. See `gtk_text_view_forward_display_line()` for an explanation of display lines vs. paragraphs.

Returns: `1` if *iter* begins a wrapped line

    method gtk_text_view_starts_display_line ( N-GObject $iter --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

[[gtk_] text_view_] move_visually
---------------------------------

Move the iterator a given number of characters visually, treating it as the strong cursor position. If *count* is positive, then the new strong cursor position will be *count* positions to the right of the old cursor position. If *count* is negative then the new strong cursor position will be *count* positions to the left of the old cursor position.

In the presence of bi-directional text, the correspondence between logical and visual order will depend on the direction of the current run, and there may be jumps when the cursor is moved off of the end of a run.

Returns: `1` if *iter* moved and is not on the end iterator

    method gtk_text_view_move_visually ( N-GObject $iter, Int $count --> Int  )

  * N-GObject $iter; a **Gnome::Gtk3::TextIter**

  * Int $count; number of characters to move (negative moves left, positive moves right)

[[gtk_] text_view_] im_context_filter_keypress
----------------------------------------------

Allow the **Gnome::Gtk3::TextView** input method to internally handle key press and release events. If this function returns `1`, then no further processing should be done for this key event. See `gtk_im_context_filter_keypress()`.

Note that you are expected to call this function from your handler when overriding key event handling. This is needed in the case when you need to insert your own key handling between the input method and the default key event handling of the **Gnome::Gtk3::TextView**.

|[<!-- language="C" --> static gboolean gtk_foo_bar_key_press_event (**Gnome::Gtk3::Widget** *widget, **Gnome::Gdk3::EventKey** *event) { if ((key->keyval == GDK_KEY_Return || key->keyval == GDK_KEY_KP_Enter)) { if (gtk_text_view_im_context_filter_keypress (GTK_TEXT_VIEW (view), event)) return TRUE; }

// Do some stuff

return GTK_WIDGET_CLASS (gtk_foo_bar_parent_class)->key_press_event (widget, event); } ]|

Returns: `1` if the input method handled the key event.

Since: 2.22

    method gtk_text_view_im_context_filter_keypress ( GdkEventKey $event --> Int  )

  * GdkEventKey $event; the key event

[[gtk_] text_view_] reset_im_context
------------------------------------

Reset the input method context of the text view if needed.

This can be necessary in the case where modifying the buffer would confuse on-going input method behavior.

Since: 2.22

    method gtk_text_view_reset_im_context ( )

[[gtk_] text_view_] add_child_in_window
---------------------------------------

Adds a child at fixed coordinates in one of the text widget's windows.

The window must have nonzero size (see `gtk_text_view_set_border_window_size()`). Note that the child coordinates are given relative to scrolling. When placing a child in `GTK_TEXT_WINDOW_WIDGET`, scrolling is irrelevant, the child floats above all scrollable areas. But when placing a child in one of the scrollable windows (border windows or text window) it will move with the scrolling as needed.

    method gtk_text_view_add_child_in_window (
      N-GObject $child, GtkTextWindowType $which_window, Int $xpos, Int $ypos
    )

  * N-GObject $child; a **Gnome::Gtk3::Widget**

  * GtkTextWindowType $which_window; which window the child should appear in

  * Int $xpos; X position of child in window coordinates

  * Int $ypos; Y position of child in window coordinates

[[gtk_] text_view_] move_child
------------------------------

Updates the position of a child, as for `gtk_text_view_add_child_in_window()`.

    method gtk_text_view_move_child ( N-GObject $child,  Int $xpos, Int $ypos )

  * N-GObject $child; child widget already added to the text view

  * Int $xpos; new X position in window coordinates

  * Int $ypos; new Y position in window coordinates

[[gtk_] text_view_] set_wrap_mode
---------------------------------

Sets the line wrapping for the view.

    method gtk_text_view_set_wrap_mode ( GtkWrapMode $wrap_mode )

  * GtkWrapMode $wrap_mode; a **Gnome::Gtk3::WrapMode**

[[gtk_] text_view_] get_wrap_mode
---------------------------------

Gets the line wrapping for the view.

Returns: the line wrap setting

    method gtk_text_view_get_wrap_mode ( --> GtkWrapMode  )

[[gtk_] text_view_] set_editable
--------------------------------

Sets the default editability of the **Gnome::Gtk3::TextView**. You can override this default setting with tags in the buffer, using the “editable” attribute of tags.

    method gtk_text_view_set_editable ( Int $setting )

  * Int $setting; whether it’s editable

[[gtk_] text_view_] get_editable
--------------------------------

Returns the default editability of the **Gnome::Gtk3::TextView**. Tags in the buffer may override this setting for some ranges of text.

Returns: whether text is editable by default

    method gtk_text_view_get_editable ( --> Int  )

[[gtk_] text_view_] set_overwrite
---------------------------------

Changes the **Gnome::Gtk3::TextView** overwrite mode.

Since: 2.4

    method gtk_text_view_set_overwrite ( Int $overwrite )

  * Int $overwrite; `1` to turn on overwrite mode, `0` to turn it off

[[gtk_] text_view_] get_overwrite
---------------------------------

Returns whether the **Gnome::Gtk3::TextView** is in overwrite mode or not.

Returns: whether *text_view* is in overwrite mode or not.

Since: 2.4

    method gtk_text_view_get_overwrite ( --> Int  )

[[gtk_] text_view_] set_accepts_tab
-----------------------------------

Sets the behavior of the text widget when the Tab key is pressed. If *accepts_tab* is `1`, a tab character is inserted. If *accepts_tab* is `0` the keyboard focus is moved to the next widget in the focus chain.

Since: 2.4

    method gtk_text_view_set_accepts_tab ( Int $accepts_tab )

  * Int $accepts_tab; `1` if pressing the Tab key should insert a tab character, `0`, if pressing the Tab key should move the keyboard focus.

[[gtk_] text_view_] get_accepts_tab
-----------------------------------

Returns whether pressing the Tab key inserts a tab characters. `gtk_text_view_set_accepts_tab()`.

Returns: `1` if pressing the Tab key inserts a tab character, `0` if pressing the Tab key moves the keyboard focus.

Since: 2.4

    method gtk_text_view_get_accepts_tab ( --> Int  )

[[gtk_] text_view_] set_pixels_above_lines
------------------------------------------

Sets the default number of blank pixels above paragraphs in *text_view*. Tags in the buffer for *text_view* may override the defaults.

    method gtk_text_view_set_pixels_above_lines ( Int $pixels_above_lines )

  * Int $pixels_above_lines; pixels above paragraphs

[[gtk_] text_view_] get_pixels_above_lines
------------------------------------------

Gets the default number of pixels to put above paragraphs. Adding this function with `gtk_text_view_get_pixels_below_lines()` is equal to the line space between each paragraph.

Returns: default number of pixels above paragraphs

    method gtk_text_view_get_pixels_above_lines ( --> Int  )

[[gtk_] text_view_] set_pixels_below_lines
------------------------------------------

Sets the default number of pixels of blank space to put below paragraphs in *text_view*. May be overridden by tags applied to *text_view*’s buffer.

    method gtk_text_view_set_pixels_below_lines ( Int $pixels_below_lines )

  * Int $pixels_below_lines; pixels below paragraphs

[[gtk_] text_view_] get_pixels_below_lines
------------------------------------------

Gets the value set by `gtk_text_view_set_pixels_below_lines()`.

The line space is the sum of the value returned by this function and the value returned by `gtk_text_view_get_pixels_above_lines()`.

Returns: default number of blank pixels below paragraphs

    method gtk_text_view_get_pixels_below_lines ( --> Int  )

[[gtk_] text_view_] set_pixels_inside_wrap
------------------------------------------

Sets the default number of pixels of blank space to leave between display/wrapped lines within a paragraph. May be overridden by tags in *text_view*’s buffer.

    method gtk_text_view_set_pixels_inside_wrap ( Int $pixels_inside_wrap )

  * Int $pixels_inside_wrap; default number of pixels between wrapped lines

[[gtk_] text_view_] get_pixels_inside_wrap
------------------------------------------

Gets the value set by `gtk_text_view_set_pixels_inside_wrap()`.

Returns: default number of pixels of blank space between wrapped lines

    method gtk_text_view_get_pixels_inside_wrap ( --> Int  )

[[gtk_] text_view_] set_justification
-------------------------------------

Sets the default justification of text in *text_view*. Tags in the view’s buffer may override the default.

    method gtk_text_view_set_justification ( GtkJustification $justification )

  * GtkJustification $justification; justification

[[gtk_] text_view_] get_justification
-------------------------------------

Gets the default justification of paragraphs in *text_view*. Tags in the buffer may override the default.

Returns: default justification

    method gtk_text_view_get_justification ( --> GtkJustification  )

[[gtk_] text_view_] set_left_margin
-----------------------------------

Sets the default left margin for text in *text_view*. Tags in the buffer may override the default.

Note that this function is confusingly named. In CSS terms, the value set here is padding.

    method gtk_text_view_set_left_margin ( Int $left_margin )

  * Int $left_margin; left margin in pixels

[[gtk_] text_view_] get_left_margin
-----------------------------------

Gets the default left margin size of paragraphs in the *text_view*. Tags in the buffer may override the default.

Returns: left margin in pixels

    method gtk_text_view_get_left_margin ( --> Int  )

[[gtk_] text_view_] set_right_margin
------------------------------------

Sets the default right margin for text in the text view. Tags in the buffer may override the default.

Note that this function is confusingly named. In CSS terms, the value set here is padding.

    method gtk_text_view_set_right_margin ( Int $right_margin )

  * Int $right_margin; right margin in pixels

[[gtk_] text_view_] get_right_margin
------------------------------------

Gets the default right margin for text in *text_view*. Tags in the buffer may override the default.

Returns: right margin in pixels

    method gtk_text_view_get_right_margin ( --> Int  )

[[gtk_] text_view_] set_top_margin
----------------------------------

Sets the top margin for text in *text_view*.

Note that this function is confusingly named. In CSS terms, the value set here is padding.

Since: 3.18

    method gtk_text_view_set_top_margin ( Int $top_margin )

  * Int $top_margin; top margin in pixels

[[gtk_] text_view_] get_top_margin
----------------------------------

Gets the top margin for text in the *text_view*.

Returns: top margin in pixels

Since: 3.18

    method gtk_text_view_get_top_margin ( --> Int  )

[[gtk_] text_view_] set_bottom_margin
-------------------------------------

Sets the bottom margin for text in *text_view*.

Note that this function is confusingly named. In CSS terms, the value set here is padding.

Since: 3.18

    method gtk_text_view_set_bottom_margin ( Int $bottom_margin )

  * Int $bottom_margin; bottom margin in pixels

[[gtk_] text_view_] get_bottom_margin
-------------------------------------

Gets the bottom margin for text in the *text_view*.

Returns: bottom margin in pixels

Since: 3.18

    method gtk_text_view_get_bottom_margin ( --> Int  )

[[gtk_] text_view_] set_indent
------------------------------

Sets the default indentation for paragraphs in *text_view*. Tags in the buffer may override the default.

    method gtk_text_view_set_indent ( Int $indent )

  * Int $indent; indentation in pixels

[[gtk_] text_view_] get_indent
------------------------------

Gets the default indentation of paragraphs in *text_view*. Tags in the view’s buffer may override the default. The indentation may be negative.

Returns: number of pixels of indentation

    method gtk_text_view_get_indent ( --> Int  )

[[gtk_] text_view_] get_default_attributes
------------------------------------------

Obtains a copy of the default text attributes. These are the attributes used for text unless a tag overrides them. You’d typically pass the default attributes in to `gtk_text_iter_get_attributes()` in order to get the attributes in effect at a given text position.

The return value is a copy owned by the caller of this function, and should be freed with `gtk_text_attributes_unref()`.

Returns: a new **Gnome::Gtk3::TextAttributes**

    method gtk_text_view_get_default_attributes ( --> N-GObject  )

[[gtk_] text_view_] set_input_purpose
-------------------------------------

Sets the *input-purpose* property which can be used by on-screen keyboards and other input methods to adjust their behaviour.

Since: 3.6

    method gtk_text_view_set_input_purpose ( GtkInputPurpose $purpose )

  * GtkInputPurpose $purpose; the purpose

[[gtk_] text_view_] get_input_purpose
-------------------------------------

Gets the value of the *input-purpose* property.

Since: 3.6

    method gtk_text_view_get_input_purpose ( --> GtkInputPurpose  )

[[gtk_] text_view_] set_input_hints
-----------------------------------

Sets the *input-hints* property, which allows input methods to fine-tune their behaviour.

Since: 3.6

    method gtk_text_view_set_input_hints ( GtkInputHints $hints )

  * GtkInputHints $hints; the hints

[[gtk_] text_view_] get_input_hints
-----------------------------------

Gets the value of the *input-hints* property.

Since: 3.6

    method gtk_text_view_get_input_hints ( --> GtkInputHints  )

[[gtk_] text_view_] set_monospace
---------------------------------

Sets the *monospace* property, which indicates that the text view should use monospace fonts.

Since: 3.16

    method gtk_text_view_set_monospace ( Int $monospace )

  * Int $monospace; `1` to request monospace styling

[[gtk_] text_view_] get_monospace
---------------------------------

Gets the value of the *monospace* property.

Return: `1` if monospace fonts are desired

Since: 3.16

    method gtk_text_view_get_monospace ( --> Int  )

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

### move-cursor

Applications should not connect to it, but may emit it with `g_signal_emit_by_name()` if they need to control the cursor programmatically.

The default bindings for this signal come in two variants, the variant with the Shift modifier extends the selection, the variant without the Shift modifer does not. There are too many key combinations to list them all here. - Arrow keys move by individual characters/lines - Ctrl-arrow key combinations move by words/paragraphs - Home/End keys move to the ends of the buffer - PageUp/PageDown keys move vertically by pages - Ctrl-PageUp/PageDown keys move horizontally by pages

    method handler (
      Unknown type GTK_TYPE_MOVEMENT_STEP $step,
      Int $count,
      Int $extend_selection,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $step; the granularity of the move, as a **Gnome::Gtk3::MovementStep**

  * $count; the number of *step* units to move

  * $extend_selection; `1` if the move should extend the selection

### move-viewport

The *move-viewport* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which can be bound to key combinations to allow the user to move the viewport, i.e. change what part of the text view is visible in a containing scrolled window.

There are no default bindings for this signal.

    method handler (
      Unknown type GTK_TYPE_SCROLL_STEP $step,
      Int $count,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $step; the granularity of the movement, as a **Gnome::Gtk3::ScrollStep**

  * $count; the number of *step* units to move

### set-anchor

The *set-anchor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates setting the "anchor" mark. The "anchor" mark gets placed at the same position as the "insert" mark.

This signal has no default bindings.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### insert-at-cursor

The *insert-at-cursor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates the insertion of a fixed string at the cursor.

This signal has no default bindings.

    method handler (
      Str $string,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $string; the string to insert

### delete-from-cursor

The *delete-from-cursor* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates a text deletion.

If the *type* is `GTK_DELETE_CHARS`, GTK+ deletes the selection if there is one, otherwise it deletes the requested number of characters.

The default bindings for this signal are Delete for deleting a character, Ctrl-Delete for deleting a word and Ctrl-Backspace for deleting a word backwords.

    method handler (
      Unknown type GTK_TYPE_DELETE_TYPE $type,
      Int $count,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $type; the granularity of the deletion, as a **Gnome::Gtk3::DeleteType**

  * $count; the number of *type* units to delete

### backspace

The *backspace* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user asks for it.

The default bindings for this signal are Backspace and Shift-Backspace.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### cut-clipboard

The *cut-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are Ctrl-x and Shift-Delete.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### copy-clipboard

The *copy-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are Ctrl-c and Ctrl-Insert.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### paste-clipboard

The *paste-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to paste the contents of the clipboard into the text view.

The default bindings for this signal are Ctrl-v and Shift-Insert.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### toggle-overwrite

The *toggle-overwrite* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to toggle the overwrite mode of the text view.

The default bindings for this signal is Insert.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### populate-popup

The *populate-popup* signal gets emitted before showing the context menu of the text view.

If you need to add items to the context menu, connect to this signal and append your items to the *popup*, which will be a **Gnome::Gtk3::Menu** in this case.

If *populate-all* is `1`, this signal will also be emitted to populate touch popups. In this case, *popup* will be a different container, e.g. a **Gnome::Gtk3::Toolbar**.

The signal handler should not make assumptions about the type of *widget*, but check whether *popup* is a **Gnome::Gtk3::Menu** or **Gnome::Gtk3::Toolbar** or another kind of container.

    method handler (
      N-GObject $popup,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; The text view on which the signal is emitted

  * $popup; the container that is being populated

### select-all

The *select-all* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to select or unselect the complete contents of the text view.

The default bindings for this signal are Ctrl-a and Ctrl-/ for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.

    method handler (
      Int $select,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $select; `1` to select, `0` to unselect

### toggle-cursor-visible

The *toggle-cursor-visible* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to toggle the *cursor-visible* property.

The default binding for this signal is F7.

    method handler (
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

### preedit-changed

If an input method is used, the typed text will not immediately be committed to the buffer. So if you are interested in the text, connect to this signal.

This signal is only emitted if the text at the given position is actually editable.

Since: 2.20

    method handler (
      Str $preedit,
      Gnome::GObject::Object :widget($text_view),
      *%user-options
    );

  * $text_view; the object which received the signal

  * $preedit; the current preedit string

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Pixels Above Lines

The **Gnome::GObject::Value** type of property *pixels-above-lines* is `G_TYPE_INT`.

### Pixels Below Lines

The **Gnome::GObject::Value** type of property *pixels-below-lines* is `G_TYPE_INT`.

### Pixels Inside Wrap

The **Gnome::GObject::Value** type of property *pixels-inside-wrap* is `G_TYPE_INT`.

### Editable

Whether the text can be modified by the user Default value: True

The **Gnome::GObject::Value** type of property *editable* is `G_TYPE_BOOLEAN`.

### Wrap Mode

Whether to wrap lines never, at word boundaries_COMMA_ or at character boundaries Default value: False

The **Gnome::GObject::Value** type of property *wrap-mode* is `G_TYPE_ENUM`.

### Justification

Left, right_COMMA_ or center justification Default value: False

The **Gnome::GObject::Value** type of property *justification* is `G_TYPE_ENUM`.

### Left Margin

The default left margin for text in the text view. Tags in the buffer may override the default. Note that this property is confusingly named. In CSS terms, the value set here is padding, and it is applied in addition to the padding from the theme. Don't confuse this property with *margin-left*.

The **Gnome::GObject::Value** type of property *left-margin* is `G_TYPE_INT`.

### Right Margin

The default right margin for text in the text view. Tags in the buffer may override the default. Note that this property is confusingly named. In CSS terms, the value set here is padding, and it is applied in addition to the padding from the theme. Don't confuse this property with *margin-right*.

The **Gnome::GObject::Value** type of property *right-margin* is `G_TYPE_INT`.

### Top Margin

The top margin for text in the text view. Note that this property is confusingly named. In CSS terms, the value set here is padding, and it is applied in addition to the padding from the theme. Don't confuse this property with *margin-top*. Since: 3.18

The **Gnome::GObject::Value** type of property *top-margin* is `G_TYPE_INT`.

### Bottom Margin

The bottom margin for text in the text view. Note that this property is confusingly named. In CSS terms, the value set here is padding, and it is applied in addition to the padding from the theme. Don't confuse this property with *margin-bottom*. Since: 3.18

The **Gnome::GObject::Value** type of property *bottom-margin* is `G_TYPE_INT`.

### Indent

The **Gnome::GObject::Value** type of property *indent* is `G_TYPE_INT`.

### Tabs

The **Gnome::GObject::Value** type of property *tabs* is `G_TYPE_BOXED`.

### Cursor Visible

If the insertion cursor is shown Default value: True

The **Gnome::GObject::Value** type of property *cursor-visible* is `G_TYPE_BOOLEAN`.

### Buffer

The buffer which is displayed Widget type: GTK_TYPE_TEXT_BUFFER

The **Gnome::GObject::Value** type of property *buffer* is `G_TYPE_OBJECT`.

### Overwrite mode

Whether entered text overwrites existing contents Default value: False

The **Gnome::GObject::Value** type of property *overwrite* is `G_TYPE_BOOLEAN`.

### Accepts tab

Whether Tab will result in a tab character being entered Default value: True

The **Gnome::GObject::Value** type of property *accepts-tab* is `G_TYPE_BOOLEAN`.

### IM module

Which IM (input method) module should be used for this text_view. See **Gnome::Gtk3::IMContext**. Setting this to a non-`Any` value overrides the system-wide IM module setting. See the **Gnome::Gtk3::Settings** *gtk-im-module* property. Since: 2.16

The **Gnome::GObject::Value** type of property *im-module* is `G_TYPE_STRING`.

### Purpose

The purpose of this text field. This property can be used by on-screen keyboards and other input methods to adjust their behaviour. Since: 3.6 Widget type: GTK_TYPE_INPUT_PURPOSE

The **Gnome::GObject::Value** type of property *input-purpose* is `G_TYPE_ENUM`.

### hints

Additional hints (beyond *input-purpose*) that allow input methods to fine-tune their behaviour. Since: 3.6

The **Gnome::GObject::Value** type of property *input-hints* is `G_TYPE_FLAGS`.

### Populate all

If *populate-all* is `1`, the *populate-popup* signal is also emitted for touch popups. Since: 3.8

The **Gnome::GObject::Value** type of property *populate-all* is `G_TYPE_BOOLEAN`.

### Monospace

If `1`, set the `GTK_STYLE_CLASS_MONOSPACE` style class on the text view to indicate that a monospace font is desired. Since: 3.16

The **Gnome::GObject::Value** type of property *monospace* is `G_TYPE_BOOLEAN`.

