use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Stack;
use Gnome::Gtk3::Entry;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Stack $s;
my Gnome::Gtk3::Window $w;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $s .= new;
  isa-ok $s, Gnome::Gtk3::Stack, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $w .= new;
  $w.container-add($s);

  my Gnome::Gtk3::Entry $entry .= new;
  $entry.set-text('abc');
  $entry.set-name('e1');
  $s.add-named( $entry, 'my-entry1');

# Possible error when name is duplicated
# (Stack.t:58794): Gtk-WARNING **: 19:12:56.257: Duplicate child name in GtkStack:

  $entry .= new;
  $entry.set-text('abc');
  $entry.set-name('e2');
  $s.add-titled( $entry, 'my-entry2', 'Entry2');

  my Gnome::Gtk3::Entry $e;
  $e .= new(:native-object($s.get-child-by-name('my-entry1')));
  is $e.get-name, 'e1', '.add-named() / .get-child-by-name()';

  $e .= new(:native-object($s.get-child-by-name('my-entry2')));
  is $e.get-name, 'e2', '.add-titled()';

  # must make all widgets visible otherwise set-visible-child won't work
  $s.set-visible-child($e);
  $e .= new(:native-object($s.get-visible-child));
  nok $e.is-valid, 'not visible -> not valid';

  $w.show-all;
  $s.set-visible-child($s.get-child-by-name('my-entry2'));
  $e .= new(:native-object($s.get-visible-child));
  is $e.get-name, 'e2', '.set-visible-child() / .get-visible-child()';

  $s.set-visible-child-name('my-entry1');
  is $s.get-visible-child-name, 'my-entry1',
     '.set-visible-child-name() / .get-visible-child-name()';

  $s.set-transition-duration(2001);
  is $s.get-transition-duration, 2001,
     '.set-transition-duration() / .get-transition-duration()';

  $s.set-visible-child-full( 'my-entry2', GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN);
  is $s.get-visible-child-name, 'my-entry2', '.set-visible-child-full()';

  # should run for 2001 ms! but returns 0, need full stack in a window!
  ok $s.gtk_stack_get_transition_running, '.gtk_stack_get_transition_running()';

  $s.set-homogeneous(True);
  ok $s.get-homogeneous, '.set-homogeneous() / .get-homogeneous()';
  $s.set-hhomogeneous(False);
  nok $s.get-hhomogeneous, '.set-hhomogeneous() / .get-hhomogeneous()';
  $s.set-vhomogeneous(False);
  nok $s.get-vhomogeneous, '.set-vhomogeneous() / .get-vhomogeneous()';

  $s.set-transition-type(GTK_STACK_TRANSITION_TYPE_OVER_DOWN);
  is GtkStackTransitionType($s.get_transition_type),
     GTK_STACK_TRANSITION_TYPE_OVER_DOWN,
     '.set-transition-type() / .get_transition_type()';

  $s.set-interpolate-size(True);
  ok $s.get-interpolate-size,
     '.set-interpolate-size() / .get-interpolate-size()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $s.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  test-property( G_TYPE_BOOLEAN, 'hhomogeneous', 'get-boolean', 0);
  test-property( G_TYPE_BOOLEAN, 'vhomogeneous', 'get-boolean', 0);
  test-property( G_TYPE_STRING, 'visible-child-name', 'get-string', 'my-entry2');
  test-property( G_TYPE_UINT, 'transition-duration', 'get-uint', 2001);
  test-property( G_TYPE_ENUM, 'transition-type', 'get-enum', GTK_STACK_TRANSITION_TYPE_OVER_DOWN.value);
  test-property( G_TYPE_BOOLEAN, 'transition-running', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'interpolate-size', 'get-boolean', 1);

#??  test-property( G_TYPE_STRING, 'name', 'get-string', 'my-entry2');

# child properties
#error shown
#(Stack.t:69912): GLib-GObject-WARNING **: 21:53:25.882: g_object_get_is_valid_property: object class 'GtkStack' has no property named 'title'
#  test-property( G_TYPE_STRING, 'title', 'get-string', 'Entry2');

#error shown
# Stack.t:69994): GLib-GObject-WARNING **: 21:54:37.068: g_object_get_is_valid_property: object class 'GtkStack' has no property named 'icon-name'
#  test-property( G_TYPE_STRING, 'icon-name', 'get-string', Str);

#  test-property( G_TYPE_, '', '', );
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Stack', {
  class MyClass is Gnome::Gtk3::Stack {
    method new ( |c ) {
      self.bless( :GtkStack, |c);
    }

    submethod BUILD ( *%options ) {

      self.set-transition-duration(2001);
      self.set-transition-type(GTK_STACK_TRANSITION_TYPE_OVER_DOWN);
    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Stack, '.new()';

  is $mgc.get-transition-duration, 2001, 'my transition';
  is GtkStackTransitionType($mgc.get_transition_type),
     GTK_STACK_TRANSITION_TYPE_OVER_DOWN, 'my transition type';

}

#`{{
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
