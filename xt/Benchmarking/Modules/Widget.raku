use v6;

use Gnome::T::Benchmark:api<1>;
use Gnome::Gtk3::Widget:api<1>;
use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Button:api<1>;

my Gnome::Gtk3::Button $*button;

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project = Gnome::T::Benchmark.type-version(Gnome::Gtk3::Widget);

my Gnome::T::Benchmark $b .= new(
  :default-count(1000), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);


my N-GtkAllocation $allocation .= new( :x(2), :y(2), :width(50), :height(20));
$b.run-test(
  'Method calls',
  {
    given $*button {
      .show;
      .hide;
      .show-now;
      .show-all;
      .set-no-show-all(True);
      my Bool $b = .get-no-show-all;
      .queue-draw;
      .queue-draw-area( 10, 10, 100, 100);
      .get-frame-clock;
      .size-allocate($allocation);
      .size-allocate-with-baseline( $allocation, 10);
      my GtkSizeRequestMode $re = .get-request-mode;

      .destroy;
    }
  },
  :prepare( { $*button .= new(:label<Start>); } ),
  :count(500)
);

#$button .= new(:label<Start>);
$b.run-test(
  'Native sub search',
  {
    given $*button {
      .gtk-widget-show;
      .gtk-widget-hide;
      .gtk-widget-show-now;
      .gtk-widget-show-all;
      .gtk-widget-set-no-show-all(True);
      my Int $i = .gtk-widget-get-no-show-all;
      .gtk-widget-queue-draw;
      .gtk-widget-queue-draw-area( 10, 10, 100, 100);
      .gtk-widget-get-frame-clock;
      .gtk-widget-size-allocate($allocation);
      .gtk-widget-size-allocate-with-baseline( $allocation, 10);
      $i = .gtk-widget-get-request-mode;

      .gtk-widget-destroy;
    }
  },
  :prepare( { $*button .= new(:label<Start>); } ),
  :count(500)
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
