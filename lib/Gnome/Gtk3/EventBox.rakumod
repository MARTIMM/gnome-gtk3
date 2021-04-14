#TL:1:Gnome::Gtk3::EventBox:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::EventBox

A widget used to catch events for widgets which do not have their own window

=head1 Description

The GtkEventBox widget is a subclass of GtkBin which also has its own window. It is useful since it allows you to catch events for widgets which do not have their own window.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::EventBox;
  also is Gnome::Gtk3::Bin;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::EventBox:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new EventBox object.

  multi method new ( )

Create a EventBox object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a EventBox object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<create-menu-proxy toolbar-reconfigured>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::EventBox';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }

  # create default object
  else {
    self.set-native-object(gtk_event_box_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkEventBox');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_event_box_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkEventBox');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_event_box_new:new()
=begin pod
=head2 gtk_event_box_new

Creates a new B<Gnome::Gtk3::EventBox>

Returns: the new B<Gnome::Gtk3::EventBox>

Since: 2.4

  method gtk_event_box_new ( --> N-GObject )


=end pod

sub gtk_event_box_new ( --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_event_box_set_above_child:
=begin pod
=head2 [gtk_event_box_] set_homogeneous

Set whether the event box window is positioned above the windows of its child,
as opposed to below it. If the window is above, all events inside the event
box will go to the event box. If the window is below, events in windows of 
child widgets will first got to that widget, and then to its parents.

Since: 2.4

  method gtk_event_box_set_above_child ( Bool $above-child )

=item Bool $above_child; TRUE if the event box window is above its child

=end pod

sub gtk_event_box_set_above_child ( N-GObject $event_box, Bool $above_child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_event_box_get_above_child:
=begin pod
=head2 [gtk_event_box_] get_homogeneous

Returns whether the event box window is above or below the windows of its child.
See C<gtk_event_box_set_above_child()> for details.

Returns: C<True> if the box window is above the window of its child
items.

Since: 2.4

  method gtk_event_box_get_above_child ( --> Bool )


=end pod

sub gtk_event_box_get_above_child ( N-GObject $event_box --> Bool )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:gtk_event_box_set_visible_window:
=begin pod
=head2 [gtk_event_box_] set_homogeneous

Set whether the event box uses a visible or invisible child window. The 
default is to use visible windows.

In an invisible window event box, the window that the event box creates is a 
GDK_INPUT_ONLY window, which means that it is invisible and only serves to 
receive events.

A visible window event box creates a visible (GDK_INPUT_OUTPUT) window that 
acts as the parent window for all the widgets contained in the event box.

You should generally make your event box invisible if you just want to trap 
events. Creating a visible window may cause artifacts that are visible to the 
user, especially if the user is using a theme with gradients or pixmaps.

The main reason to create a non input-only event box is if you want to set the
background to a different color or draw on it.

There is one unexpected issue for an invisible event box that has its window 
below the child. (See C<gtk_event_box_set_above_child()>.) Since the input-only 
window is not an ancestor window of any windows that descendent widgets of the
event box create, events on these windows aren’t propagated up by the
windowing system, but only by GTK+. The practical effect of this is if an
event isn’t in the event mask for the descendant window 
(see C<gtk_widget_add_events()>), it won’t be received by the event box.

This problem doesn’t occur for visible event boxes, because in that case, 
the event box window is actually the ancestor of the descendant windows, 
not just at the same place on the screen.

Since: 2.4

  method gtk_event_box_set_visible_window ( Bool $visible_window )

=item Bool $visible_window; TRUE to make the event box have a visible window

=end pod

sub gtk_event_box_set_visible_window ( N-GObject $event_box, Bool $visible_window  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_event_box_get_visible_window:
=begin pod
=head2 [gtk_event_box_] get_homogeneous

Returns whether the event box has a visible window.
See C<gtk_event_box_set_visible_window()> for details.

Returns: C<True> if the event box window is visible.

Since: 2.4

  method gtk_event_box_get_visible_window ( --> Bool )


=end pod

sub gtk_event_box_get_visible_window ( N-GObject $event_box --> Bool )
  is native(&gtk-lib)
  { * }



#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:above-child:
=head3 Above child

Whether the event-trapping window of the eventbox is above the window of the child widget as opposed to below it.
Default value: False


The B<Gnome::GObject::Value> type of property I<above-child> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:visible-window:
=head3 Visible window

Whether the event box is visible, as opposed to invisible and only used to trap events.
Default value: True


The B<Gnome::GObject::Value> type of property I<visible-window> is C<G_TYPE_BOOLEAN>.
=end pod
