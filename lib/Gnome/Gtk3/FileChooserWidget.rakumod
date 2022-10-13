#TL:1:Gnome::Gtk3::FileChooserWidget:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::FileChooserWidget

A file chooser widget

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::FileChooserWidget> is a widget for choosing files. It exposes the B<Gnome::Gtk3::FileChooser> interface, and you should use the methods of this interface to interact with the widget.


=head2 Css Nodes

 * GtkFileChooserWidget has a single CSS node with name filechooser.


=head2 See Also

B<Gnome::Gtk3::FileChooserDialog>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::FileChooserWidget;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::FileChooser;


=head2 Uml Diagram

![](plantuml/FileChooserWidget.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::FileChooserWidget;

  unit class MyGuiClass;
  also is Gnome::Gtk3::FileChooserWidget;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::FileChooserWidget class process the options
    self.bless( :GtkFileChooserWidget, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Box;
use Gnome::Gtk3::FileChooser;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::FileChooserWidget:auth<github:MARTIMM>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::FileChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :action

Create a new FileChooserWidget object.

  multi method new (
    GtkFileChooserAction :$action! = GTK_FILE_CHOOSER_ACTION_OPEN
  )

=head3 :native-object

Create a FileChooserWidget object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a FileChooserWidget object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new(:action):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<location-popup quick-bookmark>, :w0<location-popup-on-paste location-toggle-popup up-folder down-folder home-folder desktop-folder show-hidden search-shortcut recent-shortcut places-shortcut>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::FileChooserWidget' #`{{ or %options<GtkFileChooserWidget> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my N-GObject() $no;
      if %options<action>:exists {
        $no = _gtk_file_chooser_widget_new(%options<action>);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_file_chooser_widget_new(GTK_FILE_CHOOSER_ACTION_OPEN);
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkFileChooserWidget');
  }
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_file_chooser_widget_new:
#`{{
=begin pod
=head2 _gtk_file_chooser_widget_new

Creates a new B<Gnome::Gtk3::FileChooserWidget>. This is a file chooser widget that can be embedded in custom windows, and it is the same widget that is used by B<Gnome::Gtk3::FileChooserDialog>.

Returns: a new B<Gnome::Gtk3::FileChooserWidget>

  method _gtk_file_chooser_widget_new ( GtkFileChooserAction $action --> N-GObject )

=item GtkFileChooserAction $action; Open or save mode for the widget
=end pod
}}

sub _gtk_file_chooser_widget_new ( GEnum $action --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_chooser_widget_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:desktop-folder:
=head2 desktop-folder

The I<desktop-folder> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show the user's Desktop
folder in the file list.

The default binding for this signal is `Alt + D`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:down-folder:
=head2 down-folder

The I<down-folder> signal is a keybinding signal which gets emitted when the user asks for it.

This is used to make the file chooser go to a child of the current folder
in the file hierarchy. The subfolder that will be used is displayed in the
path bar widget of the file chooser. For example, if the path bar is showing
"/foo/bar/baz", with bar currently displayed, then this will cause the file
chooser to switch to the "baz" subfolder.

The default binding for this signal is `Alt + Down`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:home-folder:
=head2 home-folder

The I<home-folder> signal is a keybinding signal which gets emitted when the user asks for it.

This is used to make the file chooser show the user's home
folder in the file list.

The default binding for this signal is `Alt + Home`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:location-popup:
=head2 location-popup

The I<location-popup> signal is a keybinding signal which gets emitted when the user asks for it.

This is used to make the file chooser show a "Location" prompt which
the user can use to manually type the name of the file he wishes to select.

The default bindings for this signal are `Control + L` with a I<path> string
of "" (the empty string).  It is also bound to `/` with a I<path> string of
"`/`" (a slash):  this lets you type `/` and immediately type a path name.
On Unix systems, this is bound to `~` (tilde) with a I<path> string of "~"
itself for access to home directories.

  method handler (
    Str $path,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path; a string that gets put in the text entry for the file name
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:location-popup-on-paste:
=head2 location-popup-on-paste

The I<location-popup-on-paste> signal is a keybinding signal which gets emitted when the user asks for it.

This is used to make the file chooser show a "Location" prompt when the user
pastes into a B<Gnome::Gtk3::FileChooserWidget>.

The default binding for this signal is `Control + V`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:location-toggle-popup:
=head2 location-toggle-popup

The I<location-toggle-popup> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to toggle the visibility of a "Location" prompt which the user
can use to manually type the name of the file he wishes to select.

The default binding for this signal is `Control + L`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:places-shortcut:
=head2 places-shortcut

The I<places-shortcut> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to move the focus to the places sidebar.

The default binding for this signal is `Alt + P`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:quick-bookmark:
=head2 quick-bookmark

The I<quick-bookmark> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to make the file chooser switch to the bookmark specified
in the I<bookmark_index> parameter. For example, if you have three bookmarks,
you can pass 0, 1, 2 to this signal to switch to each of them, respectively.

The default binding for this signal is `Alt + 1`, `Alt + 2`,
etc. until `Alt + 0`.  Note that in the default binding, that
`Alt + 1` is actually defined to switch to the bookmark at index
0, and so on successively; `Alt + 0` is defined to switch to the
bookmark at index 10.

  method handler (
    Int $bookmark_index,
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $bookmark_index; the number of the bookmark to switch to
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:recent-shortcut:
=head2 recent-shortcut

The I<recent-shortcut> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to make the file chooser show the Recent location.

The default binding for this signal is `Alt + R`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:search-shortcut:
=head2 search-shortcut

The I<search-shortcut> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to make the file chooser show the search entry.

The default binding for this signal is `Alt + S`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:show-hidden:
=head2 show-hidden

The I<show-hidden> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to make the file chooser display hidden files.

The default binding for this signal is `Control + H`.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:up-folder:
=head2 up-folder

The I<up-folder> signal is a keybinding signal
which gets emitted when the user asks for it.

This is used to make the file chooser go to the parent of the current folder
in the file hierarchy.

The default binding for this signal is `Alt + Up`.

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
=comment #TP:1:search-mode:
=head2 search-mode

Search mode

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:subtitle:
=head2 subtitle

Subtitle

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable.

=end pod
