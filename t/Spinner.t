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
subtest 'Properties ...', {
  $s.spinner-start;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'active', $gv);
  is $gv.get-boolean, 1, 'property active';
  $gv.unset;

  $s.spinner-stop;
  $gv .= new(:init(G_TYPE_BOOLEAN));
  $s.g-object-get-property( 'active', $gv);
  is $gv.get-boolean, 0, '.spinner-start() / .spinner-stop()';
  $gv.unset;
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
