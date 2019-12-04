#TL:1:Gnome::Gtk3::SearchEntry:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::SearchEntry

An entry which shows a search icon

![](images/search-entry.png)

=head1 Description


B<Gnome::Gtk3::SearchEntry> is a subclass of B<Gnome::Gtk3::Entry> that has been
tailored for use as a search entry.

It will show an inactive symbolic “find” icon when the search
entry is empty, and a symbolic “clear” icon when there is text.
Clicking on the “clear” icon will empty the search entry.

Note that the search/clear icon is shown using a secondary
icon, and thus does not work if you are using the secondary
icon position for some other purpose.

To make filtering appear more reactive, it is a good idea to
not react to every change in the entry text immediately, but
only after a short delay. To support this, B<Gnome::Gtk3::SearchEntry>
emits the  I<search-changed> signal which can
be used instead of the  I<changed> signal.

The  I<previous-match>,  I<next-match>
and  I<stop-search> signals can be used to implement
moving between search results and ending the search.

Often, B<Gnome::Gtk3::SearchEntry> will be fed events by means of being
placed inside a B<Gnome::Gtk3::SearchBar>. If that is not the case,
you can use C<gtk_search_entry_handle_event()> to pass events.

Since: 3.6



=head2 Implemented Interfaces

Gnome::Gtk3::SearchEntry implements

=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item Gnome::Gtk3::Editable
=item Gnome::Gtk3::CellEditable

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::SearchEntry;
  also is Gnome::Gtk3::Entry;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Entry;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtksearchentry.h
# https://developer.gnome.org/gtk3/stable/GtkSearchEntry.html
unit class Gnome::Gtk3::SearchEntry:auth<github:MARTIMM>;
also is Gnome::Gtk3::Entry;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<search-changed next-match previous-match stop-search>,
  ) unless $signals-added;


  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::SearchEntry';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_search_entry_new());
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
  self.set-class-info('GtkSearchEntry');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_search_entry_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkSearchEntry');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_search_entry_new:new(:empty)
=begin pod
=head2 [gtk_] search_entry_new

Creates a B<Gnome::Gtk3::SearchEntry>, with a find icon when the search field is
empty, and a clear icon when it isn't.

Returns: a new B<Gnome::Gtk3::SearchEntry>

Since: 3.6

  method gtk_search_entry_new ( --> N-GObject  )


=end pod

sub gtk_search_entry_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_search_entry_handle_event:
=begin pod
=head2 [[gtk_] search_entry_] handle_event

This function should be called when the top-level window
which contains the search entry received a key event. If
the entry is part of a B<Gnome::Gtk3::SearchBar>, it is preferable
to call C<gtk_search_bar_handle_event()> instead, which will
reveal the entry in addition to passing the event to this
function.

If the key event is handled by the search entry and starts
or continues a search, C<GDK_EVENT_STOP> will be returned.
The caller should ensure that the entry is shown in this
case, and not propagate the event further.

Returns: C<GDK_EVENT_STOP> if the key press event resulted
in a search beginning or continuing, C<GDK_EVENT_PROPAGATE>
otherwise.

Since: 3.16

  method gtk_search_entry_handle_event ( GdkEvent $event --> Int  )

=item GdkEvent $event; a key event

=end pod

sub gtk_search_entry_handle_event ( N-GObject $entry, GdkEvent $event )
  returns int32
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


=comment #TS:0:search-changed:
=head3 search-changed

The  I<search-changed> signal is emitted with a short
delay of 150 milliseconds after the last change to the entry text.

Since: 3.10

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the entry on which the signal was emitted


=comment #TS:0:next-match:
=head3 next-match

The I<next-match> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a move to the next match
for the current search string.

Applications should connect to it, to implement moving between
matches.

The default bindings for this signal is Ctrl-g.

Since: 3.16

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the entry on which the signal was emitted


=comment #TS:0:previous-match:
=head3 previous-match

The I<previous-match> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a move to the previous match
for the current search string.

Applications should connect to it, to implement moving between
matches.

The default bindings for this signal is Ctrl-Shift-g.

Since: 3.16

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the entry on which the signal was emitted


=comment #TS:0:stop-search:
=head3 stop-search

The I<stop-search> signal is a keybinding signal
which gets emitted when the user stops a search via keyboard input.

Applications should connect to it, to implement hiding the search
entry in this case.

The default bindings for this signal is Escape.

Since: 3.16

  method handler (
    Gnome::GObject::Object :widget($entry),
    *%user-options
  );

=item $entry; the entry on which the signal was emitted


=end pod

























=finish
# ==============================================================================
sub gtk_search_entry_new ( )
  returns N-GObject       # GtkWidget
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<next-match previous-match search-changed stop-search>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::SearchEntry';

  if ? %options<empty> {
    self.native-gobject(gtk_search_entry_new());
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

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_search_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
