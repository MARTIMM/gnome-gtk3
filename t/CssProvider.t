use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::N::N-GObject;
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
my Gnome::Gtk3::CssProvider $cp .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cp, Gnome::Gtk3::CssProvider;
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

  #-----------------------------------------------------------------------------
  subtest 'load-from-data', {
    my Gnome::Glib::Error $e = $cp.load-from-data($css-text);
    is $e.is-valid, False, 'no errors';

    subtest 'invalid css from string', {
      my Gnome::Glib::Quark $quark .= new;

      $e = $cp.load-from-data($invalid-css-text);
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
        is $e.message, '<data>:3:8Invalid name of pseudo-class', $e.message;
      }
    }
  }

  #-----------------------------------------------------------------------------
  subtest 'load-from-path', {
  #Gnome::N::debug(:on);
    nok $cp.load-from-path($css-file).is-valid, 'css load ok';

    my Str $css = $cp.to-string;
    like $css, / \. green /, 'green class found';
    like $css, / 'rgb(48,143,143);' /, 'background color found';

    if %*ENV<travis_ci_tests> {
      skip 'travis differs, older GTK+ version', 1;
    }

    else {
      like $css, / 'font-stretch: initial;' /, 'some extra attributes';
    }

    my Gnome::Glib::Error $e = $cp.load-from-path($css-file);
    is $e.is-valid, False, 'no errors';

    subtest 'invalid css from file', {
      my Bool $signal-processed = False;
      class X {
        method handle-error (
          N-GObject $section, N-GError $e,
          Gnome::GObject::Object :native-object($provider)
        ) {
          my Gnome::Glib::Quark $quark .= new;
          my Gnome::Glib::Error $error .= new(:native-object($e));
          is $error.is-valid, True, 'there are errors';

          is $error.domain, $cp.error-quark(), "domain code: $error.domain()";
          is $quark.to-string($error.domain), 'gtk-css-provider-error-quark',
             "error domain: $quark.to-string($e.domain())";
          is $error.code, GTK_CSS_PROVIDER_ERROR_SYNTAX.value,
             'error code for this error is GTK_CSS_PROVIDER_ERROR_SYNTAX';

          if %*ENV<travis_ci_tests> {
            skip 'travis differs, older GTK+ version', 1;
          }

          else {
            like $error.message, /:s Invalid name of pseudo\-class/, $error.message;
          }

          $signal-processed = True;
        }
      }

      $cp.register-signal( X.new, 'handle-error', 'parsing-error');
      $cp.load-from-path($invalid-css-file);

      ok $signal-processed, 'signal processed';
    }
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
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
unlink $css-file;
unlink $invalid-css-file;
rmdir $dir;
done-testing;
