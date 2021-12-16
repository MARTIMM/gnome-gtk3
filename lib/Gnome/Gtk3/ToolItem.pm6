#TL:1:Gnome::Gtk3::ToolItem:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ToolItem

The base class of tool typed widgets
<!-- that can be added to B<Gnome::Gtk3::ToolShell> -->

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::ToolItems> are widgets that can appear on a toolbar. To create a toolbar item that contain something else than a button, use C<gtk_tool_item_new()>. Use C<gtk_container_add()> to add a child widget to the tool item.

For toolbar items that contain buttons, see the B<Gnome::Gtk3::ToolButton>, B<Gnome::Gtk3::ToggleToolButton> and B<Gnome::Gtk3::RadioToolButton> classes.

See the B<Gnome::Gtk3::Toolbar> class for a description of the toolbar widget, and B<Gnome::Gtk3::ToolShell> for a description of the tool shell interface.


=head2 See Also

B<Gnome::Gtk3::Toolbar>, B<Gnome::Gtk3::ToolButton>, B<Gnome::Gtk3::SeparatorToolItem>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ToolItem;
  also is Gnome::Gtk3::Bin;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ToolItem:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new ToolItem object.

  multi method new ( )

Create a ToolItem object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a ToolItem object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<create-menu-proxy toolbar-reconfigured>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::ToolItem';

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
    self._set-native-object(gtk_tool_item_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkToolItem');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tool_item_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkToolItem');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_tool_item_new:new()
=begin pod
=head2 gtk_tool_item_new

Creates a new B<Gnome::Gtk3::ToolItem>

Returns: the new B<Gnome::Gtk3::ToolItem>

Since: 2.4

  method gtk_tool_item_new ( --> N-GObject )


=end pod

sub gtk_tool_item_new ( --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_homogeneous:
=begin pod
=head2 [gtk_tool_item_] set_homogeneous

Sets whether I<tool_item> is to be allocated the same size as other
homogeneous items. The effect is that all homogeneous items will have
the same width as the widest of the items.

Since: 2.4

  method gtk_tool_item_set_homogeneous ( Int $homogeneous )

=item Int $homogeneous; whether I<tool_item> is the same size as other homogeneous items

=end pod

sub gtk_tool_item_set_homogeneous ( N-GObject $tool_item, int32 $homogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_homogeneous:
=begin pod
=head2 [gtk_tool_item_] get_homogeneous

Returns whether I<tool_item> is the same size as other homogeneous
items. See C<gtk_tool_item_set_homogeneous()>.

Returns: C<1> if the item is the same size as other homogeneous
items.

Since: 2.4

  method gtk_tool_item_get_homogeneous ( --> Int )


=end pod

sub gtk_tool_item_get_homogeneous ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_expand:
=begin pod
=head2 [gtk_tool_item_] set_expand

Sets whether I<tool_item> is allocated extra space when there
is more room on the toolbar then needed for the items. The
effect is that the item gets bigger when the toolbar gets bigger
and smaller when the toolbar gets smaller.

Since: 2.4

  method gtk_tool_item_set_expand ( Int $expand )

=item Int $expand; Whether I<tool_item> is allocated extra space

=end pod

sub gtk_tool_item_set_expand ( N-GObject $tool_item, int32 $expand  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_expand:
=begin pod
=head2 [gtk_tool_item_] get_expand

Returns whether I<tool_item> is allocated extra space.
See C<gtk_tool_item_set_expand()>.

Returns: C<1> if I<tool_item> is allocated extra space.

Since: 2.4

  method gtk_tool_item_get_expand ( --> Int )


=end pod

sub gtk_tool_item_get_expand ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_tooltip_text:
=begin pod
=head2 [gtk_tool_item_] set_tooltip_text

Sets the text to be displayed as tooltip on the item.
See C<gtk_widget_set_tooltip_text()>.

Since: 2.12

  method gtk_tool_item_set_tooltip_text ( Str $text )

=item Str $text; text to be used as tooltip for I<tool_item>

=end pod

sub gtk_tool_item_set_tooltip_text ( N-GObject $tool_item, Str $text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_tooltip_markup:
=begin pod
=head2 [gtk_tool_item_] set_tooltip_markup

Sets the markup text to be displayed as tooltip on the item.
See C<gtk_widget_set_tooltip_markup()>.

Since: 2.12

  method gtk_tool_item_set_tooltip_markup ( Str $markup )

=item Str $markup; markup text to be used as tooltip for I<tool_item>

=end pod

sub gtk_tool_item_set_tooltip_markup ( N-GObject $tool_item, Str $markup  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_use_drag_window:
=begin pod
=head2 [gtk_tool_item_] set_use_drag_window

Sets whether I<tool_item> has a drag window. When C<1> the
toolitem can be used as a drag source through C<gtk_drag_source_set()>.
When I<tool_item> has a drag window it will intercept all events,
even those that would otherwise be sent to a child of I<tool_item>.

Since: 2.4

  method gtk_tool_item_set_use_drag_window ( Int $use_drag_window )

=item Int $use_drag_window; Whether I<tool_item> has a drag window.

=end pod

sub gtk_tool_item_set_use_drag_window ( N-GObject $tool_item, int32 $use_drag_window  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_use_drag_window:
=begin pod
=head2 [gtk_tool_item_] get_use_drag_window

Returns whether I<tool_item> has a drag window. See
C<gtk_tool_item_set_use_drag_window()>.

Returns: C<1> if I<tool_item> uses a drag window.

Since: 2.4

  method gtk_tool_item_get_use_drag_window ( --> Int )


=end pod

sub gtk_tool_item_get_use_drag_window ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_visible_horizontal:
=begin pod
=head2 [gtk_tool_item_] set_visible_horizontal

Sets whether I<tool_item> is visible when the toolbar is docked horizontally.

Since: 2.4

  method gtk_tool_item_set_visible_horizontal ( Int $visible_horizontal )

=item Int $visible_horizontal; Whether I<tool_item> is visible when in horizontal mode

=end pod

sub gtk_tool_item_set_visible_horizontal ( N-GObject $tool_item, int32 $visible_horizontal  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_visible_horizontal:
=begin pod
=head2 [gtk_tool_item_] get_visible_horizontal

Returns whether the I<tool_item> is visible on toolbars that are
docked horizontally.

Returns: C<1> if I<tool_item> is visible on toolbars that are
docked horizontally.

Since: 2.4

  method gtk_tool_item_get_visible_horizontal ( --> Int )


=end pod

sub gtk_tool_item_get_visible_horizontal ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_visible_vertical:
=begin pod
=head2 [gtk_tool_item_] set_visible_vertical

Sets whether I<tool_item> is visible when the toolbar is docked
vertically. Some tool items, such as text entries, are too wide to be
useful on a vertically docked toolbar. If I<visible_vertical> is C<0>
I<tool_item> will not appear on toolbars that are docked vertically.

Since: 2.4

  method gtk_tool_item_set_visible_vertical ( Int $visible_vertical )

=item Int $visible_vertical; whether I<tool_item> is visible when the toolbar is in vertical mode

=end pod

sub gtk_tool_item_set_visible_vertical ( N-GObject $tool_item, int32 $visible_vertical  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_visible_vertical:
=begin pod
=head2 [gtk_tool_item_] get_visible_vertical

Returns whether I<tool_item> is visible when the toolbar is docked vertically.
See C<gtk_tool_item_set_visible_vertical()>.

Returns: Whether I<tool_item> is visible when the toolbar is docked vertically

Since: 2.4

  method gtk_tool_item_get_visible_vertical ( --> Int )


=end pod

sub gtk_tool_item_get_visible_vertical ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_is_important:
=begin pod
=head2 [gtk_tool_item_] get_is_important

Returns whether I<tool_item> is considered important. See
C<gtk_tool_item_set_is_important()>

Returns: C<1> if I<tool_item> is considered important.

Since: 2.4

  method gtk_tool_item_get_is_important ( --> Int )


=end pod

sub gtk_tool_item_get_is_important ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_is_important:
=begin pod
=head2 [gtk_tool_item_] set_is_important

Sets whether I<tool_item> should be considered important. The B<Gnome::Gtk3::ToolButton>
class uses this property to determine whether to show or hide its label
when the toolbar style is C<GTK_TOOLBAR_BOTH_HORIZ>. The result is that
only tool buttons with the “is_important” property set have labels, an
effect known as “priority text”

Since: 2.4

  method gtk_tool_item_set_is_important ( Int $is_important )

=item Int $is_important; whether the tool item should be considered important

=end pod

sub gtk_tool_item_set_is_important ( N-GObject $tool_item, int32 $is_important  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_ellipsize_mode:
=begin pod
=head2 [gtk_tool_item_] get_ellipsize_mode

Returns the ellipsize mode used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function to find out how text should
be ellipsized.

Returns: a B<PangoEllipsizeMode> indicating how text in I<tool_item>
should be ellipsized.

Since: 2.20

  method gtk_tool_item_get_ellipsize_mode ( --> PangoEllipsizeMode )


=end pod

sub gtk_tool_item_get_ellipsize_mode ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_icon_size:
=begin pod
=head2 [gtk_tool_item_] get_icon_size

Returns the icon size used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function to find out what size icons
they should use.

Returns: (type int): a B<Gnome::Gtk3::IconSize> indicating the icon size
used for I<tool_item>

Since: 2.4

  method gtk_tool_item_get_icon_size ( --> GtkIconSize )


=end pod

sub gtk_tool_item_get_icon_size ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_orientation:
=begin pod
=head2 [gtk_tool_item_] get_orientation

Returns the orientation used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function to find out what size icons
they should use.

Returns: a B<Gnome::Gtk3::Orientation> indicating the orientation
used for I<tool_item>

Since: 2.4

  method gtk_tool_item_get_orientation ( --> GtkOrientation )


=end pod

sub gtk_tool_item_get_orientation ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_toolbar_style:
=begin pod
=head2 [gtk_tool_item_] get_toolbar_style

Returns the toolbar style used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function in the handler of the
B<Gnome::Gtk3::ToolItem>::toolbar_reconfigured signal to find out in what style
the toolbar is displayed and change themselves accordingly

Possibilities are:
- C<GTK_TOOLBAR_BOTH>, meaning the tool item should show
both an icon and a label, stacked vertically
- C<GTK_TOOLBAR_ICONS>, meaning the toolbar shows only icons
- C<GTK_TOOLBAR_TEXT>, meaning the tool item should only show text
- C<GTK_TOOLBAR_BOTH_HORIZ>, meaning the tool item should show
both an icon and a label, arranged horizontally

Returns: A B<Gnome::Gtk3::ToolbarStyle> indicating the toolbar style used
for I<tool_item>.

Since: 2.4

  method gtk_tool_item_get_toolbar_style ( --> GtkToolbarStyle )


=end pod

sub gtk_tool_item_get_toolbar_style ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_relief_style:
=begin pod
=head2 [gtk_tool_item_] get_relief_style

Returns the relief style of I<tool_item>. See C<gtk_button_set_relief()>.
Custom subclasses of B<Gnome::Gtk3::ToolItem> should call this function in the handler
of the  I<toolbar_reconfigured> signal to find out the
relief style of buttons.

Returns: a B<Gnome::Gtk3::ReliefStyle> indicating the relief style used
for I<tool_item>.

Since: 2.4

  method gtk_tool_item_get_relief_style ( --> GtkReliefStyle )


=end pod

sub gtk_tool_item_get_relief_style ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_text_alignment:
=begin pod
=head2 [gtk_tool_item_] get_text_alignment

Returns the text alignment used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function to find out how text should
be aligned.

Returns: a B<gfloat> indicating the horizontal text alignment
used for I<tool_item>

Since: 2.20

  method gtk_tool_item_get_text_alignment ( --> Num )


=end pod

sub gtk_tool_item_get_text_alignment ( N-GObject $tool_item --> num32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_text_orientation:
=begin pod
=head2 [gtk_tool_item_] get_text_orientation

Returns the text orientation used for I<tool_item>. Custom subclasses of
B<Gnome::Gtk3::ToolItem> should call this function to find out how text should
be orientated.

Returns: a B<Gnome::Gtk3::Orientation> indicating the text orientation
used for I<tool_item>

Since: 2.20

  method gtk_tool_item_get_text_orientation ( --> GtkOrientation )


=end pod

sub gtk_tool_item_get_text_orientation ( N-GObject $tool_item --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_text_size_group:
=begin pod
=head2 [gtk_tool_item_] get_text_size_group

Returns the size group used for labels in I<tool_item>.
Custom subclasses of B<Gnome::Gtk3::ToolItem> should call this function
and use the size group for labels.

Returns: (transfer none): a B<Gnome::Gtk3::SizeGroup>

Since: 2.20

  method gtk_tool_item_get_text_size_group ( --> N-GObject )


=end pod

sub gtk_tool_item_get_text_size_group ( N-GObject $tool_item --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_retrieve_proxy_menu_item:
=begin pod
=head2 [gtk_tool_item_] retrieve_proxy_menu_item

Returns the B<Gnome::Gtk3::MenuItem> that was last set by
C<gtk_tool_item_set_proxy_menu_item()>, ie. the B<Gnome::Gtk3::MenuItem>
that is going to appear in the overflow menu.

Returns: (transfer none): The B<Gnome::Gtk3::MenuItem> that is going to appear in the
overflow menu for I<tool_item>.

Since: 2.4

  method gtk_tool_item_retrieve_proxy_menu_item ( --> N-GObject )


=end pod

sub gtk_tool_item_retrieve_proxy_menu_item ( N-GObject $tool_item --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_get_proxy_menu_item:
=begin pod
=head2 [gtk_tool_item_] get_proxy_menu_item

If I<menu_item_id> matches the string passed to
C<gtk_tool_item_set_proxy_menu_item()> return the corresponding B<Gnome::Gtk3::MenuItem>.

Custom subclasses of B<Gnome::Gtk3::ToolItem> should use this function to
update their menu item when the B<Gnome::Gtk3::ToolItem> changes. That the
I<menu_item_ids> must match ensures that a B<Gnome::Gtk3::ToolItem>
will not inadvertently change a menu item that they did not create.

Returns: (transfer none) (nullable): The B<Gnome::Gtk3::MenuItem> passed to
C<gtk_tool_item_set_proxy_menu_item()>, if the I<menu_item_ids>
match.

Since: 2.4

  method gtk_tool_item_get_proxy_menu_item ( Str $menu_item_id --> N-GObject )

=item Str $menu_item_id; a string used to identify the menu item

=end pod

sub gtk_tool_item_get_proxy_menu_item ( N-GObject $tool_item, Str $menu_item_id --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_set_proxy_menu_item:
=begin pod
=head2 [gtk_tool_item_] set_proxy_menu_item

Sets the B<Gnome::Gtk3::MenuItem> used in the toolbar overflow menu. The
I<menu_item_id> is used to identify the caller of this function and
should also be used with C<gtk_tool_item_get_proxy_menu_item()>.

See also  I<create-menu-proxy>.

Since: 2.4

  method gtk_tool_item_set_proxy_menu_item ( Str $menu_item_id, N-GObject $menu_item )

=item Str $menu_item_id; a string used to identify I<menu_item>
=item N-GObject $menu_item; (nullable): a B<Gnome::Gtk3::MenuItem> to use in the overflow menu, or C<Any>

=end pod

sub gtk_tool_item_set_proxy_menu_item ( N-GObject $tool_item, Str $menu_item_id, N-GObject $menu_item  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_rebuild_menu:
=begin pod
=head2 [gtk_tool_item_] rebuild_menu

Calling this function signals to the toolbar that the
overflow menu item for I<tool_item> has changed. If the
overflow menu is visible when this function it called,
the menu will be rebuilt.

The function must be called when the tool item changes what it
will do in response to the  I<create-menu-proxy> signal.

Since: 2.6

  method gtk_tool_item_rebuild_menu ( )


=end pod

sub gtk_tool_item_rebuild_menu ( N-GObject $tool_item  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tool_item_toolbar_reconfigured:
=begin pod
=head2 [gtk_tool_item_] toolbar_reconfigured

Emits the signal  I<toolbar_reconfigured> on I<tool_item>.
B<Gnome::Gtk3::Toolbar> and other B<Gnome::Gtk3::ToolShell> implementations use this function
to notify children, when some aspect of their configuration changes.

Since: 2.14

  method gtk_tool_item_toolbar_reconfigured ( )


=end pod

sub gtk_tool_item_toolbar_reconfigured ( N-GObject $tool_item  )
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


=comment #TS:0:create-menu-proxy:
=head3 create-menu-proxy

This signal is emitted when the toolbar needs information from I<tool_item>
about whether the item should appear in the toolbar overflow menu. In
response the tool item should either

- call C<gtk_tool_item_set_proxy_menu_item()> with a C<Any>
pointer and return C<1> to indicate that the item should not appear
in the overflow menu

- call C<gtk_tool_item_set_proxy_menu_item()> with a new menu
item and return C<1>, or

- return C<0> to indicate that the signal was not handled by the item.
This means that the item will not appear in the overflow menu unless
a later handler installs a menu item.

The toolbar may cache the result of this signal. When the tool item changes
how it will respond to this signal it must call C<gtk_tool_item_rebuild_menu()>
to invalidate the cache and ensure that the toolbar rebuilds its overflow
menu.

Returns: C<1> if the signal was handled, C<0> if not

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tool_item),
    *%user-options
    --> Int
  );

=item $tool_item; the object the signal was emitted on


=comment #TS:0:toolbar-reconfigured:
=head3 toolbar-reconfigured

This signal is emitted when some property of the toolbar that the
item is a child of changes. For custom subclasses of B<Gnome::Gtk3::ToolItem>,
the default handler of this signal use the functions
- C<gtk_tool_shell_get_orientation()>
- C<gtk_tool_shell_get_style()>
- C<gtk_tool_shell_get_icon_size()>
- C<gtk_tool_shell_get_relief_style()>
to find out what the toolbar should look like and change
themselves accordingly.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($tool_item),
    *%user-options
  );

=item $tool_item; the object the signal was emitted on


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

=comment #TP:0:visible-horizontal:
=head3 Visible when horizontal

Whether the toolbar item is visible when the toolbar is in a horizontal orientation.
Default value: True


The B<Gnome::GObject::Value> type of property I<visible-horizontal> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:visible-vertical:
=head3 Visible when vertical

Whether the toolbar item is visible when the toolbar is in a vertical orientation.
Default value: True


The B<Gnome::GObject::Value> type of property I<visible-vertical> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:is-important:
=head3 Is important

Whether the toolbar item is considered important. When TRUE, toolbar buttons show text in GTK_TOOLBAR_BOTH_HORIZ mode
Default value: False


The B<Gnome::GObject::Value> type of property I<is-important> is C<G_TYPE_BOOLEAN>.
=end pod
