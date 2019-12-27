use v6;

unit class GuiHandlers;

use Gnome::N::N-GObject;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::TreeStore;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::TreeViewColumn;

#-------------------------------------------------------------------------------
class Application {

  has Gnome::Gtk3::Main $!main;

  #-----------------------------------------------------------------------------
  submethod BUILD (:$!main) { }

  method exit-todo-viewer ( --> Int ) {
    $!main.gtk-main-quit;

    1
  }
}

#-------------------------------------------------------------------------------
class ListView {

  has Str $!filename;

  #-----------------------------------------------------------------------------
  method select-list-entry (
    N-GtkTreePath $n-tree-path, N-GObject $n-treeview-column,
    Hash :$data, Int :$data-col, Gnome::Gtk3::TreeStore :$files,
    Gnome::Gtk3::ListStore :$markers
    --> Int
  ) {

    my Gnome::Gtk3::TreePath $tree-path;
    my Gnome::Gtk3::TreeIter $iter;

    # Clear the list store of its entries
    $tree-path .= new(:string('0'));
    $iter = $markers.tree-model-get-iter($tree-path);

    while $iter.tree-iter-is-valid {
      $iter = $markers.list-store-remove($iter);
    }

    # Get the key from the data column and check
    $tree-path .= new(:tree-path($n-tree-path));
    $iter = $files.tree-model-get-iter($tree-path);
    my Array[Gnome::GObject::Value] $v = $files.tree-model-get-value(
      $iter, $data-col
    );
    my Str $data-key = $v[0].get-string // '';
    $v[0].unset;

    # Return if there is no filename key
    return 1 unless ?$data-key;

    # Add new entries from the data using the filename data key
    for @($data{$data-key}) -> @entry {
      $iter = $markers.list-store-append;
      $markers.list-store-set( $iter, |(@entry.kv));
    }

    $!filename = $data-key;

    1
  }

  #-----------------------------------------------------------------------------
  method select-marker-entry (
    N-GtkTreePath $n-tree-path, N-GObject $n-treeview-column,
    Gnome::Gtk3::ListStore :$markers,
    --> Int
  ) {

    my Gnome::Gtk3::TreePath $tree-path .= new(:tree-path($n-tree-path));
    my Gnome::Gtk3::TreeIter $iter = $markers.tree-model-get-iter($tree-path);

    my Array[Gnome::GObject::Value] $v =
       $markers.tree-model-get-value( $iter, 1);
    my Int $line = $v[0].get-int // -1;
    $v[0].unset;

    note "Start atom editor with folowing file $!filename at line $line";
    run 'atom', $!filename ~ ":$line";

    1
  }
}
