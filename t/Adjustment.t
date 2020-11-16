use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;

use Gnome::Gtk3::Adjustment;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::Adjustment {
  submethod new ( |c ) {
    self.bless( :GtkAdjustment, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Adjustment, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::Adjustment $a;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $a .= new(
    :value(1e1), :lower(0e0), :upper(1e2),
    :step-increment(1e0), :page-increment(1e1), :page-size(2e1)
  );
  isa-ok $a, Gnome::Gtk3::Adjustment, '.new(... options ...)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $a.get-value, 10e0, '.get-value()';
  $a.clamp-page( 11e0, 1e2);
  is $a.get-value, 11e0, '.clamp-page()';

  $a.set-value(5e0);
  is $a.get-value, 5e0, '.set-value()';
  $a.set-value(-1e0);
  is $a.get-value, 0e0, '.set-value() clamped to lower';

  is $a.get-lower, 0e0, '.get-lower()';
  $a.set-lower(2e0);
  is $a.get-lower, 2e0, '.set-lower()';

  $a.set-upper(1.1e2);
  is $a.get-upper, 1.1e2, '.get-upper() / .set-upper()';

}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {

  $a.clear-object;
  $a .= new(
    :value(1e1), :lower(11e0), :upper(1e2),
    :step-increment(1e0), :page-increment(1e1), :page-size(2e1)
  );

  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_DOUBLE));
  $a.g-object-get-property( 'value', $gv);
  is $gv.get-double, 11e0, 'property value';
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
