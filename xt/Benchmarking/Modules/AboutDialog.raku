use v6;
use lib '../gnome-native/lib';
use P5times;

use Gnome::Gtk3::AboutDialog;
use Gnome::Gdk3::Pixbuf;
#use Gnome::N::GlibToRakuTypes;

my Gnome::Gtk3::AboutDialog $a .= new;

my @bt1 = timethis( 'Method calls', 500, {
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

my @bt2 = timethis(
  'Native sub search', 500, {
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

compare @bt1, @bt2;

#-------------------------------------------------------------------------------
sub show (
  Str $test, $count, $totalu, $totals, $total, $mean, $rps, $remark = ''
) {
  note (
    "\n$test",
    "Count:             $count",
    "Total user time:   " ~ ($totalu/1e6).fmt('%.5f'),
    "Total system time: " ~ ($totals/1e6).fmt('%.5f'),
    "Total of both:     " ~ ($total/1e6).fmt('%.5f'),
    "Mean of both:      " ~ ($mean/1e6).fmt('%.5f'),
    "Runs/sec:          $rps.fmt('%.2f')$remark",
  ).join("\n  ");
}

#-------------------------------------------------------------------------------
sub timethis ( Str $test, Int $count, Callable $test-routine --> List ) {

  note "Run test $test";
  my Int ( $total-time, $total-utime, $total-stime) = ( 0, 0, 0);
  my ( $user1, $system1, $cuser1, $csystem1);

  loop ( my Int $test-count = 0; $test-count < $count; $test-count++ ) {
    ENTER {
      ( $user1, $system1, $cuser1, $csystem1) = times;
    }

    $test-routine();


    LEAVE {
      my ( $user2, $system2, $cuser2, $csystem2) = times;
      $total-utime += ($user2 - $user1);
      $total-stime += ($system2 - $system1);
    }
  }

  $total-time = ($total-utime + $total-stime);

  ( $test, $count, $total-utime, $total-stime, $total-time,
    $total-time/$count, $count/$total-time * 1e6
  )
}

#-------------------------------------------------------------------------------
sub compare ( **@data ) {

  my $slowest;
  my Str $remark;
  for (|@data).sort( -> $a, $b { $a[6] <=> $b[6] }) -> @x {
    if $slowest.defined {
      $remark = ', ' ~ (@x[6] / $slowest).fmt('%.2f') ~ ' times faster than slowest';
    }

    else {
      $remark = ', slowest';
      $slowest = @x[6];
    }

    show |@x, $remark;
  }
}
