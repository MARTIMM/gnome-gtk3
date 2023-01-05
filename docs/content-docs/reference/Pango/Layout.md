Gnome::Pango::Layout
====================

High-level layout driver objects

Description
===========

While complete access to the layout capabilities of Pango is provided using the detailed interfaces for itemization and shaping, using that functionality directly involves writing a fairly large amount of code. The objects and functions in this section provide a high-level driver for formatting entire paragraphs of text at once.

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::Layout;
    also is Gnome::GObject::Object;

Types
=====

enum PangoAlignment
-------------------

A **PangoAlignment** describes how to align the lines of a **PangoLayout** within the available space. If the **PangoLayout** is set to justify using `pango_layout_set_justify()`, this only has effect for partial lines.

  * PANGO_ALIGN_LEFT: Put all available space on the right

  * PANGO_ALIGN_CENTER: Center the line within the available space

  * PANGO_ALIGN_RIGHT: Put all available space on the left

enum PangoWrapMode
------------------

A **PangoWrapMode** describes how to wrap the lines of a **PangoLayout** to the desired width.

  * PANGO_WRAP_WORD: wrap lines at word boundaries.

  * PANGO_WRAP_CHAR: wrap lines at character boundaries.

  * PANGO_WRAP_WORD_CHAR: wrap lines at word boundaries, but fall back to character boundaries if there is not enough space for a full word.

enum PangoEllipsizeMode
-----------------------

The **PangoEllipsizeMode** type describes what sort of (if any) ellipsization should be applied to a line of text. In the ellipsization process characters are removed from the text in order to make it fit to a given width and replaced with an ellipsis.

  * PANGO_ELLIPSIZE_NONE: No ellipsization

  * PANGO_ELLIPSIZE_START: Omit characters at the start of the text

  * PANGO_ELLIPSIZE_MIDDLE: Omit characters in the middle of the text

  * PANGO_ELLIPSIZE_END: Omit characters at the end of the text

class N-PangoLayoutLine
-----------------------

The **PangoLayoutLine** structure represents one of the lines resulting from laying out a paragraph via **PangoLayout**. **PangoLayoutLine** structures are obtained by calling `pango_layout_get_line()` and are only valid until the text, attributes, or settings of the parent **PangoLayout** are modified.

Routines for rendering PangoLayout objects are provided in code specific to each rendering system.

  * N-GObject $.layout: (allow-none): the layout this line belongs to, might be `Any`

  * ___start_index: start of line as byte index into layout->text

  * ___length: length of line in bytes

  * N-GSList $.runs: (allow-none) (element-type Pango.LayoutRun): list of runs in the line, from left to right

  * ___is_paragraph_start: **TRUE** if this is the first line of the paragraph

  * ___resolved_dir: **Resolved** PangoDirection of line

Methods
=======

new
---

Create a new default object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

pango_layout_new
----------------

Create a new **PangoLayout** object with attributes initialized to default values for a particular **PangoContext**.

Return value: the newly allocated **PangoLayout**, with a reference count of one, which should be freed with `g_object_unref()`.

    method pango_layout_new ( N-GObject $context --> N-GObject  )

  * N-GObject $context; a **PangoContext**

pango_layout_copy
-----------------

Does a deep copy-by-value of the *src* layout. The attribute list, tab array, and text from the original layout are all copied by value.

Return value: (transfer full): the newly allocated **PangoLayout**, with a reference count of one, which should be freed with `g_object_unref()`.

    method pango_layout_copy ( --> N-GObject  )

[pango_layout_] get_context
---------------------------

Retrieves the **PangoContext** used for this layout.

Return value: (transfer none): the **PangoContext** for the layout. This does not have an additional refcount added, so if you want to keep a copy of this around, you must reference it yourself.

    method pango_layout_get_context ( --> N-GObject  )

[pango_layout_] set_text
------------------------

Sets the text of the layout.

Note that if you have used `pango_layout_set_markup()` or `pango_layout_set_markup_with_accel()` on *layout* before, you may want to call `pango_layout_set_attributes()` to clear the attributes set on the layout from the markup as this function does not clear attributes.

    method pango_layout_set_text ( Str $text, Int $length )

  * Str $text; a valid UTF-8 string

  * Int $length; maximum length of *text*, in bytes. -1 indicates that the string is nul-terminated and the length should be calculated. The text will also be truncated on encountering a nul-termination even when *length* is positive.

[pango_layout_] get_text
------------------------

Gets the text in the layout. The returned text should not be freed or modified.

Return value: the text in the *layout*.

    method pango_layout_get_text ( --> Str  )

[pango_layout_] get_character_count
-----------------------------------

Returns the number of Unicode characters in the the text of *layout*.

Return value: the number of Unicode characters in the text of *layout*

Since: 1.30

    method pango_layout_get_character_count ( --> Int  )

[pango_layout_] set_markup
--------------------------

Same as `pango_layout_set_markup_with_accel()`, but the markup text isn't scanned for accelerators.

    method pango_layout_set_markup ( Str $markup, Int $length )

  * Str $markup; marked-up text

  * Int $length; length of marked-up text in bytes, or -1 if *markup* is null-terminated

[pango_layout_] set_width
-------------------------

Sets the width to which the lines of the **PangoLayout** should wrap or ellipsized. The default value is -1: no width set.

    method pango_layout_set_width ( Int $width )

  * Int $width; the desired width in Pango units, or -1 to indicate that no wrapping or ellipsization should be performed.

[pango_layout_] get_width
-------------------------

Gets the width to which the lines of the **PangoLayout** should wrap.

Return value: the width in Pango units, or -1 if no width set.

    method pango_layout_get_width ( --> Int  )

[pango_layout_] set_height
--------------------------

Sets the height to which the **PangoLayout** should be ellipsized at. There are two different behaviors, based on whether *height* is positive or negative.

If *height* is positive, it will be the maximum height of the layout. Only lines would be shown that would fit, and if there is any text omitted, an ellipsis added. At least one line is included in each paragraph regardless of how small the height value is. A value of zero will render exactly one line for the entire layout.

If *height* is negative, it will be the (negative of) maximum number of lines per paragraph. That is, the total number of lines shown may well be more than this value if the layout contains multiple paragraphs of text. The default value of -1 means that first line of each paragraph is ellipsized. This behvaior may be changed in the future to act per layout instead of per paragraph. File a bug against pango at <ulink url="http://bugzilla.gnome.org/">http://bugzilla.gnome.org/</ulink> if your code relies on this behavior.

Height setting only has effect if a positive width is set on *layout* and ellipsization mode of *layout* is not `PANGO_ELLIPSIZE_NONE`. The behavior is undefined if a height other than -1 is set and ellipsization mode is set to `PANGO_ELLIPSIZE_NONE`, and may change in the future.

Since: 1.20

    method pango_layout_set_height ( Int $height )

  * Int $height; the desired height of the layout in Pango units if positive, or desired number of lines if negative.

[pango_layout_] get_height
--------------------------

Gets the height of layout used for ellipsization. See `pango_layout_set_height()` for details.

Return value: the height, in Pango units if positive, or number of lines if negative.

Since: 1.20

    method pango_layout_get_height ( --> Int  )

[pango_layout_] set_wrap
------------------------

Sets the wrap mode; the wrap mode only has effect if a width is set on the layout with `pango_layout_set_width()`. To turn off wrapping, set the width to -1.

    method pango_layout_set_wrap ( PangoWrapMode $wrap )

  * PangoWrapMode $wrap; the wrap mode

[pango_layout_] get_wrap
------------------------

Gets the wrap mode for the layout.

Use `pango_layout_is_wrapped()` to query whether any paragraphs were actually wrapped.

Return value: active wrap mode.

    method pango_layout_get_wrap ( --> PangoWrapMode  )

[pango_layout_] is_wrapped
--------------------------

Queries whether the layout had to wrap any paragraphs.

This returns `1` if a positive width is set on *layout*, ellipsization mode of *layout* is set to `PANGO_ELLIPSIZE_NONE`, and there are paragraphs exceeding the layout width that have to be wrapped.

Return value: `1` if any paragraphs had to be wrapped, `0` otherwise.

Since: 1.16

    method pango_layout_is_wrapped ( --> Int  )

[pango_layout_] set_indent
--------------------------

Sets the width in Pango units to indent each paragraph. A negative value of *indent* will produce a hanging indentation. That is, the first line will have the full width, and subsequent lines will be indented by the absolute value of *indent*.

The indent setting is ignored if layout alignment is set to `PANGO_ALIGN_CENTER`.

    method pango_layout_set_indent ( Int $indent )

  * Int $indent; the amount by which to indent.

[pango_layout_] get_indent
--------------------------

Gets the paragraph indent width in Pango units. A negative value indicates a hanging indentation.

Return value: the indent in Pango units.

    method pango_layout_get_indent ( --> Int  )

[pango_layout_] set_spacing
---------------------------

Sets the amount of spacing in Pango unit between the lines of the layout.

    method pango_layout_set_spacing ( Int $spacing )

  * Int $spacing; the amount of spacing

[pango_layout_] get_spacing
---------------------------

Gets the amount of spacing between the lines of the layout.

Return value: the spacing in Pango units.

    method pango_layout_get_spacing ( --> Int  )

[pango_layout_] set_justify
---------------------------

Sets whether each complete line should be stretched to fill the entire width of the layout. This stretching is typically done by adding whitespace, but for some scripts (such as Arabic), the justification may be done in more complex ways, like extending the characters.

Note that this setting is not implemented and so is ignored in Pango older than 1.18.

    method pango_layout_set_justify ( Int $justify )

  * Int $justify; whether the lines in the layout should be justified.

[pango_layout_] get_justify
---------------------------

Gets whether each complete line should be stretched to fill the entire width of the layout.

Return value: the justify.

    method pango_layout_get_justify ( --> Int  )

[pango_layout_] set_auto_dir
----------------------------

Sets whether to calculate the bidirectional base direction for the layout according to the contents of the layout; when this flag is on (the default), then paragraphs in (Arabic and Hebrew principally), will have right-to-left layout, paragraphs with letters from other scripts will have left-to-right layout. Paragraphs with only neutral characters get their direction from the surrounding paragraphs.

When `0`, the choice between left-to-right and right-to-left layout is done according to the base direction of the layout's **PangoContext**. (See `pango_context_set_base_dir()`).

When the auto-computed direction of a paragraph differs from the base direction of the context, the interpretation of `PANGO_ALIGN_LEFT` and `PANGO_ALIGN_RIGHT` are swapped.

Since: 1.4

    method pango_layout_set_auto_dir ( Int $auto_dir )

  * Int $auto_dir; if `1`, compute the bidirectional base direction from the layout's contents.

[pango_layout_] get_auto_dir
----------------------------

Gets whether to calculate the bidirectional base direction for the layout according to the contents of the layout. See `pango_layout_set_auto_dir()`.

Return value: `1` if the bidirectional base direction is computed from the layout's contents, `0` otherwise.

Since: 1.4

    method pango_layout_get_auto_dir ( --> Int  )

[pango_layout_] set_alignment
-----------------------------

Sets the alignment for the layout: how partial lines are positioned within the horizontal space available.

    method pango_layout_set_alignment ( PangoAlignment $alignment )

  * PangoAlignment $alignment; the alignment

[pango_layout_] get_alignment
-----------------------------

Gets the alignment for the layout: how partial lines are positioned within the horizontal space available.

Return value: the alignment.

    method pango_layout_get_alignment ( --> PangoAlignment  )

[pango_layout_] set_single_paragraph_mode
-----------------------------------------

If *setting* is `1`, do not treat newlines and similar characters as paragraph separators; instead, keep all text in a single paragraph, and display a glyph for paragraph separator characters. Used when you want to allow editing of newlines on a single text line.

    method pango_layout_set_single_paragraph_mode ( Int $setting )

  * Int $setting; new setting

[pango_layout_] get_single_paragraph_mode
-----------------------------------------

Obtains the value set by `pango_layout_set_single_paragraph_mode()`.

Return value: `1` if the layout does not break paragraphs at paragraph separator characters, `0` otherwise.

    method pango_layout_get_single_paragraph_mode ( --> Int  )

[pango_layout_] set_ellipsize
-----------------------------

Sets the type of ellipsization being performed for *layout*. Depending on the ellipsization mode *ellipsize* text is removed from the start, middle, or end of text so they fit within the width and height of layout set with `pango_layout_set_width()` and `pango_layout_set_height()`.

If the layout contains characters such as newlines that force it to be layed out in multiple paragraphs, then whether each paragraph is ellipsized separately or the entire layout is ellipsized as a whole depends on the set height of the layout. See `pango_layout_set_height()` for details.

Since: 1.6

    method pango_layout_set_ellipsize ( PangoEllipsizeMode $ellipsize )

  * PangoEllipsizeMode $ellipsize; the new ellipsization mode for *layout*

[pango_layout_] get_ellipsize
-----------------------------

Gets the type of ellipsization being performed for *layout*. See `pango_layout_set_ellipsize()`

Return value: the current ellipsization mode for *layout*.

Use `pango_layout_is_ellipsized()` to query whether any paragraphs were actually ellipsized.

Since: 1.6

    method pango_layout_get_ellipsize ( --> PangoEllipsizeMode  )

[pango_layout_] is_ellipsized
-----------------------------

Queries whether the layout had to ellipsize any paragraphs.

This returns `1` if the ellipsization mode for *layout* is not `PANGO_ELLIPSIZE_NONE`, a positive width is set on *layout*, and there are paragraphs exceeding that width that have to be ellipsized.

Return value: `1` if any paragraphs had to be ellipsized, `0` otherwise.

Since: 1.16

    method pango_layout_is_ellipsized ( --> Int  )

[pango_layout_] get_unknown_glyphs_count
----------------------------------------

Counts the number unknown glyphs in *layout*. That is, zero if glyphs for all characters in the layout text were found, or more than zero otherwise.

This function can be used to determine if there are any fonts available to render all characters in a certain string, or when used in combination with `PANGO_ATTR_FALLBACK`, to check if a certain font supports all the characters in the string.

Return value: The number of unknown glyphs in *layout*.

Since: 1.16

    method pango_layout_get_unknown_glyphs_count ( --> Int  )

[pango_layout_] context_changed
-------------------------------

Forces recomputation of any state in the **PangoLayout** that might depend on the layout's context. This function should be called if you make changes to the context subsequent to creating the layout.

    method pango_layout_context_changed ( )

[pango_layout_] get_serial
--------------------------

Returns the current serial number of *layout*. The serial number is initialized to an small number larger than zero when a new layout is created and is increased whenever the layout is changed using any of the setter functions, or the **PangoContext** it uses has changed. The serial may wrap, but will never have the value 0. Since it can wrap, never compare it with "less than", always use "not equals".

This can be used to automatically detect changes to a **PangoLayout**, and is useful for example to decide whether a layout needs redrawing. To force the serial to be increased, use `pango_layout_context_changed()`.

Return value: The current serial number of *layout*.

Since: 1.32.4

    method pango_layout_get_serial ( --> UInt  )

[pango_layout_] index_to_line_x
-------------------------------

Converts from byte *index_* within the *layout* to line and X position. (X position is measured from the left edge of the line)

    method pango_layout_index_to_line_x ( Int $index_, Int $trailing, Int $line, Int $x_pos )

  * Int $index_; the byte index of a grapheme within the layout.

  * Int $trailing; an integer indicating the edge of the grapheme to retrieve the position of. If > 0, the trailing edge of the grapheme, if 0, the leading of the grapheme.

  * Int $line; (out) (allow-none): location to store resulting line index. (which will between 0 and pango_layout_get_line_count(layout) - 1), or `Any`

  * Int $x_pos; (out) (allow-none): location to store resulting position within line (`PANGO_SCALE` units per device unit), or `Any`

[pango_layout_] move_cursor_visually
------------------------------------

Computes a new cursor position from an old position and a count of positions to move visually. If *direction* is positive, then the new strong cursor position will be one position to the right of the old cursor position. If *direction* is negative, then the new strong cursor position will be one position to the left of the old cursor position.

In the presence of bidirectional text, the correspondence between logical and visual order will depend on the direction of the current run, and there may be jumps when the cursor is moved off of the end of a run.

Motion here is in cursor positions, not in characters, so a single call to `pango_layout_move_cursor_visually()` may move the cursor over multiple characters when multiple characters combine to form a single grapheme.

    method pango_layout_move_cursor_visually ( Int $strong, Int $old_index, Int $old_trailing, Int $direction, Int $new_index, Int $new_trailing )

  * Int $strong; whether the moving cursor is the strong cursor or the weak cursor. The strong cursor is the cursor corresponding to text insertion in the base direction for the layout.

  * Int $old_index; the byte index of the grapheme for the old index

  * Int $old_trailing; if 0, the cursor was at the leading edge of the grapheme indicated by *old_index*, if > 0, the cursor was at the trailing edge.

  * Int $direction; direction to move cursor. A negative value indicates motion to the left.

  * Int $new_index; (out): location to store the new cursor byte index. A value of -1 indicates that the cursor has been moved off the beginning of the layout. A value of `G_MAXINT` indicates that the cursor has been moved off the end of the layout.

  * Int $new_trailing; (out): number of characters to move forward from the location returned for *new_index* to get the position where the cursor should be displayed. This allows distinguishing the position at the beginning of one line from the position at the end of the preceding line. *new_index* is always on the line where the cursor should be displayed.

[pango_layout_] xy_to_index
---------------------------

Converts from X and Y position within a layout to the byte index to the character at that logical position. If the Y position is not inside the layout, the closest position is chosen (the position will be clamped inside the layout). If the X position is not within the layout, then the start or the end of the line is chosen as described for `pango_layout_line_x_to_index()`. If either the X or Y positions were not inside the layout, then the function returns `0`; on an exact hit, it returns `1`.

Return value: `1` if the coordinates were inside text, `0` otherwise.

    method pango_layout_xy_to_index ( Int $x, Int $y, Int $index_, Int $trailing --> Int  )

  * Int $x; the X offset (in Pango units) from the left edge of the layout.

  * Int $y; the Y offset (in Pango units) from the top edge of the layout

  * Int $index_; (out): location to store calculated byte index

  * Int $trailing; (out): location to store a integer indicating where in the grapheme the user clicked. It will either be zero, or the number of characters in the grapheme. 0 represents the leading edge of the grapheme.

[pango_layout_] get_size
------------------------

Determines the logical width and height of a **PangoLayout** in Pango units (device units scaled by `PANGO_SCALE`). This is simply a convenience function around `pango_layout_get_extents()`.

    method pango_layout_get_size ( Int $width, Int $height )

  * Int $width; (out) (allow-none): location to store the logical width, or `Any`

  * Int $height; (out) (allow-none): location to store the logical height, or `Any`

[pango_layout_] get_pixel_size
------------------------------

Determines the logical width and height of a **PangoLayout** in device units. (`pango_layout_get_size()` returns the width and height scaled by `PANGO_SCALE`.) This is simply a convenience function around `pango_layout_get_pixel_extents()`.

    method pango_layout_get_pixel_size ( Int $width, Int $height )

  * Int $width; (out) (allow-none): location to store the logical width, or `Any`

  * Int $height; (out) (allow-none): location to store the logical height, or `Any`

[pango_layout_] get_baseline
----------------------------

Gets the Y position of baseline of the first line in *layout*.

Return value: baseline of first line, from top of *layout*.

Since: 1.22

    method pango_layout_get_baseline ( --> Int  )

[pango_layout_] get_line_count
------------------------------

Retrieves the count of lines for the *layout*.

Return value: the line count.

    method pango_layout_get_line_count ( --> Int  )

[pango_layout_] get_lines
-------------------------

Returns the lines of the *layout* as a list.

Use the faster `pango_layout_get_lines_readonly()` if you do not plan to modify the contents of the lines (glyphs, glyph widths, etc.).

Return value: (element-type Pango.LayoutLine) (transfer none): a **GSList** containing the lines in the layout. This points to internal data of the **PangoLayout** and must be used with care. It will become invalid on any change to the layout's text or properties.

    method pango_layout_get_lines ( --> N-GSList  )

[pango_layout_] get_lines_readonly
----------------------------------

Returns the lines of the *layout* as a list.

This is a faster alternative to `pango_layout_get_lines()`, but the user is not expected to modify the contents of the lines (glyphs, glyph widths, etc.).

Return value: (element-type Pango.LayoutLine) (transfer none): a **GSList** containing the lines in the layout. This points to internal data of the **PangoLayout** and must be used with care. It will become invalid on any change to the layout's text or properties. No changes should be made to the lines.

Since: 1.16

    method pango_layout_get_lines_readonly ( --> N-GSList  )

