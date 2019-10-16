use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Button;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Enums;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'Widget ISA test', {
  my Gnome::Gtk3::Button $b .= new(:empty);
  isa-ok $b, Gnome::Gtk3::Widget, '.new(:empty)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  is $b.get-visible, 0, '.get-visible()';
  $b.set-visible(1);
  is $b.get-visible, 1, '.set-visible()';

  $b.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');
  is $b.get-tooltip-text, 'Nooooo don\'t touch that button!!!!!!!',
     '.set-tooltip-text() / .get-tooltip-text()';

#  is $b.get-path, N-GtkWidgetPath, 'No widget path defined to this button';
  is GtkSizeRequestMode($b.get-request-mode),
     GTK_SIZE_REQUEST_CONSTANT_SIZE,
     'request mode is GTK_SIZE_REQUEST_CONSTANT_SIZE';

  my @l1 = $b.get-preferred-size;
#note @l1;
  is @l1.elems, 2, '.get-preferred-size()';
  ok @l1[0].width == @l1[1].width, 'widths are the same';
  ok @l1[0].height == @l1[1].height, 'heights are the same';
  my @l1b = $b.gtk_widget_get_preferred_size;
  is @l1b.elems, 2, '.gtk_widget_get_preferred_size()';
  ok @l1[0].width == @l1b[0].width, 'widths are the same';
  ok @l1[0].height == @l1b[0].height, 'heights are the same';
#note @l1b;

  my @l2 = $b.get-preferred-height-and-baseline-for-width(30);
  is @l2.elems, 4, '.get-preferred-height-and-baseline-for-width()';
  is @l2[0], @l1[0].height, 'compare heights';
  is @l2[0], @l2[1], 'heights are the same';
  is @l2[3], -1, 'no baseline';
#note @l2;

  my @l3 = $b.gtk_widget_get_preferred_height_and_baseline_for_width(30);
  is @l2 cmp @l3, Same,
             '.gtk_widget_get_preferred_height_and_baseline_for_width()';
#note @l3;

  my @l4 = $b.get-preferred-width-for-height(10);
#note @l4;
  is @l4.elems, 2, '.get-preferred-width-for-height()';
  my @l4b = $b.gtk_widget_get_preferred_width_for_height(10);
#note @l4b;
  is @l4 cmp @l4b, Same, '.gtk_widget_get_preferred_width_for_height()';

  @l4 = $b.get-preferred-height;
#note @l4;
  is @l4.elems, 2, '.get-preferred-height()';
  @l4b = $b.gtk_widget_get_preferred_height;
#note @l4b;
  is @l4 cmp @l4b, Same, '.gtk_widget_get_preferred_height()';

  @l4 = $b.get-preferred-height-for-width(10);
#note @l4;
  is @l4.elems, 2, '.get-preferred-height-for-width()';
  @l4b = $b.gtk_widget_get_preferred_height_for_width(10);
#note @l4b;
  is @l4 cmp @l4b, Same, '.gtk_widget_get_preferred_height_for_width()';

  @l4 = $b.get-preferred-width;
#note @l4;
  is @l4.elems, 2, '.get-preferred-width()';
  @l4b = $b.gtk_widget_get_preferred_width;
#note @l4b;
  is @l4 cmp @l4b, Same, '.gtk_widget_get_preferred_width()';
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
