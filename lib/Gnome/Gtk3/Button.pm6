#TL:1:Gnome::Gtk3::Button:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Button

A widget that emits a signal when clicked on

![](images/button.png)

=head1 Description

The B<Gnome::Gtk3::Button> widget is generally used to trigger a callback function that is called when the button is pressed. The various signals and how to use them are outlined below.

The B<Gnome::Gtk3::Button> widget can hold any valid child widget. That is, it can hold almost any other standard B<Gnome::Gtk3::Widget>. The most commonly used child is the B<Gnome::Gtk3::Label> and is the default.

=head2 Css Nodes

B<Gnome::Gtk3::Button> has a single CSS node with name button. The node will get the style classes .image-button or .text-button, if the content is just an image or label, respectively. It may also receive the .flat style class.

Other style classes that are commonly used with B<Gnome::Gtk3::Button> include .suggested-action and .destructive-action. In special cases, buttons can be made round by adding the .circular style class.

Button-like widgets like B<Gnome::Gtk3::ToggleButton>, B<Gnome::Gtk3::MenuButton>, B<Gnome::Gtk3::VolumeButton>, B<Gnome::Gtk3::LockButton>, B<Gnome::Gtk3::ColorButton>, B<Gnome::Gtk3::FontButton> or B<Gnome::Gtk3::FileChooserButton> use style classes such as .toggle, .popup, .scale, .lock, .color, .font, .file to differentiate themselves from a plain B<Gnome::Gtk3::Button>.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Button;
  also is Gnome::Gtk3::Bin;

=head2 Uml Diagram
![](plantuml/Button.svg)

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Button;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Button;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Button class process the options
    self.bless( :GtkButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=head2 Example

  my Gnome::Gtk3::Button $start-button .= new(:label<Start>);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbutton.h
# https://developer.gnome.org/gtk3/stable/GtkButton.html
unit class Gnome::Gtk3::Button:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::Button> widget. To add a child widget to the button, use C<gtk_container_add()>.

  multi method new ( )

=head3 new(:label)

Creates a B<Gnome::Gtk3::Button> widget with a B<Gnome::Gtk3::Label> child containing the given text.

  multi method new ( Str :$label! )

=head3 new( :icon-name, :icon-size)

Creates a new button containing an icon from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be displayed instead. If the current icon theme is changed, the icon will be updated appropriately.

This function is a convenience wrapper around C<gtk_button_new()> and C<gtk_button_set_image()>.

You can use the I<gtk3-icon-browser> tool to browse through currently installed icons. The default for `$icon-size` is `GTK_ICON_SIZE_SMALL_TOOLBAR`.

  multi method new ( Str :$icon-name!, GtkIconSize :$icon-size?)

=head3 new(:mnemonic)

Creates a new B<Gnome::Gtk3::Button> containing a label. If characters in I<label> are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use “__” (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. Pressing Alt and that key activates the button.

  multi method new ( Str :$mnemonic! )

=end pod

#TM:2:new():inheriting:CheckButton
#TM:1:new(:label):
#TM:0:new(:icon-name,:size):
#TM:0:new(:mnemonic):
#TM:1:new():
#TM:1:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<clicked>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::Button' or %options<GtkButton> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      if %options<label>.defined {
        $no = _gtk_button_new_with_label(%options<label>);
      }

      elsif %options<icon-name>.defined {
        my GtkIconSize $icon-size =
          %options<icon-size> // GTK_ICON_SIZE_SMALL_TOOLBAR;
        $no = _gtk_button_new_from_icon_name( %options<icon-name>, $icon-size);
      }

      elsif %options<mnemonic>.defined {
        $no = _gtk_button_new_with_mnemonic(%options<mnemonic>);
      }

      elsif ? %options<empty> {
        Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
        $no = _gtk_button_new();
      }

      else {
        $no = _gtk_button_new();
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkButton');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkButton');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_button_new:new()
#`{{
=begin pod
=head2 [gtk_] button_new

Creates a new B<Gnome::Gtk3::Button> widget. To add a child widget to the button, use C<gtk_container_add()>.

Returns: The newly created B<Gnome::Gtk3::Button> widget.

  method gtk_button_new ( --> N-GObject  )

=end pod
}}

sub _gtk_button_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:3:_gtk_button_new_with_label:new(:label)
#`{{
=begin pod
=head2 [[gtk_] button_] new_with_label

Creates a B<Gnome::Gtk3::Button> widget with a B<Gnome::Gtk3::Label> child containing the given
text.

Returns: The newly created B<Gnome::Gtk3::Button> widget.

  method gtk_button_new_with_label ( Str $label --> N-GObject  )

=item Str $label; The text you want the B<Gnome::Gtk3::Label> to hold.

=end pod
}}

sub _gtk_button_new_with_label ( Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_button_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_button_new_from_icon_name:
#`{{
=begin pod
=head2 [[gtk_] button_] new_from_icon_name

Creates a new button containing an icon from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be
displayed instead. If the current icon theme is changed, the icon
will be updated appropriately.

This function is a convenience wrapper around C<gtk_button_new()> and
C<gtk_button_set_image()>.

Returns: a new B<Gnome::Gtk3::Button> displaying the themed icon


  method gtk_button_new_from_icon_name (
    Str $icon_name,
    GtkIconSize $size
    --> N-GObject
  )

=item Str $icon_name; an icon name
=item GtkIconSize $size; (type int): an icon size (B<Gnome::Gtk3::IconSize>)

=end pod
}}

sub _gtk_button_new_from_icon_name ( Str $icon_name, int32 $size --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_button_new_from_icon_name')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_button_new_with_mnemonic:
#`{{
=begin pod
=head2 [[gtk_] button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::Button> containing a label.
If characters in I<label> are preceded by an underscore, they are underlined.
If you need a literal underscore character in a label, use “__” (two
underscores). The first underlined character represents a keyboard
accelerator called a mnemonic.
Pressing Alt and that key activates the button.

Returns: a new B<Gnome::Gtk3::Button>

  method gtk_button_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_button_new_with_mnemonic ( Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_button_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_clicked:
=begin pod
=head2 [gtk_] button_clicked

Emits a prop I<clicked> signal to the given B<Gnome::Gtk3::Button>.

  method gtk_button_clicked ( )

=end pod

sub gtk_button_clicked ( N-GObject $button )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_set_relief:
=begin pod
=head2 [[gtk_] button_] set_relief

Sets the relief style of the edges of the given B<Gnome::Gtk3::Button> widget.
Two styles exist, C<GTK_RELIEF_NORMAL> and C<GTK_RELIEF_NONE>.
The default style is, as one can guess, C<GTK_RELIEF_NORMAL>.
The deprecated value C<GTK_RELIEF_HALF> behaves the same as
C<GTK_RELIEF_NORMAL>.

  method gtk_button_set_relief ( GtkReliefStyle $relief )

=item GtkReliefStyle $relief; The B<Gnome::Gtk3::ReliefStyle> as described above

=end pod

sub gtk_button_set_relief ( N-GObject $button, int32 $relief )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_relief:
=begin pod
=head2 [[gtk_] button_] get_relief

Returns the current relief style of the given B<Gnome::Gtk3::Button>.

Returns: The current B<Gnome::Gtk3::ReliefStyle>

  method gtk_button_get_relief ( --> GtkReliefStyle  )


=end pod

sub gtk_button_get_relief ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_button_set_label:
=begin pod
=head2 [[gtk_] button_] set_label

Sets the text of the label of the button to I<str>. This text is
also used to select the stock item if C<gtk_button_set_use_stock()>
is used.

This will also clear any previously set labels.

  method gtk_button_set_label ( Str $label )

=item Str $label; a string

=end pod

sub gtk_button_set_label ( N-GObject $button, Str $label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_button_get_label:
=begin pod
=head2 [[gtk_] button_] get_label

Fetches the text from the label of the button, as set by
C<gtk_button_set_label()>. If the label text has not
been set the return value will be C<Any>. This will be the
case if you create an empty button with C<gtk_button_new()> to
use as a container.

Returns: The text of the label widget. This string is owned
by the widget and must not be modified or freed.

  method gtk_button_get_label ( --> Str  )


=end pod

sub gtk_button_get_label ( N-GObject $button )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_set_use_underline:
=begin pod
=head2 [[gtk_] button_] set_use_underline

If true, an underline in the text of the button label indicates
the next character should be used for the mnemonic accelerator key.

  method gtk_button_set_use_underline ( Int $use_underline )

=item Int $use_underline; C<1> if underlines in the text indicate mnemonics

=end pod

sub gtk_button_set_use_underline ( N-GObject $button, int32 $use_underline )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_use_underline:
=begin pod
=head2 [[gtk_] button_] get_use_underline

Returns whether an embedded underline in the button label indicates a
mnemonic. See C<gtk_button_set_use_underline()>.

Returns: C<1> if an embedded underline in the button label
indicates the mnemonic accelerator keys.

  method gtk_button_get_use_underline ( --> Int  )


=end pod

sub gtk_button_get_use_underline ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_set_image:
=begin pod
=head2 [[gtk_] button_] set_image

Set the image of I<button> to the given widget. The image will be
displayed if the label text is C<Any> or if
sig B<always-show-image> is C<1>. You don’t have to call
C<gtk_widget_show()> on I<image> yourself.

  method gtk_button_set_image ( N-GObject $image )

=item N-GObject $image; a widget to set as the image for the button

=end pod

sub gtk_button_set_image ( N-GObject $button, N-GObject $image )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_image:
=begin pod
=head2 [[gtk_] button_] get_image

Gets the widget that is currenty set as the image of I<button>.
This may have been explicitly set by C<gtk_button_set_image()>
or constructed by C<gtk_button_new_from_stock()>.

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::Widget> or C<Any> in case
there is no image


  method gtk_button_get_image ( --> N-GObject  )


=end pod

sub gtk_button_get_image ( N-GObject $button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_set_image_position:
=begin pod
=head2 [[gtk_] button_] set_image_position

Sets the position of the image relative to the text
inside the button.


  method gtk_button_set_image_position ( GtkPositionType $position )

=item GtkPositionType $position; the position

=end pod

sub gtk_button_set_image_position ( N-GObject $button, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_image_position:
=begin pod
=head2 [[gtk_] button_] get_image_position

Gets the position of the image relative to the text
inside the button.

Returns: the position


  method gtk_button_get_image_position ( --> GtkPositionType  )


=end pod

sub gtk_button_get_image_position ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_set_always_show_image:
=begin pod
=head2 [[gtk_] button_] set_always_show_image

If C<1>, the button will ignore the sig B<gtk-button-images>
setting and always show the image, if available.

Use this property if the button  would be useless or hard to use
without the image.


  method gtk_button_set_always_show_image ( Int $always_show )

=item Int $always_show; C<1> if the menuitem should always show the image

=end pod

sub gtk_button_set_always_show_image ( N-GObject $button, int32 $always_show )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_always_show_image:
=begin pod
=head2 [[gtk_] button_] get_always_show_image

Returns whether the button will ignore the sig B<gtk-button-images>
setting and always show the image, if available.

Returns: C<1> if the button will always show the image


  method gtk_button_get_always_show_image ( --> Int  )


=end pod

sub gtk_button_get_always_show_image ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_button_get_event_window:
=begin pod
=head2 [[gtk_] button_] get_event_window

Returns the button’s event window if it is realized, C<Any> otherwise.
This function should be rarely needed.

Returns: (transfer none): I<button>’s event window.


  method gtk_button_get_event_window ( --> N-GObject  )


=end pod

sub gtk_button_get_event_window ( N-GObject $button )
  returns N-GObject
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

=comment #TS:1:clicked:
=head3 clicked

Emitted when the button has been activated (pressed and released).

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($button),
    *%user-options
  );

=item $button; the object that received the signal
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
=head3 Label

Text of the label widget inside the button, if the button contains a label widget
Default value: Any

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment #TP:0:use-underline:
=head3 Use underline

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key
Default value: False

The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:relief:
=head3 Border relief

The border relief style
Default value: False

The B<Gnome::GObject::Value> type of property I<relief> is C<G_TYPE_ENUM>.

=begin comment
=comment #TP:0:image:
=head3 Image widget

The child widget to appear next to the button text.
Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<image> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:image-position:
=head3 Image position


The position of the image relative to the text inside the button.
Widget type: GTK_TYPE_POSITION_TYPE

The B<Gnome::GObject::Value> type of property I<image-position> is C<G_TYPE_ENUM>.

=comment #TP:0:always-show-image:
=head3 Always show image


If C<1>, the button will ignore the  I<gtk-button-images>
setting and always show the image, if available.
Use this property if the button would be useless or hard to use
without the image.

The B<Gnome::GObject::Value> type of property I<always-show-image> is C<G_TYPE_BOOLEAN>.

=end pod
