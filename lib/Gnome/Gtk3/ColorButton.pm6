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

  use Gnome::Gtk3::ColorButton;

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

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gdk3::RGBA;

use Gnome::Gtk3::Button;
use Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorButton:auth<github:MARTIMM>:ver<0.2.0>;
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

  multi method_new ( GdkRGBA :$color! )


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

      self.set-native-object($no);
    }
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
#TM:1:get-title:
=begin pod
=head2 get-title

Gets the title of the color selection dialog.

Returns: An internal string, do not free the return value

  method get-title ( --> Str )

=end pod

method get-title ( --> Str ) {
  gtk_color_button_get_title(self.get-native-object-no-reffing)
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
  gtk_color_button_set_title( self.get-native-object-no-reffing, $title);
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
=comment #TS:0:color-set:
=head3 color-set

The I<color-set> signal is emitted when the user selects a color.
When handling this signal, use C<get-rgba()> to
find out which color was just selected.

Note that this signal is only emitted when the user
changes the color. If you need to react to programmatic color changes
as well, use the notify::color signal.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

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
=comment #TP:0:rgba:
=head3 Current RGBA Color: rgba

The RGBA color.

The B<Gnome::GObject::Value> type of property I<rgba> is C<G_TYPE_BOXED>.

=comment -----------------------------------------------------------------------
=comment #TP:1:show-editor:
=head3 Show Editor: show-editor


Set this property to C<True> to skip the palette
in the dialog and go directly to the color editor.

This property should be used in cases where the palette
in the editor would be redundant, such as when the color
button is already part of a palette.


The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Title: title


The title of the color selection dialog


The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:use-alpha:
=head3 Use alpha: use-alpha


If this property is set to C<True>, the color swatch on the button is
rendered against a checkerboard background to show its opacity and
the opacity slider is displayed in the color selection dialog.


The B<Gnome::GObject::Value> type of property I<use-alpha> is C<G_TYPE_BOOLEAN>.
=end pod





























=finish
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
