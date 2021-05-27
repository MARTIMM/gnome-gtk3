#TL:1:Gnome::Gtk3::TargetList:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TargetList

Handling of target lists

=comment head2 See Also


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TargetList;
  also is Gnome::GObject::Boxed;


=head2 Example

An example of a drag destination specification (an image) which can only accept plain text.

  # Use an image to show where to drop
  my Gnome::Gtk3::Image $image .= new;
  $image.set-from-file('bullseye.jpg');

  # Define a drag destination and ise that image for it
  my Gnome::Gtk3::DragDest $destination .= new;
  $destination.set( $image, 0, GDK_ACTION_COPY);

  # Specify what the drag destination can handle. Also
  # the source must be in the same application
  my Gnome::Gtk3::TargetList $target-list .= new;
  $target-list.add(
    Gnome::Gdk3::Atom.new(:intern<text/plain>),
    GTK_TARGET_SAME_APP, $str-info
  );
  $destination.set-target-list( $widget, $target-list);


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::GObject::Boxed;

use Gnome::Gdk3::Atom;

#use Gnome::Gtk3::TargetEntry;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TargetList:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkTargetFlags

The GtkTargetFlag> enumeration is used to specify constraints on a N-GObject.

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

A B<Gnome::Gtk3::TargetPair> is used to represent the same information as a table of B<Gnome::Gtk3::TargetEntry>, but in an efficient form.

=item N-GObject $.target: B<Gnome::Gtk3::Atom> representation of the target type
=item UInt $.flags: B<Gnome::Gtk3::TargetFlags> for DND
=item UInt $.info: an application-assigned integer ID which will get passed as a parameter to e.g the  I<selection-get> signal. It allows the application to identify the target type without extensive string compares.

=end pod

#TT:0:N-GtkTargetPair:
class N-GtkTargetPair is export is repr('CStruct') {
  has N-GObject $.target;
  has guint $.flags;
  has guint $.info;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new empty TargetList object.

  multi method new ( )


=begin comment
=head3 :targets

Creates a new TargetList from an array of target entries.

  multi method new ( Array :$targets! )
=end comment


=head3 :native-object

Create a TargetList object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new():
# TM:1:new(:targets):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::TargetList' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if %options<targets>:exists {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_target_list_new___x___($no);
#`{{
        my $tes = CArray[N-TargetEntry].new;
        my Int $i = 0;
        for @(%options<targets>) -> $t {
          $tes[$i++] = $t ~~ N-TargetEntry ?? $t !! $t.get-native-object-no-reffing;
note "tes[{$i - 1}]: $tes[$i-1].gist()";
        }

        $no = _gtk_target_list_new( $tes, %options<targets>.elems);
}}
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
#        $no = _gtk_target_list_new( CArray[N-TargetEntry], 0);
        $no = _gtk_target_list_new( CArray[N-GObject], 0);
      }
      #}}

#note "no: $no.gist()";
      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkTargetList');
  }
}

#-------------------------------------------------------------------------------
# no ref/unref
method native-object-ref ( $n-native-object --> Any ) {
  _gtk_target_list_ref($n-native-object)
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _gtk_target_list_unref($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:1:add:
=begin pod
=head2 add

Appends another target to a B<Gnome::Gtk3::TargetList>.

  method add ( N-GObject $target, UInt $flags, UInt $info )

=item Gnome::Gdk3::Atom $target; the interned atom representing the target
=item UInt $flags; the flags for this target
=item UInt $info; an ID that will be passed back to the application
=end pod

method add ( $target is copy, UInt $flags, UInt $info ) {
  $target .= get-native-object-no-reffing unless $target ~~ N-GObject;
  gtk_target_list_add(
    self.get-native-object-no-reffing, $target, $flags, $info
  );
}

sub gtk_target_list_add (
  N-GObject $list, N-GObject $target, guint $flags, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-image-targets:
=begin pod
=head2 add-image-targets

Appends the image targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<$info>.

  method add-image-targets ( UInt $info, Bool $writable )

=item UInt $info; an ID that will be passed back to the application
=item Bool $writable; whether to add only targets for which GTK+ knows how to convert a pixbuf into the format
=end pod

method add-image-targets ( UInt $info, Bool $writable ) {
  gtk_target_list_add_image_targets(
    self.get-native-object-no-reffing, $info, $writable
  );
}

sub gtk_target_list_add_image_targets (
  N-GObject $list, guint $info, gboolean $writable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-rich-text-targets:
=begin pod
=head2 add-rich-text-targets

Appends the rich text targets registered with C<gtk-text-buffer-register-serialize-format()> or C<gtk-text-buffer-register-deserialize-format()> to the target list. All targets are added with the same I<info>.

  method add-rich-text-targets ( UInt $info, Bool $deserializable, N-GObject $buffer )

=item UInt $info; an ID that will be passed back to the application
=item Bool $deserializable; if C<True>, then deserializable rich text formats will be added, serializable formats otherwise.
=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>.
=end pod

method add-rich-text-targets ( UInt $info, Bool $deserializable, $buffer is copy ) {
  $buffer .= get-native-object-no-reffing unless $buffer ~~ N-GObject;

  gtk_target_list_add_rich_text_targets(
    self.get-native-object-no-reffing, $info, $deserializable, $buffer
  );
}

sub gtk_target_list_add_rich_text_targets (
  N-GObject $list, guint $info, gboolean $deserializable, N-GObject $buffer
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:4:add-table:xt/dnd-01.raku
=begin pod
=head2 add-table

Prepends a table of B<Gnome::Gtk3::TargetEntry> to a target list.

  method add-table ( Array $targets )

=item Array $targets; the table of B<Gnome::Gtk3::TargetEntry> target entries
=end pod

method add-table ( Array $targets ) {
  my $tes = CArray[N-TargetEntry].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-TargetEntry ?? $t !! $t.get-native-object-no-reffing;
note "\$tes[{$i-1}], $tes[$i - 1].gist()";
  }

  gtk_target_list_add_table(
    self.get-native-object-no-reffing, $tes, $targets.elems
  );
}

sub gtk_target_list_add_table (
  N-GObject $list, CArray[N-TargetEntry] $targets, guint $ntargets
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:add-text-targets:
=begin pod
=head2 add-text-targets

Appends the text targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<info>.

  method add-text-targets ( UInt $info )

=item UInt $info; an ID that will be passed back to the application
=end pod

method add-text-targets ( UInt $info ) {

  gtk_target_list_add_text_targets(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_target_list_add_text_targets (
  N-GObject $list, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-uri-targets:
=begin pod
=head2 add-uri-targets

Appends the URI targets supported by B<Gnome::Gtk3::SelectionData> to the target list. All targets are added with the same I<info>.

  method add-uri-targets ( UInt $info )

=item UInt $info; an ID that will be passed back to the application
=end pod

method add-uri-targets ( UInt $info ) {

  gtk_target_list_add_uri_targets(
    self.get-native-object-no-reffing, $info
  );
}

sub gtk_target_list_add_uri_targets (
  N-GObject $list, guint $info
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:find:
=begin pod
=head2 find

Looks up a given target in a B<Gnome::Gtk3::TargetList>.

  method find ( Gnome::Gdk3::Atom $target --> List )

=item Gnome::Gdk3::Atom $target; an interned atom representing the target to search for

Returns a List where;
=item Bool $result; The result of C<find()>, C<True> if the target was found, otherwise C<False>
=item Int $info; application info for target, or C<undefined>
=end pod

method find ( $target is copy --> List ) {
  $target .= get-native-object-no-reffing unless $target ~~ N-GObject;
  my Bool $r = gtk_target_list_find(
    self.get-native-object-no-reffing, $target, my guint $info
  ).Bool;

  ( $r, $info)
}

sub gtk_target_list_find (
  N-GObject $list, N-GObject $target, guint $info is rw --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_list_ref:
#`{{
=begin pod
=head2 ref

Increases the reference count of a B<Gnome::Gtk3::TargetList> by one.

Returns: the passed in B<Gnome::Gtk3::TargetList>.

  method ref ( --> N-GObject )

=end pod

method ref ( --> N-GObject ) {
  gtk_target_list_ref(self.get-native-object-no-reffing)
}
}}

sub _gtk_target_list_ref (
  N-GObject $list --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_target_list_ref')
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove:
=begin pod
=head2 remove

Removes a target from a target list.

  method remove ( Gnome::Gdk3::Atom $target )

=item Gnome::Gdk3::Atom $target; the interned atom representing the target
=end pod

method remove ( Gnome::Gdk3::Atom $target ) {
  gtk_target_list_remove( self.get-native-object-no-reffing, $target);
}

sub gtk_target_list_remove (
  N-GObject $list, N-GObject $target
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0::_gtk_target_table_free
#`{{
=begin pod
=head2 table-free

This function frees a target table as returned by C<target-table-new-from-list()>.

  method table-free ( Array $targets )

=item GtkTargetEntry $targets; a B<Gnome::Gtk3::TargetEntry> array
=end pod

method table-free ( Array $targets ) {
  my $tes = CArray[N-TargetEntry].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-TargetEntry ?? $t !! $t.get-native-object-no-reffing;
note "\$tes[{$i-1}], $tes[$i - 1].gist()";
  }

  gtk_target_table_free( $tes, $targets.elems);
}
}}

#`{{
sub _gtk_target_table_free (
  CArray[N-TargetEntry] $targets, gint $n_targets
) is native(&gtk-lib)
  is symbol('gtk_target_table_free')
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
# TM:1:table-from-list:
=begin pod
=head2 table-from-list

This function creates an B<Gnome::Gtk3::TargetEntry> array that contains the same targets as the passed C<list>.
=comment The returned table is newly allocated and should be freed using C<free()> when no longer needed. (Done here!)

Returns: the new table as an Array of target entries.

  method table-from-list ( --> Array )

=end pod

method table-from-list ( --> Array ) {
note $?LINE;
  my CArray[N-TargetEntry] $tes = gtk_target_table_new_from_list(
    self.get-native-object-no-reffing, my gint $nt
  );
note $?LINE;

  my Array $targets = [];
  for ^$nt -> $i {
note "$?LINE,  $i, $tes[$i]";
note 'tfl: ', $tes[$i].gist;
    $targets.push: Gnome::Gtk3::TargetEntry.new(:native-object($tes[$i]));
  }

  _gtk_target_table_free( $tes, $nt);
  $targets;
}

sub gtk_target_table_new_from_list (
  N-GObject $list, gint $n_targets is rw --> CArray[N-TargetEntry]
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_list_unref:
#`{{
=begin pod
=head2 unref

Decreases the reference count of a B<Gnome::Gtk3::TargetList> by one. If the resulting reference count is zero, frees the list.

  method unref ( )

=end pod

method unref ( ) {
  gtk_target_list_unref(self.get-native-object-no-reffing);
}
}}

sub _gtk_target_list_unref (
  N-GObject $list
) is native(&gtk-lib)
  is symbol('gtk_target_list_unref')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_list_new:
#`{{
=begin pod
=head2 _gtk_target_list_new

Creates a new B<Gnome::Gtk3::TargetList> from an array of B<Gnome::Gtk3::TargetEntry>.

Returns: the new B<Gnome::Gtk3::TargetList>.

  method _gtk_target_list_new ( Gnome::Gtk3::TargetEntry $targets, UInt $ntargets --> N-GObject )

=item Gnome::Gtk3::TargetEntry $targets; (array length=ntargets) : Pointer to an array of B<Gnome::Gtk3::TargetEntry>
=item UInt $ntargets; number of entries in I<targets>.
=end pod
}}

sub _gtk_target_list_new (
  CArray[N-GObject] $targets, guint $ntargets --> N-GObject
#  CArray[N-TargetEntry] $targets, guint $ntargets --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_target_list_new')
  { * }
