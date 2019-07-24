use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Button

![](images/button.png)

=SUBTITLE A widget that emits a signal when clicked on

=head1 Description

The C<Gnome::Gtk3::Button> widget is generally used to trigger a callback function that is called when the button is pressed.  The various signals and how to use them are outlined below.

The C<Gnome::Gtk3::Button> widget can hold any valid child widget.  That is, it can hold almost any other standard C<Gnome::Gtk3::Widget>.  The most commonly used child is the C<Gnome::Gtk3::Label>.


=head2 Css Nodes

C<Gnome::Gtk3::Button> has a single CSS node with name button. The node will get the style classes .image-button or .text-button, if the content is just an image or label, respectively. It may also receive the .flat style class.

Other style classes that are commonly used with C<Gnome::Gtk3::Button> include .suggested-action and .destructive-action. In special cases, buttons can be made round by adding the .circular style class.

Button-like widgets like C<Gnome::Gtk3::ToggleButton>, C<Gnome::Gtk3::MenuButton>, C<Gnome::Gtk3::VolumeButton>, C<Gnome::Gtk3::LockButton>, C<Gnome::Gtk3::ColorButton>, C<Gnome::Gtk3::FontButton> or C<Gnome::Gtk3::FileChooserButton> use style classes such as .toggle, .popup, .scale, .lock, .color, .font, .file to differentiate themselves from a plain C<Gnome::Gtk3::Button>.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Button;
  also is Gnome::Gtk3::Bin;

=head2 Example

  my Gnome::Gtk3::Button $start-button .= new(:label<Start>);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Bin;

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

=head3 multi method new ( Bool :$empty! )

Create an empty button

=head3 multi method new ( Str :$label! )

Creates a new button object with a label

=head3 multi method new ( N-GObject :$widget! )

Create a button using a native object from elsewhere. See also Gnome::GObject::Object.

=head3 multi method new ( Str :$build-id! )

Create a button using a native object from a builder. See also Gnome::GObject::Object.
=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<clicked>,
    :notsupported<activate>,
    :deprecated<enter leave pressed released>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Button';

  if %options<label>.defined {
    self.native-gobject(gtk_button_new_with_label(%options<label>));
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_button_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_button_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkButton');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_button_new

Creates a new C<Gnome::Gtk3::Button> widget. To add a child widget to the button,
use C<gtk_container_add()>.

Returns: The newly created C<Gnome::Gtk3::Button> widget.

  method gtk_button_new ( --> N-GObject  )


=end pod

sub gtk_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] new_with_label

Creates a C<Gnome::Gtk3::Button> widget with a C<Gnome::Gtk3::Label> child containing the given
text.

Returns: The newly created C<Gnome::Gtk3::Button> widget.

  method gtk_button_new_with_label ( Str $label --> N-GObject  )

=item Str $label; The text you want the C<Gnome::Gtk3::Label> to hold.

=end pod

sub gtk_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] new_from_icon_name

Creates a new button containing an icon from the current icon theme.

If the icon name isn’t known, a “broken image” icon will be
displayed instead. If the current icon theme is changed, the icon
will be updated appropriately.

This function is a convenience wrapper around C<gtk_button_new()> and
C<gtk_button_set_image()>.

Returns: a new C<Gnome::Gtk3::Button> displaying the themed icon

Since: 3.10

  method gtk_button_new_from_icon_name ( Str $icon_name, GtkIconSize $size --> N-GObject  )

=item Str $icon_name; an icon name
=item GtkIconSize $size; (type int): an icon size (C<Gnome::Gtk3::IconSize>)

=end pod

sub gtk_button_new_from_icon_name ( Str $icon_name, int32 $size )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] new_with_mnemonic

Creates a new C<Gnome::Gtk3::Button> containing a label.
If characters in I<label> are preceded by an underscore, they are underlined.
If you need a literal underscore character in a label, use “__” (two
underscores). The first underlined character represents a keyboard
accelerator called a mnemonic.
Pressing Alt and that key activates the button.

Returns: a new C<Gnome::Gtk3::Button>

  method gtk_button_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_button_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_button_clicked

Emits a sig C<clicked> signal to the given C<Gnome::Gtk3::Button>.

  method gtk_button_clicked ( )


=end pod

sub gtk_button_clicked ( N-GObject $button )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] set_relief

Sets the relief style of the edges of the given C<Gnome::Gtk3::Button> widget.
Two styles exist, C<GTK_RELIEF_NORMAL> and C<GTK_RELIEF_NONE>.
The default style is, as one can guess, C<GTK_RELIEF_NORMAL>.
The deprecated value C<GTK_RELIEF_HALF> behaves the same as
C<GTK_RELIEF_NORMAL>.

  method gtk_button_set_relief ( GtkReliefStyle $relief )

=item GtkReliefStyle $relief; The C<Gnome::Gtk3::ReliefStyle> as described above

=end pod

sub gtk_button_set_relief ( N-GObject $button, int32 $relief )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_relief

Returns the current relief style of the given C<Gnome::Gtk3::Button>.

Returns: The current C<Gnome::Gtk3::ReliefStyle>

  method gtk_button_get_relief ( --> GtkReliefStyle  )


=end pod

sub gtk_button_get_relief ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] set_label

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
=begin pod
=head2 [gtk_button_] get_label

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
=begin pod
=head2 [gtk_button_] set_use_underline

If true, an underline in the text of the button label indicates
the next character should be used for the mnemonic accelerator key.

  method gtk_button_set_use_underline ( Int $use_underline )

=item Int $use_underline; C<1> if underlines in the text indicate mnemonics

=end pod

sub gtk_button_set_use_underline ( N-GObject $button, int32 $use_underline )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_use_underline

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
=begin pod
=head2 [gtk_button_] set_image

Set the image of I<button> to the given widget. The image will be
displayed if the label text is C<Any> or if
prop C<always-show-image> is C<1>. You don’t have to call
C<gtk_widget_show()> on I<image> yourself.

Since: 2.6

  method gtk_button_set_image ( N-GObject $image )

=item N-GObject $image; a widget to set as the image for the button

=end pod

sub gtk_button_set_image ( N-GObject $button, N-GObject $image )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_image

Gets the widget that is currenty set as the image of I<button>.
This may have been explicitly set by C<gtk_button_set_image()>
or constructed by C<gtk_button_new_from_stock()>.

Returns: (nullable) (transfer none): a C<Gnome::Gtk3::Widget> or C<Any> in case
there is no image

Since: 2.6

  method gtk_button_get_image ( --> N-GObject  )


=end pod

sub gtk_button_get_image ( N-GObject $button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] set_image_position

Sets the position of the image relative to the text
inside the button.

Since: 2.10

  method gtk_button_set_image_position ( GtkPositionType $position )

=item GtkPositionType $position; the position

=end pod

sub gtk_button_set_image_position ( N-GObject $button, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_image_position

Gets the position of the image relative to the text
inside the button.

Returns: the position

Since: 2.10

  method gtk_button_get_image_position ( --> GtkPositionType  )


=end pod

sub gtk_button_get_image_position ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] set_always_show_image

If C<1>, the button will ignore the prop C<gtk-button-images>
setting and always show the image, if available.

Use this property if the button  would be useless or hard to use
without the image.

Since: 3.6

  method gtk_button_set_always_show_image ( Int $always_show )

=item Int $always_show; C<1> if the menuitem should always show the image

=end pod

sub gtk_button_set_always_show_image ( N-GObject $button, int32 $always_show )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_always_show_image

Returns whether the button will ignore the prop C<gtk-button-images>
setting and always show the image, if available.

Returns: C<1> if the button will always show the image

Since: 3.6

  method gtk_button_get_always_show_image ( --> Int  )


=end pod

sub gtk_button_get_always_show_image ( N-GObject $button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_event_window

Returns the button’s event window if it is realized, C<Any> otherwise.
This function should be rarely needed.

Returns: (transfer none): I<button>’s event window.

Since: 2.22

  method gtk_button_get_event_window ( --> N-GObject  )


=end pod

sub gtk_button_get_event_window ( N-GObject $button )
  returns N-GObject
  is native(&gtk-lib)
  { * }
#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.10
=head3 method gtk_button_set_use_stock ( Int $use_stock )
=head3 method gtk_button_get_use_stock ( --> Int  )

=head2 Since 3.10.
=head3 method gtk_button_new_from_stock ( Str $stock_id --> N-GObject  )

=head2 Since 3.14
=head3 method gtk_button_set_alignment ( Num $xalign, Num $yalign )
=head3 method gtk_button_get_alignment ( Num $xalign, Num $yalign )

=head2 Since 3.20.
=head3 method gtk_button_set_focus_on_click ( Int $focus_on_click )
=head3 method gtk_button_get_focus_on_click ( --> Int  )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 clicked

Emitted when the button has been activated (pressed and released).

  method handler (
    Gnome::GObject::Button :widget($button),
    :$user-option1, ..., :$user-optionN
  );

=item $button; the object that received the signal

=end pod

=begin pod

=head2 Unsupported / Deprecated signals

=head3 pressed

Emitted when the button is pressed.

Deprecated: 2.8: Use the sig C<button-press-event> signal.


=head3 released

Emitted when the button is released.

Deprecated: 2.8: Use the sig C<button-release-event> signal.

=head3 enter

Emitted when the pointer enters the button.

Deprecated: 2.8: Use the sig C<enter-notify-event> signal.


=head3 leave

Emitted when the pointer leaves the button.

Deprecated: 2.8: Use the sig C<leave-notify-event> signal.


=head3 activate

The ::activate signal on C<Gnome::Gtk3::Button> is an action signal and
emitting it causes the button to animate press then release.
Applications should never connect to this signal, but use the
sig C<clicked> signal.

=head3 image-spacing

Spacing in pixels between the image and label.

Since: 2.10

Deprecated: 3.20: Use CSS margins and padding instead.

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 image-position

The C<Gnome::GObject::Value> type of property I<image-position> is C<G_TYPE_ENUM>.

The position of the image relative to the text inside the button.

Since: 2.10

=head3 always-show-image

The C<Gnome::GObject::Value> type of property I<always-show-image> is C<G_TYPE_BOOLEAN>.

If C<1>, the button will ignore the prop C<gtk-button-images>
setting and always show the image, if available.

Use this property if the button would be useless or hard to use
without the image.

Since: 3.6

=head2 Not yet supported properties

=head3 image

The C<Gnome::GObject::Value> type of property I<image> is C<G_TYPE_OBJECT>.

The child widget to appear next to the button text.

Since: 2.6

=end pod












=finish

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_button_new

Creates a new native GtkButton

  method gtk_button_new ( --> N-GObject )

Returns a native widget. Can be used to initialize another object using :widget. This is very cumbersome when you know that a oneliner does the job for you: `my Gnome::Gtk3::Buton $m .= new(:empty);

  my Gnome::Gtk3::Buton $m;
  $m .= :new(:widget($m.gtk_button_new());

=end pod

sub gtk_button_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] new_with_label

  method gtk_button_new_with_label ( Str $label --> N-GObject )

Creates a new native button object with a label
=end pod

sub gtk_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] get_label

  method gtk_button_get_label ( --> Str )

Get text label of button
=end pod

sub gtk_button_get_label ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_button_] set_label

  method gtk_button_set_label ( Str $label )

Set a label ob the button
=end pod

sub gtk_button_set_label ( N-GObject $widget, Str $label )
  is native(&gtk-lib)
  { * }

#TODO can add a few more subs

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Registering example

  class MyHandlers {
    method my-click-handler ( :$widget, :$my-data ) { ... }
  }

  # elsewhere
  my MyHandlers $mh .= new;
  $button.register-signal( $mh, 'click-handler', 'clicked', :$my-data);

See also method C<register-signal> in Gnome::GObject::Object.

=head2 Supported signals
=head3 clicked

Emitted when the button has been activated (pressed and released).

Handler signature;

=code handler ( instance: :$widget, :$user-option1, ..., :$user-optionN )

=head2 Unsupported signals
=head3 activated

Signal C<activated> is not supported because GTK advises against the use of it.

=head2 Deprecated signals
=head3 enter

Signal C<enter> has been deprecated since version 2.8 and should not be used in newly-written code. Use the “enter-notify-event” signal.

=head3 leave

Signal C<leave> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<leave-notify-event> signal.

=head3 pressed

Signal C<pressed> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<button-press-event> signal.

=head3 released

Signal C<released> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<button-release-event> signal.

=end pod
