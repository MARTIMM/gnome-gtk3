use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRendererToggle;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CellRendererToggle $crt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crt .= new;
  isa-ok $crt, Gnome::Gtk3::CellRendererToggle, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  nok $crt.get-radio, '.get-radio()';
  $crt.set-radio(True);
  ok $crt.get-radio, '.get-radio() now radio';

  nok $crt.get-active, '.get-active()';
  $crt.set-active(True);
  ok $crt.get-active, '.get-active() now active';

  ok $crt.get-activatable, '.get-activatable()';
  $crt.set-activatable(False);
  nok $crt.get-activatable, '.get-activatable() now not activatable';

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
