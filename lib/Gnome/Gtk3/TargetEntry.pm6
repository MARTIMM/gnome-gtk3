#TL:1:Gnome::Gtk3::TargetEntry:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TargetEntry

Functions for handling inter-process communication

=comment ![](images/X.png)

=head1 Description

    via selections
    signals for B<Gnome::Gtk3::Widget>. In particular, if you are using the functions
    in this section, you may need to pay attention to
     I<selection-get>,  I<selection-received> and
     I<selection-clear-event> signals

The selection mechanism provides the basis for different types
of communication between processes. In particular, drag and drop and
B<Gnome::Gtk3::Clipboard> work via selections. You will very seldom or
never need to use most of the functions in this section directly;
B<Gnome::Gtk3::Clipboard> provides a nicer interface to the same functionality.

If an application is expected to exchange image data and work
on Windows, it is highly advised to support at least "image/bmp" target
for the widest possible compatibility with third-party applications.
B<Gnome::Gtk3::Clipboard> already does that by using C<gtk-target-list-add-image-targets()>
and C<gtk-selection-data-set-pixbuf()> or C<gtk-selection-data-get-pixbuf()>,
which is one of the reasons why it is advised to use B<Gnome::Gtk3::Clipboard>.

Some of the datatypes defined this section are used in
the B<Gnome::Gtk3::Clipboard> and drag-and-drop API’s as well. The
B<Gnome::Gtk3::TargetEntry> and B<Gnome::Gtk3::TargetList> objects represent
lists of data types that are supported when sending or
receiving data. The B<Gnome::Gtk3::SelectionData> object is used to
store a chunk of data along with the data type and other
 * associated information.

=head2 See Also

B<Gnome::Gtk3::Widget> - Much of the operation of selections happens via

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TargetEntry;
  also is Gnome::GObject::Boxed;

=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::TargetEntry;

  unit class MyGuiClass;
  also is Gnome::Gtk3::TargetEntry;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::TargetEntry class process the options
    self.bless( :GtkTargetEntry, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TargetEntry:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTargetFlags

The GtkTargetFlag> enumeration is used to specify constraints on a N-GtkTargetEntry.

=item GTK_TARGET_SAME_APP: If this is set, the target will only be selected for drags within a single application.
=item GTK_TARGET_SAME_WIDGET: If this is set, the target will only be selected for drags within a single widget.
=item GTK_TARGET_OTHER_APP: If this is set, the target will not be selected for drags within a single application.
=item GTK_TARGET_OTHER_WIDGET: If this is set, the target will not be selected for drags withing a single widget.

=end pod

#TE:1:GtkTargetFlags:
enum GtkTargetFlags is export (
  'GTK_TARGET_SAME_APP' => 1 +< 0,
  'GTK_TARGET_SAME_WIDGET' => 1 +< 1,
  'GTK_TARGET_OTHER_APP' => 1 +< 2,
  'GTK_TARGET_OTHER_WIDGET' => 1 +< 3,
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTargetPair

A N-GtkTargetPair is used to represent the same information as a table of N-GtkTargetEntry, but in an efficient form.

=item N-GObject $.target: a native B<Gnome::Gtk3::Atom> representation of the target type.
=item UInt $.flags: flags from enum GtkTargetFlags for DND
=item UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the  I<selection-get> signal. It allows the application to identify the target type without extensive string compares.
=end pod

# TT:0:N-GtkTargetPair:
class N-GtkTargetPair is export is repr('CStruct') {
  has N-GObject $.target;  # a native Gnome::Gdk3::Atom
  has guint $.flags;
  has guint $.info;

  submethod BUILD ( :$target, :$!flags, :$!info ) {
    my $no = $target;
    $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
    $!target = $no;
  }
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTargetEntry

A N-GtkTargetEntry represents a single type of data than can be supplied for by a widget for a selection or for supplied or received during drag-and-drop.

=item Str $.target: a string representation of the target type
=item UInt $.flags: GtkTargetFlags for DND
=item UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the  I<selection-get> signal. It allows the application to identify the target type without extensive string compares.
=end pod

#TT:0:N-GtkTargetEntry:
class N-GtkTargetEntry is export is repr('CStruct') {
  has gchar-ptr $.target;
  has guint $.flags;
  has guint $.info;

  submethod BUILD ( Str :$!target, :$!flags, :$!info ) { };
}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :target, :flags, :info

Makes a new B<Gnome::Gtk3::TargetEntry>.

  multi method new ( Str :$target!, UInt :$flags!, UInt :$info! )

=item Str $target; String identifier for target
=item UInt $flags; Set of flags of enum GtkTargetFlags
=item UInt $info; an ID that will be passed back to the application

=head3 :native-object

Create a TargetEntry object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:target,:flags,:info):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TargetEntry' #`{{ or %options<GtkTargetEntry> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
#    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if %options<target>:exists and %options<flags>:exists and %options<info>:exists {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_target_entry_new(
          %options<target>, %options<flags>, %options<info>
        );
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_target_entry_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkTargetEntry');
  }
}

#-------------------------------------------------------------------------------
# no ref/unref
method native-object-ref ( $n-native-object --> Any ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
#note'value cleared';
  _gtk_target_entry_free($n-native-object)
}


#-------------------------------------------------------------------------------
#TM:1:copy:
=begin pod
=head2 copy

Makes a copy of a B<Gnome::Gtk3::TargetEntry> and its data.

Returns: a pointer to a copy of I<data>. Free with C<free()>

  method copy ( --> N-GtkTargetEntry )

=end pod

method copy ( --> N-GtkTargetEntry ) {
  gtk_target_entry_copy(self.get-native-object-no-reffing)
}

sub gtk_target_entry_copy (
  N-GtkTargetEntry $data --> N-GtkTargetEntry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_entry_free:
#`{{
=begin pod
=head2 free

Frees a B<Gnome::Gtk3::TargetEntry> returned from C<new()> or C<gtk-target-entry-copy()>.

  method free ( )

=end pod

method free ( ) {

  gtk_target_entry_free(
    self._f('GtkTargetEntry'),
  );
}
}}

sub _gtk_target_entry_free (
  N-GtkTargetEntry $data
) is native(&gtk-lib)
  is symbol('gtk_target_entry_free')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk-selection-add-target:
=begin pod
=head2 gtk-selection-add-target

Appends a specified target to the list of supported targets for a given widget and selection.

  method gtk-selection-add-target ( N-GObject $widget, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, UInt $info )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; the selection
=item Gnome::Gdk3::Atom $target; target to add.
=item UInt $info; A unsigned integer which will be passed back to the application.
=end pod

method gtk-selection-add-target ( $widget is copy, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, UInt $info ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_add_target(
    self._f('GtkTargetEntry'), $widget, $selection, $target, $info
  );
}

sub gtk_selection_add_target (
  N-GObject $widget, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-add-targets:
=begin pod
=head2 gtk-selection-add-targets

Prepends a table of targets to the list of supported targets for a given widget and selection.

  method gtk-selection-add-targets ( N-GObject $widget, Gnome::Gdk3::Atom $selection, GtkTargetEntry $targets, UInt $ntargets )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; the selection
=item GtkTargetEntry $targets; (array length=ntargets): a table of targets to add
=item UInt $ntargets; number of entries in I<targets>
=end pod

method gtk-selection-add-targets ( $widget is copy, Gnome::Gdk3::Atom $selection, GtkTargetEntry $targets, UInt $ntargets ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_add_targets(
    self._f('GtkTargetEntry'), $widget, $selection, $targets, $ntargets
  );
}

sub gtk_selection_add_targets (
  N-GObject $widget, Gnome::Gdk3::Atom $selection, GtkTargetEntry $targets, guint $ntargets
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-clear-targets:
=begin pod
=head2 gtk-selection-clear-targets

Remove all targets registered for the given selection for the widget.

  method gtk-selection-clear-targets ( N-GObject $widget, Gnome::Gdk3::Atom $selection )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; an atom representing a selection
=end pod

method gtk-selection-clear-targets ( $widget is copy, Gnome::Gdk3::Atom $selection ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_clear_targets(
    self._f('GtkTargetEntry'), $widget, $selection
  );
}

sub gtk_selection_clear_targets (
  N-GObject $widget, Gnome::Gdk3::Atom $selection
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-convert:
=begin pod
=head2 gtk-selection-convert

Requests the contents of a selection. When received, a “selection-received” signal will be generated.

Returns: C<True> if requested succeeded. C<False> if we could not process request. (e.g., there was already a request in process for this widget).

  method gtk-selection-convert ( N-GObject $widget, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, UInt $time_ --> Bool )

=item N-GObject $widget; The widget which acts as requestor
=item Gnome::Gdk3::Atom $selection; Which selection to get
=item Gnome::Gdk3::Atom $target; Form of information desired (e.g., STRING)
=item UInt $time_; Time of request (usually of triggering event)
=end pod

method gtk-selection-convert ( $widget is copy, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, UInt $time_ --> Bool ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_convert(
    self._f('GtkTargetEntry'), $widget, $selection, $target, $time_
  ).Bool
}

sub gtk_selection_convert (
  N-GObject $widget, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target, guint32 $time_ --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-copy:
=begin pod
=head2 gtk-selection-data-copy

Makes a copy of a B<Gnome::Gtk3::SelectionData>-struct and its data.

Returns: a pointer to a copy of I<data>.

  method gtk-selection-data-copy ( GtkSelectionData $data --> GtkSelectionData )

=item GtkSelectionData $data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-copy ( GtkSelectionData $data --> GtkSelectionData ) {

  gtk_selection_data_copy(
    self._f('GtkTargetEntry'), $data
  )
}

sub gtk_selection_data_copy (
  GtkSelectionData $data --> GtkSelectionData
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-free:
=begin pod
=head2 gtk-selection-data-free

Frees a B<Gnome::Gtk3::SelectionData>-struct returned from C<gtk-selection-data-copy()>.

  method gtk-selection-data-free ( GtkSelectionData $data )

=item GtkSelectionData $data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-free ( GtkSelectionData $data ) {

  gtk_selection_data_free(
    self._f('GtkTargetEntry'), $data
  );
}

sub gtk_selection_data_free (
  GtkSelectionData $data
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-data:
=begin pod
=head2 gtk-selection-data-get-data

Retrieves the raw data of the selection.

Returns: (array) (element-type guint8): the raw data of the selection.

  method gtk-selection-data-get-data ( GtkSelectionData $selection_data --> guStr )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-data ( GtkSelectionData $selection_data --> guStr ) {

  gtk_selection_data_get_data(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_data (
  GtkSelectionData $selection_data --> gugchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-data-type:
=begin pod
=head2 gtk-selection-data-get-data-type

Retrieves the data type of the selection.

Returns: the data type of the selection.

  method gtk-selection-data-get-data-type ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-data-type ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom ) {

  gtk_selection_data_get_data_type(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_data_type (
  GtkSelectionData $selection_data --> Gnome::Gdk3::Atom
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-data-with-length:
=begin pod
=head2 gtk-selection-data-get-data-with-length

Retrieves the raw data of the selection along with its length.

Returns: (array length=length): the raw data of the selection

  method gtk-selection-data-get-data-with-length ( GtkSelectionData $selection_data --> guStr )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=item Int $length; return location for length of the data segment
=end pod

method gtk-selection-data-get-data-with-length ( GtkSelectionData $selection_data --> guStr ) {

  gtk_selection_data_get_data_with_length(
    self._f('GtkTargetEntry'), $selection_data, my gint $length
  )
}

sub gtk_selection_data_get_data_with_length (
  GtkSelectionData $selection_data, gint $length is rw --> gugchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-display:
=begin pod
=head2 gtk-selection-data-get-display

Retrieves the display of the selection.

Returns: the display of the selection.

  method gtk-selection-data-get-display ( GtkSelectionData $selection_data --> N-GObject )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-display ( GtkSelectionData $selection_data --> N-GObject ) {

  gtk_selection_data_get_display(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_display (
  GtkSelectionData $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-format:
=begin pod
=head2 gtk-selection-data-get-format

Retrieves the format of the selection.

Returns: the format of the selection.

  method gtk-selection-data-get-format ( GtkSelectionData $selection_data --> Int )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-format ( GtkSelectionData $selection_data --> Int ) {

  gtk_selection_data_get_format(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_format (
  GtkSelectionData $selection_data --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-length:
=begin pod
=head2 gtk-selection-data-get-length

Retrieves the length of the raw data of the selection.

Returns: the length of the data of the selection.

  method gtk-selection-data-get-length ( GtkSelectionData $selection_data --> Int )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-length ( GtkSelectionData $selection_data --> Int ) {

  gtk_selection_data_get_length(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_length (
  GtkSelectionData $selection_data --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-pixbuf:
=begin pod
=head2 gtk-selection-data-get-pixbuf

Gets the contents of the selection data as a B<Gnome::Gtk3::Pixbuf>.

Returns: if the selection data contained a recognized image type and it could be converted to a B<Gnome::Gtk3::Pixbuf>, a newly allocated pixbuf is returned, otherwise C<undefined>. If the result is non-C<undefined> it must be freed with C<g-object-unref()>.

  method gtk-selection-data-get-pixbuf ( GtkSelectionData $selection_data --> N-GObject )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=end pod

method gtk-selection-data-get-pixbuf ( GtkSelectionData $selection_data --> N-GObject ) {

  gtk_selection_data_get_pixbuf(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_pixbuf (
  GtkSelectionData $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-selection:
=begin pod
=head2 gtk-selection-data-get-selection

Retrieves the selection B<Gnome::Gtk3::Atom> of the selection data.

Returns: the selection B<Gnome::Gtk3::Atom> of the selection data.

  method gtk-selection-data-get-selection ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-selection ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom ) {

  gtk_selection_data_get_selection(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_selection (
  GtkSelectionData $selection_data --> Gnome::Gdk3::Atom
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-target:
=begin pod
=head2 gtk-selection-data-get-target

Retrieves the target of the selection.

Returns: the target of the selection.

  method gtk-selection-data-get-target ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method gtk-selection-data-get-target ( GtkSelectionData $selection_data --> Gnome::Gdk3::Atom ) {

  gtk_selection_data_get_target(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_target (
  GtkSelectionData $selection_data --> Gnome::Gdk3::Atom
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-targets:
=begin pod
=head2 gtk-selection-data-get-targets

Gets the contents of I<selection-data> as an array of targets. This can be used to interpret the results of getting the standard TARGETS target that is always supplied for any selection.

Returns: C<True> if I<selection-data> contains a valid array of targets, otherwise C<False>.

  method gtk-selection-data-get-targets ( GtkSelectionData $selection_data, Gnome::Gdk3::Atom $targets --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData> object
=item Gnome::Gdk3::Atom $targets;  (array length=n-atoms) (transfer container): location to store an array of targets. The result stored here must be freed with C<g-free()>.
=item Int $n_atoms; location to store number of items in I<targets>.
=end pod

method gtk-selection-data-get-targets ( GtkSelectionData $selection_data, Gnome::Gdk3::Atom $targets --> Bool ) {

  gtk_selection_data_get_targets(
    self._f('GtkTargetEntry'), $selection_data, $targets, my gint $n_atoms
  ).Bool
}

sub gtk_selection_data_get_targets (
  GtkSelectionData $selection_data, Gnome::Gdk3::Atom $targets, gint $n_atoms is rw --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-text:
=begin pod
=head2 gtk-selection-data-get-text

Gets the contents of the selection data as a UTF-8 string.

Returns: (type utf8)  : if the selection data contained a recognized text type and it could be converted to UTF-8, a newly allocated string containing the converted text, otherwise C<undefined>. If the result is non-C<undefined> it must be freed with C<g-free()>.

  method gtk-selection-data-get-text ( GtkSelectionData $selection_data --> guStr )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=end pod

method gtk-selection-data-get-text ( GtkSelectionData $selection_data --> guStr ) {

  gtk_selection_data_get_text(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_text (
  GtkSelectionData $selection_data --> gugchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-get-uris:
=begin pod
=head2 gtk-selection-data-get-uris

Gets the contents of the selection data as array of URIs.

Returns:  (element-type utf8) : if the selection data contains a list of URIs, a newly allocated C<undefined>-terminated string array containing the URIs, otherwise C<undefined>. If the result is non-C<undefined> it must be freed with C<g-strfreev()>.

  method gtk-selection-data-get-uris ( GtkSelectionData $selection_data --> CArray[Str] )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=end pod

method gtk-selection-data-get-uris ( GtkSelectionData $selection_data --> CArray[Str] ) {

  gtk_selection_data_get_uris(
    self._f('GtkTargetEntry'), $selection_data
  )
}

sub gtk_selection_data_get_uris (
  GtkSelectionData $selection_data --> gchar-pptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-set:
=begin pod
=head2 gtk-selection-data-set

Stores new data into a B<Gnome::Gtk3::SelectionData> object. Should only be called from a selection handler callback. Zero-terminates the stored data.

  method gtk-selection-data-set ( GtkSelectionData $selection_data, Gnome::Gdk3::Atom $type, Int() $format, guStr $data, Int() $length )

=item GtkSelectionData $selection_data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=item Gnome::Gdk3::Atom $type; the type of selection data
=item Int() $format; format (number of bits in a unit)
=item guStr $data; (array length=length): pointer to the data (will be copied)
=item Int() $length; length of the data
=end pod

method gtk-selection-data-set ( GtkSelectionData $selection_data, Gnome::Gdk3::Atom $type, Int() $format, guStr $data, Int() $length ) {

  gtk_selection_data_set(
    self._f('GtkTargetEntry'), $selection_data, $type, $format, $data, $length
  );
}

sub gtk_selection_data_set (
  GtkSelectionData $selection_data, Gnome::Gdk3::Atom $type, gint $format, gugchar-ptr $data, gint $length
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-set-pixbuf:
=begin pod
=head2 gtk-selection-data-set-pixbuf

Sets the contents of the selection from a B<Gnome::Gtk3::Pixbuf> The pixbuf is converted to the form determined by I<selection-data>->target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method gtk-selection-data-set-pixbuf ( GtkSelectionData $selection_data, N-GObject $pixbuf --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=item N-GObject $pixbuf; a B<Gnome::Gtk3::Pixbuf>
=end pod

method gtk-selection-data-set-pixbuf ( GtkSelectionData $selection_data, $pixbuf is copy --> Bool ) {
  $pixbuf .= get-native-object-no-reffing unless $pixbuf ~~ N-GObject;

  gtk_selection_data_set_pixbuf(
    self._f('GtkTargetEntry'), $selection_data, $pixbuf
  ).Bool
}

sub gtk_selection_data_set_pixbuf (
  GtkSelectionData $selection_data, N-GObject $pixbuf --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-set-text:
=begin pod
=head2 gtk-selection-data-set-text

Sets the contents of the selection from a UTF-8 encoded string. The string is converted to the form determined by I<selection-data>->target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method gtk-selection-data-set-text ( GtkSelectionData $selection_data, Str $str, Int() $len --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=item Str $str; a UTF-8 string
=item Int() $len; the length of I<str>, or -1 if I<str> is nul-terminated.
=end pod

method gtk-selection-data-set-text ( GtkSelectionData $selection_data, Str $str, Int() $len --> Bool ) {

  gtk_selection_data_set_text(
    self._f('GtkTargetEntry'), $selection_data, $str, $len
  ).Bool
}

sub gtk_selection_data_set_text (
  GtkSelectionData $selection_data, gchar-ptr $str, gint $len --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-set-uris:
=begin pod
=head2 gtk-selection-data-set-uris

Sets the contents of the selection from a list of URIs. The string is converted to the form determined by I<selection-data>->target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method gtk-selection-data-set-uris ( GtkSelectionData $selection_data, CArray[Str] $uris --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData>
=item CArray[Str] $uris; a C<undefined>-terminated array of strings holding URIs
=end pod

method gtk-selection-data-set-uris ( GtkSelectionData $selection_data, CArray[Str] $uris --> Bool ) {

  gtk_selection_data_set_uris(
    self._f('GtkTargetEntry'), $selection_data, $uris
  ).Bool
}

sub gtk_selection_data_set_uris (
  GtkSelectionData $selection_data, gchar-pptr $uris --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-targets-include-image:
=begin pod
=head2 gtk-selection-data-targets-include-image

Given a B<Gnome::Gtk3::SelectionData> object holding a list of targets, determines if any of the targets in I<targets> can be used to provide a B<Gnome::Gtk3::Pixbuf>.

Returns: C<True> if I<selection-data> holds a list of targets, and a suitable target for images is included, otherwise C<False>.

  method gtk-selection-data-targets-include-image ( GtkSelectionData $selection_data, Bool $writable --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData> object
=item Bool $writable; whether to accept only targets for which GTK+ knows how to convert a pixbuf into the format
=end pod

method gtk-selection-data-targets-include-image ( GtkSelectionData $selection_data, Bool $writable --> Bool ) {

  gtk_selection_data_targets_include_image(
    self._f('GtkTargetEntry'), $selection_data, $writable
  ).Bool
}

sub gtk_selection_data_targets_include_image (
  GtkSelectionData $selection_data, gboolean $writable --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-targets-include-rich-text:
=begin pod
=head2 gtk-selection-data-targets-include-rich-text

Given a B<Gnome::Gtk3::SelectionData> object holding a list of targets, determines if any of the targets in I<targets> can be used to provide rich text.

Returns: C<True> if I<selection-data> holds a list of targets, and a suitable target for rich text is included, otherwise C<False>.

  method gtk-selection-data-targets-include-rich-text ( GtkSelectionData $selection_data, N-GObject $buffer --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData> object
=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>
=end pod

method gtk-selection-data-targets-include-rich-text ( GtkSelectionData $selection_data, $buffer is copy --> Bool ) {
  $buffer .= get-native-object-no-reffing unless $buffer ~~ N-GObject;

  gtk_selection_data_targets_include_rich_text(
    self._f('GtkTargetEntry'), $selection_data, $buffer
  ).Bool
}

sub gtk_selection_data_targets_include_rich_text (
  GtkSelectionData $selection_data, N-GObject $buffer --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-targets-include-text:
=begin pod
=head2 gtk-selection-data-targets-include-text

Given a B<Gnome::Gtk3::SelectionData> object holding a list of targets, determines if any of the targets in I<targets> can be used to provide text.

Returns: C<True> if I<selection-data> holds a list of targets, and a suitable target for text is included, otherwise C<False>.

  method gtk-selection-data-targets-include-text ( GtkSelectionData $selection_data --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData> object
=end pod

method gtk-selection-data-targets-include-text ( GtkSelectionData $selection_data --> Bool ) {

  gtk_selection_data_targets_include_text(
    self._f('GtkTargetEntry'), $selection_data
  ).Bool
}

sub gtk_selection_data_targets_include_text (
  GtkSelectionData $selection_data --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-data-targets-include-uri:
=begin pod
=head2 gtk-selection-data-targets-include-uri

Given a B<Gnome::Gtk3::SelectionData> object holding a list of targets, determines if any of the targets in I<targets> can be used to provide a list or URIs.

Returns: C<True> if I<selection-data> holds a list of targets, and a suitable target for URI lists is included, otherwise C<False>.

  method gtk-selection-data-targets-include-uri ( GtkSelectionData $selection_data --> Bool )

=item GtkSelectionData $selection_data; a B<Gnome::Gtk3::SelectionData> object
=end pod

method gtk-selection-data-targets-include-uri ( GtkSelectionData $selection_data --> Bool ) {

  gtk_selection_data_targets_include_uri(
    self._f('GtkTargetEntry'), $selection_data
  ).Bool
}

sub gtk_selection_data_targets_include_uri (
  GtkSelectionData $selection_data --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-owner-set:
=begin pod
=head2 gtk-selection-owner-set

Claims ownership of a given selection for a particular widget, or, if I<widget> is C<undefined>, release ownership of the selection.

Returns: C<True> if the operation succeeded

  method gtk-selection-owner-set ( N-GObject $widget, Gnome::Gdk3::Atom $selection, UInt $time_ --> Bool )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>, or C<undefined>.
=item Gnome::Gdk3::Atom $selection; an interned atom representing the selection to claim
=item UInt $time_; timestamp with which to claim the selection
=end pod

method gtk-selection-owner-set ( $widget is copy, Gnome::Gdk3::Atom $selection, UInt $time_ --> Bool ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_owner_set(
    self._f('GtkTargetEntry'), $widget, $selection, $time_
  ).Bool
}

sub gtk_selection_owner_set (
  N-GObject $widget, Gnome::Gdk3::Atom $selection, guint32 $time_ --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-owner-set-for-display:
=begin pod
=head2 gtk-selection-owner-set-for-display

Claim ownership of a given selection for a particular widget, or, if I<widget> is C<undefined>, release ownership of the selection.

Returns: TRUE if the operation succeeded

  method gtk-selection-owner-set-for-display ( N-GObject $display, N-GObject $widget, Gnome::Gdk3::Atom $selection, UInt $time_ --> Bool )

=item N-GObject $display; the B<Gnome::Gtk3::Display> where the selection is set
=item N-GObject $widget; new selection owner (a B<Gnome::Gtk3::Widget>), or C<undefined>.
=item Gnome::Gdk3::Atom $selection; an interned atom representing the selection to claim.
=item UInt $time_; timestamp with which to claim the selection
=end pod

method gtk-selection-owner-set-for-display ( $display is copy, $widget is copy, Gnome::Gdk3::Atom $selection, UInt $time_ --> Bool ) {
  $display .= get-native-object-no-reffing unless $display ~~ N-GObject;
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_owner_set_for_display(
    self._f('GtkTargetEntry'), $display, $widget, $selection, $time_
  ).Bool
}

sub gtk_selection_owner_set_for_display (
  N-GObject $display, N-GObject $widget, Gnome::Gdk3::Atom $selection, guint32 $time_ --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-selection-remove-all:
=begin pod
=head2 gtk-selection-remove-all

Removes all handlers and unsets ownership of all selections for a widget. Called when widget is being destroyed. This function will not generally be called by applications.

  method gtk-selection-remove-all ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=end pod

method gtk-selection-remove-all ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_remove_all(
    self._f('GtkTargetEntry'), $widget
  );
}

sub gtk_selection_remove_all (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add:
=begin pod
=head2 gtk-target-list-add

Appends another target to a B<Gnome::Gtk3::TargetList>.

  method gtk-target-list-add ( GtkTargetList $list, Gnome::Gdk3::Atom $target, UInt $flags, UInt $info )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item Gnome::Gdk3::Atom $target; the interned atom representing the target
=item UInt $flags; the flags for this target
=item UInt $info; an ID that will be passed back to the application
=end pod

method gtk-target-list-add ( GtkTargetList $list, Gnome::Gdk3::Atom $target, UInt $flags, UInt $info ) {

  gtk_target_list_add(
    self._f('GtkTargetEntry'), $list, $target, $flags, $info
  );
}

sub gtk_target_list_add (
  GtkTargetList $list, Gnome::Gdk3::Atom $target, guint $flags, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add-image-targets:
=begin pod
=head2 gtk-target-list-add-image-targets

Appends the image targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<info>.

  method gtk-target-list-add-image-targets ( GtkTargetList $list, UInt $info, Bool $writable )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item UInt $info; an ID that will be passed back to the application
=item Bool $writable; whether to add only targets for which GTK+ knows how to convert a pixbuf into the format
=end pod

method gtk-target-list-add-image-targets ( GtkTargetList $list, UInt $info, Bool $writable ) {

  gtk_target_list_add_image_targets(
    self._f('GtkTargetEntry'), $list, $info, $writable
  );
}

sub gtk_target_list_add_image_targets (
  GtkTargetList $list, guint $info, gboolean $writable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add-rich-text-targets:
=begin pod
=head2 gtk-target-list-add-rich-text-targets

Appends the rich text targets registered with C<gtk-text-buffer-register-serialize-format()> or C<gtk-text-buffer-register-deserialize-format()> to the target list. All targets are added with the same I<info>.

  method gtk-target-list-add-rich-text-targets ( GtkTargetList $list, UInt $info, Bool $deserializable, N-GObject $buffer )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item UInt $info; an ID that will be passed back to the application
=item Bool $deserializable; if C<True>, then deserializable rich text formats will be added, serializable formats otherwise.
=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>.
=end pod

method gtk-target-list-add-rich-text-targets ( GtkTargetList $list, UInt $info, Bool $deserializable, $buffer is copy ) {
  $buffer .= get-native-object-no-reffing unless $buffer ~~ N-GObject;

  gtk_target_list_add_rich_text_targets(
    self._f('GtkTargetEntry'), $list, $info, $deserializable, $buffer
  );
}

sub gtk_target_list_add_rich_text_targets (
  GtkTargetList $list, guint $info, gboolean $deserializable, N-GObject $buffer
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add-table:
=begin pod
=head2 gtk-target-list-add-table

Prepends a table of B<Gnome::Gtk3::TargetEntry> to a target list.

  method gtk-target-list-add-table ( GtkTargetList $list, GtkTargetEntry $targets, UInt $ntargets )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item GtkTargetEntry $targets; (array length=ntargets): the table of B<Gnome::Gtk3::TargetEntry>
=item UInt $ntargets; number of targets in the table
=end pod

method gtk-target-list-add-table ( GtkTargetList $list, GtkTargetEntry $targets, UInt $ntargets ) {

  gtk_target_list_add_table(
    self._f('GtkTargetEntry'), $list, $targets, $ntargets
  );
}

sub gtk_target_list_add_table (
  GtkTargetList $list, GtkTargetEntry $targets, guint $ntargets
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add-text-targets:
=begin pod
=head2 gtk-target-list-add-text-targets

Appends the text targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<info>.

  method gtk-target-list-add-text-targets ( GtkTargetList $list, UInt $info )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item UInt $info; an ID that will be passed back to the application
=end pod

method gtk-target-list-add-text-targets ( GtkTargetList $list, UInt $info ) {

  gtk_target_list_add_text_targets(
    self._f('GtkTargetEntry'), $list, $info
  );
}

sub gtk_target_list_add_text_targets (
  GtkTargetList $list, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-add-uri-targets:
=begin pod
=head2 gtk-target-list-add-uri-targets

Appends the URI targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<info>.

  method gtk-target-list-add-uri-targets ( GtkTargetList $list, UInt $info )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item UInt $info; an ID that will be passed back to the application
=end pod

method gtk-target-list-add-uri-targets ( GtkTargetList $list, UInt $info ) {

  gtk_target_list_add_uri_targets(
    self._f('GtkTargetEntry'), $list, $info
  );
}

sub gtk_target_list_add_uri_targets (
  GtkTargetList $list, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-find:
=begin pod
=head2 gtk-target-list-find

Looks up a given target in a B<Gnome::Gtk3::TargetList>.

Returns: C<True> if the target was found, otherwise C<False>

  method gtk-target-list-find ( GtkTargetList $list, Gnome::Gdk3::Atom $target, guInt-ptr $info --> Bool )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item Gnome::Gdk3::Atom $target; an interned atom representing the target to search for
=item guInt-ptr $info; a pointer to the location to store application info for target, or C<undefined>
=end pod

method gtk-target-list-find ( GtkTargetList $list, Gnome::Gdk3::Atom $target, guInt-ptr $info --> Bool ) {

  gtk_target_list_find(
    self._f('GtkTargetEntry'), $list, $target, $info
  ).Bool
}

sub gtk_target_list_find (
  GtkTargetList $list, Gnome::Gdk3::Atom $target, gugint-ptr $info --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-new:
=begin pod
=head2 gtk-target-list-new

Creates a new B<Gnome::Gtk3::TargetList> from an array of B<Gnome::Gtk3::TargetEntry>.

Returns: the new B<Gnome::Gtk3::TargetList>.

  method gtk-target-list-new ( UInt $ntargets --> GtkTargetList )

=item UInt $ntargets; number of entries in I<targets>.
=end pod

method gtk-target-list-new ( UInt $ntargets --> GtkTargetList ) {

  gtk_target_list_new(
    self._f('GtkTargetEntry'), $ntargets
  )
}

sub gtk_target_list_new (
  GtkTargetEntry $targets, guint $ntargets --> GtkTargetList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-ref:
=begin pod
=head2 gtk-target-list-ref

Increases the reference count of a B<Gnome::Gtk3::TargetList> by one.

Returns: the passed in B<Gnome::Gtk3::TargetList>.

  method gtk-target-list-ref ( GtkTargetList $list --> GtkTargetList )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=end pod

method gtk-target-list-ref ( GtkTargetList $list --> GtkTargetList ) {

  gtk_target_list_ref(
    self._f('GtkTargetEntry'), $list
  )
}

sub gtk_target_list_ref (
  GtkTargetList $list --> GtkTargetList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-remove:
=begin pod
=head2 gtk-target-list-remove

Removes a target from a target list.

  method gtk-target-list-remove ( GtkTargetList $list, Gnome::Gdk3::Atom $target )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item Gnome::Gdk3::Atom $target; the interned atom representing the target
=end pod

method gtk-target-list-remove ( GtkTargetList $list, Gnome::Gdk3::Atom $target ) {

  gtk_target_list_remove(
    self._f('GtkTargetEntry'), $list, $target
  );
}

sub gtk_target_list_remove (
  GtkTargetList $list, Gnome::Gdk3::Atom $target
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-list-unref:
=begin pod
=head2 gtk-target-list-unref

Decreases the reference count of a B<Gnome::Gtk3::TargetList> by one. If the resulting reference count is zero, frees the list.

  method gtk-target-list-unref ( GtkTargetList $list )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=end pod

method gtk-target-list-unref ( GtkTargetList $list ) {

  gtk_target_list_unref(
    self._f('GtkTargetEntry'), $list
  );
}

sub gtk_target_list_unref (
  GtkTargetList $list
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-table-free:
=begin pod
=head2 gtk-target-table-free

This function frees a target table as returned by C<gtk-target-table-new-from-list()>

  method gtk-target-table-free ( Int() $n_targets )

=item Int() $n_targets; the number of entries in the array
=end pod

method gtk-target-table-free ( Int() $n_targets ) {

  gtk_target_table_free(
    self._f('GtkTargetEntry'), $n_targets
  );
}

sub gtk_target_table_free (
  GtkTargetEntry $targets, gint $n_targets
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-target-table-new-from-list:
=begin pod
=head2 gtk-target-table-new-from-list

This function creates an B<Gnome::Gtk3::TargetEntry> array that contains the same targets as the passed C<list>. The returned table is newly allocated and should be freed using C<gtk-target-table-free()> when no longer needed.

Returns: (array length=n-targets) : the new table.

  method gtk-target-table-new-from-list ( GtkTargetList $list --> GtkTargetEntry )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item Int $n_targets; return location for the number ot targets in the table
=end pod

method gtk-target-table-new-from-list ( GtkTargetList $list --> GtkTargetEntry ) {

  gtk_target_table_new_from_list(
    self._f('GtkTargetEntry'), $list, my gint $n_targets
  )
}

sub gtk_target_table_new_from_list (
  GtkTargetList $list, gint $n_targets is rw --> GtkTargetEntry
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-targets-include-image:
=begin pod
=head2 gtk-targets-include-image

Determines if any of the targets in I<targets> can be used to provide a B<Gnome::Gtk3::Pixbuf>.

Returns: C<True> if I<targets> include a suitable target for images, otherwise C<False>.

  method gtk-targets-include-image ( Gnome::Gdk3::Atom $targets, Int() $n_targets, Bool $writable --> Bool )

=item Gnome::Gdk3::Atom $targets; (array length=n-targets): an array of B<Gnome::Gtk3::Atoms>
=item Int() $n_targets; the length of I<targets>
=item Bool $writable; whether to accept only targets for which GTK+ knows how to convert a pixbuf into the format
=end pod

method gtk-targets-include-image ( Gnome::Gdk3::Atom $targets, Int() $n_targets, Bool $writable --> Bool ) {

  gtk_targets_include_image(
    self._f('GtkTargetEntry'), $targets, $n_targets, $writable
  ).Bool
}

sub gtk_targets_include_image (
  Gnome::Gdk3::Atom $targets, gint $n_targets, gboolean $writable --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-targets-include-rich-text:
=begin pod
=head2 gtk-targets-include-rich-text

Determines if any of the targets in I<targets> can be used to provide rich text.

Returns: C<True> if I<targets> include a suitable target for rich text, otherwise C<False>.

  method gtk-targets-include-rich-text ( Gnome::Gdk3::Atom $targets, Int() $n_targets, N-GObject $buffer --> Bool )

=item Gnome::Gdk3::Atom $targets; (array length=n-targets): an array of B<Gnome::Gtk3::Atoms>
=item Int() $n_targets; the length of I<targets>
=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>
=end pod

method gtk-targets-include-rich-text ( Gnome::Gdk3::Atom $targets, Int() $n_targets, $buffer is copy --> Bool ) {
  $buffer .= get-native-object-no-reffing unless $buffer ~~ N-GObject;

  gtk_targets_include_rich_text(
    self._f('GtkTargetEntry'), $targets, $n_targets, $buffer
  ).Bool
}

sub gtk_targets_include_rich_text (
  Gnome::Gdk3::Atom $targets, gint $n_targets, N-GObject $buffer --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-targets-include-text:
=begin pod
=head2 gtk-targets-include-text

Determines if any of the targets in I<targets> can be used to provide text.

Returns: C<True> if I<targets> include a suitable target for text, otherwise C<False>.

  method gtk-targets-include-text ( Gnome::Gdk3::Atom $targets, Int() $n_targets --> Bool )

=item Gnome::Gdk3::Atom $targets; (array length=n-targets): an array of B<Gnome::Gtk3::Atoms>
=item Int() $n_targets; the length of I<targets>
=end pod

method gtk-targets-include-text ( Gnome::Gdk3::Atom $targets, Int() $n_targets --> Bool ) {

  gtk_targets_include_text(
    self._f('GtkTargetEntry'), $targets, $n_targets
  ).Bool
}

sub gtk_targets_include_text (
  Gnome::Gdk3::Atom $targets, gint $n_targets --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-targets-include-uri:
=begin pod
=head2 gtk-targets-include-uri

Determines if any of the targets in I<targets> can be used to provide an uri list.

Returns: C<True> if I<targets> include a suitable target for uri lists, otherwise C<False>.

  method gtk-targets-include-uri ( Gnome::Gdk3::Atom $targets, Int() $n_targets --> Bool )

=item Gnome::Gdk3::Atom $targets; (array length=n-targets): an array of B<Gnome::Gtk3::Atoms>
=item Int() $n_targets; the length of I<targets>
=end pod

method gtk-targets-include-uri ( Gnome::Gdk3::Atom $targets, Int() $n_targets --> Bool ) {

  gtk_targets_include_uri(
    self._f('GtkTargetEntry'), $targets, $n_targets
  ).Bool
}

sub gtk_targets_include_uri (
  Gnome::Gdk3::Atom $targets, gint $n_targets --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_entry_new:
#`{{
=begin pod
=head2 _gtk_target_entry_new

Makes a new B<Gnome::Gtk3::TargetEntry>.

Returns: a pointer to a new B<Gnome::Gtk3::TargetEntry>. Free with C<free()>

  method _gtk_target_entry_new ( Str $target, UInt $flags, UInt $info --> GtkTargetEntry )

=item Str $target; String identifier for target
=item UInt $flags; Set of flags, see B<Gnome::Gtk3::TargetFlags>
=item UInt $info; an ID that will be passed back to the application
=end pod
}}

sub _gtk_target_entry_new ( gchar-ptr $target, guint $flags, guint $info --> N-GtkTargetEntry )
  is native(&gtk-lib)
  is symbol('gtk_target_entry_new')
  { * }
