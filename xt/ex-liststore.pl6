use v6;
#use lib '../gnome-gobject/lib';

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::CellRendererText;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::TreeViewColumn;
use Gnome::Gtk3::TreeIter;

use Gnome::N::X;
#Gnome::N::debug(:on);


my Gnome::Gtk3::Main $m .= new;

class X {
  method exit-gui ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}

enum list-field-columns < TITLE-CODE TITLE >;
my Gnome::Gtk3::TreeIter $iter;


my Gnome::Gtk3::Window $w .= new(:title('List store example'));
#$w.set-position(GTK_WIN_POS_MOUSE);
$w.set-border-width(10);
$w.set-default-size( 270, 250);

my Gnome::Gtk3::Grid $g .= new;
$w.gtk-container-add($g);


my Gnome::Gtk3::ListStore $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
my Gnome::Gtk3::TreeView $tv .= new(:model($ls()));
$tv.set-hexpand(1);
$tv.set-vexpand(1);
$tv.set-headers-visible(1);
$g.gtk-grid-attach( $tv, 0, 0, 1, 1);


my Gnome::Gtk3::CellRendererText $crt1 .= new;
my Gnome::GObject::Value $v .= new( :type(G_TYPE_STRING), :value<red>);
$crt1.set-property( 'foreground', $v);
#$tv.insert-column-with-attributes( -1, 'order no', $crt1);
my Gnome::Gtk3::TreeViewColumn $tvc .= new;
$tvc.set-title('order no');
$tvc.pack-end( $crt1, 1);
$tvc.add-attribute( $crt1, 'text', 0);
$tv.append-column($tvc);


my Gnome::Gtk3::CellRendererText $crt2 .= new;
my Gnome::GObject::Value $v .= new( :type(G_TYPE_STRING), :value<blue>);
$crt2.set-property( 'foreground', $v);
#$tv.insert-column-with-attributes( -1, 'title', $crt2);
$tvc .= new;
$tvc.set-title('book title');
$tvc.pack-end( $crt2, 1);
$tvc.add-attribute( $crt2, 'text', 1);
$tv.append-column($tvc);


my Array $data = [
  [ 1001, 'duizend en een nacht'],
  [ 2002, 'een beetje later'],
];

for @$data -> $row {
note "Insert: ", $row.kv.join(', ');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, |$row.kv);
}

$iter = $ls.gtk-list-store-append;
$ls.set-value( $iter, 0, 3003);
$ls.set-value( $iter, 1, 'en nog een beetje tekst');


my X $x .= new;
$w.register-signal( $x, 'exit-gui', 'destroy');
$w.show-all;

#$w.set-interactive-debugging(1);

$m.gtk-main;
