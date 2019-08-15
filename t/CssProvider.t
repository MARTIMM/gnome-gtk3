use v6;
use NativeCall;
use Test;

use Gnome::Glib::Error;
use Gnome::Glib::Quark;
use Gnome::Gtk3::CssProvider;

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
my Gnome::Gtk3::CssProvider $cp .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cp, Gnome::Gtk3::CssProvider;
}

#-------------------------------------------------------------------------------
subtest 'load-from-data', {
  is $cp.load-from-data( $css-text, $css-text.chars, Any), 1, 'css load ok';

  my Gnome::Glib::Error $e = $cp.load-from-data($css-text);
  is $e.error-is-valid, False, 'no errors';

  subtest 'invalid css from string', {
    my Gnome::Glib::Quark $quark .= new(:empty);

    $e = $cp.load-from-data($invalid-css-text);
    is $e.error-is-valid, True, 'there are errors';

    is $e.domain, $cp.error-quark(), "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-css-provider-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_CSS_PROVIDER_ERROR_SYNTAX.value,
       'error code for this error is GTK_CSS_PROVIDER_ERROR_SYNTAX';
    is $e.message, '<data>:3:8Invalid name of pseudo-class', $e.message;
  }
}

#-------------------------------------------------------------------------------
subtest 'load-from-path', {
#Gnome::N::debug(:on);
  is $cp.load-from-path( $css-file, Any), 1, 'css load ok';

  my Gnome::Glib::Error $e = $cp.load-from-path($css-file);
  is $e.error-is-valid, False, 'no errors';

  subtest 'invalid css from file', {
    my Gnome::Glib::Quark $quark .= new(:empty);

    $e = $cp.load-from-path($invalid-css-file);
    is $e.error-is-valid, True, 'there are errors';

    is $e.domain, $cp.error-quark(), "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-css-provider-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_CSS_PROVIDER_ERROR_SYNTAX.value,
       'error code for this error is GTK_CSS_PROVIDER_ERROR_SYNTAX';
    is $e.message, 'invalid-test.css:3:8Invalid name of pseudo-class', $e.message;
  }
}

#-------------------------------------------------------------------------------
unlink $css-file;
unlink $invalid-css-file;
rmdir $dir;
done-testing;
