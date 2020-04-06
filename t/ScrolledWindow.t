use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

#use Gnome::GObject::Type;
#use Gnome::GObject::Value;

use Gnome::Gtk3::Adjustment;
use Gnome::Gtk3::ScrolledWindow;

use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::ScrolledWindow {
  submethod new ( |c ) {
    self.bless( :GtkScrolledWindow, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ScrolledWindow, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::ScrolledWindow $sw;
my Gnome::Gtk3::Adjustment $ha;
my Gnome::Gtk3::Adjustment $va;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $sw .= new;
  isa-ok $sw, Gnome::Gtk3::ScrolledWindow, '.new()';


  $ha .= new(
    :value(1e1), :lower(0e0), :upper(1e2),
    :step_increment(1e0), :page_increment(1e1), :page_size(2e1)
  );

  $va .= new(
    :value(1e1), :lower(0e0), :upper(1e2),
    :step_increment(1e0), :page_increment(1e1), :page_size(2e1)
  );
  $sw .= new( :hadjustment($ha), :vadjustment($va));
  isa-ok $sw, Gnome::Gtk3::ScrolledWindow, '.new(...options...)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $va .= new(
    :value(1e1), :lower(0e0), :upper(1.1e2),
    :step_increment(1e0), :page_increment(1e1), :page_size(2e1)
  );
  is $va.get-upper, 1.1e2, 'Adjustment.get-upper()';

  $sw.set-vadjustment($va);
#Never cleanup !!!  $va.clear-object;

  my Gnome::Gtk3::Adjustment $a .= new(:native-object($sw.get-vadjustment));
  is $a.get-upper, 1.1e2, '.set-vadjustment() / .get-vadjustment()';
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
