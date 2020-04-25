#TL:1:Gnome::Gtk3::Dialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Dialog

Create popup windows

=comment ![](images/X.png)

=head1 Description


Dialog boxes are a convenient way to prompt the user for a small amount of input, e.g. to display a message, ask a question, or anything else that does not require extensive effort on the user’s part.

GTK+ treats a dialog as a window split vertically. The top section is a VBox, and is where widgets such as a B<Gnome::Gtk3::Label> or a be packed. The bottom area is known as the “action area”. This is generally used for packing buttons into the dialog which may perform functions such as cancel, ok, or apply.

B<Gnome::Gtk3::Dialog> boxes are created with a call to C<.new()> or C<.new(:$title)>. C<.new(:$title)> is recommended; it allows you to set the dialog title, some convenient flags (with C<:$flags>), and add simple buttons (with C<:$buttons>).

If “dialog” is a newly created dialog, the two primary areas of the window can be accessed through C<gtk_dialog_get_content_area()> and C<gtk_dialog_get_action_area()>, as can be seen from the example below.

A “modal” dialog (that is, one which freezes the rest of the application from user input), can be created by calling C<gtk_window_set_modal()> on the dialog. Use the C<GTK_WINDOW()> macro to cast the widget returned from C<gtk_dialog_new()> into a B<Gnome::Gtk3::Window>. When using C<gtk_dialog_new_with_buttons()> you can also pass the B<GTK_DIALOG_MODAL> flag to make a dialog modal.

If you add buttons to B<Gnome::Gtk3::Dialog> using C<.new(:$buttons)>, C<gtk_dialog_add_button()>, C<gtk_dialog_add_buttons()>, or C<gtk_dialog_add_action_widget()>, clicking the button will emit a signal called  I<response> with a response ID that you specified. GTK+ will never assign a meaning to positive response IDs; these are entirely user-defined. But for convenience, you can use the response IDs in the B<Gnome::Gtk3::ResponseType> enumeration (these all have values less than zero). If a dialog receives a delete event, the  I<response> signal will be emitted with a response ID of B<GTK_RESPONSE_DELETE_EVENT>.

If you want to block waiting for a dialog to return before returning control flow to your code, you can call C<gtk_dialog_run()>. This function enters a recursive main loop and waits for the user to respond to the dialog, returning the response ID corresponding to the button the user clicked.

For the simple dialog in the following example, in reality you’d probably use B<Gnome::Gtk3::MessageDialog> to save yourself some effort. But you’d need to create the dialog contents manually if you had more than a simple message in the dialog.

An example for simple B<Gnome::Gtk3::Dialog> usage:

  method quick-message ( Gnome::Gtk3::Window $parent, Str $message ) {

    my Gnome::Gtk3::Dialog $dialog .= new(
      :title<Message>, :$parent, :flags(GTK_DIALOG_DESTROY_WITH_PARENT),
      :button-spec( "Ok", GTK_RESPONSE_NONE)
    );

    my $content-area = $dialog.get-content-area;
    my Gnome::Gtk3::Label $label .= new(:label($message));
    $dialog.gtk_container_add($label);

    # Show the dialog. After return (Ok pressed) the dialog widget
    # is destroyed. show-all() must be called, otherwise the message
    # will not be seen.
    $dialog.show-all;
    $dialog.gtk-dialog-run;
    $dialog.gtk_widget_destroy;
  }


=head2 Gnome::Gtk3::Dialog as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Dialog> implementation of the B<Gnome::Gtk3::Buildable> interface exposes the I<vbox> and I<action_area> as internal children with the names “vbox” and “action_area”.

B<Gnome::Gtk3::Dialog> supports a custom <action-widgets> element, which can contain multiple <action-widget> elements. The “response” attribute specifies a numeric response, and the content of the element is the id of widget (which should be a child of the dialogs I<action_area>). To mark a response as default, set the “default“ attribute of the <action-widget> element to true.

B<Gnome::Gtk3::Dialog> supports adding action widgets by specifying “action“ as the “type“ attribute of a <child> element. The widget will be added either to the action area or the headerbar of the dialog, depending on the “use-header-bar“ property. The response id has to be associated with the action widget using the <action-widgets> element.

An example of a dialog UI definition fragment:

  <object class="GtkDialog" id="dialog1">
    <child type="action">
      <object class="GtkButton" id="button_cancel"/>
    </child>
    <child type="action">
      <object class="GtkButton" id="button_ok">
        <property name="can-default">True</property>
      </object>
    </child>
    <action-widgets>
      <action-widget response="cancel">button_cancel</action-widget>
      <action-widget response="ok" default="true">button_ok</action-widget>
    </action-widgets>
  </object>


=begin comment
=head2 Implemented Interfaces

Gnome::Gtk3::Dialog implements

=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)

=end comment

=head2 See Also

B<Gnome::Gtk3::Window>, B<Gnome::Gtk3::Button>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Dialog;
  also is Gnome::Gtk3::Window;
=comment  also does Gnome::Gtk3::Buildable;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Dialog;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Dialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Dialog class process the options
    self.bless( :GtkDialog, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=head2 Example

  my Gnome::Gtk3::Dialog $dialog .= new(:build-id<simple-dialog>);

  # show the dialog
  my Int $response = $dialog.gtk-dialog-run;
  if $response == GTK_RESPONSE_ACCEPT {
  ...
  }

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gtk3::Window;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkdialog.h
# https://developer.gnome.org/gtk3/stable/GtkDialog.html

unit class Gnome::Gtk3::Dialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Window;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkDialogFlags

Flags used to influence dialog construction.

=item GTK_DIALOG_MODAL: Make the constructed dialog modal, see C<gtk_window_set_modal()>
=item GTK_DIALOG_DESTROY_WITH_PARENT: Destroy the dialog when its parent is destroyed, see C<gtk_window_set_destroy_with_parent()>
=item GTK_DIALOG_USE_HEADER_BAR: Create dialog with actions in header bar instead of action area. Since 3.12.

=end pod

#TE:1:GtkDialogFlags:
enum GtkDialogFlags is export (
  'GTK_DIALOG_MODAL'               => 1 +< 0,
  'GTK_DIALOG_DESTROY_WITH_PARENT' => 1 +< 1,
  'GTK_DIALOG_USE_HEADER_BAR'      => 1 +< 2
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkResponseType

Predefined values for use as response ids in C<gtk_dialog_add_button()>.
All predefined values are negative; GTK+ leaves values of 0 or greater for
application-defined response ids.

=item GTK_RESPONSE_NONE: Returned if an action widget has no response id, or if the dialog gets programmatically hidden or destroyed
=item GTK_RESPONSE_REJECT: Generic response id, not used by GTK+ dialogs
=item GTK_RESPONSE_ACCEPT: Generic response id, not used by GTK+ dialogs
=item GTK_RESPONSE_DELETE_EVENT: Returned if the dialog is deleted
=item GTK_RESPONSE_OK: Returned by OK buttons in GTK+ dialogs
=item GTK_RESPONSE_CANCEL: Returned by Cancel buttons in GTK+ dialogs
=item GTK_RESPONSE_CLOSE: Returned by Close buttons in GTK+ dialogs
=item GTK_RESPONSE_YES: Returned by Yes buttons in GTK+ dialogs
=item GTK_RESPONSE_NO: Returned by No buttons in GTK+ dialogs
=item GTK_RESPONSE_APPLY: Returned by Apply buttons in GTK+ dialogs
=item GTK_RESPONSE_HELP: Returned by Help buttons in GTK+ dialogs

=end pod

#TE:1:GtkResponseType:
enum GtkResponseType is export (
  GTK_RESPONSE_NONE         => -1,
  GTK_RESPONSE_REJECT       => -2,
  GTK_RESPONSE_ACCEPT       => -3,
  GTK_RESPONSE_DELETE_EVENT => -4,
  GTK_RESPONSE_OK           => -5,
  GTK_RESPONSE_CANCEL       => -6,
  GTK_RESPONSE_CLOSE        => -7,
  GTK_RESPONSE_YES          => -8,
  GTK_RESPONSE_NO           => -9,
  GTK_RESPONSE_APPLY        => -10,
  GTK_RESPONSE_HELP         => -11,
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create a dialog with title flags and buttons.

  multi method new (
    Str :$title!, Gnome::GObject::Object :$parent, Int :$flags,
    List :$buttons-spec
  )

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:title):
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<close>, :w1<response>,
  ) unless $signals-added;


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Dialog' or %options<GtkDialog> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      if ? %options<empty> {
        Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
        $no = _gtk_dialog_new();
      }

      elsif ? %options<title> {
        my Str $title = %options<title> // Str;
        my Int $flags = %options<flags> // 0;
        my @buttons = %options<button-spec> // ();
        my $parent = %options<parent>;
        $parent .= get-native-object unless $parent ~~ N-GObject;
        $no = _gtk_dialog_new_with_buttons( $title, $parent, $flags, |@buttons);
      }

      else {
        $no = _gtk_dialog_new();
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkDialog');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_dialog_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkDialog');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_dialog_new:new()
#`{{
=begin pod
=head2 [gtk_] dialog_new

Creates a new dialog box.

Widgets should not be packed into this B<Gnome::Gtk3::Window>
directly, but into the I<vbox> and I<action_area>, as described above.

Returns: the new dialog as a B<Gnome::Gtk3::Widget>

  method gtk_dialog_new ( --> N-GObject  )

=end pod
}}

sub _gtk_dialog_new (  )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_dialog_new')
  { * }

#-------------------------------------------------------------------------------
#TM:3:_gtk_dialog_new_with_buttons:
#`{{
=begin pod
=head2 [[gtk_] dialog_] new_with_buttons

Creates a new B<Gnome::Gtk3::Dialog> with title I<$title> (or C<Any> for the default title; see C<gtk_window_set_title()>) and transient parent I<$parent> (or C<Any> for none; see C<gtk_window_set_transient_for()>). The I<$flags>
argument can be used to make the dialog modal (B<GTK_DIALOG_MODAL>)
and/or to have it destroyed along with its transient parent
(B<GTK_DIALOG_DESTROY_WITH_PARENT>). After I<$flags>, button
text/response ID pairs should be listed, with a C<Any> pointer ending
the list. Button text can be arbitrary text. A response ID can be
any positive number, or one of the values in the B<GtkResponseType>
enumeration. If the user clicks one of these dialog buttons,
B<Gnome::Gtk3::Dialog> will emit the  I<response> signal with the corresponding
response ID. If a B<Gnome::Gtk3::Dialog> receives the  I<delete-event> signal,
it will emit I<response> with a response ID of B<GTK_RESPONSE_DELETE_EVENT>.
However, destroying a dialog does not emit the I<response> signal;
so be careful relying on I<response> when using the
B<GTK_DIALOG_DESTROY_WITH_PARENT> flag. Buttons are from left to right,
so the first button in the list will be the leftmost button in the dialog.

Here’s a simple example:

  my $dialog = gtk_dialog_new_with_buttons(
    "My dialog", $top-window,
    GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT,
    'Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT
  );

Returns: a new native Dialog.

  method gtk_dialog_new_with_buttons (
    Str $title, N-GObject $parent, Int $flags,
    *@buttons-spec
    --> N-GObject
  )

=item Str $title; (allow-none): Title of the dialog, or C<Any>.
=item N-GObject $parent; Transient parent of the dialog, or C<Any>.
=item Int $flags. A mask of GtkDialogFlags values.

=item *@buttons-spec is a list button specifications. The list has an even number of members of which;
=item2 Str $button-label to go on the button.
=item2 $response-code, an Int, GtkResponseType or other enum (with int values) to return for the button. Taking a GtkResponseType will help the chooser dialog make a proper decision if needed. Otherwise, the user can always check codes returned by the dialog to find out what to do next.

=end pod
}}
sub _gtk_dialog_new_with_buttons (
  Str $title, N-GObject $parent, Int $flags, *@buttons
  --> N-GObject
) {

  # create parameter list and start with inserting fixed arguments
  my @parameterList = (
    Parameter.new(type => Str),         # $title
    Parameter.new(type => N-GObject),   # $parent
    Parameter.new(type => int32),       # $flags
  );

  # check the button list parameters
  my CArray $native-bspec .= new;
  if @buttons.elems %% 2 {
    for @buttons -> Str $button-text, Int $response-code {
      # values not used here, just a check on type
      @parameterList.push(Parameter.new(type => Str));
      @parameterList.push(Parameter.new(type => int32));
    }
  }

  else {
    die X::Gnome.new(:message('Odd number of button specs'));
  }

  # create signature
  my Signature $signature .= new(
    :params( |@parameterList, Parameter.new(type => Pointer)),
    :returns(N-GObject)
  );


  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_dialog_new_with_buttons', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $title, $parent, $flags, |@buttons, Pointer)
}

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_add_action_widget:
=begin pod
=head2 [[gtk_] dialog_] add_action_widget

Adds an activatable widget to the action area of a B<Gnome::Gtk3::Dialog>,
connecting a signal handler that will emit the  I<response>
signal on the dialog when the widget is activated. The widget is
appended to the end of the dialog’s action area. If you want to add a
non-activatable widget, simply pack it into the I<action_area> field
of the B<Gnome::Gtk3::Dialog> struct.

  method gtk_dialog_add_action_widget ( N-GObject $child, Int $response_id )

=item N-GObject $child; an activatable widget
=item Int $response_id; response ID for I<child>

=end pod

sub gtk_dialog_add_action_widget ( N-GObject $dialog, N-GObject $child, int32 $response_id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_add_button:
=begin pod
=head2 [[gtk_] dialog_] add_button

Adds a button with the given text and sets things up so that
clicking the button will emit the  I<response> signal with
the given I<response_id>. The button is appended to the end of the
dialog’s action area. The button widget is returned, but usually
you don’t need it.

Returns: (transfer none): the B<Gnome::Gtk3::Button> widget that was added

  method gtk_dialog_add_button ( Str $button_text, Int $response_id --> N-GObject  )

=item Str $button_text; text of button
=item Int $response_id; response ID for the button

=end pod

sub gtk_dialog_add_button ( N-GObject $dialog, Str $button_text, int32 $response_id )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_add_buttons:
=begin pod
=head2 [[gtk_] dialog_] add_buttons

Adds more buttons, same as calling C<gtk_dialog_add_button()>
repeatedly.  The variable argument list should be C<Any>-terminated
as with C<gtk_dialog_new_with_buttons()>. Each button must have both
text and response ID.

  method gtk_dialog_add_buttons ( Str $first_button_text )

=item Str $first_button_text; button text @...: response ID for first button, then more text-response_id pairs

=end pod

sub gtk_dialog_add_buttons ( N-GObject $dialog, Str $first_button_text, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_set_response_sensitive:
=begin pod
=head2 [[gtk_] dialog_] set_response_sensitive

Calls `gtk_widget_set_sensitive (widget, I<setting>)`
for each widget in the dialog’s action area with the given I<response_id>.
A convenient way to sensitize/desensitize dialog buttons.

  method gtk_dialog_set_response_sensitive ( Int $response_id, Int $setting )

=item Int $response_id; a response ID
=item Int $setting; C<1> for sensitive

=end pod

sub gtk_dialog_set_response_sensitive ( N-GObject $dialog, int32 $response_id, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_dialog_set_default_response:QAManager
=begin pod
=head2 [[gtk_] dialog_] set_default_response

Sets the last widget in the dialog’s action area with the given I<$response_id> as the default widget for the dialog. Pressing “Enter” normally activates the default widget.

  method gtk_dialog_set_default_response ( Int $response_id )

=item Int $response_id; a response ID

=end pod

sub gtk_dialog_set_default_response ( N-GObject $dialog, int32 $response_id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_get_widget_for_response:
=begin pod
=head2 [[gtk_] dialog_] get_widget_for_response

Gets the widget button that uses the given response ID in the action area of a dialog.

Returns: the I<widget> button that uses the given I<response_id>, or undefined.

  method gtk_dialog_get_widget_for_response ( Int $response_id --> N-GObject  )

=item Int $response_id; the response ID used by the I<dialog> widget

=end pod

sub gtk_dialog_get_widget_for_response ( N-GObject $dialog, int32 $response_id )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_get_response_for_widget:
=begin pod
=head2 [[gtk_] dialog_] get_response_for_widget

Gets the response id of a widget in the action area
of a dialog.

Returns: the response id of I<widget>, or C<GTK_RESPONSE_NONE>
if I<widget> doesn’t have a response id set.
DeleteMsgDialog

  method gtk_dialog_get_response_for_widget ( N-GObject $widget --> Int  )

=item N-GObject $widget; a widget in the action area of I<dialog>

=end pod

sub gtk_dialog_get_response_for_widget ( N-GObject $dialog, N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_response:
=begin pod
=head2 [gtk_] dialog_response

Emits the  I<response> signal with the given response ID.
Used to indicate that the user has responded to the dialog in some way;
typically either you or C<gtk_dialog_run()> will be monitoring the I<response> signal and take appropriate action.

  method gtk_dialog_response ( Int $response_id )

=item Int $response_id; response ID

=end pod

sub gtk_dialog_response ( N-GObject $dialog, int32 $response_id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_run:
=begin pod
=head2 [gtk_] dialog_run

Blocks in a recursive main loop until the dialog either emits the I<response> signal, or is destroyed. If the dialog is destroyed during the call to C<gtk_dialog_run()>, C<gtk_dialog_run()> returns B<GTK_RESPONSE_NONE>. Otherwise, it returns the response ID from the I<response> signal emission.

Before entering the recursive main loop, C<gtk_dialog_run()> calls C<gtk_widget_show()> on the dialog for you. Note that you still need to show any children of the dialog yourself.

During C<gtk_dialog_run()>, the default behavior of I<delete-event> is disabled; if the dialog receives a I<delete_event>, it will not be destroyed as windows usually are, and C<gtk_dialog_run()> will return B<GTK_RESPONSE_DELETE_EVENT>. Also, during C<gtk_dialog_run()> the dialog will be modal. You can force C<gtk_dialog_run()> to return at any time by calling C<gtk_dialog_response()> to emit the I<response> signal. Destroying the dialog during C<gtk_dialog_run()> is a very bad idea, because your post-run code won’t know whether the dialog was destroyed or not.

After C<gtk_dialog_run()> returns, you are responsible for hiding or destroying the dialog if you wish to do so.

Typical usage of this function might be:

  given GtkResponseType($dialog.gtk-dialog-run) {
    when GTK_RESPONSE_ACCEPT {
      do_application_specific_something();
    }

    default {
      do_nothing_since_dialog_was_cancelled();
    }
  }

  $dialog.gtk_widget_destroy;


Note that even though the recursive main loop gives the effect of a modal dialog (it prevents the user from interacting with other windows in the same window group while the dialog is run), callbacks such as timeouts, IO channel watches, DND drops, etc, will be triggered during a C<gtk_dialog_run()> call.

Returns: response ID

  method gtk_dialog_run ( --> Int  )


=end pod

sub gtk_dialog_run ( N-GObject $dialog )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_get_content_area:
=begin pod
=head2 [[gtk_] dialog_] get_content_area

Returns the content area of I<dialog>.

Returns: (type B<Gnome::Gtk3::.Box>) the content area B<Gnome::Gtk3::Box>.

  method gtk_dialog_get_content_area ( --> N-GObject  )


=end pod

sub gtk_dialog_get_content_area ( N-GObject $dialog )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_dialog_get_header_bar:
=begin pod
=head2 [[gtk_] dialog_] get_header_bar

Returns the header bar of I<dialog>. Note that the
headerbar is only used by the dialog if the
 I<use-header-bar> property is C<1>.

Returns: (transfer none): the header bar
DeleteMsgDialog

  method gtk_dialog_get_header_bar ( --> N-GObject  )


=end pod

sub gtk_dialog_get_header_bar ( N-GObject $dialog )
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


=comment #TS:0:response:
=head3 response

Emitted when an action widget is clicked, the dialog receives a
delete event, or the application programmer calls C<gtk_dialog_response()>.
On a delete event, the response ID is B<GTK_RESPONSE_DELETE_EVENT>.
Otherwise, it depends on which action widget was clicked.

  method handler (
    Int $response_id,
    Gnome::GObject::Object :widget($dialog),
    *%user-options
  );

=item $dialog; the object on which the signal is emitted

=item $response_id; the response ID


=comment #TS:0:close:
=head3 close

The I<close> signal is a keybinding signal which gets emitted when the user uses a keybinding to close the dialog.

The default binding for this signal is the Escape key.

  method handler (
    Gnome::GObject::Object :widget($dialog),
    *%user-options
  );


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

=comment #TP:0:content-area-border:
=head3 Content area border

The default border width used around the content area of the dialog, as returned by C<gtk_dialog_get_content_area()>, unless C<gtk_container_set_border_width()> was called on that widget directly.

The B<Gnome::GObject::Value> type of property I<content-area-border> is C<G_TYPE_INT>.
=end pod
