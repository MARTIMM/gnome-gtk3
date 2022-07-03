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


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::Gdk3::Types;

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
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new DragSource object.

  multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like C<:native-object> is needed.

=end pod

#TM:1:new():
# submethod BUILD ( *%options ) {  }

#-------------------------------------------------------------------------------
#TM:0:add-image-targets:
=begin pod
=head2 add-image-targets

Add the writable image targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<Gnome::Gtk3::TargetList.add-image-targets()> and C<set-target-list()>.

  method add-image-targets ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-image-targets ( N-GObject() $widget ) {
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

Add the text targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<Gnome::Gtk3::TargetList.add-text-targets()> and C<set-target-list()>.

  method add-text-targets ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-text-targets ( N-GObject() $widget ) {
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

Add the URI targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag source. The targets are added with I<info> = 0. If you need another value, use C<Gnome::Gtk3::TargetList.add-uri-targets()> and C<set-target-list()>.

  method add-uri-targets ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget> that’s is a drag source
=end pod

method add-uri-targets ( N-GObject() $widget ) {
  gtk_drag_source_add_uri_targets($widget);
}

sub gtk_drag_source_add_uri_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

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
  $widget .= _get-native-object-no-reffing unless $widget ~~ N-GObject;

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
#TM:4:set:xt/examples/Dnd
=begin pod
=head2 set

Sets up a widget so that GTK+ will start a drag operation when the user clicks and drags on the widget. The widget must have a window.

  method set (
    N-GObject() $widget, Int() $start-button-mask,
    Array[N-GtkTargetEntry] $targets, Int() $actions
  )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $start-button-mask; the bitmask of buttons that can start the drag. Bits are from enum GdkModifierType
=item $targets; an array of B<Gnome::Gtk3::TargetEntry> targets that the drag will support, may be C<undefined>
=item $actions; the bitmask of possible actions for a drag from this widget. Bits are from enum GdkDragAction defined in B<Gnome::Gdk3::Dnd>.
=end pod

method set (
  N-GObject() $widget, UInt() $start-button-mask, Array $targets, UInt() $actions
) {
  $widget .= _get-native-object-no-reffing unless $widget ~~ N-GObject;
#note "$?LINE";
  my Array $n-target-array = [];
  for @$targets -> $target is copy {
    $target = $target ~~ N-GtkTargetEntry
                ?? $target
                !! $target._get-native-object-no-reffing;
#note "$?LINE, ", $target;
    $n-target-array.push: $target;
  }
#note "$?LINE, ", $n-target-array;
  my Gnome::Gtk3::TargetTable $target-table .= new(:array($n-target-array));
#note "$?LINE, ", $target-table.get-target-table;

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
#TM:0:set-icon-gicon:
=begin pod
=head2 set-icon-gicon

Sets the icon that will be used for drags from a particular source to I<icon>. See the docs for B<Gnome::Gtk3::IconTheme> for more details.

  method set-icon-gicon ( N-GObject() $widget, N-GObject() $icon )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $icon; A B<Gnome::Gio::Icon>
=end pod

method set-icon-gicon ( N-GObject() $widget, N-GObject() $icon ) {
  gtk_drag_source_set_icon_gicon( $widget, $icon);
}

sub gtk_drag_source_set_icon_gicon (
  N-GObject $widget, GIcon $icon
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:4:set-icon-name:xt/examples/Dnd
=begin pod
=head2 set-icon-name

Sets the icon that will be used for drags from a particular source to a themed icon. See the docs for B<Gnome::Gtk3::IconTheme> for more details.

  method set-icon-name ( N-GObject() $widget, Str $icon-name )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $icon-name; name of icon to use
=end pod

method set-icon-name ( N-GObject() $widget, Str $icon-name ) {
  gtk_drag_source_set_icon_name( $widget, $icon-name);
}

sub gtk_drag_source_set_icon_name (
  N-GObject $widget, gchar-ptr $icon-name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-pixbuf:
=begin pod
=head2 set-icon-pixbuf

Sets the icon that will be used for drags from a particular widget from a B<Gnome::Gtk3::Pixbuf>. GTK+ retains a reference for I<pixbuf> and will release it when it is no longer needed.

  method set-icon-pixbuf ( N-GObject() $widget, N-GObject() $pixbuf )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $pixbuf; the B<Gnome::Gtk3::Pixbuf> for the drag icon
=end pod

method set-icon-pixbuf ( N-GObject() $widget, N-GObject() $pixbuf) {
  gtk_drag_source_set_icon_pixbuf( $widget, $pixbuf);
}

sub gtk_drag_source_set_icon_pixbuf (
  N-GObject $widget, N-GObject $pixbuf
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-target-list:
=begin pod
=head2 set-target-list

Changes the target types that this widget offers for drag-and-drop. The widget must first be made into a drag source with C<set()>.

  method set-target-list ( N-GObject() $widget, N-GtkTargetList $target-list )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag source
=item $target-list; list of draggable targets, or C<undefined> for none
=end pod

method set-target-list ( N-GObject() $widget is copy, $target-list is copy ) {
  $target-list .= _get-native-object-no-reffing
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

  method unset ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget>
=end pod

method unset ( N-GObject() $widget ) {
  gtk_drag_source_unset($widget);
}

sub gtk_drag_source_unset (
  N-GObject $widget
) is native(&gtk-lib)
  { * }
