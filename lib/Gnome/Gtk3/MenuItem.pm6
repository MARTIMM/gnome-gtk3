#TL:1:Gnome::Gtk3::MenuItem:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::MenuItem

The widget used for item in menus

=head1 Description


The B<Gnome::Gtk3::MenuItem> widget and the derived widgets are the only valid
children for menus. Their function is to correctly handle highlighting,
alignment, events and submenus.

As a B<Gnome::Gtk3::MenuItem> derives from B<Gnome::Gtk3::Bin> it can hold any valid child widget,
although only a few are really useful.

By default, a B<Gnome::Gtk3::MenuItem> sets a B<Gnome::Gtk3::AccelLabel> as its child.
B<Gnome::Gtk3::MenuItem> has direct functions to set the label and its mnemonic.
For more advanced label settings, you can fetch the child widget from the B<Gnome::Gtk3::Bin>.

=begin comment
An example for setting markup and accelerator on a MenuItem:

  my Gnome::Gtk3::Label $label = $menu-item.get-child;
  $label.set-markup('<i>new label</i> with <b>markup</b>');
  $label.

B<Gnome::Gtk3::Widget> *child = gtk_bin_get_child (GTK_BIN (menu_item));
gtk_label_set_markup (GTK_LABEL (child), "<i>new label</i> with <b>markup</b>");
gtk_accel_label_set_accel (GTK_ACCEL_LABEL (child), GDK_KEY_1, 0);
=end comment

=head2 Gnome::Gtk3::MenuItem as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::MenuItem> implementation of the B<Gnome::Gtk3::Buildable> interface supports
adding a submenu by specifying “submenu” as the “type” attribute of
a <child> element.

An example of UI definition fragment with submenus:

  <object class="B<Gnome::Gtk3::MenuItem>">
    <child type="submenu">
      <object class="B<Gnome::Gtk3::Menu>"/>
    </child>
  </object>


=head2 Css Nodes

  menuitem
  ├── <child>
  ╰── [arrow.right]

B<Gnome::Gtk3::MenuItem> has a single CSS node with name menuitem. If the menuitem
has a submenu, it gets another CSS node with name arrow, which has
the .left or .right style class.

=head2 Implemented Interfaces

Gnome::Gtk3::MenuItem implements
=item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item Gnome::Gtk3::Activatable
=item Gnome::Gtk3::Actionable

=head2 See Also

B<Gnome::Gtk3::Bin>, B<Gnome::Gtk3::MenuShell>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuItem;
  also is Gnome::Gtk3::Bin;
  also does Gnome::Gtk3::Buildable;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuItem:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create a new object with a label.

  multi method new ( Str :$label! )

Create a new object with a mnemonic.

  multi method new ( Str :$mnemonic! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:empty):
#TM:1:new(:label):
#TM:1:new(:mnemonic):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<activate activate-item select deselect>,
#    :w1<toggle-size-request toggle-size-allocate>,
    :w1<toggle-size-allocate>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::MenuItem';

  # process all named arguments
  if ? %options<empty> {
    self.set-native-object(gtk_menu_item_new());
  }

  elsif ? %options<label> {
    self.set-native-object(gtk_menu_item_new_with_label(%options<label>));
  }

  elsif ? %options<mnemonic> {
    self.set-native-object(gtk_menu_item_new_with_mnemonic(%options<mnemonic>));
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkMenuItem');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_item_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_menu_item_new:new(:empty)
=begin pod
=head2 [gtk_] menu_item_new

Creates a new B<Gnome::Gtk3::MenuItem>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new ( --> N-GObject  )


=end pod

sub gtk_menu_item_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_item_new_with_label:new(:label)
=begin pod
=head2 [[gtk_] menu_item_] new_with_label

Creates a new B<Gnome::Gtk3::MenuItem> whose child is a B<Gnome::Gtk3::Label>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new_with_label ( Str $label --> N-GObject  )

=item Str $label; the text for the label

=end pod

sub gtk_menu_item_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_item_new_with_mnemonic:new(:mnemonic)
=begin pod
=head2 [[gtk_] menu_item_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::MenuItem> containing a label.

The label will be created using C<gtk_label_new_with_mnemonic()>,
so underscores in I<label> indicate the mnemonic for the menu item.

Returns: a new B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_menu_item_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_set_submenu:
=begin pod
=head2 [[gtk_] menu_item_] set_submenu

Sets or replaces the menu item’s submenu, or removes it when a C<Any>
submenu is passed.

  method gtk_menu_item_set_submenu ( N-GObject $submenu )

=item N-GObject $submenu; (allow-none) (type B<Gnome::Gtk3::.Menu>): the submenu, or C<Any>

=end pod

sub gtk_menu_item_set_submenu ( N-GObject $menu_item, N-GObject $submenu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_get_submenu:
=begin pod
=head2 [[gtk_] menu_item_] get_submenu

Gets the submenu underneath this menu item, if any.
See C<gtk_menu_item_set_submenu()>.

Returns: (nullable) (transfer none): submenu for this menu item, or C<Any> if none

  method gtk_menu_item_get_submenu ( --> N-GObject  )


=end pod

sub gtk_menu_item_get_submenu ( N-GObject $menu_item )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_select:
=begin pod
=head2 [gtk_] menu_item_select

Emits the  I<select> signal on the given item.

  method gtk_menu_item_select ( )


=end pod

sub gtk_menu_item_select ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_deselect:
=begin pod
=head2 [gtk_] menu_item_deselect

Emits the  I<deselect> signal on the given item.

  method gtk_menu_item_deselect ( )


=end pod

sub gtk_menu_item_deselect ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_activate:
=begin pod
=head2 [gtk_] menu_item_activate

Emits the  I<activate> signal on the given item

  method gtk_menu_item_activate ( )


=end pod

sub gtk_menu_item_activate ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_toggle_size_request:
=begin pod
=head2 [[gtk_] menu_item_] toggle_size_request

Emits the  I<toggle-size-request> signal on the given item.

  method gtk_menu_item_toggle_size_request ( Int $requisition )

=item Int $requisition; (inout): the requisition to use as signal data.

=end pod

sub gtk_menu_item_toggle_size_request ( N-GObject $menu_item, int32 $requisition )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_toggle_size_allocate:
=begin pod
=head2 [[gtk_] menu_item_] toggle_size_allocate

Emits the  I<toggle-size-allocate> signal on the given item.

  method gtk_menu_item_toggle_size_allocate ( Int $allocation )

=item Int $allocation; the allocation to use as signal data.

=end pod

sub gtk_menu_item_toggle_size_allocate ( N-GObject $menu_item, int32 $allocation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_set_accel_path:
=begin pod
=head2 [[gtk_] menu_item_] set_accel_path

Set the accelerator path on I<menu_item>, through which runtime
changes of the menu item’s accelerator caused by the user can be
identified and saved to persistent storage (see C<gtk_accel_map_save()>
on this). To set up a default accelerator for this menu item, call
C<gtk_accel_map_add_entry()> with the same I<accel_path>. See also
C<gtk_accel_map_add_entry()> on the specifics of accelerator paths,
and C<gtk_menu_set_accel_path()> for a more convenient variant of
this function.

This function is basically a convenience wrapper that handles
calling C<gtk_widget_set_accel_path()> with the appropriate accelerator
group for the menu item.

Note that you do need to set an accelerator on the parent menu with
C<gtk_menu_set_accel_group()> for this to work.

Note that I<accel_path> string will be stored in a B<GQuark>.
Therefore, if you pass a static string, you can save some memory
by interning it first with C<g_intern_static_string()>.

  method gtk_menu_item_set_accel_path ( Str $accel_path )

=item Str $accel_path; (allow-none): accelerator path, corresponding to this menu item’s functionality, or C<Any> to unset the current path.

=end pod

sub gtk_menu_item_set_accel_path ( N-GObject $menu_item, Str $accel_path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_get_accel_path:
=begin pod
=head2 [[gtk_] menu_item_] get_accel_path

Retrieve the accelerator path that was previously set on I<menu_item>.

See C<gtk_menu_item_set_accel_path()> for details.

Returns: (nullable) (transfer none): the accelerator path corresponding to
this menu item’s functionality, or C<Any> if not set

Since: 2.14

  method gtk_menu_item_get_accel_path ( --> Str  )


=end pod

sub gtk_menu_item_get_accel_path ( N-GObject $menu_item )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_set_label:
=begin pod
=head2 [[gtk_] menu_item_] set_label

Sets I<text> on the I<menu_item> label

Since: 2.16

  method gtk_menu_item_set_label ( Str $label )

=item Str $label; the text you want to set

=end pod

sub gtk_menu_item_set_label ( N-GObject $menu_item, Str $label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_get_label:
=begin pod
=head2 [[gtk_] menu_item_] get_label

Sets I<text> on the I<menu_item> label

Returns: The text in the I<menu_item> label. This is the internal
string used by the label, and must not be modified.

Since: 2.16

  method gtk_menu_item_get_label ( --> Str  )


=end pod

sub gtk_menu_item_get_label ( N-GObject $menu_item )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_set_use_underline:
=begin pod
=head2 [[gtk_] menu_item_] set_use_underline

If true, an underline in the text indicates the next character
should be used for the mnemonic accelerator key.

Since: 2.16

  method gtk_menu_item_set_use_underline ( Int $setting )

=item Int $setting; C<1> if underlines in the text indicate mnemonics

=end pod

sub gtk_menu_item_set_use_underline ( N-GObject $menu_item, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_get_use_underline:
=begin pod
=head2 [[gtk_] menu_item_] get_use_underline

Checks if an underline in the text indicates the next character
should be used for the mnemonic accelerator key.

Returns: C<1> if an embedded underline in the label
indicates the mnemonic accelerator key.

Since: 2.16

  method gtk_menu_item_get_use_underline ( --> Int  )


=end pod

sub gtk_menu_item_get_use_underline ( N-GObject $menu_item )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_set_reserve_indicator:
=begin pod
=head2 [[gtk_] menu_item_] set_reserve_indicator

Sets whether the I<menu_item> should reserve space for
the submenu indicator, regardless if it actually has
a submenu or not.

There should be little need for applications to call
this functions.

Since: 3.0

  method gtk_menu_item_set_reserve_indicator ( Int $reserve )

=item Int $reserve; the new value

=end pod

sub gtk_menu_item_set_reserve_indicator ( N-GObject $menu_item, int32 $reserve )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_item_get_reserve_indicator:
=begin pod
=head2 [[gtk_] menu_item_] get_reserve_indicator

Returns whether the I<menu_item> reserves space for
the submenu indicator, regardless if it has a submenu
or not.

Returns: C<1> if I<menu_item> always reserves space for the
submenu indicator

Since: 3.0

  method gtk_menu_item_get_reserve_indicator ( --> Int  )


=end pod

sub gtk_menu_item_get_reserve_indicator ( N-GObject $menu_item )
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


=comment #TS:0:activate:
=head3 activate

Emitted when the item is activated.

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.


=comment #TS:0:activate-item:
=head3 activate-item

Emitted when the item is activated, but also if the menu item has a
submenu. For normal applications, the relevant signal is
 I<activate>.

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.


=begin comment
=comment #TS:0:toggle-size-request:
=head3 toggle-size-request

  method handler (
    Unknown type G_TYPE_POINTER $unknown type g_type_pointer,
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $unknown type g_type_pointer;
=end comment

=comment #TS:0:toggle-size-allocate:
=head3 toggle-size-allocate

  method handler (
    Int $int,
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $int; ?

=comment #TS:0:select:
=head3 select

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem;

=comment #TS:0:deselect:
=head3 deselect

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    *%user-options
  );

=item $menuitem;

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:right-justified:
=head3 Right Justified


Sets whether the menu item appears justified
at the right side of a menu bar.
Since: 2.14

The B<Gnome::GObject::Value> type of property I<right-justified> is C<G_TYPE_BOOLEAN>.

=begin comment
=comment #TP:0:submenu:
=head3 Submenu


The submenu attached to the menu item, or C<Any> if it has none.
Since: 2.12
Widget type: GTK_TYPE_MENU

The B<Gnome::GObject::Value> type of property I<submenu> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:accel-path:
=head3 Accel Path


Sets the accelerator path of the menu item, through which runtime
changes of the menu item's accelerator caused by the user can be
identified and saved to persistant storage.
Since: 2.14

The B<Gnome::GObject::Value> type of property I<accel-path> is C<G_TYPE_STRING>.

=comment #TP:0:label:
=head3 Label


The text for the child label.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment #TP:0:use-underline:
=head3 Use underline


C<1> if underlines in the text indicate mnemonics.
Since: 2.16

The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.
=end pod



















=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_item_new

Creates a new B<Gnome::Gtk3::MenuItem>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new ( --> N-GObject  )


=end pod

sub gtk_menu_item_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] new_with_label

Creates a new B<Gnome::Gtk3::MenuItem> whose child is a B<Gnome::Gtk3::Label>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new_with_label ( Str $label --> N-GObject  )

=item Str $label; the text for the label

=end pod

sub gtk_menu_item_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::MenuItem> containing a label.

The label will be created using C<gtk_label_new_with_mnemonic()>,
so underscores in I<label> indicate the mnemonic for the menu item.

Returns: a new B<Gnome::Gtk3::MenuItem>

  method gtk_menu_item_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_menu_item_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] set_submenu

Sets or replaces the menu item’s submenu, or removes it when a C<Any>
submenu is passed.

  method gtk_menu_item_set_submenu ( N-GObject $submenu )

=item N-GObject $submenu; (allow-none) (type B<Gnome::Gtk3::.Menu>): the submenu, or C<Any>

=end pod

sub gtk_menu_item_set_submenu ( N-GObject $menu_item, N-GObject $submenu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] get_submenu

Gets the submenu underneath this menu item, if any.
See C<gtk_menu_item_set_submenu()>.

Returns: (nullable) (transfer none): submenu for this menu item, or C<Any> if none

  method gtk_menu_item_get_submenu ( --> N-GObject  )


=end pod

sub gtk_menu_item_get_submenu ( N-GObject $menu_item )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_item_select

Emits the sig C<select> signal on the given item.

  method gtk_menu_item_select ( )


=end pod

sub gtk_menu_item_select ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_item_deselect

Emits the sig C<deselect> signal on the given item.

  method gtk_menu_item_deselect ( )


=end pod

sub gtk_menu_item_deselect ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_item_activate

Emits the sig C<activate> signal on the given item

  method gtk_menu_item_activate ( )


=end pod

sub gtk_menu_item_activate ( N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] toggle_size_request

Emits the sig C<toggle-size-request> signal on the given item.

  method gtk_menu_item_toggle_size_request ( Int $requisition )

=item Int $requisition; (inout): the requisition to use as signal data.

=end pod

sub gtk_menu_item_toggle_size_request ( N-GObject $menu_item, int32 $requisition )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] toggle_size_allocate

Emits the sig C<toggle-size-allocate> signal on the given item.

  method gtk_menu_item_toggle_size_allocate ( Int $allocation )

=item Int $allocation; the allocation to use as signal data.

=end pod

sub gtk_menu_item_toggle_size_allocate ( N-GObject $menu_item, int32 $allocation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] set_accel_path

Set the accelerator path on I<menu_item>, through which runtime
changes of the menu item’s accelerator caused by the user can be
identified and saved to persistent storage (see C<gtk_accel_map_save()>
on this). To set up a default accelerator for this menu item, call
C<gtk_accel_map_add_entry()> with the same I<accel_path>. See also
C<gtk_accel_map_add_entry()> on the specifics of accelerator paths,
and C<gtk_menu_set_accel_path()> for a more convenient variant of
this function.

This function is basically a convenience wrapper that handles
calling C<gtk_widget_set_accel_path()> with the appropriate accelerator
group for the menu item.

Note that you do need to set an accelerator on the parent menu with
C<gtk_menu_set_accel_group()> for this to work.

Note that I<accel_path> string will be stored in a C<GQuark>.
Therefore, if you pass a static string, you can save some memory
by interning it first with C<g_intern_static_string()>.

  method gtk_menu_item_set_accel_path ( Str $accel_path )

=item Str $accel_path; (allow-none): accelerator path, corresponding to this menu item’s functionality, or C<Any> to unset the current path.

=end pod

sub gtk_menu_item_set_accel_path ( N-GObject $menu_item, Str $accel_path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] get_accel_path

Retrieve the accelerator path that was previously set on I<menu_item>.

See C<gtk_menu_item_set_accel_path()> for details.

Returns: (nullable) (transfer none): the accelerator path corresponding to
this menu item’s functionality, or C<Any> if not set

Since: 2.14

  method gtk_menu_item_get_accel_path ( --> Str  )


=end pod

sub gtk_menu_item_get_accel_path ( N-GObject $menu_item )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] set_label

Sets I<text> on the I<menu_item> label

Since: 2.16

  method gtk_menu_item_set_label ( Str $label )

=item Str $label; the text you want to set

=end pod

sub gtk_menu_item_set_label ( N-GObject $menu_item, Str $label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] get_label

Sets I<text> on the I<menu_item> label

Returns: The text in the I<menu_item> label. This is the internal
string used by the label, and must not be modified.

Since: 2.16

  method gtk_menu_item_get_label ( --> Str  )


=end pod

sub gtk_menu_item_get_label ( N-GObject $menu_item )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] set_use_underline

If true, an underline in the text indicates the next character
should be used for the mnemonic accelerator key.

Since: 2.16

  method gtk_menu_item_set_use_underline ( Int $setting )

=item Int $setting; C<1> if underlines in the text indicate mnemonics

=end pod

sub gtk_menu_item_set_use_underline ( N-GObject $menu_item, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] get_use_underline

Checks if an underline in the text indicates the next character
should be used for the mnemonic accelerator key.

Returns: C<1> if an embedded underline in the label
indicates the mnemonic accelerator key.

Since: 2.16

  method gtk_menu_item_get_use_underline ( --> Int  )


=end pod

sub gtk_menu_item_get_use_underline ( N-GObject $menu_item )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] set_reserve_indicator

Sets whether the I<menu_item> should reserve space for
the submenu indicator, regardless if it actually has
a submenu or not.

There should be little need for applications to call
this functions.

Since: 3.0

  method gtk_menu_item_set_reserve_indicator ( Int $reserve )

=item Int $reserve; the new value

=end pod

sub gtk_menu_item_set_reserve_indicator ( N-GObject $menu_item, int32 $reserve )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_item_] get_reserve_indicator

Returns whether the I<menu_item> reserves space for
the submenu indicator, regardless if it has a submenu
or not.

Returns: C<1> if I<menu_item> always reserves space for the
submenu indicator

Since: 3.0

  method gtk_menu_item_get_reserve_indicator ( --> Int  )


=end pod

sub gtk_menu_item_get_reserve_indicator ( N-GObject $menu_item )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.2
=head3 method gtk_menu_item_set_right_justified ( Int $right_justified )
=head3 method gtk_menu_item_get_right_justified ( --> Int  )
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=begin comment

=head2 Supported signals

=head2 Unsupported signals

=end comment

=head2 Not yet supported signals


=head3 activate

Emitted when the item is activated.

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    :$user-option1, ..., :$user-optionN
  );

=item $menuitem; the object which received the signal.


=head3 activate-item

Emitted when the item is activated, but also if the menu item has a
submenu. For normal applications, the relevant signal is
sig C<activate>.

  method handler (
    Gnome::GObject::Object :widget($menuitem),
    :$user-option1, ..., :$user-optionN
  );

=item $menuitem; the object which received the signal.


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties


=head3 right-justified

The B<Gnome::GObject::Value> type of property I<right-justified> is C<G_TYPE_BOOLEAN>.

Sets whether the menu item appears justified
at the right side of a menu bar.

Since: 2.14



=head3 submenu

The B<Gnome::GObject::Value> type of property I<submenu> is C<G_TYPE_OBJECT>.

The submenu attached to the menu item, or C<Any> if it has none.

Since: 2.12



=head3 accel-path

The B<Gnome::GObject::Value> type of property I<accel-path> is C<G_TYPE_STRING>.

Sets the accelerator path of the menu item, through which runtime
changes of the menu item's accelerator caused by the user can be
identified and saved to persistant storage.

Since: 2.14



=head3 label

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

The text for the child label.

Since: 2.16



=head3 use-underline

The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.

C<1> if underlines in the text indicate mnemonics.

Since: 2.16


=end pod








=finish

use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkmenuitem.h
# https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
unit class Gnome::Gtk3::MenuItem:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
sub gtk_menu_item_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<activate activate-item deselect select >,
    :int<toggle-size-allocate>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::MenuItem';

  if ? %options<empty> {
    self.set-native-object(gtk_menu_item_new());
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
  try { $s = &::("gtk_menu_item_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
