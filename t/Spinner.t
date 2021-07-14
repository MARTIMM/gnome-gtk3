use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::Spinner;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Spinner $s;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gtk3::Spinner, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  $s.spinner-start;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'active', $gv);
  is $gv.get-boolean, True, 'property active';
  $gv.clear-object;

  $s.spinner-stop;
  $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'active', $gv);
  is $gv.get-boolean, False, '.spinner-start() / .spinner-stop()';
  $gv.clear-object;
}

#`{{

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

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
