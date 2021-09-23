use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-gobject/lib';

use NativeCall;
use Test;

use Gnome::Gtk3::AboutDialog;
use Gnome::Gdk3::Pixbuf;
use Gnome::N::GlibToRakuTypes;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AboutDialog $a;

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  $a .= new;
  isa-ok $a, Gnome::Gtk3::AboutDialog;
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $a.set-program-name('AboutDialog.t');
  is $a.get-program-name, 'AboutDialog.t',
     '.set-program-name() / .get-program-name()';

  $a.set-version('0.14.2.1');
  is $a.get-version, '0.14.2.1', '.set-version() / .get-version()';

  $a.set-copyright('m.timmerman a.k.a MARTIMM');
  is $a.get-copyright, 'm.timmerman a.k.a MARTIMM',
     '.set-copyright() / .get-copyright()';

  $a.set-comments('Very good language binding');
  is $a.get-comments, 'Very good language binding',
     '.set-comments() / .get-comments()';

  $a.set-license('Artistic License 2.0');
  is $a.get-license, 'Artistic License 2.0',
     '.set-license() / .get-license()';

  $a.set-license-type(GTK_LICENSE_MIT_X11);
  is $a.get-license-type, GTK_LICENSE_MIT_X11,
     '.set-license-type() / .get-license-type()';

  $a.set-wrap-license(True);
  ok $a.get-wrap-license, '.set-wrap-license() / .get-wrap-license()';

  $a.set-website('https://example.com/my-favorite-items.html');
  is $a.get-website, 'https://example.com/my-favorite-items.html',
      '.set-website() / .get-website()';

  $a.set-website-label('favorite');
  is $a.get-website-label, 'favorite',
     '.set-website-label() / .get-website-label()';

  $a.set-authors( 'mt++1', 'pietje puk1');
  is-deeply $a.get-authors, [ 'mt++1', 'pietje puk1'],
     '.set-authors() / .get-authors()';

  $a.set-documenters( 'mt++2', 'pietje puk2');
  is-deeply $a.get-documenters, [ 'mt++2', 'pietje puk2'],
     '.set-documenters() / .get-documenters()';

  $a.set-artists( 'mt++3', 'pietje puk3');
  is-deeply $a.get-artists, [ 'mt++3', 'pietje puk3'],
     '.set-artists() / .get-artists()';

  $a.set-translator-credits('He, who has invented Raku, thanks a lot');
  is $a.get-translator-credits, 'He, who has invented Raku, thanks a lot',
     '.set_translator_credits() / .get_translator_credits()';

  my Gnome::Gdk3::Pixbuf $p1 .= new(:file<t/data/Add.png>);
  $a.set-logo($p1);
  my Gnome::Gdk3::Pixbuf $p2 .= new(:native-object($a.get-logo));
  is $p1.get-width, $p2.get-width, 'pixbuf width is same';
  is $p1.get-height, $p2.get-height, 'pixbuf height is same';

  $a.set-logo-icon-name('folder-blue');
  is $a.get-logo-icon-name, 'folder-blue',
     '.set-logo-icon-name() / .get-logo-icon-name()';

  $a.add-credit-section( 'piano players', 'lou de haringboer', 'kniertje');
#note
#, '.() / .()';
}

#-------------------------------------------------------------------------------
#Gnome::N::debug(:on);
subtest 'Properties ...', {
#`{{
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $a.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }
}}

  my @r = $a.get-properties(
    'program-name', Str, 'version', Str, 'copyright', Str, 'comments', Str,
    'license-type', int32, 'website', Str, 'website-label', Str,
    'translator-credits', Str, 'logo-icon-name', Str, 'wrap-license', gboolean
  );
#note @r;

  is-deeply @r, [
    'AboutDialog.t', '0.14.2.1', 'm.timmerman a.k.a MARTIMM',
    'Very good language binding', GTK_LICENSE_MIT_X11.value,
    'https://example.com/my-favorite-items.html', 'favorite',
    'He, who has invented Raku, thanks a lot', 'folder-blue', 1
  ], '.get-properties';

#`{{
  test-property( G_TYPE_STRING, 'program-name', 'get-string', 'AboutDialog.t');
  test-property( G_TYPE_STRING, 'version', 'get-string', '0.14.2.1');
  test-property(
    G_TYPE_STRING, 'copyright', 'get-string', 'm.timmerman a.k.a MARTIMM'
  );
  test-property(
    G_TYPE_STRING, 'comments', 'get-string', 'Very good language binding'
  );
}}

#`{{
  # next call works but is skipped because of a language dependency which
  # might return different text in another language
  if 1 {
    skip 1;
  }

  else {
    # changed by 2nd call to license type
    is-deeply $a.get-properties( 'license', Str), ["This program comes with absolutely no warranty.\nSee the <a href=\"https://opensource.org/licenses/mit-license.php\">The MIT License (MIT)</a> for details."],
    'license';
#`{{
    test-property(
      G_TYPE_STRING, 'license', 'get-string',
      "This program comes with absolutely no warranty.\nSee the <a href=\"https://opensource.org/licenses/mit-license.php\">The MIT License (MIT)</a> for details."
    );
}}
  }
}}

#`{{
  #test-property(
  #  G_TYPE_ENUM, 'license-type', 'get-enum', GTK_LICENSE_MIT_X11.value
  #);

  test-property(
    G_TYPE_STRING, 'website', 'get-string',
    'https://example.com/my-favorite-items.html'
  );

  test-property(
    G_TYPE_STRING, 'website-label', 'get-string', 'favorite'
  );

  test-property(
    G_TYPE_STRING, 'translator-credits', 'get-string',
    'He, who has invented Raku, thanks a lot'
  );

  test-property(
    G_TYPE_STRING, 'logo-icon-name', 'get-string', 'folder-blue'
  );

  test-property(
    G_TYPE_BOOLEAN, 'wrap-license', 'get-boolean', True
  );
}}
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
#  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method activate ( Str $uri, --> Bool ) {
      is $uri, 'https://example.com/my-favorite-items.html',
        'uri received from event';
      $!signal-processed = True;

      True
    }

    method signal-emitter ( Gnome::Gtk3::AboutDialog :$_widget --> Str ) {

      $_widget.emit-by-name(
        'activate-link',
        'https://example.com/my-favorite-items.html',
        :return-type(gboolean),
        :parameters([gchar-ptr,])
      );
      is $!signal-processed, True, '\'activate-link\' signal processed';

      while $main.events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$_widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

#      while $main.events-pending() { $main.iteration-do(False); }

      sleep(0.4);
      $main.main-quit;

      'done'
    }
  }

  my SignalHandlers $sh .= new;
  $a.register-signal( $sh, 'activate', 'activate-link');

  my Promise $p = $a.start-thread(
    $sh, 'signal-emitter',
    :new-context,
    # :start-time(now + 1)
  );

  is $main.main-level, 0, "loop level 0";
  $main.main;

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::AboutDialog', {
  class MyClass is Gnome::Gtk3::AboutDialog {
    method new ( |c ) {
      self.bless( :GtkAboutDialog, |c);
    }

    submethod BUILD ( *%options ) {
      self.set-version('0.15.0.1');
    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::AboutDialog, '$mgc.new()';
  is $mgc.get-version, '0.15.0.1', 'self.set-version() / $mgc.get-version()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
