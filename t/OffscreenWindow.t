use v6;
use NativeCall;
use Test;


use Gnome::Cairo::ImageSurface;
use Gnome::Cairo;

use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::OffscreenWindow;

use Gnome::Gdk3::Pixbuf;

use Gnome::Glib::Error;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::OffscreenWindow $ow;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ow .= new;
  isa-ok $ow, Gnome::Gtk3::OffscreenWindow, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  # Setup something to show in an image. It will be a grid with two buttons
  my Gnome::Gtk3::Button $b1 .= new(:label<Stop>);
  my Gnome::Gtk3::Button $b2 .= new(:label<Start>);
  my Gnome::Gtk3::Grid $g  .= new;
  $g.attach( $b1, 0, 0, 1, 1);
  $g.attach( $b2, 1, 0, 1, 1);
  $ow.add($g);
  $ow.show-all;

  # Must process pending events, otherwise nothing is shown!
  my Gnome::Gtk3::Main $main .= new;
  while $main.gtk-events-pending() { $main.iteration-do(False); }

  # Now we can try to get the contents of the widget
  lives-ok {
    my Gnome::Cairo::ImageSurface $image-surface .= new(
      :native-object($ow.get-surface)
    );
    $image-surface.write_to_png("xt/data/OffscreenWindow-surface.png");
    $image-surface.clear-object;
  }, '.get-surface()';

  lives-ok {
    my Gnome::Gdk3::Pixbuf $pb = $ow.get-pixbuf-rk;
    my Gnome::Glib::Error $e = $pb.savev(
      "xt/data/OffscreenWindow-pixbuf.jpg", 'jpeg', ['quality'], ['100']
    );
  }, '.get-pixbuf-rk()';
}


#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::OffscreenWindow', {
  class MyClass is Gnome::Gtk3::OffscreenWindow {
    method new ( |c ) {
      self.bless( :GtkOffscreenWindow, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::OffscreenWindow, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::OffscreenWindow $ow .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $ow.get-property( $prop, $gv);
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
      Gnome::Gtk3::OffscreenWindow :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::OffscreenWindow;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::OffscreenWindow :$widget --> Str ) {

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

  my Gnome::Gtk3::OffscreenWindow $ow .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $ow.register-signal( $sh, 'method', 'signal');

  my Promise $p = $ow.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
