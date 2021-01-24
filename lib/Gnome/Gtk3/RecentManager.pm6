#TL:1:Gnome::Gtk3::RecentManager:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentManager

Managing recently used files

=comment ![](images/X.png)

=head1 Description

 
B<Gnome::Gtk3::RecentManager> provides a facility for adding, removing and 
looking up recently used files. Each recently used file is 
identified by its URI, and has meta-data associated to it, like 
the names and command lines of the applications that have 
registered it, the number of time each application has registered 
the same file, the mime type of the file and whether the file 
should be displayed only by the applications that have 
registered it. 
 
The recently used files list is per user. 
 
The B<Gnome::Gtk3::RecentManager> acts like a database of all the recently 
used files. You can create new B<Gnome::Gtk3::RecentManager> objects, but 
it is more efficient to use the default manager created by GTK+. 
 
Adding a new recently used file is as simple as: 
 
|[<!-- language="C" --> 
B<Gnome::Gtk3::RecentManager> *manager; 
 
manager = C<gtk_recent_manager_get_default()>; 
gtk_recent_manager_add_item (manager, file_uri); 
]| 
 
The B<Gnome::Gtk3::RecentManager> will try to gather all the needed information 
from the file itself through GIO. 
 
Looking up the meta-data associated with a recently used file 
given its URI requires calling C<gtk_recent_manager_lookup_item()>: 
 
|[<!-- language="C" --> 
B<Gnome::Gtk3::RecentManager> *manager; 
B<Gnome::Gtk3::RecentInfo> *info; 
GError *error = NULL; 
 
manager = C<gtk_recent_manager_get_default()>; 
info = gtk_recent_manager_lookup_item (manager, file_uri, &error); 
if (error) 
  { 
    g_warning ("Could not find the file: C<s>", error->message); 
    g_error_free (error); 
  } 
else 
 { 
   // Use the info object 
   gtk_recent_info_unref (info); 
 } 
]| 
 
In order to retrieve the list of recently used files, you can use 
C<gtk_recent_manager_get_items()>, which returns a list of B<Gnome::Gtk3::RecentInfo>-structs. 
 
A B<Gnome::Gtk3::RecentManager> is the model used to populate the contents of 
one, or more B<Gnome::Gtk3::RecentChooser> implementations. 
 
Note that the maximum age of the recently used files list is 
controllable through the  I<gtk-recent-files-max-age> 
property. 
 
 * Recently used files are supported since GTK+ 2.10.

=head2 See Also

B<GBookmarkFile>, B<Gnome::Gtk3::Settings>, B<Gnome::Gtk3::RecentChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentManager;
  


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


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


#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentManager:auth<github:MARTIMM>:ver<0.1.0>;


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

Meta-data to be passed to C<gtk_recent_manager_add_full()> when
registering a recently used resource.


=item  Str  $.display_name: a UTF-8 encoded string, containing the name of the recently used resource to be displayed, or C<Any>;
=item  Str  $.description: a UTF-8 encoded string, containing a short description of the resource, or C<Any>;
=item  Str  $.mime_type: the MIME type of the resource;
=item  Str  $.app_name: the name of the application that is registering this recently used resource;
=item  Str  $.app_exec: command line used to launch this resource; may contain the “\C<f>” and “\C<u>” escape characters which will be expanded to the resource file path and URI respectively when the command line is retrieved;
=item  CArray[Str]  $.groups: (array zero-terminated=1): a vector of strings containing groups names;
=item Int $.is_private: whether this resource should be displayed only by the applications that have registered it or not.


=end pod

#TT:0:N-GtkRecentData:
class N-GtkRecentData is export is repr('CStruct') {
  has gchar-ptr $.display_name;
  has gchar-ptr $.description;
  has gchar-ptr $.mime_type;
  has gchar-ptr $.app_name;
  has gchar-ptr $.app_exec;
  has gchar-pptr $.groups;
  has gboolean $.is_private;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentManager

B<Gnome::Gtk3::RecentManager>-struct contains only private data
and should be accessed using the provided API.





=end pod

#TT:0:N-GtkRecentManager:
class N-GtkRecentManager is export is repr('CStruct') {
  has N-GObject $.parent_instance;
  has GtkRecentManagerPrivate $.priv;
}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new RecentManager object.

  multi method new ( )

=head3 :native-object

Create a RecentManager object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RecentManager object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

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
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_recent_manager_new___x___($no);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
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
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_recent_manager_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkRecentManager');

  }
}

#`{{
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_recent_manager_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  #$s = self._xyz_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkRecentManager');
  $s = callsame unless ?$s;

  $s;
}
}}


#-------------------------------------------------------------------------------
#TM:0:error-quark:
=begin pod
=head2 error-quark



  method error-quark ( --> UInt )


=end pod

method error-quark ( --> UInt ) {
  
  gtk_recent_manager_error_quark(
    self.get-native-object-no-reffing,
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
#TM:0:get-default:
=begin pod
=head2 get-default

Gets a unique instance of B<Gnome::Gtk3::RecentManager>, that you can share in your application without caring about memory management.

Returns: (transfer none): A unique B<Gnome::Gtk3::RecentManager>. Do not ref or unref it.  

  method get-default ( --> N-GObject )


=end pod

method get-default ( --> N-GObject ) {
  
  gtk_recent_manager_get_default(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_manager_get_default (  --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-item:
=begin pod
=head2 add-item

Adds a new resource, pointed by I<uri>, into the recently used resources list.  This function automatically retrieves some of the needed metadata and setting other metadata to common default values; it then feeds the data to C<gtk_recent_manager_add_full()>.  See C<gtk_recent_manager_add_full()> if you want to explicitly define the metadata for the resource pointed by I<uri>.

Returns: C<1> if the new item was successfully added to the recently used resources list  

  method add-item (  Str  $uri --> Int )

=item  Str  $uri; a valid URI

=end pod

method add-item (  Str  $uri --> Int ) {
  
  gtk_recent_manager_add_item(
    self.get-native-object-no-reffing, $uri
  );
}

sub gtk_recent_manager_add_item ( N-GObject $manager, gchar-ptr $uri --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-full:
=begin pod
=head2 add-full

Adds a new resource, pointed by I<uri>, into the recently used resources list, using the metadata specified inside the B<Gnome::Gtk3::RecentData>-struct passed in I<recent_data>.  The passed URI will be used to identify this resource inside the list.  In order to register the new recently used resource, metadata about the resource must be passed as well as the URI; the metadata is stored in a B<Gnome::Gtk3::RecentData>-struct, which must contain the MIME type of the resource pointed by the URI; the name of the application that is registering the item, and a command line to be used when launching the item.  Optionally, a B<Gnome::Gtk3::RecentData>-struct might contain a UTF-8 string to be used when viewing the item instead of the last component of the URI; a short description of the item; whether the item should be considered private - that is, should be displayed only by the applications that have registered it.

Returns: C<1> if the new item was successfully added to the recently used resources list, C<0> otherwise  

  method add-full (  Str  $uri, GtkRecentData $recent_data --> Int )

=item  Str  $uri; a valid URI
=item GtkRecentData $recent_data; metadata of the resource

=end pod

method add-full (  Str  $uri, GtkRecentData $recent_data --> Int ) {
  
  gtk_recent_manager_add_full(
    self.get-native-object-no-reffing, $uri, $recent_data
  );
}

sub gtk_recent_manager_add_full ( N-GObject $manager, gchar-ptr $uri, GtkRecentData $recent_data --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-item:
=begin pod
=head2 remove-item

Removes a resource pointed by I<uri> from the recently used resources list handled by a recent manager.

Returns: C<1> if the item pointed by I<uri> has been successfully removed by the recently used resources list, and C<0> otherwise  

  method remove-item (  Str  $uri, N-GError $error --> Int )

=item  Str  $uri; the URI of the item you wish to remove
=item N-GError $error; (allow-none): return location for a B<GError>, or C<Any>

=end pod

method remove-item (  Str  $uri, N-GError $error --> Int ) {
  
  gtk_recent_manager_remove_item(
    self.get-native-object-no-reffing, $uri, $error
  );
}

sub gtk_recent_manager_remove_item ( N-GObject $manager, gchar-ptr $uri, N-GError $error --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:lookup-item:
=begin pod
=head2 lookup-item

Searches for a URI inside the recently used resources list, and returns a B<Gnome::Gtk3::RecentInfo>-struct containing informations about the resource like its MIME type, or its display name.

Returns: (nullable): a B<Gnome::Gtk3::RecentInfo>-struct containing information about the resource pointed by I<uri>, or C<Any> if the URI was not registered in the recently used resources list. Free with C<gtk_recent_info_unref()>.  

  method lookup-item (  Str  $uri, N-GError $error --> GtkRecentInfo )

=item  Str  $uri; a URI
=item N-GError $error; (allow-none): a return location for a B<GError>, or C<Any>

=end pod

method lookup-item (  Str  $uri, N-GError $error --> GtkRecentInfo ) {
  
  gtk_recent_manager_lookup_item(
    self.get-native-object-no-reffing, $uri, $error
  );
}

sub gtk_recent_manager_lookup_item ( N-GObject $manager, gchar-ptr $uri, N-GError $error --> GtkRecentInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-item:
=begin pod
=head2 has-item

Checks whether there is a recently used resource registered with I<uri> inside the recent manager.

Returns: C<1> if the resource was found, C<0> otherwise  

  method has-item (  Str  $uri --> Int )

=item  Str  $uri; a URI

=end pod

method has-item (  Str  $uri --> Int ) {
  
  gtk_recent_manager_has_item(
    self.get-native-object-no-reffing, $uri
  );
}

sub gtk_recent_manager_has_item ( N-GObject $manager, gchar-ptr $uri --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:move-item:
=begin pod
=head2 move-item

Changes the location of a recently used resource from I<uri> to I<new_uri>.  Please note that this function will not affect the resource pointed by the URIs, but only the URI used in the recently used resources list.

Returns: C<1> on success  

  method move-item (  Str  $uri,  Str  $new_uri, N-GError $error --> Int )

=item  Str  $uri; the URI of a recently used resource
=item  Str  $new_uri; (allow-none): the new URI of the recently used resource, or C<Any> to remove the item pointed by I<uri> in the list
=item N-GError $error; (allow-none): a return location for a B<GError>, or C<Any>

=end pod

method move-item (  Str  $uri,  Str  $new_uri, N-GError $error --> Int ) {
  
  gtk_recent_manager_move_item(
    self.get-native-object-no-reffing, $uri, $new_uri, $error
  );
}

sub gtk_recent_manager_move_item ( N-GObject $manager, gchar-ptr $uri, gchar-ptr $new_uri, N-GError $error --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-items:
=begin pod
=head2 get-items

Gets the list of recently used resources.

Returns: (element-type B<Gnome::Gtk3::RecentInfo>) (transfer full): a list of newly allocated B<Gnome::Gtk3::RecentInfo> objects. Use C<gtk_recent_info_unref()> on each item inside the list, and then free the list itself using C<g_list_free()>.  

  method get-items ( --> N-GList )


=end pod

method get-items ( --> N-GList ) {
  
  gtk_recent_manager_get_items(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_manager_get_items ( N-GObject $manager --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:purge-items:
=begin pod
=head2 purge-items

Purges every item from the recently used resources list.

Returns: the number of items that have been removed from the recently used resources list  

  method purge-items ( N-GError $error --> Int )

=item N-GError $error; (allow-none): a return location for a B<GError>, or C<Any>

=end pod

method purge-items ( N-GError $error --> Int ) {
  
  gtk_recent_manager_purge_items(
    self.get-native-object-no-reffing, $error
  );
}

sub gtk_recent_manager_purge_items ( N-GObject $manager, N-GError $error --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-ref:
=begin pod
=head2 gtk-recent-info-ref

Increases the reference count of I<recent_info> by one.

Returns: the recent info object with its reference count increased by one  

  method gtk-recent-info-ref ( GtkRecentInfo $info --> GtkRecentInfo )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-ref ( GtkRecentInfo $info --> GtkRecentInfo ) {
  
  gtk_recent_info_ref(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_ref ( GtkRecentInfo $info --> GtkRecentInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-unref:
=begin pod
=head2 gtk-recent-info-unref

Decreases the reference count of I<info> by one. If the reference count reaches zero, I<info> is deallocated, and the memory freed.  

  method gtk-recent-info-unref ( GtkRecentInfo $info )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-unref ( GtkRecentInfo $info ) {
  
  gtk_recent_info_unref(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_unref ( GtkRecentInfo $info  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-uri:
=begin pod
=head2 gtk-recent-info-get-uri

Gets the URI of the resource.

Returns: the URI of the resource. The returned string is owned by the recent manager, and should not be freed.  

  method gtk-recent-info-get-uri ( GtkRecentInfo $info -->  Str  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-uri ( GtkRecentInfo $info -->  Str  ) {
  
  gtk_recent_info_get_uri(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_uri ( GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-display-name:
=begin pod
=head2 gtk-recent-info-get-display-name

Gets the name of the resource. If none has been defined, the basename of the resource is obtained.

Returns: the display name of the resource. The returned string is owned by the recent manager, and should not be freed.  

  method gtk-recent-info-get-display-name ( GtkRecentInfo $info -->  Str  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-display-name ( GtkRecentInfo $info -->  Str  ) {
  
  gtk_recent_info_get_display_name(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_display_name ( GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-description:
=begin pod
=head2 gtk-recent-info-get-description

Gets the (short) description of the resource.

Returns: the description of the resource. The returned string is owned by the recent manager, and should not be freed.  

  method gtk-recent-info-get-description ( GtkRecentInfo $info -->  Str  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-description ( GtkRecentInfo $info -->  Str  ) {
  
  gtk_recent_info_get_description(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_description ( GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-mime-type:
=begin pod
=head2 gtk-recent-info-get-mime-type

Gets the MIME type of the resource.

Returns: the MIME type of the resource. The returned string is owned by the recent manager, and should not be freed.  

  method gtk-recent-info-get-mime-type ( GtkRecentInfo $info -->  Str  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-mime-type ( GtkRecentInfo $info -->  Str  ) {
  
  gtk_recent_info_get_mime_type(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_mime_type ( GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-added:
=begin pod
=head2 gtk-recent-info-get-added

Gets the timestamp (seconds from system’s Epoch) when the resource was added to the recently used resources list.

Returns: the number of seconds elapsed from system’s Epoch when the resource was added to the list, or -1 on failure.  

  method gtk-recent-info-get-added ( GtkRecentInfo $info --> time_t )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-added ( GtkRecentInfo $info --> time_t ) {
  
  gtk_recent_info_get_added(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_added ( GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-modified:
=begin pod
=head2 gtk-recent-info-get-modified

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last modified.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last modified, or -1 on failure.  

  method gtk-recent-info-get-modified ( GtkRecentInfo $info --> time_t )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-modified ( GtkRecentInfo $info --> time_t ) {
  
  gtk_recent_info_get_modified(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_modified ( GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-visited:
=begin pod
=head2 gtk-recent-info-get-visited

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last visited.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last visited, or -1 on failure.  

  method gtk-recent-info-get-visited ( GtkRecentInfo $info --> time_t )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-visited ( GtkRecentInfo $info --> time_t ) {
  
  gtk_recent_info_get_visited(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_visited ( GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-private-hint:
=begin pod
=head2 gtk-recent-info-get-private-hint

Gets the value of the “private” flag. Resources in the recently used list that have this flag set to C<1> should only be displayed by the applications that have registered them.

Returns: C<1> if the private flag was found, C<0> otherwise  

  method gtk-recent-info-get-private-hint ( GtkRecentInfo $info --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-private-hint ( GtkRecentInfo $info --> Int ) {
  
  gtk_recent_info_get_private_hint(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_private_hint ( GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-application-info:
=begin pod
=head2 gtk-recent-info-get-application-info

Gets the data regarding the application that has registered the resource pointed by I<info>.  If the command line contains any escape characters defined inside the storage specification, they will be expanded.

Returns: C<1> if an application with I<app_name> has registered this resource inside the recently used list, or C<0> otherwise. The I<app_exec> string is owned by the B<Gnome::Gtk3::RecentInfo> and should not be modified or freed  

  method gtk-recent-info-get-application-info ( GtkRecentInfo $info,  Str  $app_name,  CArray[Str]  $app_exec, guInt-ptr $count, time_t $time_ --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  Str  $app_name; the name of the application that has registered this item
=item  CArray[Str]  $app_exec; (transfer none) (out): return location for the string containing the command line
=item guInt-ptr $count; (out): return location for the number of times this item was registered
=item time_t $time_; (out): return location for the timestamp this item was last registered for this application

=end pod

method gtk-recent-info-get-application-info ( GtkRecentInfo $info,  Str  $app_name,  CArray[Str]  $app_exec, guInt-ptr $count, time_t $time_ --> Int ) {
  
  gtk_recent_info_get_application_info(
    self.get-native-object-no-reffing, $info, $app_name, $app_exec, $count, $time_
  );
}

sub gtk_recent_info_get_application_info ( GtkRecentInfo $info, gchar-ptr $app_name, gchar-pptr $app_exec, gugint-ptr $count, time_t $time_ --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-create-app-info:
=begin pod
=head2 gtk-recent-info-create-app-info

Creates a B<GAppInfo> for the specified B<Gnome::Gtk3::RecentInfo>

Returns: (nullable) (transfer full): the newly created B<GAppInfo>, or C<Any>. In case of error, I<error> will be set either with a C<GTK_RECENT_MANAGER_ERROR> or a C<G_IO_ERROR>

  method gtk-recent-info-create-app-info ( GtkRecentInfo $info,  Str  $app_name, N-GError $error --> GAppInfo )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  Str  $app_name; (allow-none): the name of the application that should be mapped to a B<GAppInfo>; if C<Any> is used then the default application for the MIME type is used
=item N-GError $error; (allow-none): return location for a B<GError>, or C<Any>

=end pod

method gtk-recent-info-create-app-info ( GtkRecentInfo $info,  Str  $app_name, N-GError $error --> GAppInfo ) {
  
  gtk_recent_info_create_app_info(
    self.get-native-object-no-reffing, $info, $app_name, $error
  );
}

sub gtk_recent_info_create_app_info ( GtkRecentInfo $info, gchar-ptr $app_name, N-GError $error --> GAppInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-applications:
=begin pod
=head2 gtk-recent-info-get-applications

Retrieves the list of applications that have registered this resource.

Returns: (array length=length zero-terminated=1) (transfer full): a newly allocated C<Any>-terminated array of strings. Use C<g_strfreev()> to free it.  

  method gtk-recent-info-get-applications ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC -->  CArray[Str]  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  $gsize *length G_GNUC_MALLOC; (out) (allow-none): return location for the length of the returned list

=end pod

method gtk-recent-info-get-applications ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC -->  CArray[Str]  ) {
  
  gtk_recent_info_get_applications(
    self.get-native-object-no-reffing, $info, $gsize *length G_GNUC_MALLOC
  );
}

sub gtk_recent_info_get_applications ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC --> gchar-pptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-last-application:
=begin pod
=head2 gtk-recent-info-last-application

Gets the name of the last application that have registered the recently used resource represented by I<info>.

Returns: an application name. Use C<g_free()> to free it.  

  method gtk-recent-info-last-application (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  )

=item  $GtkRecentInfo *info G_GNUC_MALLOC; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-last-application (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  ) {
  
  gtk_recent_info_last_application(
    self.get-native-object-no-reffing, $GtkRecentInfo *info G_GNUC_MALLOC
  );
}

sub gtk_recent_info_last_application (  $GtkRecentInfo *info G_GNUC_MALLOC --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-has-application:
=begin pod
=head2 gtk-recent-info-has-application

Checks whether an application registered this resource using I<app_name>.

Returns: C<1> if an application with name I<app_name> was found, C<0> otherwise  

  method gtk-recent-info-has-application ( GtkRecentInfo $info,  Str  $app_name --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  Str  $app_name; a string containing an application name

=end pod

method gtk-recent-info-has-application ( GtkRecentInfo $info,  Str  $app_name --> Int ) {
  
  gtk_recent_info_has_application(
    self.get-native-object-no-reffing, $info, $app_name
  );
}

sub gtk_recent_info_has_application ( GtkRecentInfo $info, gchar-ptr $app_name --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-groups:
=begin pod
=head2 gtk-recent-info-get-groups

Returns all groups registered for the recently used item I<info>. The array of returned group names will be C<Any> terminated, so length might optionally be C<Any>.

Returns: (array length=length zero-terminated=1) (transfer full): a newly allocated C<Any> terminated array of strings. Use C<g_strfreev()> to free it.  

  method gtk-recent-info-get-groups ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC -->  CArray[Str]  )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  $gsize *length G_GNUC_MALLOC; (out) (allow-none): return location for the number of groups returned

=end pod

method gtk-recent-info-get-groups ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC -->  CArray[Str]  ) {
  
  gtk_recent_info_get_groups(
    self.get-native-object-no-reffing, $info, $gsize *length G_GNUC_MALLOC
  );
}

sub gtk_recent_info_get_groups ( GtkRecentInfo $info,  $gsize *length G_GNUC_MALLOC --> gchar-pptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-has-group:
=begin pod
=head2 gtk-recent-info-has-group

Checks whether I<group_name> appears inside the groups registered for the recently used item I<info>.

Returns: C<1> if the group was found  

  method gtk-recent-info-has-group ( GtkRecentInfo $info,  Str  $group_name --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item  Str  $group_name; name of a group

=end pod

method gtk-recent-info-has-group ( GtkRecentInfo $info,  Str  $group_name --> Int ) {
  
  gtk_recent_info_has_group(
    self.get-native-object-no-reffing, $info, $group_name
  );
}

sub gtk_recent_info_has_group ( GtkRecentInfo $info, gchar-ptr $group_name --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-icon:
=begin pod
=head2 gtk-recent-info-get-icon

Retrieves the icon of size I<size> associated to the resource MIME type.

Returns: (nullable) (transfer full): a B<Gnome::Gdk3::Pixbuf> containing the icon, or C<Any>. Use C<g_object_unref()> when finished using the icon.  

  method gtk-recent-info-get-icon ( GtkRecentInfo $info, Int $size --> N-GObject )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>
=item Int $size; the size of the icon in pixels

=end pod

method gtk-recent-info-get-icon ( GtkRecentInfo $info, Int $size --> N-GObject ) {
  
  gtk_recent_info_get_icon(
    self.get-native-object-no-reffing, $info, $size
  );
}

sub gtk_recent_info_get_icon ( GtkRecentInfo $info, gint $size --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-gicon:
=begin pod
=head2 gtk-recent-info-get-gicon

Retrieves the icon associated to the resource MIME type.

Returns: (nullable) (transfer full): a B<GIcon> containing the icon, or C<Any>. Use C<g_object_unref()> when finished using the icon  

  method gtk-recent-info-get-gicon ( GtkRecentInfo $info --> GIcon )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-gicon ( GtkRecentInfo $info --> GIcon ) {
  
  gtk_recent_info_get_gicon(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_gicon ( GtkRecentInfo $info --> GIcon )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-short-name:
=begin pod
=head2 gtk-recent-info-get-short-name

Computes a valid UTF-8 string that can be used as the name of the item in a menu or list. For example, calling this function on an item that refers to “file:///foo/bar.txt” will yield “bar.txt”.

Returns: A newly-allocated string in UTF-8 encoding free it with C<g_free()>  

  method gtk-recent-info-get-short-name (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  )

=item  $GtkRecentInfo *info G_GNUC_MALLOC; an B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-short-name (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  ) {
  
  gtk_recent_info_get_short_name(
    self.get-native-object-no-reffing, $GtkRecentInfo *info G_GNUC_MALLOC
  );
}

sub gtk_recent_info_get_short_name (  $GtkRecentInfo *info G_GNUC_MALLOC --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-uri-display:
=begin pod
=head2 gtk-recent-info-get-uri-display

Gets a displayable version of the resource’s URI. If the resource is local, it returns a local path; if the resource is not local, it returns the UTF-8 encoded content of C<gtk_recent_info_get_uri()>.

Returns: (nullable): a newly allocated UTF-8 string containing the resource’s URI or C<Any>. Use C<g_free()> when done using it.  

  method gtk-recent-info-get-uri-display (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  )

=item  $GtkRecentInfo *info G_GNUC_MALLOC; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-uri-display (  $GtkRecentInfo *info G_GNUC_MALLOC -->  Str  ) {
  
  gtk_recent_info_get_uri_display(
    self.get-native-object-no-reffing, $GtkRecentInfo *info G_GNUC_MALLOC
  );
}

sub gtk_recent_info_get_uri_display (  $GtkRecentInfo *info G_GNUC_MALLOC --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-get-age:
=begin pod
=head2 gtk-recent-info-get-age

Gets the number of days elapsed since the last update of the resource pointed by I<info>.

Returns: a positive integer containing the number of days elapsed since the time this resource was last modified  

  method gtk-recent-info-get-age ( GtkRecentInfo $info --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-get-age ( GtkRecentInfo $info --> Int ) {
  
  gtk_recent_info_get_age(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_get_age ( GtkRecentInfo $info --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-is-local:
=begin pod
=head2 gtk-recent-info-is-local

Checks whether the resource is local or not by looking at the scheme of its URI.

Returns: C<1> if the resource is local  

  method gtk-recent-info-is-local ( GtkRecentInfo $info --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-is-local ( GtkRecentInfo $info --> Int ) {
  
  gtk_recent_info_is_local(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_is_local ( GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-exists:
=begin pod
=head2 gtk-recent-info-exists

Checks whether the resource pointed by I<info> still exists. At the moment this check is done only on resources pointing to local files.

Returns: C<1> if the resource exists  

  method gtk-recent-info-exists ( GtkRecentInfo $info --> Int )

=item GtkRecentInfo $info; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-exists ( GtkRecentInfo $info --> Int ) {
  
  gtk_recent_info_exists(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_recent_info_exists ( GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-recent-info-match:
=begin pod
=head2 gtk-recent-info-match

Checks whether two B<Gnome::Gtk3::RecentInfo>-struct point to the same resource.

Returns: C<1> if both B<Gnome::Gtk3::RecentInfo>-struct point to the same resource, C<0> otherwise  

  method gtk-recent-info-match ( GtkRecentInfo $info_a, GtkRecentInfo $info_b --> Int )

=item GtkRecentInfo $info_a; a B<Gnome::Gtk3::RecentInfo>
=item GtkRecentInfo $info_b; a B<Gnome::Gtk3::RecentInfo>

=end pod

method gtk-recent-info-match ( GtkRecentInfo $info_a, GtkRecentInfo $info_b --> Int ) {
  
  gtk_recent_info_match(
    self.get-native-object-no-reffing, $info_a, $info_b
  );
}

sub gtk_recent_info_match ( GtkRecentInfo $info_a, GtkRecentInfo $info_b --> gboolean )
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


=comment #TS:0:changed:
=head3 changed

Emitted when the current recently used resources manager changes
its contents, either by calling C<gtk_recent_manager_add_item()> or
by another application.

Since: 2.10

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
=comment #TP:0:filename:
=head3 Filename

 
The full path to the file to be used to store and read the 
recently used resources list 
 
   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<filename> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:size:
=head3 Size

 
The size of the recently used resources list. 
 
   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<size> is C<G_TYPE_INT>.
=end pod
