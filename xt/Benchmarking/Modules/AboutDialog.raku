use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-test/lib';

use Gnome::T::Benchmark:api<1>;
use Gnome::Gtk3::AboutDialog:api<1>;
#use Gnome::Gdk3::Pixbuf:api<1>;
#use Gnome::N::GlibToRakuTypes:api<1>;

my Gnome::Gtk3::AboutDialog $a .= new;

my Str $project-version = Gnome::T::Benchmark.meta6-version;
my Str $sub-project =
  Gnome::T::Benchmark.type-version(Gnome::Gtk3::AboutDialog);

my Gnome::T::Benchmark $b .= new(
  :default-count(500), :project<gnome-gtk3>, :$project-version,
  :$sub-project, :path<xt/Benchmarking/Data>
);

$b.run-test( 'Method calls', {
    $a.set-program-name('AboutDialog.t');
    my Str $s = $a.get-program-name;

    $a.set-version('0.14.2.1');
    $s = $a.get-version;

    $a.set-copyright('m.timmerman a.k.a MARTIMM');
    $s = $a.get-copyright;

    $a.set-comments('Very good language binding');
    $s = $a.get-comments;

    $a.set-license('Artistic License 2.0');
    $s = $a.get-license;

    $a.set-license-type(GTK_LICENSE_MIT_X11);
    my GtkLicense $t = $a.get-license-type;

    $a.set-wrap-license(GTK_LICENSE_MIT_X11);
    my Bool $b = $a.get-wrap-license;

    $a.set-website('https://example.com/my-favourite-items.html');
    $s = $a.get-website;

    $a.set-website-label('favourite');
    $s = $a.get-website-label;

    $a.set-authors( 'mt++1', 'pietje puk1');
    my Array $arr = $a.get-authors;

    $a.set-documenters( 'mt++2', 'pietje puk2');
    $arr = $a.get-documenters;

    $a.set-artists( 'mt++3', 'pietje puk3');
    $arr = $a.get-artists;

    $a.set-translator-credits('He, who has invented Raku, thanks a lot');
    $s = $a.get-translator-credits;

    $a.set-logo-icon-name('folder-blue');
    $s = $a.get-logo-icon-name;

    $a.add-credit-section( 'piano players', 'lou de haringboer', 'kniertje');
  }
);

$b.run-test( 'Native sub search', {
    $a.gtk-about-dialog-set-program-name('AboutDialog.t');
    my Str $s = $a.gtk-about-dialog-get-program-name;

    $a.gtk-about-dialog-set-version('0.14.2.1');
    $s = $a.gtk-about-dialog-get-version;

    $a.gtk-about-dialog-set-copyright('m.timmerman a.k.a MARTIMM');
    $s = $a.gtk-about-dialog-get-copyright;

    $a.gtk-about-dialog-set-comments('Very good language binding');
    $s = $a.gtk-about-dialog-get-comments;

    $a.gtk-about-dialog-set-license('Artistic License 2.0');
    $s = $a.gtk-about-dialog-get-license;

    $a.gtk-about-dialog-set-license-type(GTK_LICENSE_MIT_X11);
    my GtkLicense $t = $a.gtk-about-dialog-get-license-type;

    $a.gtk-about-dialog-set-wrap-license(GTK_LICENSE_MIT_X11);
    my Int $b = $a.gtk-about-dialog-get-wrap-license;

    $a.gtk-about-dialog-set-website(
      'https://example.com/my-favourite-items.html'
    );
    $s = $a.gtk-about-dialog-get-website;

    $a.gtk-about-dialog-set-website-label('favourite');
    $s = $a.gtk-about-dialog-get-website-label;

    $a.gtk-about-dialog-set-authors( 'mt++1', 'pietje puk1');
    my Array $arr = $a.gtk-about-dialog-get-authors;

    $a.gtk-about-dialog-set-documenters( 'mt++2', 'pietje puk2');
    $arr = $a.gtk-about-dialog-get-documenters;

    $a.gtk-about-dialog-set-artists( 'mt++3', 'pietje puk3');
    $arr = $a.gtk-about-dialog-get-artists;

    $a.gtk-about-dialog-set-translator-credits(
      'He, who has invented Raku, thanks a lot'
    );
    $s = $a.gtk-about-dialog-get-translator-credits;

    $a.gtk-about-dialog-set-logo-icon-name('folder-blue');
    $s = $a.gtk-about-dialog-get-logo-icon-name;

    $a.gtk-about-dialog-add-credit-section(
      'piano players', 'lou de haringboer', 'kniertje'
    );
  }
);

$b.load-tests;
$b.modify-tests;
$b.save-tests;

#$b.search-compare-tests( :$project-version, :$sub-project, :!tables);
$b.search-compare-tests( :$sub-project, :!tables);
