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


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Assistant;
  also is Gnome::Gtk3::Window;


=head2 Uml Diagram

![](plantuml/Assistant.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Assistant;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Assistant;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Assistant class process the options
    self.bless( :GtkAssistant, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=head2 Example

  unit class MyGuiClass;
  also is Gnome::Gtk3::Assistant;

  submethod new ( |c ) {
    self.bless( :GtkAssistant, |c);
  }

  submethod BUILD ( ) {
    my Gnome::Gtk3::Frame $intro-page .= new(...);
    ...
    self.add-page(
      $intro-page, GTK_ASSISTANT_PAGE_INTRO, 'Introduction'
    );

    my Gnome::Gtk3::Frame $install-page .= new(...);
    ...
    self.add-page(
      $install-page, GTK_ASSISTANT_PAGE_CONTENT, 'Installing'
    );
    ...
  }

  method add-page ( $page, GtkAssistantPageType $type, Str $title ) {
    self.append-page($page);
    self.set-page-type(
      $install-page, $type // GTK_ASSISTANT_PAGE_CONTENT
    );
    self.set-page-title($title);
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Window;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Assistant:auth<github:MARTIMM>:ver<0.1.1>;
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

=head3 default, no options

Create a new Assistant object.

  multi method new ( )

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):TopLevelSupportClass
#TM:4:new(:build-id):Object
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
  if self.^name eq 'Gnome::Gtk3::Assistant' or %options<GtkAssistant> {

    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # create default object
    else {
      my $no;

      $no = _gtk_assistant_new();
      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkAssistant');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_assistant_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkAssistant');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:add-action-widget:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 add-action-widget

Adds a widget to the action area of a B<Gnome::Gtk3::Assistant>.

  method add-action-widget ( N-GObject $child )

=item N-GObject $child; an action widget.

=end pod

method add-action-widget ( $child ) {

  my $no = $child;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
#note 'no: ', $child.^name, ', ', $no.^name;

  gtk_assistant_add_action_widget( self.get-native-object-no-reffing, $no)
}

sub gtk_assistant_add_action_widget ( N-GObject $assistant, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:append-page:
=begin pod
=head2 append-page

Appends a I<$page> to the assistant. Returns the index (starting at 0) of the inserted page. C<$page> can be any widget making up the content of a page in this assistant.

  method append-page ( N-GObject $page --> Int )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>

=end pod

method append-page ( $page --> Int ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_append_page( self.get-native-object-no-reffing, $no)
}

sub gtk_assistant_append_page (
  N-GObject $assistant, N-GObject $page --> int32
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:commit:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 commit

Erases the visited page history so the back button is not shown on the current page, and removes the cancel button from subsequent pages.

Use this when the information provided up to the current page is hereafter deemed permanent and cannot be modified or undone. For example, showing a progress page to track a long-running, unreversible operation after the user has clicked apply on a confirmation page.

  method commit ( )

=end pod

method commit ( ) {
  gtk_assistant_commit(self.get-native-object-no-reffing)
}

sub gtk_assistant_commit ( N-GObject $assistant )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-current-page:
=begin pod
=head2 get-current-page

Returns the page number of the current page. This is the index (starting from 0) of the current page in the assistant, or -1 if the assistant has no pages, or no current page.

  method get-current-page ( --> Int )

=end pod

method get-current-page ( --> Int ) {
  gtk_assistant_get_current_page(self.get-native-object-no-reffing);
}

sub gtk_assistant_get_current_page ( N-GObject $assistant --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-n-pages:
=begin pod
=head2 get-n-pages

Returns the number of pages in the assistant.

  method get-n-pages ( --> Int )

=end pod

method get-n-pages ( --> Int ) {
  gtk_assistant_get_n_pages( self.get-native-object-no-reffing)
}

sub gtk_assistant_get_n_pages ( N-GObject $assistant --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-nth-page:
#TM:1:get-nth-page-rk:
=begin pod
=head2 get-nth-page, get-nth-page-rk

Returns the child widget contained in page number I<$page_num>, or C<Any> if I<$page_num> is out of bounds

  method get-nth-page ( Int $page_num --> N-GObject )
  method get-nth-page-rk (
    Int $page_num, :$child-type?
    --> Gnome::GObject::Object
  )

=item Int $page_num; the index of a page in the assistant, or -1 to get the last page

=end pod

method get-nth-page ( Int $page_num --> N-GObject ) {
  gtk_assistant_get_nth_page( self.get-native-object-no-reffing, $page_num)
}

method get-nth-page-rk ( Int $page_num, *%options --> Gnome::GObject::Object ) {
  my $o = self._wrap-native-type-from-no(
    gtk_assistant_get_nth_page( self.get-native-object-no-reffing, $page_num),
    |%options
  );

  $o ~~ N-GObject ?? Gnome::GObject::Widget.new(:native-object($o)) !! $o
}

sub gtk_assistant_get_nth_page (
  N-GObject $assistant, gint $page_num --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-page-complete:
=begin pod
=head2 get-page-complete

Gets whether I<$page> is complete. C<True> if I<$page> is complete.

  method get-page-complete ( N-GObject $page --> Bool )

=item N-GObject $page; a page of assistant

=end pod

method get-page-complete ( $page --> Bool ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_get_page_complete( self.get-native-object-no-reffing, $no).Bool
}

sub gtk_assistant_get_page_complete (
  N-GObject $assistant, N-GObject $page --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_assistant_get_page_has_padding:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 get-page-has-padding

Gets whether page has padding.

Returns: C<True> if I<$page> has padding

  method gtk_assistant_get_page_has_padding ( N-GObject $page --> Bool )

=item N-GObject $page; a page of I<assistant>

=end pod

method get-page-has-padding ( $page --> Bool ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_get_page_has_padding(
    self.get-native-object-no-reffing, $no
  ).Bool
}

sub gtk_assistant_get_page_has_padding (
  N-GObject $assistant, N-GObject $page --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-page-title:
=begin pod
=head2 get-page-title

Gets the title for I<$page>. C<$page> is a previously added widget.

  method get-page-title ( N-GObject $page --> Str )

=item N-GObject $page; a page of assistant

=end pod

method get-page-title ( $page --> Str ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_get_page_title( self.get-native-object-no-reffing, $no)
}

sub gtk_assistant_get_page_title (
  N-GObject $assistant, N-GObject $page --> Str
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-page-type:
=begin pod
=head2 get-page-type

Gets the page type of I<$page>. C<$page> is a previously added widget.

  method get-page-type (
    N-GObject $page --> GtkAssistantPageType
  )

=item N-GObject $page; a page of Iassistant

=end pod

method get-page-type ( $page --> GtkAssistantPageType ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  GtkAssistantPageType(
    gtk_assistant_get_page_type( self.get-native-object-no-reffing, $no)
  )
}

sub gtk_assistant_get_page_type (
  N-GObject $assistant, N-GObject $page --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-page:
=begin pod
=head2 insert-page

Inserts a I<$page> in the assistant at a given position. C<$page> can be any widget making up the content of a page in this assistant.

Returns: the index (starting from 0) of the inserted page

  method insert-page (
    N-GObject $page, Int $position --> Int
  )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>
=item Int $position; the index (starting at 0) at which to insert the page, or -1 to append the page to the assistant

=end pod

method insert-page ( $page, Int $position --> Int ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_insert_page( self.get-native-object-no-reffing, $no, $position)
}

sub gtk_assistant_insert_page (
  N-GObject $assistant, N-GObject $page, gint $position --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:next-page:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 next-page

Navigate to the next page. It is a programming error to call this function when there is no next page. This function is for use when creating pages of the
B<GTK_ASSISTANT_PAGE_CUSTOM> type.

  method next-page ( )

=end pod

method next-page ( ) {
  gtk_assistant_next_page(self.get-native-object-no-reffing);
}

sub gtk_assistant_next_page ( N-GObject $assistant )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prepend-page:
=begin pod
=head2 prepend-page

Prepends a I<$page> to the assistant. Returns the index (starting at 0) of the inserted page. C<$page> can be any widget making up the content of a page in this assistant.

  method prepend-page ( N-GObject $page --> Int )

=item N-GObject $page; a B<Gnome::Gtk3::Widget>

=end pod

method prepend-page ( $page --> Int ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_prepend_page( self.get-native-object-no-reffing, $no);
}

sub gtk_assistant_prepend_page (
  N-GObject $assistant, N-GObject $page --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:previous-page:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 previous-page

Navigate to the previous visited page. It is a programming error to call this function when no previous page is available. This function is for use when creating pages of the B<GTK_ASSISTANT_PAGE_CUSTOM> type.

  method previous-page ( )

=end pod

method previous-page ( ) {
  gtk_assistant_previous_page(self.get-native-object-no-reffing);
}

sub gtk_assistant_previous_page ( N-GObject $assistant  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:remove-action-widget:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 remove-action-widget

Removes a widget from the action area of a B<Gnome::Gtk3::Assistant>.

  method remove-action-widget ( N-GObject $child )

=item N-GObject $child; a previously added action widget

=end pod

method remove-action-widget ( $child ) {

  my $no = $child;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_remove_action_widget( self.get-native-object-no-reffing, $no)
}

sub gtk_assistant_remove_action_widget (
  N-GObject $assistant, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-page:
=begin pod
=head2 remove-page

Removes the I<$page-num>’s page from assistant. C<$page> is a previously inserted widget.

  method remove-page ( Int $page-num )

=item Int $page-num; the index of a page in the assistant, or -1 to remove the last page

=end pod

method remove-page ( Int $page-num ) {
  gtk_assistant_remove_page( self.get-native-object-no-reffing, $page-num )
}

sub gtk_assistant_remove_page ( N-GObject $assistant, gint $page-num  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-current-page:
=begin pod
=head2 set-current-page

Switches the page to I<$page_num>. Note that this will only be necessary in custom buttons, as the assistant flow can be set with C<gtk_assistant_set_forward_page_func()>.

  method set-current-page ( Int $page_num )

=item Int $page_num; index of the page to switch to, starting from 0. If negative, the last page will be used. If greater than the number of pages in the assistant, nothing will be done.

=end pod

method set-current-page ( Int $page_num ) {
  gtk_assistant_set_current_page( self.get-native-object-no-reffing, $page_num);
}

sub gtk_assistant_set_current_page ( N-GObject $assistant, gint $page_num  )
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
#TM:1:set-page-complete:
=begin pod
=head2 set-page-complete

Sets whether I<$page> contents are complete. This will make assistant update the buttons state to be able to continue the task. C<$page> is a previously added widget.

  method set-page-complete ( $page, Bool $complete )

=item $page; a page of assistant
=item Bool $complete; the completeness status of the page. C<True> to set page complete.

=end pod

method set-page-complete ( $page, Bool $complete ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_set_page_complete(
    self.get-native-object-no-reffing, $no, $complete.Int
  )
}

sub gtk_assistant_set_page_complete (
  N-GObject $assistant, N-GObject $page, gboolean $complete
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-page-has-padding:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 set-page-has-padding

Sets whether the assistant is adding padding around the page.

  method set-page-has-padding ( N-GObject $page, Bool $has_padding )

=item N-GObject $page; a page of I<assistant>
=item Bool $has_padding; whether this page has padding

=end pod

method set-page-has-padding ( $page, Bool $has_padding ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_set_page_has_padding(
    self.get-native-object-no-reffing, $no, $has_padding.Int
  )
}

sub gtk_assistant_set_page_has_padding (
  N-GObject $assistant, N-GObject $page, gboolean $has_padding
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-page-type:
=begin pod
=head2 set-page-type

Sets the page type for I<$page>. The page type determines the page behavior in the assistant. C<$page> is a previously added page.

  method set-page-type (
    N-GObject $page, GtkAssistantPageType $type
  )

=item N-GObject $page; a page of assistant
=item GtkAssistantPageType $type; the new type for I<$page>

=end pod

method set-page-type ( $page, GtkAssistantPageType $type ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_set_page_type(
    self.get-native-object-no-reffing, $no, $type.value
  )
}

sub gtk_assistant_set_page_type (
  N-GObject $assistant, N-GObject $page, GEnum $type
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-page-title:
=begin pod
=head2 set-page-title

Sets a title for I<$page>. The title is displayed in the header area of the assistant when I<$page> is the current page. C<$page> is a previously added widget.

  method set-page-title ( N-GObject $page, Str $title )

=item N-GObject $page; a page of assistant
=item Str $title; the new title for I<$page>

=end pod

method set-page-title ( $page, Str $title ) {

  my $no = $page;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_assistant_set_page_title( self.get-native-object-no-reffing, $no, $title)
}

sub gtk_assistant_set_page_title (
  N-GObject $assistant, N-GObject $page, Str $title
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:update-buttons-state:xt/Benchmarking/Modules/Assistant.raku
=begin pod
=head2 update-buttons-state

Forces the I<assistant> to recompute the buttons state.

GTK+ automatically takes care of this in most situations, e.g. when the user goes to a different page, or when the visibility or completeness of a page changes.

One situation where it can be necessary to call this function is when changing a value on the current page affects the future page flow of the assistant.

  method update-buttons-state ( )

=end pod

method update-buttons-state ( ) {
  gtk_assistant_update_buttons_state(self.get-native-object-no-reffing)
}

sub gtk_assistant_update_buttons_state ( N-GObject $assistant )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_assistant_new:
#`{{
=begin pod
=head2 _gtk_assistant_new

Creates a new B<Gnome::Gtk3::Assistant>.

Returns: a newly created B<Gnome::Gtk3::Assistant>

  method _gtk_assistant_new ( --> N-GObject )

=end pod
}}

sub _gtk_assistant_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_assistant_new')
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
=comment #TS:0:apply:
=head3 apply

The I<apply> signal is emitted when the apply button is clicked.

The default behavior of the B<Gnome::Gtk3::Assistant> is to switch to the page
after the current page, unless the current page is the last one.

A handler for the I<apply> signal should carry out the actions for
which the wizard has collected data. If the action takes a long time
to complete, you might consider putting a page of type
C<GTK-ASSISTANT-PAGE-PROGRESS> after the confirmation page and handle
this operation within the  I<prepare> signal of the progress
page.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:cancel:
=head3 cancel

The I<cancel> signal is emitted when then the cancel button is clicked.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:close:
=head3 close

The I<close> signal is emitted either when the close button of
a summary page is clicked, or when the apply button in the last
page in the flow (of type C<GTK-ASSISTANT-PAGE-CONFIRM>) is clicked.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:escape:
=head3 escape

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($assistant),
    *%user-options
  );

=item $assistant;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:prepare:
=head3 prepare

The I<prepare> signal is emitted when a new page is set as the
assistant's current page, before making the new page visible.

A handler for this signal can do any preparations which are
necessary before showing I<page>.


  method handler (
    N-GObject #`{ is widget } $page,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($assistant),
    *%user-options
  );

=item $assistant; the B<Gnome::Gtk3::Assistant>

=item $page; the current page

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
=comment #TP:0:use-header-bar:
=head3 Use Header Bar: use-header-bar


C<True> if the assistant uses a B<Gnome::Gtk3::HeaderBar> for action buttons
instead of the action-area.

For technical reasons, this property is declared as an integer
property, but you should only set it to C<True> or C<False>.


The B<Gnome::GObject::Value> type of property I<use-header-bar> is C<G_TYPE_INT>.
=end pod
