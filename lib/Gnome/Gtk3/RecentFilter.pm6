#TL:1:Gnome::Gtk3::RecentFilter:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentFilter

A filter for selecting a subset of recently used files

=comment ![](images/X.png)

=head1 Description


A B<Gnome::Gtk3::RecentFilter> can be used to restrict the files being shown in a B<Gnome::Gtk3::RecentChooser>.

Files can be filtered based on their name (with C<add-pattern()>), on their mime type (with C<add-mime-type()>), on the application that has registered them (with C<add-application()>), or by a custom filter function (with C<add-custom()>).

Filtering by mime type handles aliasing and subclassing of mime types; e.g. a filter for text/plain also matches a file with mime type application/rtf, since application/rtf is a subclass of text/plain.

Note that B<Gnome::Gtk3::RecentFilter> allows wildcards for the subtype of a mime type, so you can e.g. filter for image/*.

Normally, filters are used by adding them to a B<Gnome::Gtk3::RecentChooser>, see C<add_filter()>, but it is also possible to manually use a filter on a file with C<filter()>.

## B<Gnome::Gtk3::RecentFilter> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::RecentFilter> implementation of the B<Gnome::Gtk3::Buildable> interface
supports adding rules using the <mime-types>, <patterns> and
<applications> elements and listing the rules within. Specifying
a <mime-type>, <pattern> or <application> has the same effect as
calling C<gtk_recent_filter_add_mime_type()>,
C<gtk_recent_filter_add_pattern()> or C<gtk_recent_filter_add_application()>.

An example of a UI definition fragment specifying B<Gnome::Gtk3::RecentFilter> rules:

  <object class="GtkRecentFilter">
    <mime-types>
      <mime-type>text/plain</mime-type>
      <mime-type>image/png</mime-type>
    </mime-types>
    <patterns>
      <pattern>*.txt</pattern>
      <pattern>*.png</pattern>
    </patterns>
    <applications>
      <application>gimp</application>
      <application>gedit</application>
      <application>glade</application>
    </applications>
  </object>



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentFilter;
  also is Gnome::GObject::InitiallyUnowned;
  also does Gnome::Gtk3::Buildable;

=head2 Uml Diagram

![](plantuml/RecentFilter.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RecentFilter;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RecentFilter;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RecentFilter class process the options
    self.bless( :GtkRecentFilter, |c);
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

use Gnome::GObject::InitiallyUnowned;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentFilter:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::InitiallyUnowned;
also does Gnome::Gtk3::Buildable;

#`{{ only indirect use from RecentChooser interface
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkRecentFilterFlags

These flags indicate what parts of a B<N-RecentFilterInfo> struct are filled or need to be filled.

=item GTK_RECENT_FILTER_URI: the URI of the file being tested
=item GTK_RECENT_FILTER_DISPLAY_NAME: the string that will be used to display the file in the recent chooser
=item GTK_RECENT_FILTER_MIME_TYPE: the mime type of the file
=item GTK_RECENT_FILTER_APPLICATION: the list of applications that have registered the file
=item GTK_RECENT_FILTER_GROUP: the groups to which the file belongs to
=item GTK_RECENT_FILTER_AGE: the number of days elapsed since the file has been registered

=end pod

# TE:0:GtkRecentFilterFlags:
enum GtkRecentFilterFlags is export (
  'GTK_RECENT_FILTER_URI'          => 1 +< 0,
  'GTK_RECENT_FILTER_DISPLAY_NAME' => 1 +< 1,
  'GTK_RECENT_FILTER_MIME_TYPE'    => 1 +< 2,
  'GTK_RECENT_FILTER_APPLICATION'  => 1 +< 3,
  'GTK_RECENT_FILTER_GROUP'        => 1 +< 4,
  'GTK_RECENT_FILTER_AGE'          => 1 +< 5
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkRecentFilterInfo

A B<Gnome::Gtk3::RecentFilterInfo> struct is used to pass information about the tested file to C<filter()>.


=item B<GFlag> $.contains: ored B<GtkRecentFilterFlags> flags to indicate which fields are set.
=item  Str  $.uri: (nullable): The URI of the file being tested.
=item  Str  $.display_name: (nullable): The string that will be used to display the file in the recent chooser.
=item  Str  $.mime_type: (nullable): MIME type of the file.
=item  CArray[Str]  $.applications: (nullable) (array zero-terminated=1): The list of applications that have registered the file.
=item  CArray[Str]  $.groups: (nullable) (array zero-terminated=1): The groups to which the file belongs to.
=item Int $.age: The number of days elapsed since the file has been registered.


=end pod

# TT:1:N-GtkRecentFilterInfo:
class N-GtkRecentFilterInfo is export is repr('CStruct') {
  has GFlag $.contains;      # GtkRecentFilterFlags
  has gchar-ptr $.uri;
  has gchar-ptr $.display_name;
  has gchar-ptr $.mime_type;
  has gchar-pptr $.applications;
  has gchar-pptr $.groups;
  has gint $.age;

  submethod BUILD (
    GFlag :$!contains = 0, Str :$uri, Str :$display_name,
    Str :$mime_type, Array :$applications, Array :$groups,
    Int :$!age
  ) {
    $!uri := $uri;
    $!display_name := $display_name;
    $!mime_type := $mime_type;
    $!applications := CArray[Str].new( |@$applications, Nil);
    $!groups := CArray[Str].new( |@$groups, Nil);
  }
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new RecentFilter object.

  multi method new ( )

=head3 :native-object

Create a RecentFilter object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RecentFilter object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentFilter' #`{{ or %options<GtkRecentFilter> }} {

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
        #$no = _gtk_recent_filter_new___x___($no);
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
        $no = _gtk_recent_filter_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkRecentFilter');

  }
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_filter_new:
#`{{
=begin pod
=head2 _gtk_recent_filter_new

Creates a new B<Gnome::Gtk3::RecentFilter> with no rules added to it. Such filter does not accept any recently used resources, so is not particularly useful until you add rules with C<gtk_recent_filter_add_pattern()>, C<gtk_recent_filter_add_mime_type()>, C<gtk_recent_filter_add_application()>, C<gtk_recent_filter_add_age()>. To create a filter that accepts any recently used resource, use: |[<!-- language="C" --> B<Gnome::Gtk3::RecentFilter> *filter = C<gtk_recent_filter_new()>; gtk_recent_filter_add_pattern (filter, "*"); ]|

Returns: a new B<Gnome::Gtk3::RecentFilter>

  method _gtk_recent_filter_new ( --> N-GObject )


=end pod
}}

sub _gtk_recent_filter_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_filter_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-name:
=begin pod
=head2 set-name

Sets the human-readable name of the filter; this is the string that will be displayed in the recently used resources selector user interface if there is a selectable list of filters.

  method set-name (  Str  $name )

=item  Str  $name; then human readable name of I<filter>

=end pod

method set-name (  Str  $name ) {

  gtk_recent_filter_set_name(
    self.get-native-object-no-reffing, $name
  );
}

sub gtk_recent_filter_set_name ( N-GObject $filter, gchar-ptr $name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-name:
=begin pod
=head2 get-name

Gets the human-readable name for the filter. See C<gtk_recent_filter_set_name()>.

Returns: (nullable): the name of the filter, or C<Any>.  The returned string is owned by the filter object and should not be freed.

  method get-name ( -->  Str  )


=end pod

method get-name ( -->  Str  ) {

  gtk_recent_filter_get_name(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_filter_get_name ( N-GObject $filter --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-mime-type:
=begin pod
=head2 add-mime-type

Adds a rule that allows resources based on their registered MIME type.

  method add-mime-type (  Str  $mime_type )

=item  Str  $mime_type; a MIME type

=end pod

method add-mime-type (  Str  $mime_type ) {

  gtk_recent_filter_add_mime_type(
    self.get-native-object-no-reffing, $mime_type
  );
}

sub gtk_recent_filter_add_mime_type ( N-GObject $filter, gchar-ptr $mime_type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-pattern:
=begin pod
=head2 add-pattern

Adds a rule that allows resources based on a pattern matching their display name.

  method add-pattern ( Str $pattern )

=item Str $pattern; a file pattern

=end pod

method add-pattern ( Str $pattern ) {
  gtk_recent_filter_add_pattern(
    self.get-native-object-no-reffing, $pattern
  );
}

sub gtk_recent_filter_add_pattern ( N-GObject $filter, gchar-ptr $pattern  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-pixbuf-formats:
=begin pod
=head2 add-pixbuf-formats

Adds a rule allowing image files in the formats supported by B<Gnome::Gdk3::Pixbuf>.

  method add-pixbuf-formats ( )

=end pod

method add-pixbuf-formats ( ) {

  gtk_recent_filter_add_pixbuf_formats(
    self.get-native-object-no-reffing,
  );
}

sub gtk_recent_filter_add_pixbuf_formats ( N-GObject $filter  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-application:
=begin pod
=head2 add-application

Adds a rule that allows resources based on the name of the application that has registered them.

  method add-application ( Str $application )

=item  Str  $application; an application name

=end pod

method add-application ( Str $application ) {

  gtk_recent_filter_add_application(
    self.get-native-object-no-reffing, $application
  );
}

sub gtk_recent_filter_add_application ( N-GObject $filter, gchar-ptr $application  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-group:
=begin pod
=head2 add-group

Adds a rule that allows resources based on the name of the group to which they belong

  method add-group ( Str $group )

=item  Str  $group; a group name

=end pod

method add-group (  Str  $group ) {

  gtk_recent_filter_add_group(
    self.get-native-object-no-reffing, $group
  );
}

sub gtk_recent_filter_add_group ( N-GObject $filter, gchar-ptr $group  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-age:
=begin pod
=head2 add-age

Adds a rule that allows resources based on their age - that is, the number of days elapsed since they were last modified.

  method add-age ( Int $days )

=item Int $days; number of days

=end pod

method add-age ( Int $days ) {

  gtk_recent_filter_add_age(
    self.get-native-object-no-reffing, $days
  );
}

sub gtk_recent_filter_add_age ( N-GObject $filter, gint $days  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-custom:
=begin pod
=head2 add-custom

Adds a rule to a filter that allows resources based on a custom callback function. The bitfield I<needed> which is passed in provides information about what sorts of information that the filter function needs; this allows GTK+ to avoid retrieving expensive information when it isn’t needed by the filter.

  method add-custom ( GtkRecentFilterFlags $needed, GtkRecentFilterFunc $func, Pointer $data, GDestroyNotify $data_destroy )

=item GtkRecentFilterFlags $needed; bitfield of flags indicating the information that the custom filter function needs.
=item GtkRecentFilterFunc $func; callback function; if the function returns C<1>, then the file will be displayed.
=item Pointer $data; data to pass to I<func>
=item GDestroyNotify $data_destroy; function to call to free I<data> when it is no longer needed.

=end pod

method add-custom ( GtkRecentFilterFlags $needed, GtkRecentFilterFunc $func, Pointer $data, GDestroyNotify $data_destroy ) {

  gtk_recent_filter_add_custom(
    self.get-native-object-no-reffing, $needed, $func, $data, $data_destroy
  );
}

sub gtk_recent_filter_add_custom ( N-GObject $filter, GtkRecentFilterFlags $needed, GtkRecentFilterFunc $func, gpointer $data, GDestroyNotify $data_destroy  )
  is native(&gtk-lib)
  { * }
}}

#`{{ only indirect use from RecentChooser interface
#-------------------------------------------------------------------------------
# TM:0:get-needed:
=begin pod
=head2 get-needed

Gets the fields that need to be filled in for the B<Gnome::Gtk3::RecentFilterInfo> passed to C<filter()>  This function will not typically be used by applications; it is intended principally for use in the implementation of B<Gnome::Gtk3::RecentChooser>.

Returns: bitfield of flags indicating needed fields when calling C<gtk_recent_filter_filter()>

  method get-needed ( --> GFlag )

=end pod

method get-needed ( --> GFlag ) {

  GtkRecentFilterFlags(
    gtk_recent_filter_get_needed(self.get-native-object-no-reffing)
  )
}

sub gtk_recent_filter_get_needed ( N-GObject $filter --> GFlag )
  is native(&gtk-lib)
  { * }
}}

#`{{ only indirect use from RecentChooser interface
#-------------------------------------------------------------------------------
# TM:1:filter:
=begin pod
=head2 filter

Tests whether a file should be displayed according to I<filter>. The B<Gnome::Gtk3::RecentFilterInfo> I<$filter_info> should include the fields returned from C<get-needed()>, and must set the C<contains> field of I<$filter_info> to indicate which fields have been set.  This function will not typically be used by applications; it is intended principally for use in the implementation of B<Gnome::Gtk3::RecentChooser>.

Returns: C<True> if the file should be displayed

  method filter ( N-GtkRecentFilterInfo $filter_info --> Bool )

=item N-GtkRecentFilterInfo $filter_info; a B<Gnome::Gtk3::RecentFilterInfo> containing information about a recently used resource

=end pod

method filter ( N-GtkRecentFilterInfo $filter_info --> Bool ) {

  gtk_recent_filter_filter(
    self.get-native-object-no-reffing, $filter_info
  ).Bool;
}

sub gtk_recent_filter_filter ( N-GObject $filter, N-GtkRecentFilterInfo $filter_info --> gboolean )
  is native(&gtk-lib)
  { * }
}}
