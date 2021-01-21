use v6;
use lib './lib';

use Gnome::T::Benchmark;

use Gnome::N::N-GObject;
use Gnome::N::X;
#Gnome::N::debug(:on);

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::CheckMenuItem;
#use Gnome::Gtk3::Entry;

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
