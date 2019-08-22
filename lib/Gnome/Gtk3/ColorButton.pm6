use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ColorButton

![](images/color-button.png)

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

=head3 multi method_new ( Bool :$empty! )

Create a color button with current selected color

=head3 multi method_new ( GdkRGBA :$color! )

Create a color button with a new color

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

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

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkColorButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_color_button_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  self.set-class-name-of-sub('GtkColorButton');
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

Returns: a new color button

Since: 2.4

  method gtk_color_button_new ( --> N-GObject  )


=end pod

sub gtk_color_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] new_with_rgba

Creates a new color button.

Returns: a new color button

Since: 3.0

  method gtk_color_button_new_with_rgba ( GdkRGBA $rgba --> N-GObject  )

=item GdkRGBA $rgba; A C<Gnome::Gdk3::RGBA> to set the current color with

=end pod

sub gtk_color_button_new_with_rgba ( GdkRGBA $rgba )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] set_title

Sets the title for the color selection dialog.

Since: 2.4

  method gtk_color_button_set_title ( Str $title )

=item Str $title; String containing new window title

=end pod

sub gtk_color_button_set_title ( N-GObject $button, Str $title )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_button_] get_title

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
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.4.
=head3 method gtk_color_button_new_with_color ( GdkColor $color --> N-GObject  )
=head3 method gtk_color_button_set_color ( GdkColor $color )
=head3 method gtk_color_button_get_color ( GdkColor $color )
=head3 method gtk_color_button_set_alpha ( UInt $alpha )
=head3 method gtk_color_button_get_alpha ( --> UInt  )
=head3 method gtk_color_button_set_use_alpha ( Int $use_alpha )
=head3 method gtk_color_button_get_use_alpha ( --> Int  )
=head3 method gtk_color_button_set_rgba ( N-GObject $rgba )
=head3 method gtk_color_button_get_rgba ( N-GObject $rgba )
=end pod

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

Since: 2.4

  method handler (
    Gnome::GObject::Object :$widget,
    :$user-option1, ..., $user-optionN
  );

=item $widget; the object which received the signal.

=end pod



#-------------------------------------------------------------------------------
#TODO Must add type info
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 use-alpha

The C<Gnome::GObject::Value> type of property I<use-alpha> is C<G_TYPE_BOOLEAN>.

If this property is set to C<1>, the color swatch on the button is
rendered against a checkerboard background to show its opacity and
the opacity slider is displayed in the color selection dialog.

Since: 2.4



=head3 title

The C<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

The title of the color selection dialog

Since: 2.4



=head3 alpha

The C<Gnome::GObject::Value> type of property I<alpha> is C<G_TYPE_UINT>.

The selected opacity value (0 fully transparent, 65535 fully opaque).

Since: 2.4


=head3 show-editor

The C<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.

Set this property to C<1> to skip the palette
in the dialog and go directly to the color editor.

This property should be used in cases where the palette
in the editor would be redundant, such as when the color
button is already part of a palette.

Since: 3.20

=head2 Not yet supported properties

=head3 rgba

The C<Gnome::GObject::Value> type of property I<rgba> is C<G_TYPE_BOXED>.

The RGBA color.

Since: 3.0

=end pod
