use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::GObject::Value;
use Gnome::GObject::Type;

use Gnome::Gdk3::Window;

use Gnome::Gtk3::Button;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Enums;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'Widget ISA test', {
  my Gnome::Gtk3::Button $b .= new;
  isa-ok $b, Gnome::Gtk3::Widget, '.new';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  is $b.get-visible, 0, '.get-visible()';
  $b.set-visible(1);
  ok $b.get-visible, '.set-visible()';
  ok $b.is-visible, '.is-visible()';
  nok $b.get-has-window, '.get-has-window() is False';

  # does not set .get-has-window()
  my Gnome::Gdk3::Window $gdk-window .= new;
  nok $b.get-has-window, '.get-has-window() still False';
  lives-ok {$b.set-window($gdk-window);}, '.set-window()';
  ok $b.get-window.defined, '.get-window()';
  $b.set-has-window(True);
  ok $b.get-has-window, '.set-has-window()';
  lives-ok {$b.register-window($gdk-window);}, '.register-window()';
  lives-ok {$b.unregister-window($gdk-window);}, '.unregister-window()';
  $b.set-has-window(False);
  nok $b.get-has-window, '.get-has-window() False again';

  # no parent or parent window -> undefined
  nok $b.get-parent.defined, '.get-parent()';
  nok $b.get-parent-window.defined, '.get-parent-window()';

  lives-ok {$b.show-now;}, '.show-now()';
  lives-ok {$b.widget-hide;}, '.widget-hide()';
  lives-ok {$b.widget-show;}, '.widget-show()';
  lives-ok {$b.show-all;}, '.show-all()';
  lives-ok {$b.hide;}, '.hide()';
  lives-ok {$b.show;}, '.show()';

  lives-ok { $b.get_allocated_width;}, '.get_allocated_width()';
  lives-ok { $b.get_allocated_height;}, '.get_allocated_height()';
  lives-ok { $b.get_allocated_baseline;}, '.get_allocated_baseline()';
  lives-ok { $b.get_allocated_size;}, '.get_allocated_size()';
  lives-ok { $b.get_allocation;}, '.get_allocation()';
  lives-ok { $b.get-clip;}, '.get-clip()';
  lives-ok { $b.get-toplevel;}, '.get-toplevel()';

  $b.set_size_request( 100, 101);
  my List $l = $b.get_size_request;
  is $l[0], 100, '.set_size_request()';
  is $l[1], 101, '.get_size_request()';

  $b.set-opacity(0.8);
  is $b.get-opacity, 0.8, '.set-opacity() / .get-opacity()';

  $b.set_no_show_all(True);
  ok $b.get-no-show-all, '.set_no_show_all() / .get-no-show-all()';

  # not drawable because not visible/mapped
  nok $b.get-realized, '.get-realized()';
  nok $b.get-mapped, '.get-mapped()';
  nok $b.is-drawable, '.is-drawable()';

  nok $b.get-hexpand, '.get-hexpand()';
  $b.set-hexpand(True);
  ok $b.get-hexpand, '.set-hexpand()';
  ok $b.get-hexpand-set, '.get-hexpand-set()';
  $b.set-hexpand-set(False);
  nok $b.get-hexpand-set, '.set-hexpand-set()';

  nok $b.get-vexpand, '.get-vexpand()';
  $b.set-vexpand(True);
  ok $b.get-vexpand, '.set-vexpand()';
  ok $b.get-vexpand-set, '.get-vexpand-set()';
  $b.set-vexpand-set(False);
  nok $b.get-vexpand-set, '.set-vexpand-set()';

  $b.set-halign(GTK_ALIGN_START);
  is GtkAlign($b.get-halign), GTK_ALIGN_START, '.set-halign() / .get-halign()';

  $b.set-valign(GTK_ALIGN_START);
  is GtkAlign($b.get-valign), GTK_ALIGN_START, '.set-valign() / .get-valign()';

  $b.set-direction(GTK_TEXT_DIR_RTL);
  is GtkTextDirection($b.get-direction), GTK_TEXT_DIR_RTL,
    '.set-direction() / .get-direction()';

  $b.set-default-direction(GTK_TEXT_DIR_LTR);
  is GtkTextDirection($b.get-default-direction), GTK_TEXT_DIR_LTR,
    '.set-default-direction() / .get-default-direction()';


  $b.set_app_paintable(1);
  ok $b.get_app_paintable, '.set_app_paintable() / .get_app_paintable()';
  nok $b.is-toplevel, '.is-toplevel()';

  $b.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');
  is $b.get-tooltip-text, 'Nooooo don\'t touch that button!!!!!!!',
     '.set-tooltip-text() / .get-tooltip-text()';

#  is $b.get-path, N-GtkWidgetPath, 'No widget path defined to this button';
  is GtkSizeRequestMode($b.get-request-mode),
     GTK_SIZE_REQUEST_CONSTANT_SIZE,
     'request mode is GTK_SIZE_REQUEST_CONSTANT_SIZE';

  my $l1 = $b.get-preferred-size;
  is $l1.elems, 2, '.get-preferred-size()';
  ok $l1[0].width == $l1[1].width, 'widths are the same';
  ok $l1[0].height == $l1[1].height, 'heights are the same';
  my $l1b = $b.gtk_widget_get_preferred_size;
  is $l1b.elems, 2, '.gtk_widget_get_preferred_size()';
  ok $l1[0].width == $l1b[0].width, 'widths are the same';
  ok $l1[0].height == $l1b[0].height, 'heights are the same';
#note $l1b;

  my $l2 = $b.get-preferred-height-and-baseline-for-width(30);
  is $l2.elems, 4, '.get-preferred-height-and-baseline-for-width()';
  is $l2[0], $l1[0].height, 'compare heights';
  is $l2[0], $l2[1], 'heights are the same';
  is $l2[3], -1, 'no baseline';
#note $l2;

  my $l3 = $b.gtk_widget_get_preferred_height_and_baseline_for_width(30);
  is $l2 cmp $l3, Same,
             '.gtk_widget_get_preferred_height_and_baseline_for_width()';
#note $l3;

  my $l4 = $b.get-preferred-width-for-height(10);
#note $l4;
  is $l4.elems, 2, '.get-preferred-width-for-height()';
  my $l4b = $b.gtk_widget_get_preferred_width_for_height(10);
#note $l4b;
  is $l4 cmp $l4b, Same, '.gtk_widget_get_preferred_width_for_height()';

  $l4 = $b.get-preferred-height;
#note $l4;
  is $l4.elems, 2, '.get-preferred-height()';
  $l4b = $b.gtk_widget_get_preferred_height;
#note $l4b;
  is $l4 cmp $l4b, Same, '.gtk_widget_get_preferred_height()';

  $l4 = $b.get-preferred-height-for-width(10);
#note $l4;
  is $l4.elems, 2, '.get-preferred-height-for-width()';
  $l4b = $b.gtk_widget_get_preferred_height_for_width(10);
#note $l4b;
  is $l4 cmp $l4b, Same, '.gtk_widget_get_preferred_height_for_width()';

  $l4 = $b.get-preferred-width;
#note $l4;
  is $l4.elems, 2, '.get-preferred-width()';
  $l4b = $b.gtk_widget_get_preferred_width;
#note $l4b;
  is $l4 cmp $l4b, Same, '.gtk_widget_get_preferred_width()';

  $b.set-sensitive(False);
  nok $b.get-sensitive, '.set-sensitive() / .get-sensitive()';
  nok $b.is-sensitive, '.is-sensitive()';

  $b.gtk-widget-destroy;
  nok $b.is-valid, '.destroy()';
}

#`{{ drop
#-------------------------------------------------------------------------------
subtest 'Requisitions ...', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  my N-GtkRequisition $r = $b.requisition-new;
  is $r.width, 0, '.requisition-new().width()';
  is $r.height, 0, '.requisition-new().height()';

  my N-GtkRequisition $rc = $b.gtk_requisition_copy($r);
  is $r.width, 0, '.gtk_requisition_copy().width()';
  is $r.height, 0, '.gtk_requisition_copy().height()';
}
}}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my Gnome::GObject::Value $gv;

  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  $b.set_no_show_all(True);
  $b.set-name('test-button');

  $gv .= new(:init(G_TYPE_STRING));
  $b.g-object-get-property( 'name', $gv);
  is $gv.g-value-get-string, 'test-button', 'get property name';
  $gv.clear-object;

  $gv .= new(:init(G_TYPE_BOOLEAN));
  $b.g-object-get-property( 'no-show-all', $gv);
  ok $gv.g-value-get-boolean, 'get property no-show-all';
  $gv.g-value-set-boolean(False);
  $b.g-object-set-property( 'no-show-all', $gv);
  is $b.get_no_show_all, 0, 'set property no-show-all';
  $gv.clear-object;
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

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
