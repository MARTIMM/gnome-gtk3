use v6;
#use lib '../gnome-gobject/lib';

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gdk3::Pixbuf;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::CellRendererText;
use Gnome::Gtk3::CellRendererPixbuf;
use Gnome::Gtk3::CellRendererProgress;
use Gnome::Gtk3::CellRendererToggle;
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

enum list-field-columns < TITLE-CODE TITLE SOLD LIKE PICT >;
my Gnome::Gtk3::TreeIter $iter;

my Gnome::Gdk3::Pixbuf $pb .= new(:file<xt/data/gtk-raku-64.png>);
my Int $pb-type = $pb.get-class-gtype;
#note "Pixbuf type: $pb-type";

my Gnome::Gtk3::Window $w .= new(:title('List store example'));
#$w.set-position(GTK_WIN_POS_MOUSE);
$w.set-border-width(10);
$w.set-default-size( 270, 250);

my Gnome::Gtk3::Grid $g .= new;
$w.gtk-container-add($g);

my Gnome::Gtk3::ListStore $ls .= new(
  :field-types( G_TYPE_INT, G_TYPE_STRING, G_TYPE_BOOLEAN, G_TYPE_INT, $pb-type)
);

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
$tvc.set-title('Order No');
$tvc.pack-end( $crt1, 1);
$tvc.add-attribute( $crt1, 'text', TITLE-CODE);
$tv.append-column($tvc);


my Gnome::Gtk3::CellRendererText $crt2 .= new;
$v .= new( :type(G_TYPE_STRING), :value<blue>);
$crt2.set-property( 'foreground', $v);
#$tv.insert-column-with-attributes( -1, 'title', $crt2);
$tvc .= new;
$tvc.set-title('Book Title');
$tvc.pack-end( $crt2, 1);
$tvc.add-attribute( $crt2, 'text', TITLE);
$tv.append-column($tvc);


my Gnome::Gtk3::CellRendererToggle $crt3 .= new;
$tvc .= new;
$tvc.set-title('Book sold out');
$tvc.pack-end( $crt3, 1);
$tvc.add-attribute( $crt3, 'active', SOLD);
$tv.append-column($tvc);


my Gnome::Gtk3::CellRendererProgress $crt4 .= new;
$tvc .= new;
$tvc.set-title('Rating');
$tvc.pack-end( $crt4, 1);
$tvc.add-attribute( $crt4, 'value', LIKE);
$tv.append-column($tvc);


my Gnome::Gtk3::CellRendererPixbuf $crt5 .= new;
$tvc .= new;
$tvc.set-title('Front Page');
$tvc.pack-end( $crt5, 1);
$tvc.add-attribute( $crt5, 'pixbuf', PICT);
$tv.append-column($tvc);



my Array $data = [
  [ 1001, 'duizend en een nacht', True, 96,
    Gnome::Gdk3::Pixbuf.new(:file<xt/data/amber-on-256.png>)
  ],
  [ 2002, 'een beetje later', False, 30,
    Gnome::Gdk3::Pixbuf.new(:file<xt/data/green-on-256.png>)
  ],
  [ 3003, 'en nog een beetje tekst', False, 71,
    Gnome::Gdk3::Pixbuf.new(:file<xt/data/red-on-256.png>)
  ]
];

#Gnome::N::debug(:on);
for @$data -> $row {
#note "Insert: ", $row.kv.join(', ');
  $iter = $ls.gtk-list-store-append;
  $ls.gtk-list-store-set( $iter, |$row.kv);
}

my X $x .= new;
$w.register-signal( $x, 'exit-gui', 'destroy');
$w.show-all;

#$w.set-interactive-debugging(1);

$m.gtk-main;
