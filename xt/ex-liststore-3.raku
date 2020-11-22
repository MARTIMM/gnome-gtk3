use v6;
#use lib '../gnome-gobject/lib';

use Gnome::GObject::Type;
use Gnome::GObject::Value;

use Gnome::Gdk3::Pixbuf;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::CellRenderer;
use Gnome::Gtk3::CellRendererText;
use Gnome::Gtk3::CellRendererPixbuf;
use Gnome::Gtk3::CellRendererProgress;
use Gnome::Gtk3::CellRendererToggle;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::TreeViewColumn;
use Gnome::Gtk3::TreeIter;
use Gnome::Gtk3::Tooltip;

use Gnome::N::N-GObject;
use Gnome::N::X;
#Gnome::N::debug(:on);


my Gnome::Gtk3::Main $m .= new;

class X {
  method exit-gui ( ) {
    $m.main-quit;
  }

  # tips from https://www.reddit.com/r/learnpython/comments/b6dva1/gtk3_adding_tooltips_to_treeview_cells/
  method tooltip (
    Int $x, Int $y, Int $kb-mode, N-GObject $n-tooltip,
    Gnome::Gtk3::TreeView :_widget($treeview), Array :$tooltips
    --> int32
  ) {

#CATCH {.note};
#Gnome::N::debug(:on);

    my int32 $show-tooltip = 0;

    # convert widget coordinates into those of the treeview
    my List $cc = $treeview.convert-widget-to-bin-window-coords( $x, $y);

    # get path from the converted coordinates
    my List $pp = $treeview.get-path-at-pos( $cc[0], $cc[1]);

    # if path is defined, then w're on some row or column
    if ?$pp[0] {
      #TODO if ?$kb-mode {} else {
      my Gnome::Gtk3::TreePath $path := $pp[1];
      my Gnome::Gtk3::TreeViewColumn $column := $pp[2];

#note "xy: $x, $y, $cc[0], $cc[1], $pp[3], $pp[4], path: $path.to-string(), $column.get-title()";

#note "tt: $n-tooltip.perl()";

    my Gnome::Gtk3::Tooltip $tooltip .= new(:native-object($n-tooltip));
    if $column.get-title eq 'Front Page' {
#Gnome::N::debug(:on);
      $show-tooltip = 1;
      my Int $idx = $path.to-string.Int;
#note "set tooltip path $idx: {$tooltips[$idx].substr( 0, 20)} …";
      $tooltip.set-text($tooltips[$idx]);
#      $tooltip.set-visible(True);

      $treeview.set-tooltip-cell( $tooltip, $path, $column, N-GObject);
#      $treeview.set-tooltip-row( $tooltip, $path);
#Gnome::N::debug(:off);
    }
#    note 'tv: ', $treeview.perl;
#Gnome::N::debug(:off);

      $path.clear-object;
    }

    $show-tooltip
  }
}
my X $x .= new;

enum list-field-columns < TITLE-CODE TITLE SOLD LIKE PICT >;
my Gnome::Gtk3::TreeIter $iter;

# must initialize a pixbuf before a class type is known because
# pixbuf is not a basic type like G_TYPE_INT or G_TYPE_DOUBLE.
my %defaults = :width(80), :height(80), :preserve_aspect_ratio(True);
my Array $tooltips = [
  'Albert Finney and Diane Cilento in Tom Jones (1963): \'Fielding\'s novel might have been made for the screen.\' Photograph: Everett Collection/ Rex Features',

  'Detail of the frontispiece of the fourth edition of The Pilgrim\'s Progress (1680). Photograph: Alamy',

  'On the island of Lilliput: a colour print from an 1860s edition of Gulliver’s Travels. Photograph: Alamy',
];
my Array $Xtooltips = [
  't1',
  't2',
  't3',
];

my Gnome::Gdk3::Pixbuf $b1 .= new( :file<xt/data/b1-tomj.jpg>, |%defaults);
my Gnome::Gdk3::Pixbuf $b2 .= new( :file<xt/data/b2-pilp.jpg>, |%defaults);
my Gnome::Gdk3::Pixbuf $b3 .= new( :file<xt/data/b3-gulv.jpg>, |%defaults);
my Int $pb-type = $b1.get-class-gtype;



my Gnome::Gtk3::ListStore $ls .= new(
  :field-types( G_TYPE_INT, G_TYPE_STRING, G_TYPE_BOOLEAN, G_TYPE_INT, $pb-type)
);

given my Gnome::Gtk3::TreeView $tv .= new(:model($ls)) {
  .set-hexpand(1);
  .set-vexpand(1);
  .set-headers-visible(1);
  .set-has-tooltip(True);
  .register-signal( $x, 'tooltip', 'query-tooltip', :$tooltips);
}

my Gnome::Gtk3::CellRendererText $crt1 .= new;
my Gnome::GObject::Value $v .= new( :type(G_TYPE_STRING), :value<red>);
$crt1.set-property( 'foreground', $v);
set-col-specs( $crt1, 'Order No', 'text', TITLE-CODE, $tv);

my Gnome::Gtk3::CellRendererText $crt2 .= new;
$v .= new( :type(G_TYPE_STRING), :value<blue>);
$crt2.set-property( 'foreground', $v);
set-col-specs( $crt2, 'Book Title', 'text', TITLE, $tv);

my Gnome::Gtk3::CellRendererToggle $crt3 .= new;
set-col-specs( $crt3, 'Book sold out', 'active', SOLD, $tv);

my Gnome::Gtk3::CellRendererProgress $crt4 .= new;
set-col-specs( $crt4, "Public\nOpinion", 'value', LIKE, $tv);

my Gnome::Gtk3::CellRendererPixbuf $crt5 .= new;
set-col-specs( $crt5, 'Front Page', 'pixbuf', PICT, $tv);


my Array $data = [
  [ 1001, 'Tom Jones', True, 96, $b1 ],
  [ 2002, 'The Pilgrim’s Progress', False, 30, $b2 ],
  [ 3003, 'Gulliver’s Travels', False, 71, $b3 ]
];

for @$data -> $row {
  $iter = $ls.list-store-append;
  $ls.list-store-set( $iter, |$row.kv);
#  $tv.set-tooltip-row( $tooltips.shift, $ls.get-path($iter));
}


my Gnome::Gtk3::Grid $g .= new;
$g.grid-attach( $tv, 0, 0, 1, 1);

given my Gnome::Gtk3::Window $w .= new(:title('List store example')) {
  .set-position(GTK_WIN_POS_MOUSE);
  .set-keep-above(True);
  .set-border-width(10);
#  .set-default-size( 270, 250);
  .container-add($g);
  .register-signal( $x, 'exit-gui', 'destroy');
  .show-all;
}

$m.gtk-main;

#-------------------------------------------------------------------------------
sub set-col-specs (
  Gnome::Gtk3::CellRenderer $cr, Str $title, Str $attribute,
  list-field-columns $colnbr, Gnome::Gtk3::TreeView $tv
) {
  given my Gnome::Gtk3::TreeViewColumn $tvc .= new {
    .set-title($title);
    .pack-end( $cr, 1);
    .add-attribute( $cr, $attribute, $colnbr);
  }
  $tv.append-column($tvc);
}
