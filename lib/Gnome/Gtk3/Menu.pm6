use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Menu

=SUBTITLE A menu widget

=head1 Description


A C<Gnome::Gtk3::Menu> is a C<Gnome::Gtk3::MenuShell> that implements a drop down menu
consisting of a list of C<Gnome::Gtk3::MenuItem> objects which can be navigated
and activated by the user to perform application functions.

A C<Gnome::Gtk3::Menu> is most commonly dropped down by activating a
C<Gnome::Gtk3::MenuItem> in a C<Gnome::Gtk3::MenuBar> or popped up by activating a
C<Gnome::Gtk3::MenuItem> in another C<Gnome::Gtk3::Menu>.

A C<Gnome::Gtk3::Menu> can also be popped up by activating a C<Gnome::Gtk3::ComboBox>.
Other composite widgets such as the C<Gnome::Gtk3::Notebook> can pop up a
C<Gnome::Gtk3::Menu> as well.

Applications can display a C<Gnome::Gtk3::Menu> as a popup menu by calling the
C<gtk_menu_popup()> function.  The example below shows how an application
can pop up a menu when the 3rd mouse button is pressed.

## Connecting the popup signal handler.

|[<!-- language="C" -->
  // connect our handler which will popup the menu
  g_signal_connect_swapped (window, "button_press_event",
	G_CALLBACK (my_popup_handler), menu);
]|

## Signal handler which displays a popup menu.

|[<!-- language="C" -->
static gint
my_popup_handler (C<Gnome::Gtk3::Widget> *widget, C<Gnome::Gdk3::Event> *event)
{
  C<Gnome::Gtk3::Menu> *menu;
  C<Gnome::Gdk3::EventButton> *event_button;

  g_return_val_if_fail (widget != NULL, FALSE);
  g_return_val_if_fail (GTK_IS_MENU (widget), FALSE);
  g_return_val_if_fail (event != NULL, FALSE);

  // The "widget" is the menu that was supplied when
  // C<g_signal_connect_swapped()> was called.
  menu = GTK_MENU (widget);

  if (event->type == GDK_BUTTON_PRESS)
    {
      event_button = (C<Gnome::Gdk3::EventButton> *) event;
      if (event_button->button == GDK_BUTTON_SECONDARY)
        {
          gtk_menu_popup (menu, NULL, NULL, NULL, NULL,
                          event_button->button, event_button->time);
          return TRUE;
        }
    }

  return FALSE;
}
]|


=head2 Css Nodes

  menu
  ├── arrow.top
  ├── <child>
  ┊
  ├── <child>
  ╰── arrow.bottom

The main CSS node of C<Gnome::Gtk3::Menu> has name B<menu>, and there are two subnodes with name arrow, for scrolling menu arrows. These subnodes get the .top and .bottom style classes.



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Menu;
  also is Gnome::Gtk3::MenuShell;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gdk3::EventTypes;
use Gnome::Gdk3::Window;
use Gnome::Gtk3::MenuShell;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/gtkmenu.h
# https://developer.gnome.org/gtk3/stable/GtkMenu.html
unit class Gnome::Gtk3::Menu:auth<github:MARTIMM>;
also is Gnome::Gtk3::MenuShell;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :scrolltype<move-scroll>, :ptr2bool2<popped-up>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Menu';

  # process all named arguments
  if ? %options<empty> {
    # self.native-gobject(gtk_menu_new());
  }

  elsif ? %options<widget> || %options<build-id> {
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
  try { $s = &::("gtk_menu_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

=begin pod
=head2 enum GtkArrowPlacement

Used to specify the placement of scroll arrows in scrolling menus.


=item GTK_ARROWS_BOTH: Place one arrow on each end of the menu.
=item GTK_ARROWS_START: Place both arrows at the top of the menu.
=item GTK_ARROWS_END: Place both arrows at the bottom of the menu.


=end pod

enum GtkArrowPlacement is export (
  'GTK_ARROWS_BOTH',
  'GTK_ARROWS_START',
  'GTK_ARROWS_END'
);


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_new

Creates a new C<Gnome::Gtk3::Menu>

Returns: a new C<Gnome::Gtk3::Menu>

  method gtk_menu_new ( --> N-GObject  )


=end pod

sub gtk_menu_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] new_from_model

Creates a C<Gnome::Gtk3::Menu> and populates it with menu items and
submenus according to I<model>.

The created menu items are connected to actions found in the
C<Gnome::Gtk3::ApplicationWindow> to which the menu belongs - typically
by means of being attached to a widget (see C<gtk_menu_attach_to_widget()>)
that is contained within the C<Gnome::Gtk3::ApplicationWindows> widget hierarchy.

Actions can also be added using C<gtk_widget_insert_action_group()> on the menu's
attach widget or on any of its parent widgets.

Returns: a new C<Gnome::Gtk3::Menu>

Since: 3.4

  method gtk_menu_new_from_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; a C<GMenuModel>

=end pod

sub gtk_menu_new_from_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] popup_at_rect

Displays I<menu> and makes it available for selection.

See C<gtk_menu_popup_at_widget()> and C<gtk_menu_popup_at_pointer()>, which
handle more common cases for popping up menus.

I<menu> will be positioned at I<rect>, aligning their anchor points. I<rect> is
relative to the top-left corner of I<rect_window>. I<rect_anchor> and
I<menu_anchor> determine anchor points on I<rect> and I<menu> to pin together.
I<menu> can optionally be offset by prop C<rect-anchor-dx> and
prop C<rect-anchor-dy>.

Anchors should be specified under the assumption that the text direction is
left-to-right; they will be flipped horizontally automatically if the text
direction is right-to-left.

Other properties that influence the behaviour of this function are
prop C<anchor-hints> and prop C<menu-type-hint>. Connect to the
sig C<popped-up> signal to find out how it was actually positioned.

Since: 3.22
Stability: Unstable

  method gtk_menu_popup_at_rect ( N-GObject $rect_window, N-GObject $rect, GdkGravity $rect_anchor, GdkGravity $menu_anchor, GdkEvent $trigger_event )

=item N-GObject $rect_window; (not nullable): the C<Gnome::Gdk3::Window> I<rect> is relative to
=item N-GObject $rect; (not nullable): the C<Gnome::Gdk3::Rectangle> to align I<menu> with
=item GdkGravity $rect_anchor; the point on I<rect> to align with I<menu>'s anchor point
=item GdkGravity $menu_anchor; the point on I<menu> to align with I<rect>'s anchor point
=item GdkEvent $trigger_event; (nullable): the C<Gnome::Gdk3::Event> that initiated this request or C<Any> if it's the current event

=end pod

sub gtk_menu_popup_at_rect ( N-GObject $menu, N-GObject $rect_window, N-GObject $rect, int32 $rect_anchor, int32 $menu_anchor, GdkEvent $trigger_event )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] popup_at_widget

Displays I<menu> and makes it available for selection.

See C<gtk_menu_popup_at_pointer()> to pop up a menu at the master pointer.
C<gtk_menu_popup_at_rect()> also allows you to position a menu at an arbitrary
rectangle.

![](images/popup-anchors.png)

I<menu> will be positioned at I<widget>, aligning their anchor points.
I<widget_anchor> and I<menu_anchor> determine anchor points on I<widget> and I<menu>
to pin together. I<menu> can optionally be offset by prop C<rect-anchor-dx>
and prop C<rect-anchor-dy>.

Anchors should be specified under the assumption that the text direction is
left-to-right; they will be flipped horizontally automatically if the text
direction is right-to-left.

Other properties that influence the behaviour of this function are
prop C<anchor-hints> and prop C<menu-type-hint>. Connect to the
sig C<popped-up> signal to find out how it was actually positioned.

Since: 3.22
Stability: Unstable

  method gtk_menu_popup_at_widget ( N-GObject $widget, GdkGravity $widget_anchor, GdkGravity $menu_anchor, GdkEvent $trigger_event )

=item N-GObject $widget; (not nullable): the C<Gnome::Gtk3::Widget> to align I<menu> with
=item GdkGravity $widget_anchor; the point on I<widget> to align with I<menu>'s anchor point
=item GdkGravity $menu_anchor; the point on I<menu> to align with I<widget>'s anchor point
=item GdkEvent $trigger_event; (nullable): the C<Gnome::Gdk3::Event> that initiated this request or C<Any> if it's the current event

=end pod

sub gtk_menu_popup_at_widget ( N-GObject $menu, N-GObject $widget, int32 $widget_anchor, int32 $menu_anchor, GdkEvent $trigger_event )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] popup_at_pointer

Displays I<menu> and makes it available for selection.

See C<gtk_menu_popup_at_widget()> to pop up a menu at a widget.
C<gtk_menu_popup_at_rect()> also allows you to position a menu at an arbitrary
rectangle.

I<menu> will be positioned at the pointer associated with I<trigger_event>.

Properties that influence the behaviour of this function are
prop C<anchor-hints>, prop C<rect-anchor-dx>, prop C<rect-anchor-dy>, and
prop C<menu-type-hint>. Connect to the sig C<popped-up> signal to find
out how it was actually positioned.

Since: 3.22
Stability: Unstable

  method gtk_menu_popup_at_pointer ( GdkEvent $trigger_event )

=item GdkEvent $trigger_event; (nullable): the C<Gnome::Gdk3::Event> that initiated this request or C<Any> if it's the current event

=end pod

sub gtk_menu_popup_at_pointer ( N-GObject $menu, GdkEvent $trigger_event )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_reposition

Repositions the menu according to its position function.

  method gtk_menu_reposition ( )


=end pod

sub gtk_menu_reposition ( N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_popdown

Removes the menu from the screen.

  method gtk_menu_popdown ( )


=end pod

sub gtk_menu_popdown ( N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_active

Returns the selected menu item from the menu.  This is used by the
C<Gnome::Gtk3::ComboBox>.

Returns: (transfer none): the C<Gnome::Gtk3::MenuItem> that was last selected
in the menu.  If a selection has not yet been made, the
first menu item is selected.

  method gtk_menu_get_active ( --> N-GObject  )


=end pod

sub gtk_menu_get_active ( N-GObject $menu )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_active

Selects the specified menu item within the menu.  This is used by
the C<Gnome::Gtk3::ComboBox> and should not be used by anyone else.

  method gtk_menu_set_active ( UInt $index )

=item UInt $index; the index of the menu item to select.  Index values are from 0 to n-1

=end pod

sub gtk_menu_set_active ( N-GObject $menu, uint32 $index )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_accel_group

Set the C<Gnome::Gtk3::AccelGroup> which holds global accelerators for the
menu.  This accelerator group needs to also be added to all windows
that this menu is being used in with C<gtk_window_add_accel_group()>,
in order for those windows to support all the accelerators
contained in this group.

  method gtk_menu_set_accel_group ( N-GObject $accel_group )

=item N-GObject $accel_group; (allow-none): the C<Gnome::Gtk3::AccelGroup> to be associated with the menu.

=end pod

sub gtk_menu_set_accel_group ( N-GObject $menu, N-GObject $accel_group )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_accel_group

Gets the C<Gnome::Gtk3::AccelGroup> which holds global accelerators for the
menu. See C<gtk_menu_set_accel_group()>.

Returns: (transfer none): the C<Gnome::Gtk3::AccelGroup> associated with the menu

  method gtk_menu_get_accel_group ( --> N-GObject  )


=end pod

sub gtk_menu_get_accel_group ( N-GObject $menu )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_accel_path

Sets an accelerator path for this menu from which accelerator paths
for its immediate children, its menu items, can be constructed.
The main purpose of this function is to spare the programmer the
inconvenience of having to call C<gtk_menu_item_set_accel_path()> on
each menu item that should support runtime user changable accelerators.
Instead, by just calling C<gtk_menu_set_accel_path()> on their parent,
each menu item of this menu, that contains a label describing its
purpose, automatically gets an accel path assigned.

For example, a menu containing menu items “New” and “Exit”, will, after
`gtk_menu_set_accel_path (menu, "<Gnumeric-Sheet>/File");` has been
called, assign its items the accel paths: `"<Gnumeric-Sheet>/File/New"`
and `"<Gnumeric-Sheet>/File/Exit"`.

Assigning accel paths to menu items then enables the user to change
their accelerators at runtime. More details about accelerator paths
and their default setups can be found at C<gtk_accel_map_add_entry()>.

Note that I<accel_path> string will be stored in a C<GQuark>. Therefore,
if you pass a static string, you can save some memory by interning
it first with C<g_intern_static_string()>.

  method gtk_menu_set_accel_path ( Str $accel_path )

=item Str $accel_path; (allow-none): a valid accelerator path

=end pod

sub gtk_menu_set_accel_path ( N-GObject $menu, Str $accel_path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_accel_path

Retrieves the accelerator path set on the menu.

Returns: the accelerator path set on the menu.

Since: 2.14

  method gtk_menu_get_accel_path ( --> Str  )


=end pod

sub gtk_menu_get_accel_path ( N-GObject $menu )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] attach_to_widget

Attaches the menu to the widget and provides a callback function
that will be invoked when the menu calls C<gtk_menu_detach()> during
its destruction.

If the menu is attached to the widget then it will be destroyed
when the widget is destroyed, as if it was a child widget.
An attached menu will also move between screens correctly if the
widgets moves between screens.

  method gtk_menu_attach_to_widget ( N-GObject $attach_widget, GtkMenuDetachFunc $detacher )

=item N-GObject $attach_widget; the C<Gnome::Gtk3::Widget> that the menu will be attached to
=item GtkMenuDetachFunc $detacher; (scope async)(allow-none): the user supplied callback function that will be called when the menu calls C<gtk_menu_detach()>

=end pod

sub gtk_menu_attach_to_widget ( N-GObject $menu, N-GObject $attach_widget, GtkMenuDetachFunc $detacher )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_detach

Detaches the menu from the widget to which it had been attached.
This function will call the callback function, I<detacher>, provided
when the C<gtk_menu_attach_to_widget()> function was called.

  method gtk_menu_detach ( )


=end pod

sub gtk_menu_detach ( N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_attach_widget

Returns the C<Gnome::Gtk3::Widget> that the menu is attached to.

Returns: (transfer none): the C<Gnome::Gtk3::Widget> that the menu is attached to

  method gtk_menu_get_attach_widget ( --> N-GObject  )


=end pod

sub gtk_menu_get_attach_widget ( N-GObject $menu )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] reorder_child

Moves I<child> to a new I<position> in the list of I<menu>
children.

  method gtk_menu_reorder_child ( N-GObject $child, Int $position )

=item N-GObject $child; the C<Gnome::Gtk3::MenuItem> to move
=item Int $position; the new position to place I<child>. Positions are numbered from 0 to n - 1

=end pod

sub gtk_menu_reorder_child ( N-GObject $menu, N-GObject $child, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_screen

Sets the C<Gnome::Gdk3::Screen> on which the menu will be displayed.

Since: 2.2

  method gtk_menu_set_screen ( N-GObject $screen )

=item N-GObject $screen; (allow-none): a C<Gnome::Gdk3::Screen>, or C<Any> if the screen should be determined by the widget the menu is attached to

=end pod

sub gtk_menu_set_screen ( N-GObject $menu, N-GObject $screen )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_attach

Adds a new C<Gnome::Gtk3::MenuItem> to a (table) menu. The number of “cells” that
an item will occupy is specified by I<left_attach>, I<right_attach>,
I<top_attach> and I<bottom_attach>. These each represent the leftmost,
rightmost, uppermost and lower column and row numbers of the table.
(Columns and rows are indexed from zero).

Note that this function is not related to C<gtk_menu_detach()>.

Since: 2.4

  method gtk_menu_attach ( N-GObject $child, UInt $left_attach, UInt $right_attach, UInt $top_attach, UInt $bottom_attach )

=item N-GObject $child; a C<Gnome::Gtk3::MenuItem>
=item UInt $left_attach; The column number to attach the left side of the item to
=item UInt $right_attach; The column number to attach the right side of the item to
=item UInt $top_attach; The row number to attach the top of the item to
=item UInt $bottom_attach; The row number to attach the bottom of the item to

=end pod

sub gtk_menu_attach ( N-GObject $menu, N-GObject $child, uint32 $left_attach, uint32 $right_attach, uint32 $top_attach, uint32 $bottom_attach )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_monitor

Informs GTK+ on which monitor a menu should be popped up.
See C<gdk_monitor_get_geometry()>.

This function should be called from a C<Gnome::Gtk3::MenuPositionFunc>
if the menu should not appear on the same monitor as the pointer.
This information can’t be reliably inferred from the coordinates
returned by a C<Gnome::Gtk3::MenuPositionFunc>, since, for very long menus,
these coordinates may extend beyond the monitor boundaries or even
the screen boundaries.

Since: 2.4

  method gtk_menu_set_monitor ( Int $monitor_num )

=item Int $monitor_num; the number of the monitor on which the menu should be popped up

=end pod

sub gtk_menu_set_monitor ( N-GObject $menu, int32 $monitor_num )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_monitor

Retrieves the number of the monitor on which to show the menu.

Returns: the number of the monitor on which the menu should
be popped up or -1, if no monitor has been set

Since: 2.14

  method gtk_menu_get_monitor ( --> Int  )


=end pod

sub gtk_menu_get_monitor ( N-GObject $menu )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] place_on_monitor



  method gtk_menu_place_on_monitor ( N-GObject $monitor )

=item N-GObject $monitor;

=end pod

sub gtk_menu_place_on_monitor ( N-GObject $menu, N-GObject $monitor )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_for_attach_widget

Returns a list of the menus which are attached to this widget.
This list is owned by GTK+ and must not be modified.

Returns: (element-type C<Gnome::Gtk3::Widget>) (transfer none): the list
of menus attached to his widget.

Since: 2.6

  method gtk_menu_get_for_attach_widget ( N-GObject $widget --> N-GObject  )

=item N-GObject $widget; a C<Gnome::Gtk3::Widget>

=end pod

sub gtk_menu_get_for_attach_widget ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] set_reserve_toggle_size

Sets whether the menu should reserve space for drawing toggles
or icons, regardless of their actual presence.

Since: 2.18

  method gtk_menu_set_reserve_toggle_size ( Int $reserve_toggle_size )

=item Int $reserve_toggle_size; whether to reserve size for toggles

=end pod

sub gtk_menu_set_reserve_toggle_size ( N-GObject $menu, int32 $reserve_toggle_size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_] get_reserve_toggle_size

Returns whether the menu reserves space for toggles and
icons, regardless of their actual presence.

Returns: Whether the menu reserves toggle space

Since: 2.18

  method gtk_menu_get_reserve_toggle_size ( --> Int  )


=end pod

sub gtk_menu_get_reserve_toggle_size ( N-GObject $menu )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TODO
# https://developer.gnome.org/gtk3/stable/GtkMenu.html

=begin pod
=head1 List of not yet implemented methods and classes

=head3 method gtk_menu_attach_to_widget (...)

=head3 handler GtkMenuDetachFunc (...)

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.10
=head3 method gtk_menu_set_tearoff_state ( Int $torn_off )
=head3 method gtk_menu_get_tearoff_state ( --> Int  )
=head3 method gtk_menu_set_title ( Str $title )
=head3 method gtk_menu_get_title ( --> Str  )

=head2 Since 3.22.
=head3 method gtk_menu_popup ( N-GObject $parent_menu_shell, N-GObject $parent_menu_item, GtkMenuPositionFunc $func, gpointer $data, UInt $button, UInt $activate_time )
=head3 method gtk_menu_popup_for_device ( N-GObject $device, N-GObject $parent_menu_shell, N-GObject $parent_menu_item, GtkMenuPositionFunc $func, gpointer $data, GDestroyNotify $destroy, UInt $button, UInt $activate_time )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., $user-optionN
  )

=begin comment

=head2 Supported signals

=head2 Unsupported signals

=end comment

=head2 Not yet supported signals


=head3 move-scroll

  method handler (
    :$menu, :$scroll_type,
    :$user-option1, ..., $user-optionN
  );

=item $menu; a C<Gnome::Gtk3::Menu>

=item $scroll_type; a C<Gnome::Gtk3::ScrollType>

=head3 popped-up

Emitted when the position of I<menu> is finalized after being popped up
using C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>, or
C<gtk_menu_popup_at_pointer()>.

I<menu> might be flipped over the anchor rectangle in order to keep it
on-screen, in which case I<flipped_x> and I<flipped_y> will be set to C<1>
accordingly.

I<flipped_rect> is the ideal position of I<menu> after any possible flipping,
but before any possible sliding. I<final_rect> is I<flipped_rect>, but possibly
translated in the case that flipping is still ineffective in keeping I<menu>
on-screen.

![](images/popup-slide.png)

The blue menu is I<menu>'s ideal position, the green menu is I<flipped_rect>,
and the red menu is I<final_rect>.

See C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>,
C<gtk_menu_popup_at_pointer()>, prop C<anchor-hints>,
prop C<rect-anchor-dx>, prop C<rect-anchor-dy>, and
prop C<menu-type-hint>.

Since: 3.22
Stability: Unstable

  method handler (
    Gnome::GObject::Object :widget($menu),
    :handle-arg0($flipped_rect),
    :handle-arg1($final_rect),
    :handle-arg2($flipped_x),
    :handle-arg3($flipped_y),
    :$user-option1, ..., :$user-optionN
  );

=item $menu; the C<Gnome::Gtk3::Menu> that popped up

=item $flipped_rect; (nullable): the position of I<menu> after any possible
flipping or C<Any> if the backend can't obtain it

=item $final_rect; (nullable): the final position of I<menu> or C<Any> if the
backend can't obtain it

=item $flipped_x; C<1> if the anchors were flipped horizontally

=item $flipped_y; C<1> if the anchors were flipped vertically

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head3 active

The C<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_INT>.

The index of the currently selected menu item, or -1 if no
menu item is selected.


=head3 accel-path

The C<Gnome::GObject::Value> type of property I<accel-path> is C<G_TYPE_STRING>.

An accel path used to conveniently construct accel paths of child items.

=head3 monitor

The C<Gnome::GObject::Value> type of property I<monitor> is C<G_TYPE_INT>.

The monitor the menu will be popped up on.

=head3 reserve-toggle-size

The C<Gnome::GObject::Value> type of property I<reserve-toggle-size> is C<G_TYPE_BOOLEAN>.

A boolean that indicates whether the menu reserves space for
toggles and icons, regardless of their actual presence.

This property should only be changed from its default value
for special-purposes such as tabular menus. Regular menus that
are connected to a menu bar or context menus should reserve
toggle space for consistency.

Since: 2.18


=head3 rect-anchor-dx

The C<Gnome::GObject::Value> type of property I<rect-anchor-dx> is C<G_TYPE_INT>.

Horizontal offset to apply to the menu, i.e. the rectangle or widget
anchor.

See C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>,
C<gtk_menu_popup_at_pointer()>, prop C<anchor-hints>,
prop C<rect-anchor-dy>, prop C<menu-type-hint>, and sig C<popped-up>.

Stability: Unstable


=head3 rect-anchor-dy

The C<Gnome::GObject::Value> type of property I<rect-anchor-dy> is C<G_TYPE_INT>.

Vertical offset to apply to the menu, i.e. the rectangle or widget anchor.

See C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>,
C<gtk_menu_popup_at_pointer()>, prop C<anchor-hints>,
prop C<rect-anchor-dx>, prop C<menu-type-hint>, and sig C<popped-up>.

Stability: Unstable


=head3 menu-type-hint

The C<Gnome::GObject::Value> type of property I<menu-type-hint> is C<G_TYPE_ENUM>.

The C<Gnome::Gdk3::WindowTypeHint> to use for the menu's C<Gnome::Gdk3::Window>.

See C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>,
C<gtk_menu_popup_at_pointer()>, prop C<anchor-hints>,
prop C<rect-anchor-dx>, prop C<rect-anchor-dy>, and sig C<popped-up>.

Stability: Unstable

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties

=head3 accel-group

The C<Gnome::GObject::Value> type of property I<accel-group> is C<G_TYPE_OBJECT>.

The accel group holding accelerators for the menu.

=head3 attach-widget

The C<Gnome::GObject::Value> type of property I<attach-widget> is C<G_TYPE_OBJECT>.

The widget the menu is attached to. Setting this property attaches
the menu without a C<Gnome::Gtk3::MenuDetachFunc>. If you need to use a detacher,
use C<gtk_menu_attach_to_widget()> directly.

=head3 anchor-hints

The C<Gnome::GObject::Value> type of property I<anchor-hints> is C<G_TYPE_FLAGS>.

Positioning hints for aligning the menu relative to a rectangle.

These hints determine how the menu should be positioned in the case that
the menu would fall off-screen if placed in its ideal position.

![](images/popup-flip.png)

For example, C<GDK_ANCHOR_FLIP_Y> will replace C<GDK_GRAVITY_NORTH_WEST> with
C<GDK_GRAVITY_SOUTH_WEST> and vice versa if the menu extends beyond the
bottom edge of the monitor.

See C<gtk_menu_popup_at_rect()>, C<gtk_menu_popup_at_widget()>,
C<gtk_menu_popup_at_pointer()>, prop C<rect-anchor-dx>,
prop C<rect-anchor-dy>, prop C<menu-type-hint>, and sig C<popped-up>.

Stability: Unstable

=end pod
