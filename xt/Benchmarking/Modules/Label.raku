use v6;

use Gnome::T::Benchmark:api<1>;

use Gnome::N::N-GObject:api<1>;
#use Gnome::N::X:api<1>;

use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Label:api<1>;
use Gnome::Gtk3::Entry:api<1>;


my Gnome::Gtk3::Entry $entry .= new;
my Gnome::Gtk3::Label $*Label .= new(:text(Str));

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project = Gnome::T::Benchmark.type-version(Gnome::Gtk3::Label);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

$b.run-test(
  'Method calls',
  {
    given $*Label {
      .set-text('label text');
      my Str $s = .get-text;
      .set-label('label <b>text</b>');
      $s = .get-label;
      .set-markup('abcdef');
      .set-use-markup(True);
      my Bool $b = .get-use-markup;
      .set-use-underline(True);
      $b = .get-use-underline;
      .set-markup-with-mnemonic('pqs<small>jhg</small>');
      my UInt $u = .get-mnemonic-keyval;
      .set-mnemonic-widget($entry);
      my N-GObject $no = .get-mnemonic-widget;
      .set-text-with-mnemonic('_Stop');
      .set-justify(GTK_JUSTIFY_RIGHT);
      my GtkJustification $j = .get-justify;
      .set-width-chars(10);
      my Int $i = .get-width-chars;
      .set-max-width-chars(10);
      $i = .get-max-width-chars;
      .set-lines(2);
      $i = .get-lines;
      .set_pattern('__  _');
      .set-line-wrap(True);
      $b = .get-line-wrap;
      .set-selectable(True);
      $b = .get-selectable;
      .set-angle(270.234);
      my Num $n = .get-angle;
      .select-region( 10, 11);
      my List $l = .get-selection-bounds;
      .set-single-line-mode(True);
      $b = .get-single-line-mode;
      $s = .get-current-uri;
      .set-track-visited-links(True);
      $b = .get-track-visited-links;
      .set-xalign(0.2);
      $n = .get-xalign;
      .set-yalign(0.2);
      $n = .get-yalign;
    }
  },
#  :prepare( { $*Label .= new(:label<Start>); } ),
  :count(1500)
);

#$button .= new(:label<Start>);
$b.run-test(
  'Native sub search',
  {
    given $*Label {
      .gtk-label-set-text('label text');
      my Str $s = .gtk-label-get-text;
      .gtk-label-set-label('label <b>text</b>');
      $s = .gtk-label-get-label;
      .gtk-label-set-markup('abcdef');
      .gtk-label-set-use-markup(True);
      my Int $i = .gtk-label-get-use-markup;
      .gtk-label-set-use-underline(True);
      $i = .gtk-label-get-use-underline;
      .gtk-label-set-markup-with-mnemonic('pqs<small>jhg</small>');
      my UInt $u = .gtk-label-get-mnemonic-keyval;
      .gtk-label-set-mnemonic-widget($entry);
      my N-GObject $no = .gtk-label-get-mnemonic-widget;
      .gtk-label-set-text-with-mnemonic('_Stop');
      .gtk-label-set-justify(GTK_JUSTIFY_RIGHT);
      $i = .gtk-label-get-justify;
      .gtk-label-set-width-chars(10);
      $i = .gtk-label-get-width-chars;
      .gtk-label-set-max-width-chars(10);
      $i = .gtk-label-get-max-width-chars;
      .gtk-label-set-lines(2);
      $i = .gtk-label-get-lines;
      .gtk-label-set_pattern('__  _');
      .gtk-label-set-line-wrap(True);
      $i = .gtk-label-get-line-wrap;
      .gtk-label-set-selectable(True);
      $i = .gtk-label-get-selectable;
      .gtk-label-set-angle(270.234e0);
      my Num $n = .gtk-label-get-angle;
      .gtk-label-select-region( 10, 11);
      my List $l = .gtk-label-get-selection-bounds;
      .gtk-label-set-single-line-mode(1);
      $i = .gtk-label-get-single-line-mode;
      $s = .gtk-label-get-current-uri;
      .gtk-label-set-track-visited-links(1);
      $i = .gtk-label-get-track-visited-links;
      .gtk-label-set-xalign(0.2e0);
      $n = .gtk-label-get-xalign;
      .gtk-label-set-yalign(0.2e0);
      $n = .gtk-label-get-yalign;
    }
  },
#  :prepare( { $*Label .= new(:label<Start>); } ),
  :count(1000)
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
