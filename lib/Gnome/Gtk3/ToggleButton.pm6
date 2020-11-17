#TL:1:Gnome::Gtk3::ToggleButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ToggleButton

Create buttons which retain their state

![](images/toggle-button.png)

=head1 Description


A B<Gnome::Gtk3::ToggleButton> is a B<Gnome::Gtk3::Button> which will remain “pressed-in” when
clicked. Clicking again will cause the toggle button to return to its
normal state.

A toggle button is created by calling either C<gtk_toggle_button_new()> or
C<gtk_toggle_button_new_with_label()>. If using the former, it is advisable to
pack a widget, (such as a B<Gnome::Gtk3::Label> and/or a B<Gnome::Gtk3::Image>), into the toggle
button’s container. (See B<Gnome::Gtk3::Button> for more information).

The state of a B<Gnome::Gtk3::ToggleButton> can be set specifically using
C<gtk_toggle_button_set_active()>, and retrieved using
C<gtk_toggle_button_get_active()>.

To simply switch the state of a toggle button, use C<gtk_toggle_button_toggled()>.


=head2 Css Nodes


B<Gnome::Gtk3::ToggleButton> has a single CSS node with name button. To differentiate it from a plain B<Gnome::Gtk3::Button>, it gets the .toggle style class.

=head2 See Also

B<Gnome::Gtk3::Button>, B<Gnome::Gtk3::CheckButton>, B<Gnome::Gtk3::CheckMenuItem>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ToggleButton;
  also is Gnome::Gtk3::Button;

=begin comment
=head2 Example

  my Gnome::Gtk3::ToggleButton $start-tggl .= new(:label('Start Process'));

  # a toggled signal handler
  method start-stop-process-handle( :native-object($start-tggl) --> Int ) {
    if $start-tggl.get-active {
      $start-tggl.set-label('Stop Process');
      # start process ...
    }

    else {
      $start-tggl.set-label('Start Process');
      # stop process ...
    }

    1
  }
=end comment

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktogglebutton.h
# https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
unit class Gnome::Gtk3::ToggleButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create a GtkToggleButton with a label.

  multi method new ( Str :$label )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:label):
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<toggled>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ToggleButton';

  # process all named arguments
  if %options<label>.defined {
    self.set-native-object(gtk_toggle_button_new_with_label(%options<label>));
  }

  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#elsif ? %options<empty> {
    self.set-native-object(gtk_toggle_button_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkToggleButton');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_toggle_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkToggleButton');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_toggle_button_new:new()
=begin pod
=head2 [gtk_] toggle_button_new

Creates a new toggle button. A widget should be packed into the button, as in C<gtk_button_new()>.

Returns: a new toggle button.

  method gtk_toggle_button_new ( --> N-GObject  )


=end pod

sub gtk_toggle_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_toggle_button_new_with_label:new(:label)
=begin pod
=head2 [[gtk_] toggle_button_] new_with_label

Creates a new toggle button with a text label.

Returns: a new toggle button.

  method gtk_toggle_button_new_with_label ( Str $label --> N-GObject  )

=item Str $label; a string containing the message to be placed in the toggle button.

=end pod

sub gtk_toggle_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_toggle_button_new_with_mnemonic:
=begin pod
=head2 [[gtk_] toggle_button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::ToggleButton> containing a label. The label
will be created using C<gtk_label_new_with_mnemonic()>, so underscores
in I<label> indicate the mnemonic for the button.

Returns: a new B<Gnome::Gtk3::ToggleButton>

  method gtk_toggle_button_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; the text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_toggle_button_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_toggle_button_set_mode:
=begin pod
=head2 [[gtk_] toggle_button_] set_mode

Sets whether the button is displayed as a separate indicator and label.
You can call this function on a checkbutton or a radiobutton with
C<$draw_indicator> = C<0> to make the button look like a normal button.

This can be used to create linked strip of buttons that work like
a B<Gnome::Gtk3::StackSwitcher>.

This function only affects instances of classes like B<Gnome::Gtk3::CheckButton>
and B<Gnome::Gtk3::RadioButton> that derive from B<Gnome::Gtk3::ToggleButton>,
not instances of B<Gnome::Gtk3::ToggleButton> itself.

  method gtk_toggle_button_set_mode ( Int $draw_indicator )

=item Int $draw_indicator; if C<1>, draw the button as a separate indicator and label; if C<0>, draw the button like a normal button

=end pod

sub gtk_toggle_button_set_mode ( N-GObject $toggle_button, int32 $draw_indicator )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_toggle_button_get_mode:
=begin pod
=head2 [[gtk_] toggle_button_] get_mode

Retrieves whether the button is displayed as a separate indicator
and label. See C<gtk_toggle_button_set_mode()>.

Returns: C<1> if the togglebutton is drawn as a separate indicator
and label.

  method gtk_toggle_button_get_mode ( --> Int  )


=end pod

sub gtk_toggle_button_get_mode ( N-GObject $toggle_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:3:gtk_toggle_button_set_active:CheckButton.t
=begin pod
=head2 [[gtk_] toggle_button_] set_active

Sets the status of the toggle button. Set to C<1> if you want the
B<Gnome::Gtk3::ToggleButton> to be “pressed in”, and C<0> to raise it.
This action causes the  I<toggled> signal and the
 I<clicked> signal to be emitted.

  method gtk_toggle_button_set_active ( Int $is_active )

=item Int $is_active; C<1> or C<0>.

=end pod

sub gtk_toggle_button_set_active ( N-GObject $toggle_button, int32 $is_active )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:3:gtk_toggle_button_get_active:CheckButton.t
=begin pod
=head2 [[gtk_] toggle_button_] get_active

Queries a B<Gnome::Gtk3::ToggleButton> and returns its current state. Returns C<1> if the toggle button is pressed in and C<0> if it is raised.

Returns: a B<Int> value.

  method gtk_toggle_button_get_active ( --> Int  )


=end pod

sub gtk_toggle_button_get_active ( N-GObject $toggle_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_toggle_button_toggled:
=begin pod
=head2 [gtk_] toggle_button_toggled

Emits the I<toggled> signal on the B<Gnome::Gtk3::ToggleButton>. There is no good reason for an application ever to call this function.

  method gtk_toggle_button_toggled ( )

=end pod

sub gtk_toggle_button_toggled ( N-GObject $toggle_button )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_toggle_button_set_inconsistent:
=begin pod
=head2 [[gtk_] toggle_button_] set_inconsistent

If the user has selected a range of elements (such as some text or
spreadsheet cells) that are affected by a toggle button, and the
current values in that range are inconsistent, you may want to
display the toggle in an “in between” state. This function turns on
“in between” display.  Normally you would turn off the inconsistent
state again if the user toggles the toggle button. This has to be
done manually, C<gtk_toggle_button_set_inconsistent()> only affects
visual appearance, it doesn’t affect the semantics of the button.


  method gtk_toggle_button_set_inconsistent ( Int $setting )

=item Int $setting; C<1> if state is inconsistent

=end pod

sub gtk_toggle_button_set_inconsistent ( N-GObject $toggle_button, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_toggle_button_get_inconsistent:
=begin pod
=head2 [[gtk_] toggle_button_] get_inconsistent

Gets the value set by C<gtk_toggle_button_set_inconsistent()>.

Returns: C<1> if the button is displayed as inconsistent, C<0> otherwise

  method gtk_toggle_button_get_inconsistent ( --> Int  )


=end pod

sub gtk_toggle_button_get_inconsistent ( N-GObject $toggle_button )
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


=comment #TS:1:toggled:
=head3 toggled

Should be connected if you wish to perform an action whenever the
B<Gnome::Gtk3::ToggleButton>'s state is changed.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($togglebutton),
    *%user-options
  );

=item $togglebutton; the object which received the signal.


=end pod
