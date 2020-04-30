use v6;

use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Glib::List;
use Gnome::Glib::Main;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
# used later on in tests
my Gnome::Gtk3::Main $main .= new;
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
subtest 'Button as container', {
  $b .= new(:label('xyz'));
  is $b.get-label, 'xyz', 'gtk_button_get_label()';
  $b.set-label('xyz');
  is $b.get-label, 'xyz', 'gtk_button_set_label() / gtk_button_get_label()';

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
  $button2.gtk-container-add($label);

  $l .= new(:native-object($button2.get-child));
  is $l.get-text, 'pqr', 'text label from button 2';

  # Next statement is not able to get the text directly
  # when gtk-container-add is used.
  is $button2.get-label, Str, 'text cannot be returned like this anymore';

  $gl.clear-object;
}

#-------------------------------------------------------------------------------
class BH {

  method click-handler ( :widget($button), Array :$user-data ) {
    isa-ok $button, Gnome::Gtk3::Button;
    is $user-data[0], 'Hello', 'data 0 ok';
    is $user-data[1], 'World', 'data 1 ok';
    is $user-data[2], '!', 'data 2 ok';
  }
}

#-------------------------------------------------------------------------------
subtest 'Button connect and emit signal', {

  # register button signal
  $b .= new(:label('xyz'));

  # prevent errors from gnome gtk
  my Gnome::Gtk3::Window $w .= new;
  $w.container-add($b);

  my Array $data = [];
  $data[0] = 'Hello';
  $data[1] = 'World';

  my BH $x .= new;
  $b.register-signal( $x, 'click-handler', 'clicked', :user-data($data));

  # add after registration
  $data[2] = '!';

  my Promise $p = start {
    # wait for loop to start
    sleep(1.1);

    is $main.gtk-main-level, 1, "loop level now 1";

    my Gnome::Glib::Main $gmain .= new;
    my $main-context = $gmain.context-get-thread-default;

    $gmain.context-invoke(
      $main-context,
      -> $d {
        $b.emit-by-name( 'clicked', $b);

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

#`{{
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
