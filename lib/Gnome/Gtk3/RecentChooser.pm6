#TL:1:Gnome::Gtk3::RecentChooser:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentChooser

Interface implemented by widgets displaying recently used files

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::RecentChooser> is an interface that can be implemented by widgets
displaying the list of recently used files.  In GTK+, the main objects
that implement this interface are B<Gnome::Gtk3::RecentChooserWidget>,
B<Gnome::Gtk3::RecentChooserDialog> and B<Gnome::Gtk3::RecentChooserMenu>.

 * Recently used files are supported since GTK+ 2.10.

=head2 See Also

B<Gnome::Gtk3::RecentManager>, B<Gnome::Gtk3::RecentChooserDialog>,
B<Gnome::Gtk3::RecentChooserWidget>, B<Gnome::Gtk3::RecentChooserMenu>

=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::RecentChooser;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Error;
use Gnome::Glib::List;
use Gnome::Glib::SList;

#use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkRecentSortType

Used to specify the sorting method to be applied to the recently used resource list.

=item GTK_RECENT_SORT_NONE: Do not sort the returned list of recently used resources.
=item GTK_RECENT_SORT_MRU: Sort the returned list with the most recently used items first.
=item GTK_RECENT_SORT_LRU: Sort the returned list with the least recently used items first.
=item GTK_RECENT_SORT_CUSTOM: Sort the returned list using a custom sorting function passed using C<gtk_recent_chooser_set_sort_func()>.


=end pod

#TE:1:GtkRecentSortType:
enum GtkRecentSortType is export (
  'GTK_RECENT_SORT_NONE' => 0,
  'GTK_RECENT_SORT_MRU',
  'GTK_RECENT_SORT_LRU',
  'GTK_RECENT_SORT_CUSTOM'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkRecentChooserError

These identify the various errors that can occur while calling
B<Gnome::Gtk3::RecentChooser> functions.

=item GTK_RECENT_CHOOSER_ERROR_NOT_FOUND: Indicates that a file does not exist
=item GTK_RECENT_CHOOSER_ERROR_INVALID_URI: Indicates a malformed URI

=end pod

#TE:0:GtkRecentChooserError:
enum GtkRecentChooserError is export (
  'GTK_RECENT_CHOOSER_ERROR_NOT_FOUND',
  'GTK_RECENT_CHOOSER_ERROR_INVALID_URI'
);


#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentChooserIface

=item ___set_current_uri: Sets uri as the current URI for chooser.
=item ___get_current_uri: Gets the URI currently selected by chooser.
=item ___select_uri: Selects uri inside chooser.
=item ___unselect_uri: Unselects uri inside chooser.
=item ___select_all: Selects all the items inside chooser, if the chooser supports multiple selection.
=item ___unselect_all: Unselects all the items inside chooser.
=item ___get_items: Gets the list of recently used resources in form of B<Gnome::Gtk3::RecentInfo> objects.
=item ___get_recent_manager: Gets the B<Gnome::Gtk3::RecentManager> used by chooser.
=item ___add_filter: Adds filter to the list of B<Gnome::Gtk3::RecentFilter> objects held by chooser.
=item ___remove_filter: Removes filter from the list of B<Gnome::Gtk3::RecentFilter> objects held by chooser.
=item ___list_filters: Gets the B<Gnome::Gtk3::RecentFilter> objects held by chooser.
=item ___set_sort_func: Sets the comparison function used when sorting to be sort_func.
=item ___item_activated: Signal emitted when the user “activates” a recent item in the recent chooser.
=item ___selection_changed: Signal emitted when there is a change in the set of selected recently used resources.

=end pod

#TT:0:N-GtkRecentChooserIface:
class N-GtkRecentChooserIface is export is repr('CStruct') {
  has voi $.d		    (* item_activated)     (GtkRecentChooser  *chooser);
  has voi $.d		    (* selection_changed)  (GtkRecentChooser  *chooser);
}
}}

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::RecentChooser:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _recent_chooser_interface ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_recent_chooser_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:error-quark:
=begin pod
=head2 error-quark

Returns: The error quark used for I<Gnome::Gtk3::RecentChooser> errors.

  method error-quark ( --> UInt )

=end pod

method error-quark ( --> UInt ) {
  gtk_recent_chooser_error_quark;
}

sub gtk_recent_chooser_error_quark ( --> GQuark )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-private:
=begin pod
=head2 set-show-private

Whether to show recently used resources marked registered as private.

  method set-show-private ( Bool $show_private )

=item Bool $show_private; C<True> to show private items, C<0> otherwise

=end pod

method set-show-private ( Bool $show_private ) {

  gtk_recent_chooser_set_show_private(
    self.get-native-object-no-reffing, $show_private.Int
  );
}

sub gtk_recent_chooser_set_show_private ( N-GObject $chooser, gboolean $show_private  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-show-private:
=begin pod
=head2 get-show-private

Returns whether I<chooser> should display recently used resources registered as private.

Returns: C<True> if the recent chooser should show private items, C<False> otherwise.

  method get-show-private ( --> Bool )


=end pod

method get-show-private ( --> Bool ) {

  gtk_recent_chooser_get_show_private(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_show_private ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-not-found:
=begin pod
=head2 set-show-not-found

Sets whether I<chooser> should display the recently used resources that it didn’t find.  This only applies to local resources.

  method set-show-not-found ( Bool $show_not_found )

=item Bool $show_not_found; whether to show the local items we didn’t find

=end pod

method set-show-not-found ( Bool $show_not_found ) {

  gtk_recent_chooser_set_show_not_found(
    self.get-native-object-no-reffing, $show_not_found.Int
  );
}

sub gtk_recent_chooser_set_show_not_found ( N-GObject $chooser, gboolean $show_not_found  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-not-found:
=begin pod
=head2 get-show-not-found

Retrieves whether I<chooser> should show the recently used resources that were not found.

Returns: C<True> if the resources not found should be displayed, and C<False> otheriwse.

  method get-show-not-found ( --> Bool )


=end pod

method get-show-not-found ( --> Bool ) {

  gtk_recent_chooser_get_show_not_found(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_show_not_found ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-select-multiple:
=begin pod
=head2 set-select-multiple

Sets whether I<chooser> can select multiple items.

  method set-select-multiple ( Bool $select_multiple )

=item Bool $select_multiple; C<True> if I<chooser> can select more than one item

=end pod

method set-select-multiple ( Bool $select_multiple ) {

  gtk_recent_chooser_set_select_multiple(
    self.get-native-object-no-reffing, $select_multiple.Int
  );
}

sub gtk_recent_chooser_set_select_multiple ( N-GObject $chooser, gboolean $select_multiple  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-select-multiple:
=begin pod
=head2 get-select-multiple

Gets whether I<chooser> can select multiple items.

Returns: C<True> if I<chooser> can select more than one item.

  method get-select-multiple ( --> Bool )

=end pod

method get-select-multiple ( --> Bool ) {

  gtk_recent_chooser_get_select_multiple(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_select_multiple ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-limit:
=begin pod
=head2 set-limit

Sets the number of items that should be returned by C<gtk_recent_chooser_get_items()> and C<gtk_recent_chooser_get_uris()>.

  method set-limit ( Int $limit )

=item Int $limit; a positive integer, or -1 for all items

=end pod

method set-limit ( Int $limit ) {

  gtk_recent_chooser_set_limit(
    self.get-native-object-no-reffing, $limit
  );
}

sub gtk_recent_chooser_set_limit ( N-GObject $chooser, gint $limit  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-limit:
=begin pod
=head2 get-limit

Gets the number of items returned by C<gtk_recent_chooser_get_items()> and C<gtk_recent_chooser_get_uris()>.

Returns: A positive integer, or -1 meaning that all items are returned.

  method get-limit ( --> Int )


=end pod

method get-limit ( --> Int ) {

  gtk_recent_chooser_get_limit(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_get_limit ( N-GObject $chooser --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-local-only:
=begin pod
=head2 set-local-only

Sets whether only local resources, that is resources using the file:// URI scheme, should be shown in the recently used resources selector.  If I<local_only> is C<True> (the default) then the shown resources are guaranteed to be accessible through the operating system native file system.

  method set-local-only ( Bool $local_only )

=item Bool $local_only; C<1> if only local files can be shown

=end pod

method set-local-only ( Bool $local_only ) {

  gtk_recent_chooser_set_local_only(
    self.get-native-object-no-reffing, $local_only.Int
  );
}

sub gtk_recent_chooser_set_local_only ( N-GObject $chooser, gboolean $local_only  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-local-only:
=begin pod
=head2 get-local-only

Gets whether only local resources should be shown in the recently used resources selector.  See C<gtk_recent_chooser_set_local_only()>

Returns: C<True> if only local resources should be shown.

  method get-local-only ( --> Bool )

=end pod

method get-local-only ( --> Bool ) {

  gtk_recent_chooser_get_local_only(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_local_only ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-tips:
=begin pod
=head2 set-show-tips

Sets whether to show a tooltips containing the full path of each recently used resource in a B<Gnome::Gtk3::RecentChooser> widget.

  method set-show-tips ( Bool $show_tips )

=item Bool $show_tips; C<True> if tooltips should be shown

=end pod

method set-show-tips ( Bool $show_tips ) {

  gtk_recent_chooser_set_show_tips(
    self.get-native-object-no-reffing, $show_tips.Int
  );
}

sub gtk_recent_chooser_set_show_tips ( N-GObject $chooser, gboolean $show_tips  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-tips:
=begin pod
=head2 get-show-tips

Gets whether I<chooser> should display tooltips containing the full path of a recently user resource.

Returns: C<True> if the recent chooser should show tooltips, C<False> otherwise.

  method get-show-tips ( --> Bool )

=end pod

method get-show-tips ( --> Bool ) {

  gtk_recent_chooser_get_show_tips(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_show_tips ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-icons:
=begin pod
=head2 set-show-icons

Sets whether I<chooser> should show an icon near the resource when displaying it.

  method set-show-icons ( Bool $show_icons )

=item Bool $show_icons; whether to show an icon near the resource

=end pod

method set-show-icons ( Bool $show_icons ) {

  gtk_recent_chooser_set_show_icons(
    self.get-native-object-no-reffing, $show_icons.Int
  );
}

sub gtk_recent_chooser_set_show_icons ( N-GObject $chooser, gboolean $show_icons  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-icons:
=begin pod
=head2 get-show-icons

Retrieves whether I<chooser> should show an icon near the resource.

Returns: C<True> if the icons should be displayed, C<False> otherwise.

  method get-show-icons ( --> Bool )


=end pod

method get-show-icons ( --> Bool ) {

  gtk_recent_chooser_get_show_icons(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_recent_chooser_get_show_icons ( N-GObject $chooser --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-sort-type:
=begin pod
=head2 set-sort-type

Changes the sorting order of the recently used resources list displayed by I<chooser>.

  method set-sort-type ( GtkRecentSortType $sort_type )

=item GtkRecentSortType $sort_type; sort order that the chooser should use

=end pod

method set-sort-type ( GtkRecentSortType $sort_type ) {

  gtk_recent_chooser_set_sort_type(
    self.get-native-object-no-reffing, $sort_type.value
  );
}

sub gtk_recent_chooser_set_sort_type ( N-GObject $chooser, GEnum $sort_type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-sort-type:
=begin pod
=head2 get-sort-type

Gets the value set by C<gtk_recent_chooser_set_sort_type()>.

Returns: the sorting order of the I<chooser>.

  method get-sort-type ( --> GtkRecentSortType )

=end pod

method get-sort-type ( --> GtkRecentSortType ) {
  GtkRecentSortType(
    gtk_recent_chooser_get_sort_type(self.get-native-object-no-reffing)
  );
}

sub gtk_recent_chooser_get_sort_type ( N-GObject $chooser --> GEnum )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:set-sort-func:
=begin pod
=head2 set-sort-func

Sets the comparison function used when sorting to be I<sort_func>.  If the I<chooser> has the sort type set to B<GTK_RECENT_SORT_CUSTOM> then the chooser will sort using this function.  To the comparison function will be passed two B<Gnome::Gtk3::RecentInfo> structs and I<sort_data>;  I<sort_func> should return a positive integer if the first item comes before the second, zero if the two items are equal and a negative integer if the first item comes after the second.

  method set-sort-func ( GtkRecentSortFunc $sort_func, Pointer $sort_data, GDestroyNotify $data_destroy )

=item GtkRecentSortFunc $sort_func; the comparison function
=item Pointer $sort_data; (allow-none): user data to pass to I<sort_func>, or C<Any>
=item GDestroyNotify $data_destroy; (allow-none): destroy notifier for I<sort_data>, or C<Any>

=end pod

method set-sort-func ( GtkRecentSortFunc $sort_func, Pointer $sort_data, GDestroyNotify $data_destroy ) {

  gtk_recent_chooser_set_sort_func(
    self.get-native-object-no-reffing, $sort_func, $sort_data, $data_destroy
  );
}

sub gtk_recent_chooser_set_sort_func ( N-GObject $chooser, GtkRecentSortFunc $sort_func, gpointer $sort_data, GDestroyNotify $data_destroy  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-current-uri:
=begin pod
=head2 set-current-uri

Sets I<uri> as the current URI for I<chooser>.

Returns: C<1> if the URI was found.

  method set-current-uri (  Str  $uri, N-GError $error --> Int )

=item  Str  $uri; a URI
=item N-GError $error; (allow-none): return location for a B<GError>, or C<Any>

=end pod

method set-current-uri (  Str  $uri, N-GError $error --> Int ) {

  gtk_recent_chooser_set_current_uri(
    self.get-native-object-no-reffing, $uri, $error
  );
}

sub gtk_recent_chooser_set_current_uri ( N-GObject $chooser, gchar-ptr $uri, N-GError $error --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-uri:
=begin pod
=head2 get-current-uri

Gets the URI currently selected by I<chooser>.

Returns: a newly allocated string holding a URI.

  method get-current-uri ( -->  Str  )

=end pod

method get-current-uri ( -->  Str  ) {

  gtk_recent_chooser_get_current_uri(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_get_current_uri ( N-GObject $chooser --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-current-item:
=begin pod
=head2 get-current-item

Gets the B<Gnome::Gtk3::RecentInfo> currently selected by I<chooser>.

Returns: a B<Gnome::Gtk3::RecentInfo>.  Use C<clear-object()> when when you have finished using it.

  method get-current-item ( --> GtkRecentInfo )


=end pod

method get-current-item ( --> GtkRecentInfo ) {

  gtk_recent_chooser_get_current_item(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_get_current_item ( N-GObject $chooser --> GtkRecentInfo )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:select-uri:
=begin pod
=head2 select-uri

Selects I<uri> inside I<chooser>.

Returns: C<1> if I<uri> was found.

  method select-uri (  Str  $uri, N-GError $error --> Int )

=item  Str  $uri; a URI
=item N-GError $error; (allow-none): return location for a B<GError>, or C<Any>

=end pod

method select-uri (  Str  $uri, N-GError $error --> Int ) {

  gtk_recent_chooser_select_uri(
    self.get-native-object-no-reffing, $uri, $error
  );
}

sub gtk_recent_chooser_select_uri ( N-GObject $chooser, gchar-ptr $uri, N-GError $error --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-uri:
=begin pod
=head2 unselect-uri

Unselects I<uri> inside I<chooser>.

  method unselect-uri (  Str  $uri )

=item  Str  $uri; a URI

=end pod

method unselect-uri (  Str  $uri ) {

  gtk_recent_chooser_unselect_uri(
    self.get-native-object-no-reffing, $uri
  );
}

sub gtk_recent_chooser_unselect_uri ( N-GObject $chooser, gchar-ptr $uri  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-all:
=begin pod
=head2 select-all

Selects all the items inside I<chooser>, if the I<chooser> supports multiple selection.

  method select-all ( )


=end pod

method select-all ( ) {

  gtk_recent_chooser_select_all(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_select_all ( N-GObject $chooser  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-all:
=begin pod
=head2 unselect-all

Unselects all the items inside I<chooser>.

  method unselect-all ( )


=end pod

method unselect-all ( ) {

  gtk_recent_chooser_unselect_all(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_unselect_all ( N-GObject $chooser  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-items:
=begin pod
=head2 get-items

Gets the list of recently used resources in form of B<Gnome::Gtk3::RecentInfo> objects.  The return value of this function is affected by the “sort-type” and “limit” properties of I<chooser>.

Returns:  (element-type B<Gnome::Gtk3::RecentInfo>) (transfer full): A newly allocated list of B<Gnome::Gtk3::RecentInfo> objects.  You should use C<gtk_recent_info_unref()> on every item of the list, and then free the list itself using C<g_list_free()>.

  method get-items ( --> N-GList )


=end pod

method get-items ( --> N-GList ) {

  gtk_recent_chooser_get_items(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_get_items ( N-GObject $chooser --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uris:
=begin pod
=head2 get-uris

Gets the URI of the recently used resources.  The return value of this function is affected by the “sort-type” and “limit” properties of I<chooser>.  Since the returned array is C<Any> terminated, I<length> may be C<Any>.

Returns: (array length=length zero-terminated=1) (transfer full): A newly allocated, C<Any>-terminated array of strings. Use C<g_strfreev()> to free it.

  method get-uris ( UInt $length -->  CArray[Str]  )

=item UInt $length; (out) (allow-none): return location for a the length of the URI list, or C<Any>

=end pod

method get-uris ( UInt $length -->  CArray[Str]  ) {

  gtk_recent_chooser_get_uris(
    self.get-native-object-no-reffing, $length
  );
}

sub gtk_recent_chooser_get_uris ( N-GObject $chooser, gsize $length --> gchar-pptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-filter:
=begin pod
=head2 add-filter

Adds I<filter> to the list of B<Gnome::Gtk3::RecentFilter> objects held by I<chooser>.  If no previous filter objects were defined, this function will call C<gtk_recent_chooser_set_filter()>.

  method add-filter ( N-GObject $filter )

=item N-GObject $filter; a B<Gnome::Gtk3::RecentFilter>

=end pod

method add-filter ( $filter ) {
  #my $no = $xyz;
  #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_recent_chooser_add_filter(
    self.get-native-object-no-reffing, $filter
  );
}

sub gtk_recent_chooser_add_filter ( N-GObject $chooser, N-GObject $filter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-filter:
=begin pod
=head2 remove-filter

Removes I<filter> from the list of B<Gnome::Gtk3::RecentFilter> objects held by I<chooser>.

  method remove-filter ( N-GObject $filter )

=item N-GObject $filter; a B<Gnome::Gtk3::RecentFilter>

=end pod

method remove-filter ( $filter ) {
  #my $no = $xyz;
  #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_recent_chooser_remove_filter(
    self.get-native-object-no-reffing, $filter
  );
}

sub gtk_recent_chooser_remove_filter ( N-GObject $chooser, N-GObject $filter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-filters:
=begin pod
=head2 list-filters

Gets the B<Gnome::Gtk3::RecentFilter> objects held by I<chooser>.

Returns: (element-type B<Gnome::Gtk3::RecentFilter>) (transfer container): A singly linked list of B<Gnome::Gtk3::RecentFilter> objects.  You should just free the returned list using C<g_slist_free()>.

  method list-filters ( --> N-GSList )


=end pod

method list-filters ( --> N-GSList ) {

  gtk_recent_chooser_list_filters(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_list_filters ( N-GObject $chooser --> N-GSList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-filter:
=begin pod
=head2 set-filter

Sets I<filter> as the current B<Gnome::Gtk3::RecentFilter> object used by I<chooser> to affect the displayed recently used resources.

  method set-filter ( N-GObject $filter )

=item N-GObject $filter; (allow-none): a B<Gnome::Gtk3::RecentFilter>

=end pod

method set-filter ( $filter ) {
  #my $no = $xyz;
  #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_recent_chooser_set_filter(
    self.get-native-object-no-reffing, $filter
  );
}

sub gtk_recent_chooser_set_filter ( N-GObject $chooser, N-GObject $filter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filter:
=begin pod
=head2 get-filter

Gets the B<Gnome::Gtk3::RecentFilter> object currently used by I<chooser> to affect the display of the recently used resources.

Returns: (transfer none): a B<Gnome::Gtk3::RecentFilter> object.

  method get-filter ( --> N-GObject )


=end pod

method get-filter ( --> N-GObject ) {

  gtk_recent_chooser_get_filter(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_chooser_get_filter ( N-GObject $chooser --> N-GObject )
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


=comment #TS:0:selection-changed:
=head3 selection-changed

This signal is emitted when there is a change in the set of
selected recently used resources.  This can happen when a user
modifies the selection with the mouse or the keyboard, or when
explicitly calling functions to change the selection.

Since: 2.10

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($chooser),
    *%user-options
  );

=item $chooser; the object which received the signal


=comment #TS:0:item-activated:
=head3 item-activated

This signal is emitted when the user "activates" a recent item
in the recent chooser.  This can happen by double-clicking on an item
in the recently used resources list, or by pressing
`Enter`.

Since: 2.10

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($chooser),
    *%user-options
  );

=item $chooser; the object which received the signal


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

=comment #TP:0:recent-manager:
=head3 Recent Manager


The B<Gnome::Gtk3::RecentManager> instance used by the B<Gnome::Gtk3::RecentChooser> to
display the list of recently used resources.

   * Since: 2.10Widget type: GTK_TYPE_RECENT_MANAGER

The B<Gnome::GObject::Value> type of property I<recent-manager> is C<G_TYPE_OBJECT>.

=comment #TP:0:show-private:
=head3 Show Private


Whether this B<Gnome::Gtk3::RecentChooser> should display recently used resources
marked with the "private" flag. Such resources should be considered
private to the applications and groups that have added them.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<show-private> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:show-tips:
=head3 Show Tooltips


Whether this B<Gnome::Gtk3::RecentChooser> should display a tooltip containing the
full path of the recently used resources.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<show-tips> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:show-icons:
=head3 Show Icons


Whether this B<Gnome::Gtk3::RecentChooser> should display an icon near the item.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<show-icons> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:show-not-found:
=head3 Show Not Found


Whether this B<Gnome::Gtk3::RecentChooser> should display the recently used resources
even if not present anymore. Setting this to C<0> will perform a
potentially expensive check on every local resource (every remote
resource will always be displayed).

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<show-not-found> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:select-multiple:
=head3 Select Multiple


Allow the user to select multiple resources.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<select-multiple> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:local-only:
=head3 Local only


Whether this B<Gnome::Gtk3::RecentChooser> should display only local (file:)
resources.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<local-only> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:limit:
=head3 Limit


The maximum number of recently used resources to be displayed,
or -1 to display all items.

   * Since: 2.10
The B<Gnome::GObject::Value> type of property I<limit> is C<G_TYPE_INT>.

=comment #TP:0:sort-type:
=head3 Sort Type


Sorting order to be used when displaying the recently used resources.

   * Since: 2.10Widget type: GTK_TYPE_RECENT_SORT_TYPE

The B<Gnome::GObject::Value> type of property I<sort-type> is C<G_TYPE_ENUM>.

=comment #TP:0:filter:
=head3 Filter


The B<Gnome::Gtk3::RecentFilter> object to be used when displaying
the recently used resources.

   * Since: 2.10Widget type: GTK_TYPE_RECENT_FILTER

The B<Gnome::GObject::Value> type of property I<filter> is C<G_TYPE_OBJECT>.
=end pod
