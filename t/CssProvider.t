use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Glib::Error;
use Gnome::Glib::Quark;
use Gnome::Gtk3::CssProvider;
use Gnome::Gio::File;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my $dir = 't/css';
mkdir $dir unless $dir.IO ~~ :e;
my Str $css-file = $dir ~ '/test.css';
my Str $invalid-css-file = $dir ~ '/invalid-test.css';

my Str $css-text = Q:q:to/EOXML/;

  .green {
    color:            #a0f0cc;
    background-color: #308f8f;
    font:             25px sans;
  }

  .yellow {
    color:            #ffdf10;
    background-color: #806000;
    font:             25px sans;
  }

  EOXML

$css-file.IO.spurt($css-text);

# invalid data
my Str $invalid-css-text = $css-text;
$invalid-css-text ~~ s:g/ '{' //;
$invalid-css-file.IO.spurt($invalid-css-text);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CssProvider $cp;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $cp .= new;
  ok $cp.is-valid, '.new()';
  $cp .= new( :named<Breeze>, :variant<dark>);
  ok $cp.is-valid, '.new( :named, :variant)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  unlink $css-file;
  unlink $invalid-css-file;
  rmdir $dir;
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Glib::Quark $quark .= new;

  #-----------------------------------------------------------------------------
  sub test ( Gnome::Glib::Error $e ) {
    is $e.is-valid, True, 'there are errors';
    is $e.domain, $cp.error-quark(), "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-css-provider-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_CSS_PROVIDER_ERROR_SYNTAX.value,
       'error code for this error is GTK_CSS_PROVIDER_ERROR_SYNTAX';

    if %*ENV<travis_ci_tests> {
      skip 'travis differs, older GTK+ version', 1;
    }

    else {
      # no message testing, might become other language!
      ok $e.is-valid, $e.message;
    }
  }

  #-----------------------------------------------------------------------------
  class X {
    has Bool $.signal-processed is rw;

    method handle-error (
      N-GObject $section, N-GError $e,
      Gnome::GObject::Object :native-object($provider)
    ) {
      my Gnome::Glib::Quark $quark .= new;
      my Gnome::Glib::Error $error .= new(:native-object($e));
      test($error);
      $!signal-processed = True;
    }
  }

  my X $x .= new;
  $cp.register-signal( $x, 'handle-error', 'parsing-error');

  #-----------------------------------------------------------------------------
  subtest 'load-from-data', {
    my Gnome::Glib::Error $e = $cp.load-from-data($css-text);
    nok $e.is-valid, '.load-from-data()';
    like $cp.to-string, / 'color: rgb(160,240,204);' /, '.to-string()';

    $x.signal-processed = False;
    $e = $cp.load-from-data($invalid-css-text);
    ok $x.signal-processed, 'signal processed';
    subtest 'invalid css from string', { test($e); };
  }

  #-----------------------------------------------------------------------------
  subtest 'load-from-path', {
    my Gnome::Glib::Error $e = $cp.load-from-path($css-file);
    nok $e.is-valid, '.load-from-path()';

    $x.signal-processed = False;
    $e = $cp.load-from-path($invalid-css-file);
    ok $x.signal-processed, 'signal processed';
    subtest 'invalid css from path', { test($e); };
  }

  #-----------------------------------------------------------------------------
  subtest 'load-from-file', {
    my Gnome::Gio::File $file .= new(:path($css-file));
    my Gnome::Glib::Error $e = $cp.load-from-file($file);
    nok $e.is-valid, '.load-from-path()';

    $x.signal-processed = False;
    $file .= new(:path($invalid-css-file));
    $e = $cp.load-from-file($file);
    ok $x.signal-processed, 'signal processed';
    subtest 'invalid css from file', { test($e); };
  }
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
unlink $css-file;
unlink $invalid-css-file;
rmdir $dir;
done-testing;
