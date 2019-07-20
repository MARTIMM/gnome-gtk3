use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ColorButton

=SUBTITLE A button to launch a color selection dialog

=head1 Description


The C<Gnome::Gtk3::ColorButton> is a button which displays the currently selected
color and allows to open a color selection dialog to change the color.
It is a suitable widget for selecting a color in a preference dialog.


=head2 Css Nodes


C<Gnome::Gtk3::ColorButton> has a single CSS node with name button. To differentiate
it from a plain C<Gnome::Gtk3::Button>, it gets the .color style class.



=head2 See Also

C<Gnome::Gtk3::ColorSelectionDialog>, C<Gnome::Gtk3::FontButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorButton;
  also is Gnome::Gtk3::Button;

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

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method_new ( Bool :$empty! )

Create a color button with current selected color

  multi method_new ( GdkRGBA :$color! )

Create a color button with a new color

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc.
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<color-set>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ColorButton';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_color_button_new());
  }

  elsif ? %options<color> {
    self.native-gobject(gtk_color_button_new_with_rgba(%options<color>));
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_color_button_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_color_button_new

Creates a new color button.

This returns a widget in the form of a small button containing
a swatch representing the current selected color. When the button
is clicked, a color-selection dialog will open, allowing the user
to select a color. The swatch will be updated to reflect the new
color when the user finishes.

  method gtk_color_button_new ( --> N-GObject )

Returns N-GObject; a new color button
=end pod

sub gtk_color_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] new_with_rgba

Creates a new color button.

  method gtk_color_button_new_with_rgba ( N-GObject $rgba --> N-GObject )

=item GdkRGBA $rgba; A C<GdkRGBA> from C<Gnome::Gdk3::RGBA> to set the current color with.

Returns N-GObject; a new color button
=end pod

sub gtk_color_button_new_with_rgba ( GdkRGBA $rgba )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] set_title


Sets the title for the color selection dialog.

  method gtk_color_button_set_title ( Str $title)

=item Str $title;  String containing new window title

=end pod

sub gtk_color_button_set_title (  N-GObject $button,  str $title )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] get_title

Gets the title of the color selection dialog.

  method gtk_color_button_get_title ( --> Str )

Returns str; An internal string, do not free the return value
=end pod

sub gtk_color_button_get_title (  N-GObject $button )
  returns str
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TODO Must add type info
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');


=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties

=head3 use-alpha

If this property is set to 1, the color swatch on the button is
rendered against a checkerboard background to show its opacity and
the opacity slider is displayed in the color selection dialog.

=head3 title

The title of the color selection dialog

=head3 alpha

The selected opacity value (0 fully transparent, 65535 fully opaque).

=head3 rgba

The RGBA color.

=head3 show-editor

Set this property to 1 to skip the palette
in the dialog and go directly to the color editor.

This property should be used in cases where the palette
in the editor would be redundant, such as when the color
button is already part of a palette.

=end pod

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod
}}
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., $user-optionN
  )

=begin comment

=head2 Unsupported signals

=head2 Not yet supported signals
=end comment

=head2 Supported signals
=head3 color-set

The C<color-set> signal is emitted when the user selects a color.
When handling this signal, use gtk_color_button_get_rgba() to
find out which color was just selected.

Note that this signal is only emitted when the user
changes the color. If you need to react to programmatic color changes
as well, use the notify::color signal.


  method handler (
    Gnome::GObject::Object :$widget,
    :$user-option1, ..., $user-optionN
  );

=item $widget; the object which received the signal.

=begin comment

=head4 Signal Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, :$user-option1, ..., $user-optionN
  )

=head4 Event Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, GdkEvent :$event,
    :$user-option1, ..., $user-optionN
  )

=head4 Native Object Handler Signature

  method handler (
    Gnome::GObject::Object :$widget, N-GObject :$nativewidget,
    :$user-option1, ..., :$user-optionN
  )

=end comment

=begin comment

=head4 Handler Method Arguments
=item $widget; This can be any perl6 widget with C<Gnome::GObject::Object> as the top parent class e.g. C<Gnome::Gtk3::Button>.
=item $event; A structure defined in C<Gnome::Gdk3::Events>.
=item $nativewidget; A native widget (a C<N-GObject>) which can be turned into a perl6 widget using C<.new(:widget())> on the appropriate class.
=item $user-option*; Any extra options given by the user when registering the signal.

=end comment

=end pod
