use v6;
#use lib '../gnome-native/lib';
#use lib '../gnome-gobject/lib';
#use lib '../gnome-glib/lib';

use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Glib::List;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Image;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Button $b;

#-------------------------------------------------------------------------------
subtest 'ISA tests', {

  $b .= new(:label('abc def'));
  isa-ok $b, Gnome::Gtk3::Button, '.new(:label)';

  $b .= new(:mnemonic('_pqr'));
  isa-ok $b, Gnome::Gtk3::Button, '.new(:mnemonic)';

  $b .= new( :icon-name('audio-volume-high'), :icon-size(GTK_ICON_SIZE_BUTTON));
  isa-ok $b, Gnome::Gtk3::Button, '.new(:icon-name, :icon-size)';

#  dies-ok(
#    { $b.get-label('xyz'); },
#    'wrong arguments to get-label()'
#  );
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'manipulations', {
  $b .= new(:label<Off>);

  $b.set-always-show-image(True);
  ok $b.get-always-show-image,
    '.set-always-show-image() / .get-always-show-image()';

  my Gnome::Gtk3::Image $image .= new(
    :icon-name<audio-off>, :size(GTK_ICON_SIZE_BUTTON)
  );
  $image.set-name('bttnimg');
  $b.set-image($image);
  is $b.get-image-rk.get-name, 'bttnimg', '.set-image() / .get-image-rk()';

  $b.set-image-position(GTK_POS_RIGHT);
  is $b.get-image-position, GTK_POS_RIGHT,
    '.set-image-position() / .get-image-position()';

#  is $b.get-label, 'Off', '.get-label()';
  $b.set-label('x1');
  is $b.get-label, 'x1', '.set-label() / .get-label()';

  $b.set-relief(GTK_RELIEF_NONE);
  is $b.get-relief, GTK_RELIEF_NONE, '.set-relief() / .get-relief()';

  $b.set-use-underline(True);
  ok $b.get-use-underline, '.set-use-underline() / .get-use-underline()';
}

#-------------------------------------------------------------------------------
subtest 'Button as container', {
  $b .= new(:label<xyz>);
  my Gnome::Gtk3::Label $l .= new(:text(''));

  my Gnome::Glib::List $gl .= new(:native-object($b.get-children));
  $l .= new(:native-object($gl.nth-data(0)));
  is $l.get-text, 'xyz', 'text label from button 1';

  class X {
    method cfe ( $nw ) {
      $l .= new(:native-object($nw));
      is $l.widget-get-name, 'GtkLabel', 'widget name ok';
      is $l.get-text, 'xyz', 'text label from button 1';
    }
  }
  $b.gtk_container_foreach( X.new, 'cfe');


  my Gnome::Gtk3::Label $label .= new(:text('pqr'));
  my Gnome::Gtk3::Button $button2 .= new;
  $button2.add($label);

  $l .= new(:native-object($button2.get-child));
  is $l.get-text, 'pqr', 'text label from button 2';

  # Next statement is not able to get the text directly
  # when gtk-container-add is used.
  is $button2.get-label, Str, 'text cannot be returned like this anymore';

  $gl.clear-object;
}

#-------------------------------------------------------------------------------
subtest 'Button connect and emit signal', {

  use Gnome::Gtk3::Main;
  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method click-handler (
      Gnome::Gtk3::Button :_widget($button), Array :$user-data, :$_handler-id
    ) {
#  note "click-handler handler id: $_handler-id";
      isa-ok $button, Gnome::Gtk3::Button;
      is $user-data[0], 'Hello', 'data 0 ok';
      is $user-data[1], 'World', 'data 1 ok';
      is $user-data[2], '!', 'data 2 ok';

      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Button :_widget($button) --> Str ) {
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      $button.clicked;  #emit-by-name('clicked');
#      sleep(0.3);
      while $main.gtk-events-pending() { $main.iteration-do(False); }

#      sleep(0.3);
      is $!signal-processed, True, '\'clicked\' signal processed';

      #$!signal-processed = False;
      #$mh-in-handler.emit-by-name( ..., $mh-in-handler);
      #is $!signal-processed, True, '... signal processed';

#      sleep(1.0);
      $main.gtk-main-quit;

      'done'
    }
  }

  # create new button, register button signal and prepare user data
  $b .= new(:label('xyz'));

#Gnome::N::debug(:on);

  # prevent errors from gnome gtk
  my Gnome::Gtk3::Window $w .= new;
  $w.add($b);
  $w.show-all;

  my Array $data = [];
  $data[0] = 'Hello';
  $data[1] = 'World';

  my SignalHandlers $sh .= new;
  my $hid = $b.register-signal(
    $sh, 'click-handler', 'clicked', :user-data($data)
  );
#  note "handler id: $hid";

  # add after registration to see if that comes through too
  $data[2] = '!';

  my Promise $p = $b.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,       # enable 'use Gnome::Glib::Main'
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  is $main.gtk-main-level, 0, "loop level is 0 again";
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Button', {
  class MyClass is Gnome::Gtk3::Button {
    method new ( |c ) {
      self.bless( :GtkButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Button, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @r = $b.get-properties(
    'label', Str
  );
  is-deeply @r, [
    'xyz'
  ], 'label, ';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Button $b .= new;

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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', False);
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
      Gnome::Gtk3::Button :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Button;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Button :$widget --> Str ) {

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

  my Gnome::Gtk3::Button $b .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $b.register-signal( $sh, 'method', 'signal');

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
