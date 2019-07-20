use v6;
use NativeCall;
use Test;

use Gnome::Glib::SList;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::RadioButton;

#-------------------------------------------------------------------------------
subtest 'RadioButton create', {

  my Gnome::Gtk3::RadioButton $rb1 .= new(:label('abc'));
  isa-ok $rb1, Gnome::Gtk3::RadioButton;

  my Gnome::Gtk3::RadioButton $rb2 .= new(:group-from($rb1));

  $rb2.set-label('rb2');
  is $rb2.get-label, 'rb2', 'label of 2nd button is ok';

  is $rb1.get-active, 1, '1st button is selected';
  is $rb2.get-active, 0, '2nd button is not selected';

  $rb2.set-active(1);
  is $rb1.get-active, 0, '1st button is not selected';
  is $rb2.get-active, 1, '2nd button is selected';
}

#-------------------------------------------------------------------------------
subtest 'RadioButton group list', {

  my Gnome::Gtk3::RadioButton $rb1 .= new(:label<rb1>);
  my Gnome::Gtk3::RadioButton $rb2 .= new( :group-from($rb1), :label<rb2>);

  my Gnome::Glib::SList $l .= new(:gslist($rb2.get-group));
  is $l.g-slist-length, 2, 'group has two members';

  my Gnome::Gtk3::RadioButton $b .= new(:widget($l.nth-data-gobject(1)));
  is $b.get-label, 'rb1', 'found label from 1st radio button';
  $b .= new(:widget($l.nth-data-gobject(0)));
  is $b.get-label, 'rb2', 'found label from 2nd radio button';
}

#-------------------------------------------------------------------------------
done-testing;
