use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-test/lib';

use Gnome::T::Benchmark:api<1>;
use Gnome::Gtk3::Statusbar:api<1>;
use Gnome::Gtk3::Box:api<1>;

my Gnome::Gtk3::Statusbar $s .= new;

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project =
  Gnome::T::Benchmark.type-version(Gnome::Gtk3::Statusbar);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

my Str $msg1 = 'zou je dat wel doen?';
$b.run-test( 'Method calls', {
    my Int $cid1 = $s.get-context-id('FaFooFum');
    my Int $mid1 = $s.push( $cid1, $msg1);
    $s.pop($cid1);
    $s.remove( $cid1, 2);
    $s.remove-all($cid1);
  }
);

$b.run-test( 'Native sub search', {
    my Int $cid1 = $s.gtk-statusbar-get-context-id('FaFooFum');
    my Int $mid1 = $s.gtk-statusbar-push( $cid1, $msg1);
    $s.gtk-statusbar-pop($cid1);
    $s.gtk-statusbar-remove( $cid1, 2);
    $s.gtk-statusbar-remove-all($cid1);
  }
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

#$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
$b.search-compare-tests( :$sub-project, :!tables);
