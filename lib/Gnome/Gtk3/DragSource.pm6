#TL:1:Gnome::Gtk3::DragSource:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::DragSource

=comment ![](images/X.png)

=head1 Description

GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

This module defines the drag source manipulations


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::DragSource;


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::DragSource;

  unit class MyGuiClass;
  also is Gnome::Gtk3::DragSource;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::DragSource class process the options
    self.bless( :GtkDragSource, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::Gdk3::Types;
#use Gnome::Gdk3::Dnd;

use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::TargetTable;
use Gnome::Gtk3::TargetList;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::DragSource:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
#`{{
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new DragSource object.

  multi method new ( )

=head3 :native-object

Create a DragSource object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a DragSource object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::DragSource' #`{{ or %options<GtkDragSource> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_drag_source_new___x___($no);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_drag_source_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkDragSource');
  }
}
}}

#-------------------------------------------------------------------------------
#TM:0:add-image-targets:
=begin pod
=head2 add-image-targets

Add the writable image targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-image-targets()> and C<set-target-list()>.

  method add-image-targets ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-image-targets ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  gtk_drag_source_add_image_targets($widget);
}

sub gtk_drag_source_add_image_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-text-targets:
=begin pod
=head2 add-text-targets

Add the text targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-text-targets()> and C<set-target-list()>.

  method add-text-targets ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-text-targets ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  gtk_drag_source_add_text_targets($widget);
}

sub gtk_drag_source_add_text_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-uri-targets:
=begin pod
=head2 add-uri-targets

Add the URI targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-uri-targets()> and C<set-target-list()>.

  method add-uri-targets ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-uri-targets ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_source_add_uri_targets(
     $widget
  );
}

sub gtk_drag_source_add_uri_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }


#`{{
#-------------------------------------------------------------------------------
#TM:0:begin-with-coordinates:
=begin pod
=head2 begin-with-coordinates

Initiates a drag on the source side. The function only needs to be used when the application is starting drags itself, and is not needed when C<source-set()> is used.

The I<event> is used to retrieve the timestamp that will be used internally to grab the pointer. If I<event> is C<undefined>, then C<GDK-CURRENT-TIME> will be used. However, you should try to pass a real event in all cases, since that can be used to get information about the drag.

Generally there are three cases when you want to start a drag by hand by calling this function:

1. During a  I<button-press-event> handler, if you want to start a drag immediately when the user presses the mouse button. Pass the I<event> that you have in your  I<button-press-event> handler.

2. During a  I<motion-notify-event> handler, if you want to start a drag when the mouse moves past a certain threshold distance after a button-press. Pass the I<event> that you have in your  I<motion-notify-event> handler.

3. During a timeout handler, if you want to start a drag after the mouse button is held down for some time. Try to save the last event that you got from the mouse, using C<gdk-event-copy()>, and pass it to this function (remember to free the event with C<gdk-event-free()> when you are done). If you really cannot pass a real event, pass C<undefined> instead.

Returns: the context for this drag

  method begin-with-coordinates ( N-GObject $widget, N-GtkTargetList $targets, GdkDragAction $actions, Int() $button, GdkEvent $event, Int() $x, Int() $y --> GdkDragContext )

=item N-GObject $widget; the source widget
=item GtkTargetList $targets; The targets (data formats) in which the source can provide the data
=item GdkDragAction $actions; A bitmask of the allowed drag actions for this drag
=item Int() $button; The button the user clicked to start the drag
=item GdkEvent $event; The event that triggered the start of the drag, or C<undefined> if none can be obtained.
=item Int() $x; The initial x coordinate to start dragging from, in the coordinate space of I<widget>. If -1 is passed, the coordinates are retrieved from I<event> or the current pointer position
=item Int() $y; The initial y coordinate to start dragging from, in the coordinate space of I<widget>. If -1 is passed, the coordinates are retrieved from I<event> or the current pointer position
=end pod

method begin-with-coordinates ( $widget is copy, GtkTargetList $targets, GdkDragAction $actions, Int() $button, GdkEvent $event, Int() $x, Int() $y --> GdkDragContext ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_begin_with_coordinates(
     $widget, $targets, $actions, $button, $event, $x, $y
  )
}

sub gtk_drag_begin_with_coordinates (
  N-GObject $widget, GtkTargetList $targets, GdkDragAction $actions, gint $button, GdkEvent $event, gint $x, gint $y --> GdkDragContext
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:cancel:
=begin pod
=head2 cancel

Cancels an ongoing drag operation on the source side.

If you want to be able to cancel a drag operation in this way, you need to keep a pointer to the drag context, either from an explicit call to C<begin-with-coordinates()>, or by connecting to  I<drag-begin>.

If this I<context> does not refer to an ongoing drag operation, this function does nothing.

If a drag is cancelled in this way, the I<result> argument of  I<drag-failed> is set to I<GTK-DRAG-RESULT-ERROR>.

  method cancel ()

=end pod

method cancel ( ) {
  gtk_drag_cancel(self.get-native-object-no-reffing);
}

sub gtk_drag_cancel (
  GEnum $context
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:check-threshold:
=begin pod
=head2 check-threshold

Checks to see if a mouse drag starting at (I<start-x>, I<start-y>) and ending at (I<current-x>, I<current-y>) has passed the GTK+ drag threshold, and thus should trigger the beginning of a drag-and-drop operation.

Returns: C<True> if the drag threshold has been passed.

  method check-threshold ( N-GObject $widget, Int() $start_x, Int() $start_y, Int() $current_x, Int() $current_y --> Bool )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Int() $start_x; X coordinate of start of drag
=item Int() $start_y; Y coordinate of start of drag
=item Int() $current_x; current X coordinate
=item Int() $current_y; current Y coordinate
=end pod

method check-threshold ( $widget is copy, Int() $start_x, Int() $start_y, Int() $current_x, Int() $current_y --> Bool ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_check_threshold(
     $widget, $start_x, $start_y, $current_x, $current_y
  ).Bool
}

sub gtk_drag_check_threshold (
  N-GObject $widget, gint $start_x, gint $start_y, gint $current_x, gint $current_y --> gboolean
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-target-list:
=begin pod
=head2 get-target-list

Gets the list of targets this widget can provide for drag-and-drop.

Returns: the B<Gnome::Gtk3::TargetList>, or C<undefined> if none

  method get-target-list ( N-GObject $widget --> Gnome::Gtk3::TargetList )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=end pod

method get-target-list ( $widget is copy --> Gnome::Gtk3::TargetList ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_source_get_target_list(
     $widget
  )
}

sub gtk_drag_source_get_target_list (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:set:xt/dnd-01.raku
=begin pod
=head2 set

Sets up a widget so that GTK+ will start a drag operation when the user clicks and drags on the widget. The widget must have a window.

  method set (
    N-GObject $widget, Int() $start-button-mask,
    Array[N-GtkTargetEntry] $targets, Int() $actions
  )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Int() $start-button-mask; the bitmask of buttons that can start the drag. Bits are from enum GdkModifierType
=comment item $targets; an array of B<Gnome::Gtk3::TargetEntry> targets that the drag will support
=comment , may be C<undefined>
=item Int() $actions; the bitmask of possible actions for a drag from this widget. Bits are from enum GdkDragAction defined in B<Gnome::Gdk3::Dnd>.
=end pod

method set (
  $widget is copy, UInt() $start-button-mask, Array $targets, UInt() $actions
) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
note "$?LINE";
  my Array $n-target-array = [];
  for @$targets -> $target is copy {
    $target = $target ~~ N-GtkTargetEntry
                ?? $target
                !! $target.get-native-object-no-reffing;
note "$?LINE, ", $target;
    $n-target-array.push: $target;
  }
note "$?LINE, ", $n-target-array;
  my Gnome::Gtk3::TargetTable $target-table .= new(:array($n-target-array));
note "$?LINE, ", $target-table.get-target-table;

  gtk_drag_source_set(
    $widget, $start-button-mask, $target-table.get-target-table,
    $targets.elems, $actions
  );
}


sub gtk_drag_source_set (
  N-GObject $widget, GFlag $start_button_mask,
  CArray[uint8] $targets, gint $n_targets, GFlag $actions
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-icon-default:
=begin pod
=head2 set-icon-default

Sets the icon for a particular drag to the default icon.

  method set-icon-default ( GdkDragContext $context )

=item GdkDragContext $context; the context for a drag (This must be called  with a  context for the source side of a drag)
=end pod

method set-icon-default ( GdkDragContext $context ) {

  gtk_drag_set_icon_default(
     $context
  );
}

sub gtk_drag_set_icon_default (
  GdkDragContext $context
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-gicon:
=begin pod
=head2 set-icon-gicon

Sets the icon that will be used for drags from a particular source to I<icon>. See the docs for B<Gnome::Gtk3::IconTheme> for more details.

  method set-icon-gicon ( N-GObject $widget, GIcon $icon )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item GIcon $icon; A B<Gnome::Gtk3::Icon>
=end pod

method set-icon-gicon ( $widget is copy, GIcon $icon ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_source_set_icon_gicon(
     $widget, $icon
  );
}

sub gtk_drag_source_set_icon_gicon (
  N-GObject $widget, GIcon $icon
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:set-icon-name:xt/dnd-01.raku
=begin pod
=head2 set-icon-name

Sets the icon that will be used for drags from a particular source to a themed icon. See the docs for B<Gnome::Gtk3::IconTheme> for more details.

  method set-icon-name ( N-GObject $widget, Str $icon_name )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Str $icon_name; name of icon to use
=end pod

method set-icon-name ( $widget is copy, Str $icon_name ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_source_set_icon_name(
     $widget, $icon_name
  );
}

sub gtk_drag_source_set_icon_name (
  N-GObject $widget, gchar-ptr $icon_name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-pixbuf:
=begin pod
=head2 set-icon-pixbuf

Sets the icon that will be used for drags from a particular widget from a B<Gnome::Gtk3::Pixbuf>. GTK+ retains a reference for I<pixbuf> and will release it when it is no longer needed.

  method set-icon-pixbuf ( N-GObject $widget, N-GObject $pixbuf )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item N-GObject $pixbuf; the B<Gnome::Gtk3::Pixbuf> for the drag icon
=end pod

method set-icon-pixbuf ( $widget is copy, $pixbuf is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  $pixbuf .= get-native-object-no-reffing unless $pixbuf ~~ N-GObject;

  gtk_drag_source_set_icon_pixbuf(
     $widget, $pixbuf
  );
}

sub gtk_drag_source_set_icon_pixbuf (
  N-GObject $widget, N-GObject $pixbuf
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-icon-surface:
=begin pod
=head2 set-icon-surface

Sets I<surface> as the icon for a given drag. GTK+ retains references for the arguments, and will release them when they are no longer needed.

To position the surface relative to the mouse, use C<cairo-surface-set-device-offset()> on I<surface>. The mouse cursor will be positioned at the (0,0) coordinate of the surface.

  method set-icon-surface ( GdkDragContext $context, cairo_surface_t $surface )

=item GdkDragContext $context; the context for a drag (This must be called with a context for the source side of a drag)
=item cairo_surface_t $surface; the surface to use as icon
=end pod

method set-icon-surface ( GdkDragContext $context, cairo_surface_t $surface ) {

  gtk_drag_set_icon_surface(
     $context, $surface
  );
}

sub gtk_drag_set_icon_surface (
  GdkDragContext $context, cairo_surface_t $surface
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-widget:
=begin pod
=head2 set-icon-widget

Changes the icon for drag operation to a given widget. GTK+ will not destroy the widget, so if you don’t want it to persist, you should connect to the “drag-end” signal and destroy it yourself.

  method set-icon-widget ( GdkDragContext $context, N-GObject $widget, Int() $hot_x, Int() $hot_y )

=item GdkDragContext $context; the context for a drag. (This must be called
=item N-GObject $widget; a widget to use as an icon
=item Int() $hot_x; the X offset within I<widget> of the hotspot
=item Int() $hot_y; the Y offset within I<widget> of the hotspot
=end pod

method set-icon-widget ( GdkDragContext $context, $widget is copy, Int() $hot_x, Int() $hot_y ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_set_icon_widget(
     $context, $widget, $hot_x, $hot_y
  );
}

sub gtk_drag_set_icon_widget (
  GdkDragContext $context, N-GObject $widget, gint $hot_x, gint $hot_y
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:set-target-list:xt/dnd-01.raku
=begin pod
=head2 set-target-list

Changes the target types that this widget offers for drag-and-drop. The widget must first be made into a drag source with C<set()>.

  method set-target-list ( N-GObject $widget, N-GtkTargetList $target-list )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget> that’s a drag source
=item N-GtkTargetList $target-list; list of draggable targets, or C<undefined> for none
=end pod

method set-target-list ( $widget is copy, $target-list is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  $target-list .= get-native-object-no-reffing
    unless $target-list ~~ N-GtkTargetList;
  gtk_drag_source_set_target_list( $widget, $target-list);
}

sub gtk_drag_source_set_target_list (
  N-GObject $widget, N-GtkTargetList $target-list
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unset:
=begin pod
=head2 unset

Undoes the effects of C<set()>.

  method unset ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=end pod

method unset ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_drag_source_unset(
     $widget
  );
}

sub gtk_drag_source_unset (
  N-GObject $widget
) is native(&gtk-lib)
  { * }
