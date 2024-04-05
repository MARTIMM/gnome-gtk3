#TL:1:Gnome::Gtk3::RadioButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RadioButton

A choice from multiple check buttons

![](images/radio-group.png)

=head1 Description

A single radio button performs the same basic function as a B<Gnome::Gtk3::CheckButton>, as its position in the object hierarchy reflects. It is only when multiple radio buttons are grouped together that they become a different user interface component in their own right.

Every radio button is a member of some group of radio buttons. When one is selected, all other radio buttons in the same group are deselected. A B<Gnome::Gtk3::RadioButton> is one way of giving the user a choice from many options.

=begin comment
Radio button widgets are created with C<gtk_radio_button_new()>, passing C<Any> as the argument if this is the first radio button in a group. In subsequent calls, the group you wish to add this button to should be passed as an argument. Optionally, C<new(:label())> or C<gtk_radio_button_new_with_label()> can be used if you want a text label on the radio button.

Alternatively, when adding widgets to an existing group of radio buttons, use C<gtk_radio_button_new_from_widget()> with a B<Gnome::Gtk3::RadioButton> that already has a group assigned to it. The convenience function C<gtk_radio_button_new_with_label_from_widget()> is also provided.

To retrieve the group a B<Gnome::Gtk3::RadioButton> is assigned to, use C<gtk_radio_button_get_group()>.

To remove a B<Gnome::Gtk3::RadioButton> from one group and make it part of a new one, use C<gtk_radio_button_set_group()>.

The group list does not need to be freed, as each B<Gnome::Gtk3::RadioButton> will remove itself and its list item when it is destroyed.
=end comment


=head2 Css Nodes

  radiobutton
  ├── radio
  ╰── <child>

A B<Gnome::Gtk3::RadioButton> with indicator (see C<gtk_toggle_button_set_mode()>) has a main CSS node with name radiobutton and a subnode with name radio.

  button.radio
  ├── radio
  ╰── <child>

A B<Gnome::Gtk3::RadioButton> without indicator changes the name of its main node to button and adds a .radio style class to it. The subnode is invisible in this case.

When an unselected button in the group is clicked the clicked button receives the  I<toggled> signal, as does the previously selected button. Inside the  I<toggled> handler, C<gtk_toggle_button_get_active()> can be used to determine if the button has been selected or deselected.


=head2 See Also

B<Gnome::Gtk3::ComboBox>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RadioButton;
  also is Gnome::Gtk3::CheckButton;


=head2 Uml Diagram

![](plantuml/RadioButton.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RadioButton:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RadioButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RadioButton class process the options
    self.bless( :GtkRadioButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=head2 Example

Create a group with two radio buttons

  # Create a top level window and set a title
  my Gnome::Gtk3::Window $top-window .= new(:title('Two Radio Buttons'));
  $top-window.set-border-width(20);

  # Create a grid and add it to the window
  my Gnome::Gtk3::Grid $grid .= new;
  $top-window.add($grid);

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

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Glib::SList:api<1>;

use Gnome::Gtk3::CheckButton:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkradiobutton.h
# https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
unit class Gnome::Gtk3::RadioButton:auth<github:MARTIMM>:api<1>;;
also is Gnome::Gtk3::CheckButton;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods

Creates a new B<Gnome::Gtk3::RadioButton>. To be of any practical value, a widget should then be packed into the radio button. This will create a new group.

  multi method new ( )

Create a new object and add to the group defined by the list.

  multi method new (
    Gnome::Glib::SList :$group!, Str :$label!, Bool :$mnemonic = False
  )

Create a new object and add to the group defined by another radio button object.

  multi method new (
    Gnome::Gtk3::RadioButton :$group-from!, Str :$label!,
    Bool :$mnemonic = False
  )

Create a new object with a label.

  multi method new ( Str :$label!, Bool :$mnemonic = False )

Create an object using a native object from elsewhere.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:1:new(:group, :label):
#TM:0:new(:group):
#TM:1:new(:group-from, :label):
#TM:1:new(:group-from):
#TM:1:new(:label):
#TM:4:new(:native-object):TopLevelClass
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<group-changed>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RadioButton' or ? %options<GtkRadioButton> {

    # check if native object is set by other parent class BUILDers
    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;
      my Bool $mnemonic = %options<mnemonic> // False;

      if ? %options<group> and ? %options<label> {
        my $g = %options<group>;
        $g .= _get-native-object if $g ~~ Gnome::Glib::SList;
        if $mnemonic {
          $no = _gtk_radio_button_new_with_mnemonic( $g, %options<label>);
        }

        else {
          $no = _gtk_radio_button_new_with_label( $g, %options<label>);
        }
      }

      elsif ? %options<group-from> and ? %options<label> {
        my $w = %options<group-from>;
        $w .= _get-native-object if $w ~~ Gnome::Gtk3::RadioButton;
        if $mnemonic {
          $no = _gtk_radio_button_new_with_mnemonic_from_widget(
            $w, %options<label>
          );
        }

        else {
          $no = _gtk_radio_button_new_with_label_from_widget(
            $w, %options<label>
          );
        }
      }

      elsif ? %options<group-from> {
        my $w = %options<group-from>;
        $w .= _get-native-object if $w ~~ Gnome::GObject::Object;
        $no = _gtk_radio_button_new_from_widget($w);
      }

      elsif ? %options<label> {
        $no = _gtk_radio_button_new_with_label( Any, %options<label>);
      }

      elsif ? %options<group> {
        my $g = %options<group>;
        $g .= _get-native-object if $g ~~ Gnome::Glib::SList;
        $no = _gtk_radio_button_new($g);
      }

      else {#if ? %options<empty> {
        $no = _gtk_radio_button_new(Any);
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRadioButton');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_radio_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkRadioButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:get-group:
#TM:1:get-group-rk:
=begin pod
=head2 get-group, get-group-rk

Retrieves the group assigned to a radio button.

Returns: (element-type GtkRadioButton) : a linked list containing all the radio buttons in the same group as I<radio-button>. The returned list is owned by the radio button and must not be modified or freed.

  method get-group ( --> N-GSList )
  method get-group-rk ( --> Gnome::Glib::SList )

=end pod

method get-group ( --> N-GSList ) {
  gtk_radio_button_get_group(self._get-native-object-no-reffing)
}

method get-group-rk ( --> Gnome::Glib::SList ) {
  Gnome::Glib::SList.new(:native-object(
      gtk_radio_button_get_group(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_radio_button_get_group (
  N-GObject $radio_button --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:join-group:
=begin pod
=head2 join-group

Joins a B<Gnome::Gtk3::RadioButton> object to the group of another B<Gnome::Gtk3::RadioButton> object

Use this in language bindings instead of the C<get-group()> and C<gtk-radio-button-set-group()> methods

  method join-group ( N-GObject $group_source )

=head3 Example

A common way to set up a group of radio buttons is the following:

  my Gnome::Gtk3::RadioButton $last-button;
  for @button-labels -> $label {
    my Gnome::Gtk3::RadioButton $radio-button .= new(:$label);
    $radio-button.join_group($last_button) if $last_button.defined;
    $last_button = $radio_button;
  }


=item N-GObject $group_source; a radio button object whos group we are  joining, or C<undefined> to remove the radio button from its group
=end pod

method join-group ( $group_source is copy ) {
  $group_source .= _get-native-object-no-reffing
    unless $group_source ~~ N-GObject;

  gtk_radio_button_join_group(
    self._get-native-object-no-reffing, $group_source
  );
}

sub gtk_radio_button_join_group (
  N-GObject $radio_button, N-GObject $group_source
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-group:
=begin pod
=head2 set-group

Sets a B<Gnome::Gtk3::RadioButton>’s group. It should be noted that this does not change the layout of your interface in any way, so if you are changing the group, it is likely you will need to re-arrange the user interface to reflect these changes.

  method set-group ( N-GSList $group )

=item N-GSList $group; (element-type GtkRadioButton): an existing radio button group, such as one returned from C<get-group()>, or C<undefined>.
=end pod

method set-group ( $group is copy ) {
  $group .= _get-native-object-no-reffing unless $group ~~ N-GSList;
  gtk_radio_button_set_group( self._get-native-object-no-reffing, $group);
}

sub gtk_radio_button_set_group (
  N-GObject $radio_button, N-GSList $group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new:
#`{{
=begin pod
=head2 _gtk_radio_button_new

Creates a new B<Gnome::Gtk3::RadioButton>. To be of any practical value, a widget should then be packed into the radio button.

Returns: a new radio button

  method _gtk_radio_button_new ( N-GSList $group --> N-GObject )

=item N-GSList $group; (element-type GtkRadioButton) : an existing radio button group, or C<undefined> if you are creating a new group.
=end pod
}}

sub _gtk_radio_button_new ( N-GSList $group --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_button_new_from_widget

Creates a new B<Gnome::Gtk3::RadioButton>, adding it to the same group as I<radio-group-member>. As with C<new()>, a widget should be packed into the radio button.

Returns: a new radio button.

  method _gtk_radio_button_new_from_widget ( --> N-GObject )

=end pod
}}

sub _gtk_radio_button_new_from_widget ( N-GObject $radio_group_member --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new_with_label:
#`{{
=begin pod
=head2 _gtk_radio_button_new_with_label

Creates a new B<Gnome::Gtk3::RadioButton> with a text label.

Returns: a new radio button.

  method _gtk_radio_button_new_with_label ( N-GSList $group, Str $label --> N-GObject )

=item N-GSList $group; (element-type GtkRadioButton) : an existing radio button group, or C<undefined> if you are creating a new group.
=item Str $label; the text label to display next to the radio button.
=end pod
}}

sub _gtk_radio_button_new_with_label ( N-GSList $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new_with_label_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_button_new_with_label_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> with a text label, adding it to the same group as I<radio-group-member>.

Returns: a new radio button.

  method _gtk_radio_button_new_with_label_from_widget ( Str $label --> N-GObject )

=item Str $label; a text string to display next to the radio button.
=end pod
}}

sub _gtk_radio_button_new_with_label_from_widget ( N-GObject $radio_group_member, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_label_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_radio_button_new_with_mnemonic

Creates a new B<Gnome::Gtk3::RadioButton> containing a label, adding it to the same group as I<group>. The label will be created using C<gtk-label-new-with-mnemonic()>, so underscores in I<label> indicate the mnemonic for the button.

Returns: a new B<Gnome::Gtk3::RadioButton>

  method _gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label --> N-GObject )

=item N-GSList $group; (element-type GtkRadioButton) : the radio button group, or C<undefined>
=item Str $label; the text of the button, with an underscore in front of the mnemonic character
=end pod
}}

sub _gtk_radio_button_new_with_mnemonic ( N-GSList $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_button_new_with_mnemonic_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_button_new_with_mnemonic_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> containing a label. The label will be created using C<gtk-label-new-with-mnemonic()>, so underscores in I<label> indicate the mnemonic for the button.

Returns: a new B<Gnome::Gtk3::RadioButton>

  method _gtk_radio_button_new_with_mnemonic_from_widget ( Str $label --> N-GObject )

=item Str $label; the text of the button, with an underscore in front of the mnemonic character
=end pod
}}

sub _gtk_radio_button_new_with_mnemonic_from_widget ( N-GObject $radio_group_member, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_mnemonic_from_widget')
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
=comment #TS:1:group-changed:
=head3 group-changed

Emitted when the group of radio buttons that a radio button belongs
to changes. This is emitted when a radio button switches from
being alone to being part of a group of 2 or more buttons, or
vice-versa, and when a button is moved from one group of 2 or
more buttons to a different one, but not when the composition
of the group that a button belongs to changes.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($button),
    *%user-options
  );

=item $button; the object which received the signal

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
=comment #TP:1:group:
=head3 Group: group

Sets a new group for a radio button.Widget type: GTK_TYPE_RADIO_BUTTON

The B<Gnome::GObject::Value> type of property I<group> is C<G_TYPE_OBJECT>.

Property is write only
=end pod





























=finish

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new:
#`{{
=begin pod
=head2 [gtk_] radio_button_new

Creates a new B<Gnome::Gtk3::RadioButton>. To be of any practical value, a widget should
then be packed into the radio button.

Returns: a new radio button

  method gtk_radio_button_new ( N-GSList $group --> N-GObject  )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): an existing radio button group, or C<Any> if you are creating a new group.

=end pod
}}

sub _gtk_radio_button_new ( N-GSList $group --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new_from_widget:
#`{{
=begin pod
=head2 [[gtk_] radio_button_] new_from_widget

Creates a new B<Gnome::Gtk3::RadioButton>, adding it to the same group as
I<radio_group_member>. As with C<gtk_radio_button_new()>, a widget
should be packed into the radio button.

Returns: (transfer none): a new radio button.

  method gtk_radio_button_new_from_widget ( --> N-GObject  )

=end pod
}}

sub _gtk_radio_button_new_from_widget ( N-GObject $radio_group_member --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new_with_label:
#`{{
=begin pod
=head2 [[gtk_] radio_button_] new_with_label

Creates a new B<Gnome::Gtk3::RadioButton> with a text label.

Returns: a new radio button.

  method gtk_radio_button_new_with_label ( N-GSList $group, Str $label --> N-GObject  )

=item N-GSList $group; an existing radio button group, or C<Any> if you are creating a new group.
=item Str $label; the text label to display next to the radio button.

=end pod
}}

sub _gtk_radio_button_new_with_label ( N-GSList $group, Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new_with_label_from_widget:
#`{{
=begin pod
=head2 [[gtk_] radio_button_] new_with_label_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> with a text label, adding it to
the same group.

Returns: (transfer none): a new radio button.

  method gtk_radio_button_new_with_label_from_widget ( Str $label --> N-GObject  )

=item Str $label; a text string to display next to the radio button.

=end pod
}}

sub _gtk_radio_button_new_with_label_from_widget ( N-GObject $radio_group_member, Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_label_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new_with_mnemonic:new(:mnemonic)
#`{{
=begin pod
=head2 [[gtk_] radio_button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::RadioButton> containing a label, adding it to the same
group as I<group>. The label will be created using
C<gtk_label_new_with_mnemonic()>, so underscores in I<label> indicate the
mnemonic for the button.

Returns: a new B<Gnome::Gtk3::RadioButton>

  method gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label --> N-GObject  )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioButton>) (allow-none): the radio button group, or C<Any>
=item Str $label; the text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_radio_button_new_with_mnemonic ( N-GSList $group, Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_radio_button_new_with_mnemonic_from_widget:new(:mnemonic)
#`{{
=begin pod
=head2 [[gtk_] radio_button_] new_with_mnemonic_from_widget

Creates a new B<Gnome::Gtk3::RadioButton> containing a label. The label
will be created using C<gtk_label_new_with_mnemonic()>, so underscores
in I<label> indicate the mnemonic for the button.

Returns: (transfer none): a new B<Gnome::Gtk3::RadioButton>

  method gtk_radio_button_new_with_mnemonic_from_widget ( Str $label --> N-GObject  )

=item Str $label; the text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_radio_button_new_with_mnemonic_from_widget ( N-GObject $radio_group_member, Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_button_new_with_mnemonic_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_radio_button_get_group:
=begin pod
=head2 [[gtk_] radio_button_] get_group

Retrieves the group assigned to a radio button.

Returns: a linked list containing all the radio buttons (native GtkRadioButton objects) in the same group as this I<radio_button>. The returned list is owned by the radio button and must not be modified or freed.

  method gtk_radio_button_get_group ( --> N-GSList )

=end pod

sub gtk_radio_button_get_group ( N-GObject $radio_button --> N-GSList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_radio_button_set_group:
=begin pod
=head2 [[gtk_] radio_button_] set_group

Sets a B<Gnome::Gtk3::RadioButton>’s group. It should be noted that this does not change the layout of your interface in any way, so if you are changing the group, it is likely you will need to re-arrange the user interface to reflect these changes.

  method gtk_radio_button_set_group ( N-GSList $group )

=item N-GSList $group; (native GtkRadioButton objects) an existing radio button group, such as one returned from C<gtk_radio_button_get_group()>, or undefined as an empty list.

=end pod

sub gtk_radio_button_set_group ( N-GObject $radio_button, N-GSList $group )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_radio_button_join_group:
=begin pod
=head2 [[gtk_] radio_button_] join_group

Joins a B<Gnome::Gtk3::RadioButton> object to the group of another B<Gnome::Gtk3::RadioButton> object

Use this in language bindings instead of the C<gtk_radio_button_get_group()> and C<gtk_radio_button_set_group()> methods.

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

  method gtk_radio_button_join_group ( N-GObject $group_source )

=item N-GObject $group_source; a radio button object who's group we are  joining, or undefined to remove the radio button from its group

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
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
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


  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($button),
    *%user-options
  );

=item $button; the object which received the signal


=end pod
