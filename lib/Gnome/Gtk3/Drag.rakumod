#TL:1:Gnome::Gtk3::Drag:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Drag

Functions for controlling drag and drop handling


=comment ![](images/X.png)


=head1 Description


GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

As well as the functions listed here, applications may need to use some facilities provided for [Selections][gtk3-Selections]. Also, the Drag and Drop API makes use of signals in the B<Gnome::Gtk3::Widget> class.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Drag;


=comment head2 Uml Diagram

=comment ![](plantuml/Drag.svg)


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Drag:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new Drag object.

  multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like C<:native-object> is needed.

=end pod

#TM:1:new():
# submethod BUILD ( *%options ) {  }

#`{{
#-------------------------------------------------------------------------------
#TM:0:begin-with-coordinates:
=begin pod
=head2 begin-with-coordinates

Initiates a drag on the source side. The function only needs to be used when the application is starting drags itself, and is not needed when C<source_set()> is used.

The I<event> is used to retrieve the timestamp that will be used internally to grab the pointer. If I<event> is C<undefined>, then C<GDK_CURRENT_TIME> will be used. However, you should try to pass a real event in all cases, since that can be used to get information about the drag.

Generally there are three cases when you want to start a drag by hand by calling this function:

1. During a I<button-press-event from Gnome::Gtk3::Widget> handler, if you want to start a drag immediately when the user presses the mouse button. Pass the I<event> that you have in your I<button-press-event from Gnome::Gtk3::Widget> handler.

2. During a I<motion-notify-event from Gnome::Gtk3::Widget> handler, if you want to start a drag when the mouse moves past a certain threshold distance after a button-press. Pass the I<event> that you have in your I<motion-notify-event from Gnome::Gtk3::Widget> handler.

3. During a timeout handler, if you want to start a drag after the mouse button is held down for some time. Try to save the last event that you got from the mouse, using C<gdk_event_copy()>, and pass it to this function (remember to free the event with C<gdk_event_free()> when you are done). If you really cannot pass a real event, pass C<undefined> instead.

Returns: the context for this drag

  method begin-with-coordinates ( N-GObject() $widget, GtkTargetList $targets, GdkDragAction $actions, Int() $button, N-GdkEvent $event, Int() $x, Int() $y --> N-GObject )

=item $widget; the source widget
=item $targets; The targets (data formats) in which the source can provide the data
=item $actions; A bitmask of the allowed drag actions for this drag
=item $button; The button the user clicked to start the drag
=item $event; The event that triggered the start of the drag, or C<undefined> if none can be obtained.
=item $x; The initial x coordinate to start dragging from, in the coordinate space of I<widget>. If -1 is passed, the coordinates are retrieved from I<event> or the current pointer position
=item $y; The initial y coordinate to start dragging from, in the coordinate space of I<widget>. If -1 is passed, the coordinates are retrieved from I<event> or the current pointer position
=end pod

method begin-with-coordinates ( N-GObject() $widget, GtkTargetList $targets, GdkDragAction $actions, Int() $button, N-GdkEvent $event, Int() $x, Int() $y --> N-GObject ) {
  gtk_drag_begin_with_coordinates( $widget, $targets, $actions, $button, $event, $x, $y)
}

sub gtk_drag_begin_with_coordinates (
  N-GObject $widget, GtkTargetList $targets, GEnum $actions, gint $button, N-GdkEvent $event, gint $x, gint $y --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:cancel:
=begin pod
=head2 cancel

Cancels an ongoing drag operation on the source side.

If you want to be able to cancel a drag operation in this way, you need to keep a pointer to the drag context, either from an explicit call to C<begin_with_coordinates()>, or by connecting to I<drag-begin from Gnome::Gtk3::Widget>.

If I<context> does not refer to an ongoing drag operation, this function does nothing.

If a drag is cancelled in this way, the I<result> argument of I<drag-failed from Gnome::Gtk3::Widget> is set to I<GTK_DRAG_RESULT_ERROR>.

  method cancel ( N-GObject() $context )

=item $context; a native B<Gnome::Gdk3::DragContext>.
=comment , as e.g. returned by C<begin-with-coordinates()>

=end pod

method cancel ( N-GObject() $context ) {
  gtk_drag_cancel($context);
}

sub gtk_drag_cancel (
  N-GObject $context
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:check-threshold:
=begin pod
=head2 check-threshold

Checks to see if a mouse drag starting at (I<start_x>, I<start_y>) and ending at (I<current_x>, I<current_y>) has passed the GTK+ drag threshold, and thus should trigger the beginning of a drag-and-drop operation.

Returns: C<True> if the drag threshold has been passed.

  method check-threshold ( N-GObject() $widget, Int() $start_x, Int() $start_y, Int() $current_x, Int() $current_y --> Bool )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $start_x; X coordinate of start of drag
=item $start_y; Y coordinate of start of drag
=item $current_x; current X coordinate
=item $current_y; current Y coordinate
=end pod

method check-threshold ( N-GObject() $widget, Int() $start_x, Int() $start_y, Int() $current_x, Int() $current_y --> Bool ) {
  gtk_drag_check_threshold( $widget, $start_x, $start_y, $current_x, $current_y).Bool
}

sub gtk_drag_check_threshold (
  N-GObject $widget, gint $start_x, gint $start_y, gint $current_x, gint $current_y --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:finish:xt/examples/Dnd
=begin pod
=head2 finish

Informs the drag source that the drop is finished, and that the data of the drag will no longer be required.

  method finish ( N-GObject() $context, Bool $success, Bool $del, UInt $time )

=item $context; the drag context
=item $success; a flag indicating whether the drop was successful
=item $del; a flag indicating whether the source should delete the original data. (This should be C<True> for a move)
=item $time; the timestamp from the I<drag-drop from Gnome::Gtk3::Widget> signal
=end pod

method finish ( N-GObject() $context, Bool $success, Bool $del, UInt $time ) {
  gtk_drag_finish( $context, $success, $del, $time);
}

sub gtk_drag_finish (
  N-GObject $context, gboolean $success, gboolean $del, guint32 $time
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-data:xt/examples/Dnd
=begin pod
=head2 get-data

Gets the data associated with a drag. When the data is received or the retrieval fails, GTK+ will emit a I<drag-data-received from Gnome::Gtk3::Widget> signal. Failure of the retrieval is indicated by the length field of the I<selection_data> signal parameter being negative. However, when C<get_data()> is called implicitely because the C<GTK_DEST_DEFAULT_DROP> was set, then the widget will not receive notification of failed drops.

  method get-data (
    N-GObject() $widget, N-GObject() $context,
    N-GObject() $target, UInt $time
  )

=item $widget; the widget that will receive the I<drag-data-received from Gnome::Gtk3::Widget> signal
=item $context; the drag context, a B<Gnome::Gdk3::DragContext>.
=item $target; the target (form of the data) to retrieve, A native B<Gnome::Gdk3::Atom>.
=item $time; a timestamp for retrieving the data. This will generally be the time received in a I<drag-motion from Gnome::Gtk3::Widget> or I<drag-drop from Gnome::Gtk3::Widget> signal
=end pod

method get-data (
  N-GObject() $widget, N-GObject() $context, N-GObject() $target, UInt $time
) {
  gtk_drag_get_data( $widget, $context, $target, $time);
}

sub gtk_drag_get_data (
  N-GObject $widget, N-GObject $context, N-GObject $target, guint32 $time
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-source-widget:
=begin pod
=head2 get-source-widget

Determines the source widget for a drag.

Returns: if the drag is occurring within a single application, a pointer to the source widget. Otherwise, C<undefined>.

  method get-source-widget ( N-GObject() $context --> N-GObject )

=item $context; a (destination side) drag context
=end pod

method get-source-widget ( N-GObject() $context --> N-GObject ) {
  gtk_drag_get_source_widget($context)
}

sub gtk_drag_get_source_widget (
  N-GObject $context --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:highlight:xt/examples/Dnd
=begin pod
=head2 highlight

Highlights a widget as a currently hovered drop target. To end the highlight, call C<unhighlight()>. GTK+ calls this automatically if C<GTK_DEST_DEFAULT_HIGHLIGHT> is set.

  method highlight ( N-GObject() $widget )

=item $widget; a widget to highlight
=end pod

method highlight ( N-GObject() $widget ) {
  gtk_drag_highlight($widget);
}

sub gtk_drag_highlight (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-icon-default:
=begin pod
=head2 set-icon-default

Sets the icon for a particular drag to the default icon.

  method set-icon-default ( N-GObject() $context )

=item $context; the context for a drag (This must be called  with a  context for the source side of a drag)
=end pod

method set-icon-default ( N-GObject() $context ) {
  gtk_drag_set_icon_default($context);
}

sub gtk_drag_set_icon_default (
  N-GObject $context
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-gicon:
=begin pod
=head2 set-icon-gicon

Sets the icon for a given drag from the given I<icon>. See the documentation for C<set_icon_name()> for more details about using icons in drag and drop.

  method set-icon-gicon ( N-GObject() $context, N-GObject() $icon, Int() $hot_x, Int() $hot_y )

=item $context; the context for a drag (This must be called  with a context for the source side of a drag)
=item $icon; a B<Gnome::Gio::Icon>
=item $hot_x; the X offset of the hotspot within the icon
=item $hot_y; the Y offset of the hotspot within the icon
=end pod

method set-icon-gicon ( N-GObject() $context, N-GObject() $icon, Int() $hot_x, Int() $hot_y ) {
  gtk_drag_set_icon_gicon( $context, $icon, $hot_x, $hot_y);
}

sub gtk_drag_set_icon_gicon (
  N-GObject $context, N-GObject $icon, gint $hot_x, gint $hot_y
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-icon-name:
=begin pod
=head2 set-icon-name

Sets the icon for a given drag from a named themed icon. See the docs for B<Gnome::Gtk3::IconTheme> for more details. Note that the size of the icon depends on the icon theme (the icon is loaded at the symbolic size B<Gnome::Gio::TK_ICON_SIZE_DND>), thus I<hot_x> and I<hot_y> have to be used with care.

  method set-icon-name (
    N-GObject() $context, Str $icon_name, Int() $hot_x, Int() $hot_y
  )

=item $context; the context for a drag (This must be called  with a context for the source side of a drag)
=item $icon_name; name of icon to use
=item $hot_x; the X offset of the hotspot within the icon
=item $hot_y; the Y offset of the hotspot within the icon
=end pod

method set-icon-name (
  N-GObject() $context, Str $icon_name, Int() $hot_x, Int() $hot_y
) {
  gtk_drag_set_icon_name( $context, $icon_name, $hot_x, $hot_y);
}

sub gtk_drag_set_icon_name (
  N-GObject $context, gchar-ptr $icon_name, gint $hot_x, gint $hot_y
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-pixbuf:
=begin pod
=head2 set-icon-pixbuf

Sets I<pixbuf> as the icon for a given drag.

  method set-icon-pixbuf (
    N-GObject() $context, N-GObject() $pixbuf,
    Int() $hot_x, Int() $hot_y
  )

=item $context; the context for a drag (This must be called  with a  context for the source side of a drag)
=item $pixbuf; the B<Gnome::Gdk3::Pixbuf> to use as the drag icon
=item $hot_x; the X offset within I<widget> of the hotspot
=item $hot_y; the Y offset within I<widget> of the hotspot
=end pod

method set-icon-pixbuf (
  N-GObject() $context, N-GObject() $pixbuf, Int() $hot_x, Int() $hot_y
) {
  gtk_drag_set_icon_pixbuf( $context, $pixbuf, $hot_x, $hot_y);
}

sub gtk_drag_set_icon_pixbuf (
  N-GObject $context, N-GObject $pixbuf, gint $hot_x, gint $hot_y
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-icon-surface:
=begin pod
=head2 set-icon-surface

Sets I<surface> as the icon for a given drag. GTK+ retains references for the arguments, and will release them when they are no longer needed.

To position the surface relative to the mouse, use C<cairo_surface_set_device_offset()> on I<surface>. The mouse cursor will be positioned at the (0,0) coordinate of the surface.

  method set-icon-surface ( N-GObject() $context, cairo_surface_t $surface )

=item $context; the context for a drag (This must be called with a context for the source side of a drag)
=item $surface; the surface to use as icon
=end pod

method set-icon-surface ( N-GObject() $context, cairo_surface_t $surface ) {
  gtk_drag_set_icon_surface( $context, $surface);
}

sub gtk_drag_set_icon_surface (
  N-GObject $context, cairo_surface_t $surface
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-widget:
=begin pod
=head2 set-icon-widget

Changes the icon for drag operation to a given widget. GTK+ will not destroy the widget, so if you don’t want it to persist, you should connect to the “drag-end” signal and destroy it yourself.

  method set-icon-widget ( N-GObject() $context, N-GObject() $widget, Int() $hot_x, Int() $hot_y )

=item $context; the context for a drag. (This must be called
=item $widget; a widget to use as an icon
=item $hot_x; the X offset within I<widget> of the hotspot
=item $hot_y; the Y offset within I<widget> of the hotspot
=end pod

method set-icon-widget ( N-GObject() $context, N-GObject() $widget, Int() $hot_x, Int() $hot_y ) {
  gtk_drag_set_icon_widget( $context, $widget, $hot_x, $hot_y);
}

sub gtk_drag_set_icon_widget (
  N-GObject $context, N-GObject $widget, gint $hot_x, gint $hot_y
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:unhighlight:xt/examples/Dnd
=begin pod
=head2 unhighlight

Removes a highlight set by C<highlight()> from a widget.

  method unhighlight ( N-GObject() $widget )

=item $widget; a widget to remove the highlight from
=end pod

method unhighlight ( N-GObject() $widget ) {
  gtk_drag_unhighlight($widget);
}

sub gtk_drag_unhighlight (
  N-GObject $widget
) is native(&gtk-lib)
  { * }
