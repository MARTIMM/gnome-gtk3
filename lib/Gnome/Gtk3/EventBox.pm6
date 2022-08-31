#TL:1:Gnome::Gtk3::EventBox:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::EventBox

A widget used to catch events for widgets which do not have their own window

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::EventBox> widget is a subclass of B<Gnome::Gtk3::Bin> which also has its own window. It is useful since it allows you to catch events for widgets which do not have their own window.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::EventBox;
  also is Gnome::Gtk3::Bin;


=head2 Uml Diagram

![](plantuml/EventBox.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::EventBox;

  unit class MyGuiClass;
  also is Gnome::Gtk3::EventBox;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::EventBox class process the options
    self.bless( :GtkEventBox, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::EventBox:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Bin;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new EventBox object.

  multi method new ( )

=head3 :native-object

Create a EventBox object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a EventBox object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::EventBox' #`{{ or %options<GtkEventBox> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
#        $no = %options<___x___>;
#        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
#        #$no = _gtk_event_box_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_event_box_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkEventBox');
  }
}

#-------------------------------------------------------------------------------
#TM:1:get-above-child:
=begin pod
=head2 get-above-child

Returns whether the event box window is above or below the windows of its child. See C<set-above-child()> for details.

Returns: C<True> if the event box window is above the window of its child

  method get-above-child ( --> Bool )

=end pod

method get-above-child ( --> Bool ) {

  gtk_event_box_get_above_child(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_event_box_get_above_child (
  N-GObject $event_box --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-visible-window:
=begin pod
=head2 get-visible-window

Returns whether the event box has a visible window. See C<set-visible-window()> for details.

Returns: C<True> if the event box window is visible

  method get-visible-window ( --> Bool )

=end pod

method get-visible-window ( --> Bool ) {
  gtk_event_box_get_visible_window(self._get-native-object-no-reffing).Bool
}

sub gtk_event_box_get_visible_window (
  N-GObject $event_box --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-above-child:
=begin pod
=head2 set-above-child

Set whether the event box window is positioned above the windows of its child, as opposed to below it. If the window is above, all events inside the event box will go to the event box. If the window is below, events in windows of child widgets will first got to that widget, and then to its parents.

The default is to keep the window below the child.

  method set-above-child ( Bool $above_child )

=item Bool $above_child; C<True> if the event box window is above its child
=end pod

method set-above-child ( Bool $above_child ) {
  gtk_event_box_set_above_child(
    self._get-native-object-no-reffing, $above_child
  );
}

sub gtk_event_box_set_above_child (
  N-GObject $event_box, gboolean $above_child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-visible-window:
=begin pod
=head2 set-visible-window

Set whether the event box uses a visible or invisible child window. The default is to use visible windows.

In an invisible window event box, the window that the event box creates is a C<GDK-INPUT-ONLY> window, which means that it is invisible and only serves to receive events.

A visible window event box creates a visible (C<GDK-INPUT-OUTPUT>) window that acts as the parent window for all the widgets contained in the event box.

You should generally make your event box invisible if you just want to trap events. Creating a visible window may cause artifacts that are visible to the user, especially if the user is using a theme with gradients or pixmaps.

The main reason to create a non input-only event box is if you want to set the background to a different color or draw on it.

There is one unexpected issue for an invisible event box that has its window below the child. (See C<set-above-child()>.) Since the input-only window is not an ancestor window of any windows that descendent widgets of the event box create, events on these windows aren’t propagated up by the windowing system, but only by GTK+. The practical effect of this is if an event isn’t in the event mask for the descendant window (see C<gtk-widget-add-events()>), it won’t be received by the event box.

This problem doesn’t occur for visible event boxes, because in that case, the event box window is actually the ancestor of the descendant windows, not just at the same place on the screen.

  method set-visible-window ( Bool $visible_window )

=item Bool $visible_window; C<True> to make the event box have a visible window
=end pod

method set-visible-window ( Bool $visible_window ) {

  gtk_event_box_set_visible_window(
    self._get-native-object-no-reffing, $visible_window
  );
}

sub gtk_event_box_set_visible_window (
  N-GObject $event_box, gboolean $visible_window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_event_box_new:
#`{{
=begin pod
=head2 _gtk_event_box_new

Creates a new B<Gnome::Gtk3::EventBox>.

Returns: a new B<Gnome::Gtk3::EventBox>

  method _gtk_event_box_new ( --> N-GObject )

=end pod
}}

sub _gtk_event_box_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_event_box_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:above-child:
=head2 above-child

Whether the event-trapping window of the eventbox is above the window of the child widget as opposed to below it.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:visible-window:
=head2 visible-window

Whether the event box is visible, as opposed to invisible and only used to trap events.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.

=end pod




=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:above-child:
=head3 Above child: above-child

Whether the event-trapping window of the eventbox is above the window of the child widget as opposed to below it.
Default value: False

The B<Gnome::GObject::Value> type of property I<above-child> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:visible-window:
=head3 Visible Window: visible-window

Whether the event box is visible, as opposed to invisible and only used to trap events.
Default value: True

The B<Gnome::GObject::Value> type of property I<visible-window> is C<G_TYPE_BOOLEAN>.
=end pod
