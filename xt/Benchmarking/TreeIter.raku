use v6;
use lib '../gnome-gobject/lib';
use lib '../gnome-native/lib';

#use NativeCall;

use Gnome::N::N-GObject:api<1>;
use Gnome::GObject::Type:api<1>;
use Gnome::GObject::Value:api<1>;
#use Gnome::Gtk3::TreeModel:api<1>;
use Gnome::Gtk3::TreeIter:api<1>;
use Gnome::Gtk3::TreePath:api<1>;
use Gnome::Gtk3::ListStore:api<1>;

use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListStore $ls;
my Gnome::Gtk3::TreeIter $iter;
my Gnome::Gtk3::TreePath $tp;

enum ColumnNames < Col0 Col1 >;

#-------------------------------------------------------------------------------
my class ShowTabel {
  submethod BUILD ( ) {
    note "\n Row  | Number | String\n------+--------+-------------------";
  }

  method show-entry (
    N-GObject $nc-ls,
    Gnome::Gtk3::TreePath $c-path,
    Gnome::Gtk3::TreeIter $c-iter
    --> int32
  ) {
note 'step 0';
#    my Str $row = $c-path.to-string;
note 'step 1';
    my Gnome::Gtk3::ListStore $c-ls .= new(:native-object($nc-ls));
note 'step 2';
#`{{
    my Array[Gnome::GObject::Value] $va = $c-ls.get-value( $c-iter, Col0, Col1);
note 'step 3';

    note [~] $row.fmt('%5.5s'), ' | ',
             $va[Col0].get-int.fmt('%6d'), ' | ',
#             $va[Col1].get-string;
             $va[Col1].get-int;
note 'step 4';

    $va[Col0].clear-object;
note 'step 5';
    $va[Col1].clear-object;
note 'step 6';
}}

    0
  }
}

#-------------------------------------------------------------------------------
#$ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
$ls .= new(:field-types( G_TYPE_INT, G_TYPE_INT));
for ^100 {
  #$iter = $ls.gtk-list-store-append;
  $iter = $ls.gtk_list_store_insert(-1);
  $ls.set-value( $iter, Col0, 1001);
#  $ls.set-value( $iter, Col1, 'duizend en een nacht');
  $ls.set-value( $iter, Col1, 65436543);
}


#Gnome::N::debug(:on);
$ls.foreach( ShowTabel.new, 'show-entry');
