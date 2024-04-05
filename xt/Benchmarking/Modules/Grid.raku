use v6;

use Gnome::T::Benchmark:api<1>;

use Gnome::N::N-GObject:api<1>;
#use Gnome::N::X:api<1>;

use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Label:api<1>;

my Gnome::Gtk3::Grid $*grid;
my Gnome::Gtk3::Label $l1;
my Gnome::Gtk3::Label $l2;

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project = Gnome::T::Benchmark.type-version(Gnome::Gtk3::Grid);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

$b.run-test(
  'Method calls',
  {
    given $*grid {
      .attach( $l1, 0, 0, 1, 1);
      .attach-next-to( $l2, $l1, GTK_POS_LEFT, 1, 1);
      my N-GObject $no = .get-child-at( 0, 0);
      .insert-row(2);
      .insert-column(2);
      .remove-row(2);
      .remove-column(2);
      .insert-next-to( $l2, GTK_POS_LEFT);
      .set-row-homogeneous(True);
      my Bool $b = .get-row-homogeneous;
      .set-row-spacing(2);
      my UInt $u = .get-row-spacing;
      .set-column-homogeneous(True);
      $b = .get-column-homogeneous;
      .set-column-spacing(2);
      $u = .get-column-spacing;
      .set-row-baseline-position( 1, GTK_BASELINE_POSITION_CENTER);
      my GtkBaselinePosition $bp = .get-row-baseline-position(1);
      .set-baseline-row(1);
      my Int $i = .get-baseline-row;
    }
  },
  :prepare( {
      $*grid .= new;
      $l1 .= new(:text<l1>);
      $l2 .= new(:text<l2>);
    }
  ),
#  :count(1)
);

#$button .= new(:label<Start>);
$b.run-test(
  'Native sub search',
  {
    given $*grid {
      .gtk-grid-attach( $l1, 0, 0, 1, 1);
      .gtk-grid-attach-next-to( $l2, $l1, GTK_POS_LEFT, 1, 1);
      my N-GObject $no = .gtk-grid-get-child-at( 0, 0);
      .gtk-grid-insert-row(2);
      .gtk-grid-insert-column(2);
      .gtk-grid-remove-row(2);
      .gtk-grid-remove-column(2);
      .gtk-grid-insert-next-to( $l2, GTK_POS_LEFT);
      .gtk-grid-set-row-homogeneous(True);
      my Int $i = .gtk-grid-get-row-homogeneous;
      .gtk-grid-set-row-spacing(2);
      my UInt $u = .gtk-grid-get-row-spacing;
      .gtk-grid-set-column-homogeneous(True);
      $i = .gtk-grid-get-column-homogeneous;
      .gtk-grid-set-column-spacing(2);
      $u = .gtk-grid-get-column-spacing;
      .gtk-grid-set-row-baseline-position( 1, GTK_BASELINE_POSITION_CENTER);
      $i = .gtk-grid-get-row-baseline-position(1);
      .gtk-grid-set-baseline-row(1);
      $i = .gtk-grid-get-baseline-row;
    }
  },
  :prepare( {
      $*grid .= new;
      $l1 .= new(:text<l1>);
      $l2 .= new(:text<l2>);
    }
  ),
#  :count(1)
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
