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

By default, a B<Gnome::Gtk3::MenuItem> sets a B<Gnome::Gtk3::AccelLabel> as its child. B<Gnome::Gtk3::MenuItem> has direct functions to set the label and its mnemonic. For more advanced label settings, you can fetch the child widget from the B<Gnome::Gtk3::Bin>.


=head2 Gnome::Gtk3::MenuItem as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::MenuItem> implementation of the B<Gnome::Gtk3::Buildable> interface supports adding a submenu by specifying “submenu” as the “type” attribute of a <child> element.

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

B<Gnome::Gtk3::MenuItem> has a single CSS node with name menuitem. If the menuitem has a submenu, it gets another CSS node with name arrow, which has the .left or .right style class.


=head2 See Also

B<Gnome::Gtk3::Bin>, B<Gnome::Gtk3::MenuShell>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuItem;
  also is Gnome::Gtk3::Bin;
  also does Gnome::Gtk3::Actionable;


=head2 Uml Diagram

![](plantuml/MenuItem-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::MenuItem;

  unit class MyGuiClass;
  also is Gnome::Gtk3::MenuItem;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::MenuItem class process the options
    self.bless( :GtkMenuItem, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=begin comment
=head2 Example

An example for setting markup and accelerator on a MenuItem:

  my Gnome::Gtk3::MenuItem $menu-item .= new(:label("Example Menu Item"));
  my Gnome::Gtk3::AccelLabel $label = $menu-item.get-child-rk;
  $label.set-markup('<i>new label</i> with <b>markup</b>');
  $label.set-accel( GDK_KEY_1, 0);

The code C<GDK_KEY_1> can be found in B<Gnome::Gdk3::Keysyms>.
=end comment

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Actionable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuItem:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;
also does Gnome::Gtk3::Actionable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new plain object.

  multi method new ( )


=head3 :label

Create a new object with a label.

  multi method new ( Str :$label! )


=head3 :mnemonic

Create a new object with a mnemonic.

  multi method new ( Str :$mnemonic! )


=head3 :native-object

Create a MenuItem object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a MenuItem object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
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
  if self.^name eq 'Gnome::Gtk3::MenuItem' #`{{ or %options<GtkMenuItem> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;

      # process all named arguments
      if ? %options<label> {
        $no = _gtk_menu_item_new_with_label(%options<label>);
      }

      elsif ? %options<mnemonic> {
        $no = _gtk_menu_item_new_with_mnemonic(%options<mnemonic>);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_menu_item_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkMenuItem');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_item_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:activate:
=begin pod
=head2 activate

Emits the  I<activate> signal on the given item.

  method activate ( )

=end pod

method activate ( ) {
  gtk_menu_item_activate(self._f('GtkMenuItem'));
}

sub gtk_menu_item_activate (
  N-GObject $menu_item
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:deselect:
=begin pod
=head2 deselect

Emits the  I<deselect> signal on the given item.

  method deselect ( )

=end pod

method deselect ( ) {
  gtk_menu_item_deselect(self._f('GtkMenuItem'));
}

sub gtk_menu_item_deselect (
  N-GObject $menu_item
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-accel-path:
=begin pod
=head2 get-accel-path

Retrieve the accelerator path that was previously set on I<menu-item>.

See C<set-accel-path()> for details.

Returns: the accelerator path corresponding to this menu item’s functionality, or C<undefined> if not set

  method get-accel-path ( --> Str )

=end pod

method get-accel-path ( --> Str ) {
  gtk_menu_item_get_accel_path(self._f('GtkMenuItem'))
}

sub gtk_menu_item_get_accel_path (
  N-GObject $menu_item --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-label:
=begin pod
=head2 get-label

Sets I<text> on the I<menu-item> label

Returns: The text in the I<menu-item> label. This is the internal string used by the label, and must not be modified.

  method get-label ( --> Str )

=end pod

method get-label ( --> Str ) {

  gtk_menu_item_get_label(
    self._f('GtkMenuItem'),
  )
}

sub gtk_menu_item_get_label (
  N-GObject $menu_item --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-reserve-indicator:
=begin pod
=head2 get-reserve-indicator

Returns whether the I<menu-item> reserves space for the submenu indicator, regardless if it has a submenu or not.

Returns: C<True> if I<menu-item> always reserves space for the submenu indicator

  method get-reserve-indicator ( --> Bool )

=end pod

method get-reserve-indicator ( --> Bool ) {
  gtk_menu_item_get_reserve_indicator(self._f('GtkMenuItem')).Bool
}

sub gtk_menu_item_get_reserve_indicator (
  N-GObject $menu_item --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-submenu:
#TM:1:get-submenu-rk:
=begin pod
=head2 get-submenu

Gets the submenu underneath this menu item, if any. See C<set-submenu()>.

Returns: submenu for this menu item, or C<undefined> if none

  method get-submenu ( --> N-GObject )

=end pod

method get-submenu ( --> N-GObject ) {

  gtk_menu_item_get_submenu(
    self._f('GtkMenuItem'),
  )
}

sub gtk_menu_item_get_submenu (
  N-GObject $menu_item --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-use-underline:
=begin pod
=head2 get-use-underline

Checks if an underline in the text indicates the next character should be used for the mnemonic accelerator key.

Returns: C<True> if an embedded underline in the label indicates the mnemonic accelerator key.

  method get-use-underline ( --> Bool )

=end pod

method get-use-underline ( --> Bool ) {
  gtk_menu_item_get_use_underline(self._f('GtkMenuItem')).Bool
}

sub gtk_menu_item_get_use_underline (
  N-GObject $menu_item --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select:
=begin pod
=head2 select

Emits the I<select> signal on the given item.

  method select ( )

=end pod

method select ( ) {
  gtk_menu_item_select(self._f('GtkMenuItem'));
}

sub gtk_menu_item_select (
  N-GObject $menu_item
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-accel-path:
=begin pod
=head2 set-accel-path

Set the accelerator path on the I<menu-item>, through which runtime changes of the menu item’s accelerator caused by the user can be identified and saved to persistent storage (see C<Gnome::Gtk3::AccelMap.save()> on this). To set up a default accelerator for this menu item, call C<Gnome::Gtk3::AccelMap.add-entry()> with the same I<accel-path>. See also C<Gnome::Gtk3::AccelMap.add-entry()> on the specifics of accelerator paths, and C<Gnome::Gtk3::Menu.set-accel-path()> for a more convenient variant of this function.

This function is basically a convenience wrapper that handles calling C<Gnome::Gtk3::Widget.set-accel-path()> with the appropriate accelerator group for the menu item.

Note that you do need to set an accelerator on the parent menu with C<Gnome::Gtk3::Menu.set-accel-group()> for this to work.

=comment Note that I<accel-path> string will be stored in a B<Gnome::Gtk3::Quark>. Therefore, if you pass a static string, you can save some memory by interning it first with C<g-intern-static-string()>.

  method set-accel-path ( Str $accel_path )

=item Str $accel_path; accelerator path, corresponding to this menu item’s functionality, or C<undefined> to unset the current path.
=end pod

method set-accel-path ( Str $accel_path ) {
  gtk_menu_item_set_accel_path( self._f('GtkMenuItem'), $accel_path);
}

sub gtk_menu_item_set_accel_path (
  N-GObject $menu_item, gchar-ptr $accel_path
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-label:
=begin pod
=head2 set-label

Sets I<$label> on the I<menu-item> label

  method set-label ( Str $label )

=item Str $label; the text you want to set
=end pod

method set-label ( Str $label ) {
  gtk_menu_item_set_label( self._f('GtkMenuItem'), $label);
}

sub gtk_menu_item_set_label (
  N-GObject $menu_item, gchar-ptr $label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-reserve-indicator:
=begin pod
=head2 set-reserve-indicator

Sets whether the I<menu-item> should reserve space for the submenu indicator, regardless if it actually has a submenu or not.

There should be little need for applications to call this functions.

  method set-reserve-indicator ( Bool $reserve )

=item Bool $reserve; the new value
=end pod

method set-reserve-indicator ( Bool $reserve ) {
  gtk_menu_item_set_reserve_indicator( self._f('GtkMenuItem'), $reserve);
}

sub gtk_menu_item_set_reserve_indicator (
  N-GObject $menu_item, gboolean $reserve
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-submenu:
=begin pod
=head2 set-submenu

Sets or replaces the menu item’s submenu, or removes it when a C<undefined> submenu is passed.

  method set-submenu ( N-GObject $submenu )

=item N-GObject $submenu; (type Gnome::Gtk3::Menu): the submenu, or C<undefined>
=end pod

method set-submenu ( $submenu is copy ) {
  $submenu .= _get-native-object-no-reffing unless $submenu ~~ N-GObject;
  gtk_menu_item_set_submenu( self._f('GtkMenuItem'), $submenu);
}

sub gtk_menu_item_set_submenu (
  N-GObject $menu_item, N-GObject $submenu
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-use-underline:
=begin pod
=head2 set-use-underline

If true, an underline in the text indicates the next character should be used for the mnemonic accelerator key.

  method set-use-underline ( Bool $setting )

=item Bool $setting; C<True> if underlines in the text indicate mnemonics
=end pod

method set-use-underline ( Bool $setting ) {
  gtk_menu_item_set_use_underline( self._f('GtkMenuItem'), $setting);
}

sub gtk_menu_item_set_use_underline (
  N-GObject $menu_item, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:toggle-size-allocate:
=begin pod
=head2 toggle-size-allocate

Emits the  I<toggle-size-allocate> signal on the given item.

  method toggle-size-allocate ( Int() $allocation )

=item Int() $allocation; the allocation to use as signal data.
=end pod

method toggle-size-allocate ( Int() $allocation ) {
  gtk_menu_item_toggle_size_allocate( self._f('GtkMenuItem'), $allocation);
}

sub gtk_menu_item_toggle_size_allocate (
  N-GObject $menu_item, gint $allocation
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:toggle-size-request:
=begin pod
=head2 toggle-size-request

Emits the  I<toggle-size-request> signal on the given item.

  method toggle-size-request ( --> Int )

The method returns an integer $requisition;
=end pod

method toggle-size-request ( --> Int ) {
  gtk_menu_item_toggle_size_request(
    self._f('GtkMenuItem'), my gint $requisition
  );

  $requisition
}

sub gtk_menu_item_toggle_size_request (
  N-GObject $menu_item, gint $requisition is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_menu_item_new:
#`{{
=begin pod
=head2 _gtk_menu_item_new

Creates a new B<Gnome::Gtk3::MenuItem>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method _gtk_menu_item_new ( --> N-GObject )

=end pod
}}

sub _gtk_menu_item_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_menu_item_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_menu_item_new_with_label:
#`{{
=begin pod
=head2 _gtk_menu_item_new_with_label

Creates a new B<Gnome::Gtk3::MenuItem> whose child is a B<Gnome::Gtk3::Label>.

Returns: the newly created B<Gnome::Gtk3::MenuItem>

  method _gtk_menu_item_new_with_label ( Str $label --> N-GObject )

=item Str $label; the text for the label
=end pod
}}

sub _gtk_menu_item_new_with_label ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_menu_item_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_menu_item_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_menu_item_new_with_mnemonic

Creates a new B<Gnome::Gtk3::MenuItem> containing a label.

The label will be created using C<gtk-label-new-with-mnemonic()>, so underscores in I<label> indicate the mnemonic for the menu item.

Returns: a new B<Gnome::Gtk3::MenuItem>

  method _gtk_menu_item_new_with_mnemonic ( Str $label --> N-GObject )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character
=end pod
}}

sub _gtk_menu_item_new_with_mnemonic ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_menu_item_new_with_mnemonic')
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
=comment #TS:0:activate:
=head3 activate

Emitted when the item is activated.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:activate-item:
=head3 activate-item

Emitted when the item is activated, but also if the menu item has a
submenu. For normal applications, the relevant signal is
 I<activate>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:deselect:
=head3 deselect

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:select:
=head3 select

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:toggle-size-allocate:
=head3 toggle-size-allocate

  method handler (
    Int $int,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $int;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:toggle-size-request:
=head3 toggle-size-request

  method handler (
    Unknown type G_TYPE_POINTER $unknown type g_type_pointer,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $unknown type g_type_pointer;
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
=comment #TP:1:accel-path:
=head3 Accel Path: accel-path

Sets the accelerator path of the menu item, through which runtime changes of the menu item's accelerator caused by the user can be identified and saved to persistant storage.


The B<Gnome::GObject::Value> type of property I<accel-path> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:label:
=head3 Label: label

The text for the child label.

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:right-justified:
=head3 Right Justified: right-justified

Sets whether the menu item appears justified at the right side of a menu bar.

The B<Gnome::GObject::Value> type of property I<right-justified> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:submenu:
=head3 Submenu: submenu

The submenu attached to the menu item, or C<undefined> if it has none.

   Widget type: GTK_TYPE_MENU

The B<Gnome::GObject::Value> type of property I<submenu> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:use-underline:
=head3 Use underline: use-underline

C<True> if underlines in the text indicate mnemonics.


The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.
=end pod


























=finish
#-------------------------------------------------------------------------------
#TM:2:gtk_menu_item_new:new()
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


=comment #TS:0:activate:
=head3 activate

Emitted when the item is activated.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.


=comment #TS:0:activate-item:
=head3 activate-item

Emitted when the item is activated, but also if the menu item has a
submenu. For normal applications, the relevant signal is
 I<activate>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem; the object which received the signal.


=begin comment
=comment #TS:0:toggle-size-request:
=head3 toggle-size-request

  method handler (
    Unknown type G_TYPE_POINTER $unknown type g_type_pointer,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $unknown type g_type_pointer;
=end comment

=comment #TS:0:toggle-size-allocate:
=head3 toggle-size-allocate

  method handler (
    Int $int,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;
=item $int; ?

=comment #TS:0:select:
=head3 select

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;

=comment #TS:0:deselect:
=head3 deselect

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($menuitem),
    *%user-options
  );

=item $menuitem;

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
