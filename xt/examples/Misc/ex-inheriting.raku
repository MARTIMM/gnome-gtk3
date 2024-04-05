use v6.d;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Label:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Window:api<1>;

unit class VerticalHeaderLabel is Gnome::Gtk3::Label;

submethod new ( |c ) {
  # let the Gnome::Gtk3::Label class process the options
  self.bless( :GtkLabel, |c);
}

submethod BUILD ( ) {
  my Str $text = '<b><small>' ~ self.get-text ~ '</small></b>';
  self.set-text($text);
  self.set-use-markup(True);
  self.set-line-wrap(False);
  self.set-width-chars(16);
  self.set-angle(80);
}


my Gnome::Gtk3::Window $w .= new;
$w.set-title('inheriting and vertical labels example');

my Gnome::Gtk3::Grid $grid .= new;
$w.add($grid);

my Int $col = 1;
for ('success tests', 'failed tests', 'skipped tests', 'total') -> $hdr {
  my VerticalHeaderLabel $v .= new(:text($hdr));
  $grid.attach( $v, $col++, 0, 1, 1);
}

my $data = [
  ( 'foo', 10, 5, 2, 17),
  ( 'bar', 1, 12, 3, 16),
  ( 'baz', 2, 2, 1, 5),
];

my Int $row = 1;
for @$data -> @d {
  my Int $col = 0;
  for @d -> $col-data {
    my Str $text = $col-data ~~ Str
        ?? $col-data.fmt('%5s')
        !! $col-data.fmt('%3d');

    $grid.attach(
      Gnome::Gtk3::Label.new(:$text), $col++, $row, 1, 1
    );
  }
  $row++;
}

$w.show-all;
Gnome::Gtk3::Main.new.gtk-main;
