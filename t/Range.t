use v6;
use NativeCall;
use Test;
#use lib '../perl6-gnome-native/lib';
#use lib '../perl6-gnome-gobject/lib';

#BEGIN {
#  @*ARGS = < --geometry 300x200+10+10 >;
#}

use Gnome::Gdk3::Types;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Range;
use Gnome::Gtk3::Scale;
use Gnome::Gtk3::Window;

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
  my Gnome::Gtk3::Window $w .= new(:empty);
  my Gnome::Gtk3::Scale $s .= new(
    :orientation(GTK_ORIENTATION_HORIZONTAL),
    :min(10e0), :max(100e0), :step(5e-1)
  );
  $w.gtk-container-add($s);
  $w.show-all;

  my GdkRectangle $ra = $s.get-range-rect;
  ok $ra.x > 1, 'x > 1: ' ~ $ra.x;
  ok $ra.y > 1, 'y > 1: ' ~ $ra.y;
  ok $ra.width > 1, 'width > 1: ' ~ $ra.width;
  ok $ra.height > 1, 'height > 1: ' ~ $ra.height;

  my Int ( $slider_start, $slider_end) = $s.get-slider-range;
  ok $slider_start > 1, 'slider_start: ' ~ $slider_start;
  ok $slider_end > 1, 'slider_end: ' ~ $slider_end;
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
