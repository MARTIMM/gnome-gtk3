#TL:1:Gnome::Gtk3::Switch:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Switch

A “light switch” style toggle

![](images/switch.png)

=head1 Description

B<Gnome::Gtk3::Switch> is a widget that has two states: on or off. The user can control which state should be active by clicking the empty area, or by dragging the handle.

B<Gnome::Gtk3::Switch> can also handle situations where the underlying state changes with a delay. See  I<state-set> for details.

=head2 Css Nodes

  switch
  ╰── slider

B<Gnome::Gtk3::Switch> has two css nodes, the main node with the name switch and a subnode named slider. Neither of them is using any style classes.

=head2 Implemented Interfaces

Gnome::Gtk3::Switch implements
=comment item Gnome::Gtk3::Actionable

=item

=head2 See Also

B<Gnome::Gtk3::ToggleButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Switch;
  also is Gnome::Gtk3::Widget;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Switch:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkSwitch

The B<Gnome::Gtk3::Switch>-struct contains private data and it should only be accessed using the provided API.

=end pod

#TT:0:N-GtkSwitch:
class N-GtkSwitch is export is repr('CStruct') {
  has N-GObject $.parent_instance;
  has GtkSwitchPrivate $.priv;
}
}}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new default object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<activate>, :w1<state-set>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Switch';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported, undefined or wrongly typed options for ' ~
               self.^name ~ ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # create default object
  else {
    self.set-native-object(gtk_switch_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkSwitch');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_switch_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkSwitch');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_switch_new:new()
=begin pod
=head2 gtk_switch_new

Creates a new B<Gnome::Gtk3::Switch> widget.

Returns: the newly created B<Gnome::Gtk3::Switch> instance

Since: 3.0

  method gtk_switch_new ( --> N-GObject )

=end pod

sub gtk_switch_new (  --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_switch_set_active:
=begin pod
=head2 [gtk_switch_] set_active

Changes the state of the switch to the desired one.

Since: 3.0

  method gtk_switch_set_active ( Int $is_active )

=item Int $is_active; C<True> if I<sw> should be active, and C<False> otherwise

=end pod

sub gtk_switch_set_active ( N-GObject $sw, int32 $is_active  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_switch_get_active:
=begin pod
=head2 [gtk_switch_] get_active

Gets whether the B<Gnome::Gtk3::Switch> is in its “on” or “off” state.

Returns: C<1> if the B<Gnome::Gtk3::Switch> is active, and C<0> otherwise

Since: 3.0

  method gtk_switch_get_active ( --> Int )


=end pod

sub gtk_switch_get_active ( N-GObject $sw --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_switch_set_state:
=begin pod
=head2 [gtk_switch_] set_state

Sets the underlying state of the B<Gnome::Gtk3::Switch>.

Normally, this is the same as  I<active>, unless the switch
is set up for delayed state changes. This function is typically
called from a  I<state-set> signal handler.

See  I<state-set> for details.

Since: 3.14

  method gtk_switch_set_state ( Int $state )

=item Int $state; the new state

=end pod

sub gtk_switch_set_state ( N-GObject $sw, int32 $state  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_switch_get_state:
=begin pod
=head2 [gtk_switch_] get_state

Gets the underlying state of the B<Gnome::Gtk3::Switch>.

Returns: the underlying state

Since: 3.14

  method gtk_switch_get_state ( --> Int )


=end pod

sub gtk_switch_get_state ( N-GObject $sw --> int32 )
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


=comment #TS:0:activate:
=head3 activate

The I<activate> signal on B<Gnome::Gtk3::Switch> is an action signal and
emitting it causes the switch to animate.
Applications should never connect to this signal, but use the
notify::active signal.

  method handler (
    Gnome::GObject::Object :widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment #TS:0:state-set:
=head3 state-set

The I<state-set> signal on B<Gnome::Gtk3::Switch> is emitted to change the underlying
state. It is emitted when the user changes the switch position. The
default handler keeps the state in sync with the  I<active>
property.

To implement delayed state change, applications can connect to this signal,
initiate the change of the underlying state, and call C<gtk_switch_set_state()>
when the underlying state change is complete. The signal handler should
return C<1> to prevent the default handler from running.

Visually, the underlying state is represented by the trough color of
the switch, while the  I<active> property is represented by the
position of the switch.

Returns: C<1> to stop the signal emission

Since: 3.14

  method handler (
    Int $state,
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object on which the signal was emitted

=item $state; the new state of the switch


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

=comment #TP:1:active:
=head3 Active

Whether the B<Gnome::Gtk3::Switch> widget is in its on or off state.

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment #TP:1:state:
=head3 State

The backend state that is controlled by the switch.
See  I<state-set> for details.
Since: 3.14

The B<Gnome::GObject::Value> type of property I<state> is C<G_TYPE_BOOLEAN>.
=end pod
