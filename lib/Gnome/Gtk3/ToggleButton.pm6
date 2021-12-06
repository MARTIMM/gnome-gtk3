#TL:1:Gnome::Gtk3::ToggleButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ToggleButton

Create buttons which retain their state

![](images/toggle-button.png)

=head1 Description

A B<Gnome::Gtk3::ToggleButton> is a B<Gnome::Gtk3::Button> which will remain “pressed-in” when clicked. Clicking again will cause the toggle button to return to its normal state.

A toggle button is created by calling either C<gtk_toggle_button_new()> or C<gtk_toggle_button_new_with_label()>. If using the former, it is advisable to pack a widget, (such as a B<Gnome::Gtk3::Label> and/or a B<Gnome::Gtk3::Image>), into the toggle button’s container. (See B<Gnome::Gtk3::Button> for more information).

The state of a B<Gnome::Gtk3::ToggleButton> can be set specifically using C<gtk_toggle_button_set_active()>, and retrieved using C<gtk_toggle_button_get_active()>.

To simply switch the state of a toggle button, use C<gtk_toggle_button_toggled()>.


=head2 Css Nodes

B<Gnome::Gtk3::ToggleButton> has a single CSS node with name button. To differentiate it from a plain B<Gnome::Gtk3::Button>, it gets the .toggle style class.


=head2 See Also

B<Gnome::Gtk3::Button>, B<Gnome::Gtk3::CheckButton>, B<Gnome::Gtk3::CheckMenuItem>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ToggleButton;
  also is Gnome::Gtk3::Button;


=head2 Uml Diagram

![](plantuml/ToggleButton.svg)


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
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktogglebutton.h
# https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
unit class Gnome::Gtk3::ToggleButton:auth<github:MARTIMM>:ver<0.2.0>;
also is Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new toggle button. A widget should be packed into the button, as in C<Gnome::Gtk3::Button.new()>.

  multi method new ( )


=head3 :label

Create a B<Gnome::Gtk3::ToggleButton> with a label.

  multi method new ( Str :$label! )


=head3 :native-object

Create a ToggleButton object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ToggleButton object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:label):
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<toggled>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ToggleButton' or ? %options<GtkToggleButton> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other arguments
    else {
      my $no;
      if %options<label>.defined {
        $no = _gtk_toggle_button_new_with_label(%options<label>);
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

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_toggle_button_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkToggleButton');
  }
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
#TM:1:get-active:
=begin pod
=head2 get-active

Queries a B<Gnome::Gtk3::ToggleButton> and returns its current state. Returns C<True> if the toggle button is pressed in and C<False> if it is raised.

Returns: a B<gboolean> value.

  method get-active ( --> Bool )

=end pod

method get-active ( --> Bool ) {
  gtk_toggle_button_get_active(self._f('GtkToggleButton')).Bool
}

sub gtk_toggle_button_get_active (
  N-GObject $toggle_button --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-inconsistent:
=begin pod
=head2 get-inconsistent

Gets the value set by C<set-inconsistent()>.

Returns: C<True> if the button is displayed as inconsistent, C<False> otherwise

  method get-inconsistent ( --> Bool )

=end pod

method get-inconsistent ( --> Bool ) {
  gtk_toggle_button_get_inconsistent(self._f('GtkToggleButton')).Bool
}

sub gtk_toggle_button_get_inconsistent (
  N-GObject $toggle_button --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-mode:
=begin pod
=head2 get-mode

Retrieves whether the button is displayed as a separate indicator and label. See C<set-mode()>.

Returns: C<True> if the togglebutton is drawn as a separate indicator and label.

  method get-mode ( --> Bool )

=end pod

method get-mode ( --> Bool ) {
  gtk_toggle_button_get_mode(self._f('GtkToggleButton')).Bool
}

sub gtk_toggle_button_get_mode (
  N-GObject $toggle_button --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-active:
=begin pod
=head2 set-active

Sets the status of the toggle button. Set to C<True> if you want the B<Gnome::Gtk3::ToggleButton> to be “pressed in”, and C<False> to raise it. This action causes the  I<toggled> signal and the  I<clicked> signal to be emitted.

  method set-active ( Bool $is-active )

=item Bool $is-active; C<True> for pressed in, C<False> otherwise
=end pod

method set-active ( Bool $is-active ) {
  gtk_toggle_button_set_active( self._f('GtkToggleButton'), $is-active);
}

sub gtk_toggle_button_set_active (
  N-GObject $toggle_button, gboolean $is-active
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-inconsistent:
=begin pod
=head2 set-inconsistent

If the user has selected a range of elements (such as some text or spreadsheet cells) that are affected by a toggle button, and the current values in that range are inconsistent, you may want to display the toggle in an “in between” state. This function turns on “in between” display. Normally you would turn off the inconsistent state again if the user toggles the toggle button. This has to be done manually, C<set-inconsistent()> only affects visual appearance, it doesn’t affect the semantics of the button.

  method set-inconsistent ( Bool $setting )

=item Bool $setting; C<True> if state is inconsistent
=end pod

method set-inconsistent ( Bool $setting ) {
  gtk_toggle_button_set_inconsistent( self._f('GtkToggleButton'), $setting);
}

sub gtk_toggle_button_set_inconsistent (
  N-GObject $toggle_button, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-mode:
=begin pod
=head2 set-mode

Sets whether the button is displayed as a separate indicator and label. You can call this function on a checkbutton or a radiobutton with I<$draw-indicator> = C<False> to make the button look like a normal button.

This can be used to create linked strip of buttons that work like a B<Gnome::Gtk3::StackSwitcher>.

This function only affects instances of classes like B<Gnome::Gtk3::CheckButton> and B<Gnome::Gtk3::RadioButton> that derive from B<Gnome::Gtk3::ToggleButton>, not instances of B<Gnome::Gtk3::ToggleButton> itself.

  method set-mode ( Bool $draw-indicator )

=item Bool $draw-indicator; if C<True>, draw the button as a separate indicator and label; if C<False>, draw the button like a normal button
=end pod

method set-mode ( Bool $draw-indicator ) {
  gtk_toggle_button_set_mode( self._f('GtkToggleButton'), $draw-indicator);
}

sub gtk_toggle_button_set_mode (
  N-GObject $toggle_button, gboolean $draw-indicator
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:toggled:
=begin pod
=head2 toggled

Emits the  I<toggled> signal on the B<Gnome::Gtk3::ToggleButton>. There is no good reason for an application ever to call this function.

  method toggled ( )

=end pod

method toggled ( ) {
  gtk_toggle_button_toggled(self._f('GtkToggleButton'));
}

sub gtk_toggle_button_toggled (
  N-GObject $toggle_button
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_toggle_button_new:
#`{{
=begin pod
=head2 _gtk_toggle_button_new

Creates a new toggle button. A widget should be packed into the button, as in C<gtk-button-new()>.

Returns: a new toggle button.

  method _gtk_toggle_button_new ( --> N-GObject )

=end pod
}}

sub _gtk_toggle_button_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_toggle_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_toggle_button_new_with_label:
#`{{
=begin pod
=head2 _gtk_toggle_button_new_with_label

Creates a new toggle button with a text label.

Returns: a new toggle button.

  method _gtk_toggle_button_new_with_label ( Str $label --> N-GObject )

=item Str $label; a string containing the message to be placed in the toggle button.
=end pod
}}

sub _gtk_toggle_button_new_with_label ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_toggle_button_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_toggle_button_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_toggle_button_new_with_mnemonic

Creates a new B<Gnome::Gtk3::ToggleButton> containing a label. The label will be created using C<gtk-label-new-with-mnemonic()>, so underscores in I<label> indicate the mnemonic for the button.

Returns: a new B<Gnome::Gtk3::ToggleButton>

  method _gtk_toggle_button_new_with_mnemonic ( Str $label --> N-GObject )

=item Str $label; the text of the button, with an underscore in front of the mnemonic character
=end pod
}}

sub _gtk_toggle_button_new_with_mnemonic ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_toggle_button_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:1:toggled:
=head3 toggled

Should be connected if you wish to perform an action whenever the
B<Gnome::Gtk3::ToggleButton>'s state is changed.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($togglebutton),
    *%user-options
  );

=item $togglebutton; the object which received the signal.

=item $_handle_id; the registered event handler id

=end pod


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
=comment #TP:1:active:
=head3 Active: active

If the toggle button should be pressed in
Default value: False

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:draw-indicator:
=head3 Draw Indicator: draw-indicator

If the toggle part of the button is displayed
Default value: False

The B<Gnome::GObject::Value> type of property I<draw-indicator> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:inconsistent:
=head3 Inconsistent: inconsistent

If the toggle button is in an \in between\ state
Default value: False

The B<Gnome::GObject::Value> type of property I<inconsistent> is C<G_TYPE_BOOLEAN>.
=end pod



























=finish
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
C<$draw-indicator> = C<0> to make the button look like a normal button.

This can be used to create linked strip of buttons that work like
a B<Gnome::Gtk3::StackSwitcher>.

This function only affects instances of classes like B<Gnome::Gtk3::CheckButton>
and B<Gnome::Gtk3::RadioButton> that derive from B<Gnome::Gtk3::ToggleButton>,
not instances of B<Gnome::Gtk3::ToggleButton> itself.

  method gtk_toggle_button_set_mode ( Int $draw-indicator )

=item Int $draw-indicator; if C<1>, draw the button as a separate indicator and label; if C<0>, draw the button like a normal button

=end pod

sub gtk_toggle_button_set_mode ( N-GObject $toggle_button, int32 $draw-indicator )
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

  method gtk_toggle_button_set_active ( Int $is-active )

=item Int $is-active; C<1> or C<0>.

=end pod

sub gtk_toggle_button_set_active ( N-GObject $toggle_button, int32 $is-active )
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
