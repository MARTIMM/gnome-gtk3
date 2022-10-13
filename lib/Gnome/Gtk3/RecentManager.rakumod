#TL:1:Gnome::Gtk3::RecentManager:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentManager

Managing recently used files

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::RecentManager> provides a facility for adding, removing and looking up recently used files. Each recently used file is identified by its URI, and has meta-data associated to it, like the names and command lines of the applications that have registered it, the number of time each application has registered the same file, the mime type of the file and whether the file should be displayed only by the applications that have registered it.

The recently used files list is per user.

The B<Gnome::Gtk3::RecentManager> acts like a database of all the recently used files. You can create new B<Gnome::Gtk3::RecentManager> objects, but it is more efficient to use the default manager created by GTK+.

Adding a new recently used file is as simple as:

  my Gnome::Gtk3::RecentManager $manager .= new(:default);
  $manager.add-item('file:///foo/bar.baz');

The B<Gnome::Gtk3::RecentManager> will try to gather all the needed information from the file itself through GIO.

Looking up the meta-data associated with a recently used file given its URI requires calling C<lookup-item()>:

  my Gnome::Glib::Error $e;
  my Gnome::Gtk3::RecentInfo $ri;
  my Gnome::Gtk3::RecentManager $manager .= new(:default);
  ( $ri, $e ) = $manager.lookup-item('file:///foo/bar.baz');
  if $ri.is-valid {
    # Use the info object …
    # free object
    $ri.clear-object;
  }

  else {
    note $e.message; # or die on it
    $e.clear-object
  }

In order to retrieve the list of recently used files, you can use C<get-items()>, which returns a list of B<Gnome::Gtk3::RecentInfo> objects. This list must be freed after use.

  sub clear-list ( Gnome::Glib::List $l is copy ) {
    my Gnome::Glib::List $lbackup = $l;
    while $l {
      my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
      $ri.clear-object;
      $l .= next;
    }
    $lbackup.clear-object;
  }

  my Gnome::Glib::List $l = .get-items;
  # use first item of the list for example
  my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
  # Use the info object …
  # free the list
  clear-list($l);


A B<Gnome::Gtk3::RecentManager> is the model used to populate the contents of one, or more B<Gnome::Gtk3::RecentChooser> implementations.

Note that the maximum age of the recently used files list is controllable through the  I<gtk-recent-files-max-age> property.


=head2 See Also

B<GBookmarkFile>, B<Gnome::Gtk3::Settings>, B<Gnome::Gtk3::RecentChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentManager;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/RecentManager.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RecentManager;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RecentManager;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RecentManager class process the options
    self.bless( :GtkRecentManager, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Quark;
use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::GObject::Object;

use Gnome::Gtk3::RecentInfo;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentManager:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkRecentManagerError

Error codes for B<Gnome::Gtk3::RecentManager> operations

=item GTK_RECENT_MANAGER_ERROR_NOT_FOUND: the URI specified does not exists in the recently used resources list.
=item GTK_RECENT_MANAGER_ERROR_INVALID_URI: the URI specified is not valid.
=item GTK_RECENT_MANAGER_ERROR_INVALID_ENCODING: the supplied string is not UTF-8 encoded.
=item GTK_RECENT_MANAGER_ERROR_NOT_REGISTERED: no application has registered the specified item.
=item GTK_RECENT_MANAGER_ERROR_READ: failure while reading the recently used resources file.
=item GTK_RECENT_MANAGER_ERROR_WRITE: failure while writing the recently used resources file.
=item GTK_RECENT_MANAGER_ERROR_UNKNOWN: unspecified error.


=end pod

#TE:0:GtkRecentManagerError:
enum GtkRecentManagerError is export (
  'GTK_RECENT_MANAGER_ERROR_NOT_FOUND',
  'GTK_RECENT_MANAGER_ERROR_INVALID_URI',
  'GTK_RECENT_MANAGER_ERROR_INVALID_ENCODING',
  'GTK_RECENT_MANAGER_ERROR_NOT_REGISTERED',
  'GTK_RECENT_MANAGER_ERROR_READ',
  'GTK_RECENT_MANAGER_ERROR_WRITE',
  'GTK_RECENT_MANAGER_ERROR_UNKNOWN'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentData

Meta-data to be passed to C<add-full()> when registering a recently used resource.


=item  Str  $.display_name: a UTF-8 encoded string, containing the name of the recently used resource to be displayed, or C<Any>;
=item  Str  $.description: a UTF-8 encoded string, containing a short description of the resource, or C<Any>;
=item  Str  $.mime_type: the MIME type of the resource;
=item  Str  $.app_name: the name of the application that is registering this recently used resource;
=item  Str  $.app_exec: command line used to launch this resource; may contain the C<%f> and C<%u> escape characters which will be expanded to the resource file path and URI respectively when the command line is retrieved;
=item  CArray[Str]  $.groups: (array zero-terminated=1): a vector of strings containing groups names. When initializing, an Array of Str is ok, no need to have a last entry set to Nil;
=item Int $.is_private: whether this resource should be displayed only by the applications that have registered it or not.

=end pod

#TT:1:N-GtkRecentData:
class N-GtkRecentData is export is repr('CStruct') {
  has gchar-ptr $.display_name;
  has gchar-ptr $.description;
  has gchar-ptr $.mime_type;
  has gchar-ptr $.app_name;
  has gchar-ptr $.app_exec;
  has gchar-pptr $.groups;
  has gboolean $.is_private;

  submethod BUILD (
    Str :$display_name = '', Str :$description = '', Str :$mime_type = '',
    Str :$app_name = '', Str :$app_exec = '', Array :$groups = [],
    Bool :$!is_private = False
  ) {
    $!display_name := $display_name;
    $!description := $description;
    $!mime_type := $mime_type;
    $!app_name := $app_name;
    $!app_exec := $app_exec;
    $!groups := CArray[Str].new( |@$groups, Nil);
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentManager

B<Gnome::Gtk3::RecentManager>-struct contains only private data
and should be accessed using the provided API.

=end pod

#TT:0:N-GtkRecentManager:
class N-GtkRecentManager is repr('CPointer') is export { }

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 no options

Create a new RecentManager object.

  multi method new ( )

=head :default

Gets a unique instance of B<Gnome::Gtk3::RecentManager>, that you can share in your application without caring about memory management.

  multi method new ( :default! )

=head3 :native-object

Create a RecentManager object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RecentManager object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:default):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentManager' #`{{ or %options<GtkRecentManager> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<default> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_recent_manager_get_default;
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
        $no = _gtk_recent_manager_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRecentManager');

  }
}


#-------------------------------------------------------------------------------
#TM:0:error-quark:
=begin pod
=head2 error-quark

Returns: The error quark used for I<Gnome::Gtk3::RecentManager> errors.

  method error-quark ( --> UInt )

=end pod

method error-quark ( --> UInt ) {

  gtk_recent_manager_error_quark(
    self._get-native-object-no-reffing,
  );
}

sub gtk_recent_manager_error_quark (  --> GQuark )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_manager_new:
#`{{
=begin pod
=head2 _gtk_recent_manager_new

Creates a new recent manager object. Recent manager objects are used to handle the list of recently used resources. A B<Gnome::Gtk3::RecentManager> object monitors the recently used resources list, and emits the “changed” signal each time something inside the list changes.  B<Gnome::Gtk3::RecentManager> objects are expensive: be sure to create them only when needed. You should use C<gtk_recent_manager_get_default()> instead.

Returns: A newly created B<Gnome::Gtk3::RecentManager> object

  method _gtk_recent_manager_new ( --> N-GObject )


=end pod
}}

sub _gtk_recent_manager_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_manager_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_recent_manager_get-default:
#`{{
=begin pod
=head2 get-default

Gets a unique instance of B<Gnome::Gtk3::RecentManager>, that you can share in your application without caring about memory management.

Returns: A unique B<Gnome::Gtk3::RecentManager>. Do not ref or unref it.

  method get-default ( --> N-GObject )


=end pod

method get-default ( --> N-GObject ) {

  gtk_recent_manager_get_default(
    self._get-native-object-no-reffing,
  );
}
}}

sub _gtk_recent_manager_get_default (  --> N-GObject )
  is symbol('gtk_recent_manager_get_default')
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-item:
=begin pod
=head2 add-item

Adds a new resource, pointed by I<$uri>, into the recently used resources list.  This function automatically retrieves some of the needed metadata and setting other metadata to common default values; it then feeds the data to C<add-full()>.  See C<add-full()> if you want to explicitly define the metadata for the resource pointed by I<$uri>.

Returns: C<True> if the new item was successfully added to the recently used resources list

  method add-item (  Str  $uri --> Bool )

=item  Str  $uri; a valid URI

=end pod

method add-item (  Str  $uri --> Bool ) {

  gtk_recent_manager_add_item(
    self._get-native-object-no-reffing, $uri
  ).Bool;
}

sub gtk_recent_manager_add_item ( N-GObject $manager, gchar-ptr $uri --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-full:
=begin pod
=head2 add-full

Adds a new resource, pointed by I<$uri>, into the recently used resources list, using the metadata specified inside the C<N-GtkRecentData>-struct passed in I<$recent_data>.
The passed URI will be used to identify this resource inside the list.
In order to register the new recently used resource, metadata about the resource must be passed as well as the URI; the metadata is stored in a C<N-GtkRecentData>-struct, which must contain the MIME type of the resource pointed by the URI; the name of the application that is registering the item, and a command line to be used when launching the item.

Optionally, a C<N-GtkRecentData>-struct might contain a UTF-8 string to be used when viewing the item instead of the last component of the URI; a short description of the item; whether the item should be considered private - that is, should be displayed only by the applications that have registered it.

Returns: C<True> if the new item was successfully added to the recently used resources list, C<False> otherwise.

  method add-full ( Str $uri, N-GtkRecentData $recent_data --> Bool )

=item  Str  $uri; a valid URI
=item N-GtkRecentData $recent_data; metadata of the resource

=end pod

method add-full (  Str  $uri, N-GtkRecentData $recent_data --> Bool ) {

  gtk_recent_manager_add_full(
    self._get-native-object-no-reffing, $uri, $recent_data
  ).Bool;
}

sub gtk_recent_manager_add_full ( N-GObject $manager, gchar-ptr $uri, N-GtkRecentData $recent_data --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-item:
=begin pod
=head2 remove-item

Removes a resource pointed by I<$uri> from the recently used resources list handled by a recent manager.

Returns: An invalid error object if the item pointed by I<$uri> has been successfully removed by the recently used resources list, and a valid one with additional data otherwise.

  method remove-item ( Str  $uri --> Gnome::Glib::Error )

=item  Str  $uri; the URI of the item you wish to remove

=end pod

method remove-item ( Str $uri --> Gnome::Glib::Error ) {
  my CArray[N-GError] $ne .= new(N-GError);
  my Int $r = gtk_recent_manager_remove_item(
    self._get-native-object-no-reffing, $uri, $ne
  );

  my Gnome::Glib::Error $e .= new(:native-object($ne[0]));
  $e.clear-object if $r == 1;
  $e
}

sub gtk_recent_manager_remove_item (
  N-GObject $manager, gchar-ptr $uri, CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:lookup-item:
=begin pod
=head2 lookup-item

Searches for a URI inside the recently used resources list, and returns a B<Gnome::Gtk3::RecentInfo>-struct containing informations about the resource like its MIME type, or its display name.

Returns: A list. The first item is a B<Gnome::Gtk3::RecentInfo> object containing information about the resource pointed by I<uri>, or it is invalid if the URI was not registered in the recently used resources list. Free it with C<clear-object()>. The second item is a B<Gnome::Glib::Error> object which is invalid when the first item in the list is defined. Otherwise the error object shows why it failed.

  method lookup-item (  Str  $uri --> List )

=item  Str  $uri; a URI

The returned list items;
=item B<Gnome::Gtk3::RecentInfo>; Recent info object or undefined.
=item B<Gnome::Glib::Error> $error; A (in)valid error object

=end pod

method lookup-item (  Str  $uri --> List ) {
  my CArray[N-GError] $ne .= new(N-GError);

  my Gnome::Gtk3::RecentInfo $ri .= new(
    :native-object(
      gtk_recent_manager_lookup_item(
        self._get-native-object-no-reffing, $uri, $ne
      )
    )
  );

  my Gnome::Glib::Error $e .= new(:native-object($ne[0]));
  $e.clear-object if $ri.is-valid;

  ( $ri, $e)
}

sub gtk_recent_manager_lookup_item (
  N-GObject $manager, gchar-ptr $uri, CArray[N-GError] $error
  --> N-GtkRecentInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:has-item:
=begin pod
=head2 has-item

Checks whether there is a recently used resource registered with I<$uri> inside the recent manager.

Returns: C<True> if the resource was found, C<False> otherwise

  method has-item (  Str  $uri --> Bool )

=item  Str  $uri; a URI

=end pod

method has-item (  Str  $uri --> Bool ) {

  gtk_recent_manager_has_item(
    self._get-native-object-no-reffing, $uri
  ).Bool;
}

sub gtk_recent_manager_has_item ( N-GObject $manager, gchar-ptr $uri --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:move-item:
=begin pod
=head2 move-item

Changes the location of a recently used resource from I<$uri> to I<$new_uri>.  Please note that this function will not affect the resource pointed by the URIs, but only the URI used in the recently used resources list.

Returns: an invalid error object on success. The error object has information if it fails.

  method move-item (  Str  $uri,  Str  $new_uri --> Gnome::Glib::Error )

=item  Str  $uri; the URI of a recently used resource
=item  Str  $new_uri; (allow-none): the new URI of the recently used resource, or C<Any> to remove the item pointed by I<uri> in the list
=item N-GError $error; (allow-none): a return location for a B<GError>, or C<Any>

=end pod

method move-item (  Str  $uri,  Str  $new_uri --> Gnome::Glib::Error ) {
  my CArray[N-GError] $ne .= new(N-GError);
  my Int $r = gtk_recent_manager_move_item(
    self._get-native-object-no-reffing, $uri, $new_uri, $ne
  );

  my Gnome::Glib::Error $e .= new(:native-object($ne[0]));
  $e.clear-object if $r == 1;
  $e
}

sub gtk_recent_manager_move_item (
  N-GObject $manager, gchar-ptr $uri, gchar-ptr $new_uri,
  CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-items:
=begin pod
=head2 get-items

Gets the list of recently used resources.

Returns: (element-type B<Gnome::Gtk3::RecentInfo>): a list of newly allocated B<Gnome::Gtk3::RecentInfo> objects. Use C<clear-object()> on each item inside the list, and then free the list itself also using C<clear-object()>.

  method get-items ( --> Gnome::Glib::List )

=end pod

method get-items ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(
      gtk_recent_manager_get_items(self._get-native-object-no-reffing)
    )
  );
}

sub gtk_recent_manager_get_items ( N-GObject $manager --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:purge-items:
=begin pod
=head2 purge-items

Purges every item from the recently used resources list.

Returns: the number of items that have been removed from the recently used resources list

  method purge-items ( --> Int )

=end pod

method purge-items ( --> Int ) {
  my CArray[N-GError] $ne .= new(N-GError);

  my Int $nitems = gtk_recent_manager_purge_items(
    self._get-native-object-no-reffing, $ne
  );

  my Gnome::Glib::Error $e .= new(:native-object($ne[0]));
  note ($e.message // '') unless $nitems > 0;

  $nitems
}

sub gtk_recent_manager_purge_items (
  N-GObject $manager, CArray[N-GError] $error --> gint
) is native(&gtk-lib)
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

=comment -----------------------------------------------------------------------
=comment #TS:0:changed:
=head3 changed

Emitted when the current recently used resources manager changes its contents, either by calling C<gtk_recent_manager_add_item()> or by another application.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($recent_manager),
    *%user-options
  );

=item $recent_manager; the recent manager

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

=comment -----------------------------------------------------------------------
=comment #TP:1:filename:
=head3 Filename

The full path to the file to be used to store and read the recently used resources list

The B<Gnome::GObject::Value> type of property I<filename> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:size:
=head3 Size

The size of the recently used resources list.

The B<Gnome::GObject::Value> type of property I<size> is C<G_TYPE_INT>.
=end pod
