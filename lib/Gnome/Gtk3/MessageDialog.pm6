#TL:0:Gnome::Gtk3::MessageDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::MessageDialog

A convenient message window

![](images/messagedialog.png)

=head1 Description

B<Gnome::Gtk3::MessageDialog> presents a dialog with some message text. It’s simply a convenience widget; you could construct the equivalent of B<Gnome::Gtk3::MessageDialog> from B<Gnome::Gtk3::Dialog> without too much effort, but B<Gnome::Gtk3::MessageDialog> saves typing.

One difference from B<Gnome::Gtk3::Dialog> is that B<Gnome::Gtk3::MessageDialog> sets the I<skip-taskbar-hint> property to C<1>, so that the dialog is hidden from the taskbar by default.

The easiest way to do a modal message dialog is to use C<gtk_dialog_run()>, though you can also pass in the C<GTK_DIALOG_MODAL> flag, C<gtk_dialog_run()> automatically makes the dialog modal and waits for the user to respond to it. C<gtk_dialog_run()> returns when any dialog button is clicked.

=begin comment
An example for using a modal dialog:
|[<!-- language="C" -->
 B<Gnome::Gtk3::DialogFlags> flags = GTK_DIALOG_DESTROY_WITH_PARENT;
 dialog = gtk_message_dialog_new (parent_window,
                                  flags,
                                  GTK_MESSAGE_ERROR,
                                  GTK_BUTTONS_CLOSE,
                                  "Error reading “C<s>”: C<s>",
                                  filename,
                                  g_strerror (errno));
 gtk_dialog_run (GTK_DIALOG (dialog));
 gtk_widget_destroy (dialog);
]|

You might do a non-modal B<Gnome::Gtk3::MessageDialog> as follows:

An example for a non-modal dialog:
|[<!-- language="C" -->
 B<Gnome::Gtk3::DialogFlags> flags = GTK_DIALOG_DESTROY_WITH_PARENT;
 dialog = gtk_message_dialog_new (parent_window,
                                  flags,
                                  GTK_MESSAGE_ERROR,
                                  GTK_BUTTONS_CLOSE,
                                  "Error reading “C<s>”: C<s>",
                                  filename,
                                  g_strerror (errno));

 // Destroy the dialog when the user responds to it
 // (e.g. clicks a button)

 g_signal_connect_swapped (dialog, "response",
                           G_CALLBACK (gtk_widget_destroy),
                           dialog);
]|
=end comment


=head2 B<Gnome::Gtk3::MessageDialog> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::MessageDialog> implementation of the B<Gnome::Gtk3::Buildable> interface exposes the message area as an internal child with the name “message_area”.


=head2 Implemented Interfaces

Gnome::Gtk3::MessageDialog implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)

=head2 See Also

B<Gnome::Gtk3::Dialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MessageDialog;
  also is Gnome::Gtk3::Dialog;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::MessageDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkButtonsType

Prebuilt sets of buttons for the dialog. If none of these choices are appropriate, simply use C<GTK_BUTTONS_NONE> then call C<gtk_dialog_add_buttons()>.

Please note that C<GTK_BUTTONS_OK>, C<GTK_BUTTONS_YES_NO> and C<GTK_BUTTONS_OK_CANCEL> are discouraged by the [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).

=item GTK_BUTTONS_NONE: no buttons at all
=item GTK_BUTTONS_OK: an OK button
=item GTK_BUTTONS_CLOSE: a Close button
=item GTK_BUTTONS_CANCEL: a Cancel button
=item GTK_BUTTONS_YES_NO: Yes and No buttons
=item GTK_BUTTONS_OK_CANCEL: OK and Cancel buttons

=end pod

#TE:0:GtkButtonsType:
enum GtkButtonsType is export (
  'GTK_BUTTONS_NONE',
  'GTK_BUTTONS_OK',
  'GTK_BUTTONS_CLOSE',
  'GTK_BUTTONS_CANCEL',
  'GTK_BUTTONS_YES_NO',
  'GTK_BUTTONS_OK_CANCEL'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new MessageDialog object.

  multi method new (
    Str :$message!, N-GObject $parent?, GtkDialogFlags $flags?,
    GtkMessageType $type?, GtkButtonsType $buttons?
    --> N-GObject
  )

  multi method new (
    Str :$markup-message!, N-GObject $parent?, GtkDialogFlags $flags?,
    GtkMessageType $type?, GtkButtonsType $buttons?
    --> N-GObject
  )

=item N-GObject $parent; transient parent, or C<Any> for none
=item GtkDialogFlags $flags; flags. Default is GTK_DIALOG_MODAL.
=item GtkMessageType $type; type of message. Default is GTK_MESSAGE_INFO.
=item GtkButtonsType $buttons; set of buttons to use. Default is  GTK_BUTTONS_CLOSE.
=item Str $message; a string. XML is converted to proper text.
=item Str $markup-message; a string with Pango markup


Create a MessageDialog object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a MessageDialog object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:message):
#TM:1:new(:markup-message):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::MessageDialog';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif ?%options<message> {
    my N-GObject $parent = %options<parent> // N-GObject;
    $parent .= self.get-native-object if $parent ~~ Gnome::GObject::Object;

    my GtkDialogFlags $flags = %options<flags> // GTK_DIALOG_MODAL;
    my GtkMessageType $type = %options<type> // GTK_MESSAGE_INFO;
    my GtkButtonsType $buttons = %options<buttons> // GTK_BUTTONS_CLOSE;

    self.set-native-object(
      gtk_message_dialog_new(
        $parent, $flags, $type, $buttons, %options<message>
      )
    );
  }

  elsif ?%options<markup-message> {
    my N-GObject $parent = %options<parent> // N-GObject;
    $parent .= self.get-native-object if $parent ~~ Gnome::GObject::Object;

    my GtkDialogFlags $flags = %options<flags> // GTK_DIALOG_MODAL;
    my GtkMessageType $type = %options<type> // GTK_MESSAGE_INFO;
    my GtkButtonsType $buttons = %options<buttons> // GTK_BUTTONS_CLOSE;

    self.set-native-object(
      gtk_message_dialog_new_with_markup(
        $parent, $flags, $type, $buttons, %options<markup-message>
      )
    );
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
    die X::Gnome.new(:message('No options found'));
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkMessageDialog');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_message_dialog_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
#  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkMessageDialog');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_message_dialog_new:new(:message)
=begin pod
=head2 gtk_message_dialog_new

Creates a new message dialog, which is a simple dialog with some text the user may want to see. When the user clicks a button a “response” signal is emitted with response IDs from B<Gnome::Gtk3::ResponseType>. See B<Gnome::Gtk3::Dialog> for more details.

Returns: (transfer none): a new B<Gnome::Gtk3::MessageDialog>

  method gtk_message_dialog_new (
    N-GObject $parent, GtkDialogFlags $flags, GtkMessageType $type,
    GtkButtonsType $buttons, Str $message,
    --> N-GObject
  )

=item N-GObject $parent; (allow-none): transient parent, or C<Any> for none
=item GtkDialogFlags $flags; flags
=item GtkMessageType $type; type of message
=item GtkButtonsType $buttons; set of buttons to use
=item Str $message; A string

=end pod

sub gtk_message_dialog_new (
  N-GObject $parent, int32 $flags, int32 $type, int32 $buttons,
  Str $message
  --> N-GObject
) {
  $message ~~ s:g/ '%' / %% /;
  _gtk_message_dialog_new( $parent, $flags, $type, $buttons, $message)
}

sub _gtk_message_dialog_new ( N-GObject $parent, int32 $flags, int32 $type, int32 $buttons, Str $message --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_message_dialog_new')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_message_dialog_new_with_markup:new(:markup-message)
=begin pod
=head2 [gtk_message_dialog_] new_with_markup

Creates a new message dialog, which is a simple dialog with some text that is marked up with the [Pango text markup language][PangoMarkupFormat]. When the user clicks a button a “response” signal is emitted with response IDs from B<Gnome::Gtk3::ResponseType>. See B<Gnome::Gtk3::Dialog> for more details.

=begin comment
|[<!-- language="C" -->
B<Gnome::Gtk3::Widget> *dialog;
B<Gnome::Gtk3::DialogFlags> flags = GTK_DIALOG_DESTROY_WITH_PARENT;
dialog = gtk_message_dialog_new (parent_window,
flags,
GTK_MESSAGE_ERROR,
GTK_BUTTONS_CLOSE,
NULL);
gtk_message_dialog_set_markup (GTK_MESSAGE_DIALOG (dialog),
markup);
]|
=end comment

Returns: a new B<Gnome::Gtk3::MessageDialog>

Since: 2.4

  method gtk_message_dialog_new_with_markup (
    N-GObject $parent, GtkDialogFlags $flags, GtkMessageType $type,
    GtkButtonsType $buttons, Str $message
    --> N-GObject
  )

=item N-GObject $parent; transient parent, or C<Any> for none
=item GtkDialogFlags $flags; flags
=item GtkMessageType $type; type of message
=item GtkButtonsType $buttons; set of buttons to use
=item Str $message; a string

=end pod

sub gtk_message_dialog_new_with_markup (
  N-GObject $parent, int32 $flags, int32 $type, int32 $buttons,
  Str $message
  --> N-GObject
) {
  $message ~~ s:g/ '%' / %% /;
  _gtk_message_dialog_new_with_markup(
    $parent, $flags, $type, $buttons, $message
  )
}

sub _gtk_message_dialog_new_with_markup (
  N-GObject $parent, int32 $flags, int32 $type, int32 $buttons,
  Str $message
  --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_message_dialog_new_with_markup')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_message_dialog_set_markup:
=begin pod
=head2 [gtk_message_dialog_] set_markup

Sets the text of the message dialog to be I<$str>, which is marked
up with the L<Pango text markup language|PangoMarkupFormathttps://developer.gnome.org/pygtk/stable/pango-markup-language.html>.

Since: 2.4

  method gtk_message_dialog_set_markup ( Str $str )

=item Str $str; markup string (see [Pango markup format][PangoMarkupFormat])

=end pod

sub gtk_message_dialog_set_markup ( N-GObject $message_dialog, Str $str  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_message_dialog_format_secondary_text:
=begin pod
=head2 [gtk_message_dialog_] format_secondary_text

Sets the secondary text of the message dialog to be I<$message>.

Since: 2.6

  method gtk_message_dialog_format_secondary_text ( Str $message )

=item Str $message; a string

=end pod

sub gtk_message_dialog_format_secondary_text (
  N-GObject $message_dialog, Str $message
) {
  $message ~~ s:g/ '%' / %% /;
  _gtk_message_dialog_format_secondary_text( $message_dialog, $message)
}

sub _gtk_message_dialog_format_secondary_text (
  N-GObject $message_dialog, Str $message
) is native(&gtk-lib)
  is symbol('gtk_message_dialog_format_secondary_text')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_message_dialog_format_secondary_markup:
=begin pod
=head2 [gtk_message_dialog_] format_secondary_markup

Sets the secondary text of the message dialog to be I<$message> (with C<printf()>-style), which is marked up with the [Pango text markup language][PangoMarkupFormat].

Due to an oversight, this function does not escape special XML characters like C<gtk_message_dialog_new_with_markup()> does. Thus, if the arguments may contain special XML characters, you should use C<g_markup_printf_escaped()> to escape it.

=begin comment
|[<!-- language="C" -->
gchar *msg;

msg = g_markup_printf_escaped (message_format, ...);
gtk_message_dialog_format_secondary_markup (message_dialog,
"C<s>", msg);
g_free (msg);
]|
=end comment

Since: 2.6

  method gtk_message_dialog_format_secondary_markup ( Str $message )

=item Str $message; a message

=end pod
sub gtk_message_dialog_format_secondary_markup (
  N-GObject $message_dialog, Str $message
) {
  $message ~~ s:g/ '%' / %% /;
  _gtk_message_dialog_format_secondary_markup( $message_dialog, $message);
}

sub _gtk_message_dialog_format_secondary_markup ( N-GObject $message_dialog, Str $message )
  is native(&gtk-lib)
  is symbol('gtk_message_dialog_format_secondary_markup')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_message_dialog_get_message_area:
=begin pod
=head2 [gtk_message_dialog_] get_message_area

Returns the message area of the dialog. This is the box where the dialog’s primary and secondary labels are packed. You can add your own extra content to that box and it will appear below those labels. See C<gtk_dialog_get_content_area()> for the corresponding function in the parent B<Gnome::Gtk3::Dialog>.

Returns: (transfer none): A B<Gnome::Gtk3::Box> corresponding to the “message area” in the I<message_dialog>.

Since: 2.22

  method gtk_message_dialog_get_message_area ( --> N-GObject )

=end pod

sub gtk_message_dialog_get_message_area ( N-GObject $message_dialog --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:message-type:
=head3 Message Type


The type of the message.
Widget type: GTK_TYPE_MESSAGE_TYPE

The B<Gnome::GObject::Value> type of property I<message-type> is C<G_TYPE_ENUM>.

=comment #TP:0:buttons:
=head3 Message Buttons

The buttons shown in the message dialog
Default value: False


The B<Gnome::GObject::Value> type of property I<buttons> is C<G_TYPE_ENUM>.

=comment #TP:0:text:
=head3 Text


The primary text of the message dialog. If the dialog has
a secondary text, this will appear as the title.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=comment #TP:0:use-markup:
=head3 Use Markup


C<1> if the primary text of the dialog includes Pango markup.
See C<pango_parse_markup()>.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<use-markup> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:secondary-text:
=head3 Secondary Text


The secondary text of the message dialog.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<secondary-text> is C<G_TYPE_STRING>.

=comment #TP:0:secondary-use-markup:
=head3 Use Markup in secondary


C<1> if the secondary text of the dialog includes Pango markup.
See C<pango_parse_markup()>.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<secondary-use-markup> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:message-area:
=head3 Message area


The B<Gnome::Gtk3::Box> that corresponds to the message area of this dialog.  See
C<gtk_message_dialog_get_message_area()> for a detailed description of this
area.
Since: 2.22
Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<message-area> is C<G_TYPE_OBJECT>.
=end pod
