#TL:1:Gnome::Gtk3::RecentInfo:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentInfo

Class for recently used files information

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentInfo;
  also is Gnome::N::TopLevelClassSupport;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::Glib::Error;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentInfo:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::N::TopLevelClassSupport;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentInfo

B<N-GtkRecentInfo>-struct contains only private data and should be accessed using the provided API.

=end pod

#TT:1:N-GtkRecentInfo:
class N-GtkRecentInfo is repr('CPointer') is export { }

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods

=head2 new()
=head3 :native-object

Create a RecentInfo object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GtkRecentInfo :$native-object! )

=end pod

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::RecentInfo' {

    # check if native object is set by other parent class BUILDers
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all named arguments
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRecentInfo');
  }
}

#-------------------------------------------------------------------------------
# no ref/unref for a variant type
method native-object-ref ( $n-native-object --> N-GtkRecentInfo ) {
  _gtk_recent_info_ref($n-native-object)
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _gtk_recent_info_unref($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:1:_gtk-recent-info-ref:
#`{{
=begin pod
=head2 gtk-recent-info-ref

Increases the reference count of I<recent_info> by one.

Returns: the recent info object with its reference count increased by one

  method gtk-recent-info-ref ( N-GtkRecentInfo $info --> N-GtkRecentInfo )


=end pod

method gtk-recent-info-ref ( N-GtkRecentInfo $info --> N-GtkRecentInfo ) {
  gtk_recent_info_ref(
    self.get-native-object-no-reffing
  );
}
}}

sub _gtk_recent_info_ref ( N-GtkRecentInfo $info --> N-GtkRecentInfo )
  is native(&gtk-lib)
  is symbol('gtk_recent_info_ref')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk-recent-info-unref:
#`{{
=begin pod
=head2 gtk-recent-info-unref

Decreases the reference count of I<info> by one. If the reference count reaches zero, I<info> is deallocated, and the memory freed.

  method gtk-recent-info-unref ( N-GtkRecentInfo $info )

=end pod

method gtk-recent-info-unref ( N-GtkRecentInfo $info ) {

  gtk_recent_info_unref(
    self.get-native-object-no-reffing
  );
}
}}

sub _gtk_recent_info_unref ( N-GtkRecentInfo $info  )
  is native(&gtk-lib)
  is symbol('gtk_recent_info_unref')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-uri:
=begin pod
=head2 get-uri

Gets the URI of the resource.

Returns: the URI of the resource. The returned string is owned by the recent manager, and should not be freed.

  method get-uri ( -->  Str  )

=end pod

method get-uri ( -->  Str  ) {

  gtk_recent_info_get_uri(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_uri ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-display-name:
=begin pod
=head2 get-display-name

Gets the name of the resource. If none has been defined, the basename of the resource is obtained.

Returns: the display name of the resource. The returned string is owned by the recent manager, and should not be freed.

  method get-display-name ( -->  Str  )

=end pod

method get-display-name ( -->  Str  ) {

  gtk_recent_info_get_display_name(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_display_name ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-description:
=begin pod
=head2 get-description

Gets the (short) description of the resource.

Returns: the description of the resource. The returned string is owned by the recent manager, and should not be freed.

  method get-description ( -->  Str  )

=end pod

method get-description ( -->  Str  ) {

  gtk_recent_info_get_description(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_description ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-mime-type:
=begin pod
=head2 get-mime-type

Gets the MIME type of the resource.

Returns: the MIME type of the resource. The returned string is owned by the recent manager, and should not be freed.

  method get-mime-type ( -->  Str  )

=end pod

method get-mime-type ( -->  Str  ) {

  gtk_recent_info_get_mime_type(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_mime_type ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-added:
=begin pod
=head2 get-added

Gets the timestamp (seconds from system’s Epoch) when the resource was added to the recently used resources list.

Returns: the number of seconds elapsed from system’s Epoch when the resource was added to the list, or -1 on failure.

  method get-added ( --> Int )

=end pod

method get-added ( --> Int ) {

  gtk_recent_info_get_added(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_added ( N-GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-modified:
=begin pod
=head2 get-modified

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last modified.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last modified, or -1 on failure.

  method get-modified ( --> Int )

=end pod

method get-modified ( --> Int ) {

  gtk_recent_info_get_modified(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_modified ( N-GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-visited:
=begin pod
=head2 get-visited

Gets the timestamp (seconds from system’s Epoch) when the meta-data for the resource was last visited.

Returns: the number of seconds elapsed from system’s Epoch when the resource was last visited, or -1 on failure.

  method get-visited ( --> Int )

=end pod

method get-visited ( --> Int ) {

  gtk_recent_info_get_visited(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_visited ( N-GtkRecentInfo $info --> time_t )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-private-hint:
=begin pod
=head2 get-private-hint

Gets the value of the “private” flag. Resources in the recently used list that have this flag set to C<True> should only be displayed by the applications that have registered them.

Returns: C<True> if the private flag was found, C<False> otherwise

  method get-private-hint ( --> Bool )

=end pod

method get-private-hint ( --> Bool ) {

  gtk_recent_info_get_private_hint(
    self.get-native-object-no-reffing
  ).Bool;
}

sub gtk_recent_info_get_private_hint ( N-GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-application-info:
=begin pod
=head2 get-application-info

Gets the data regarding the application that has registered the resource. If the command line contains any escape characters defined inside the storage specification, they will be expanded.

if an application with I<app_name> has registered this resource inside the recently used list a 3 element B<List> is returned. An empty list is returned otherwise.

  method get-application-info ( Str $app_name --> List )

=item Str $app_name; the name of the application that has registered this item

The returned list holds;
=item Str $app_exec; the string containing the command line
=item UInt $count; the number of times this item was registered
=item Int $time; the timestamp this item was last registered for this application

=end pod

method get-application-info ( Str $app_name --> List ) {
  my CArray[Str] $app_exec .= new(Nil);
  my guint $count;
  my time_t $time;
  my Int $r = gtk_recent_info_get_application_info(
    self.get-native-object-no-reffing, $app_name, $app_exec, $count, $time
  );

  $r ?? ( $app_exec[0], $count.Int, $time.Int) !! ()
}

sub gtk_recent_info_get_application_info (
  N-GtkRecentInfo $info, gchar-ptr $app_name, gchar-pptr $app_exec is rw,
  guint $count is rw, time_t $time is rw
  --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:create-app-info:
=begin pod
=head2 create-app-info

Creates a B<GAppInfo> for the specified B<Gnome::Gtk3::RecentInfo>

Returns: (nullable) (transfer full): the newly created B<GAppInfo>, or C<Any>. In case of error, I<error> will be set either with a C<GTK_RECENT_MANAGER_ERROR> or a C<G_IO_ERROR>

  method create-app-info ( Str  $app_name, N-GError $error --> GAppInfo )

=item  Str  $app_name; (allow-none): the name of the application that should be mapped to a B<GAppInfo>; if C<Any> is used then the default application for the MIME type is used
=item N-GError $error; (allow-none): return location for a B<GError>, or C<Any>

=end pod

method create-app-info ( Str  $app_name, N-GError $error --> GAppInfo ) {

  gtk_recent_info_create_app_info(
    self.get-native-object-no-reffing, $app_name, $error
  );
}

sub gtk_recent_info_create_app_info ( N-GtkRecentInfo $info, gchar-ptr $app_name, N-GError $error --> GAppInfo )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-applications:
=begin pod
=head2 get-applications

Retrieves the list of applications that have registered this resource.

Returns: an array of strings.

  method get-applications ( --> Array )

=end pod

method get-applications ( --> Array ) {

  my CArray[Str] $a = gtk_recent_info_get_applications(
    self.get-native-object-no-reffing, my gsize $length
  );

  my Array $apps = [];
  for ^$length -> $i {
    $apps[$i] = $a[$i];
  }

  $apps
}

sub gtk_recent_info_get_applications (
  N-GtkRecentInfo $info, gsize $length is rw --> gchar-pptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:last-application:
=begin pod
=head2 last-application

Gets the name of the last application that have registered the recently used resource represented by I<info>.

Returns: an application name.

  method last-application ( --> Str )

=end pod

method last-application ( --> Str ) {
  gtk_recent_info_last_application(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_last_application ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:has-application:
=begin pod
=head2 has-application

Checks whether an application registered this resource using I<$app_name>.

Returns: C<True> if an application with name I<$app_name> was found, C<False> otherwise

  method has-application ( Str  $app_name --> Bool )

=item  Str  $app_name; a string containing an application name

=end pod

method has-application ( Str  $app_name --> Bool ) {

  gtk_recent_info_has_application(
    self.get-native-object-no-reffing, $app_name
  ).Bool;
}

sub gtk_recent_info_has_application ( N-GtkRecentInfo $info, gchar-ptr $app_name --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-groups:
=begin pod
=head2 get-groups

Returns all groups registered for the recently used item I<info>.

  method get-groups ( --> Array )

=end pod

method get-groups ( --> Array ) {

  my CArray $a = gtk_recent_info_get_groups(
    self.get-native-object-no-reffing, my gsize $length
  );

  my Array $grps = [];
  for ^$length -> $i {
    $grps[$i] = $a[$i];
  }

  $grps
}

sub gtk_recent_info_get_groups (
  N-GtkRecentInfo $info, gsize $length is rw --> gchar-pptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:has-group:
=begin pod
=head2 has-group

Checks whether I<group_name> appears inside the groups registered for the recently used item I<info>.

Returns: C<True> if the group was found

  method has-group ( Str  $group_name --> Bool )

=item  Str  $group_name; name of a group

=end pod

method has-group ( Str  $group_name --> Bool ) {

  gtk_recent_info_has_group(
    self.get-native-object-no-reffing, $group_name
  ).Bool;
}

sub gtk_recent_info_has_group ( N-GtkRecentInfo $info, gchar-ptr $group_name --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-icon:
=begin pod
=head2 get-icon

Retrieves the icon of size I<size> associated to the resource MIME type.

Returns: (nullable) (transfer full): a B<Gnome::Gdk3::Pixbuf> containing the icon, or C<Any>. Use C<clear-object()> when finished using the icon.

  method get-icon ( Int $size --> N-GObject )

=item Int $size; the size of the icon in pixels

=end pod

method get-icon ( Int $size --> N-GObject ) {

  gtk_recent_info_get_icon(
    self.get-native-object-no-reffing, $size
  );
}

sub gtk_recent_info_get_icon ( N-GtkRecentInfo $info, gint $size --> N-GObject )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-gicon:
=begin pod
=head2 get-gicon

Retrieves the icon associated to the resource MIME type.

Returns: (nullable) (transfer full): a B<GIcon> containing the icon, or C<Any>. Use C<g_object_unref()> when finished using the icon

  method get-gicon ( --> GIcon )

=end pod

method get-gicon ( --> GIcon ) {

  gtk_recent_info_get_gicon(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_gicon ( N-GtkRecentInfo $info --> GIcon )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-short-name:
=begin pod
=head2 get-short-name

Computes a valid UTF-8 string that can be used as the name of the item in a menu or list. For example, calling this function on an item that refers to “file:///foo/bar.txt” will yield “bar.txt”.

Returns: A newly-allocated string in UTF-8 encoding.

  method get-short-name ( --> Str )

=end pod

method get-short-name ( --> Str ) {

  gtk_recent_info_get_short_name(
    self.get-native-object-no-reffing
  )
}

sub gtk_recent_info_get_short_name ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-uri-display:
=begin pod
=head2 get-uri-display

Gets a displayable version of the resource’s URI. If the resource is local, it returns a local path; if the resource is not local, it returns the UTF-8 encoded content of C<get-uri()>.

Returns: (nullable): a newly allocated UTF-8 string containing the resource’s URI or C<Any>. Use C<g_free()> when done using it.

  method get-uri-display ( --> Str )

=end pod

method get-uri-display ( --> Str ) {

  gtk_recent_info_get_uri_display(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_uri_display ( N-GtkRecentInfo $info --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-age:
=begin pod
=head2 get-age

Gets the number of days elapsed since the last update of the resource pointed by I<info>.

Returns: a positive integer containing the number of days elapsed since the time this resource was last modified

  method get-age ( --> Int )

=end pod

method get-age ( --> Int ) {

  gtk_recent_info_get_age(
    self.get-native-object-no-reffing
  );
}

sub gtk_recent_info_get_age ( N-GtkRecentInfo $info --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-local:
=begin pod
=head2 is-local

Checks whether the resource is local or not by looking at the scheme of its URI.

Returns: C<True> if the resource is local

  method is-local ( --> Bool )

=end pod

method is-local ( --> Bool ) {

  gtk_recent_info_is_local(
    self.get-native-object-no-reffing
  ).Bool;
}

sub gtk_recent_info_is_local ( N-GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:exists:
=begin pod
=head2 exists

Checks whether the resource still exists. At the moment this check is done only on resources pointing to local files.

Returns: C<True> if the resource exists

  method exists ( --> Bool )

=end pod

method exists ( --> Bool ) {

  gtk_recent_info_exists(
    self.get-native-object-no-reffing
  ).Bool;
}

sub gtk_recent_info_exists ( N-GtkRecentInfo $info --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:match:
=begin pod
=head2 match

Checks whether two B<Gnome::Gtk3::RecentInfo>-struct point to the same resource.

Returns: C<True> if both B<Gnome::Gtk3::RecentInfo>-struct point to the same resource, C<False> otherwise.

  method match ( N-GtkRecentInfo $info --> Bool )

=item N-GtkRecentInfo $info; a native B<Gnome::Gtk3::RecentInfo> object.

=end pod

method match ( $info --> Bool ) {

  my $no = $info;
  $no .= get-native-object-no-reffing unless $info ~~ N-GtkRecentInfo;
  gtk_recent_info_match(
    self.get-native-object-no-reffing, $no
  ).Bool;
}

sub gtk_recent_info_match (
  N-GtkRecentInfo $info_a, N-GtkRecentInfo $info_b --> gboolean
) is native(&gtk-lib)
  { * }
