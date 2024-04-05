use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Window:api<1>;

my Gnome::Gtk3::Window $w .= new(:title('My Button In My Window'));
$w.set-position(GTK_WIN_POS_MOUSE);

my Gnome::Gtk3::Button $b .= new(:label('The Button'));
$w.add($b);
$w.show-all;

$w.set-interactive-debugging(1);

my Gnome::Gtk3::Main $m .= new;
$m.gtk-main;
