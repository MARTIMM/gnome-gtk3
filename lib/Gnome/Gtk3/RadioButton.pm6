#TL:1:Gnome::Gtk3::RadioButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RadioButton

A choice from multiple check buttons

![](images/radio-group.png)

=head1 Description


A single radio button performs the same basic function as a B<Gnome::Gtk3::CheckButton>,
as its position in the object hierarchy reflects. It is only when multiple
radio buttons are grouped together that they become a different user
interface component in their own right.

Every radio button is a member of some group of radio buttons. When one is
selected, all other radio buttons in the same group are deselected. A
B<Gnome::Gtk3::RadioButton> is one way of giving the user a choice from many options.

Radio button widgets are created with C<gtk_radio_button_new()>, passing C<Any>
as the argument if this is the first radio button in a group. In subsequent
calls, the group you wish to add this button to should be passed as an
argument. Optionally, C<new(:label())> or C<gtk_radio_button_new_with_label()> can be used if you want a text label on the radio button.

Alternatively, when adding widgets to an existing group of radio buttons,
use C<gtk_radio_button_new_from_widget()> with a B<Gnome::Gtk3::RadioButton> that already
has a group assigned to it. The convenience function
C<gtk_radio_button_new_with_label_from_widget()> is also provided.

To retrieve the group a B<Gnome::Gtk3::RadioButton> is assigned to, use
C<gtk_radio_button_get_group()>.

To remove a B<Gnome::Gtk3::RadioButton> from one group and make it part of a new one,
use C<gtk_radio_button_set_group()>.

The group list does not need to be freed, as each B<Gnome::Gtk3::RadioButton> will remove
itself and its list item when it is destroyed.


=head2 Css Nodes

  radiobutton
  ├── radio
  ╰── <child>

A B<Gnome::Gtk3::RadioButton> with indicator (see C<gtk_toggle_button_set_mode()>) has a
main CSS node with name radiobutton and a subnode with name radio.

  button.radio
  ├── radio
  ╰── <child>

A B<Gnome::Gtk3::RadioButton> without indicator changes the name of its main node
to button and adds a .radio style class to it. The subnode is invisible
in this case.

When an unselected button in the group is clicked the clicked button
receives the  I<toggled> signal, as does the previously
selected button.
Inside the  I<toggled> handler, C<gtk_toggle_button_get_active()>
can be used to determine if the button has been selected or deselected.

=head2 Implemented Interfaces
=item Gnome::Atk::ImplementorIface
=item Gnome::Gtk3::Buildable
=item Gnome::Gtk3::Actionable
=item Gnome::Gtk3::Activatable

=head2 See Also

B<Gnome::Gtk3::ComboBox>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RadioButton;
  also is Gnome::Gtk3::CheckButton;

=head2 Example

Create a group with two radio buttons

  # Create a top level window and set a title
  my Gnome::Gtk3::Window $top-window .= new(:title('Two Radio Buttons'));
  $top-window.set-border-width(20);

  # Create a grid and add it to the window
  my Gnome::Gtk3::Grid $grid .= new(:empty);
  $top-window.gtk-container-add($grid);

  # Creat the radio buttons
  my Gnome::Gtk3::RadioButton $rb1 .= new(:label('Radio One'));
  my Gnome::Gtk3::RadioButton $rb2 .= new(
    :group-from($rb1), :label('Radio Two')
  );

  # First button selected
  $rb1.set-active(1);

  # Add radio buttons to the grid
  $grid.gtk-grid-attach( $rb1, 0, 0, 1, 1);
  $grid.gtk-grid-attach( $rb2, 0, 1, 1, 1);

  # Show everything and activate all
  $top-window.show-all;

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Glib::SList;
use Gnome::Gtk3::CheckButton;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkradiobutton.h
# https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
unit class Gnome::Gtk3::RadioButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::CheckButton;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

=end pod

#TM:1:new(:empty):
#TM:1:new(:group, :label):
#TM:0:new(:group):
#TM:1:new(:group-from, :label):
#TM:1:new(:group-from):
#TM:1:new(:label):
#TM:1:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<group-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::RadioButton';

  if ? %options<empty> {
    self.native-gobject(gtk_radio_button_new(Any));
  }

  elsif ? %options<group> and ? %options<label> {
    my $g = %options<group>;
    $g = $g() if $g ~~ Gnome::Glib::SList;
    self.native-gobject(
      gtk_radio_button_new_with_label( $g, %options<label>)
    );
  }

  elsif ? %options<group-from> and ? %options<label> {
    my $w = %options<group-from>;
    $w = $w() if $w ~~ Gnome::GObject::Object;
    self.native-gobject(
      gtk_radio_button_new_with_label_from_widget( $w, %options<label>)
    );
  }

  elsif ? %options<group-from> {
    my $w = %options<group-from>;
    $w = $w() if $w ~~ Gnome::GObject::Object;
    self.native-gobject(gtk_radio_button_new_from_widget($w));
  }

  elsif ? %options<label> {
    self.native-gobject(gtk_radio_button_new_with_label( Any, %options<label>));
  }

  elsif ? %options<group> {
    my $g = %options<group>;
    $g = $g() if $g ~~ Gnome::Glib::SList;
    self.native-gobject(gtk_radio_button_new($g));
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

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkRadioButton');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_radio_button_$native-sub"); } unless ?$s;

  # search in the interface modules, name all interfaces which are implemented
  # for this module. not implemented ones are skipped.
  if !$s {
    $s = self._query_interfaces(
      $native-sub, <
        Gnome::Atk::ImplementorIface Gnome::Gtk3::Buildable
        Gnome::Gtk3::Actionable Gnome::Gtk3::Activatable
      >
    );
  }

  self.set-class-name-of-sub('GtkRadioButton');
  $s = callsame unless ?$s;

  $s;
}
#-------------------------------------------------------------------------------
#TM:2:gtk_radio_button_new:
=begin pod
=head2 gtk_radio_button_new

Creates a new B<Gnome::Gtk3::RadioButton>. To be of any practical value, a widget should
then be packed into the radio button.

Returns: a new radio button

  method gtk_radio_button_new ( N-GSList $group --> N-GObject  )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): an existing radio button group, or C<Any> if you are creating a new group.

=end pod

sub gtk_radio_button_new ( N-GSList $group )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_radio_button_new_from_widget:
=begin pod
=head2 [gtk_radio_button_] new_from_widget

Creates a new B<Gnome::Gtk3::RadioButton>, adding it to the same group as
I<radio_group_member>. As with C<gtk_radio_button_new()>, a widget
should be packed into the radio button.

Returns: (transfer none): a new radio button.

  method gtk_radio_button_new_from_widget ( --> N-GObject  )


=end pod

sub gtk_radio_button_new_from_widget ( N-GObject $radio_group_member )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_radio_button_new_with_label:
=begin pod
=head2 [gtk_radio_button_] new_with_label

Creates a new B<Gnome::Gtk3::RadioButton> with a text label.

Returns: a new radio button.

  method gtk_radio_button_new_with_label ( N-GSList $group, Str $label --> N-GObject  )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): an existing radio button group, or C<Any> if you are creating a new group.
=item Str $label; the text label to display next to the radio button.

=end pod

sub gtk_radio_button_new_with_label ( N-GSList $group, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_radio_button_new_with_label_from_widget:
=begin pod
=head2 [gtk_radio_button_] new_with_label_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> with a text label, adding it to
the same group as I<radio_group_member>.

Returns: (transfer none): a new radio button.

  method gtk_radio_button_new_with_label_from_widget ( Str $label --> N-GObject  )

=item Str $label; a text string to display next to the radio button.

=end pod

sub gtk_radio_button_new_with_label_from_widget ( N-GObject $radio_group_member, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_radio_button_new_with_mnemonic:
=begin pod
=head2 [gtk_radio_button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::RadioButton> containing a label, adding it to the same
group as I<group>. The label will be created using
C<gtk_label_new_with_mnemonic()>, so underscores in I<label> indicate the
mnemonic for the button.

Returns: a new B<Gnome::Gtk3::RadioButton>

  method gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label --> N-GObject  )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): the radio button group, or C<Any>
=item Str $label; the text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_radio_button_new_with_mnemonic_from_widget:
=begin pod
=head2 [gtk_radio_button_] new_with_mnemonic_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> containing a label. The label
will be created using C<gtk_label_new_with_mnemonic()>, so underscores
in I<label> indicate the mnemonic for the button.

Returns: (transfer none): a new B<Gnome::Gtk3::RadioButton>

  method gtk_radio_button_new_with_mnemonic_from_widget ( Str $label --> N-GObject  )

=item Str $label; the text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_radio_button_new_with_mnemonic_from_widget ( N-GObject $radio_group_member, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_radio_button_get_group:
=begin pod
=head2 [gtk_radio_button_] get_group

Retrieves the group assigned to a radio button.

Returns: (element-type B<Gnome::Gtk3::RadioButton>) (transfer none): a linked list
containing all the radio buttons in the same group
as I<radio_button>. The returned list is owned by the radio button
and must not be modified or freed.

  method gtk_radio_button_get_group ( --> N-GSList  )


=end pod

sub gtk_radio_button_get_group ( N-GObject $radio_button )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_radio_button_set_group:
=begin pod
=head2 [gtk_radio_button_] set_group

Sets a B<Gnome::Gtk3::RadioButton>’s group. It should be noted that this does not change
the layout of your interface in any way, so if you are changing the group,
it is likely you will need to re-arrange the user interface to reflect these
changes.

  method gtk_radio_button_set_group ( N-GSList $group )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): an existing radio button group, such as one returned from C<gtk_radio_button_get_group()>, or C<Any>.

=end pod

sub gtk_radio_button_set_group ( N-GObject $radio_button, N-GSList $group )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_radio_button_join_group:
=begin pod
=head2 [gtk_radio_button_] join_group

Joins a B<Gnome::Gtk3::RadioButton> object to the group of another B<Gnome::Gtk3::RadioButton> object

Use this in language bindings instead of the C<gtk_radio_button_get_group()>
and C<gtk_radio_button_set_group()> methods

=begin comment
A common way to set up a group of radio buttons is the following:
|[<!-- language="C" -->
B<Gnome::Gtk3::RadioButton> *radio_button;
B<Gnome::Gtk3::RadioButton> *last_button;

while ( ...more buttons to add... )
{
radio_button = gtk_radio_button_new (...);

gtk_radio_button_join_group (radio_button, last_button);
last_button = radio_button;
}
]|
=end comment

Since: 3.0

  method gtk_radio_button_join_group ( N-GObject $group_source )

=item N-GObject $group_source; (allow-none): a radio button object whos group we are  joining, or C<Any> to remove the radio button from its group

=end pod

sub gtk_radio_button_join_group ( N-GObject $radio_button, N-GObject $group_source )
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


=comment #TS:1:group-changed:
=head3 group-changed

Emitted when the group of radio buttons that a radio button belongs
to changes. This is emitted when a radio button switches from
being alone to being part of a group of 2 or more buttons, or
vice-versa, and when a button is moved from one group of 2 or
more buttons to a different one, but not when the composition
of the group that a button belongs to changes.

Since: 2.4

  method handler (
    Gnome::GObject::Object :widget($button),
    *%user-options
  );

=item $button; the object which received the signal


=end pod






















=finish
#-------------------------------------------------------------------------------
sub gtk_radio_button_new ( N-GSList $group --> N-GObject )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_from_widget ( N-GObject $group_member --> N-GObject )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_with_label ( N-GSList $group, Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_new_with_label_from_widget (
  N-GObject $group_member, Str $label
) returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_set_group ( N-GObject $radio_button, N-GSList $group )
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_get_group ( N-GObject $radio_button )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_radio_button_join_group (
  N-GObject $radio_button, N-GObject $group_source
) returns N-GSList
  is native(&gtk-lib)
  { * }
