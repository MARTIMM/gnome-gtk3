use v6;
use NativeCall;
use Test;
#use lib '../perl6-gnome-native/lib';
#use lib '../perl6-gnome-gobject/lib';

use Gnome::Gdk3::Types;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Range;
use Gnome::Gtk3::Scale;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Scale $s .= new(:empty);
  my Gnome::Gtk3::Range $r .= new(:widget($s));
  isa-ok $r, Gnome::Gtk3::Range;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Scale $s .= new(
    :orientation(GTK_ORIENTATION_HORIZONTAL),
    :min(10e0), :max(100e0), :step(5e-1)
  );

  my Gnome::Gtk3::Range $r .= new(:widget($s));

  diag '.get-range-rect() gives odd values, only after UI setup and show-all() it shows proper values';
  my GdkRectangle $ra = $r.get-range-rect;
  is $ra.x, 1, 'x = 1';
  is $ra.y, 1, 'y = 1';
  is $ra.width, -1, 'width = -1';
  is $ra.height, -1, 'height = -1';
#  note GdkRectangle.new;
}

#-------------------------------------------------------------------------------
done-testing;
