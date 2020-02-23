#TL:1:Gnome::Gtk3::Assistant:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Assistant

A widget used to guide users through multi-step operations

![](images/assistant.png)

=head1 Description

A B<Gnome::Gtk3::Assistant> is a widget used to represent a generally complex operation splitted in several steps, guiding the user through its pages and controlling the page flow to collect the necessary data.

The design of B<Gnome::Gtk3::Assistant> is that it controls what buttons to show and to make sensitive, based on what it knows about the page sequence and the C<AssistantPageType> of each page, in addition to state information like the page completion and committed status.

If you have a case that doesn’t quite fit in B<Gnome::Gtk3::Assistants> way of handling buttons, you can use the B<GTK_ASSISTANT_PAGE_CUSTOM> page type and handle buttons yourself.

=head2 B<Gnome::Gtk3::Assistant> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::Assistant> implementation of the B<Gnome::Gtk3::Buildable> interface exposes the I<action_area> as internal children with the name “action_area”.

To add pages to an assistant in B<Gnome::Gtk3::Builder>, simply add it as a child to the B<Gnome::Gtk3::Assistant> object, and set its child properties as necessary.

=head2 Css Nodes

B<Gnome::Gtk3::Assistant> has a single CSS node with the name assistant.

=head2 Implemented Interfaces

Gnome::Gtk3::Assistant implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Assistant;
  also is Gnome::Gtk3::Window;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Window;

#use Gnome::Gtk3::Orientable;
#use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Assistant:auth<github:MARTIMM>;
also is Gnome::Gtk3::Window;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkAssistantPageType

An enum for determining the page role inside the B<Gnome::Gtk3::Assistant>. It's used to handle buttons sensitivity and visibility.

Note that an assistant needs to end its page flow with a page of type C<GTK_ASSISTANT_PAGE_CONFIRM>, C<GTK_ASSISTANT_PAGE_SUMMARY> or C<GTK_ASSISTANT_PAGE_PROGRESS> to be correct.

The Cancel button will only be shown if the page isn’t “committed”. See C<gtk_assistant_commit()> for details.

=item GTK_ASSISTANT_PAGE_CONTENT: The page has regular contents. Both the Back and forward buttons will be shown.
=item GTK_ASSISTANT_PAGE_INTRO: The page contains an introduction to the assistant task. Only the Forward button will be shown if there is a next page.
=item GTK_ASSISTANT_PAGE_CONFIRM: The page lets the user confirm or deny the changes. The Back and Apply buttons will be shown.
=item GTK_ASSISTANT_PAGE_SUMMARY: The page informs the user of the changes done. Only the Close button will be shown.
=item GTK_ASSISTANT_PAGE_PROGRESS: Used for tasks that take a long time to complete, blocks the assistant until the page is marked as complete. Only the back button will be shown.
=item GTK_ASSISTANT_PAGE_CUSTOM: Used for when other page types are not appropriate. No buttons will be shown, and the application must add its own buttons through C<gtk_assistant_add_action_widget()>.

=end pod

#TE:0:GtkAssistantPageType:
enum GtkAssistantPageType is export (
  'GTK_ASSISTANT_PAGE_CONTENT',
  'GTK_ASSISTANT_PAGE_INTRO',
  'GTK_ASSISTANT_PAGE_CONFIRM',
  'GTK_ASSISTANT_PAGE_SUMMARY',
  'GTK_ASSISTANT_PAGE_PROGRESS',
  'GTK_ASSISTANT_PAGE_CUSTOM'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new Assistant object.

  multi method new ( )

Create a Assistant object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a Assistant object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<prepare>, :w0<cancel apply close escape>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Assistant';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }

  # create default object
  else {
    self.set-native-object(gtk_assistant_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkAssistant');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_assistant_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkAssistant');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_assistant_new:new()
=begin pod
=head2 gtk_assistant_new

Creates a new B<Gnome::Gtk3::Assistant>.

Since: 2.10

  method gtk_assistant_new ( --> N-GObject )

=end pod

sub gtk_assistant_new (  --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_next_page:
=begin pod
=head2 [gtk_assistant_] next_page

Navigate to the next page.

It is a programming error to call this function when
there is no next page.

This function is for use when creating pages of the
B<GTK_ASSISTANT_PAGE_CUSTOM> type.

Since: 3.0

  method gtk_assistant_next_page ( )


=end pod

sub gtk_assistant_next_page ( N-GObject $assistant  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_previous_page:
=begin pod
=head2 [gtk_assistant_] previous_page

Navigate to the previous visited page.

It is a programming error to call this function when
no previous page is available.

This function is for use when creating pages of the
B<GTK_ASSISTANT_PAGE_CUSTOM> type.

Since: 3.0

  method gtk_assistant_previous_page ( )


=end pod

sub gtk_assistant_previous_page ( N-GObject $assistant  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_get_current_page:
=begin pod
=head2 [gtk_assistant_] get_current_page

Returns the page number of the current page.

Returns: The index (starting from 0) of the current
page in the I<assistant>, or -1 if the I<assistant> has no pages,
or no current page.

Since: 2.10

  method gtk_assistant_get_current_page ( --> Int )


=end pod

sub gtk_assistant_get_current_page ( N-GObject $assistant --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_set_current_page:
=begin pod
=head2 [gtk_assistant_] set_current_page

Switches the page to I<page_num>.

Note that this will only be necessary in custom buttons,
as the I<assistant> flow can be set with
C<gtk_assistant_set_forward_page_func()>.

Since: 2.10

  method gtk_assistant_set_current_page ( Int $page_num )

=item Int $page_num; index of the page to switch to, starting from 0. If negative, the last page will be used. If greater than the number of pages in the I<assistant>, nothing will be done.

=end pod

sub gtk_assistant_set_current_page ( N-GObject $assistant, int32 $page_num  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_assistant_get_n_pages:
=begin pod
=head2 [gtk_assistant_] get_n_pages

Returns the number of pages in the I<assistant>

Returns: the number of pages in the I<assistant>

Since: 2.10

  method gtk_assistant_get_n_pages ( --> Int )


=end pod

sub gtk_assistant_get_n_pages ( N-GObject $assistant --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_assistant_get_nth_page:
=begin pod
=head2 [gtk_assistant_] get_nth_page

Returns the child widget contained in page number I<page_num>.

Returns: (nullable) (transfer none): the child widget, or C<Any>
if I<page_num> is out of bounds

Since: 2.10

  method gtk_assistant_get_nth_page ( Int $page_num --> N-GObject )

=item Int $page_num; the index of a page in the I<assistant>, or -1 to get the last page

=end pod

sub gtk_assistant_get_nth_page ( N-GObject $assistant, int32 $page_num --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_prepend_page:
=begin pod
=head2 [gtk_assistant_] prepend_page

Prepends a page to the I<assistant>.

Returns: the index (starting at 0) of the inserted page

Since: 2.10

  method gtk_assistant_prepend_page ( N-GObject $page --> Int )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_assistant_prepend_page ( N-GObject $assistant, N-GObject $page --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_assistant_append_page:
=begin pod
=head2 [gtk_assistant_] append_page

Appends a page to the I<assistant>.

Returns: the index (starting at 0) of the inserted page

Since: 2.10

  method gtk_assistant_append_page ( N-GObject $page --> Int )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_assistant_append_page ( N-GObject $assistant, N-GObject $page --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_insert_page:
=begin pod
=head2 [gtk_assistant_] insert_page

Inserts a page in the I<assistant> at a given position.

Returns: the index (starting from 0) of the inserted page

Since: 2.10

  method gtk_assistant_insert_page ( N-GObject $page, Int $position --> Int )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>
=item Int $position; the index (starting at 0) at which to insert the page, or -1 to append the page to the I<assistant>

=end pod

sub gtk_assistant_insert_page ( N-GObject $assistant, N-GObject $page, int32 $position --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_remove_page:
=begin pod
=head2 [gtk_assistant_] remove_page

Removes the I<page_num>’s page from I<assistant>.

Since: 3.2

  method gtk_assistant_remove_page ( Int $page_num )

=item Int $page_num; the index of a page in the I<assistant>, or -1 to remove the last page

=end pod

sub gtk_assistant_remove_page ( N-GObject $assistant, int32 $page_num  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_set_forward_page_func:
=begin pod
=head2 [gtk_assistant_] set_forward_page_func

Sets the page forwarding function to be I<page_func>.

This function will be used to determine what will be
the next page when the user presses the forward button.
Setting I<page_func> to C<Any> will make the assistant to
use the default forward function, which just goes to the
next visible page.

Since: 2.10

  method gtk_assistant_set_forward_page_func ( GtkAssistantPageFunc $page_func, Pointer $data, GDestroyNotify $destroy )

=item GtkAssistantPageFunc $page_func; (allow-none): the B<Gnome::Gtk3::AssistantPageFunc>, or C<Any> to use the default one
=item Pointer $data; user data for I<page_func>
=item GDestroyNotify $destroy; destroy notifier for I<data>

=end pod

sub gtk_assistant_set_forward_page_func ( N-GObject $assistant, GtkAssistantPageFunc $page_func, Pointer $data, GDestroyNotify $destroy  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_assistant_set_page_type:
=begin pod
=head2 [gtk_assistant_] set_page_type

Sets the page type for I<page>.

The page type determines the page behavior in the I<assistant>.

Since: 2.10

  method gtk_assistant_set_page_type (
    N-GObject $page, GtkAssistantPageType $type
  )

=item N-GObject $page; a page of I<assistant>
=item GtkAssistantPageType $type; the new type for I<page>

=end pod

sub gtk_assistant_set_page_type ( N-GObject $assistant, N-GObject $page, int32 $type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_assistant_get_page_type:
=begin pod
=head2 [gtk_assistant_] get_page_type

Gets the page type of I<page>.

Returns: the page type of I<page>

Since: 2.10

  method gtk_assistant_get_page_type ( N-GObject $page --> GtkAssistantPageType )

=item N-GObject $page; a page of I<assistant>

=end pod

sub gtk_assistant_get_page_type ( N-GObject $assistant, N-GObject $page --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_set_page_title:
=begin pod
=head2 [gtk_assistant_] set_page_title

Sets a title for I<page>.

The title is displayed in the header area of the assistant
when I<page> is the current page.

Since: 2.10

  method gtk_assistant_set_page_title ( N-GObject $page, Str $title )

=item N-GObject $page; a page of I<assistant>
=item Str $title; the new title for I<page>

=end pod

sub gtk_assistant_set_page_title ( N-GObject $assistant, N-GObject $page, Str $title  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_get_page_title:
=begin pod
=head2 [gtk_assistant_] get_page_title

Gets the title for I<page>.

Returns: the title for I<page>

Since: 2.10

  method gtk_assistant_get_page_title ( N-GObject $page --> Str )

=item N-GObject $page; a page of I<assistant>

=end pod

sub gtk_assistant_get_page_title ( N-GObject $assistant, N-GObject $page --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_set_page_complete:
=begin pod
=head2 [gtk_assistant_] set_page_complete

Sets whether I<page> contents are complete.

This will make I<assistant> update the buttons state
to be able to continue the task.

Since: 2.10

  method gtk_assistant_set_page_complete ( N-GObject $page, Int $complete )

=item N-GObject $page; a page of I<assistant>
=item Int $complete; the completeness status of the page

=end pod

sub gtk_assistant_set_page_complete ( N-GObject $assistant, N-GObject $page, int32 $complete  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_get_page_complete:
=begin pod
=head2 [gtk_assistant_] get_page_complete

Gets whether I<page> is complete.

Returns: C<1> if I<page> is complete.

Since: 2.10

  method gtk_assistant_get_page_complete ( N-GObject $page --> Int )

=item N-GObject $page; a page of I<assistant>

=end pod

sub gtk_assistant_get_page_complete ( N-GObject $assistant, N-GObject $page --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_add_action_widget:
=begin pod
=head2 [gtk_assistant_] add_action_widget

Adds a widget to the action area of a B<Gnome::Gtk3::Assistant>.

Since: 2.10

  method gtk_assistant_add_action_widget ( N-GObject $child )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_assistant_add_action_widget ( N-GObject $assistant, N-GObject $child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_remove_action_widget:
=begin pod
=head2 [gtk_assistant_] remove_action_widget

Removes a widget from the action area of a B<Gnome::Gtk3::Assistant>.

Since: 2.10

  method gtk_assistant_remove_action_widget ( N-GObject $child )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_assistant_remove_action_widget ( N-GObject $assistant, N-GObject $child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_update_buttons_state:
=begin pod
=head2 [gtk_assistant_] update_buttons_state

Forces I<assistant> to recompute the buttons state.

GTK+ automatically takes care of this in most situations,
e.g. when the user goes to a different page, or when the
visibility or completeness of a page changes.

One situation where it can be necessary to call this
function is when changing a value on the current page
affects the future page flow of the assistant.

Since: 2.10

  method gtk_assistant_update_buttons_state ( )


=end pod

sub gtk_assistant_update_buttons_state ( N-GObject $assistant  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_commit:
=begin pod
=head2 gtk_assistant_commit

Erases the visited page history so the back button is not
shown on the current page, and removes the cancel button
from subsequent pages.

Use this when the information provided up to the current
page is hereafter deemed permanent and cannot be modified
or undone. For example, showing a progress page to track
a long-running, unreversible operation after the user has
clicked apply on a confirmation page.

Since: 2.22

  method gtk_assistant_commit ( )


=end pod

sub gtk_assistant_commit ( N-GObject $assistant  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_set_page_has_padding:
=begin pod
=head2 [gtk_assistant_] set_page_has_padding

Sets whether the assistant is adding padding around
the page.

Since: 3.18

  method gtk_assistant_set_page_has_padding ( N-GObject $page, Int $has_padding )

=item N-GObject $page; a page of I<assistant>
=item Int $has_padding; whether this page has padding

=end pod

sub gtk_assistant_set_page_has_padding ( N-GObject $assistant, N-GObject $page, int32 $has_padding  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_assistant_get_page_has_padding:
=begin pod
=head2 [gtk_assistant_] get_page_has_padding

Gets whether page has padding.

Returns: C<1> if I<page> has padding
Since: 3.18

  method gtk_assistant_get_page_has_padding ( N-GObject $page --> Int )

=item N-GObject $page; a page of I<assistant>

=end pod

sub gtk_assistant_get_page_has_padding ( N-GObject $assistant, N-GObject $page --> int32 )
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


=comment #TS:0:cancel:
=head3 cancel

The I<cancel> signal is emitted when then the cancel button is clicked.

Since: 2.10

  method handler (
    Gnome::GObject::Object :widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>


=comment #TS:0:prepare:
=head3 prepare

The I<prepare> signal is emitted when a new page is set as the
assistant's current page, before making the new page visible.

A handler for this signal can do any preparations which are
necessary before showing I<page>.

Since: 2.10

  method handler (
    N-GObject #`{ is widget } $page,
    Gnome::GObject::Object :widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>

=item $page; the current page


=comment #TS:0:apply:
=head3 apply

The I<apply> signal is emitted when the apply button is clicked.

The default behavior of the B<Gnome::Gtk3::Assistant> is to switch to the page
after the current page, unless the current page is the last one.

A handler for the I<apply> signal should carry out the actions for
which the wizard has collected data. If the action takes a long time
to complete, you might consider putting a page of type
C<GTK_ASSISTANT_PAGE_PROGRESS> after the confirmation page and handle
this operation within the  I<prepare> signal of the progress
page.

Since: 2.10

  method handler (
    Gnome::GObject::Object :widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>


=comment #TS:0:close:
=head3 close

The I<close> signal is emitted either when the close button of
a summary page is clicked, or when the apply button in the last
page in the flow (of type C<GTK_ASSISTANT_PAGE_CONFIRM>) is clicked.

Since: 2.10

  method handler (
    Gnome::GObject::Object :widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>


=comment #TS:0:escape:
=head3 escape

  method handler (
    Gnome::GObject::Object :widget($assistant),
    *%user-options
  );

=item $assistant;

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

=comment #TP:0:use-header-bar:
=head3 Use Header Bar


C<1> if the assistant uses a B<Gnome::Gtk3::HeaderBar> for action buttons
instead of the action-area.
For technical reasons, this property is declared as an integer
property, but you should only set it to C<1> or C<0>.
Since: 3.12

The B<Gnome::GObject::Value> type of property I<use-header-bar> is C<G_TYPE_INT>.
=end pod
