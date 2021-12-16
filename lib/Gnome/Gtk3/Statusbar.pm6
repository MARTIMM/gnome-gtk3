#TL:1:Gnome::Gtk3::Statusbar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Statusbar

Report messages of minor importance to the user

![](images/statusbar.png)

=head1 Description

A B<Gnome::Gtk3::Statusbar> is usually placed along the bottom of an application's main B<Gnome::Gtk3::Window>. It may provide a regular commentary of the application's status (as is usually the case in a web browser, for example), or may be used to simply output a message when the status changes, (when an upload is complete in an FTP client, for example).

Status bars in GTK+ maintain a stack of messages. The message at the top of each bar’s stack is the one that will currently be displayed.

Any messages added to a statusbar’s stack must specify a context id that is used to uniquely identify the source of a message. This context id can be generated by C<.gtk_statusbar_get_context_id()>, given a message and the statusbar that it will be added to. Note that messages are stored in a stack, and when choosing which message to display, the stack structure is adhered to, regardless of the context identifier of a message.

One could say that a statusbar maintains one stack of messages for display purposes, but allows multiple message producers to maintain sub-stacks of the messages they produced (via context ids).

Status bars are created using C<.new()>.

Messages are added to the bar’s stack with C<.gtk_statusbar_push()>.

The message at the top of the stack can be removed using C<.gtk_statusbar_pop()>. A message can be removed from anywhere in the stack if its message id was recorded at the time it was added. This is done using C<.gtk_statusbar_remove()>.


=head2 CSS node

=item B<Gnome::Gtk3::Statusbar> has a single CSS node with name statusbar.



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Statusbar;
  also is Gnome::Gtk3::Box;


=head2 Uml Diagram

![](plantuml/Statusbar.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Statusbar;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Statusbar;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Statusbar class process the options
    self.bless( :GtkStatusbar, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Statusbar:auth<github:MARTIMM>:ver<0.2.0>;
also is Gnome::Gtk3::Box;
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::Statusbar> ready for messages.

  multi method new ( )

=begin comment
Create a StatusBar object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a StatusBar object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<text-pushed text-popped>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Statusbar' or %options<GtkStatusbar> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing
          if $no.^can('_get-native-object-no-reffing');
        #$no = _gtk_statusbar_new___x___($no);
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

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_statusbar_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkStatusbar');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_statusbar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkStatusbar');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:get-context-id:
=begin pod
=head2 get-context-id

Returns a new context identifier, given a description of the actual context. Note that the description is not shown in the UI.

Returns: an integer id

  method get-context-id ( Str $context_description --> UInt )

=item Str $context_description; textual description of what context  the new message is being used in
=end pod

method get-context-id ( Str $context_description --> UInt ) {

  gtk_statusbar_get_context_id(
    self._f('GtkStatusbar'), $context_description
  )
}

sub gtk_statusbar_get_context_id (
  N-GObject $statusbar, gchar-ptr $context_description --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-message-area:
#TM:1:get-message-area-rk:
=begin pod
=head2 get-message-area, get-message-area-rk

Retrieves the box containing the label widget.

Returns: a B<Gnome::Gtk3::Box>

  method get-message-area ( --> N-GObject )
  method get-message-area-rk ( :$child-type? --> Gnome::Gtk3::Box )

=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.

=end pod

method get-message-area ( --> N-GObject ) {
  gtk_statusbar_get_message_area(self._f('GtkStatusbar'))
}

method get-message-area-rk ( *%options --> Gnome::Gtk3::Box ) {
  self._wrap-native-type-from-no(
    gtk_statusbar_get_message_area(self._f('GtkStatusbar')),
    |%options
  )
}

sub gtk_statusbar_get_message_area (
  N-GObject $statusbar --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pop:
=begin pod
=head2 pop

Removes the first message in the B<Gnome::Gtk3::Statusbar>’s stack with the given context id.

Note that this may not change the displayed message, if the message at the top of the stack has a different context id.

  method pop ( UInt $context_id )

=item UInt $context_id; a context identifier
=end pod

method pop ( UInt $context_id ) {
  gtk_statusbar_pop( self._f('GtkStatusbar'), $context_id);
}

sub gtk_statusbar_pop (
  N-GObject $statusbar, guint $context_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:push:
=begin pod
=head2 push

Pushes a new message onto a statusbar’s stack.

Returns: a message id that can be used with C<remove()>.

  method push ( UInt $context_id, Str $text --> UInt )

=item UInt $context_id; the message’s context id, as returned by C<get-context-id()>
=item Str $text; the message to add to the statusbar
=end pod

method push ( UInt $context_id, Str $text --> UInt ) {
  gtk_statusbar_push( self._f('GtkStatusbar'), $context_id, $text)
}

sub gtk_statusbar_push (
  N-GObject $statusbar, guint $context_id, gchar-ptr $text --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove:
=begin pod
=head2 remove

Forces the removal of a message from a statusbar’s stack. The exact I<context-id> and I<message-id> must be specified.

  method remove ( UInt $context_id, UInt $message_id )

=item UInt $context_id; a context identifier
=item UInt $message_id; a message identifier, as returned by C<push()>
=end pod

method remove ( UInt $context_id, UInt $message_id ) {
  gtk_statusbar_remove( self._f('GtkStatusbar'), $context_id, $message_id);
}

sub gtk_statusbar_remove (
  N-GObject $statusbar, guint $context_id, guint $message_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-all:
=begin pod
=head2 remove-all

Forces the removal of all messages from a statusbar's stack with the exact I<context-id>.

  method remove-all ( UInt $context_id )

=item UInt $context_id; a context identifier
=end pod

method remove-all ( UInt $context_id ) {
  gtk_statusbar_remove_all( self._f('GtkStatusbar'), $context_id);
}

sub gtk_statusbar_remove_all (
  N-GObject $statusbar, guint $context_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_statusbar_new:
#`{{
=begin pod
=head2 _gtk_statusbar_new

Creates a new B<Gnome::Gtk3::Statusbar> ready for messages.

Returns: the new B<Gnome::Gtk3::Statusbar>

  method _gtk_statusbar_new ( --> N-GObject )

=end pod
}}

sub _gtk_statusbar_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_statusbar_new')
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
=comment #TS:1:text-popped:
=head3 text-popped

Is emitted whenever a new message is popped off a statusbar's stack.

  method handler (
    UInt $context_id,
    Str $text,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($statusbar),
    *%user-options
    --> Int
  );

=item $statusbar; the object which received the signal

=item $context_id; the context id of the relevant message/statusbar

=item $text; the message that was just popped

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:1:text-pushed:
=head3 text-pushed

Is emitted whenever a new message gets pushed onto a statusbar's stack.

  method handler (
    UInt $context_id,
    Str $text,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($statusbar),
    *%user-options
    --> Int
  );

=item $statusbar; the object which received the signal

=item $context_id; the context id of the relevant message/statusbar

=item $text; the message that was pushed

=item $_handle_id; the registered event handler id

=end pod
