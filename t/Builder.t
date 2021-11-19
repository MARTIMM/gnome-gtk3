use v6;
#use NativeCall;
#use lib '../gnome-gobject/lib';
#use lib '../gnome-glib/lib';
#use lib '../gnome-native/lib';
use Test;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::Glib::Error;
use Gnome::Glib::Quark;

#use Gnome::GObject::Object;
#use Gnome::GObject::Type;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Window;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Glib::Quark $quark .= new;
my Gnome::Glib::Error $e;

my Str $ui-file = 't/data/ui.glade';

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  my Gnome::Gtk3::Builder $builder;
  $builder .= new;
  isa-ok $builder, Gnome::Gtk3::Builder, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Add ui from file to builder', {
  my Gnome::Gtk3::Builder $builder .= new;

  $e = $builder.add-from-file($ui-file);
  nok $e.is-valid, ".add-from-file()";

  my Str $text = $ui-file.IO.slurp;
  $e = $builder.add-from-string($text);
  nok $e.is-valid, ".add-from-string()";

  $builder .= new(:string($text));
  ok $builder.defined, '.new(:string)';

  $builder .= new(:file($ui-file));
  ok $builder.defined, '.new-from-file()';

  nok $builder.get-application-rk.is-valid, '.get-application-rk()';
}

#-------------------------------------------------------------------------------
subtest 'Test builder errors', {
  my Gnome::Gtk3::Builder $builder .= new;

  # Get the text glade text again and corrupt it by removing an element
  my Str $text = $ui-file.IO.slurp;
  $text ~~ s/ '<interface>' //;

  subtest "errorcode return from gtk_builder_add_from_file", {
    $e = $builder.add-from-file('x.glade');
    ok $e.is-valid, "error from .add-from-file()";
    ok $e.domain > 0, "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'g-file-error-quark', 'error domain ok';
    is $e.code, 4, 'error code for this error is 4 and is from file IO';
#    is $e.message,
#       'Failed to open file “x.glade”: No such file or directory',
#       $e.message;
  }

  subtest "errorcode return from gtk_builder_add_from_string", {
    my Gnome::Glib::Quark $quark .= new;

    $e = $builder.add-from-string($text);
    ok $e.is-valid, "error from .add-from-string()";
    is $e.domain, $builder.error-quark(), "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-builder-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_BUILDER_ERROR_UNHANDLED_TAG.value,
       'error code for this error is GTK_BUILDER_ERROR_UNHANDLED_TAG';
#    is $e.message, '<input>:4:40 Unhandled tag: <requires>', $e.message;
  }
}

#-------------------------------------------------------------------------------
subtest 'Test items from ui', {
  my Gnome::Gtk3::Builder $builder .= new;
  $e = $builder.add-from-file($ui-file);
  nok $e.is-valid, ".add-from-file()";

  lives-ok {
    isa-ok $builder.get-object('my-button-1'), N-GObject;

    my Gnome::Gtk3::Button $b1 .= new(:build-id<my-button-1>);
    my Gnome::Gtk3::Button $b2 = $builder.get-object-rk('my-button-1');

    is $b1.get-label, $b2.get-label, '.get-label()';
    is $b1.gtk-widget-get-name, $b2.gtk-widget-get-name,
      '.gtk-widget-get-name()';
    is $b1.get-border-width, $b2.get-border-width, '.get-border-width()';
  }, '.get-object() / .get-object-rk()';

  #$b.gtk-widget-show;
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#`{{
Other X11 errors prevent good tests

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Main $m .= new;
my Str $ui = q:to/EOUI/;
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <requires lib="gtk+" version="3.20"/>

      <object class="GtkWindow" id="top">
        <property name="title">top window</property>
        <signal name="destroy" handler="window-quit"/>
        <child>
          <object class="GtkButton" id="help">
            <property name="label">Help</property>
            <signal name="clicked" handler="button-click"/>
          </object>
        </child>
      </object>
    </interface>
    EOUI

class X {
  method window-quit ( :$o1, :$o2 --> Int ) {
    is $o1, 'o1', 'option 1 found';
    $m.gtk-main-quit;
    1
  }
}

class Z {
  method button-click ( :$o3, :$o4 --> Int ) {
    is $o3, 'o3', 'option 3 found';
    1
  }
}

class Y {
  method send-signals ( :$widget, :$window, :$button --> Str ) {

    while $m.gtk-events-pending() { $m.iteration-do(False); }
    $button.emit-by-name('clicked');
    sleep 0.5;

    while $m.gtk-events-pending() { $m.iteration-do(False); }
    $window.emit-by-name('destroy');

    return 'done'
  }
}

subtest 'Find signals in ui', {
  my Gnome::Gtk3::Builder $builder .= new(:string($ui));

  # add a small delay. sometimes there is a weird error;
  # 'Gdk-Message: 13:49:15.306: Builder.t: Fatal IO error 0 (Success) on
  # X server :0.'
  # It seems this delay helps.
  sleep 0.5;

  my Gnome::Gtk3::Window $w .= new(:build-id<top>);

  my X $x .= new;
  my Z $z .= new;
  my Hash $handlers = %(
    :window-quit( $x, :o1<o1>, :o2<o2>),
    :button-click( $z, :o3<o3>, :o4<o4>)
  );
#Gnome::N::debug(:on);
  $builder.connect-signals-full($handlers);
#Gnome::N::debug(:off);
  my Promise $p = $builder.start-thread(
    Y.new, 'send-signals', :window($w),
    :button(Gnome::Gtk3::Button.new(:build-id<help>))
  );

  $w.show-all;
  $m.gtk-main;

  is $p.result, 'done', 'exit thread ok';
}
}}

#-------------------------------------------------------------------------------
done-testing;
