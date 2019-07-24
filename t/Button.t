use v6;
#use lib '../perl6-gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::GObject::Object;
use Gnome::Glib::List;
use Gnome::Glib::Main;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

use Gnome::N::X;
Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
# used later on in tests
my Gnome::Gtk3::Main $main .= new;

#-------------------------------------------------------------------------------
subtest 'ISA tests', {

  my Gnome::Gtk3::Button $button1 .= new(:label('abc def'));
  isa-ok $button1, Gnome::Gtk3::Button;
  isa-ok $button1, Gnome::Gtk3::Bin;

  throws-like
    { $button1.get-label('xyz'); },
    X::Gnome, 'wrong arguments to get-label()',
    :message(/:s Calling gtk_button_get_label .*? will never work /);

  is $button1.get-label, 'abc def', 'text on button ok';
  $button1.set-label('xyz');
  is $button1.get-label, 'xyz', 'text on button changed ok';
}

#-------------------------------------------------------------------------------
subtest 'Button as container', {
  my Gnome::Gtk3::Button $button1 .= new(:label('xyz'));
  my Gnome::Gtk3::Label $l .= new(:label(''));

  my Gnome::Glib::List $gl .= new(:glist($button1.get-children));
  $l($gl.nth-data-gobject(0));
  is $l.get-text, 'xyz', 'text label from button 1';

  my Gnome::Gtk3::Label $label .= new(:label('pqr'));
  my Gnome::Gtk3::Button $button2 .= new(:empty);
  $button2.gtk-container-add($label);

  $l($button2.get-child);
  is $l.get-text, 'pqr', 'text label from button 2';

  # Next statement is not able to get the text directly
  # when gtk-container-add is used.
  is $button2.get-label, Str, 'text cannot be returned like this anymore';

  $gl.g-list-free;
  $gl = Gnome::Glib::List;
}

#-------------------------------------------------------------------------------
#TODO is it necessary to inherit
class BH {

  method click-handler ( :widget($button), Array :$user-data ) {
    isa-ok $button, Gnome::Gtk3::Button;
    is $user-data[0], 'Hello', 'data 0 ok';
    is $user-data[1], 'World', 'data 1 ok';
  }
}

#-------------------------------------------------------------------------------
subtest 'Button connect and emit signal', {

  # register button signal
  my Gnome::Gtk3::Button $button .= new(:label('xyz'));

  my Array $data = [];
  $data[0] = 'Hello';
  $data[1] = 'World';

  my BH $x .= new(:empty);
  $button.register-signal( $x, 'click-handler', 'clicked', :user-data($data));

  my Promise $p = start {
    # wait for loop to start
    sleep(1.1);

    is $main.gtk-main-level, 1, "loop level now 1";

    my Gnome::Glib::Main $gmain .= new;
    my $main-context = $gmain.context-get-thread-default;

    $gmain.context-invoke(
      $main-context,
      -> $d {
        $button.emit-by-name( 'clicked', $button);

        sleep(1.0);
        $main.gtk-main-quit;

        0
      },
      OpaquePointer
    );

    'test done'
  }

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  is $main.gtk-main-level, 0, "loop level is 0 again";
}

#-------------------------------------------------------------------------------
done-testing;
