use v6;
#use lib '../gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::Gtk3::RadioButton;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::RadioButton ( $rb1, $rb2, $rb3, $b);
my Gnome::Glib::SList $l;
#my Gnome::Glib::SList $l2;

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rb1 .= new;
  isa-ok $rb1, Gnome::Gtk3::RadioButton, '.new()';

  $rb1 .= new(:label('abc'));
  isa-ok $rb1, Gnome::Gtk3::RadioButton, '.new(:label)';

  my Gnome::Gtk3::RadioButton $rb2 .= new(:group-from($rb1));
  isa-ok $rb2, Gnome::Gtk3::RadioButton, '.new(:group-from)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $rb1 .= new(:label<rb1>);
  $rb2 .= new( :group-from($rb1), :label<rb2>);

  $l .= new(:native-object($rb2.get-group));
  is $l.g-slist-length, 2, '.new(:group-from, :label) / .get-group';

  # new radio button is shifted up front in the list
  $rb3 .= new( :group($l), :label<rb3>);
  $l .= new(:native-object($rb1.get-group));
  is $l.g-slist-length, 3, '.new(:group, :label)';

  $b .= new(:native-object($l.nth-data(0)));
  is $b.get-label, 'rb3', "found label 'rb3' from 1st radio button";
  $b .= new(:native-object($l.nth-data(1)));
  is $b.get-label, 'rb2', "found label 'rb2' from 2nd radio button";
  $b .= new(:native-object($l.nth-data(2)));
  is $b.get-label, 'rb1', "found label 'rb1' from 3rd radio button";
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  $rb2.set-label('rb2');
  is $rb2.get-label, 'rb2', 'label of 2nd button is ok';

  is $rb1.get-active, 1, '1st button is selected';
  is $rb2.get-active, 0, '2nd button is not selected';

  $rb2.set-active(1);
  is $rb1.get-active, 0, '1st button is not selected';
  is $rb2.get-active, 1, '2nd button is selected';
}


#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {

  ok 1, "signal 'group-changed'";
  my Bool $triggered = False;

  class X {
    method r-event ( :$widget ) {
      isa-ok $widget, Gnome::Gtk3::RadioButton,
             'signal received on proper widget';
      my Gnome::Glib::SList $l .= new(:native-object($widget.get-group));
      is $l.g-slist-length, 4, 'group now has four members';
      $triggered = True;
    }
  }

  # new radio button is added to the group
  my Gnome::Gtk3::RadioButton $rb4 .= new(:label<rb4>);
  $rb4.register-signal( X.new, 'r-event', 'group-changed');
  $rb4.join-group($rb1);

  ok $triggered, 'signal is triggered';
}

#-------------------------------------------------------------------------------
done-testing;
