use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::Switch;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Switch $s;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gtk3::Switch, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $s.set-active(True);
  is $s.get-active, 1, '.set-active() / .get-active()';

  $s.set-state(True);
  is $s.get-state, 1, '.set-state() / .get-state()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'active', $gv);
  is $gv.get-boolean, True, 'property active';
  $gv.clear-object;

  $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'state', $gv);
  is $gv.get-boolean, True, 'property state';
  $gv.clear-object;
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
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
