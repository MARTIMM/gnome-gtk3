#TL:1:Gnome::Gtk3::TargetEntry:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TargetEntry

Functions for handling target entries

=begin comment
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
=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TargetEntry;
  also is Gnome::GObject::Boxed;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
#use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TargetEntry:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2  N-GtkTargetEntry

A C<N-GtkTargetEntry> represents a single type of data that can be supplied by a widget in a selection or supplied during drag-and-drop.

=item Str $.target: a string representation of the target type
=item UInt $.flags: C<GtkTargetFlags> for DND
=item UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the I<selection-get> signal. It allows the application to identify the target type without extensive string compares.

=end pod

#TT:1:N-GtkTargetEntry:
class N-GtkTargetEntry is repr('CStruct') is export {
  has Str $.target;
  has guint $.flags;
  has guint $.info;

  # method created for use in a few methods in TargetList
  submethod BUILD ( Str :$target?, Int :$!flags = 0, Int :$!info = 0 ) {
    $!target := $target if $target.defined;
  }
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

=head4 Example

An example initialization and insertion into a target list.

  my Gnome::Gtk3::TargetEntry $te1 .= new(
    :target<text/plain>, :flags(GTK_TARGET_SAME_APP), :info(1234)
  );
  …
  my Gnome::Gtk3::TargetList $tl .= new(:targets([ $te1, …]))
  …

=head3 :native-object

Create a TargetEntry object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GtkTargetEntry :$native-object! )

=end pod

#TM:1:new(:target,:flags,:info):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TargetEntry' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if %options<target>:exists and %options<flags>:exists and %options<info>:exists {

#        my $ca = CArray[uint8].new(%options<target>.encode);
#        $ca[%options<target>.encode.elems] = 0;
#        $no = _gtk_target_entry_new( $ca, %options<flags>, %options<info>);

        $no = _gtk_target_entry_new(
          %options<target>, %options<flags>, %options<info>
        );

#note "te: %options<target>, %options<flags>, %options<info>";
#dd $no;
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

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    #self._set-class-info('GtkTargetEntry');
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
  gtk_target_entry_copy(self._get-native-object-no-reffing)
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

sub _gtk_target_entry_new (
#  CArray[uint8] $target, guint $flags, guint $info --> N-GtkTargetEntry
  gchar-ptr $target, guint $flags, guint $info --> N-GtkTargetEntry
) is native(&gtk-lib)
  is symbol('gtk_target_entry_new')
  { * }
