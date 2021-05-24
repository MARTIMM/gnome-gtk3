#TL:1:Gnome::::Enums:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Enums

Standard Enumerations — Public enumerated types used throughout GTK+

  unit class Gnome::Gtk3::Enums;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktypes.h
unit class Gnome::Gtk3::Enums:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkAlign

Controls how a widget deals with extra space in a single (x or y)
dimension.

Alignment only matters if the widget receives a “too large” allocation,
for example if you packed the widget with the  I<expand>
flag inside a B<Gnome::Gtk3::Box>, then the widget might get extra space.  If
you have for example a 16x16 icon inside a 32x32 space, the icon
could be scaled and stretched, it could be centered, or it could be
positioned to one side of the space.

Note that in horizontal context I<GTK_ALIGN_START> and I<GTK_ALIGN_END>
are interpreted relative to text direction.

GTK_ALIGN_BASELINE support for it is optional for containers and widgets, and
it is only supported for vertical alignment.  When its not supported by
a child or a container it is treated as I<GTK_ALIGN_FILL>.


=item GTK_ALIGN_FILL: stretch to fill all space if possible, center if no meaningful way to stretch
=item GTK_ALIGN_START: snap to left or top side, leaving space on right or bottom
=item GTK_ALIGN_END: snap to right or bottom side, leaving space on left or top
=item GTK_ALIGN_CENTER: center natural width of widget inside the allocation
=item GTK_ALIGN_BASELINE: align the widget according to the baseline. Since 3.10.


=end pod

#TE:0:GtkAlign:
enum GtkAlign is export (
  'GTK_ALIGN_FILL',
  'GTK_ALIGN_START',
  'GTK_ALIGN_END',
  'GTK_ALIGN_CENTER',
  'GTK_ALIGN_BASELINE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkArrowType

Used to indicate the direction in which an arrow should point.


=item GTK_ARROW_UP: Represents an upward pointing arrow.
=item GTK_ARROW_DOWN: Represents a downward pointing arrow.
=item GTK_ARROW_LEFT: Represents a left pointing arrow.
=item GTK_ARROW_RIGHT: Represents a right pointing arrow.
=item GTK_ARROW_NONE: No arrow. Since 2.10.


=end pod

#TE:0:GtkArrowType:
enum GtkArrowType is export (
  'GTK_ARROW_UP',
  'GTK_ARROW_DOWN',
  'GTK_ARROW_LEFT',
  'GTK_ARROW_RIGHT',
  'GTK_ARROW_NONE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkBaselinePosition

Whenever a container has some form of natural row it may align
children in that row along a common typographical baseline. If
the amount of verical space in the row is taller than the total
requested height of the baseline-aligned children then it can use a
B<Gnome::Gtk3::BaselinePosition> to select where to put the baseline inside the
extra availible space.

Since: 3.10


=item GTK_BASELINE_POSITION_TOP: Align the baseline at the top
=item GTK_BASELINE_POSITION_CENTER: Center the baseline
=item GTK_BASELINE_POSITION_BOTTOM: Align the baseline at the bottom


=end pod

#TE:0:GtkBaselinePosition:
enum GtkBaselinePosition is export (
  'GTK_BASELINE_POSITION_TOP',
  'GTK_BASELINE_POSITION_CENTER',
  'GTK_BASELINE_POSITION_BOTTOM'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkDeleteType

See also:  I<delete-from-cursor>.


=item GTK_DELETE_CHARS: Delete characters.
=item GTK_DELETE_WORD_ENDS: Delete only the portion of the word to the left/right of cursor if we’re in the middle of a word.
=item GTK_DELETE_WORDS: Delete words.
=item GTK_DELETE_DISPLAY_LINES: Delete display-lines. Display-lines refers to the visible lines, with respect to to the current line breaks. As opposed to paragraphs, which are defined by line breaks in the input.
=item GTK_DELETE_DISPLAY_LINE_ENDS: Delete only the portion of the display-line to the left/right of cursor.
=item GTK_DELETE_PARAGRAPH_ENDS: Delete to the end of the paragraph. Like C-k in Emacs (or its reverse).
=item GTK_DELETE_PARAGRAPHS: Delete entire line. Like C-k in pico.
=item GTK_DELETE_WHITESPACE: Delete only whitespace. Like M-\ in Emacs.


=end pod

#TE:0:GtkDeleteType:
enum GtkDeleteType is export (
  'GTK_DELETE_CHARS',
  'GTK_DELETE_WORD_ENDS',
  'GTK_DELETE_WORDS',
  'GTK_DELETE_DISPLAY_LINES',
  'GTK_DELETE_DISPLAY_LINE_ENDS',
  'GTK_DELETE_PARAGRAPH_ENDS',
  'GTK_DELETE_PARAGRAPHS',
  'GTK_DELETE_WHITESPACE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkDirectionType

Focus movement types.

=item GTK_DIR_TAB_FORWARD: Move forward.
=item GTK_DIR_TAB_BACKWARD: Move backward.
=item GTK_DIR_UP: Move up.
=item GTK_DIR_DOWN: Move down.
=item GTK_DIR_LEFT: Move left.
=item GTK_DIR_RIGHT: Move right.

=end pod

#TE:1:GtkDirectionType:
enum GtkDirectionType is export (
  'GTK_DIR_TAB_FORWARD',
  'GTK_DIR_TAB_BACKWARD',
  'GTK_DIR_UP',
  'GTK_DIR_DOWN',
  'GTK_DIR_LEFT',
  'GTK_DIR_RIGHT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIconSize

Built-in stock icon sizes.

=item GTK_ICON_SIZE_INVALID: Invalid size.
=item GTK_ICON_SIZE_MENU: Size appropriate for menus (16px).
=item GTK_ICON_SIZE_SMALL_TOOLBAR: Size appropriate for small toolbars (16px).
=item GTK_ICON_SIZE_LARGE_TOOLBAR: Size appropriate for large toolbars (24px)
=item GTK_ICON_SIZE_BUTTON: Size appropriate for buttons (16px)
=item GTK_ICON_SIZE_DND: Size appropriate for drag and drop (32px)
=item GTK_ICON_SIZE_DIALOG: Size appropriate for dialogs (48px)


=end pod

#TE:4:GtkIconSize:Button.t
enum GtkIconSize is export (
  'GTK_ICON_SIZE_INVALID',
  'GTK_ICON_SIZE_MENU',
  'GTK_ICON_SIZE_SMALL_TOOLBAR',
  'GTK_ICON_SIZE_LARGE_TOOLBAR',
  'GTK_ICON_SIZE_BUTTON',
  'GTK_ICON_SIZE_DND',
  'GTK_ICON_SIZE_DIALOG'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSensitivityType

Determines how GTK+ handles the sensitivity of stepper arrows
at the end of range widgets.


=item GTK_SENSITIVITY_AUTO: The arrow is made insensitive if the thumb is at the end
=item GTK_SENSITIVITY_ON: The arrow is always sensitive
=item GTK_SENSITIVITY_OFF: The arrow is always insensitive


=end pod

#TE:0:GtkSensitivityType:
enum GtkSensitivityType is export (
  'GTK_SENSITIVITY_AUTO',
  'GTK_SENSITIVITY_ON',
  'GTK_SENSITIVITY_OFF'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextDirection

Reading directions for text.

=item GTK_TEXT_DIR_NONE: No direction.
=item GTK_TEXT_DIR_LTR: Left to right text direction.
=item GTK_TEXT_DIR_RTL: Right to left text direction.

=end pod

#TE:2:GtkTextDirection:
enum GtkTextDirection is export (
  'GTK_TEXT_DIR_NONE',
  'GTK_TEXT_DIR_LTR',
  'GTK_TEXT_DIR_RTL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkJustification

Used for justifying the text inside a B<Gnome::Gtk3::Label> widget. (See also
B<Gnome::Gtk3::Alignment>).


=item GTK_JUSTIFY_LEFT: The text is placed at the left edge of the label.
=item GTK_JUSTIFY_RIGHT: The text is placed at the right edge of the label.
=item GTK_JUSTIFY_CENTER: The text is placed in the center of the label.
=item GTK_JUSTIFY_FILL: The text is placed is distributed across the label.


=end pod

#TE:0:GtkJustification:
enum GtkJustification is export (
  'GTK_JUSTIFY_LEFT',
  'GTK_JUSTIFY_RIGHT',
  'GTK_JUSTIFY_CENTER',
  'GTK_JUSTIFY_FILL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkMenuDirectionType

An enumeration representing directional movements within a menu.


=item GTK_MENU_DIR_PARENT: To the parent menu shell
=item GTK_MENU_DIR_CHILD: To the submenu, if any, associated with the item
=item GTK_MENU_DIR_NEXT: To the next menu item
=item GTK_MENU_DIR_PREV: To the previous menu item


=end pod

#TE:0:GtkMenuDirectionType:
enum GtkMenuDirectionType is export (
  'GTK_MENU_DIR_PARENT',
  'GTK_MENU_DIR_CHILD',
  'GTK_MENU_DIR_NEXT',
  'GTK_MENU_DIR_PREV'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkMessageType

The type of message being displayed in the dialog.


=item GTK_MESSAGE_INFO: Informational message
=item GTK_MESSAGE_WARNING: Non-fatal warning message
=item GTK_MESSAGE_QUESTION: Question requiring a choice
=item GTK_MESSAGE_ERROR: Fatal error message
=item GTK_MESSAGE_OTHER: None of the above


=end pod

#TE:0:GtkMessageType:
enum GtkMessageType is export (
  'GTK_MESSAGE_INFO',
  'GTK_MESSAGE_WARNING',
  'GTK_MESSAGE_QUESTION',
  'GTK_MESSAGE_ERROR',
  'GTK_MESSAGE_OTHER'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkMovementStep




=item GTK_MOVEMENT_LOGICAL_POSITIONS: Move forward or back by graphemes
=item GTK_MOVEMENT_VISUAL_POSITIONS:  Move left or right by graphemes
=item GTK_MOVEMENT_WORDS:             Move forward or back by words
=item GTK_MOVEMENT_DISPLAY_LINES:     Move up or down lines (wrapped lines)
=item GTK_MOVEMENT_DISPLAY_LINE_ENDS: Move to either end of a line
=item GTK_MOVEMENT_PARAGRAPHS:        Move up or down paragraphs (newline-ended lines)
=item GTK_MOVEMENT_PARAGRAPH_ENDS:    Move to either end of a paragraph
=item GTK_MOVEMENT_PAGES:             Move by pages
=item GTK_MOVEMENT_BUFFER_ENDS:       Move to ends of the buffer
=item GTK_MOVEMENT_HORIZONTAL_PAGES:  Move horizontally by pages


=end pod

#TE:0:GtkMovementStep:
enum GtkMovementStep is export (
  'GTK_MOVEMENT_LOGICAL_POSITIONS',
  'GTK_MOVEMENT_VISUAL_POSITIONS',
  'GTK_MOVEMENT_WORDS',
  'GTK_MOVEMENT_DISPLAY_LINES',
  'GTK_MOVEMENT_DISPLAY_LINE_ENDS',
  'GTK_MOVEMENT_PARAGRAPHS',
  'GTK_MOVEMENT_PARAGRAPH_ENDS',
  'GTK_MOVEMENT_PAGES',
  'GTK_MOVEMENT_BUFFER_ENDS',
  'GTK_MOVEMENT_HORIZONTAL_PAGES'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkScrollStep




=item GTK_SCROLL_STEPS: Scroll in steps.
=item GTK_SCROLL_PAGES: Scroll by pages.
=item GTK_SCROLL_ENDS: Scroll to ends.
=item GTK_SCROLL_HORIZONTAL_STEPS: Scroll in horizontal steps.
=item GTK_SCROLL_HORIZONTAL_PAGES: Scroll by horizontal pages.
=item GTK_SCROLL_HORIZONTAL_ENDS: Scroll to the horizontal ends.


=end pod

#TE:0:GtkScrollStep:
enum GtkScrollStep is export (
  'GTK_SCROLL_STEPS',
  'GTK_SCROLL_PAGES',
  'GTK_SCROLL_ENDS',
  'GTK_SCROLL_HORIZONTAL_STEPS',
  'GTK_SCROLL_HORIZONTAL_PAGES',
  'GTK_SCROLL_HORIZONTAL_ENDS'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkOrientation

Represents the orientation of widgets and other objects which can be switched
between horizontal and vertical orientation on the fly, like B<Gnome::Gtk3::Toolbar> or
B<Gnome::Gtk3::GesturePan>.


=item GTK_ORIENTATION_HORIZONTAL: The element is in horizontal orientation.
=item GTK_ORIENTATION_VERTICAL: The element is in vertical orientation.


=end pod

#TE:0:GtkOrientation:
enum GtkOrientation is export (
  'GTK_ORIENTATION_HORIZONTAL',
  'GTK_ORIENTATION_VERTICAL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPackType

Represents the packing location B<Gnome::Gtk3::Box> children. (See: B<Gnome::Gtk3::VBox>,
B<Gnome::Gtk3::HBox>, and B<Gnome::Gtk3::ButtonBox>).


=item GTK_PACK_START: The child is packed into the start of the box
=item GTK_PACK_END: The child is packed into the end of the box


=end pod

#TE:0:GtkPackType:
enum GtkPackType is export (
  'GTK_PACK_START',
  'GTK_PACK_END'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPositionType

Describes which edge of a widget a certain feature is positioned at, e.g. the
tabs of a B<Gnome::Gtk3::Notebook>, the handle of a B<Gnome::Gtk3::HandleBox> or the label of a
B<Gnome::Gtk3::Scale>.


=item GTK_POS_LEFT: The feature is at the left edge.
=item GTK_POS_RIGHT: The feature is at the right edge.
=item GTK_POS_TOP: The feature is at the top edge.
=item GTK_POS_BOTTOM: The feature is at the bottom edge.


=end pod

#TE:1:GtkPositionType:
enum GtkPositionType is export (
  'GTK_POS_LEFT',
  'GTK_POS_RIGHT',
  'GTK_POS_TOP',
  'GTK_POS_BOTTOM'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkReliefStyle

Indicated the relief to be drawn around a B<Gnome::Gtk3::Button>.


=item GTK_RELIEF_NORMAL: Draw a normal relief.
=item GTK_RELIEF_HALF: A half relief. Deprecated in 3.14, does the same as I<GTK_RELIEF_NORMAL>
=item GTK_RELIEF_NONE: No relief.


=end pod

#TE:0:GtkReliefStyle:
enum GtkReliefStyle is export (
  'GTK_RELIEF_NORMAL',
  'GTK_RELIEF_HALF',
  'GTK_RELIEF_NONE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkScrollType

Scrolling types.


=item GTK_SCROLL_NONE: No scrolling.
=item GTK_SCROLL_JUMP: Jump to new location.
=item GTK_SCROLL_STEP_BACKWARD: Step backward.
=item GTK_SCROLL_STEP_FORWARD: Step forward.
=item GTK_SCROLL_PAGE_BACKWARD: Page backward.
=item GTK_SCROLL_PAGE_FORWARD: Page forward.
=item GTK_SCROLL_STEP_UP: Step up.
=item GTK_SCROLL_STEP_DOWN: Step down.
=item GTK_SCROLL_PAGE_UP: Page up.
=item GTK_SCROLL_PAGE_DOWN: Page down.
=item GTK_SCROLL_STEP_LEFT: Step to the left.
=item GTK_SCROLL_STEP_RIGHT: Step to the right.
=item GTK_SCROLL_PAGE_LEFT: Page to the left.
=item GTK_SCROLL_PAGE_RIGHT: Page to the right.
=item GTK_SCROLL_START: Scroll to start.
=item GTK_SCROLL_END: Scroll to end.


=end pod

#TE:0:GtkScrollType:
enum GtkScrollType is export (
  'GTK_SCROLL_NONE',
  'GTK_SCROLL_JUMP',
  'GTK_SCROLL_STEP_BACKWARD',
  'GTK_SCROLL_STEP_FORWARD',
  'GTK_SCROLL_PAGE_BACKWARD',
  'GTK_SCROLL_PAGE_FORWARD',
  'GTK_SCROLL_STEP_UP',
  'GTK_SCROLL_STEP_DOWN',
  'GTK_SCROLL_PAGE_UP',
  'GTK_SCROLL_PAGE_DOWN',
  'GTK_SCROLL_STEP_LEFT',
  'GTK_SCROLL_STEP_RIGHT',
  'GTK_SCROLL_PAGE_LEFT',
  'GTK_SCROLL_PAGE_RIGHT',
  'GTK_SCROLL_START',
  'GTK_SCROLL_END'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSelectionMode

Used to control what selections users are allowed to make.


=item GTK_SELECTION_NONE: No selection is possible.
=item GTK_SELECTION_SINGLE: Zero or one element may be selected.
=item GTK_SELECTION_BROWSE: Exactly one element is selected. In some circumstances, such as initially or during a search operation, it’s possible for no element to be selected with C<GTK_SELECTION_BROWSE>. What is really enforced is that the user can’t deselect a currently selected element except by selecting another element.
=item GTK_SELECTION_MULTIPLE: Any number of elements may be selected. The Ctrl key may be used to enlarge the selection, and Shift key to select between the focus and the child pointed to. Some widgets may also allow Click-drag to select a range of elements.


=end pod

#TE:0:GtkSelectionMode:
enum GtkSelectionMode is export (
  'GTK_SELECTION_NONE',
  'GTK_SELECTION_SINGLE',
  'GTK_SELECTION_BROWSE',
  'GTK_SELECTION_MULTIPLE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkShadowType

Used to change the appearance of an outline typically provided by a B<Gnome::Gtk3::Frame>.

Note that many themes do not differentiate the appearance of the
various shadow types: Either their is no visible shadow (I<GTK_SHADOW_NONE>),
or there is (any other value).


=item GTK_SHADOW_NONE: No outline.
=item GTK_SHADOW_IN: The outline is bevelled inwards.
=item GTK_SHADOW_OUT: The outline is bevelled outwards like a button.
=item GTK_SHADOW_ETCHED_IN: The outline has a sunken 3d appearance.
=item GTK_SHADOW_ETCHED_OUT: The outline has a raised 3d appearance.


=end pod

#TE:0:GtkShadowType:
enum GtkShadowType is export (
  'GTK_SHADOW_NONE',
  'GTK_SHADOW_IN',
  'GTK_SHADOW_OUT',
  'GTK_SHADOW_ETCHED_IN',
  'GTK_SHADOW_ETCHED_OUT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkStateType

This type indicates the current state of a widget; the state determines how
the widget is drawn. The B<Gnome::Gtk3::StateType> enumeration is also used to
identify different colors in a B<Gnome::Gtk3::Style> for drawing, so states can be
used for subparts of a widget as well as entire widgets.

Deprecated: 3.14: All APIs that are using this enumeration have been deprecated
in favor of alternatives using B<Gnome::Gtk3::StateFlags>.


=item GTK_STATE_NORMAL: State during normal operation.
=item GTK_STATE_ACTIVE: State of a currently active widget, such as a depressed button.
=item GTK_STATE_PRELIGHT: State indicating that the mouse pointer is over the widget and the widget will respond to mouse clicks.
=item GTK_STATE_SELECTED: State of a selected item, such the selected row in a list.
=item GTK_STATE_INSENSITIVE: State indicating that the widget is unresponsive to user actions.
=item GTK_STATE_INCONSISTENT: The widget is inconsistent, such as checkbuttons or radiobuttons that aren’t either set to C<1> nor C<0>, or buttons requiring the user attention.
=item GTK_STATE_FOCUSED: The widget has the keyboard focus.


=end pod

#TE:0:GtkStateType:
enum GtkStateType is export (
  'GTK_STATE_NORMAL',
  'GTK_STATE_ACTIVE',
  'GTK_STATE_PRELIGHT',
  'GTK_STATE_SELECTED',
  'GTK_STATE_INSENSITIVE',
  'GTK_STATE_INCONSISTENT',
  'GTK_STATE_FOCUSED'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkToolbarStyle

Used to customize the appearance of a B<Gnome::Gtk3::Toolbar>. Note that
setting the toolbar style overrides the user’s preferences
for the default toolbar style.  Note that if the button has only
a label set and GTK_TOOLBAR_ICONS is used, the label will be
visible, and vice versa.


=item GTK_TOOLBAR_ICONS: Buttons display only icons in the toolbar.
=item GTK_TOOLBAR_TEXT: Buttons display only text labels in the toolbar.
=item GTK_TOOLBAR_BOTH: Buttons display text and icons in the toolbar.
=item GTK_TOOLBAR_BOTH_HORIZ: Buttons display icons and text alongside each other, rather than vertically stacked


=end pod

#TE:0:GtkToolbarStyle:
enum GtkToolbarStyle is export (
  'GTK_TOOLBAR_ICONS',
  'GTK_TOOLBAR_TEXT',
  'GTK_TOOLBAR_BOTH',
  'GTK_TOOLBAR_BOTH_HORIZ'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkWrapMode

Describes a type of line wrapping.


=item GTK_WRAP_NONE: do not wrap lines; just make the text area wider
=item GTK_WRAP_CHAR: wrap text, breaking lines anywhere the cursor can appear (between characters, usually - if you want to be technical, between graphemes, see C<pango_get_log_attrs()>)
=item GTK_WRAP_WORD: wrap text, breaking lines in between words
=item GTK_WRAP_WORD_CHAR: wrap text, breaking lines in between words, or if that is not enough, also between graphemes


=end pod

#TE:0:GtkWrapMode:
enum GtkWrapMode is export (
  'GTK_WRAP_NONE',
  'GTK_WRAP_CHAR',
  'GTK_WRAP_WORD',
  'GTK_WRAP_WORD_CHAR'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSortType

Determines the direction of a sort.


=item GTK_SORT_ASCENDING: Sorting is in ascending order.
=item GTK_SORT_DESCENDING: Sorting is in descending order.


=end pod

#TE:0:GtkSortType:
enum GtkSortType is export (
  'GTK_SORT_ASCENDING',
  'GTK_SORT_DESCENDING'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIMPreeditStyle

Style for input method preedit. See also
 I<gtk-im-preedit-style>

Deprecated: 3.10


=item GTK_IM_PREEDIT_NOTHING: Deprecated
=item GTK_IM_PREEDIT_CALLBACK: Deprecated
=item GTK_IM_PREEDIT_NONE: Deprecated


=end pod

#TE:0:GtkIMPreeditStyle:
enum GtkIMPreeditStyle is export (
  'GTK_IM_PREEDIT_NOTHING',
  'GTK_IM_PREEDIT_CALLBACK',
  'GTK_IM_PREEDIT_NONE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIMStatusStyle

Style for input method status. See also
 I<gtk-im-status-style>

Deprecated: 3.10


=item GTK_IM_STATUS_NOTHING: Deprecated
=item GTK_IM_STATUS_CALLBACK: Deprecated
=item GTK_IM_STATUS_NONE: Deprecated


=end pod

#TE:0:GtkIMStatusStyle:
enum GtkIMStatusStyle is export (
  'GTK_IM_STATUS_NOTHING',
  'GTK_IM_STATUS_CALLBACK',
  'GTK_IM_STATUS_NONE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPackDirection

Determines how widgets should be packed inside menubars
and menuitems contained in menubars.


=item GTK_PACK_DIRECTION_LTR: Widgets are packed left-to-right
=item GTK_PACK_DIRECTION_RTL: Widgets are packed right-to-left
=item GTK_PACK_DIRECTION_TTB: Widgets are packed top-to-bottom
=item GTK_PACK_DIRECTION_BTT: Widgets are packed bottom-to-top


=end pod

#TE:0:GtkPackDirection:
enum GtkPackDirection is export (
  'GTK_PACK_DIRECTION_LTR',
  'GTK_PACK_DIRECTION_RTL',
  'GTK_PACK_DIRECTION_TTB',
  'GTK_PACK_DIRECTION_BTT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPrintPages

See also C<gtk_print_job_set_pages()>


=item GTK_PRINT_PAGES_ALL: All pages.
=item GTK_PRINT_PAGES_CURRENT: Current page.
=item GTK_PRINT_PAGES_RANGES: Range of pages.
=item GTK_PRINT_PAGES_SELECTION: Selected pages.


=end pod

#TE:0:GtkPrintPages:
enum GtkPrintPages is export (
  'GTK_PRINT_PAGES_ALL',
  'GTK_PRINT_PAGES_CURRENT',
  'GTK_PRINT_PAGES_RANGES',
  'GTK_PRINT_PAGES_SELECTION'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPageSet

See also C<gtk_print_job_set_page_set()>.


=item GTK_PAGE_SET_ALL: All pages.
=item GTK_PAGE_SET_EVEN: Even pages.
=item GTK_PAGE_SET_ODD: Odd pages.


=end pod

#TE:0:GtkPageSet:
enum GtkPageSet is export (
  'GTK_PAGE_SET_ALL',
  'GTK_PAGE_SET_EVEN',
  'GTK_PAGE_SET_ODD'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkNumberUpLayout

Used to determine the layout of pages on a sheet when printing
multiple pages per sheet.


=item GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM: ![](images/layout-lrtb.png)
=item GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP: ![](images/layout-lrbt.png)
=item GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM: ![](images/layout-rltb.png)
=item GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP: ![](images/layout-rlbt.png)
=item GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT: ![](images/layout-tblr.png)
=item GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT: ![](images/layout-tbrl.png)
=item GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT: ![](images/layout-btlr.png)
=item GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT: ![](images/layout-btrl.png)


=end pod

#TE:0:GtkNumberUpLayout:
enum GtkNumberUpLayout is export (
  'GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT';
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPageOrientation

See also C<gtk_print_settings_set_orientation()>.


=item GTK_PAGE_ORIENTATION_PORTRAIT: Portrait mode.
=item GTK_PAGE_ORIENTATION_LANDSCAPE: Landscape mode.
=item GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT: Reverse portrait mode.
=item GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE: Reverse landscape mode.


=end pod

#TE:0:GtkPageOrientation:
enum GtkPageOrientation is export (
  'GTK_PAGE_ORIENTATION_PORTRAIT',
  'GTK_PAGE_ORIENTATION_LANDSCAPE',
  'GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT',
  'GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPrintQuality

See also C<gtk_print_settings_set_quality()>.


=item GTK_PRINT_QUALITY_LOW: Low quality.
=item GTK_PRINT_QUALITY_NORMAL: Normal quality.
=item GTK_PRINT_QUALITY_HIGH: High quality.
=item GTK_PRINT_QUALITY_DRAFT: Draft quality.


=end pod

#TE:0:GtkPrintQuality:
enum GtkPrintQuality is export (
  'GTK_PRINT_QUALITY_LOW',
  'GTK_PRINT_QUALITY_NORMAL',
  'GTK_PRINT_QUALITY_HIGH',
  'GTK_PRINT_QUALITY_DRAFT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPrintDuplex

See also C<gtk_print_settings_set_duplex()>.


=item GTK_PRINT_DUPLEX_SIMPLEX: No duplex.
=item GTK_PRINT_DUPLEX_HORIZONTAL: Horizontal duplex.
=item GTK_PRINT_DUPLEX_VERTICAL: Vertical duplex.


=end pod

#TE:0:GtkPrintDuplex:
enum GtkPrintDuplex is export (
  'GTK_PRINT_DUPLEX_SIMPLEX',
  'GTK_PRINT_DUPLEX_HORIZONTAL',
  'GTK_PRINT_DUPLEX_VERTICAL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkUnit

See also C<gtk_print_settings_set_paper_width()>.


=item GTK_UNIT_NONE: No units.
=item GTK_UNIT_POINTS: Dimensions in points.
=item GTK_UNIT_INCH: Dimensions in inches.
=item GTK_UNIT_MM: Dimensions in millimeters


=end pod

#TE:0:GtkUnit:
enum GtkUnit is export (
  'GTK_UNIT_NONE',
  'GTK_UNIT_POINTS',
  'GTK_UNIT_INCH',
  'GTK_UNIT_MM'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTreeViewGridLines

Used to indicate which grid lines to draw in a tree view.


=item GTK_TREE_VIEW_GRID_LINES_NONE: No grid lines.
=item GTK_TREE_VIEW_GRID_LINES_HORIZONTAL: Horizontal grid lines.
=item GTK_TREE_VIEW_GRID_LINES_VERTICAL: Vertical grid lines.
=item GTK_TREE_VIEW_GRID_LINES_BOTH: Horizontal and vertical grid lines.


=end pod

#TE:0:GtkTreeViewGridLines:
enum GtkTreeViewGridLines is export (
  'GTK_TREE_VIEW_GRID_LINES_NONE',
  'GTK_TREE_VIEW_GRID_LINES_HORIZONTAL',
  'GTK_TREE_VIEW_GRID_LINES_VERTICAL',
  'GTK_TREE_VIEW_GRID_LINES_BOTH'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkDragResult

Gives an indication why a drag operation failed. The value can by obtained by connecting to the  I<drag-failed> signal.

=item GTK_DRAG_RESULT_SUCCESS: The drag operation was successful.
=item GTK_DRAG_RESULT_NO_TARGET: No suitable drag target.
=item GTK_DRAG_RESULT_USER_CANCELLED: The user cancelled the drag operation.
=item GTK_DRAG_RESULT_TIMEOUT_EXPIRED: The drag operation timed out.
=item GTK_DRAG_RESULT_GRAB_BROKEN: The pointer or keyboard grab used for the drag operation was broken.
=item GTK_DRAG_RESULT_ERROR: The drag operation failed due to some unspecified error.

=end pod

#TE:1:GtkDragResult:
enum GtkDragResult is export (
  'GTK_DRAG_RESULT_SUCCESS',
  'GTK_DRAG_RESULT_NO_TARGET',
  'GTK_DRAG_RESULT_USER_CANCELLED',
  'GTK_DRAG_RESULT_TIMEOUT_EXPIRED',
  'GTK_DRAG_RESULT_GRAB_BROKEN',
  'GTK_DRAG_RESULT_ERROR'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSizeGroupMode

The mode of the size group determines the directions in which the size
group affects the requested sizes of its component widgets.


=item GTK_SIZE_GROUP_NONE: group has no effect
=item GTK_SIZE_GROUP_HORIZONTAL: group affects horizontal requisition
=item GTK_SIZE_GROUP_VERTICAL: group affects vertical requisition
=item GTK_SIZE_GROUP_BOTH: group affects both horizontal and vertical requisition


=end pod

#TE:0:GtkSizeGroupMode:
enum GtkSizeGroupMode is export (
  'GTK_SIZE_GROUP_NONE',
  'GTK_SIZE_GROUP_HORIZONTAL',
  'GTK_SIZE_GROUP_VERTICAL',
  'GTK_SIZE_GROUP_BOTH'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSizeRequestMode

Specifies a preference for height-for-width or
width-for-height geometry management.


=item GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH: Prefer height-for-width geometry management
=item GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT: Prefer width-for-height geometry management
=item GTK_SIZE_REQUEST_CONSTANT_SIZE: Don’t trade height-for-width or width-for-height


=end pod

#TE:2:GtkSizeRequestMode:Widget.t
enum GtkSizeRequestMode is export (
  'GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH' => 0,
  'GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT',
  'GTK_SIZE_REQUEST_CONSTANT_SIZE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkScrollablePolicy

Defines the policy to be used in a scrollable widget when updating
the scrolled window adjustments in a given orientation.


=item GTK_SCROLL_MINIMUM: Scrollable adjustments are based on the minimum size
=item GTK_SCROLL_NATURAL: Scrollable adjustments are based on the natural size


=end pod

#TE:0:GtkScrollablePolicy:
enum GtkScrollablePolicy is export (
  'GTK_SCROLL_MINIMUM' => 0,
  'GTK_SCROLL_NATURAL'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkStateFlags

Describes a widget state. Widget states are used to match the widget
against CSS pseudo-classes. Note that GTK extends the regular CSS
classes and sometimes uses different names.


=item GTK_STATE_FLAG_NORMAL: State during normal operation.
=item GTK_STATE_FLAG_ACTIVE: Widget is active.
=item GTK_STATE_FLAG_PRELIGHT: Widget has a mouse pointer over it.
=item GTK_STATE_FLAG_SELECTED: Widget is selected.
=item GTK_STATE_FLAG_INSENSITIVE: Widget is insensitive.
=item GTK_STATE_FLAG_INCONSISTENT: Widget is inconsistent.
=item GTK_STATE_FLAG_FOCUSED: Widget has the keyboard focus.
=item GTK_STATE_FLAG_BACKDROP: Widget is in a background toplevel window.
=item GTK_STATE_FLAG_DIR_LTR: Widget is in left-to-right text direction. Since 3.8
=item GTK_STATE_FLAG_DIR_RTL: Widget is in right-to-left text direction. Since 3.8
=item GTK_STATE_FLAG_LINK: Widget is a link. Since 3.12
=item GTK_STATE_FLAG_VISITED: The location the widget points to has already been visited. Since 3.12
=item GTK_STATE_FLAG_CHECKED: Widget is checked. Since 3.14
=item GTK_STATE_FLAG_DROP_ACTIVE: Widget is highlighted as a drop target for DND. Since 3.20


=end pod

#TE:2:GtkStateFlags:WidgetPath.t
enum GtkStateFlags is export (
  'GTK_STATE_FLAG_NORMAL'       => 0,
  'GTK_STATE_FLAG_ACTIVE'       => 1 +< 0,
  'GTK_STATE_FLAG_PRELIGHT'     => 1 +< 1,
  'GTK_STATE_FLAG_SELECTED'     => 1 +< 2,
  'GTK_STATE_FLAG_INSENSITIVE'  => 1 +< 3,
  'GTK_STATE_FLAG_INCONSISTENT' => 1 +< 4,
  'GTK_STATE_FLAG_FOCUSED'      => 1 +< 5,
  'GTK_STATE_FLAG_BACKDROP'     => 1 +< 6,
  'GTK_STATE_FLAG_DIR_LTR'      => 1 +< 7,
  'GTK_STATE_FLAG_DIR_RTL'      => 1 +< 8,
  'GTK_STATE_FLAG_LINK'         => 1 +< 9,
  'GTK_STATE_FLAG_VISITED'      => 1 +< 10,
  'GTK_STATE_FLAG_CHECKED'      => 1 +< 11,
  'GTK_STATE_FLAG_DROP_ACTIVE'  => 1 +< 12
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkRegionFlags

Describes a region within a widget.


=item GTK_REGION_EVEN: Region has an even number within a set.
=item GTK_REGION_ODD: Region has an odd number within a set.
=item GTK_REGION_FIRST: Region is the first one within a set.
=item GTK_REGION_LAST: Region is the last one within a set.
=item GTK_REGION_ONLY: Region is the only one within a set.
=item GTK_REGION_SORTED: Region is part of a sorted area.


=end pod

#TE:0:GtkRegionFlags:
enum GtkRegionFlags is export (
  'GTK_REGION_EVEN'    => 1 +< 0,
  'GTK_REGION_ODD'     => 1 +< 1,
  'GTK_REGION_FIRST'   => 1 +< 2,
  'GTK_REGION_LAST'    => 1 +< 3,
  'GTK_REGION_ONLY'    => 1 +< 4,
  'GTK_REGION_SORTED'  => 1 +< 5
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkJunctionSides

Describes how a rendered element connects to adjacent elements.


=item GTK_JUNCTION_NONE: No junctions.
=item GTK_JUNCTION_CORNER_TOPLEFT: Element connects on the top-left corner.
=item GTK_JUNCTION_CORNER_TOPRIGHT: Element connects on the top-right corner.
=item GTK_JUNCTION_CORNER_BOTTOMLEFT: Element connects on the bottom-left corner.
=item GTK_JUNCTION_CORNER_BOTTOMRIGHT: Element connects on the bottom-right corner.
=item GTK_JUNCTION_TOP: Element connects on the top side.
=item GTK_JUNCTION_BOTTOM: Element connects on the bottom side.
=item GTK_JUNCTION_LEFT: Element connects on the left side.
=item GTK_JUNCTION_RIGHT: Element connects on the right side.


=end pod

#TE:0:GtkJunctionSides:
enum GtkJunctionSides is export (
  'GTK_JUNCTION_NONE'   => 0,
  'GTK_JUNCTION_CORNER_TOPLEFT' =>      0x01,
  'GTK_JUNCTION_CORNER_TOPRIGHT' =>     0x02,
  'GTK_JUNCTION_CORNER_BOTTOMLEFT' =>   0x04,
  'GTK_JUNCTION_CORNER_BOTTOMRIGHT' =>  0x08,
  'GTK_JUNCTION_TOP'    =>              0x03, # TOPLEFT +| TOPRIGHT
  'GTK_JUNCTION_BOTTOM' =>              0x0C, # BOTTOMLEFT +| BOTTOMRIGHT
  'GTK_JUNCTION_LEFT'   =>              0x05, # TOPLEFT +| BOTTOMLEFT
  'GTK_JUNCTION_RIGHT'  =>              0x0A, # TOPRIGHT +| BOTTOMRIGHT
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkBorderStyle

Describes how the border of a UI element should be rendered.


=item GTK_BORDER_STYLE_NONE: No visible border
=item GTK_BORDER_STYLE_SOLID: A single line segment
=item GTK_BORDER_STYLE_INSET: Looks as if the content is sunken into the canvas
=item GTK_BORDER_STYLE_OUTSET: Looks as if the content is coming out of the canvas
=item GTK_BORDER_STYLE_HIDDEN: Same as I<GTK_BORDER_STYLE_NONE>
=item GTK_BORDER_STYLE_DOTTED: A series of round dots
=item GTK_BORDER_STYLE_DASHED: A series of square-ended dashes
=item GTK_BORDER_STYLE_DOUBLE: Two parallel lines with some space between them
=item GTK_BORDER_STYLE_GROOVE: Looks as if it were carved in the canvas
=item GTK_BORDER_STYLE_RIDGE: Looks as if it were coming out of the canvas


=end pod

#TE:0:GtkBorderStyle:
enum GtkBorderStyle is export (
  'GTK_BORDER_STYLE_NONE',
  'GTK_BORDER_STYLE_SOLID',
  'GTK_BORDER_STYLE_INSET',
  'GTK_BORDER_STYLE_OUTSET',
  'GTK_BORDER_STYLE_HIDDEN',
  'GTK_BORDER_STYLE_DOTTED',
  'GTK_BORDER_STYLE_DASHED',
  'GTK_BORDER_STYLE_DOUBLE',
  'GTK_BORDER_STYLE_GROOVE',
  'GTK_BORDER_STYLE_RIDGE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkLevelBarMode

Describes how B<Gnome::Gtk3::LevelBar> contents should be rendered.
Note that this enumeration could be extended with additional modes
in the future.

Since: 3.6


=item GTK_LEVEL_BAR_MODE_CONTINUOUS: the bar has a continuous mode
=item GTK_LEVEL_BAR_MODE_DISCRETE: the bar has a discrete mode


=end pod

#TE:0:GtkLevelBarMode:
enum GtkLevelBarMode is export (
  'GTK_LEVEL_BAR_MODE_CONTINUOUS',
  'GTK_LEVEL_BAR_MODE_DISCRETE'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkInputPurpose

Describes primary purpose of the input widget. This information is
useful for on-screen keyboards and similar input methods to decide
which keys should be presented to the user.

Note that the purpose is not meant to impose a totally strict rule
about allowed characters, and does not replace input validation.
It is fine for an on-screen keyboard to let the user override the
character set restriction that is expressed by the purpose. The
application is expected to validate the entry contents, even if
it specified a purpose.

The difference between I<GTK_INPUT_PURPOSE_DIGITS> and
I<GTK_INPUT_PURPOSE_NUMBER> is that the former accepts only digits
while the latter also some punctuation (like commas or points, plus,
minus) and “e” or “E” as in 3.14E+000.

This enumeration may be extended in the future; input methods should
interpret unknown values as “free form”.

Since: 3.6


=item GTK_INPUT_PURPOSE_FREE_FORM: Allow any character
=item GTK_INPUT_PURPOSE_ALPHA: Allow only alphabetic characters
=item GTK_INPUT_PURPOSE_DIGITS: Allow only digits
=item GTK_INPUT_PURPOSE_NUMBER: Edited field expects numbers
=item GTK_INPUT_PURPOSE_PHONE: Edited field expects phone number
=item GTK_INPUT_PURPOSE_URL: Edited field expects URL
=item GTK_INPUT_PURPOSE_EMAIL: Edited field expects email address
=item GTK_INPUT_PURPOSE_NAME: Edited field expects the name of a person
=item GTK_INPUT_PURPOSE_PASSWORD: Like I<GTK_INPUT_PURPOSE_FREE_FORM>, but characters are hidden
=item GTK_INPUT_PURPOSE_PIN: Like I<GTK_INPUT_PURPOSE_DIGITS>, but characters are hidden


=end pod

#TE:0:GtkInputPurpose:
enum GtkInputPurpose is export (
  'GTK_INPUT_PURPOSE_FREE_FORM',
  'GTK_INPUT_PURPOSE_ALPHA',
  'GTK_INPUT_PURPOSE_DIGITS',
  'GTK_INPUT_PURPOSE_NUMBER',
  'GTK_INPUT_PURPOSE_PHONE',
  'GTK_INPUT_PURPOSE_URL',
  'GTK_INPUT_PURPOSE_EMAIL',
  'GTK_INPUT_PURPOSE_NAME',
  'GTK_INPUT_PURPOSE_PASSWORD',
  'GTK_INPUT_PURPOSE_PIN'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkInputHints

Describes hints that might be taken into account by input methods
or applications. Note that input methods may already tailor their
behaviour according to the B<Gnome::Gtk3::InputPurpose> of the entry.

Some common sense is expected when using these flags - mixing
I<GTK_INPUT_HINT_LOWERCASE> with any of the uppercase hints makes no sense.

This enumeration may be extended in the future; input methods should
ignore unknown values.

Since: 3.6


=item GTK_INPUT_HINT_NONE: No special behaviour suggested
=item GTK_INPUT_HINT_SPELLCHECK: Suggest checking for typos
=item GTK_INPUT_HINT_NO_SPELLCHECK: Suggest not checking for typos
=item GTK_INPUT_HINT_WORD_COMPLETION: Suggest word completion
=item GTK_INPUT_HINT_LOWERCASE: Suggest to convert all text to lowercase
=item GTK_INPUT_HINT_UPPERCASE_CHARS: Suggest to capitalize all text
=item GTK_INPUT_HINT_UPPERCASE_WORDS: Suggest to capitalize the first character of each word
=item GTK_INPUT_HINT_UPPERCASE_SENTENCES: Suggest to capitalize the first word of each sentence
=item GTK_INPUT_HINT_INHIBIT_OSK: Suggest to not show an onscreen keyboard (e.g for a calculator that already has all the keys).
=item GTK_INPUT_HINT_VERTICAL_WRITING: The text is vertical. Since 3.18
=item GTK_INPUT_HINT_EMOJI: Suggest offering Emoji support. Since 3.22.20
=item GTK_INPUT_HINT_NO_EMOJI: Suggest not offering Emoji support. Since 3.22.20


=end pod

#TE:0:GtkInputHints:
enum GtkInputHints is export (
  'GTK_INPUT_HINT_NONE'                => 0,
  'GTK_INPUT_HINT_SPELLCHECK'          => 1 +< 0,
  'GTK_INPUT_HINT_NO_SPELLCHECK'       => 1 +< 1,
  'GTK_INPUT_HINT_WORD_COMPLETION'     => 1 +< 2,
  'GTK_INPUT_HINT_LOWERCASE'           => 1 +< 3,
  'GTK_INPUT_HINT_UPPERCASE_CHARS'     => 1 +< 4,
  'GTK_INPUT_HINT_UPPERCASE_WORDS'     => 1 +< 5,
  'GTK_INPUT_HINT_UPPERCASE_SENTENCES' => 1 +< 6,
  'GTK_INPUT_HINT_INHIBIT_OSK'         => 1 +< 7,
  'GTK_INPUT_HINT_VERTICAL_WRITING'    => 1 +< 8,
  'GTK_INPUT_HINT_EMOJI'               => 1 +< 9,
  'GTK_INPUT_HINT_NO_EMOJI'            => 1 +< 10
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPropagationPhase

Describes the stage at which events are fed into a B<Gnome::Gtk3::EventController>.

Since: 3.14


=item GTK_PHASE_NONE: Events are not delivered automatically. Those can be manually fed through C<gtk_event_controller_handle_event()>. This should only be used when full control about when, or whether the controller handles the event is needed.
=item GTK_PHASE_CAPTURE: Events are delivered in the capture phase. The capture phase happens before the bubble phase, runs from the toplevel down to the event widget. This option should only be used on containers that might possibly handle events before their children do.
=item GTK_PHASE_BUBBLE: Events are delivered in the bubble phase. The bubble phase happens after the capture phase, and before the default handlers are run. This phase runs from the event widget, up to the toplevel.
=item GTK_PHASE_TARGET: Events are delivered in the default widget event handlers, note that widget implementations must chain up on button, motion, touch and grab broken handlers for controllers in this phase to be run.


=end pod

#TE:0:GtkPropagationPhase:
enum GtkPropagationPhase is export (
  'GTK_PHASE_NONE',
  'GTK_PHASE_CAPTURE',
  'GTK_PHASE_BUBBLE',
  'GTK_PHASE_TARGET'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkEventSequenceState

Describes the state of a B<Gnome::Gdk3::EventSequence> in a B<Gnome::Gtk3::Gesture>.

Since: 3.14


=item GTK_EVENT_SEQUENCE_NONE: The sequence is handled, but not grabbed.
=item GTK_EVENT_SEQUENCE_CLAIMED: The sequence is handled and grabbed.
=item GTK_EVENT_SEQUENCE_DENIED: The sequence is denied.


=end pod

#TE:0:GtkEventSequenceState:
enum GtkEventSequenceState is export (
  'GTK_EVENT_SEQUENCE_NONE',
  'GTK_EVENT_SEQUENCE_CLAIMED',
  'GTK_EVENT_SEQUENCE_DENIED'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPanDirection

Describes the panning direction of a B<Gnome::Gtk3::GesturePan>

Since: 3.14


=item GTK_PAN_DIRECTION_LEFT: panned towards the left
=item GTK_PAN_DIRECTION_RIGHT: panned towards the right
=item GTK_PAN_DIRECTION_UP: panned upwards
=item GTK_PAN_DIRECTION_DOWN: panned downwards


=end pod

#TE:0:GtkPanDirection:
enum GtkPanDirection is export (
  'GTK_PAN_DIRECTION_LEFT',
  'GTK_PAN_DIRECTION_RIGHT',
  'GTK_PAN_DIRECTION_UP',
  'GTK_PAN_DIRECTION_DOWN'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPopoverConstraint

Describes constraints to positioning of popovers. More values
may be added to this enumeration in the future.

Since: 3.20


=item GTK_POPOVER_CONSTRAINT_NONE: Don't constrain the popover position beyond what is imposed by the implementation
=item GTK_POPOVER_CONSTRAINT_WINDOW: Constrain the popover to the boundaries of the window that it is attached to


=end pod

#TE:0:GtkPopoverConstraint:
enum GtkPopoverConstraint is export (
  'GTK_POPOVER_CONSTRAINT_NONE',
  'GTK_POPOVER_CONSTRAINT_WINDOW'
);



































=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

=begin pod
=head2 enum GtkAlign

Controls how a widget deals with extra space in a single (x or y)
dimension.

Alignment only matters if the widget receives a “too large” allocation,
for example if you packed the widget with the prop C<expand>
flag inside a C<Gnome::Gtk3::Box>, then the widget might get extra space.  If
you have for example a 16x16 icon inside a 32x32 space, the icon
could be scaled and stretched, it could be centered, or it could be
positioned to one side of the space.

Note that in horizontal context I<GTK_ALIGN_START> and I<GTK_ALIGN_END>
are interpreted relative to text direction.

GTK_ALIGN_BASELINE support for it is optional for containers and widgets, and
it is only supported for vertical alignment.  When its not supported by
a child or a container it is treated as I<GTK_ALIGN_FILL>.


=item Short_description: Public enumerated types used throughout GTK+
=item Title: Standard Enumerations
=item GTK_ALIGN_FILL: stretch to fill all space if possible, center if no meaningful way to stretch
=item GTK_ALIGN_START: snap to left or top side, leaving space on right or bottom
=item GTK_ALIGN_END: snap to right or bottom side, leaving space on left or top
=item GTK_ALIGN_CENTER: center natural width of widget inside the allocation
=item GTK_ALIGN_BASELINE: align the widget according to the baseline. Since 3.10.


=end pod

enum GtkAlign is export (
  'GTK_ALIGN_FILL',
  'GTK_ALIGN_START',
  'GTK_ALIGN_END',
  'GTK_ALIGN_CENTER',
  'GTK_ALIGN_BASELINE'
);


=begin pod
=head2 enum GtkArrowType

Used to indicate the direction in which an arrow should point.


=item GTK_ARROW_UP: Represents an upward pointing arrow.
=item GTK_ARROW_DOWN: Represents a downward pointing arrow.
=item GTK_ARROW_LEFT: Represents a left pointing arrow.
=item GTK_ARROW_RIGHT: Represents a right pointing arrow.
=item GTK_ARROW_NONE: No arrow. Since 2.10.


=end pod

enum GtkArrowType is export (
  'GTK_ARROW_UP',
  'GTK_ARROW_DOWN',
  'GTK_ARROW_LEFT',
  'GTK_ARROW_RIGHT',
  'GTK_ARROW_NONE'
);


=begin pod
=head2 enum GtkBaselinePosition

Whenever a container has some form of natural row it may align
children in that row along a common typographical baseline. If
the amount of verical space in the row is taller than the total
requested height of the baseline-aligned children then it can use a
C<Gnome::Gtk3::BaselinePosition> to select where to put the baseline inside the
extra availible space.

Since: 3.10


=item GTK_BASELINE_POSITION_TOP: Align the baseline at the top
=item GTK_BASELINE_POSITION_CENTER: Center the baseline
=item GTK_BASELINE_POSITION_BOTTOM: Align the baseline at the bottom


=end pod

enum GtkBaselinePosition is export (
  'GTK_BASELINE_POSITION_TOP',
  'GTK_BASELINE_POSITION_CENTER',
  'GTK_BASELINE_POSITION_BOTTOM'
);


=begin pod
=head2 enum GtkDeleteType

See also: sig C<delete-from-cursor>.


=item GTK_DELETE_CHARS: Delete characters.
=item GTK_DELETE_WORD_ENDS: Delete only the portion of the word to the left/right of cursor if we’re in the middle of a word.
=item GTK_DELETE_WORDS: Delete words.
=item GTK_DELETE_DISPLAY_LINES: Delete display-lines. Display-lines refers to the visible lines, with respect to to the current line breaks. As opposed to paragraphs, which are defined by line breaks in the input.
=item GTK_DELETE_DISPLAY_LINE_ENDS: Delete only the portion of the display-line to the left/right of cursor.
=item GTK_DELETE_PARAGRAPH_ENDS: Delete to the end of the paragraph. Like C-k in Emacs (or its reverse).
=item GTK_DELETE_PARAGRAPHS: Delete entire line. Like C-k in pico.
=item GTK_DELETE_WHITESPACE: Delete only whitespace. Like M-\ in Emacs.


=end pod

enum GtkDeleteType is export (
  'GTK_DELETE_CHARS',
  'GTK_DELETE_WORD_ENDS',
  'GTK_DELETE_WORDS',
  'GTK_DELETE_DISPLAY_LINES',
  'GTK_DELETE_DISPLAY_LINE_ENDS',
  'GTK_DELETE_PARAGRAPH_ENDS',
  'GTK_DELETE_PARAGRAPHS',
  'GTK_DELETE_WHITESPACE'
);


=begin pod
=head2 enum GtkDirectionType

Focus movement types.

=item GTK_DIR_TAB_FORWARD: Move forward.
=item GTK_DIR_TAB_BACKWARD: Move backward.
=item GTK_DIR_UP: Move up.
=item GTK_DIR_DOWN: Move down.
=item GTK_DIR_LEFT: Move left.
=item GTK_DIR_RIGHT: Move right.

=end pod

enum GtkDirectionType is export (
  'GTK_DIR_TAB_FORWARD',
  'GTK_DIR_TAB_BACKWARD',
  'GTK_DIR_UP',
  'GTK_DIR_DOWN',
  'GTK_DIR_LEFT',
  'GTK_DIR_RIGHT'
);


=begin pod
=head2 enum GtkIconSize

Built-in stock icon sizes.


=item GTK_ICON_SIZE_INVALID: Invalid size.
=item GTK_ICON_SIZE_MENU: Size appropriate for menus (16px).
=item GTK_ICON_SIZE_SMALL_TOOLBAR: Size appropriate for small toolbars (16px).
=item GTK_ICON_SIZE_LARGE_TOOLBAR: Size appropriate for large toolbars (24px)
=item GTK_ICON_SIZE_BUTTON: Size appropriate for buttons (16px)
=item GTK_ICON_SIZE_DND: Size appropriate for drag and drop (32px)
=item GTK_ICON_SIZE_DIALOG: Size appropriate for dialogs (48px)


=end pod

enum GtkIconSize is export (
  'GTK_ICON_SIZE_INVALID',
  'GTK_ICON_SIZE_MENU',
  'GTK_ICON_SIZE_SMALL_TOOLBAR',
  'GTK_ICON_SIZE_LARGE_TOOLBAR',
  'GTK_ICON_SIZE_BUTTON',
  'GTK_ICON_SIZE_DND',
  'GTK_ICON_SIZE_DIALOG'
);


=begin pod
=head2 enum GtkSensitivityType

Determines how GTK+ handles the sensitivity of stepper arrows
at the end of range widgets.


=item GTK_SENSITIVITY_AUTO: The arrow is made insensitive if the thumb is at the end
=item GTK_SENSITIVITY_ON: The arrow is always sensitive
=item GTK_SENSITIVITY_OFF: The arrow is always insensitive


=end pod

enum GtkSensitivityType is export (
  'GTK_SENSITIVITY_AUTO',
  'GTK_SENSITIVITY_ON',
  'GTK_SENSITIVITY_OFF'
);


=begin pod
=head2 enum GtkTextDirection

Reading directions for text.


=item GTK_TEXT_DIR_NONE: No direction.
=item GTK_TEXT_DIR_LTR: Left to right text direction.
=item GTK_TEXT_DIR_RTL: Right to left text direction.


=end pod

enum GtkTextDirection is export (
  'GTK_TEXT_DIR_NONE',
  'GTK_TEXT_DIR_LTR',
  'GTK_TEXT_DIR_RTL'
);


=begin pod
=head2 enum GtkJustification

Used for justifying the text inside a C<Gnome::Gtk3::Label> widget. (See also
C<Gnome::Gtk3::Alignment>).


=item GTK_JUSTIFY_LEFT: The text is placed at the left edge of the label.
=item GTK_JUSTIFY_RIGHT: The text is placed at the right edge of the label.
=item GTK_JUSTIFY_CENTER: The text is placed in the center of the label.
=item GTK_JUSTIFY_FILL: The text is placed is distributed across the label.


=end pod

enum GtkJustification is export (
  'GTK_JUSTIFY_LEFT',
  'GTK_JUSTIFY_RIGHT',
  'GTK_JUSTIFY_CENTER',
  'GTK_JUSTIFY_FILL'
);


=begin pod
=head2 enum GtkMenuDirectionType

An enumeration representing directional movements within a menu.


=item GTK_MENU_DIR_PARENT: To the parent menu shell
=item GTK_MENU_DIR_CHILD: To the submenu, if any, associated with the item
=item GTK_MENU_DIR_NEXT: To the next menu item
=item GTK_MENU_DIR_PREV: To the previous menu item


=end pod

enum GtkMenuDirectionType is export (
  'GTK_MENU_DIR_PARENT',
  'GTK_MENU_DIR_CHILD',
  'GTK_MENU_DIR_NEXT',
  'GTK_MENU_DIR_PREV'
);


=begin pod
=head2 enum GtkMessageType

The type of message being displayed in the dialog.


=item GTK_MESSAGE_INFO: Informational message
=item GTK_MESSAGE_WARNING: Non-fatal warning message
=item GTK_MESSAGE_QUESTION: Question requiring a choice
=item GTK_MESSAGE_ERROR: Fatal error message
=item GTK_MESSAGE_OTHER: None of the above


=end pod

enum GtkMessageType is export (
  'GTK_MESSAGE_INFO',
  'GTK_MESSAGE_WARNING',
  'GTK_MESSAGE_QUESTION',
  'GTK_MESSAGE_ERROR',
  'GTK_MESSAGE_OTHER'
);


=begin pod
=head2 enum GtkMovementStep




=item GTK_MOVEMENT_LOGICAL_POSITIONS: Move forward or back by graphemes
=item GTK_MOVEMENT_VISUAL_POSITIONS:  Move left or right by graphemes
=item GTK_MOVEMENT_WORDS:             Move forward or back by words
=item GTK_MOVEMENT_DISPLAY_LINES:     Move up or down lines (wrapped lines)
=item GTK_MOVEMENT_DISPLAY_LINE_ENDS: Move to either end of a line
=item GTK_MOVEMENT_PARAGRAPHS:        Move up or down paragraphs (newline-ended lines)
=item GTK_MOVEMENT_PARAGRAPH_ENDS:    Move to either end of a paragraph
=item GTK_MOVEMENT_PAGES:             Move by pages
=item GTK_MOVEMENT_BUFFER_ENDS:       Move to ends of the buffer
=item GTK_MOVEMENT_HORIZONTAL_PAGES:  Move horizontally by pages


=end pod

enum GtkMovementStep is export (
  'GTK_MOVEMENT_LOGICAL_POSITIONS',
  'GTK_MOVEMENT_VISUAL_POSITIONS',
  'GTK_MOVEMENT_WORDS',
  'GTK_MOVEMENT_DISPLAY_LINES',
  'GTK_MOVEMENT_DISPLAY_LINE_ENDS',
  'GTK_MOVEMENT_PARAGRAPHS',
  'GTK_MOVEMENT_PARAGRAPH_ENDS',
  'GTK_MOVEMENT_PAGES',
  'GTK_MOVEMENT_BUFFER_ENDS',
  'GTK_MOVEMENT_HORIZONTAL_PAGES'
);


=begin pod
=head2 enum GtkScrollStep




=item GTK_SCROLL_STEPS: Scroll in steps.
=item GTK_SCROLL_PAGES: Scroll by pages.
=item GTK_SCROLL_ENDS: Scroll to ends.
=item GTK_SCROLL_HORIZONTAL_STEPS: Scroll in horizontal steps.
=item GTK_SCROLL_HORIZONTAL_PAGES: Scroll by horizontal pages.
=item GTK_SCROLL_HORIZONTAL_ENDS: Scroll to the horizontal ends.


=end pod

enum GtkScrollStep is export (
  'GTK_SCROLL_STEPS',
  'GTK_SCROLL_PAGES',
  'GTK_SCROLL_ENDS',
  'GTK_SCROLL_HORIZONTAL_STEPS',
  'GTK_SCROLL_HORIZONTAL_PAGES',
  'GTK_SCROLL_HORIZONTAL_ENDS'
);


=begin pod
=head2 enum GtkOrientation

Represents the orientation of widgets and other objects which can be switched
between horizontal and vertical orientation on the fly, like C<Gnome::Gtk3::Toolbar> or
C<Gnome::Gtk3::GesturePan>.


=item GTK_ORIENTATION_HORIZONTAL: The element is in horizontal orientation.
=item GTK_ORIENTATION_VERTICAL: The element is in vertical orientation.


=end pod

enum GtkOrientation is export (
  'GTK_ORIENTATION_HORIZONTAL',
  'GTK_ORIENTATION_VERTICAL'
);


=begin pod
=head2 enum GtkPackType

Represents the packing location C<Gnome::Gtk3::Box> children. (See: C<Gnome::Gtk3::VBox>,
C<Gnome::Gtk3::HBox>, and C<Gnome::Gtk3::ButtonBox>).


=item GTK_PACK_START: The child is packed into the start of the box
=item GTK_PACK_END: The child is packed into the end of the box


=end pod

enum GtkPackType is export (
  'GTK_PACK_START',
  'GTK_PACK_END'
);


=begin pod
=head2 enum GtkPositionType

Describes which edge of a widget a certain feature is positioned at, e.g. the
tabs of a C<Gnome::Gtk3::Notebook>, the handle of a C<Gnome::Gtk3::HandleBox> or the label of a
C<Gnome::Gtk3::Scale>.


=item GTK_POS_LEFT: The feature is at the left edge.
=item GTK_POS_RIGHT: The feature is at the right edge.
=item GTK_POS_TOP: The feature is at the top edge.
=item GTK_POS_BOTTOM: The feature is at the bottom edge.


=end pod

enum GtkPositionType is export (
  'GTK_POS_LEFT',
  'GTK_POS_RIGHT',
  'GTK_POS_TOP',
  'GTK_POS_BOTTOM'
);


=begin pod
=head2 enum GtkReliefStyle

Indicated the relief to be drawn around a C<Gnome::Gtk3::Button>.


=item GTK_RELIEF_NORMAL: Draw a normal relief.
=item GTK_RELIEF_HALF: A half relief. Deprecated in 3.14, does the same as I<GTK_RELIEF_NORMAL>
=item GTK_RELIEF_NONE: No relief.


=end pod

enum GtkReliefStyle is export (
  'GTK_RELIEF_NORMAL',
  'GTK_RELIEF_HALF',
  'GTK_RELIEF_NONE'
);


=begin pod
=head2 enum GtkScrollType

Scrolling types.


=item GTK_SCROLL_NONE: No scrolling.
=item GTK_SCROLL_JUMP: Jump to new location.
=item GTK_SCROLL_STEP_BACKWARD: Step backward.
=item GTK_SCROLL_STEP_FORWARD: Step forward.
=item GTK_SCROLL_PAGE_BACKWARD: Page backward.
=item GTK_SCROLL_PAGE_FORWARD: Page forward.
=item GTK_SCROLL_STEP_UP: Step up.
=item GTK_SCROLL_STEP_DOWN: Step down.
=item GTK_SCROLL_PAGE_UP: Page up.
=item GTK_SCROLL_PAGE_DOWN: Page down.
=item GTK_SCROLL_STEP_LEFT: Step to the left.
=item GTK_SCROLL_STEP_RIGHT: Step to the right.
=item GTK_SCROLL_PAGE_LEFT: Page to the left.
=item GTK_SCROLL_PAGE_RIGHT: Page to the right.
=item GTK_SCROLL_START: Scroll to start.
=item GTK_SCROLL_END: Scroll to end.


=end pod

enum GtkScrollType is export (
  'GTK_SCROLL_NONE',
  'GTK_SCROLL_JUMP',
  'GTK_SCROLL_STEP_BACKWARD',
  'GTK_SCROLL_STEP_FORWARD',
  'GTK_SCROLL_PAGE_BACKWARD',
  'GTK_SCROLL_PAGE_FORWARD',
  'GTK_SCROLL_STEP_UP',
  'GTK_SCROLL_STEP_DOWN',
  'GTK_SCROLL_PAGE_UP',
  'GTK_SCROLL_PAGE_DOWN',
  'GTK_SCROLL_STEP_LEFT',
  'GTK_SCROLL_STEP_RIGHT',
  'GTK_SCROLL_PAGE_LEFT',
  'GTK_SCROLL_PAGE_RIGHT',
  'GTK_SCROLL_START',
  'GTK_SCROLL_END'
);


=begin pod
=head2 enum GtkSelectionMode

Used to control what selections users are allowed to make.


=item GTK_SELECTION_NONE: No selection is possible.
=item GTK_SELECTION_SINGLE: Zero or one element may be selected.
=item GTK_SELECTION_BROWSE: Exactly one element is selected. In some circumstances, such as initially or during a search operation, it’s possible for no element to be selected with C<GTK_SELECTION_BROWSE>. What is really enforced is that the user can’t deselect a currently selected element except by selecting another element.
=item GTK_SELECTION_MULTIPLE: Any number of elements may be selected. The Ctrl key may be used to enlarge the selection, and Shift key to select between the focus and the child pointed to. Some widgets may also allow Click-drag to select a range of elements.


=end pod

enum GtkSelectionMode is export (
  'GTK_SELECTION_NONE',
  'GTK_SELECTION_SINGLE',
  'GTK_SELECTION_BROWSE',
  'GTK_SELECTION_MULTIPLE'
);


=begin pod
=head2 enum GtkShadowType

Used to change the appearance of an outline typically provided by a C<Gnome::Gtk3::Frame>.

Note that many themes do not differentiate the appearance of the
various shadow types: Either their is no visible shadow (I<GTK_SHADOW_NONE>),
or there is (any other value).


=item GTK_SHADOW_NONE: No outline.
=item GTK_SHADOW_IN: The outline is bevelled inwards.
=item GTK_SHADOW_OUT: The outline is bevelled outwards like a button.
=item GTK_SHADOW_ETCHED_IN: The outline has a sunken 3d appearance.
=item GTK_SHADOW_ETCHED_OUT: The outline has a raised 3d appearance.


=end pod

enum GtkShadowType is export (
  'GTK_SHADOW_NONE',
  'GTK_SHADOW_IN',
  'GTK_SHADOW_OUT',
  'GTK_SHADOW_ETCHED_IN',
  'GTK_SHADOW_ETCHED_OUT'
);

#`{{
=begin pod
=head2 enum GtkStateType

This type indicates the current state of a widget; the state determines how
the widget is drawn. The C<Gnome::Gtk3::StateType> enumeration is also used to
identify different colors in a C<Gnome::Gtk3::Style> for drawing, so states can be
used for subparts of a widget as well as entire widgets.

Deprecated: 3.14: All APIs that are using this enumeration have been deprecated
in favor of alternatives using C<Gnome::Gtk3::StateFlags>.


=item GTK_STATE_NORMAL: State during normal operation.
=item GTK_STATE_ACTIVE: State of a currently active widget, such as a depressed button.
=item GTK_STATE_PRELIGHT: State indicating that the mouse pointer is over the widget and the widget will respond to mouse clicks.
=item GTK_STATE_SELECTED: State of a selected item, such the selected row in a list.
=item GTK_STATE_INSENSITIVE: State indicating that the widget is unresponsive to user actions.
=item GTK_STATE_INCONSISTENT: The widget is inconsistent, such as checkbuttons or radiobuttons that aren’t either set to C<1> nor C<0>, or buttons requiring the user attention.
=item GTK_STATE_FOCUSED: The widget has the keyboard focus.


=end pod

enum GtkStateType is export (
  'GTK_STATE_NORMAL',
  'GTK_STATE_ACTIVE',
  'GTK_STATE_PRELIGHT',
  'GTK_STATE_SELECTED',
  'GTK_STATE_INSENSITIVE',
  'GTK_STATE_INCONSISTENT',
  'GTK_STATE_FOCUSED'
);
}}

=begin pod
=head2 enum GtkToolbarStyle

Used to customize the appearance of a C<Gnome::Gtk3::Toolbar>. Note that
setting the toolbar style overrides the user’s preferences
for the default toolbar style.  Note that if the button has only
a label set and GTK_TOOLBAR_ICONS is used, the label will be
visible, and vice versa.


=item GTK_TOOLBAR_ICONS: Buttons display only icons in the toolbar.
=item GTK_TOOLBAR_TEXT: Buttons display only text labels in the toolbar.
=item GTK_TOOLBAR_BOTH: Buttons display text and icons in the toolbar.
=item GTK_TOOLBAR_BOTH_HORIZ: Buttons display icons and text alongside each other, rather than vertically stacked


=end pod

enum GtkToolbarStyle is export (
  'GTK_TOOLBAR_ICONS',
  'GTK_TOOLBAR_TEXT',
  'GTK_TOOLBAR_BOTH',
  'GTK_TOOLBAR_BOTH_HORIZ'
);


=begin pod
=head2 enum GtkWrapMode

Describes a type of line wrapping.


=item GTK_WRAP_NONE: do not wrap lines; just make the text area wider
=item GTK_WRAP_CHAR: wrap text, breaking lines anywhere the cursor can appear (between characters, usually - if you want to be technical, between graphemes, see C<pango_get_log_attrs()>)
=item GTK_WRAP_WORD: wrap text, breaking lines in between words
=item GTK_WRAP_WORD_CHAR: wrap text, breaking lines in between words, or if that is not enough, also between graphemes


=end pod

enum GtkWrapMode is export (
  'GTK_WRAP_NONE',
  'GTK_WRAP_CHAR',
  'GTK_WRAP_WORD',
  'GTK_WRAP_WORD_CHAR'
);


=begin pod
=head2 enum GtkSortType

Determines the direction of a sort.


=item GTK_SORT_ASCENDING: Sorting is in ascending order.
=item GTK_SORT_DESCENDING: Sorting is in descending order.


=end pod

enum GtkSortType is export (
  'GTK_SORT_ASCENDING',
  'GTK_SORT_DESCENDING'
);


=begin pod
=head2 enum GtkIMPreeditStyle

Style for input method preedit. See also
prop C<gtk-im-preedit-style>

Deprecated: 3.10


=item GTK_IM_PREEDIT_NOTHING: Deprecated
=item GTK_IM_PREEDIT_CALLBACK: Deprecated
=item GTK_IM_PREEDIT_NONE: Deprecated


=end pod

enum GtkIMPreeditStyle is export (
  'GTK_IM_PREEDIT_NOTHING',
  'GTK_IM_PREEDIT_CALLBACK',
  'GTK_IM_PREEDIT_NONE'
);


=begin pod
=head2 enum GtkIMStatusStyle

Style for input method status. See also
prop C<gtk-im-status-style>

Deprecated: 3.10


=item GTK_IM_STATUS_NOTHING: Deprecated
=item GTK_IM_STATUS_CALLBACK: Deprecated
=item GTK_IM_STATUS_NONE: Deprecated


=end pod

enum GtkIMStatusStyle is export (
  'GTK_IM_STATUS_NOTHING',
  'GTK_IM_STATUS_CALLBACK',
  'GTK_IM_STATUS_NONE'
);


=begin pod
=head2 enum GtkPackDirection

Determines how widgets should be packed inside menubars
and menuitems contained in menubars.


=item GTK_PACK_DIRECTION_LTR: Widgets are packed left-to-right
=item GTK_PACK_DIRECTION_RTL: Widgets are packed right-to-left
=item GTK_PACK_DIRECTION_TTB: Widgets are packed top-to-bottom
=item GTK_PACK_DIRECTION_BTT: Widgets are packed bottom-to-top


=end pod

enum GtkPackDirection is export (
  'GTK_PACK_DIRECTION_LTR',
  'GTK_PACK_DIRECTION_RTL',
  'GTK_PACK_DIRECTION_TTB',
  'GTK_PACK_DIRECTION_BTT'
);


=begin pod
=head2 enum GtkPrintPages

See also C<gtk_print_job_set_pages()>


=item GTK_PRINT_PAGES_ALL: All pages.
=item GTK_PRINT_PAGES_CURRENT: Current page.
=item GTK_PRINT_PAGES_RANGES: Range of pages.
=item GTK_PRINT_PAGES_SELECTION: Selected pages.


=end pod

enum GtkPrintPages is export (
  'GTK_PRINT_PAGES_ALL',
  'GTK_PRINT_PAGES_CURRENT',
  'GTK_PRINT_PAGES_RANGES',
  'GTK_PRINT_PAGES_SELECTION'
);


=begin pod
=head2 enum GtkPageSet

See also C<gtk_print_job_set_page_set()>.


=item GTK_PAGE_SET_ALL: All pages.
=item GTK_PAGE_SET_EVEN: Even pages.
=item GTK_PAGE_SET_ODD: Odd pages.


=end pod

enum GtkPageSet is export (
  'GTK_PAGE_SET_ALL',
  'GTK_PAGE_SET_EVEN',
  'GTK_PAGE_SET_ODD'
);


=begin pod
=head2 enum GtkNumberUpLayout

Used to determine the layout of pages on a sheet when printing
multiple pages per sheet.


=item GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM: ![](images/layout-lrtb.png)
=item GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP: ![](images/layout-lrbt.png)
=item GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM: ![](images/layout-rltb.png)
=item GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP: ![](images/layout-rlbt.png)
=item GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT: ![](images/layout-tblr.png)
=item GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT: ![](images/layout-tbrl.png)
=item GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT: ![](images/layout-btlr.png)
=item GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT: ![](images/layout-btrl.png)


=end pod

enum GtkNumberUpLayout is export (
  'GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT'  # < nick=>btrl >
);


=begin pod
=head2 enum GtkPageOrientation

See also C<gtk_print_settings_set_orientation()>.


=item GTK_PAGE_ORIENTATION_PORTRAIT: Portrait mode.
=item GTK_PAGE_ORIENTATION_LANDSCAPE: Landscape mode.
=item GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT: Reverse portrait mode.
=item GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE: Reverse landscape mode.


=end pod

enum GtkPageOrientation is export (
  'GTK_PAGE_ORIENTATION_PORTRAIT',
  'GTK_PAGE_ORIENTATION_LANDSCAPE',
  'GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT',
  'GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE'
);


=begin pod
=head2 enum GtkPrintQuality

See also C<gtk_print_settings_set_quality()>.


=item GTK_PRINT_QUALITY_LOW: Low quality.
=item GTK_PRINT_QUALITY_NORMAL: Normal quality.
=item GTK_PRINT_QUALITY_HIGH: High quality.
=item GTK_PRINT_QUALITY_DRAFT: Draft quality.


=end pod

enum GtkPrintQuality is export (
  'GTK_PRINT_QUALITY_LOW',
  'GTK_PRINT_QUALITY_NORMAL',
  'GTK_PRINT_QUALITY_HIGH',
  'GTK_PRINT_QUALITY_DRAFT'
);


=begin pod
=head2 enum GtkPrintDuplex

See also C<gtk_print_settings_set_duplex()>.


=item GTK_PRINT_DUPLEX_SIMPLEX: No duplex.
=item GTK_PRINT_DUPLEX_HORIZONTAL: Horizontal duplex.
=item GTK_PRINT_DUPLEX_VERTICAL: Vertical duplex.


=end pod

enum GtkPrintDuplex is export (
  'GTK_PRINT_DUPLEX_SIMPLEX',
  'GTK_PRINT_DUPLEX_HORIZONTAL',
  'GTK_PRINT_DUPLEX_VERTICAL'
);


=begin pod
=head2 enum GtkUnit

See also C<gtk_print_settings_set_paper_width()>.


=item GTK_UNIT_NONE: No units.
=item GTK_UNIT_POINTS: Dimensions in points.
=item GTK_UNIT_INCH: Dimensions in inches.
=item GTK_UNIT_MM: Dimensions in millimeters


=end pod

enum GtkUnit is export (
  'GTK_UNIT_NONE',
  'GTK_UNIT_POINTS',
  'GTK_UNIT_INCH',
  'GTK_UNIT_MM'
);


=begin pod
=head2 enum GtkTreeViewGridLines

Used to indicate which grid lines to draw in a tree view.


=item GTK_TREE_VIEW_GRID_LINES_NONE: No grid lines.
=item GTK_TREE_VIEW_GRID_LINES_HORIZONTAL: Horizontal grid lines.
=item GTK_TREE_VIEW_GRID_LINES_VERTICAL: Vertical grid lines.
=item GTK_TREE_VIEW_GRID_LINES_BOTH: Horizontal and vertical grid lines.


=end pod

enum GtkTreeViewGridLines is export (
  'GTK_TREE_VIEW_GRID_LINES_NONE',
  'GTK_TREE_VIEW_GRID_LINES_HORIZONTAL',
  'GTK_TREE_VIEW_GRID_LINES_VERTICAL',
  'GTK_TREE_VIEW_GRID_LINES_BOTH'
);


=begin pod
=head2 enum GtkDragResult

Gives an indication why a drag operation failed.
The value can by obtained by connecting to the
sig C<drag-failed> signal.


=item GTK_DRAG_RESULT_SUCCESS: The drag operation was successful.
=item GTK_DRAG_RESULT_NO_TARGET: No suitable drag target.
=item GTK_DRAG_RESULT_USER_CANCELLED: The user cancelled the drag operation.
=item GTK_DRAG_RESULT_TIMEOUT_EXPIRED: The drag operation timed out.
=item GTK_DRAG_RESULT_GRAB_BROKEN: The pointer or keyboard grab used for the drag operation was broken.
=item GTK_DRAG_RESULT_ERROR: The drag operation failed due to some unspecified error.


=end pod

enum GtkDragResult is export (
  'GTK_DRAG_RESULT_SUCCESS',
  'GTK_DRAG_RESULT_NO_TARGET',
  'GTK_DRAG_RESULT_USER_CANCELLED',
  'GTK_DRAG_RESULT_TIMEOUT_EXPIRED',
  'GTK_DRAG_RESULT_GRAB_BROKEN',
  'GTK_DRAG_RESULT_ERROR'
);


=begin pod
=head2 enum GtkSizeGroupMode

The mode of the size group determines the directions in which the size
group affects the requested sizes of its component widgets.


=item GTK_SIZE_GROUP_NONE: group has no effect
=item GTK_SIZE_GROUP_HORIZONTAL: group affects horizontal requisition
=item GTK_SIZE_GROUP_VERTICAL: group affects vertical requisition
=item GTK_SIZE_GROUP_BOTH: group affects both horizontal and vertical requisition


=end pod

enum GtkSizeGroupMode is export (
  'GTK_SIZE_GROUP_NONE',
  'GTK_SIZE_GROUP_HORIZONTAL',
  'GTK_SIZE_GROUP_VERTICAL',
  'GTK_SIZE_GROUP_BOTH'
);


=begin pod
=head2 enum GtkSizeRequestMode

Specifies a preference for height-for-width or
width-for-height geometry management.


=item GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH: Prefer height-for-width geometry management
=item GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT: Prefer width-for-height geometry management
=item GTK_SIZE_REQUEST_CONSTANT_SIZE: Don’t trade height-for-width or width-for-height


=end pod

enum GtkSizeRequestMode is export (
  'GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH' => 0,
  'GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT',
  'GTK_SIZE_REQUEST_CONSTANT_SIZE'
);


=begin pod
=head2 enum GtkScrollablePolicy

Defines the policy to be used in a scrollable widget when updating
the scrolled window adjustments in a given orientation.


=item GTK_SCROLL_MINIMUM: Scrollable adjustments are based on the minimum size
=item GTK_SCROLL_NATURAL: Scrollable adjustments are based on the natural size


=end pod

enum GtkScrollablePolicy is export (
  'GTK_SCROLL_MINIMUM' => 0,
  'GTK_SCROLL_NATURAL'
);


=begin pod
=head2 enum GtkStateFlags

Describes a widget state. Widget states are used to match the widget
against CSS pseudo-classes. Note that GTK extends the regular CSS
classes and sometimes uses different names.


=item GTK_STATE_FLAG_NORMAL: State during normal operation.
=item GTK_STATE_FLAG_ACTIVE: Widget is active.
=item GTK_STATE_FLAG_PRELIGHT: Widget has a mouse pointer over it.
=item GTK_STATE_FLAG_SELECTED: Widget is selected.
=item GTK_STATE_FLAG_INSENSITIVE: Widget is insensitive.
=item GTK_STATE_FLAG_INCONSISTENT: Widget is inconsistent.
=item GTK_STATE_FLAG_FOCUSED: Widget has the keyboard focus.
=item GTK_STATE_FLAG_BACKDROP: Widget is in a background toplevel window.
=item GTK_STATE_FLAG_DIR_LTR: Widget is in left-to-right text direction. Since 3.8
=item GTK_STATE_FLAG_DIR_RTL: Widget is in right-to-left text direction. Since 3.8
=item GTK_STATE_FLAG_LINK: Widget is a link. Since 3.12
=item GTK_STATE_FLAG_VISITED: The location the widget points to has already been visited. Since 3.12
=item GTK_STATE_FLAG_CHECKED: Widget is checked. Since 3.14
=item GTK_STATE_FLAG_DROP_ACTIVE: Widget is highlighted as a drop target for DND. Since 3.20


=end pod

enum GtkStateFlags is export (
  'GTK_STATE_FLAG_NORMAL'       => 0,
  'GTK_STATE_FLAG_ACTIVE'       => 1 +< 0,
  'GTK_STATE_FLAG_PRELIGHT'     => 1 +< 1,
  'GTK_STATE_FLAG_SELECTED'     => 1 +< 2,
  'GTK_STATE_FLAG_INSENSITIVE'  => 1 +< 3,
  'GTK_STATE_FLAG_INCONSISTENT' => 1 +< 4,
  'GTK_STATE_FLAG_FOCUSED'      => 1 +< 5,
  'GTK_STATE_FLAG_BACKDROP'     => 1 +< 6,
  'GTK_STATE_FLAG_DIR_LTR'      => 1 +< 7,
  'GTK_STATE_FLAG_DIR_RTL'      => 1 +< 8,
  'GTK_STATE_FLAG_LINK'         => 1 +< 9,
  'GTK_STATE_FLAG_VISITED'      => 1 +< 10,
  'GTK_STATE_FLAG_CHECKED'      => 1 +< 11,
  'GTK_STATE_FLAG_DROP_ACTIVE'  => 1 +< 12
);


=begin pod
=head2 enum GtkRegionFlags

Describes a region within a widget.


=item GTK_REGION_EVEN: Region has an even number within a set.
=item GTK_REGION_ODD: Region has an odd number within a set.
=item GTK_REGION_FIRST: Region is the first one within a set.
=item GTK_REGION_LAST: Region is the last one within a set.
=item GTK_REGION_ONLY: Region is the only one within a set.
=item GTK_REGION_SORTED: Region is part of a sorted area.


=end pod

enum GtkRegionFlags is export (
  'GTK_REGION_EVEN'    => 1 +< 0,
  'GTK_REGION_ODD'     => 1 +< 1,
  'GTK_REGION_FIRST'   => 1 +< 2,
  'GTK_REGION_LAST'    => 1 +< 3,
  'GTK_REGION_ONLY'    => 1 +< 4,
  'GTK_REGION_SORTED'  => 1 +< 5
);


=begin pod
=head2 enum GtkJunctionSides

Describes how a rendered element connects to adjacent elements.


=item GTK_JUNCTION_NONE: No junctions.
=item GTK_JUNCTION_CORNER_TOPLEFT: Element connects on the top-left corner.
=item GTK_JUNCTION_CORNER_TOPRIGHT: Element connects on the top-right corner.
=item GTK_JUNCTION_CORNER_BOTTOMLEFT: Element connects on the bottom-left corner.
=item GTK_JUNCTION_CORNER_BOTTOMRIGHT: Element connects on the bottom-right corner.
=item GTK_JUNCTION_TOP: Element connects on the top side.
=item GTK_JUNCTION_BOTTOM: Element connects on the bottom side.
=item GTK_JUNCTION_LEFT: Element connects on the left side.
=item GTK_JUNCTION_RIGHT: Element connects on the right side.


=end pod

enum GtkJunctionSides is export (
  'GTK_JUNCTION_NONE'   => 0,
  'GTK_JUNCTION_CORNER_TOPLEFT' => 1 +< 0,
  'GTK_JUNCTION_CORNER_TOPRIGHT' => 1 +< 1,
  'GTK_JUNCTION_CORNER_BOTTOMLEFT' => 1 +< 2,
  'GTK_JUNCTION_CORNER_BOTTOMRIGHT' => 1 +< 3,
  'GTK_JUNCTION_TOP'    => (1 +< 0 +| 1 +< 1),
  'GTK_JUNCTION_BOTTOM' => (1 +< 2 +| 1 +< 3),
  'GTK_JUNCTION_LEFT'   => (1 +< 0 +| 1 +< 2),
  'GTK_JUNCTION_RIGHT'  => (1 +< 1 +| 1 +< 3)
);


=begin pod
=head2 enum GtkBorderStyle

Describes how the border of a UI element should be rendered.


=item GTK_BORDER_STYLE_NONE: No visible border
=item GTK_BORDER_STYLE_SOLID: A single line segment
=item GTK_BORDER_STYLE_INSET: Looks as if the content is sunken into the canvas
=item GTK_BORDER_STYLE_OUTSET: Looks as if the content is coming out of the canvas
=item GTK_BORDER_STYLE_HIDDEN: Same as I<GTK_BORDER_STYLE_NONE>
=item GTK_BORDER_STYLE_DOTTED: A series of round dots
=item GTK_BORDER_STYLE_DASHED: A series of square-ended dashes
=item GTK_BORDER_STYLE_DOUBLE: Two parallel lines with some space between them
=item GTK_BORDER_STYLE_GROOVE: Looks as if it were carved in the canvas
=item GTK_BORDER_STYLE_RIDGE: Looks as if it were coming out of the canvas


=end pod

enum GtkBorderStyle is export (
  'GTK_BORDER_STYLE_NONE',
  'GTK_BORDER_STYLE_SOLID',
  'GTK_BORDER_STYLE_INSET',
  'GTK_BORDER_STYLE_OUTSET',
  'GTK_BORDER_STYLE_HIDDEN',
  'GTK_BORDER_STYLE_DOTTED',
  'GTK_BORDER_STYLE_DASHED',
  'GTK_BORDER_STYLE_DOUBLE',
  'GTK_BORDER_STYLE_GROOVE',
  'GTK_BORDER_STYLE_RIDGE'
);


=begin pod
=head2 enum GtkLevelBarMode

Describes how C<Gnome::Gtk3::LevelBar> contents should be rendered.
Note that this enumeration could be extended with additional modes
in the future.

Since: 3.6


=item GTK_LEVEL_BAR_MODE_CONTINUOUS: the bar has a continuous mode
=item GTK_LEVEL_BAR_MODE_DISCRETE: the bar has a discrete mode


=end pod

enum GtkLevelBarMode is export (
  'GTK_LEVEL_BAR_MODE_CONTINUOUS',
  'GTK_LEVEL_BAR_MODE_DISCRETE'
);


=begin pod
=head2 enum GtkInputPurpose

Describes primary purpose of the input widget. This information is
useful for on-screen keyboards and similar input methods to decide
which keys should be presented to the user.

Note that the purpose is not meant to impose a totally strict rule
about allowed characters, and does not replace input validation.
It is fine for an on-screen keyboard to let the user override the
character set restriction that is expressed by the purpose. The
application is expected to validate the entry contents, even if
it specified a purpose.

The difference between I<GTK_INPUT_PURPOSE_DIGITS> and
I<GTK_INPUT_PURPOSE_NUMBER> is that the former accepts only digits
while the latter also some punctuation (like commas or points, plus,
minus) and “e” or “E” as in 3.14E+000.

This enumeration may be extended in the future; input methods should
interpret unknown values as “free form”.

Since: 3.6


=item GTK_INPUT_PURPOSE_FREE_FORM: Allow any character
=item GTK_INPUT_PURPOSE_ALPHA: Allow only alphabetic characters
=item GTK_INPUT_PURPOSE_DIGITS: Allow only digits
=item GTK_INPUT_PURPOSE_NUMBER: Edited field expects numbers
=item GTK_INPUT_PURPOSE_PHONE: Edited field expects phone number
=item GTK_INPUT_PURPOSE_URL: Edited field expects URL
=item GTK_INPUT_PURPOSE_EMAIL: Edited field expects email address
=item GTK_INPUT_PURPOSE_NAME: Edited field expects the name of a person
=item GTK_INPUT_PURPOSE_PASSWORD: Like I<GTK_INPUT_PURPOSE_FREE_FORM>, but characters are hidden
=item GTK_INPUT_PURPOSE_PIN: Like I<GTK_INPUT_PURPOSE_DIGITS>, but characters are hidden


=end pod

enum GtkInputPurpose is export (
  'GTK_INPUT_PURPOSE_FREE_FORM',
  'GTK_INPUT_PURPOSE_ALPHA',
  'GTK_INPUT_PURPOSE_DIGITS',
  'GTK_INPUT_PURPOSE_NUMBER',
  'GTK_INPUT_PURPOSE_PHONE',
  'GTK_INPUT_PURPOSE_URL',
  'GTK_INPUT_PURPOSE_EMAIL',
  'GTK_INPUT_PURPOSE_NAME',
  'GTK_INPUT_PURPOSE_PASSWORD',
  'GTK_INPUT_PURPOSE_PIN'
);


=begin pod
=head2 enum GtkInputHints

Describes hints that might be taken into account by input methods
or applications. Note that input methods may already tailor their
behaviour according to the C<Gnome::Gtk3::InputPurpose> of the entry.

Some common sense is expected when using these flags - mixing
I<GTK_INPUT_HINT_LOWERCASE> with any of the uppercase hints makes no sense.

This enumeration may be extended in the future; input methods should
ignore unknown values.

Since: 3.6


=item GTK_INPUT_HINT_NONE: No special behaviour suggested
=item GTK_INPUT_HINT_SPELLCHECK: Suggest checking for typos
=item GTK_INPUT_HINT_NO_SPELLCHECK: Suggest not checking for typos
=item GTK_INPUT_HINT_WORD_COMPLETION: Suggest word completion
=item GTK_INPUT_HINT_LOWERCASE: Suggest to convert all text to lowercase
=item GTK_INPUT_HINT_UPPERCASE_CHARS: Suggest to capitalize all text
=item GTK_INPUT_HINT_UPPERCASE_WORDS: Suggest to capitalize the first character of each word
=item GTK_INPUT_HINT_UPPERCASE_SENTENCES: Suggest to capitalize the first word of each sentence
=item GTK_INPUT_HINT_INHIBIT_OSK: Suggest to not show an onscreen keyboard (e.g for a calculator that already has all the keys).
=item GTK_INPUT_HINT_VERTICAL_WRITING: The text is vertical. Since 3.18
=item GTK_INPUT_HINT_EMOJI: Suggest offering Emoji support. Since 3.22.20
=item GTK_INPUT_HINT_NO_EMOJI: Suggest not offering Emoji support. Since 3.22.20


=end pod

enum GtkInputHints is export (
  'GTK_INPUT_HINT_NONE'                => 0,
  'GTK_INPUT_HINT_SPELLCHECK'          => 1 +< 0,
  'GTK_INPUT_HINT_NO_SPELLCHECK'       => 1 +< 1,
  'GTK_INPUT_HINT_WORD_COMPLETION'     => 1 +< 2,
  'GTK_INPUT_HINT_LOWERCASE'           => 1 +< 3,
  'GTK_INPUT_HINT_UPPERCASE_CHARS'     => 1 +< 4,
  'GTK_INPUT_HINT_UPPERCASE_WORDS'     => 1 +< 5,
  'GTK_INPUT_HINT_UPPERCASE_SENTENCES' => 1 +< 6,
  'GTK_INPUT_HINT_INHIBIT_OSK'         => 1 +< 7,
  'GTK_INPUT_HINT_VERTICAL_WRITING'    => 1 +< 8,
  'GTK_INPUT_HINT_EMOJI'               => 1 +< 9,
  'GTK_INPUT_HINT_NO_EMOJI'            => 1 +< 10
);


=begin pod
=head2 enum GtkPropagationPhase

Describes the stage at which events are fed into a C<Gnome::Gtk3::EventController>.

Since: 3.14


=item GTK_PHASE_NONE: Events are not delivered automatically. Those can be manually fed through C<gtk_event_controller_handle_event()>. This should only be used when full control about when, or whether the controller handles the event is needed.
=item GTK_PHASE_CAPTURE: Events are delivered in the capture phase. The capture phase happens before the bubble phase, runs from the toplevel down to the event widget. This option should only be used on containers that might possibly handle events before their children do.
=item GTK_PHASE_BUBBLE: Events are delivered in the bubble phase. The bubble phase happens after the capture phase, and before the default handlers are run. This phase runs from the event widget, up to the toplevel.
=item GTK_PHASE_TARGET: Events are delivered in the default widget event handlers, note that widget implementations must chain up on button, motion, touch and grab broken handlers for controllers in this phase to be run.


=end pod

enum GtkPropagationPhase is export (
  'GTK_PHASE_NONE',
  'GTK_PHASE_CAPTURE',
  'GTK_PHASE_BUBBLE',
  'GTK_PHASE_TARGET'
);


=begin pod
=head2 enum GtkEventSequenceState

Describes the state of a C<Gnome::Gdk3::EventSequence> in a C<Gnome::Gtk3::Gesture>.

Since: 3.14


=item GTK_EVENT_SEQUENCE_NONE: The sequence is handled, but not grabbed.
=item GTK_EVENT_SEQUENCE_CLAIMED: The sequence is handled and grabbed.
=item GTK_EVENT_SEQUENCE_DENIED: The sequence is denied.


=end pod

enum GtkEventSequenceState is export (
  'GTK_EVENT_SEQUENCE_NONE',
  'GTK_EVENT_SEQUENCE_CLAIMED',
  'GTK_EVENT_SEQUENCE_DENIED'
);


=begin pod
=head2 enum GtkPanDirection

Describes the panning direction of a C<Gnome::Gtk3::GesturePan>

Since: 3.14


=item GTK_PAN_DIRECTION_LEFT: panned towards the left
=item GTK_PAN_DIRECTION_RIGHT: panned towards the right
=item GTK_PAN_DIRECTION_UP: panned upwards
=item GTK_PAN_DIRECTION_DOWN: panned downwards


=end pod

enum GtkPanDirection is export (
  'GTK_PAN_DIRECTION_LEFT',
  'GTK_PAN_DIRECTION_RIGHT',
  'GTK_PAN_DIRECTION_UP',
  'GTK_PAN_DIRECTION_DOWN'
);


=begin pod
=head2 enum GtkPopoverConstraint

Describes constraints to positioning of popovers. More values
may be added to this enumeration in the future.

Since: 3.20


=item GTK_POPOVER_CONSTRAINT_NONE: Don't constrain the popover position beyond what is imposed by the implementation
=item GTK_POPOVER_CONSTRAINT_WINDOW: Constrain the popover to the boundaries of the window that it is attached to


=end pod

enum GtkPopoverConstraint is export (
  'GTK_POPOVER_CONSTRAINT_NONE',
  'GTK_POPOVER_CONSTRAINT_WINDOW'
);
