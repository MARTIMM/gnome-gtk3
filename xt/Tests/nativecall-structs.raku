use v6;
use NativeCall;
use Gnome::N::GlibToRakuTypes:api<1>;

#-------------------------------------------------------------------------------
class N-GValue is repr('CStruct') is export {
  has gint $.g-type;

  # Data is a union. We do not use it but GTK does, so here it is
  # only set to a type with 64 bits for the longest field in the union.
  has gint64 $!g-data;

  # As if it was G_VALUE_INIT macro. g_value_init() must have the type
  # set to 0.
  submethod TWEAK {
    $!g-type = 0;
    $!g-data = 0;
  }

  method set-type($t) {
    $!g-type = $t;
  }
}

my N-GValue $v .= new;
note "gtype=$v.g-type()";
$v.set-type(2);
note "gtype=$v.g-type()";

#-------------------------------------------------------------------------------
class N-GtkTargetEntry is repr('CStruct') is export {
  has Str $.target;
  has guint $.flags;
  has guint $.info;

  submethod BUILD ( Str :$target, Int :$!flags, Int :$!info ) {
    $!target := $target;
  }
};

my N-GtkTargetEntry $te .= new( :target('number'), :flags(0), :info(1));
note "target=$te.target(), flags=$te.flags(), info=$te.info()";

#-------------------------------------------------------------------------------
my $array-size = nativesizeof(N-GtkTargetEntry);
class TargetEntryBytes is repr('CUnion') {
  HAS N-GtkTargetEntry $.target-entry;
  HAS CArray[uint8] $.target-bytes;

  submethod BUILD ( N-GtkTargetEntry :$target-entry ) {
    $!target-entry := $target-entry;
  }
}

$te .= new( :target('text/plain'), :flags(0), :info(0x876));
my TargetEntryBytes $tb .= new(:target-entry($te));
#$tb.target-entry($te);
note "target=$tb.target-entry.target(), flags=$tb.target-entry.flags(), info=$tb.target-entry.info()";
note "bytes: ", $tb.target-bytes[0..($array-size-1)]>>.fmt('%02x');
