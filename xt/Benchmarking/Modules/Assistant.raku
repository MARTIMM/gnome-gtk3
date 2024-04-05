use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-test/lib';

use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::T::Benchmark:api<1>;
use Gnome::Gtk3::Assistant:api<1>;
use Gnome::Gtk3::Frame:api<1>;
use Gnome::Gtk3::Button:api<1>;

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project = Gnome::T::Benchmark.type-version(Gnome::Gtk3::Assistant);

my Gnome::T::Benchmark $b .= new(
  :default-count(400), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

my Gnome::Gtk3::Assistant $*assistant;
my Gnome::Gtk3::Frame $f1;
my Gnome::Gtk3::Frame $f2;
my Gnome::Gtk3::Frame $f3;
my Gnome::Gtk3::Button $bttn;

$b.run-test( 'Method calls', {
    given $*assistant {
      my Int $i = .append-page($f1);
      .set-page-title( $f1, 'title');
      my Str $s = .get-page-title($f1);
      .set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
      my GtkAssistantPageType $pt = .get-page-type($f1);
      $i = .prepend-page($f2);
#      .set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);
      $i = .insert-page( $f3, 0);
      .remove-page($i);

      .set-page-complete( $f2, True);
      my Bool $bl = .get-page-complete($f2);

      .set-current-page(1);
      $i = .get-current-page;
      $i = .get-n-pages;
      my N-GObject $no = .get-nth-page(0);

      .add-action-widget($bttn);
      .remove-action-widget($bttn);
      .update-buttons-state;
      .commit;

      .set-page-has-padding( $f2, True);
      $bl = .get-page-has-padding($f2);

#    $a.next-page;
#    $a.previous-page;
    }
  },

  :prepare( {
      $*assistant .= new;
      $f1 .= new(:label<page-1>);
      $f2 .= new(:label<page-2>);
      $f3 .= new(:label<page-3>);
      $bttn .= new(:label<action>);
    }
  ),
  :cleanup( {
      $*assistant.destroy;
    }
  ),
);

$b.run-test( 'Native sub search', {
    given $*assistant {
      my Int $i = .gtk-assistant-append-page($f1);
      .gtk-assistant-set-page-title( $f1, 'title');
      my Str $s = .gtk-assistant-get-page-title($f1);
      .gtk-assistant-set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
      my GEnum $e = .gtk-assistant-get-page-type($f1);
      $i = .gtk-assistant-prepend-page($f2);
#      .gtk-assistant-set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);
      $i = .gtk-assistant-insert-page( $f3, 0);
      .gtk-assistant-remove-page($i);

      .gtk-assistant-set-page-complete( $f2, True);
      $i = .gtk-assistant-get-page-complete($f2);

      .gtk-assistant-set-current-page(0);
      $i = .gtk-assistant-get-current-page;
      $i = .gtk-assistant-get-n-pages;
      my N-GObject $no = .gtk-assistant-get-nth-page(0);

      .gtk-assistant-add-action-widget($bttn);
      .gtk-assistant-remove-action-widget($bttn);
      .gtk-assistant-update-buttons-state;
      .gtk-assistant-commit;

      .gtk-assistant-set-page-has-padding( $f2, True);
      $i = .gtk-assistant-get-page-has-padding($f2);

#    $a.gtk-assistant-next-page;
#    $a.gtk-assistant-previous-page;
    }
  },

  :prepare( {
      $*assistant .= new;
      $f1 .= new(:label<page-1>);
      $f2 .= new(:label<page-2>);
      $f3 .= new(:label<page-3>);
      $bttn .= new(:label<action>);
    }
  ),
  :cleanup( {
      $*assistant.destroy;
    }
  ),
);


$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
