#TL:1:Gnome::Gtk3::FileFilter:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::FileFilter

A filter for selecting a file subset

=comment ![](images/X.png)

=head1 Description

A B<Gnome::Gtk3::FileFilter> can be used to restrict the files being shown in a
B<Gnome::Gtk3::FileChooser>. Files can be filtered based on their name (with
C<gtk_file_filter_add_pattern()>), on their mime type (with
C<gtk_file_filter_add_mime_type()>), or by a custom filter function
(with C<gtk_file_filter_add_custom()>).

Filtering by mime types handles aliasing and subclassing of mime
types; e.g. a filter for text/plain also matches a file with mime
type application/rtf, since application/rtf is a subclass of
text/plain. Note that B<Gnome::Gtk3::FileFilter> allows wildcards for the
subtype of a mime type, so you can e.g. filter for image/\*.

Normally, filters are used by adding them to a B<Gnome::Gtk3::FileChooser>,
see C<gtk_file_chooser_add_filter()>, but it is also possible
to manually use a filter on a file with C<gtk_file_filter_filter()>.


=head2 B<Gnome::Gtk3::FileFilter> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::FileFilter> implementation of the B<Gnome::Gtk3::Buildable> interface supports adding rules using the <mime-types>, <patterns> and <applications> elements and listing the rules within. Specifying a <mime-type> or <pattern> has the same effect as calling C<gtk_file_filter_add_mime_type()> or C<gtk_file_filter_add_pattern()>.

An example of a UI definition fragment specifying B<Gnome::Gtk3::FileFilter>
rules:

  <object class="GtkFileFilter>">
    <mime-types>
      <mime-type>text/plain</mime-type>
      <mime-type>image/ *</mime-type>
    </mime-types>
    <patterns>
      <pattern>*.txt</pattern>
      <pattern>*.png</pattern>
    </patterns>
  </object>

=head2 Implemented Interfaces

Gnome::Gtk3::FileFilter implements
=item [Gnome::Gtk3::Buildable](Buildable.html)

=head2 See Also

B<Gnome::Gtk3::FileChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::FileFilter;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::InitiallyUnowned;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilefilter.h
# https://developer.gnome.org/gtk3/stable/GtkFileFilter.html
unit class Gnome::Gtk3::FileFilter:auth<github:MARTIMM>;
also is Gnome::GObject::InitiallyUnowned;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkFileFilterFlags

These flags indicate what parts of a B<Gnome::Gtk3::FileFilterInfo> struct
are filled or need to be filled.


=item GTK_FILE_FILTER_FILENAME: the filename of the file being tested
=item GTK_FILE_FILTER_URI: the URI for the file being tested
=item GTK_FILE_FILTER_DISPLAY_NAME: the string that will be used to  display the file in the file chooser
=item GTK_FILE_FILTER_MIME_TYPE: the mime type of the file


=end pod

#TE:0:GtkFileFilterFlags:
enum GtkFileFilterFlags is export (
  GTK_FILE_FILTER_FILENAME     => 0x01,
  GTK_FILE_FILTER_URI          => 0x02,
  GTK_FILE_FILTER_DISPLAY_NAME => 0x04,
  GTK_FILE_FILTER_MIME_TYPE    => 0x08,
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkFileFilterInfo

A B<Gnome::Gtk3::FileFilterInfo>-struct is used to pass information about the
tested file to C<gtk_file_filter_filter()>.


=item B<Gnome::Gtk3::FileFilterFlags> $.contains: Flags indicating which of the following fields need are filled
=item Str $.filename: the filename of the file being tested
=item Str $.uri: the URI for the file being tested
=item Str $.display_name: the string that will be used to display the file in the file chooser
=item Str $.mime_type: the mime type of the file


=end pod

#TT:0:N-GtkFileFilterInfo:
class GtkFileFilterInfo is repr('CStruct') is export {
  # contains: flags indicating which of the following fields need are filled
  has int32 $.contains;          # bits from GtkFileFilterFlags
  has Str $.filename;
  has Str $.uri;
  has Str $.display_name;
  has Str $.mime_type;
}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::FileFilter';

  if ? %options<empty> {
    self.native-gobject(gtk_file_filter_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkFileFilter');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_file_filter_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkFileFilter');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_file_filter_new:
=begin pod
=head2 gtk_file_filter_new

Creates a new B<Gnome::Gtk3::FileFilter> with no rules added to it.
Such a filter doesn’t accept any files, so is not
particularly useful until you add rules with
C<gtk_file_filter_add_mime_type()>, C<gtk_file_filter_add_pattern()>,
or C<gtk_file_filter_add_custom()>. To create a filter
that accepts any file, use:

  my Gnome::Gtk3::FileFilter $filter .= new(:empty);
  $filter.add-pattern("*");

Returns: a new B<Gnome::Gtk3::FileFilter>

Since: 2.4

  method gtk_file_filter_new ( --> N-GObject  )

=end pod

sub gtk_file_filter_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_file_filter_set_name:
=begin pod
=head2 [gtk_file_filter_] set_name

Sets the human-readable name of the filter; this is the string
that will be displayed in the file selector user interface if
there is a selectable list of filters.

Since: 2.4

  method gtk_file_filter_set_name ( Str $name )

=item Str $name; (allow-none): the human-readable-name for the filter, or C<Any> to remove any existing name.

=end pod

sub gtk_file_filter_set_name ( N-GObject $filter, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_file_filter_get_name:
=begin pod
=head2 [gtk_file_filter_] get_name

Gets the human-readable name for the filter. See C<gtk_file_filter_set_name()>.

Returns: (nullable): The human-readable name of the filter,
or C<Any>. This value is owned by GTK+ and must not
be modified or freed.

Since: 2.4

  method gtk_file_filter_get_name ( --> Str  )


=end pod

sub gtk_file_filter_get_name ( N-GObject $filter )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_add_mime_type:
=begin pod
=head2 [gtk_file_filter_] add_mime_type

Adds a rule allowing a given mime type to I<filter>.

Since: 2.4

  method gtk_file_filter_add_mime_type ( Str $mime_type )

=item Str $mime_type; name of a MIME type

=end pod

sub gtk_file_filter_add_mime_type ( N-GObject $filter, Str $mime_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_add_pattern:
=begin pod
=head2 [gtk_file_filter_] add_pattern

Adds a rule allowing a shell style glob to a filter.

Since: 2.4

  method gtk_file_filter_add_pattern ( Str $pattern )

=item Str $pattern; a shell style glob

=end pod

sub gtk_file_filter_add_pattern ( N-GObject $filter, Str $pattern )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_add_pixbuf_formats:
=begin pod
=head2 [gtk_file_filter_] add_pixbuf_formats

Adds a rule allowing image files in the formats supported
by B<Gnome::Gdk3::Pixbuf>.

Since: 2.6

  method gtk_file_filter_add_pixbuf_formats ( )


=end pod

sub gtk_file_filter_add_pixbuf_formats ( N-GObject $filter )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_add_custom:
=begin pod
=head2 [gtk_file_filter_] add_custom

Adds rule to a filter that allows files based on a custom callback
function. The bitfield I<needed> which is passed in provides information
about what sorts of information that the filter function needs;
this allows GTK+ to avoid retrieving expensive information when
it isn’t needed by the filter.

Since: 2.4

  method gtk_file_filter_add_custom ( GtkFileFilterFlags $needed, GtkFileFilterFunc $func, Pointer $data, GDestroyNotify $notify )

=item GtkFileFilterFlags $needed; bitfield of flags indicating the information that the custom filter function needs.
=item GtkFileFilterFunc $func; callback function; if the function returns C<1>, then the file will be displayed.
=item Pointer $data; data to pass to I<func>
=item GDestroyNotify $notify; function to call to free I<data> when it is no longer needed.

=end pod

sub gtk_file_filter_add_custom ( N-GObject $filter, int32 $needed, GtkFileFilterFunc $func, Pointer $data, GDestroyNotify $notify )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_get_needed:
=begin pod
=head2 [gtk_file_filter_] get_needed

Gets the fields that need to be filled in for the B<Gnome::Gtk3::FileFilterInfo>
passed to C<gtk_file_filter_filter()>

This function will not typically be used by applications; it
is intended principally for use in the implementation of
B<Gnome::Gtk3::FileChooser>.

Returns: bitfield of flags indicating needed fields when
calling C<gtk_file_filter_filter()>

Since: 2.4

  method gtk_file_filter_get_needed ( --> GtkFileFilterFlags  )


=end pod

sub gtk_file_filter_get_needed ( N-GObject $filter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_filter:
=begin pod
=head2 gtk_file_filter_filter

Tests whether a file should be displayed according to I<filter>.
The B<Gnome::Gtk3::FileFilterInfo> I<filter_info> should include
the fields returned from C<gtk_file_filter_get_needed()>.

This function will not typically be used by applications; it
is intended principally for use in the implementation of
B<Gnome::Gtk3::FileChooser>.

Returns: C<1> if the file should be displayed

Since: 2.4

  method gtk_file_filter_filter ( GtkFileFilterInfo $filter_info --> Int  )

=item GtkFileFilterInfo $filter_info; a B<Gnome::Gtk3::FileFilterInfo> containing information about a file.

=end pod

sub gtk_file_filter_filter ( N-GObject $filter, GtkFileFilterInfo $filter_info )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_to_gvariant:
=begin pod
=head2 [gtk_file_filter_] to_gvariant

Serialize a file filter to an a{sv} variant.

Returns: (transfer none): a new, floating, B<GVariant>

Since: 3.22

  method gtk_file_filter_to_gvariant ( --> N-GObject  )


=end pod

sub gtk_file_filter_to_gvariant ( N-GObject $filter )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_filter_new_from_gvariant:
=begin pod
=head2 [gtk_file_filter_] new_from_gvariant

Deserialize a file filter from an a{sv} variant in
the format produced by C<gtk_file_filter_to_gvariant()>.

Returns: (transfer full): a new B<Gnome::Gtk3::FileFilter> object

Since: 3.22

  method gtk_file_filter_new_from_gvariant ( N-GObject $variant --> N-GObject  )

=item N-GObject $variant; an a{sv} B<GVariant>

=end pod

sub gtk_file_filter_new_from_gvariant ( N-GObject $variant )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}
























=finish
#-------------------------------------------------------------------------------
sub gtk_file_filter_new ( )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_set_name ( N-GObject $filter, Str $name)
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_get_name ( N-GObject $filter )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_mime_type ( N-GObject $filter, Str $mime_type)
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_pattern ( N-GObject $filter, Str $pattern )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_pixbuf_formats ( N-GObject $filter )
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_add_custom (
  N-GObject $filter, int32 $filter-flags-needed,
  &filter-func ( GtkFileFilterInfo $filter_info, OpaquePointer),
  OpaquePointer, &notify ( OpaquePointer )
) is native(&gtk-lib)
  { * }

sub gtk_file_filter_get_needed ( N-GObject $filter )
  returns int32 # GtkFileFilterFlags
  is native(&gtk-lib)
  { * }

sub gtk_file_filter_filter ( N-GObject $filter, int32 $filter_info )
  is native(&gtk-lib)
  { * }
