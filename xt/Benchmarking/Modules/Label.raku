use v6;

use Gnome::T::Benchmark;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Entry;

my Gnome::Gtk3::Entry $entry .= new;
my Gnome::Gtk3::Label $*Label .= new(:text(Str));

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>,
  :project-version<0.34.2.1-native:0.18.5.2>,
  :sub-project<Label>, :path<xt/Benchmarking/Data>
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
      .set-angle(270.234e0);
      my Num $n = .get-angle;
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
    }
  },
#  :prepare( { $*Label .= new(:label<Start>); } ),
  :count(1000)
);

$b.compare-tests;

#$b.show-test('Native sub search');
#$b.show-test('Method calls');
$b.save-tests;

#$b.md-test-table( '0.34.2.1', '2020.10.109', 'AboutDialog', 0, 1);
