#TL:1:Gnome::Gtk3::PlacesSidebar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::PlacesSidebar

Sidebar that displays frequently-used places in the file system

![](images/placessidebar.png)

=head1 Description

B<Gnome::Gtk3::PlacesSidebar> is a widget that displays a list of frequently-used places in the file system:  the user’s home directory, the user’s bookmarks, and volumes and drives. This widget is used as a sidebar in B<Gnome::Gtk3::FileChooser> and may be used by file managers and similar programs.

The places sidebar displays drives and volumes, and will automatically mount or unmount them when the user selects them.

Applications can hook to various signals in the places sidebar to customize its behavior.  For example, they can add extra commands to the context menu of the sidebar.

While bookmarks are completely in control of the user, the places sidebar also allows individual applications to provide extra shortcut folders that are unique to each application.  For example, a Paint program may want to add a shortcut for a Clipart folder.  You can do this with C<gtk_places_sidebar_add_shortcut()>.

To make use of the places sidebar, an application at least needs to connect to the  I<open-location> signal.  This is emitted when the user selects in the sidebar a location to open.  The application should also call C<gtk_places_sidebar_set_location()> when it changes the currently-viewed location.


=head2 Css Nodes


B<Gnome::Gtk3::PlacesSidebar> uses a single CSS node with name placessidebar and style class .sidebar.

Among the children of the places sidebar, the following style classes can
be used:
=item .sidebar-new-bookmark-row for the 'Add new bookmark' row
=item .sidebar-placeholder-row for a row that is a placeholder
=item .has-open-popup when a popup is open for a row

=head2 See Also

B<Gnome::Gtk3::FileChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::PlacesSidebar;
  also is Gnome::Gtk3::ScrolledWindow;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::PlacesSidebar:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::PlacesSidebar;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::PlacesSidebar class process the options
    self.bless( :GtkPlacesSidebar, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::Glib::SList:api<1>;
use Gnome::Gio::File:api<1>;
use Gnome::Gtk3::ScrolledWindow:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::PlacesSidebar:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::ScrolledWindow;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPlacesOpenFlags

These flags serve two purposes.  First, the application can call C<gtk_places_sidebar_set_open_flags()> using these flags as a bitmask.  This tells the sidebar that the application is able to open folders selected from the sidebar in various ways, for example, in new tabs or in new windows in addition to the normal mode.

Second, when one of these values gets passed back to the application in the  I<open-location> signal, it means that the application should open the selected location in the normal way, in a new tab, or in a new window.  The sidebar takes care of determining the desired way to open the location, based on the modifier keys that the user is pressing at the time the selection is made.

If the application never calls C<gtk_places_sidebar_set_open_flags()>, then the sidebar will only use B<GTK_PLACES_OPEN_NORMAL> in the  I<open-location> signal.  This is the default mode of operation.


=item GTK_PLACES_OPEN_NORMAL: This is the default mode that B<Gnome::Gtk3::PlacesSidebar> uses if no other flags are specified.  It indicates that the calling application should open the selected location in the normal way, for example, in the folder view beside the sidebar.
=item GTK_PLACES_OPEN_NEW_TAB: When passed to C<gtk_places_sidebar_set_open_flags()>, this indicates that the application can open folders selected from the sidebar in new tabs.  This value will be passed to the  I<open-location> signal when the user selects that a location be opened in a new tab instead of in the standard fashion.
=item GTK_PLACES_OPEN_NEW_WINDOW: Similar to I<GTK_PLACES_OPEN_NEW_TAB>, but indicates that the application can open folders in new windows.


=end pod

#TE:1:GtkPlacesOpenFlags:
enum GtkPlacesOpenFlags is export (
  'GTK_PLACES_OPEN_NORMAL'     => 1 +< 0,
  'GTK_PLACES_OPEN_NEW_TAB'    => 1 +< 1,
  'GTK_PLACES_OPEN_NEW_WINDOW' => 1 +< 2
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new PlacesSidebar object.

  multi method new ( )

Create a PlacesSidebar object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a PlacesSidebar object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<open-location show-error-message>, :w3<populate-popup drag-action-requested drag-perform-drop>, :w1<drag-action-ask show-other-locations-with-flags mount unmount show-starred-location>, :w0<show-connect-to-server show-enter-location show-other-locations>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::PlacesSidebar' #`{{ or %options<GtkPlacesSidebar> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # elsif ? %options<> {
    # }

    # check if there are unknown options
    elsif %options.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }

    #`{{ when there are no defaults use this
    # check if there are any options
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }
    }}

    ##`{{ when there are options use this instead
    # create default object
    else {
      self._set-native-object(_gtk_places_sidebar_new());
    }
    #}}

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkPlacesSidebar');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_places_sidebar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkPlacesSidebar');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_places_sidebar_new:new()
#`{{
=begin pod
=head2 gtk_places_sidebar_new

Creates a new B<Gnome::Gtk3::PlacesSidebar> widget. The application should connect to at least the I<open-location> signal to be notified when the user makes a selection in the sidebar.

Returns: a newly created B<Gnome::Gtk3::PlacesSidebar>

  method gtk_places_sidebar_new ( --> N-GObject )

=end pod
}}

sub _gtk_places_sidebar_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_places_sidebar_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_places_sidebar_get_open_flags:
=begin pod
=head2 [gtk_places_sidebar_] get_open_flags

Gets the open flags.

Returns: the B<GtkPlacesOpenFlags> of I<sidebar>

  method gtk_places_sidebar_get_open_flags ( --> GtkPlacesOpenFlags )

=end pod

sub gtk_places_sidebar_get_open_flags ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_places_sidebar_set_open_flags:
=begin pod
=head2 [gtk_places_sidebar_] set_open_flags

Sets the way in which the calling application can open new locations from the places sidebar.  For example, some applications only open locations “directly” into their main view, while others may support opening locations in a new notebook tab or a new window.

This function is used to tell the places I<sidebar> about the ways in which the application can open new locations, so that the sidebar can display (or not) the “Open in new tab” and “Open in new window” menu items as appropriate.

When the  I<open-location> signal is emitted, its flags argument will be set to one of the I<flags> that was passed in C<gtk_places_sidebar_set_open_flags()>.

Passing 0 for I<flags> will cause B<GTK_PLACES_OPEN_NORMAL> to always be sent to callbacks for the “open-location” signal.


  method gtk_places_sidebar_set_open_flags ( GtkPlacesOpenFlags $flags )

=item GtkPlacesOpenFlags $flags; Bitmask of modes in which the calling application can open locations

=end pod

sub gtk_places_sidebar_set_open_flags ( N-GObject $sidebar, int32 $flags  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_location:
=begin pod
=head2 [gtk_places_sidebar_] get_location

Gets the currently selected location in the I<sidebar>. This can be C<Any> when nothing is selected, for example, when C<gtk_places_sidebar_set_location()> has been called with a location that is not among the sidebar’s list of places to show.

You can use this function to get the selection in the I<sidebar>.  Also, if you connect to the  I<populate-popup> signal, you can use this function to get the location that is being referred to during the callbacks for your menu items.

Returns: (nullable) (transfer full): a B<N-GFile> with the selected location, or C<Any> if nothing is visually selected.

  method gtk_places_sidebar_get_location ( --> N-GFile )

=end pod

sub gtk_places_sidebar_get_location ( N-GObject $sidebar --> N-GFile )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_location:
=begin pod
=head2 [gtk_places_sidebar_] set_location

Sets the location that is being shown in the widgets surrounding the I<sidebar>, for example, in a folder view in a file manager.  In turn, the I<sidebar> will highlight that location if it is being shown in the list of places, or it will unhighlight everything if the I<location> is not among the places in the list.

  method gtk_places_sidebar_set_location ( N-GFile $location )

=item N-GFile $location; (nullable): location to select, or C<Any> for no current path

=end pod

sub gtk_places_sidebar_set_location ( N-GObject $sidebar, N-GFile $location  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_recent:
=begin pod
=head2 [gtk_places_sidebar_] get_show_recent

Returns the value previously set with C<gtk_places_sidebar_set_show_recent()>

Returns: C<1> if the sidebar will display a builtin shortcut for recent files


  method gtk_places_sidebar_get_show_recent ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_recent ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_recent:
=begin pod
=head2 [gtk_places_sidebar_] set_show_recent

Sets whether the I<sidebar> should show an item for recent files.
The default value for this option is determined by the desktop
environment, but this function can be used to override it on a
per-application basis.


  method gtk_places_sidebar_set_show_recent ( Int $show_recent )

=item Int $show_recent; whether to show an item for recent files

=end pod

sub gtk_places_sidebar_set_show_recent ( N-GObject $sidebar, int32 $show_recent  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_desktop:
=begin pod
=head2 [gtk_places_sidebar_] get_show_desktop

Returns the value previously set with C<gtk_places_sidebar_set_show_desktop()>

Returns: C<1> if the sidebar will display a builtin shortcut to the desktop folder.


  method gtk_places_sidebar_get_show_desktop ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_desktop ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_desktop:
=begin pod
=head2 [gtk_places_sidebar_] set_show_desktop

Sets whether the I<sidebar> should show an item for the Desktop folder.
The default value for this option is determined by the desktop
environment and the user’s configuration, but this function can be
used to override it on a per-application basis.


  method gtk_places_sidebar_set_show_desktop ( Int $show_desktop )

=item Int $show_desktop; whether to show an item for the Desktop folder

=end pod

sub gtk_places_sidebar_set_show_desktop ( N-GObject $sidebar, int32 $show_desktop  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_enter_location:
=begin pod
=head2 [gtk_places_sidebar_] get_show_enter_location

Returns the value previously set with C<gtk_places_sidebar_set_show_enter_location()>

Returns: C<1> if the sidebar will display an “Enter Location” item.


  method gtk_places_sidebar_get_show_enter_location ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_enter_location ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_enter_location:
=begin pod
=head2 [gtk_places_sidebar_] set_show_enter_location

Sets whether the I<sidebar> should show an item for entering a location;
this is off by default. An application may want to turn this on if manually
entering URLs is an expected user action.

If you enable this, you should connect to the
 I<show-enter-location> signal.


  method gtk_places_sidebar_set_show_enter_location ( Int $show_enter_location )

=item Int $show_enter_location; whether to show an item to enter a location

=end pod

sub gtk_places_sidebar_set_show_enter_location ( N-GObject $sidebar, int32 $show_enter_location  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_local_only:
=begin pod
=head2 [gtk_places_sidebar_] set_local_only

Sets whether the I<sidebar> should only show local files.


  method gtk_places_sidebar_set_local_only ( Int $local_only )

=item Int $local_only; whether to show only local files

=end pod

sub gtk_places_sidebar_set_local_only ( N-GObject $sidebar, int32 $local_only  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_local_only:
=begin pod
=head2 [gtk_places_sidebar_] get_local_only

Returns the value previously set with C<gtk_places_sidebar_set_local_only()>.

Returns: C<1> if the sidebar will only show local files.


  method gtk_places_sidebar_get_local_only ( --> Int )


=end pod

sub gtk_places_sidebar_get_local_only ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_add_shortcut:
=begin pod
=head2 [gtk_places_sidebar_] add_shortcut

Applications may want to present some folders in the places sidebar if
they could be immediately useful to users.  For example, a drawing
program could add a “/usr/share/clipart” location when the sidebar is
being used in an “Insert Clipart” dialog box.

This function adds the specified I<location> to a special place for immutable
shortcuts.  The shortcuts are application-specific; they are not shared
across applications, and they are not persistent.  If this function
is called multiple times with different locations, then they are added
to the sidebar’s list in the same order as the function is called.


  method gtk_places_sidebar_add_shortcut ( N-GFile $location )

=item N-GFile $location; location to add as an application-specific shortcut

=end pod

sub gtk_places_sidebar_add_shortcut ( N-GObject $sidebar, N-GFile $location  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_remove_shortcut:
=begin pod
=head2 [gtk_places_sidebar_] remove_shortcut

Removes an application-specific shortcut that has been previously been
inserted with C<gtk_places_sidebar_add_shortcut()>.  If the I<location> is not a
shortcut in the sidebar, then nothing is done.


  method gtk_places_sidebar_remove_shortcut ( N-GFile $location )

=item N-GFile $location; location to remove

=end pod

sub gtk_places_sidebar_remove_shortcut ( N-GObject $sidebar, N-GFile $location  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_list_shortcuts:
=begin pod
=head2 [gtk_places_sidebar_] list_shortcuts

Gets the list of shortcuts.

Returns: (element-type N-GFile) (transfer full):
A B<GSList> of B<N-GFile> of the locations that have been added as
application-specific shortcuts with C<gtk_places_sidebar_add_shortcut()>.

  method gtk_places_sidebar_list_shortcuts ( --> N-GSList )


=end pod

sub gtk_places_sidebar_list_shortcuts ( N-GObject $sidebar --> N-GSList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_nth_bookmark:
=begin pod
=head2 [gtk_places_sidebar_] get_nth_bookmark

This function queries the bookmarks added by the user to the places sidebar,
and returns one of them.  This function is used by B<Gnome::Gtk3::FileChooser> to implement
the “Alt-1”, “Alt-2”, etc. shortcuts, which activate the cooresponding bookmark.

Returns: (nullable) (transfer full): The bookmark specified by the index I<n>, or
C<Any> if no such index exist.  Note that the indices start at 0, even though
the file chooser starts them with the keyboard shortcut "Alt-1".


  method gtk_places_sidebar_get_nth_bookmark ( Int $n --> N-GFile )

=item Int $n; index of the bookmark to query

=end pod

sub gtk_places_sidebar_get_nth_bookmark ( N-GObject $sidebar, int32 $n --> N-GFile )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_drop_targets_visible:
=begin pod
=head2 [gtk_places_sidebar_] set_drop_targets_visible

Make the B<Gnome::Gtk3::PlacesSidebar> show drop targets, so it can show the available
drop targets and a "new bookmark" row. This improves the Drag-and-Drop
experience of the user and allows applications to show all available
drop targets at once.

This needs to be called when the application is aware of an ongoing drag
that might target the sidebar. The drop-targets-visible state will be unset
automatically if the drag finishes in the B<Gnome::Gtk3::PlacesSidebar>. You only need
to unset the state when the drag ends on some other widget on your application.


  method gtk_places_sidebar_set_drop_targets_visible ( Int $visible, GdkDragContext $context )

=item Int $visible; whether to show the valid targets or not.
=item GdkDragContext $context; drag context used to ask the source about the action that wants to perform, so hints are more accurate.

=end pod

sub gtk_places_sidebar_set_drop_targets_visible ( N-GObject $sidebar, int32 $visible, GdkDragContext $context  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_trash:
=begin pod
=head2 [gtk_places_sidebar_] get_show_trash

Returns the value previously set with C<gtk_places_sidebar_set_show_trash()>

Returns: C<1> if the sidebar will display a “Trash” item.


  method gtk_places_sidebar_get_show_trash ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_trash ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_trash:
=begin pod
=head2 [gtk_places_sidebar_] set_show_trash

Sets whether the I<sidebar> should show an item for the Trash location.


  method gtk_places_sidebar_set_show_trash ( Int $show_trash )

=item Int $show_trash; whether to show an item for the Trash location

=end pod

sub gtk_places_sidebar_set_show_trash ( N-GObject $sidebar, int32 $show_trash  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_other_locations:
=begin pod
=head2 [gtk_places_sidebar_] set_show_other_locations

Sets whether the I<sidebar> should show an item for the application to show
an Other Locations view; this is off by default. When set to C<1>, persistent
devices such as hard drives are hidden, otherwise they are shown in the sidebar.
An application may want to turn this on if it implements a way for the user to
see and interact with drives and network servers directly.

If you enable this, you should connect to the
 I<show-other-locations> signal.


  method gtk_places_sidebar_set_show_other_locations ( Int $show_other_locations )

=item Int $show_other_locations; whether to show an item for the Other Locations view

=end pod

sub gtk_places_sidebar_set_show_other_locations ( N-GObject $sidebar, int32 $show_other_locations  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_other_locations:
=begin pod
=head2 [gtk_places_sidebar_] get_show_other_locations

Returns the value previously set with C<gtk_places_sidebar_set_show_other_locations()>

Returns: C<1> if the sidebar will display an “Other Locations” item.


  method gtk_places_sidebar_get_show_other_locations ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_other_locations ( N-GObject $sidebar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_set_show_starred_location:
=begin pod
=head2 [gtk_places_sidebar_] set_show_starred_location

If you enable this, you should connect to the
 I<show-starred-location> signal.
.26

  method gtk_places_sidebar_set_show_starred_location ( Int $show_starred_location )

=item Int $show_starred_location; whether to show an item for Starred files

=end pod

sub gtk_places_sidebar_set_show_starred_location ( N-GObject $sidebar, int32 $show_starred_location  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_places_sidebar_get_show_starred_location:
=begin pod
=head2 [gtk_places_sidebar_] get_show_starred_location

Returns the value previously set with C<gtk_places_sidebar_set_show_starred_location()>

Returns: C<1> if the sidebar will display a Starred item.
.26

  method gtk_places_sidebar_get_show_starred_location ( --> Int )


=end pod

sub gtk_places_sidebar_get_show_starred_location ( N-GObject $sidebar --> int32 )
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


=comment #TS:0:open-location:
=head3 open-location

The places sidebar emits this signal when the user selects a location
in it.  The calling application should display the contents of that
location; for example, a file manager should show a list of files in
the specified location.


  method handler (
    Unknown type G_TYPE_OBJECT $location,
    Unknown type GTK_TYPE_PLACES_OPEN_FLAGS $open_flags,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $location; (type Gio.File): B<N-GFile> to which the caller should switch.

=item $open_flags; a single value from B<GtkPlacesOpenFlags> specifying how the I<location> should be opened.


=comment #TS:0:populate-popup:
=head3 populate-popup

The places sidebar emits this signal when the user invokes a contextual
popup on one of its items. In the signal handler, the application may
add extra items to the menu as appropriate. For example, a file manager
may want to add a "Properties" command to the menu.

It is not necessary to store the I<selected_item> for each menu item;
during their callbacks, the application can use C<gtk_places_sidebar_get_location()>
to get the file to which the item refers.

The I<selected_item> argument may be C<Any> in case the selection refers to
a volume. In this case, I<selected_volume> will be non-C<Any>. In this case,
the calling application will have to C<g_object_ref()> the I<selected_volume> and
keep it around to use it in the callback.

The I<container> and all its contents are destroyed after the user
dismisses the popup. The popup is re-created (and thus, this signal is
emitted) every time the user activates the contextual menu.

Before 3.18, the I<container> always was a B<Gnome::Gtk3::Menu>, and you were expected
to add your items as B<Gnome::Gtk3::MenuItems>. Since 3.18, the popup may be implemented
as a B<Gnome::Gtk3::Popover>, in which case I<container> will be something else, e.g. a
B<Gnome::Gtk3::Box>, to which you may add B<Gnome::Gtk3::ModelButtons> or other widgets, such as
B<Gnome::Gtk3::Entries>, B<Gnome::Gtk3::SpinButtons>, etc. If your application can deal with this
situation, you can set  I<populate-all> to C<1> to request
that this signal is emitted for populating popovers as well.


  method handler (
    N-GObject #`{ is widget } $container,
    Unknown type G_TYPE_FILE $selected_item,
    Unknown type G_TYPE_VOLUME $selected_volume,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $container; (type B<Gnome::Gtk3::.Widget>): a B<Gnome::Gtk3::Menu> or another B<Gnome::Gtk3::Container>

=item $selected_item; (type Gio.File) (nullable): B<N-GFile> with the item to which the popup should refer, or C<Any> in the case of a I<selected_volume>. =item $selected_volume; (type Gio.Volume) (nullable): B<GVolume> if the selected item is a volume, or C<Any> if it is a file.

=comment #TS:0:show-error-message:
=head3 show-error-message

The places sidebar emits this signal when it needs the calling
application to present an error message.  Most of these messages
refer to mounting or unmounting media, for example, when a drive
cannot be started for some reason.


  method handler (
    Str $primary,
    Str $secondary,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $primary; primary message with a summary of the error to show.

=item $secondary; secondary message with details of the error to show.


=comment #TS:0:show-connect-to-server:
=head3 show-connect-to-server

The places sidebar emits this signal when it needs the calling
application to present an way to connect directly to a network server.
For example, the application may bring up a dialog box asking for
a URL like "sftp://ftp.example.com".  It is up to the application to create
the corresponding mount by using, for example, C<g_file_mount_enclosing_volume()>.

Deprecated: 3.18: use the  I<show-other-locations> signal
to connect to network servers.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.


=comment #TS:0:show-enter-location:
=head3 show-enter-location

The places sidebar emits this signal when it needs the calling
application to present an way to directly enter a location.
For example, the application may bring up a dialog box asking for
a URL like "http://http.example.com".


  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.


=comment #TS:0:drag-action-requested:
=head3 drag-action-requested

When the user starts a drag-and-drop operation and the sidebar needs
to ask the application for which drag action to perform, then the
sidebar will emit this signal.

The application can evaluate the I<context> for customary actions, or
it can check the type of the files indicated by I<source_file_list> against the
possible actions for the destination I<dest_file>.

The drag action to use must be the return value of the signal handler.

Returns: The drag action to use, for example, B<GDK_ACTION_COPY>
or B<GDK_ACTION_MOVE>, or 0 if no action is allowed here (i.e. drops
are not allowed in the specified I<dest_file>).


  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Unknown type G_TYPE_OBJECT $dest_file,
    Unknown type G_TYPE_POINTER /* GList of N-GFile */  $source_file_list,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
    --> Int
  );

=item $sidebar; the object which received the signal.

=item $context; (type B<Gnome::Gdk3::.DragContext>): B<Gnome::Gdk3::DragContext> with information about the drag operation

=item $dest_file; (type Gio.File): B<N-GFile> with the tentative location that is being hovered for a drop

=item $source_file_list; (type GLib.List) (element-type N-GFile) (transfer none):
List of B<N-GFile> that are being dragged

=comment #TS:0:drag-action-ask:
=head3 drag-action-ask

The places sidebar emits this signal when it needs to ask the application
to pop up a menu to ask the user for which drag action to perform.

Returns: the final drag action that the sidebar should pass to the drag side
of the drag-and-drop operation.


  method handler (
    Int $actions,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
    --> Int
  );

=item $sidebar; the object which received the signal.

=item $actions; Possible drag actions that need to be asked for.


=comment #TS:0:drag-perform-drop:
=head3 drag-perform-drop

The places sidebar emits this signal when the user completes a
drag-and-drop operation and one of the sidebar's items is the
destination.  This item is in the I<dest_file>, and the
I<source_file_list> has the list of files that are dropped into it and
which should be copied/moved/etc. based on the specified I<action>.


  method handler (
    Unknown type G_TYPE_OBJECT $dest_file,
    Unknown type G_TYPE_POINTER $source_file_list,
    Unknown type /* GList of N-GFile */
                        G_TYPE_INT $action,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $dest_file; (type Gio.File): Destination B<N-GFile>.

=item $source_file_list; (type GLib.List) (element-type N-GFile) (transfer none):
B<GList> of B<N-GFile> that got dropped.
=item $action; Drop action to perform.


=comment #TS:0:show-other-locations:
=head3 show-other-locations

The places sidebar emits this signal when it needs the calling
application to present a way to show other locations e.g. drives
and network access points.
For example, the application may bring up a page showing persistent
volumes and discovered network addresses.

Deprecated: 3.20: use the  I<show-other-locations-with-flags>
which includes the open flags in order to allow the user to specify to open
in a new tab or window, in a similar way than  I<open-location>


  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.


=comment #TS:0:show-other-locations-with-flags:
=head3 show-other-locations-with-flags

The places sidebar emits this signal when it needs the calling
application to present a way to show other locations e.g. drives
and network access points.
For example, the application may bring up a page showing persistent
volumes and discovered network addresses.


  method handler (
    Unknown type GTK_TYPE_PLACES_OPEN_FLAGS $open_flags,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $open_flags; a single value from B<GtkPlacesOpenFlags> specifying how it should be opened.


=comment #TS:0:mount:
=head3 mount

The places sidebar emits this signal when it starts a new operation
because the user clicked on some location that needs mounting.
In this way the application using the B<Gnome::Gtk3::PlacesSidebar> can track the
progress of the operation and, for example, show a notification.


  method handler (
    Unknown type G_TYPE_MOUNT_OPERATION $mount_operation,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $mount_operation; the B<GMountOperation> that is going to start.


=comment #TS:0:unmount:
=head3 unmount

The places sidebar emits this signal when it starts a new operation
because the user for example ejected some drive or unmounted a mount.
In this way the application using the B<Gnome::Gtk3::PlacesSidebar> can track the
progress of the operation and, for example, show a notification.


  method handler (
    Unknown type G_TYPE_MOUNT_OPERATION $mount_operation,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $mount_operation; the B<GMountOperation> that is going to start.


=comment #TS:0:show-starred-location:
=head3 show-starred-location

The places sidebar emits this signal when it needs the calling
application to present a way to show the starred files. In GNOME,
starred files are implemented by setting the nao:predefined-tag-favorite
tag in the tracker database.

  method handler (
    Unknown type GTK_TYPE_PLACES_OPEN_FLAGS $open_flags,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($sidebar),
    *%user-options
  );

=item $sidebar; the object which received the signal.

=item $open_flags; a single value from B<GtkPlacesOpenFlags> specifying how the
starred file should be opened.

=end pod
