#TL:1:Gnome::Gtk3::Entry:
# NOTE: there are documentation errors in gtkentry.c
#   GtkEntry::show-emoji-icon: -> GtkEntry:show-emoji-icon:
#   GtkEntry::tabs:            -> GtkEntry:tabs:
use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Entry

A single line text entry field

![](images/entry.png)

=head1 Description

The B<Gnome::Gtk3::Entry> widget is a single line text entry widget. A fairly large set of key bindings are supported by default. If the entered text is longer than the allocation of the widget, the widget will scroll so that the cursor position is visible.

When using an entry for passwords and other sensitive information, it can be put into “password mode” using C<gtk_entry_set_visibility()>. In this mode, entered text is displayed using a “invisible” character. By default, GTK+ picks the best invisible character that is available in the current font, but it can be changed with C<gtk_entry_set_invisible_char()>. Since 2.16, GTK+ displays a warning when Caps Lock or input methods might interfere with entering text in a password entry. The warning can be turned off with the  I<caps-lock-warning> property.

Since 2.16, B<Gnome::Gtk3::Entry> has the ability to display progress or activity information behind the text. To make an entry display such information, use C<gtk_entry_set_progress_fraction()> or C<gtk_entry_set_progress_pulse_step()>.

=begin comment
Additionally, B<Gnome::Gtk3::Entry> can show icons at either side of the entry. These icons can be activatable by clicking, can be set up as drag source and can have tooltips. To add an icon, use C<gtk_entry_set_icon_from_gicon()> or one of the various other functions that set an icon from a stock id, an icon name or a pixbuf. To trigger an action when the user clicks an icon, connect to the  I<icon-press> signal. To allow DND operations from an icon, use C<gtk_entry_set_icon_drag_source()>. To set a tooltip on an icon, use C<gtk_entry_set_icon_tooltip_text()> or the corresponding function for markup.
=end comment

Note that functionality or information that is only available by clicking on an icon in an entry may not be accessible at all to users which are not able to use a mouse or other pointing device. It is therefore recommended that any such functionality should also be available by other means, e.g. via the context menu of the entry.


=head2 Css Nodes

  entry
  ├── image.left
  ├── image.right
  ├── undershoot.left
  ├── undershoot.right
  ├── [selection]
  ├── [progress[.pulse]]
  ╰── [window.popup]

B<Gnome::Gtk3::Entry> has a main node with the name entry. Depending on the properties of the entry, the style classes .read-only and .flat may appear. The style classes .warning and .error may also be used with entries.

When the entry shows icons, it adds subnodes with the name image and the style class .left or .right, depending on where the icon appears.

When the entry has a selection, it adds a subnode with the name selection.

When the entry shows progress, it adds a subnode with the name progress. The node has the style class .pulse when the shown progress is pulsing.

The CSS node for a context menu is added as a subnode below entry as well.

The undershoot nodes are used to draw the underflow indication when content is scrolled out of view. These nodes get the .left and .right style classes added depending on where the indication is drawn.

When touch is used and touch selection handles are shown, they are using CSS nodes with name cursor-handle. They get the .top or .bottom style class depending on where they are shown in relation to the selection. If there is just a single handle for the text cursor, it gets the style class .insertion-cursor.

=head2 Implemented Interfaces

Gnome::Gtk3::Entry implements
=item Gnome::Gtk3::Editable
=item Gnome::Gtk3::CellEditable


=comment head2 Uml Diagram

![](plantuml/Entry.svg)


=head2 See Also

B<Gnome::Gtk3::TextView>, B<Gnome::Gtk3::EntryCompletion>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Entry;
  also is Gnome::Gtk3::Widget;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Entry;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Entry;
  also does Gnome::Gtk3::Editable;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Entry class process the options
    self.bless( :GtkEntry, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gdk3::Events;
use Gnome::Gdk3::DragContext;

use Gnome::Gtk3::Image;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Editable;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::TargetList;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Entry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;
also does Gnome::Gtk3::Editable;

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

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  unless $signals-added {
    # add signal info in the form of w*<signal-name>.
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<insert-at-cursor toggle-overwrite icon-press>, :w1<tabs move-cursor icon-release>, :w3<activate>, :w0<populate-popup delete-from-cursor backspace cut-clipboard copy-clipboard paste-clipboard>,
    );

    # signals from interfaces
    self._add_editable_interface_signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Entry' or %options<GtkEntry> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      # process all named arguments
      $no = _gtk_entry_new();

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkEntry');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_entry_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_entry_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('entry-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-entry-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkEntry');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:get-activates-default:
=begin pod
=head2 get-activates-default

Retrieves the value set by C<set_activates_default()>.

Returns: C<True> if the entry will activate the default widget

  method get-activates-default ( --> Bool )

=end pod

method get-activates-default ( --> Bool ) {
  gtk_entry_get_activates_default( self._f('GtkEntry')).Bool
}

sub gtk_entry_get_activates_default (
  N-GObject $entry --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-alignment:
=begin pod
=head2 get-alignment

Gets the value set by C<set_alignment()>.

Returns: the alignment

  method get-alignment ( --> Num )

=end pod

method get-alignment ( --> Num ) {
  gtk_entry_get_alignment( self._f('GtkEntry'))
}

sub gtk_entry_get_alignment (
  N-GObject $entry --> gfloat
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-attributes:
=begin pod
=head2 get-attributes

Gets the attribute list that was set on the entry using C<set_attributes()>, if any.

Returns: the attribute list, or C<undefined> if none was set.

  method get-attributes ( --> PangoAttrList )

=end pod

method get-attributes ( --> PangoAttrList ) {
  gtk_entry_get_attributes( self._f('GtkEntry'))
}

sub gtk_entry_get_attributes (
  N-GObject $entry --> PangoAttrList
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-buffer:
=begin pod
=head2 get-buffer

Get the B<Gnome::Gtk3::EntryBuffer> object which holds the text for this widget.

Returns: A B<Gnome::Gtk3::EntryBuffer> object.

  method get-buffer ( --> N-GObject )

=end pod

method get-buffer ( --> N-GObject ) {
  gtk_entry_get_buffer( self._f('GtkEntry'))
}

sub gtk_entry_get_buffer (
  N-GObject $entry --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-completion:
=begin pod
=head2 get-completion

Returns the auxiliary completion object currently in use by I<entry>.

Returns: The auxiliary completion object currently in use by I<entry>.

  method get-completion ( --> N-GObject )

=end pod

method get-completion ( --> N-GObject ) {
  gtk_entry_get_completion( self._f('GtkEntry'))
}

sub gtk_entry_get_completion (
  N-GObject $entry --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-icon-drag-source:
=begin pod
=head2 get-current-icon-drag-source

Returns the index of the icon which is the source of the current DND operation, or -1.

This function is meant to be used in a I<drag-data-get from Gnome::Gtk3::Widget> callback.

Returns: index of the icon which is the source of the current DND operation, or -1.

  method get-current-icon-drag-source ( --> Int )

=end pod

method get-current-icon-drag-source ( --> Int ) {
  gtk_entry_get_current_icon_drag_source( self._f('GtkEntry'))
}

sub gtk_entry_get_current_icon_drag_source (
  N-GObject $entry --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-cursor-hadjustment:
=begin pod
=head2 get-cursor-hadjustment

Retrieves the horizontal cursor adjustment for the entry. See C<set_cursor_hadjustment()>.

Returns: the horizontal cursor adjustment, or C<undefined> if none has been set.

  method get-cursor-hadjustment ( --> N-GObject )

=end pod

method get-cursor-hadjustment ( --> N-GObject ) {
  gtk_entry_get_cursor_hadjustment( self._f('GtkEntry'))
}

sub gtk_entry_get_cursor_hadjustment (
  N-GObject $entry --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-has-frame:
=begin pod
=head2 get-has-frame

Gets the value set by C<set_has_frame()>.

Returns: whether the entry has a beveled frame

  method get-has-frame ( --> Bool )

=end pod

method get-has-frame ( --> Bool ) {
  gtk_entry_get_has_frame( self._f('GtkEntry')).Bool
}

sub gtk_entry_get_has_frame (
  N-GObject $entry --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-activatable:
=begin pod
=head2 get-icon-activatable

Returns whether the icon is activatable.

Returns: C<True> if the icon is activatable.

  method get-icon-activatable ( GtkEntryIconPosition $icon_pos --> Bool )

=item $icon_pos; Icon position
=end pod

method get-icon-activatable ( GtkEntryIconPosition $icon_pos --> Bool ) {
  gtk_entry_get_icon_activatable( self._f('GtkEntry'), $icon_pos).Bool
}

sub gtk_entry_get_icon_activatable (
  N-GObject $entry, GEnum $icon_pos --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-area:
=begin pod
=head2 get-icon-area

Gets the area where entry’s icon at I<icon_pos> is drawn. This function is useful when drawing something to the entry in a draw callback.

If the entry is not realized or has no icon at the given position, I<icon_area> is filled with zeros. Otherwise, I<icon_area> will be filled with the icon’s allocation, relative to I<entry>’s allocation.

See also C<get_text_area()>

  method get-icon-area ( GtkEntryIconPosition $icon_pos, N-GObject() $icon_area )

=item $icon_pos; Icon position
=item $icon_area; Return location for the icon’s area
=end pod

method get-icon-area ( GtkEntryIconPosition $icon_pos, N-GObject() $icon_area ) {
  gtk_entry_get_icon_area( self._f('GtkEntry'), $icon_pos, $icon_area);
}

sub gtk_entry_get_icon_area (
  N-GObject $entry, GEnum $icon_pos, N-GObject $icon_area
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-at-pos:
=begin pod
=head2 get-icon-at-pos

Finds the icon at the given position and return its index. The position’s coordinates are relative to the I<entry>’s top left corner. If I<x>, I<y> doesn’t lie inside an icon, -1 is returned. This function is intended for use in a I<query-tooltip from Gnome::Gtk3::Widget> signal handler.

Returns: the index of the icon at the given position, or -1

  method get-icon-at-pos ( Int() $x, Int() $y --> Int )

=item $x; the x coordinate of the position to find
=item $y; the y coordinate of the position to find
=end pod

method get-icon-at-pos ( Int() $x, Int() $y --> Int ) {
  gtk_entry_get_icon_at_pos( self._f('GtkEntry'), $x, $y)
}

sub gtk_entry_get_icon_at_pos (
  N-GObject $entry, gint $x, gint $y --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-gicon:
=begin pod
=head2 get-icon-gicon

Retrieves the B<Gnome::Gio::Icon> used for the icon, or C<undefined> if there is no icon or if the icon was set by some other method (e.g., by stock, pixbuf, or icon name).

Returns: A B<Gnome::Gio::Icon>, or C<undefined> if no icon is set or if the icon is not a B<Gnome::Gio::Icon>

  method get-icon-gicon ( GtkEntryIconPosition $icon_pos --> N-GObject )

=item $icon_pos; Icon position
=end pod

method get-icon-gicon ( GtkEntryIconPosition $icon_pos --> N-GObject ) {
  gtk_entry_get_icon_gicon( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_gicon (
  N-GObject $entry, GEnum $icon_pos --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-name:
=begin pod
=head2 get-icon-name

Retrieves the icon name used for the icon, or C<undefined> if there is no icon or if the icon was set by some other method (e.g., by pixbuf, stock or gicon).

Returns: An icon name, or C<undefined> if no icon is set or if the icon wasn’t set from an icon name

  method get-icon-name ( GtkEntryIconPosition $icon_pos --> Str )

=item $icon_pos; Icon position
=end pod

method get-icon-name ( GtkEntryIconPosition $icon_pos --> Str ) {
  gtk_entry_get_icon_name( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_name (
  N-GObject $entry, GEnum $icon_pos --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-pixbuf:
=begin pod
=head2 get-icon-pixbuf

Retrieves the image used for the icon.

Unlike the other methods of setting and getting icon data, this method will work regardless of whether the icon was set using a B<Gnome::Gdk3::Pixbuf>, a B<Gnome::Gio::Icon>, a stock item, or an icon name.

Returns: A B<Gnome::Gdk3::Pixbuf>, or C<undefined> if no icon is set for this position.

  method get-icon-pixbuf ( GtkEntryIconPosition $icon_pos --> N-GObject )

=item $icon_pos; Icon position
=end pod

method get-icon-pixbuf ( GtkEntryIconPosition $icon_pos --> N-GObject ) {
  gtk_entry_get_icon_pixbuf( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_pixbuf (
  N-GObject $entry, GEnum $icon_pos --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-sensitive:
=begin pod
=head2 get-icon-sensitive

Returns whether the icon appears sensitive or insensitive.

Returns: C<True> if the icon is sensitive.

  method get-icon-sensitive ( GtkEntryIconPosition $icon_pos --> Bool )

=item $icon_pos; Icon position
=end pod

method get-icon-sensitive ( GtkEntryIconPosition $icon_pos --> Bool ) {
  gtk_entry_get_icon_sensitive( self._f('GtkEntry'), $icon_pos).Bool
}

sub gtk_entry_get_icon_sensitive (
  N-GObject $entry, GEnum $icon_pos --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-storage-type:
=begin pod
=head2 get-icon-storage-type

Gets the type of representation being used by the icon to store image data. If the icon has no image data, the return value will be C<GTK_IMAGE_EMPTY>.

Returns: image representation being used

  method get-icon-storage-type ( GtkEntryIconPosition $icon_pos --> GtkImageType )

=item $icon_pos; Icon position
=end pod

method get-icon-storage-type ( GtkEntryIconPosition $icon_pos --> GtkImageType ) {
  gtk_entry_get_icon_storage_type( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_storage_type (
  N-GObject $entry, GEnum $icon_pos --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-tooltip-markup:
=begin pod
=head2 get-icon-tooltip-markup

Gets the contents of the tooltip on the icon at the specified position in I<entry>.

Returns: the tooltip text, or C<undefined>. Free the returned string with C<g_free()> when done.

  method get-icon-tooltip-markup ( GtkEntryIconPosition $icon_pos --> Str )

=item $icon_pos; the icon position
=end pod

method get-icon-tooltip-markup ( GtkEntryIconPosition $icon_pos --> Str ) {
  gtk_entry_get_icon_tooltip_markup( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_tooltip_markup (
  N-GObject $entry, GEnum $icon_pos --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-tooltip-text:
=begin pod
=head2 get-icon-tooltip-text

Gets the contents of the tooltip on the icon at the specified position in I<entry>.

Returns: the tooltip text, or C<undefined>. Free the returned string with C<g_free()> when done.

  method get-icon-tooltip-text ( GtkEntryIconPosition $icon_pos --> Str )

=item $icon_pos; the icon position
=end pod

method get-icon-tooltip-text ( GtkEntryIconPosition $icon_pos --> Str ) {
  gtk_entry_get_icon_tooltip_text( self._f('GtkEntry'), $icon_pos)
}

sub gtk_entry_get_icon_tooltip_text (
  N-GObject $entry, GEnum $icon_pos --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-input-hints:
=begin pod
=head2 get-input-hints

Gets the value of the I<input-hints> property.

  method get-input-hints ( --> GtkInputHints )

=end pod

method get-input-hints ( --> GtkInputHints ) {
  gtk_entry_get_input_hints( self._f('GtkEntry'))
}

sub gtk_entry_get_input_hints (
  N-GObject $entry --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-input-purpose:
=begin pod
=head2 get-input-purpose

Gets the value of the I<input-purpose> property.

  method get-input-purpose ( --> GtkInputPurpose )

=end pod

method get-input-purpose ( --> GtkInputPurpose ) {
  gtk_entry_get_input_purpose( self._f('GtkEntry'))
}

sub gtk_entry_get_input_purpose (
  N-GObject $entry --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-invisible-char:
=begin pod
=head2 get-invisible-char

Retrieves the character displayed in place of the real characters for entries with visibility set to false. See C<set_invisible_char()>.

Returns: the current invisible char, or 0, if the entry does not show invisible text at all.

  method get-invisible-char ( --> gunichar )

=end pod

method get-invisible-char ( --> gunichar ) {
  gtk_entry_get_invisible_char( self._f('GtkEntry'))
}

sub gtk_entry_get_invisible_char (
  N-GObject $entry --> gunichar
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-layout:
=begin pod
=head2 get-layout

Gets the B<PangoLayout> used to display the entry. The layout is useful to e.g. convert text positions to pixel positions, in combination with C<get_layout_offsets()>. The returned layout is owned by the entry and must not be modified or freed by the caller.

Keep in mind that the layout text may contain a preedit string, so C<layout_index_to_text_index()> and C<text_index_to_layout_index()> are needed to convert byte indices in the layout to byte indices in the entry contents.

Returns: the B<PangoLayout> for this entry

  method get-layout ( --> N-GObject )

=end pod

method get-layout ( --> N-GObject ) {
  gtk_entry_get_layout( self._f('GtkEntry'))
}

sub gtk_entry_get_layout (
  N-GObject $entry --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-layout-offsets:
=begin pod
=head2 get-layout-offsets

Obtains the position of the B<PangoLayout> used to render text in the entry, in widget coordinates. Useful if you want to line up the text in an entry with some other text, e.g. when using the entry to implement editable cells in a sheet widget.

Also useful to convert mouse events into coordinates inside the B<PangoLayout>, e.g. to take some action if some part of the entry text is clicked.

Note that as the user scrolls around in the entry the offsets will change; you’ll need to connect to the “notify::scroll-offset” signal to track this. Remember when using the B<PangoLayout> functions you need to convert to and from pixels using C<PANGO_PIXELS()> or B<PANGO_SCALE>.

Keep in mind that the layout text may contain a preedit string, so C<layout_index_to_text_index()> and C<text_index_to_layout_index()> are needed to convert byte indices in the layout to byte indices in the entry contents.

  method get-layout-offsets ( )

=item $x; location to store X offset of layout, or C<undefined>
=item $y; location to store Y offset of layout, or C<undefined>
=end pod

method get-layout-offsets ( ) {
  gtk_entry_get_layout_offsets( self._f('GtkEntry'), my gint $x, my gint $y);
}

sub gtk_entry_get_layout_offsets (
  N-GObject $entry, gint $x is rw, gint $y is rw
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-max-length:
=begin pod
=head2 get-max-length

Retrieves the maximum allowed length of the text in I<entry>. See C<set_max_length()>.

This is equivalent to getting I<entry>'s B<Gnome::Gtk3::EntryBuffer> and calling C<buffer_get_max_length()> on it.

Returns: the maximum allowed number of characters in B<Gnome::Gtk3::Entry>, or 0 if there is no maximum.

  method get-max-length ( --> Int )

=end pod

method get-max-length ( --> Int ) {
  gtk_entry_get_max_length( self._f('GtkEntry'))
}

sub gtk_entry_get_max_length (
  N-GObject $entry --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-max-width-chars:
=begin pod
=head2 get-max-width-chars

Retrieves the desired maximum width of I<entry>, in characters. See C<set_max_width_chars()>.

Returns: the maximum width of the entry, in characters

  method get-max-width-chars ( --> Int )

=end pod

method get-max-width-chars ( --> Int ) {
  gtk_entry_get_max_width_chars( self._f('GtkEntry'))
}

sub gtk_entry_get_max_width_chars (
  N-GObject $entry --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-overwrite-mode:
=begin pod
=head2 get-overwrite-mode

Gets the value set by C<set_overwrite_mode()>.

Returns: whether the text is overwritten when typing.

  method get-overwrite-mode ( --> Bool )

=end pod

method get-overwrite-mode ( --> Bool ) {
  gtk_entry_get_overwrite_mode( self._f('GtkEntry')).Bool
}

sub gtk_entry_get_overwrite_mode (
  N-GObject $entry --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-placeholder-text:
=begin pod
=head2 get-placeholder-text

Retrieves the text that will be displayed when I<entry> is empty and unfocused

Returns: a pointer to the placeholder text as a string. This string points to internally allocated storage in the widget and must not be freed, modified or stored.

  method get-placeholder-text ( --> Str )

=end pod

method get-placeholder-text ( --> Str ) {
  gtk_entry_get_placeholder_text( self._f('GtkEntry'))
}

sub gtk_entry_get_placeholder_text (
  N-GObject $entry --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-progress-fraction:
=begin pod
=head2 get-progress-fraction

Returns the current fraction of the task that’s been completed. See C<set_progress_fraction()>.

Returns: a fraction from 0.0 to 1.0

  method get-progress-fraction ( --> Num )

=end pod

method get-progress-fraction ( --> Num ) {
  gtk_entry_get_progress_fraction( self._f('GtkEntry'))
}

sub gtk_entry_get_progress_fraction (
  N-GObject $entry --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-progress-pulse-step:
=begin pod
=head2 get-progress-pulse-step

Retrieves the pulse step set with C<set_progress_pulse_step()>.

Returns: a fraction from 0.0 to 1.0

  method get-progress-pulse-step ( --> Num )

=end pod

method get-progress-pulse-step ( --> Num ) {
  gtk_entry_get_progress_pulse_step( self._f('GtkEntry'))
}

sub gtk_entry_get_progress_pulse_step (
  N-GObject $entry --> gdouble
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-tabs:
=begin pod
=head2 get-tabs

Gets the tabstops that were set on the entry using C<set_tabs()>, if any.

Returns: the tabstops, or C<undefined> if none was set.

  method get-tabs ( --> PangoTabArray )

=end pod

method get-tabs ( --> PangoTabArray ) {
  gtk_entry_get_tabs( self._f('GtkEntry'))
}

sub gtk_entry_get_tabs (
  N-GObject $entry --> PangoTabArray
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-text:
=begin pod
=head2 get-text

Retrieves the contents of the entry widget. See also C<gtk_editable_get_chars()>.

This is equivalent to getting I<entry>'s B<Gnome::Gtk3::EntryBuffer> and calling C<buffer_get_text()> on it.

Returns: a pointer to the contents of the widget as a string. This string points to internally allocated storage in the widget and must not be freed, modified or stored.

  method get-text ( --> Str )

=end pod

method get-text ( --> Str ) {
  gtk_entry_get_text( self._f('GtkEntry'))
}

sub gtk_entry_get_text (
  N-GObject $entry --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-text-area:
=begin pod
=head2 get-text-area

Gets the area where the entry’s text is drawn. This function is useful when drawing something to the entry in a draw callback.

If the entry is not realized, I<text_area> is filled with zeros.

See also C<get_icon_area()>.

  method get-text-area ( N-GObject() $text_area )

=item $text_area; Return location for the text area.
=end pod

method get-text-area ( N-GObject() $text_area ) {
  gtk_entry_get_text_area( self._f('GtkEntry'), $text_area);
}

sub gtk_entry_get_text_area (
  N-GObject $entry, N-GObject $text_area
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-text-length:
=begin pod
=head2 get-text-length

Retrieves the current length of the text in I<entry>.

This is equivalent to getting I<entry>'s B<Gnome::Gtk3::EntryBuffer> and calling C<buffer_get_length()> on it.

Returns: the current number of characters in B<Gnome::Gtk3::Entry>, or 0 if there are none.

  method get-text-length ( --> UInt )

=end pod

method get-text-length ( --> UInt ) {
  gtk_entry_get_text_length( self._f('GtkEntry'))
}

sub gtk_entry_get_text_length (
  N-GObject $entry --> guint16
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-visibility:
=begin pod
=head2 get-visibility

Retrieves whether the text in I<entry> is visible. See C<set_visibility()>.

Returns: C<True> if the text is currently visible

  method get-visibility ( --> Bool )

=end pod

method get-visibility ( --> Bool ) {
  gtk_entry_get_visibility( self._f('GtkEntry')).Bool
}

sub gtk_entry_get_visibility (
  N-GObject $entry --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-width-chars:
=begin pod
=head2 get-width-chars

Gets the value set by C<set_width_chars()>.

Returns: number of chars to request space for, or negative if unset

  method get-width-chars ( --> Int )

=end pod

method get-width-chars ( --> Int ) {
  gtk_entry_get_width_chars( self._f('GtkEntry'))
}

sub gtk_entry_get_width_chars (
  N-GObject $entry --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:grab-focus-without-selecting:
=begin pod
=head2 grab-focus-without-selecting

Causes I<entry> to have keyboard focus.

It behaves like C<gtk_widget_grab_focus()>, except that it doesn't select the contents of the entry. You only want to call this on some special entries which the user usually doesn't want to replace all text in, such as search-as-you-type entries.

  method grab-focus-without-selecting ( )

=end pod

method grab-focus-without-selecting ( ) {
  gtk_entry_grab_focus_without_selecting( self._f('GtkEntry'));
}

sub gtk_entry_grab_focus_without_selecting (
  N-GObject $entry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:im-context-filter-keypress:
=begin pod
=head2 im-context-filter-keypress

Allow the B<Gnome::Gtk3::Entry> input method to internally handle key press and release events. If this function returns C<True>, then no further processing should be done for this key event. See C<gtk_im_context_filter_keypress()>.

Note that you are expected to call this function from your handler when overriding key event handling. This is needed in the case when you need to insert your own key handling between the input method and the default key event handling of the B<Gnome::Gtk3::Entry>. See C<gtk_text_view_reset_im_context()> for an example of use.

Returns: C<True> if the input method handled the key event.

  method im-context-filter-keypress ( N-GdkEvent $event --> Bool )

=item $event; (type Gdk.EventKey): the key event
=end pod

method im-context-filter-keypress ( N-GdkEvent $event --> Bool ) {
  gtk_entry_im_context_filter_keypress( self._f('GtkEntry'), $event).Bool
}

sub gtk_entry_im_context_filter_keypress (
  N-GObject $entry, N-GdkEvent $event --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:layout-index-to-text-index:
=begin pod
=head2 layout-index-to-text-index

Converts from a position in the entry’s B<PangoLayout> (returned by C<get_layout()>) to a position in the entry contents (returned by C<get_text()>).

Returns: byte index into the entry contents

  method layout-index-to-text-index ( Int() $layout_index --> Int )

=item $layout_index; byte index into the entry layout text
=end pod

method layout-index-to-text-index ( Int() $layout_index --> Int ) {
  gtk_entry_layout_index_to_text_index( self._f('GtkEntry'), $layout_index)
}

sub gtk_entry_layout_index_to_text_index (
  N-GObject $entry, gint $layout_index --> gint
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:progress-pulse:
=begin pod
=head2 progress-pulse

Indicates that some progress is made, but you don’t know how much. Causes the entry’s progress indicator to enter “activity mode,” where a block bounces back and forth. Each call to C<progress_pulse()> causes the block to move by a little bit (the amount of movement per pulse is determined by C<set_progress_pulse_step()>).

  method progress-pulse ( )

=end pod

method progress-pulse ( ) {
  gtk_entry_progress_pulse( self._f('GtkEntry'));
}

sub gtk_entry_progress_pulse (
  N-GObject $entry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:reset-im-context:
=begin pod
=head2 reset-im-context

Reset the input method context of the entry if needed.

This can be necessary in the case where modifying the buffer would confuse on-going input method behavior.

  method reset-im-context ( )

=end pod

method reset-im-context ( ) {
  gtk_entry_reset_im_context( self._f('GtkEntry'));
}

sub gtk_entry_reset_im_context (
  N-GObject $entry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-activates-default:
=begin pod
=head2 set-activates-default

If I<setting> is C<True>, pressing Enter in the I<entry> will activate the default widget for the window containing the entry. This usually means that the dialog box containing the entry will be closed, since the default widget is usually one of the dialog buttons.

(For experts: if I<setting> is C<True>, the entry calls C<gtk_window_activate_default()> on the window containing the entry, in the default handler for the I<activate> signal.)

  method set-activates-default ( Bool $setting )

=item $setting; C<True> to activate window’s default widget on Enter keypress
=end pod

method set-activates-default ( Bool $setting ) {
  gtk_entry_set_activates_default( self._f('GtkEntry'), $setting);
}

sub gtk_entry_set_activates_default (
  N-GObject $entry, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-alignment:
=begin pod
=head2 set-alignment

Sets the alignment for the contents of the entry. This controls the horizontal positioning of the contents when the displayed text is shorter than the width of the entry.

  method set-alignment ( Num() $xalign )

=item $xalign; The horizontal alignment, from 0 (left) to 1 (right). Reversed for RTL layouts
=end pod

method set-alignment ( Num() $xalign ) {
  gtk_entry_set_alignment( self._f('GtkEntry'), $xalign);
}

sub gtk_entry_set_alignment (
  N-GObject $entry, gfloat $xalign
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-attributes:
=begin pod
=head2 set-attributes

Sets a B<PangoAttrList>; the attributes in the list are applied to the entry text.

  method set-attributes ( PangoAttrList $attrs )

=item $attrs; a B<PangoAttrList>
=end pod

method set-attributes ( PangoAttrList $attrs ) {
  gtk_entry_set_attributes( self._f('GtkEntry'), $attrs);
}

sub gtk_entry_set_attributes (
  N-GObject $entry, PangoAttrList $attrs
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-buffer:
=begin pod
=head2 set-buffer

Set the B<Gnome::Gtk3::EntryBuffer> object which holds the text for this widget.

  method set-buffer ( N-GObject() $buffer )

=item $buffer; a B<Gnome::Gtk3::EntryBuffer>
=end pod

method set-buffer ( N-GObject() $buffer ) {
  gtk_entry_set_buffer( self._f('GtkEntry'), $buffer);
}

sub gtk_entry_set_buffer (
  N-GObject $entry, N-GObject $buffer
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-completion:
=begin pod
=head2 set-completion

Sets I<completion> to be the auxiliary completion object to use with I<entry>. All further configuration of the completion mechanism is done on I<completion> using the B<Gnome::Gtk3::EntryCompletion> API. Completion is disabled if I<completion> is set to C<undefined>.

  method set-completion ( N-GObject() $completion )

=item $completion; The B<Gnome::Gtk3::EntryCompletion> or C<undefined>
=end pod

method set-completion ( N-GObject() $completion ) {
  gtk_entry_set_completion( self._f('GtkEntry'), $completion);
}

sub gtk_entry_set_completion (
  N-GObject $entry, N-GObject $completion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-cursor-hadjustment:
=begin pod
=head2 set-cursor-hadjustment

Hooks up an adjustment to the cursor position in an entry, so that when the cursor is moved, the adjustment is scrolled to show that position. See C<gtk_scrolled_window_get_hadjustment()> for a typical way of obtaining the adjustment.

The adjustment has to be in pixel units and in the same coordinate system as the entry.

  method set-cursor-hadjustment ( N-GObject() $adjustment )

=item $adjustment; an adjustment which should be adjusted when the cursor is moved, or C<undefined>
=end pod

method set-cursor-hadjustment ( N-GObject() $adjustment ) {
  gtk_entry_set_cursor_hadjustment( self._f('GtkEntry'), $adjustment);
}

sub gtk_entry_set_cursor_hadjustment (
  N-GObject $entry, N-GObject $adjustment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-has-frame:
=begin pod
=head2 set-has-frame

Sets whether the entry has a beveled frame around it.

  method set-has-frame ( Bool $setting )

=item $setting; new value
=end pod

method set-has-frame ( Bool $setting ) {
  gtk_entry_set_has_frame( self._f('GtkEntry'), $setting);
}

sub gtk_entry_set_has_frame (
  N-GObject $entry, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-activatable:
=begin pod
=head2 set-icon-activatable

Sets whether the icon is activatable.

  method set-icon-activatable ( GtkEntryIconPosition $icon_pos, Bool $activatable )

=item $icon_pos; Icon position
=item $activatable; C<True> if the icon should be activatable
=end pod

method set-icon-activatable ( GtkEntryIconPosition $icon_pos, Bool $activatable ) {
  gtk_entry_set_icon_activatable( self._f('GtkEntry'), $icon_pos, $activatable);
}

sub gtk_entry_set_icon_activatable (
  N-GObject $entry, GEnum $icon_pos, gboolean $activatable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-drag-source:
=begin pod
=head2 set-icon-drag-source

Sets up the icon at the given position so that GTK+ will start a drag operation when the user clicks and drags the icon.

To handle the drag operation, you need to connect to the usual I<drag-data-get from Gnome::Gtk3::Widget> (or possibly I<drag-data-delete from Gnome::Gtk3::Widget>) signal, and use C<get_current_icon_drag_source()> in your signal handler to find out if the drag was started from an icon.

By default, GTK+ uses the icon as the drag icon. You can use the I<drag-begin from Gnome::Gtk3::Widget> signal to set a different icon. Note that you have to use C<g_signal_connect_after()> to ensure that your signal handler gets executed after the default handler.

  method set-icon-drag-source ( GtkEntryIconPosition $icon_pos, N-GtkTargetList $target_list, GdkDragAction $actions )

=item $icon_pos; icon position
=item $target_list; the targets (data formats) in which the data can be provided
=item $actions; a bitmask of the allowed drag actions
=end pod

method set-icon-drag-source ( GtkEntryIconPosition $icon_pos, N-GtkTargetList $target_list, GdkDragAction $actions ) {
  gtk_entry_set_icon_drag_source(
    self._f('GtkEntry'), $icon_pos, $target_list, $actions
  );
}

sub gtk_entry_set_icon_drag_source (
  N-GObject $entry, GEnum $icon_pos, N-GtkTargetList $target_list, GEnum $actions
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-from-gicon:
=begin pod
=head2 set-icon-from-gicon

Sets the icon shown in the entry at the specified position from the current icon theme. If the icon isn’t known, a “broken image” icon will be displayed instead.

If I<icon> is C<undefined>, no icon will be shown in the specified position.

  method set-icon-from-gicon ( GtkEntryIconPosition $icon_pos, N-GObject() $icon )

=item $icon_pos; The position at which to set the icon
=item $icon; The icon to set, or C<undefined>
=end pod

method set-icon-from-gicon ( GtkEntryIconPosition $icon_pos, N-GObject() $icon ) {
  gtk_entry_set_icon_from_gicon( self._f('GtkEntry'), $icon_pos, $icon);
}

sub gtk_entry_set_icon_from_gicon (
  N-GObject $entry, GEnum $icon_pos, N-GObject $icon
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-from-icon-name:
=begin pod
=head2 set-icon-from-icon-name

Sets the icon shown in the entry at the specified position from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be displayed instead.

If I<icon_name> is C<undefined>, no icon will be shown in the specified position.

  method set-icon-from-icon-name ( GtkEntryIconPosition $icon_pos, Str $icon_name )

=item $icon_pos; The position at which to set the icon
=item $icon_name; An icon name, or C<undefined>
=end pod

method set-icon-from-icon-name ( GtkEntryIconPosition $icon_pos, Str $icon_name ) {
  gtk_entry_set_icon_from_icon_name( self._f('GtkEntry'), $icon_pos, $icon_name);
}

sub gtk_entry_set_icon_from_icon_name (
  N-GObject $entry, GEnum $icon_pos, gchar-ptr $icon_name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-from-pixbuf:
=begin pod
=head2 set-icon-from-pixbuf

Sets the icon shown in the specified position using a pixbuf.

If I<pixbuf> is C<undefined>, no icon will be shown in the specified position.

  method set-icon-from-pixbuf ( GtkEntryIconPosition $icon_pos, N-GObject() $pixbuf )

=item $icon_pos; Icon position
=item $pixbuf; A B<Gnome::Gdk3::Pixbuf>, or C<undefined>
=end pod

method set-icon-from-pixbuf ( GtkEntryIconPosition $icon_pos, N-GObject() $pixbuf ) {
  gtk_entry_set_icon_from_pixbuf( self._f('GtkEntry'), $icon_pos, $pixbuf);
}

sub gtk_entry_set_icon_from_pixbuf (
  N-GObject $entry, GEnum $icon_pos, N-GObject $pixbuf
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-sensitive:
=begin pod
=head2 set-icon-sensitive

Sets the sensitivity for the specified icon.

  method set-icon-sensitive ( GtkEntryIconPosition $icon_pos, Bool $sensitive )

=item $icon_pos; Icon position
=item $sensitive; Specifies whether the icon should appear sensitive or insensitive
=end pod

method set-icon-sensitive ( GtkEntryIconPosition $icon_pos, Bool $sensitive ) {
  gtk_entry_set_icon_sensitive( self._f('GtkEntry'), $icon_pos, $sensitive);
}

sub gtk_entry_set_icon_sensitive (
  N-GObject $entry, GEnum $icon_pos, gboolean $sensitive
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-icon-tooltip-markup:
=begin pod
=head2 set-icon-tooltip-markup

Sets I<tooltip> as the contents of the tooltip for the icon at the specified position. I<tooltip> is assumed to be marked up with the [Pango text markup language][PangoMarkupFormat].

Use C<undefined> for I<tooltip> to remove an existing tooltip.

See also C<gtk_widget_set_tooltip_markup()> and C<set_icon_tooltip_text()>.

  method set-icon-tooltip-markup ( GtkEntryIconPosition $icon_pos, Str $tooltip )

=item $icon_pos; the icon position
=item $tooltip; the contents of the tooltip for the icon, or C<undefined>
=end pod

method set-icon-tooltip-markup ( GtkEntryIconPosition $icon_pos, Str $tooltip ) {
  gtk_entry_set_icon_tooltip_markup( self._f('GtkEntry'), $icon_pos, $tooltip);
}

sub gtk_entry_set_icon_tooltip_markup (
  N-GObject $entry, GEnum $icon_pos, gchar-ptr $tooltip
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-icon-tooltip-text:
=begin pod
=head2 set-icon-tooltip-text

Sets I<tooltip> as the contents of the tooltip for the icon at the specified position.

Use C<undefined> for I<tooltip> to remove an existing tooltip.

See also C<gtk_widget_set_tooltip_text()> and C<set_icon_tooltip_markup()>.

If you unset the widget tooltip via C<gtk_widget_set_tooltip_text()> or C<gtk_widget_set_tooltip_markup()>, this sets GtkWidget:has-tooltip to C<False>, which suppresses icon tooltips too. You can resolve this by then calling C<gtk_widget_set_has_tooltip()> to set GtkWidget:has-tooltip back to C<True>, or setting at least one non-empty tooltip on any icon achieves the same result.

  method set-icon-tooltip-text ( GtkEntryIconPosition $icon_pos, Str $tooltip )

=item $icon_pos; the icon position
=item $tooltip; the contents of the tooltip for the icon, or C<undefined>
=end pod

method set-icon-tooltip-text ( GtkEntryIconPosition $icon_pos, Str $tooltip ) {
  gtk_entry_set_icon_tooltip_text( self._f('GtkEntry'), $icon_pos, $tooltip);
}

sub gtk_entry_set_icon_tooltip_text (
  N-GObject $entry, GEnum $icon_pos, gchar-ptr $tooltip
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-input-hints:
=begin pod
=head2 set-input-hints

Sets the I<input-hints> property, which allows input methods to fine-tune their behaviour.

  method set-input-hints ( GtkInputHints $hints )

=item $hints; the hints
=end pod

method set-input-hints ( GtkInputHints $hints ) {
  gtk_entry_set_input_hints( self._f('GtkEntry'), $hints);
}

sub gtk_entry_set_input_hints (
  N-GObject $entry, GEnum $hints
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-input-purpose:
=begin pod
=head2 set-input-purpose

Sets the I<input-purpose> property which can be used by on-screen keyboards and other input methods to adjust their behaviour.

  method set-input-purpose ( GtkInputPurpose $purpose )

=item $purpose; the purpose
=end pod

method set-input-purpose ( GtkInputPurpose $purpose ) {
  gtk_entry_set_input_purpose( self._f('GtkEntry'), $purpose);
}

sub gtk_entry_set_input_purpose (
  N-GObject $entry, GEnum $purpose
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-invisible-char:
=begin pod
=head2 set-invisible-char

Sets the character to use in place of the actual text when C<set_visibility()> has been called to set text visibility to C<False>. i.e. this is the character used in “password mode” to show the user how many characters have been typed. By default, GTK+ picks the best invisible char available in the current font. If you set the invisible char to 0, then the user will get no feedback at all; there will be no text on the screen as they type.

  method set-invisible-char ( gunichar $ch )

=item $ch; a Unicode character
=end pod

method set-invisible-char ( gunichar $ch ) {
  gtk_entry_set_invisible_char( self._f('GtkEntry'), $ch);
}

sub gtk_entry_set_invisible_char (
  N-GObject $entry, gunichar $ch
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-max-length:
=begin pod
=head2 set-max-length

Sets the maximum allowed length of the contents of the widget. If the current contents are longer than the given length, then they will be truncated to fit.

This is equivalent to getting I<entry>'s B<Gnome::Gtk3::EntryBuffer> and calling C<buffer_set_max_length()> on it. ]|

  method set-max-length ( Int() $max )

=item $max; the maximum length of the entry, or 0 for no maximum. (other than the maximum length of entries.) The value passed in will be clamped to the range 0-65536.
=end pod

method set-max-length ( Int() $max ) {
  gtk_entry_set_max_length( self._f('GtkEntry'), $max);
}

sub gtk_entry_set_max_length (
  N-GObject $entry, gint $max
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-max-width-chars:
=begin pod
=head2 set-max-width-chars

Sets the desired maximum width in characters of I<entry>.

  method set-max-width-chars ( Int() $n_chars )

=item $n_chars; the new desired maximum width, in characters
=end pod

method set-max-width-chars ( Int() $n_chars ) {
  gtk_entry_set_max_width_chars( self._f('GtkEntry'), $n_chars);
}

sub gtk_entry_set_max_width_chars (
  N-GObject $entry, gint $n_chars
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-overwrite-mode:
=begin pod
=head2 set-overwrite-mode

Sets whether the text is overwritten when typing in the B<Gnome::Gtk3::Entry>.

  method set-overwrite-mode ( Bool $overwrite )

=item $overwrite; new value
=end pod

method set-overwrite-mode ( Bool $overwrite ) {
  gtk_entry_set_overwrite_mode( self._f('GtkEntry'), $overwrite);
}

sub gtk_entry_set_overwrite_mode (
  N-GObject $entry, gboolean $overwrite
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-placeholder-text:
=begin pod
=head2 set-placeholder-text

Sets text to be displayed in I<entry> when it is empty and unfocused. This can be used to give a visual hint of the expected contents of the B<Gnome::Gtk3::Entry>.

Note that since the placeholder text gets removed when the entry received focus, using this feature is a bit problematic if the entry is given the initial focus in a window. Sometimes this can be worked around by delaying the initial focus setting until the first key event arrives.

  method set-placeholder-text ( Str $text )

=item $text; a string to be displayed when I<entry> is empty and unfocused, or C<undefined>
=end pod

method set-placeholder-text ( Str $text ) {
  gtk_entry_set_placeholder_text( self._f('GtkEntry'), $text);
}

sub gtk_entry_set_placeholder_text (
  N-GObject $entry, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-progress-fraction:
=begin pod
=head2 set-progress-fraction

Causes the entry’s progress indicator to “fill in” the given fraction of the bar. The fraction should be between 0.0 and 1.0, inclusive.

  method set-progress-fraction ( Num() $fraction )

=item $fraction; fraction of the task that’s been completed
=end pod

method set-progress-fraction ( Num() $fraction ) {
  gtk_entry_set_progress_fraction( self._f('GtkEntry'), $fraction);
}

sub gtk_entry_set_progress_fraction (
  N-GObject $entry, gdouble $fraction
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-progress-pulse-step:
=begin pod
=head2 set-progress-pulse-step

Sets the fraction of total entry width to move the progress bouncing block for each call to C<progress_pulse()>.

  method set-progress-pulse-step ( Num() $fraction )

=item $fraction; fraction between 0.0 and 1.0
=end pod

method set-progress-pulse-step ( Num() $fraction ) {
  gtk_entry_set_progress_pulse_step( self._f('GtkEntry'), $fraction);
}

sub gtk_entry_set_progress_pulse_step (
  N-GObject $entry, gdouble $fraction
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-tabs:
=begin pod
=head2 set-tabs

Sets a B<PangoTabArray>; the tabstops in the array are applied to the entry text.

  method set-tabs ( PangoTabArray $tabs )

=item $tabs; a B<PangoTabArray>
=end pod

method set-tabs ( PangoTabArray $tabs ) {
  gtk_entry_set_tabs( self._f('GtkEntry'), $tabs);
}

sub gtk_entry_set_tabs (
  N-GObject $entry, PangoTabArray $tabs
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-text:
=begin pod
=head2 set-text

Sets the text in the widget to the given value, replacing the current contents.

See C<buffer_set_text()>.

  method set-text ( Str $text )

=item $text; the new text
=end pod

method set-text ( Str $text ) {
  gtk_entry_set_text( self._f('GtkEntry'), $text);
}

sub gtk_entry_set_text (
  N-GObject $entry, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-visibility:
=begin pod
=head2 set-visibility

Sets whether the contents of the entry are visible or not. When visibility is set to C<False>, characters are displayed as the invisible char, and will also appear that way when the text in the entry widget is copied elsewhere.

By default, GTK+ picks the best invisible character available in the current font, but it can be changed with C<set_invisible_char()>.

Note that you probably want to set I<input-purpose> to C<GTK_INPUT_PURPOSE_PASSWORD> or C<GTK_INPUT_PURPOSE_PIN> to inform input methods about the purpose of this entry, in addition to setting visibility to C<False>.

  method set-visibility ( Bool $visible )

=item $visible; C<True> if the contents of the entry are displayed as plaintext
=end pod

method set-visibility ( Bool $visible ) {
  gtk_entry_set_visibility( self._f('GtkEntry'), $visible);
}

sub gtk_entry_set_visibility (
  N-GObject $entry, gboolean $visible
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-width-chars:
=begin pod
=head2 set-width-chars

Changes the size request of the entry to be about the right size for I<n_chars> characters. Note that it changes the size request, the size can still be affected by how you pack the widget into containers. If I<n_chars> is -1, the size reverts to the default entry size.

  method set-width-chars ( Int() $n_chars )

=item $n_chars; width in chars
=end pod

method set-width-chars ( Int() $n_chars ) {
  gtk_entry_set_width_chars( self._f('GtkEntry'), $n_chars);
}

sub gtk_entry_set_width_chars (
  N-GObject $entry, gint $n_chars
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:text-index-to-layout-index:
=begin pod
=head2 text-index-to-layout-index

Converts from a position in the entry contents (returned by C<get_text()>) to a position in the entry’s B<PangoLayout> (returned by C<get_layout()>, with text retrieved via C<pango_layout_get_text()>).

Returns: byte index into the entry layout text

  method text-index-to-layout-index ( Int() $text_index --> Int )

=item $text_index; byte index into the entry contents
=end pod

method text-index-to-layout-index ( Int() $text_index --> Int ) {
  gtk_entry_text_index_to_layout_index( self._f('GtkEntry'), $text_index)
}

sub gtk_entry_text_index_to_layout_index (
  N-GObject $entry, gint $text_index --> gint
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:unset-invisible-char:
=begin pod
=head2 unset-invisible-char

Unsets the invisible char previously set with C<set_invisible_char()>. So that the default invisible char is used again.

  method unset-invisible-char ( )

=end pod

method unset-invisible-char ( ) {
  gtk_entry_unset_invisible_char( self._f('GtkEntry'));
}

sub gtk_entry_unset_invisible_char (
  N-GObject $entry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_entry_new:
#`{{
=begin pod
=head2 _gtk_entry_new

Creates a new entry.

Returns: a new B<Gnome::Gtk3::Entry>.

  method _gtk_entry_new ( --> N-GObject )

=end pod
}}

sub _gtk_entry_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_entry_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_entry_new_with_buffer:
#`{{
=begin pod
=head2 _gtk_entry_new_with_buffer

Creates a new entry with the specified text buffer.

Returns: a new B<Gnome::Gtk3::Entry>

  method _gtk_entry_new_with_buffer ( N-GObject() $buffer --> N-GObject )

=item $buffer; The buffer to use for the new B<Gnome::Gtk3::Entry>.
=end pod
}}

sub _gtk_entry_new_with_buffer ( N-GObject $buffer --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_entry_new_with_buffer')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:activate:
=head2 activate

The I<activate> signal is emitted when the user hits
the Enter key.

While this signal is used as a
[keybinding signal][GtkBindingSignal],
it is also commonly used by applications to intercept
activation of entries.

The default bindings for this signal are all forms of the Enter key.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:backspace:
=head2 backspace

The I<backspace> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

The default bindings for this signal are
Backspace and Shift-Backspace.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:copy-clipboard:
=head2 copy-clipboard

The I<copy-clipboard> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to copy the selection to the clipboard.

The default bindings for this signal are
Ctrl-c and Ctrl-Insert.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:cut-clipboard:
=head2 cut-clipboard

The I<cut-clipboard> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to cut the selection to the clipboard.

The default bindings for this signal are
Ctrl-x and Shift-Delete.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:delete-from-cursor:
=head2 delete-from-cursor

The I<delete-from-cursor> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user initiates a text deletion.

If the I<type> is C<GTK_DELETE_CHARS>, GTK+ deletes the selection
if there is one, otherwise it deletes the requested number
of characters.

The default bindings for this signal are
Delete for deleting a character and Ctrl-Delete for
deleting a word.

  method handler (
    Unknown type: GTK_TYPE_DELETE_TYPE $type,
    Int $count,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $type; the granularity of the deletion, as a B<Gnome::Gtk3::DeleteType>
=item $count; the number of I<type> units to delete
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:icon-press:
=head2 icon-press

The I<icon-press> signal is emitted when an activatable icon
is clicked.

  method handler (
    Unknown type: GTK_TYPE_ENTRY_ICON_POSITION $icon_pos,
    Unknown type: GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $event,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $icon_pos; The position of the clicked icon
=item $event; the button press event
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:icon-release:
=head2 icon-release

The I<icon-release> signal is emitted on the button release from a
mouse click over an activatable icon.

  method handler (
    Unknown type: GTK_TYPE_ENTRY_ICON_POSITION $icon_pos,
    Unknown type: GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $event,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $icon_pos; The position of the clicked icon
=item $event; the button release event
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:insert-at-cursor:
=head2 insert-at-cursor

The I<insert-at-cursor> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user initiates the insertion of a
fixed string at the cursor.

This signal has no default bindings.

  method handler (
    Str $string,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $string; the string to insert
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:insert-emoji:
=head2 insert-emoji

The I<insert-emoji> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to present the Emoji chooser for the I<entry>.

The default bindings for this signal are Ctrl-. and Ctrl-;.27

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:move-cursor:
=head2 move-cursor

The I<move-cursor> signal is a
[keybinding signal][GtkBindingSignal]
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
    Unknown type: GTK_TYPE_MOVEMENT_STEP $step,
    Int $count,
    Bool $extend_selection,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>
=item $count; the number of I<step> units to move
=item $extend_selection; C<True> if the move should extend the selection
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:paste-clipboard:
=head2 paste-clipboard

The I<paste-clipboard> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to paste the contents of the clipboard
into the text view.

The default bindings for this signal are
Ctrl-v and Shift-Insert.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:populate-popup:
=head2 populate-popup

The I<populate-popup> signal gets emitted before showing the
context menu of the entry.

If you need to add items to the context menu, connect
to this signal and append your items to the I<widget>, which
will be a B<Gnome::Gtk3::Menu> in this case.

If I<populate-all> is C<True>, this signal will
also be emitted to populate touch popups. In this case,
I<widget> will be a different container, e.g. a B<Gnome::Gtk3::Toolbar>.
The signal handler should not make assumptions about the
type of I<widget>.

  method handler (
    N-GObject #`{ native widget } $widget,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $widget; the container that is being populated
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:preedit-changed:
=head2 preedit-changed

If an input method is used, the typed text will not immediately
be committed to the buffer. So if you are interested in the text,
connect to this signal.

  method handler (
    Str $preedit,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $preedit; the current preedit string
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:toggle-overwrite:
=head2 toggle-overwrite

The I<toggle-overwrite> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to toggle the overwrite mode of the entry.

The default bindings for this signal is Insert.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:activates-default:
=head2 activates-default

Whether to activate the default widget (such as the default button in a dialog when Enter is pressed)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:attributes:
=head2 attributes

A list of style attributes to apply to the text of the label

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item The type of this G_TYPE_BOXED object is PANGO_TYPE_ATTR_LIST
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:buffer:
=head2 buffer

Text buffer object which actually stores entry text

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_ENTRY_BUFFER
=item Parameter is readable and writable.
=item Parameter is set on construction of object.


=comment -----------------------------------------------------------------------
=comment #TP:0:caps-lock-warning:
=head2 caps-lock-warning

Whether password entries will show a warning when Caps Lock is on

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:completion:
=head2 completion

The auxiliary completion object

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_ENTRY_COMPLETION
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:cursor-position:
=head2 cursor-position

The current position of the insertion cursor in chars

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is GTK_ENTRY_BUFFER_MAX_SIZE.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:editable:
=head2 editable

Whether the entry contents can be edited

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:enable-emoji-completion:
=head2 enable-emoji-completion

Whether to suggest Emoji replacements

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:has-frame:
=head2 has-frame

FALSE removes outside bevel from entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:im-module:
=head2 im-module

Which IM module should be used

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:input-hints:
=head2 input-hints

Hints for the text field behaviour

=item B<Gnome::GObject::Value> type of this property is G_TYPE_FLAGS
=item The type of this G_TYPE_FLAGS object is GTK_TYPE_INPUT_HINTS
=item Parameter is readable and writable.
=item Default value is GTK_INPUT_HINT_NONE.


=comment -----------------------------------------------------------------------
=comment #TP:0:input-purpose:
=head2 input-purpose

Purpose of the text field

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_INPUT_PURPOSE
=item Parameter is readable and writable.
=item Default value is GTK_INPUT_PURPOSE_FREE_FORM.


=comment -----------------------------------------------------------------------
=comment #TP:0:invisible-char:
=head2 invisible-char

The character to use when masking entry contents (in \password mode\)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_UNICHAR


=comment -----------------------------------------------------------------------
=comment #TP:0:invisible-char-set:
=head2 invisible-char-set

Whether the invisible character has been set

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:max-length:
=head2 max-length

Maximum number of characters for this entry. Zero if no maximum

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is GTK_ENTRY_BUFFER_MAX_SIZE.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:max-width-chars:
=head2 max-width-chars

The desired maximum width of the entry, in characters

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:0:overwrite-mode:
=head2 overwrite-mode

Whether new text overwrites existing text

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:placeholder-text:
=head2 placeholder-text

Show text in the entry when it's empty and unfocused

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:populate-all:
=head2 populate-all

Whether to emit I<populate-popup> for touch popups

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-activatable:
=head2 primary-icon-activatable

Whether the primary icon is activatable

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-gicon:
=head2 primary-icon-gicon

GIcon for primary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is G_TYPE_ICON
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-name:
=head2 primary-icon-name

Icon name for primary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-pixbuf:
=head2 primary-icon-pixbuf

Primary pixbuf for the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GDK_TYPE_PIXBUF
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-sensitive:
=head2 primary-icon-sensitive

Whether the primary icon is sensitive

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-storage-type:
=head2 primary-icon-storage-type

The representation being used for primary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_IMAGE_TYPE
=item Parameter is readable.
=item Default value is GTK_IMAGE_EMPTY.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-tooltip-markup:
=head2 primary-icon-tooltip-markup

The contents of the tooltip on the primary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:primary-icon-tooltip-text:
=head2 primary-icon-tooltip-text

The contents of the tooltip on the primary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:progress-fraction:
=head2 progress-fraction

The current fraction of the task that's been completed

=item B<Gnome::GObject::Value> type of this property is G_TYPE_DOUBLE
=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.0.


=comment -----------------------------------------------------------------------
=comment #TP:0:progress-pulse-step:
=head2 progress-pulse-step
The fraction of total entry width to move the progress bouncing block for each call to gtk_entry_progress_pulse()

=item B<Gnome::GObject::Value> type of this property is G_TYPE_DOUBLE
=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.1.


=comment -----------------------------------------------------------------------
=comment #TP:0:scroll-offset:
=head2 scroll-offset

Number of pixels of the entry scrolled off the screen to the left

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-activatable:
=head2 secondary-icon-activatable

Whether the secondary icon is activatable

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-gicon:
=head2 secondary-icon-gicon

GIcon for secondary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is G_TYPE_ICON
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-name:
=head2 secondary-icon-name

Icon name for secondary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-pixbuf:
=head2 secondary-icon-pixbuf

Secondary pixbuf for the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GDK_TYPE_PIXBUF
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-sensitive:
=head2 secondary-icon-sensitive

Whether the secondary icon is sensitive

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-storage-type:
=head2 secondary-icon-storage-type

The representation being used for secondary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_IMAGE_TYPE
=item Parameter is readable.
=item Default value is GTK_IMAGE_EMPTY.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-tooltip-markup:
=head2 secondary-icon-tooltip-markup

The contents of the tooltip on the secondary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:secondary-icon-tooltip-text:
=head2 secondary-icon-tooltip-text

The contents of the tooltip on the secondary icon

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:selection-bound:
=head2 selection-bound

The position of the opposite end of the selection from the cursor in chars

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is GTK_ENTRY_BUFFER_MAX_SIZE.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:show-emoji-icon:
=head2 show-emoji-icon

Whether to show an icon for Emoji

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:tabs:
=head2 tabs

A list of tabstop locations to apply to the text of the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item The type of this G_TYPE_BOXED object is PANGO_TYPE_TAB_ARRAY
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:text:
=head2 text

The contents of the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:text-length:
=head2 text-length

Length of the text currently in the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_UINT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXUINT16.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:0:truncate-multiline:
=head2 truncate-multiline

Whether to truncate multiline pastes to one line.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:visibility:
=head2 visibility

FALSE displays the \invisible char\ instead of the actual text (password mode)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:width-chars:
=head2 width-chars

Number of characters to leave space for in the entry

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:0:xalign:
=head2 xalign

The horizontal alignment, from 0 (left to 1 (right). Reversed for RTL layouts.)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_FLOAT
=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.0.

=end pod





























=finish
#-------------------------------------------------------------------------------
#TM:2:_gtk_entry_new:
#`{{
=begin pod
=head2 [gtk_] entry_new

Creates a new entry.

Returns: a new B<Gnome::Gtk3::Entry>.

  method gtk_entry_new ( --> N-GObject  )


=end pod
}}

sub _gtk_entry_new (  )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_entry_new')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_new_with_buffer:
=begin pod
=head2 [[gtk_] entry_] new_with_buffer

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
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_buffer:
=begin pod
=head2 [[gtk_] entry_] get_buffer

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
=head2 [[gtk_] entry_] set_buffer

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
=head2 [[gtk_] entry_] get_text_area

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
=head2 [[gtk_] entry_] set_visibility

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
=head2 [[gtk_] entry_] get_visibility

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
=head2 [[gtk_] entry_] set_invisible_char

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
=head2 [[gtk_] entry_] get_invisible_char

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
=head2 [[gtk_] entry_] unset_invisible_char

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
=head2 [[gtk_] entry_] set_has_frame

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
=head2 [[gtk_] entry_] get_has_frame

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
=head2 [[gtk_] entry_] set_overwrite_mode

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
=head2 [[gtk_] entry_] get_overwrite_mode

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
=head2 [[gtk_] entry_] set_max_length

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
=head2 [[gtk_] entry_] get_max_length

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
=head2 [[gtk_] entry_] get_text_length

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
=head2 [[gtk_] entry_] set_activates_default

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
=head2 [[gtk_] entry_] get_activates_default

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
=head2 [[gtk_] entry_] set_width_chars

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
=head2 [[gtk_] entry_] get_width_chars

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
=head2 [[gtk_] entry_] set_max_width_chars

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
=head2 [[gtk_] entry_] get_max_width_chars

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
=head2 [[gtk_] entry_] set_text

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
=head2 [[gtk_] entry_] get_text

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
=head2 [[gtk_] entry_] get_layout

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
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_layout_offsets:
=begin pod
=head2 [[gtk_] entry_] get_layout_offsets

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
=head2 [[gtk_] entry_] set_alignment

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
=head2 [[gtk_] entry_] get_alignment

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
#TM:2:gtk_entry_set_completion:
=begin pod
=head2 [[gtk_] entry_] set_completion

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
=head2 [[gtk_] entry_] get_completion

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
=head2 [[gtk_] entry_] layout_index_to_text_index

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
=head2 [[gtk_] entry_] text_index_to_layout_index

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
=head2 [[gtk_] entry_] set_cursor_hadjustment

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
=head2 [[gtk_] entry_] get_cursor_hadjustment

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
=head2 [[gtk_] entry_] set_progress_fraction

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
=head2 [[gtk_] entry_] get_progress_fraction

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
=head2 [[gtk_] entry_] set_progress_pulse_step

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
=head2 [[gtk_] entry_] get_progress_pulse_step

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
=head2 [[gtk_] entry_] progress_pulse

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
=head2 [[gtk_] entry_] get_placeholder_text

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
=head2 [[gtk_] entry_] set_placeholder_text

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
=head2 [[gtk_] entry_] set_icon_from_pixbuf

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
=head2 [[gtk_] entry_] set_icon_from_icon_name

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
=head2 [[gtk_] entry_] set_icon_from_gicon

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
=head2 [[gtk_] entry_] get_icon_storage_type

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
=head2 [[gtk_] entry_] get_icon_pixbuf

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
=head2 [[gtk_] entry_] get_icon_name

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
=head2 [[gtk_] entry_] get_icon_gicon

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
=head2 [[gtk_] entry_] set_icon_activatable

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
=head2 [[gtk_] entry_] get_icon_activatable

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
=head2 [[gtk_] entry_] set_icon_sensitive

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
=head2 [[gtk_] entry_] get_icon_sensitive

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
=head2 [[gtk_] entry_] get_icon_at_pos

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
=head2 [[gtk_] entry_] set_icon_tooltip_text

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
=head2 [[gtk_] entry_] get_icon_tooltip_text

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
=head2 [[gtk_] entry_] set_icon_tooltip_markup

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
=head2 [[gtk_] entry_] get_icon_tooltip_markup

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
=head2 [[gtk_] entry_] set_icon_drag_source

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
    GtkEntryIconPosition $icon_pos, N-GtkTargetList $target_list,
    GdkDragAction $actions
  )

=item GtkEntryIconPosition $icon_pos; icon position
=item N-GtkTargetList $target_list; the targets (data formats) in which the data can be provided
=item GdkDragAction $actions; a bitmask of the allowed drag actions

=end pod

sub gtk_entry_set_icon_drag_source ( N-GObject $entry, int32 $icon_pos, N-GtkTargetList $target_list, GdkDragAction $actions )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_get_current_icon_drag_source:
=begin pod
=head2 [[gtk_] entry_] get_current_icon_drag_source

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
=head2 [[gtk_] entry_] get_icon_area

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
=head2 [[gtk_] entry_] im_context_filter_keypress

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

  method gtk_entry_im_context_filter_keypress ( N-GdkEventKey $event --> Int  )

=item N-GdkEventKey $event; (type B<Gnome::Gdk3::.EventKey>): the key event

=end pod

sub gtk_entry_im_context_filter_keypress ( N-GObject $entry, N-GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_entry_reset_im_context:
=begin pod
=head2 [[gtk_] entry_] reset_im_context

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
=head2 [[gtk_] entry_] set_input_purpose

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
=head2 [[gtk_] entry_] get_input_purpose

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
=head2 [[gtk_] entry_] set_input_hints

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
=head2 [[gtk_] entry_] get_input_hints

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
=head2 [[gtk_] entry_] set_attributes

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
=head2 [[gtk_] entry_] get_attributes

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
=head2 [[gtk_] entry_] set_tabs

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
=head2 [[gtk_] entry_] get_tabs

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
=head2 [[gtk_] entry_] grab_focus_without_selecting

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
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
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

  my Gnome::Gtk3::Label $label .= new;
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
