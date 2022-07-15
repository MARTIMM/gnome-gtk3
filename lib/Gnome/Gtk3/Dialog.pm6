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

If you want to block waiting for a dialog to return before returning control flow to your code, you can call C<run()>. This function enters a recursive main loop and waits for the user to respond to the dialog, returning the response ID corresponding to the button the user clicked.

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


=head2 See Also

B<Gnome::Gtk3::Window>, B<Gnome::Gtk3::Button>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Dialog;
  also is Gnome::Gtk3::Window;


=head2 Uml Diagram

![](plantuml/Dialog.svg)


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
    …
  }

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::HeaderBar;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkdialog.h
# https://developer.gnome.org/gtk3/stable/GtkDialog.html

unit class Gnome::Gtk3::Dialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Window;

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

=head3 default, no options

Create a new plain object.

  multi method new ( )


=head3 :title, :parent, :flags, :buttons-spec

Creates a new B<Gnome::Gtk3::Dialog> with title I<title> (or C<undefined> for the default title; see C<Gnome::Gtk3::Window.set-title()>) and transient parent I<parent> (or C<undefined> for none; see C<Gnome::Gtk3::Window.set-transient-for()>).

The I<flags> argument can be used to make the dialog modal (C<GTK-DIALOG-MODAL>) and/or to have it destroyed along with its transient parent (C<GTK-DIALOG-DESTROY-WITH-PARENT>). After I<flags>, button text/response ID pairs should be listed.

Button text can be arbitrary text. A response ID can be any positive number, or one of the values in the C<GtkResponseType> enumeration.

If the user clicks one of these dialog buttons, B<Gnome::Gtk3::Dialog> will emit the  I<response> signal with the corresponding response ID. If a B<Gnome::Gtk3::Dialog> receives the  I<delete-event> signal, it will emit I<response> with a response ID of C<GTK-RESPONSE-DELETE-EVENT>. However, destroying a dialog does not emit the I<response> signal; so be careful relying on I<response> when using the C<GTK-DIALOG-DESTROY-WITH-PARENT> flag. Buttons are from left to right, so the first button in the list will be the leftmost button in the dialog.

=begin comment
Here’s a simple example: |[<!-- language="C" --> GtkWidget *main-app-window; // Window the dialog should show up on GtkWidget *dialog; GtkDialogFlags flags = GTK-DIALOG-MODAL | GTK-DIALOG-DESTROY-WITH-PARENT; dialog = new-with-buttons ("My dialog", main-app-window, flags, -("-OK"), GTK-RESPONSE-ACCEPT, -("-Cancel"), GTK-RESPONSE-REJECT, NULL); ]|
=end comment

  multi method new (
    Str :$title!, N-Object() :$parent = N-GObject,
    Int :$flags = 0, List :$buttons-spec
  )

=item $title; Title of the dialog, or C<undefined>.
=item $parent; Transient parent of the dialog, or C<undefined>.
=item $flags; GtkDialogFlags from B<Gnome::Gtk3::DialogFlags>.
=item $buttons-spec; A list of alternating names and response codes i.e. an C<Str> text for the first button then an C<Int> response ID for first button, then additional buttons if any.


=head3 :native-object

Create a Dialog object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Dialog object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:title,:parent,:flags,:buttons-spec):
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
    elsif %options<native-object>:exists or %options<build-id>:exists { }

    else {
      my $no;

      if ? %options<title> {
        my Str $title = %options<title> // Str;
        my Int $flags = %options<flags> // 0;
        my @buttons = %options<button-spec> // ();
        my $parent = %options<parent>;
        $parent .= _get-native-object unless $parent ~~ N-GObject;
        $no = _gtk_dialog_new_with_buttons( $title, $parent, $flags, |@buttons);
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


      else {
        $no = _gtk_dialog_new();
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkDialog');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_dialog_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_dialog_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('dialog-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-dialog-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkDialog');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:add-action-widget:
=begin pod
=head2 add-action-widget

Adds an activatable widget to the action area of a B<Gnome::Gtk3::Dialog>, connecting a signal handler that will emit the  I<response> signal on the dialog when the widget is activated. The widget is appended to the end of the dialog’s action area.
=comment If you want to add a non-activatable widget, simply pack it into the I<action-area> field of the B<Gnome::Gtk3::Dialog> struct.

  method add-action-widget ( N-GObject() $child, Int() $response_id )

=item $child; an activatable widget
=item $response_id; response ID for I<child>
=end pod

method add-action-widget ( N-GObject() $child, Int() $response_id ) {
  gtk_dialog_add_action_widget( self._f('GtkDialog'), $child, $response_id);
}

sub gtk_dialog_add_action_widget (
  N-GObject $dialog, N-GObject $child, gint $response_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-button:
=begin pod
=head2 add-button

Adds a button with the given text and sets things up so that clicking the button will emit the  I<response> signal with the given I<response-id>. The button is appended to the end of the dialog’s action area. The button widget is returned, but usually you don’t need it.

Returns: the B<Gnome::Gtk3::Button> widget that was added

  method add-button ( Str() $button_text, Int() $response_id --> N-GObject )

=item $button_text; text of button
=item $response_id; response ID for the button
=end pod

method add-button ( Str() $button_text, Int() $response_id --> N-GObject ) {
  gtk_dialog_add_button( self._f('GtkDialog'), $button_text, $response_id)
}

sub gtk_dialog_add_button (
  N-GObject $dialog, gchar-ptr $button_text, gint $response_id --> N-GObject
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-buttons:
=begin pod
=head2 add-buttons

Adds more buttons, same as calling C<add-button()> repeatedly. The variable argument list should be C<undefined>-terminated as with C<gtk-dialog-new-with-buttons()>. Each button must have both text and response ID.

  method add-buttons ( Str $first_button_text )

=item Str $first_button_text; button text @...: response ID for first button, then more text-response-id pairs
=end pod

method add-buttons ( Str $first_button_text ) {

  gtk_dialog_add_buttons(
    self._f('GtkDialog'), $first_button_text
  );
}

sub gtk_dialog_add_buttons (
  N-GObject $dialog, gchar-ptr $first_button_text, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-content-area:
=begin pod
=head2 get-content-area

Returns the content area of I<dialog>.

Returns: (type Gtk.Box) : the native object of the content area as B<Gnome::Gtk3::Box>.

  method get-content-area ( --> N-GObject )

=end pod

method get-content-area ( --> N-GObject ) {
  gtk_dialog_get_content_area(self._f('GtkDialog'))
}

method get-content-area-rk ( --> Gnome::Gtk3::Box ) {
  Gnome::N::deprecate(
    'get-content-area-rk', 'coercing from get-content-area',
    '0.48.6', '0.50.0'
  );

  Gnome::Gtk3::Box.new(
    :native-object(gtk_dialog_get_content_area(self._f('GtkDialog')))
  )
}

sub gtk_dialog_get_content_area (
  N-GObject $dialog --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-header-bar:
=begin pod
=head2 get-header-bar

Returns the header bar of I<dialog>. Note that the headerbar is only used by the dialog if the  I<use-header-bar> property is C<True>.

Returns: the native object of a header bar

  method get-header-bar ( --> N-GObject )

=end pod

method get-header-bar ( --> N-GObject ) {
  gtk_dialog_get_header_bar(self._f('GtkDialog'))
}

method get-header-bar-rk ( --> Gnome::Gtk3::HeaderBar ) {
  Gnome::N::deprecate(
    'get-content-area-rk', 'coercing from get-content-area',
    '0.48.6', '0.50.0'
  );

  Gnome::Gtk3::HeaderBar.new(
    :native-object(gtk_dialog_get_header_bar(self._f('GtkDialog')))
  )
}

sub gtk_dialog_get_header_bar (
  N-GObject $dialog --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-response-for-widget:
=begin pod
=head2 get-response-for-widget

Gets the response id of a widget in the action area of a dialog.

Returns: the response id of I<widget>, or C<GTK_RESPONSE_NONE> if I<widget> doesn’t have a response id set.

  method get-response-for-widget ( N-GObject() $widget --> Int )

=item $widget; a widget in the action area of I<dialog>
=end pod

method get-response-for-widget ( N-GObject() $widget --> Int ) {
  gtk_dialog_get_response_for_widget( self._f('GtkDialog'), $widget)
}

sub gtk_dialog_get_response_for_widget (
  N-GObject $dialog, N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-widget-for-response:
=begin pod
=head2 get-widget-for-response

Gets the widget button that uses the given response ID in the action area of a dialog.

Returns: the I<widget> button that uses the given I<$response-id>, or C<undefined>.

  method get-widget-for-response ( Int() $response_id --> N-GObject )

=item $response_id; the response ID used by the I<dialog> widget
=end pod

method get-widget-for-response ( Int() $response_id --> N-GObject ) {
  gtk_dialog_get_widget_for_response( self._f('GtkDialog'), $response_id)
}

sub gtk_dialog_get_widget_for_response (
  N-GObject $dialog, gint $response_id --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:response:
=begin pod
=head2 response

Emits the  I<response> signal with the given response ID. Used to indicate that the user has responded to the dialog in some way; typically either you or C<run()> will be monitoring the I<response> signal and take appropriate action.

  method response ( Int() $response_id )

=item $response_id; response ID
=end pod

method response ( Int() $response_id ) {
  gtk_dialog_response( self._f('GtkDialog'), $response_id);
}

sub gtk_dialog_response (
  N-GObject $dialog, gint $response_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:run:
=begin pod
=head2 run

Blocks in a recursive main loop until the I<dialog> either emits the  I<response> signal, or is destroyed. If the dialog is destroyed during the call to C<run()>, C<gtk-dialog-run()> returns B<Gnome::Gtk3::TK-RESPONSE-NONE>. Otherwise, it returns the response ID from the I<response> signal emission.

Before entering the recursive main loop, C<gtk-dialog-run()> calls C<gtk-widget-show()> on the dialog for you. Note that you still need to show any children of the dialog yourself.

During C<gtk-dialog-run()>, the default behavior of  I<delete-event> is disabled; if the dialog receives I<delete-event>, it will not be destroyed as windows usually are, and C<gtk-dialog-run()> will return B<Gnome::Gtk3::TK-RESPONSE-DELETE-EVENT>. Also, during C<gtk-dialog-run()> the dialog will be modal. You can force C<gtk-dialog-run()> to return at any time by calling C<gtk-dialog-response()> to emit the I<response> signal. Destroying the dialog during C<gtk-dialog-run()> is a very bad idea, because your post-run code won’t know whether the dialog was destroyed or not.

After C<gtk-dialog-run()> returns, you are responsible for hiding or destroying the dialog if you wish to do so.

Typical usage of this function might be: |[<!-- language="C" --> GtkWidget *dialog = C<gtk-dialog-new()>; // Set up dialog...

int result = gtk-dialog-run (GTK-DIALOG (dialog)); switch (result) { case GTK-RESPONSE-ACCEPT: // C<do-application-specific-something()>; break; default: // C<do-nothing-since-dialog-was-cancelled()>; break; } gtk-widget-destroy (dialog); ]|

Note that even though the recursive main loop gives the effect of a modal dialog (it prevents the user from interacting with other windows in the same window group while the dialog is run), callbacks such as timeouts, IO channel watches, DND drops, etc, will be triggered during a C<gtk-dialog-run()> call.

Returns: response ID

  method run ( --> Int )

=end pod

method run ( --> Int ) {
  gtk_dialog_run(self._f('GtkDialog'))
}

sub gtk_dialog_run (
  N-GObject $dialog --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default-response:
=begin pod
=head2 set-default-response

Sets the last widget in the dialog’s action area with the given I<$response-id> as the default widget for the dialog. Pressing “Enter” normally activates the default widget.

  method set-default-response ( Int() $response_id )

=item $response_id; a response ID
=end pod

method set-default-response ( Int() $response_id ) {
  gtk_dialog_set_default_response( self._f('GtkDialog'), $response_id);
}

sub gtk_dialog_set_default_response (
  N-GObject $dialog, gint $response_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-response-sensitive:
=begin pod
=head2 set-response-sensitive

Calls C<Gnome::Gtk3::Widget.set-sensitive($setting)> for each widget in the dialog’s action area with the given I<$response-id>. A convenient way to sensitize/desensitize dialog buttons.

  method set-response-sensitive ( Int() $response_id, Bool $setting )

=item $response_id; a response ID
=item $setting; C<True> for sensitive
=end pod

method set-response-sensitive ( Int() $response_id, Bool $setting ) {
  gtk_dialog_set_response_sensitive(
    self._f('GtkDialog'), $response_id, $setting
  );
}

sub gtk_dialog_set_response_sensitive (
  N-GObject $dialog, gint $response_id, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_dialog_new:
#`{{
=begin pod
=head2 _gtk_dialog_new

Creates a new dialog box.

Widgets should not be packed into this B<Gnome::Gtk3::Window> directly, but into the I<vbox> and I<action-area>, as described above.

Returns: the new dialog as a B<Gnome::Gtk3::Widget>

  method _gtk_dialog_new ( --> N-GObject )

=end pod
}}

sub _gtk_dialog_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_dialog_new')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_dialog_new_with_buttons:
#`{{
=begin pod
=head2 _gtk_dialog_new_with_buttons

Creates a new B<Gnome::Gtk3::Dialog> with title I<title> (or C<undefined> for the default title; see C<gtk-window-set-title()>) and transient parent I<parent> (or C<undefined> for none; see C<gtk-window-set-transient-for()>). The I<flags> argument can be used to make the dialog modal (B<Gnome::Gtk3::TK-DIALOG-MODAL>) and/or to have it destroyed along with its transient parent (B<Gnome::Gtk3::TK-DIALOG-DESTROY-WITH-PARENT>). After I<flags>, button text/response ID pairs should be listed, with a C<undefined> pointer ending the list. Button text can be arbitrary text. A response ID can be any positive number, or one of the values in the B<Gnome::Gtk3::ResponseType> enumeration. If the user clicks one of these dialog buttons, B<Gnome::Gtk3::Dialog> will emit the  I<response> signal with the corresponding response ID. If a B<Gnome::Gtk3::Dialog> receives the  I<delete-event> signal, it will emit I<response> with a response ID of B<Gnome::Gtk3::TK-RESPONSE-DELETE-EVENT>. However, destroying a dialog does not emit the I<response> signal; so be careful relying on I<response> when using the B<Gnome::Gtk3::TK-DIALOG-DESTROY-WITH-PARENT> flag. Buttons are from left to right, so the first button in the list will be the leftmost button in the dialog.

Here’s a simple example: |[<!-- language="C" --> GtkWidget *main-app-window; // Window the dialog should show up on GtkWidget *dialog; GtkDialogFlags flags = GTK-DIALOG-MODAL | GTK-DIALOG-DESTROY-WITH-PARENT; dialog = new-with-buttons ("My dialog", main-app-window, flags, -("-OK"), GTK-RESPONSE-ACCEPT, -("-Cancel"), GTK-RESPONSE-REJECT, NULL); ]|

Returns: a new B<Gnome::Gtk3::Dialog>

  method _gtk_dialog_new_with_buttons ( Str $title, N-GObject $parent, GtkDialogFlags $flags, Str $first_button_text --> N-GObject )

=item Str $title; Title of the dialog, or C<undefined>
=item N-GObject $parent; Transient parent of the dialog, or C<undefined>
=item GtkDialogFlags $flags; from B<Gnome::Gtk3::DialogFlags>
=item Str $first_button_text; text to go in first button, or C<undefined> @...: response ID for first button, then additional buttons, ending with C<undefined>
=end pod
}}

sub _gtk_dialog_new_with_buttons ( gchar-ptr $title, N-GObject $parent, GEnum $flags, gchar-ptr $first_button_text, Any $any = Any --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_dialog_new_with_buttons')
  { * }
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
      @parameterList.push(Parameter.new(type => GEnum));
    }
    # end list with a Nil
    @parameterList.push(Parameter.new(type => Pointer));
  }

  else {
    die X::Gnome.new(:message('Odd number of button specs'));
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameterList),
    :returns(N-GObject)
  );


  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_dialog_new_with_buttons', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $title, $parent, $flags, |@buttons, Nil)
}

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:close:
=head2 close

The I<close> signal is a keybinding signal which gets emitted when the user uses a keybinding to close the dialog.

The default binding for this signal is the Escape key.

  method handler (
    Gnome::Gtk3::Dialog :_widget($dialog),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  );

=item $dialog; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method


=comment -----------------------------------------------------------------------
=comment #TS:0:response:
=head2 response

Emitted when an action widget is clicked, the dialog receives a
delete event, or the application programmer calls C<response()>.
On a delete event, the response ID is B<Gnome::Gtk3::TK-RESPONSE-DELETE-EVENT>.
Otherwise, it depends on which action widget was clicked.

  method handler (
    Int $response-id,
    Int :$_handle-id,
    Gnome::Gtk3::Dialog :_widget($dialog),
    N-GObject :$_native-object,
    *%user-options
  );

=item $response-id; the response ID
=item $_handler-id; The handler id which is returned from the registration
=item $dialog; the object on which the signal is emitted
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=begin comment
#TODO style properties

=comment -----------------------------------------------------------------------
=comment # TP:1:action-area-border:
=head2 action-area-border

Width of border around the button area at the bottom of the dialog

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 5.


=comment -----------------------------------------------------------------------
=comment # TP:1:button-spacing:
=head2 button-spacing

Spacing between buttons

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 6.


=comment -----------------------------------------------------------------------
=comment # TP:1:content-area-border:
=head2 content-area-border

Width of border around the main dialog area

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 2.


=comment -----------------------------------------------------------------------
=comment # TP:1:content-area-spacing:
=head2 content-area-spacing

Spacing between elements of the main dialog area

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.

=end comment


=comment -----------------------------------------------------------------------
=comment #TP:1:use-header-bar:
=head2 use-header-bar

Use Header Bar for actions.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Minimum value is -1.
=item Maximum value is 1.
=item Default value is -1.

=end pod





=finish
=comment -----------------------------------------------------------------------
=comment #TP:1:content-area-border:
=head3 Content area border: content-area-border


The default border width used around the
content area of the dialog, as returned by
C<get-content-area()>, unless C<gtk-container-set-border-width()>
   * was called on that widget directly.
The B<Gnome::GObject::Value> type of property I<content-area-border> is C<G_TYPE_INT>.
=end pod
