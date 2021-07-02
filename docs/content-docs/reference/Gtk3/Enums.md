Gnome::Gtk3::Enums
==================

Standard Enumerations — Public enumerated types used throughout GTK+

    unit class Gnome::Gtk3::Enums;

Types
=====

enum GtkAlign
-------------

Controls how a widget deals with extra space in a single (x or y) dimension.

Alignment only matters if the widget receives a “too large” allocation, for example if you packed the widget with the *expand* flag inside a **Gnome::Gtk3::Box**, then the widget might get extra space. If you have for example a 16x16 icon inside a 32x32 space, the icon could be scaled and stretched, it could be centered, or it could be positioned to one side of the space.

Note that in horizontal context *GTK_ALIGN_START* and *GTK_ALIGN_END* are interpreted relative to text direction.

GTK_ALIGN_BASELINE support for it is optional for containers and widgets, and it is only supported for vertical alignment. When its not supported by a child or a container it is treated as *GTK_ALIGN_FILL*.

  * GTK_ALIGN_FILL: stretch to fill all space if possible, center if no meaningful way to stretch

  * GTK_ALIGN_START: snap to left or top side, leaving space on right or bottom

  * GTK_ALIGN_END: snap to right or bottom side, leaving space on left or top

  * GTK_ALIGN_CENTER: center natural width of widget inside the allocation

  * GTK_ALIGN_BASELINE: align the widget according to the baseline. Since 3.10.

enum GtkArrowType
-----------------

Used to indicate the direction in which an arrow should point.

  * GTK_ARROW_UP: Represents an upward pointing arrow.

  * GTK_ARROW_DOWN: Represents a downward pointing arrow.

  * GTK_ARROW_LEFT: Represents a left pointing arrow.

  * GTK_ARROW_RIGHT: Represents a right pointing arrow.

  * GTK_ARROW_NONE: No arrow. Since 2.10.

enum GtkBaselinePosition
------------------------

Whenever a container has some form of natural row it may align children in that row along a common typographical baseline. If the amount of verical space in the row is taller than the total requested height of the baseline-aligned children then it can use a **Gnome::Gtk3::BaselinePosition** to select where to put the baseline inside the extra availible space.

Since: 3.10

  * GTK_BASELINE_POSITION_TOP: Align the baseline at the top

  * GTK_BASELINE_POSITION_CENTER: Center the baseline

  * GTK_BASELINE_POSITION_BOTTOM: Align the baseline at the bottom

enum GtkDeleteType
------------------

See also: *delete-from-cursor*.

  * GTK_DELETE_CHARS: Delete characters.

  * GTK_DELETE_WORD_ENDS: Delete only the portion of the word to the left/right of cursor if we’re in the middle of a word.

  * GTK_DELETE_WORDS: Delete words.

  * GTK_DELETE_DISPLAY_LINES: Delete display-lines. Display-lines refers to the visible lines, with respect to to the current line breaks. As opposed to paragraphs, which are defined by line breaks in the input.

  * GTK_DELETE_DISPLAY_LINE_ENDS: Delete only the portion of the display-line to the left/right of cursor.

  * GTK_DELETE_PARAGRAPH_ENDS: Delete to the end of the paragraph. Like C-k in Emacs (or its reverse).

  * GTK_DELETE_PARAGRAPHS: Delete entire line. Like C-k in pico.

  * GTK_DELETE_WHITESPACE: Delete only whitespace. Like M-\ in Emacs.

enum GtkDirectionType
---------------------

Focus movement types.

  * GTK_DIR_TAB_FORWARD: Move forward.

  * GTK_DIR_TAB_BACKWARD: Move backward.

  * GTK_DIR_UP: Move up.

  * GTK_DIR_DOWN: Move down.

  * GTK_DIR_LEFT: Move left.

  * GTK_DIR_RIGHT: Move right.

enum GtkIconSize
----------------

Built-in stock icon sizes.

  * GTK_ICON_SIZE_INVALID: Invalid size.

  * GTK_ICON_SIZE_MENU: Size appropriate for menus (16px).

  * GTK_ICON_SIZE_SMALL_TOOLBAR: Size appropriate for small toolbars (16px).

  * GTK_ICON_SIZE_LARGE_TOOLBAR: Size appropriate for large toolbars (24px)

  * GTK_ICON_SIZE_BUTTON: Size appropriate for buttons (16px)

  * GTK_ICON_SIZE_DND: Size appropriate for drag and drop (32px)

  * GTK_ICON_SIZE_DIALOG: Size appropriate for dialogs (48px)

enum GtkSensitivityType
-----------------------

Determines how GTK+ handles the sensitivity of stepper arrows at the end of range widgets.

  * GTK_SENSITIVITY_AUTO: The arrow is made insensitive if the thumb is at the end

  * GTK_SENSITIVITY_ON: The arrow is always sensitive

  * GTK_SENSITIVITY_OFF: The arrow is always insensitive

enum GtkTextDirection
---------------------

Reading directions for text.

  * GTK_TEXT_DIR_NONE: No direction.

  * GTK_TEXT_DIR_LTR: Left to right text direction.

  * GTK_TEXT_DIR_RTL: Right to left text direction.

enum GtkJustification
---------------------

Used for justifying the text inside a **Gnome::Gtk3::Label** widget. (See also **Gnome::Gtk3::Alignment**).

  * GTK_JUSTIFY_LEFT: The text is placed at the left edge of the label.

  * GTK_JUSTIFY_RIGHT: The text is placed at the right edge of the label.

  * GTK_JUSTIFY_CENTER: The text is placed in the center of the label.

  * GTK_JUSTIFY_FILL: The text is placed is distributed across the label.

enum GtkMenuDirectionType
-------------------------

An enumeration representing directional movements within a menu.

  * GTK_MENU_DIR_PARENT: To the parent menu shell

  * GTK_MENU_DIR_CHILD: To the submenu, if any, associated with the item

  * GTK_MENU_DIR_NEXT: To the next menu item

  * GTK_MENU_DIR_PREV: To the previous menu item

enum GtkMessageType
-------------------

The type of message being displayed in the dialog.

  * GTK_MESSAGE_INFO: Informational message

  * GTK_MESSAGE_WARNING: Non-fatal warning message

  * GTK_MESSAGE_QUESTION: Question requiring a choice

  * GTK_MESSAGE_ERROR: Fatal error message

  * GTK_MESSAGE_OTHER: None of the above

enum GtkMovementStep
--------------------

  * GTK_MOVEMENT_LOGICAL_POSITIONS: Move forward or back by graphemes

  * GTK_MOVEMENT_VISUAL_POSITIONS: Move left or right by graphemes

  * GTK_MOVEMENT_WORDS: Move forward or back by words

  * GTK_MOVEMENT_DISPLAY_LINES: Move up or down lines (wrapped lines)

  * GTK_MOVEMENT_DISPLAY_LINE_ENDS: Move to either end of a line

  * GTK_MOVEMENT_PARAGRAPHS: Move up or down paragraphs (newline-ended lines)

  * GTK_MOVEMENT_PARAGRAPH_ENDS: Move to either end of a paragraph

  * GTK_MOVEMENT_PAGES: Move by pages

  * GTK_MOVEMENT_BUFFER_ENDS: Move to ends of the buffer

  * GTK_MOVEMENT_HORIZONTAL_PAGES: Move horizontally by pages

enum GtkScrollStep
------------------

  * GTK_SCROLL_STEPS: Scroll in steps.

  * GTK_SCROLL_PAGES: Scroll by pages.

  * GTK_SCROLL_ENDS: Scroll to ends.

  * GTK_SCROLL_HORIZONTAL_STEPS: Scroll in horizontal steps.

  * GTK_SCROLL_HORIZONTAL_PAGES: Scroll by horizontal pages.

  * GTK_SCROLL_HORIZONTAL_ENDS: Scroll to the horizontal ends.

enum GtkOrientation
-------------------

Represents the orientation of widgets and other objects which can be switched between horizontal and vertical orientation on the fly, like **Gnome::Gtk3::Toolbar** or **Gnome::Gtk3::GesturePan**.

  * GTK_ORIENTATION_HORIZONTAL: The element is in horizontal orientation.

  * GTK_ORIENTATION_VERTICAL: The element is in vertical orientation.

enum GtkPackType
----------------

Represents the packing location **Gnome::Gtk3::Box** children. (See: **Gnome::Gtk3::VBox**, **Gnome::Gtk3::HBox**, and **Gnome::Gtk3::ButtonBox**).

  * GTK_PACK_START: The child is packed into the start of the box

  * GTK_PACK_END: The child is packed into the end of the box

enum GtkPositionType
--------------------

Describes which edge of a widget a certain feature is positioned at, e.g. the tabs of a **Gnome::Gtk3::Notebook**, the handle of a **Gnome::Gtk3::HandleBox** or the label of a **Gnome::Gtk3::Scale**.

  * GTK_POS_LEFT: The feature is at the left edge.

  * GTK_POS_RIGHT: The feature is at the right edge.

  * GTK_POS_TOP: The feature is at the top edge.

  * GTK_POS_BOTTOM: The feature is at the bottom edge.

enum GtkReliefStyle
-------------------

Indicated the relief to be drawn around a **Gnome::Gtk3::Button**.

  * GTK_RELIEF_NORMAL: Draw a normal relief.

  * GTK_RELIEF_HALF: A half relief. Deprecated in 3.14, does the same as *GTK_RELIEF_NORMAL*

  * GTK_RELIEF_NONE: No relief.

enum GtkScrollType
------------------

Scrolling types.

  * GTK_SCROLL_NONE: No scrolling.

  * GTK_SCROLL_JUMP: Jump to new location.

  * GTK_SCROLL_STEP_BACKWARD: Step backward.

  * GTK_SCROLL_STEP_FORWARD: Step forward.

  * GTK_SCROLL_PAGE_BACKWARD: Page backward.

  * GTK_SCROLL_PAGE_FORWARD: Page forward.

  * GTK_SCROLL_STEP_UP: Step up.

  * GTK_SCROLL_STEP_DOWN: Step down.

  * GTK_SCROLL_PAGE_UP: Page up.

  * GTK_SCROLL_PAGE_DOWN: Page down.

  * GTK_SCROLL_STEP_LEFT: Step to the left.

  * GTK_SCROLL_STEP_RIGHT: Step to the right.

  * GTK_SCROLL_PAGE_LEFT: Page to the left.

  * GTK_SCROLL_PAGE_RIGHT: Page to the right.

  * GTK_SCROLL_START: Scroll to start.

  * GTK_SCROLL_END: Scroll to end.

enum GtkSelectionMode
---------------------

Used to control what selections users are allowed to make.

  * GTK_SELECTION_NONE: No selection is possible.

  * GTK_SELECTION_SINGLE: Zero or one element may be selected.

  * GTK_SELECTION_BROWSE: Exactly one element is selected. In some circumstances, such as initially or during a search operation, it’s possible for no element to be selected with `GTK_SELECTION_BROWSE`. What is really enforced is that the user can’t deselect a currently selected element except by selecting another element.

  * GTK_SELECTION_MULTIPLE: Any number of elements may be selected. The Ctrl key may be used to enlarge the selection, and Shift key to select between the focus and the child pointed to. Some widgets may also allow Click-drag to select a range of elements.

enum GtkShadowType
------------------

Used to change the appearance of an outline typically provided by a **Gnome::Gtk3::Frame**.

Note that many themes do not differentiate the appearance of the various shadow types: Either their is no visible shadow (*GTK_SHADOW_NONE*), or there is (any other value).

  * GTK_SHADOW_NONE: No outline.

  * GTK_SHADOW_IN: The outline is bevelled inwards.

  * GTK_SHADOW_OUT: The outline is bevelled outwards like a button.

  * GTK_SHADOW_ETCHED_IN: The outline has a sunken 3d appearance.

  * GTK_SHADOW_ETCHED_OUT: The outline has a raised 3d appearance.

enum GtkStateType
-----------------

This type indicates the current state of a widget; the state determines how the widget is drawn. The **Gnome::Gtk3::StateType** enumeration is also used to identify different colors in a **Gnome::Gtk3::Style** for drawing, so states can be used for subparts of a widget as well as entire widgets.

Deprecated: 3.14: All APIs that are using this enumeration have been deprecated in favor of alternatives using **Gnome::Gtk3::StateFlags**.

  * GTK_STATE_NORMAL: State during normal operation.

  * GTK_STATE_ACTIVE: State of a currently active widget, such as a depressed button.

  * GTK_STATE_PRELIGHT: State indicating that the mouse pointer is over the widget and the widget will respond to mouse clicks.

  * GTK_STATE_SELECTED: State of a selected item, such the selected row in a list.

  * GTK_STATE_INSENSITIVE: State indicating that the widget is unresponsive to user actions.

  * GTK_STATE_INCONSISTENT: The widget is inconsistent, such as checkbuttons or radiobuttons that aren’t either set to `1` nor `0`, or buttons requiring the user attention.

  * GTK_STATE_FOCUSED: The widget has the keyboard focus.

enum GtkToolbarStyle
--------------------

Used to customize the appearance of a **Gnome::Gtk3::Toolbar**. Note that setting the toolbar style overrides the user’s preferences for the default toolbar style. Note that if the button has only a label set and GTK_TOOLBAR_ICONS is used, the label will be visible, and vice versa.

  * GTK_TOOLBAR_ICONS: Buttons display only icons in the toolbar.

  * GTK_TOOLBAR_TEXT: Buttons display only text labels in the toolbar.

  * GTK_TOOLBAR_BOTH: Buttons display text and icons in the toolbar.

  * GTK_TOOLBAR_BOTH_HORIZ: Buttons display icons and text alongside each other, rather than vertically stacked

enum GtkWrapMode
----------------

Describes a type of line wrapping.

  * GTK_WRAP_NONE: do not wrap lines; just make the text area wider

  * GTK_WRAP_CHAR: wrap text, breaking lines anywhere the cursor can appear (between characters, usually - if you want to be technical, between graphemes, see `pango_get_log_attrs()`)

  * GTK_WRAP_WORD: wrap text, breaking lines in between words

  * GTK_WRAP_WORD_CHAR: wrap text, breaking lines in between words, or if that is not enough, also between graphemes

enum GtkSortType
----------------

Determines the direction of a sort.

  * GTK_SORT_ASCENDING: Sorting is in ascending order.

  * GTK_SORT_DESCENDING: Sorting is in descending order.

enum GtkIMPreeditStyle
----------------------

Style for input method preedit. See also *gtk-im-preedit-style*

Deprecated: 3.10

  * GTK_IM_PREEDIT_NOTHING: Deprecated

  * GTK_IM_PREEDIT_CALLBACK: Deprecated

  * GTK_IM_PREEDIT_NONE: Deprecated

enum GtkIMStatusStyle
---------------------

Style for input method status. See also *gtk-im-status-style*

Deprecated: 3.10

  * GTK_IM_STATUS_NOTHING: Deprecated

  * GTK_IM_STATUS_CALLBACK: Deprecated

  * GTK_IM_STATUS_NONE: Deprecated

enum GtkPackDirection
---------------------

Determines how widgets should be packed inside menubars and menuitems contained in menubars.

  * GTK_PACK_DIRECTION_LTR: Widgets are packed left-to-right

  * GTK_PACK_DIRECTION_RTL: Widgets are packed right-to-left

  * GTK_PACK_DIRECTION_TTB: Widgets are packed top-to-bottom

  * GTK_PACK_DIRECTION_BTT: Widgets are packed bottom-to-top

enum GtkPrintPages
------------------

See also `gtk_print_job_set_pages()`

  * GTK_PRINT_PAGES_ALL: All pages.

  * GTK_PRINT_PAGES_CURRENT: Current page.

  * GTK_PRINT_PAGES_RANGES: Range of pages.

  * GTK_PRINT_PAGES_SELECTION: Selected pages.

enum GtkPageSet
---------------

See also `gtk_print_job_set_page_set()`.

  * GTK_PAGE_SET_ALL: All pages.

  * GTK_PAGE_SET_EVEN: Even pages.

  * GTK_PAGE_SET_ODD: Odd pages.

enum GtkNumberUpLayout
----------------------

Used to determine the layout of pages on a sheet when printing multiple pages per sheet.

  * GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM: ![](images/layout-lrtb.png)

  * GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP: ![](images/layout-lrbt.png)

  * GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM: ![](images/layout-rltb.png)

  * GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP: ![](images/layout-rlbt.png)

  * GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT: ![](images/layout-tblr.png)

  * GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT: ![](images/layout-tbrl.png)

  * GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT: ![](images/layout-btlr.png)

  * GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT: ![](images/layout-btrl.png)

enum GtkPageOrientation
-----------------------

See also `gtk_print_settings_set_orientation()`.

  * GTK_PAGE_ORIENTATION_PORTRAIT: Portrait mode.

  * GTK_PAGE_ORIENTATION_LANDSCAPE: Landscape mode.

  * GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT: Reverse portrait mode.

  * GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE: Reverse landscape mode.

enum GtkPrintQuality
--------------------

See also `gtk_print_settings_set_quality()`.

  * GTK_PRINT_QUALITY_LOW: Low quality.

  * GTK_PRINT_QUALITY_NORMAL: Normal quality.

  * GTK_PRINT_QUALITY_HIGH: High quality.

  * GTK_PRINT_QUALITY_DRAFT: Draft quality.

enum GtkPrintDuplex
-------------------

See also `gtk_print_settings_set_duplex()`.

  * GTK_PRINT_DUPLEX_SIMPLEX: No duplex.

  * GTK_PRINT_DUPLEX_HORIZONTAL: Horizontal duplex.

  * GTK_PRINT_DUPLEX_VERTICAL: Vertical duplex.

enum GtkUnit
------------

See also `gtk_print_settings_set_paper_width()`.

  * GTK_UNIT_NONE: No units.

  * GTK_UNIT_POINTS: Dimensions in points.

  * GTK_UNIT_INCH: Dimensions in inches.

  * GTK_UNIT_MM: Dimensions in millimeters

enum GtkTreeViewGridLines
-------------------------

Used to indicate which grid lines to draw in a tree view.

  * GTK_TREE_VIEW_GRID_LINES_NONE: No grid lines.

  * GTK_TREE_VIEW_GRID_LINES_HORIZONTAL: Horizontal grid lines.

  * GTK_TREE_VIEW_GRID_LINES_VERTICAL: Vertical grid lines.

  * GTK_TREE_VIEW_GRID_LINES_BOTH: Horizontal and vertical grid lines.

enum GtkDragResult
------------------

Gives an indication why a drag operation failed. The value can by obtained by connecting to the *drag-failed* signal.

  * GTK_DRAG_RESULT_SUCCESS: The drag operation was successful.

  * GTK_DRAG_RESULT_NO_TARGET: No suitable drag target.

  * GTK_DRAG_RESULT_USER_CANCELLED: The user cancelled the drag operation.

  * GTK_DRAG_RESULT_TIMEOUT_EXPIRED: The drag operation timed out.

  * GTK_DRAG_RESULT_GRAB_BROKEN: The pointer or keyboard grab used for the drag operation was broken.

  * GTK_DRAG_RESULT_ERROR: The drag operation failed due to some unspecified error.

enum GtkSizeGroupMode
---------------------

The mode of the size group determines the directions in which the size group affects the requested sizes of its component widgets.

  * GTK_SIZE_GROUP_NONE: group has no effect

  * GTK_SIZE_GROUP_HORIZONTAL: group affects horizontal requisition

  * GTK_SIZE_GROUP_VERTICAL: group affects vertical requisition

  * GTK_SIZE_GROUP_BOTH: group affects both horizontal and vertical requisition

enum GtkSizeRequestMode
-----------------------

Specifies a preference for height-for-width or width-for-height geometry management.

  * GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH: Prefer height-for-width geometry management

  * GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT: Prefer width-for-height geometry management

  * GTK_SIZE_REQUEST_CONSTANT_SIZE: Don’t trade height-for-width or width-for-height

enum GtkScrollablePolicy
------------------------

Defines the policy to be used in a scrollable widget when updating the scrolled window adjustments in a given orientation.

  * GTK_SCROLL_MINIMUM: Scrollable adjustments are based on the minimum size

  * GTK_SCROLL_NATURAL: Scrollable adjustments are based on the natural size

enum GtkStateFlags
------------------

Describes a widget state. Widget states are used to match the widget against CSS pseudo-classes. Note that GTK extends the regular CSS classes and sometimes uses different names.

  * GTK_STATE_FLAG_NORMAL: State during normal operation.

  * GTK_STATE_FLAG_ACTIVE: Widget is active.

  * GTK_STATE_FLAG_PRELIGHT: Widget has a mouse pointer over it.

  * GTK_STATE_FLAG_SELECTED: Widget is selected.

  * GTK_STATE_FLAG_INSENSITIVE: Widget is insensitive.

  * GTK_STATE_FLAG_INCONSISTENT: Widget is inconsistent.

  * GTK_STATE_FLAG_FOCUSED: Widget has the keyboard focus.

  * GTK_STATE_FLAG_BACKDROP: Widget is in a background toplevel window.

  * GTK_STATE_FLAG_DIR_LTR: Widget is in left-to-right text direction.

  * GTK_STATE_FLAG_DIR_RTL: Widget is in right-to-left text direction.

  * GTK_STATE_FLAG_LINK: Widget is a link.

  * GTK_STATE_FLAG_VISITED: The location the widget points to has already been visited.

  * GTK_STATE_FLAG_CHECKED: Widget is checked.

  * GTK_STATE_FLAG_DROP_ACTIVE: Widget is highlighted as a drop target for DND.

enum GtkRegionFlags
-------------------

Describes a region within a widget.

  * GTK_REGION_EVEN: Region has an even number within a set.

  * GTK_REGION_ODD: Region has an odd number within a set.

  * GTK_REGION_FIRST: Region is the first one within a set.

  * GTK_REGION_LAST: Region is the last one within a set.

  * GTK_REGION_ONLY: Region is the only one within a set.

  * GTK_REGION_SORTED: Region is part of a sorted area.

enum GtkJunctionSides
---------------------

Describes how a rendered element connects to adjacent elements.

  * GTK_JUNCTION_NONE: No junctions.

  * GTK_JUNCTION_CORNER_TOPLEFT: Element connects on the top-left corner.

  * GTK_JUNCTION_CORNER_TOPRIGHT: Element connects on the top-right corner.

  * GTK_JUNCTION_CORNER_BOTTOMLEFT: Element connects on the bottom-left corner.

  * GTK_JUNCTION_CORNER_BOTTOMRIGHT: Element connects on the bottom-right corner.

  * GTK_JUNCTION_TOP: Element connects on the top side.

  * GTK_JUNCTION_BOTTOM: Element connects on the bottom side.

  * GTK_JUNCTION_LEFT: Element connects on the left side.

  * GTK_JUNCTION_RIGHT: Element connects on the right side.

enum GtkBorderStyle
-------------------

Describes how the border of a UI element should be rendered.

  * GTK_BORDER_STYLE_NONE: No visible border

  * GTK_BORDER_STYLE_SOLID: A single line segment

  * GTK_BORDER_STYLE_INSET: Looks as if the content is sunken into the canvas

  * GTK_BORDER_STYLE_OUTSET: Looks as if the content is coming out of the canvas

  * GTK_BORDER_STYLE_HIDDEN: Same as *GTK_BORDER_STYLE_NONE*

  * GTK_BORDER_STYLE_DOTTED: A series of round dots

  * GTK_BORDER_STYLE_DASHED: A series of square-ended dashes

  * GTK_BORDER_STYLE_DOUBLE: Two parallel lines with some space between them

  * GTK_BORDER_STYLE_GROOVE: Looks as if it were carved in the canvas

  * GTK_BORDER_STYLE_RIDGE: Looks as if it were coming out of the canvas

enum GtkLevelBarMode
--------------------

Describes how **Gnome::Gtk3::LevelBar** contents should be rendered. Note that this enumeration could be extended with additional modes in the future.

Since: 3.6

  * GTK_LEVEL_BAR_MODE_CONTINUOUS: the bar has a continuous mode

  * GTK_LEVEL_BAR_MODE_DISCRETE: the bar has a discrete mode

enum GtkInputPurpose
--------------------

Describes primary purpose of the input widget. This information is useful for on-screen keyboards and similar input methods to decide which keys should be presented to the user.

Note that the purpose is not meant to impose a totally strict rule about allowed characters, and does not replace input validation. It is fine for an on-screen keyboard to let the user override the character set restriction that is expressed by the purpose. The application is expected to validate the entry contents, even if it specified a purpose.

The difference between *GTK_INPUT_PURPOSE_DIGITS* and *GTK_INPUT_PURPOSE_NUMBER* is that the former accepts only digits while the latter also some punctuation (like commas or points, plus, minus) and “e” or “E” as in 3.14E+000.

This enumeration may be extended in the future; input methods should interpret unknown values as “free form”.

Since: 3.6

  * GTK_INPUT_PURPOSE_FREE_FORM: Allow any character

  * GTK_INPUT_PURPOSE_ALPHA: Allow only alphabetic characters

  * GTK_INPUT_PURPOSE_DIGITS: Allow only digits

  * GTK_INPUT_PURPOSE_NUMBER: Edited field expects numbers

  * GTK_INPUT_PURPOSE_PHONE: Edited field expects phone number

  * GTK_INPUT_PURPOSE_URL: Edited field expects URL

  * GTK_INPUT_PURPOSE_EMAIL: Edited field expects email address

  * GTK_INPUT_PURPOSE_NAME: Edited field expects the name of a person

  * GTK_INPUT_PURPOSE_PASSWORD: Like *GTK_INPUT_PURPOSE_FREE_FORM*, but characters are hidden

  * GTK_INPUT_PURPOSE_PIN: Like *GTK_INPUT_PURPOSE_DIGITS*, but characters are hidden

enum GtkInputHints
------------------

Describes hints that might be taken into account by input methods or applications. Note that input methods may already tailor their behaviour according to the **Gnome::Gtk3::InputPurpose** of the entry.

Some common sense is expected when using these flags - mixing *GTK_INPUT_HINT_LOWERCASE* with any of the uppercase hints makes no sense.

This enumeration may be extended in the future; input methods should ignore unknown values.

Since: 3.6

  * GTK_INPUT_HINT_NONE: No special behaviour suggested

  * GTK_INPUT_HINT_SPELLCHECK: Suggest checking for typos

  * GTK_INPUT_HINT_NO_SPELLCHECK: Suggest not checking for typos

  * GTK_INPUT_HINT_WORD_COMPLETION: Suggest word completion

  * GTK_INPUT_HINT_LOWERCASE: Suggest to convert all text to lowercase

  * GTK_INPUT_HINT_UPPERCASE_CHARS: Suggest to capitalize all text

  * GTK_INPUT_HINT_UPPERCASE_WORDS: Suggest to capitalize the first character of each word

  * GTK_INPUT_HINT_UPPERCASE_SENTENCES: Suggest to capitalize the first word of each sentence

  * GTK_INPUT_HINT_INHIBIT_OSK: Suggest to not show an onscreen keyboard (e.g for a calculator that already has all the keys).

  * GTK_INPUT_HINT_VERTICAL_WRITING: The text is vertical. Since 3.18

  * GTK_INPUT_HINT_EMOJI: Suggest offering Emoji support. Since 3.22.20

  * GTK_INPUT_HINT_NO_EMOJI: Suggest not offering Emoji support. Since 3.22.20

enum GtkPropagationPhase
------------------------

Describes the stage at which events are fed into a **Gnome::Gtk3::EventController**.

Since: 3.14

  * GTK_PHASE_NONE: Events are not delivered automatically. Those can be manually fed through `gtk_event_controller_handle_event()`. This should only be used when full control about when, or whether the controller handles the event is needed.

  * GTK_PHASE_CAPTURE: Events are delivered in the capture phase. The capture phase happens before the bubble phase, runs from the toplevel down to the event widget. This option should only be used on containers that might possibly handle events before their children do.

  * GTK_PHASE_BUBBLE: Events are delivered in the bubble phase. The bubble phase happens after the capture phase, and before the default handlers are run. This phase runs from the event widget, up to the toplevel.

  * GTK_PHASE_TARGET: Events are delivered in the default widget event handlers, note that widget implementations must chain up on button, motion, touch and grab broken handlers for controllers in this phase to be run.

enum GtkEventSequenceState
--------------------------

Describes the state of a **Gnome::Gdk3::EventSequence** in a **Gnome::Gtk3::Gesture**.

Since: 3.14

  * GTK_EVENT_SEQUENCE_NONE: The sequence is handled, but not grabbed.

  * GTK_EVENT_SEQUENCE_CLAIMED: The sequence is handled and grabbed.

  * GTK_EVENT_SEQUENCE_DENIED: The sequence is denied.

enum GtkPanDirection
--------------------

Describes the panning direction of a **Gnome::Gtk3::GesturePan**

Since: 3.14

  * GTK_PAN_DIRECTION_LEFT: panned towards the left

  * GTK_PAN_DIRECTION_RIGHT: panned towards the right

  * GTK_PAN_DIRECTION_UP: panned upwards

  * GTK_PAN_DIRECTION_DOWN: panned downwards

enum GtkPopoverConstraint
-------------------------

Describes constraints to positioning of popovers. More values may be added to this enumeration in the future.

Since: 3.20

  * GTK_POPOVER_CONSTRAINT_NONE: Don't constrain the popover position beyond what is imposed by the implementation

  * GTK_POPOVER_CONSTRAINT_WINDOW: Constrain the popover to the boundaries of the window that it is attached to

