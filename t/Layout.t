use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;

use Gnome::Cairo::ImageSurface;

use Gnome::Gtk3::OffscreenWindow;
use Gnome::Gtk3::Layout;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;
#use Gnome::Gtk3::Adjustment;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Layout $l;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $l .= new;
  isa-ok $l, Gnome::Gtk3::Layout, '.new()';

  $l .= new( :hadjustment(N-GObject), :vadjustment(N-GObject));
  isa-ok $l, Gnome::Gtk3::Layout, '.new()';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  given my Gnome::Gtk3::OffscreenWindow $ow .= new {
    .set-size-request( 400, 300);
    .add($l);
  }
#`{{
  my Gnome::Gtk3::Adjustment $hadjustment .= new(
    :value(1), :lower(0), :upper(100), :step-increment(1),
    :page-increment(1), :page-size(10)
  );
  my Gnome::Gtk3::Adjustment $vadjustment .= new(
    :value(1), :lower(0), :upper(110), :step-increment(1),
    :page-increment(1), :page-size(10)
  );
}}
  $l.set-size( 400, 300);
  my ( $w, $h) = $l.get-size;
  ok ($w == 400 and $h == 300), '.set-size() / .get-size()';

  my Gnome::Gtk3::Button $b .= new(:label<Start>);
  $l.put( $b, 100, 100);
  $b .= new(:label<Stop>);
  $l.put( $b, 100, 100);
  $l.move( $b, 200, 250);
  $b .= new(:label<Quit>);
  $l.put( $b, 300, 150);

  # Make it so
  $ow.show-all;

  # Must process pending events, otherwise nothing is shown! Note,
  # that this is written outside the main event loop in the test program!
  # Otherwise, this is not necessary.
  my Gnome::Gtk3::Main $main .= new;
  while $main.gtk-events-pending() { $main.iteration-do(False); }

  # Now we can try to get the contents of the widget. First using
  # a cairo_surface
  my Gnome::Cairo::ImageSurface $image-surface .= new(
    :native-object($ow.get-surface)
  );

  $image-surface.write_to_png("xt/data/Layout.png");
  $image-surface.clear-object;
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Layout', {
  class MyClass is Gnome::Gtk3::Layout {
    method new ( |c ) {
      self.bless( :GtkLayout, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Layout, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Layout $l .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $l.get-property( $prop, $gv);
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

  test-property( G_TYPE_UINT, 'width', 'get-uint', 400);
  test-property( G_TYPE_UINT, 'height', 'get-uint', 300);

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', False);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
done-testing;

=finish

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
      Gnome::Gtk3::Layout() :_native-object($_widget), gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Layout;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Layout :$widget --> Str ) {

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

  my Gnome::Gtk3::Layout $l .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $l.register-signal( $sh, 'method', 'signal');

  my Promise $p = $l.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
