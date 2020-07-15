#TL:1:Gnome::Gtk3::CellRendererToggle:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererToggle

Renders a toggle button in a cell

=head1 Description

B<Gnome::Gtk3::CellRendererToggle> renders a toggle button in a cell. The button is drawn as a radio or a checkbutton, depending on the I<radio> property. When activated, it emits the  I<toggled> signal.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererToggle;
  also is Gnome::Gtk3::CellRenderer;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererToggle:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRenderer;

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

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<toggled>,
    );
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CellRendererToggle';

  # process all named arguments
  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    self.set-native-object(gtk_cell_renderer_toggle_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self.set-native-object(gtk_cell_renderer_toggle_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkCellRendererToggle');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_toggle_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkCellRendererToggle');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_toggle_new:new()
=begin pod
=head2 [gtk_] cell_renderer_toggle_new

Creates a new B<Gnome::Gtk3::CellRendererToggle>. Adjust rendering parameters using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “active” property on the cell renderer to a boolean value in the model, thus causing the check button to reflect the state of the model.

Returns: the new cell renderer

  method gtk_cell_renderer_toggle_new ( --> N-GObject  )


=end pod

sub gtk_cell_renderer_toggle_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_radio:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_radio

Returns C<1> whether we’re rendering radio toggles rather than checkboxes.

  method gtk_cell_renderer_toggle_get_radio ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_radio ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_radio:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_radio

If I<$radio> is C<True>, the cell renderer renders a radio toggle (i.e. a toggle in a group of mutually-exclusive toggles). If C<False>, it renders a check toggle (a standalone boolean option). This can be set globally for the cell renderer, or changed just before rendering each cell in the model (for B<Gnome::Gtk3::TreeView>, you set up a per-row setting using B<Gnome::Gtk3::TreeViewColumn> to associate model columns with cell renderer properties).

  method gtk_cell_renderer_toggle_set_radio ( Bool $radio )

=item Bool $radio; C<True> to make the toggle look like a radio button

=end pod

sub gtk_cell_renderer_toggle_set_radio ( N-GObject $toggle, int32 $radio )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_active:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_active

Returns C<1> if the cell renderer is active. See C<gtk_cell_renderer_toggle_set_active()>.

  method gtk_cell_renderer_toggle_get_active ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_active ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_active:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_active

Activates or deactivates a cell renderer.

  method gtk_cell_renderer_toggle_set_active ( Bool $setting )

=item Bool $setting; the value to set.

=end pod

sub gtk_cell_renderer_toggle_set_active ( N-GObject $toggle, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_activatable:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_activatable

Returns C<1> if the cell renderer is activatable. See C<gtk_cell_renderer_toggle_set_activatable()>.

Since: 2.18

  method gtk_cell_renderer_toggle_get_activatable ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_activatable ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_activatable:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_activatable

Makes the cell renderer activatable.

Since: 2.18

  method gtk_cell_renderer_toggle_set_activatable ( Bool $setting )

=item Bool $setting; the value to set.

=end pod

sub gtk_cell_renderer_toggle_set_activatable ( N-GObject $toggle, int32 $setting )
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


=comment #TS:0:toggled:
=head3 toggled

The I<toggled> signal is emitted when the cell is toggled.

It is the responsibility of the application to update the model
with the correct value to store at I<path>.  Often this is simply the
opposite of the value currently stored at I<path>.

  method handler (
    Str $path,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($cell_renderer),
    *%user-options
  );

=item $cell_renderer; the object which received the signal

=item $path; string representation of B<Gnome::Gtk3::TreePath> describing the
event location

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

=comment #TP:0:active:
=head3 Toggle state

The toggle state of the button
Default value: False


The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:inconsistent:
=head3 Inconsistent state

The inconsistent state of the button
Default value: False


The B<Gnome::GObject::Value> type of property I<inconsistent> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:activatable:
=head3 Activatable

The toggle button can be activated
Default value: True


The B<Gnome::GObject::Value> type of property I<activatable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:radio:
=head3 Radio state

Draw the toggle button as a radio button
Default value: False


The B<Gnome::GObject::Value> type of property I<radio> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:indicator-size:
=head3 Indicator size



The B<Gnome::GObject::Value> type of property I<indicator-size> is C<G_TYPE_INT>.
=end pod
