#TL:1:Gnome::Gtk3::Window

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Window

Toplevel which can contain other widgets

![](images/window.png)

=head1 Description

A B<Gnome::Gtk3::Window> is a toplevel window which can contain other widgets. Windows normally have decorations that are under the control of the windowing system and allow the user to manipulate the window (resize it, move it, close it,...).

=head2 Gnome::Gtk3::Window as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Window> implementation of the B<Gnome::Gtk3::Buildable> interface supports a custom <accel-groups> element, which supports any number of <group> elements representing the B<Gnome::Gtk3::AccelGroup> objects you want to add to your window (synonymous with C<gtk_window_add_accel_group()>.

It also supports the <initial-focus> element, whose name property names the widget to receive the focus when the window is mapped.

An example of a UI definition fragment with accel groups:

  <object class="GtkWindow>">
    <accel-groups>
      <group name="accelgroup1"/>
    </accel-groups>
    <initial-focus name="thunderclap"/>
  </object>
  ...
  <object class="GtkAccelGroup>" id="accelgroup1"/>

The B<Gnome::Gtk3::Window> implementation of the B<Gnome::Gtk3::Buildable> interface supports setting a child as the titlebar by specifying “titlebar” as the “type” attribute of a <child> element.

=head2 Css Nodes

  window
  ├── decoration
  ╰── <child>

B<Gnome::Gtk3::Window> has a main CSS node with name window and style class .background, and a subnode with name decoration.

Style classes that are typically used with the main CSS node are .csd (when client-side decorations are in use), .solid-csd (for client-side decorations without invisible borders), .ssd (used by mutter when rendering server-side decorations). B<Gnome::Gtk3::Window> also represents window states with the following style classes on the main node: .tiled, .maximized, .fullscreen. Specialized types of window often add their own discriminating style classes, such as .popup or .tooltip.

B<Gnome::Gtk3::Window> adds the .titlebar and .default-decoration style classes to the widget that is added as a titlebar child.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Window;
  also is Gnome::Gtk3::Bin;

=head2 Uml Diagram

![](plantuml/Window.svg)

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Window;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Window;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Window class process the options
    self.bless( :GtkWindow, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=head2 Example

  my Gnome::Gtk3::Window $w .= new(:title('My Button In My Window'));
  my Gnome::Gtk3::Button $b .= new(:label('The Button'));
  $w.container-add($b);
  $w.show-all;

  my Gnome::Gtk3::Main $m .= new;
  $m.gtk-main;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gdk3::Window;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkwindow.h
# https://developer.gnome.org/gtk3/stable/GtkWindow.html
unit class Gnome::Gtk3::Window:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkWindowType

A B<Gnome::Gtk3::Window> can be one of these types. Most things you’d consider a “window” should have type B<GTK_WINDOW_TOPLEVEL>; windows with this type are managed by the window manager and have a frame by default (call C<gtk_window_set_decorated()> to toggle the frame).  Windows with type B<GTK_WINDOW_POPUP> are ignored by the window manager; window manager keybindings won’t work on them, the window manager won’t decorate the window with a frame, many GTK+ features that rely on the window manager will not work (e.g. resize grips and maximization/minimization). B<GTK_WINDOW_POPUP> is used to implement widgets such as B<Gnome::Gtk3::Menu> or tooltips that you normally don’t think of as windows per se. Nearly all windows should be B<GTK_WINDOW_TOPLEVEL>. In particular, do not use B<GTK_WINDOW_POPUP> just to turn off the window borders; use C<gtk_window_set_decorated()> for that.

=item GTK_WINDOW_TOPLEVEL. A regular window, such as a dialog.
=item GTK_WINDOW_POPUP. A special window such as a tooltip.

=end pod

#TE:1:GtkWindowType:
enum GtkWindowType is export <
  GTK_WINDOW_TOPLEVEL GTK_WINDOW_POPUP
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkWindowPosition

Window placement can be influenced using this enumeration. Note that using GTK_WIN_POS_CENTER_ALWAYS is almost always a bad idea. It won’t necessarily work well with all window managers or on all windowing systems.

=item GTK_WIN_POS_NONE. No influence is made on placement.
=item GTK_WIN_POS_CENTER. Windows should be placed in the center of the screen.
=item GTK_WIN_POS_MOUSE. Windows should be placed at the current mouse position.
=item GTK_WIN_POS_CENTER_ALWAYS. Keep window centered as it changes size, etc.
=item GTK_WIN_POS_CENTER_ON_PARENT. Center the window on its transient parent.

=end pod

#TE:4:GtkWindowPosition:QAManager
enum GtkWindowPosition is export <
  GTK_WIN_POS_NONE
  GTK_WIN_POS_CENTER
  GTK_WIN_POS_MOUSE
  GTK_WIN_POS_CENTER_ALWAYS
  GTK_WIN_POS_CENTER_ON_PARENT
>;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::Window>, which is a toplevel window that can contain other widgets. Nearly always, the type of the window should be C<GTK_WINDOW_TOPLEVEL>. If you’re implementing something like a popup menu from scratch (which is a bad idea, just use B<Gnome::Gtk3::Menu>), you might use C<GTK_WINDOW_POPUP>. C<GTK_WINDOW_POPUP> is not for dialogs, though in some other toolkits dialogs are called “popups”. In GTK+, C<GTK_WINDOW_POPUP> means a pop-up menu or pop-up tooltip. On X11, popup windows are not controlled by the window manager.

If you simply want an undecorated window (no window borders), use C<gtk_window_set_decorated()>, don’t use C<GTK_WINDOW_POPUP>.

All top-level windows created by C<gtk_window_new()> are stored in an internal top-level window list.  This list can be obtained from C<gtk_window_list_toplevels()>. Due to Gtk+ keeping a reference to the window internally, C<gtk_window_new()> does not return a reference to the caller.

To delete a B<Gnome::Gtk3::Window>, call C<gtk_widget_destroy()>.

  multi method new (
    GtkWindowType :$window-type = GTK_WINDOW_TOPLEVEL
  )

=end pod

#TM:2:inheriting:*
#TM:1:new():
#TM:1:new(:window-type):
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<activate-default activate-focus keys-changed>,
    :w1<enable-debugging set-focus>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Window' or %options<GtkWindow> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $wtype = %options<window-type> // GTK_WINDOW_TOPLEVEL;
      self.set-native-object(_gtk_window_new($wtype));
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkWindow');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_window_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkWindow');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_window_new:new()
#`{{
=begin pod
=head2 [gtk_] window_new

Creates a new B<Gnome::Gtk3::Window>, which is a toplevel window that can contain other widgets. Nearly always, the type of the window should be C<GTK_WINDOW_TOPLEVEL>. If you’re implementing something like a popup menu from scratch (which is a bad idea, just use B<Gnome::Gtk3::Menu>), you might use C<GTK_WINDOW_POPUP>. C<GTK_WINDOW_POPUP> is not for dialogs, though in some other toolkits dialogs are called “popups”. In GTK+, C<GTK_WINDOW_POPUP> means a pop-up menu or pop-up tooltip. On X11, popup windows are not controlled by the window manager.

If you simply want an undecorated window (no window borders), use C<gtk_window_set_decorated()>, don’t use C<GTK_WINDOW_POPUP>.

All top-level windows created by C<gtk_window_new()> are stored in an internal top-level window list.  This list can be obtained from C<gtk_window_list_toplevels()>. Due to Gtk+ keeping a reference to the window internally, C<gtk_window_new()> does not return a reference to the caller.

To delete a B<Gnome::Gtk3::Window>, call C<gtk_widget_destroy()>.

Returns: a new B<Gnome::Gtk3::Window>.

  method gtk_window_new ( GtkWindowType $type --> N-GObject  )

=item GtkWindowType $type; type of window

=end pod
}}

sub _gtk_window_new ( int32 $type --> N-GObject )
  is symbol('gtk_window_new')
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_set_title:new(:title)
=begin pod
=head2 [[gtk_] window_] set_title

Sets the title of the B<Gnome::Gtk3::Window>. The title of a window will be displayed in its title bar; on the X Window System, the title bar is rendered by the window manager, so exactly how the title appears to users may vary according to a user’s exact configuration. The title should help a user distinguish this window from other windows they may have open. A good title might include the application name and current document filename, for example.

  method gtk_window_set_title ( Str $title )

=item Str $title; title of the window

=end pod

sub gtk_window_set_title ( N-GObject $window, Str $title )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_get_title
=begin pod
=head2 [[gtk_] window_] get_title

Retrieves the title of the window. See C<gtk_window_set_title()>.

Returns: (nullable): the title of the window, or C<Any> if none has been set explicitly. The returned string is owned by the widget and must not be modified or freed.

  method gtk_window_get_title ( --> Str  )

=end pod

sub gtk_window_get_title ( N-GObject $window )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] set_role

This function is only useful on X11, not with other GTK+ targets.

In combination with the window title, the window role allows a
[window manager][gtk-X11-arch] to identify "the
same" window when an application is restarted. So for example you
might set the “toolbox” role on your app’s toolbox window, so that
when the user restarts their session, the window manager can put
the toolbox back in the same place.

If a window already has a unique title, you don’t need to set the
role, since the WM can use the title to identify the window when
restoring the session.


  method gtk_window_set_role ( Str $role )

=item Str $role; unique identifier for the window to be used when restoring a session

=end pod

sub gtk_window_set_role ( N-GObject $window, Str $role )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] set_startup_id

Startup notification identifiers are used by desktop environment to
track application startup, to provide user feedback and other
features. This function changes the corresponding property on the
underlying B<Gnome::Gdk3::Window>. Normally, startup identifier is managed
automatically and you should only use this function in special cases
like transferring focus from other processes. You should use this
function before calling C<gtk_window_present()> or any equivalent
function generating a window map event.

This function is only useful on X11, not with other GTK+ targets.

Since: 2.12

  method gtk_window_set_startup_id ( Str $startup_id )

=item Str $startup_id; a string with startup-notification identifier

=end pod

sub gtk_window_set_startup_id ( N-GObject $window, Str $startup_id )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] get_role

Returns the role of the window. See C<gtk_window_set_role()> for
further explanation.

Returns: (nullable): the role of the window if set, or C<Any>. The
returned is owned by the widget and must not be modified or freed.

  method gtk_window_get_role ( --> Str  )


=end pod

sub gtk_window_get_role ( N-GObject $window )
  returns Str
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] add_accel_group

Associate I<accel_group> with I<window>, such that calling
C<gtk_accel_groups_activate()> on I<window> will activate accelerators
in I<accel_group>.

  method gtk_window_add_accel_group ( N-GObject $accel_group )

=item N-GObject $accel_group; a B<Gnome::Gtk3::AccelGroup>

=end pod

sub gtk_window_add_accel_group ( N-GObject $window, N-GObject $accel_group )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] remove_accel_group

Reverses the effects of C<gtk_window_add_accel_group()>.

  method gtk_window_remove_accel_group ( N-GObject $accel_group )

=item N-GObject $accel_group; a B<Gnome::Gtk3::AccelGroup>

=end pod

sub gtk_window_remove_accel_group ( N-GObject $window, N-GObject $accel_group )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_window_set_position
=begin pod
=head2 [[gtk_] window_] set_position

Sets a position constraint for this window. If the old or new constraint is C<GTK_WIN_POS_CENTER_ALWAYS>, this will also cause the window to be repositioned to satisfy the new constraint.

  method gtk_window_set_position ( GtkWindowPosition $position )

=item GtkWindowPosition $position; a position constraint.

=end pod

sub gtk_window_set_position ( N-GObject $window, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] activate_focus

Activates the current focused widget within the window.

Returns: C<1> if a widget got activated.

  method gtk_window_activate_focus ( --> Int  )


=end pod

sub gtk_window_activate_focus ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_focus

If I<focus> is not the current focus widget, and is focusable, sets
it as the focus widget for the window. If I<focus> is C<Any>, unsets
the focus widget for this window. To set the focus to a particular
widget in the toplevel, it is usually more convenient to use
C<gtk_widget_grab_focus()> instead of this function.

  method gtk_window_set_focus ( N-GObject $focus )

=item N-GObject $focus; (allow-none): widget to be the new focus widget, or C<Any> to unset any focus widget for the toplevel window.

=end pod

sub gtk_window_set_focus ( N-GObject $window, N-GObject $focus )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_focus

Retrieves the current focused widget within the window.
Note that this is the widget that would have the focus
if the toplevel window focused; if the toplevel window
is not focused then  `gtk_widget_has_focus (widget)` will
not be C<1> for the widget.

Returns: (nullable) (transfer none): the currently focused widget,
or C<Any> if there is none.

  method gtk_window_get_focus ( --> N-GObject  )


=end pod

sub gtk_window_get_focus ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_default

The default widget is the widget that’s activated when the user
presses Enter in a dialog (for example). This function sets or
unsets the default widget for a B<Gnome::Gtk3::Window>. When setting (rather
than unsetting) the default widget it’s generally easier to call
C<gtk_widget_grab_default()> on the widget. Before making a widget
the default widget, you must call C<gtk_widget_set_can_default()> on
the widget you’d like to make the default.

  method gtk_window_set_default ( N-GObject $default_widget )

=item N-GObject $default_widget; (allow-none): widget to be the default, or C<Any> to unset the default widget for the toplevel

=end pod

sub gtk_window_set_default ( N-GObject $window, N-GObject $default_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_default_widget

Returns the default widget for I<window>. See
C<gtk_window_set_default()> for more details.

Returns: (nullable) (transfer none): the default widget, or C<Any>
if there is none.

Since: 2.14

  method gtk_window_get_default_widget ( --> N-GObject  )


=end pod

sub gtk_window_get_default_widget ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] activate_default

Activates the default widget for the window, unless the current
focused widget has been configured to receive the default action
(see C<gtk_widget_set_receives_default()>), in which case the
focused widget is activated.

Returns: C<1> if a widget got activated.

  method gtk_window_activate_default ( --> Int  )


=end pod

sub gtk_window_activate_default ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_transient_for

Dialog windows should be set transient for the main application
window they were spawned from. This allows
[window managers][gtk-X11-arch] to e.g. keep the
dialog on top of the main window, or center the dialog over the
main window. C<gtk_dialog_new_with_buttons()> and other convenience
functions in GTK+ will sometimes call
C<gtk_window_set_transient_for()> on your behalf.

Passing C<Any> for I<parent> unsets the current transient window.

On Wayland, this function can also be used to attach a new
C<GTK_WINDOW_POPUP> to a C<GTK_WINDOW_TOPLEVEL> parent already mapped
on screen so that the C<GTK_WINDOW_POPUP> will be created as a
subsurface-based window C<GDK_WINDOW_SUBSURFACE> which can be
positioned at will relatively to the C<GTK_WINDOW_TOPLEVEL> surface.

On Windows, this function puts the child window on top of the parent,
much as the window manager would have done on X.

  method gtk_window_set_transient_for ( N-GObject $parent )

=item N-GObject $parent; (allow-none): parent window, or C<Any>

=end pod

sub gtk_window_set_transient_for ( N-GObject $window, N-GObject $parent )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_transient_for

Fetches the transient parent for this window. See
C<gtk_window_set_transient_for()>.

Returns: (nullable) (transfer none): the transient parent for this
window, or C<Any> if no transient parent has been set.

  method gtk_window_get_transient_for ( --> N-GObject  )


=end pod

sub gtk_window_get_transient_for ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_attached_to

Marks I<window> as attached to I<attach_widget>. This creates a logical binding
between the window and the widget it belongs to, which is used by GTK+ to
propagate information such as styling or accessibility to I<window> as if it
was a children of I<attach_widget>.

Examples of places where specifying this relation is useful are for instance
a B<Gnome::Gtk3::Menu> created by a B<Gnome::Gtk3::ComboBox>, a completion popup window
created by B<Gnome::Gtk3::Entry> or a typeahead search entry created by B<Gnome::Gtk3::TreeView>.

Note that this function should not be confused with
C<gtk_window_set_transient_for()>, which specifies a window manager relation
between two toplevels instead.

Passing C<Any> for I<attach_widget> detaches the window.

Since: 3.4

  method gtk_window_set_attached_to ( N-GObject $attach_widget )

=item N-GObject $attach_widget; (allow-none): a B<Gnome::Gtk3::Widget>, or C<Any>

=end pod

sub gtk_window_set_attached_to ( N-GObject $window, N-GObject $attach_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_attached_to

Fetches the attach widget for this window. See
C<gtk_window_set_attached_to()>.

Returns: (nullable) (transfer none): the widget where the window
is attached, or C<Any> if the window is not attached to any widget.

Since: 3.4

  method gtk_window_get_attached_to ( --> N-GObject  )


=end pod

sub gtk_window_get_attached_to ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_type_hint

By setting the type hint for the window, you allow the window
manager to decorate and handle the window in a way which is
suitable to the function of the window in your application.

This function should be called before the window becomes visible.

C<gtk_dialog_new_with_buttons()> and other convenience functions in GTK+
will sometimes call C<gtk_window_set_type_hint()> on your behalf.


  method gtk_window_set_type_hint ( GdkWindowTypeHint32 $hint )

=item GdkWindowTypeHint32 $hint; the window type

=end pod

sub gtk_window_set_type_hint ( N-GObject $window, int32 $hint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_type_hint

Gets the type hint for this window. See C<gtk_window_set_type_hint()>.

Returns: the type hint for I<window>.

  method gtk_window_get_type_hint ( --> GdkWindowTypeHint32  )


=end pod

sub gtk_window_get_type_hint ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_skip_taskbar_hint

Windows may set a hint asking the desktop environment not to display
the window in the task bar. This function sets this hint.

Since: 2.2

  method gtk_window_set_skip_taskbar_hint ( Int $setting )

=item Int $setting; C<1> to keep this window from appearing in the task bar

=end pod

sub gtk_window_set_skip_taskbar_hint ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_skip_taskbar_hint

Gets the value set by C<gtk_window_set_skip_taskbar_hint()>

Returns: C<1> if window shouldn’t be in taskbar

Since: 2.2

  method gtk_window_get_skip_taskbar_hint ( --> Int  )


=end pod

sub gtk_window_get_skip_taskbar_hint ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_skip_pager_hint

Windows may set a hint asking the desktop environment not to display
the window in the pager. This function sets this hint.
(A "pager" is any desktop navigation tool such as a workspace
switcher that displays a thumbnail representation of the windows
on the screen.)

Since: 2.2

  method gtk_window_set_skip_pager_hint ( Int $setting )

=item Int $setting; C<1> to keep this window from appearing in the pager

=end pod

sub gtk_window_set_skip_pager_hint ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_skip_pager_hint

Gets the value set by C<gtk_window_set_skip_pager_hint()>.

Returns: C<1> if window shouldn’t be in pager

Since: 2.2

  method gtk_window_get_skip_pager_hint ( --> Int  )


=end pod

sub gtk_window_get_skip_pager_hint ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_urgency_hint

Windows may set a hint asking the desktop environment to draw
the users attention to the window. This function sets this hint.

Since: 2.8

  method gtk_window_set_urgency_hint ( Int $setting )

=item Int $setting; C<1> to mark this window as urgent

=end pod

sub gtk_window_set_urgency_hint ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_urgency_hint

Gets the value set by C<gtk_window_set_urgency_hint()>

Returns: C<1> if window is urgent

Since: 2.8

  method gtk_window_get_urgency_hint ( --> Int  )


=end pod

sub gtk_window_get_urgency_hint ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_accept_focus

Windows may set a hint asking the desktop environment not to receive
the input focus. This function sets this hint.

Since: 2.4

  method gtk_window_set_accept_focus ( Int $setting )

=item Int $setting; C<1> to let this window receive input focus

=end pod

sub gtk_window_set_accept_focus ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_accept_focus

Gets the value set by C<gtk_window_set_accept_focus()>.

Returns: C<1> if window should receive the input focus

Since: 2.4

  method gtk_window_get_accept_focus ( --> Int  )


=end pod

sub gtk_window_get_accept_focus ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_focus_on_map

Windows may set a hint asking the desktop environment not to receive
the input focus when the window is mapped.  This function sets this
hint.

Since: 2.6

  method gtk_window_set_focus_on_map ( Int $setting )

=item Int $setting; C<1> to let this window receive input focus on map

=end pod

sub gtk_window_set_focus_on_map ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_focus_on_map

Gets the value set by C<gtk_window_set_focus_on_map()>.

Returns: C<1> if window should receive the input focus when
mapped.

Since: 2.6

  method gtk_window_get_focus_on_map ( --> Int  )


=end pod

sub gtk_window_get_focus_on_map ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_destroy_with_parent

If I<setting> is C<1>, then destroying the transient parent of I<window>
will also destroy I<window> itself. This is useful for dialogs that
shouldn’t persist beyond the lifetime of the main window they're
associated with, for example.

  method gtk_window_set_destroy_with_parent ( Int $setting )

=item Int $setting; whether to destroy I<window> with its transient parent

=end pod

sub gtk_window_set_destroy_with_parent ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_destroy_with_parent

Returns whether the window will be destroyed with its transient parent. See
C<gtk_window_set_destroy_with_parent()>.

Returns: C<1> if the window will be destroyed with its transient parent.

  method gtk_window_get_destroy_with_parent ( --> Int  )


=end pod

sub gtk_window_get_destroy_with_parent ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_hide_titlebar_when_maximized

If I<setting> is C<1>, then I<window> will request that it’s titlebar
should be hidden when maximized.
This is useful for windows that don’t convey any information other
than the application name in the titlebar, to put the available
screen space to better use. If the underlying window system does not
support the request, the setting will not have any effect.

Note that custom titlebars set with C<gtk_window_set_titlebar()> are
not affected by this. The application is in full control of their
content and visibility anyway.

Since: 3.4

  method gtk_window_set_hide_titlebar_when_maximized ( Int $setting )

=item Int $setting; whether to hide the titlebar when I<window> is maximized

=end pod

sub gtk_window_set_hide_titlebar_when_maximized ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_hide_titlebar_when_maximized

Returns whether the window has requested to have its titlebar hidden
when maximized. See C<gtk_window_set_hide_titlebar_when_maximized()>.

Returns: C<1> if the window has requested to have its titlebar
hidden when maximized

Since: 3.4

  method gtk_window_get_hide_titlebar_when_maximized ( --> Int  )


=end pod

sub gtk_window_get_hide_titlebar_when_maximized ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_mnemonics_visible

Sets the prop C<mnemonics-visible> property.

Since: 2.20

  method gtk_window_set_mnemonics_visible ( Int $setting )

=item Int $setting; the new value

=end pod

sub gtk_window_set_mnemonics_visible ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_mnemonics_visible

Gets the value of the prop C<mnemonics-visible> property.

Returns: C<1> if mnemonics are supposed to be visible
in this window.

Since: 2.20

  method gtk_window_get_mnemonics_visible ( --> Int  )


=end pod

sub gtk_window_get_mnemonics_visible ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_focus_visible

Sets the prop C<focus-visible> property.

Since: 3.2

  method gtk_window_set_focus_visible ( Int $setting )

=item Int $setting; the new value

=end pod

sub gtk_window_set_focus_visible ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_focus_visible

Gets the value of the prop C<focus-visible> property.

Returns: C<1> if “focus rectangles” are supposed to be visible
in this window.

Since: 3.2

  method gtk_window_get_focus_visible ( --> Int  )


=end pod

sub gtk_window_get_focus_visible ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_resizable

Sets whether the user can resize a window. Windows are user resizable
by default.

  method gtk_window_set_resizable ( Int $resizable )

=item Int $resizable; C<1> if the user can resize this window

=end pod

sub gtk_window_set_resizable ( N-GObject $window, int32 $resizable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_resizable

Gets the value set by C<gtk_window_set_resizable()>.

Returns: C<1> if the user can resize the window

  method gtk_window_get_resizable ( --> Int  )


=end pod

sub gtk_window_get_resizable ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_gravity

Window gravity defines the meaning of coordinates passed to
C<gtk_window_move()>. See C<gtk_window_move()> and B<Gnome::Gdk3::Gravity> for
more details.

The default window gravity is C<GDK_GRAVITY_NORTH_WEST> which will
typically “do what you mean.”


  method gtk_window_set_gravity ( GdkGravity $gravity )

=item GdkGravity $gravity; window gravity

=end pod

sub gtk_window_set_gravity ( N-GObject $window, int32 $gravity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_gravity

Gets the value set by C<gtk_window_set_gravity()>.

Returns: (transfer none): window gravity

  method gtk_window_get_gravity ( --> GdkGravity  )


=end pod

sub gtk_window_get_gravity ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_geometry_hints

This function sets up hints about how a window can be resized by
the user.  You can set a minimum and maximum size; allowed resize
increments (e.g. for xterm, you can only resize by the size of a
character); aspect ratios; and more. See the B<Gnome::Gdk3::Geometry> struct.

  method gtk_window_set_geometry_hints ( N-GObject $geometry_widget, GdkGeometry $geometry, GdkWindowHints $geom_mask )

=item N-GObject $geometry_widget; (allow-none): widget the geometry hints used to be applied to or C<Any>. Since 3.20 this argument is ignored and GTK behaves as if C<Any> was set.
=item GdkGeometry $geometry; (allow-none): struct containing geometry information or C<Any>
=item GdkWindowHints $geom_mask; mask indicating which struct fields should be paid attention to

=end pod

sub gtk_window_set_geometry_hints ( N-GObject $window, N-GObject $geometry_widget, GdkGeometry $geometry, int32 $geom_mask )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_screen

Sets the B<Gnome::Gdk3::Screen> where the I<window> is displayed; if
the window is already mapped, it will be unmapped, and
then remapped on the new screen.

Since: 2.2

  method gtk_window_set_screen ( N-GObject $screen )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>.

=end pod

sub gtk_window_set_screen ( N-GObject $window, N-GObject $screen )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_screen

Returns the B<Gnome::Gdk3::Screen> associated with I<window>.

Returns: (transfer none): a B<Gnome::Gdk3::Screen>.

Since: 2.2

  method gtk_window_get_screen ( --> N-GObject  )


=end pod

sub gtk_window_get_screen ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] is_active

Returns whether the window is part of the current active toplevel.
(That is, the toplevel window receiving keystrokes.)
The return value is C<1> if the window is active toplevel
itself, but also if it is, say, a B<Gnome::Gtk3::Plug> embedded in the active toplevel.
You might use this function if you wanted to draw a widget
differently in an active window from a widget in an inactive window.
See C<gtk_window_has_toplevel_focus()>

Returns: C<1> if the window part of the current active window.

Since: 2.4

  method gtk_window_is_active ( --> Int  )


=end pod

sub gtk_window_is_active ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] has_toplevel_focus

Returns whether the input focus is within this B<Gnome::Gtk3::Window>.
For real toplevel windows, this is identical to C<gtk_window_is_active()>,
but for embedded windows, like B<Gnome::Gtk3::Plug>, the results will differ.

Returns: C<1> if the input focus is within this B<Gnome::Gtk3::Window>

Since: 2.4

  method gtk_window_has_toplevel_focus ( --> Int  )


=end pod

sub gtk_window_has_toplevel_focus ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_decorated

By default, windows are decorated with a title bar, resize
controls, etc.  Some [window managers][gtk-X11-arch]
allow GTK+ to disable these decorations, creating a
borderless window. If you set the decorated property to C<0>
using this function, GTK+ will do its best to convince the window
manager not to decorate the window. Depending on the system, this
function may not have any effect when called on a window that is
already visible, so you should call it before calling C<gtk_widget_show()>.

On Windows, this function always works, since there’s no window manager
policy involved.


  method gtk_window_set_decorated ( Int $setting )

=item Int $setting; C<1> to decorate the window

=end pod

sub gtk_window_set_decorated ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_decorated

Returns whether the window has been set to have decorations
such as a title bar via C<gtk_window_set_decorated()>.

Returns: C<1> if the window has been set to have decorations

  method gtk_window_get_decorated ( --> Int  )


=end pod

sub gtk_window_get_decorated ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_deletable

By default, windows have a close button in the window frame. Some
[window managers][gtk-X11-arch] allow GTK+ to
disable this button. If you set the deletable property to C<0>
using this function, GTK+ will do its best to convince the window
manager not to show a close button. Depending on the system, this
function may not have any effect when called on a window that is
already visible, so you should call it before calling C<gtk_widget_show()>.

On Windows, this function always works, since there’s no window manager
policy involved.

Since: 2.10

  method gtk_window_set_deletable ( Int $setting )

=item Int $setting; C<1> to decorate the window as deletable

=end pod

sub gtk_window_set_deletable ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_deletable

Returns whether the window has been set to have a close button
via C<gtk_window_set_deletable()>.

Returns: C<1> if the window has been set to have a close button

Since: 2.10

  method gtk_window_get_deletable ( --> Int  )


=end pod

sub gtk_window_get_deletable ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_icon_list

Sets up the icon representing a B<Gnome::Gtk3::Window>. The icon is used when
the window is minimized (also known as iconified).  Some window
managers or desktop environments may also place it in the window
frame, or display it in other contexts. On others, the icon is not
used at all, so your mileage may vary.

C<gtk_window_set_icon_list()> allows you to pass in the same icon in
several hand-drawn sizes. The list should contain the natural sizes
your icon is available in; that is, don’t scale the image before
passing it to GTK+. Scaling is postponed until the last minute,
when the desired final size is known, to allow best quality.

By passing several sizes, you may improve the final image quality
of the icon, by reducing or eliminating automatic image scaling.

Recommended sizes to provide: 16x16, 32x32, 48x48 at minimum, and
larger images (64x64, 128x128) if you have them.

See also C<gtk_window_set_default_icon_list()> to set the icon
for all windows in your application in one go.

Note that transient windows (those who have been set transient for another
window using C<gtk_window_set_transient_for()>) will inherit their
icon from their transient parent. So there’s no need to explicitly
set the icon on transient windows.

  method gtk_window_set_icon_list ( N-GObject $list )

=item N-GObject $list; (element-type B<Gnome::Gdk3::Pixbuf>): list of B<Gnome::Gdk3::Pixbuf>

=end pod

sub gtk_window_set_icon_list ( N-GObject $window, N-GObject $list )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_icon_list

Retrieves the list of icons set by C<gtk_window_set_icon_list()>.
The list is copied, but the reference count on each
member won’t be incremented.

Returns: (element-type B<Gnome::Gdk3::Pixbuf>) (transfer container): copy of window’s icon list

  method gtk_window_get_icon_list ( --> N-GObject  )


=end pod

sub gtk_window_get_icon_list ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_icon

Sets up the icon representing a B<Gnome::Gtk3::Window>. This icon is used when the window is minimized (also known as iconified). Some window managers or desktop environments may also place it in the window frame, or display it in other contexts. On others, the icon is not used at all, so your mileage may vary.

The icon should be provided in whatever size it was naturally drawn; that is, don’t scale the image before passing it to GTK+. Scaling is postponed until the last minute, when the desired final size is known, to allow best quality.

If you have your icon hand-drawn in multiple sizes, use C<gtk_window_set_icon_list()>. Then the best size will be used. This function is equivalent to calling C<gtk_window_set_icon_list()> with a 1-element list.

See also C<gtk_window_set_default_icon_list()> to set the icon for all windows in your application in one go.

  method gtk_window_set_icon ( N-GObject $icon )

=item N-GObject $icon; icon image, or undefined

=end pod

sub gtk_window_set_icon ( N-GObject $window, N-GObject $icon )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_icon_name

Sets the icon for the window from a named themed icon.
See the docs for B<Gnome::Gtk3::IconTheme> for more details.
On some platforms, the window icon is not used at all.

Note that this has nothing to do with the WM_ICON_NAME
property which is mentioned in the ICCCM.

Since: 2.6

  method gtk_window_set_icon_name ( Str $name )

=item Str $name; (allow-none): the name of the themed icon

=end pod

sub gtk_window_set_icon_name ( N-GObject $window, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_icon_from_file

Sets the icon for I<window>.
Warns on failure if I<err> is C<Any>.

This function is equivalent to calling C<gtk_window_set_icon()>
with a pixbuf created by loading the image from I<filename>.

Returns: C<1> if setting the icon succeeded.

Since: 2.2

  method gtk_window_set_icon_from_file ( Str $filename, N-GObject $err --> Int  )

=item Str $filename; (type filename): location of icon file
=item N-GObject $err; (allow-none): location to store error, or C<Any>.

=end pod

sub gtk_window_set_icon_from_file ( N-GObject $window, Str $filename, N-GObject $err )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_icon

Gets the value set by C<gtk_window_set_icon()> (or if you've
called C<gtk_window_set_icon_list()>, gets the first icon in
the icon list).

Returns: (transfer none): icon for window

  method gtk_window_get_icon ( --> N-GObject  )


=end pod

sub gtk_window_get_icon ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_icon_name

Returns the name of the themed icon for the window,
see C<gtk_window_set_icon_name()>.

Returns: (nullable): the icon name or C<Any> if the window has
no themed icon

Since: 2.6

  method gtk_window_get_icon_name ( --> Str  )


=end pod

sub gtk_window_get_icon_name ( N-GObject $window )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_default_icon_list

Sets an icon list to be used as fallback for windows that haven't
had C<gtk_window_set_icon_list()> called on them to set up a
window-specific icon list. This function allows you to set up the
icon for all windows in your app at once.

See C<gtk_window_set_icon_list()> for more details.


  method gtk_window_set_default_icon_list ( N-GObject $list )

=item N-GObject $list; (element-type B<Gnome::Gdk3::Pixbuf>) (transfer container): a list of B<Gnome::Gdk3::Pixbuf>

=end pod

sub gtk_window_set_default_icon_list ( N-GObject $list )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_default_icon_list

Gets the value set by C<gtk_window_set_default_icon_list()>.
The list is a copy and should be freed with C<g_list_free()>,
but the pixbufs in the list have not had their reference count
incremented.

Returns: (element-type B<Gnome::Gdk3::Pixbuf>) (transfer container): copy of default icon list

  method gtk_window_get_default_icon_list ( --> N-GObject  )


=end pod

sub gtk_window_get_default_icon_list (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_default_icon

Sets an icon to be used as fallback for windows that haven't
had C<gtk_window_set_icon()> called on them from a pixbuf.

Since: 2.4

  method gtk_window_set_default_icon ( N-GObject $icon )

=item N-GObject $icon; the icon

=end pod

sub gtk_window_set_default_icon ( N-GObject $icon )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_default_icon_name

Sets an icon to be used as fallback for windows that haven't
had C<gtk_window_set_icon_list()> called on them from a named
themed icon, see C<gtk_window_set_icon_name()>.

Since: 2.6

  method gtk_window_set_default_icon_name ( Str $name )

=item Str $name; the name of the themed icon

=end pod

sub gtk_window_set_default_icon_name ( Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_default_icon_name

Returns the fallback icon name for windows that has been set
with C<gtk_window_set_default_icon_name()>. The returned
string is owned by GTK+ and should not be modified. It
is only valid until the next call to
C<gtk_window_set_default_icon_name()>.

Returns: the fallback icon name for windows

Since: 2.16

  method gtk_window_get_default_icon_name ( --> Str  )


=end pod

sub gtk_window_get_default_icon_name (  )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_default_icon_from_file

Sets an icon to be used as fallback for windows that haven't
had C<gtk_window_set_icon_list()> called on them from a file
on disk. Warns on failure if I<err> is C<Any>.

Returns: C<1> if setting the icon succeeded.

Since: 2.2

  method gtk_window_set_default_icon_from_file ( Str $filename, N-GObject $err --> Int  )

=item Str $filename; (type filename): location of icon file
=item N-GObject $err; (allow-none): location to store error, or C<Any>.

=end pod

sub gtk_window_set_default_icon_from_file ( Str $filename, N-GObject $err )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_auto_startup_notification

By default, after showing the first B<Gnome::Gtk3::Window>, GTK+ calls
C<gdk_notify_startup_complete()>.  Call this function to disable
the automatic startup notification. You might do this if your
first window is a splash screen, and you want to delay notification
until after your real main window has been shown, for example.

In that example, you would disable startup notification
temporarily, show your splash screen, then re-enable it so that
showing the main window would automatically result in notification.

Since: 2.2

  method gtk_window_set_auto_startup_notification ( Int $setting )

=item Int $setting; C<1> to automatically do startup notification

=end pod

sub gtk_window_set_auto_startup_notification ( int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_modal

Sets a window modal or non-modal. Modal windows prevent interaction
with other windows in the same application. To keep modal dialogs
on top of main application windows, use
C<gtk_window_set_transient_for()> to make the dialog transient for the
parent; most [window managers][gtk-X11-arch]
will then disallow lowering the dialog below the parent.



  method gtk_window_set_modal ( Int $modal )

=item Int $modal; whether the window is modal

=end pod

sub gtk_window_set_modal ( N-GObject $window, int32 $modal )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_modal

Returns whether the window is modal. See C<gtk_window_set_modal()>.

Returns: C<1> if the window is set to be modal and
establishes a grab when shown

  method gtk_window_get_modal ( --> Int  )


=end pod

sub gtk_window_get_modal ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] list_toplevels

Returns a list of all existing toplevel windows. The widgets
in the list are not individually referenced. If you want
to iterate through the list and perform actions involving
callbacks that might destroy the widgets, you must call
`g_list_foreach (result, (GFunc)g_object_ref, NULL)` first, and
then unref all the widgets afterwards.

Returns: (element-type B<Gnome::Gtk3::Widget>) (transfer container): list of toplevel widgets

  method gtk_window_list_toplevels ( --> N-GObject  )


=end pod

sub gtk_window_list_toplevels (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_has_user_ref_count

Tells GTK+ whether to drop its extra reference to the window
when C<gtk_widget_destroy()> is called.

This function is only exported for the benefit of language
bindings which may need to keep the window alive until their
wrapper object is garbage collected. There is no justification
for ever calling this function in an application.

Since: 3.0

  method gtk_window_set_has_user_ref_count ( Int $setting )

=item Int $setting; the new value

=end pod

sub gtk_window_set_has_user_ref_count ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] add_mnemonic

Adds a mnemonic to this window.

  method gtk_window_add_mnemonic ( UInt $keyval, N-GObject $target )

=item UInt $keyval; the mnemonic
=item N-GObject $target; the widget that gets activated by the mnemonic

=end pod

sub gtk_window_add_mnemonic ( N-GObject $window, uint32 $keyval, N-GObject $target )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] remove_mnemonic

Removes a mnemonic from this window.

  method gtk_window_remove_mnemonic ( UInt $keyval, N-GObject $target )

=item UInt $keyval; the mnemonic
=item N-GObject $target; the widget that gets activated by the mnemonic

=end pod

sub gtk_window_remove_mnemonic ( N-GObject $window, uint32 $keyval, N-GObject $target )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] mnemonic_activate

Activates the targets associated with the mnemonic.

Returns: C<1> if the activation is done.

  method gtk_window_mnemonic_activate ( UInt $keyval, GdkModifierType $modifier --> Int  )

=item UInt $keyval; the mnemonic
=item GdkModifierType $modifier; the modifiers

=end pod

sub gtk_window_mnemonic_activate ( N-GObject $window, uint32 $keyval, int32 $modifier )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_mnemonic_modifier

Sets the mnemonic modifier for this window.

  method gtk_window_set_mnemonic_modifier ( GdkModifierType $modifier )

=item GdkModifierType $modifier; the modifier mask used to activate mnemonics on this window.

=end pod

sub gtk_window_set_mnemonic_modifier ( N-GObject $window, int32 $modifier )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_mnemonic_modifier

Returns the mnemonic modifier for this window. See
C<gtk_window_set_mnemonic_modifier()>.

Returns: the modifier mask used to activate
mnemonics on this window.

  method gtk_window_get_mnemonic_modifier ( --> GdkModifierType  )


=end pod

sub gtk_window_get_mnemonic_modifier ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] activate_key

Activates mnemonics and accelerators for this B<Gnome::Gtk3::Window>. This is normally
called by the default ::key_press_event handler for toplevel windows,
however in some cases it may be useful to call this directly when
overriding the standard key handling for a toplevel window.

Returns: C<1> if a mnemonic or accelerator was found and activated.

Since: 2.4

  method gtk_window_activate_key ( N-GdkEventKey $event --> Int  )

=item N-GdkEventKey $event; a B<Gnome::Gdk3::EventKey>

=end pod

sub gtk_window_activate_key ( N-GObject $window, N-GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] propagate_key_event

Propagate a key press or release event to the focus widget and
up the focus container chain until a widget handles I<event>.
This is normally called by the default ::key_press_event and
::key_release_event handlers for toplevel windows,
however in some cases it may be useful to call this directly when
overriding the standard key handling for a toplevel window.

Returns: C<1> if a widget in the focus chain handled the event.

Since: 2.4

  method gtk_window_propagate_key_event ( N-GdkEventKey $event --> Int  )

=item N-GdkEventKey $event; a B<Gnome::Gdk3::EventKey>

=end pod

sub gtk_window_propagate_key_event ( N-GObject $window, N-GdkEventKey $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_present

Presents a window to the user. This may mean raising the window
in the stacking order, deiconifying it, moving it to the current
desktop, and/or giving it the keyboard focus, possibly dependent
on the user’s platform, window manager, and preferences.

If I<window> is hidden, this function calls C<gtk_widget_show()>
as well.

This function should be used when the user tries to open a window
that’s already open. Say for example the preferences dialog is
currently open, and the user chooses Preferences from the menu
a second time; use C<gtk_window_present()> to move the already-open dialog
where the user can see it.

If you are calling this function in response to a user interaction,
it is preferable to use C<gtk_window_present_with_time()>.


  method gtk_window_present ( )


=end pod

sub gtk_window_present ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] present_with_time

Presents a window to the user in response to a user interaction.
If you need to present a window without a timestamp, use
C<gtk_window_present()>. See C<gtk_window_present()> for details.

Since: 2.8

  method gtk_window_present_with_time ( UInt $timestamp )

=item UInt $timestamp; the timestamp of the user interaction (typically a  button or key press event) which triggered this call

=end pod

sub gtk_window_present_with_time ( N-GObject $window, uint32 $timestamp )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_iconify

Asks to iconify (i.e. minimize) the specified I<window>. Note that
you shouldn’t assume the window is definitely iconified afterward,
because other entities (e.g. the user or
[window manager][gtk-X11-arch]) could deiconify it
again, or there may not be a window manager in which case
iconification isn’t possible, etc. But normally the window will end
up iconified. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window,
in which case the window will be iconified before it ever appears
onscreen.

You can track iconification via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

  method gtk_window_iconify ( )


=end pod

sub gtk_window_iconify ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_deiconify

Asks to deiconify (i.e. unminimize) the specified I<window>. Note
that you shouldn’t assume the window is definitely deiconified
afterward, because other entities (e.g. the user or
[window manager][gtk-X11-arch])) could iconify it
again before your code which assumes deiconification gets to run.

You can track iconification via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

  method gtk_window_deiconify ( )


=end pod

sub gtk_window_deiconify ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_stick

Asks to stick I<window>, which means that it will appear on all user
desktops. Note that you shouldn’t assume the window is definitely
stuck afterward, because other entities (e.g. the user or
[window manager][gtk-X11-arch] could unstick it
again, and some window managers do not support sticking
windows. But normally the window will end up stuck. Just don't
write code that crashes if not.

It’s permitted to call this function before showing a window.

You can track stickiness via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

  method gtk_window_stick ( )


=end pod

sub gtk_window_stick ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_unstick

Asks to unstick I<window>, which means that it will appear on only
one of the user’s desktops. Note that you shouldn’t assume the
window is definitely unstuck afterward, because other entities
(e.g. the user or [window manager][gtk-X11-arch]) could
stick it again. But normally the window will
end up stuck. Just don’t write code that crashes if not.

You can track stickiness via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

  method gtk_window_unstick ( )


=end pod

sub gtk_window_unstick ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_maximize

Asks to maximize I<window>, so that it becomes full-screen. Note that
you shouldn’t assume the window is definitely maximized afterward,
because other entities (e.g. the user or
[window manager][gtk-X11-arch]) could unmaximize it
again, and not all window managers support maximization. But
normally the window will end up maximized. Just don’t write code
that crashes if not.

It’s permitted to call this function before showing a window,
in which case the window will be maximized when it appears onscreen
initially.

You can track maximization via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>, or by listening to notifications on the
prop C<is-maximized> property.

  method gtk_window_maximize ( )


=end pod

sub gtk_window_maximize ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_unmaximize

Asks to unmaximize I<window>. Note that you shouldn’t assume the
window is definitely unmaximized afterward, because other entities
(e.g. the user or [window manager][gtk-X11-arch])
could maximize it again, and not all window
managers honor requests to unmaximize. But normally the window will
end up unmaximized. Just don’t write code that crashes if not.

You can track maximization via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

  method gtk_window_unmaximize ( )


=end pod

sub gtk_window_unmaximize ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_fullscreen

Asks to place I<window> in the fullscreen state. Note that you
shouldn’t assume the window is definitely full screen afterward,
because other entities (e.g. the user or
[window manager][gtk-X11-arch]) could unfullscreen it
again, and not all window managers honor requests to fullscreen
windows. But normally the window will end up fullscreen. Just
don’t write code that crashes if not.

You can track the fullscreen state via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

Since: 2.2

  method gtk_window_fullscreen ( )


=end pod

sub gtk_window_fullscreen ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_unfullscreen

Asks to toggle off the fullscreen state for I<window>. Note that you
shouldn’t assume the window is definitely not full screen
afterward, because other entities (e.g. the user or
[window manager][gtk-X11-arch]) could fullscreen it
again, and not all window managers honor requests to unfullscreen
windows. But normally the window will end up restored to its normal
state. Just don’t write code that crashes if not.

You can track the fullscreen state via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

Since: 2.2

  method gtk_window_unfullscreen ( )


=end pod

sub gtk_window_unfullscreen ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] fullscreen_on_monitor

Asks to place I<window> in the fullscreen state. Note that you shouldn't assume
the window is definitely full screen afterward.

You can track the fullscreen state via the "window-state-event" signal
on B<Gnome::Gtk3::Widget>.

Since: 3.18

  method gtk_window_fullscreen_on_monitor ( N-GObject $screen, Int $monitor )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen> to draw to
=item Int $monitor; which monitor to go fullscreen on

=end pod

sub gtk_window_fullscreen_on_monitor ( N-GObject $window, N-GObject $screen, int32 $monitor )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [gtk_] window_close

Requests that the window is closed, similar to what happens
when a window manager close button is clicked.

This function can be used with close buttons in custom
titlebars.

Since: 3.10

  method gtk_window_close ( )


=end pod

sub gtk_window_close ( N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_keep_above

Asks to keep I<window> above, so that it stays on top. Note that
you shouldn’t assume the window is definitely above afterward,
because other entities (e.g. the user or
[window manager][gtk-X11-arch]) could not keep it above,
and not all window managers support keeping windows above. But
normally the window will end kept above. Just don’t write code
that crashes if not.

It’s permitted to call this function before showing a window,
in which case the window will be kept above when it appears onscreen
initially.

You can track the above state via the “window-state-event” signal
on B<Gnome::Gtk3::Widget>.

Note that, according to the
[Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec),
the above state is mainly meant for user preferences and should not
be used by applications e.g. for drawing attention to their
dialogs.

Since: 2.4

  method gtk_window_set_keep_above ( Int $setting )

=item Int $setting; whether to keep I<window> above other windows

=end pod

sub gtk_window_set_keep_above ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_keep_below

Asks to keep I<window> below, so that it stays in bottom. Note that you shouldn’t assume the window is definitely below afterward, because other entities (e.g. the user or window manager) could not keep it below, and not all window managers support putting windows below. But normally the window will be kept below. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window, in which case the window will be kept below when it appears onscreen initially.

You can track the below state via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

Note that, according to the [Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec), the above state is mainly meant for user preferences and should not be used by applications e.g. for drawing attention to their dialogs.

Since: 2.4

  method gtk_window_set_keep_below ( Int $setting )

=item Int $setting; whether to keep I<window> below other windows

=end pod

sub gtk_window_set_keep_below ( N-GObject $window, int32 $setting )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] begin_resize_drag

Starts resizing a window. This function is used if an application
has window resizing controls. When GDK can support it, the resize
will be done using the standard mechanism for the
[window manager][gtk-X11-arch] or windowing
system. Otherwise, GDK will try to emulate window resizing,
potentially not all that well, depending on the windowing system.

  method gtk_window_begin_resize_drag ( GdkWindowEdge $edge, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item GdkWindowEdge $edge; mouse button that initiated the drag
=item Int $button; position of the resize control
=item Int $root_x; X position where the user clicked to initiate the drag, in root window coordinates
=item Int $root_y; Y position where the user clicked to initiate the drag
=item UInt $timestamp; timestamp from the click event that initiated the drag

=end pod

sub gtk_window_begin_resize_drag ( N-GObject $window, int32 $edge, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] begin_move_drag

Starts moving a window. This function is used if an application has
window movement grips. When GDK can support it, the window movement
will be done using the standard mechanism for the
[window manager][gtk-X11-arch] or windowing
system. Otherwise, GDK will try to emulate window movement,
potentially not all that well, depending on the windowing system.

  method gtk_window_begin_move_drag ( Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item Int $button; mouse button that initiated the drag
=item Int $root_x; X position where the user clicked to initiate the drag, in root window coordinates
=item Int $root_y; Y position where the user clicked to initiate the drag
=item UInt $timestamp; timestamp from the click event that initiated the drag

=end pod

sub gtk_window_begin_move_drag ( N-GObject $window, int32 $button, int32 $root_x, int32 $root_y, uint32 $timestamp )
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:1:gtk_window_set_default_size
=begin pod
=head2 [[gtk_] window_] set_default_size

Sets the default size of a window. If the window’s “natural” size
(its size request) is larger than the default, the default will be
ignored. More generally, if the default size does not obey the
geometry hints for the window (C<gtk_window_set_geometry_hints()> can
be used to set these explicitly), the default size will be clamped
to the nearest permitted size.

Unlike C<gtk_widget_set_size_request()>, which sets a size request for
a widget and thus would keep users from shrinking the window, this
function only sets the initial size, just as if the user had
resized the window themselves. Users can still shrink the window
again as they normally would. Setting a default size of -1 means to
use the “natural” default size (the size request of the window).

For more control over a window’s initial size and how resizing works,
investigate C<gtk_window_set_geometry_hints()>.

For some uses, C<gtk_window_resize()> is a more appropriate function.
C<gtk_window_resize()> changes the current size of the window, rather
than the size to be used on initial display. C<gtk_window_resize()> always
affects the window itself, not the geometry widget.

The default size of a window only affects the first time a window is
shown; if a window is hidden and re-shown, it will remember the size
it had prior to hiding, rather than using the default size.

Windows can’t actually be 0x0 in size, they must be at least 1x1, but
passing 0 for I<width> and I<height> is OK, resulting in a 1x1 default size.

If you use this function to reestablish a previously saved window size,
note that the appropriate size to save is the one returned by
C<gtk_window_get_size()>. Using the window allocation directly will not
work in all circumstances and can lead to growing or shrinking windows.

  method gtk_window_set_default_size ( Int $width, Int $height )

=item Int $width; width in pixels, or -1 to unset the default width
=item Int $height; height in pixels, or -1 to unset the default height

=end pod

sub gtk_window_set_default_size ( N-GObject $window, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_get_default_size
=begin pod
=head2 [[gtk_] window_] get_default_size

Gets the default size of the window. A value of -1 for the width or
height indicates that a default size has not been explicitly set
for that dimension, so the “natural” size of the window will be
used.


  method gtk_window_get_default_size ( --> List )

Returns a List
=item Int $width: location to store the default width, or C<Any>
=item Int $height: location to store the default height, or C<Any>

=end pod

sub gtk_window_get_default_size ( N-GObject $window --> List ) {
  _gtk_window_get_default_size( $window, my int32 $w, my int32 $h);
  ( $w, $h)
}

sub _gtk_window_get_default_size (
  N-GObject $window, int32 $width is rw, int32 $height is rw
) is native(&gtk-lib)
  is symbol('gtk_window_get_default_size')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_resize
=begin pod
=head2 [gtk_] window_resize

Resizes the window as if the user had done so, obeying geometry constraints. The default geometry constraint is that windows may not be smaller than their size request; to override this constraint, call C<gtk_widget_set_size_request()> to set the window's request to a smaller value.

If C<gtk_window_resize()> is called before showing a window for the first time, it overrides any default size set with C<gtk_window_set_default_size()>.

Windows may not be resized smaller than 1 by 1 pixels.

When using client side decorations, GTK+ will do its best to adjust the given size so that the resulting window size matches the requested size without the title bar, borders and shadows added for the client side decorations, but there is no garantee that the result will be totally accurate because these widgets added for client side decorations depend on the theme and may not be realized or visible at the time C<gtk_window_resize()> is issued.

Typically, C<gtk_window_resize()> will compensate for the B<Gnome::Gtk3::HeaderBar> height only if it's known at the time the resulting B<Gnome::Gtk3::Window> configuration is issued. For example, if new widgets are added after the B<Gnome::Gtk3::Window> configuration and cause the B<Gnome::Gtk3::HeaderBar> to grow in height, this will result in a window content smaller that specified by C<gtk_window_resize()> and not a larger window.

  method gtk_window_resize ( Int $width, Int $height )

=item Int $width; width in pixels to resize the window to
=item Int $height; height in pixels to resize the window to

=end pod

sub gtk_window_resize ( N-GObject $window, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_get_size
=begin pod
=head2 [[gtk_] window_] get_size

Obtains the current size of I<window>.

If I<window> is not visible on screen, this function return the size GTK+ will suggest to the window manager for the initial window size (but this is not reliably the same as the size the window manager will actually select). See: C<gtk_window_set_default_size()>.

Depending on the windowing system and the window manager constraints, the size returned by this function may not match the size set using C<gtk_window_resize()>; additionally, since C<gtk_window_resize()> may be implemented as an asynchronous operation, GTK+ cannot guarantee in any way that this code:

  # width and height are set elsewhere
  $w.gtk_window_resize( $width, $height);
  ...
  my Int ( $new_width, $new_height) = $w.get_size();

will result in `new_width` and `new_height` matching `width` and `height`, respectively.

This function will return the logical size of the B<Gnome::Gtk3::Window>, excluding the widgets used in client side decorations; there is, however, no guarantee that the result will be completely accurate because client side decoration may include widgets that depend on the user preferences and that may not be visibile at the time you call this function.

The dimensions returned by this function are suitable for being stored across sessions; use C<gtk_window_set_default_size()> to restore them when before showing the window.

To avoid potential race conditions, you should only call this function in response to a size change notification, for instance inside a handler for the sig C<size-allocate> signal, or inside a handler for the sig C<configure-event> signal:

=begin comment
|[<!-- language="C" -->
static void
on_size_allocate (B<Gnome::Gtk3::Widget> *widget, B<Gnome::Gtk3::Allocation> *allocation)
{
int new_width, new_height;

gtk_window_get_size (GTK_WINDOW (widget), &new_width, &new_height);

...
}
]|

Note that, if you connect to the sig C<size-allocate> signal, you should not use the dimensions of the B<Gnome::Gtk3::Allocation> passed to the signal handler, as the allocation may contain client side decorations added by GTK+, depending on the windowing system in use.
=end comment

If you are getting a window size in order to position the window on the screen, you should, instead, simply set the window’s semantic type with C<gtk_window_set_type_hint()>, which allows the window manager to e.g. center dialogs. Also, if you set the transient parent of dialogs with C<gtk_window_set_transient_for()> window managers will often center the dialog over its parent window. It's much preferred to let the window manager handle these cases rather than doing it yourself, because all apps will behave consistently and according to user or system preferences, if the window manager handles it. Also, the window manager can take into account the size of the window decorations and border that it may add, and of which GTK+ has no knowledge. Additionally, positioning windows in global screen coordinates may not be allowed by the windowing system. For more information, see: C<gtk_window_set_position()>.

  method gtk_window_get_size ( --> List )

Returns a list ( Int $width, Int $height )
=item Int $width: return location for width, or C<Any>
=item Int $height: return location for height, or C<Any>

=end pod

sub gtk_window_get_size ( N-GObject $window --> List ) is inlinable {
  _gtk_window_get_size( $window, my int32 $w, my int32 $h);
  ( $w, $h)
}

sub _gtk_window_get_size (
  N-GObject $window, int32 $width is rw, int32 $height is rw
) is native(&gtk-lib)
  is symbol('gtk_window_get_size')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_move
=begin pod
=head2 [gtk_] window_move

Asks the window manager to move I<window> to the given position.  Window managers are free to ignore this; most window managers ignore requests for initial window positions (instead using a user-defined placement algorithm) and honor requests after the window has already been shown.

Note: the position is the position of the gravity-determined reference point for the window. The gravity determines two things: first, the location of the reference point in root window coordinates; and second, which point on the window is positioned at the reference point.

By default the gravity is C<GDK_GRAVITY_NORTH_WEST>, so the reference point is simply the I<x>, I<y> supplied to C<gtk_window_move()>. The top-left corner of the window decorations (aka window frame or border) will be placed at I<x>, I<y>.  Therefore, to position a window at the top left of the screen, you want to use the default gravity (which is C<GDK_GRAVITY_NORTH_WEST>) and move the window to 0,0.

To position a window at the bottom right corner of the screen, you would set C<GDK_GRAVITY_SOUTH_EAST>, which means that the reference point is at I<x> + the window width and I<y> + the window height, and the bottom-right corner of the window border will be placed at that reference point. So, to place a window in the bottom right corner you would first set gravity to south east, then write: `gtk_window_move (window, C<gdk_screen_width()> - window_width, C<gdk_screen_height()> - window_height)` (note that this example does not take multi-head scenarios into account).

The [Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec) has a nice table of gravities in the “implementation notes” section.

The C<gtk_window_get_position()> documentation may also be relevant.

  method gtk_window_move ( Int $x, Int $y )

=item Int $x; X coordinate to move window to
=item Int $y; Y coordinate to move window to

=end pod

sub gtk_window_move ( N-GObject $window, int32 $x, int32 $y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_window_get_position
=begin pod
=head2 [[gtk_] window_] get_position

This function returns the position you need to pass to C<gtk_window_move()> to keep I<window> in its current position. This means that the meaning of the returned value varies with window gravity. See C<gtk_window_move()> for more details.

The reliability of this function depends on the windowing system currently in use. Some windowing systems, such as Wayland, do not support a global coordinate system, and thus the position of the window will always be (0, 0). Others, like X11, do not have a reliable way to obtain the geometry of the decorations of a window if they are provided by the window manager. Additionally, on X11, window manager have been known to mismanage window gravity, which result in windows moving even if you use the coordinates of the current position as returned by this function.

If you haven’t changed the window gravity, its gravity will be C<GDK_GRAVITY_NORTH_WEST>. This means that C<gtk_window_get_position()> gets the position of the top-left corner of the window manager frame for the window. C<gtk_window_move()> sets the position of this same top-left corner.

If a window has gravity C<GDK_GRAVITY_STATIC> the window manager frame is not relevant, and thus C<gtk_window_get_position()> will always produce accurate results. However you can’t use static gravity to do things like place a window in a corner of the screen, because static gravity ignores the window manager decorations.

Ideally, this function should return appropriate values if the window has client side decorations, assuming that the windowing system supports global coordinates.

In practice, saving the window position should not be left to applications, as they lack enough knowledge of the windowing system and the window manager state to effectively do so. The appropriate way to implement saving the window position is to use a platform-specific protocol, wherever that is available.

  method gtk_window_get_position ( --> List )

The list returned is ( Int $root_x, Int $root_y )

=item Int $root_x: return location for X coordinate of gravity-determined reference point, or C<Any>
=item Int $root_y: return location for Y coordinate of gravity-determined reference point, or C<Any>

=end pod

sub gtk_window_get_position( N-GObject $window --> List ) is inlinable {
  _gtk_window_get_position( $window, my int32 $rx, my int32 $ry);
  ( $rx, $ry)
}

sub _gtk_window_get_position (
  N-GObject $window, int32 $root_x is rw, int32 $root_y is rw
) is native(&gtk-lib)
  is symbol('gtk_window_get_position')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_group

Returns the group for I<window> or the default group, if I<window> is C<Any> or if I<window> does not have an explicit window group.

Returns: (transfer none): the B<Gnome::Gtk3::WindowGroup> for a window or the default group

Since: 2.10

  method gtk_window_get_group ( --> N-GObject  )

=end pod

sub gtk_window_get_group ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] has_group

Returns whether I<window> has an explicit window group.

Returns: C<1> if I<window> has an explicit window group.

Since 2.22

  method gtk_window_has_group ( --> Int  )

=end pod

sub gtk_window_has_group ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_window_get_window_type
=begin pod
=head2 [[gtk_] window_] get_window_type

Gets the type of the window. See B<Gnome::Gtk3::WindowType>.

Returns: the type of the window

Since: 2.20

  method gtk_window_get_window_type ( --> GtkWindowType  )

=end pod

sub gtk_window_get_window_type ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] get_application

Gets the B<Gnome::Gtk3::Application> associated with the window (if any).

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::Application>, or C<Any>

Since: 3.0

  method gtk_window_get_application ( --> N-GObject  )

=end pod

sub gtk_window_get_application ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_application

Sets or unsets the B<Gnome::Gtk3::Application> associated with the window.

The application will be kept alive for at least as long as the window
is open.

Since: 3.0

  method gtk_window_set_application ( N-GObject $application )

=item N-GObject $application; (allow-none): a B<Gnome::Gtk3::Application>, or C<Any>

=end pod

sub gtk_window_set_application ( N-GObject $window, N-GObject $application )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] window_] set_titlebar

Sets a custom titlebar for I<window>.

If you set a custom titlebar, GTK+ will do its best to convince the window manager not to put its own titlebar on the window. Depending on the system, this function may not work for a window that is already visible, so you set the titlebar before calling C<gtk_widget_show()>.

Since: 3.10

  method gtk_window_set_titlebar ( N-GObject $titlebar )

=item N-GObject $titlebar; (allow-none): the widget to use as titlebar

=end pod

sub gtk_window_set_titlebar ( N-GObject $window, N-GObject $titlebar )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] get_titlebar

Returns the custom titlebar that has been set with
C<gtk_window_set_titlebar()>.

Returns: (nullable) (transfer none): the custom titlebar, or C<Any>

Since: 3.16

  method gtk_window_get_titlebar ( --> N-GObject  )


=end pod

sub gtk_window_get_titlebar ( N-GObject $window )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] window_] is_maximized

Retrieves the current maximized state of I<window>.

Note that since maximization is ultimately handled by the window manager and happens asynchronously to an application request, you shouldn’t assume the return value of this function changing immediately (or at all), as an effect of calling C<gtk_window_maximize()> or C<gtk_window_unmaximize()>.

Returns: whether the window has a maximized state.

Since: 3.12

  method gtk_window_is_maximized ( --> Int  )


=end pod

sub gtk_window_is_maximized ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_window_set_interactive_debugging
=begin pod
=head2 [[gtk_] window_] set_interactive_debugging

Opens or closes the [interactive debugger][interactive-debugging], which offers access to the widget hierarchy of the application and to useful debugging tools.

Since: 3.14

  method gtk_window_set_interactive_debugging ( Int $enable )

=item Int $enable; C<1> to enable interactive debugging

=end pod

sub gtk_window_set_interactive_debugging ( int32 $enable )
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

=comment #TS:0:activate-focus:
=head3 activate-focus

The I<activate-focus> signal is a [keybinding signal](https://developer.gnome.org/gtk3/3.24/gtk3-Bindings.html#GtkBindingSignal) which gets emitted when the user activates the currently focused widget of I<$window>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment #TS:0:activate-default:
=head3 activate-default

The I<activate-default> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>] which gets emitted when the user activates the default widget of I<$window>.

  meInt :$_handler_id,
    Gnome::GObject::Object :_widget(
    Gnome::GObject::Object :widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment #TS:0:keys-changed:
=head3 keys-changed

The I<keys-changed> signal gets emitted when the set of accelerators or mnemonics that are associated with I<$window> changes.
Int :$_handler_id,
    Gnome::GObject::Object :_widget(
  method handler (
    Gnome::GObject::Object :widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment #TS:1:enable-debugging:
=head3 enable-debugging

The I<enable-debugging> signal is a [keybinding signal](https://developer.gnome.org/gtk3/3.24/gtk3-Bindings.html#GtkBindingSignal) which gets emitted when the user enables or disables interactive debugging. When I<$toggle> is C<1>, interactive debugging is toggled on or off, when it is C<0>, the debugger will be pointed at the widget under the pointer.

The default bindings for this signal are Ctrl-Shift-I and Ctrl-Shift-D.

Return: C<1> if the key binding was handled
Int :$_handler_id,
    Gnome::GObject::Object :_widget(
  method handler (
    int32 $toggle,
    Gnome::GObject::Object :widget($window),
    *%user-options
    --> Int
  );

=item $window; the window on which the signal is emitted
=item $toggle; toggle the debugger


=comment #TS:0:set-focus:
=head3 set-focus

ThisInt :$_handler_id,
    Gnome::GObject::Object :_widget( currently focused widget in this window changes.

  method handler (
    N-GObject $widget,
    Gnome::GObject::Object :widget($window),
    *%user-options
    --> Int
  );

=item $window; the window on which the signal is emitted
=item $widget; the newly focused widget

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

=comment #TP:0:type:
=head3 Window Type

The type of the window
Default value: False


The B<Gnome::GObject::Value> type of property I<type> is C<G_TYPE_ENUM>.

=comment #TP:0:title:
=head3 Window Title

The title of the window
Default value: Any


The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment #TP:0:role:
=head3 Window Role

Unique identifier for the window to be used when restoring a session
Default value: Any


The B<Gnome::GObject::Value> type of property I<role> is C<G_TYPE_STRING>.

=comment #TP:0:startup-id:
=head3 Startup ID


The I<startup-id> is a write-only property for setting window's
startup notification identifier. See C<gtk_window_set_startup_id()>
for more details.
Since: 2.12

The B<Gnome::GObject::Value> type of property I<startup-id> is C<G_TYPE_STRING>.

=comment #TP:0:resizable:
=head3 Resizable

If TRUE, users can resize the window
Default value: True


The B<Gnome::GObject::Value> type of property I<resizable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:modal:
=head3 Modal

If TRUE, the window is modal (other windows are not usable while this one is up)
Default value: False


The B<Gnome::GObject::Value> type of property I<modal> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:window-position:
=head3 Window Position

The initial position of the window
Default value: False


The B<Gnome::GObject::Value> type of property I<window-position> is C<G_TYPE_ENUM>.

=comment #TP:0:default-width:
=head3 Default Width



The B<Gnome::GObject::Value> type of property I<default-width> is C<G_TYPE_INT>.

=comment #TP:0:default-height:
=head3 Default Height



The B<Gnome::GObject::Value> type of property I<default-height> is C<G_TYPE_INT>.

=comment #TP:0:destroy-with-parent:
=head3 Destroy with Parent

If this window should be destroyed when the parent is destroyed
Default value: False


The B<Gnome::GObject::Value> type of property I<destroy-with-parent> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:hide-titlebar-when-maximized:
=head3 Hide the titlebar during maximization


Whether the titlebar should be hidden during maximization.
Since: 3.4

The B<Gnome::GObject::Value> type of property I<hide-titlebar-when-maximized> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:icon:
=head3 Icon

Icon for this window
Widget type: GDK_TYPE_PIXBUF


The B<Gnome::GObject::Value> type of property I<icon> is C<G_TYPE_OBJECT>.

=comment #TP:0:mnemonics-visible:
=head3 Mnemonics Visible


Whether mnemonics are currently visible in this window.
This property is maintained by GTK+ based on user input,
and should not be set by applications.
Since: 2.20

The B<Gnome::GObject::Value> type of property I<mnemonics-visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:focus-visible:
=head3 Focus Visible


Whether 'focus rectangles' are currently visible in this window.
This property is maintained by GTK+ based on user input
and should not be set by applications.
Since: 2.20

The B<Gnome::GObject::Value> type of property I<focus-visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:icon-name:
=head3 Icon Name


The I<icon-name> property specifies the name of the themed icon to
use as the window icon. See B<Gnome::Gtk3::IconTheme> for more details.
Since: 2.6

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=begin comment
=comment #TP:0:screen:
=head3 Screen

The screen where this window will be displayed
Widget type: GDK_TYPE_SCREEN


The B<Gnome::GObject::Value> type of property I<screen> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:is-active:
=head3 Is Active

Whether the toplevel is the current active window
Default value: False


The B<Gnome::GObject::Value> type of property I<is-active> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:has-toplevel-focus:
=head3 Focus in Toplevel

Whether the input focus is within this B<Gnome::Gtk3::Window>
Default value: False


The B<Gnome::GObject::Value> type of property I<has-toplevel-focus> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:type-hint:
=head3 Type hint

Hint to help the desktop environment understand what kind of window this is and how to treat it.
Default value: False


The B<Gnome::GObject::Value> type of property I<type-hint> is C<G_TYPE_ENUM>.

=comment #TP:0:skip-taskbar-hint:
=head3 Skip taskbar

TRUE if the window should not be in the task bar.
Default value: False


The B<Gnome::GObject::Value> type of property I<skip-taskbar-hint> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:skip-pager-hint:
=head3 Skip pager

TRUE if the window should not be in the pager.
Default value: False


The B<Gnome::GObject::Value> type of property I<skip-pager-hint> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:urgency-hint:
=head3 Urgent

TRUE if the window should be brought to the user's attention.
Default value: False


The B<Gnome::GObject::Value> type of property I<urgency-hint> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:accept-focus:
=head3 Accept focus


Whether the window should receive the input focus.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<accept-focus> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:focus-on-map:
=head3 Focus on map


Whether the window should receive the input focus when mapped.
Since: 2.6

The B<Gnome::GObject::Value> type of property I<focus-on-map> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:decorated:
=head3 Decorated


Whether the window should be decorated by the window manager.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<decorated> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:deletable:
=head3 Deletable


Whether the window frame should have a close button.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<deletable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:gravity:
=head3 Gravity


The window gravity of the window. See C<gtk_window_move()> and B<Gnome::Gdk3::Gravity> for
more details about window gravity.
Since: 2.4
Widget type: GDK_TYPE_GRAVITY

The B<Gnome::GObject::Value> type of property I<gravity> is C<G_TYPE_ENUM>.


=begin comment
=comment #TP:0:transient-for:
=head3 Transient for Window


The transient parent of the window. See C<gtk_window_set_transient_for()> for
more details about transient windows.
Since: 2.10
Widget type: GTK_TYPE_WINDOW

The B<Gnome::GObject::Value> type of property I<transient-for> is C<G_TYPE_OBJECT>.
=end comment

=begin comment
=comment #TP:0:attached-to:
=head3 Attached to Widget


The widget to which this window is attached.
See C<gtk_window_set_attached_to()>.
Examples of places where specifying this relation is useful are
for instance a B<Gnome::Gtk3::Menu> created by a B<Gnome::Gtk3::ComboBox>, a completion
popup window created by B<Gnome::Gtk3::Entry> or a typeahead search entry
created by B<Gnome::Gtk3::TreeView>.
Since: 3.4
Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<attached-to> is C<G_TYPE_OBJECT>.
=end comment


=comment #TP:0:is-maximized:
=head3 Is maximized

Whether the window is maximized
Default value: False


The B<Gnome::GObject::Value> type of property I<is-maximized> is C<G_TYPE_BOOLEAN>.


=begin comment
=comment #TP:0:application:
=head3 GtkApplication


The B<Gnome::Gtk3::Application> associated with the window.
The application will be kept alive for at least as long as it
has any windows associated with it (see C<g_application_hold()>
for a way to keep it alive without windows).
Normally, the connection between the application and the window
will remain until the window is destroyed, but you can explicitly
remove it by setting the I<application> property to C<Any>.
Since: 3.0
Widget type: GTK_TYPE_APPLICATION

The B<Gnome::GObject::Value> type of property I<application> is C<G_TYPE_OBJECT>.
=end comment
=end pod
