#TL:1:Gnome::Gtk3::MenuShell:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::MenuShell

A base class for menu objects

=head1 Description


A B<Gnome::Gtk3::MenuShell> is the abstract base class used to derive the
B<Gnome::Gtk3::Menu> and B<Gnome::Gtk3::MenuBar> subclasses.

A B<Gnome::Gtk3::MenuShell> is a container of B<Gnome::Gtk3::MenuItem> objects arranged
in a list which can be navigated, selected, and activated by the
user to perform application functions. A B<Gnome::Gtk3::MenuItem> can have a
submenu associated with it, allowing for nested hierarchical menus.

=head2 Terminology

A menu item can be “selected”, this means that it is displayed
in the prelight state, and if it has a submenu, that submenu
will be popped up.

A menu is “active” when it is visible onscreen and the user
is selecting from it. A menubar is not active until the user
clicks on one of its menuitems. When a menu is active,
passing the mouse over a submenu will pop it up.

There is also is a concept of the current menu and a current
menu item. The current menu item is the selected menu item
that is furthest down in the hierarchy. (Every active menu shell
does not necessarily contain a selected menu item, but if
it does, then the parent menu shell must also contain
a selected menu item.) The current menu is the menu that
contains the current menu item. It will always have a GTK
grab and receive all key presses.

=head2 Implemented Interfaces

Gnome::Gtk3::MenuShell implements

=item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuShell;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Container;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuShell:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:1:new():inheriting
#TM:1:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<deactivate selection-done cancel>,
    :w1<move-current activate-current cycle-focus move-selected>,
    :w2<insert>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::MenuShell';

  # process all named arguments
  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
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
  self.set-class-info('GtkMenuShell');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_shell_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkMenuShell');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_append:
=begin pod
=head2 [gtk_] menu_shell_append

Adds a new B<Gnome::Gtk3::MenuItem> to the end of the menu shell's
item list.

  method gtk_menu_shell_append ( N-GObject $child )

=item N-GObject $child; (type B<Gnome::Gtk3::.MenuItem>): The B<Gnome::Gtk3::MenuItem> to add

=end pod

sub gtk_menu_shell_append ( N-GObject $menu_shell, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_prepend:
=begin pod
=head2 [gtk_] menu_shell_prepend

Adds a new B<Gnome::Gtk3::MenuItem> to the beginning of the menu shell's
item list.

  method gtk_menu_shell_prepend ( N-GObject $child )

=item N-GObject $child; The B<Gnome::Gtk3::MenuItem> to add

=end pod

sub gtk_menu_shell_prepend ( N-GObject $menu_shell, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_insert:
=begin pod
=head2 [gtk_] menu_shell_insert

Adds a new B<Gnome::Gtk3::MenuItem> to the menu shell’s item list
at the position indicated by I<position>.

  method gtk_menu_shell_insert ( N-GObject $child, Int $position )

=item N-GObject $child; The B<Gnome::Gtk3::MenuItem> to add
=item Int $position; The position in the item list where I<child> is added. Positions are numbered from 0 to n-1

=end pod

sub gtk_menu_shell_insert ( N-GObject $menu_shell, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_deactivate:
=begin pod
=head2 [gtk_] menu_shell_deactivate

Deactivates the menu shell.

Typically this results in the menu shell being erased
from the screen.

  method gtk_menu_shell_deactivate ( )


=end pod

sub gtk_menu_shell_deactivate ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_select_item:
=begin pod
=head2 [[gtk_] menu_shell_] select_item

Selects the menu item from the menu shell.

  method gtk_menu_shell_select_item ( N-GObject $menu_item )

=item N-GObject $menu_item; The B<Gnome::Gtk3::MenuItem> to select

=end pod

sub gtk_menu_shell_select_item ( N-GObject $menu_shell, N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_deselect:
=begin pod
=head2 [gtk_] menu_shell_deselect

Deselects the currently selected item from the menu shell,
if any.

  method gtk_menu_shell_deselect ( )


=end pod

sub gtk_menu_shell_deselect ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_activate_item:
=begin pod
=head2 [[gtk_] menu_shell_] activate_item

Activates the menu item within the menu shell.

  method gtk_menu_shell_activate_item ( N-GObject $menu_item, Int $force_deactivate )

=item N-GObject $menu_item; the B<Gnome::Gtk3::MenuItem> to activate
=item Int $force_deactivate; if C<1>, force the deactivation of the menu shell after the menu item is activated

=end pod

sub gtk_menu_shell_activate_item ( N-GObject $menu_shell, N-GObject $menu_item, int32 $force_deactivate )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_select_first:
=begin pod
=head2 [[gtk_] menu_shell_] select_first

Select the first visible or selectable child of the menu shell;
don’t select tearoff items unless the only item is a tearoff
item.

Since: 2.2

  method gtk_menu_shell_select_first ( Int $search_sensitive )

=item Int $search_sensitive; if C<1>, search for the first selectable menu item, otherwise select nothing if the first item isn’t sensitive. This should be C<0> if the menu is being popped up initially.

=end pod

sub gtk_menu_shell_select_first ( N-GObject $menu_shell, int32 $search_sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_cancel:
=begin pod
=head2 [gtk_] menu_shell_cancel

Cancels the selection within the menu shell.

Since: 2.4

  method gtk_menu_shell_cancel ( )


=end pod

sub gtk_menu_shell_cancel ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_get_take_focus:
=begin pod
=head2 [[gtk_] menu_shell_] get_take_focus

Returns C<1> if the menu shell will take the keyboard focus on popup.

Returns: C<1> if the menu shell will take the keyboard focus on popup.

Since: 2.8

  method gtk_menu_shell_get_take_focus ( --> Int  )


=end pod

sub gtk_menu_shell_get_take_focus ( N-GObject $menu_shell )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_set_take_focus:
=begin pod
=head2 [[gtk_] menu_shell_] set_take_focus

If I<take_focus> is C<1> (the default) the menu shell will take
the keyboard focus so that it will receive all keyboard events
which is needed to enable keyboard navigation in menus.

Setting I<take_focus> to C<0> is useful only for special applications
like virtual keyboard implementations which should not take keyboard
focus.

The I<take_focus> state of a menu or menu bar is automatically
propagated to submenus whenever a submenu is popped up, so you
don’t have to worry about recursively setting it for your entire
menu hierarchy. Only when programmatically picking a submenu and
popping it up manually, the I<take_focus> property of the submenu
needs to be set explicitly.

Note that setting it to C<0> has side-effects:

If the focus is in some other app, it keeps the focus and keynav in
the menu doesn’t work. Consequently, keynav on the menu will only
work if the focus is on some toplevel owned by the onscreen keyboard.

To avoid confusing the user, menus with I<take_focus> set to C<0>
should not display mnemonics or accelerators, since it cannot be
guaranteed that they will work.

See also C<gdk_keyboard_grab()>

Since: 2.8

  method gtk_menu_shell_set_take_focus ( Int $take_focus )

=item Int $take_focus; C<1> if the menu shell should take the keyboard focus on popup

=end pod

sub gtk_menu_shell_set_take_focus ( N-GObject $menu_shell, int32 $take_focus )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_get_selected_item:
=begin pod
=head2 [[gtk_] menu_shell_] get_selected_item

Gets the currently selected item.

Returns: (transfer none): the currently selected item

Since: 3.0

  method gtk_menu_shell_get_selected_item ( --> N-GObject  )


=end pod

sub gtk_menu_shell_get_selected_item ( N-GObject $menu_shell )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_get_parent_shell:
=begin pod
=head2 [[gtk_] menu_shell_] get_parent_shell

Gets the parent menu shell.

The parent menu shell of a submenu is the B<Gnome::Gtk3::Menu> or B<Gnome::Gtk3::MenuBar>
from which it was opened up.

Returns: (transfer none): the parent B<Gnome::Gtk3::MenuShell>

Since: 3.0

  method gtk_menu_shell_get_parent_shell ( --> N-GObject  )


=end pod

sub gtk_menu_shell_get_parent_shell ( N-GObject $menu_shell )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_shell_bind_model:
=begin pod
=head2 [[gtk_] menu_shell_] bind_model

Establishes a binding between a B<Gnome::Gtk3::MenuShell> and a B<GMenuModel>.

The contents of I<shell> are removed and then refilled with menu items
according to I<model>.  When I<model> changes, I<shell> is updated.
Calling this function twice on I<shell> with different I<model> will
cause the first binding to be replaced with a binding to the new
model. If I<model> is C<Any> then any previous binding is undone and
all children are removed.

I<with_separators> determines if toplevel items (eg: sections) have
separators inserted between them.  This is typically desired for
menus but doesn’t make sense for menubars.

If I<action_namespace> is non-C<Any> then the effect is as if all
actions mentioned in the I<model> have their names prefixed with the
namespace, plus a dot.  For example, if the action “quit” is
mentioned and I<action_namespace> is “app” then the effective action
name is “app.quit”.

This function uses B<Gnome::Gtk3::Actionable> to define the action name and
target values on the created menu items.  If you want to use an
action group other than “app” and “win”, or if you want to use a
B<Gnome::Gtk3::MenuShell> outside of a B<Gnome::Gtk3::ApplicationWindow>, then you will need
to attach your own action group to the widget hierarchy using
C<gtk_widget_insert_action_group()>.  As an example, if you created a
group with a “quit” action and inserted it with the name “mygroup”
then you would use the action name “mygroup.quit” in your
B<GMenuModel>.

For most cases you are probably better off using
C<gtk_menu_new_from_model()> or C<gtk_menu_bar_new_from_model()> or just
directly passing the B<GMenuModel> to C<gtk_application_set_app_menu()> or
C<gtk_application_set_menubar()>.

Since: 3.6

  method gtk_menu_shell_bind_model ( N-GObject $model, Str $action_namespace, Int $with_separators )

=item N-GObject $model; (allow-none): the B<GMenuModel> to bind to or C<Any> to remove binding
=item Str $action_namespace; (allow-none): the namespace for actions in I<model>
=item Int $with_separators; C<1> if toplevel items in I<shell> should have separators between them

=end pod

sub gtk_menu_shell_bind_model ( N-GObject $menu_shell, N-GObject $model, Str $action_namespace, int32 $with_separators )
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


=comment #TS:0:deactivate:
=head3 deactivate

This signal is emitted when a menu shell is deactivated.

  method handler (
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal


=comment #TS:0:selection-done:
=head3 selection-done

This signal is emitted when a selection has been
completed within a menu shell.

  method handler (
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal


=comment #TS:0:move-current:
=head3 move-current

An keybinding signal which moves the current menu item
in the direction specified by I<direction>.

  method handler (
    Unknown type GTK_TYPE_MENU_DIRECTION_TYPE $direction,
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal

=item $direction; the direction to move


=comment #TS:0:activate-current:
=head3 activate-current

An action signal that activates the current menu item within
the menu shell.

  method handler (
    Int $force_hide,
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal

=item $force_hide; if C<1>, hide the menu after activating the menu item


=comment #TS:0:cancel:
=head3 cancel

An action signal which cancels the selection within the menu shell.
Causes the  I<selection-done> signal to be emitted.

  method handler (
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal


=comment #TS:0:cycle-focus:
=head3 cycle-focus

A keybinding signal which moves the focus in the
given I<direction>.

  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $direction,
    Gnome::GObject::Object :widget($menushell),
    *%user-options
  );

=item $menushell; the object which received the signal

=item $direction; the direction to cycle in


=comment #TS:0:move-selected:
=head3 move-selected

The I<move-selected> signal is emitted to move the selection to
another item.

Returns: C<1> to stop the signal emission, C<0> to continue

Since: 2.12

  method handler (
    Int $distance,
    Gnome::GObject::Object :widget($menu_shell),
    *%user-options
    --> Int
  );

=item $menu_shell; the object on which the signal is emitted

=item $distance; +1 to move to the next item, -1 to move to the previous


=comment #TS:0:insert:
=head3 insert

The I<insert> signal is emitted when a new B<Gnome::Gtk3::MenuItem> is added to
a B<Gnome::Gtk3::MenuShell>.  A separate signal is used instead of
B<Gnome::Gtk3::Container>::add because of the need for an additional position
parameter.

The inverse of this signal is the B<Gnome::Gtk3::Container>::removed signal.

Since: 3.2

  method handler (
    N-GObject $child,
    Int $position,
    Gnome::GObject::Object :widget($menu_shell),
    *%user-options
  );

=item $menu_shell; the object on which the signal is emitted

=item $child; the B<Gnome::Gtk3::MenuItem> that is being inserted

=item $position; the position at which the insert occurs


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

=comment #TP:0:take-focus:
=head3 Take Focus


A boolean that determines whether the menu and its submenus grab the
keyboard focus. See C<gtk_menu_shell_set_take_focus()> and
C<gtk_menu_shell_get_take_focus()>.
Since: 2.8


The B<Gnome::GObject::Value> type of property I<take-focus> is C<G_TYPE_BOOLEAN>.
=end pod
