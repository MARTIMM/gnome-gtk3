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

![](plantuml/StatusBar.svg)


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
use Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Statusbar:auth<github:MARTIMM>;
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
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');
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

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkStatusbar');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_statusbar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkStatusbar');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_statusbar_new:new()
#`{{
=begin pod
=head2 [gtk_] statusbar_new

Creates a new B<Gnome::Gtk3::Statusbar> ready for messages.

Returns: the new B<Gnome::Gtk3::Statusbar>

  method gtk_statusbar_new ( --> N-GObject )

=end pod
}}
sub _gtk_statusbar_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_statusbar_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_get_context_id:
=begin pod
=head2 [[gtk_] statusbar_] get_context_id

Returns a new context identifier, given a description of the actual context. Note that the description is not shown in the UI.

Returns: an integer id

  method gtk_statusbar_get_context_id ( Str $context_description --> UInt )

=item Str $context_description; textual description of what context the new message is being used in

=end pod

sub gtk_statusbar_get_context_id ( N-GObject $statusbar, Str $context_description --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_push:
=begin pod
=head2 [gtk_] statusbar_push

Pushes a new message onto a statusbar’s stack.

Returns: a message id that can be used with  C<gtk_statusbar_remove()>.

  method gtk_statusbar_push ( UInt $context_id, Str $text --> UInt )

=item UInt $context_id; the message’s context id, as returned by C<gtk_statusbar_get_context_id()>
=item Str $text; the message to add to the statusbar

=end pod

sub gtk_statusbar_push ( N-GObject $statusbar, uint32 $context_id, Str $text --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_pop:
=begin pod
=head2 [gtk_] statusbar_pop

Removes the first message in the B<Gnome::Gtk3::Statusbar>’s stack with the given context id. Note that this may not change the displayed message, if  the message at the top of the stack has a different context id.

  method gtk_statusbar_pop ( UInt $context_id )

=item UInt $context_id; a context identifier

=end pod

sub gtk_statusbar_pop ( N-GObject $statusbar, uint32 $context_id  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_remove:
=begin pod
=head2 [gtk_] statusbar_remove

Forces the removal of a message from a statusbar’s stack. The exact I<context_id> and I<message_id> must be specified.

  method gtk_statusbar_remove ( UInt $context_id, UInt $message_id )

=item UInt $context_id; a context identifier
=item UInt $message_id; a message identifier, as returned by C<gtk_statusbar_push()>

=end pod

sub gtk_statusbar_remove ( N-GObject $statusbar, uint32 $context_id, uint32 $message_id  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_remove_all:
=begin pod
=head2 [[gtk_] statusbar_] remove_all

Forces the removal of all messages from a statusbar's stack with the exact I<context_id>.

  method gtk_statusbar_remove_all ( UInt $context_id )

=item UInt $context_id; a context identifier

=end pod

sub gtk_statusbar_remove_all ( N-GObject $statusbar, uint32 $context_id  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_statusbar_get_message_area:
=begin pod
=head2 [[gtk_] statusbar_] get_message_area

Retrieves the box containing the label widget.

Returns: (type B<N-GObject>) a native B<Gnome::Gtk3::Box> object

  method gtk_statusbar_get_message_area ( --> N-GObject )

=end pod

sub gtk_statusbar_get_message_area ( N-GObject $statusbar --> N-GObject )
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


=comment #TS:1:text-pushed:
=head3 text-pushed

Is emitted whenever a new message gets pushed onto a statusbar's stack.

  method handler (
    Int $context_id,
    Str $text,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($statusbar),
    *%user-options
  );

=item $statusbar; the object which received the signal

=item $context_id; the context id of the relevant message/statusbar

=item $text; the message that was pushed


=comment #TS:1:text-popped:
=head3 text-popped

Is emitted whenever a new message is popped off a statusbar's stack.

  method handler (
    Int $context_id,
    Str $text,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($statusbar),
    *%user-options
  );

=item $statusbar; the object which received the signal

=item $context_id; the context id of the relevant message/statusbar

=item $text; the message that was just popped


=end pod
