use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Button;
#use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Enums;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'Widget ISA test', {
  my Gnome::Gtk3::Button $b .= new(:empty);
  isa-ok $b, Gnome::Gtk3::Widget;
}

#-------------------------------------------------------------------------------
subtest 'Widget manipulations', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  is $b.get-visible, 0, "widget is invisible";
  $b.set-visible(1);
  is $b.get-visible, 1, "widget set visible";

  $b.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');
  is $b.get-tooltip-text, 'Nooooo don\'t touch that button!!!!!!!',
     'tooltip ok';

#  is $b.get-path, N-GtkWidgetPath, 'No widget path defined to this button';
  is $b.get-request-mode, GTK_SIZE_REQUEST_CONSTANT_SIZE.value,
     'request mode is GTK_SIZE_REQUEST_CONSTANT_SIZE';
}

#-------------------------------------------------------------------------------
done-testing;
