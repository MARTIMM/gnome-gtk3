use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AboutDialog;

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
subtest 'Manipulations', {
  $a.set-program-name('AboutDialog.t');
  is $a.get-program-name, 'AboutDialog.t',
     '.set-program-name() / .get-program-name()';

  $a.set-version('0.14.2.1');
  is $a.get-version, '0.14.2.1', '.set-version() / .get-version()';

  $a.set-copyright('m.timmerman a.k.a MARTIMM');
  is $a.get-copyright, 'm.timmerman a.k.a MARTIMM',
     '.set-copyright() / .get-copyright()';

  $a.set-comments('Awfully good language binding');
  is $a.get-comments, 'Awfully good language binding',
     '.set-comments() / .get-comments()';

  $a.set-license('Artistic License 2.0');
  is $a.get-license, 'Artistic License 2.0',
     '.set-license() / .get-license()';
#, '.() / .()';
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
done-testing;
