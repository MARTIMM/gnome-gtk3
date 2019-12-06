use v6;

unit class Gui;

enum FileListColumns <FILENAME_COL TODO_COUNT_COL>;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::TreeViewColumn;
use Gnome::Gtk3::TreeStore;
use Gnome::Gtk3::CellRendererText;
use Gnome::Gtk3::TreePath;
use Gnome::Gtk3::TreeIter;

use Gnome::N::X;
#Gnome::N::debug(:on);

has Gnome::Gtk3::TreeView $!file-list-view;
has Gnome::Gtk3::TreeStore $!file-list-store;
has Hash $!tree-path-directory;
#has Array $!insert-path;

submethod BUILD ( ) {
  $!tree-path-directory = %();


  my Gnome::Gtk3::Window $w .= new(:title('Todo Viewer'));
  my Gnome::Gtk3::Grid $g .= new(:empty);
  $w.container-add($g);
  $w.set-border-width(10);
  $w.set-default-size( 270, 300);


  $!file-list-store .= new(:field-types( G_TYPE_STRING, G_TYPE_INT));
  $!file-list-view .= new(:model($!file-list-store));
  $!file-list-view.set-hexpand(1);
  $!file-list-view.set-vexpand(1);
  $!file-list-view.set-headers-visible(1);
  $g.grid-attach( $!file-list-view, 0, 0, 1, 1);


  my Gnome::Gtk3::CellRendererText $crt .= new(:empty);
  my Gnome::GObject::Value $v .= new( :type(G_TYPE_STRING), :value<blue>);
  $crt.set-property( 'foreground', $v);
  my Gnome::Gtk3::TreeViewColumn $tvc .= new(:empty);
  $tvc.set-title('Filename');
  $tvc.pack-end( $crt, 1);
  $tvc.add-attribute( $crt, 'text', 0);
  $!file-list-view.append-column($tvc);

  $crt .= new(:empty);
#  $v .= new( :type(G_TYPE_STRING), :value<blue>);
#  $crt.set-property( 'foreground', $v);
  $tvc .= new(:empty);
  $tvc.set-title('Todo Count');
  $tvc.pack-end( $crt, 1);
  $tvc.add-attribute( $crt, 'text', 0);
  $!file-list-view.append-column($tvc);


  $w.show-all;
}

method add-file-data (
  Str $base-name, Str $filename-path, Array $data
) {
note "\nFile path: $base-name/$filename-path";

  self!insert-in-table( "$base-name/$filename-path".split('/'), $data);
}

method activate ( ) {
  Gnome::Gtk3::Main.new.gtk-main;
}

method !insert-in-table ( @path-parts, Array $data ) {

  return unless @path-parts.elems;

  my Callable $s = sub ( @path-parts is copy, Array :$ts-iter-path is copy ) {

    my Bool $found = False;
    my Str $part;
    my Gnome::Gtk3::TreeIter $iter;
    while ( ($iter = self!get-iter($ts-iter-path)).tree-iter-is-valid ) {
#      last unless @path-parts.elems;
      $part = @path-parts.shift;

      my Array[Gnome::GObject::Value] $v =
         $!file-list-store.get-value( $iter, FILENAME_COL);
      my Str $filename-table-entry = $v[0].get-string // '-';
      $v[0].unset;

      # Test if part is in the treestore at the provided path
      last unless @path-parts.elems;
      my Order $order = $part cmp $filename-table-entry;
note "cmp: $part <=> $filename-table-entry: ", $order;

      # Insert entry before this one and go a level deeper with the rest
      if $order == Less {
        $iter = $!file-list-store.insert-before(
          self!get-parent-iter($ts-iter-path),      # parent
          self!get-iter($ts-iter-path)              # sybling
        );

        $!file-list-store.set-value( $iter, FILENAME_COL, $part);
        $!file-list-store.set-value( $iter, TODO_COUNT_COL, 1);
        $ts-iter-path.push(0);
        $s( @path-parts, :$ts-iter-path);
      }

      elsif $order == Same {

      }

      else { # $order == More

      }


note "Test path: ", @path-parts.perl, ', ', $ts-iter-path;
    }

    # Not found on this level => $iter not defined
    if !$found and @path-parts.elems {
      $part = @path-parts.shift;
      my Gnome::Gtk3::TreeIter $parent-iter = self!get-iter($ts-iter-path);
      $iter = $!file-list-store.gtk-tree-store-append($parent-iter);
#Gnome::N::debug(:on);
#      $!file-list-store.set-value( $iter, FILENAME_COL, $part);
#      $!file-list-store.set-value( $iter, TODO_COUNT_COL, 0);
      $!file-list-store.set( $iter, FILENAME_COL, $part, TODO_COUNT_COL, 0);
#Gnome::N::debug(:off);

      $ts-iter-path.push(0);
      $s( @path-parts, :$ts-iter-path);
    }
  }

  # start inserting
  $s( @path-parts, :ts-iter-path([0]));
}



#`{{
method !insert-in-table ( @path-parts, Array $data ) {

  my Callable $s = sub (
    @path-parts is copy, Array :$ts-iter-path is copy
  ) {

    $ts-iter-path //= [0,];
#    my Str $ts-parent-path = $ts-iter-path.join(':');
#    my Gnome::Gtk3::TreePath $tpp .= new(:string($ts-parent-path));
#    my Gnome::Gtk3::TreeIter $parent-iter = $!file-list-store.get-iter($tpp);
    my Gnome::Gtk3::TreeIter $parent-iter;
    my Gnome::Gtk3::TreeIter $iter = self!get-iter($ts-iter-path);

note "PPP: ", @path-parts.perl, ', ', $ts-iter-path.perl,
      ', ', $iter.tree-iter-is-valid;

    my Bool $found = False;
    while ( $iter.tree-iter-is-valid ) {

      my Array[Gnome::GObject::Value] $v =
         $!file-list-store.get-value( $iter, FILENAME_COL);
      my Str $filename-table-entry = $v[0].get-string;
      $v[0].unset;

      # Test if part is in the treestore at the provided path
      last unless @path-parts.elems;
      my Str $first-part = @path-parts.shift;
      my Order $order = $first-part cmp $filename-table-entry;
note "cmp: $first-part <=> $filename-table-entry: ", $order;

      if $order == Same {
        # part is found, go one level deeper if possible
        if @path-parts.elems {
          $ts-iter-path.push(0);
note "Go deeper: ", $ts-iter-path.perl;
          $s( @path-parts, :$ts-iter-path);
        }

        else {
          # whole tree is found so only other columns needs to set
note "Now set value: ", $ts-iter-path.perl, ', ', $!file-list-store.get-path($iter).to-string;
          $!file-list-store.set-value( $iter, TODO_COUNT_COL, $data.elems);
          $found = True;
        }
        last;
      }

      elsif $order == Less {
#        $ts-parent-path = $ts-iter-path.join(':');
#note "Insert before (last): ", $ts-parent-path;
#        $tpp .= new(:string($ts-parent-path));
#        $parent-iter = $!file-list-store.get-iter($tpp);

#        $parent-iter = self!get-parent-iter($ts-iter-path);
#        my Int $location = self!get-position($ts-iter-path);
#Gnome::N::debug(:on);
        $iter = $!file-list-store.insert-before(
          self!get-parent-iter($ts-iter-path),
          self!get-iter($ts-iter-path)
        );

        $!file-list-store.set-value( $iter, FILENAME_COL, $first-part);
        $ts-iter-path.push(0);
        $s( @path-parts, :$ts-iter-path);
#Gnome::N::debug(:off);
      }

      else {  # $order == More
        # not found yet, try next entry
        $ts-iter-path[*-1]++;
#        $ts-parent-path = $ts-iter-path.join(':');
#note "NFY: ", $ts-parent-path;
#        $tpp .= new(:string($ts-parent-path));
#        $parent-iter = $!file-list-store.get-iter($tpp);
#note "I: ", $ts-iter-path.perl, ', ', self!get-iter($ts-iter-path);

        $iter = self!get-iter($ts-iter-path);
      }
note "next: ", $!file-list-store.get-path($iter).to-string if ?$iter;
    }

    if !$found {
#      my Gnome::Gtk3::TreeIter $iter = $parent-iter;
#      my Int $location;
      for @path-parts -> $part {
        $parent-iter = self!get-parent-iter($ts-iter-path);
#        my Int $location = self!get-position($ts-iter-path);
        my Gnome::Gtk3::TreeIter $iter =
          $!file-list-store.gtk-tree-store-append($parent-iter);
        $!file-list-store.set-value( $iter, FILENAME_COL, $part);

        # prepare for deeper level if any
        $ts-iter-path.push(0);
note "!F: $part, ", $!file-list-store.get-path($iter).to-string, ', ', $ts-iter-path;
      }

#note "SD: ", $!file-list-store.get-path($iter).to-string,
#              ', ', TODO_COUNT_COL.value, ', ', $data.elems
#              if ?$iter;

      $!file-list-store.set-value( $iter, TODO_COUNT_COL, $data.elems);
    }
  }


  # start inserting
  $s(@path-parts);
}
}}


method !get-iter ( Array $store-location --> Gnome::Gtk3::TreeIter ) {
note "GI 0: ", $store-location.perl;
  my Gnome::Gtk3::TreePath $tp .= new(
    :string($store-location[0 .. *-1].join(':'))
  );

note "GI 1: ", $tp.to-string, ', ', ($!file-list-store.get-iter($tp) // '-');
  $!file-list-store.get-iter($tp)
}

method !get-parent-iter ( Array $store-location --> Gnome::Gtk3::TreeIter ) {
note "GPI: ", $store-location.perl;
  my Gnome::Gtk3::TreeIter $parent-iter;
  if $store-location.elems > 1 {
    $parent-iter = $!file-list-store.get-iter(
      Gnome::Gtk3::TreePath.new(:string($store-location[0 ..^ *-1].join(':')))
    );
  }

  else {
    $parent-iter .= new(:tree-iter(N-GtkTreeIter));
  }

  $parent-iter
}

method !get-position ( Array $store-location --> Int ) {
  $store-location[*-1]
}
