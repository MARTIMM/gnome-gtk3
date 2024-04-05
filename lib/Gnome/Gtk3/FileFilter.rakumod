#TL:1:Gnome::Gtk3::FileFilter:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::FileFilter

A filter for selecting a file subset

=comment ![](images/X.png)


=head1 Description

A B<Gnome::Gtk3::FileFilter> can be used to restrict the files being shown in a B<Gnome::Gtk3::FileChooser>. Files can be filtered based on their name (with C<gtk_file_filter_add_pattern()>), on their mime type (with C<gtk_file_filter_add_mime_type()>), or by a custom filter function (with C<gtk_file_filter_add_custom()>).

Filtering by mime types handles aliasing and subclassing of mime types; e.g. a filter for text/plain also matches a file with mime type application/rtf, since application/rtf is a subclass of text/plain. Note that B<Gnome::Gtk3::FileFilter> allows wildcards for the subtype of a mime type, so you can e.g. filter for image/\*.

Normally, filters are used by adding them to a B<Gnome::Gtk3::FileChooser>, see C<gtk_file_chooser_add_filter()>, but it is also possible to manually use a filter on a file with C<gtk_file_filter_filter()>.


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


=head2 See Also

B<Gnome::Gtk3::FileChooser>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::FileFilter;
  also is Gnome::GObject::InitiallyUnowned;
  also does Gnome::Gtk3::Buildable;


=head2 Uml Diagram

![](plantuml/FileFilter.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::FileFilter:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::FileFilter;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::FileFilter class process the options
    self.bless( :GtkFileFilter, |c);
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
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::GObject::InitiallyUnowned:api<1>;

use Gnome::Gtk3::Buildable:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilefilter.h
# https://developer.gnome.org/gtk3/stable/GtkFileFilter.html
unit class Gnome::Gtk3::FileFilter:auth<github:MARTIMM>:api<1>;
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

A B<N-GtkFileFilterInfo>-struct is used to pass information about the tested file to C<gtk_file_filter_filter()>.


=item B<GtkFileFilterFlags> $.contains: Flags indicating which of the following fields need are filled
=item Str $.filename: the filename of the file being tested
=item Str $.uri: the URI for the file being tested
=item Str $.display_name: the string that will be used to display the file in the file chooser
=item Str $.mime_type: the mime type of the file


=end pod

#TT:0:N-GtkFileFilterInfo:
class N-GtkFileFilterInfo is repr('CStruct') is export {
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

=head3 default, no options

Create a new plain object.

  multi method new ( )


=head3 :variant

Deserialize a file filter from an a{sv} variant in the format produced by C<to_gvariant()>.

  multi method new ( N-GObject :$variant! )


=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:1:new(:variant):
#TM:4:new(:native-object):TopLevelSupportClass
#TM:4:new(:build-id):Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::FileFilter' #`{{ or %options<GtkFileFilter> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my N-GObject() $no;
      if ? %options<variant> {
        $no = %options<variant>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_file_filter_new___x___($no);
        $no = _gtk_file_filter_new_from_gvariant($no);
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
        $no = _gtk_file_filter_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkFileFilter');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_file_filter_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_file_filter_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('file-filter-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-file-filter-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  $s = self._buildable_interface($native-sub) unless ?$s;

  self._set-class-name-of-sub('GtkFileFilter');
  $s = callsame unless ?$s;

  $s;
}

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-custom:
=begin pod
=head2 add-custom

Adds rule to a filter that allows files based on a custom callback function. The bitfield I<needed> which is passed in provides information about what sorts of information that the filter function needs; this allows GTK+ to avoid retrieving expensive information when it isn’t needed by the filter.

  method add-custom ( GtkFileFilterFlags $needed, GtkFileFilterFunc $func, Pointer $data, GDestroyNotify $notify )

=item $needed; bitfield of flags indicating the information that the custom filter function needs.
=item $func; callback function; if the function returns C<True>, then the file will be displayed.
=item $data; data to pass to I<func>
=item $notify; function to call to free I<data> when it is no longer needed.
=end pod

method add-custom (
  GtkFileFilterFlags $needed, GtkFileFilterFunc $func, Pointer $data,
  GDestroyNotify $notify
) {
  gtk_file_filter_add_custom( self._f('GtkFileFilter'), $needed, $func, $data, $notify);
}

sub gtk_file_filter_add_custom (
  N-GObject $filter, GEnum $needed, GtkFileFilterFunc $func, gpointer $data, GDestroyNotify $notify 
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:add-mime-type:
=begin pod
=head2 add-mime-type

Adds a rule allowing a given mime type to I<filter>.

  method add-mime-type ( Str $mime_type )

=item $mime_type; name of a MIME type
=end pod

method add-mime-type ( Str $mime_type ) {
  gtk_file_filter_add_mime_type( self._f('GtkFileFilter'), $mime_type);
}

sub gtk_file_filter_add_mime_type (
  N-GObject $filter, gchar-ptr $mime_type 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-pattern:
=begin pod
=head2 add-pattern

Adds a rule allowing a shell style glob to a filter.

  method add-pattern ( Str $pattern )

=item $pattern; a shell style glob
=end pod

method add-pattern ( Str $pattern ) {
  gtk_file_filter_add_pattern( self._f('GtkFileFilter'), $pattern);
}

sub gtk_file_filter_add_pattern (
  N-GObject $filter, gchar-ptr $pattern 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-pixbuf-formats:
=begin pod
=head2 add-pixbuf-formats

Adds a rule allowing image files in the formats supported by GdkPixbuf.

  method add-pixbuf-formats ( )

=end pod

method add-pixbuf-formats ( ) {
  gtk_file_filter_add_pixbuf_formats( self._f('GtkFileFilter'));
}

sub gtk_file_filter_add_pixbuf_formats (
  N-GObject $filter 
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:filter:
=begin pod
=head2 filter

Tests whether a file should be displayed according to I<filter>. The B<Gnome::Gtk3::FileFilterInfo> I<filter_info> should include the fields returned from C<get_needed()>.

This function will not typically be used by applications; it is intended principally for use in the implementation of B<Gnome::Gtk3::FileChooser>.

Returns: C<True> if the file should be displayed

  method filter ( GtkFileFilterInfo $filter_info --> Bool )

=item $filter_info; a B<Gnome::Gtk3::FileFilterInfo> containing information about a file.
=end pod

method filter ( GtkFileFilterInfo $filter_info --> Bool ) {
  gtk_file_filter_filter( self._f('GtkFileFilter'), $filter_info).Bool
}

sub gtk_file_filter_filter (
  N-GObject $filter, GtkFileFilterInfo $filter_info --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-name:
=begin pod
=head2 get-name

Gets the human-readable name for the filter. See C<set_name()>.

Returns: The human-readable name of the filter, or C<undefined>. This value is owned by GTK+ and must not be modified or freed.

  method get-name ( --> Str )

=end pod

method get-name ( --> Str ) {
  gtk_file_filter_get_name( self._f('GtkFileFilter'))
}

sub gtk_file_filter_get_name (
  N-GObject $filter --> gchar-ptr
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-needed:
=begin pod
=head2 get-needed

Gets the fields that need to be filled in for the B<Gnome::Gtk3::FileFilterInfo> passed to C<filter()>

This function will not typically be used by applications; it is intended principally for use in the implementation of B<Gnome::Gtk3::FileChooser>.

Returns: bitfield of flags indicating needed fields when calling C<filter()>

  method get-needed ( --> GtkFileFilterFlags )

=end pod

method get-needed ( --> GtkFileFilterFlags ) {
  gtk_file_filter_get_needed( self._f('GtkFileFilter'))
}

sub gtk_file_filter_get_needed (
  N-GObject $filter --> GEnum
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-name:
=begin pod
=head2 set-name

Sets the human-readable name of the filter; this is the string that will be displayed in the file selector user interface if there is a selectable list of filters.

  method set-name ( Str $name )

=item $name; the human-readable-name for the filter, or C<undefined> to remove any existing name.
=end pod

method set-name ( Str $name ) {
  gtk_file_filter_set_name( self._f('GtkFileFilter'), $name);
}

sub gtk_file_filter_set_name (
  N-GObject $filter, gchar-ptr $name 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:to-gvariant:
=begin pod
=head2 to-gvariant

Serialize a file filter to an a{sv} variant.

Returns: a new, floating, B<Gnome::Glib::Variant>

  method to-gvariant ( --> N-GObject )

=end pod

method to-gvariant ( --> N-GObject ) {
  gtk_file_filter_to_gvariant( self._f('GtkFileFilter'))
}

sub gtk_file_filter_to_gvariant (
  N-GObject $filter --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_file_filter_new:
#`{{
=begin pod
=head2 _gtk_file_filter_new

Creates a new B<Gnome::Gtk3::FileFilter> with no rules added to it. Such a filter doesn’t accept any files, so is not particularly useful until you add rules with C<add_mime_type()>, C<add_pattern()>, or C<add_custom()>. To create a filter that accepts any file, use: |[<!-- language="C" --> GtkFileFilter *filter = C<new()>; add_pattern (filter, "*"); ]|

Returns: a new B<Gnome::Gtk3::FileFilter>

  method _gtk_file_filter_new ( --> N-GObject )

=end pod
}}

sub _gtk_file_filter_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_filter_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_file_filter_new_from_gvariant:
#`{{
=begin pod
=head2 _gtk_file_filter_new_from_gvariant

Deserialize a file filter from an a{sv} variant in the format produced by C<to_gvariant()>.

Returns: a new B<Gnome::Gtk3::FileFilter> object

  method _gtk_file_filter_new_from_gvariant ( N-GObject() $variant --> N-GObject )

=item $variant; an a{sv} B<Gnome::Gio::Variant>
=end pod
}}

sub _gtk_file_filter_new_from_gvariant ( N-GObject $variant --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_file_filter_new_from_gvariant')
  { * }
