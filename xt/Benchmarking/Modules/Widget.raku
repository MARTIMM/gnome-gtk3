use v6;

use Gnome::T::Benchmark;
use Gnome::Gtk3::Button;

my Gnome::Gtk3::Button $*button;

my Gnome::T::Benchmark $b .= new(
  :default-count(1000), :project<gnome-gtk3>, :project-version<0.34.2.1>,
  :sub-project<Widget>, :path<xt/Benchmarking/Data>
);

$b.run-test(
  'Destroy Method call',
  {
    given $*button {
      .show;
      .hide;
      .show-now;
      .show-all;
      .set-no-show-all(True);
      my Bool $b = .get_no_show_all;
      .queue-draw;
      .queue-draw-area( 10, 10, 100, 100);
      .get-frame-clock;

      .destroy;
    }
  },
  :prepare( { $*button .= new(:label<Start>); } ),
  :count(500)
);

#$button .= new(:label<Start>);
$b.run-test(
  'Native destroy sub',
  {
    given $*button {
      .gtk-widget-show;
      .gtk-widget-hide;
      .gtk-widget-show-now;
      .gtk-widget-show-all;
      .gtk-widget-set-no-show-all(True);
      my Int $i = .gtk-widget-get_no_show_all;
      .gtk-widget-queue-draw;
      .gtk-widget-queue-draw-area( 10, 10, 100, 100);
      .gtk-widget-get-frame-clock;

      .gtk-widget-destroy;
    }
  },
  :prepare( { $*button .= new(:label<Start>); } ),
  :count(500)
);

$b.compare-tests;

#$b.show-test('Native sub search');
#$b.show-test('Method calls');
$b.save-tests;

#$b.md-test-table( '0.34.2.1', '2020.10.109', 'AboutDialog', 0, 1);
