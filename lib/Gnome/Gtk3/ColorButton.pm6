#TL:1:Gnome::Gtk3::ColorButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorButton

A button to launch a color selection dialog

![](images/color-button.png)

=head1 Description


The B<Gnome::Gtk3::ColorButton> is a button which displays the currently selected
color and allows to open a color selection dialog to change the color.
It is a suitable widget for selecting a color in a preference dialog.


=head2 Css Nodes


B<Gnome::Gtk3::ColorButton> has a single CSS node with name button. To differentiate
it from a plain B<Gnome::Gtk3::Button>, it gets the .color style class.

=head2 Implemented Interfaces

Gnome::Gtk3::ColorButton implements
=item [Gnome::Gtk3::ColorChooser](ColorChooser.html)

=head2 See Also

B<Gnome::Gtk3::ColorSelectionDialog>, B<Gnome::Gtk3::FontButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorButton;
  also is Gnome::Gtk3::Button;
  also does Gnome::Gtk3::ColorChooser;

=head2 Example

  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );
  my Gnome::Gtk3::ColorButton $color-button .= new(:$color));


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::Button;

use Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::Button;
also does Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a color button with current selected color

  multi method_new ( Bool :$empty! )

Create a color button with a new color

  multi method_new ( GdkRGBA :$color! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:1:new(:color):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc.
  if $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name, :w0<color-set>);

    # signals from interfaces
    self._add_color_chooser_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ColorButton';

  # process all named arguments
  if ? %options<color> {
    self.set-native-object(gtk_color_button_new_with_rgba(%options<color>));
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
    self.set-native-object(gtk_color_button_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkColorButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_color_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._color_chooser_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkColorButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_color_button_new:
=begin pod
=head2 [gtk_] color_button_new

Creates a new color button.

This returns a widget in the form of a small button containing
a swatch representing the current selected color. When the button
is clicked, a color-selection dialog will open, allowing the user
to select a color. The swatch will be updated to reflect the new
color when the user finishes.

Returns: a new color button

Since: 2.4

  method gtk_color_button_new ( --> N-GObject  )


=end pod

sub gtk_color_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_color_button_new_with_rgba:
=begin pod
=head2 [[gtk_] color_button_] new_with_rgba

Creates a new color button.

Returns: a new color button

Since: 3.0

  method gtk_color_button_new_with_rgba ( GdkRGBA $rgba --> N-GObject  )

=item N-GObject $rgba; A B<Gnome::Gdk3::RGBA> to set the current color with

=end pod

sub gtk_color_button_new_with_rgba ( GdkRGBA $rgba )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_color_button_set_title:
=begin pod
=head2 [[gtk_] color_button_] set_title

Sets the title for the color selection dialog.

Since: 2.4

  method gtk_color_button_set_title ( Str $title )

=item Str $title; String containing new window title

=end pod

sub gtk_color_button_set_title ( N-GObject $button, Str $title )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_color_button_get_title:
=begin pod
=head2 [[gtk_] color_button_] get_title

Gets the title of the color selection dialog.

Returns: An internal string, do not free the return value

Since: 2.4

  method gtk_color_button_get_title ( --> Str  )


=end pod

sub gtk_color_button_get_title ( N-GObject $button )
  returns Str
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


=comment #TS:0:color-set:
=head3 color-set

The I<color-set> signal is emitted when the user selects a color.
When handling this signal, use C<gtk_color_button_get_rgba()> to
find out which color was just selected.

Note that this signal is only emitted when the user
changes the color. If you need to react to programmatic color changes
as well, use the notify::color signal.

Since: 2.4

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.
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

=comment #TP:0:use-alpha:
=head3 Use alpha


If this property is set to C<1>, the color swatch on the button is
rendered against a checkerboard background to show its opacity and
the opacity slider is displayed in the color selection dialog.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<use-alpha> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:title:
=head3 Title


The title of the color selection dialog
Since: 2.4

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=begin comment
=comment #TP:0:rgba:
=head3 Current RGBA Color


The RGBA color.
Since: 3.0

The B<Gnome::GObject::Value> type of property I<rgba> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:show-editor:
=head3 Show Editor


Set this property to C<1> to skip the palette
in the dialog and go directly to the color editor.
This property should be used in cases where the palette
in the editor would be redundant, such as when the color
button is already part of a palette.
Since: 3.20

The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.
=end pod
