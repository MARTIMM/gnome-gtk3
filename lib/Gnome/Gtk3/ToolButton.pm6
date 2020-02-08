#TL:1:Gnome::Gtk3::ToolButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ToolButton

A B<Gnome::Gtk3::ToolItem> subclass that displays buttons

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::ToolButtons> are B<Gnome::Gtk3::ToolItems> containing buttons.

Use C<gtk_tool_button_new()> to create a new B<Gnome::Gtk3::ToolButton>.

The label of a B<Gnome::Gtk3::ToolButton> is determined by the properties  I<label-widget>, I<label>, and I<stock-id>. If I<label-widget> is defined, then that widget is used as the label. Otherwise, if I<label> is defined, that string is used as the label. Otherwise, if I<stock-id> is defined, the label is determined by the stock item. Otherwise, the button does not have a label.

The icon of a B<Gnome::Gtk3::ToolButton> is determined by the properties I<icon-widget> and I<stock-id>. If I<icon-widget> is non-C<Any>, then that widget is used as the icon. Otherwise, if  I<stock-id> is non-C<Any>, the icon is determined by the stock item. Otherwise, the button does not have a icon.

=head2 Css Nodes

B<Gnome::Gtk3::ToolButton> has a single CSS node with name toolbutton.

=head2 Implemented Interfaces

Gnome::Gtk3::ToolButton implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=comment item [Gnome::Gtk3::Activatable](Activatable.html)
=comment item [Gnome::Gtk3::Actionable](Actionable.html)

=head2 See Also

B<Gnome::Gtk3::Toolbar>, B<Gnome::Gtk3::MenuToolButton>, B<Gnome::Gtk3::ToggleToolButton>, B<Gnome::Gtk3::RadioToolButton>, B<Gnome::Gtk3::SeparatorToolItem>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ToolButton;
  also is Gnome::Gtk3::ToolItem;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::ToolItem;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ToolButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToolItem;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new ToolButton object. No icon or label is displayed.

  multi method new ( )

Create a new ToolButton object with a label

  multi method new ( Str :$label! )

Create a new ToolButton object with an icon

  multi method new ( N-GObject :$icon! )

Create a ToolButton object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a ToolButton object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:icon):
#TM:1:new(:label):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<clicked>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ToolButton';

  # process all named arguments
  if ? %options<label> {
    self.set-native-object(gtk_tool_button_new( N-GObject, %options<label>));
  }

  elsif ? %options<icon> {
    my $w = %options<icon>;
    $w .= get-native-object if $w ~~ Gnome::GObject::Object;
    self.set-native-object(gtk_tool_button_new( $w, Str));
  }

  elsif ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }

  # create default object
  else {
    self.set-native-object(gtk_tool_button_new( N-GObject, Str));
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkToolButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tool_button_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
#  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkToolButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_new:
=begin pod
=head2 gtk_tool_button_new

Creates a new B<Gnome::Gtk3::ToolButton> using I<icon_widget> as contents and I<label> as
label.

Returns: A new B<Gnome::Gtk3::ToolButton>

Since: 2.4

  method gtk_tool_button_new ( N-GObject $icon_widget, Str $label --> N-GObject )

=item N-GObject $icon_widget; (allow-none): a string that will be used as label, or C<Any>
=item Str $label; (allow-none): a widget that will be used as the button contents, or C<Any>

=end pod

sub gtk_tool_button_new ( N-GObject $icon_widget, Str $label --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_set_label:
=begin pod
=head2 [gtk_tool_button_] set_label

Sets I<label> as the label used for the tool button. The  I<label>
property only has an effect if not overridden by a non-C<Any>
 I<label-widget> property. If both the  I<label-widget>
and  I<label> properties are C<Any>, the label is determined by the
 I<stock-id> property. If the  I<stock-id> property is
also C<Any>, I<button> will not have a label.

Since: 2.4

  method gtk_tool_button_set_label ( Str $label )

=item Str $label; (allow-none): a string that will be used as label, or C<Any>.

=end pod

sub gtk_tool_button_set_label ( N-GObject $button, Str $label  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_get_label:
=begin pod
=head2 [gtk_tool_button_] get_label

Returns the label used by the tool button, or C<Any> if the tool button
doesn’t have a label. or uses a the label from a stock item. The returned
string is owned by GTK+, and must not be modified or freed.

Returns: (nullable): The label, or C<Any>

Since: 2.4

  method gtk_tool_button_get_label ( --> Str )


=end pod

sub gtk_tool_button_get_label ( N-GObject $button --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_set_use_underline:
=begin pod
=head2 [gtk_tool_button_] set_use_underline

If set, an underline in the label property indicates that the next character
should be used for the mnemonic accelerator key in the overflow menu. For
example, if the label property is “_Open” and I<use_underline> is C<1>,
the label on the tool button will be “Open” and the item on the overflow
menu will have an underlined “O”.

Labels shown on tool buttons never have mnemonics on them; this property
only affects the menu item on the overflow menu.

Since: 2.4

  method gtk_tool_button_set_use_underline ( Int $use_underline )

=item Int $use_underline; whether the button label has the form “_Open”

=end pod

sub gtk_tool_button_set_use_underline ( N-GObject $button, int32 $use_underline  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_get_use_underline:
=begin pod
=head2 [gtk_tool_button_] get_use_underline

Returns whether underscores in the label property are used as mnemonics
on menu items on the overflow menu. See C<gtk_tool_button_set_use_underline()>.

Returns: C<1> if underscores in the label property are used as
mnemonics on menu items on the overflow menu.

Since: 2.4

  method gtk_tool_button_get_use_underline ( --> Int )


=end pod

sub gtk_tool_button_get_use_underline ( N-GObject $button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_set_icon_name:
=begin pod
=head2 [gtk_tool_button_] set_icon_name

Sets the icon for the tool button from a named themed icon.
See the docs for B<Gnome::Gtk3::IconTheme> for more details.
The  I<icon-name> property only has an effect if not
overridden by non-C<Any>  I<label-widget>,
 I<icon-widget> and  I<stock-id> properties.

Since: 2.8

  method gtk_tool_button_set_icon_name ( Str $icon_name )

=item Str $icon_name; (allow-none): the name of the themed icon

=end pod

sub gtk_tool_button_set_icon_name ( N-GObject $button, Str $icon_name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_get_icon_name:
=begin pod
=head2 [gtk_tool_button_] get_icon_name

Returns the name of the themed icon for the tool button,
see C<gtk_tool_button_set_icon_name()>.

Returns: (nullable): the icon name or C<Any> if the tool button has
no themed icon

Since: 2.8

  method gtk_tool_button_get_icon_name ( --> Str )


=end pod

sub gtk_tool_button_get_icon_name ( N-GObject $button --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_set_icon_widget:
=begin pod
=head2 [gtk_tool_button_] set_icon_widget

Sets I<icon> as the widget used as icon on I<button>. If I<icon_widget> is
C<Any> the icon is determined by the  I<stock-id> property. If the
 I<stock-id> property is also C<Any>, I<button> will not have an icon.

Since: 2.4

  method gtk_tool_button_set_icon_widget ( N-GObject $icon_widget )

=item N-GObject $icon_widget; (allow-none): the widget used as icon, or C<Any>

=end pod

sub gtk_tool_button_set_icon_widget ( N-GObject $button, N-GObject $icon_widget  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_get_icon_widget:
=begin pod
=head2 [gtk_tool_button_] get_icon_widget

Return the widget used as icon widget on I<button>.
See C<gtk_tool_button_set_icon_widget()>.

Returns: (nullable) (transfer none): The widget used as icon
on I<button>, or C<Any>.

Since: 2.4

  method gtk_tool_button_get_icon_widget ( --> N-GObject )


=end pod

sub gtk_tool_button_get_icon_widget ( N-GObject $button --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_set_label_widget:
=begin pod
=head2 [gtk_tool_button_] set_label_widget

Sets I<label_widget> as the widget that will be used as the label
for I<button>. If I<label_widget> is C<Any> the  I<label> property is used
as label. If  I<label> is also C<Any>, the label in the stock item
determined by the  I<stock-id> property is used as label. If
 I<stock-id> is also C<Any>, I<button> does not have a label.

Since: 2.4

  method gtk_tool_button_set_label_widget ( N-GObject $label_widget )

=item N-GObject $label_widget; (allow-none): the widget used as label, or C<Any>

=end pod

sub gtk_tool_button_set_label_widget ( N-GObject $button, N-GObject $label_widget  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_button_get_label_widget:
=begin pod
=head2 [gtk_tool_button_] get_label_widget

Returns the widget used as label on I<button>.
See C<gtk_tool_button_set_label_widget()>.

Returns: (nullable) (transfer none): The widget used as label
on I<button>, or C<Any>.

Since: 2.4

  method gtk_tool_button_get_label_widget ( --> N-GObject )


=end pod

sub gtk_tool_button_get_label_widget ( N-GObject $button --> N-GObject )
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


=comment #TS:0:clicked:
=head3 clicked

This signal is emitted when the tool button is clicked with the mouse
or activated with the keyboard.

  method handler (
    Gnome::GObject::Object :widget($toolbutton),
    *%user-options
  );

=item $toolbutton; the object that emitted the signal


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

=comment #TP:0:label:
=head3 Label

Text to show in the item.
Default value: Any


The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment #TP:0:use-underline:
=head3 Use underline

If set, an underline in the label property indicates that the next character should be used for the mnemonic accelerator key in the overflow menu
Default value: False


The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:label-widget:
=head3 Label widget

Widget to use as the item label
Widget type: GTK_TYPE_WIDGET


The B<Gnome::GObject::Value> type of property I<label-widget> is C<G_TYPE_OBJECT>.

=comment #TP:0:icon-name:
=head3 Icon name


The name of the themed icon displayed on the item.
This property only has an effect if not overridden by
 I<label-widget>,  I<icon-widget> or
 I<stock-id> properties.
Since: 2.8

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=comment #TP:0:icon-widget:
=head3 Icon widget

Icon widget to display in the item
Widget type: GTK_TYPE_WIDGET


The B<Gnome::GObject::Value> type of property I<icon-widget> is C<G_TYPE_OBJECT>.
=end pod
