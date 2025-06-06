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

  use Gnome::Gtk3::Window:api<1>;

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

  my Gnome::Gtk3::Window $w .= new;
  $w.set-title('My Button In My Window');
  my Gnome::Gtk3::Button $b .= new(:label('The Button'));
  $w.add($b);
  $w.show-all;

  my Gnome::Gtk3::Main $m .= new;
  $m.gtk-main;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Glib::Error:api<1>;
use Gnome::Glib::List:api<1>;

use Gnome::Gdk3::Window:api<1>;
use Gnome::Gdk3::Events:api<1>;
use Gnome::Gdk3::Types:api<1>;

use Gnome::Gtk3::Bin:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkwindow.h
# https://developer.gnome.org/gtk3/stable/GtkWindow.html
unit class Gnome::Gtk3::Window:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkWindowType

A B<Gnome::Gtk3::Window> can be one of these types. Most things you’d consider a “window” should have type C<GTK_WINDOW_TOPLEVEL>; windows with this type are managed by the window manager and have a frame by default (call C<gtk_window_set_decorated()> to toggle the frame).  Windows with type C<GTK_WINDOW_POPUP> are ignored by the window manager; window manager keybindings won’t work on them, the window manager won’t decorate the window with a frame, many GTK+ features that rely on the window manager will not work (e.g. resize grips and maximization/minimization). C<GTK_WINDOW_POPUP> is used to implement widgets such as B<Gnome::Gtk3::Menu> or tooltips that you normally don’t think of as windows per se. Nearly all windows should be C<GTK_WINDOW_TOPLEVEL>. In particular, do not use C<GTK_WINDOW_POPUP> just to turn off the window borders; use C<gtk_window_set_decorated()> for that.

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

=head3 default, no options

Creates a new B<Gnome::Gtk3::Window>, which is a toplevel window that can contain other widgets. The window type is set to C<GTK_WINDOW_TOPLEVEL>.

  multi method new ( )


=head3 :window-type

Nearly always, the type of the window should be C<GTK_WINDOW_TOPLEVEL> which is the default. If you’re implementing something like a popup menu from scratch (which is a bad idea, just use B<Gnome::Gtk3::Menu>), you might use C<GTK_WINDOW_POPUP>. C<GTK_WINDOW_POPUP> is not for dialogs, though in some other toolkits dialogs are called “popups”. In GTK+, C<GTK_WINDOW_POPUP> means a pop-up menu or pop-up tooltip. On X11, popup windows are not controlled by the window manager.

If you simply want an undecorated window (no window borders), use C<set-decorated()>, don’t use C<GTK_WINDOW_POPUP>.

All top-level windows created by C<new()> are stored in an internal top-level window list.  This list can be obtained from C<list-toplevels()>.
=comment Due to Gtk+ keeping a reference to the window internally, C<new()> does not return a reference to the caller.

To delete a B<Gnome::Gtk3::Window>, call C<destroy()>.

  multi method new ( GtkWindowType :$window-type! )

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

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<window-type> {
        $no = _gtk_window_new(%options<window-type>);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X:Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X:Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_window_new(GTK_WINDOW_TOPLEVEL);
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkWindow');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_window_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkWindow');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:activate-default:
=begin pod
=head2 activate-default

Activates the default widget for the window, unless the current focused widget has been configured to receive the default action (see C<Gnome::Gtk3::Widget.set-receives-default()>), in which case the focused widget is activated.

Returns: C<True> if a widget got activated.

  method activate-default ( --> Bool )

=end pod

method activate-default ( --> Bool ) {

  gtk_window_activate_default(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_activate_default (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:activate-focus:
=begin pod
=head2 activate-focus

Activates the current focused widget within the window.

Returns: C<True> if a widget got activated.

  method activate-focus ( --> Bool )

=end pod

method activate-focus ( --> Bool ) {

  gtk_window_activate_focus(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_activate_focus (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:activate-key:
=begin pod
=head2 activate-key

Activates mnemonics and accelerators for this B<Gnome::Gtk3::Window>. This is normally called by the default ::key-press-event handler for toplevel windows, however in some cases it may be useful to call this directly when overriding the standard key handling for a toplevel window.

Returns: C<True> if a mnemonic or accelerator was found and activated.

  method activate-key ( N-GdkEventKey $event --> Bool )

=item N-GdkEventKey $event; an EventKey structure
=end pod

method activate-key ( N-GdkEventKey $event --> Bool ) {
  gtk_window_activate_key( self._f('GtkWindow'), $event).Bool
}

sub gtk_window_activate_key (
  N-GObject $window, N-GdkEventKey $event --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-accel-group:
=begin pod
=head2 add-accel-group

Associate I<accel-group> with I<window>, such that calling C<gtk-accel-groups-activate()> on I<window> will activate accelerators in I<accel-group>.

  method add-accel-group ( N-GObject $accel_group )

=item N-GObject $accel_group; a B<Gnome::Gtk3::AccelGroup>
=end pod

method add-accel-group ( $accel_group is copy ) {
  $accel_group .= _get-native-object-no-reffing unless $accel_group ~~ N-GObject;
  gtk_window_add_accel_group( self._f('GtkWindow'), $accel_group);
}

sub gtk_window_add_accel_group (
  N-GObject $window, N-GObject $accel_group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-mnemonic:
=begin pod
=head2 add-mnemonic

Adds a mnemonic to this window.

  method add-mnemonic ( UInt $keyval, N-GObject $target )

=item UInt $keyval; the mnemonic
=item N-GObject $target; the widget that gets activated by the mnemonic
=end pod

method add-mnemonic ( UInt $keyval, $target is copy ) {
  $target .= _get-native-object-no-reffing unless $target ~~ N-GObject;

  gtk_window_add_mnemonic(
    self._f('GtkWindow'), $keyval
  );
}

sub gtk_window_add_mnemonic (
  N-GObject $window, guint $keyval, N-GObject $target
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:begin-move-drag:
=begin pod
=head2 begin-move-drag

Starts moving a window. This function is used if an application has window movement grips. When GDK can support it, the window movement will be done using the standard mechanism for the [window manager][gtk-X11-arch] or windowing system. Otherwise, GDK will try to emulate window movement, potentially not all that well, depending on the windowing system.

  method begin-move-drag ( Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item Int $button; mouse button that initiated the drag
=item Int $root_x; X position where the user clicked to initiate the drag, in root window coordinates
=item Int $root_y; Y position where the user clicked to initiate the drag
=item UInt $timestamp; timestamp from the click event that initiated the drag
=end pod

method begin-move-drag ( Int $button, Int $root_x, Int $root_y, UInt $timestamp ) {

  gtk_window_begin_move_drag(
    self._f('GtkWindow'), $button, $root_x, $root_y, $timestamp
  );
}

sub gtk_window_begin_move_drag (
  N-GObject $window, gint $button, gint $root_x, gint $root_y, guint32 $timestamp
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:begin-resize-drag:
=begin pod
=head2 begin-resize-drag

Starts resizing a window. This function is used if an application has window resizing controls. When GDK can support it, the resize will be done using the standard mechanism for the [window manager][gtk-X11-arch] or windowing system. Otherwise, GDK will try to emulate window resizing, potentially not all that well, depending on the windowing system.

  method begin-resize-drag ( GdkWindowEdge $edge, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

=item GdkWindowEdge $edge; mouse button that initiated the drag
=item Int $button; position of the resize control
=item Int $root_x; X position where the user clicked to initiate the drag, in root window coordinates
=item Int $root_y; Y position where the user clicked to initiate the drag
=item UInt $timestamp; timestamp from the click event that initiated the drag
=end pod

method begin-resize-drag ( GdkWindowEdge $edge, Int $button, Int $root_x, Int $root_y, UInt $timestamp ) {

  gtk_window_begin_resize_drag(
    self._f('GtkWindow'), $edge, $button, $root_x, $root_y, $timestamp
  );
}

sub gtk_window_begin_resize_drag (
  N-GObject $window, GEnum $edge, gint $button, gint $root_x, gint $root_y, guint32 $timestamp
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:close:
=begin pod
=head2 close

Requests that the window is closed, similar to what happens when a window manager close button is clicked.

This function can be used with close buttons in custom titlebars.

  method close ( )

=end pod

method close ( ) {

  gtk_window_close(
    self._f('GtkWindow'),
  );
}

sub gtk_window_close (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:deiconify:
=begin pod
=head2 deiconify

Asks to deiconify (i.e. unminimize) the specified I<window>. Note that you shouldn’t assume the window is definitely deiconified afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch])) could iconify it again before your code which assumes deiconification gets to run.

You can track iconification via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method deiconify ( )

=end pod

method deiconify ( ) {

  gtk_window_deiconify(
    self._f('GtkWindow'),
  );
}

sub gtk_window_deiconify (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:fullscreen:
=begin pod
=head2 fullscreen

Asks to place I<window> in the fullscreen state. Note that you shouldn’t assume the window is definitely full screen afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could unfullscreen it again, and not all window managers honor requests to fullscreen windows. But normally the window will end up fullscreen. Just don’t write code that crashes if not.

You can track the fullscreen state via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method fullscreen ( )

=end pod

method fullscreen ( ) {

  gtk_window_fullscreen(
    self._f('GtkWindow'),
  );
}

sub gtk_window_fullscreen (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:fullscreen-on-monitor:
=begin pod
=head2 fullscreen-on-monitor

Asks to place I<window> in the fullscreen state. Note that you shouldn't assume the window is definitely full screen afterward.

You can track the fullscreen state via the "window-state-event" signal on B<Gnome::Gtk3::Widget>.

  method fullscreen-on-monitor ( N-GObject $screen, Int $monitor )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen> to draw to
=item Int $monitor; which monitor to go fullscreen on
=end pod

method fullscreen-on-monitor ( $screen is copy, Int $monitor ) {
  $screen .= _get-native-object-no-reffing unless $screen ~~ N-GObject;

  gtk_window_fullscreen_on_monitor(
    self._f('GtkWindow'), $monitor
  );
}

sub gtk_window_fullscreen_on_monitor (
  N-GObject $window, N-GObject $screen, gint $monitor
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-accept-focus:
=begin pod
=head2 get-accept-focus

Gets the value set by C<set-accept-focus()>.

Returns: C<True> if window should receive the input focus

  method get-accept-focus ( --> Bool )

=end pod

method get-accept-focus ( --> Bool ) {

  gtk_window_get_accept_focus(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_accept_focus (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-application:
=begin pod
=head2 get-application

Gets the B<Gnome::Gtk3::Application> associated with the window (if any).

Returns: a B<Gnome::Gtk3::Application>, or C<undefined>

  method get-application ( --> N-GObject )

=end pod

method get-application ( --> N-GObject ) {

  gtk_window_get_application(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_application (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-attached-to:
=begin pod
=head2 get-attached-to

Fetches the attach widget for this window. See C<set-attached-to()>.

Returns: the widget where the window is attached, or C<undefined> if the window is not attached to any widget.

  method get-attached-to ( --> N-GObject )

=end pod

method get-attached-to ( --> N-GObject ) {

  gtk_window_get_attached_to(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_attached_to (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-decorated:
=begin pod
=head2 get-decorated

Returns whether the window has been set to have decorations such as a title bar via C<set-decorated()>.

Returns: C<True> if the window has been set to have decorations

  method get-decorated ( --> Bool )

=end pod

method get-decorated ( --> Bool ) {

  gtk_window_get_decorated(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_decorated (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-default-icon-list:
=begin pod
=head2 get-default-icon-list

Gets the value set by C<set-default-icon-list()>. The list is a copy and should be freed with C<g-list-free()>, but the pixbufs in the list have not had their reference count incremented.

Returns: (element-type GdkPixbuf) (transfer container): copy of default icon list

  method get-default-icon-list ( --> N-GList )

=end pod

method get-default-icon-list ( --> N-GList ) {

  gtk_window_get_default_icon_list(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_default_icon_list (
   --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-default-icon-name:
=begin pod
=head2 get-default-icon-name

Returns the fallback icon name for windows that has been set with C<set-default-icon-name()>. The returned string is owned by GTK+ and should not be modified. It is only valid until the next call to C<set-default-icon-name()>.

Returns: the fallback icon name for windows

  method get-default-icon-name ( --> Str )

=end pod

method get-default-icon-name ( --> Str ) {

  gtk_window_get_default_icon_name(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_default_icon_name (
   --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-default-size:
=begin pod
=head2 get-default-size

Gets the default size of the window. A value of -1 for the width or height indicates that a default size has not been explicitly set for that dimension, so the “natural” size of the window will be used.

  method get-default-size ( --> List )

The List returns;
=item Int width; location to store the default width, or C<undefined>
=item Int height; location to store the default height, or C<undefined>
=end pod

method get-default-size ( --> List ) {

  gtk_window_get_default_size(
    self._f('GtkWindow'), my gint $width, my gint $height
  );
  ( $width, $height)
}

sub gtk_window_get_default_size (
  N-GObject $window, gint $width is rw, gint $height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-default-widget:
=begin pod
=head2 get-default-widget

Returns the default widget for I<window>. See C<set-default()> for more details.

Returns: the default widget, or C<undefined> if there is none.

  method get-default-widget ( --> N-GObject )

=end pod

method get-default-widget ( --> N-GObject ) {

  gtk_window_get_default_widget(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_default_widget (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-deletable:
=begin pod
=head2 get-deletable

Returns whether the window has been set to have a close button via C<set-deletable()>.

Returns: C<True> if the window has been set to have a close button

  method get-deletable ( --> Bool )

=end pod

method get-deletable ( --> Bool ) {

  gtk_window_get_deletable(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_deletable (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-destroy-with-parent:
=begin pod
=head2 get-destroy-with-parent

Returns whether the window will be destroyed with its transient parent. See C<set-destroy-with-parent()>.

Returns: C<True> if the window will be destroyed with its transient parent.

  method get-destroy-with-parent ( --> Bool )

=end pod

method get-destroy-with-parent ( --> Bool ) {

  gtk_window_get_destroy_with_parent(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_destroy_with_parent (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-focus:
=begin pod
=head2 get-focus

Retrieves the current focused widget within the window. Note that this is the widget that would have the focus if the toplevel window focused; if the toplevel window is not focused then `gtk-widget-has-focus (widget)` will not be C<True> for the widget.

Returns: the currently focused widget, or C<undefined> if there is none.

  method get-focus ( --> N-GObject )

=end pod

method get-focus ( --> N-GObject ) {

  gtk_window_get_focus(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_focus (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-focus-on-map:
=begin pod
=head2 get-focus-on-map

Gets the value set by C<set-focus-on-map()>.

Returns: C<True> if window should receive the input focus when mapped.

  method get-focus-on-map ( --> Bool )

=end pod

method get-focus-on-map ( --> Bool ) {

  gtk_window_get_focus_on_map(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_focus_on_map (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-focus-visible:
=begin pod
=head2 get-focus-visible

Gets the value of the  I<focus-visible> property.

Returns: C<True> if “focus rectangles” are supposed to be visible in this window.

  method get-focus-visible ( --> Bool )

=end pod

method get-focus-visible ( --> Bool ) {

  gtk_window_get_focus_visible(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_focus_visible (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-gravity:
=begin pod
=head2 get-gravity

Gets the value set by C<set-gravity()>.

Returns: window gravity

  method get-gravity ( --> GdkGravity )

=end pod

method get-gravity ( --> GdkGravity ) {

  gtk_window_get_gravity(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_gravity (
  N-GObject $window --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-group:
=begin pod
=head2 get-group

Returns the group for I<window> or the default group, if I<window> is C<undefined> or if I<window> does not have an explicit window group.

Returns: the B<Gnome::Gtk3::WindowGroup> for a window or the default group

  method get-group ( --> N-GObject )

=end pod

method get-group ( --> N-GObject ) {

  gtk_window_get_group(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_group (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-hide-titlebar-when-maximized:
=begin pod
=head2 get-hide-titlebar-when-maximized

Returns whether the window has requested to have its titlebar hidden when maximized. See C<set-hide-titlebar-when-maximized()>.

Returns: C<True> if the window has requested to have its titlebar hidden when maximized

  method get-hide-titlebar-when-maximized ( --> Bool )

=end pod

method get-hide-titlebar-when-maximized ( --> Bool ) {

  gtk_window_get_hide_titlebar_when_maximized(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_hide_titlebar_when_maximized (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon:
=begin pod
=head2 get-icon

Gets the value set by C<set-icon()> (or if you've called C<set-icon-list()>, gets the first icon in the icon list).

Returns: icon for window or C<undefined> if none

  method get-icon ( --> N-GObject )

=end pod

method get-icon ( --> N-GObject ) {

  gtk_window_get_icon(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_icon (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-list:
=begin pod
=head2 get-icon-list

Retrieves the list of icons set by C<set-icon-list()>. The list is copied, but the reference count on each member won’t be incremented.

Returns: (element-type GdkPixbuf) (transfer container): copy of window’s icon list

  method get-icon-list ( --> N-GList )

=end pod

method get-icon-list ( --> N-GList ) {

  gtk_window_get_icon_list(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_icon_list (
  N-GObject $window --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-icon-name:
=begin pod
=head2 get-icon-name

Returns the name of the themed icon for the window, see C<set-icon-name()>.

Returns: the icon name or C<undefined> if the window has no themed icon

  method get-icon-name ( --> Str )

=end pod

method get-icon-name ( --> Str ) {

  gtk_window_get_icon_name(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_icon_name (
  N-GObject $window --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-mnemonic-modifier:
=begin pod
=head2 get-mnemonic-modifier

Returns the mnemonic modifier for this window. See C<set-mnemonic-modifier()>.

Returns: the modifier mask used to activate mnemonics on this window.

  method get-mnemonic-modifier ( --> GdkModifierType )

=end pod

method get-mnemonic-modifier ( --> GdkModifierType ) {

  GdkModifierType(
    gtk_window_get_mnemonic_modifier(self._f('GtkWindow'))
  )
}

sub gtk_window_get_mnemonic_modifier (
  N-GObject $window --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-mnemonics-visible:
=begin pod
=head2 get-mnemonics-visible

Gets the value of the  I<mnemonics-visible> property.

Returns: C<True> if mnemonics are supposed to be visible in this window.

  method get-mnemonics-visible ( --> Bool )

=end pod

method get-mnemonics-visible ( --> Bool ) {

  gtk_window_get_mnemonics_visible(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_mnemonics_visible (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-modal:
=begin pod
=head2 get-modal

Returns whether the window is modal. See C<set-modal()>.

Returns: C<True> if the window is set to be modal and establishes a grab when shown

  method get-modal ( --> Bool )

=end pod

method get-modal ( --> Bool ) {

  gtk_window_get_modal(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_modal (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-position:
=begin pod
=head2 get-position

This function returns the position you need to pass to C<move()> to keep I<window> in its current position. This means that the meaning of the returned value varies with window gravity. See C<move()> for more details.

The reliability of this function depends on the windowing system currently in use. Some windowing systems, such as Wayland, do not support a global coordinate system, and thus the position of the window will always be (0, 0). Others, like X11, do not have a reliable way to obtain the geometry of the decorations of a window if they are provided by the window manager. Additionally, on X11, window manager have been known to mismanage window gravity, which result in windows moving even if you use the coordinates of the current position as returned by this function.

If you haven’t changed the window gravity, its gravity will be C<GDK_GRAVITY_NORTH_WEST>. This means that C<get-position()> gets the position of the top-left corner of the window manager frame for the window. C<move()> sets the position of this same top-left corner.

If a window has gravity C<GDK_GRAVITY_STATIC> the window manager frame is not relevant, and thus C<get-position()> will always produce accurate results. However you can’t use static gravity to do things like place a window in a corner of the screen, because static gravity ignores the window manager decorations.

Ideally, this function should return appropriate values if the window has client side decorations, assuming that the windowing system supports global coordinates.

In practice, saving the window position should not be left to applications, as they lack enough knowledge of the windowing system and the window manager state to effectively do so. The appropriate way to implement saving the window position is to use a platform-specific protocol, wherever that is available.

  method get-position ( --> List )

The List returns;
=item Int root_x; return location for X coordinate of gravity-determined reference point, or C<undefined>
=item Int root_y; return location for Y coordinate of gravity-determined reference point, or C<undefined>
=end pod

method get-position ( --> List ) {
  gtk_window_get_position(
    self._f('GtkWindow'), my gint $root_x, my gint $root_y
  );

  ( $root_x, $root_y)
}

sub gtk_window_get_position (
  N-GObject $window, gint $root_x is rw, gint $root_y is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-resizable:
=begin pod
=head2 get-resizable

Gets the value set by C<set-resizable()>.

Returns: C<True> if the user can resize the window

  method get-resizable ( --> Bool )

=end pod

method get-resizable ( --> Bool ) {

  gtk_window_get_resizable(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_resizable (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-role:
=begin pod
=head2 get-role

Returns the role of the window. See C<set-role()> for further explanation.

Returns: the role of the window if set, or C<undefined>. The returned is owned by the widget and must not be modified or freed.

  method get-role ( --> Str )

=end pod

method get-role ( --> Str ) {

  gtk_window_get_role(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_role (
  N-GObject $window --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-screen:
=begin pod
=head2 get-screen

Returns the B<Gnome::Gdk3::Screen> associated with I<window>.

Returns: a B<Gnome::Gdk3::Screen>.

  method get-screen ( --> N-GObject )

=end pod

method get-screen ( --> N-GObject ) {

  gtk_window_get_screen(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_screen (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-size:
=begin pod
=head2 get-size

Obtains the current size of I<window>.

If I<window> is not visible on screen, this function return the size GTK+ will suggest to the [window manager][gtk-X11-arch] for the initial window size (but this is not reliably the same as the size the window manager will actually select). See: C<set-default-size()>.

Depending on the windowing system and the window manager constraints, the size returned by this function may not match the size set using C<resize()>; additionally, since C<resize()> may be implemented as an asynchronous operation, GTK+ cannot guarantee in any way that this code:

  # Width and height are set elsewhere with
  $window.resize( $width, $height);

  # And will result in `$new-width` and `$new-height` matching
  #`$width` and `$height`, respectively.
  my Int ( $new-width, $new-height) = $window.get-size;


This function will return the logical size of the B<Gnome::Gtk3::Window>, excluding the widgets used in client side decorations; there is, however, no guarantee that the result will be completely accurate because client side decoration may include widgets that depend on the user preferences and that may not be visibile at the time you call this function.

The dimensions returned by this function are suitable for being stored across sessions; use C<set-default-size()> to restore them when before showing the window.

To avoid potential race conditions, you should only call this function in response to a size change notification, for instance inside a handler for the C<size-allocate> signal, or inside a handler for the C<configure-event> signal (both defined in B<Gnome::Gtk3::Widget>):

=begin comment
  static void on-size-allocate( GtkWidget *widget, GtkAllocation *allocation) { int new-width, new-height;

    gtk-window-get-size( GTK-WINDOW (widget), &new-width, &new-height);
    …
  }
=end comment

Note that, if you connect to the B<Gnome::Gtk3::Widget>::size-allocate signal, you should not use the dimensions of the B<Gnome::Gtk3::Allocation> passed to the signal handler, as the allocation may contain client side decorations added by GTK+, depending on the windowing system in use.

If you are getting a window size in order to position the window on the screen, you should, instead, simply set the window’s semantic type with C<set-type-hint()>, which allows the window manager to e.g. center dialogs. Also, if you set the transient parent of dialogs with C<set-transient-for()> window managers will often center the dialog over its parent window. It's much preferred to let the window manager handle these cases rather than doing it yourself, because all apps will behave consistently and according to user or system preferences, if the window manager handles it. Also, the window manager can take into account the size of the window decorations and border that it may add, and of which GTK+ has no knowledge. Additionally, positioning windows in global screen coordinates may not be allowed by the windowing system. For more information, see: C<set-position()>.

  method get-size ( --> List )

=item Int $width; return location for width, or C<undefined>
=item Int $height; return location for height, or C<undefined>
=end pod

method get-size ( --> List ) {

  gtk_window_get_size(
    self._f('GtkWindow'), my gint $width, my gint $height
  );

  ( $width, $height)
}

sub gtk_window_get_size (
  N-GObject $window, gint $width is rw, gint $height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-skip-pager-hint:
=begin pod
=head2 get-skip-pager-hint

Gets the value set by C<set-skip-pager-hint()>.

Returns: C<True> if window shouldn’t be in pager

  method get-skip-pager-hint ( --> Bool )

=end pod

method get-skip-pager-hint ( --> Bool ) {

  gtk_window_get_skip_pager_hint(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_skip_pager_hint (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-skip-taskbar-hint:
=begin pod
=head2 get-skip-taskbar-hint

Gets the value set by C<set-skip-taskbar-hint()>

Returns: C<True> if window shouldn’t be in taskbar

  method get-skip-taskbar-hint ( --> Bool )

=end pod

method get-skip-taskbar-hint ( --> Bool ) {

  gtk_window_get_skip_taskbar_hint(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_skip_taskbar_hint (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-title:
=begin pod
=head2 get-title

Retrieves the title of the window. See C<set-title()>.

Returns: the title of the window, or C<undefined> if none has been set explicitly. The returned string is owned by the widget and must not be modified or freed.

  method get-title ( --> Str )

=end pod

method get-title ( --> Str ) {

  gtk_window_get_title(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_title (
  N-GObject $window --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-titlebar:
=begin pod
=head2 get-titlebar

Returns the custom titlebar that has been set with C<set-titlebar()>.

Returns: the custom titlebar, or C<undefined>

  method get-titlebar ( --> N-GObject )

=end pod

method get-titlebar ( --> N-GObject ) {

  gtk_window_get_titlebar(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_titlebar (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-transient-for:
=begin pod
=head2 get-transient-for

Fetches the transient parent for this window. See C<set-transient-for()>.

Returns: the transient parent for this window, or C<undefined> if no transient parent has been set.

  method get-transient-for ( --> N-GObject )

=end pod

method get-transient-for ( --> N-GObject ) {

  gtk_window_get_transient_for(
    self._f('GtkWindow'),
  )
}

sub gtk_window_get_transient_for (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-type-hint:
=begin pod
=head2 get-type-hint

Gets the type hint for this window. See C<set-type-hint()>.

Returns: the type hint for I<window>.

  method get-type-hint ( --> GdkWindowTypeHint )

=end pod

method get-type-hint ( --> GdkWindowTypeHint ) {

  GdkWindowTypeHint(
    gtk_window_get_type_hint(self._f('GtkWindow'))
  )
}

sub gtk_window_get_type_hint (
  N-GObject $window --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-urgency-hint:
=begin pod
=head2 get-urgency-hint

Gets the value set by C<set-urgency-hint()>

Returns: C<True> if window is urgent

  method get-urgency-hint ( --> Bool )

=end pod

method get-urgency-hint ( --> Bool ) {

  gtk_window_get_urgency_hint(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_get_urgency_hint (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-window-type:
=begin pod
=head2 get-window-type

Gets the type of the window.

Returns: the type of the window

  method get-window-type ( --> GtkWindowType )

=end pod

method get-window-type ( --> GtkWindowType ) {
  GtkWindowType(gtk_window_get_window_type(self._f('GtkWindow')))
}

sub gtk_window_get_window_type (
  N-GObject $window --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-group:
=begin pod
=head2 has-group

Returns whether I<window> has an explicit window group.

Returns: C<True> if I<window> has an explicit window group.

Since 2.22

  method has-group ( --> Bool )

=end pod

method has-group ( --> Bool ) {

  gtk_window_has_group(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_has_group (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-toplevel-focus:
=begin pod
=head2 has-toplevel-focus

Returns whether the input focus is within this GtkWindow. For real toplevel windows, this is identical to C<is-active()>, but for embedded windows, like B<Gnome::Gtk3::Plug>, the results will differ.

Returns: C<True> if the input focus is within this GtkWindow

  method has-toplevel-focus ( --> Bool )

=end pod

method has-toplevel-focus ( --> Bool ) {

  gtk_window_has_toplevel_focus(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_has_toplevel_focus (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:iconify:
=begin pod
=head2 iconify

Asks to iconify (i.e. minimize) the specified I<window>. Note that you shouldn’t assume the window is definitely iconified afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could deiconify it again, or there may not be a window manager in which case iconification isn’t possible, etc. But normally the window will end up iconified. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window, in which case the window will be iconified before it ever appears onscreen.

You can track iconification via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method iconify ( )

=end pod

method iconify ( ) {

  gtk_window_iconify(
    self._f('GtkWindow'),
  );
}

sub gtk_window_iconify (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-active:
=begin pod
=head2 is-active

Returns whether the window is part of the current active toplevel. (That is, the toplevel window receiving keystrokes.) The return value is C<True> if the window is active toplevel itself, but also if it is, say, a B<Gnome::Gtk3::Plug> embedded in the active toplevel. You might use this function if you wanted to draw a widget differently in an active window from a widget in an inactive window. See C<has-toplevel-focus()>

Returns: C<True> if the window part of the current active window.

  method is-active ( --> Bool )

=end pod

method is-active ( --> Bool ) {

  gtk_window_is_active(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_is_active (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-maximized:
=begin pod
=head2 is-maximized

Retrieves the current maximized state of I<window>.

Note that since maximization is ultimately handled by the window manager and happens asynchronously to an application request, you shouldn’t assume the return value of this function changing immediately (or at all), as an effect of calling C<maximize()> or C<unmaximize()>.

Returns: whether the window has a maximized state.

  method is-maximized ( --> Bool )

=end pod

method is-maximized ( --> Bool ) {

  gtk_window_is_maximized(
    self._f('GtkWindow'),
  ).Bool
}

sub gtk_window_is_maximized (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-toplevels:
=begin pod
=head2 list-toplevels

Returns a list of all existing toplevel windows. The widgets in the list are not individually referenced. If you want to iterate through the list and perform actions involving callbacks that might destroy the widgets, you must call `g-list-foreach (result, (GFunc)g-object-ref, NULL)` first, and then unref all the widgets afterwards.

Returns: (element-type GtkWidget) (transfer container): list of toplevel widgets

  method list-toplevels ( --> N-GList )

=end pod

method list-toplevels ( --> N-GList ) {

  gtk_window_list_toplevels(
    self._f('GtkWindow'),
  )
}

sub gtk_window_list_toplevels (
   --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:maximize:
=begin pod
=head2 maximize

Asks to maximize I<window>, so that it becomes full-screen. Note that you shouldn’t assume the window is definitely maximized afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could unmaximize it again, and not all window managers support maximization. But normally the window will end up maximized. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window, in which case the window will be maximized when it appears onscreen initially.

You can track maximization via the “window-state-event” signal on B<Gnome::Gtk3::Widget>, or by listening to notifications on the  I<is-maximized> property.

  method maximize ( )

=end pod

method maximize ( ) {

  gtk_window_maximize(
    self._f('GtkWindow'),
  );
}

sub gtk_window_maximize (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:mnemonic-activate:
=begin pod
=head2 mnemonic-activate

Activates the targets associated with the mnemonic.

Returns: C<True> if the activation is done.

  method mnemonic-activate ( UInt $keyval, GdkModifierType $modifier --> Bool )

=item UInt $keyval; the mnemonic
=item GdkModifierType $modifier; the modifiers
=end pod

method mnemonic-activate ( UInt $keyval, GdkModifierType $modifier --> Bool ) {

  gtk_window_mnemonic_activate(
    self._f('GtkWindow'), $keyval, $modifier
  ).Bool
}

sub gtk_window_mnemonic_activate (
  N-GObject $window, guint $keyval, GEnum $modifier --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:move:
=begin pod
=head2 move

Asks the [window manager][gtk-X11-arch] to move I<window> to the given position. Window managers are free to ignore this; most window managers ignore requests for initial window positions (instead using a user-defined placement algorithm) and honor requests after the window has already been shown.

Note: the position is the position of the gravity-determined reference point for the window. The gravity determines two things: first, the location of the reference point in root window coordinates; and second, which point on the window is positioned at the reference point.

By default the gravity is C<GDK_GRAVITY_NORTH_WEST>, so the reference point is simply the I<x>, I<y> supplied to C<move()>. The top-left corner of the window decorations (aka window frame or border) will be placed at I<x>, I<y>. Therefore, to position a window at the top left of the screen, you want to use the default gravity (which is C<GDK_GRAVITY_NORTH_WEST>) and move the window to 0,0.

To position a window at the bottom right corner of the screen, you would set C<GDK_GRAVITY_SOUTH_EAST>, which means that the reference point is at I<x> + the window width and I<y> + the window height, and the bottom-right corner of the window border will be placed at that reference point. So, to place a window in the bottom right corner you would first set gravity to south east, then write: `gtk-window-move (window, C<gdk-screen-width()> - window-width, C<gdk-screen-height()> - window-height)` (note that this example does not take multi-head scenarios into account).

The [Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec) has a nice table of gravities in the “implementation notes” section.

The C<get-position()> documentation may also be relevant.

  method move ( Int $x, Int $y )

=item Int $x; X coordinate to move window to
=item Int $y; Y coordinate to move window to
=end pod

method move ( Int $x, Int $y ) {

  gtk_window_move(
    self._f('GtkWindow'), $x, $y
  );
}

sub gtk_window_move (
  N-GObject $window, gint $x, gint $y
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:present:
=begin pod
=head2 present

Presents a window to the user. This function should not be used as when it is called, it is too late to gather a valid timestamp to allow focus stealing prevention to work correctly.

  method present ( )

=end pod

method present ( ) {

  gtk_window_present(
    self._f('GtkWindow'),
  );
}

sub gtk_window_present (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:present-with-time:
=begin pod
=head2 present-with-time

Presents a window to the user. This may mean raising the window in the stacking order, deiconifying it, moving it to the current desktop, and/or giving it the keyboard focus, possibly dependent on the user’s platform, window manager, and preferences.

If I<window> is hidden, this function calls C<Gnome::Gtk3::Widget.show()> as well.

This function should be used when the user tries to open a window that’s already open. Say for example the preferences dialog is currently open, and the user chooses Preferences from the menu a second time; use C<present()> to move the already-open dialog where the user can see it.

Presents a window to the user in response to a user interaction. The timestamp should be gathered when the window was requested to be shown (when clicking a link for example), rather than once the window is ready to be shown.

  method present-with-time ( UInt $timestamp )

=item UInt $timestamp; the timestamp of the user interaction (typically a  button or key press event) which triggered this call
=end pod

method present-with-time ( UInt $timestamp ) {

  gtk_window_present_with_time(
    self._f('GtkWindow'), $timestamp
  );
}

sub gtk_window_present_with_time (
  N-GObject $window, guint32 $timestamp
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:propagate-key-event:
=begin pod
=head2 propagate-key-event

Propagate a key press or release event to the focus widget and up the focus container chain until a widget handles I<event>. This is normally called by the default ::key-press-event and ::key-release-event handlers for toplevel windows, however in some cases it may be useful to call this directly when overriding the standard key handling for a toplevel window.

Returns: C<True> if a widget in the focus chain handled the event.

  method propagate-key-event ( N-GdkEventKey $event --> Bool )

=item N-GdkEventKey $event; an EventKey structure
=end pod

method propagate-key-event ( N-GdkEventKey $event --> Bool ) {
  gtk_window_propagate_key_event( self._f('GtkWindow'), $event).Bool
}

sub gtk_window_propagate_key_event (
  N-GObject $window, N-GdkEventKey $event --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-accel-group:
=begin pod
=head2 remove-accel-group

Reverses the effects of C<add-accel-group()>.

  method remove-accel-group ( N-GObject $accel_group )

=item N-GObject $accel_group; a B<Gnome::Gtk3::AccelGroup>
=end pod

method remove-accel-group ( $accel_group is copy ) {
  $accel_group .= _get-native-object-no-reffing unless $accel_group ~~ N-GObject;

  gtk_window_remove_accel_group(
    self._f('GtkWindow'),
  );
}

sub gtk_window_remove_accel_group (
  N-GObject $window, N-GObject $accel_group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-mnemonic:
=begin pod
=head2 remove-mnemonic

Removes a mnemonic from this window.

  method remove-mnemonic ( UInt $keyval, N-GObject $target )

=item UInt $keyval; the mnemonic
=item N-GObject $target; the widget that gets activated by the mnemonic
=end pod

method remove-mnemonic ( UInt $keyval, $target is copy ) {
  $target .= _get-native-object-no-reffing unless $target ~~ N-GObject;

  gtk_window_remove_mnemonic(
    self._f('GtkWindow'), $keyval
  );
}

sub gtk_window_remove_mnemonic (
  N-GObject $window, guint $keyval, N-GObject $target
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:resize:
=begin pod
=head2 resize

Resizes the window as if the user had done so, obeying geometry constraints. The default geometry constraint is that windows may not be smaller than their size request; to override this constraint, call C<Gnome::Gtk3::Widget.set-size-request()> to set the window's request to a smaller value.

If C<resize()> is called before showing a window for the first time, it overrides any default size set with C<set-default-size()>.

Windows may not be resized smaller than 1 by 1 pixels.

When using client side decorations, GTK+ will do its best to adjust the given size so that the resulting window size matches the requested size without the title bar, borders and shadows added for the client side decorations, but there is no guarantee that the result will be totally accurate because these widgets added for client side decorations depend on the theme and may not be realized or visible at the time C<resize()> is issued.

If the GtkWindow has a titlebar widget (see C<set-titlebar()>), then typically, C<resize()> will compensate for the height of the titlebar widget only if the height is known when the resulting GtkWindow configuration is issued. For example, if new widgets are added after the GtkWindow configuration and cause the titlebar widget to grow in height, this will result in a window content smaller that specified by C<resize()> and not a larger window.

  method resize ( Int $width, Int $height )

=item Int $width; width in pixels to resize the window to
=item Int $height; height in pixels to resize the window to
=end pod

method resize ( Int $width, Int $height ) {

  gtk_window_resize(
    self._f('GtkWindow'), $width, $height
  );
}

sub gtk_window_resize (
  N-GObject $window, gint $width, gint $height
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-accept-focus:
=begin pod
=head2 set-accept-focus

Windows may set a hint asking the desktop environment not to receive the input focus. This function sets this hint.

  method set-accept-focus ( Bool $setting )

=item Bool $setting; C<True> to let this window receive input focus
=end pod

method set-accept-focus ( Bool $setting ) {

  gtk_window_set_accept_focus(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_accept_focus (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-application:
=begin pod
=head2 set-application

Sets or unsets the B<Gnome::Gtk3::Application> associated with the window.

The application will be kept alive for at least as long as it has any windows associated with it (see C<g-application-hold()> for a way to keep it alive without windows).

Normally, the connection between the application and the window will remain until the window is destroyed, but you can explicitly remove it by setting the I<application> to C<undefined>.

This is equivalent to calling C<gtk-application-remove-window()> and/or C<gtk-application-add-window()> on the old/new applications as relevant.

  method set-application ( N-GObject $application )

=item N-GObject $application; a B<Gnome::Gtk3::Application>, or C<undefined> to unset
=end pod

method set-application ( $application is copy ) {
  $application .= _get-native-object-no-reffing unless $application ~~ N-GObject;

  gtk_window_set_application(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_application (
  N-GObject $window, N-GObject $application
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-attached-to:
=begin pod
=head2 set-attached-to

Marks I<window> as attached to I<attach-widget>. This creates a logical binding between the window and the widget it belongs to, which is used by GTK+ to propagate information such as styling or accessibility to I<window> as if it was a children of I<attach-widget>.

Examples of places where specifying this relation is useful are for instance a B<Gnome::Gtk3::Menu> created by a B<Gnome::Gtk3::ComboBox>, a completion popup window created by B<Gnome::Gtk3::Entry> or a typeahead search entry created by B<Gnome::Gtk3::TreeView>.

Note that this function should not be confused with C<set-transient-for()>, which specifies a window manager relation between two toplevels instead.

Passing C<undefined> for I<attach-widget> detaches the window.

  method set-attached-to ( N-GObject $attach_widget )

=item N-GObject $attach_widget; a B<Gnome::Gtk3::Widget>, or C<undefined>
=end pod

method set-attached-to ( $attach_widget is copy ) {
  $attach_widget .= _get-native-object-no-reffing unless $attach_widget ~~ N-GObject;

  gtk_window_set_attached_to(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_attached_to (
  N-GObject $window, N-GObject $attach_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-auto-startup-notification:
=begin pod
=head2 set-auto-startup-notification

By default, after showing the first B<Gnome::Gtk3::Window>, GTK+ calls C<gdk-notify-startup-complete()>. Call this function to disable the automatic startup notification. You might do this if your first window is a splash screen, and you want to delay notification until after your real main window has been shown, for example.

In that example, you would disable startup notification temporarily, show your splash screen, then re-enable it so that showing the main window would automatically result in notification.

  method set-auto-startup-notification ( Bool $setting )

=item Bool $setting; C<True> to automatically do startup notification
=end pod

method set-auto-startup-notification ( Bool $setting ) {

  gtk_window_set_auto_startup_notification(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_auto_startup_notification (
  gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-decorated:
=begin pod
=head2 set-decorated

By default, windows are decorated with a title bar, resize controls, etc. Some [window managers][gtk-X11-arch] allow GTK+ to disable these decorations, creating a borderless window. If you set the decorated property to C<False> using this function, GTK+ will do its best to convince the window manager not to decorate the window. Depending on the system, this function may not have any effect when called on a window that is already visible, so you should call it before calling C<Gnome::Gtk3::Widget.show()>.

On Windows, this function always works, since there’s no window manager policy involved.

  method set-decorated ( Bool $setting )

=item Bool $setting; C<True> to decorate the window
=end pod

method set-decorated ( Bool $setting ) {

  gtk_window_set_decorated(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_decorated (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default:
=begin pod
=head2 set-default

The default widget is the widget that’s activated when the user presses Enter in a dialog (for example). This function sets or unsets the default widget for a B<Gnome::Gtk3::Window>. When setting (rather than unsetting) the default widget it’s generally easier to call C<Gnome::Gtk3::Widget.grab-default()> on the widget. Before making a widget the default widget, you must call C<Gnome::Gtk3::Widget.set-can-default()> on the widget you’d like to make the default.

  method set-default ( N-GObject $default_widget )

=item N-GObject $default_widget; widget to be the default, or C<undefined> to unset the default widget for the toplevel
=end pod

method set-default ( $default_widget is copy ) {
  $default_widget .= _get-native-object-no-reffing
    unless $default_widget ~~ N-GObject;

  gtk_window_set_default(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_default (
  N-GObject $window, N-GObject $default_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default-icon:
=begin pod
=head2 set-default-icon

Sets an icon to be used as fallback for windows that haven't had C<set-icon()> called on them from a pixbuf.

  method set-default-icon ( N-GObject $icon )

=item N-GObject $icon; the icon
=end pod

method set-default-icon ( $icon is copy ) {
  $icon .= _get-native-object-no-reffing unless $icon ~~ N-GObject;

  gtk_window_set_default_icon(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_default_icon (
  N-GObject $icon
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default-icon-from-file:
=begin pod
=head2 set-default-icon-from-file

Sets an icon to be used as fallback for windows that haven't had C<set-icon-list()> called on them from a file on disk.
=comment Warns on failure if I<err> is C<undefined>.

Returns: a invalid error object if setting the icon succeeded. If it fails, the error must be checked for the reason.

  method set-default-icon-from-file ( Str $filename --> Gnome::Glib::Error )

=item Str $filename; location of icon file.
=end pod

method set-default-icon-from-file ( Str $filename --> Gnome::Glib::Error ) {
  my CArray[N-GError] $e .= new(N-GError);

  my Int $r = gtk_window_set_default_icon_from_file(
    self._f('GtkWindow'), $filename, $e
  );

  if $r {
    Gnome::Glib::Error.new(:native-object(N-GError))
  }

  else {
    Gnome::Glib::Error.new(:native-object($e[0]))
  }
}

sub gtk_window_set_default_icon_from_file (
  gchar-ptr $filename, CArray[N-GError] $err --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default-icon-list:
=begin pod
=head2 set-default-icon-list

Sets an icon list to be used as fallback for windows that haven't had C<set-icon-list()> called on them to set up a window-specific icon list. This function allows you to set up the icon for all windows in your app at once.

See C<set-icon-list()> for more details.

  method set-default-icon-list ( N-GList $list )

=item N-GList $list; a list of native B<Gnome::Gdk3::Pixbuf> objects
=end pod

method set-default-icon-list ( $list is copy ) {
  $list .= _get-native-object-no-reffing unless $list ~~ N-GList;

  gtk_window_set_default_icon_list(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_default_icon_list (
  N-GList $list
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-default-icon-name:
=begin pod
=head2 set-default-icon-name

Sets an icon to be used as fallback for windows that haven't had C<set-icon-list()> called on them from a named themed icon, see C<set-icon-name()>.

  method set-default-icon-name ( Str $name )

=item Str $name; the name of the themed icon
=end pod

method set-default-icon-name ( Str $name ) {

  gtk_window_set_default_icon_name(
    self._f('GtkWindow'), $name
  );
}

sub gtk_window_set_default_icon_name (
  gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-default-size:
=begin pod
=head2 set-default-size

Sets the default size of a window. If the window’s “natural” size (its size request) is larger than the default, the default will be ignored. More generally, if the default size does not obey the geometry hints for the window (C<set-geometry-hints()> can be used to set these explicitly), the default size will be clamped to the nearest permitted size.

Unlike C<Gnome::Gtk3::Widget.set-size-request()>, which sets a size request for a widget and thus would keep users from shrinking the window, this function only sets the initial size, just as if the user had resized the window themselves. Users can still shrink the window again as they normally would. Setting a default size of -1 means to use the “natural” default size (the size request of the window).

For more control over a window’s initial size and how resizing works, investigate C<set-geometry-hints()>.

For some uses, C<resize()> is a more appropriate function. C<resize()> changes the current size of the window, rather than the size to be used on initial display. C<resize()> always affects the window itself, not the geometry widget.

The default size of a window only affects the first time a window is shown; if a window is hidden and re-shown, it will remember the size it had prior to hiding, rather than using the default size.

Windows can’t actually be 0x0 in size, they must be at least 1x1, but passing 0 for I<width> and I<height> is OK, resulting in a 1x1 default size.

If you use this function to reestablish a previously saved window size, note that the appropriate size to save is the one returned by C<get-size()>. Using the window allocation directly will not work in all circumstances and can lead to growing or shrinking windows.

  method set-default-size ( Int $width, Int $height )

=item Int $width; width in pixels, or -1 to unset the default width
=item Int $height; height in pixels, or -1 to unset the default height
=end pod

method set-default-size ( Int $width, Int $height ) {

  gtk_window_set_default_size(
    self._f('GtkWindow'), $width, $height
  );
}

sub gtk_window_set_default_size (
  N-GObject $window, gint $width, gint $height
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-deletable:
=begin pod
=head2 set-deletable

By default, windows have a close button in the window frame. Some [window managers][gtk-X11-arch] allow GTK+ to disable this button. If you set the deletable property to C<False> using this function, GTK+ will do its best to convince the window manager not to show a close button. Depending on the system, this function may not have any effect when called on a window that is already visible, so you should call it before calling C<Gnome::Gtk3::Widget.show()>.

On Windows, this function always works, since there’s no window manager policy involved.

  method set-deletable ( Bool $setting )

=item Bool $setting; C<True> to decorate the window as deletable
=end pod

method set-deletable ( Bool $setting ) {

  gtk_window_set_deletable(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_deletable (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-destroy-with-parent:
=begin pod
=head2 set-destroy-with-parent

If I<setting> is C<True>, then destroying the transient parent of I<window> will also destroy I<window> itself. This is useful for dialogs that shouldn’t persist beyond the lifetime of the main window they're associated with, for example.

  method set-destroy-with-parent ( Bool $setting )

=item Bool $setting; whether to destroy I<window> with its transient parent
=end pod

method set-destroy-with-parent ( Bool $setting ) {

  gtk_window_set_destroy_with_parent(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_destroy_with_parent (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-focus:
=begin pod
=head2 set-focus

If I<focus> is not the current focus widget, and is focusable, sets it as the focus widget for the window. If I<focus> is C<undefined>, unsets the focus widget for this window. To set the focus to a particular widget in the toplevel, it is usually more convenient to use C<Gnome::Gtk3::Widget.grab-focus()> instead of this function.

  method set-focus ( N-GObject $focus )

=item N-GObject $focus; widget to be the new focus widget, or C<undefined> to unset any focus widget for the toplevel window.
=end pod

method set-focus ( $focus is copy ) {
  $focus .= _get-native-object-no-reffing unless $focus ~~ N-GObject;

  gtk_window_set_focus(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_focus (
  N-GObject $window, N-GObject $focus
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-focus-on-map:
=begin pod
=head2 set-focus-on-map

Windows may set a hint asking the desktop environment not to receive the input focus when the window is mapped. This function sets this hint.

  method set-focus-on-map ( Bool $setting )

=item Bool $setting; C<True> to let this window receive input focus on map
=end pod

method set-focus-on-map ( Bool $setting ) {

  gtk_window_set_focus_on_map(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_focus_on_map (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-focus-visible:
=begin pod
=head2 set-focus-visible

Sets the  I<focus-visible> property.

  method set-focus-visible ( Bool $setting )

=item Bool $setting; the new value
=end pod

method set-focus-visible ( Bool $setting ) {

  gtk_window_set_focus_visible(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_focus_visible (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-geometry-hints:
=begin pod
=head2 set-geometry-hints

This function sets up hints about how a window can be resized by the user. You can set a minimum and maximum size; allowed resize increments (e.g. for xterm, you can only resize by the size of a character); aspect ratios; and more. See the B<Gnome::Gtk3::Geometry> struct.

  method set-geometry-hints (
    N-GObject $geometry_widget, N-GdkGeometry $geometry,
    GdkWindowHints $geom_mask
  )

=item N-GObject $geometry_widget; widget the geometry hints used to be applied to or C<undefined>. Since 3.20 this argument is ignored and GTK behaves as if C<undefined> was set.
=item N-GdkGeometry $geometry; struct containing geometry information or C<undefined>
=item GdkWindowHints $geom_mask; mask indicating which struct fields should be paid attention to
=end pod

method set-geometry-hints ( $geometry_widget is copy, N-GdkGeometry $geometry, GdkWindowHints $geom_mask ) {
  $geometry_widget .= _get-native-object-no-reffing unless $geometry_widget ~~ N-GObject;

  gtk_window_set_geometry_hints(
    self._f('GtkWindow'), $geometry, $geom_mask
  );
}

sub gtk_window_set_geometry_hints (
  N-GObject $window, N-GObject $geometry_widget, N-GdkGeometry $geometry, GEnum $geom_mask
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-gravity:
=begin pod
=head2 set-gravity

Window gravity defines the meaning of coordinates passed to C<move()>. See C<move()> and B<Gnome::Gtk3::Gravity> for more details.

The default window gravity is C<GDK_GRAVITY_NORTH_WEST> which will typically “do what you mean.”

  method set-gravity ( GdkGravity $gravity )

=item GdkGravity $gravity; window gravity
=end pod

method set-gravity ( GdkGravity $gravity ) {

  gtk_window_set_gravity(
    self._f('GtkWindow'), $gravity
  );
}

sub gtk_window_set_gravity (
  N-GObject $window, GEnum $gravity
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-has-user-ref-count:
=begin pod
=head2 set-has-user-ref-count

Tells GTK+ whether to drop its extra reference to the window when C<Gnome::Gtk3::Widget.destroy()> is called.

This function is only exported for the benefit of language bindings which may need to keep the window alive until their wrapper object is garbage collected. There is no justification for ever calling this function in an application.

  method set-has-user-ref-count ( Bool $setting )

=item Bool $setting; the new value
=end pod

method set-has-user-ref-count ( Bool $setting ) {

  gtk_window_set_has_user_ref_count(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_has_user_ref_count (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-hide-titlebar-when-maximized:
=begin pod
=head2 set-hide-titlebar-when-maximized

If I<setting> is C<True>, then I<window> will request that it’s titlebar should be hidden when maximized. This is useful for windows that don’t convey any information other than the application name in the titlebar, to put the available screen space to better use. If the underlying window system does not support the request, the setting will not have any effect.

Note that custom titlebars set with C<set-titlebar()> are not affected by this. The application is in full control of their content and visibility anyway.

  method set-hide-titlebar-when-maximized ( Bool $setting )

=item Bool $setting; whether to hide the titlebar when I<window> is maximized
=end pod

method set-hide-titlebar-when-maximized ( Bool $setting ) {

  gtk_window_set_hide_titlebar_when_maximized(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_hide_titlebar_when_maximized (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon:
=begin pod
=head2 set-icon

Sets up the icon representing a B<Gnome::Gtk3::Window>. This icon is used when the window is minimized (also known as iconified). Some window managers or desktop environments may also place it in the window frame, or display it in other contexts. On others, the icon is not used at all, so your mileage may vary.

The icon should be provided in whatever size it was naturally drawn; that is, don’t scale the image before passing it to GTK+. Scaling is postponed until the last minute, when the desired final size is known, to allow best quality.

If you have your icon hand-drawn in multiple sizes, use C<set-icon-list()>. Then the best size will be used.

This function is equivalent to calling C<set-icon-list()> with a 1-element list.

See also C<set-default-icon-list()> to set the icon for all windows in your application in one go.

  method set-icon ( N-GObject $icon )

=item N-GObject $icon; icon image, or C<undefined>
=end pod

method set-icon ( $icon is copy ) {
  $icon .= _get-native-object-no-reffing unless $icon ~~ N-GObject;

  gtk_window_set_icon(
    self._f('GtkWindow'), $icon
  );
}

sub gtk_window_set_icon (
  N-GObject $window, N-GObject $icon
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-from-file:
=begin pod
=head2 set-icon-from-file

Sets the icon for I<window>.
=comment Warns on failure if I<err> is C<undefined>.

This function is equivalent to calling C<set-icon()> with a pixbuf created by loading the image from I<filename>.

Returns: an invalid error object if setting the icon succeeded.

  method set-icon-from-file ( Str $filename --> Gnome::Glib::Error )

=item Str $filename; location of icon file
=end pod

method set-icon-from-file ( Str $filename --> Gnome::Glib::Error ) {
  my CArray[N-GError] $e .= new(N-GError);

  my Int $r = gtk_window_set_icon_from_file(
    self._f('GtkWindow'), $filename, $e
  );

  if $r {
    Gnome::Glib::Error.new(:native-object(N-GError))
  }

  else {
    Gnome::Glib::Error.new(:native-object($e[0]))
  }
}

sub gtk_window_set_icon_from_file (
  N-GObject $window, gchar-ptr $filename, CArray[N-GError] $err --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-list:
=begin pod
=head2 set-icon-list

Sets up the icon representing a B<Gnome::Gtk3::Window>. The icon is used when the window is minimized (also known as iconified). Some window managers or desktop environments may also place it in the window frame, or display it in other contexts. On others, the icon is not used at all, so your mileage may vary.

C<set-icon-list()> allows you to pass in the same icon in several hand-drawn sizes. The list should contain the natural sizes your icon is available in; that is, don’t scale the image before passing it to GTK+. Scaling is postponed until the last minute, when the desired final size is known, to allow best quality.

By passing several sizes, you may improve the final image quality of the icon, by reducing or eliminating automatic image scaling.

Recommended sizes to provide: 16x16, 32x32, 48x48 at minimum, and larger images (64x64, 128x128) if you have them.

See also C<set-default-icon-list()> to set the icon for all windows in your application in one go.

Note that transient windows (those who have been set transient for another window using C<set-transient-for()>) will inherit their icon from their transient parent. So there’s no need to explicitly set the icon on transient windows.

  method set-icon-list ( N-GList $list )

=item N-GList $list; list of native B<Gnome::Gdk3::Pixbuf> objects
=end pod

method set-icon-list ( $list is copy ) {
  $list .= _get-native-object-no-reffing unless $list ~~ N-GList;

  gtk_window_set_icon_list(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_icon_list (
  N-GObject $window, N-GList $list
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-icon-name:
=begin pod
=head2 set-icon-name

Sets the icon for the window from a named themed icon. See the docs for B<Gnome::Gtk3::IconTheme> for more details. On some platforms, the window icon is not used at all.

Note that this has nothing to do with the WM-ICON-NAME property which is mentioned in the ICCCM.

  method set-icon-name ( Str $name )

=item Str $name; the name of the themed icon
=end pod

method set-icon-name ( Str $name ) {

  gtk_window_set_icon_name(
    self._f('GtkWindow'), $name
  );
}

sub gtk_window_set_icon_name (
  N-GObject $window, gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-interactive-debugging:
=begin pod
=head2 set-interactive-debugging

Opens or closes the [interactive debugger][interactive-debugging], which offers access to the widget hierarchy of the application and to useful debugging tools.

  method set-interactive-debugging ( Bool $enable )

=item Bool $enable; C<True> to enable interactive debugging
=end pod

method set-interactive-debugging ( Bool $enable ) {

  gtk_window_set_interactive_debugging(
    self._f('GtkWindow'), $enable
  );
}

sub gtk_window_set_interactive_debugging (
  N-GObject $window, gboolean $enable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-keep-above:
=begin pod
=head2 set-keep-above

Asks to keep I<window> above, so that it stays on top. Note that you shouldn’t assume the window is definitely above afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could not keep it above, and not all window managers support keeping windows above. But normally the window will end kept above. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window, in which case the window will be kept above when it appears onscreen initially.

You can track the above state via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

Note that, according to the [Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec), the above state is mainly meant for user preferences and should not be used by applications e.g. for drawing attention to their dialogs.

  method set-keep-above ( Bool $setting )

=item Bool $setting; whether to keep I<window> above other windows
=end pod

method set-keep-above ( Bool $setting ) {

  gtk_window_set_keep_above(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_keep_above (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-keep-below:
=begin pod
=head2 set-keep-below

Asks to keep I<window> below, so that it stays in bottom. Note that you shouldn’t assume the window is definitely below afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could not keep it below, and not all window managers support putting windows below. But normally the window will be kept below. Just don’t write code that crashes if not.

It’s permitted to call this function before showing a window, in which case the window will be kept below when it appears onscreen initially.

You can track the below state via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

Note that, according to the [Extended Window Manager Hints Specification](http://www.freedesktop.org/Standards/wm-spec), the above state is mainly meant for user preferences and should not be used by applications e.g. for drawing attention to their dialogs.

  method set-keep-below ( Bool $setting )

=item Bool $setting; whether to keep I<window> below other windows
=end pod

method set-keep-below ( Bool $setting ) {

  gtk_window_set_keep_below(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_keep_below (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-mnemonic-modifier:
=begin pod
=head2 set-mnemonic-modifier

Sets the mnemonic modifier for this window.

  method set-mnemonic-modifier ( GdkModifierType $modifier )

=item GdkModifierType $modifier; the modifier mask used to activate mnemonics on this window.
=end pod

method set-mnemonic-modifier ( GdkModifierType $modifier ) {

  gtk_window_set_mnemonic_modifier(
    self._f('GtkWindow'), $modifier
  );
}

sub gtk_window_set_mnemonic_modifier (
  N-GObject $window, GEnum $modifier
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-mnemonics-visible:
=begin pod
=head2 set-mnemonics-visible

Sets the  I<mnemonics-visible> property.

  method set-mnemonics-visible ( Bool $setting )

=item Bool $setting; the new value
=end pod

method set-mnemonics-visible ( Bool $setting ) {

  gtk_window_set_mnemonics_visible(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_mnemonics_visible (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-modal:
=begin pod
=head2 set-modal

Sets a window modal or non-modal. Modal windows prevent interaction with other windows in the same application. To keep modal dialogs on top of main application windows, use C<set-transient-for()> to make the dialog transient for the parent; most [window managers][gtk-X11-arch] will then disallow lowering the dialog below the parent.

  method set-modal ( Bool $modal )

=item Bool $modal; whether the window is modal
=end pod

method set-modal ( Bool $modal ) {
  gtk_window_set_modal( self._f('GtkWindow'), $modal);
}

sub gtk_window_set_modal (
  N-GObject $window, gboolean $modal
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-position:
=begin pod
=head2 set-position

Sets a position constraint for this window. If the old or new constraint is C<GTK-WIN-POS-CENTER-ALWAYS>, this will also cause the window to be repositioned to satisfy the new constraint.

  method set-position ( GtkWindowPosition $position )

=item GtkWindowPosition $position; a position constraint.
=end pod

method set-position ( GtkWindowPosition $position ) {
  gtk_window_set_position( self._f('GtkWindow'), $position);
}

sub gtk_window_set_position (
  N-GObject $window, GEnum $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-resizable:
=begin pod
=head2 set-resizable

Sets whether the user can resize a window. Windows are user resizable by default.

  method set-resizable ( Bool $resizable )

=item Bool $resizable; C<True> if the user can resize this window
=end pod

method set-resizable ( Bool $resizable ) {
  gtk_window_set_resizable( self._f('GtkWindow'), $resizable);
}

sub gtk_window_set_resizable (
  N-GObject $window, gboolean $resizable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-role:
=begin pod
=head2 set-role

This function is only useful on X11, not with other GTK+ targets.

In combination with the window title, the window role allows a [window manager][gtk-X11-arch] to identify "the same" window when an application is restarted. So for example you might set the “toolbox” role on your app’s toolbox window, so that when the user restarts their session, the window manager can put the toolbox back in the same place.

If a window already has a unique title, you don’t need to set the role, since the WM can use the title to identify the window when restoring the session.

  method set-role ( Str $role )

=item Str $role; unique identifier for the window to be used when restoring a session
=end pod

method set-role ( Str $role ) {

  gtk_window_set_role(
    self._f('GtkWindow'), $role
  );
}

sub gtk_window_set_role (
  N-GObject $window, gchar-ptr $role
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-screen:
=begin pod
=head2 set-screen

Sets the B<Gnome::Gdk3::Screen> where the I<window> is displayed; if the window is already mapped, it will be unmapped, and then remapped on the new screen.

  method set-screen ( N-GObject $screen )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>.
=end pod

method set-screen ( $screen is copy ) {
  $screen .= _get-native-object-no-reffing unless $screen ~~ N-GObject;

  gtk_window_set_screen(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_screen (
  N-GObject $window, N-GObject $screen
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-skip-pager-hint:
=begin pod
=head2 set-skip-pager-hint

Windows may set a hint asking the desktop environment not to display the window in the pager. This function sets this hint. (A "pager" is any desktop navigation tool such as a workspace switcher that displays a thumbnail representation of the windows on the screen.)

  method set-skip-pager-hint ( Bool $setting )

=item Bool $setting; C<True> to keep this window from appearing in the pager
=end pod

method set-skip-pager-hint ( Bool $setting ) {

  gtk_window_set_skip_pager_hint(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_skip_pager_hint (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-skip-taskbar-hint:
=begin pod
=head2 set-skip-taskbar-hint

Windows may set a hint asking the desktop environment not to display the window in the task bar. This function sets this hint.

  method set-skip-taskbar-hint ( Bool $setting )

=item Bool $setting; C<True> to keep this window from appearing in the task bar
=end pod

method set-skip-taskbar-hint ( Bool $setting ) {

  gtk_window_set_skip_taskbar_hint(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_skip_taskbar_hint (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-startup-id:
=begin pod
=head2 set-startup-id

Startup notification identifiers are used by desktop environment to track application startup, to provide user feedback and other features. This function changes the corresponding property on the underlying GdkWindow. Normally, startup identifier is managed automatically and you should only use this function in special cases like transferring focus from other processes. You should use this function before calling C<present()> or any equivalent function generating a window map event.

This function is only useful on X11, not with other GTK+ targets.

  method set-startup-id ( Str $startup_id )

=item Str $startup_id; a string with startup-notification identifier
=end pod

method set-startup-id ( Str $startup_id ) {

  gtk_window_set_startup_id(
    self._f('GtkWindow'), $startup_id
  );
}

sub gtk_window_set_startup_id (
  N-GObject $window, gchar-ptr $startup_id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-title:
=begin pod
=head2 set-title

Sets the title of the B<Gnome::Gtk3::Window>. The title of a window will be displayed in its title bar; on the X Window System, the title bar is rendered by the [window manager][gtk-X11-arch], so exactly how the title appears to users may vary according to a user’s exact configuration. The title should help a user distinguish this window from other windows they may have open. A good title might include the application name and current document filename, for example.

  method set-title ( Str $title )

=item Str $title; title of the window
=end pod

method set-title ( Str $title ) {

  gtk_window_set_title(
    self._f('GtkWindow'), $title
  );
}

sub gtk_window_set_title (
  N-GObject $window, gchar-ptr $title
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-titlebar:
=begin pod
=head2 set-titlebar

Sets a custom titlebar for I<window>.

A typical widget used here is B<Gnome::Gtk3::HeaderBar>, as it provides various features expected of a titlebar while allowing the addition of child widgets to it.

If you set a custom titlebar, GTK+ will do its best to convince the window manager not to put its own titlebar on the window. Depending on the system, this function may not work for a window that is already visible, so you set the titlebar before calling C<Gnome::Gtk3::Widget.show()>.

  method set-titlebar ( N-GObject $titlebar )

=item N-GObject $titlebar; the widget to use as titlebar
=end pod

method set-titlebar ( $titlebar is copy ) {
  $titlebar .= _get-native-object-no-reffing unless $titlebar ~~ N-GObject;

  gtk_window_set_titlebar(
    self._f('GtkWindow'),
  );
}

sub gtk_window_set_titlebar (
  N-GObject $window, N-GObject $titlebar
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-transient-for:
=begin pod
=head2 set-transient-for

Dialog windows should be set transient for the main application window they were spawned from. This allows [window managers][gtk-X11-arch] to e.g. keep the dialog on top of the main window, or center the dialog over the main window. C<gtk-dialog-new-with-buttons()> and other convenience functions in GTK+ will sometimes call C<set-transient-for()> on your behalf.

Passing C<undefined> for I<parent> unsets the current transient window.

On Wayland, this function can also be used to attach a new C<GTK_WINDOW_POPUP> to a C<GTK_WINDOW_TOPLEVEL> parent already mapped on screen so that the C<GTK_WINDOW_POPUP> will be created as a subsurface-based window C<GDK_WINDOW_SUBSURFACE> which can be positioned at will relatively to the C<GTK_WINDOW_TOPLEVEL> surface.

On Windows, this function puts the child window on top of the parent, much as the window manager would have done on X.

  method set-transient-for ( N-GObject $parent )

=item N-GObject $parent; parent window, or C<undefined>
=end pod

method set-transient-for ( $parent is copy ) {
  $parent .= _get-native-object-no-reffing unless $parent ~~ N-GObject;

  gtk_window_set_transient_for(
    self._f('GtkWindow'), $parent
  );
}

sub gtk_window_set_transient_for (
  N-GObject $window, N-GObject $parent
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-type-hint:
=begin pod
=head2 set-type-hint

By setting the type hint for the window, you allow the window manager to decorate and handle the window in a way which is suitable to the function of the window in your application.

This function should be called before the window becomes visible.

C<gtk-dialog-new-with-buttons()> and other convenience functions in GTK+ will sometimes call C<set-type-hint()> on your behalf.

  method set-type-hint ( GdkWindowTypeHint $hint )

=item GdkWindowTypeHint $hint; the window type
=end pod

method set-type-hint ( GdkWindowTypeHint $hint ) {

  gtk_window_set_type_hint(
    self._f('GtkWindow'), $hint
  );
}

sub gtk_window_set_type_hint (
  N-GObject $window, GEnum $hint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-urgency-hint:
=begin pod
=head2 set-urgency-hint

Windows may set a hint asking the desktop environment to draw the users attention to the window. This function sets this hint.

  method set-urgency-hint ( Bool $setting )

=item Bool $setting; C<True> to mark this window as urgent
=end pod

method set-urgency-hint ( Bool $setting ) {

  gtk_window_set_urgency_hint(
    self._f('GtkWindow'), $setting
  );
}

sub gtk_window_set_urgency_hint (
  N-GObject $window, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:stick:
=begin pod
=head2 stick

Asks to stick I<window>, which means that it will appear on all user desktops. Note that you shouldn’t assume the window is definitely stuck afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch] could unstick it again, and some window managers do not support sticking windows. But normally the window will end up stuck. Just don't write code that crashes if not.

It’s permitted to call this function before showing a window.

You can track stickiness via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method stick ( )

=end pod

method stick ( ) {

  gtk_window_stick(
    self._f('GtkWindow'),
  );
}

sub gtk_window_stick (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unfullscreen:
=begin pod
=head2 unfullscreen

Asks to toggle off the fullscreen state for I<window>. Note that you shouldn’t assume the window is definitely not full screen afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could fullscreen it again, and not all window managers honor requests to unfullscreen windows. But normally the window will end up restored to its normal state. Just don’t write code that crashes if not.

You can track the fullscreen state via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method unfullscreen ( )

=end pod

method unfullscreen ( ) {

  gtk_window_unfullscreen(
    self._f('GtkWindow'),
  );
}

sub gtk_window_unfullscreen (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unmaximize:
=begin pod
=head2 unmaximize

Asks to unmaximize I<window>. Note that you shouldn’t assume the window is definitely unmaximized afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could maximize it again, and not all window managers honor requests to unmaximize. But normally the window will end up unmaximized. Just don’t write code that crashes if not.

You can track maximization via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method unmaximize ( )

=end pod

method unmaximize ( ) {

  gtk_window_unmaximize(
    self._f('GtkWindow'),
  );
}

sub gtk_window_unmaximize (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unstick:
=begin pod
=head2 unstick

Asks to unstick I<window>, which means that it will appear on only one of the user’s desktops. Note that you shouldn’t assume the window is definitely unstuck afterward, because other entities (e.g. the user or [window manager][gtk-X11-arch]) could stick it again. But normally the window will end up stuck. Just don’t write code that crashes if not.

You can track stickiness via the “window-state-event” signal on B<Gnome::Gtk3::Widget>.

  method unstick ( )

=end pod

method unstick ( ) {

  gtk_window_unstick(
    self._f('GtkWindow'),
  );
}

sub gtk_window_unstick (
  N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_window_new:
#`{{
=begin pod
=head2 _gtk_window_new

Creates a new B<Gnome::Gtk3::Window>, which is a toplevel window that can contain other widgets. Nearly always, the type of the window should be C<GTK_WINDOW_TOPLEVEL>. If you’re implementing something like a popup menu from scratch (which is a bad idea, just use B<Gnome::Gtk3::Menu>), you might use C<GTK_WINDOW_POPUP>. C<GTK_WINDOW_POPUP> is not for dialogs, though in some other toolkits dialogs are called “popups”. In GTK+, C<GTK_WINDOW_POPUP> means a pop-up menu or pop-up tooltip. On X11, popup windows are not controlled by the [window manager][gtk-X11-arch].

If you simply want an undecorated window (no window borders), use C<set-decorated()>, don’t use C<GTK_WINDOW_POPUP>.

All top-level windows created by C<new()> are stored in an internal top-level window list. This list can be obtained from C<list-toplevels()>. Due to Gtk+ keeping a reference to the window internally, C<new()> does not return a reference to the caller.

To delete a B<Gnome::Gtk3::Window>, call C<Gnome::Gtk3::Widget.destroy()>.

Returns: a new B<Gnome::Gtk3::Window>.

  method _gtk_window_new ( GtkWindowType $type --> N-GObject )

=item GtkWindowType $type; type of window
=end pod
}}

sub _gtk_window_new ( GEnum $type --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_window_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:0:activate-default:
=head3 activate-default

The ::activate-default signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user activates the default widget
of I<window>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment -----------------------------------------------------------------------
=comment #TS:0:activate-focus:
=head3 activate-focus

The ::activate-focus signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user activates the currently
focused widget of I<window>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment -----------------------------------------------------------------------
=comment #TS:1:enable-debugging:
=head3 enable-debugging

The ::enable-debugging signal is a [keybinding signal][GtkBindingSignal]
which gets emitted when the user enables or disables interactive
debugging. When I<toggle> is C<True>, interactive debugging is toggled
on or off, when it is C<False>, the debugger will be pointed at the
widget under the pointer.

The default bindings for this signal are Ctrl-Shift-I
and Ctrl-Shift-D.

Return: C<True> if the key binding was handled

  method handler (
    Int $toggle,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
    --> Int
  );

=item $window; the window on which the signal is emitted

=item $toggle; toggle the debugger


=comment -----------------------------------------------------------------------
=comment #TS:0:keys-changed:
=head3 keys-changed

The ::keys-changed signal gets emitted when the set of accelerators
or mnemonics that are associated with I<window> changes.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
  );

=item $window; the window which received the signal


=comment -----------------------------------------------------------------------
=comment #TS:0:set-focus:
=head3 set-focus

This signal is emitted whenever the currently focused widget in
this window changes.


  method handler (
    N-GObject #`{ is widget } $widget,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($window),
    *%user-options
  );

=item $window; the window which received the signal

=item $widget; the newly focused widget (or C<undefined> for no focus)
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
=comment #TP:0:accept-focus:
=head3 Accept focus: accept-focus


Whether the window should receive the input focus.


The B<Gnome::GObject::Value> type of property I<accept-focus> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:application:
=head3 GtkApplication: application


The B<Gnome::Gtk3::Application> associated with the window.

The application will be kept alive for at least as long as it
has any windows associated with it (see C<g-application-hold()>
for a way to keep it alive without windows).

Normally, the connection between the application and the window
will remain until the window is destroyed, but you can explicitly
remove it by setting the I<application> property to C<undefined>.

   Widget type: GTK_TYPE_APPLICATION

The B<Gnome::GObject::Value> type of property I<application> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:attached-to:
=head3 Attached to Widget: attached-to


The widget to which this window is attached.
See C<set-attached-to()>.

Examples of places where specifying this relation is useful are
for instance a B<Gnome::Gtk3::Menu> created by a B<Gnome::Gtk3::ComboBox>, a completion
popup window created by B<Gnome::Gtk3::Entry> or a typeahead search entry
created by B<Gnome::Gtk3::TreeView>.

   Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<attached-to> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:decorated:
=head3 Decorated: decorated


Whether the window should be decorated by the window manager.


The B<Gnome::GObject::Value> type of property I<decorated> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:default-height:
=head3 Default Height: default-height


The B<Gnome::GObject::Value> type of property I<default-height> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:default-width:
=head3 Default Width: default-width


The B<Gnome::GObject::Value> type of property I<default-width> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:deletable:
=head3 Deletable: deletable


Whether the window frame should have a close button.


The B<Gnome::GObject::Value> type of property I<deletable> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:destroy-with-parent:
=head3 Destroy with Parent: destroy-with-parent

If this window should be destroyed when the parent is destroyed
Default value: False

The B<Gnome::GObject::Value> type of property I<destroy-with-parent> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:focus-on-map:
=head3 Focus on map: focus-on-map


Whether the window should receive the input focus when mapped.


The B<Gnome::GObject::Value> type of property I<focus-on-map> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:focus-visible:
=head3 Focus Visible: focus-visible


Whether 'focus rectangles' are currently visible in this window.

This property is maintained by GTK+ based on user input
and should not be set by applications.


The B<Gnome::GObject::Value> type of property I<focus-visible> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:gravity:
=head3 Gravity: gravity


The window gravity of the window. See C<move()> and B<Gnome::Gtk3::Gravity> for
more details about window gravity.

   Widget type: GDK_TYPE_GRAVITY

The B<Gnome::GObject::Value> type of property I<gravity> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:has-toplevel-focus:
=head3 Focus in Toplevel: has-toplevel-focus

Whether the input focus is within this GtkWindow
Default value: False

The B<Gnome::GObject::Value> type of property I<has-toplevel-focus> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:hide-titlebar-when-maximized:
=head3 Hide the titlebar during maximization: hide-titlebar-when-maximized


Whether the titlebar should be hidden during maximization.


The B<Gnome::GObject::Value> type of property I<hide-titlebar-when-maximized> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:icon:
=head3 Icon: icon

Icon for this window
Widget type: GDK-TYPE-PIXBUF

The B<Gnome::GObject::Value> type of property I<icon> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:icon-name:
=head3 Icon Name: icon-name


The I<icon-name> property specifies the name of the themed icon to
use as the window icon. See B<Gnome::Gtk3::IconTheme> for more details.


The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:is-active:
=head3 Is Active: is-active

Whether the toplevel is the current active window
Default value: False

The B<Gnome::GObject::Value> type of property I<is-active> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:is-maximized:
=head3 Is maximized: is-maximized

Whether the window is maximized
Default value: False

The B<Gnome::GObject::Value> type of property I<is-maximized> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:mnemonics-visible:
=head3 Mnemonics Visible: mnemonics-visible


Whether mnemonics are currently visible in this window.

This property is maintained by GTK+ based on user input,
and should not be set by applications.


The B<Gnome::GObject::Value> type of property I<mnemonics-visible> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:modal:
=head3 Modal: modal

If TRUE, the window is modal (other windows are not usable while this one is up)
Default value: False

The B<Gnome::GObject::Value> type of property I<modal> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:resizable:
=head3 Resizable: resizable

If TRUE, users can resize the window
Default value: True

The B<Gnome::GObject::Value> type of property I<resizable> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:role:
=head3 Window Role: role

Unique identifier for the window to be used when restoring a session
Default value: Any

The B<Gnome::GObject::Value> type of property I<role> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:screen:
=head3 Screen: screen

The screen where this window will be displayed
Widget type: GDK-TYPE-SCREEN

The B<Gnome::GObject::Value> type of property I<screen> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:skip-pager-hint:
=head3 Skip pager: skip-pager-hint

TRUE if the window should not be in the pager.
Default value: False

The B<Gnome::GObject::Value> type of property I<skip-pager-hint> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:skip-taskbar-hint:
=head3 Skip taskbar: skip-taskbar-hint

TRUE if the window should not be in the task bar.
Default value: False

The B<Gnome::GObject::Value> type of property I<skip-taskbar-hint> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:startup-id:
=head3 Startup ID: startup-id


The I<startup-id> is a write-only property for setting window's
startup notification identifier. See C<set-startup-id()>
for more details.


The B<Gnome::GObject::Value> type of property I<startup-id> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Window Title: title

The title of the window
Default value: Any

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:transient-for:
=head3 Transient for Window: transient-for


The transient parent of the window. See C<set-transient-for()> for
more details about transient windows.

   Widget type: GTK_TYPE_WINDOW

The B<Gnome::GObject::Value> type of property I<transient-for> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:type:
=head3 Window Type: type

The type of the window
Default value: False

The B<Gnome::GObject::Value> type of property I<type> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:type-hint:
=head3 Type hint: type-hint

Hint to help the desktop environment understand what kind of window this is and how to treat it.
Default value: False

The B<Gnome::GObject::Value> type of property I<type-hint> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:urgency-hint:
=head3 Urgent: urgency-hint

TRUE if the window should be brought to the user's attention.
Default value: False

The B<Gnome::GObject::Value> type of property I<urgency-hint> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:window-position:
=head3 Window Position: window-position

The initial position of the window
Default value: False

The B<Gnome::GObject::Value> type of property I<window-position> is C<G_TYPE_ENUM>.
=end pod
