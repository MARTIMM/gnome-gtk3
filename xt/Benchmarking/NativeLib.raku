use v6;
#use lib '../gnome-native/lib';

sub cairo-lib2 ( --> Str ) is export { 'libcairo.so.2'; }

use Gnome::T::Benchmark:api<1>;

use Gnome::N::NativeLib:api<1>;
#use Gnome::N::X:api<1>;

my Str $project-version = 'Gnome::N-0.18.5.3';
my Str $sub-project = 'NativeLib-0.2.1.1';

my Gnome::T::Benchmark $b .= new(
  :default-count(100000), :project<gnome-native>,
  :$project-version, :$sub-project,
  :path<xt/Benchmarking/Data>
);

#$button .= new(:label<Start>);
$b.run-test(
  'direct without cache', {
    my Str $s = cairo-lib();
  },
#  :prepare( { $*Label .= new(:label<Start>); } ),
#  :count(1000)
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);

$b.search-compare-tests(
  :project-version<Gnome::N>, :sub-project<NativeLib>, :!tables,
  :test-text('direct without cache')
);
