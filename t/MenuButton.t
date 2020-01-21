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
  diag ".new";
  $mb .= new;
  isa-ok $mb, Gnome::Gtk3::MenuButton;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  diag ".set-direction() / .get-direction()";
  $mb.set-direction(GTK_ARROW_RIGHT);
  is GtkArrowType($mb.get-direction), GTK_ARROW_RIGHT, 'arrow set right';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  diag ".set-label() / .get-label()";
  $mb.set-label('set bold');
  is $mb.get-label, 'set bold', 'label set';

  diag ".set-active() / .get-active()";
  is $mb.get-active, 0, 'Not active';
  $mb.set-active(1);
  is $mb.get-active, 1, 'Active';
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
