use v6;
#use lib '../perl6-gnome-gobject/lib';

use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::WidgetPath $wp .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $wp, Gnome::Gtk3::WidgetPath;
  ok $wp.widgetpath-is-valid, 'widgetpath is valid';
  $wp.clear-widget-path;
  ok !$wp.widgetpath-is-valid, 'widgetpath not valid anymore';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
#  $wp.append-type(GTK_TYPE_WINDOW);
  my Gnome::Gtk3::Window $w .= new(:title<Top>);
  $w.set-name('top-level-window');

  my Gnome::Gtk3::Grid $g .= new(:empty);
  $g.set-name('top-grid');
  $w.gtk-container-add($g);

  my Gnome::Gtk3::Button $b1 .= new(:label<Start>);
  $b1.set-name('start-button');
  $g.gtk-grid-attach( $b1, 0, 0, 1, 1);

  my Gnome::Gtk3::Button $b2 .= new(:label<Stop>);
  $g.gtk-grid-attach( $b2, 0, 1, 1, 1);

#  note $b1.get-path.perl;
  $wp .= new(:widgetpath($b1.get-path));
  is $wp.gtk-widget-path-length, 3, 'length of path is 3';
  is $wp.iter-get-name(0), 'top-level-window', $wp.iter-get-name(0);
  is $wp.iter-get-name(1), 'top-grid', $wp.iter-get-name(1);
  is $wp.iter-get-name(2), 'start-button', $wp.iter-get-name(2);

  is $wp.to-string, 'window(top-level-window):dir-ltr.background grid(top-grid):dir-ltr.horizontal button(start-button):dir-ltr.text-button', $wp.to-string;

  $wp .= new(:widgetpath($b2.get-path));
  is $wp.iter-get-name(2), Str, 'string button 2 not set';
  ok !$wp.iter_has_name( 2, 'stop-button'), 'iter 2 has different name';
  $wp.iter-set-name( 2, 'stop-button');
  ok $wp.iter_has_name( 2, 'stop-button'), "iter 2 now has 'stop-button' name";
  is $wp.iter-get-name(2), 'stop-button', 'string button 2 correct';

  # widget(name):state.class
  is $wp.to-string,
   'window(top-level-window):dir-ltr.background grid(top-grid):dir-ltr.horizontal button(stop-button):dir-ltr.text-button', $wp.to-string;

  my Gnome::Glib::SList $l .= new(:gslist($wp.iter-list-classes(2)));
  is $l.g-slist-length, 1, 'list contains one class';
  is $l.nth-data-str(0), 'text-button', "class is a 'text-button'";

  ok $wp.iter-get-state(2) +& GTK_STATE_FLAG_DIR_LTR.value,
     'flag GTK_STATE_FLAG_DIR_LTR ok';
  my Int $new-state = $wp.iter-get-state(2) +| GTK_STATE_FLAG_INSENSITIVE;
  $wp.iter-set-state( 2, $new-state);
  ok $wp.iter-get-state(2) +& GTK_STATE_FLAG_INSENSITIVE.value,
     'flag GTK_STATE_FLAG_INSENSITIVE ok';
  ok $wp.iter-get-state(2) +& GTK_STATE_FLAG_DIR_LTR.value,
     'flag GTK_STATE_FLAG_DIR_LTR still there';

  my Int $drop-flag = GTK_STATE_FLAG_INSENSITIVE.value +^ 0xFFFFFFFF;
  $new-state = $wp.iter-get-state(2) +& $drop-flag;
  $wp.iter-set-state( 2, $new-state);
  ok !($wp.iter-get-state(2) +& GTK_STATE_FLAG_INSENSITIVE.value),
     'flag GTK_STATE_FLAG_INSENSITIVE is removed';
  ok $wp.iter-get-state(2) +& GTK_STATE_FLAG_DIR_LTR.value,
     'flag GTK_STATE_FLAG_DIR_LTR still there';

  # make a copy and do a check
  my Gnome::Gtk3::WidgetPath $wp-copy .= new(
    :widgetpath($wp.gtk-widget-path-copy)
  );
  is $wp-copy.gtk-widget-path-length, 3, 'copy has same length';
  ok $wp-copy.iter-get-state(2) +& GTK_STATE_FLAG_DIR_LTR.value,
     'flag GTK_STATE_FLAG_DIR_LTR in copy is there too';
  $wp-copy.clear-widget-path;

#  ok $wp.gtk_widget_path_iter_has_class( 0, 'GtkWindow'), 'top class is a Window';

  my Int $quark-name = Gnome::GObject::Type.new().g_type_from_name('GtkButton');
}

#-------------------------------------------------------------------------------
done-testing;
