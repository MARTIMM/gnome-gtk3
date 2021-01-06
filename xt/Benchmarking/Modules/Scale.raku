use v6;
use lib './lib';

use Gnome::T::Benchmark;

use Gnome::N::N-GObject;
use Gnome::N::X;
#Gnome::N::debug(:on);

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Scale;
#use Gnome::Gtk3::Entry;


#my Gnome::Gtk3::Entry $entry .= new;
my Gnome::Gtk3::Scale $*scale .= new(:text(Str));

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project = Gnome::T::Benchmark.type-version(Gnome::Gtk3::Scale);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

$b.run-test(
  'Method calls',
  {
    given $*scale {
      .set-digits(2);
      my Int $i = .get-digits;
      .set-draw-value(True);
      my Bool $b = .get-draw-value;
      .set-value-pos(GTK_POS_TOP);
      my GtkPositionType $gp = .get-value-pos;
      .set-has-origin(True);
      $b = .get-has-origin;
      .add-mark( 2.2, GTK_POS_TOP, '11e-1');
      .clear-marks;
    }
  },
#  :prepare( { $*scale .= new(:label<Start>); } ),
  :count(1000)
);

$b.run-test(
  'Native sub search',
  {
    given $*scale {
      .gtk-scale-set-digits(2);
      my Int $i = .get-digits;
      .gtk-scale-set-draw-value(True);
      $i = .gtk-scale-get-draw-value;
      .gtk-scale-set-value-pos(GTK_POS_TOP);
      $i = .gtk-scale-get-value-pos;
      .gtk-scale-set-has-origin(True);
      $i = .gtk-scale-get-has-origin;
      .gtk-scale-add-mark( 2.2, GTK_POS_TOP, '11e-1');
      .gtk-scale-clear-marks;
    }
  },
#  :prepare( { $*scale .= new(:label<Start>); } ),
  :count(1000)
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
