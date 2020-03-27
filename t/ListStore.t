use v6;
#use lib '../gnome-gobject/lib';

use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TreeModel;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::ListStore;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListStore $ls;
my Gnome::Gtk3::TreeIter $iter;
my Gnome::Gtk3::TreePath $tp;

enum ColumnNames < Col0 Col1 Col2 >; # Col2 is not used or set!

my class ShowTabel {
  submethod BUILD ( ) {
    diag "\n Row  | Number | String\n------+--------+-------------------";
  }

  method show-entry (
    N-GObject $nc-ls,
    Gnome::Gtk3::TreePath $c-path,
    Gnome::Gtk3::TreeIter $c-iter
  ) {
    my Str $row = $c-path.to-string;
    my Gnome::Gtk3::ListStore $c-ls .= new(:native-object($nc-ls));
    my Array[Gnome::GObject::Value] $va = $c-ls.get-value( $c-iter, Col0, Col1);

    diag [~] $row.fmt('%5.5s'), ' | ',
             $va[Col0].get-int.fmt('%6d'), ' | ',
             $va[Col1].get-string;

    $va[Col0].unset;
    $va[Col1].unset;

    0
  }
}

#-------------------------------------------------------------------------------
subtest 'ISA test', {
#  note "W: ", gtk_list_store_new( G_TYPE_INT, G_TYPE_STRING) // '-';
#  $ls .= new(:native-object(gtk_list_store_newv( G_TYPE_INT, G_TYPE_STRING)));
  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  isa-ok $ls, Gnome::Gtk3::ListStore, '.new(:field-types)';
}

#-------------------------------------------------------------------------------
# Setup test
$iter = $ls.gtk-list-store-append;
$ls.set-value( $iter, Col0, 1001);
$ls.set-value( $iter, Col1, 'duizend en een nacht');

$iter = $ls.gtk-list-store-append;
$ls.gtk-list-store-set( $iter, Col0, 2002, Col1, 'een beetje later');

#-------------------------------------------------------------------------------
subtest 'Interface TreeModel', {
  my Int $flags = $ls.get-flags;
  is GtkTreeModelFlags($flags +& 0x01), GTK_TREE_MODEL_ITERS_PERSIST,
     '.get-flags() bit 1';
  is GtkTreeModelFlags($flags +& 0x02), GTK_TREE_MODEL_LIST_ONLY,
     '.get-flags() bit 2';

  is $ls.get-n-columns, 2, '.get-n-columns()';
  is $ls.get-column-type(Col0), G_TYPE_INT, '.get-column-type()';

  $tp .= new(:first);
  ok 1, 'Iterator set to first row: ' ~ $tp.to-string;
  $iter = $ls.get-iter($tp);
  ok $iter.is-valid, '.get-iter()';
  $tp.next;
  $tp.next;
  ok 1, 'Iterator set to 3rd row: ' ~ $tp.to-string;
  $iter = $ls.get-iter($tp);
  nok $iter.is-valid, 'past the last row';

  ok 1, 'Iterator set to 2nd row: 1';
  $iter = $ls.get-iter-from-string('1');
  ok $iter.is-valid, '.get-iter-from-string()';
  #$iter = $ls.gtk_tree_model_get_iter_from_string('0:1');
  #ok $iter.is-valid, '.gtk_tree_model_get_iter_from_string()';

  is $ls.get-string-from-iter($iter), '1', '.get-string-from-iter()';

  $iter = $ls.get-iter-first;
  is $ls.get-string-from-iter($iter), '0', '.get-iter-first()';

  $tp = $ls.get-path($iter);
  is $tp.to-string, '0', '.get-path()';

  my Array[Gnome::GObject::Value] $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col0].get-int, 1001, '.get-value(): col0';
  is $va[Col1].get-string, 'duizend en een nacht', '.get-value(): col1';
  $va[Col0].unset;
  $va[Col1].unset;

  my Int $sts = $ls.iter-next($iter);
  ok 1, "there is a next path: $sts";
  $tp = $ls.get-path($iter);
  is $tp.to-string, '1', '.iter-next()';

  $sts = $ls.iter-previous($iter);
  ok 1, "there is a previous path: $sts";
  $tp = $ls.get-path($iter);
  is $tp.to-string, '0', '.iter-previous()';

  my Gnome::Gtk3::TreeIter $child-iter;
  $child-iter = $ls.iter-children($iter);
  nok $child-iter.is-valid,
      '.iter-children(): ListStore has no children';
  nok $ls.iter-has-child($iter),
      '.iter-has-child(): ListStore has no children';
  is $ls.iter-n-children($iter), 0, '.iter-n-children() children row 0';
  is $ls.iter-n-children(Any), 2, '.iter-n-children() top level nodes';

  is $ls.get-path($ls.iter-nth-child( Any, 0)).to-string, '0',
     '.iter-nth-child()';

  subtest 'gtk-container-foreach', {
    my class X {
      has $!row-count = 0;

      method row-loop (
        N-GObject $nl-loop,
        Gnome::Gtk3::TreePath $p-loop,
        Gnome::Gtk3::TreeIter $i-loop,
        :$test
      ) {
        is $p-loop.to-string, $!row-count.Str, 'row ok';
        is $ls.get-path($i-loop).to-string, $p-loop.to-string, 'iter == path';
        once is $test, 'abcdef', 'found test named attribute';
        $!row-count++;

        # stop walking to the next row
        1
      }
    }

#Gnome::N::debug(:on);
    $ls.gtk-tree-model-foreach( X.new, 'row-loop', :test<abcdef>);
  }
}

#-------------------------------------------------------------------------------
subtest 'Signals TreeModel', {

  my class X {
    has $.rc-signal = False;
    has $.ri-signal = False;
    has $.rd-signal = False;
    has $.rct-signal = False;
    has $.ro-signal = False;

    method reset-ro-signal ( ) {
      $!ro-signal = False;
    }

    method rc ( N-GObject $p, N-GtkTreeIter $i, :$widget ) {
      $!rc-signal = True;
    }

    method ri ( N-GObject $p, N-GtkTreeIter $i, :$widget ) {
      $!ri-signal = True;
    }

    method rd ( N-GObject $p, :$widget ) {
      $!rd-signal = True;
    }

    method rct ( N-GObject $p, N-GtkTreeIter $i, :$widget ) {
      $!rct-signal = True;
    }

    method ro ( N-GObject $p, N-GtkTreeIter $i, CArray[int32] $a, :$widget ) {
      $!ro-signal = True;
      is $a[0], 1, 'row 1 now at row 0';
    }
  }

  my X $x .= new;
  $ls.register-signal( $x, 'rc', 'row-changed');
  $ls.register-signal( $x, 'ri', 'row-inserted');
  $ls.register-signal( $x, 'rd', 'row-deleted');
  $ls.register-signal( $x, 'rct', 'row-has-child-toggled');
  $ls.register-signal( $x, 'ro', 'rows-reordered');

  $iter = $ls.get-iter-first;
  $tp .= new(:first);

  $ls.row-changed( $tp, $iter);
  ok $x.rc-signal, 'row-changed signal processed';
  $ls.row-inserted( $tp, $iter);
  ok $x.ri-signal, 'row-inserted signal processed';
  $ls.row-deleted($tp);
  ok $x.rd-signal, 'row-deleted signal processed';
  $ls.row-has-child-toggled( $tp, $iter);
  ok $x.rct-signal, 'row-has-child-toggled signal processed';
  $ls.rows-reordered( $tp, $iter, CArray[int32].new( 1, 0));
  ok $x.ro-signal, 'rows-reordered signal processed';
  $x.reset-ro-signal;
  $ls.rows-reordered-with-length( $tp, $iter, CArray[int32].new( 1, 0), 0);
  ok $x.ro-signal, 'rows-reordered-with-length signal processed';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $iter = $ls.insert-with-values( 0, Col0, 10, Col1, 'abacadabra');
  $tp = $ls.get-path($iter);
  is $tp.to-string, '0', '.insert-with-values()';
  my Array[Gnome::GObject::Value] $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col1].get-string, 'abacadabra', '.insert-with-values(): col1 ok';
  $va[Col0].unset;
  $va[Col1].unset;

  $iter = $ls.gtk-list-store-prepend;
  $tp = $ls.get-path($iter);
  is $tp.to-string, '0', '.gtk-list-store-prepend()';
  $ls.gtk-list-store-set( $iter, Col0, 4004, Col1, 'dus');
  $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col1].get-string, 'dus', '.gtk-list-store-prepend(): col1 ok';
  $va[Col0].unset;
  $va[Col1].unset;

  # remove the 'abacadabra' row
  $iter = $ls.get-iter-from-string('1');
  $iter = $ls.gtk-list-store-remove($iter);
  ok $iter.is-valid, '.gtk-list-store-remove()';

  $iter = $ls.gtk-list-store-insert(2);
  $ls.gtk-list-store-set( $iter, Col0, 555, Col1, 'en een nieuwe entry');
  ok $iter.is-valid, '.gtk-list-store-insert()';
  $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col1].get-string, 'en een nieuwe entry',
     '.gtk-list-store-insert(): col1 ok';
  $va[Col0].unset;
  $va[Col1].unset;

  my Gnome::Gtk3::TreeIter $sibling-iter = $ls.get-iter-from-string('3');
  $iter = $ls.insert-before($sibling-iter);
  $tp = $ls.get-path($sibling-iter);
  ok 1, "sibling moved from 3 to $tp.to-string()";
  $tp = $ls.get-path($iter);
  ok 1, "iter set to $tp.to-string()";
  $ls.gtk-list-store-set( $iter, Col0, 123, Col1, 'I am lost of words');
  $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col1].get-string, 'I am lost of words', '.insert-before(): col1 ok';
  $va[Col0].unset;
  $va[Col1].unset;

  $iter = $ls.insert-after($sibling-iter);
  $tp = $ls.get-path($sibling-iter);
  ok 1, "sibling moved from 4 to $tp.to-string()";
  $tp = $ls.get-path($iter);
  ok 1, "iter set to $tp.to-string()";
  $ls.gtk-list-store-set( $iter, Col0, 1098, Col1, '#me too');
  $va = $ls.get-value( $iter, Col0, Col1);
  is $va[Col1].get-string, '#me too', '.insert-after(): col1 ok';
  $va[Col0].unset;
  $va[Col1].unset;

  #Gnome::N::debug(:on);
  Gnome::N::debug(:off);
  $ls.foreach( ShowTabel.new, 'show-entry');
#  note ' ';

  $ls.gtk-list-store-clear;
  is $ls.iter-n-children(Any), 0, '.gtk-list-store-clear() no entries in table';

  $ls.foreach( ShowTabel.new, 'show-entry');
#  note ' ';

}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
