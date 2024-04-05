#!/usr/bin/env perl6

use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::MenuBar:api<1>;
use Gnome::Gtk3::Menu:api<1>;
use Gnome::Gtk3::MenuItem:api<1>;
use Gnome::Gtk3::TreePath:api<1>;
use Gnome::Gtk3::TreeStore:api<1>;
use Gnome::Gtk3::CellRendererText:api<1>;
use Gnome::Gtk3::TreeView:api<1>;
use Gnome::Gtk3::TreeViewColumn:api<1>;
use Gnome::Gtk3::TreeIter:api<1>;
use Gnome::Gtk3::TreeSelection:api<1>;
use Gnome::GObject::Type:api<1>;
use Gnome::GObject::Value:api<1>;

use Gnome::N::N-GObject:api<1>;
#Gnome::N::debug(:on);

my Gnome::Gtk3::Main $m .= new;

my Gnome::Gtk3::TreeStore $ts .= new(:field-types( G_TYPE_STRING));
my Gnome::Gtk3::TreeView $tv .= new(:model($ts));

class AppSignalHandlers {

  method edit( ) {
    note 'edit gs: ', $tv.gtk_tree_view_get_selection.perl;
    my Gnome::Gtk3::TreeSelection $tselect .= new(:treeview($tv));
    note 'edit sr: ', $tselect.get-selected-rows(N-GObject);
  }

  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}

my AppSignalHandlers $ash .= new;

my Gnome::GObject::Type $type .= new;
my int32 $menu-shell-gtype = $type.g_type_from_name('GtkMenuShell');
my Gnome::Gtk3::Window $top-window .= new(:title('A window with a menu'));
$top-window.set-size-request( 300, 300);

my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

my Gnome::Gtk3::Menu $menu = make-menubar-menu( $ash);
my Gnome::Gtk3::MenuItem $root-menu .= new(:label('File'));
$root-menu.set-submenu($menu);
my Gnome::Gtk3::MenuBar $menu-bar .= new;
$grid.gtk_grid_attach( $menu-bar, 0, 0, 1, 1);
$menu-bar.gtk-menu-shell-append($root-menu);

my Gnome::Gtk3::TreeIter $iter;
$grid.gtk_grid_attach( $tv, 0, 1, 1, 1);
my Gnome::Gtk3::CellRendererText $crt1 .= new();
my Gnome::Gtk3::TreeViewColumn $tvc .= new();
#$tvc.set-title('Some Header');

#my Gnome::GObject::Value $v .= new( :type(G_TYPE_BOOLEAN), :value<1>);

$tvc.pack-end( $crt1, 1);
$tvc.add-attribute( $crt1, 'text', 0);
$tv.append-column($tvc);

my Gnome::Gtk3::TreePath $tp;
my Gnome::Gtk3::TreeIter $parent-iter;

$tp .= new(:string('0'));
$parent-iter = $ts.get-iter($tp);
$iter = $ts.insert-with-values( $parent-iter, -1, 0, 'begin');

$tp .= new(:string('1'));
$parent-iter = $ts.get-iter($tp);
$iter = $ts.insert-with-values( $parent-iter, -1, 0, 'end');

$top-window.register-signal( $ash, 'exit-program', 'destroy');
$top-window.show-all;
$m.gtk-main;

# Create menu for the menu bar
sub make-menubar-menu ( AppSignalHandlers $ash ) {
  my Gnome::Gtk3::Menu $menu .= new;

  my Gnome::Gtk3::MenuItem $menu-item .= new(:label("Edit"));
  $menu.gtk-menu-shell-append($menu-item);
  $menu-item.register-signal( $ash, 'edit', 'activate');

  $menu
}
