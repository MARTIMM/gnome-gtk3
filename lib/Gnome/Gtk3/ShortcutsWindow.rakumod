#TL:1:Gnome::Gtk3::ShortcutsWindow:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ShortcutsWindow

Toplevel which shows help for shortcuts


![](images/ShortcutsWindow.png)


=head1 Description

A B<Gnome::Gtk3::ShortcutsWindow> shows brief information about the keyboard shortcuts and gestures of an application. The shortcuts can be grouped, and you can have multiple sections in this window, corresponding to the major modes of your application.

Additionally, the shortcuts can be filtered by the current view, to avoid showing information that is not relevant in the current application context.

The recommended way to construct a GtkShortcutsWindow is with GtkBuilder, by populating a B<Gnome::Gtk3::ShortcutsWindow> with one or more B<Gnome::Gtk3::ShortcutsSection> objects, which contain B<Gnome::Gtk3::ShortcutsGroups> that in turn contain objects of class B<Gnome::Gtk3::ShortcutsShortcut>.


=head2 A simple example:

![](images/gedit-shortcuts.png)

This example has as single section. As you can see, the shortcut groups are arranged in columns, and spread across several pages if there are too many to find on a single page.

The .ui file for this example can be found L<here|https://git.gnome.org/browse/gtk+/tree/demos/gtk-demo/shortcuts-gedit.ui>.


=head2 An example with multiple views:

![](images/clocks-shortcuts.png)

This example shows a B<Gnome::Gtk3::ShortcutsWindow> that has been configured to show only the shortcuts relevant to the "stopwatch" view.

The .ui file for this example can be found L<here|https://git.gnome.org/browse/gtk+/tree/demos/gtk-demo/shortcuts-clocks.ui>.


=head2 An example with multiple sections:

![](images/builder-shortcuts.png)

This example shows a B<Gnome::Gtk3::ShortcutsWindow> with two sections, "Editor Shortcuts" and "Terminal Shortcuts". The .ui file for this example can be found L<here|https://git.gnome.org/browse/gtk+/tree/demos/gtk-demo/shortcuts-builder.ui>.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::ShortcutsWindow;
  also is Gnome::Gtk3::Window;


=head2 Uml Diagram

![](plantuml/ShortcutsWindow.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ShortcutsWindow:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ShortcutsWindow;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ShortcutsWindow class process the options
    self.bless( :GtkShortcutsWindow, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::Gtk3::Window:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ShortcutsWindow:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Window;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a ShortcutsWindow object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ShortcutsWindow object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<close search>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ShortcutsWindow' #`{{  or %options<GtkShortcutsWindow> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_shortcuts_window_new___x___($no);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_shortcuts_window_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkShortcutsWindow');
  }
}


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
=comment #TS:1:close:
=head3 close

The I<close> signal is a keybinding signal which gets emitted when the user uses a keybinding to close the window.

The default binding for this signal is the Escape key.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($shortcutswindow),
    N-GObject :$_native-object,
    *%user-options
  );

=item $_handler-id; The handler id which is returned from the registration
=item $_widget; The instance which registered the signal
=item $_native-object; The native object provided by the caller wrapped in the Raku object.

=comment -----------------------------------------------------------------------
=comment #TS:1:search:
=head3 search

The I<search> signal is a keybinding signal which gets emitted when the user uses a keybinding to start a search.

The default binding for this signal is Control-F.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($shortcutswindow),
    N-GObject :$_native-object,
    *%user-options
  );

=item $_handler-id; The handler id which is returned from the registration
=item $_widget; The instance which registered the signal
=item $_native-object; The native object provided by the caller wrapped in the Raku object.

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
=comment #TP:1:section-name:
=head3 Section Name: section-name

The name of the section to show.

This should be the section-name of one of the B<Gnome::Gtk3::ShortcutsSection> objects that are in this shortcuts window.

The B<Gnome::GObject::Value> type of property I<section-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:view-name:
=head3 View Name: view-name

The view name by which to filter the contents.

This should correspond to the  I<view> property of some of the B<Gnome::Gtk3::ShortcutsGroup> objects that are inside this shortcuts window. Set this to C<undefined> to show all groups.

The B<Gnome::GObject::Value> type of property I<view-name> is C<G_TYPE_STRING>.
=end pod
