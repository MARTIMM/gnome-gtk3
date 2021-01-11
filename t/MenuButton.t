use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::MenuButton;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MenuButton $mb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $mb .= new;
  isa-ok $mb, Gnome::Gtk3::MenuButton, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $mb.set-direction(GTK_ARROW_RIGHT);
  is GtkArrowType($mb.get-direction), GTK_ARROW_RIGHT,
     '.set-direction() / .get-direction()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  $mb.set-label('set bold');
  is $mb.get-label, 'set bold', '.set-label() / .get-label()';

  is $mb.get-active, 0, '.set-active()';
  $mb.set-active(1);
  is $mb.get-active, 1, '.set-active()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
