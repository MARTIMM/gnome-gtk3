#TL:1:Gnome::Gtk3::TextView:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TextView

Widget that displays a B<Gnome::Gtk3::TextBuffer>

![](images/multiline-text.png)

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

=head2 Css Nodes

  textview.view
  ├── border.top
  ├── border.left
  ├── text
  │   ╰── [selection]
  ├── border.right
  ├── border.bottom
  ╰── [window.popup]

B<Gnome::Gtk3::TextView> has a main css node with name textview and style class .view, and subnodes for each of the border windows, and the main text area, with names border and text, respectively. The border nodes each get one of the style classes .left, .right, .top or .bottom.

A node representing the selection will appear below the text node.

If a context menu is opened, the window node will appear as a subnode of the main node.

=head2 Implemented Interfaces

Gnome::Gtk3::TextView implements

=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item Gnome::Gtk3::Scrollable

=head2 See Also

B<Gnome::Gtk3::TextBuffer>, B<Gnome::Gtk3::TextIter>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextView;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Container;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextview.h
# https://developer.gnome.org/gtk3/stable/GtkTextView.html
unit class Gnome::Gtk3::TextView:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextWindowType

Used to reference the parts of B<Gnome::Gtk3::TextView>.

=item GTK_TEXT_WINDOW_PRIVATE: Invalid value, used as a marker
=item GTK_TEXT_WINDOW_WIDGET: Window that floats over scrolling areas.
=item GTK_TEXT_WINDOW_TEXT: Scrollable text window.
=item GTK_TEXT_WINDOW_LEFT: Left side border window.
=item GTK_TEXT_WINDOW_RIGHT: Right side border window.
=item GTK_TEXT_WINDOW_TOP: Top border window.
=item GTK_TEXT_WINDOW_BOTTOM: Bottom border window.

=end pod

#TE:0:GtkTextWindowType:
enum GtkTextWindowType is export (
  'GTK_TEXT_WINDOW_PRIVATE',
  'GTK_TEXT_WINDOW_WIDGET',
  'GTK_TEXT_WINDOW_TEXT',
  'GTK_TEXT_WINDOW_LEFT',
  'GTK_TEXT_WINDOW_RIGHT',
  'GTK_TEXT_WINDOW_TOP',
  'GTK_TEXT_WINDOW_BOTTOM'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextViewLayer

Used to reference the layers of B<Gnome::Gtk3::TextView> for the purpose of customized drawing with the sig I<draw_layer> vfunc.

=item GTK_TEXT_VIEW_LAYER_BELOW: Old deprecated layer, use C<GTK_TEXT_VIEW_LAYER_BELOW_TEXT> instead
=item GTK_TEXT_VIEW_LAYER_ABOVE: Old deprecated layer, use C<GTK_TEXT_VIEW_LAYER_ABOVE_TEXT> instead
=item GTK_TEXT_VIEW_LAYER_BELOW_TEXT: The layer rendered below the text (but above the background).  Since: 3.20
=item GTK_TEXT_VIEW_LAYER_ABOVE_TEXT: The layer rendered above the text.  Since: 3.20

=end pod

#TE:0:GtkTextViewLayer:
enum GtkTextViewLayer is export (
  'GTK_TEXT_VIEW_LAYER_BELOW',
  'GTK_TEXT_VIEW_LAYER_ABOVE',
  'GTK_TEXT_VIEW_LAYER_BELOW_TEXT',
  'GTK_TEXT_VIEW_LAYER_ABOVE_TEXT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTextExtendSelection

Granularity types that extend the text selection. Use the sig C<extend-selection> signal to customize the selection.

Since: 3.16


=item GTK_TEXT_EXTEND_SELECTION_WORD: Selects the current word. It is triggered by a double-click for example.
=item GTK_TEXT_EXTEND_SELECTION_LINE: Selects the current line. It is triggered by a triple-click for example.


=end pod

#TE:0:GtkTextExtendSelection:
enum GtkTextExtendSelection is export (
  'GTK_TEXT_EXTEND_SELECTION_WORD',
  'GTK_TEXT_EXTEND_SELECTION_LINE'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<set-anchor backspace cut-clipboard copy-clipboard paste-clipboard toggle-overwrite toggle-cursor-visible>,
    :w1<insert-at-cursor populate-popup select-all preedit-changed>,
    :w3<move-cursor>,
    :w2<move-viewport delete-from-cursor>,
    :w4<extend-selection>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextView';

  if ? %options<empty> {
    self.native-gobject(gtk_text_view_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkTextView');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_view_$native-sub"); } unless ?$s;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkTextView');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_text_view_new:new(:e,pty)
=begin pod
=head2 gtk_text_view_new

Creates a new B<Gnome::Gtk3::TextView>. If you don’t call C<gtk_text_view_set_buffer()>
before using the text view, an empty default buffer will be created
for you. Get the buffer with C<gtk_text_view_get_buffer()>. If you want
to specify your own buffer, consider C<gtk_text_view_new_with_buffer()>.

Returns: a new B<Gnome::Gtk3::TextView>

  method gtk_text_view_new ( --> N-GObject  )


=end pod

sub gtk_text_view_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_new_with_buffer:
=begin pod
=head2 [gtk_text_view_] new_with_buffer

Creates a new B<Gnome::Gtk3::TextView> widget displaying the buffer
I<buffer>. One buffer can be shared among many widgets.
I<buffer> may be C<Any> to create a default buffer, in which case
this function is equivalent to C<gtk_text_view_new()>. The
text view adds its own reference count to the buffer; it does not
take over an existing reference.

Returns: a new B<Gnome::Gtk3::TextView>.

  method gtk_text_view_new_with_buffer ( N-GObject $buffer --> N-GObject  )

=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>

=end pod

sub gtk_text_view_new_with_buffer ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_buffer:
=begin pod
=head2 [gtk_text_view_] set_buffer

Sets I<buffer> as the buffer being displayed by I<text_view>. The previous
buffer displayed by the text view is unreferenced, and a reference is
added to I<buffer>. If you owned a reference to I<buffer> before passing it
to this function, you must remove that reference yourself; B<Gnome::Gtk3::TextView>
will not “adopt” it.

  method gtk_text_view_set_buffer ( N-GObject $buffer )

=item N-GObject $buffer; (allow-none): a B<Gnome::Gtk3::TextBuffer>

=end pod

sub gtk_text_view_set_buffer ( N-GObject $text_view, N-GObject $buffer )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_buffer:
=begin pod
=head2 [gtk_text_view_] get_buffer

Returns the B<Gnome::Gtk3::TextBuffer> being displayed by this text view.
The reference count on the buffer is not incremented; the caller
of this function won’t own a new reference.

Returns: (transfer none): a B<Gnome::Gtk3::TextBuffer>

  method gtk_text_view_get_buffer ( --> N-GObject  )


=end pod

sub gtk_text_view_get_buffer ( N-GObject $text_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_scroll_to_iter:
=begin pod
=head2 [gtk_text_view_] scroll_to_iter

Scrolls I<text_view> so that I<iter> is on the screen in the position
indicated by I<xalign> and I<yalign>. An alignment of 0.0 indicates
left or top, 1.0 indicates right or bottom, 0.5 means center.
If I<use_align> is C<0>, the text scrolls the minimal distance to
get the mark onscreen, possibly not scrolling at all. The effective
screen for purposes of this function is reduced by a margin of size
I<within_margin>.

Note that this function uses the currently-computed height of the
lines in the text buffer. Line heights are computed in an idle
handler; so this function may not have the desired effect if it’s
called before the height computations. To avoid oddness, consider
using C<gtk_text_view_scroll_to_mark()> which saves a point to be
scrolled to after line validation.

Returns: C<1> if scrolling occurred

  method gtk_text_view_scroll_to_iter ( N-GObject $iter, Num $within_margin, Int $use_align, Num $xalign, Num $yalign --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Num $within_margin; margin as a [0.0,0.5) fraction of screen size
=item Int $use_align; whether to use alignment arguments (if C<0>, just get the mark onscreen)
=item Num $xalign; horizontal alignment of mark within visible area
=item Num $yalign; vertical alignment of mark within visible area

=end pod

sub gtk_text_view_scroll_to_iter ( N-GObject $text_view, N-GObject $iter, num64 $within_margin, int32 $use_align, num64 $xalign, num64 $yalign )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_scroll_to_mark:
=begin pod
=head2 [gtk_text_view_] scroll_to_mark

Scrolls I<text_view> so that I<mark> is on the screen in the position
indicated by I<xalign> and I<yalign>. An alignment of 0.0 indicates
left or top, 1.0 indicates right or bottom, 0.5 means center.
If I<use_align> is C<0>, the text scrolls the minimal distance to
get the mark onscreen, possibly not scrolling at all. The effective
screen for purposes of this function is reduced by a margin of size
I<within_margin>.

  method gtk_text_view_scroll_to_mark ( N-GObject $mark, Num $within_margin, Int $use_align, Num $xalign, Num $yalign )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark>
=item Num $within_margin; margin as a [0.0,0.5) fraction of screen size
=item Int $use_align; whether to use alignment arguments (if C<0>, just  get the mark onscreen)
=item Num $xalign; horizontal alignment of mark within visible area
=item Num $yalign; vertical alignment of mark within visible area

=end pod

sub gtk_text_view_scroll_to_mark ( N-GObject $text_view, N-GObject $mark, num64 $within_margin, int32 $use_align, num64 $xalign, num64 $yalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_scroll_mark_onscreen:
=begin pod
=head2 [gtk_text_view_] scroll_mark_onscreen

Scrolls I<text_view> the minimum distance such that I<mark> is contained
within the visible area of the widget.

  method gtk_text_view_scroll_mark_onscreen ( N-GObject $mark )

=item N-GObject $mark; a mark in the buffer for I<text_view>

=end pod

sub gtk_text_view_scroll_mark_onscreen ( N-GObject $text_view, N-GObject $mark )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_move_mark_onscreen:
=begin pod
=head2 [gtk_text_view_] move_mark_onscreen

Moves a mark within the buffer so that it's
located within the currently-visible text area.

Returns: C<1> if the mark moved (wasn’t already onscreen)

  method gtk_text_view_move_mark_onscreen ( N-GObject $mark --> Int  )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark>

=end pod

sub gtk_text_view_move_mark_onscreen ( N-GObject $text_view, N-GObject $mark )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_place_cursor_onscreen:
=begin pod
=head2 [gtk_text_view_] place_cursor_onscreen

Moves the cursor to the currently visible region of the
buffer, it it isn’t there already.

Returns: C<1> if the cursor had to be moved.

  method gtk_text_view_place_cursor_onscreen ( --> Int  )


=end pod

sub gtk_text_view_place_cursor_onscreen ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_visible_rect:
=begin pod
=head2 [gtk_text_view_] get_visible_rect

Fills I<visible_rect> with the currently-visible
region of the buffer, in buffer coordinates. Convert to window coordinates
with C<gtk_text_view_buffer_to_window_coords()>.

  method gtk_text_view_get_visible_rect ( N-GObject $visible_rect )

=item N-GObject $visible_rect; (out): rectangle to fill

=end pod

sub gtk_text_view_get_visible_rect ( N-GObject $text_view, N-GObject $visible_rect )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_cursor_visible:
=begin pod
=head2 [gtk_text_view_] set_cursor_visible

Toggles whether the insertion point should be displayed. A buffer with
no editable text probably shouldn’t have a visible cursor, so you may
want to turn the cursor off.

Note that this property may be overridden by the
 I<gtk-keynave-use-caret> settings.

  method gtk_text_view_set_cursor_visible ( Int $setting )

=item Int $setting; whether to show the insertion cursor

=end pod

sub gtk_text_view_set_cursor_visible ( N-GObject $text_view, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_cursor_visible:
=begin pod
=head2 [gtk_text_view_] get_cursor_visible

Find out whether the cursor should be displayed.

Returns: whether the insertion mark is visible

  method gtk_text_view_get_cursor_visible ( --> Int  )


=end pod

sub gtk_text_view_get_cursor_visible ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_reset_cursor_blink:
=begin pod
=head2 [gtk_text_view_] reset_cursor_blink

Ensures that the cursor is shown (i.e. not in an 'off' blink
interval) and resets the time that it will stay blinking (or
visible, in case blinking is disabled).

This function should be called in response to user input
(e.g. from derived classes that override the textview's
 I<key-press-event> handler).

Since: 3.20

  method gtk_text_view_reset_cursor_blink ( )


=end pod

sub gtk_text_view_reset_cursor_blink ( N-GObject $text_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_cursor_locations:
=begin pod
=head2 [gtk_text_view_] get_cursor_locations

Given an I<iter> within a text layout, determine the positions of the
strong and weak cursors if the insertion point is at that
iterator. The position of each cursor is stored as a zero-width
rectangle. The strong cursor location is the location where
characters of the directionality equal to the base direction of the
paragraph are inserted.  The weak cursor location is the location
where characters of the directionality opposite to the base
direction of the paragraph are inserted.

If I<iter> is C<Any>, the actual cursor position is used.

Note that if I<iter> happens to be the actual cursor position, and
there is currently an IM preedit sequence being entered, the
returned locations will be adjusted to account for the preedit
cursor’s offset within the preedit sequence.

The rectangle position is in buffer coordinates; use
C<gtk_text_view_buffer_to_window_coords()> to convert these
coordinates to coordinates for one of the windows in the text view.

Since: 3.0

  method gtk_text_view_get_cursor_locations ( N-GObject $iter, N-GObject $strong, N-GObject $weak )

=item N-GObject $iter; (allow-none): a B<Gnome::Gtk3::TextIter>
=item N-GObject $strong; (out) (allow-none): location to store the strong cursor position (may be C<Any>)
=item N-GObject $weak; (out) (allow-none): location to store the weak cursor position (may be C<Any>)

=end pod

sub gtk_text_view_get_cursor_locations ( N-GObject $text_view, N-GObject $iter, N-GObject $strong, N-GObject $weak )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_iter_location:
=begin pod
=head2 [gtk_text_view_] get_iter_location

Gets a rectangle which roughly contains the character at I<iter>.
The rectangle position is in buffer coordinates; use
C<gtk_text_view_buffer_to_window_coords()> to convert these
coordinates to coordinates for one of the windows in the text view.

  method gtk_text_view_get_iter_location ( N-GObject $iter, N-GObject $location )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item N-GObject $location; (out): bounds of the character at I<iter>

=end pod

sub gtk_text_view_get_iter_location ( N-GObject $text_view, N-GObject $iter, N-GObject $location )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_iter_at_location:
=begin pod
=head2 [gtk_text_view_] get_iter_at_location

Retrieves the iterator at buffer coordinates I<x> and I<y>. Buffer
coordinates are coordinates for the entire buffer, not just the
currently-displayed portion.  If you have coordinates from an
event, you have to convert those to buffer coordinates with
C<gtk_text_view_window_to_buffer_coords()>.

Returns: C<1> if the position is over text

  method gtk_text_view_get_iter_at_location ( N-GObject $iter, Int $x, Int $y --> Int  )

=item N-GObject $iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $x; x position, in buffer coordinates
=item Int $y; y position, in buffer coordinates

=end pod

sub gtk_text_view_get_iter_at_location ( N-GObject $text_view, N-GObject $iter, int32 $x, int32 $y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_iter_at_position:
=begin pod
=head2 [gtk_text_view_] get_iter_at_position

Retrieves the iterator pointing to the character at buffer
coordinates I<x> and I<y>. Buffer coordinates are coordinates for
the entire buffer, not just the currently-displayed portion.
If you have coordinates from an event, you have to convert
those to buffer coordinates with
C<gtk_text_view_window_to_buffer_coords()>.

Note that this is different from C<gtk_text_view_get_iter_at_location()>,
which returns cursor locations, i.e. positions between
characters.

Returns: C<1> if the position is over text

Since: 2.6

  method gtk_text_view_get_iter_at_position ( N-GObject $iter, Int $trailing, Int $x, Int $y --> Int  )

=item N-GObject $iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $trailing; (out) (allow-none): if non-C<Any>, location to store an integer indicating where in the grapheme the user clicked. It will either be zero, or the number of characters in the grapheme. 0 represents the trailing edge of the grapheme.
=item Int $x; x position, in buffer coordinates
=item Int $y; y position, in buffer coordinates

=end pod

sub gtk_text_view_get_iter_at_position ( N-GObject $text_view, N-GObject $iter, int32 $trailing, int32 $x, int32 $y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_line_yrange:
=begin pod
=head2 [gtk_text_view_] get_line_yrange

Gets the y coordinate of the top of the line containing I<iter>,
and the height of the line. The coordinate is a buffer coordinate;
convert to window coordinates with C<gtk_text_view_buffer_to_window_coords()>.

  method gtk_text_view_get_line_yrange ( N-GObject $iter, Int $y, Int $height )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Int $y; (out): return location for a y coordinate
=item Int $height; (out): return location for a height

=end pod

sub gtk_text_view_get_line_yrange ( N-GObject $text_view, N-GObject $iter, int32 $y, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_line_at_y:
=begin pod
=head2 [gtk_text_view_] get_line_at_y

Gets the B<Gnome::Gtk3::TextIter> at the start of the line containing
the coordinate I<y>. I<y> is in buffer coordinates, convert from
window coordinates with C<gtk_text_view_window_to_buffer_coords()>.
If non-C<Any>, I<line_top> will be filled with the coordinate of the top
edge of the line.

  method gtk_text_view_get_line_at_y ( N-GObject $target_iter, Int $y, Int $line_top )

=item N-GObject $target_iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $y; a y coordinate
=item Int $line_top; (out): return location for top coordinate of the line

=end pod

sub gtk_text_view_get_line_at_y ( N-GObject $text_view, N-GObject $target_iter, int32 $y, int32 $line_top )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_buffer_to_window_coords:
=begin pod
=head2 [gtk_text_view_] buffer_to_window_coords

Converts coordinate (I<buffer_x>, I<buffer_y>) to coordinates for the window
I<win>, and stores the result in (I<window_x>, I<window_y>).

Note that you can’t convert coordinates for a nonexisting window (see
C<gtk_text_view_set_border_window_size()>).

  method gtk_text_view_buffer_to_window_coords ( GtkTextWindowType $win, Int $buffer_x, Int $buffer_y, Int $window_x, Int $window_y )

=item GtkTextWindowType $win; a B<Gnome::Gtk3::TextWindowType> except B<GTK_TEXT_WINDOW_PRIVATE>
=item Int $buffer_x; buffer x coordinate
=item Int $buffer_y; buffer y coordinate
=item Int $window_x; (out) (allow-none): window x coordinate return location or C<Any>
=item Int $window_y; (out) (allow-none): window y coordinate return location or C<Any>

=end pod

sub gtk_text_view_buffer_to_window_coords ( N-GObject $text_view, int32 $win, int32 $buffer_x, int32 $buffer_y, int32 $window_x, int32 $window_y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_window_to_buffer_coords:
=begin pod
=head2 [gtk_text_view_] window_to_buffer_coords

Converts coordinates on the window identified by I<win> to buffer
coordinates, storing the result in (I<buffer_x>,I<buffer_y>).

Note that you can’t convert coordinates for a nonexisting window (see
C<gtk_text_view_set_border_window_size()>).

  method gtk_text_view_window_to_buffer_coords ( GtkTextWindowType $win, Int $window_x, Int $window_y, Int $buffer_x, Int $buffer_y )

=item GtkTextWindowType $win; a B<Gnome::Gtk3::TextWindowType> except B<GTK_TEXT_WINDOW_PRIVATE>
=item Int $window_x; window x coordinate
=item Int $window_y; window y coordinate
=item Int $buffer_x; (out) (allow-none): buffer x coordinate return location or C<Any>
=item Int $buffer_y; (out) (allow-none): buffer y coordinate return location or C<Any>

=end pod

sub gtk_text_view_window_to_buffer_coords ( N-GObject $text_view, int32 $win, int32 $window_x, int32 $window_y, int32 $buffer_x, int32 $buffer_y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_window:
=begin pod
=head2 [gtk_text_view_] get_window

Retrieves the B<Gnome::Gdk3::Window> corresponding to an area of the text view;
possible windows include the overall widget window, child windows
on the left, right, top, bottom, and the window that displays the
text buffer. Windows are C<Any> and nonexistent if their width or
height is 0, and are nonexistent before the widget has been
realized.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Window>, or C<Any>

  method gtk_text_view_get_window ( GtkTextWindowType $win --> N-GObject  )

=item GtkTextWindowType $win; window to get

=end pod

sub gtk_text_view_get_window ( N-GObject $text_view, int32 $win )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_window_type:
=begin pod
=head2 [gtk_text_view_] get_window_type

Usually used to find out which window an event corresponds to.
If you connect to an event signal on I<text_view>, this function
should be called on `event->window` to
see which window it was.

Returns: the window type.

  method gtk_text_view_get_window_type ( N-GObject $window --> GtkTextWindowType  )

=item N-GObject $window; a window type

=end pod

sub gtk_text_view_get_window_type ( N-GObject $text_view, N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_border_window_size:
=begin pod
=head2 [gtk_text_view_] set_border_window_size

Sets the width of C<GTK_TEXT_WINDOW_LEFT> or C<GTK_TEXT_WINDOW_RIGHT>,
or the height of C<GTK_TEXT_WINDOW_TOP> or C<GTK_TEXT_WINDOW_BOTTOM>.
Automatically destroys the corresponding window if the size is set
to 0, and creates the window if the size is set to non-zero.  This
function can only be used for the “border windows,” it doesn’t work
with B<GTK_TEXT_WINDOW_WIDGET>, B<GTK_TEXT_WINDOW_TEXT>, or
B<GTK_TEXT_WINDOW_PRIVATE>.

  method gtk_text_view_set_border_window_size ( GtkTextWindowType $type, Int $size )

=item GtkTextWindowType $type; window to affect
=item Int $size; width or height of the window

=end pod

sub gtk_text_view_set_border_window_size ( N-GObject $text_view, int32 $type, int32 $size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_border_window_size:
=begin pod
=head2 [gtk_text_view_] get_border_window_size

Gets the width of the specified border window. See
C<gtk_text_view_set_border_window_size()>.

Returns: width of window

  method gtk_text_view_get_border_window_size ( GtkTextWindowType $type --> Int  )

=item GtkTextWindowType $type; window to return size from

=end pod

sub gtk_text_view_get_border_window_size ( N-GObject $text_view, int32 $type )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_forward_display_line:
=begin pod
=head2 [gtk_text_view_] forward_display_line

Moves the given I<iter> forward by one display (wrapped) line.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_forward_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_forward_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_backward_display_line:
=begin pod
=head2 [gtk_text_view_] backward_display_line

Moves the given I<iter> backward by one display (wrapped) line.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_backward_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_backward_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_forward_display_line_end:
=begin pod
=head2 [gtk_text_view_] forward_display_line_end

Moves the given I<iter> forward to the next display line end.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_forward_display_line_end ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_forward_display_line_end ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_backward_display_line_start:
=begin pod
=head2 [gtk_text_view_] backward_display_line_start

Moves the given I<iter> backward to the next display line start.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_backward_display_line_start ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_backward_display_line_start ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_starts_display_line:
=begin pod
=head2 [gtk_text_view_] starts_display_line

Determines whether I<iter> is at the start of a display line.
See C<gtk_text_view_forward_display_line()> for an explanation of
display lines vs. paragraphs.

Returns: C<1> if I<iter> begins a wrapped line

  method gtk_text_view_starts_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_starts_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_move_visually:
=begin pod
=head2 [gtk_text_view_] move_visually

Move the iterator a given number of characters visually, treating
it as the strong cursor position. If I<count> is positive, then the
new strong cursor position will be I<count> positions to the right of
the old cursor position. If I<count> is negative then the new strong
cursor position will be I<count> positions to the left of the old
cursor position.

In the presence of bi-directional text, the correspondence
between logical and visual order will depend on the direction
of the current run, and there may be jumps when the cursor
is moved off of the end of a run.

Returns: C<1> if I<iter> moved and is not on the end iterator

  method gtk_text_view_move_visually ( N-GObject $iter, Int $count --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Int $count; number of characters to move (negative moves left,  positive moves right)

=end pod

sub gtk_text_view_move_visually ( N-GObject $text_view, N-GObject $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_im_context_filter_keypress:
=begin pod
=head2 [gtk_text_view_] im_context_filter_keypress

Allow the B<Gnome::Gtk3::TextView> input method to internally handle key press
and release events. If this function returns C<1>, then no further
processing should be done for this key event. See
C<gtk_im_context_filter_keypress()>.

Note that you are expected to call this function from your handler
when overriding key event handling. This is needed in the case when
you need to insert your own key handling between the input method
and the default key event handling of the B<Gnome::Gtk3::TextView>.

|[<!-- language="C" -->
static gboolean
gtk_foo_bar_key_press_event (B<Gnome::Gtk3::Widget>   *widget,
B<Gnome::Gdk3::EventKey> *event)
{
if ((key->keyval == GDK_KEY_Return || key->keyval == GDK_KEY_KP_Enter))
{
if (gtk_text_view_im_context_filter_keypress (GTK_TEXT_VIEW (view), event))
return TRUE;
}

// Do some stuff

return GTK_WIDGET_CLASS (gtk_foo_bar_parent_class)->key_press_event (widget, event);
}
]|

Returns: C<1> if the input method handled the key event.

Since: 2.22

  method gtk_text_view_im_context_filter_keypress ( GdkEventKey $event --> Int  )

=item GdkEventKey $event; the key event

=end pod

sub gtk_text_view_im_context_filter_keypress ( N-GObject $text_view, GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_reset_im_context:
=begin pod
=head2 [gtk_text_view_] reset_im_context

Reset the input method context of the text view if needed.

This can be necessary in the case where modifying the buffer
would confuse on-going input method behavior.

Since: 2.22

  method gtk_text_view_reset_im_context ( )


=end pod

sub gtk_text_view_reset_im_context ( N-GObject $text_view )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_add_child_at_anchor:
=begin pod
=head2 [gtk_text_view_] add_child_at_anchor

Adds a child widget in the text buffer, at the given I<anchor>.

  method gtk_text_view_add_child_at_anchor ( N-GObject $child, GtkTextChildAnchor $anchor )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>
=item GtkTextChildAnchor $anchor; a B<Gnome::Gtk3::TextChildAnchor> in the B<Gnome::Gtk3::TextBuffer> for I<text_view>

=end pod

sub gtk_text_view_add_child_at_anchor ( N-GObject $text_view, N-GObject $child, GtkTextChildAnchor $anchor )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_add_child_in_window:
=begin pod
=head2 [gtk_text_view_] add_child_in_window

Adds a child at fixed coordinates in one of the text widget's windows.

The window must have nonzero size (see C<gtk_text_view_set_border_window_size()>). Note that the child coordinates are given relative to scrolling. When placing a child in C<GTK_TEXT_WINDOW_WIDGET>, scrolling is irrelevant, the child floats above all scrollable areas. But when placing a child in one of the scrollable windows (border windows or text window) it will move with the scrolling as needed.

  method gtk_text_view_add_child_in_window (
    N-GObject $child, GtkTextWindowType $which_window, Int $xpos, Int $ypos
  )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>
=item GtkTextWindowType $which_window; which window the child should appear in
=item Int $xpos; X position of child in window coordinates
=item Int $ypos; Y position of child in window coordinates

=end pod

sub gtk_text_view_add_child_in_window ( N-GObject $text_view, N-GObject $child, int32 $which_window, int32 $xpos, int32 $ypos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_move_child:
=begin pod
=head2 [gtk_text_view_] move_child

Updates the position of a child, as for C<gtk_text_view_add_child_in_window()>.

  method gtk_text_view_move_child ( N-GObject $child,  Int $xpos, Int $ypos )

=item N-GObject $child; child widget already added to the text view
=item Int $xpos; new X position in window coordinates
=item Int $ypos; new Y position in window coordinates

=end pod

sub gtk_text_view_move_child ( N-GObject $text_view, N-GObject $child,  int32 $xpos, int32 $ypos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_wrap_mode:
=begin pod
=head2 [gtk_text_view_] set_wrap_mode

Sets the line wrapping for the view.

  method gtk_text_view_set_wrap_mode ( GtkWrapMode $wrap_mode )

=item GtkWrapMode $wrap_mode; a B<Gnome::Gtk3::WrapMode>

=end pod

sub gtk_text_view_set_wrap_mode ( N-GObject $text_view, int32 $wrap_mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_wrap_mode:
=begin pod
=head2 [gtk_text_view_] get_wrap_mode

Gets the line wrapping for the view.

Returns: the line wrap setting

  method gtk_text_view_get_wrap_mode ( --> GtkWrapMode  )


=end pod

sub gtk_text_view_get_wrap_mode ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_editable:
=begin pod
=head2 [gtk_text_view_] set_editable

Sets the default editability of the B<Gnome::Gtk3::TextView>. You can override
this default setting with tags in the buffer, using the “editable”
attribute of tags.

  method gtk_text_view_set_editable ( Int $setting )

=item Int $setting; whether it’s editable

=end pod

sub gtk_text_view_set_editable ( N-GObject $text_view, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_editable:
=begin pod
=head2 [gtk_text_view_] get_editable

Returns the default editability of the B<Gnome::Gtk3::TextView>. Tags in the
buffer may override this setting for some ranges of text.

Returns: whether text is editable by default

  method gtk_text_view_get_editable ( --> Int  )


=end pod

sub gtk_text_view_get_editable ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_overwrite:
=begin pod
=head2 [gtk_text_view_] set_overwrite

Changes the B<Gnome::Gtk3::TextView> overwrite mode.

Since: 2.4

  method gtk_text_view_set_overwrite ( Int $overwrite )

=item Int $overwrite; C<1> to turn on overwrite mode, C<0> to turn it off

=end pod

sub gtk_text_view_set_overwrite ( N-GObject $text_view, int32 $overwrite )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_overwrite:
=begin pod
=head2 [gtk_text_view_] get_overwrite

Returns whether the B<Gnome::Gtk3::TextView> is in overwrite mode or not.

Returns: whether I<text_view> is in overwrite mode or not.

Since: 2.4

  method gtk_text_view_get_overwrite ( --> Int  )


=end pod

sub gtk_text_view_get_overwrite ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_accepts_tab:
=begin pod
=head2 [gtk_text_view_] set_accepts_tab

Sets the behavior of the text widget when the Tab key is pressed.
If I<accepts_tab> is C<1>, a tab character is inserted. If I<accepts_tab>
is C<0> the keyboard focus is moved to the next widget in the focus
chain.

Since: 2.4

  method gtk_text_view_set_accepts_tab ( Int $accepts_tab )

=item Int $accepts_tab; C<1> if pressing the Tab key should insert a tab  character, C<0>, if pressing the Tab key should move the  keyboard focus.

=end pod

sub gtk_text_view_set_accepts_tab ( N-GObject $text_view, int32 $accepts_tab )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_accepts_tab:
=begin pod
=head2 [gtk_text_view_] get_accepts_tab

Returns whether pressing the Tab key inserts a tab characters.
C<gtk_text_view_set_accepts_tab()>.

Returns: C<1> if pressing the Tab key inserts a tab character,
C<0> if pressing the Tab key moves the keyboard focus.

Since: 2.4

  method gtk_text_view_get_accepts_tab ( --> Int  )


=end pod

sub gtk_text_view_get_accepts_tab ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_pixels_above_lines:
=begin pod
=head2 [gtk_text_view_] set_pixels_above_lines

Sets the default number of blank pixels above paragraphs in I<text_view>.
Tags in the buffer for I<text_view> may override the defaults.

  method gtk_text_view_set_pixels_above_lines ( Int $pixels_above_lines )

=item Int $pixels_above_lines; pixels above paragraphs

=end pod

sub gtk_text_view_set_pixels_above_lines ( N-GObject $text_view, int32 $pixels_above_lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_pixels_above_lines:
=begin pod
=head2 [gtk_text_view_] get_pixels_above_lines

Gets the default number of pixels to put above paragraphs.
Adding this function with C<gtk_text_view_get_pixels_below_lines()>
is equal to the line space between each paragraph.

Returns: default number of pixels above paragraphs

  method gtk_text_view_get_pixels_above_lines ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_above_lines ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_pixels_below_lines:
=begin pod
=head2 [gtk_text_view_] set_pixels_below_lines

Sets the default number of pixels of blank space
to put below paragraphs in I<text_view>. May be overridden
by tags applied to I<text_view>’s buffer.

  method gtk_text_view_set_pixels_below_lines ( Int $pixels_below_lines )

=item Int $pixels_below_lines; pixels below paragraphs

=end pod

sub gtk_text_view_set_pixels_below_lines ( N-GObject $text_view, int32 $pixels_below_lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_pixels_below_lines:
=begin pod
=head2 [gtk_text_view_] get_pixels_below_lines

Gets the value set by C<gtk_text_view_set_pixels_below_lines()>.

The line space is the sum of the value returned by this function and the
value returned by C<gtk_text_view_get_pixels_above_lines()>.

Returns: default number of blank pixels below paragraphs

  method gtk_text_view_get_pixels_below_lines ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_below_lines ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_pixels_inside_wrap:
=begin pod
=head2 [gtk_text_view_] set_pixels_inside_wrap

Sets the default number of pixels of blank space to leave between
display/wrapped lines within a paragraph. May be overridden by
tags in I<text_view>’s buffer.

  method gtk_text_view_set_pixels_inside_wrap ( Int $pixels_inside_wrap )

=item Int $pixels_inside_wrap; default number of pixels between wrapped lines

=end pod

sub gtk_text_view_set_pixels_inside_wrap ( N-GObject $text_view, int32 $pixels_inside_wrap )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_pixels_inside_wrap:
=begin pod
=head2 [gtk_text_view_] get_pixels_inside_wrap

Gets the value set by C<gtk_text_view_set_pixels_inside_wrap()>.

Returns: default number of pixels of blank space between wrapped lines

  method gtk_text_view_get_pixels_inside_wrap ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_inside_wrap ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_justification:
=begin pod
=head2 [gtk_text_view_] set_justification

Sets the default justification of text in I<text_view>.
Tags in the view’s buffer may override the default.


  method gtk_text_view_set_justification ( GtkJustification $justification )

=item GtkJustification $justification; justification

=end pod

sub gtk_text_view_set_justification ( N-GObject $text_view, int32 $justification )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_justification:
=begin pod
=head2 [gtk_text_view_] get_justification

Gets the default justification of paragraphs in I<text_view>.
Tags in the buffer may override the default.

Returns: default justification

  method gtk_text_view_get_justification ( --> GtkJustification  )


=end pod

sub gtk_text_view_get_justification ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_left_margin:
=begin pod
=head2 [gtk_text_view_] set_left_margin

Sets the default left margin for text in I<text_view>.
Tags in the buffer may override the default.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

  method gtk_text_view_set_left_margin ( Int $left_margin )

=item Int $left_margin; left margin in pixels

=end pod

sub gtk_text_view_set_left_margin ( N-GObject $text_view, int32 $left_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_left_margin:
=begin pod
=head2 [gtk_text_view_] get_left_margin

Gets the default left margin size of paragraphs in the I<text_view>.
Tags in the buffer may override the default.

Returns: left margin in pixels

  method gtk_text_view_get_left_margin ( --> Int  )


=end pod

sub gtk_text_view_get_left_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_right_margin:
=begin pod
=head2 [gtk_text_view_] set_right_margin

Sets the default right margin for text in the text view.
Tags in the buffer may override the default.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

  method gtk_text_view_set_right_margin ( Int $right_margin )

=item Int $right_margin; right margin in pixels

=end pod

sub gtk_text_view_set_right_margin ( N-GObject $text_view, int32 $right_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_right_margin:
=begin pod
=head2 [gtk_text_view_] get_right_margin

Gets the default right margin for text in I<text_view>. Tags
in the buffer may override the default.

Returns: right margin in pixels

  method gtk_text_view_get_right_margin ( --> Int  )


=end pod

sub gtk_text_view_get_right_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_top_margin:
=begin pod
=head2 [gtk_text_view_] set_top_margin

Sets the top margin for text in I<text_view>.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

Since: 3.18

  method gtk_text_view_set_top_margin ( Int $top_margin )

=item Int $top_margin; top margin in pixels

=end pod

sub gtk_text_view_set_top_margin ( N-GObject $text_view, int32 $top_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_top_margin:
=begin pod
=head2 [gtk_text_view_] get_top_margin

Gets the top margin for text in the I<text_view>.

Returns: top margin in pixels

Since: 3.18

  method gtk_text_view_get_top_margin ( --> Int  )


=end pod

sub gtk_text_view_get_top_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_bottom_margin:
=begin pod
=head2 [gtk_text_view_] set_bottom_margin

Sets the bottom margin for text in I<text_view>.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

Since: 3.18

  method gtk_text_view_set_bottom_margin ( Int $bottom_margin )

=item Int $bottom_margin; bottom margin in pixels

=end pod

sub gtk_text_view_set_bottom_margin ( N-GObject $text_view, int32 $bottom_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_bottom_margin:
=begin pod
=head2 [gtk_text_view_] get_bottom_margin

Gets the bottom margin for text in the I<text_view>.

Returns: bottom margin in pixels

Since: 3.18

  method gtk_text_view_get_bottom_margin ( --> Int  )


=end pod

sub gtk_text_view_get_bottom_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_indent:
=begin pod
=head2 [gtk_text_view_] set_indent

Sets the default indentation for paragraphs in I<text_view>.
Tags in the buffer may override the default.

  method gtk_text_view_set_indent ( Int $indent )

=item Int $indent; indentation in pixels

=end pod

sub gtk_text_view_set_indent ( N-GObject $text_view, int32 $indent )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_indent:
=begin pod
=head2 [gtk_text_view_] get_indent

Gets the default indentation of paragraphs in I<text_view>.
Tags in the view’s buffer may override the default.
The indentation may be negative.

Returns: number of pixels of indentation

  method gtk_text_view_get_indent ( --> Int  )


=end pod

sub gtk_text_view_get_indent ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_tabs:
=begin pod
=head2 [gtk_text_view_] set_tabs

Sets the default tab stops for paragraphs in I<text_view>.
Tags in the buffer may override the default.

  method gtk_text_view_set_tabs ( PangoTabArray $tabs )

=item PangoTabArray $tabs; tabs as a B<PangoTabArray>

=end pod

sub gtk_text_view_set_tabs ( N-GObject $text_view, PangoTabArray $tabs )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_tabs:
=begin pod
=head2 [gtk_text_view_] get_tabs

Gets the default tabs for I<text_view>. Tags in the buffer may
override the defaults. The returned array will be C<Any> if
“standard” (8-space) tabs are used. Free the return value
with C<pango_tab_array_free()>.

Returns: (nullable) (transfer full): copy of default tab array, or C<Any> if
“standard" tabs are used; must be freed with C<pango_tab_array_free()>.

  method gtk_text_view_get_tabs ( --> PangoTabArray  )


=end pod

sub gtk_text_view_get_tabs ( N-GObject $text_view )
  returns PangoTabArray
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_default_attributes:
=begin pod
=head2 [gtk_text_view_] get_default_attributes

Obtains a copy of the default text attributes. These are the
attributes used for text unless a tag overrides them.
You’d typically pass the default attributes in to
C<gtk_text_iter_get_attributes()> in order to get the
attributes in effect at a given text position.

The return value is a copy owned by the caller of this function,
and should be freed with C<gtk_text_attributes_unref()>.

Returns: a new B<Gnome::Gtk3::TextAttributes>

  method gtk_text_view_get_default_attributes ( --> N-GObject  )


=end pod

sub gtk_text_view_get_default_attributes ( N-GObject $text_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_input_purpose:
=begin pod
=head2 [gtk_text_view_] set_input_purpose

Sets the  I<input-purpose> property which
can be used by on-screen keyboards and other input
methods to adjust their behaviour.

Since: 3.6

  method gtk_text_view_set_input_purpose ( GtkInputPurpose $purpose )

=item GtkInputPurpose $purpose; the purpose

=end pod

sub gtk_text_view_set_input_purpose ( N-GObject $text_view, int32 $purpose )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_input_purpose:
=begin pod
=head2 [gtk_text_view_] get_input_purpose

Gets the value of the  I<input-purpose> property.

Since: 3.6

  method gtk_text_view_get_input_purpose ( --> GtkInputPurpose  )


=end pod

sub gtk_text_view_get_input_purpose ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_input_hints:
=begin pod
=head2 [gtk_text_view_] set_input_hints

Sets the  I<input-hints> property, which
allows input methods to fine-tune their behaviour.

Since: 3.6

  method gtk_text_view_set_input_hints ( GtkInputHints $hints )

=item GtkInputHints $hints; the hints

=end pod

sub gtk_text_view_set_input_hints ( N-GObject $text_view, int32 $hints )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_input_hints:
=begin pod
=head2 [gtk_text_view_] get_input_hints

Gets the value of the  I<input-hints> property.

Since: 3.6

  method gtk_text_view_get_input_hints ( --> GtkInputHints  )


=end pod

sub gtk_text_view_get_input_hints ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_set_monospace:
=begin pod
=head2 [gtk_text_view_] set_monospace

Sets the  I<monospace> property, which
indicates that the text view should use monospace
fonts.

Since: 3.16

  method gtk_text_view_set_monospace ( Int $monospace )

=item Int $monospace; C<1> to request monospace styling

=end pod

sub gtk_text_view_set_monospace ( N-GObject $text_view, int32 $monospace )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_view_get_monospace:
=begin pod
=head2 [gtk_text_view_] get_monospace

Gets the value of the  I<monospace> property.

Return: C<1> if monospace fonts are desired

Since: 3.16

  method gtk_text_view_get_monospace ( --> Int  )


=end pod

sub gtk_text_view_get_monospace ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:move-cursor:
=head3 move-cursor

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically.

The default bindings for this signal come in two variants,
the variant with the Shift modifier extends the selection,
the variant without the Shift modifer does not.
There are too many key combinations to list them all here.
- Arrow keys move by individual characters/lines
- Ctrl-arrow key combinations move by words/paragraphs
- Home/End keys move to the ends of the buffer
- PageUp/PageDown keys move vertically by pages
- Ctrl-PageUp/PageDown keys move horizontally by pages

  method handler (
    Unknown type GTK_TYPE_MOVEMENT_STEP $step,
    Int $count,
    Int $extend_selection,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>

=item $count; the number of I<step> units to move

=item $extend_selection; C<1> if the move should extend the selection



=comment #TS:0:move-viewport:
=head3 move-viewport

The I<move-viewport> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which can be bound to key combinations to allow the user
to move the viewport, i.e. change what part of the text view
is visible in a containing scrolled window.

There are no default bindings for this signal.

  method handler (
    Unknown type GTK_TYPE_SCROLL_STEP $step,
    Int $count,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal

=item $step; the granularity of the movement, as a B<Gnome::Gtk3::ScrollStep>

=item $count; the number of I<step> units to move


=comment #TS:0:set-anchor:
=head3 set-anchor

The I<set-anchor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates setting the "anchor"
mark. The "anchor" mark gets placed at the same position as the
"insert" mark.

This signal has no default bindings.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:insert-at-cursor:
=head3 insert-at-cursor

The I<insert-at-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates the insertion of a
fixed string at the cursor.

This signal has no default bindings.

  method handler (
    Str $string,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal

=item $string; the string to insert


=comment #TS:0:delete-from-cursor:
=head3 delete-from-cursor

The I<delete-from-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a text deletion.

If the I<type> is C<GTK_DELETE_CHARS>, GTK+ deletes the selection
if there is one, otherwise it deletes the requested number
of characters.

The default bindings for this signal are
Delete for deleting a character, Ctrl-Delete for
deleting a word and Ctrl-Backspace for deleting a word
backwords.

  method handler (
    Unknown type GTK_TYPE_DELETE_TYPE $type,
    Int $count,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal

=item $type; the granularity of the deletion, as a B<Gnome::Gtk3::DeleteType>

=item $count; the number of I<type> units to delete


=comment #TS:0:backspace:
=head3 backspace

The I<backspace> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user asks for it.

The default bindings for this signal are
Backspace and Shift-Backspace.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:cut-clipboard:
=head3 cut-clipboard

The I<cut-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are
Ctrl-x and Shift-Delete.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:copy-clipboard:
=head3 copy-clipboard

The I<copy-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are
Ctrl-c and Ctrl-Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:paste-clipboard:
=head3 paste-clipboard

The I<paste-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to paste the contents of the clipboard
into the text view.

The default bindings for this signal are
Ctrl-v and Shift-Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:toggle-overwrite:
=head3 toggle-overwrite

The I<toggle-overwrite> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to toggle the overwrite mode of the text view.

The default bindings for this signal is Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:populate-popup:
=head3 populate-popup

The I<populate-popup> signal gets emitted before showing the
context menu of the text view.

If you need to add items to the context menu, connect
to this signal and append your items to the I<popup>, which
will be a B<Gnome::Gtk3::Menu> in this case.

If  I<populate-all> is C<1>, this signal will
also be emitted to populate touch popups. In this case,
I<popup> will be a different container, e.g. a B<Gnome::Gtk3::Toolbar>.

The signal handler should not make assumptions about the
type of I<widget>, but check whether I<popup> is a B<Gnome::Gtk3::Menu>
or B<Gnome::Gtk3::Toolbar> or another kind of container.

  method handler (
    N-GObject $popup,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; The text view on which the signal is emitted

=item $popup; the container that is being populated


=comment #TS:0:select-all:
=head3 select-all

The I<select-all> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to select or unselect the complete
contents of the text view.

The default bindings for this signal are Ctrl-a and Ctrl-/
for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.

  method handler (
    Int $select,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal

=item $select; C<1> to select, C<0> to unselect


=comment #TS:0:toggle-cursor-visible:
=head3 toggle-cursor-visible

The I<toggle-cursor-visible> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to toggle the  I<cursor-visible>
property.

The default binding for this signal is F7.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal


=comment #TS:0:preedit-changed:
=head3 preedit-changed

If an input method is used, the typed text will not immediately
be committed to the buffer. So if you are interested in the text,
connect to this signal.

This signal is only emitted if the text at the given position
is actually editable.

Since: 2.20

  method handler (
    Str $preedit,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
  );

=item $text_view; the object which received the signal
=item $preedit; the current preedit string


=begin comment
=comment #TS:0:extend-selection:
=head3 extend-selection

The I<extend-selection> signal is emitted when the selection needs to be
extended at I<location>.

Returns: C<GDK_EVENT_STOP> to stop other handlers from being invoked for the
event. C<GDK_EVENT_PROPAGATE> to propagate the event further.
Since: 3.16

  method handler (
    Unknown type GTK_TYPE_TEXT_EXTEND_SELECTION $granularity,
    Unknown type GTK_TYPE_TEXT_ITER | G_SIGNAL_TYPE_STATIC_SCOPE $location,
    Unknown type GTK_TYPE_TEXT_ITER | G_SIGNAL_TYPE_STATIC_SCOPE $start,
    Unknown type GTK_TYPE_TEXT_ITER | G_SIGNAL_TYPE_STATIC_SCOPE $end,
    Gnome::GObject::Object :widget($text_view),
    *%user-options
    --> int32
  );

=item $text_view; the object which received the signal
=item $granularity; the granularity type
=item $location; the location where to extend the selection
=item $start; where the selection should start
=item $end; where the selection should end
=end comment
=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:pixels-above-lines:
=head3 Pixels Above Lines



The B<Gnome::GObject::Value> type of property I<pixels-above-lines> is C<G_TYPE_INT>.

=comment #TP:0:pixels-below-lines:
=head3 Pixels Below Lines



The B<Gnome::GObject::Value> type of property I<pixels-below-lines> is C<G_TYPE_INT>.

=comment #TP:0:pixels-inside-wrap:
=head3 Pixels Inside Wrap



The B<Gnome::GObject::Value> type of property I<pixels-inside-wrap> is C<G_TYPE_INT>.

=comment #TP:0:editable:
=head3 Editable

Whether the text can be modified by the user
Default value: True


The B<Gnome::GObject::Value> type of property I<editable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:wrap-mode:
=head3 Wrap Mode

Whether to wrap lines never, at word boundaries_COMMA_ or at character boundaries
Default value: False


The B<Gnome::GObject::Value> type of property I<wrap-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:justification:
=head3 Justification

Left, right_COMMA_ or center justification
Default value: False


The B<Gnome::GObject::Value> type of property I<justification> is C<G_TYPE_ENUM>.

=comment #TP:0:left-margin:
=head3 Left Margin


The default left margin for text in the text view.
Tags in the buffer may override the default.
Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.
Don't confuse this property with  I<margin-left>.

The B<Gnome::GObject::Value> type of property I<left-margin> is C<G_TYPE_INT>.

=comment #TP:0:right-margin:
=head3 Right Margin


The default right margin for text in the text view.
Tags in the buffer may override the default.
Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.
Don't confuse this property with  I<margin-right>.

The B<Gnome::GObject::Value> type of property I<right-margin> is C<G_TYPE_INT>.

=comment #TP:0:top-margin:
=head3 Top Margin


The top margin for text in the text view.
Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.
Don't confuse this property with  I<margin-top>.
Since: 3.18

The B<Gnome::GObject::Value> type of property I<top-margin> is C<G_TYPE_INT>.

=comment #TP:0:bottom-margin:
=head3 Bottom Margin


The bottom margin for text in the text view.
Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.
Don't confuse this property with  I<margin-bottom>.
Since: 3.18

The B<Gnome::GObject::Value> type of property I<bottom-margin> is C<G_TYPE_INT>.

=comment #TP:0:indent:
=head3 Indent



The B<Gnome::GObject::Value> type of property I<indent> is C<G_TYPE_INT>.

=comment #TP:0:tabs:
=head3 Tabs



The B<Gnome::GObject::Value> type of property I<tabs> is C<G_TYPE_BOXED>.

=comment #TP:0:cursor-visible:
=head3 Cursor Visible

If the insertion cursor is shown
Default value: True


The B<Gnome::GObject::Value> type of property I<cursor-visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:buffer:
=head3 Buffer

The buffer which is displayed
Widget type: GTK_TYPE_TEXT_BUFFER


The B<Gnome::GObject::Value> type of property I<buffer> is C<G_TYPE_OBJECT>.

=comment #TP:0:overwrite:
=head3 Overwrite mode

Whether entered text overwrites existing contents
Default value: False


The B<Gnome::GObject::Value> type of property I<overwrite> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:accepts-tab:
=head3 Accepts tab

Whether Tab will result in a tab character being entered
Default value: True


The B<Gnome::GObject::Value> type of property I<accepts-tab> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:im-module:
=head3 IM module


Which IM (input method) module should be used for this text_view.
See B<Gnome::Gtk3::IMContext>.
Setting this to a non-C<Any> value overrides the
system-wide IM module setting. See the B<Gnome::Gtk3::Settings>
 I<gtk-im-module> property.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<im-module> is C<G_TYPE_STRING>.

=comment #TP:0:input-purpose:
=head3 Purpose


The purpose of this text field.
This property can be used by on-screen keyboards and other input
methods to adjust their behaviour.
Since: 3.6
Widget type: GTK_TYPE_INPUT_PURPOSE

The B<Gnome::GObject::Value> type of property I<input-purpose> is C<G_TYPE_ENUM>.

=comment #TP:0:input-hints:
=head3 hints


Additional hints (beyond  I<input-purpose>) that
allow input methods to fine-tune their behaviour.
Since: 3.6

The B<Gnome::GObject::Value> type of property I<input-hints> is C<G_TYPE_FLAGS>.

=comment #TP:0:populate-all:
=head3 Populate all


If I<populate-all> is C<1>, the  I<populate-popup>
signal is also emitted for touch popups.
Since: 3.8

The B<Gnome::GObject::Value> type of property I<populate-all> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:monospace:
=head3 Monospace


If C<1>, set the C<GTK_STYLE_CLASS_MONOSPACE> style class on the
text view to indicate that a monospace font is desired.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<monospace> is C<G_TYPE_BOOLEAN>.
=end pod

































=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_view_new

Creates a new B<Gnome::Gtk3::TextView>. If you don’t call C<gtk_text_view_set_buffer()>
before using the text view, an empty default buffer will be created
for you. Get the buffer with C<gtk_text_view_get_buffer()>. If you want
to specify your own buffer, consider C<gtk_text_view_new_with_buffer()>.

Returns: a new B<Gnome::Gtk3::TextView>

  method gtk_text_view_new ( --> N-GObject  )


=end pod

sub gtk_text_view_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] new_with_buffer

Creates a new B<Gnome::Gtk3::TextView> widget displaying the buffer
I<buffer>. One buffer can be shared among many widgets.
I<buffer> may be C<Any> to create a default buffer, in which case
this function is equivalent to C<gtk_text_view_new()>. The
text view adds its own reference count to the buffer; it does not
take over an existing reference.

Returns: a new B<Gnome::Gtk3::TextView>.

  method gtk_text_view_new_with_buffer ( N-GObject $buffer --> N-GObject  )

=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>

=end pod

sub gtk_text_view_new_with_buffer ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_buffer

Sets I<buffer> as the buffer being displayed by I<text_view>. The previous
buffer displayed by the text view is unreferenced, and a reference is
added to I<buffer>. If you owned a reference to I<buffer> before passing it
to this function, you must remove that reference yourself; B<Gnome::Gtk3::TextView>
will not “adopt” it.

  method gtk_text_view_set_buffer ( N-GObject $buffer )

=item N-GObject $buffer; (allow-none): a B<Gnome::Gtk3::TextBuffer>

=end pod

sub gtk_text_view_set_buffer ( N-GObject $text_view, N-GObject $buffer )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_buffer

Returns the B<Gnome::Gtk3::TextBuffer> being displayed by this text view.
The reference count on the buffer is not incremented; the caller
of this function won’t own a new reference.

Returns: (transfer none): a B<Gnome::Gtk3::TextBuffer>

  method gtk_text_view_get_buffer ( --> N-GObject  )


=end pod

sub gtk_text_view_get_buffer ( N-GObject $text_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] scroll_to_iter

Scrolls I<text_view> so that I<iter> is on the screen in the position
indicated by I<xalign> and I<yalign>. An alignment of 0.0 indicates
left or top, 1.0 indicates right or bottom, 0.5 means center.
If I<use_align> is C<0>, the text scrolls the minimal distance to
get the mark onscreen, possibly not scrolling at all. The effective
screen for purposes of this function is reduced by a margin of size
I<within_margin>.

Note that this function uses the currently-computed height of the
lines in the text buffer. Line heights are computed in an idle
handler; so this function may not have the desired effect if it’s
called before the height computations. To avoid oddness, consider
using C<gtk_text_view_scroll_to_mark()> which saves a point to be
scrolled to after line validation.

Returns: C<1> if scrolling occurred

  method gtk_text_view_scroll_to_iter ( N-GObject $iter, Num $within_margin, Int $use_align, Num $xalign, Num $yalign --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Num $within_margin; margin as a [0.0,0.5) fraction of screen size
=item Int $use_align; whether to use alignment arguments (if C<0>, just get the mark onscreen)
=item Num $xalign; horizontal alignment of mark within visible area
=item Num $yalign; vertical alignment of mark within visible area

=end pod

sub gtk_text_view_scroll_to_iter ( N-GObject $text_view, N-GObject $iter, num64 $within_margin, int32 $use_align, num64 $xalign, num64 $yalign )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] scroll_to_mark

Scrolls I<text_view> so that I<mark> is on the screen in the position
indicated by I<xalign> and I<yalign>. An alignment of 0.0 indicates
left or top, 1.0 indicates right or bottom, 0.5 means center.
If I<use_align> is C<0>, the text scrolls the minimal distance to
get the mark onscreen, possibly not scrolling at all. The effective
screen for purposes of this function is reduced by a margin of size
I<within_margin>.

  method gtk_text_view_scroll_to_mark ( N-GObject $mark, Num $within_margin, Int $use_align, Num $xalign, Num $yalign )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark>
=item Num $within_margin; margin as a [0.0,0.5) fraction of screen size
=item Int $use_align; whether to use alignment arguments (if C<0>, just  get the mark onscreen)
=item Num $xalign; horizontal alignment of mark within visible area
=item Num $yalign; vertical alignment of mark within visible area

=end pod

sub gtk_text_view_scroll_to_mark ( N-GObject $text_view, N-GObject $mark, num64 $within_margin, int32 $use_align, num64 $xalign, num64 $yalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] scroll_mark_onscreen

Scrolls I<text_view> the minimum distance such that I<mark> is contained
within the visible area of the widget.

  method gtk_text_view_scroll_mark_onscreen ( N-GObject $mark )

=item N-GObject $mark; a mark in the buffer for I<text_view>

=end pod

sub gtk_text_view_scroll_mark_onscreen ( N-GObject $text_view, N-GObject $mark )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] move_mark_onscreen

Moves a mark within the buffer so that it's
located within the currently-visible text area.

Returns: C<1> if the mark moved (wasn’t already onscreen)

  method gtk_text_view_move_mark_onscreen ( N-GObject $mark --> Int  )

=item N-GObject $mark; a B<Gnome::Gtk3::TextMark>

=end pod

sub gtk_text_view_move_mark_onscreen ( N-GObject $text_view, N-GObject $mark )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] place_cursor_onscreen

Moves the cursor to the currently visible region of the
buffer, it it isn’t there already.

Returns: C<1> if the cursor had to be moved.

  method gtk_text_view_place_cursor_onscreen ( --> Int  )


=end pod

sub gtk_text_view_place_cursor_onscreen ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_visible_rect

Fills I<visible_rect> with the currently-visible
region of the buffer, in buffer coordinates. Convert to window coordinates
with C<gtk_text_view_buffer_to_window_coords()>.

  method gtk_text_view_get_visible_rect ( N-GObject $visible_rect )

=item N-GObject $visible_rect; (out): rectangle to fill

=end pod

sub gtk_text_view_get_visible_rect ( N-GObject $text_view, N-GObject $visible_rect )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_cursor_visible

Toggles whether the insertion point should be displayed. A buffer with
no editable text probably shouldn’t have a visible cursor, so you may
want to turn the cursor off.

Note that this property may be overridden by the
prop C<gtk-keynave-use-caret> settings.

  method gtk_text_view_set_cursor_visible ( Int $setting )

=item Int $setting; whether to show the insertion cursor

=end pod

sub gtk_text_view_set_cursor_visible ( N-GObject $text_view, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_cursor_visible

Find out whether the cursor should be displayed.

Returns: whether the insertion mark is visible

  method gtk_text_view_get_cursor_visible ( --> Int  )


=end pod

sub gtk_text_view_get_cursor_visible ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] reset_cursor_blink

Ensures that the cursor is shown (i.e. not in an 'off' blink
interval) and resets the time that it will stay blinking (or
visible, in case blinking is disabled).

This function should be called in response to user input
(e.g. from derived classes that override the textview's
sig C<key-press-event> handler).

Since: 3.20

  method gtk_text_view_reset_cursor_blink ( )


=end pod

sub gtk_text_view_reset_cursor_blink ( N-GObject $text_view )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_cursor_locations

Given an I<iter> within a text layout, determine the positions of the
strong and weak cursors if the insertion point is at that
iterator. The position of each cursor is stored as a zero-width
rectangle. The strong cursor location is the location where
characters of the directionality equal to the base direction of the
paragraph are inserted.  The weak cursor location is the location
where characters of the directionality opposite to the base
direction of the paragraph are inserted.

If I<iter> is C<Any>, the actual cursor position is used.

Note that if I<iter> happens to be the actual cursor position, and
there is currently an IM preedit sequence being entered, the
returned locations will be adjusted to account for the preedit
cursor’s offset within the preedit sequence.

The rectangle position is in buffer coordinates; use
C<gtk_text_view_buffer_to_window_coords()> to convert these
coordinates to coordinates for one of the windows in the text view.

Since: 3.0

  method gtk_text_view_get_cursor_locations ( N-GObject $iter, N-GObject $strong, N-GObject $weak )

=item N-GObject $iter; (allow-none): a B<Gnome::Gtk3::TextIter>
=item N-GObject $strong; (out) (allow-none): location to store the strong cursor position (may be C<Any>)
=item N-GObject $weak; (out) (allow-none): location to store the weak cursor position (may be C<Any>)

=end pod

sub gtk_text_view_get_cursor_locations ( N-GObject $text_view, N-GObject $iter, N-GObject $strong, N-GObject $weak )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_iter_location

Gets a rectangle which roughly contains the character at I<iter>.
The rectangle position is in buffer coordinates; use
C<gtk_text_view_buffer_to_window_coords()> to convert these
coordinates to coordinates for one of the windows in the text view.

  method gtk_text_view_get_iter_location ( N-GObject $iter, N-GObject $location )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item N-GObject $location; (out): bounds of the character at I<iter>

=end pod

sub gtk_text_view_get_iter_location ( N-GObject $text_view, N-GObject $iter, N-GObject $location )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_iter_at_location

Retrieves the iterator at buffer coordinates I<x> and I<y>. Buffer
coordinates are coordinates for the entire buffer, not just the
currently-displayed portion.  If you have coordinates from an
event, you have to convert those to buffer coordinates with
C<gtk_text_view_window_to_buffer_coords()>.

Returns: C<1> if the position is over text

  method gtk_text_view_get_iter_at_location ( N-GObject $iter, Int $x, Int $y --> Int  )

=item N-GObject $iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $x; x position, in buffer coordinates
=item Int $y; y position, in buffer coordinates

=end pod

sub gtk_text_view_get_iter_at_location ( N-GObject $text_view, N-GObject $iter, int32 $x, int32 $y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_iter_at_position

Retrieves the iterator pointing to the character at buffer
coordinates I<x> and I<y>. Buffer coordinates are coordinates for
the entire buffer, not just the currently-displayed portion.
If you have coordinates from an event, you have to convert
those to buffer coordinates with
C<gtk_text_view_window_to_buffer_coords()>.

Note that this is different from C<gtk_text_view_get_iter_at_location()>,
which returns cursor locations, i.e. positions between
characters.

Returns: C<1> if the position is over text

Since: 2.6

  method gtk_text_view_get_iter_at_position ( N-GObject $iter, Int $trailing, Int $x, Int $y --> Int  )

=item N-GObject $iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $trailing; (out) (allow-none): if non-C<Any>, location to store an integer indicating where in the grapheme the user clicked. It will either be zero, or the number of characters in the grapheme. 0 represents the trailing edge of the grapheme.
=item Int $x; x position, in buffer coordinates
=item Int $y; y position, in buffer coordinates

=end pod

sub gtk_text_view_get_iter_at_position ( N-GObject $text_view, N-GObject $iter, int32 $trailing, int32 $x, int32 $y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_line_yrange

Gets the y coordinate of the top of the line containing I<iter>,
and the height of the line. The coordinate is a buffer coordinate;
convert to window coordinates with C<gtk_text_view_buffer_to_window_coords()>.

  method gtk_text_view_get_line_yrange ( N-GObject $iter, Int $y, Int $height )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Int $y; (out): return location for a y coordinate
=item Int $height; (out): return location for a height

=end pod

sub gtk_text_view_get_line_yrange ( N-GObject $text_view, N-GObject $iter, int32 $y, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_line_at_y

Gets the B<Gnome::Gtk3::TextIter> at the start of the line containing
the coordinate I<y>. I<y> is in buffer coordinates, convert from
window coordinates with C<gtk_text_view_window_to_buffer_coords()>.
If non-C<Any>, I<line_top> will be filled with the coordinate of the top
edge of the line.

  method gtk_text_view_get_line_at_y ( N-GObject $target_iter, Int $y, Int $line_top )

=item N-GObject $target_iter; (out): a B<Gnome::Gtk3::TextIter>
=item Int $y; a y coordinate
=item Int $line_top; (out): return location for top coordinate of the line

=end pod

sub gtk_text_view_get_line_at_y ( N-GObject $text_view, N-GObject $target_iter, int32 $y, int32 $line_top )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] buffer_to_window_coords

Converts coordinate (I<buffer_x>, I<buffer_y>) to coordinates for the window
I<win>, and stores the result in (I<window_x>, I<window_y>).

Note that you can’t convert coordinates for a nonexisting window (see
C<gtk_text_view_set_border_window_size()>).

  method gtk_text_view_buffer_to_window_coords ( GtkTextWindowType $win, Int $buffer_x, Int $buffer_y, Int $window_x, Int $window_y )

=item GtkTextWindowType $win; a B<Gnome::Gtk3::TextWindowType> except C<GTK_TEXT_WINDOW_PRIVATE>
=item Int $buffer_x; buffer x coordinate
=item Int $buffer_y; buffer y coordinate
=item Int $window_x; (out) (allow-none): window x coordinate return location or C<Any>
=item Int $window_y; (out) (allow-none): window y coordinate return location or C<Any>

=end pod

sub gtk_text_view_buffer_to_window_coords ( N-GObject $text_view, int32 $win, int32 $buffer_x, int32 $buffer_y, int32 $window_x, int32 $window_y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] window_to_buffer_coords

Converts coordinates on the window identified by I<win> to buffer
coordinates, storing the result in (I<buffer_x>,I<buffer_y>).

Note that you can’t convert coordinates for a nonexisting window (see
C<gtk_text_view_set_border_window_size()>).

  method gtk_text_view_window_to_buffer_coords ( GtkTextWindowType $win, Int $window_x, Int $window_y, Int $buffer_x, Int $buffer_y )

=item GtkTextWindowType $win; a B<Gnome::Gtk3::TextWindowType> except C<GTK_TEXT_WINDOW_PRIVATE>
=item Int $window_x; window x coordinate
=item Int $window_y; window y coordinate
=item Int $buffer_x; (out) (allow-none): buffer x coordinate return location or C<Any>
=item Int $buffer_y; (out) (allow-none): buffer y coordinate return location or C<Any>

=end pod

sub gtk_text_view_window_to_buffer_coords ( N-GObject $text_view, int32 $win, int32 $window_x, int32 $window_y, int32 $buffer_x, int32 $buffer_y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_window

Retrieves the B<Gnome::Gdk3::Window> corresponding to an area of the text view;
possible windows include the overall widget window, child windows
on the left, right, top, bottom, and the window that displays the
text buffer. Windows are C<Any> and nonexistent if their width or
height is 0, and are nonexistent before the widget has been
realized.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::Window>, or C<Any>

  method gtk_text_view_get_window ( GtkTextWindowType $win --> N-GObject  )

=item GtkTextWindowType $win; window to get

=end pod

sub gtk_text_view_get_window ( N-GObject $text_view, int32 $win )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_window_type

Usually used to find out which window an event corresponds to.
If you connect to an event signal on I<text_view>, this function
should be called on `event->window` to
see which window it was.

Returns: the window type.

  method gtk_text_view_get_window_type ( N-GObject $window --> GtkTextWindowType  )

=item N-GObject $window; a window type

=end pod

sub gtk_text_view_get_window_type ( N-GObject $text_view, N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_border_window_size

Sets the width of C<GTK_TEXT_WINDOW_LEFT> or C<GTK_TEXT_WINDOW_RIGHT>,
or the height of C<GTK_TEXT_WINDOW_TOP> or C<GTK_TEXT_WINDOW_BOTTOM>.
Automatically destroys the corresponding window if the size is set
to 0, and creates the window if the size is set to non-zero.  This
function can only be used for the “border windows,” it doesn’t work
with C<GTK_TEXT_WINDOW_WIDGET>, C<GTK_TEXT_WINDOW_TEXT>, or
C<GTK_TEXT_WINDOW_PRIVATE>.

  method gtk_text_view_set_border_window_size ( GtkTextWindowType $type, Int $size )

=item GtkTextWindowType $type; window to affect
=item Int $size; width or height of the window

=end pod

sub gtk_text_view_set_border_window_size ( N-GObject $text_view, int32 $type, int32 $size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_border_window_size

Gets the width of the specified border window. See
C<gtk_text_view_set_border_window_size()>.

Returns: width of window

  method gtk_text_view_get_border_window_size ( GtkTextWindowType $type --> Int  )

=item GtkTextWindowType $type; window to return size from

=end pod

sub gtk_text_view_get_border_window_size ( N-GObject $text_view, int32 $type )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] forward_display_line

Moves the given I<iter> forward by one display (wrapped) line.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_forward_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_forward_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] backward_display_line

Moves the given I<iter> backward by one display (wrapped) line.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_backward_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_backward_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] forward_display_line_end

Moves the given I<iter> forward to the next display line end.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_forward_display_line_end ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_forward_display_line_end ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] backward_display_line_start

Moves the given I<iter> backward to the next display line start.
A display line is different from a paragraph. Paragraphs are
separated by newlines or other paragraph separator characters.
Display lines are created by line-wrapping a paragraph. If
wrapping is turned off, display lines and paragraphs will be the
same. Display lines are divided differently for each view, since
they depend on the view’s width; paragraphs are the same in all
views, since they depend on the contents of the B<Gnome::Gtk3::TextBuffer>.

Returns: C<1> if I<iter> was moved and is not on the end iterator

  method gtk_text_view_backward_display_line_start ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_backward_display_line_start ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] starts_display_line

Determines whether I<iter> is at the start of a display line.
See C<gtk_text_view_forward_display_line()> for an explanation of
display lines vs. paragraphs.

Returns: C<1> if I<iter> begins a wrapped line

  method gtk_text_view_starts_display_line ( N-GObject $iter --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>

=end pod

sub gtk_text_view_starts_display_line ( N-GObject $text_view, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] move_visually

Move the iterator a given number of characters visually, treating
it as the strong cursor position. If I<count> is positive, then the
new strong cursor position will be I<count> positions to the right of
the old cursor position. If I<count> is negative then the new strong
cursor position will be I<count> positions to the left of the old
cursor position.

In the presence of bi-directional text, the correspondence
between logical and visual order will depend on the direction
of the current run, and there may be jumps when the cursor
is moved off of the end of a run.

Returns: C<1> if I<iter> moved and is not on the end iterator

  method gtk_text_view_move_visually ( N-GObject $iter, Int $count --> Int  )

=item N-GObject $iter; a B<Gnome::Gtk3::TextIter>
=item Int $count; number of characters to move (negative moves left,  positive moves right)

=end pod

sub gtk_text_view_move_visually ( N-GObject $text_view, N-GObject $iter, int32 $count )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] im_context_filter_keypress

Allow the B<Gnome::Gtk3::TextView> input method to internally handle key press
and release events. If this function returns C<1>, then no further
processing should be done for this key event. See
C<gtk_im_context_filter_keypress()>.

Note that you are expected to call this function from your handler
when overriding key event handling. This is needed in the case when
you need to insert your own key handling between the input method
and the default key event handling of the B<Gnome::Gtk3::TextView>.

|[<!-- language="C" -->
static gboolean
gtk_foo_bar_key_press_event (B<Gnome::Gtk3::Widget>   *widget,
B<Gnome::Gdk3::EventKey> *event)
{
if ((key->keyval == GDK_KEY_Return || key->keyval == GDK_KEY_KP_Enter))
{
if (gtk_text_view_im_context_filter_keypress (GTK_TEXT_VIEW (view), event))
return TRUE;
}

// Do some stuff

return GTK_WIDGET_CLASS (gtk_foo_bar_parent_class)->key_press_event (widget, event);
}
]|

Returns: C<1> if the input method handled the key event.

Since: 2.22

  method gtk_text_view_im_context_filter_keypress ( GdkEventKey $event --> Int  )

=item GdkEventKey $event; the key event

=end pod

sub gtk_text_view_im_context_filter_keypress ( N-GObject $text_view, GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] reset_im_context

Reset the input method context of the text view if needed.

This can be necessary in the case where modifying the buffer
would confuse on-going input method behavior.

Since: 2.22

  method gtk_text_view_reset_im_context ( )


=end pod

sub gtk_text_view_reset_im_context ( N-GObject $text_view )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] add_child_at_anchor

Adds a child widget in the text buffer, at the given I<anchor>.

  method gtk_text_view_add_child_at_anchor ( N-GObject $child, GtkTextChildAnchor $anchor )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>
=item GtkTextChildAnchor $anchor; a B<Gnome::Gtk3::TextChildAnchor> in the B<Gnome::Gtk3::TextBuffer> for I<text_view>

=end pod

sub gtk_text_view_add_child_at_anchor ( N-GObject $text_view, N-GObject $child, GtkTextChildAnchor $anchor )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] add_child_in_window

Adds a child at fixed coordinates in one of the text widget's windows.

The window must have nonzero size (see C<gtk_text_view_set_border_window_size()>). Note that the child coordinates are given relative to scrolling. When placing a child in C<GTK_TEXT_WINDOW_WIDGET>, scrolling is irrelevant, the child floats above all scrollable areas. But when placing a child in one of the scrollable windows (border windows or text window) it will move with the scrolling as needed.

  method gtk_text_view_add_child_in_window (
    N-GObject $child, GtkTextWindowType $which_window, Int $xpos, Int $ypos
  )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>
=item GtkTextWindowType $which_window; which window the child should appear in
=item Int $xpos; X position of child in window coordinates
=item Int $ypos; Y position of child in window coordinates

=end pod

sub gtk_text_view_add_child_in_window ( N-GObject $text_view, N-GObject $child, int32 $which_window, int32 $xpos, int32 $ypos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] move_child

Updates the position of a child, as for C<gtk_text_view_add_child_in_window()>.

  method gtk_text_view_move_child ( N-GObject $child, Int $xpos, Int $ypos )

=item N-GObject $child; child widget already added to the text view
=item Int $xpos; new X position in window coordinates
=item Int $ypos; new Y position in window coordinates

=end pod

sub gtk_text_view_move_child ( N-GObject $text_view, N-GObject $child, int32 $xpos, int32 $ypos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_wrap_mode

Sets the line wrapping for the view.

  method gtk_text_view_set_wrap_mode ( GtkWrapMode $wrap_mode )

=item GtkWrapMode $wrap_mode; a B<Gnome::Gtk3::WrapMode>

=end pod

sub gtk_text_view_set_wrap_mode ( N-GObject $text_view, int32 $wrap_mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_wrap_mode

Gets the line wrapping for the view.

Returns: the line wrap setting

  method gtk_text_view_get_wrap_mode ( --> GtkWrapMode  )


=end pod

sub gtk_text_view_get_wrap_mode ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_editable

Sets the default editability of the B<Gnome::Gtk3::TextView>. You can override
this default setting with tags in the buffer, using the “editable”
attribute of tags.

  method gtk_text_view_set_editable ( Int $setting )

=item Int $setting; whether it’s editable

=end pod

sub gtk_text_view_set_editable ( N-GObject $text_view, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_editable

Returns the default editability of the B<Gnome::Gtk3::TextView>. Tags in the
buffer may override this setting for some ranges of text.

Returns: whether text is editable by default

  method gtk_text_view_get_editable ( --> Int  )


=end pod

sub gtk_text_view_get_editable ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_overwrite

Changes the B<Gnome::Gtk3::TextView> overwrite mode.

Since: 2.4

  method gtk_text_view_set_overwrite ( Int $overwrite )

=item Int $overwrite; C<1> to turn on overwrite mode, C<0> to turn it off

=end pod

sub gtk_text_view_set_overwrite ( N-GObject $text_view, int32 $overwrite )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_overwrite

Returns whether the B<Gnome::Gtk3::TextView> is in overwrite mode or not.

Returns: whether I<text_view> is in overwrite mode or not.

Since: 2.4

  method gtk_text_view_get_overwrite ( --> Int  )


=end pod

sub gtk_text_view_get_overwrite ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_accepts_tab

Sets the behavior of the text widget when the Tab key is pressed.
If I<accepts_tab> is C<1>, a tab character is inserted. If I<accepts_tab>
is C<0> the keyboard focus is moved to the next widget in the focus
chain.

Since: 2.4

  method gtk_text_view_set_accepts_tab ( Int $accepts_tab )

=item Int $accepts_tab; C<1> if pressing the Tab key should insert a tab  character, C<0>, if pressing the Tab key should move the  keyboard focus.

=end pod

sub gtk_text_view_set_accepts_tab ( N-GObject $text_view, int32 $accepts_tab )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_accepts_tab

Returns whether pressing the Tab key inserts a tab characters.
C<gtk_text_view_set_accepts_tab()>.

Returns: C<1> if pressing the Tab key inserts a tab character,
C<0> if pressing the Tab key moves the keyboard focus.

Since: 2.4

  method gtk_text_view_get_accepts_tab ( --> Int  )


=end pod

sub gtk_text_view_get_accepts_tab ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_pixels_above_lines

Sets the default number of blank pixels above paragraphs in I<text_view>.
Tags in the buffer for I<text_view> may override the defaults.

  method gtk_text_view_set_pixels_above_lines ( Int $pixels_above_lines )

=item Int $pixels_above_lines; pixels above paragraphs

=end pod

sub gtk_text_view_set_pixels_above_lines ( N-GObject $text_view, int32 $pixels_above_lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_pixels_above_lines

Gets the default number of pixels to put above paragraphs.
Adding this function with C<gtk_text_view_get_pixels_below_lines()>
is equal to the line space between each paragraph.

Returns: default number of pixels above paragraphs

  method gtk_text_view_get_pixels_above_lines ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_above_lines ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_pixels_below_lines

Sets the default number of pixels of blank space
to put below paragraphs in I<text_view>. May be overridden
by tags applied to I<text_view>’s buffer.

  method gtk_text_view_set_pixels_below_lines ( Int $pixels_below_lines )

=item Int $pixels_below_lines; pixels below paragraphs

=end pod

sub gtk_text_view_set_pixels_below_lines ( N-GObject $text_view, int32 $pixels_below_lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_pixels_below_lines

Gets the value set by C<gtk_text_view_set_pixels_below_lines()>.

The line space is the sum of the value returned by this function and the
value returned by C<gtk_text_view_get_pixels_above_lines()>.

Returns: default number of blank pixels below paragraphs

  method gtk_text_view_get_pixels_below_lines ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_below_lines ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_pixels_inside_wrap

Sets the default number of pixels of blank space to leave between
display/wrapped lines within a paragraph. May be overridden by
tags in I<text_view>’s buffer.

  method gtk_text_view_set_pixels_inside_wrap ( Int $pixels_inside_wrap )

=item Int $pixels_inside_wrap; default number of pixels between wrapped lines

=end pod

sub gtk_text_view_set_pixels_inside_wrap ( N-GObject $text_view, int32 $pixels_inside_wrap )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_pixels_inside_wrap

Gets the value set by C<gtk_text_view_set_pixels_inside_wrap()>.

Returns: default number of pixels of blank space between wrapped lines

  method gtk_text_view_get_pixels_inside_wrap ( --> Int  )


=end pod

sub gtk_text_view_get_pixels_inside_wrap ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_justification

Sets the default justification of text in I<text_view>.
Tags in the view’s buffer may override the default.


  method gtk_text_view_set_justification ( GtkJustification $justification )

=item GtkJustification $justification; justification

=end pod

sub gtk_text_view_set_justification ( N-GObject $text_view, int32 $justification )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_justification

Gets the default justification of paragraphs in I<text_view>.
Tags in the buffer may override the default.

Returns: default justification

  method gtk_text_view_get_justification ( --> GtkJustification  )


=end pod

sub gtk_text_view_get_justification ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_left_margin

Sets the default left margin for text in I<text_view>.
Tags in the buffer may override the default.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

  method gtk_text_view_set_left_margin ( Int $left_margin )

=item Int $left_margin; left margin in pixels

=end pod

sub gtk_text_view_set_left_margin ( N-GObject $text_view, int32 $left_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_left_margin

Gets the default left margin size of paragraphs in the I<text_view>.
Tags in the buffer may override the default.

Returns: left margin in pixels

  method gtk_text_view_get_left_margin ( --> Int  )


=end pod

sub gtk_text_view_get_left_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_right_margin

Sets the default right margin for text in the text view.
Tags in the buffer may override the default.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

  method gtk_text_view_set_right_margin ( Int $right_margin )

=item Int $right_margin; right margin in pixels

=end pod

sub gtk_text_view_set_right_margin ( N-GObject $text_view, int32 $right_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_right_margin

Gets the default right margin for text in I<text_view>. Tags
in the buffer may override the default.

Returns: right margin in pixels

  method gtk_text_view_get_right_margin ( --> Int  )


=end pod

sub gtk_text_view_get_right_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_top_margin

Sets the top margin for text in I<text_view>.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

Since: 3.18

  method gtk_text_view_set_top_margin ( Int $top_margin )

=item Int $top_margin; top margin in pixels

=end pod

sub gtk_text_view_set_top_margin ( N-GObject $text_view, int32 $top_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_top_margin

Gets the top margin for text in the I<text_view>.

Returns: top margin in pixels

Since: 3.18

  method gtk_text_view_get_top_margin ( --> Int  )


=end pod

sub gtk_text_view_get_top_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_bottom_margin

Sets the bottom margin for text in I<text_view>.

Note that this function is confusingly named.
In CSS terms, the value set here is padding.

Since: 3.18

  method gtk_text_view_set_bottom_margin ( Int $bottom_margin )

=item Int $bottom_margin; bottom margin in pixels

=end pod

sub gtk_text_view_set_bottom_margin ( N-GObject $text_view, int32 $bottom_margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_bottom_margin

Gets the bottom margin for text in the I<text_view>.

Returns: bottom margin in pixels

Since: 3.18

  method gtk_text_view_get_bottom_margin ( --> Int  )


=end pod

sub gtk_text_view_get_bottom_margin ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_indent

Sets the default indentation for paragraphs in I<text_view>.
Tags in the buffer may override the default.

  method gtk_text_view_set_indent ( Int $indent )

=item Int $indent; indentation in pixels

=end pod

sub gtk_text_view_set_indent ( N-GObject $text_view, int32 $indent )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_indent

Gets the default indentation of paragraphs in I<text_view>.
Tags in the view’s buffer may override the default.
The indentation may be negative.

Returns: number of pixels of indentation

  method gtk_text_view_get_indent ( --> Int  )


=end pod

sub gtk_text_view_get_indent ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_tabs

Sets the default tab stops for paragraphs in I<text_view>.
Tags in the buffer may override the default.

  method gtk_text_view_set_tabs ( PangoTabArray $tabs )

=item PangoTabArray $tabs; tabs as a C<PangoTabArray>

=end pod

sub gtk_text_view_set_tabs ( N-GObject $text_view, PangoTabArray $tabs )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_tabs

Gets the default tabs for I<text_view>. Tags in the buffer may
override the defaults. The returned array will be C<Any> if
“standard” (8-space) tabs are used. Free the return value
with C<pango_tab_array_free()>.

Returns: (nullable) (transfer full): copy of default tab array, or C<Any> if
“standard" tabs are used; must be freed with C<pango_tab_array_free()>.

  method gtk_text_view_get_tabs ( --> PangoTabArray  )


=end pod

sub gtk_text_view_get_tabs ( N-GObject $text_view )
  returns PangoTabArray
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_default_attributes

Obtains a copy of the default text attributes. These are the
attributes used for text unless a tag overrides them.
You’d typically pass the default attributes in to
C<gtk_text_iter_get_attributes()> in order to get the
attributes in effect at a given text position.

The return value is a copy owned by the caller of this function,
and should be freed with C<gtk_text_attributes_unref()>.

Returns: a new B<Gnome::Gtk3::TextAttributes>

  method gtk_text_view_get_default_attributes ( --> N-GObject  )


=end pod

sub gtk_text_view_get_default_attributes ( N-GObject $text_view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_input_purpose

Sets the prop C<input-purpose> property which
can be used by on-screen keyboards and other input
methods to adjust their behaviour.

Since: 3.6

  method gtk_text_view_set_input_purpose ( GtkInputPurpose $purpose )

=item GtkInputPurpose $purpose; the purpose

=end pod

sub gtk_text_view_set_input_purpose ( N-GObject $text_view, int32 $purpose )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_input_purpose

Gets the value of the prop C<input-purpose> property.

Since: 3.6

  method gtk_text_view_get_input_purpose ( --> GtkInputPurpose  )


=end pod

sub gtk_text_view_get_input_purpose ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_input_hints

Sets the prop C<input-hints> property, which
allows input methods to fine-tune their behaviour.

Since: 3.6

  method gtk_text_view_set_input_hints ( GtkInputHints $hints )

=item GtkInputHints $hints; the hints

=end pod

sub gtk_text_view_set_input_hints ( N-GObject $text_view, int32 $hints )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_input_hints

Gets the value of the prop C<input-hints> property.

Since: 3.6

  method gtk_text_view_get_input_hints ( --> GtkInputHints  )


=end pod

sub gtk_text_view_get_input_hints ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] set_monospace

Sets the prop C<monospace> property, which
indicates that the text view should use monospace
fonts.

Since: 3.16

  method gtk_text_view_set_monospace ( Int $monospace )

=item Int $monospace; C<1> to request monospace styling

=end pod

sub gtk_text_view_set_monospace ( N-GObject $text_view, int32 $monospace )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_view_] get_monospace

Gets the value of the prop C<monospace> property.

Return: C<1> if monospace fonts are desired

Since: 3.16

  method gtk_text_view_get_monospace ( --> Int  )


=end pod

sub gtk_text_view_get_monospace ( N-GObject $text_view )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Not yet implemented methods

=head3 method gtk_text_view_set_tabs ( ... )
=head3 method gtk_text_view_get_tabs ( ... )
=head3 method gtk_text_view_add_child_at_anchor ( ... )


=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.0.
=head3 method gtk_text_view_get_hadjustment ( --> N-GObject  )
=head3 method gtk_text_view_get_vadjustment ( --> N-GObject  )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 set-anchor

The sig I<set-anchor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates setting the "anchor"
mark. The "anchor" mark gets placed at the same position as the
"insert" mark.

This signal has no default bindings.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal


=head3 backspace

The sig I<backspace> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user asks for it.

The default bindings for this signal are
Backspace and Shift-Backspace.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal

=head3 cut-clipboard

The sig I<cut-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are
Ctrl-x and Shift-Delete.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal

=head3 copy-clipboard

The sig I<copy-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are
Ctrl-c and Ctrl-Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal

=head3 paste-clipboard

The sig I<paste-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to paste the contents of the clipboard
into the text view.

The default bindings for this signal are
Ctrl-v and Shift-Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal


=head3 toggle-overwrite

The sig I<toggle-overwrite> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to toggle the overwrite mode of the text view.

The default bindings for this signal is Insert.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal


=head3 toggle-cursor-visible

The sig I<toggle-cursor-visible> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to toggle the prop C<cursor-visible>
property.

The default binding for this signal is F7.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal


=begin comment
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals

=head3 move-cursor

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically.

The default bindings for this signal come in two variants,
the variant with the Shift modifier extends the selection,
the variant without the Shift modifer does not.
There are too many key combinations to list them all here.
- Arrow keys move by individual characters/lines
- Ctrl-arrow key combinations move by words/paragraphs
- Home/End keys move to the ends of the buffer
- PageUp/PageDown keys move vertically by pages
- Ctrl-PageUp/PageDown keys move horizontally by pages

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($step),
    :handler-arg1($count),
    :handler-arg2($extend_selection),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>
=item $count; the number of I<step> units to move
=item $extend_selection; C<1> if the move should extend the selection



=head3 move-viewport

The sig I<move-viewport> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which can be bound to key combinations to allow the user
to move the viewport, i.e. change what part of the text view
is visible in a containing scrolled window.

There are no default bindings for this signal.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($step),
    :handler-arg1($count),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $step; the granularity of the movement, as a B<Gnome::Gtk3::ScrollStep>
=item $count; the number of I<step> units to move


=head3 insert-at-cursor

The sig I<insert-at-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates the insertion of a
fixed string at the cursor.

This signal has no default bindings.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($string),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $string; the string to insert


=head3 delete-from-cursor

The sig I<delete-from-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a text deletion.

If the I<type> is C<GTK_DELETE_CHARS>, GTK+ deletes the selection
if there is one, otherwise it deletes the requested number
of characters.

The default bindings for this signal are
Delete for deleting a character, Ctrl-Delete for
deleting a word and Ctrl-Backspace for deleting a word
backwords.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($type),
    :handler-arg1($count),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $type; the granularity of the deletion, as a B<Gnome::Gtk3::DeleteType>
=item $count; the number of I<type> units to delete

=head3 populate-popup

The sig I<populate-popup> signal gets emitted before showing the
context menu of the text view.

If you need to add items to the context menu, connect
to this signal and append your items to the I<popup>, which
will be a B<Gnome::Gtk3::Menu> in this case.

If prop C<populate-all> is C<1>, this signal will
also be emitted to populate touch popups. In this case,
I<popup> will be a different container, e.g. a B<Gnome::Gtk3::Toolbar>.

The signal handler should not make assumptions about the
type of I<widget>, but check whether I<popup> is a B<Gnome::Gtk3::Menu>
or B<Gnome::Gtk3::Toolbar> or another kind of container.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($popup),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; The text view on which the signal is emitted
=item $popup; the container that is being populated


=head3 select-all

The sig I<select-all> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to select or unselect the complete
contents of the text view.

The default bindings for this signal are Ctrl-a and Ctrl-/
for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($select),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $select; C<1> to select, C<0> to unselect



=head3 preedit-changed

If an input method is used, the typed text will not immediately
be committed to the buffer. So if you are interested in the text,
connect to this signal.

This signal is only emitted if the text at the given position
is actually editable.

Since: 2.20

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($preedit),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $preedit; the current preedit string


=head3 extend-selection

The sig I<extend-selection> signal is emitted when the selection needs to be
extended at I<location>.

Returns: C<GDK_EVENT_STOP> to stop other handlers from being invoked for the
event. C<GDK_EVENT_PROPAGATE> to propagate the event further.
Since: 3.16

  method handler (
    Gnome::GObject::Object :widget($text_view),
    :handler-arg0($granularity),
    :handler-arg1($location),
    :handler-arg2($start),
    :handler-arg3($end),
    :$user-option1, ..., :$user-optionN
  );

=item $text_view; the object which received the signal
=item $granularity; the granularity type
=item $location; the location where to extend the selection
=item $start; where the selection should start
=item $end; where the selection should end

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 left-margin

The B<Gnome::GObject::Value> type of property I<left-margin> is C<G_TYPE_INT>.

The default left margin for text in the text view.
Tags in the buffer may override the default.

Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.

Don't confuse this property with prop C<margin-left>.



=head3 right-margin

The B<Gnome::GObject::Value> type of property I<right-margin> is C<G_TYPE_INT>.

The default right margin for text in the text view.
Tags in the buffer may override the default.

Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.

Don't confuse this property with prop C<margin-right>.



=head3 top-margin

The B<Gnome::GObject::Value> type of property I<top-margin> is C<G_TYPE_INT>.

The top margin for text in the text view.

Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.

Don't confuse this property with prop C<margin-top>.

Since: 3.18



=head3 bottom-margin

The B<Gnome::GObject::Value> type of property I<bottom-margin> is C<G_TYPE_INT>.

The bottom margin for text in the text view.

Note that this property is confusingly named. In CSS terms,
the value set here is padding, and it is applied in addition
to the padding from the theme.

Don't confuse this property with prop C<margin-bottom>.

Since: 3.18



=head3 im-module

The B<Gnome::GObject::Value> type of property I<im-module> is C<G_TYPE_STRING>.

Which IM (input method) module should be used for this text_view.
See B<Gnome::Gtk3::IMContext>.

Setting this to a non-C<Any> value overrides the
system-wide IM module setting. See the B<Gnome::Gtk3::Settings>
prop C<gtk-im-module> property.

Since: 2.16



=head3 input-purpose

The B<Gnome::GObject::Value> type of property I<input-purpose> is C<G_TYPE_ENUM>.

The purpose of this text field.

This property can be used by on-screen keyboards and other input
methods to adjust their behaviour.

Since: 3.6


=head3 populate-all

The B<Gnome::GObject::Value> type of property I<populate-all> is C<G_TYPE_BOOLEAN>.

If prop C<populate-all> is C<1>, the sig C<populate-popup>
signal is also emitted for touch popups.

Since: 3.8



=begin comment
=head2 Unsupported properties

=end comment

=head2 Not yet supported properties

=head3 input-hints

The B<Gnome::GObject::Value> type of property I<input-hints> is C<G_TYPE_FLAGS>.

Additional hints (beyond prop C<input-purpose>) that
allow input methods to fine-tune their behaviour.

Since: 3.6




=end pod













=finish
#-------------------------------------------------------------------------------
sub gtk_text_view_new ( )
  returns N-GObject # buffer
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_buffer ( N-GObject $view )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_editable ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_editable ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_cursor_visible ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_cursor_visible ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_get_monospace ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_text_view_set_monospace ( N-GObject $widget, int32 $setting )
  is native(&gtk-lib)
  { * }
