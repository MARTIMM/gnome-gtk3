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
unit class Gnome::Gtk3::FileChooserWidget:auth<github:MARTIMM>:ver<0.1.0>;
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

  multi method new ( GtkFileChooserAction :$action! )

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
      my $no;
      if ? %options<action> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_file_chooser_widget_new(%options<action>);
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

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_file_chooser_widget_new();
      }
      }}

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
=comment #TS:0:desktop-folder:
=head3 desktop-folder

The I<desktop-folder> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show the user's Desktop
folder in the file list.

The default binding for this signal is `Alt + D`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:down-folder:
=head3 down-folder

The I<down-folder> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser go to a child of the current folder
in the file hierarchy. The subfolder that will be used is displayed in the
path bar widget of the file chooser. For example, if the path bar is showing
"/foo/bar/baz", with bar currently displayed, then this will cause the file
chooser to switch to the "baz" subfolder.

The default binding for this signal is `Alt + Down`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:home-folder:
=head3 home-folder

The I<home-folder> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show the user's home
folder in the file list.

The default binding for this signal is `Alt + Home`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:location-popup:
=head3 location-popup

The I<location-popup> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show a "Location" prompt which
the user can use to manually type the name of the file he wishes to select.

The default bindings for this signal are `Control + L` with a I<path> string
of "" (the empty string).  It is also bound to `/` with a I<path> string of
"`/`" (a slash):  this lets you type `/` and immediately type a path name.
On Unix systems, this is bound to `~` (tilde) with a I<path> string of "~"
itself for access to home directories.

  method handler (
    Str $path,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $path; a string that gets put in the text entry for the file name

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:location-popup-on-paste:
=head3 location-popup-on-paste

The I<location-popup-on-paste> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show a "Location" prompt when the user
pastes into a B<Gnome::Gtk3::FileChooserWidget>.

The default binding for this signal is `Control + V`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:location-toggle-popup:
=head3 location-toggle-popup

The I<location-toggle-popup> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to toggle the visibility of a "Location" prompt which the user
can use to manually type the name of the file he wishes to select.

The default binding for this signal is `Control + L`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:places-shortcut:
=head3 places-shortcut

The I<places-shortcut> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to move the focus to the places sidebar.

The default binding for this signal is `Alt + P`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:quick-bookmark:
=head3 quick-bookmark

The I<quick-bookmark> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser switch to the bookmark specified
in the I<bookmark-index> parameter. For example, if you have three bookmarks,
you can pass 0, 1, 2 to this signal to switch to each of them, respectively.

The default binding for this signal is `Alt + 1`, `Alt + 2`,
etc. until `Alt + 0`.  Note that in the default binding, that
`Alt + 1` is actually defined to switch to the bookmark at index
0, and so on successively; `Alt + 0` is defined to switch to the
bookmark at index 10.

  method handler (
    Int $bookmark_index,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $bookmark_index; the number of the bookmark to switch to

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:recent-shortcut:
=head3 recent-shortcut

The I<recent-shortcut> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show the Recent location.

The default binding for this signal is `Alt + R`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:search-shortcut:
=head3 search-shortcut

The I<search-shortcut> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser show the search entry.

The default binding for this signal is `Alt + S`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:show-hidden:
=head3 show-hidden

The I<show-hidden> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser display hidden files.

The default binding for this signal is `Control + H`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:up-folder:
=head3 up-folder

The I<up-folder> signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user asks for it.

This is used to make the file chooser go to the parent of the current folder
in the file hierarchy.

The default binding for this signal is `Alt + Up`.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

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
=comment #TP:1:search-mode:
=head3 Search mode: search-mode

Search mode
Default value: False

The B<Gnome::GObject::Value> type of property I<search-mode> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:subtitle:
=head3 Subtitle: subtitle

Subtitle
Default value:

The B<Gnome::GObject::Value> type of property I<subtitle> is C<G_TYPE_STRING>.
=end pod
