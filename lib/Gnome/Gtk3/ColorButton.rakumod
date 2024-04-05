#TL:1:Gnome::Gtk3::ColorButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorButton

A button to launch a color selection dialog

![](images/color-button.png)


=head1 Description

The B<Gnome::Gtk3::ColorButton> is a button which displays the currently selected color and allows to open a color selection dialog to change the color. It is a suitable widget for selecting a color in a preference dialog.


=head2 Css Nodes

B<Gnome::Gtk3::ColorButton> has a single CSS node with name button. To differentiate it from a plain B<Gnome::Gtk3::Button>, it gets the .color style class.


=head2 See Also

B<Gnome::Gtk3::ColorSelectionDialog>, B<Gnome::Gtk3::FontButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorButton;
  also is Gnome::Gtk3::Button;
  also does Gnome::Gtk3::ColorChooser;


=head2 Uml Diagram

![](plantuml/ColorButton.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ColorButton:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ColorButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ColorButton class process the options
    self.bless( :GtkColorButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );
  my Gnome::Gtk3::ColorButton $color-button .= new(:$color));


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gdk3::RGBA:api<1>;

use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::ColorChooser:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorButton:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Button;
also does Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new color button. This creates a widget in the form of a small button containing a swatch representing the current selected color. When the button is clicked, a color-selection dialog will open, allowing the user to select a color. The swatch will be updated to reflect the new color when the user finishes.

  multi method new ( )


=head3 :color

Create a color button with a new color

  multi method_new ( N-GdkRGBA :$color! )


=head3 :native-object

Create a ColorButton object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ColorButton object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:1:new(:color):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc.
  unless $signals-added {
    $signals-added = True;
    self.add-signal-types( $?CLASS.^name, :w0<color-set>);

    # signals from interfaces
    self._add_color_chooser_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ColorButton' or %options<GtkColorButton> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;

      # process all named arguments
      if ? %options<color> {
        $no = _gtk_color_button_new_with_rgba(%options<color>);
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
        $no = _gtk_color_button_new();
      }
      #}}

      self._set-native-object($no);
    }
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkColorButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_color_button_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_color_button_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('color-button-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-color-button-'),
          '0.47.4', '0.50.0'
        );
      }

      else {
        $s = self._color_chooser_interface($native-sub);
      }
    }
  }

  self._set-class-name-of-sub('GtkColorButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:get-title:
=begin pod
=head2 get-title

Gets the title of the color selection dialog.

Returns: An internal string, do not free the return value

  method get-title ( --> Str )

=end pod

method get-title ( --> Str ) {
  gtk_color_button_get_title(self._get-native-object-no-reffing)
}

sub gtk_color_button_get_title (
  N-GObject $button --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-title:
=begin pod
=head2 set-title

Sets the title for the color selection dialog.

  method set-title ( Str $title )

=item Str $title; String containing new window title
=end pod

method set-title ( Str $title ) {
  gtk_color_button_set_title( self._get-native-object-no-reffing, $title);
}

sub gtk_color_button_set_title (
  N-GObject $button, gchar-ptr $title
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_color_button_new:
#`{{
=begin pod
=head2 _gtk_color_button_new

Creates a new color button.

This returns a widget in the form of a small button containing a swatch representing the current selected color. When the button is clicked, a color-selection dialog will open, allowing the user to select a color. The swatch will be updated to reflect the new color when the user finishes.

Returns: a new color button

  method _gtk_color_button_new ( --> N-GObject )

=end pod
}}

sub _gtk_color_button_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_color_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_color_button_new_with_rgba:
#`{{
=begin pod
=head2 _gtk_color_button_new_with_rgba

Creates a new color button.

Returns: a new color button

  method _gtk_color_button_new_with_rgba ( N-GdkRGBA $rgba --> N-GObject )

=item N-GObject $rgba; A B<Gnome::Gtk3::RGBA> to set the current color with
=end pod
}}

sub _gtk_color_button_new_with_rgba ( N-GdkRGBA $rgba --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_color_button_new_with_rgba')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:color-set:
=head2 color-set

The I<color-set> signal is emitted when the user selects a color.
When handling this signal, use C<get_rgba()> to
find out which color was just selected.

Note that this signal is only emitted when the user
changes the color. If you need to react to programmatic color changes
as well, use the notify::color signal.

  method handler (
    Gnome::Gtk3::ColorButton :_widget($widget),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $widget; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:alpha:
=head2 alpha

The selected opacity value (0 fully transparent, 65535 fully opaque)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_UINT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is 65535.
=item Default value is 65535.


=comment -----------------------------------------------------------------------
=comment #TP:1:rgba:
=head2 rgba

The selected RGBA color

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is GDK_TYPE_RGBA
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-editor:
=head2 show-editor

Whether to show the color editor right away

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head2 title

The title of the color selection dialog

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is _(Pick a Color.


=comment -----------------------------------------------------------------------
=comment #TP:1:use-alpha:
=head2 use-alpha

Whether to give the color an alpha value

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.

=end pod
