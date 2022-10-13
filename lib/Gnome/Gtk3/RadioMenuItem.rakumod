#TL:1:Gnome::Gtk3::RadioMenuItem:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RadioMenuItem

A choice from multiple check menu items

=comment ![](images/X.png)

=head1 Description

A radio menu item is a check menu item that belongs to a group. At each instant exactly one of the radio menu items from a group is selected.

The group list does not need to be freed, as each B<Gnome::Gtk3::RadioMenuItem> will remove itself and its list item when it is destroyed.

The correct way to create a group of radio menu items is approximatively this:

  my Gnome::Glib::SList $group .= new;
  my Gnome::Gtk3::RadioMenuItem $item;
  for ^5 -> $i {

    # Create radio menu item
    $item .= new( :$group, :label("This is an example: entry $i");

    # Get the group list to be used for the next radio menu item.
    # however, only once is enough!
    $group .= new(:native-object($item.get-group)) if $i == 0;

    # Activate 2nd item
    $item.set_active(TRUE) if $i == 1;
  }


=head2 Css Nodes

  menuitem
  ├── radio.left
  ╰── <child>

B<Gnome::Gtk3::RadioMenuItem> has a main CSS node with name menuitem, and a subnode with name radio, which gets the .left or .right style class.


=head2 See Also

B<Gnome::Gtk3::MenuItem>, B<Gnome::Gtk3::CheckMenuItem>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RadioMenuItem;
  also is Gnome::Gtk3::CheckMenuItem;
  also does Gnome::Gtk3::Actionable;


=head2 Uml Diagram

![](plantuml/MenuItem-ea.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RadioMenuItem;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RadioMenuItem;

  has Gnome::Glib::SList $!group;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RadioMenuItem class process the options
    self.bless( :GtkRadioMenuItem, |c, :group(N-GSList), :label<1st>);
  }

  submethod BUILD ( ... ) {
    $!group .= new(:native-object(self.get-group));
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

use Gnome::Glib::SList;

use Gnome::Gtk3::CheckMenuItem;
use Gnome::Gtk3::Actionable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RadioMenuItem:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::CheckMenuItem;
also does Gnome::Gtk3::Actionable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :group

Create a new RadioMenuItem object.

  multi method new ( N-GSList :$group! )

=item N-GSList $group; (element-type a native B<Gnome::Gtk3::RadioMenuItem>) group the radio menu item inside, or undefined


=head3 :group, :label

Creates a new B<Gnome::Gtk3::RadioMenuItem> whose child is a simple B<Gnome::Gtk3::Label>.

  multi method new ( N-GSList :$group!, Str :$label! )

=item N-GSList $group; (element-type a native B<Gnome::Gtk3::RadioMenuItem>) group the radio menu item inside, or undefined
=item Str $label; the text for the label


=head3 :group, :mnemonic

Creates a new B<Gnome::Gtk3::RadioMenuItem> containing a label. The label will be created using the C<:mnemonic> option to the C<.new()> call of B<Gnome::Gtk3::Label>, so underscores in I<label> indicate the mnemonic for the menu item.

  multi method new ( N-GSList :$group!, Str :$mnemonic! )

=item N-GSList $group; (element-type a native B<Gnome::Gtk3::RadioMenuItem>) group the radio menu item inside, or undefined
=item  Str $mnemonic; the text of the menu item, with an underscore in front of the mnemonic character


=head3 :group-widget

Create a new RadioMenuItem object.

  multi method new ( N-GObject :$group-widget! )

=item N-GObject $group-widget; a B<Gnome::Gtk3::RadioMenuItem> used to group the radio menu items. The first one creates the group.


=head3 :group-widget, :label

Creates a new B<Gnome::Gtk3::RadioMenuItem> whose child is a simple B<Gnome::Gtk3::Label>.

  multi method new ( N-GObject :$group-widget!, Str :$label! )

=item N-GSList $group; (element-type a native B<Gnome::Gtk3::RadioMenuItem>) group the radio menu item inside, or undefined
=item Str $label; the text for the label


=head3 :group-widget, :mnemonic

Creates a new B<Gnome::Gtk3::RadioMenuItem> containing a label. The label will be created using the C<:mnemonic> option to the C<.new()> call of B<Gnome::Gtk3::Label>, so underscores in I<label> indicate the mnemonic for the menu item.

  multi method new ( N-GObject :$group-widget!, Str :$mnemonic! )

=item N-GSList $group; (element-type a native B<Gnome::Gtk3::RadioMenuItem>) group the radio menu item inside, or undefined
=item  Str $mnemonic; the text of the menu item, with an underscore in front of the mnemonic character



=head3 :native-object

Create a RadioMenuItem object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RadioMenuItem object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:group):
#TM:1:new(:group,:label):
#TM:1:new(:group,:mnemonic):
#TM:1:new(:group-widget):
#TM:1:new(:group-widget,:label):
#TM:1:new(:group-widget,:mnemonic):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<group-changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RadioMenuItem' or %options<GtkRadioMenuItem> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      die X::Gnome.new(
        :message('Missing :group or :group-widget option to .new()')
      ) unless ( %options<group>:exists or %options<group-widget>:exists );

      my $no-group;
      if %options<group>:exists {
        $no-group = %options<group> // N-GSList;
        $no-group .= _get-native-object-no-reffing unless $no-group ~~ N-GSList;
      }

      elsif %options<group-widget>:exists {
        $no-group = %options<group-widget> // N-GObject;
        $no-group .= _get-native-object-no-reffing unless $no-group ~~ N-GObject;
      }

      my $no;
      if ? %options<label> {
        if %options<group>:exists {
          $no = _gtk_radio_menu_item_new_with_label(
            $no-group, %options<label>
          );
        }

        elsif %options<group-widget>:exists {
          $no = _gtk_radio_menu_item_new_with_label_from_widget(
            $no-group, %options<mnemonic>
          );
        }
      }

      elsif ? %options<mnemonic> {
        if %options<group>:exists {
          $no = _gtk_radio_menu_item_new_with_mnemonic(
            $no-group, %options<mnemonic>
          );
        }

        elsif %options<group-widget>:exists {
          $no = _gtk_radio_menu_item_new_with_mnemonic_from_widget(
            $no-group, %options<mnemonic>
          );
        }
      }

      # no label nor mnemonic
      elsif %options<group>:exists {
        $no = _gtk_radio_menu_item_new($no-group);
      }

      elsif %options<group-widget>:exists {
        $no = _gtk_radio_menu_item_new_from_widget($no-group);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_radio_menu_item_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRadioMenuItem');

  }
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new

Creates a new B<Gnome::Gtk3::RadioMenuItem>.

Returns: a new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new ( N-GSList $group --> N-GObject )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioMenuItem>) (allow-none): the group to which the radio menu item is to be attached, or C<Any>

=end pod
}}

sub _gtk_radio_menu_item_new ( N-GSList $group --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new_with_label:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new_with_label

Creates a new B<Gnome::Gtk3::RadioMenuItem> whose child is a simple B<Gnome::Gtk3::Label>.

Returns: (transfer none): A new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new_with_label ( N-GSList $group,  Str  $label --> N-GObject )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioMenuItem>) (allow-none): group the radio menu item is inside, or C<Any>
=item  Str  $label; the text for the label

=end pod
}}

sub _gtk_radio_menu_item_new_with_label ( N-GSList $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new_with_mnemonic

Creates a new B<Gnome::Gtk3::RadioMenuItem> containing a label. The label will be created using C<gtk_label_new_with_mnemonic()>, so underscores in I<label> indicate the mnemonic for the menu item.

Returns: a new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new_with_mnemonic ( N-GSList $group,  Str  $label --> N-GObject )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioMenuItem>) (allow-none): group the radio menu item is inside, or C<Any>
=item  Str  $label; the text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_radio_menu_item_new_with_mnemonic ( N-GSList $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new_from_widget

Creates a new B<Gnome::Gtk3::RadioMenuItem> adding it to the same group as I<group>.

Returns: (transfer none): The new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new_from_widget ( --> N-GObject )


=end pod
}}

sub _gtk_radio_menu_item_new_from_widget ( N-GObject $group --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new_with_mnemonic_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new_with_mnemonic_from_widget

Creates a new B<Gnome::Gtk3::RadioMenuItem> containing a label. The label will be created using C<gtk_label_new_with_mnemonic()>, so underscores in label indicate the mnemonic for the menu item.  The new B<Gnome::Gtk3::RadioMenuItem> is added to the same group as I<group>.

Returns: (transfer none): The new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new_with_mnemonic_from_widget (  Str  $label --> N-GObject )

=item  Str  $label; (allow-none): the text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_radio_menu_item_new_with_mnemonic_from_widget ( N-GObject $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new_with_mnemonic_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_radio_menu_item_new_with_label_from_widget:
#`{{
=begin pod
=head2 _gtk_radio_menu_item_new_with_label_from_widget

Creates a new B<Gnome::Gtk3::RadioMenuItem> whose child is a simple B<Gnome::Gtk3::Label>. The new B<Gnome::Gtk3::RadioMenuItem> is added to the same group as I<group>.

Returns: (transfer none): The new B<Gnome::Gtk3::RadioMenuItem>

  method _gtk_radio_menu_item_new_with_label_from_widget (  Str  $label --> N-GObject )

=item  Str  $label; (allow-none): the text for the label

=end pod
}}

sub _gtk_radio_menu_item_new_with_label_from_widget ( N-GObject $group, gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_radio_menu_item_new_with_label_from_widget')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-group:
=begin pod
=head2 get-group

Returns the group to which the radio menu item belongs, as a B<GList> of B<Gnome::Gtk3::RadioMenuItem>. The list belongs to GTK+ and should not be freed.

Returns: (element-type B<Gnome::Gtk3::RadioMenuItem>) (transfer none): the group of I<radio_menu_item>

  method get-group ( --> N-GSList )


=end pod

method get-group ( --> N-GSList ) {

  gtk_radio_menu_item_get_group(
    self._f('GtkRadioMenuItem'),
  );
}

sub gtk_radio_menu_item_get_group ( N-GObject $radio_menu_item --> N-GSList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-group:
=begin pod
=head2 set-group

Sets the group of a radio menu item, or changes it.

  method set-group ( N-GSList $group )

=item N-GSList $group; (element-type B<Gnome::Gtk3::RadioMenuItem>) (allow-none): the new group, or undefined.

=end pod

method set-group ( $group ) {

  my $no = $group;
  $no .= _get-native-object-no-reffing unless $no ~~ N-GSList;

  gtk_radio_menu_item_set_group(
    self._f('GtkRadioMenuItem'), $no
  );
}

sub gtk_radio_menu_item_set_group ( N-GObject $radio_menu_item, N-GSList $group  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:join-group:
=begin pod
=head2 join-group

Joins a B<Gnome::Gtk3::RadioMenuItem> object to the group of another B<Gnome::Gtk3::RadioMenuItem> object.  This function should be used by language bindings to avoid the memory manangement of the opaque B<GSList> of C<gtk_radio_menu_item_get_group()> and C<gtk_radio_menu_item_set_group()>.  A common way to set up a group of B<Gnome::Gtk3::RadioMenuItem> instances is:  |[ B<Gnome::Gtk3::RadioMenuItem> *last_item = NULL;  while ( ...more items to add... ) { B<Gnome::Gtk3::RadioMenuItem> *radio_item;  radio_item = gtk_radio_menu_item_new (...);  gtk_radio_menu_item_join_group (radio_item, last_item); last_item = radio_item; } ]|

  method join-group ( N-GObject $group-source )

=item N-GObject $group_source; (allow-none): a B<Gnome::Gtk3::RadioMenuItem> whose group we are joining, or C<Any> to remove the I<radio_menu_item> from its current group

=end pod

method join-group ( $group-source ) {
  my $no = $group-source;
  $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_radio_menu_item_join_group(
    self._f('GtkRadioMenuItem'), $no
  );
}

sub gtk_radio_menu_item_join_group ( N-GObject $radio_menu_item, N-GObject $group-source  )
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


=comment #TS:0:group-changed:
=head3 group-changed

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($radiomenuitem),
    *%user-options
  );

=item $radiomenuitem;

=end pod

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment # TP:0:group:
=head3 Group


The radio menu item whose group this widget belongs to.

   * Since: 2.8Widget type: GTK_TYPE_RADIO_MENU_ITEM

The B<Gnome::GObject::Value> type of property I<group> is C<G_TYPE_OBJECT>.
=end pod
}}
