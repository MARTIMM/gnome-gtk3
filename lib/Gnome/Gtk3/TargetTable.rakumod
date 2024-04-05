#TL:1:Gnome::Gtk3::TargetTable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TargetTable


=head1 Description

Convenience class to create and handle TargetTable structures.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TargetTable;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::N::TopLevelClassSupport:api<1>;


use Gnome::Gdk3::Atom:api<1>;

use Gnome::Gtk3::TargetEntry:api<1>;
use Gnome::Gtk3::TargetList:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TargetTable:auth<github:MARTIMM>:api<1>;

#-------------------------------------------------------------------------------
class TargetEntryBytes is repr('CUnion') {
  HAS N-GtkTargetEntry $.target-entry;
  HAS CArray[uint8] $.target-bytes;

  multi submethod BUILD ( N-GtkTargetEntry :$target-entry! ) {
    $!target-entry := $target-entry;
  }

  multi submethod BUILD ( CArray[uint8] :$target-bytes! ) {
    # need to make dummy to create proper space
    $!target-entry := N-GtkTargetEntry.new;

    my Int $array-size = nativesizeof(N-GtkTargetEntry);
#note "$?LINE, ", $!target-bytes[0..($array-size - 1)]>>.base(16);

    for ^$array-size -> $i {
      $!target-bytes[$i] = $target-bytes[$i];
    }
#note "$?LINE, ", $!target-bytes[0..($array-size - 1)]>>.base(16);
  }
}

#-------------------------------------------------------------------------------
has CArray[uint8] $!target-table;
has gint $!nbr-targets;
has Bool $!from-target-list = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :list

Create a new TargetTable object using data from B<Gnome::Gtk3::TargetList>.

  multi method new ( N-GObject :list! )


=head3 :array

Create a new TargetTable object using data from B<Array[Gnome::Gtk3::TargetEntry]>.

  multi method new ( Array :array! )

=end pod

#TM:1:new(:array):
#TM:1:new(:list):
submethod BUILD ( *%options ) {

  if %options<list>:exists {
    # if table is from _gtk_target_table_new_from_list() it must bee freed
    _gtk_target_table_free( $!target-table, $!nbr-targets)
      if $!from-target-list and ?$!target-table;
#    $!target-table = CArray[uint8].new;

    my N-GtkTargetList $list = %options<list> ~~ N-GtkTargetList
                               ?? %options<list>
                               !! %options<list>._get-native-object-no-reffing;


    $!target-table = _gtk_target_table_new_from_list( $list, $!nbr-targets);
    $!from-target-list = True;
#my Int $array-size = nativesizeof(N-GtkTargetEntry);
#note $!target-table[0..($!nbr-targets * $array-size - 1)]>>.base(16);
  }


  elsif %options<array>:exists {
    # if table is from _gtk_target_table_new_from_list() it must bee freed
    _gtk_target_table_free( $!target-table, $!nbr-targets)
      if $!from-target-list and ?$!target-table;
    $!from-target-list = False;
    $!target-table = CArray[uint8].new;

    $!nbr-targets = 0;
    my Int $array-size = nativesizeof(N-GtkTargetEntry);

    for @(%options<array>) -> $te {
      my TargetEntryBytes $tb .= new(:target-entry($te));
      loop ( my $i = 0; $i < $array-size; $i++ ) {
        $!target-table[$!nbr-targets * $array-size + $i] = $tb.target-bytes[$i];
      }
      $!nbr-targets++;
    }
  }


  else {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }
}

#-------------------------------------------------------------------------------
#TM:1:get-array:
=begin pod
=head2 get-array

Get an array of B<N-GtkTargetEntry> or B<Gnome::Gtk3::TargetEntry>.

  method get-array ( --> Array[N-GtkTargetEntry] )

=end pod

method get-array ( --> Array ) {
  my Int $array-size = nativesizeof(N-GtkTargetEntry);
  my Array $r = [];
  loop ( my $nbr-targets = 0; $nbr-targets < $!nbr-targets; $nbr-targets++ ) {
    my $target-bytes = CArray[uint8].new;
    loop ( my $nb = 0; $nb < $array-size; $nb++ ) {
      $target-bytes[$nb] = $!target-table[$nbr-targets * $array-size + $nb];
    }
    my TargetEntryBytes $tb .= new(:$target-bytes);
#note 'target: ', $tb.target-entry.target;
    $r.push: $tb.target-entry;
  }

  $r
}

#`{{
method get-array-rk ( --> Array ) {
  my Int $array-size = nativesizeof(N-GtkTargetEntry);
  my Array $r = [];
  loop ( my $nt = 0; $nt < $!nbr-targets; $nt++ ) {
    my $target-bytes = CArray[uint8].new;
    loop ( my $nb = 0; $nb < $array-size; $nb++ ) {
      $target-bytes[$nb] = $!target-table[$nt * $array-size + $nb];
    }
    my TargetEntryBytes $tb .= new(:$target-bytes);
    $r.push: Gnome::Gtk3::TargetEntry(:native-object($tb.target-entry));
  }

  $r
}
}}

#-------------------------------------------------------------------------------
#TM:1:get-target-table:
=begin pod
=head2 get-target-table

Get the target table as an array of unsigned bytes.

  method get-array ( --> Array[N-GtkTargetEntry] )

=end pod

method get-target-table ( --> CArray[uint8] ) {
  $!target-table
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_table_free:
#`{{
=begin pod
=head2 free

This function frees a target table as returned by C<new-from-list()>

  method free ( GtkTargetEntry $targets, Int() $n_targets )

=item GtkTargetEntry $targets; (array length=n-targets): a B<Gnome::Gtk3::TargetEntry> array
=item Int() $n_targets; the number of entries in the array
=end pod

method free ( GtkTargetEntry $targets, Int() $n_targets ) {

  gtk_target_table_free(
    self._f('GtkTargetTable'), $targets, $n_targets
  );
}
}}

sub _gtk_target_table_free (
  CArray[uint8] $targets, gint $n_targets
) is native(&gtk-lib)
  is symbol('gtk_target_table_free')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_target_table_new_from_list:
#`{{
=begin pod
=head2 _gtk_target_table_new_from_list

This function creates an B<Gnome::Gtk3::TargetEntry> array that contains the same targets as the passed C<list>. The returned table is newly allocated and should be freed using C<free()> when no longer needed.

Returns: (array length=n-targets) : the new table.

  method _gtk_target_table_new_from_list ( GtkTargetList $list --> GtkTargetEntry )

=item GtkTargetList $list; a B<Gnome::Gtk3::TargetList>
=item Int $n_targets; return location for the number ot targets in the table
=end pod
}}

sub _gtk_target_table_new_from_list (
  N-GtkTargetList $list, gint $n_targets is rw --> CArray[uint8]
) is native(&gtk-lib)
  is symbol('gtk_target_table_new_from_list')
  { * }
