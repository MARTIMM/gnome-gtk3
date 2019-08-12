use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Window $w .= new(:empty);
  isa-ok $w, Gnome::Gtk3::Window, '.new(:empty)';
  $w .= new(:title('My test window'));
  isa-ok $w, Gnome::Gtk3::Window, '.new(:title)';
  is $w.get-title, 'My test window', '.get-title()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Window $w .= new(:empty);
  is $w.get-window-type, GTK_WINDOW_TOPLEVEL.value, '.get-window-type()';

#Gnome::N::debug(:on);
  diag ".get-default-size() defaults";
  my Int ( $ww, $wh) = $w.get-default-size;
  ok Any || $ww == -1, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == -1, '.get-size(), h=' ~ ($wh//'Any');
  diag '.set-default-size( 123, 356)';
  $w.set-default-size( 123, 356);
  ( $ww, $wh) = $w.get-default-size;
  ok Any || $ww == 123, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == 356, '.get-size(), h=' ~ ($wh//'Any');

#Gnome::N::debug(:off);

  $w.set-title('empty window');
  is $w.get-title, 'empty window', '.set-title()';

  diag '.set-position()';
  $w.set-position(GTK_WIN_POS_MOUSE);
  my Int ( $rx, $ry) = $w.get-position;
  ok Any || $rx >= 0, '.get-position(), x=' ~ ($rx//'Any');
  ok Any || $ry >= 0, '.get-position(), y=' ~ ($ry//'Any');

  diag '.gtk-window-move( 900, 250)';
  $w.gtk-window-move( 900, 250);
  ( $rx, $ry) = $w.get-position;
  ok Any || $rx == 900, '.get-position(), x=' ~ ($rx//'Any');
  ok Any || $ry == 250, '.get-position(), y=' ~ ($ry//'Any');

  diag '.gtk-window-resize( 240, 341)';
  $w.gtk-window-resize( 240, 341);
  ( $ww, $wh) = $w.get-size;
  ok Any || $ww == 240, '.get-size(), w=' ~ ($ww//'Any');
  ok Any || $wh == 341, '.get-size(), h=' ~ ($wh//'Any');

}

#-------------------------------------------------------------------------------
done-testing;
