use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

use Gnome::Glib::List;

use Gnome::Gdk3::Window;
use Gnome::Gdk3::Display;
#use Gnome::Gdk3::Device;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Screen;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::StyleContext;

#use Gnome::N::X;
#Gnome::N::debug(:on);
use Gnome::N::GlibToRakuTypes;
use Gnome::N::N-GObject;

#-------------------------------------------------------------------------------
subtest 'Widget ISA test', {
  my Gnome::Gtk3::Button $b .= new;
  isa-ok $b, Gnome::Gtk3::Widget, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
#`{{}}
class ListHandlerClass {
  has Bool $.mnem-found = False;

  method list-handler ( Pointer $item ) {
    my N-GObject $no = nativecast( N-GObject, $item);
    my Gnome::Gtk3::Widget $w .= new(:native-object($no));
    if $w.get-name eq 'GtkLabel' {
      my Gnome::Gtk3::Label $hl .= new(:native-object($no));
      is $hl.get-label, any(<_Abc _Def>),
        '.add-mnemonic-label() / .list-mnemonic-labels-rk()';
      $!mnem-found = True;
    }
  }

  method can-act-acc ( guint $sig-id --> gboolean ) {
    diag "signal id: $sig-id";
    1
  }
}

subtest 'Manipulations 1', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  $b.add-mnemonic-label(Gnome::Gtk3::Label.new(:mnemonic<_Abc>));
  $b.add-mnemonic-label(Gnome::Gtk3::Label.new(:mnemonic<_Def>));

  my Gnome::Glib::List $lst = $b.list-mnemonic-labels-rk;
  is $lst.length, 2, 'list length: ' ~ $lst.length;
  my ListHandlerClass $lhc .= new;
  $lst.foreach( $lhc, 'list-handler');
  $lst.clear-object;
  ok $lhc.mnem-found, 'mnemonic found';

  $b.remove-mnemonic-label(Gnome::Gtk3::Label.new(:mnemonic<_Def>));
  $lst = $b.list-mnemonic-labels-rk;
  is $lst.length, 2, 'list length: ' ~ $lst.length;

  my Int $hid = $b.register-signal( $lhc, 'can-act-acc', 'can-activate-accel');
  ok $b.can-activate-accel($hid), '.can-activate-accel()';
}


#-------------------------------------------------------------------------------
my Gnome::Gtk3::Button $b .= new(:label<abc>);
subtest 'Manipulations 2', {
  nok $b.get-visible, '.get-visible()';
  $b.set-visible(True);
  ok $b.get-visible, '.set-visible()';
  ok $b.is-visible, '.is-visible()';
  nok $b.get-has-window, '.get-has-window() is False';
  ok $b.activate, '.activate()';

  #diag 'eventmask bits: ' ~ $b.get-events.base(2);
  my Int $em = $b.get-events;
  $b.add-events( GDK_POINTER_MOTION_MASK +| GDK_BUTTON_MOTION_MASK);
  ok ($b.get-events +& GDK_POINTER_MOTION_MASK) > 0,
    '.add-events() / .get-events()';
  $b.set-events($em);
  ok ($b.get-events +& GDK_BUTTON_MOTION_MASK) > 0, '.set-events()';

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

  lives-ok {$b.show-now;}, '.show-now()';
  lives-ok {$b.show-all;}, '.show-all()';
  lives-ok {$b.hide;}, '.hide()';
  lives-ok {$b.show;}, '.show()';

  my N-GtkAllocation $allocation .= new( :x(2), :y(2), :width(50), :height(20));
  $b.size-allocate($allocation);
  is $b.get-allocated-width, 50, '.get-allocated-width()';
  is $b.get-allocated-height, 20, '.get-allocated-height()';
  $b.size-allocate-with-baseline( $allocation, 10);
  lives-ok { $b.get-allocated-baseline;},
    '.size-allocate-with-baseline() / .get-allocated-baseline()';

  if %*ENV<travis_ci_tests> {
    skip 'travis differs, older GTK+ version', 1;
  }

  else {
    lives-ok { $b.get-allocated-size;}, '.get-allocated-size()';
  }

  lives-ok { $b.get-allocation;}, '.get-allocation()';
  lives-ok { $b.get-clip;}, '.get-clip()';
  lives-ok { $b.get-toplevel;}, '.get-toplevel()';

  $b.set-size-request( 100, 101);
  my List $l = $b.get-size-request;
  is $l[0], 100, '.set-size-request()';
  is $l[1], 101, '.get-size-request()';

  $b.set-opacity(0.8);
  is $b.get-opacity, 0.8, '.set-opacity() / .get-opacity()';

  $b.set-no-show-all(True);
  ok $b.get-no-show-all, '.set-no-show-all() / .get-no-show-all()';

  # not drawable because not visible/mapped
  $b.set-realized(True);
  ok $b.get-realized, '.get-realized()';

  # set back to False otherwise next problem occurs
  # Gtk:ERROR:gtkwidget.c:5871:gtk_widget_get_frame_clock: assertion failed: (window != NULL)
  # Bail out! Gtk:ERROR:gtkwidget.c:5871:gtk_widget_get_frame_clock: assertion failed: (window != NULL)
  # Abort (core dumped)
  $b.set-realized(False);

  nok $b.get-mapped, '.get-mapped()';
  nok $b.is-drawable, '.is-drawable()';

  nok $b.get-hexpand, '.get-hexpand()';
  $b.set-hexpand(True);
  ok $b.get-hexpand, '.set-hexpand()';
  ok $b.get-hexpand-set, '.get-hexpand-set()';
  $b.set-hexpand-set(False);
  nok $b.get-hexpand-set, '.set-hexpand-set()';
  lives-ok {$b.compute-expand(GTK_ORIENTATION_VERTICAL);}, '.compute-expand()';

  nok $b.get-vexpand, '.get-vexpand()';
  $b.set-vexpand(True);
  ok $b.get-vexpand, '.set-vexpand()';
  ok $b.get-vexpand-set, '.get-vexpand-set()';
  $b.set-vexpand-set(False);
  nok $b.get-vexpand-set, '.set-vexpand-set()';

  $b.set-halign(GTK_ALIGN_START);
  is $b.get-halign, GTK_ALIGN_START, '.set-halign() / .get-halign()';

  $b.set-valign(GTK_ALIGN_START);
  is $b.get-valign, GTK_ALIGN_START, '.set-valign() / .get-valign()';
  is $b.get-valign-with-baseline, GTK_ALIGN_START,
    '.set-valign-with-baseline()';

  $b.set-direction(GTK_TEXT_DIR_RTL);
  is GtkTextDirection($b.get-direction), GTK_TEXT_DIR_RTL,
    '.set-direction() / .get-direction()';

  $b.set-default-direction(GTK_TEXT_DIR_LTR);
  is GtkTextDirection($b.get-default-direction), GTK_TEXT_DIR_LTR,
    '.set-default-direction() / .get-default-direction()';


  $b.set-app-paintable(True);
  ok $b.get-app-paintable, '.set-app-paintable() / .get-app-paintable()';
  nok $b.is-toplevel, '.is-toplevel()';

  $b.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');
  is $b.get-tooltip-text, 'Nooooo don\'t touch that button!!!!!!!',
     '.set-tooltip-text() / .get-tooltip-text()';
  $b.set-has-tooltip(False);
  nok $b.get-has-tooltip, '.set-has-tooltip() / .get-has-tooltip()';

#  is $b.get-path, N-GtkWidgetPath, 'No widget path defined to this button';
  is GtkSizeRequestMode($b.get-request-mode),
     GTK_SIZE_REQUEST_CONSTANT_SIZE,
     'request mode is GTK_SIZE_REQUEST_CONSTANT_SIZE';

  my $l1 = $b.get-preferred-size;
  is $l1.elems, 2, '.get-preferred-size()';
  ok $l1[0].width == $l1[1].width, 'widths are the same';
  ok $l1[0].height == $l1[1].height, 'heights are the same';
  my $l1b = $b.get-preferred-size;
  is $l1b.elems, 2, '.get-preferred-size()';
  ok $l1[0].width == $l1b[0].width, 'widths are the same';
  ok $l1[0].height == $l1b[0].height, 'heights are the same';
#note $l1b;

  my $l2 = $b.get-preferred-height-and-baseline-for-width(30);
  is $l2.elems, 4, '.get-preferred-height-and-baseline-for-width()';
  is $l2[0], $l1[0].height, 'compare heights';
  is $l2[0], $l2[1], 'heights are the same';
  is $l2[3], -1, 'no baseline';
#note $l2;

  my $l3 = $b.get-preferred-height-and-baseline-for-width(30);
  is $l2 cmp $l3, Same,
             '.get-preferred-height-and-baseline-for-width()';
#note $l3;

  my $l4 = $b.get-preferred-width-for-height(10);
#note $l4;
  is $l4.elems, 2, '.get-preferred-width-for-height()';
  my $l4b = $b.get-preferred-width-for-height(10);
#note $l4b;
  is $l4 cmp $l4b, Same, '.get-preferred-width-for-height()';

  $l4 = $b.get-preferred-height;
#note $l4;
  is $l4.elems, 2, '.get-preferred-height()';
  $l4b = $b.get-preferred-height;
#note $l4b;
  is $l4 cmp $l4b, Same, '.get-preferred-height()';

  $l4 = $b.get-preferred-height-for-width(10);
#note $l4;
  is $l4.elems, 2, '.get-preferred-height-for-width()';
  $l4b = $b.get-preferred-height-for-width(10);
#note $l4b;
  is $l4 cmp $l4b, Same, '.get-preferred-height-for-width()';

  $l4 = $b.get-preferred-width;
#note $l4;
  is $l4.elems, 2, '.get-preferred-width()';
  $l4b = $b.get-preferred-width;
#note $l4b;
  is $l4 cmp $l4b, Same, '.get-preferred-width()';

  $b.set-sensitive(False);
  nok $b.get-sensitive, '.set-sensitive() / .get-sensitive()';
  nok $b.is-sensitive, '.is-sensitive()';

  lives-ok {$b.error-bell;}, '.error-bell()';

  my Gnome::Gtk3::Window $w .= new;
  $w.set-title('My Button In My Window');
  my Gnome::Gtk3::Grid $g .= new;
  $w.add($g);
  $g.attach( $b, 0, 0, 1, 1);

  $b.set-can-default(True);
  ok $b.get-can-default, '.set-can-default() / .get-can-default()';
  lives-ok {$b.grab-default;}, '.grab-default()';
  ok $b.has-default, '.has-default()';

  $b.set-can-focus(True);
  ok $b.get-can-focus, '.set-can-focus() / .get-can-focus()';
  lives-ok { $b.grab-focus; }, '.grab-focus()';
  lives-ok { diag 'has focus: ' ~ $b.has-focus; }, '.has-focus()';
  lives-ok { diag 'is focus: ' ~ $b.is-focus; }, '.is-focus()';
  lives-ok { diag 'has grab: ' ~ $b.has-grab; }, '.has-grab()';
  lives-ok { diag 'has screen: ' ~ $b.has-screen; }, '.has-screen()';
  lives-ok { diag 'has vis. focus: ' ~ $b.has-visible-focus; },
    '.has-visible-focus()';
  lives-ok { diag 'hide on del: ' ~ $b.hide-on-delete; }, '.hide-on-delete()';
  nok $b.in-destruction, '.in-destruction()';

  $b.set-child-visible(True);
  ok $b.get-child-visible, '.set-child-visible() / .get-child-visible()';

  if %*ENV<travis_ci_tests> {
    skip '. set/get -focus-on-click() not known on Travis';
  }

  else {
    $b.set-focus-on-click(True);
    ok $b.get-focus-on-click, '.set-focus-on-click() / .get-focus-on-click()';
  }

  $b.set-margin-bottom(10);
  is $b.get-margin-bottom, 10, '.set-margin-bottom() / .get-margin-bottom()';

  $b.set-margin-end(10);
  is $b.get-margin-end, 10, '.set-margin-end() / .get-margin-end()';

  $b.set-margin-start(10);
  is $b.get-margin-start, 10, '.set-margin-start() / .get-margin-start()';

  $b.set-margin-top(10);
  is $b.get-margin-top, 10, '.set-margin-top() / .get-margin-top()';

  $b.set-name('test-button1');
  is $b.get-name, 'test-button1', '.set-name() / .get-name()';
  $b.buildable-set-name('other-test-button1');
  is $b.buildable-get-name, 'other-test-button1',
    '.buildable-set-name() / .buildable-get-name()';

  lives-ok {
      diag 'modifier type mask: ' ~ $b.get-modifier-mask(
        GDK_MODIFIER_INTENT_PRIMARY_ACCELERATOR
      ).base(2);
    }, '.get-modifier-mask()';

  lives-ok { diag 'widget-path: ' ~ $b.get-path-rk.to-string; },
    '.get-path-rk()';

  $b.set-receives-default(True);
  ok $b.get-receives-default,
    '.set-receives-default() / .get-receives-default()';

  lives-ok { diag 'request mode: ' ~ $b.get-request-mode; },
    '.get-request-mode()';

  lives-ok { diag 'scale factor: ' ~ $b.get-scale-factor; },
    '.get-scale-factor()';

  lives-ok { $b.set-redraw-on-allocate(True); }, '.set-redraw-on-allocate()';

  my Gnome::Gtk3::Window $w2 = $b.get-ancestor-rk($w.get-class-gtype);
  is $w2.get-title, 'My Button In My Window', '.get-ancestor-rk(Int)';
  $w2 = $b.get-ancestor-rk('GtkWindow');
  is $w2.get-title, 'My Button In My Window', '.get-ancestor-rk(Str)';
  $w2 = $b.get-ancestor-rk($w);
  is $w2.get-title, 'My Button In My Window',
    '.get-ancestor-rk(Gnome::Gtk3::Window)';
  $w2 .= new(:native-object($b.get-ancestor($w.get-class-gtype)));
  is $w2.get-title, 'My Button In My Window', '.get-ancestor(Int)';

  my Gnome::Gtk3::Grid $g2 = $b.get-parent-rk;
  my Gnome::Glib::List $list .= new(:native-object($g2.get-children));
  is $list.length, 1, '.get-parent(): ' ~ $list.length;

# TODO don't understand next tests. It returns a button.
#`{{
  $w2 .= new(:native-object($b.get-parent-window));
  is $w2.get-title, 'My Button In My Window', '.get-parent-window()';

  $w2 = $b.get-parent-window;
  is $w2.get-title, 'My Button In My Window', '.get-parent-window()';
}}

  $b.set-tooltip-markup('A <B>ha</b>');
  is $b.get-tooltip-markup, 'A <B>ha</b>',
    '.set-tooltip-markup() / .get-tooltip-markup()';

# TODO don't understand next tests. It returns a button.
#`{{
  is $b.get-tooltip-window.^name, 'Gnome::Gtk3::Window',
    '.get-tooltip-window()';
}}
  is $b.get-toplevel-rk.^name, 'Gnome::Gtk3::Window', '.get-toplevel()';
  is $b.get-visual-rk.^name, 'Gnome::Gdk3::Visual', '.get-visual()';


  $b.set-state-flags( GTK_STATE_FLAG_ACTIVE, False);
  ok $b.get-state-flags() +| GTK_STATE_FLAG_ACTIVE,
    '.set-state-flags() / .get-state-flags(): ' ~
    $b.get-state-flags().fmt('0b%016b');
  $b.unset-state-flags(GTK_STATE_FLAG_ACTIVE);
  nok $b.get-state-flags() +& GTK_STATE_FLAG_ACTIVE,
    '.unset-state-flags(): ' ~ $b.get-state-flags().fmt('0b%016b');


  my Gnome::Gtk3::StyleContext $sc = $b.get-style-context-rk;
  ok 1, '.get-style-context-rk(): ' ~ ($sc.get-path // '-');

  my N-GdkRectangle $area .= new( :x(10), :y(10), :width(100), :height(200));
  my N-GdkRectangle $inter .= new;
  $b.intersect( $area, $inter);
  diag "Intersection of button with area $area.gist() is $inter.gist()";


  $w.set-support-multidevice(True);
  ok $w.get-support-multidevice,
    '.set-support-multidevice() / .get-support-multidevice()';

  ok $b.is-ancestor($w), '.is-ancestor()';
  lives-ok { diag 'action list: ' ~ $b.list-action-prefixes(); },
    '.list-action-prefixes()';

  lives-ok { $b.queue-compute-expand; }, '.queue-compute-expand()';
  lives-ok { $b.queue-draw; }, '.queue-draw()';
  lives-ok { $b.queue-draw-area( 10, 10, 100, 200); }, '.queue-draw-area()';
  lives-ok { $b.reset-style; }, '.reset-style()';
  #lives-ok { $b.; }, '.()';

  $b.destroy;
  $w.destroyed($b);
  nok $b.is-valid, '.destroy() / .destroyed()';

#note $b.list-action-prefixes[0];
}

#-------------------------------------------------------------------------------
subtest 'devices…', {

  $b .= new(:label<abc>);

  my Gnome::Gtk3::Window $w .= new;
  $w.set-title('My Button In My Window');
  $w.add($b);

  lives-ok {diag 'display name: ' ~ $b.get-display.().get-name;},
    '.get-display()';
  lives-ok {diag 'display name: ' ~ $b.get-screen.().get-display.().get-name;},
    'get-screen()';
#  lives-ok { $b.set-device-enabled(True) }, '.set-device-enabled()';
}

#`{{ drop }}
#-------------------------------------------------------------------------------
subtest 'Requisitions ...', {
  my Gnome::Gtk3::Button $b .= new(:label<abc>);
  my N-GtkRequisition $r = $b.requisition-new;
  is $r.width, 0, '.requisition-new().width()';
  is $r.height, 0, '.requisition-new().height()';

  my N-GtkRequisition $rc = $b.gtk-requisition-copy($r);
  is $r.width, 0, '.gtk-requisition-copy().width()';
  is $r.height, 0, '.gtk-requisition-copy().height()';

  lives-ok {
    $b.gtk-requisition-free($rc);
    $b.gtk-requisition-free($r);
  }, '.gtk-requisition-free()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Widget $w .= new;
  $b .= new(:label<abc>);
  $b.set-no-show-all(True);
  ok $b.get-no-show-all, '.set-no-show-all() / .get-no-show-all()';
  $b.set-name('test-button');

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $b.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    # dependency on local settings might result in different values
    elsif $is-local {
      if $gv-value ~~ /$value/ {
        like $gv-value, /$value/, "property $prop, value: " ~ $gv-value;
      }

      else {
        ok 1, "property $prop, value: " ~ $gv-value;
      }
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);

  test-property( G_TYPE_STRING, 'name', 'get-string', 'test-button');
  test-property( G_TYPE_BOOLEAN, 'no-show-all', 'get-boolean', True);
  test-property( G_TYPE_BOOLEAN, 'app-paintable', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'can-default', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'can-focus', 'get-boolean', True);
  test-property( G_TYPE_BOOLEAN, 'composite-child', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'expand', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'has-default', 'get-boolean', False);

  if %*ENV<travis_ci_tests> {
    skip 'property focus-on-click not known on Travis';
  }

  else {
    test-property( G_TYPE_BOOLEAN, 'focus-on-click', 'get-boolean', True);
  }
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method m-act ( Int $group_cycling --> gboolean ) {
      ok $group_cycling, 'arg $group_cycling';
      $!signal-processed = True;
      1
    }

    method k-fail ( Int $direction --> gboolean ) {
      is GtkDirectionType($direction), GTK_DIR_UP, 'arg $direction';
      $!signal-processed = True;
      1
    }

    method signal-emitter ( Gnome::Gtk3::Widget :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);

      ok $b.mnemonic-activate(True), '.mnemonic-activate()';
      is $!signal-processed, True, '\'mnemonic-activate\' signal processed';
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      $!signal-processed = False;

      ok $b.keynav-failed(GTK_DIR_UP), '.keynav-failed()';
      is $!signal-processed, True, '\'keynav-failed\' signal processed';
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      $!signal-processed = False;

      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  #my Gnome::Gtk3::Widget $w .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $b.register-signal( $sh, 'm-act', 'mnemonic-activate');
  $b.register-signal( $sh, 'k-fail', 'keynav-failed');

  my Promise $p = $b.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Widget', {
  class MyClass is Gnome::Gtk3::Widget {
    method new ( |c ) {
      self.bless( :GtkWidget, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Widget, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
