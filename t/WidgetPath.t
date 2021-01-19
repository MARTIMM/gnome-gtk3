use v6;
#use lib '../gnome-gobject/lib';
#use lib '../gnome-native/lib';

use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Type;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::Window;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::WidgetPath $wp .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $wp, Gnome::Gtk3::WidgetPath;
  ok $wp.is-valid, 'widgetpath is valid';
  $wp.clear-object;
  nok $wp.is-valid, 'widgetpath not valid anymore';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
#  $wp.append-type(GTK_TYPE_WINDOW);
  my Gnome::Gtk3::Window $w .= new;
  $w.set-title('Top');
  $w.gtk-widget-set-name('top-level-window');

  my Gnome::Gtk3::Grid $g .= new;
  $g.gtk-widget-set-name('top-grid');
  $w.gtk-container-add($g);

  my Gnome::Gtk3::Button $b1 .= new(:label<Start>);
  $b1.gtk-widget-set-name('start-button');
  $g.gtk-grid-attach( $b1, 0, 0, 1, 1);

  my Gnome::Gtk3::Button $b2 .= new(:label<Stop>);
  $g.gtk-grid-attach( $b2, 0, 1, 1, 1);

#note "path: ", $b1.get-path.Str;
#Gnome::N::debug(:on);
  $wp .= new(:native-object($b1.get-path));
#note "path $wp.get-native-object-no-reffing()";
  ok $wp.is-valid, '.get-path()';
  is $wp.gtk-widget-path-length, 3, 'length of path is 3';

  is $wp.iter-get-name(0), 'top-level-window', $wp.iter-get-name(0);
  is $wp.iter-get-name(1), 'top-grid', $wp.iter-get-name(1);
  is $wp.iter-get-name(2), 'start-button', $wp.iter-get-name(2);

  if %*ENV<travis_ci_tests> {
    diag 'Rest of tests skipped. GTK+ on travis differs using an older version. some tests depend also on other skipped tests';
    done-testing;
    exit(0);
  }

  else {
    is $wp.iter-get-object-name(0), 'window', $wp.iter-get-object-name(0);
    is $wp.iter-get-object-name(1), 'grid', $wp.iter-get-object-name(1);
    is $wp.iter-get-object-name(2), 'button', $wp.iter-get-object-name(2);

    is $wp.to-string, 'window(top-level-window):dir-ltr.background grid(top-grid):dir-ltr.horizontal button(start-button):dir-ltr.text-button', $wp.to-string;

    $wp .= new(:native-object($b2.get-path));
    is $wp.iter-get-name(2), Str, 'string button 2 not set';
    ok !$wp.iter_has_name( 2, 'stop-button'), 'iter 2 has different name';
    $wp.iter-set-name( 2, 'stop-button');
    ok $wp.iter_has_name( 2, 'stop-button'), "iter 2 now has 'stop-button' name";
    is $wp.iter-get-name(2), 'stop-button', 'string button 2 correct';

    # widget(name):state.class
    is $wp.to-string,
     'window(top-level-window):dir-ltr.background grid(top-grid):dir-ltr.horizontal button(stop-button):dir-ltr.text-button', $wp.to-string;

    my Gnome::Glib::SList $l .= new(:native-object($wp.iter-list-classes(2)));
    is $l.g-slist-length, 1, 'list contains one class';
    is nativecast( Str, $l.nth-data(0)), 'text-button', "class is a 'text-button'";

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
      :native-object($wp.gtk-widget-path-copy)
    );
    is $wp-copy.gtk-widget-path-length, 3, 'copy has same length';
    ok $wp-copy.iter-get-state(2) +& GTK_STATE_FLAG_DIR_LTR.value,
       'flag GTK_STATE_FLAG_DIR_LTR in copy is there too';
    $wp-copy.clear-object;

  #  ok $wp.gtk_widget_path_iter_has_class( 0, 'GtkWindow'), 'top class is a Window';

    my Int $quark-name = Gnome::GObject::Type.new().g_type_from_name('GtkButton');
  }
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
