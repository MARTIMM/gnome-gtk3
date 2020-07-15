#TL:1:Gnome::Gtk3::Application:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Application

Application class

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::Application> is a class that handles many important aspects of a GTK+ application in a convenient fashion, without enforcing a one-size-fits-all application model.

Currently, B<Gnome::Gtk3::Application> handles GTK+ initialization, application uniqueness, session management, provides some basic scriptability and desktop shell integration by exporting actions and menus and manages a list of toplevel windows whose life-cycle is automatically tied to the life-cycle of your application.

While B<Gnome::Gtk3::Application> works fine with plain B<Gnome::Gtk3::Windows>, it is recommended to use it together with B<Gnome::Gtk3::ApplicationWindow>.

When GDK threads are enabled, B<Gnome::Gtk3::Application> will acquire the GDK lock when invoking actions that arrive from other processes.  The GDK lock is not touched for local action invocations.  In order to have actions invoked in a predictable context it is therefore recommended that the GDK lock be held while invoking actions locally with C<g_action_group_activate_action()>.  The same applies to actions associated with B<Gnome::Gtk3::ApplicationWindow> and to the “activate” and “open” B<GApplication> methods.

=head2 Automatic resources

B<Gnome::Gtk3::Application> will automatically load menus from the B<Gnome::Gtk3::Builder> resource located at "gtk/menus.ui", relative to the application's resource base path (see C<g_application_set_resource_base_path()>).  The menu with the ID "app-menu" is taken as the application's app menu and the menu with the ID "menubar" is taken as the application's menubar.  Additional menus (most interesting submenus) can be named and accessed via C<gtk_application_get_menu_by_id()> which allows for dynamic population of a part of the menu structure.

If the resources "gtk/menus-appmenu.ui" or "gtk/menus-traditional.ui" are present then these files will be used in preference, depending on the value of C<gtk_application_prefers_app_menu()>. If the resource "gtk/menus-common.ui" is present it will be loaded as well. This is useful for storing items that are referenced from both "gtk/menus-appmenu.ui" and "gtk/menus-traditional.ui".

It is also possible to provide the menus manually using C<gtk_application_set_app_menu()> and C<gtk_application_set_menubar()>.

B<Gnome::Gtk3::Application> will also automatically setup an icon search path for the default icon theme by appending "icons" to the resource base path.  This allows your application to easily store its icons as resources.  See C<gtk_icon_theme_add_resource_path()> for more information.

If there is a resource located at "gtk/help-overlay.ui" which defines a B<Gnome::Gtk3::ShortcutsWindow> with ID "help_overlay" then B<Gnome::Gtk3::Application> associates an instance of this shortcuts window with each B<Gnome::Gtk3::ApplicationWindow> and sets up keyboard accelerators (Control-F1 and Control-?) to open it. To create a menu item that displays the shortcuts window, associate the item with the action win.show-help-overlay.

=head2 A simple application

[A simple example](https://git.gnome.org/browse/gtk+/tree/examples/bp/bloatpad.c)

B<Gnome::Gtk3::Application> optionally registers with a session manager of the users session (if you set the  I<register-session> property) and offers various functionality related to the session life-cycle.

An application can block various ways to end the session with the C<gtk_application_inhibit()> function. Typical use cases for this kind of inhibiting are long-running, uninterruptible operations, such as burning a CD or performing a disk backup. The session manager may not honor the inhibitor, but it can be expected to inform the user about the negative consequences of ending the session while inhibitors are present.

=head2 See Also

[HowDoI: Using B<Gnome::Gtk3::Application>](https://wiki.gnome.org/HowDoI/B<Gnome::Gtk3::Application>), [Getting Started with GTK+: Basics](https://developer.gnome.org/gtk3/stable/gtk-getting-started.htmlB<id>-1.2.3.3)


=head2 Implemented Interfaces

Gnome::Gtk3::Application implements
=item Gnome::Gio::ActionGroup
=item Gnome::Gio::ActionMap


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Application;
  also is Gnome::Gio::Application;
  also does Gnome::Gio::ActionMap;

=comment  also does Gnome::Gio::ActionGroup;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Application;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Application;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Application class process the options
    self.bless( :GtkApplication, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gio::Application;
use Gnome::Gio::MenuModel;
use Gnome::Gio::Enums;
use Gnome::Glib::List;
use Gnome::Glib::Error;
use Gnome::Glib::OptionContext;

use Gnome::Gio::ActionMap;
#use Gnome::Gio::ActionGroup;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Application:auth<github:MARTIMM>;
also is Gnome::Gio::Application;
also does Gnome::Gio::ActionMap;

#also does Gnome::Gio::ActionGroup;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new Application object.

  multi method new ( )

Create a Application object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a Application object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:app-id):
#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<window-added window-removed>, :w0<query-end>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  #return unless self.^name eq 'Gnome::Gtk3::Application';
  if self.^name eq 'Gnome::Gtk3::Application' or %options<GtkApplication> {

    # process all named arguments
    if self.is-valid { }

    elsif ? %options<app-id> {
      self.set-native-object(
        gtk_application_new(
          %options<app-id>, %options<flags> // G_APPLICATION_FLAGS_NONE
        )
      );
    }

    elsif ? %options<widget> || ? %options<native-object> ||
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
      self.set-native-object(gtk_application_new( '', G_APPLICATION_FLAGS_NONE));
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkApplication');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_application_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._action_map_interface($native-sub) unless ?$s;
#also does Gnome::Gio::ActionGroup;
#also does Gnome::Gio::ActionMap;

  self.set-class-name-of-sub('GtkApplication');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_application_new:new(:app-id)
=begin pod
=head2 gtk_application_new

Creates a new B<Gnome::Gtk3::Application> instance.

When using B<Gnome::Gtk3::Application>, it is not necessary to call C<gtk_init()> manually. It is called as soon as the application gets registered as the primary instance.

Concretely, C<gtk_init()> is called in the default handler for the  I<startup> signal. Therefore, B<Gnome::Gtk3::Application> subclasses should chain up in their  I<startup> handler before using any GTK+ API.

Note that commandline arguments are not passed to C<gtk_init()>. All GTK+ functionality that is available via commandline arguments can also be achieved by setting suitable environment variables such as `G_DEBUG`, so this should not be a big problem. If you absolutely must support GTK+ commandline arguments, you can explicitly call C<gtk_init()> before creating the application instance.

If non-C<Any>, the application ID must be valid.  See C<g_application_id_is_valid()>.

If no application ID is given then some features (most notably application uniqueness) will be disabled. A null application ID is only allowed with GTK+ 3.6 or later.

Returns: a new B<Gnome::Gtk3::Application> instance

  method gtk_application_new ( Str $application_id, GApplicationFlags $flags --> N-GObject )

=item Str $application_id; (allow-none): The application ID.
=item GApplicationFlags $flags; the application flags

=end pod

sub gtk_application_new ( Str $application_id, int32 $flags --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_add_window:
=begin pod
=head2 [gtk_application_] add_window

Adds a window to I<application>.

This call can only happen after the I<application> has started;
typically, you should add new application windows in response
to the emission of the  I<activate> signal.

This call is equivalent to setting the  I<application>
property of I<$window> to I<application>.

Normally, the connection between the application and the window
will remain until the window is destroyed, but you can explicitly
remove it with C<gtk_application_remove_window()>.

GTK+ will keep the I<application> running as long as it has
any windows.

  method gtk_application_add_window ( N-GObject $window )

=item N-GObject $window; a B<Gnome::Gtk3::Window>

=end pod

sub gtk_application_add_window ( N-GObject $application, N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_remove_window:
=begin pod
=head2 [gtk_application_] remove_window

Remove a window from I<application>.

If I<window> belongs to I<application> then this call is equivalent to
setting the  I<application> property of I<window> to
C<Any>.

The application may stop running as a result of a call to this
function.

  method gtk_application_remove_window ( N-GObject $window )

=item N-GObject $window; a B<Gnome::Gtk3::Window>

=end pod

sub gtk_application_remove_window ( N-GObject $application, N-GObject $window  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_windows:
=begin pod
=head2 [gtk_application_] get_windows

Gets a list of the B<Gnome::Gtk3::Windows> associated with I<application>.

The list is sorted by most recently focused window, such that the first
element is the currently focused window. (Useful for choosing a parent
for a transient window.)

The list that is returned should not be modified in any way. It will
only remain valid until the next focus change or window creation or
deletion.

Returns: (element-type B<Gnome::Gtk3::Window>) (transfer none): a B<GList> of B<Gnome::Gtk3::Window>

  method gtk_application_get_windows ( --> N-GList )


=end pod

sub gtk_application_get_windows ( N-GObject $application --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_app_menu:
=begin pod
=head2 [gtk_application_] get_app_menu

Returns the menu model that has been set with
C<gtk_application_set_app_menu()>.

Returns: (transfer none) (nullable): the application menu of I<application>
or C<Any> if no application menu has been set.

  method gtk_application_get_app_menu ( --> N-GObject )


=end pod

sub gtk_application_get_app_menu ( N-GObject $application --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_set_app_menu:
=begin pod
=head2 [gtk_application_] set_app_menu

Sets or unsets the application menu for I<application>.

This can only be done in the primary instance of the application,
after it has been registered.   I<startup> is a good place
to call this.

The application menu is a single menu containing items that typically
impact the application as a whole, rather than acting on a specific
window or document.  For example, you would expect to see
“Preferences” or “Quit” in an application menu, but not “Save” or
“Print”.

If supported, the application menu will be rendered by the desktop
environment.

Use the base B<GActionMap> interface to add actions, to respond to the user
selecting these menu items.

  method gtk_application_set_app_menu ( N-GObject $app_menu )

=item N-GObject $app_menu; (allow-none): a B<GMenuModel>, or C<Any>

=end pod

sub gtk_application_set_app_menu ( N-GObject $application, N-GObject $app_menu  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_menubar:
=begin pod
=head2 [gtk_application_] get_menubar

Returns the menu model that has been set with
C<gtk_application_set_menubar()>.

Returns: (transfer none): the menubar for windows of I<application>

  method gtk_application_get_menubar ( --> N-GObject )


=end pod

sub gtk_application_get_menubar ( N-GObject $application --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_set_menubar:
=begin pod
=head2 [gtk_application_] set_menubar

Sets or unsets the menubar for windows of I<application>.

This is a menubar in the traditional sense.

This can only be done in the primary instance of the application,
after it has been registered.   I<startup> is a good place
to call this.

Depending on the desktop environment, this may appear at the top of
each window, or at the top of the screen.  In some environments, if
both the application menu and the menubar are set, the application
menu will be presented as if it were the first item of the menubar.
Other environments treat the two as completely separate — for example,
the application menu may be rendered by the desktop shell while the
menubar (if set) remains in each individual window.

Use the base B<GActionMap> interface to add actions, to respond to the
user selecting these menu items.

  method gtk_application_set_menubar ( N-GObject $menubar )

=item N-GObject $menubar; (allow-none): a B<GMenuModel>, or C<Any>

=end pod

sub gtk_application_set_menubar ( N-GObject $application, N-GObject $menubar  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_application_inhibit:
=begin pod
=head2 gtk_application_inhibit

Inform the session manager that certain types of actions should be
inhibited. This is not guaranteed to work on all platforms and for
all types of actions.

Applications should invoke this method when they begin an operation
that should not be interrupted, such as creating a CD or DVD. The
types of actions that may be blocked are specified by the I<flags>
parameter. When the application completes the operation it should
call C<gtk_application_uninhibit()> to remove the inhibitor. Note that
an application can have multiple inhibitors, and all of them must
be individually removed. Inhibitors are also cleared when the
application exits.

Applications should not expect that they will always be able to block
the action. In most cases, users will be given the option to force
the action to take place.

Reasons should be short and to the point.

If I<window> is given, the session manager may point the user to
this window to find out more about why the action is inhibited.

Returns: A non-zero cookie that is used to uniquely identify this
request. It should be used as an argument to C<gtk_application_uninhibit()>
in order to remove the request. If the platform does not support
inhibiting or the request failed for some reason, 0 is returned.

  method gtk_application_inhibit ( N-GObject $window, GtkApplicationInhibitFlags $flags, Str $reason --> UInt )

=item N-GObject $window; (allow-none): a B<Gnome::Gtk3::Window>, or C<Any>
=item GtkApplicationInhibitFlags $flags; what types of actions should be inhibited
=item Str $reason; (allow-none): a short, human-readable string that explains why these operations are inhibited

=end pod

sub gtk_application_inhibit ( N-GObject $application, N-GObject $window, GtkApplicationInhibitFlags $flags, Str $reason --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_uninhibit:
=begin pod
=head2 gtk_application_uninhibit

Removes an inhibitor that has been established with C<gtk_application_inhibit()>.
Inhibitors are also cleared when the application exits.

  method gtk_application_uninhibit ( UInt $cookie )

=item UInt $cookie; a cookie that was returned by C<gtk_application_inhibit()>

=end pod

sub gtk_application_uninhibit ( N-GObject $application, uint32 $cookie  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_is_inhibited:
=begin pod
=head2 [gtk_application_] is_inhibited

Determines if any of the actions specified in I<flags> are
currently inhibited (possibly by another application).

Note that this information may not be available (for example
when the application is running in a sandbox).

Returns: C<1> if any of the actions specified in I<flags> are inhibited

  method gtk_application_is_inhibited ( GtkApplicationInhibitFlags $flags --> Int )

=item GtkApplicationInhibitFlags $flags; what types of actions should be queried

=end pod

sub gtk_application_is_inhibited ( N-GObject $application, GtkApplicationInhibitFlags $flags --> int32 )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_window_by_id:
=begin pod
=head2 [gtk_application_] get_window_by_id

Returns the B<Gnome::Gtk3::ApplicationWindow> with the given ID.

The ID of a B<Gnome::Gtk3::ApplicationWindow> can be retrieved with
C<gtk_application_window_get_id()>.

Returns: (nullable) (transfer none): the window with ID I<id>, or
C<Any> if there is no window with this ID

  method gtk_application_get_window_by_id ( UInt $id --> N-GObject )

=item UInt $id; an identifier number

=end pod

sub gtk_application_get_window_by_id ( N-GObject $application, uint32 $id --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_active_window:
=begin pod
=head2 [gtk_application_] get_active_window

Gets the “active” window for the application.

The active window is the one that was most recently focused (within
the application).  This window may not have the focus at the moment
if another application has it — this is just the most
recently-focused window within this application.

Returns: (transfer none) (nullable): the active window, or C<Any> if
there isn't one.

  method gtk_application_get_active_window ( --> N-GObject )


=end pod

sub gtk_application_get_active_window ( N-GObject $application --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_list_action_descriptions:
=begin pod
=head2 [gtk_application_] list_action_descriptions

Lists the detailed action names which have associated accelerators.
See C<gtk_application_set_accels_for_action()>.

Returns: (transfer full): a C<Any>-terminated array of strings,
free with C<g_strfreev()> when done

  method gtk_application_list_action_descriptions ( --> CArray[Str] )


=end pod

sub gtk_application_list_action_descriptions ( N-GObject $application --> CArray[Str] )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_accels_for_action:
=begin pod
=head2 [gtk_application_] get_accels_for_action

Gets the accelerators that are currently associated with
the given action.

Returns: (transfer full): accelerators for I<detailed_action_name>, as
a C<Any>-terminated array. Free with C<g_strfreev()> when no longer needed

  method gtk_application_get_accels_for_action ( Str $detailed_action_name --> CArray[Str] )

=item Str $detailed_action_name; a detailed action name, specifying an action and target to obtain accelerators for

=end pod

sub gtk_application_get_accels_for_action ( N-GObject $application, Str $detailed_action_name --> CArray[Str] )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_actions_for_accel:
=begin pod
=head2 [gtk_application_] get_actions_for_accel

Returns the list of actions (possibly empty) that I<accel> maps to.
Each item in the list is a detailed action name in the usual form.

This might be useful to discover if an accel already exists in
order to prevent installation of a conflicting accelerator (from
an accelerator editor or a plugin system, for example). Note that
having more than one action per accelerator may not be a bad thing
and might make sense in cases where the actions never appear in the
same context.

In case there are no actions for a given accelerator, an empty array
is returned.  C<Any> is never returned.

It is a programmer error to pass an invalid accelerator string.
If you are unsure, check it with C<gtk_accelerator_parse()> first.

Returns: (transfer full): a C<Any>-terminated array of actions for I<accel>

  method gtk_application_get_actions_for_accel ( Str $accel --> CArray[Str] )

=item Str $accel; an accelerator that can be parsed by C<gtk_accelerator_parse()>

=end pod

sub gtk_application_get_actions_for_accel ( N-GObject $application, Str $accel --> CArray[Str] )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_set_accels_for_action:
=begin pod
=head2 [gtk_application_] set_accels_for_action

Sets zero or more keyboard accelerators that will trigger the
given action. The first item in I<accels> will be the primary
accelerator, which may be displayed in the UI.

To remove all accelerators for an action, use an empty, zero-terminated
array for I<accels>.

For the I<detailed_action_name>, see C<g_action_parse_detailed_name()> and
C<g_action_print_detailed_name()>.

  method gtk_application_set_accels_for_action ( Str $detailed_action_name, CArray[Str] $accels )

=item Str $detailed_action_name; a detailed action name, specifying an action and target to associate accelerators with
=item CArray[Str] $accels; (array zero-terminated=1): a list of accelerators in the format understood by C<gtk_accelerator_parse()>

=end pod

sub gtk_application_set_accels_for_action ( N-GObject $application, Str $detailed_action_name, CArray[Str] $accels  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_prefers_app_menu:
=begin pod
=head2 [gtk_application_] prefers_app_menu

Determines if the desktop environment in which the application is
running would prefer an application menu be shown.

If this function returns C<1> then the application should call
C<gtk_application_set_app_menu()> with the contents of an application
menu, which will be shown by the desktop environment.  If it returns
C<0> then you should consider using an alternate approach, such as
a menubar.

The value returned by this function is purely advisory and you are
free to ignore it.  If you call C<gtk_application_set_app_menu()> even
if the desktop environment doesn't support app menus, then a fallback
will be provided.

Applications are similarly free not to set an app menu even if the
desktop environment wants to show one.  In that case, a fallback will
also be created by the desktop environment (GNOME, for example, uses
a menu with only a "Quit" item in it).

The value returned by this function never changes.  Once it returns a
particular value, it is guaranteed to always return the same value.

You may only call this function after the application has been
registered and after the base startup handler has run.  You're most
likely to want to use this from your own startup handler.  It may
also make sense to consult this function while constructing UI (in
activate, open or an action activation handler) in order to determine
if you should show a gear menu or not.

This function will return C<0> on Mac OS and a default app menu
will be created automatically with the "usual" contents of that menu
typical to most Mac OS applications.  If you call
C<gtk_application_set_app_menu()> anyway, then this menu will be
replaced with your own.

Returns: C<1> if you should set an app menu

  method gtk_application_prefers_app_menu ( --> Int )


=end pod

sub gtk_application_prefers_app_menu ( N-GObject $application --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_get_menu_by_id:
=begin pod
=head2 [gtk_application_] get_menu_by_id

Gets a menu from automatically loaded resources.
See [Automatic resources][automatic-resources]
for more information.

Returns: (transfer none): Gets the menu with the
given id from the automatically loaded resources

  method gtk_application_get_menu_by_id ( Str $id --> N-GObject )

=item Str $id; the id of the menu to look up

=end pod

sub gtk_application_get_menu_by_id ( N-GObject $application, Str $id --> N-GObject )
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


=comment #TS:0:window-added:
=head3 window-added

Emitted when a B<Gnome::Gtk3::Window> is added to I<application> through
C<gtk_application_add_window()>.

  method handler (
    Unknown type GTK_TYPE_WINDOW $window,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($application),
    *%user-options
  );

=item $application; the B<Gnome::Gtk3::Application> which emitted the signal

=item $window; the newly-added B<Gnome::Gtk3::Window>


=comment #TS:0:window-removed:
=head3 window-removed

Emitted when a B<Gnome::Gtk3::Window> is removed from I<application>,
either as a side-effect of being destroyed or explicitly
through C<gtk_application_remove_window()>.

  method handler (
    Unknown type GTK_TYPE_WINDOW $window,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($application),
    *%user-options
  );

=item $application; the B<Gnome::Gtk3::Application> which emitted the signal

=item $window; the B<Gnome::Gtk3::Window> that is being removed


=comment #TS:0:query-end:
=head3 query-end

Emitted when the session manager is about to end the session, only
if  I<register-session> is C<1>. Applications can
connect to this signal and call C<gtk_application_inhibit()> with
C<GTK_APPLICATION_INHIBIT_LOGOUT> to delay the end of the session
until state has been saved.

Since: 3.24.8

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($application),
    *%user-options
  );

=item $application; the B<Gnome::Gtk3::Application> which emitted the signal


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

=comment #TP:0:register-session:
=head3 Register session


Set this property to C<1> to register with the session manager.
The B<Gnome::GObject::Value> type of property I<register-session> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:screensaver-active:
=head3 Screensaver Active


This property is C<1> if GTK+ believes that the screensaver is
currently active. GTK+ only tracks session state (including this)
when  I<register-session> is set to C<1>.
Tracking the screensaver state is supported on Linux.
The B<Gnome::GObject::Value> type of property I<screensaver-active> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:app-menu:
=head3 Application menu

The GMenuModel for the application menu
Widget type: G_TYPE_MENU_MODEL


The B<Gnome::GObject::Value> type of property I<app-menu> is C<G_TYPE_OBJECT>.

=comment #TP:0:menubar:
=head3 Menubar

The GMenuModel for the menubar
Widget type: G_TYPE_MENU_MODEL


The B<Gnome::GObject::Value> type of property I<menubar> is C<G_TYPE_OBJECT>.

=comment #TP:0:active-window:
=head3 Active window

The window which most recently had focus
Widget type: GTK_TYPE_WINDOW


The B<Gnome::GObject::Value> type of property I<active-window> is C<G_TYPE_OBJECT>.
=end pod
