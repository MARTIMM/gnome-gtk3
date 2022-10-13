use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::MenuBar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MenuBar $mb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $mb .= new;
  isa-ok $mb, Gnome::Gtk3::MenuBar, ".new";
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is GtkPackDirection($mb.get-pack-direction), GTK_PACK_DIRECTION_LTR,
    '.get-pack-direction()';
  $mb.set-pack-direction(GTK_PACK_DIRECTION_TTB);
  is GtkPackDirection($mb.get-pack-direction), GTK_PACK_DIRECTION_TTB,
    '.set-pack-direction()';
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
