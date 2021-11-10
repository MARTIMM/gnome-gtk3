use v6;

#-------------------------------------------------------------------------------
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Main;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Window $w .= new;
$w.set-title('icon-image');

my Gnome::Gtk3::Grid $g .= new;
$w.add($g);

my Int $row = 0;
my Int $col = 0;
add-image( $g, $col, $row++, 'document-multiple');
add-image( $g, $col, $row++, 'user-trash');
add-image( $g, $col, $row++, 'user-identity');

$row = 0;
$col = 1;
add-image( $g, $col, $row++, 'bqm-add');
add-image( $g, $col, $row++, 'call-start');
add-image( $g, $col, $row++, 'checkmark');
add-image( $g, $col, $row++, 'channelmixer');
add-image( $g, $col, $row++, 'list-add');
add-image( $g, $col, $row++, 'list-remove');

$row = 0;
$col = 2;
add-image( $g, $col, $row++, 'abrt');
add-image( $g, $col, $row++, 'accessories-dictionary');
#add-image( $g, $col, $row++, 'anjuta');
#add-image( $g, $col, $row++, 'author');

$row = 0;
$col = 3;
add-image( $g, $col, $row++, 'alarm-symbolic');
add-image( $g, $col, $row++, 'appointment-missed-symbolic');
add-image( $g, $col, $row++, 'appointment-missed');
add-image( $g, $col, $row++, 'audio-off');
add-image( $g, $col, $row++, 'battery-low');

$w.show-all;
$w.set-size-request( 100, 100);

Gnome::Gtk3::Main.new.gtk-main;

#-------------------------------------------------------------------------------
sub add-image ( Gnome::Gtk3::Grid $g, Int $col, Int $row,  Str $iname ) {

  my Gnome::Gtk3::Image $i .= new;
  $i.set-from-icon-name( $iname, GTK_ICON_SIZE_DIALOG);
  $g.grid-attach( $i, $col, $row, 1, 1);
}
