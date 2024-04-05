#TL:1:Gnome::Gtk3::FileChooserButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::FileChooserButton

A button to launch a file selection dialog

![](images/file-button.png)


=head1 Description

The B<Gnome::Gtk3::FileChooserButton> is a widget that lets the user select a file.  It implements the B<Gnome::Gtk3::FileChooser> interface.  Visually, it is a file name with a button to bring up a B<Gnome::Gtk3::FileChooserDialog>. The user can then use that dialog to change the file associated with that button.  This widget does not support setting the I<select-multiple> property to C<1>.

The B<Gnome::Gtk3::FileChooserButton> supports the B<GtkFileChooserAction>s (from B<Gnome::Gtk3::FileChooser>) C<GTK_FILE_CHOOSER_ACTION_OPEN> and C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER>.

The B<Gnome::Gtk3::FileChooserButton> will ellipsize the label, and will thus request little horizontal space.  To give the button more space, you should call C<gtk_widget_get_preferred_size()>, C<gtk_file_chooser_button_set_width_chars()>, or pack the button in such a way that other interface elements give space to the widget.


=head2 Css Nodes

B<Gnome::Gtk3::FileChooserButton> has a CSS node with name “filechooserbutton”, containing a subnode for the internal button with name “button” and style class “.file”.


=head2 See Also

B<Gnome::Gtk3::FileChooserDialog>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::FileChooserButton;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::FileChooser;


=comment head2 Uml Diagram

![](plantuml/FileChooserButton.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::FileChooserButton:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::FileChooserButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::FileChooserButton class process the options
    self.bless( :GtkFileChooserButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

Create a button to let the user select a file in /etc

  use Gnome::Gtk3::FileChooser:api<1>;
  use Gnome::Gtk3::FileChooserButton:api<1>;

  my Gnome::Gtk3::FileChooserButton $button .= new(
    :title('Select a file'), :action(GTK_FILE_CHOOSER_ACTION_OPEN)
  );
  $button.set-current-folder("/etc");

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Box:api<1>;
use Gnome::Gtk3::FileChooser:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::FileChooserButton:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::FileChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 new( :title, :action)

Create a new FileChooserButton object.

  multi method new (
    Str :$title!, GtkFileChooserAction,
    GtkFileChooserAction :$action = GTK_FILE_CHOOSER_ACTION_OPEN
  )

=begin comment
=head3 new(:dialog)

Creates a B<Gnome::Gtk3::FileChooserButton> widget which uses I<dialog> as its file-picking window.  Note that I<dialog> must be a B<Gnome::Gtk3::Dialog> (or subclass) which implements the B<Gnome::Gtk3::FileChooser> interface and must not have C<GTK_DIALOG_DESTROY_WITH_PARENT> set.  Also note that the dialog needs to have its confirmative button added with response C<GTK_RESPONSE_ACCEPT> or C<GTK_RESPONSE_OK> in order for the button to take over the file selected in the dialog.

  multi method new ( N-GObject :$dialog! )
=end comment

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:title,:action):
#TM:0:new(:dialog):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<file-set>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
    self._add_file_chooser_signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::FileChooserButton' or
     %options<GtkFileChooserButton> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<title> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing
        #  if $no.^can('_get-native-object-no-reffing');
        my $action = %options<action> // GTK_FILE_CHOOSER_ACTION_OPEN;
        $no = _gtk_file_chooser_button_new( %options<title>, $action.value);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_file_chooser_button_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkFileChooserButton');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_file_chooser_button_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_file_chooser_button_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('file-chooser-button-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-file-chooser-button-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  # then in interfaces
  $s = self._file_chooser_interface($native-sub) unless ?$s;

  self._set-class-name-of-sub('GtkFileChooserButton');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:get-title:
=begin pod
=head2 get-title

Retrieves the title of the browse dialog used by I<button>. The returned value should not be modified or freed.

Returns: a pointer to the browse dialog’s title.

  method get-title ( --> Str )

=end pod

method get-title ( --> Str ) {
  gtk_file_chooser_button_get_title( self._get-native-object-no-reffing)
}

sub gtk_file_chooser_button_get_title (
  N-GObject $button --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-width-chars:
=begin pod
=head2 get-width-chars

Retrieves the width in characters of the I<button> widget’s entry and/or label.

Returns: an integer width (in characters) that the button will use to size itself.

  method get-width-chars ( --> Int )

=end pod

method get-width-chars ( --> Int ) {
  gtk_file_chooser_button_get_width_chars( self._get-native-object-no-reffing)
}

sub gtk_file_chooser_button_get_width_chars (
  N-GObject $button --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-title:
=begin pod
=head2 set-title

Modifies the I<title> of the browse dialog used by I<button>.

  method set-title ( Str $title )

=item $title; the new browse dialog title.
=end pod

method set-title ( Str $title ) {
  gtk_file_chooser_button_set_title( self._get-native-object-no-reffing, $title);
}

sub gtk_file_chooser_button_set_title (
  N-GObject $button, gchar-ptr $title
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-width-chars:
=begin pod
=head2 set-width-chars

Sets the width (in characters) that I<button> will use to I<n_chars>.

  method set-width-chars ( Int() $n_chars )

=item $n_chars; the new width, in characters.
=end pod

method set-width-chars ( Int() $n_chars ) {
  gtk_file_chooser_button_set_width_chars( self._get-native-object-no-reffing, $n_chars);
}

sub gtk_file_chooser_button_set_width_chars (
  N-GObject $button, gint $n_chars
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_file_chooser_button_new:
#`{{
=begin pod
=head2 _gtk_file_chooser_button_new

Creates a new file-selecting button widget.

Returns: a new button widget.

  method _gtk_file_chooser_button_new ( Str $title, GtkFileChooserAction $action --> N-GObject )

=item $title; the title of the browse dialog.
=item $action; the open mode for the widget.
=end pod
}}

sub _gtk_file_chooser_button_new ( gchar-ptr $title, GEnum $action --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_chooser_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_file_chooser_button_new_with_dialog:
#`{{
=begin pod
=head2 _gtk_file_chooser_button_new_with_dialog

Creates a B<Gnome::Gtk3::FileChooserButton> widget which uses I<dialog> as its file-picking window.

Note that I<dialog> must be a B<Gnome::Gtk3::Dialog> (or subclass) which implements the B<Gnome::Gtk3::FileChooser> interface and must not have C<GTK_DIALOG_DESTROY_WITH_PARENT> set.

Also note that the dialog needs to have its confirmative button added with response C<GTK_RESPONSE_ACCEPT> or C<GTK_RESPONSE_OK> in order for the button to take over the file selected in the dialog.

Returns: a new button widget.

  method _gtk_file_chooser_button_new_with_dialog ( N-GObject() $dialog --> N-GObject )

=item $dialog; (type Gtk.Dialog): the widget to use as dialog
=end pod
}}

sub _gtk_file_chooser_button_new_with_dialog ( N-GObject $dialog --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_chooser_button_new_with_dialog')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:file-set:
=head2 file-set

The I<file-set> signal is emitted when the user selects a file.

Note that this signal is only emitted when the user
changes the file.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:dialog:
=head2 dialog

The file chooser dialog to use.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_FILE_CHOOSER
=item Parameter is writable.
=item Parameter is set on construction of object.


=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head2 title

The title of the file chooser dialog.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is _(DEFAULT_TITLE.


=comment -----------------------------------------------------------------------
=comment #TP:1:width-chars:
=head2 width-chars

The desired width of the button widget, in characters.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.

=end pod




































=finish

#-------------------------------------------------------------------------------
#TM:1:_gtk_file_chooser_button_new:
#`{{
=begin pod
=head2 [gtk_] file_chooser_button_new

Creates a new file-selecting button widget.

Returns: a new button widget.

  method gtk_file_chooser_button_new ( Str $title, GtkFileChooserAction $action --> N-GObject )

=item Str $title; the title of the browse dialog.
=item GtkFileChooserAction $action; the open mode for the widget.

=end pod
}}

sub _gtk_file_chooser_button_new ( Str $title, int32 $action --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_chooser_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_file_chooser_button_new_with_dialog:
#`{{
=begin pod
=head2 [[gtk_] file_chooser_button_] new_with_dialog

Creates a B<Gnome::Gtk3::FileChooserButton> widget which uses I<dialog> as its file-picking window.  Note that I<dialog> must be a B<Gnome::Gtk3::Dialog> (or subclass) which implements the B<Gnome::Gtk3::FileChooser> interface and must not have C<GTK_DIALOG_DESTROY_WITH_PARENT> set.  Also note that the dialog needs to have its confirmative button added with response C<GTK_RESPONSE_ACCEPT> or C<GTK_RESPONSE_OK> in order for the button to take over the file selected in the dialog.

Returns: a new button widget.

  method gtk_file_chooser_button_new_with_dialog ( N-GObject $dialog --> N-GObject )

=item N-GObject $dialog; (type B<Gnome::Gtk3::.Dialog>): the widget to use as dialog

=end pod
}}

sub _gtk_file_chooser_button_new_with_dialog ( N-GObject $dialog --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_chooser_button_new_with_dialog')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_file_chooser_button_get_title:
=begin pod
=head2 [[gtk_] file_chooser_button_] get_title

Retrieves the title of the browse dialog used by I<button>. The returned value should not be modified or freed.

Returns: a pointer to the browse dialog’s title.

  method gtk_file_chooser_button_get_title ( --> Str )


=end pod

sub gtk_file_chooser_button_get_title ( N-GObject $button --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_file_chooser_button_set_title:
=begin pod
=head2 [[gtk_] file_chooser_button_] set_title

Modifies the I<title> of the browse dialog used by I<button>.

  method gtk_file_chooser_button_set_title ( Str $title )

=item Str $title; the new browse dialog title.

=end pod

sub gtk_file_chooser_button_set_title ( N-GObject $button, Str $title  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_button_get_width_chars:
=begin pod
=head2 [[gtk_] file_chooser_button_] get_width_chars

Retrieves the width in characters of the I<button> widget’s entry and/or label.

Returns: an integer width (in characters) that the button will use to size itself.

  method gtk_file_chooser_button_get_width_chars ( --> Int )


=end pod

sub gtk_file_chooser_button_get_width_chars ( N-GObject $button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_button_set_width_chars:
=begin pod
=head2 [[gtk_] file_chooser_button_] set_width_chars

Sets the width (in characters) that I<button> will use to I<n_chars>.

  method gtk_file_chooser_button_set_width_chars ( Int $n_chars )

=item Int $n_chars; the new width, in characters.

=end pod

sub gtk_file_chooser_button_set_width_chars ( N-GObject $button, int32 $n_chars  )
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


=comment #TS:0:file-set:
=head3 file-set

The I<file-set> signal is emitted when the user selects a file.

Note that this signal is only emitted when the user
changes the file.

Since: 2.12

  method handler (
    Int :$_handle_id,
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

=comment #TP:0:dialog:
=head3 Dialog

Instance of the B<Gnome::Gtk3::FileChooserDialog> associated with the button.
Widget type: GTK_TYPE_FILE_CHOOSER

The B<Gnome::GObject::Value> type of property I<dialog> is C<G_TYPE_OBJECT>.


=comment #TP:1:title:
=head3 Title

Title to put on the B<Gnome::Gtk3::FileChooserDialog> associated with the button.

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.


=comment #TP:0:width-chars:
=head3 Width In Characters


The width of the entry and label inside the button, in characters.

The B<Gnome::GObject::Value> type of property I<width-chars> is C<G_TYPE_INT>.
=end pod
