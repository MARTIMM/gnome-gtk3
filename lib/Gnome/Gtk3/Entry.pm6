#TL:1:Gnome::Gtk3::Entry:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Entry

A single line text entry field

![](images/entry.png)

=head1 Description


The B<Gnome::Gtk3::Entry> widget is a single line text entry
widget. A fairly large set of key bindings are supported
by default. If the entered text is longer than the allocation
of the widget, the widget will scroll so that the cursor
position is visible.

When using an entry for passwords and other sensitive information,
it can be put into “password mode” using C<gtk_entry_set_visibility()>.
In this mode, entered text is displayed using a “invisible” character.
By default, GTK+ picks the best invisible character that is available
in the current font, but it can be changed with
C<gtk_entry_set_invisible_char()>. Since 2.16, GTK+ displays a warning
when Caps Lock or input methods might interfere with entering text in
a password entry. The warning can be turned off with the
 I<caps-lock-warning> property.

Since 2.16, B<Gnome::Gtk3::Entry> has the ability to display progress or activity
information behind the text. To make an entry display such information,
use C<gtk_entry_set_progress_fraction()> or C<gtk_entry_set_progress_pulse_step()>.

Additionally, B<Gnome::Gtk3::Entry> can show icons at either side of the entry. These
icons can be activatable by clicking, can be set up as drag source and
can have tooltips. To add an icon, use C<gtk_entry_set_icon_from_gicon()> or
one of the various other functions that set an icon from a stock id, an
icon name or a pixbuf. To trigger an action when the user clicks an icon,
connect to the  I<icon-press> signal. To allow DND operations
from an icon, use C<gtk_entry_set_icon_drag_source()>. To set a tooltip on
an icon, use C<gtk_entry_set_icon_tooltip_text()> or the corresponding function
for markup.

Note that functionality or information that is only available by clicking
on an icon in an entry may not be accessible at all to users which are not
able to use a mouse or other pointing device. It is therefore recommended
that any such functionality should also be available by other means, e.g.
via the context menu of the entry.


=head2 Css Nodes

  entry
  ├── image.left
  ├── image.right
  ├── undershoot.left
  ├── undershoot.right
  ├── [selection]
  ├── [progress[.pulse]]
  ╰── [window.popup]

B<Gnome::Gtk3::Entry> has a main node with the name entry. Depending on the properties
of the entry, the style classes .read-only and .flat may appear. The style
classes .warning and .error may also be used with entries.

When the entry shows icons, it adds subnodes with the name image and the
style class .left or .right, depending on where the icon appears.

When the entry has a selection, it adds a subnode with the name selection.

When the entry shows progress, it adds a subnode with the name progress.
The node has the style class .pulse when the shown progress is pulsing.

The CSS node for a context menu is added as a subnode below entry as well.

The undershoot nodes are used to draw the underflow indication when content
is scrolled out of view. These nodes get the .left and .right style classes
added depending on where the indication is drawn.

When touch is used and touch selection handles are shown, they are using
CSS nodes with name cursor-handle. They get the .top or .bottom style class
depending on where they are shown in relation to the selection. If there is
just a single handle for the text cursor, it gets the style class
.insertion-cursor.

=head2 Implemented Interfaces

Gnome::Gtk3::Entry implements
=comment item Gnome::Atk::ImplementorIface
=item Gnome::Gtk3::Buildable
=item Gnome::Gtk3::Editable
=item Gnome::Gtk3::CellEditable

=head2 See Also

B<Gnome::Gtk3::TextView>, B<Gnome::Gtk3::EntryCompletion>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Entry;
  also is Gnome::Gtk3::Widget;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Entry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkEntryIconPosition

Specifies the side of the entry at which an icon is placed.

Since: 2.16


=item GTK_ENTRY_ICON_PRIMARY: At the beginning of the entry (depending on the text direction).
=item GTK_ENTRY_ICON_SECONDARY: At the end of the entry (depending on the text direction).


=end pod

#TE:0:GtkEntryIconPosition:
enum GtkEntryIconPosition is export (
  'GTK_ENTRY_ICON_PRIMARY',
  'GTK_ENTRY_ICON_SECONDARY'
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

#TM:1:new():inheriting
#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w2<insert-at-cursor toggle-overwrite icon-press>, :w1<tabs move-cursor icon-release>, :w3<activate>, :w0<populate-popup delete-from-cursor backspace cut-clipboard copy-clipboard paste-clipboard>,
  ) unless $signals-added;


  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Entry';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_entry_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkEntry');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_entry_$native-sub"); } unless ?$s;

  # search in the interface modules, name all interfaces which are implemented
  # for this module. not implemented ones are skipped.
  if !$s {
    $s = self._query_interfaces(
      $native-sub, <
        Gnome::Atk::ImplementorIface Gnome::Gtk3::Buildable
        Gnome::Gtk3::Editable Gnome::Gtk3::CellEditable
      >
    );
  }

  self.set-class-name-of-sub('GtkEntry');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_entry_new:
=begin pod
=head2 gtk_entry_new

Creates a new entry.

Returns: a new B<Gnome::Gtk3::Entry>.

  method gtk_entry_new ( --> N-GObject  )


=end pod

sub gtk_entry_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_new_with_buffer:
=begin pod
=head2 [gtk_entry_] new_with_buffer

Creates a new entry with the specified text buffer.

Returns: a new B<Gnome::Gtk3::Entry>

Since: 2.18

  method gtk_entry_new_with_buffer ( N-GObject $buffer --> N-GObject  )

=item N-GObject $buffer; The buffer to use for the new B<Gnome::Gtk3::Entry>.

=end pod

sub gtk_entry_new_with_buffer ( N-GObject $buffer )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_buffer:
=begin pod
=head2 [gtk_entry_] get_buffer

Get the B<Gnome::Gtk3::EntryBuffer> object which holds the text for
this widget.

Since: 2.18

Returns: (transfer none): A B<Gnome::Gtk3::EntryBuffer> object.

  method gtk_entry_get_buffer ( --> N-GObject  )


=end pod

sub gtk_entry_get_buffer ( N-GObject $entry )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_buffer:
=begin pod
=head2 [gtk_entry_] set_buffer

Set the B<Gnome::Gtk3::EntryBuffer> object which holds the text for
this widget.

Since: 2.18

  method gtk_entry_set_buffer ( N-GObject $buffer )

=item N-GObject $buffer; a B<Gnome::Gtk3::EntryBuffer>

=end pod

sub gtk_entry_set_buffer ( N-GObject $entry, N-GObject $buffer )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_text_area:
=begin pod
=head2 [gtk_entry_] get_text_area

Gets the area where the entry’s text is drawn. This function is
useful when drawing something to the entry in a draw callback.

If the entry is not realized, I<text_area> is filled with zeros.

See also C<gtk_entry_get_icon_area()>.

Since: 3.0

  method gtk_entry_get_text_area ( N-GObject $text_area )

=item N-GObject $text_area; (out): Return location for the text area.

=end pod

sub gtk_entry_get_text_area ( N-GObject $entry, N-GObject $text_area )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_visibility:
=begin pod
=head2 [gtk_entry_] set_visibility

Sets whether the contents of the entry are visible or not.
When visibility is set to C<0>, characters are displayed
as the invisible char, and will also appear that way when
the text in the entry widget is copied elsewhere.

By default, GTK+ picks the best invisible character available
in the current font, but it can be changed with
C<gtk_entry_set_invisible_char()>.

Note that you probably want to set  I<input-purpose>
to C<GTK_INPUT_PURPOSE_PASSWORD> or C<GTK_INPUT_PURPOSE_PIN> to
inform input methods about the purpose of this entry,
in addition to setting visibility to C<0>.

  method gtk_entry_set_visibility ( Int $visible )

=item Int $visible; C<1> if the contents of the entry are displayed as plaintext

=end pod

sub gtk_entry_set_visibility ( N-GObject $entry, int32 $visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_entry_get_visibility:
=begin pod
=head2 [gtk_entry_] get_visibility

Retrieves whether the text in I<entry> is visible. See
C<gtk_entry_set_visibility()>.

Returns: C<1> if the text is currently visible

  method gtk_entry_get_visibility ( --> Int  )


=end pod

sub gtk_entry_get_visibility ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_invisible_char:
=begin pod
=head2 [gtk_entry_] set_invisible_char

Sets the character to use in place of the actual text when
C<gtk_entry_set_visibility()> has been called to set text visibility
to C<0>. i.e. this is the character used in “password mode” to
show the user how many characters have been typed. By default, GTK+
picks the best invisible char available in the current font. If you
set the invisible char to 0, then the user will get no feedback
at all; there will be no text on the screen as they type.

  method gtk_entry_set_invisible_char ( gunichar $ch )

=item UInt $ch; a Unicode character. This is a 4 byte UCS representation of

=end pod

sub gtk_entry_set_invisible_char ( N-GObject $entry, uint32 $ch )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# from Rosetta Code: https://rosettacode.org/wiki/Host_introspection#Perl_6
sub _big_endian ( --> Bool ) {
  my $bytes = nativecast( CArray[uint8], CArray[uint16].new(1));
  ?$bytes[0]
}

#-------------------------------------------------------------------------------
#TM:1:gtk_entry_get_invisible_char:
=begin pod
=head2 [gtk_entry_] get_invisible_char

Retrieves the character displayed in place of the real characters
for entries with visibility set to false. See C<gtk_entry_set_invisible_char()>.

Returns: the current invisible char, or 0, if the entry does not
show invisible text at all.

  method gtk_entry_get_invisible_char ( --> UInt  )


=end pod

sub gtk_entry_get_invisible_char ( N-GObject $entry )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_unset_invisible_char:
=begin pod
=head2 [gtk_entry_] unset_invisible_char

Unsets the invisible char previously set with
C<gtk_entry_set_invisible_char()>. So that the
default invisible char is used again.

Since: 2.16

  method gtk_entry_unset_invisible_char ( )


=end pod

sub gtk_entry_unset_invisible_char ( N-GObject $entry )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_has_frame:
=begin pod
=head2 [gtk_entry_] set_has_frame

Sets whether the entry has a beveled frame around it.

  method gtk_entry_set_has_frame ( Int $setting )

=item Int $setting; new value

=end pod

sub gtk_entry_set_has_frame ( N-GObject $entry, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_has_frame:
=begin pod
=head2 [gtk_entry_] get_has_frame

Gets the value set by C<gtk_entry_set_has_frame()>.

Returns: whether the entry has a beveled frame

  method gtk_entry_get_has_frame ( --> Int  )


=end pod

sub gtk_entry_get_has_frame ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_overwrite_mode:
=begin pod
=head2 [gtk_entry_] set_overwrite_mode

Sets whether the text is overwritten when typing in the B<Gnome::Gtk3::Entry>.

Since: 2.14

  method gtk_entry_set_overwrite_mode ( Int $overwrite )

=item Int $overwrite; new value

=end pod

sub gtk_entry_set_overwrite_mode ( N-GObject $entry, int32 $overwrite )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_overwrite_mode:
=begin pod
=head2 [gtk_entry_] get_overwrite_mode

Gets the value set by C<gtk_entry_set_overwrite_mode()>.

Returns: whether the text is overwritten when typing.

Since: 2.14

  method gtk_entry_get_overwrite_mode ( --> Int  )


=end pod

sub gtk_entry_get_overwrite_mode ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_max_length:
=begin pod
=head2 [gtk_entry_] set_max_length

Sets the maximum allowed length of the contents of the widget. If
the current contents are longer than the given length, then they
will be truncated to fit.

This is equivalent to:

|[<!-- language="C" -->
B<Gnome::Gtk3::EntryBuffer> *buffer;
buffer = gtk_entry_get_buffer (entry);
gtk_entry_buffer_set_max_length (buffer, max);
]|

  method gtk_entry_set_max_length ( Int $max )

=item Int $max; the maximum length of the entry, or 0 for no maximum. (other than the maximum length of entries.) The value passed in will be clamped to the range 0-65536.

=end pod

sub gtk_entry_set_max_length ( N-GObject $entry, int32 $max )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_max_length:
=begin pod
=head2 [gtk_entry_] get_max_length

Retrieves the maximum allowed length of the text in
I<entry>. See C<gtk_entry_set_max_length()>.

This is equivalent to:

|[<!-- language="C" -->
B<Gnome::Gtk3::EntryBuffer> *buffer;
buffer = gtk_entry_get_buffer (entry);
gtk_entry_buffer_get_max_length (buffer);
]|

Returns: the maximum allowed number of characters
in B<Gnome::Gtk3::Entry>, or 0 if there is no maximum.

  method gtk_entry_get_max_length ( --> Int  )


=end pod

sub gtk_entry_get_max_length ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_entry_get_text_length:
=begin pod
=head2 [gtk_entry_] get_text_length

Retrieves the current length of the text in
I<entry>.

This is equivalent to:

|[<!-- language="C" -->
B<Gnome::Gtk3::EntryBuffer> *buffer;
buffer = gtk_entry_get_buffer (entry);
gtk_entry_buffer_get_length (buffer);
]|

Returns: the current number of characters
in B<Gnome::Gtk3::Entry>, or 0 if there are none.

Since: 2.14

  method gtk_entry_get_text_length ( --> UInt  )


=end pod

sub gtk_entry_get_text_length ( N-GObject $entry )
  returns uint16
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_activates_default:
=begin pod
=head2 [gtk_entry_] set_activates_default

If I<setting> is C<1>, pressing Enter in the I<entry> will activate the default
widget for the window containing the entry. This usually means that
the dialog box containing the entry will be closed, since the default
widget is usually one of the dialog buttons.

(For experts: if I<setting> is C<1>, the entry calls
C<gtk_window_activate_default()> on the window containing the entry, in
the default handler for the  I<activate> signal.)

  method gtk_entry_set_activates_default ( Int $setting )

=item Int $setting; C<1> to activate window’s default widget on Enter keypress

=end pod

sub gtk_entry_set_activates_default ( N-GObject $entry, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_activates_default:
=begin pod
=head2 [gtk_entry_] get_activates_default

Retrieves the value set by C<gtk_entry_set_activates_default()>.

Returns: C<1> if the entry will activate the default widget

  method gtk_entry_get_activates_default ( --> Int  )


=end pod

sub gtk_entry_get_activates_default ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_width_chars:
=begin pod
=head2 [gtk_entry_] set_width_chars

Changes the size request of the entry to be about the right size
for I<n_chars> characters. Note that it changes the size
request, the size can still be affected by
how you pack the widget into containers. If I<n_chars> is -1, the
size reverts to the default entry size.

  method gtk_entry_set_width_chars ( Int $n_chars )

=item Int $n_chars; width in chars

=end pod

sub gtk_entry_set_width_chars ( N-GObject $entry, int32 $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_width_chars:
=begin pod
=head2 [gtk_entry_] get_width_chars

Gets the value set by C<gtk_entry_set_width_chars()>.

Returns: number of chars to request space for, or negative if unset

  method gtk_entry_get_width_chars ( --> Int  )


=end pod

sub gtk_entry_get_width_chars ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_max_width_chars:
=begin pod
=head2 [gtk_entry_] set_max_width_chars

Sets the desired maximum width in characters of I<entry>.

Since: 3.12

  method gtk_entry_set_max_width_chars ( Int $n_chars )

=item Int $n_chars; the new desired maximum width, in characters

=end pod

sub gtk_entry_set_max_width_chars ( N-GObject $entry, int32 $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_max_width_chars:
=begin pod
=head2 [gtk_entry_] get_max_width_chars

Retrieves the desired maximum width of I<entry>, in characters.
See C<gtk_entry_set_max_width_chars()>.

Returns: the maximum width of the entry, in characters

Since: 3.12

  method gtk_entry_get_max_width_chars ( --> Int  )


=end pod

sub gtk_entry_get_max_width_chars ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_entry_set_text:
=begin pod
=head2 [gtk_entry_] set_text

Sets the text in the widget to the given
value, replacing the current contents.

See C<gtk_entry_buffer_set_text()>.

  method gtk_entry_set_text ( Str $text )

=item Str $text; the new text

=end pod

sub gtk_entry_set_text ( N-GObject $entry, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_entry_get_text:
=begin pod
=head2 [gtk_entry_] get_text

Retrieves the contents of the entry widget.
See also C<gtk_editable_get_chars()>.

This is equivalent to:

|[<!-- language="C" -->
B<Gnome::Gtk3::EntryBuffer> *buffer;
buffer = gtk_entry_get_buffer (entry);
gtk_entry_buffer_get_text (buffer);
]|

Returns: a pointer to the contents of the widget as a
string. This string points to internally allocated
storage in the widget and must not be freed, modified or
stored.

  method gtk_entry_get_text ( --> Str  )


=end pod

sub gtk_entry_get_text ( N-GObject $entry )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_layout:
=begin pod
=head2 [gtk_entry_] get_layout

Gets the B<PangoLayout> used to display the entry.
The layout is useful to e.g. convert text positions to
pixel positions, in combination with C<gtk_entry_get_layout_offsets()>.
The returned layout is owned by the entry and must not be
modified or freed by the caller.

Keep in mind that the layout text may contain a preedit string, so
C<gtk_entry_layout_index_to_text_index()> and
C<gtk_entry_text_index_to_layout_index()> are needed to convert byte
indices in the layout to byte indices in the entry contents.

Returns: (transfer none): the B<PangoLayout> for this entry

  method gtk_entry_get_layout ( --> PangoLayout  )


=end pod

sub gtk_entry_get_layout ( N-GObject $entry )
  returns PangoLayout
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_layout_offsets:
=begin pod
=head2 [gtk_entry_] get_layout_offsets

Obtains the position of the B<PangoLayout> used to render text
in the entry, in widget coordinates. Useful if you want to line
up the text in an entry with some other text, e.g. when using the
entry to implement editable cells in a sheet widget.

Also useful to convert mouse events into coordinates inside the
B<PangoLayout>, e.g. to take some action if some part of the entry text
is clicked.

Note that as the user scrolls around in the entry the offsets will
change; you’ll need to connect to the “notify::scroll-offset”
signal to track this. Remember when using the B<PangoLayout>
functions you need to convert to and from pixels using
C<PANGO_PIXELS()> or B<PANGO_SCALE>.

Keep in mind that the layout text may contain a preedit string, so
C<gtk_entry_layout_index_to_text_index()> and
C<gtk_entry_text_index_to_layout_index()> are needed to convert byte
indices in the layout to byte indices in the entry contents.

  method gtk_entry_get_layout_offsets ( Int $x, Int $y )

=item Int $x; (out) (allow-none): location to store X offset of layout, or C<Any>
=item Int $y; (out) (allow-none): location to store Y offset of layout, or C<Any>

=end pod

sub gtk_entry_get_layout_offsets ( N-GObject $entry, int32 $x, int32 $y )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_alignment:
=begin pod
=head2 [gtk_entry_] set_alignment

Sets the alignment for the contents of the entry. This controls
the horizontal positioning of the contents when the displayed
text is shorter than the width of the entry.

Since: 2.4

  method gtk_entry_set_alignment ( Num $xalign )

=item Num $xalign; The horizontal alignment, from 0 (left) to 1 (right). Reversed for RTL layouts

=end pod

sub gtk_entry_set_alignment ( N-GObject $entry, num32 $xalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_alignment:
=begin pod
=head2 [gtk_entry_] get_alignment

Gets the value set by C<gtk_entry_set_alignment()>.

Returns: the alignment

Since: 2.4

  method gtk_entry_get_alignment ( --> Num  )


=end pod

sub gtk_entry_get_alignment ( N-GObject $entry )
  returns num32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_completion:
=begin pod
=head2 [gtk_entry_] set_completion

Sets I<completion> to be the auxiliary completion object to use with I<entry>.
All further configuration of the completion mechanism is done on
I<completion> using the B<Gnome::Gtk3::EntryCompletion> API. Completion is disabled if
I<completion> is set to C<Any>.

Since: 2.4

  method gtk_entry_set_completion ( N-GObject $completion )

=item N-GObject $completion; (allow-none): The B<Gnome::Gtk3::EntryCompletion> or C<Any>

=end pod

sub gtk_entry_set_completion ( N-GObject $entry, N-GObject $completion )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_completion:
=begin pod
=head2 [gtk_entry_] get_completion

Returns the auxiliary completion object currently in use by I<entry>.

Returns: (transfer none): The auxiliary completion object currently
in use by I<entry>.

Since: 2.4

  method gtk_entry_get_completion ( --> N-GObject  )


=end pod

sub gtk_entry_get_completion ( N-GObject $entry )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_layout_index_to_text_index:
=begin pod
=head2 [gtk_entry_] layout_index_to_text_index

Converts from a position in the entry contents (returned
by C<gtk_entry_get_text()>) to a position in the
entry’s B<PangoLayout> (returned by C<gtk_entry_get_layout()>,
with text retrieved via C<pango_layout_get_text()>).

Returns: byte index into the entry contents

  method gtk_entry_layout_index_to_text_index ( Int $layout_index --> Int  )

=item Int $layout_index; byte index into the entry layout text

=end pod

sub gtk_entry_layout_index_to_text_index ( N-GObject $entry, int32 $layout_index )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_text_index_to_layout_index:
=begin pod
=head2 [gtk_entry_] text_index_to_layout_index

Converts from a position in the entry’s B<PangoLayout> (returned by
C<gtk_entry_get_layout()>) to a position in the entry contents
(returned by C<gtk_entry_get_text()>).

Returns: byte index into the entry layout text

  method gtk_entry_text_index_to_layout_index ( Int $text_index --> Int  )

=item Int $text_index; byte index into the entry contents

=end pod

sub gtk_entry_text_index_to_layout_index ( N-GObject $entry, int32 $text_index )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_cursor_hadjustment:
=begin pod
=head2 [gtk_entry_] set_cursor_hadjustment

Hooks up an adjustment to the cursor position in an entry, so that when
the cursor is moved, the adjustment is scrolled to show that position.
See C<gtk_scrolled_window_get_hadjustment()> for a typical way of obtaining
the adjustment.

The adjustment has to be in pixel units and in the same coordinate system
as the entry.

Since: 2.12

  method gtk_entry_set_cursor_hadjustment ( N-GObject $adjustment )

=item N-GObject $adjustment; (nullable): an adjustment which should be adjusted when the cursor is moved, or C<Any>

=end pod

sub gtk_entry_set_cursor_hadjustment ( N-GObject $entry, N-GObject $adjustment )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_cursor_hadjustment:
=begin pod
=head2 [gtk_entry_] get_cursor_hadjustment

Retrieves the horizontal cursor adjustment for the entry.
See C<gtk_entry_set_cursor_hadjustment()>.

Returns: (transfer none) (nullable): the horizontal cursor adjustment, or C<Any>
if none has been set.

Since: 2.12

  method gtk_entry_get_cursor_hadjustment ( --> N-GObject  )


=end pod

sub gtk_entry_get_cursor_hadjustment ( N-GObject $entry )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_progress_fraction:
=begin pod
=head2 [gtk_entry_] set_progress_fraction

Causes the entry’s progress indicator to “fill in” the given
fraction of the bar. The fraction should be between 0.0 and 1.0,
inclusive.

Since: 2.16

  method gtk_entry_set_progress_fraction ( Num $fraction )

=item Num $fraction; fraction of the task that’s been completed

=end pod

sub gtk_entry_set_progress_fraction ( N-GObject $entry, num64 $fraction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_progress_fraction:
=begin pod
=head2 [gtk_entry_] get_progress_fraction

Returns the current fraction of the task that’s been completed.
See C<gtk_entry_set_progress_fraction()>.

Returns: a fraction from 0.0 to 1.0

Since: 2.16

  method gtk_entry_get_progress_fraction ( --> Num  )


=end pod

sub gtk_entry_get_progress_fraction ( N-GObject $entry )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_progress_pulse_step:
=begin pod
=head2 [gtk_entry_] set_progress_pulse_step

Sets the fraction of total entry width to move the progress
bouncing block for each call to C<gtk_entry_progress_pulse()>.

Since: 2.16

  method gtk_entry_set_progress_pulse_step ( Num $fraction )

=item Num $fraction; fraction between 0.0 and 1.0

=end pod

sub gtk_entry_set_progress_pulse_step ( N-GObject $entry, num64 $fraction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_progress_pulse_step:
=begin pod
=head2 [gtk_entry_] get_progress_pulse_step

Retrieves the pulse step set with C<gtk_entry_set_progress_pulse_step()>.

Returns: a fraction from 0.0 to 1.0

Since: 2.16

  method gtk_entry_get_progress_pulse_step ( --> Num  )


=end pod

sub gtk_entry_get_progress_pulse_step ( N-GObject $entry )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_progress_pulse:
=begin pod
=head2 [gtk_entry_] progress_pulse

Indicates that some progress is made, but you don’t know how much.
Causes the entry’s progress indicator to enter “activity mode,”
where a block bounces back and forth. Each call to
C<gtk_entry_progress_pulse()> causes the block to move by a little bit
(the amount of movement per pulse is determined by
C<gtk_entry_set_progress_pulse_step()>).

Since: 2.16

  method gtk_entry_progress_pulse ( )


=end pod

sub gtk_entry_progress_pulse ( N-GObject $entry )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_placeholder_text:
=begin pod
=head2 [gtk_entry_] get_placeholder_text

Retrieves the text that will be displayed when I<entry> is empty and unfocused

Returns: a pointer to the placeholder text as a string. This string points to internally allocated
storage in the widget and must not be freed, modified or stored.

Since: 3.2

  method gtk_entry_get_placeholder_text ( --> Str  )


=end pod

sub gtk_entry_get_placeholder_text ( N-GObject $entry )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_placeholder_text:
=begin pod
=head2 [gtk_entry_] set_placeholder_text

Sets text to be displayed in I<entry> when it is empty and unfocused.
This can be used to give a visual hint of the expected contents of
the B<Gnome::Gtk3::Entry>.

Note that since the placeholder text gets removed when the entry
received focus, using this feature is a bit problematic if the entry
is given the initial focus in a window. Sometimes this can be
worked around by delaying the initial focus setting until the
first key event arrives.

Since: 3.2

  method gtk_entry_set_placeholder_text ( Str $text )

=item Str $text; (nullable): a string to be displayed when I<entry> is empty and unfocused, or C<Any>

=end pod

sub gtk_entry_set_placeholder_text ( N-GObject $entry, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_from_pixbuf:
=begin pod
=head2 [gtk_entry_] set_icon_from_pixbuf

Sets the icon shown in the specified position using a pixbuf.

If I<pixbuf> is C<Any>, no icon will be shown in the specified position.

Since: 2.16

  method gtk_entry_set_icon_from_pixbuf (
    GtkEntryIconPosition $icon_pos, N-GObject $pixbuf
  )

=item GtkEntryIconPosition $icon_pos; Icon position
=item N-GObject $pixbuf; (allow-none): A B<Gnome::Gdk3::Pixbuf>, or C<Any>

=end pod

sub gtk_entry_set_icon_from_pixbuf ( N-GObject $entry, int32 $icon_pos, N-GObject $pixbuf )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_from_icon_name:
=begin pod
=head2 [gtk_entry_] set_icon_from_icon_name

Sets the icon shown in the entry at the specified position
from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be displayed
instead.

If I<icon_name> is C<Any>, no icon will be shown in the specified position.

Since: 2.16

  method gtk_entry_set_icon_from_icon_name (
    GtkEntryIconPosition $icon_pos, Str $icon_name
  )

=item GtkEntryIconPosition $icon_pos; The position at which to set the icon
=item Str $icon_name; (allow-none): An icon name, or C<Any>

=end pod

sub gtk_entry_set_icon_from_icon_name ( N-GObject $entry, int32 $icon_pos, Str $icon_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_from_gicon:
=begin pod
=head2 [gtk_entry_] set_icon_from_gicon

Sets the icon shown in the entry at the specified position
from the current icon theme.
If the icon isn’t known, a “broken image” icon will be displayed
instead.

If I<icon> is C<Any>, no icon will be shown in the specified position.

Since: 2.16

  method gtk_entry_set_icon_from_gicon (
    GtkEntryIconPosition $icon_pos, N-GObject $icon
  )

=item GtkEntryIconPosition $icon_pos; The position at which to set the icon
=item N-GObject $icon; (allow-none): The icon to set, or C<Any>

=end pod

sub gtk_entry_set_icon_from_gicon ( N-GObject $entry, int32 $icon_pos, N-GObject $icon )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_storage_type:
=begin pod
=head2 [gtk_entry_] get_icon_storage_type

Gets the type of representation being used by the icon
to store image data. If the icon has no image data,
the return value will be C<GTK_IMAGE_EMPTY>.

Returns: image representation being used

Since: 2.16

  method gtk_entry_get_icon_storage_type (
    GtkEntryIconPosition $icon_pos
    --> GtkImageType
  )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_storage_type ( N-GObject $entry, int32 $icon_pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_pixbuf:
=begin pod
=head2 [gtk_entry_] get_icon_pixbuf

Retrieves the image used for the icon.

Unlike the other methods of setting and getting icon data, this
method will work regardless of whether the icon was set using a
B<Gnome::Gdk3::Pixbuf>, a B<GIcon>, a stock item, or an icon name.

Returns: (transfer none) (nullable): A B<Gnome::Gdk3::Pixbuf>, or C<Any> if no icon is
set for this position.

Since: 2.16

  method gtk_entry_get_icon_pixbuf (
    GtkEntryIconPosition $icon_pos --> N-GObject
  )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_pixbuf ( N-GObject $entry, int32 $icon_pos )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_name:
=begin pod
=head2 [gtk_entry_] get_icon_name

Retrieves the icon name used for the icon, or C<Any> if there is
no icon or if the icon was set by some other method (e.g., by
pixbuf, stock or gicon).

Returns: (nullable): An icon name, or C<Any> if no icon is set or if the icon
wasn’t set from an icon name

Since: 2.16

  method gtk_entry_get_icon_name ( GtkEntryIconPosition $icon_pos --> Str )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_name ( N-GObject $entry, int32 $icon_pos )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_gicon:
=begin pod
=head2 [gtk_entry_] get_icon_gicon

Retrieves the B<GIcon> used for the icon, or C<Any> if there is
no icon or if the icon was set by some other method (e.g., by
stock, pixbuf, or icon name).

Returns: (transfer none) (nullable): A B<GIcon>, or C<Any> if no icon is set
or if the icon is not a B<GIcon>

Since: 2.16

  method gtk_entry_get_icon_gicon (
    GtkEntryIconPosition $icon_pos --> N-GObject
  )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_gicon ( N-GObject $entry, int32 $icon_pos )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_activatable:
=begin pod
=head2 [gtk_entry_] set_icon_activatable

Sets whether the icon is activatable.

Since: 2.16

  method gtk_entry_set_icon_activatable (
    GtkEntryIconPosition $icon_pos, Int $activatable
  )

=item GtkEntryIconPosition $icon_pos; Icon position
=item Int $activatable; C<1> if the icon should be activatable

=end pod

sub gtk_entry_set_icon_activatable ( N-GObject $entry, int32 $icon_pos, int32 $activatable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_activatable:
=begin pod
=head2 [gtk_entry_] get_icon_activatable

Returns whether the icon is activatable.

Returns: C<1> if the icon is activatable.

Since: 2.16

  method gtk_entry_get_icon_activatable (
    GtkEntryIconPosition $icon_pos --> Int
  )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_activatable ( N-GObject $entry, int32 $icon_pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_sensitive:
=begin pod
=head2 [gtk_entry_] set_icon_sensitive

Sets the sensitivity for the specified icon.

Since: 2.16

  method gtk_entry_set_icon_sensitive (
    GtkEntryIconPosition $icon_pos, Int $sensitive
  )

=item GtkEntryIconPosition $icon_pos; Icon position
=item Int $sensitive; Specifies whether the icon should appear sensitive or insensitive

=end pod

sub gtk_entry_set_icon_sensitive ( N-GObject $entry, int32 $icon_pos, int32 $sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_sensitive:
=begin pod
=head2 [gtk_entry_] get_icon_sensitive

Returns whether the icon appears sensitive or insensitive.

Returns: C<1> if the icon is sensitive.

Since: 2.16

  method gtk_entry_get_icon_sensitive (
    GtkEntryIconPosition $icon_pos --> Int
  )

=item GtkEntryIconPosition $icon_pos; Icon position

=end pod

sub gtk_entry_get_icon_sensitive ( N-GObject $entry, int32 $icon_pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_at_pos:
=begin pod
=head2 [gtk_entry_] get_icon_at_pos

Finds the icon at the given position and return its index. The
position’s coordinates are relative to the I<entry>’s top left corner.
If I<x>, I<y> doesn’t lie inside an icon, -1 is returned.
This function is intended for use in a  I<query-tooltip>
signal handler.

Returns: the index of the icon at the given position, or -1

Since: 2.16

  method gtk_entry_get_icon_at_pos ( Int $x, Int $y --> Int  )

=item Int $x; the x coordinate of the position to find
=item Int $y; the y coordinate of the position to find

=end pod

sub gtk_entry_get_icon_at_pos ( N-GObject $entry, int32 $x, int32 $y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_tooltip_text:
=begin pod
=head2 [gtk_entry_] set_icon_tooltip_text

Sets I<tooltip> as the contents of the tooltip for the icon
at the specified position.

Use C<Any> for I<tooltip> to remove an existing tooltip.

See also C<gtk_widget_set_tooltip_text()> and
C<gtk_entry_set_icon_tooltip_markup()>.

Since: 2.16

  method gtk_entry_set_icon_tooltip_text (
    GtkEntryIconPosition $icon_pos, Str $tooltip
  )

=item GtkEntryIconPosition $icon_pos; the icon position
=item Str $tooltip; (allow-none): the contents of the tooltip for the icon, or C<Any>

=end pod

sub gtk_entry_set_icon_tooltip_text ( N-GObject $entry, int32 $icon_pos, Str $tooltip )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_tooltip_text:
=begin pod
=head2 [gtk_entry_] get_icon_tooltip_text

Gets the contents of the tooltip on the icon at the specified
position in I<entry>.

Returns: (nullable): the tooltip text, or C<Any>. Free the returned
string with C<g_free()> when done.

Since: 2.16

  method gtk_entry_get_icon_tooltip_text (
    GtkEntryIconPosition $icon_pos --> Str
  )

=item GtkEntryIconPosition $icon_pos; the icon position

=end pod

sub gtk_entry_get_icon_tooltip_text ( N-GObject $entry, int32 $icon_pos )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_tooltip_markup:
=begin pod
=head2 [gtk_entry_] set_icon_tooltip_markup

Sets I<tooltip> as the contents of the tooltip for the icon at
the specified position. I<tooltip> is assumed to be marked up with
the [Pango text markup language][PangoMarkupFormat].

Use C<Any> for I<tooltip> to remove an existing tooltip.

See also C<gtk_widget_set_tooltip_markup()> and
C<gtk_entry_set_icon_tooltip_text()>.

Since: 2.16

  method gtk_entry_set_icon_tooltip_markup ( GtkEntryIconPosition $icon_pos, Str $tooltip )

=item GtkEntryIconPosition $icon_pos; the icon position
=item Str $tooltip; (allow-none): the contents of the tooltip for the icon, or C<Any>

=end pod

sub gtk_entry_set_icon_tooltip_markup ( N-GObject $entry, int32 $icon_pos, Str $tooltip )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_tooltip_markup:
=begin pod
=head2 [gtk_entry_] get_icon_tooltip_markup

Gets the contents of the tooltip on the icon at the specified
position in I<entry>.

Returns: (nullable): the tooltip text, or C<Any>. Free the returned
string with C<g_free()> when done.

Since: 2.16

  method gtk_entry_get_icon_tooltip_markup (
    GtkEntryIconPosition $icon_pos --> Str
  )

=item GtkEntryIconPosition $icon_pos; the icon position

=end pod

sub gtk_entry_get_icon_tooltip_markup ( N-GObject $entry, int32 $icon_pos )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_icon_drag_source:
=begin pod
=head2 [gtk_entry_] set_icon_drag_source

Sets up the icon at the given position so that GTK+ will start a drag
operation when the user clicks and drags the icon.

To handle the drag operation, you need to connect to the usual
 I<drag-data-get> (or possibly  I<drag-data-delete>)
signal, and use C<gtk_entry_get_current_icon_drag_source()> in
your signal handler to find out if the drag was started from
an icon.

By default, GTK+ uses the icon as the drag icon. You can use the
 I<drag-begin> signal to set a different icon. Note that you
have to use C<g_signal_connect_after()> to ensure that your signal handler
gets executed after the default handler.

Since: 2.16

  method gtk_entry_set_icon_drag_source (
    GtkEntryIconPosition $icon_pos, GtkTargetList $target_list,
    GdkDragAction $actions
  )

=item GtkEntryIconPosition $icon_pos; icon position
=item GtkTargetList $target_list; the targets (data formats) in which the data can be provided
=item GdkDragAction $actions; a bitmask of the allowed drag actions

=end pod

sub gtk_entry_set_icon_drag_source ( N-GObject $entry, int32 $icon_pos, GtkTargetList $target_list, GdkDragAction $actions )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_current_icon_drag_source:
=begin pod
=head2 [gtk_entry_] get_current_icon_drag_source

Returns the index of the icon which is the source of the current
DND operation, or -1.

This function is meant to be used in a  I<drag-data-get>
callback.

Returns: index of the icon which is the source of the current
DND operation, or -1.

Since: 2.16

  method gtk_entry_get_current_icon_drag_source ( --> Int  )


=end pod

sub gtk_entry_get_current_icon_drag_source ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_icon_area:
=begin pod
=head2 [gtk_entry_] get_icon_area

Gets the area where entry’s icon at I<icon_pos> is drawn.
This function is useful when drawing something to the
entry in a draw callback.

If the entry is not realized or has no icon at the given position,
I<icon_area> is filled with zeros.

See also C<gtk_entry_get_text_area()>

Since: 3.0

  method gtk_entry_get_icon_area (
    GtkEntryIconPosition $icon_pos, N-GObject $icon_area
  )

=item GtkEntryIconPosition $icon_pos; Icon position
=item N-GObject $icon_area; (out): Return location for the icon’s area

=end pod

sub gtk_entry_get_icon_area ( N-GObject $entry, int32 $icon_pos, N-GObject $icon_area )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_im_context_filter_keypress:
=begin pod
=head2 [gtk_entry_] im_context_filter_keypress

Allow the B<Gnome::Gtk3::Entry> input method to internally handle key press
and release events. If this function returns C<1>, then no further
processing should be done for this key event. See
C<gtk_im_context_filter_keypress()>.

Note that you are expected to call this function from your handler
when overriding key event handling. This is needed in the case when
you need to insert your own key handling between the input method
and the default key event handling of the B<Gnome::Gtk3::Entry>.
See C<gtk_text_view_reset_im_context()> for an example of use.

Returns: C<1> if the input method handled the key event.

Since: 2.22

  method gtk_entry_im_context_filter_keypress ( GdkEventKey $event --> Int  )

=item GdkEventKey $event; (type B<Gnome::Gdk3::.EventKey>): the key event

=end pod

sub gtk_entry_im_context_filter_keypress ( N-GObject $entry, GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_reset_im_context:
=begin pod
=head2 [gtk_entry_] reset_im_context

Reset the input method context of the entry if needed.

This can be necessary in the case where modifying the buffer
would confuse on-going input method behavior.

Since: 2.22

  method gtk_entry_reset_im_context ( )


=end pod

sub gtk_entry_reset_im_context ( N-GObject $entry )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_input_purpose:
=begin pod
=head2 [gtk_entry_] set_input_purpose

Sets the  I<input-purpose> property which
can be used by on-screen keyboards and other input
methods to adjust their behaviour.

Since: 3.6

  method gtk_entry_set_input_purpose ( GtkInputPurpose $purpose )

=item GtkInputPurpose $purpose; the purpose

=end pod

sub gtk_entry_set_input_purpose ( N-GObject $entry, int32 $purpose )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_input_purpose:
=begin pod
=head2 [gtk_entry_] get_input_purpose

Gets the value of the  I<input-purpose> property.

Since: 3.6

  method gtk_entry_get_input_purpose ( --> GtkInputPurpose  )


=end pod

sub gtk_entry_get_input_purpose ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_input_hints:
=begin pod
=head2 [gtk_entry_] set_input_hints

Sets the  I<input-hints> property, which
allows input methods to fine-tune their behaviour.

Since: 3.6

  method gtk_entry_set_input_hints ( GtkInputHints $hints )

=item GtkInputHints $hints; the hints

=end pod

sub gtk_entry_set_input_hints ( N-GObject $entry, int32 $hints )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_input_hints:
=begin pod
=head2 [gtk_entry_] get_input_hints

Gets the value of the  I<input-hints> property.

Since: 3.6

  method gtk_entry_get_input_hints ( --> GtkInputHints  )


=end pod

sub gtk_entry_get_input_hints ( N-GObject $entry )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_attributes:
=begin pod
=head2 [gtk_entry_] set_attributes

Sets a B<PangoAttrList>; the attributes in the list are applied to the
entry text.

Since: 3.6

  method gtk_entry_set_attributes ( PangoAttrList $attrs )

=item PangoAttrList $attrs; a B<PangoAttrList>

=end pod

sub gtk_entry_set_attributes ( N-GObject $entry, PangoAttrList $attrs )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_attributes:
=begin pod
=head2 [gtk_entry_] get_attributes

Gets the attribute list that was set on the entry using
C<gtk_entry_set_attributes()>, if any.

Returns: (transfer none) (nullable): the attribute list, or C<Any>
if none was set.

Since: 3.6

  method gtk_entry_get_attributes ( --> PangoAttrList  )


=end pod

sub gtk_entry_get_attributes ( N-GObject $entry )
  returns PangoAttrList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_set_tabs:
=begin pod
=head2 [gtk_entry_] set_tabs

Sets a B<PangoTabArray>; the tabstops in the array are applied to the entry
text.

Since: 3.10

  method gtk_entry_set_tabs ( PangoTabArray $tabs )

=item PangoTabArray $tabs; a B<PangoTabArray>

=end pod

sub gtk_entry_set_tabs ( N-GObject $entry, PangoTabArray $tabs )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_tabs:
=begin pod
=head2 [gtk_entry_] get_tabs

Gets the tabstops that were set on the entry using C<gtk_entry_set_tabs()>, if
any.

Returns: (nullable) (transfer none): the tabstops, or C<Any> if none was set.

Since: 3.10

  method gtk_entry_get_tabs ( --> PangoTabArray  )


=end pod

sub gtk_entry_get_tabs ( N-GObject $entry )
  returns PangoTabArray
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_grab_focus_without_selecting:
=begin pod
=head2 [gtk_entry_] grab_focus_without_selecting

Causes I<entry> to have keyboard focus.

It behaves like C<gtk_widget_grab_focus()>,
except that it doesn't select the contents of the entry.
You only want to call this on some special entries
which the user usually doesn't want to replace all text in,
such as search-as-you-type entries.

Since: 3.16

  method gtk_entry_grab_focus_without_selecting ( )


=end pod

sub gtk_entry_grab_focus_without_selecting ( N-GObject $entry )
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


=comment #TS:0:tabs:
=head3 tabs

A list of tabstops to apply to the text of the entry.

Since: 3.8

  method handler (
    ,
    *%user-options
  );


=comment #TS:0:populate-popup:
=head3 populate-popup

The I<populate-popup> signal gets emitted before showing the
context menu of the entry.

If you need to add items to the context menu, connect
to this signal and append your items to the I<widget>, which
will be a B<Gnome::Gtk3::Menu> in this case.

If  I<populate-all> is C<1>, this signal will
also be emitted to populate touch popups. In this case,
I<widget> will be a different container, e.g. a B<Gnome::Gtk3::Toolbar>.
The signal handler should not make assumptions about the
type of I<widget>.

  method handler (
    - $popup,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; The entry on which the signal is emitted

=item $popup; the container that is being populated


=comment #TS:0:activate:
=head3 activate

The I<activate> signal is emitted when the user hits
the Enter key.

While this signal is used as a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>],
it is also commonly used by applications to intercept
activation of entries.

The default bindings for this signal are all forms of the Enter key.

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; The entry on which the signal is emitted


=comment #TS:0:move-cursor:
=head3 move-cursor

The I<move-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a cursor movement.
If the cursor is not visible in I<entry>, this signal causes
the viewport to be moved instead.

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

  method handler (
    Str $step,
    - $count,
    - $extend_selection,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>

=item $count; the number of I<step> units to move

=item $extend_selection; C<1> if the move should extend the selection


=comment #TS:0:insert-at-cursor:
=head3 insert-at-cursor

The I<insert-at-cursor> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates the insertion of a
fixed string at the cursor.

This signal has no default bindings.

  method handler (
    Unknown type GTK_TYPE_DELETE_TYPE $string,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal

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
Delete for deleting a character and Ctrl-Delete for
deleting a word.

  method handler (
    - $type,
    - $count,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal

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
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal


=comment #TS:0:cut-clipboard:
=head3 cut-clipboard

The I<cut-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are
Ctrl-x and Shift-Delete.

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal


=comment #TS:0:copy-clipboard:
=head3 copy-clipboard

The I<copy-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are
Ctrl-c and Ctrl-Insert.

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal


=comment #TS:0:paste-clipboard:
=head3 paste-clipboard

The I<paste-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to paste the contents of the clipboard
into the text view.

The default bindings for this signal are
Ctrl-v and Shift-Insert.

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal


=comment #TS:0:toggle-overwrite:
=head3 toggle-overwrite

The I<toggle-overwrite> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to toggle the overwrite mode of the entry.

The default bindings for this signal is Insert.

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal


=comment #TS:0:icon-press:
=head3 icon-press

The I<icon-press> signal is emitted when an activatable icon
is clicked.

Since: 2.16

  method handler (
    Unknown type GTK_TYPE_ENTRY_ICON_POSITION $icon_pos,
    Unknown type GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $event,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; The entry on which the signal is emitted

=item $icon_pos; The position of the clicked icon

=item $event; (type B<Gnome::Gdk3::.EventButton>): the button press event


=comment #TS:0:icon-release:
=head3 icon-release

The I<icon-release> signal is emitted on the button release from a
mouse click over an activatable icon.

Since: 2.16

  method handler (
    Str $icon_pos,
    - $event,
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; The entry on which the signal is emitted

=item $icon_pos; The position of the clicked icon

=item $event; (type B<Gnome::Gdk3::.EventButton>): the button release event


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

=begin comment
=comment #TP:0:buffer:
=head3 Text Buffer

Text buffer object which actually stores entry text
Widget type: GTK_TYPE_ENTRY_BUFFER


The B<Gnome::GObject::Value> type of property I<buffer> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:cursor-position:
=head3 Cursor Position



The B<Gnome::GObject::Value> type of property I<cursor-position> is C<G_TYPE_INT>.

=comment #TP:0:selection-bound:
=head3 Selection Bound



The B<Gnome::GObject::Value> type of property I<selection-bound> is C<G_TYPE_INT>.

=comment #TP:0:editable:
=head3 Editable

Whether the entry contents can be edited
Default value: True


The B<Gnome::GObject::Value> type of property I<editable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:max-length:
=head3 Maximum length



The B<Gnome::GObject::Value> type of property I<max-length> is C<G_TYPE_INT>.

=comment #TP:0:visibility:
=head3 Visibility

FALSE displays the \invisible char\ instead of the actual text (password mode)
Default value: True


The B<Gnome::GObject::Value> type of property I<visibility> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:has-frame:
=head3 Has Frame

FALSE removes outside bevel from entry
Default value: True


The B<Gnome::GObject::Value> type of property I<has-frame> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:invisible-char:
=head3 Invisible character



The B<Gnome::GObject::Value> type of property I<invisible-char> is C<G_TYPE_UNICHAR>.

=comment #TP:0:activates-default:
=head3 Activates default

Whether to activate the default widget (such as the default button in a dialog when Enter is pressed)
Default value: False


The B<Gnome::GObject::Value> type of property I<activates-default> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:width-chars:
=head3 Width in chars



The B<Gnome::GObject::Value> type of property I<width-chars> is C<G_TYPE_INT>.

=comment #TP:0:max-width-chars:
=head3 Maximum width in characters


The desired maximum width of the entry, in characters.
If this property is set to -1, the width will be calculated
automatically.
Since: 3.12

The B<Gnome::GObject::Value> type of property I<max-width-chars> is C<G_TYPE_INT>.

=comment #TP:0:scroll-offset:
=head3 Scroll offset



The B<Gnome::GObject::Value> type of property I<scroll-offset> is C<G_TYPE_INT>.

=comment #TP:0:text:
=head3 Text

The contents of the entry
Default value:


The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=comment #TP:0:xalign:
=head3 X align


The horizontal alignment, from 0 (left) to 1 (right).
Reversed for RTL layouts.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:truncate-multiline:
=head3 Truncate multiline


When C<1>, pasted multi-line text is truncated to the first line.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<truncate-multiline> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:overwrite-mode:
=head3 Overwrite mode


If text is overwritten when typing in the B<Gnome::Gtk3::Entry>.
Since: 2.14

The B<Gnome::GObject::Value> type of property I<overwrite-mode> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:text-length:
=head3 Text length


The length of the text in the B<Gnome::Gtk3::Entry>.
Since: 2.14

The B<Gnome::GObject::Value> type of property I<text-length> is C<G_TYPE_UINT>.

=comment #TP:0:invisible-char-set:
=head3 Invisible character set


Whether the invisible char has been set for the B<Gnome::Gtk3::Entry>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<invisible-char-set> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:caps-lock-warning:
=head3 Caps Lock warning


Whether password entries will show a warning when Caps Lock is on.
Note that the warning is shown using a secondary icon, and thus
does not work if you are using the secondary icon position for some
other purpose.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<caps-lock-warning> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:progress-fraction:
=head3 Progress Fraction


The current fraction of the task that's been completed.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<progress-fraction> is C<G_TYPE_DOUBLE>.

=comment #TP:0:progress-pulse-step:
=head3 Progress Pulse Step


The fraction of total entry width to move the progress
bouncing block for each call to C<gtk_entry_progress_pulse()>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<progress-pulse-step> is C<G_TYPE_DOUBLE>.

=comment #TP:0:placeholder-text:
=head3 Placeholder text


The text that will be displayed in the B<Gnome::Gtk3::Entry> when it is empty
and unfocused.
Since: 3.2

The B<Gnome::GObject::Value> type of property I<placeholder-text> is C<G_TYPE_STRING>.

=begin comment
=comment #TP:0:primary-icon-pixbuf:
=head3 Primary pixbuf


A pixbuf to use as the primary icon for the entry.
Since: 2.16
Widget type: GDK_TYPE_PIXBUF

The B<Gnome::GObject::Value> type of property I<primary-icon-pixbuf> is C<G_TYPE_OBJECT>.

=comment #TP:0:secondary-icon-pixbuf:
=head3 Secondary pixbuf

An pixbuf to use as the secondary icon for the entry.
Since: 2.16
Widget type: GDK_TYPE_PIXBUF

The B<Gnome::GObject::Value> type of property I<secondary-icon-pixbuf> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:primary-icon-name:
=head3 Primary icon name


The icon name to use for the primary icon for the entry.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<primary-icon-name> is C<G_TYPE_STRING>.

=comment #TP:0:secondary-icon-name:
=head3 Secondary icon name


The icon name to use for the secondary icon for the entry.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<secondary-icon-name> is C<G_TYPE_STRING>.

=begin comment

=comment #TP:0:primary-icon-gicon:
=head3 Primary GIcon


The B<GIcon> to use for the primary icon for the entry.
Since: 2.16
Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<primary-icon-gicon> is C<G_TYPE_OBJECT>.

=comment #TP:0:secondary-icon-gicon:
=head3 Secondary GIcon


The B<GIcon> to use for the secondary icon for the entry.
Since: 2.16
Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<secondary-icon-gicon> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:primary-icon-storage-type:
=head3 Primary storage type


The representation which is used for the primary icon of the entry.
Since: 2.16
Widget type: GTK_TYPE_IMAGE_TYPE

The B<Gnome::GObject::Value> type of property I<primary-icon-storage-type> is C<G_TYPE_ENUM>.

=comment #TP:0:secondary-icon-storage-type:
=head3 Secondary storage type


The representation which is used for the secondary icon of the entry.
Since: 2.16
Widget type: GTK_TYPE_IMAGE_TYPE

The B<Gnome::GObject::Value> type of property I<secondary-icon-storage-type> is C<G_TYPE_ENUM>.

=comment #TP:0:primary-icon-activatable:
=head3 Primary icon activatable


Whether the primary icon is activatable.
GTK+ emits the  I<icon-press> and  I<icon-release>
signals only on sensitive, activatable icons.
Sensitive, but non-activatable icons can be used for purely
informational purposes.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<primary-icon-activatable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:secondary-icon-activatable:
=head3 Secondary icon activatable


Whether the secondary icon is activatable.
GTK+ emits the  I<icon-press> and  I<icon-release>
signals only on sensitive, activatable icons.
Sensitive, but non-activatable icons can be used for purely
informational purposes.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<secondary-icon-activatable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:primary-icon-sensitive:
=head3 Primary icon sensitive


Whether the primary icon is sensitive.
An insensitive icon appears grayed out. GTK+ does not emit the
 I<icon-press> and  I<icon-release> signals and
does not allow DND from insensitive icons.
An icon should be set insensitive if the action that would trigger
when clicked is currently not available.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<primary-icon-sensitive> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:secondary-icon-sensitive:
=head3 Secondary icon sensitive


Whether the secondary icon is sensitive.
An insensitive icon appears grayed out. GTK+ does not emit the
 I<icon-press> and  I<icon-release> signals and
does not allow DND from insensitive icons.
An icon should be set insensitive if the action that would trigger
when clicked is currently not available.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<secondary-icon-sensitive> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:primary-icon-tooltip-text:
=head3 Primary icon tooltip text


The contents of the tooltip on the primary icon.
Also see C<gtk_entry_set_icon_tooltip_text()>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<primary-icon-tooltip-text> is C<G_TYPE_STRING>.

=comment #TP:0:secondary-icon-tooltip-text:
=head3 Secondary icon tooltip text


The contents of the tooltip on the secondary icon.
Also see C<gtk_entry_set_icon_tooltip_text()>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<secondary-icon-tooltip-text> is C<G_TYPE_STRING>.

=comment #TP:0:primary-icon-tooltip-markup:
=head3 Primary icon tooltip markup


The contents of the tooltip on the primary icon, which is marked up
with the [Pango text markup language][PangoMarkupFormat].
Also see C<gtk_entry_set_icon_tooltip_markup()>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<primary-icon-tooltip-markup> is C<G_TYPE_STRING>.

=comment #TP:0:secondary-icon-tooltip-markup:
=head3 Secondary icon tooltip markup


The contents of the tooltip on the secondary icon, which is marked up
with the [Pango text markup language][PangoMarkupFormat].
Also see C<gtk_entry_set_icon_tooltip_markup()>.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<secondary-icon-tooltip-markup> is C<G_TYPE_STRING>.

=comment #TP:0:im-module:
=head3 IM module


Which IM (input method) module should be used for this entry.
See B<Gnome::Gtk3::IMContext>.
Setting this to a non-C<Any> value overrides the
system-wide IM module setting. See the B<Gnome::Gtk3::Settings>
 I<gtk-im-module> property.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<im-module> is C<G_TYPE_STRING>.

=begin comment
=comment #TP:0:completion:
=head3 Completion

The auxiliary completion object to use with the entry.
Since: 3.2
Widget type: GTK_TYPE_ENTRY_COMPLETION

The B<Gnome::GObject::Value> type of property I<completion> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:input-purpose:
=head3 Purpose


The purpose of this text field.
This property can be used by on-screen keyboards and other input
methods to adjust their behaviour.
Note that setting the purpose to C<GTK_INPUT_PURPOSE_PASSWORD> or
C<GTK_INPUT_PURPOSE_PIN> is independent from setting
 I<visibility>.
Since: 3.6
Widget type: GTK_TYPE_INPUT_PURPOSE

The B<Gnome::GObject::Value> type of property I<input-purpose> is C<G_TYPE_ENUM>.

=comment #TP:0:input-hints:
=head3 hints


Additional hints (beyond  I<input-purpose>) that
allow input methods to fine-tune their behaviour.
Since: 3.6

The B<Gnome::GObject::Value> type of property I<input-hints> is C<G_TYPE_FLAGS>.


=begin comment
=comment #TP:0:attributes:
=head3 Attributes


A list of Pango attributes to apply to the text of the entry.
This is mainly useful to change the size or weight of the text.
Since: 3.6

The B<Gnome::GObject::Value> type of property I<attributes> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:populate-all:
=head3 Populate all


If I<populate-all> is C<1>, the  I<populate-popup>
signal is also emitted for touch popups.
Since: 3.8

The B<Gnome::GObject::Value> type of property I<populate-all> is C<G_TYPE_BOOLEAN>.

=begin comment
=comment #TP:0:tabs:
=head3 Tabs

The B<Gnome::GObject::Value> type of property I<tabs> is C<G_TYPE_BOXED>.
=end comment
=end pod
















=finish
use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkentry.h
# https://developer.gnome.org/gtk3/stable/GtkEntry.html
unit class Gnome::Gtk3::Entry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
sub gtk_entry_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_entry_get_text ( N-GObject $entry )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_text ( N-GObject $entry, Str $text )
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_visibility ( N-GObject $entry, int32 $visible )
  is native(&gtk-lib)
  { * }

# hints is an enum with type GtkInputHints -> int
# The values are defined in Enums.pm6
sub gtk_entry_set_input_hints ( N-GObject $entry, uint32 $hints )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
#submethod BUILD ( ) {
#  self.native-gobject(gtk_entry_new);
#}
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<activate backspace copy-clipboard cut-clipboard insert-emoji
            paste-clipboard toggle-overwrite
           >,
    :nativewidget<populate-popup>,
    :GtkDeleteType<delete-from-cursor>,
    :iconEvent<icon-press icon-release>,
    :str<insert-at-cursor preedit-changed>,
    :intbool<move-cursor>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Entry';

  if ? %options<empty> {
    self.native-gobject(gtk_entry_new());
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
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
