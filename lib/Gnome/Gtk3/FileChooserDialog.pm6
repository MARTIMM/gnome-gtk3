#TL:1:Gnome::Gtk3::FileChooserDialog:

# fix to at least 6.d because of use of variable args list
use v6.d;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::FileChooserDialog

![](images/filechooser.png)

=SUBTITLE A file chooser dialog, suitable for “File/Open” or “File/Save” commands

=head1 Description

I<Gnome::Gtk3::FileChooserDialog> is a dialog box suitable for use with “File/Open” or “File/Save as” commands. This widget works by putting a I<Gnome::Gtk3::FileChooserWidget> inside a I<Gnome::Gtk3::Dialog>. It exposes the I<Gnome::Gtk3::FileChooser> interface, so you can use all of the I<Gnome::Gtk3::FileChooser> functions on the file chooser dialog as well as those for I<Gnome::Gtk3::Dialog>.

Note that I<Gnome::Gtk3::FileChooserDialog> does not have any methods of its own. Instead, you should use the functions that work on a I<Gnome::Gtk3::FileChooser>.

If you want to integrate well with the platform you should use the I<Gnome::Gtk3::FileChooserNative> API, which will use a platform-specific dialog if available and fall back to B<Gnome::Gtk3::FileChooserDialog> otherwise.

=begin comment
=head2 Typical usage

In the simplest of cases, you can the following code to use I<Gnome::Gtk3::FileChooserDialog> to select a file for opening:

|[
B<Gnome::Gtk3::Widget> *dialog;
B<Gnome::Gtk3::FileChooserAction> action = GTK_FILE_CHOOSER_ACTION_OPEN;
gint res;

dialog = gtk_file_chooser_dialog_new ("Open File",
                                      parent_window,
                                      action,
                                      _("_Cancel"),
                                      GTK_RESPONSE_CANCEL,
                                      _("_Open"),
                                      GTK_RESPONSE_ACCEPT,
                                      NULL);

res = gtk_dialog_run (GTK_DIALOG (dialog));
if (res == GTK_RESPONSE_ACCEPT)
  {
    char *filename;
    B<Gnome::Gtk3::FileChooser> *chooser = GTK_FILE_CHOOSER (dialog);
    filename = gtk_file_chooser_get_filename (chooser);
    open_file (filename);
    g_free (filename);
  }

gtk_widget_destroy (dialog);
]|

To use a dialog for saving, you can use this:

|[
B<Gnome::Gtk3::Widget> *dialog;
B<Gnome::Gtk3::FileChooser> *chooser;
B<Gnome::Gtk3::FileChooserAction> action = GTK_FILE_CHOOSER_ACTION_SAVE;
gint res;

dialog = gtk_file_chooser_dialog_new ("Save File",
                                      parent_window,
                                      action,
                                      _("_Cancel"),
                                      GTK_RESPONSE_CANCEL,
                                      _("_Save"),
                                      GTK_RESPONSE_ACCEPT,
                                      NULL);
chooser = GTK_FILE_CHOOSER (dialog);

gtk_file_chooser_set_do_overwrite_confirmation (chooser, TRUE);

if (user_edited_a_new_document)
  gtk_file_chooser_set_current_name (chooser,
                                     _("Untitled document"));
else
  gtk_file_chooser_set_filename (chooser,
                                 existing_filename);

res = gtk_dialog_run (GTK_DIALOG (dialog));
if (res == GTK_RESPONSE_ACCEPT)
  {
    char *filename;

    filename = gtk_file_chooser_get_filename (chooser);
    save_to_file (filename);
    g_free (filename);
  }

gtk_widget_destroy (dialog);
]|
=end comment

=head2 Setting up a file chooser dialog

There are various cases in which you may need to use a I<Gnome::Gtk3::FileChooserDialog>:

- To select a file for opening. Use I<GTK_FILE_CHOOSER_ACTION_OPEN>.

- To save a file for the first time. Use I<GTK_FILE_CHOOSER_ACTION_SAVE>, and suggest a name such as “Untitled” with C<gtk_file_chooser_set_current_name()>.

- To save a file under a different name. Use I<GTK_FILE_CHOOSER_ACTION_SAVE>, and set the existing filename with C<gtk_file_chooser_set_filename()>.

- To choose a folder instead of a file. Use I<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER>.

Note that old versions of the file chooser’s documentation suggested using C<gtk_file_chooser_set_current_folder()> in various situations, with the intention of letting the application suggest a reasonable default folder.  This is no longer considered to be a good policy, as now the file chooser is able to make good suggestions on its own. In general, you should only cause the file chooser to show a specific folder when it is appropriate to use C<gtk_file_chooser_set_filename()>, i.e. when you are doing a Save As command and you already have a file saved somewhere.

=begin comment
=head2 Response Codes

I<Gnome::Gtk3::FileChooserDialog> inherits from I<Gnome::Gtk3::Dialog>, so buttons that go in its action area have response codes such as I<GTK_RESPONSE_ACCEPT> and I<GTK_RESPONSE_CANCEL>. For example, you could call C<gtk_file_chooser_dialog_new()> as follows:

|[
B<Gnome::Gtk3::Widget> *dialog;
B<Gnome::Gtk3::FileChooserAction> action = GTK_FILE_CHOOSER_ACTION_OPEN;

dialog = gtk_file_chooser_dialog_new ("Open File",
                                      parent_window,
                                      action,
                                      _("_Cancel"),
                                      GTK_RESPONSE_CANCEL,
                                      _("_Open"),
                                      GTK_RESPONSE_ACCEPT,
                                      NULL);
]|

This will create buttons for “Cancel” and “Open” that use stock
response identifiers from I<Gnome::Gtk3::ResponseType>.  For most dialog
boxes you can use your own custom response codes rather than the
ones in I<Gnome::Gtk3::ResponseType>, but I<Gnome::Gtk3::FileChooserDialog> assumes that
its “accept”-type action, e.g. an “Open” or “Save” button,
will have one of the following response codes:

- I<GTK_RESPONSE_ACCEPT>
- I<GTK_RESPONSE_OK>
- I<GTK_RESPONSE_YES>
- I<GTK_RESPONSE_APPLY>

This is because I<Gnome::Gtk3::FileChooserDialog> must intercept responses
and switch to folders if appropriate, rather than letting the
dialog terminate — the implementation uses these known
response codes to know which responses can be blocked if
appropriate.

To summarize, make sure you use a
[stock response code][gtkfilechooserdialog-responses]
when you use I<Gnome::Gtk3::FileChooserDialog> to ensure proper operation.
=end comment


=head2 See Also

I<Gnome::Gtk3::FileChooser>, I<Gnome::Gtk3::Dialog>, B<Gnome::Gtk3::FileChooserNative>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::FileChooserDialog;
  also is Gnome::Gtk3::Dialog;

=head2 Example

  use Gnome::Gtk3::Dialog;
  use Gnome::Gtk3::FileChooserDialog;

  my Gnome::Gtk3::FileChooserDialog $fchoose .= new(:build-id<save-dialog>);

  # show the dialog
  my Int $response = $fchoose.gtk-dialog-run;
  if $response == GTK_RESPONSE_ACCEPT {
    ...
  }

  # when dialog buttons are pressed hide it again
  $fchoose.hide;

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::FileChooser;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilechooserdialog.h
# https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
unit class Gnome::Gtk3::FileChooserDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;
#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new


=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

=end pod

#TM:0:new(:):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::FileChooserDialog';

  # process all named arguments
  if %options<action>.defined {
    my @buttons = %options<button-spec>;
    my N-GObject $parent = %options<parent> ~~ N-GObject
                        ?? %options<parent>
                        !! %options<parent>();

    self.native-gobject(
      gtk_file_chooser_dialog_new(
        %options<title>, $parent, %options<action>, @buttons
      )
    );
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
  self.set-class-info('GtkFileChooserDialog');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  # search this module first
  try { $s = &::($native-sub); }
#  try { $s = &::("gtk_file_chooser_dialog_$native-sub"); } unless ?$s;

  # search in the interface module
  if !$s {
    my Gnome::Gtk3::FileChooser $fc .= new(:widget(self.native-gobject));
    $s = $fc._interface($native-sub);
  }

  # any other parent class
  $s = callsame unless ?$s;

  # return result
  $s;
}

#`{{
#-------------------------------------------------------------------------------
# mail example variable lists
# Vittore Scolari
sub pera-int-f(Str $format, *@args) {
    state $ptr = cglobal(Str, "printf", Pointer);
    my $signature = Signature.new(
        params => (
            Parameter.new(type => Str),
            |(@args.map: { Parameter.new(type => .WHAT) })
        ),

        returns => int32
    );

    my &f = nativecast($signature, $ptr);
    f($format, |@args)
}

pera-int-f("Pera + Mela = %d + %d %s\n", 25, 12, "cippas");
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_dialog_new:
=begin pod
=head2 gtk_file_chooser_dialog_new

Creates a new file chooser dialog. This function is analogous to C<gtk_dialog_new_with_buttons()>.

Returns: a new native file chooser dialog.

Since: 2.4

  method gtk_file_chooser_dialog_new (
    Str $title, N-GObject $parent, GtkFileChooserAction $action,
    *@buttons-spec
    --> N-GObject
  )

=item Str $title; Title of the dialog, or C<Any>.
=item N-GObject $parent; Transient parent of the dialog, or C<Any>.
=item GtkFileChooserAction $action; Open or save mode for the dialog.

=item *@buttons-spec is a list button specifications. The list has an even number of members of which;
=item2 Str $button-label to go on the button.
=item2 GtkResponseType $response-code to return for the button.

=end pod

sub gtk_file_chooser_dialog_new (
  Str $title, N-GObject $parent, GtkFileChooserAction $action, *@buttons
#  --> N-GObject
) {

  # create parameter list and start with inserting fixed arguments
  my @parameterList = (
    Parameter.new(type => Str),         # $title
    Parameter.new(type => N-GObject),   # $parent
    Parameter.new(type => int32),       # $action
  );

  # check the button list parameters
  my CArray $native-bspec .= new;
  if @buttons.elems %% 2 {
    for @buttons -> Str $button-text, GtkResponseType $response-code {
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

note "S: ", $signature;

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that te sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_file_chooser_dialog_new', Pointer);
  my Callable $f = nativecast( $signature, $ptr);
note "F: ", $f.perl;
  $f( $title, $parent, $action, |@buttons, Pointer)
}




















=finish

# ==============================================================================
=begin pod

=head1 Methods

=head2 [gtk_file_chooser_] dialog_new_two_buttons

  method gtk_file_chooser_dialog_new_two_buttons (
    Str $title, N-GObject $parent-window, int32 $file-chooser-action,
    Str $first_button_text, int32 $first-button-response,
    Str $secnd-button-text, int32 $secnd-button-response,
    OpaquePointer $stopper
    --> N-GObject
  )

Creates a new filechooser dialog widget. It returns a native object which must be stored in another object. Better, shorter and easier is to use C<.new(....)>. See info below.
=end pod





sub gtk_file_chooser_dialog_new_two_buttons (
  Str $title, N-GObject $parent-window, int32 $file-chooser-action,
  Str $first-button-text, int32 $first-button-response,
  Str $secnd-button-text, int32 $secnd-button-response,
  OpaquePointer $stopper
) returns N-GObject       # GtkFileChooserDialog
  is native(&gtk-lib)
  is symbol("gtk_file_chooser_dialog_new")
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=begin pod
=head2 new

  multi method new ( Str :$title! )

Create a filechooser dialog with given title. There will be only two buttons
C<:bt1text> and C<:bt2text>. These are by default C<Cancel> and C<Accept>.
There response types are given by  C<:bt1response> and C<:bt2response>.
Defaults for these are C<GTK_RESPONSE_CANCEL> and C<GTK_RESPONSE_ACCEPT>
respectively.

The filechooser action is set with C<:action> which has C<GTK_FILE_CHOOSER_ACTION_OPEN> as its default.

The parent window is set by C<:window> and is by default C<Any>.

The values are defined in C<Gnome::Gtk3::Dialog> and C<GtkFileChooser>.

  multi method new ( :$widget! )

Create a filechooser dialog using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create a filechooser dialog using a native object from a builder. See also Gnome::GObject::Object.

=end pod
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::FileChooserDialog';

  if ? %options<title> {
    self.native-gobject(
      gtk_file_chooser_dialog_new_two_buttons(
        %options<title>, %options<window>//Any,
        %options<action>//GTK_FILE_CHOOSER_ACTION_OPEN,
        %options<bt1text>//'Cancel',
        %options<bt1response>//GTK_RESPONSE_CANCEL,
        %options<bt2text>//'Accept',
        %options<bt2response>//GTK_RESPONSE_ACCEPT,
        Any
      )
    );
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
}
