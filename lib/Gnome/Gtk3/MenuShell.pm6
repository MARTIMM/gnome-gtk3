use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::MenuShell

=SUBTITLE A base class for menu objects

=head1 Description


A C<Gnome::Gtk3::MenuShell> is the abstract base class used to derive the
C<Gnome::Gtk3::Menu> and C<Gnome::Gtk3::MenuBar> subclasses.

A C<Gnome::Gtk3::MenuShell> is a container of C<Gnome::Gtk3::MenuItem> objects arranged
in a list which can be navigated, selected, and activated by the
user to perform application functions. A C<Gnome::Gtk3::MenuItem> can have a
submenu associated with it, allowing for nested hierarchical menus.

# Terminology

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



=head2 See Also



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuShell;
  also is Gnome::Gtk3::Container;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuShell:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new


  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<cancel deactivate selection-done>,
    :boolean<activate-current>,
    :dirtype<cycle-focus>,
    :widgetInt<insert>,
    :menudirtype<move-current>,
    :int<move-selected>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::MenuShell';

  # process all named arguments
  if ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_menu_shell_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_append

Adds a new C<Gnome::Gtk3::MenuItem> to the end of the menu shell's item list.

  method gtk_menu_shell_append ( N-GObject $child )

=item N-GObject $child; (type C<Gnome::Gtk3::.MenuItem>): The C<Gnome::Gtk3::MenuItem> to add

=end pod

sub gtk_menu_shell_append ( N-GObject $menu_shell, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_prepend

Adds a new C<Gnome::Gtk3::MenuItem> to the beginning of the menu shell's item list.

  method gtk_menu_shell_prepend ( N-GObject $child )

=item N-GObject $child; The C<Gnome::Gtk3::MenuItem> to add

=end pod

sub gtk_menu_shell_prepend ( N-GObject $menu_shell, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_insert

Adds a new C<Gnome::Gtk3::MenuItem> to the menu shell’s item list at the position indicated by I<position>.

  method gtk_menu_shell_insert ( N-GObject $child, Int $position )

=item N-GObject $child; The C<Gnome::Gtk3::MenuItem> to add
=item Int $position; The position in the item list where I<child> is added. Positions are numbered from 0 to n-1

=end pod

sub gtk_menu_shell_insert ( N-GObject $menu_shell, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_deactivate

Deactivates the menu shell.

  method gtk_menu_shell_deactivate ( )


=end pod

sub gtk_menu_shell_deactivate ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] select_item

Selects the menu item from the menu shell.

  method gtk_menu_shell_select_item ( N-GObject $menu_item )

=item N-GObject $menu_item; The C<Gnome::Gtk3::MenuItem> to select

=end pod

sub gtk_menu_shell_select_item ( N-GObject $menu_shell, N-GObject $menu_item )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_deselect

Deselects the currently selected item from the menu shell, if any.

  method gtk_menu_shell_deselect ( )


=end pod

sub gtk_menu_shell_deselect ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] activate_item

Activates the menu item within the menu shell.

  method gtk_menu_shell_activate_item ( N-GObject $menu_item, Int $force_deactivate )

=item N-GObject $menu_item; the C<Gnome::Gtk3::MenuItem> to activate
=item Int $force_deactivate; if C<1>, force the deactivation of the menu shell after the menu item is activated

=end pod

sub gtk_menu_shell_activate_item ( N-GObject $menu_shell, N-GObject $menu_item, int32 $force_deactivate )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] select_first

Select the first visible or selectable child of the menu shell; don’t select tearoff items unless the only item is a tearoff item.

  method gtk_menu_shell_select_first ( Int $search_sensitive )

=item Int $search_sensitive; if C<1>, search for the first selectable menu item, otherwise select nothing if the first item isn’t sensitive. This should be C<0> if the menu is being popped up initially.

=end pod

sub gtk_menu_shell_select_first ( N-GObject $menu_shell, int32 $search_sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_shell_cancel

Cancels the selection within the menu shell.

  method gtk_menu_shell_cancel ( )


=end pod

sub gtk_menu_shell_cancel ( N-GObject $menu_shell )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] get_take_focus

Returns C<1> if the menu shell will take the keyboard focus on popup.

  method gtk_menu_shell_get_take_focus ( --> Int  )


Returns Int; C<1> if the menu shell will take the keyboard focus on popup.
=end pod

sub gtk_menu_shell_get_take_focus ( N-GObject $menu_shell )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] set_take_focus

If I<take_focus> is C<1> (the default) the menu shell will take the keyboard focus so that it will receive all keyboard events which is needed to enable keyboard navigation in menus.

  method gtk_menu_shell_set_take_focus ( Int $take_focus )

=item Int $take_focus; C<1> if the menu shell should take the keyboard focus on popup

=end pod

sub gtk_menu_shell_set_take_focus ( N-GObject $menu_shell, int32 $take_focus )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] get_selected_item

Gets the currently selected item.

  method gtk_menu_shell_get_selected_item ( --> N-GObject  )


Returns N-GObject; (transfer none): the currently selected item
=end pod

sub gtk_menu_shell_get_selected_item ( N-GObject $menu_shell )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] get_parent_shell

Gets the parent menu shell.

  method gtk_menu_shell_get_parent_shell ( --> N-GObject  )


Returns N-GObject; (transfer none): the parent C<Gnome::Gtk3::MenuShell>
=end pod

sub gtk_menu_shell_get_parent_shell ( N-GObject $menu_shell )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_shell_] bind_model

Establishes a binding between a C<Gnome::Gtk3::MenuShell> and a C<GMenuModel>.

  method gtk_menu_shell_bind_model ( N-GObject $model, Str $action_namespace, Int $with_separators )

=item N-GObject $model; (allow-none): the C<GMenuModel> to bind to or C<Any> to remove binding
=item Str $action_namespace; (allow-none): the namespace for actions in I<model>
=item Int $with_separators; C<1> if toplevel items in I<shell> should have separators between them

=end pod

sub gtk_menu_shell_bind_model ( N-GObject $menu_shell, N-GObject $model, Str $action_namespace, int32 $with_separators )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 deactivate

This signal is emitted when a menu shell is deactivated.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal


=head3 selection-done

This signal is emitted when a selection has been
completed within a menu shell.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal

=head3 cancel

An action signal which cancels the selection within the menu shell.
Causes the sig C<selection-done> signal to be emitted.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal





=begin comment
=head2 Unsupported signals

=end comment

=head2 Not yet supported signals


=head3 move-current

An keybinding signal which moves the current menu item
in the direction specified by I<direction>.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :C<handle-arg0>($direction),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal

=item $direction; the direction to move


=head3 activate-current

An action signal that activates the current menu item within
the menu shell.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :C<handle-arg0>($force_hide),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal

=item $force_hide; if C<1>, hide the menu after activating the menu item


=head3 cycle-focus

A keybinding signal which moves the focus in the
given I<direction>.

  method handler (
    Gnome::GObject::Object :C<widget>($menushell),
    :C<handle-arg0>($direction),
    :$user-option1, ..., :$user-optionN
  );

=item $menushell; the object which received the signal

=item $direction; the direction to cycle in


=head3 move-selected

The ::move-selected signal is emitted to move the selection to
another item.

Returns: C<1> to stop the signal emission, C<0> to continue

Since: 2.12

  method handler (
    Gnome::GObject::Object :C<widget>($menu_shell),
    :C<handle-arg0>($distance),
    :$user-option1, ..., :$user-optionN
  );

=item $menu_shell; the object on which the signal is emitted

=item $distance; +1 to move to the next item, -1 to move to the previous


=head3 insert

The ::insert signal is emitted when a new C<Gnome::Gtk3::MenuItem> is added to
a C<Gnome::Gtk3::MenuShell>.  A separate signal is used instead of
C<Gnome::Gtk3::Container>::add because of the need for an additional position
parameter.

The inverse of this signal is the C<Gnome::Gtk3::Container>::removed signal.

Since: 3.2

  method handler (
    Gnome::GObject::Object :C<widget>($menu_shell),
    :C<handle-arg0>($child),
    :C<handle-arg1>($position),
    :$user-option1, ..., :$user-optionN
  );

=item $menu_shell; the object on which the signal is emitted

=item $child; the C<Gnome::Gtk3::MenuItem> that is being inserted

=item $position; the position at which the insert occurs


=end pod





#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 take-focus

The C<Gnome::GObject::Value> type of property I<take-focus> is C<G_TYPE_BOOLEAN>.

A boolean that determines whether the menu and its submenus grab the
keyboard focus. See C<gtk_menu_shell_set_take_focus()> and
C<gtk_menu_shell_get_take_focus()>.

Since: 2.8


=begin comment

=head2 Unsupported properties

=head2 Not yet supported properties

=end comment


=end pod
