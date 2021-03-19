use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::MenuButton;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Popover;

use Gnome::Gio::Menu;
use Gnome::Gio::MenuItem;

use Gnome::N::N-GObject;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MenuButton $mb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $mb .= new;
  isa-ok $mb, Gnome::Gtk3::MenuButton, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

# there is a method in Widget which is called the same! Should be no problem
# because it has a different intent!.

  my Gnome::Gtk3::Window $w .= new;
  $w.set-name('top-window');
  $w.container-add($mb);

  $mb.set-direction(GTK_ARROW_RIGHT);
  is $mb.get-direction, GTK_ARROW_RIGHT, '.set-direction() / .get-direction()';

  $mb.set-align-widget($w);
  my Gnome::Gtk3::Widget $wdgt .= new(:native-object($mb.get-align-widget));
  is $wdgt.get-name, 'top-window', '.set-align-widget() / .get-align-widget()';

  my Gnome::Gio::Menu $menu = make-menu();

  $mb.set-menu-model($menu);
  ok $mb.get-use-popover, '.set-menu-model()';
  my Gnome::Gtk3::Menu $xm = $mb.get-popup;
  nok $xm.is-valid, '.get-popup()';
  my Gnome::Gtk3::Popover $xp = $mb.get-popover;
  ok $xp.is-valid, '.get-popover()';
  my Gnome::Gio::MenuModel $xmm = $mb.get-menu-model;
  ok $xmm.is-valid, '.get-menu-model()';

  $mb.set-popover(N-GObject);
  $menu.clear-object;
  nok $mb.get-popover.is-valid, '.set-popover(N-GObject)';

  $mb.set-use-popover(False);
  nok $mb.get-use-popover, '.set-use-popover() / .get-use-popover()';

  $menu = make-menu();          # read a Gnome::Gio::Menu
  $mb.set-menu-model($menu);
  $xm = $mb.get-popup;          # get a Gnome::Gtk3::Menu
  $mb.set-popup($xm);           # set a Gnome::Gtk3::Menu
  ok $xm.is-valid, '.set-popup() / .get-popup()';

}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::MenuButton', {
  class MyClass is Gnome::Gtk3::MenuButton {
    method new ( |c ) {
      self.bless( :GtkMenuButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::MenuButton, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::MenuButton $mb .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $mb.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);

  test-property( G_TYPE_BOOLEAN, 'use-popover', 'get-boolean', 0);
}

#-------------------------------------------------------------------------------
done-testing;

#-------------------------------------------------------------------------------
sub make-menu ( --> Gnome::Gio::Menu ) {
  # Make a section menu with 2 items in it; Toolbar and Statusbar
  my Gnome::Gio::Menu $section .= new;
  $section.append( 'Toolbar', 'app.set-toolbar');
  $section.append( 'Statusbar', 'app.set-statusbar');
  # make the top menu and append 1st section made above
  my Gnome::Gio::Menu $menu .= new;
  $menu.append-item(Gnome::Gio::MenuItem.new(:section($section)));
  $section.clear-object;

  $menu
}

=finish


#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... (
      'any-args',
      Gnome::Gtk3::MenuButton :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::MenuButton;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::MenuButton :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
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

  my Gnome::Gtk3::MenuButton $mb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $mb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $mb.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
