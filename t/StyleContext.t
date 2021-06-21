use v6;
use NativeCall;
use Test;

use Gnome::Cairo::ImageSurface;
use Gnome::Cairo;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;

use Gnome::Gdk3::Screen;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::RGBA;
use Gnome::Gdk3::Pixbuf;

use Gnome::Gtk3::Border;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::StyleContext;
use Gnome::Gtk3::StyleProvider;
use Gnome::Gtk3::CssProvider;

use Gnome::GObject::Value;

use Gnome::Glib::List;


#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::StyleContext $sc;
  $sc .= new;
  isa-ok $sc, Gnome::Gtk3::StyleContext;
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Style context manipulations', {
  my Gnome::Gdk3::Screen $screen .= new;
  my Gnome::Gtk3::StyleContext $sc .= new;
  my Gnome::Gtk3::CssProvider $cp1 .= new;

  lives-ok {
    $sc.add-provider-for-screen(
      $screen, $cp1, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
    );
    $sc.remove-provider-for-screen( $screen, $cp1);
  }, '.add-provider-for-screen() / .remove-provider-for-screen()';

  lives-ok {
    my Gnome::Gtk3::CssProvider $cp2 .= new;
    $sc.add-provider( $cp2, 234);
    $sc.remove-provider($cp2);
  }, '.add-provider() / .remove-provider()';

  lives-ok {
    $sc.reset-widgets($screen);
  }, '.reset-widgets()';

  # use for later
  my Gnome::Gtk3::Label $lbl .= new(:text('my label text'));
  $sc .= new(:native-object($lbl.get-style-context));
  lives-ok {
    $sc.add-class('xyz');
    $sc.remove-class('xyz');
    $sc.add-class('MyLabel');
  }, '.add-class() / .remove-class()';

  lives-ok {
    $sc.save;
    $sc.remove-class('MyLabel');
    $sc.restore;
  }, '.save() / .restore()';

  my Str $data = Q:q:to/EOCSS/;
      .MyLabel { color: #204080; }
      label { color: #204080; }
      EOCSS
  $cp1.load-from-data($data);
  $sc.add-provider-for-screen(
    $screen, $cp1, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
  );


  $sc.set-state(GTK_STATE_FLAG_LINK +| GTK_STATE_FLAG_DIR_LTR);
  ok $sc.get-state +& GTK_STATE_FLAG_DIR_LTR, '.set-state() / .get-state()';

  my N-GtkBorder $border-no = $sc.get-border(GTK_STATE_FLAG_DIR_LTR);
  is $border-no.left, 0, '.get-border()';

  my N-GdkRGBA $rgba-no = $sc.get-color(GTK_STATE_FLAG_DIR_LTR);
  is-approx $rgba-no.red, 0.1254901, '.get-color()';

  my Gnome::Gtk3::Border $border = $sc.get-margin-rk(GTK_STATE_FLAG_DIR_LTR);
  is $border.left, 0, '.get-margin-rk()';

  $border = $sc.get-padding-rk(GTK_STATE_FLAG_DIR_LTR);
  is $border.left, 0, '.get-padding-rk()';


  lives-ok {
    my Gnome::Gtk3::Label $lbl2 .= new(:text('my label text'));
    my Gnome::Gtk3::StyleContext $sc2 .= new(
      :native-object($lbl2.get-style-context)
    );
    $sc.set-parent($sc2);
    my Gnome::Gtk3::StyleContext $cs3 = $sc.get-parent-rk;
    ok $cs3.is-valid, 'cs3 is valid';
  }, '.set-parent() / .get-parent-rk()';

  like $sc.get-path-rk.to-string, /MyLabel/,
    '.get-path-rk(): ' ~ $sc.get-path-rk.to-string;

#  my Gnome::GObject::Value $v = $sc.get-property-rk(
#    'color', GTK_STATE_FLAG_DIR_LTR
#  );
#  nok $v.is-valid, '.get-property-rk(): color property not set';
#  $v.clear-object;

  $sc.set-scale(2);
  is $sc.get-scale, 2, '.set-scale() / .get-scale()';

  $sc.set-screen($screen);
  my Gnome::Gdk3::Screen $screen2 = $sc.get-screen-rk;
  ok $screen2.is-valid, '.set-screen() / .get-screen()';

  ok $sc.has-class('MyLabel'), '.has-class()';
  my Gnome::Glib::List $list = $sc.list-classes-rk;
  is $list.length, 1e0, '.list-classes-rk()';
  $list.clear-object;

  $rgba-no = $sc.lookup-color('red');
  is $rgba-no.red, 1, '.lookup-color()';
  my Gnome::Gdk3::RGBA $blue = $sc.lookup-color-rk('blue');
  is $blue.blue, 1e0, '.lookup-color-rk()';

#  my Gnome::GObject::Value $v = $sc.get-style-property-rk('color');
#  ok $v.is-valid, '.get-style-property-rk(): no color property';
#note "type: ", $v.get-gtype;
#  $v.clear-object;

  $sc.set-junction-sides(GTK_JUNCTION_CORNER_TOPLEFT);
  ok $sc.get-junction-sides +& GTK_JUNCTION_CORNER_TOPLEFT,
    '.set-junction-sides() / .get-junction-sides()';

#  lives-ok {
#    $sc.set-path($sc.get-path);
#  }, '.set-path';

  like my $sts = $sc.to-string(GTK_STYLE_CONTEXT_PRINT_SHOW_STYLE), /link/,
    '.to-string(): ' ~ $sts;
}

#-------------------------------------------------------------------------------
subtest 'rendering', {
  my Gnome::Gdk3::Screen $screen .= new;
  my Gnome::Gtk3::StyleContext $sc .= new;
  my Gnome::Gtk3::CssProvider $cp1 .= new;

  $sc.add-provider-for-screen(
    $screen, $cp1, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
  );

  my Gnome::Gtk3::Label $lbl .= new(:text('my label text'));
  $sc .= new(:native-object($lbl.get-style-context));

  my Gnome::Cairo::ImageSurface $image .= new(
    :format(CAIRO_FORMAT_RGB24), :width(100), :height(100));
  my Gnome::Cairo $cr .= new(:surface($image));

  lives-ok {
    $sc.render-activity( $cr, 10, 10, 80, 80);
    $sc.render-arrow( $cr, ⅔ * π, 50, 50, 10);
    $sc.render-background( $cr, 0, 0, 100, 100);
    my N-GdkRectangle $r = $sc.render-background-get-clip( 10, 10, 80, 80);
    is $r.width, 80, '.render-background-get-clip()';
#    note $r.gist;
    $sc.render-check( $cr, 10, 10, 80, 80);
    $sc.render-expander( $cr, 10, 10, 80, 80);
    $sc.render-extension( $cr, 10, 10, 80, 80, GTK_POS_LEFT);
    $sc.render-focus( $cr, 10, 10, 80, 80);
    $sc.render-frame( $cr, 10, 10, 80, 80);
    $sc.render-handle( $cr, 10, 10, 80, 80);

    my Gnome::Gdk3::Pixbuf $pbuf .= new(
      :surface($image), :clipto( 0, 0, 40, 40)
    );
    $sc.render-icon( $cr, $pbuf, 5, 5);
    $sc.render-icon-surface( $cr, $image, 5, 5);

    $sc.render-line( $cr, 10, 10, 80, 80);
    $sc.render-option( $cr, 10, 10, 80, 80);
    $sc.render-slider( $cr, 10, 10, 80, 80, GTK_ORIENTATION_VERTICAL);
#    $sc.render-( $cr, 10, 10, 80, 80);
}, '.render-*()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::StyleContext', {
  class MyClass is Gnome::Gtk3::StyleContext {
    method new ( |c ) {
      self.bless( :GtkStyleContext, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::StyleContext, '.new() inherit';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::StyleContext $sc .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $sc.get-property( $prop, $gv);
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
      Gnome::Gtk3::StyleContext :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::StyleContext;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::StyleContext :$widget --> Str ) {

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

  my Gnome::Gtk3::StyleContext $sc .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $sc.register-signal( $sh, 'method', 'signal');

  my Promise $p = $sc.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
