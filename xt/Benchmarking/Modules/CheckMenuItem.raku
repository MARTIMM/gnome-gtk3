use v6;
use lib './lib';

use Gnome::T::Benchmark:api<1>;

use Gnome::N::N-GObject:api<1>;
use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);

use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::CheckMenuItem:api<1>;
#use Gnome::Gtk3::Entry:api<1>;

#my Gnome::Gtk3::Entry $entry .= new;
my Gnome::Gtk3::CheckMenuItem $*menu-item .= new(:label(Str));

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project =
  Gnome::T::Benchmark.type-version(Gnome::Gtk3::CheckMenuItem);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

$b.run-test(
  'Method calls',
  {
    given $*menu-item {
      .set-active(True);
      my Bool $b = .get-active;
      .set-inconsistent(True);
      $b = .get-inconsistent;
      .set-draw-as-radio(True);
      $b = .get-draw-as-radio;
    }
  },
#  :prepare( { $*menu-item .= new(:label<Start>); } ),
  :count(1000)
);

#`{{
$b.run-test(
  'Native sub search',
  {
    given $*menu-item {
    }
  },
#  :prepare( { $*menu-item .= new(:label<Start>); } ),
  :count(1000)
);
}}

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
