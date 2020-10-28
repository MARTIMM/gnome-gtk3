use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Stack;
use Gnome::Gtk3::StackSwitcher;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Stack $s;
my Gnome::Gtk3::StackSwitcher $ss;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ss .= new;
  isa-ok $ss, Gnome::Gtk3::StackSwitcher, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $s .= new;
  $s.set-name('stacktest');
  $ss.set-stack($s);

  $s .= new(:native-object($ss.get-stack));
  is $s.get-name, 'stacktest', '.set-stack() / .get-stack()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;
#  use Gnome::N::N-GObject;

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $ss.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  test-property( G_TYPE_INT, 'icon-size', 'get-int', 1);
#  test-property( G_TYPE_OBJECT, 'stack', 'get-object', N-GObject);
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}
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
