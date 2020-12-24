use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-test/lib';

use Gnome::T::Benchmark;
use Gnome::Gtk3::Assistant;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Frame;

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :project-version<0.34.3>,
  :sub-project<Assistant>, :path<xt/Benchmarking/Data>
);

my Gnome::Gtk3::Assistant $*assistant;
my Gnome::Gtk3::Frame $f1; # .= new(:label<page-1>);
my Gnome::Gtk3::Frame $f2; # .= new(:label<page-2>);
#my Gnome::Gtk3::Frame $f3 .= new(:label<page-3>);
$b.run-test( 'Method calls', {
    given $*assistant {
      .append-page($f1);
      .set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
      .append-page($f2);
      .set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);

      .set-current-page(1);
      my Int $i = .get-current-page;
#note 'x1';
#    $a.next-page;
#    $a.previous-page;
    }
  },

  :prepare( {
      $*assistant .= new;
      $f1 .= new(:label<page-1>);
      $f2 .= new(:label<page-2>);
    }
  ),
  :cleanup( {
      $*assistant.destroy;
    }
  ),
#  :count(2)
);

#$*assistant.destroy;

#$f1 .= new(:label<page-1>);
#$f2 .= new(:label<page-2>);
#$f3 .= new(:label<page-3>);
$b.run-test( 'Native sub search', {
    given $*assistant {
      .gtk-assistant-append-page($f1);
      .gtk-assistant-set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
      .gtk-assistant-append-page($f2);
      .gtk-assistant-set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);

      .gtk-assistant-set-current-page(0);
      my Int $i = .gtk-assistant-get-current-page;

  #    $a.gtk-assistant-next-page;
  #    $a.gtk-assistant-previous-page;
    }
  },

  :prepare( {
      $*assistant .= new;
      $f1 .= new(:label<page-1>);
      $f2 .= new(:label<page-2>);
    }
  ),
  :cleanup( {
      $*assistant.destroy;
    }
  ),
#  :count(2)
);

$b.compare-tests;

#$b.show-test('Native sub search');
#$b.show-test('Method calls');

#$b.save-tests;

#$b.md-test-table( '0.34.2.1', '2020.10.109', 'Assistant', 0, 1);
